<?php
/**
 * Created by PhpStorm.
 * User: Eric
 * Date: 2017/8/17
 * Time: 14:38
 */
/*****************************基础验证模块*****************************/
//解析token服务
function getToken()
{
    if (isset($_SESSION['token'])) {
        $decoded = \Firebase\JWT\JWT::decode($_SESSION['token'], TOKEN, array('HS256'));
        if (empty($decoded) || $decoded->iss != "www.systec.com") {
            echo json_encode(array("state" => 0, "ret" => "Login error"));
            exit();
        } else {
            return TRUE;
        }
    } else {
        echo json_encode(array("state" => 0, "ret" => "Login error"));
        exit();
    }
}


/*****************************MQTT处理模块*****************************/
//获取所有MQTT在线设备列表服务
function __getEMQTTClients()
{
    $raw_data = _getHTTPS("http://" . EMQTTD_IP .
        ":18083/api/v2/nodes/emq@127.0.0.1/clients?curr_page=1&page_size=100");
    $raw_data = json_decode($raw_data, TRUE);

    $res = array();
    $i = 0;
    for ($page = 1; $page <= $raw_data['result']['total_page']; $page++) {
        $raw_data = _getHTTPS("http://" . EMQTTD_IP .
            ":18083/api/v2/nodes/emq@127.0.0.1/clients?curr_page=" . $page . "&page_size=100");
        $raw_data = json_decode($raw_data, TRUE);
        foreach ($raw_data['result']['objects'] as $key => $value) {
            $res[$i]['ipaddress'] = $value['ipaddress'];
            $res[$i]['client_id'] = $value['client_id'];
            $i++;
        }
    }
    return $res;
}

//获取所有订阅主题服务
function __getEMQTTopic()
{
    $raw_data = _getHTTPS("http://" . EMQTTD_IP .
        ":18083/api/v2/nodes/emq@127.0.0.1/subscriptions?curr_page=1&page_size=100");
    $raw_data = json_decode($raw_data, TRUE);
    $res = array();
    $i = 0;
    for ($page = 1; $page <= $raw_data['result']['total_page']; $page++) {
        $raw_data = _getHTTPS("http://" . EMQTTD_IP .
            ":18083/api/v2/nodes/emq@127.0.0.1/subscriptions?curr_page=" . $page .
            "&page_size=100");
        $raw_data = json_decode($raw_data, TRUE);
        foreach ($raw_data['result']['objects'] as $key => $value) {
            $res[$i]['topic'] = $value['topic'];
            $res[$i]['client_id'] = $value['client_id'];
            $i++;
        }
    }
    return $res;
}

//根据TOPIC获取EMQTTD在线设备列表服务
function getOnlineDeviceByTopic($topic)
{
    $topics = __getEMQTTopic();
    $clients = __getEMQTTClients();
    $resTemp = array();
    foreach ($clients as $key => $value) {
        $resTemp[] = $value['client_id'];
    }
    $res = array();
    foreach ($topics as $key => $value) {
        if (strstr($value['topic'], $topic . "/") && in_array($value['client_id'], $resTemp)) {
            $res[] = $value['topic'];
        }
    }
    return $res;
}


//定向发送MQTT消息服务(公告业务)
function senddMQTTMSGByGroup($target, $topic, $content)
{
    file_put_contents("/home/wwwroot/default/aa", $topic . "\r\n", FILE_APPEND);
    require_once dirname(dirname(__file__)) . '/libraries/phpMQTT.php';
    $res = array();
    $sendReceivers = array();

    file_put_contents("/home/wwwroot/default/aa", $topic . "\r\n", FILE_APPEND);
    foreach (getOnlineDeviceByTopic($topic) as $v) {
        $res[end(explode("?", $v))] = $v;
    }

    file_put_contents("/home/wwwroot/default/aa", json_encode($target) . "\r\n", FILE_APPEND);
    foreach ($target as $key => $value) {
        if (array_key_exists($value['id'], $res)) {
            $sendReceivers[] = $res[$value['id']];
        }
    }

    $mqtt = new phpMQTT(EMQTTD_IP, EMQTTD_PORT, EMQTTD_ID);
    if ($mqtt->connect()) {
        foreach ($sendReceivers as $v) {
            $mqtt->publish($v, $content, 1);
        }
        $mqtt->close();
    }


}

//发送MQTT消息通用方法
function sendMQTTMSG($topic, $content)
{
    require dirname(dirname(__file__)) . '/libraries/phpMQTT.php';
    $mqtt = new phpMQTT(EMQTTD_IP, EMQTTD_PORT, EMQTTD_ID);
    if ($mqtt->connect()) {
        foreach (getOnlineDeviceByTopic($topic) as $key => $value) {
            $mqtt->publish($value, $content, 1);

        }

        $mqtt->close();
    }

}


//通用错误返回服务
function getMsg($content)
{
    echo json_encode(array("state" => 0, "ret" => $content));
    exit();
}


/**
 * 模拟post进行url请求
 * @param string $url
 * @param string $param
 */
function request_post($url = '', $param = '')
{
    if (empty($url)) {
        return FALSE;
    }

    $postUrl = $url;
    $curlPost = $param;
    $ch = curl_init(); //初始化curl
    curl_setopt($ch, CURLOPT_URL, $postUrl); //抓取指定网页
    curl_setopt($ch, CURLOPT_HEADER, 0); //设置header
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1); //要求结果为字符串且输出到屏幕上
    curl_setopt($ch, CURLOPT_POST, 1); //post提交方式
    curl_setopt($ch, CURLOPT_POSTFIELDS, $curlPost);
    $data = curl_exec($ch); //运行curl
    curl_close($ch);

    return $data;
}


//获取HTTPS请求服务
function _getHTTPS($url)
{
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($ch, CURLOPT_HTTPAUTH, CURLAUTH_ANY);
    curl_setopt($ch, CURLOPT_USERPWD, EMQTTD_USER . ":" . EMQTTD_PWD);
    $result = curl_exec($ch);
    curl_close($ch);
    return $result;
}

//根据3-2-4结构自动补零服务
/*
 * @location: 楼栋，单元或者房间号名称
 * @type    : 标识楼栋(building),单元(unit),房间号(room)
 */
function placeholderLocation($location, $type)
{
    $result = "";
    if ($type == "building") {
        if (strlen($location) == 1) {
            $result = "00" . $location;
        } elseif (strlen($location) == 2) {
            $result = "0" . $location;
        } elseif (strlen($location) == 3) {
            $result = $location;
        } else {
            $result = "";
        }
    } elseif ($type == "unit") {
        if (strlen($location) == 1) {
            $result = "0" . $location;
        } elseif (strlen($location) == 2) {
            $result = $location;
        } else {
            $result = "";
        }

    } elseif ($type == "room") {
        if (strlen($location) == 1) {
            $result = "000" . $location;
        } elseif (strlen($location) == 2) {
            $result = "00" . $location;
        } elseif (strlen($location) == 3) {
            $result = "0" . $location;
        } elseif (strlen($location) == 4) {
            $result = $location;
        } else {
            $result = "";
        }
    } else {
        $result = "";
    }
    return strtoupper($result);
}

function more_array_unique($arr = array())
{
    foreach ($arr[0] as $k => $v) {
        $arr_inner_key[] = $k;
    }
    foreach ($arr as $k => $v) {
        $v = join(",", $v);
        $temp[$k] = $v;
    }
    $temp = array_unique($temp);
    foreach ($temp as $k => $v) {
        $a = explode(",", $v);
        $arr_after[$k] = array_combine($arr_inner_key, $a);
    }
    return $arr_after;
}

function check_is_chinese($str)
{
    return preg_match('/[\x80-\xff]./', $str);
}

//过滤视频文件服务
function getVideoFile()
{
    $arrs = array(
        'hqx' => array('application/mac-binhex40', 'application/mac-binhex', 'application/x-binhex40', 'application/x-mac-binhex40'),
        'cpt' => 'application/mac-compactpro',
        'csv' => array('text/x-comma-separated-values', 'text/comma-separated-values', 'application/octet-stream', 'application/vnd.ms-excel', 'application/x-csv', 'text/x-csv', 'text/csv', 'application/csv', 'application/excel', 'application/vnd.msexcel', 'text/plain'),
        'bin' => array('application/macbinary', 'application/mac-binary', 'application/octet-stream', 'application/x-binary', 'application/x-macbinary'),
        'dms' => 'application/octet-stream',
        'lha' => 'application/octet-stream',
        'lzh' => 'application/octet-stream',
        'exe' => array('application/octet-stream', 'application/x-msdownload'),
        'class' => 'application/octet-stream',
        'psd' => array('application/x-photoshop', 'image/vnd.adobe.photoshop'),
        'so' => 'application/octet-stream',
        'sea' => 'application/octet-stream',
        'dll' => 'application/octet-stream',
        'oda' => 'application/oda',
        'pdf' => array('application/pdf', 'application/force-download', 'application/x-download', 'binary/octet-stream'),
        'ai' => array('application/pdf', 'application/postscript'),
        'eps' => 'application/postscript',
        'ps' => 'application/postscript',
        'smi' => 'application/smil',
        'smil' => 'application/smil',
        'mif' => 'application/vnd.mif',
        'xls' => array('application/vnd.ms-excel', 'application/msexcel', 'application/x-msexcel', 'application/x-ms-excel', 'application/x-excel', 'application/x-dos_ms_excel', 'application/xls', 'application/x-xls', 'application/excel', 'application/download', 'application/vnd.ms-office', 'application/msword'),
        'ppt' => array('application/powerpoint', 'application/vnd.ms-powerpoint', 'application/vnd.ms-office', 'application/msword'),
        'pptx' => array('application/vnd.openxmlformats-officedocument.presentationml.presentation', 'application/x-zip', 'application/zip'),
        'wbxml' => 'application/wbxml',
        'wmlc' => 'application/wmlc',
        'dcr' => 'application/x-director',
        'dir' => 'application/x-director',
        'dxr' => 'application/x-director',
        'dvi' => 'application/x-dvi',
        'gtar' => 'application/x-gtar',
        'gz' => 'application/x-gzip',
        'gzip' => 'application/x-gzip',
        'php' => array('application/x-httpd-php', 'application/php', 'application/x-php', 'text/php', 'text/x-php', 'application/x-httpd-php-source'),
        'php4' => 'application/x-httpd-php',
        'php3' => 'application/x-httpd-php',
        'phtml' => 'application/x-httpd-php',
        'phps' => 'application/x-httpd-php-source',
        'js' => array('application/x-javascript', 'text/plain'),
        'swf' => 'application/x-shockwave-flash',
        'sit' => 'application/x-stuffit',
        'tar' => 'application/x-tar',
        'tgz' => array('application/x-tar', 'application/x-gzip-compressed'),
        'z' => 'application/x-compress',
        'xhtml' => 'application/xhtml+xml',
        'xht' => 'application/xhtml+xml',
        'zip' => array('application/x-zip', 'application/zip', 'application/x-zip-compressed', 'application/s-compressed', 'multipart/x-zip'),
        'rar' => array('application/x-rar', 'application/rar', 'application/x-rar-compressed'),
        'mid' => 'audio/midi',
        'midi' => 'audio/midi',
        'mpga' => 'audio/mpeg',
        'mp2' => 'audio/mpeg',
        'mp3' => array('audio/mpeg', 'audio/mpg', 'audio/mpeg3', 'audio/mp3'),
        'aif' => array('audio/x-aiff', 'audio/aiff'),
        'aiff' => array('audio/x-aiff', 'audio/aiff'),
        'aifc' => 'audio/x-aiff',
        'ram' => 'audio/x-pn-realaudio',
        'rm' => 'audio/x-pn-realaudio',
        'rpm' => 'audio/x-pn-realaudio-plugin',
        'ra' => 'audio/x-realaudio',
        'rv' => 'video/vnd.rn-realvideo',
        'wav' => array('audio/x-wav', 'audio/wave', 'audio/wav'),
        'bmp' => array('image/bmp', 'image/x-bmp', 'image/x-bitmap', 'image/x-xbitmap', 'image/x-win-bitmap', 'image/x-windows-bmp', 'image/ms-bmp', 'image/x-ms-bmp', 'application/bmp', 'application/x-bmp', 'application/x-win-bitmap'),
        'gif' => 'image/gif',
        'jpeg' => array('image/jpeg', 'image/pjpeg'),
        'jpg' => array('image/jpeg', 'image/pjpeg'),
        'jpe' => array('image/jpeg', 'image/pjpeg'),
        'jp2' => array('image/jp2', 'video/mj2', 'image/jpx', 'image/jpm'),
        'j2k' => array('image/jp2', 'video/mj2', 'image/jpx', 'image/jpm'),
        'jpf' => array('image/jp2', 'video/mj2', 'image/jpx', 'image/jpm'),
        'jpg2' => array('image/jp2', 'video/mj2', 'image/jpx', 'image/jpm'),
        'jpx' => array('image/jp2', 'video/mj2', 'image/jpx', 'image/jpm'),
        'jpm' => array('image/jp2', 'video/mj2', 'image/jpx', 'image/jpm'),
        'mj2' => array('image/jp2', 'video/mj2', 'image/jpx', 'image/jpm'),
        'mjp2' => array('image/jp2', 'video/mj2', 'image/jpx', 'image/jpm'),
        'png' => array('image/png', 'image/x-png'),
        'tiff' => 'image/tiff',
        'tif' => 'image/tiff',
        'css' => array('text/css', 'text/plain'),
        'html' => array('text/html', 'text/plain'),
        'htm' => array('text/html', 'text/plain'),
        'shtml' => array('text/html', 'text/plain'),
        'txt' => 'text/plain',
        'text' => 'text/plain',
        'log' => array('text/plain', 'text/x-log'),
        'rtx' => 'text/richtext',
        'rtf' => 'text/rtf',
        'xml' => array('application/xml', 'text/xml', 'text/plain'),
        'xsl' => array('application/xml', 'text/xsl', 'text/xml'),
        'mpeg' => 'video/mpeg',
        'mpg' => 'video/mpeg',
        'mpe' => 'video/mpeg',
        'qt' => 'video/quicktime',
        'mov' => 'video/quicktime',
        'avi' => 'video/x-msvideo',
        'movie' => 'video/x-sgi-movie',
        'doc' => array('application/msword', 'application/vnd.ms-office'),
        'docx' => array('application/vnd.openxmlformats-officedocument.wordprocessingml.document', 'application/zip', 'application/msword', 'application/x-zip'),
        'dot' => array('application/msword', 'application/vnd.ms-office'),
        'dotx' => array('application/vnd.openxmlformats-officedocument.wordprocessingml.document', 'application/zip', 'application/msword'),
        'xlsx' => array('application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 'application/zip', 'application/vnd.ms-excel', 'application/msword', 'application/x-zip'),
        'word' => array('application/msword', 'application/octet-stream'),
        'xl' => 'application/excel',
        'eml' => 'message/rfc822',
        'json' => array('application/json', 'text/json'),
        'pem' => array('application/x-x509-user-cert', 'application/x-pem-file', 'application/octet-stream'),
        'p10' => array('application/x-pkcs10', 'application/pkcs10'),
        'p12' => 'application/x-pkcs12',
        'p7a' => 'application/x-pkcs7-signature',
        'p7c' => array('application/pkcs7-mime', 'application/x-pkcs7-mime'),
        'p7m' => array('application/pkcs7-mime', 'application/x-pkcs7-mime'),
        'p7r' => 'application/x-pkcs7-certreqresp',
        'p7s' => 'application/pkcs7-signature',
        'crt' => array('application/x-x509-ca-cert', 'application/x-x509-user-cert', 'application/pkix-cert'),
        'crl' => array('application/pkix-crl', 'application/pkcs-crl'),
        'der' => 'application/x-x509-ca-cert',
        'kdb' => 'application/octet-stream',
        'pgp' => 'application/pgp',
        'gpg' => 'application/gpg-keys',
        'sst' => 'application/octet-stream',
        'csr' => 'application/octet-stream',
        'rsa' => 'application/x-pkcs7',
        'cer' => array('application/pkix-cert', 'application/x-x509-ca-cert'),
        '3g2' => 'video/3gpp2',
        '3gp' => array('video/3gp', 'video/3gpp'),
        'mp4' => 'video/mp4',
        'm4a' => 'audio/x-m4a',
        'f4v' => array('video/mp4', 'video/x-f4v'),
        'flv' => 'video/x-flv',
        'webm' => 'video/webm',
        'aac' => 'audio/x-acc',
        'm4u' => 'application/vnd.mpegurl',
        'm3u' => 'text/plain',
        'xspf' => 'application/xspf+xml',
        'vlc' => 'application/videolan',
        'wmv' => 'video/x-ms-wmv',
        'au' => 'audio/x-au',
        'ac3' => 'audio/ac3',
        'flac' => 'audio/x-flac',
        'ogg' => 'video/ogg',
        'kmz' => array('application/vnd.google-earth.kmz', 'application/zip', 'application/x-zip'),
        'kml' => array('application/vnd.google-earth.kml+xml', 'application/xml', 'text/xml'),
        'ics' => 'text/calendar',
        'ical' => 'text/calendar',
        'zsh' => 'text/x-scriptzsh',
        '7zip' => array('application/x-compressed', 'application/x-zip-compressed', 'application/zip', 'multipart/x-zip'),
        'cdr' => array('application/cdr', 'application/coreldraw', 'application/x-cdr', 'application/x-coreldraw', 'image/cdr', 'image/x-cdr', 'zz-application/zz-winassoc-cdr'),
        'wma' => array('audio/x-ms-wma', 'video/x-ms-asf'),
        'jar' => array('application/java-archive', 'application/x-java-application', 'application/x-jar', 'application/x-compressed'),
        'svg' => array('image/svg+xml', 'application/xml', 'text/xml'),
        'vcf' => 'text/x-vcard',
        'srt' => array('text/srt', 'text/plain'),
        'vtt' => array('text/vtt', 'text/plain'),
        'ico' => array('image/x-icon', 'image/x-ico', 'image/vnd.microsoft.icon'),
        'odc' => 'application/vnd.oasis.opendocument.chart',
        'otc' => 'application/vnd.oasis.opendocument.chart-template',
        'odf' => 'application/vnd.oasis.opendocument.formula',
        'otf' => 'application/vnd.oasis.opendocument.formula-template',
        'odg' => 'application/vnd.oasis.opendocument.graphics',
        'otg' => 'application/vnd.oasis.opendocument.graphics-template',
        'odi' => 'application/vnd.oasis.opendocument.image',
        'oti' => 'application/vnd.oasis.opendocument.image-template',
        'odp' => 'application/vnd.oasis.opendocument.presentation',
        'otp' => 'application/vnd.oasis.opendocument.presentation-template',
        'ods' => 'application/vnd.oasis.opendocument.spreadsheet',
        'ots' => 'application/vnd.oasis.opendocument.spreadsheet-template',
        'odt' => 'application/vnd.oasis.opendocument.text',
        'odm' => 'application/vnd.oasis.opendocument.text-master',
        'ott' => 'application/vnd.oasis.opendocument.text-template',
        'oth' => 'application/vnd.oasis.opendocument.text-web'
    );
    foreach ($arrs as $key => $value) {
        if (strstr($value, "video")) {
            $result[] = $key;
        }
    }

    return $result;

}


//二维数组排序服务
function sigcol_arrsort($data, $col, $type = SORT_DESC)
{
    if (is_array($data)) {
        $i = 0;
        foreach ($data as $k => $v) {
            if (key_exists($col, $v)) {
                $arr[$i] = $v[$col];
                $i++;
            } else {
                continue;
            }
        }
    } else {
        return FALSE;
    }
    array_multisort($arr, $type, $data);
    return $data;
}

//二维数组分类服务
function array_group_by($arr, $key)
{
    $grouped = [];
    foreach ($arr as $value) {
        $grouped[$value[$key]][] = $value;
    }
    // Recursively build a nested grouping if more parameters are supplied
    // Each grouped array value is grouped according to the next sequential key
    if (func_num_args() > 2) {
        $args = func_get_args();
        foreach ($grouped as $key => $value) {
            $parms = array_merge([$value], array_slice($args, 2, func_num_args()));
            $grouped[$key] = call_user_func_array('array_group_by', $parms);
        }
    }
    return $grouped;
}

//通用洛哥打印服务
function printLog($level="INFO",$content){
	file_put_contents("/home/wwwroot/default/log.txt","[".date("Y-m-d H:i:s")."] ".$level."  ".$content."\r\n",FILE_APPEND);
}


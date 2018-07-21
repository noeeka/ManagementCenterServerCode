<?php
error_reporting(E_ALL);

class Welcome extends CI_Controller
{

    //获取在线设备列表
    public function getOnlineDevices()
    {
        
        $key = "example_key";
        $token = array(
            "iss" => "http://example.org",
            "aud" => "http://example.com",
            "iat" => 1356999524,
            "nbf" => 1357000000
        );

        /**
         * IMPORTANT:
         * You must specify supported algorithms for your application. See
         * https://tools.ietf.org/html/draft-ietf-jose-json-web-algorithms-40
         * for a list of spec-compliant algorithms.
         */
        $jwt = \Firebase\JWT\JWT::encode($token, $key);
        $decoded = \Firebase\JWT\JWT::decode($jwt, $key, array('HS256'));

        print_r($decoded);
        $deviceIds=array();
        //获取设备视图列表
        foreach ($this->db->query("select * from View_GetALLDeviceList")->result() as $key => $value) {
            if (empty($value->building)) {
                $building = "000";
            } else {
                $building = $value->building;
            }

            if (empty($value->unit)) {
                $unit = "00";
            } else {
                $unit = $value->unit;
            }
            if (empty($value->room)) {
                $room = "0000";
            } else {
                $room = $value->room;
            }
            $deviceIds[$value->device_ip]['deviceID'] = $value->deviceTypeNo . $building . $unit . $room . $value->deviceNo;
        }

        //设备类型对应关系列表
        $device_type_res = array("01" => "室内机", "02" => "门口机", "03" => "围墙机", "04" => "独立门禁", "05" => "扩展安防", "06" => "独立安防", "07" => "门卫机", "09" => "二次确认门口机", "11" => "电梯连接器", "12" => "HomeLink", "13" => "移动终端");

        $raw_data = _getHTTPS("http://" . EMQTTD_IP . ":" . EMQTTD_API_PORT . "/api/v2/nodes/emq@127.0.0.1/clients");
        $raw_data = json_decode($raw_data, true);



        $res_online_devices=array();
        $res_online_devices_id=array();
        $res_online_clients_id=array();
        $i = 0;
        for ($page = 1; $page <= $raw_data['result']['total_page']; $page++) {
            $raw_data = _getHTTPS("http://" . EMQTTD_IP . ":" . EMQTTD_API_PORT . "/api/v2/nodes/emq@127.0.0.1/clients?curr_page=" . $page . "&page_size=20");
            $raw_data = json_decode($raw_data, true);
            foreach ($raw_data['result']['objects'] as $key => $value) {
                $res_online_devices[$i]['clientID'] = $value['client_id'];
                $res_online_devices[$i]['ip'] = $value['ipaddress'];
                $res_online_devices[$i]['type'] = $device_type_res[substr(end(explode("?", $value['client_id'])), 0, 2)];
                $res_online_devices[$i]['typeCode'] = substr(end(explode("?", $value['client_id'])), 0, 2);
                $res_online_devices[$i]['deviceID'] = end(explode("?", $value['client_id']));

                $res_online_devices[$i]['location'] = substr(end(explode("?", $value['client_id'])), 2, 9);
                $res_online_devices_id[$i]=end(explode("?", $value['client_id']));
                $res_online_clients_id[$value['ipaddress']."-".$i]=$value['client_id'];
                $i++;
            }
        }
        $res_status_0 = array();//正常的设备
        foreach ($res_online_devices as $key => $value) {
            if (in_array($value['deviceID'], $deviceIds)) {
                $res_status_0[$key]['clientID'] = $value['clientID'];
                $res_status_0[$key]['ip'] = $value['ip'];
                $res_status_0[$key]['type'] = $value['type'];
                $res_status_0[$key]['typeCode'] = $value['typeCode'];
                $res_status_0[$key]['deviceID'] = $value['deviceID'];
                $res_status_0[$key]['deviceNo'] = substr($value['deviceID'],0,strlen($value['deviceID'])-2);
                $res_status_0[$key]['location'] =$value['location'];
                $res_status_0[$key]['status'] = 0;
            }
        }


        $res_status_2 = array();//断线的设备
        foreach ($deviceIds as $key => $value) {
            if (!in_array($value, $res_online_devices_id)) {
                $res_status_2[$key]['status'] = 2;
                $res_status_2[$key]['clientID'] = "*?".$value['deviceID'];
                $res_status_2[$key]['ip'] = $key;
                $res_status_2[$key]['type'] = $device_type_res[substr($value['deviceID'], 0, 2)];
                $res_status_2[$key]['typeCode'] = substr($value['deviceID'], 0, 2);
                $res_status_2[$key]['deviceID'] = $value['deviceID'];
                $res_status_2[$key]['deviceNo'] = substr($value['deviceID'],0,strlen($value['deviceID'])-2);
                $res_status_2[$key]['location'] =substr($value['deviceID'], 2, 9);
            }
        }

        $res_status_1=array();//新设备
        foreach ($res_online_clients_id as $key=>$value){
            $deviceId=end(explode("?", $value));
            if(!in_array($deviceId,$deviceIds)){
                $res_status_1[$key]['status'] = 1;
                $res_status_1[$key]['clientID'] = $value;
                $res_status_1[$key]['ip'] = current(explode("-",$key));
                $res_status_1[$key]['type'] = $device_type_res[substr($deviceId, 0, 2)];
                $res_status_1[$key]['typeCode'] = substr($deviceId, 0, 2);
                $res_status_1[$key]['deviceID'] = $deviceId;
                $res_status_1[$key]['deviceNo'] = substr($deviceId,0,strlen($deviceId)-2);
                $res_status_1[$key]['location'] =substr($deviceId, 2, 9);

            }
        }

        $ret=array_values(array_merge($res_status_0,$res_status_2,$res_status_1));

        if ($ret) {
            echo json_encode(array("state" => 1, "ret" => $ret));
        } else {
            echo json_encode(array("state" => 0, "ret" => "Error"));
        }
    }

    function test()
    {

        $this->load->library('image_lib');
        $config['image_library'] = 'gd2';
        $config['source_image'] = '/home/wwwroot/default/test.jpg';

        $config['create_thumb'] = TRUE;
        $config['maintain_ratio'] = TRUE;
        $config['new_image'] = '/home/wwwroot/default/bbb.jpg';
        $config['width'] = 600;
        $config['height'] = 500;

        $this->load->library('image_lib');
        $this->image_lib->initialize($config);
        $aa = $this->image_lib->resize();
        print_r($aa);
        die;
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, "http://192.168.1.143:18083/api/v2/nodes/emq@127.0.0.1/subscriptions");

        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_HTTPAUTH, CURLAUTH_ANY);
        curl_setopt($ch, CURLOPT_USERPWD, "admin:public");
        $result = curl_exec($ch);
        curl_close($ch);
        print_r($result);


    }
}

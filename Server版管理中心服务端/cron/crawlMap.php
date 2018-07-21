<?php
include dirname(dirname(__FILE__)) . "/application/config/constants.php";
$con = mysql_connect("localhost","root","root");
if (!$con)
{
    die('Could not connect: ' . mysql_error());
}

mysql_select_db("management", $con);

$result = mysql_query("SELECT `traffic` FROM `configuration`");

while($row = mysql_fetch_array($result))
{
    $traffic_info=json_decode($row['traffic'],true);
}
mysql_close($con);

$html_map = '<html>
            <head>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
            <meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
            <link href="http://api.map.baidu.com/library/TrafficControl/1.4/src/TrafficControl_min.css" rel="stylesheet" type="text/css" />
            <script type="text/javascript" src="http://api.map.baidu.com/api?v=1.4"></script>
            <script type="text/javascript" src="http://api.map.baidu.com/library/TrafficControl/1.4/src/TrafficControl_min.js"></script>
            <style>.anchorBL{display:none;}body{ margin: 0; }</style>
             </head>
             <body>
                <div style="width:100%;height:100%;" id="container">
                </div>
                <script type="text/javascript">
                   var map = new BMap.Map("container");
                var geolocation = new BMap.Geolocation();
                var gc = new BMap.Geocoder();
                    var currPoint = new BMap.Point('.$traffic_info['lng'].', '.$traffic_info['lat'].');
                   map.centerAndZoom(currPoint, '.$traffic_info['zoom'].');
                   var ctrl = new BMapLib.TrafficControl({
                       showPanel: false
                   });
                   map.addControl(ctrl);
                   ctrl.setAnchor(BMAP_ANCHOR_BOTTOM_RIGHT);
                    ctrl.showTraffic();
                </script>
             </body>
            </html>';
//获取web页面
file_put_contents(dirname(dirname(__FILE__)) . "/cron/index.html", $html_map);

//利用phantomjs截取页面影像
$phantomjs = dirname(dirname(__FILE__)) . "/phantomjs/bin/phantomjs ";
$rasterize = dirname(dirname(__FILE__)) . "/phantomjs/examples/rasterize.js";

$param_7 = " http://".MASTER."/cron/ ".dirname(dirname(__FILE__)) . "/cron/map_7.png"." 1024px*492px";
$param_10 = " http://".MASTER."/cron/ ".dirname(dirname(__FILE__)) . "/cron/map_10.png"." 1280px*692px";
$thumbnail = " http://".MASTER."/cron/ ".dirname(dirname(__FILE__)) . "/cron/thumbnail.png"." 270px*272px";
exec($phantomjs . $rasterize . $param_7, $rs);
exec($phantomjs . $rasterize . $param_10, $rs);
exec($phantomjs . $rasterize . $thumbnail, $rs);
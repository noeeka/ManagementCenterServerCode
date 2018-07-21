<?php
// 根据时间范围获取时间数组
function getTimeArrayByTime($timeFrom, $timeTo,$minTimeInterval){
	$minTimeInterval=BOOKING_MIN_TIME;//最小必须是5分钟add by paul 2018-03-13
    $timeArray = array();
    $timeFromTime = strtotime($timeFrom);
    $timeToTime = strtotime($timeTo);
    $count = ($timeToTime - $timeFromTime)/($minTimeInterval*60);
    for ($i = 0; $i < $count; $i++) {
        $iArray = array("timeFrom"=>date("H:i", $timeFromTime),"timeTo"=>date("H:i", $timeFromTime + ($minTimeInterval*60)));
        $timeFromTime += ($minTimeInterval*60);
        $timeArray[$i] = $iArray;
    }
    return $timeArray;
}
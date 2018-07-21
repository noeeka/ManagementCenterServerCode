<?php

//创建系统实体
class Systems extends CI_Controller
{
    public function __construct()
    {
        parent::__construct();
    }

    //获取系统状态服务
    public function status()
    {
        //初始化数组
        $ret = array();

        exec('top n 1 b i', $top, $error);

        if (!$error) {

            preg_match_all("/:(.*)us/", $top[2], $cpu_arr);
            preg_match_all("/:(.*)total/", $top[3], $mem_total);
            preg_match_all("/total,(.*)used/", $top[3], $mem_used);

            $mem_float = ($mem_used[1][0] / $mem_total[1][0]);
            $mem = number_format($mem_float, 2, '.', '');
            $ret['cpu'] = trim($cpu_arr[1][0]);
            $ret['mem'] = $mem;
        } else {
            $ret['cpu'] = '0';
            $ret['mem'] = '0';
        }

        echo json_encode(array("state" => 0, "ret" => $ret));
        die;
    }
}

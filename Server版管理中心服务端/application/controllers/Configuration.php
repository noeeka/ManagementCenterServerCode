<?php
/**
 * Created by PhpStorm.
 * User: Eric
 * Date: 2017/12/2
 * Time: 11:37
 */

class Configuration extends CI_Controller
{

    public function __construct()
    {
        parent::__construct();
    }


    //交通流量地图参数服务
    function trafficMapParam()
    {
		set_time_limit(0);
        if (!$_POST) {
            $this->db->select('traffic');
            $result = $this->db->get('configuration')->row();

            if ($result) {
                echo json_encode(array("state" => 1, "ret" => json_decode($result->traffic, true)));
            } else {
                echo json_encode(array("state" => 0, "ret" => array()));
            }
        } else {
            $lng = $this->input->post("lng");
            $lat = $this->input->post("lat");
            $zoom = $this->input->post("zoom");

            $this->db->set('traffic', json_encode(array(
                "lng" => $lng,
                "lat" => $lat,
                "zoom" => $zoom)));
            $this->db->update('configuration');


            exec("php " . dirname(dirname(dirname(__FILE__))) . '/cron/crawlMap.php 2>&1', $log, $status);
			echo json_encode(array("state" => 1, "ret" => "success"));
        }


    }

    //添加新闻设置服务
    function newsCate()
    {
        if (!$_POST) {
            $this->db->select('news');
            $result = $this->db->get('configuration')->row();
            if ($result) {
                echo json_encode(array("state" => 1, "ret" => json_decode($result->news, true)));
            } else {
                echo json_encode(array("state" => 0, "ret" => array()));
            }
        } else {
            $cate = $this->input->post("cate");
            $this->db->set('news', json_encode(array($cate)));
            $this->db->update('configuration');
            echo json_encode(array("state" => 1, "ret" => "success"));
        }
    }

    //当前城市设置
    function location()
    {
        if (!$_POST) {
            $this->db->select('location');
            $result = $this->db->get('configuration')->row();
            if ($result) {
                echo json_encode(array("state" => 1, "ret" => json_decode($result->location, true)));
            } else {
                echo json_encode(array("state" => 0, "ret" => array()));
            }
        } else {
            $cityid = $this->input->post("citycode");
            $cityname = $this->input->post("cityname");
            $this->db->set('location', json_encode(array("citycode" => $cityid, "cityname" => $cityname)));
            $this->db->update('configuration');
            //调用从服务器更改API参数服务


            echo file_get_contents("http://" . SLAVER . "/?c=common&m=crawlWeather");
        }
    }


    //获取省市列表服务
    function getCityList()
    {
        $res = array();
        $result = $this->db->get('city_info')->result();
        foreach ($result as $key => $value) {
            if ($value->city === $value->district) {
                array_push($res, (array )$value);
            }
        }
        $temp_arr = [];
        foreach ($res as $key => $value) {
            $temp_arr[$value['province']][] = $value;
        }
        $rt = array();
        $i = 0;
        foreach ($temp_arr as $key => $item) {
            $id = end($item);
            $rt[$i]['id'] = $id['city_id'];
            $rt[$i]['name'] = $key;
            $rt[$i]['pid'] = $id['city_id'];
            $j = 0;
            $rt_citys = array();
            foreach ($item as $k => $v) {
                if ($item[$j]['city'] != $item[$j + 1]['city']) {
                    array_push($rt_citys, array(
                        "id" => $v['city_id'],
                        "name" => $v['city'],
                        "pid" => $v['city_id']));
                }
                $rt[$i]['cities'] = $rt_citys;
                $j++;
            }
            $i++;
        }
        echo json_encode(array("state" => 1, "data" => array_values($rt)));
        die;
    }

    //保存RSS新闻
    function rssNews()
    {
        if (!$_POST) {
            $this->db->select('news');
            $result = $this->db->get('configuration')->row();
            if ($result) {
                echo json_encode(array("state" => 1, "ret" => json_decode($result->news, true)));
            } else {
                echo json_encode(array("state" => 0, "ret" => array()));
            }
        } else {
            $newsid = $this->input->post("newsid");

            $newsname = $this->input->post("newsname");

            $this->db->set('news', json_encode(array("newsid" => $newsid, "newsname" => $newsname),JSON_UNESCAPED_SLASHES));
            $this->db->update('configuration');

            //调用获取新闻服务
			unset($log);
			exec("python " . dirname(dirname(dirname(__FILE__))) . "/lib/python/crawlNews.py", $log, $status);
			echo end($log);
			die;
        }
    }
	//清空新闻列表服务
	public function truncateRss(){
        $rs=$this->input->post();
		$this->db->set('news',json_encode(array("newsid"=>$rs['source'],"newsname"=>$rs['newsname']),JSON_UNESCAPED_SLASHES));
		$this->db->update('configuration');
		$this->db->truncate("message_news");
		echo json_encode(array("state"=>1));
	}
}



?>

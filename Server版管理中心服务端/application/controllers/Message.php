<?php

/**
 * Created by PhpStorm.
 * User: James
 * Date: 2017/11/28
 * Time: 14:49
 */
class Message extends CI_Controller {
	public function __construct()
	{
		parent::__construct();
	}

	#########################天气模块##############################
	//消息推送 获取天气信息
	function getWeatherInfo()
	{
		$this->db->select('weather');
		$this->db->order_by('id DESC');
		$result_tmp = $this->db->get('message_weather')->row();


		$res_arr = (array)$result_tmp;
		$res = (json_decode($res_arr['weather'], TRUE));
		$result = array();
		if ( ! empty($res))
		{
			if ( ! empty($res['weather']))
			{
				foreach ($res['weather'] as $key => $value)
				{
					$result[$key]['date'] = strtotime($value['date']);
					$result[$key]['dayImg'] = $value['info']['day'][0];
					$result[$key]['dayWeather'] = ($value['info']['day'][1]);
					$result[$key]['dayTmp'] = $value['info']['day'][2];
					$result[$key]['dayWind'] = $value['info']['day'][3];
					$result[$key]['dayWindF'] = $value['info']['day'][4];


					$result[$key]['nightImg'] = $value['info']['night'][0];
					$result[$key]['nightWeather'] = $value['info']['night'][1];
					$result[$key]['nightTmp'] = $value['info']['night'][2];
					$result[$key]['nightWind'] = $value['info']['night'][3];
					$result[$key]['nightWindF'] = $value['info']['night'][4];


					if ( ! empty($value['info']['dawn']))
					{
						$result[$key]['dawnImg'] = $value['info']['dawn'][0];
						$result[$key]['dawnWeather'] = $value['info']['dawn'][1];
						$result[$key]['dawnTmp'] = $value['info']['dawn'][2];
						$result[$key]['dawnWind'] = $value['info']['dawn'][3];
						$result[$key]['dawnWindF'] = $value['info']['dawn'][4];
					}
				}
				$result_forest = array_values($result);

			}

			//print_r($result_forest);
			$result = array_shift($result_forest);
			if (empty($result_forest))
			{
				file_put_contents("weather.log", date("Y-m-d H:i:s") . "\r\n", FILE_APPEND);
			}
			echo json_encode(array("state" => 1, "ret" => array("weather" => $result_forest, "pm25" => $res['pm25']['pm25'], "realtime" => $res['realtime'])), JSON_UNESCAPED_UNICODE);
			die;
		}
		else
		{
			echo json_encode(array("state" => 0, "ret" => ""));
			die;
		}
	}

	#########################交通模块##############################
	//获取限行信息
	function getTrafficInfo()
	{
		echo json_encode(array("state" => 1, "ret" => ""), JSON_UNESCAPED_UNICODE);
		die;
		$this->db->select('trafficinfo');
		$this->db->order_by('id DESC');
		$result_tmp = $this->db->get('message_traffic_ban_info')->row();
		$res_arr = (array)$result_tmp;
		$configur = $this->db->get('configuration')->row();
		$result = array();

		$this->db->like('name', trim(end(explode("/", end(json_decode($configur->location, TRUE))))), 'both');
		$result_ban_city = $this->db->get('message_traffic_ban_city')->result();
		if ($res_arr['trafficinfo'] === "\"所有号牌;所有号牌;所有号牌;所有号牌;所有号牌;所有号牌;所有号牌\"" || empty($result_ban_city))
		{
			echo json_encode(array("state" => 1, "ret" => array("traffic" => array())), JSON_UNESCAPED_UNICODE);
			die;
		}
		$numbers = explode(";", str_replace("\"", "", $res_arr['trafficinfo']));
		foreach ($numbers as $key => $value)
		{
			$time = time() + $key * 24 * 60 * 60;
			$result[$key]['date'] = $time;
			if ($value == "不限行")
			{
				$result[$key]['num'] = "N";
			}
			else
			{
				$result[$key]['num'] = $value;
			}
		}
		if (empty($result))
		{
			file_put_contents("weather.log", date("Y-m-d H:i:s") . "\r\n", FILE_APPEND);
		}
		echo json_encode(array("state" => 1, "ret" => array("traffic" => $result)), JSON_UNESCAPED_UNICODE);
		die;
	}


	#########################地理信息模块##############################
	//获取公网IP地址服务
	function getOuterIP()
	{
		$this->load->library('Curl');
		$this->load->library('CurlResponse');
		$curl = new Curl;
		$url = 'http://2017.ip138.com/ic.asp';
		$info = $curl->get($url);
		preg_match('/\[(.*)\]/i', $info->body, $m);
		if (empty($m[1]))
		{
			echo json_encode(array("state" => 0, "ret" => "Outer IP get error"));
			die;
		}
		else
		{
			return $m[1];
		}
	}

	//根据公网IP获取所在城市信息服务
	function getCityInfoByIP()
	{
		$this->load->library('Curl');
		$this->load->library('CurlResponse');
		$curl = new Curl;
		$res = $curl->get('http://int.dpool.sina.com.cn/iplookup/iplookup.php?format=json&ip=' . $this->getOuterIP());

		$result = json_decode($res->body, TRUE);
		if (empty($result['city']))
		{
			echo json_encode(array("state" => 0, "ret" => "City Info get error"));
			die;
		}
		else
		{
			return $result['city'];
		}
	}


#########################新闻模块##############################
//获取新闻类别服务
	function getNewsCate()
	{
		$result = array("chinese_simple" => array("http://www.people.com.cn/rss/politics.xml", "人民网"), "en" => array("https://www.engadget.com/rss.xml", "Yahoo(EN)"), "chinese_traditional" => array("http://www.hket.com/rss/hongkong", "Yahoo(繁)"),"tencent" => array("http://news.qq.com/newsgn/rss_newsgn.xml", "腾讯"), "BBC" => array("http://feeds.bbci.co.uk/news/rss.xml", "BBC"));
		if ( ! empty($result))
		{
			echo json_encode(array("state" => 1, "ret" => $result));
			die;
		}
		else
		{
			echo json_encode(array("state" => 0, "ret" => "error"));
			die;
		}
	}


	//获取新闻服务
	function getNews()
	{
		$configuration = $this->db->get('configuration')->row();
		$news_cates = (json_decode($configuration->news, TRUE));
		$this->db->order_by('mtime DESC');
		$this->db->limit(RPP, 0);
		$result_tmp = $this->db->get('message_news')->result();
		$result = array();

		foreach ($result_tmp as $key => $value)
		{
			$result[$key]['id'] = $value->id;
			$result[$key]['cateid'] = $value->cateid;
			$result[$key]['cate'] = $value->cate;
			$result[$key]['docid'] = $value->docid;
			$result[$key]['digest'] = $value->digest;
			$result[$key]['imgsrc'] = $value->imgsrc;
			$result[$key]['mtime'] = strtotime(date("Y-m-d H:i", strtotime($value->mtime)));
			$result[$key]['source'] = $value->source;
			$result[$key]['title'] = $value->title;
			$result[$key]['url'] = $value->url;
			$result[$key]['datetime'] = $value->datetime;
		}
		$result = sigcol_arrsort($result, "mtime", $type = SORT_DESC);

		echo json_encode(array("state" => 1, "ret" => $result));
	}

	//获取交通实时路况服务
	function getTrafficFlow()
	{
		if (empty($_GET['size']) || $_GET['size'] != 7)
		{
			$size = 10;
		}
		else
		{
			$size = $_GET['size'];
		}
		//获取影像地址
		echo json_encode(array("state" => 1, "ret" => array("original" => base_url() . "cron/map_" . $size . ".png", "thumbnail" => base_url() . "cron/thumbnail.png")));
		die;
	}

	//短消息发送记录服务
	function smsLog()
	{
		if ( ! $_POST)
		{
			$page=$_GET['page']?(int)$_GET['page']:'0';
			$size=RPP;

			$result = array();
			$i = 0;
			foreach ($this->db->get('message_record')->result() as $key => $value)
			{
				foreach (json_decode($value->receiver, TRUE) as $k => $v)
				{
					$result[$i]['id'] = $value->id;
					$result[$i]['mid'] = $value->mid;
					$result[$i]['title'] = $value->title;
					$result[$i]['important'] = $value->important;
					$result[$i]['content'] = $value->content;
					$result[$i]['status'] = $v['status'];
					$result[$i]['location'] = $v['location'];
					$result[$i]['sender'] = $value->sender;
					$result[$i]['datetime'] = $value->datetime;
					$i++;
				}
			}

			$j = 0;
			foreach (array_group_by($result, "mid") as $key => $value)
			{

				$result_filter[$j]['mid'] = $value[0]['mid'];
				$result_filter[$j]['title'] = $value[0]['title'];
				$result_filter[$j]['important'] = $value[0]['important'];
				$result_filter[$j]['content'] = $value[0]['content'];
				$grouped = array();
				foreach ($value as $v)
				{
					if ($v['status'] == 0)
					{
						$grouped['fail'][] = $v['location'];
					}
					else
					{
						$grouped['success'][] = $v['location'];
					}

				}

				$result_filter[$j]['locations'] = $grouped;
				$result_filter[$j]['sender'] = $value[0]['sender'];
				$result_filter[$j]['datetime'] = $value[0]['datetime'];
				$j++;
			}
			$newArray = array_slice(sigcol_arrsort($result_filter, "datetime"),($page-1)*$size,$size);
			echo json_encode(array("state" => 1, "ret" => $newArray, "total" => count($result_filter)));


		}
		else
		{
			$postData = $this->input->post('data');
			$title = $postData['title'];//标题
			$important = $postData['important'];//是否重要
			$content = $postData['content'];//内容
			$sender = $postData["sender"];//发送者
			$mid = $postData["mid"];//mid
			$datetime = time();


			require dirname(dirname(__FILE__)) . '/libraries/phpMQTT.php';
			$sendReceivers = array();
			$locations = array();

			foreach ($postData["receiver"] as $key => $value)
			{

				$group = array();
				$res_temp = explode("-", $value['id']);
				$build_info = $this->db->get_where('base_building_info', array('building_id' => $res_temp[0]))->row();
				$unit_info = $this->db->get_where('base_unit_info', array('unit_id' => $res_temp[1]))->row();
				$room_info = $this->db->get_where('base_room_info', array('room_id' => $res_temp[2]))->row();


				$topic_append = placeholderLocation($build_info->building, "building") . placeholderLocation($unit_info->unit, "unit") . placeholderLocation($room_info->room, "room");

				if (array_key_exists($topic_append, $this->getAvailableDevice()))
				{
					array_push($locations, array("location" => $topic_append, "status" => 1));
				}
				else
				{
					array_push($locations, array("location" => $topic_append, "status" => 0));
				}
				foreach ($this->getAvailableDevice() as $v)
				{
					foreach ($v as $kk => $vv)
					{
						if (strstr($vv, $topic_append))
						{
							array_push($sendReceivers, $vv);
						}
					}

				}
			}
			$mqtt = new phpMQTT(EMQTTD_IP, EMQTTD_PORT, EMQTTD_ID);
			if ($mqtt->connect())
			{
				foreach ($sendReceivers as $v)
				{
					$mqtt->publish($v, json_encode(array('cate' => 'message', 'subcate' => 'property', 'title' => $title, 'content' => $content, 'important' => intval($important), 'datetime' => $datetime)), 1);

				}
				$mqtt->close();
			}
			$data = array(
				'title' => $title,
				'important' => $important,
				'content' => $content,
				'receiver' => json_encode($locations),
				'sender' => $sender,
				'datetime' => $datetime,
				'mid' => $mid,
			);
			$result = $this->db->insert('message_record', $data);
			if ($result)
			{
				echo json_encode(array("state" => 1, "ret" => "success"));
			}

		}
	}


	//消息重发服务
	function resendSMS()
	{
		$postData = $this->input->post('data');
		$receiver = $postData["receiver"];//接收者
		$mid = $postData["mid"];//mid
		$title = $postData['title'];//标题
		$important = $postData['important'];//是否重要
		$content = $postData['content'];//内容
		$sender = $postData["sender"];//发送者
		$mid = $postData["mid"];//mid
		$datetime = time();
		require dirname(dirname(__FILE__)) . '/libraries/phpMQTT.php';
		$sendReceivers = array();
		$locations = array();


		foreach ($postData["receiver"] as $key => $value)
		{
			if (array_key_exists($value, $this->getAvailableDevice()))
			{
				array_push($locations, array("location" => $value, "status" => 1));
			}
			else
			{
				array_push($locations, array("location" => $value, "status" => 0));
			}

			foreach ($this->getAvailableDevice() as $v)
			{
				if (strstr($v, $value))
				{
					array_push($sendReceivers, $v);
				}
			}
		}

		$locations_temp = json_decode($this->db->query("SELECT * from `message_record` WHERE `mid`='" . $mid . "'")->row()->receiver, TRUE);
		$new_locations = array();
		foreach ($locations as $k => $v)
		{
			$new_locations[$v['location']] = $v['status'];
		}

		foreach ($locations_temp as $key => $value)
		{
			if (array_key_exists($value['location'], $new_locations))
			{
				unset($locations_temp[$key]);
			}
		}
		$final_locations = array_merge($locations_temp, $locations);


		$mqtt = new phpMQTT(EMQTTD_IP, EMQTTD_PORT, EMQTTD_ID);
		if ($mqtt->connect())
		{
			foreach ($sendReceivers as $v)
			{
				$mqtt->publish($v, json_encode(array('cate' => 'message', 'subcate' => 'property', 'title' => $title, 'content' => $content, 'important' => intval($important), 'datetime' => $datetime)), 1);
			}
			$mqtt->close();
		}
		$result = $this->db->query("UPDATE `message_record` SET `receiver`='" . json_encode($final_locations) . "' WHERE `mid`='" . $mid . "'");

		if ($result)
		{
			echo json_encode(array("state" => 1, "ret" => "success"));
		}
	}

	//获取常用文本列表
	public function getMessageTemplate()
	{

		$rpp = $this->input->get('rpp');
		$page = $this->input->get('page');
		$rpp = empty($rpp) ? RPP : $this->input->get('rpp');
		$page = empty($page) ? 1 : $this->input->get('page');
		$this->db->limit($rpp, ($page - 1) * $rpp);
		$result = $this->db->get('message_template')->result();
		echo json_encode(array("state" => 1, "ret" => $result, "total" => $this->db->count_all_results('message_template')));
	}

	//保存常用文本列表
	public function saveMessageTemplate()
	{
		$title = $this->input->post("title");
		$content = $this->input->post("content");
		$datetime = time();

		$data = array(
			'title' => $title,
			'content' => $content,
			'datetime' => $datetime
		);

		$result = $this->db->insert('message_template', $data);
		if ($result)
		{
			echo json_encode(array("state" => 1, "ret" => "success"));
		}
	}

	//删除常用文本列表
	public function removeMessageTemplate()
	{
		$message_id = $this->input->post('id');
		$this->db->delete('message_template', array('id' => $message_id));

		echo json_encode(array("state" => 1, "ret" => "success"));
	}

	/************************************日历事件模块********************************************/
	function addEvent()
	{

		$titles = $this->input->post("title");

		foreach ($titles as $key => $value)
		{
			$datetime = strtotime($this->input->post("datetime"));
			file_put_contents("/home/wwwroot/default/aa", $datetime . "\r\n", FILE_APPEND);
			$data = array("title" => $value, "datetime" => $datetime);
			$result = $this->db->insert('message_event', $data);
			file_put_contents("/home/wwwroot/default/aa", $this->db->last_query() . "\r\n", FILE_APPEND);
		}


		if ($result)
		{
			//MQTT通讯操作待和小曽调试
			$content = json_encode(array(
				'cate' => 'calendar',
				'subcate' => 'event',
				'title' => $titles,
				'datetime' => time()));
			sendMQTTMSG("Calendar", $content);
			echo json_encode(array("state" => 1, "ret" => "success"));
		}
	}

	//获取事件列表服务
	function getEvents()
	{
		$rpp = empty($rpp) ? RPP : $this->input->get('rpp');
		$page = empty($page) ? 1 : $this->input->get('page');
		if (empty($this->input->get('date')))
		{
			$this->db->limit($rpp, ($page - 1) * $rpp);
			$this->db->order_by('event_id', 'DESC');
			$result = $this->db->get('message_event')->result();
			echo json_encode(array("state" => 1, "ret" => $result, "total" => $this->db->count_all_results('message_event')));
			die;
		}
		else
		{
			$date = strtotime($this->input->get('date'));
			$this->db->order_by('event_id', 'DESC');
			$this->db->limit($rpp, ($page - 1) * $rpp);

			$result = $this->db->get_where('message_event', array("datetime" => $date))->result();
			echo json_encode(array("state" => 1, "ret" => $result));
			die;

		}

	}

	//根据月份获取哪天包含日历事件服务
	function getEventDayByMonth()
	{
		$month = $this->input->get('month');
		$startDate = $month . "-01";
		$lastDate = date('Y-m-d', strtotime("$startDate +1 month -1 day"));
		$sql = "select * from message_event where datetime >=" . strtotime($startDate) . " and datetime<=" . strtotime($lastDate);
		file_put_contents("/home/wwwroot/default/aa", $sql . "\r\n", FILE_APPEND);
		$result = $this->db->query($sql)->result();

		if ( ! empty($result))
		{
			foreach ($result as $key => $value)
			{
				$res[$key] = $value->datetime;
			}
		}
		else
		{
			$res = array();
		}
		$reansfer_tmp = array_unique($res);

		foreach ($reansfer_tmp as $key => $value)
		{
			$new_arr = array();
			$temp_array = array();
			$sql = "select * from message_event where datetime=" . $value;
			$result = $this->db->query($sql)->result();
			foreach ($result as $k => $v)
			{
				$new_arr[$k]['id'] = $v->event_id;
				$new_arr[$k]['title'] = $v->title;
				$new_arr[$k]['datetime'] = $v->datetime;
			}
			$temp_array = sigcol_arrsort($new_arr, "id", $type = SORT_DESC);
			if ($temp_array[0]['title'] == "" && $temp_array[1]['title'] == "" && $temp_array[2]['title'] == "")
			{
				unset($reansfer_tmp[$key]);
			}

		}
		foreach (array_values($reansfer_tmp) as $k => $v)
		{
			$res[] = date("Y-m-d", $v);
		}
		echo json_encode(array("state" => 1, "ret" => $res));
		die;

	}


	//获取系统时间服务
	function getServerTime()
	{
		echo json_encode(array("state" => 1, "ret" => time()));
	}

	function getServerTimeByFormat()
	{
		echo json_encode(array("state" => 1, "ret" => date("Y-m-d", time())));
	}

	function __getEMQTTopic()
	{
		$raw_data = $this->_getHTTPS("http://" . EMQTTD_IP . ":18083/api/v2/nodes/emq@127.0.0.1/subscriptions?timestamps=1519725008636");
		$raw_data = json_decode($raw_data, TRUE);
		$res = array();
		$i = 0;
		for ($page = 1; $page <= $raw_data['result']['total_page']; $page++)
		{
			$raw_data = $this->_getHTTPS("http://" . EMQTTD_IP . ":18083/api/v2/nodes/emq@127.0.0.1/subscriptions?curr_page=" . $page . "&page_size=10");
			$raw_data = json_decode($raw_data, TRUE);
			foreach ($raw_data['result']['objects'] as $key => $value)
			{
				$res[$i]['topic'] = $value['topic'];
				$res[$i]['client_id'] = $value['client_id'];
				$i++;
			}
		}
		return ($res);
	}

	function __getEMQTTClients()
	{
		$raw_data = $this->_getHTTPS("http://" . EMQTTD_IP . ":18083/api/v2/nodes/emq@127.0.0.1/clients?timestamps=1519725008636");
		$raw_data = json_decode($raw_data, TRUE);
		$res = array();
		$i = 0;
		for ($page = 1; $page <= $raw_data['result']['total_page']; $page++)
		{
			$raw_data = $this->_getHTTPS("http://" . EMQTTD_IP . ":18083/api/v2/nodes/emq@127.0.0.1/clients?curr_page=" . $page . "&page_size=10");
			$raw_data = json_decode($raw_data, TRUE);
			foreach ($raw_data['result']['objects'] as $key => $value)
			{
				$res[$i]['ipaddress'] = $value['ipaddress'];
				$res[$i]['client_id'] = $value['client_id'];
				$i++;
			}
		}
		return ($res);

	}

	function getAvailableDevice()
	{
		$topics = $this->__getEMQTTopic();
		$clients = $this->__getEMQTTClients();
		$resTemp = array();
		foreach ($clients as $key => $value)
		{
			$resTemp[] = $value['client_id'];
		}
		$res = array();
		foreach ($topics as $key => $value)
		{
			if (strstr($value['topic'], "Message/") && in_array($value['client_id'], $resTemp))
			{
				$res[substr(end(explode("?", $value['client_id'])), 2, 9)][] = $value['topic'];
			}
		}
		return $res;
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
}

<?php

//创建公告实体
class Announcement extends CI_Controller {
	public function __construct()
	{
		parent::__construct();
	}

	//存储公告内容
	function publishAnnouncement()
	{
		//公告类型type=0:图文 type=1:视频 type=2:纯文字
		$type = $this->input->post('type');
		$content = $this->input->post('content');
		$username = $this->input->post('username');
		$deadline = strtotime($this->input->post('deadline'));
		$deadline = strtotime(date("Y-m-d", $deadline) . " 23:59:59");
		$target = $this->input->post("target");
		if ($deadline < time())
		{
			echo json_encode(array("state" => 0, "ret" => "fail(time is error)"));
			die;
		}
		require dirname(dirname(__FILE__)) . '/libraries/phpMQTT.php';
		$mqtt = new phpMQTT(EMQTTD_IP, EMQTTD_PORT, EMQTTD_ID);
		if ($type == 0)
		{
			//先将base64转换成影像文件
			header('Content-type:text/html;charset=utf-8');
			//匹配出图片的格式
			if (preg_match('/^(data:\s*image\/(\w+);base64,)/', $content, $result))
			{
				$type = $result[2];
				$img_path = dirname(dirname(dirname(__file__))) . "/files/notice";
				if ( ! is_dir($img_path))
				{
					mkdir($img_path);
				}
				$file_name = "notice_" . time() . "." . $type;
				$new_file = $img_path . "/" . $file_name;
				if (file_put_contents($new_file, base64_decode(str_replace($result[1], '', $content))))
				{

					//保存成功后入库操作
					$data = array(
						'content' => "/files/notice/" . $file_name,
						'raw' => $this->input->post("raw"),
						'author' => $username, //此处暂定，登录做好在替换
						'deadline' => $deadline,
						'type' => $type,
						'datetime' => time(),
						'bgcolor' => $this->input->post('bgcolor'),
						'target' => json_encode($target)
					);
					$flag = $this->db->insert('notice_info', $data);
					if ($flag)
					{
						//EMQTTD通讯操作待和小齐调试
						$content = json_encode(array(
							'cate' => 'notice',
							'subcate' => 'richmedia',
							'id' => $this->db->insert_id(),
							'content' => "/files/notice/" . $file_name,
							'deadline' => $deadline,
							'datetime' => time()));


						senddMQTTMSGByGroup($target, "Notice", $content);


					}
					echo json_encode(array("state" => 1, "ret" => "success"));
					die;
				}
				else
				{
					echo json_encode(array("state" => 0, "ret" => "notice create image failed"));
					die;
				}
			}
		}
		elseif ($type == 1)
		{
			file_put_contents("/home/wwwroot/default/aa",json_encode($this->input->post())."\r\n",FILE_APPEND);
			if (SLAVER == MASTER)
			{
				$link = $content;
			}
			else
			{
				$content = json_decode(urldecode($content), TRUE);
				$link = $content['link'];
			}
			echo request_post("http://" . SLAVER . "/index.php?c=Handler&m=handleVideo", "content=" . $link . "&deadline=" . $deadline . "&username=" . $username . "&targets=" . json_encode($target)."&file_name=".($this->input->post("name")));
		}
		elseif ($type == 2)
		{
			//保存成功后入库操作
			$data = array(
				'content' => $content,
				'author' => $username, //此处暂定，登录做好在替换
				'deadline' => $deadline,
				'type' => $type,
				'datetime' => time(),
				'target' => json_encode($target));
			$flag = $this->db->insert('notice_info', $data);
			if ($flag)
			{

				$content = json_encode(array(
					'cate' => 'notice',
					'subcate' => 'text',
					'id' => $this->db->insert_id(),
					'content' => $content,
					'deadline' => $deadline,
					'datetime' => time()));

				file_put_contents("/home/wwwroot/default/aa",json_encode($content)."\r\n",FILE_APPEND);
				senddMQTTMSGByGroup($target, "Notice", $content);
			}
			echo json_encode(array("state" => 1, "ret" => "success"));
			die;
		}
	}

	//分页显示公告列表
	function listAnnouncement()
	{

		$rpp = $this->input->get('rpp');
		$page = $this->input->get('page');
		$res = array();
		//公告类型type=0:图文 type=1:视频 type=2:纯文字
		$type = $this->input->get('type');
		$rpp = empty($rpp) ? RPP : $this->input->get('rpp');
		$page = empty($page) ? 1 : $this->input->get('page');
		$this->db->order_by('deadline', 'DESC');
		$this->db->order_by('datetime', 'DESC');
		$this->db->limit($rpp, ($page - 1) * $rpp);

		$result = $this->db->get_where('notice_info', array("type" => $type))->result();
		$this->db->where('type', $type);
		$count = $this->db->count_all_results('notice_info');

		foreach ($result as $key => $value)
		{
			if (($value->deadline) < time())
			{
				$res[$key]['status'] = 1;
			}
			else
			{
				$res[$key]['status'] = 0;
			}
			$res[$key]['id'] = $value->id;
			$res[$key]['content'] = $value->content;
			preg_match_all("/(.*)post_(.*)_(.*)/iUs",$value->content,$temps);
			$res[$key]['name'] = $temps[2][0];
			$res[$key]['author'] = $value->author;
			$res[$key]['deadline'] = date("Y/m/d", $value->deadline);
			$res[$key]['datetime'] = date("Y/m/d", $value->datetime);
			$res[$key]['type'] = $value->type;
			$res[$key]['raw'] = $value->raw;
			$res[$key]['thumb'] = $value->thumb;
			$res[$key]['target'] = json_decode($value->target);
		}
		echo json_encode(array(
			"state" => 1,
			"ret" => $res,
			"total" => $count));
	}

	//门口机公告列表API
	function getTextAnnouncements()
	{
		$res = array();
		//公告类型type=0:图文 type=1:视频 type=2:纯文字
		$this->db->order_by('deadline', 'DESC');
		$this->db->order_by('datetime', 'DESC');
		$this->db->limit(5, 0);
		$result = $this->db->get_where('notice_info', array("type" => 2))->result();


		foreach ($result as $key => $value)
		{
			if (($value->deadline + 24 * 60 * 60) > time())
			{
				$res[$key]['id'] = $value->id;
				$res[$key]['content'] = $value->content;
				$res[$key]['author'] = $value->author;
				$res[$key]['deadline'] = $value->deadline;
				$res[$key]['datetime'] = $value->datetime;
				$res[$key]['type'] = $value->type;
			}

		}
		echo json_encode(array("state" => 1, "ret" => $res));
	}


	//门口机公告列表API
	function getMediaAnnouncements()
	{
		$res = array();
		//公告类型type=0:图文 type=1:视频 type=2:纯文字

		$this->db->order_by('deadline', 'DESC');
		$this->db->order_by('datetime', 'DESC');
		$this->db->limit(5, 0);
		$this->db->where('type!=', 2);
		$result = $this->db->get('notice_info')->result();

		foreach ($result as $key => $value)
		{
			if (($value->deadline + 24 * 60 * 60) > time())
			{
				$res[$key]['id'] = $value->id;
				$res[$key]['content'] = $value->content;
				$res[$key]['author'] = $value->author;
				$res[$key]['deadline'] = $value->deadline;
				$res[$key]['datetime'] = $value->datetime;
				$res[$key]['type'] = $value->type;
			}

		}
		echo json_encode(array("state" => 1, "ret" => $res));
	}

	//根据公告ID查看公告服务
	function reviewInfo()
	{
		$id = $this->input->get('id');
		$result = $this->db->get_where('notice_info', array("id" => $id))->row();
		if ($result)
		{
			echo json_encode(array("state" => 1, "ret" => $result));
		}
	}

	//删除公告服务
	function removeAnnouncement()
	{
		$id = $this->input->post('id');
		$info = $this->db->get_where('notice_info', array("id" => $id))->row();
		$unlink_flag = TRUE;
		if ($info->type != 2)
		{
			$file = $info->content;
			$unlink_flag = unlink(dirname(dirname(dirname(__file__))) . $file);
		}
		$result = $this->db->delete('notice_info', array('id' => $id));
		if ($result && $unlink_flag)
		{
			$content = json_encode(array(
				'cate' => 'notice',
				'subcate' => 'remove',
				'id' => $id));

			sendMQTTMSG("Notice", $content);

			echo json_encode(array("state" => 1, "ret" => "success"));
		}
	}

}

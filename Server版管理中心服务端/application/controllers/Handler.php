<?php
/**
 * Created by PhpStorm.
 * User: James
 * Date: 2017/11/11
 * Time: 14:52
 * uasge:公共处理服务
 */

class Handler extends CI_Controller {
	public function __construct()
	{
		parent::__construct();
	}

	//处理视频服务
	/*
	 * @content POST
	 */
	function handleVideo()
	{
		set_time_limit(0);
		$pid=time();
		echo json_encode(array("state" => 1, "ret" => "success"));
		if (function_exists('fastcgi_finish_request'))
		{
			ob_flush();
			flush();
			fastcgi_finish_request();
		}
		$tumbfileName = $this->input->post('file_name')."_".date("YmdHis");
		$content = $this->input->post('content');
		$deadline = $this->input->post('deadline');
		$username = $this->input->post('username');
		$target = json_decode($this->input->post("targets"), TRUE);
		$filepath = dirname(dirname(dirname(__file__))) . "/files/video/";

		$this->db->insert("notice_encode_transfer",array("pid"=>$pid,"file_name"=>$tumbfileName));
		$cmd = 'ffmpeg -i ' . dirname(dirname(dirname(__file__))) . $content . ' -c:v libx264 -strict -2 ' . $filepath . "post_" . $tumbfileName . '.mp4';
		exec($cmd, $output, $error);
		$cmdImg = "ffmpeg -y -ss 10 -i " . dirname(dirname(dirname(__file__))) . $content .
			" -vframes 1 -f image2 -s 400*300 " . $filepath . "notice_thumb_" . $tumbfileName .
			'.jpg';

		exec($cmdImg, $outputImg, $errorImg);
		file_put_contents("/home/wwwroot/default/log.txt", "[" . date("Y-m-d H:i:s") . "] [INFO] video convert info. " . serialize($outputImg) . "\r\n", FILE_APPEND);
		$removeInt = unlink(dirname(dirname(dirname(__file__))) . $content);
		if ($removeInt)
		{
			//保存成功后入库操作
			$data = array(
				"content" => "/files/video/" . "post_" . $tumbfileName . '.mp4',
				"author" => $username,
				"deadline" => $deadline,
				"datetime" => time(),
				"type" => 1,
				"thumb" => "/files/video/" . "notice_thumb_" . $tumbfileName . '.jpg',
				'target' => json_encode($target)
			);
			$this->db->insert("notice_info", $data);
			//MQTT通讯操作
			$content = json_encode(array(
				'cate' => 'notice',
				'subcate' => 'video',
				'id' => $this->db->insert_id(),
				'content' => "/files/video/" . "post_" . $tumbfileName . '.mp4',
				'deadline' => $deadline,
				'datetime' => time()));

			senddMQTTMSGByGroup($target, "Notice", $content);
			$this->db->delete('notice_encode_transfer',array('pid'=>$pid));
		}
		echo json_encode(array("state" => 1, "ret" => "success"));
		die;
	}
}
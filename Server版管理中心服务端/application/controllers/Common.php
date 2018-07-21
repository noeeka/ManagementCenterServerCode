<?php
/**
 * User: Paul
 * Date: 2018/01/22
 * 通用公共API
 * Modifier: James
 * Description:
 */

class Common extends CI_Controller {
	public function __construct()
	{
		parent::__construct();
		//getToken();
	}

	public function getTokenByWebClient()
	{
		getToken();
	}

	public function uploadVideoFile()
	{
		$path = $this->input->get('path');
		require('UploadHandler.php');
		$upload_handler = new UploadHandler(array('upload_dir' => dirname(dirname(dirname(__FILE__))) . '/files/' . $path . '/'));
		$tmp = $upload_handler->response;
		$old_file = current($tmp['files'])->name;

		$temp = explode(".", $old_file);
		$extension = end($temp);
		$extensions = getVideoFile();
		if ( ! in_array($extension, $extensions))
		{
			echo json_encode(array("state" => 2, "msg" => "file format error"));
			die;
		}
		$new_file =($temp[0]."_". date("YmdHis") . '.' . $extension);
		$filePath = dirname(dirname(dirname(__FILE__))) . '/files/' . $path . '/';
		if ( ! is_dir($filePath))
		{
			mkdir($filePath);
		}
		$flag = rename($filePath . current($tmp['files'])->name, $filePath . $new_file);
		if ($flag)
		{
			$result = array("state" => 1, "link" => '/files/' . $path . '/' . $new_file);
		}
		else
		{
			$result = array("state" => 0, "msg" => "remove file fail");
		}
		echo json_encode($result);
		die;
	}

	/**
	 * 更加不同的业务类型上传对应目录的文件
	 *
	 * @param path
	 * @return path
	 */
	public function uploadFile()
	{
		$path = $this->input->get('path');
		require('UploadHandler.php');
		$upload_handler = new UploadHandler(array('upload_dir' => dirname(dirname(dirname(__FILE__))) . '/files/' . $path . '/'));
		$tmp = $upload_handler->response;
		if (empty($tmp['files']))
		{
			$content = $GLOBALS['HTTP_RAW_POST_DATA'];
			if (empty($content))
			{
				$content = file_get_contents('php://input');
			}


			$new_file = date("YmdHis") . ".jpg";
			$filePath = dirname(dirname(dirname(__FILE__))) . '/files/' . $path . '/';

			if ( ! is_dir($filePath))
			{
				mkdir($filePath);
			}
			$ret = file_put_contents($filePath . $new_file, $content, TRUE);
			if ($ret)
			{
				$result = array("link" => '/files/' . $path . '/' . $new_file);
			}
			else
			{
				$result = array("msg" => "remove file fail");
			}
			echo '/files/' . $path . '/' . $new_file;
			die;


		}


		$old_file = current($tmp['files'])->name;
		$temp = explode(".", $old_file);
		$extension = end($temp);
		$new_file = time() . '.' . $extension;
		$filePath = dirname(dirname(dirname(__FILE__))) . '/files/' . $path . '/';

		if ( ! is_dir($filePath))
		{
			mkdir($filePath);
		}
		//rename(oldname,newname,context)

		$flag = rename($filePath . current($tmp['files'])->name, $filePath . $new_file);
		if ($flag)
		{
			$result = array("link" => '/files/' . $path . '/' . $new_file);
		}
		else
		{
			$result = array("msg" => "remove file fail");
		}
		echo json_encode($result);
		die;
	}

	/**
	 * 编辑器上传图片服务
	 *
	 * @param path
	 * @return path
	 */
	public function uploadFileForEditor()
	{
		$path = $this->input->get('path');

		require('UploadHandler.php');

		$upload_handler = new UploadHandler(array('upload_dir' => dirname(dirname(dirname(__FILE__))) . '/files/' . $path . '/'));
		$tmp = $upload_handler->response;

		$old_file = current($tmp['files'])->name;
		$temp = explode(".", $old_file);
		$extension = end($temp);
		$new_file = time() . '.' . $extension;
		$filePath = dirname(dirname(dirname(__FILE__))) . '/files/' . $path . '/';

		if ( ! is_dir($filePath))
		{
			mkdir($filePath);
		}
		//rename(oldname,newname,context)

		$flag = rename($filePath . current($tmp['files'])->name, $filePath . $new_file);
		if ($flag)
		{
			$result = array("link" => '/files/' . $path . '/' . $new_file);
		}
		else
		{
			$result = array("msg" => "remove file fail");
		}
		echo json_encode($result);
		die;
	}


	/**
	 * 删除文件
	 *
	 * @param string $aimUrl
	 * @return boolean
	 */
	function deleteFile()
	{
		$filePath = $this->input->post("filePath");
		$filePath = dirname(dirname(dirname(__FILE__))) . $filePath;
		if (file_exists($filePath))
		{
			unlink($filePath);
			echo json_encode(array("state" => 1, "ret" => "success"));
		}
		else
		{
			echo json_encode(array("state" => 0, "ret" => "fail"));
		}
	}

	//公告上传
	public function noticeUpload()
	{
		$allowedExts = array("gif", "jpeg", "jpg", "png");
		// Get filename.
		$temp = explode(".", $_FILES["file"]["name"]);
		// Get extension.
		$extension = end($temp);
		if ($_FILES['file']['size'] > 2097152)
		{
			echo json_encode(array("state" => 2, "ret" => "File size too big"));
			die;
		}
		if ((($extension == "gif") ||
				($extension == "jpeg") ||
				($extension == "jpg") ||
				($extension == "png")) &&
			in_array($extension, $allowedExts))
		{
			$temp = explode(".", $_FILES["file"]["name"]);
			$extension = end($temp);
			$rename = time() . "." . $extension;
			$filePath = dirname(dirname(dirname(__FILE__))) . '/files/';
			move_uploaded_file($_FILES["file"]["tmp_name"], $filePath . $rename);
			$newfilepath = "../files/" . $rename;
			echo json_encode(array("state" => 1, "link" => $newfilepath));
		}
		else
		{
			echo json_encode(array("state" => 0, "ret" => "fail"));
		}
	}

	//备份
	public function backups()
	{
		$curr_date = date("YmdHis", time());

		$backup_name = $curr_date . ".sql";
		$filepath = dirname(dirname(dirname(__FILE__))) . "/files/db/";
		if ( ! is_dir($filepath))
		{
			mkdir($filepath);
		}
		/*$cmd = '/usr/bin/mysqldump -h127.0.0.1 -u' . DATABASE_USER . ' -p' . DATABASE_PWD . ' --opt --no-create-info management ' .
			' base_building_info base_unit_info base_room_info base_guard_info base_independent_info  ' .
			' base_indoor_info base_outdoor_info base_owner_info    ' .
			' base_user_info base_wall_info booking_res_info booking_act_info configuration '.
			' message_traffic_ban_city city_info device sippeers sippeers_status device_group > '
			. $filepath
			. $backup_name;//. $backup_name. ' 2>&1'  输出*/

		$cmd = '/usr/bin/mysqldump -h127.0.0.1 -u' . DATABASE_USER . ' -p' . DATABASE_PWD . ' --skip-opt --no-create-info --skip-triggers -t management ' .
			' base_building_info base_unit_info base_room_info base_guard_info base_independent_info  ' .
			' base_indoor_info base_outdoor_info base_owner_info    ' .
			' base_role_info base_permission_info base_user_info  base_wall_info '.
			' booking_res_info booking_act_info booking_act_record booking_res_record  ' .
			' message_traffic_ban_city  device   device_group > '
			. $filepath
			. $backup_name;//. $backup_name. ' 2>&1'  输出configuration

		try
		{
			exec($cmd, $output, $error);

			if ($error == 0)
			{
				echo json_encode(array("state" => 1, "ret" => "success"));
			}
			else
			{
				$filePath = $filepath . $backup_name;
				if (file_exists($filePath))
				{
					unlink($filePath);
				}
				echo json_encode(array("state" => 0, "ret" => "fail"));
			}
		} catch (Exception $exception)
		{
			echo json_encode(array("state" => 0, "ret" => $exception));
		}
	}

	private function removeBaseInfo()
	{
		$this->db->trans_begin();
		$this->db->truncate('base_building_info');
		$this->db->truncate('base_unit_info');
		$this->db->truncate('base_room_info');

		$this->db->truncate('base_guard_info');
		$this->db->truncate('base_independent_info');
		$this->db->truncate('base_indoor_info');
		$this->db->truncate('base_outdoor_info');
		$this->db->truncate('base_owner_info');

		$this->db->truncate('base_role_info');
		$this->db->truncate('base_permission_info');
		$this->db->truncate('base_user_info');
		
		$this->db->truncate('base_wall_info');
		
		$this->db->truncate('booking_res_info');
		$this->db->truncate('booking_act_info');
		$this->db->truncate('booking_act_record');
		$this->db->truncate('booking_res_record');
		
		//$this->db->truncate('configuration');
		$this->db->truncate('message_traffic_ban_city');
		//$this->db->truncate('city_info');


		$this->db->truncate('device');
		$this->db->truncate('sippeers');
		$this->db->truncate('sippeers_status');
		$this->db->truncate('device_group');
		$this->db->truncate('message_news');


		$this->db->trans_complete();
		if ($this->db->trans_status() === FALSE)
		{
			$this->db->trans_rollback();
			return FALSE;
			die;
		}
		else
		{
			$this->db->trans_commit();
			return TRUE;
			die;
		}
	}

	public function restoreDatabase()
	{
		$filename = $this->input->post("filename");
		$result = $this->removeBaseInfo();

		if ($result)
		{
			$filepath = dirname(dirname(dirname(__FILE__))) . '/files/db/' . date("YmdHis", strtotime($filename)) . '.sql';
			if (file_exists($filepath))
			{
				$cmd = 'mysql -u' . DATABASE_USER . ' -p' . DATABASE_PWD . ' management <  ' . $filepath;
			}

			exec($cmd, $output, $error);
			if ($error == 0)
			{

				echo json_encode(array("state" => 1, "ret" => "success"));
			}
			else
			{
				echo json_encode(array("state" => 0, "ret" => "fail"));
			}
		}
		else
		{
			echo json_encode(array("state" => 0, "ret" => "restore fail"));
		}
	}

	public function removeBackupByFilename()
	{
		$filename = $this->input->post("filename");
		$filePath = dirname(dirname(dirname(__FILE__))) . '/files/db/' . date("YmdHis", strtotime($filename)) . '.sql';

		if (file_exists($filePath))
		{
			unlink($filePath);
			echo json_encode(array("state" => 1, "ret" => "success"));
		}
		else
		{
			echo json_encode(array("state" => 0, "ret" => "fail"));
		}
	}

	public function getBackupList()
	{
		$rpp = $this->input->get('rpp');
		$page = $this->input->get('page');

		$rpp = empty($rpp) ? RPP : $this->input->get('rpp');
		$page = empty($page) ? 1 : $this->input->get('page');

		$dir = dirname(dirname(dirname(__FILE__))) . "/files/db/";
		$data = array();

		if (is_dir($dir))
		{
			if ($dh = opendir($dir))
			{
				while (($filename = readdir($dh)) !== FALSE)
				{
					$extension = substr(strrchr($filename, '.'), 1);
					$name = basename($filename, "." . $extension);
					if ($name != '.' and $name != '..')
					{
						$data[] = $name;
					}
				}
				closedir($dh);
			}
		}

		rsort($data);//时间降序

		$newdata = array();

		foreach ($data as $value)
		{
			$newdata[] = date("Y-m-d H:i:s", strtotime($value));
		}

		$total = count($data);
		//设置总页数
		$pagesize = ceil($total / $rpp);
		//设置偏移量 从第几页开始
		$start = ($page - 1) * $rpp;
		$result = array_slice($newdata, $start, $rpp, TRUE);
		echo json_encode(array("state" => 1, "ret" => $result, "total" => $total));
	}

	//获取主从服务器地址服务
	function getServerAddress()
	{
		echo json_encode(array("master" => MASTER, "slaver" => SLAVER));
		die;
	}

	//调用执行抓取新闻服务
	function crawlNews()
	{
		try
		{
			exec("python " . dirname(dirname(dirname(__FILE__))) . "/lib/python/crawlNews.py 2>&1", $log, $status);

			echo json_encode(array("state" => 1, "ret" => "success"));
		} catch (Exception $exception)
		{
			echo json_encode(array("state" => 0, "ret" => $exception));
		}
	}

	//调用执行抓取新闻服务
	function crawlWeather()
	{
		try
		{
			exec("python " . dirname(dirname(dirname(__FILE__))) . "/lib/python/crawlWeather.py  2>&1", $log, $status);

			echo json_encode(array("state" => 1, "ret" => "success"));
		} catch (Exception $exception)
		{
			echo json_encode(array("state" => 0, "ret" => $exception));
		}
	}

	//检测系统进程服务
	function listVideoProcess()
	{
		$check_ps_flag=array();
		exec("ps -aux", $output, $error);
		foreach ($output as $key => $value)
		{
			if (strstr($value, "ffmpeg"))
			{
				$check_ps_flag[] = 1;
			}
		}
		if(!in_array(1,$check_ps_flag)){
			$this->db->truncate('notice_encode_transfer');
		}

		foreach ($this->db->get("notice_encode_transfer")->result() as $key=>$value){
			$res[$key]['user'] = "www-data";
			$res[$key]['pid'] = $value->pid;

			//preg_match_all("/post_(.*)_(.*)/iUs",,$temps);
			$res[$key]['name'] =current(explode("_",$value->file_name));
			$res[$key]['datetime'] = strtotime(end(explode("_",$value->file_name)));

		}

		if ( ! empty($res))
		{
			echo json_encode(array("state" => 1, "ret" => $res));
			die;
		}
		else
		{
			echo json_encode(array("state" => 0, "ret" => ""));
			die;
		}
	}



}

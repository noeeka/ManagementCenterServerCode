<?php

//SIP信息model
class Sip_model extends CI_Model {
	public function __construct()
	{
		parent::__construct();
	}

	public function getMaxSipNo($building, $unit, $room, $deviceType)
	{

		switch ($deviceType)
		{

			case "guard":
				$sql = "SELECT ifnull(max(SUBSTR(sipNo,12,2)),'00') xh FROM View_GetALLDeviceList 
						  WHERE deviceTypeNo='07' AND building='" . $building . "' AND unit='" . $unit . "'";
				break;
			case "outdoor":
				$sql = "SELECT ifnull(max(SUBSTR(sipNo,12,2)),'00') xh FROM View_GetALLDeviceList 
						  WHERE deviceTypeNo='02' AND building='" . $building . "' AND unit='" . $unit . "'";
				break;
			case "indoor":
				$sql = "SELECT ifnull(max(SUBSTR(sipNo,12,2)),'00') xh FROM View_GetALLDeviceList 
						  WHERE deviceTypeNo='01' AND building='" . $building . "' AND unit='" . $unit . "' AND room='" . $room . "'";
				break;
			case "wall":
				$sql = "SELECT ifnull(max(SUBSTR(device_id,10,2)),'00') xh FROM base_wall_info";
				break;
			case "mcUser":
				$sql = "SELECT ifnull(max(SUBSTR(sipNo,10,2)),'00') xh FROM base_user_info";
				break;
			case "device_group":
				$sql = "SELECT ifnull(max(SUBSTR(name,10,2)),'00') xh FROM device_group";
				break;
		}
		$row = $this->db->query($sql)->row();
		return $row->xh == "" ? "00" : $row->xh;
	}
	/**
	 * 事务：添加管理中心客户端信息和sipserver 账号
	 */
	/*public function addMcClientAndSip($mac)
	{
		$maxSipNo	= $this->getMaxSipNo("","","","","","","mcClient")+1;

		$maxSipNo	= strlen($maxSipNo)==1?"0".$maxSipNo:$maxSipNo;
		$deviceID	= "000000000".$maxSipNo."00";

		$client_data = array(
			'deviceID'		=> $deviceID,
			'mac'			=> $mac
			);
		$device_data=array(
			'name'		=> $deviceID,
			'password'	=> $deviceID
			);

		$this->db->trans_begin();
		$result				= $this->db->insert('base_client_info',$client_data);
		$result_device		= $this->db->insert('device',$device_data);

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
	}*/
	/**
	 * 事务：终端请求分配SIP账号
	 */
	public function addIndoorAndSip($building, $unit, $room, $deviceType, $deviceIp, $mac, $remark)
	{
		$this->load->model('BasicInfo_model');
		$building_id = $this->BasicInfo_model->getBuildIdByBuilding($building);
		$unit_id = $this->BasicInfo_model->getUnitIdByUnit($building_id,$unit);
		$room_id = $this->BasicInfo_model->getRoomIdByRoom($building_id,$unit_id,$room);

		$maxSipNo = $this->getMaxSipNo($building, $unit, $room, "indoor") + 1;
		$maxSipNo = strlen($maxSipNo) == 1 ? "0" . $maxSipNo : $maxSipNo;
		$device_id = "01" . $building . $unit . $room . $maxSipNo;
		if ($deviceIp == "")
		{
			$deviceIp = $_SERVER['REMOTE_ADDR'];
		}
		$data = array(
			'building_id' => $building_id,
			'unit_id' => $unit_id,
			'room_id' => $room_id,
			'device_id' => $device_id,
			'device_ip' => $deviceIp,
			'device_Type' => $deviceType,
			'remark' => $remark,
			'mac' => $mac
		);
		$device_data = array(
			'name' => $device_id,
			'password' => $device_id
		);
		$this->db->trans_begin();
		$this->db->insert('base_indoor_info', $data);
		$this->db->insert('device', $device_data);
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

	//在线监测添加室内机携带编号
	public function addIndoorAndSipByNO($building, $unit, $room, $deviceType, $deviceIp, $mac, $remark,$maxSipNo,$deviceTypeName="")
	{
		$this->load->model('BasicInfo_model');
		$building_id = $this->BasicInfo_model->getBuildIdByBuilding($building);
		$unit_id = $this->BasicInfo_model->getUnitIdByUnit($building_id,$unit);
		$room_id = $this->BasicInfo_model->getRoomIdByRoom($building_id,$unit_id,$room);
		$device_id = "01" . $building . $unit . $room . $maxSipNo;
		if ($deviceIp == "")
		{
			$deviceIp = $_SERVER['REMOTE_ADDR'];
		}
		$data = array(
			'building_id' => $building_id,
			'unit_id' => $unit_id,
			'room_id' => $room_id,
			'device_id' => $device_id,
			'device_ip' => $deviceIp,
			'device_Type' => $deviceTypeName,
			'remark' => $remark,
			'mac' => $mac
		);
		$device_data = array(
			'name' => $device_id,
			'password' => $device_id
		);
		$this->db->trans_begin();
		$this->db->insert('base_indoor_info', $data);
		$this->db->insert('device', $device_data);
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

	/**
	 * 事务：通过UI添加室内机信息和sipserver 账号
	 */
	public function addIndoorAndSipByUI($building_id, $unit_id, $room_id,
										$building, $unit, $room, $device_type, $device_ip, $remark)
	{

		$maxSipNo = $this->getMaxSipNo($building, $unit, $room, "indoor") + 1;
		$maxSipNo = strlen($maxSipNo) == 1 ? "0" . $maxSipNo : $maxSipNo;
		$device_id = "01" . $building . $unit . $room . $maxSipNo;

		$data = array(
			'building_id' => $building_id,
			'unit_id' => $unit_id,
			'room_id' => $room_id,
			'device_id' => $device_id,
			'device_ip' => $device_ip,
			'device_type' => $device_type,
			'remark' => $remark
		);
		$device_data = array(
			'name' => $device_id,
			'password' => $device_id
		);
		$this->db->trans_begin();
		$this->db->insert('base_indoor_info', $data);
		$this->db->insert('device', $device_data);
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

	public function addGuardAndOutdoorSip($deviceTypeFlag, $building_id, $unit_id, $building, $unit, $no, $device_type, $device_ip, $remark, $mac)
	{
		/*$maxSipNo	= $this->getMaxSipNo($building_id, $unit_id,"",$building,$unit,"","guard")+1;
		$maxSipNo	= strlen($maxSipNo)==1?"0".$maxSipNo:$maxSipNo;*/
		$no = placeholderLocation($no, "room");
		switch ($deviceTypeFlag)
		{
			case "02";
				$tableName = "base_outdoor_info";
				$device_id = "02" . $building . $unit . $no . "00";
				$data = array(
					'building_id'	=> $building_id,
					'unit_id'		=> $unit_id,
					'outdoor_no'	=> $no,
					'device_type'	=> $device_type,
					'device_id'		=> $device_id,
					'device_ip'		=> $device_ip,
					'remark'		=> $remark,
					'mac'			=> $mac
				);
				
				break;
			case "07";
				$tableName = "base_guard_info";
				$device_id = "07" . $building . $unit . $no . "00";
				$data = array(
					'building_id'	=> $building_id,
					'unit_id'		=> $unit_id,
					'guard_no'		=> $no,
					'device_type'	=> $device_type,
					'device_id'		=> $device_id,
					'device_ip'		=> $device_ip,
					'remark'		=> $remark,
					'mac'			=> $mac
				);
				break;
		}

		$isExsit	=	$this->isExsitDeviceIdByDeviceType($device_id,$deviceTypeFlag);
		
		if($isExsit)
		{
			$new_data = array(
				'device_ip'		=> $device_ip,
				'mac'			=> $mac
				);
			$this->db->where('device_id', $device_id);
			$result = $this->db->update($tableName, $new_data);
			return $result;
		}
		else
		{
			$device_data = array(
				'name'		=> $device_id,
				'password'	=> $device_id
				);
			
			$this->db->trans_begin();
			$result = $this->db->insert($tableName, $data);
			$result_device = $this->db->insert('device', $device_data);

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
		
	}

	public function updateIndoorAndSipByMac($building_id, $unit_id, $room_id, $oldSipNo, $newSipNo, $mac)
	{
		$indoor_data = array(
			'building_id' => $building_id,
			'unit_id' => $unit_id,
			'room_id' => $room_id,
			'device_id' => $newSipNo
		);
		$device_data = array(
			'name' => $newSipNo,
			'password' => $newSipNo
		);

		$this->db->trans_begin();

		$this->db->where('mac', $mac);
		$result = $this->db->update('base_indoor_info', $indoor_data);

		$this->db->where('name', $oldSipNo);
		$result_device = $this->db->update('device', $device_data);
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

	public function addWallAndSip($wall_no, $device_type, $device_ip, $remark, $mac)
	{
		/*$maxSipNo	= $this->getMaxSipNo("","","","","","","wall")+1;
		$maxSipNo	= strlen($maxSipNo)==1?"0".$maxSipNo:$maxSipNo;*/
		$wall_no = placeholderLocation($wall_no, "room");
		$device_id = "0300000" . $wall_no . "00";
		$data = array(
			'device_type'	=> $device_type,
			'wall_no'		=> $wall_no,
			'device_ip'		=> $device_ip,
			'device_id'		=> $device_id,
			'remark'		=> $remark,
			'mac'			=> $mac
		);
		$device_data = array(
			'name'		=> $device_id,
			'password'	=> $device_id
		);
		$isExsit	=	$this->isExsitDeviceIdByDeviceType($device_id,"03");
		
		if($isExsit)
		{
			$new_data = array(
				'device_ip'		=> $device_ip,
				'mac'			=> $mac
				);
			$this->db->where('device_id', $device_id);
			$result = $this->db->update("base_wall_info", $new_data);
			return $result;
		}
		else
		{
			$this->db->trans_begin();
			$result = $this->db->insert("base_wall_info", $data);
			$result_device = $this->db->insert('device', $device_data);

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
	}


	//删除sip账号后对其它标的操作
	function removeSipNoByID($deviceid)
	{
		$result = $this->db->query("select * from `device_group` where `members` like '%{$deviceid}%' or `transfer` like '%{$deviceid}%'")->result();
		file_put_contents("/home/test", $deviceid, FILE_APPEND);
		if ( ! empty($result))
		{
			foreach ($result as $key => $value)
			{
				$id = $value->id;
				$members = $value->members;
				$members_set = array();
				$members_set = json_decode($members, TRUE);
				foreach ($members_set as $k => $v)
				{
					if ($v === $deviceid)
					{
						unset($members_set[$k]);
					}
				}
				if ($value->transfer == $deviceid)
				{
					$transfer = "NULL";
				}
				else
				{
					$transfer = $value->transfer;
					$transfer = "'$transfer'";
				}
				$new_members = '["' . implode('","', $members_set) . '"]';
				if ($new_members == '[""]')
				{
					$new_members = "NULL";
				}
				else
				{
					$new_members = "'$new_members'";
				}
				$sql = "update `device_group` set `members`=$new_members,`transfer`=$transfer where id=" . $id;
				file_put_contents("/home/test", $sql . "\r\n", FILE_APPEND);
				$this->db->query($sql);

			}
		}
		$res = $this->db->query("select * from `device` where `transfer` like '%{$deviceid}%'")->result();
		foreach ($res as $key => $value)
		{
			if ($value->transfer == $deviceid)
			{
				$id = $value->id;
				$this->db->query("update `device` set `transfer`='' where id=" . $id);
			}
		}
		return json_encode($this->db->get("device_group"));
	}
	
	public function getSipGroupDeviceIdByID($sipGroupID)
	{
		$sql = "SELECT name device_id FROM device_group where id=" . $sipGroupID;
		$row = $this->db->query($sql)->row();
		return $row->device_id;
	}
	private function isExsitDeviceIdByDeviceType($deviceID,$deviceType)
	{
		switch($deviceType)
		{
			case "02":$sql = "SELECT count(1) ct FROM base_guard_info		where device_id='". $deviceID."'";break;
			case "07":$sql = "SELECT count(1) ct FROM base_outdoor_info		where device_id='". $deviceID."'";break;
			case "03":$sql = "SELECT count(1) ct FROM base_wall_info		where device_id='". $deviceID."'";break;
		}
		
		$row = $this->db->query($sql)->row();
		if($row->ct==0)
		{
			return FALSE;
		}
		else
		{
			return TRUE;
		}
	}
}
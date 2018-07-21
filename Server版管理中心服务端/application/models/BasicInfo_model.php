<?php

//基础信息model
class BasicInfo_model extends CI_Model {
	public function __construct()
	{
		parent::__construct();
	}

	public function getDeviceIdByID($type, $id)
	{
		switch ($type)
		{
			case "building":
				$sql = "
						SELECT device_id from base_indoor_info   where building_id=" . $id . "
						UNION 
						SELECT device_id from base_outdoor_info  where building_id=" . $id . "
						UNION 
						SELECT device_id from base_guard_info where building_id=" . $id . "
						";
				break;
			case "unit":
				$sql=" SELECT device_id from base_indoor_info  where unit_id=" . $id . "
						UNION 
						SELECT device_id from base_outdoor_info  where unit_id=" . $id . "
						UNION 
						SELECT device_id from base_guard_info where unit_id=" . $id . "";
				break;
			case "room":
				$sql = "SELECT device_id FROM base_indoor_info where room_id=" . $id . " ";
				break;
		}
		$result = $this->db->query($sql)->result();
		return $result;
	}

	public function getBuildIdByBuilding($building)
	{
		$sql = "SELECT building_id FROM base_building_info where building='" . $building . "' ";
		$row = $this->db->query($sql)->row();
		return $row->building_id;
	}

	public function getUnitIdByUnit($building_id,$unit)
	{
		$sql = "SELECT unit_id FROM base_unit_info where building_id=" . $building_id . " and unit='" . $unit . "' ";
		$row = $this->db->query($sql)->row();
		return $row->unit_id;
	}

	public function getRoomIdByRoom($building_id,$unit_id,$room)
	{
		$sql = "SELECT room_id FROM base_room_info where building_id=" . $building_id . " and unit_id=" . $unit_id . " and room='" . $room . "' ";
		$row = $this->db->query($sql)->row();
		return $row->room_id;
	}

	public function getIndoorDeviceIdByID($indoor_id)
	{
		$sql = "SELECT device_id FROM base_indoor_info where indoor_id=" . $indoor_id;
		$row = $this->db->query($sql)->row();
		return $row->device_id;
	}

	public function getOutdoorDeviceIdByID($outdoor_id)
	{
		$sql = "SELECT device_id FROM base_outdoor_info where outdoor_id=" . $outdoor_id;
		$row = $this->db->query($sql)->row();
		return $row->device_id;
	}

	public function getGuardDeviceIdByID($guard_id)
	{
		$sql = "SELECT device_id FROM base_guard_info where guard_id=" . $guard_id;
		$row = $this->db->query($sql)->row();
		return $row->device_id;
	}

	//获取门卫机和管理中心用户sip账号和用户
	public function getSipNoListByDeviceType($type)
	{
		switch ($type)
		{
			case "07":
				$sql = "SELECT building,unit,deviceNo,sipNo,deviceTypeNo from View_GetALLDeviceList where deviceTypeNo='07'";
				$result = $this->db->query($sql)->result();
				return $result;
				break;

			case "00":
				$sql = "SELECT username,'intercom,test2' permission,sipNo,'00' deviceTypeNo from base_user_info
					where username='admin' 
					UNION 
					SELECT username,ifnull(permission,'') permission,sipNo,'00' deviceTypeNo 
					from base_user_info A inner JOIN base_permission_info B ON A.roleID=B.roleID
					WHERE A.privilege<>1";
				$result = $this->db->query($sql)->result();
				$newResult = array();
				foreach($result as $k => $v)
				{
					$arrayPermission = explode(",",$v->permission);
					$isExsit = in_array("intercom",$arrayPermission);
					if(strtoupper($v->username)==SUPER || $isExsit)
					{
						$newResult[$k]['username']			= $v->username;
						$newResult[$k]['sipNo']			= $v->sipNo;
						$newResult[$k]['deviceTypeNo']		= $v->deviceTypeNo;
					}
				}
				return $newResult;
				break;

			case "99":
				$sql = "SELECT remark username,name sipNo,'99' deviceTypeNo from device_group where name not in ('9901000000000','9902000000000','9907000000000')";
				$result = $this->db->query($sql)->result();
				return $result;
				break;

			case "guardAndMcUser":
				$sql = "SELECT building,unit,deviceNo,'' username,sipNo,'intercom,test2' permission from View_GetALLDeviceList 
						where deviceTypeNo='07'
						union
						SELECT '','','',username,sipNo,B.permission from base_user_info A
						LEFT JOIN base_permission_info B on A.roleID=B.roleID 
						where A.privilege<>1";
				$result = $this->db->query($sql)->result();
				$newResult = array();
				foreach($result as $k => $v)
				{
					
					$arrayPermission = explode(",",$v->permission);
					$isExsit = in_array("intercom",$arrayPermission);
					if(strtoupper($v->username)==SUPER || strtoupper($v->username)==ADMIN || $isExsit)
					{
						$newResult[$k]['building']			= $v->building;
						$newResult[$k]['unit']				= $v->unit;
						$newResult[$k]['deviceNo']			= $v->deviceNo;
						$newResult[$k]['username']			= $v->username;
						$newResult[$k]['sipNo']			= $v->sipNo;
						
					}
					
				}
				return $newResult;
				break;
		}

		

		
	}


	public function getUserDeviceIdByID($user_id)
	{
		$sql = "SELECT sipNo device_id FROM base_user_info where user_id=" . $user_id;
		$row = $this->db->query($sql)->row();
		return $row->device_id;
	}

	public function isExsitDeviceIp($Ip)
	{
		$sql = "SELECT count(1) ct FROM View_GetALLDeviceList where device_ip='" . $Ip . "'";
		$row = $this->db->query($sql)->row();
		if ($row->ct == 0)
			return FALSE;
		else
			return TRUE;
	}

	public function getIndoorDeviceIpByID($indoor_id)
	{
		$sql = "SELECT device_ip FROM base_indoor_info where indoor_id=" . $indoor_id;
		$row = $this->db->query($sql)->row();
		return $row->device_ip;
	}

	public function getOutdoorDeviceIpByID($outdoor_id)
	{
		$sql = "SELECT device_ip FROM base_outdoor_info where outdoor_id=" . $outdoor_id;
		$row = $this->db->query($sql)->row();
		return $row->device_ip;
	}

	public function getGuardDeviceIpByID($guard_id)
	{
		$sql = "SELECT device_ip FROM base_guard_info where guard_id=" . $guard_id;
		$row = $this->db->query($sql)->row();
		return $row->device_ip;
	}

	public function getWallDeviceIpByID($wall_id)
	{
		$sql = "SELECT device_ip FROM base_wall_info where wall_id=" . $wall_id;
		$row = $this->db->query($sql)->row();
		return $row->device_ip;
	}
	public function getWallDeviceIdByID($wall_id)
	{
		$sql = "SELECT device_id FROM base_wall_info where wall_id=" . $wall_id;
		$row = $this->db->query($sql)->row();
		return $row->device_id;
	}

	/**
	 * 添加楼栋服务
	 *
	 * @param   string $building
	 * @return  int ID
	 */
	public function addBuilding($building)
	{

		//如果楼栋号不存在
		if (!$this->isExsitBuildingByID("", $building, "add"))
		{

			$building = placeholderLocation($building, "building");
			$data = array(
				'building' => $building
			);

			//"INSERT INTO `base_building_info` SET `building`='{$building}' ";
			$result = $this->db->insert('base_building_info', $data);

			if ($result)
			{
				return $this->db->query("SELECT LAST_INSERT_ID() as ls")->row()->ls;
			}
			else
			{
				return "";
			}
		}
		else
		{

			$row = $this->db->query("SELECT `building_id` FROM base_building_info WHERE `building`='" . $building . "'")->row();
			return $row->building_id;
		}
	}


	/**
	 * 添加单元服务
	 *
	 * @param   string $building , $unit
	 * @return  int ID
	 */
	public function addUnit($building, $unit)
	{
		//如果楼栋号不存在
		$building_id = $this->addBuilding($building);
		if ( ! $this->isExsitUnitByID($building_id, "", $unit, "add"))
		{
			$data = array(
				'building_id' => $building_id,
				'unit' =>  placeholderLocation($unit, "unit")
			);

			$result = $this->db->insert('base_unit_info', $data);
			if ($result)
			{
				return $this->db->query("SELECT LAST_INSERT_ID() as ls")->row()->ls;
			}
			else
			{
				return "";
			}
		}
		else
		{
			$row_build = $this->db->query("SELECT `building_id` FROM base_building_info WHERE `building`='" . $building . "'")->row();

			$row = $this->db->query("SELECT `unit_id` FROM base_unit_info WHERE `building_id`=" . $row_build->building_id . " and `unit`='" . $unit . "'")->row();
			return $row->unit_id;
		}
	}

	/**
	 * 添加房间服务
	 *
	 * @param   string $building , $unit, $room
	 * @return  int ID
	 */
	public function addRoom($building, $unit, $room)
	{
		$building_id = $this->addBuilding($building);
		$unit_id = $this->addUnit($building, $unit);
		if ( ! $this->isExsitRoomByID($building_id, $unit_id, "", $room, "add"))
		{
			$data = array(
				'building_id'	=> $building_id,
				'unit_id'		=> $unit_id,
				'room'			=> placeholderLocation($room, "room")
			);
			$result = $this->db->insert('base_room_info', $data);
			if ($result)
			{
				return $this->db->query("SELECT LAST_INSERT_ID() as ls")->row()->ls;

			}
			else
			{
				return "";
			}
		}
		else
		{
			$row_build = $this->db->query("SELECT `building_id` FROM base_building_info WHERE `building`='" . $building . "'")->row();
			$row_unit = $this->db->query("SELECT `unit_id` FROM base_unit_info WHERE `unit`='" . $unit . "' and `building_id`=" . $row_build->building_id)->row();
			$row = $this->db->query("SELECT `room_id` FROM base_room_info WHERE `building_id`=" . $row_build->building_id . " and `unit_id`=" . $row_unit->unit_id . " and `room`='" . $room . "'")->row();

			return $row->room_id;
		}


	}


	/**
	 * 判断楼栋是否存在服务
	 *
	 * @param   string $building_id ,$building,$action
	 * @return  Boolean
	 */
	public function isExsitBuildingByID($building_id, $building, $action)
	{
		$building = placeholderLocation($building, "building");
		if ($action == "add")
		{
			$row = $this->db->query("SELECT  count(1) ct FROM base_building_info where building='" . $building . "'")->row();
			if ($row->ct == 0)
			{
				return FALSE;
			}
			return TRUE;
		}
		else
		{
			$this->db->escape();
			$row = $this->db->query("SELECT count(building) ct FROM base_building_info 
									 WHERE building_id <> " . $building_id . " AND building='" . $building . "'")->row();

			if ($row->ct == 0)
			{
				return FALSE;
			}
			return TRUE;
		}

	}

	/**
	 * 判断单元是否存在服务
	 *
	 * @param   string $building_id ,$unit_id,$unit,$action
	 * @return  Boolean
	 */
	public function isExsitUnitByID($building_id, $unit_id, $unit, $action)
	{
		$unit = placeholderLocation($unit, "unit");
		$this->db->escape();
		if ($action == "add")
		{
			$row = $this->db->query("SELECT  count(1) ct FROM base_unit_info where building_id =" . $building_id . " and unit='" . $unit . "'")->row();
			if ($row->ct == 0)
			{
				return FALSE;
			}
			else
			{
				return TRUE;
			}
		}
		else
		{

			$row = $this->db->query("SELECT count(unit) ct  FROM base_unit_info 
									  WHERE building_id=" . $building_id . " AND unit_id!=" . $unit_id . " AND unit='" . $unit . "'")->row();

			if ($row->ct == 0)
			{
				return FALSE;
			}
			else
			{
				return TRUE;
			}
		}

	}


	/**
	 * 判断房间是否存在服务
	 *
	 * @param   string $building_id ,$unit_id,$room_id,$room,$action
	 * @return  Boolean
	 */
	public function isExsitRoomByID($building_id, $unit_id, $room_id, $room, $action)
	{
		$room = placeholderLocation($room, "room");
		if ($action == "add")
		{
			$row = $this->db->query("SELECT  count(1) ct FROM base_room_info where 
			building_id =" . $building_id . " and unit_id=" . $unit_id . " and room='" . $room . "'")->row();
			if ($row->ct == 0)
			{
				return FALSE;
			}
			return TRUE;
		}
		else
		{

			$this->db->escape();
			$row = $this->db->query("SELECT count(room) ct  FROM base_room_info 
				WHERE building_id=" . $building_id . " AND unit_id=" . $unit_id . " AND room_id !=" . $room_id . " AND room='" . $room . "'")->row();
			if ($row->ct == 0)
			{
				return FALSE;
			}
			return TRUE;
		}

	}
	public function addDeviceModel($deviceType,$deviceTypeName)
	{
		$IsExsit = $this->isExsitDeviceModelByName($deviceType,$deviceTypeName);
		if (!$IsExsit)
		{
			$data = array(
				'device_type'		=> $deviceType,
				'device_type_name'	=> $deviceTypeName
				);

			$this->db->insert('base_device_type', $data);
		}
	}
	private function isExsitDeviceModelByName($deviceType,$deviceTypeName)
	{
		$sql="SELECT  count(1) ct FROM base_device_type where device_type='".$deviceType."' AND device_type_name='" . $deviceTypeName . "'";
		$row = $this->db->query($sql)->row();
		if ($row->ct == 0)
		{
			return FALSE;
		}
		return TRUE;
	}
}

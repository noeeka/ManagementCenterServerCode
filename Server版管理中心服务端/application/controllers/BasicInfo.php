<?php
/**
 * Created by PhpStorm.
 * User: James
 * Date: 2017/11/11
 * Time: 14:52
 */

class BasicInfo extends CI_Controller {
	public function __construct()
	{
		parent::__construct();
		//getToken();
	}

	//这里权限有遗留，稍后补上------------------------------------------------------
	public function getManagementClients()
	{
		$username = $this->input->post('username');
		$this->db->escape();
		$sql = "SELECT username,sipNo from base_user_info where username<>'" . $username . "'";
		$result = $this->db->query($sql)->result();
		echo json_encode(array("state" => 1, "ret" => $result));
	}

	//获取门卫机和管理中心用户sip账号和用户
	public function getGuardAndUserSipList()
	{
		$this->load->model('BasicInfo_model');
		$result = $this->BasicInfo_model->getSipNoListByDeviceType("guardAndMcUser");
		echo json_encode(array("state" => 1, "ret" => $result));
	}

	public function getSipNoListByDeviceType()
	{
		$deviceType = $this->input->post('deviceType');
		$this->load->model('BasicInfo_model');
		$result = $this->BasicInfo_model->getSipNoListByDeviceType($deviceType);

		echo json_encode(array("state" => 1, "ret" => $result));
	}

	//编辑单元
	public function editClient()
	{
		$clientID = $this->input->post('clientID');
		$clientName = $this->input->post("clientName");
		$IsExsit = $this->isExsitClientName($clientID, $clientName, "edit");
		if ($IsExsit)
		{
			echo json_encode(array("state" => 2, "ret" => "exsit"));
			die;
		}
		$data = array(
			'clientName' => $clientName
		);
		$this->db->where('clientID', $clientID);
		$result = $this->db->update('base_client_info', $data);
		if ($result)
		{
			echo json_encode(array("state" => 1, "ret" => "success"));
		}
	}

	public function deleteClient()
	{
		$clientID = $this->input->post('clientID');
		$this->db->delete('base_client_info', array('clientID' => $clientID));
		echo json_encode(array("state" => 1, "ret" => "success"));
	}

	public function isExsitClientName($clientID, $clientName, $action)
	{
		$this->db->escape();
		if ($action == "add")
		{
			$row = $this->db->query("SELECT  count(1) ct FROM base_client_info where clientName='" . $clientName . "'")->row();
			if ($row->ct == 0)
			{
				return FALSE;
			}
			return TRUE;
		}
		else
		{
			$row = $this->db->query("SELECT count(1) ct FROM base_client_info 
									 WHERE clientID <> ' . $clientID . ' AND clientName='" . $clientName . "'")->row();
			if ($row->ct == 0)
			{
				return FALSE;
			}
			return TRUE;
		}
	}

	public function getMap()
	{
		$row = $this->db->query('SELECT  map FROM configuration')->row();
		$res = $row->map;
		$result = array("map" => $res);
		echo json_encode($result);
	}

	public function setMap()
	{
		$map_path = $this->input->post("map");
		$data = array(
			'map' => $map_path
		);
		$result = $this->db->update('configuration', $data);
		if ($result)
		{
			echo json_encode(array("state" => 1, "ret" => "success"));
		}
	}

	//获取楼栋列表
	public function getBuildings()
	{
		$rpp = $this->input->get('rpp');
		$page = $this->input->get('page');
		$rpp = empty($rpp) ? RPP : $this->input->get('rpp');
		$page = empty($page) ? 1 : $this->input->get('page');
		$this->db->order_by('building', 'ASC');
		$this->db->limit($rpp, ($page - 1) * $rpp);
		$result = $this->db->get('base_building_info')->result();
		echo json_encode(array("state" => 1, "ret" => $result, "total" => $this->db->count_all_results('base_building_info')));
	}

	//添加楼栋号
	public function addBuilding()
	{
		$building = $this->input->post("building");
		//$remark		= $this->input->post("remark");
		//$action		= $this->input->get("action");	
		$building = placeholderLocation($building, "building");

		$this->load->model('BasicInfo_model');
		$IsExsit = $this->BasicInfo_model->isExsitBuildingByID("", $building, "add");

		if ($IsExsit)
		{
			echo json_encode(array("state" => 2, "ret" => "exsit"));
			die;
		}
		$data = array(
			'building' => $building

		);

		$result = $this->db->insert('base_building_info', $data);
		if ($result)
		{
			echo json_encode(array("state" => 1, "ret" => "success"));
		}
	}

	//编辑楼栋信息
	public function editBuilding()
	{
		$building_id = $this->input->post('building_id');
		$building = $this->input->post('building');
		$remark = $this->input->post("remark");
		//$action			= $this->input->get("action");
		$building = placeholderLocation($building, "building");
		//判断楼栋名称是否存在
		$this->load->model('BasicInfo_model');
		$IsExsit = $this->BasicInfo_model->isExsitBuildingByID($building_id, $building, "edit");

		if ($IsExsit)
		{
			echo json_encode(array("state" => 2, "ret" => "exsit"));
			die;
		}

		$data = array(
			'building' => $building,
			'remark' => $remark
		);

		$this->db->where('building_id', $building_id);
		$result = $this->db->update('base_building_info', $data);
		if ($result)
		{
			echo json_encode(array("state" => 1, "ret" => "success"));
		}
	}

	//删除楼栋、单元、房间号信息
	public function removeBuilding()
	{
		$building_id = $this->input->post('building_id');

		$this->load->model('BasicInfo_model');
		$this->load->model('Sip_model');
		$result = $this->BasicInfo_model->getDeviceIdByID("building", $building_id);

		$this->db->trans_begin();

		$this->db->delete('base_building_info', array('building_id' => $building_id));
		$this->db->delete('base_unit_info', array('building_id' => $building_id));
		$this->db->delete('base_room_info', array('building_id' => $building_id));
		$this->db->delete('base_indoor_info', array('building_id' => $building_id));
		$this->db->delete('base_outdoor_info', array('building_id' => $building_id));
		$this->db->delete('base_guard_info', array('building_id' => $building_id));
		$this->db->delete('base_owner_info', array('building_id' => $building_id));
		foreach ($result as $k => $v)
		{
			$this->db->delete('device', array('name' => $v->device_id));
			
			$this->Sip_model->removeSipNoByID($v->device_id);
		}

		if ($this->db->trans_status() === FALSE)
		{
			$this->db->trans_rollback();
			echo json_encode(array("state" => 0, "ret" => "database error"));
			die;
		}
		else
		{
			$this->db->trans_commit();
			echo json_encode(array("state" => 1, "ret" => "success"));
			die;
		}

	}

	public function updateBuildingXY()
	{
		$building_id = $this->input->post('building_id');
		$x = $this->input->post('x');
		$y = $this->input->post('y');
		$data = array(
			'x' => $x,
			'y' => $y
		);
		$this->db->where('building_id', $building_id);
		$result = $this->db->update('base_building_info', $data);
		if ($result)
		{
			echo json_encode(array("state" => 1, "ret" => "success"));
		}

	}

	public function clareAllBuildingXY()
	{
		$data = array(
			'x' => "",
			'y' => ""
		);
		$result = $this->db->update('base_building_info', $data);
		if ($result)
		{
			echo json_encode(array("state" => 1, "ret" => "success"));
		}
	}


	//获取单元列表
	public function getUnits()
	{
		$building_id = $this->input->post("building_id");
		$rpp = $this->input->get('rpp');
		$page = $this->input->get('page');
		$rpp = empty($rpp) ? RPP : $this->input->get('rpp');
		$page = empty($page) ? 1 : $this->input->get('page');

		
		$all_result = $this->db->get_where('base_unit_info', array("building_id" => $building_id))->result();
		$this->db->limit($rpp, ($page - 1) * $rpp);
		if ( ! empty($building_id))
		{
			$this->db->order_by('unit', 'ASC');
			$result = $this->db->get_where('base_unit_info', array("building_id" => $building_id))->result();
		}
		else
		{
			$this->db->order_by('unit', 'ASC');
			$result = $this->db->get('base_unit_info')->result();
		}
		
		$total = count($all_result);
		$res = array();
		foreach ($result as $k => $v)
		{

			$res[$k]['unit_id']= $v->unit_id;
			$res[$k]['unit']	= $v->unit;
			$res[$k]['remark'] = $v->remark;
		}
		echo json_encode(array("state" => 1, "ret" => $res, "total" => $total));

	}

	//添加单元信息
	public function addUnit()
	{
		$building_id = $this->input->post("building_id");
		$unit = $this->input->post("unit");
		$remark = $this->input->post("remark");
		//$action			= $this->input->get("action");
		$unit = placeholderLocation($unit, "unit");
		$this->load->model('BasicInfo_model');
		$IsExsit = $this->BasicInfo_model->isExsitUnitByID($building_id, "", $unit, "add");
		if ($IsExsit)
		{
			echo json_encode(array("state" => 2, "ret" => "exsit"));
			die;
		}
		$data = array(
			'building_id' => $building_id,
			'unit' => $unit,
			'remark' => $remark
		);

		$result = $this->db->insert('base_unit_info', $data);
		if ($result)
		{
			echo json_encode(array("state" => 1, "ret" => "success"));
		}
	}

	//编辑单元
	public function editUnit()
	{
		$unit_id = $this->input->post('unit_id');
		$building_id = $this->input->post('building_id');
		$unit = $this->input->post('unit');
		$remark = $this->input->post("remark");
		//$action			= $this->input->get("action");
		$unit = placeholderLocation($unit, "unit");
		$this->load->model('BasicInfo_model');
		$IsExsit = $this->BasicInfo_model->isExsitUnitByID($building_id, $unit_id, $unit, "edit");
		if ($IsExsit)
		{
			echo json_encode(array("state" => 2, "ret" => "exsit"));
			die;
		}
		$data = array(
			'building_id' => $building_id,
			'unit' => $unit,
			'remark' => $remark
		);
		$this->db->where('unit_id', $unit_id);
		$result = $this->db->update('base_unit_info', $data);
		if ($result)
		{
			echo json_encode(array("state" => 1, "ret" => "success"));
		}
	}

	//删除单元
	public function removeUnit()
	{
		$unit_id = $this->input->post('unit_id');
		$this->load->model('BasicInfo_model');
		$this->load->model('Sip_model');
		$result = $this->BasicInfo_model->getDeviceIdByID("unit", $unit_id);

		$this->db->trans_begin();
		$this->db->delete('base_room_info', array('unit_id' => $unit_id));
		$this->db->delete('base_unit_info', array('unit_id' => $unit_id));
		$this->db->delete('base_indoor_info', array('unit_id' => $unit_id));
		$this->db->delete('base_outdoor_info', array('unit_id' => $unit_id));
		$this->db->delete('base_guard_info', array('unit_id' => $unit_id));
		$this->db->delete('base_owner_info', array('unit_id' => $unit_id));
		
		foreach ($result as $k => $v)
		{
			$this->db->delete('device', array('name' => $v->device_id));
			
			$this->Sip_model->removeSipNoByID($v->device_id);

		}

		if ($this->db->trans_status() === FALSE)
		{
			$this->db->trans_rollback();
			echo json_encode(array("state" => 0, "ret" => "database error"));
			die;
		}
		else
		{
			$this->db->trans_commit();
			echo json_encode(array("state" => 1, "ret" => "success"));
			die;
		}
	}

	//根据楼栋获取单元
	public function getUnitsByBuilding()
	{
		$building_id = $this->input->post("building_id");
		$this->db->order_by('unit', 'ASC');
		$result = $this->db->get_where('base_unit_info', array("building_id" => $building_id))->result();
		echo json_encode(array("state" => 1, "ret" => $result));
	}

	public function getRoomsByUnitAndBuilding()
	{
		$building_id = $this->input->post("building_id");
		$unit_id = $this->input->post("unit_id");
		$room_id = $this->input->post("room_id");
		$rpp = $this->input->get('rpp');
		$page = $this->input->get('page');
		$rpp = empty($rpp) ? RPP : $this->input->get('rpp');
		$page = empty($page) ? 1 : $this->input->get('page');

		if ($building_id != '0')
		{
			$sql_condition .=" AND A.building_id=".$building_id;
		}
		if ($unit_id != '0')
		{
			$sql_condition .=" AND A.unit_id=".$unit_id;
		}
		if ($room_id != '0')
		{
			$sql_condition .=" AND A.room_id=".$room_id;
		}
		$sql_condition .= " ORDER BY B.building,C.unit,A.room ";
		$fromIndex = ($page-1)*$rpp;
		$sql_condition .=" limit ".$fromIndex.",".$rpp;
	
		$sql="SELECT A.*,B.building,C.unit from base_room_info A LEFT JOIN

				base_building_info B ON A.building_id=B.building_id LEFT JOIN

				base_unit_info C ON A.unit_id=C.unit_id WHERE 1=1 ";
				
		
		
		$result = $this->db->query($sql.$sql_condition)->result();
		$total	 = count($this->db->query($sql)->result());
		echo json_encode(array("state" => 1, "ret" => $result, "total" => $total));
	}

	//添加房间
	public function addRoom()
	{
		$building_id = $this->input->post("building_id");
		$unit_id = $this->input->post("unit_id");
		$room = $this->input->post("room");
		$remark = $this->input->post("remark");
		$room = placeholderLocation($room, "room");
		$this->load->model('BasicInfo_model');
		$IsExsit = $this->BasicInfo_model->isExsitRoomByID($building_id, $unit_id, "", $room, "add");
		if ($IsExsit)
		{
			echo json_encode(array("state" => 2, "ret" => "exsit"));
			die;
		}
		$data = array(
			'building_id' => $building_id,
			'unit_id' => $unit_id,
			'room' => $room,
			'remark' => $remark
		);
		$result = $this->db->insert('base_room_info', $data);
		if ($result)
		{
			echo json_encode(array("state" => 1, "ret" => "success"));
		}
	}


	public function getRooms()
	{
		$filter_building = $this->input->post("building_id");
		$filter_unit = $this->input->post("unit_id");
		$rpp = $this->input->get('rpp');
		$page = $this->input->get('page');
		$rpp = empty($rpp) ? RPP : $this->input->get('rpp');
		$page = empty($page) ? 1 : $this->input->get('page');
		
		$all_result = $this->db->get_where('base_room_info', array("building_id" => $filter_building, "unit_id" => $filter_unit))->result();
		$this->db->limit($rpp, ($page - 1) * $rpp);
		if (empty($filter_building) && empty($filter_unit))
		{
			
			$result = $this->db->get('base_room_info')->result();

		}
		else
		{
			$this->db->order_by('room', 'ASC');
			$result = $this->db->get_where('base_room_info', array("building_id" => $filter_building, "unit_id" => $filter_unit))->result();

		}
		$total = count($all_result);
		$res = array();
		foreach ($result as $k => $v)
		{

			$res[$k]['room_id'] = $v->room_id;
			$res[$k]['room'] = $v->room;
			$res[$k]['remark'] = $v->remark;
		}
		echo json_encode(array("state" => 1, "ret" => $res, "total" => $total));

	}

	//编辑房间
	public function editRoom()
	{
		$room_id = $this->input->post('room_id');
		$building_id = $this->input->post('building_id');
		$unit_id = $this->input->post('unit_id');
		$room = $this->input->post('room');
		$remark = $this->input->post("remark");
		$room = placeholderLocation($room, "room");
		$this->load->model('BasicInfo_model');
		$IsExsit = $this->BasicInfo_model->isExsitRoomByID($building_id, $unit_id, $room_id, $room, "edit");
		if ($IsExsit)
		{
			echo json_encode(array("state" => 2, "ret" => "exsit"));
			die;
		}
		$data = array(
			'building_id' => $building_id,
			'unit_id' => $unit_id,
			'room' => $room,
			'remark' => $remark
		);
		$this->db->where('room_id', $room_id);
		$result = $this->db->update('base_room_info', $data);
		if ($result)
		{
			echo json_encode(array("state" => 1, "ret" => "success"));
		}
	}

	//删除房间
	public function removeRoom()
	{
		$room_id = $this->input->post('room_id');

		$this->load->model('BasicInfo_model');
		$this->load->model('Sip_model');
		$result = $this->BasicInfo_model->getDeviceIdByID("room", $room_id);

		$this->db->trans_begin();
		$this->db->delete('base_room_info', array('room_id' => $room_id));
		$this->db->delete('base_indoor_info', array('room_id' => $room_id));
		$this->db->delete('base_owner_info', array('room_id' => $room_id));

		foreach ($result as $k => $v)
		{
			$this->db->delete('device', array('name' => $v->device_id));
			
			$this->Sip_model->removeSipNoByID($v->device_id);

		}

		if ($this->db->trans_status() === FALSE)
		{
			$this->db->trans_rollback();
			echo json_encode(array("state" => 0, "ret" => "database error"));
			die;
		}
		else
		{
			$this->db->trans_commit();
			echo json_encode(array("state" => 1, "ret" => "success"));
			die;
		}
	}

#############################室内机相关服务###############################


	//添加室内机服务
	public function addIndoor()
	{
		$building_id = $this->input->post("building_id");
		$unit_id = $this->input->post("unit_id");
		$room_id = $this->input->post("room_id");

		$building = $this->input->post("building");
		$unit = $this->input->post("unit");
		$room = $this->input->post("room");

		$device_type = $this->input->post("device_type");
		$device_ip = $this->input->post("device_ip");
		$remark = $this->input->post("remark");
		if (check_is_chinese($device_ip))
		{
			echo json_encode(array("state" => 4, "ret" => "ip error"));
			die;
		}
		$this->load->model('BasicInfo_model');
		if ($device_ip != "")
		{
			if ($this->BasicInfo_model->isExsitDeviceIp($device_ip))
			{
				echo json_encode(array("state" => 11, "ret" => "ip exsit"));
				die;
			}
		}
		$this->load->model('Sip_model');
		$isSuccessFlag = $this->Sip_model->addIndoorAndSipByUI($building_id, $unit_id, $room_id,
			$building, $unit, $room, $device_type, $device_ip, $remark);
		if ($isSuccessFlag === FALSE)
		{
			echo json_encode(array("state" => 10, "ret" => "Database Error"));

		}
		else
		{
			echo json_encode(array("state" => 1, "ret" => "Success"));

		}
	}

	//编辑室内机服务
	public function editIndoor()
	{

		$indoor_id = $this->input->post("indoor_id");
		//$indoor_no	= $this->input->post("indoor_no");
		$device_type = $this->input->post("device_type");
		$device_ip = $this->input->post("device_ip");
		$remark = $this->input->post("remark");
		//$indoor_no	= placeholderLocation($indoor_no,"unit");
		/*$IsExsit		= $this->isExsitIndoorByID($building_id,$unit_id,$room_id,$indoor_id,$indoor_no,"edit");
		if ($IsExsit) 
		{
			echo json_encode(array("state" => 2, "ret" => "exsit"));
			die;
		}*/
		if (check_is_chinese($device_ip))
		{
			echo json_encode(array("state" => 4, "ret" => "ip error"));
			die;
		}

		$this->load->model('BasicInfo_model');
		$deviceIp = $this->BasicInfo_model->getIndoorDeviceIpByID($indoor_id);

		if ($device_ip != "")
		{
			if ($deviceIp != $device_ip)
			{
				if ($this->BasicInfo_model->isExsitDeviceIp($device_ip))
				{
					echo json_encode(array("state" => 11, "ret" => "ip exsit"));
					die;
				}
			}
		}
		$data = array(
			'device_type' => $device_type,
			'device_ip' => $device_ip,
			'remark' => $remark
		);
		$this->db->where('indoor_id', $indoor_id);
		$result = $this->db->update('base_indoor_info', $data);
		if ($result)
		{
			echo json_encode(array("state" => 1, "ret" => "success"));
		}
	}
	/*private function isExsitIndoorByID($building_id,$unit_id,$room_id,$indoor_id,$indoor_no,$action)
	{
		//$indoor_no		= placeholderLocation($indoor_no,"unit");
		if($action=="add")
		{
			$row = $this->db->query("SELECT  count(1) ct FROM base_indoor_info where 
			building_id =".$building_id." and unit_id=".$unit_id." and room_id=".$room_id." ")->row();
			if ($row->ct == 0) 
			{
				return FALSE;
			} 
			return TRUE;
		}
		else
		{
			
			$this->db->escape();
			$row = $this->db->query("SELECT count(indoor_no) ct FROM base_indoor_info 
				WHERE building_id=" . $building_id ." AND unit_id=" . $unit_id ." AND indoor_id !=" . $indoor_id. " AND indoor_no='".$indoor_no."'")->row();
			if ($row->ct == 0) 
			{
				return FALSE;
			} 
			return TRUE;
		}
	}*/

	//删除室内机和DeviceID
	public function removeIndoor()
	{
		$indoor_id = $this->input->post('indoor_id');

		$this->load->model('BasicInfo_model');
		$deviceID = $this->BasicInfo_model->getIndoorDeviceIdByID($indoor_id);

		$this->db->trans_begin();

		$this->db->delete('base_indoor_info', array('indoor_id' => $indoor_id));
		$this->db->delete('device', array('name' => $deviceID));
		$this->load->model('Sip_model');
		$this->Sip_model->removeSipNoByID($deviceID);

		if ($this->db->trans_status() === FALSE)
		{
			$this->db->trans_rollback();
			echo json_encode(array("state" => 10, "ret" => "Database Error"));
			die;
		}
		else
		{
			$this->db->trans_commit();
			echo json_encode(array("state" => 1, "ret" => "Success"));
			die;
		}
	}

	public function IsExsitIndoor()
	{
		$building_id = $this->input->post("building_id");
		$unit_id = $this->input->post("unit_id");
		$room_id = $this->input->post("room_id");
		//$indoor_no		= $this->input->post("indoor_no");
		//$indoor_no		= placeholderLocation($indoor_no,"unit");
		$result = $this->db->get_where('base_indoor_info',
			array("building_id" => $building_id, "unit_id" => $unit_id, "room_id" => $room_id))->result();
		$count = count($result);
		if ($count > 0)
		{
			echo json_encode(array("state" => 1, "ret" => "success"));
		}
	}

	//获取室内机列表
	public function getIndoors()
	{

		$filter_building = $this->input->post("building_id");
		$filter_unit = $this->input->post("unit_id");
		$filter_room = $this->input->post("room_id");

		$rpp = $this->input->get('rpp');
		$page = $this->input->get('page');
		$rpp = empty($rpp) ? RPP : $this->input->get('rpp');
		$page = empty($page) ? 1 : $this->input->get('page');

		$all_result = $this->db->get_where('base_indoor_info', array("building_id" => $filter_building,
			"unit_id" => $filter_unit, "room_id" => $filter_room))->result();

		$this->db->limit($rpp, ($page - 1) * $rpp);

		$sql = "select (@i := @i + 1) as xh,a.indoor_id,
				ifnull(device_ip,'') device_ip,
				ifnull(device_type,'') device_type,
				ifnull(remark,'') remark 
			   from base_indoor_info a,(select @i := 0) b where 1=1 ";
		if (empty($filter_building) && empty($filter_unit) && empty($filter_room))
		{
			$result = $this->db->query($sql)->result();

		}
		else
		{
			$sqlCondition = " and building_id=" . $filter_building . " and unit_id=" . $filter_unit . " and room_id=" . $filter_room . " 
			order by indoor_id desc";
			$result = $this->db->query($sql . $sqlCondition)->result();
		}
		$total = count($all_result);
		$res = array();
		foreach ($result as $k => $v)
		{
			$res[$k]['xh'] = $v->xh;
			$res[$k]['indoor_id'] = $v->indoor_id;
			$res[$k]['device_type'] = $v->device_type;
			/*$res[$k]['indoor_no']	=$v->indoor_no;*/
			$res[$k]['device_ip'] = $v->device_ip;
			$res[$k]['remark'] = $v->remark;

		}
		echo json_encode(array("state" => 1, "ret" => $res, "total" => $total));
	}

	###########################门口机相关服务#############################
	private function isExsitOutdoorByID($building_id, $unit_id, $outdoor_id, $outdoor_no, $action)
	{
		$outdoor_no = placeholderLocation($outdoor_no, "room");
		if ($action == "add")
		{
			$row = $this->db->query("SELECT  count(1) ct FROM base_outdoor_info where 
			building_id =" . $building_id . " and unit_id=" . $unit_id . " and 
		    outdoor_no= '" . $outdoor_no . "'")->row();
			if ($row->ct == 0)
			{
				return FALSE;
			}
			return TRUE;
		}
		else
		{

			$this->db->escape();
			$row = $this->db->query("SELECT count(outdoor_no) ct FROM base_outdoor_info WHERE building_id=" . $building_id . " AND unit_id=" . $unit_id .
				" AND outdoor_id !=" . $outdoor_id . " AND outdoor_no='" . $outdoor_no . "'")->row();

			if ($row->ct == 0)
			{
				return FALSE;
			}
			return TRUE;
		}

	}

	//添加门口机服务
	public function addOutdoor()
	{

		$building_id = $this->input->post("building_id");
		$unit_id = $this->input->post("unit_id");
		$building = $this->input->post("building");
		$unit = $this->input->post("unit");
		$outdoor_no = $this->input->post("outdoor_no");
		$device_type = $this->input->post("device_type");
		$device_ip = $this->input->post("device_ip");
		$remark = $this->input->post("remark");
		$outdoor_no = placeholderLocation($outdoor_no, "room");

		if (check_is_chinese($device_ip))
		{
			echo json_encode(array("state" => 4, "ret" => "ip error"));
			die;
		}
		$this->load->model('BasicInfo_model');
		if ($device_ip != "")
		{
			if ($this->BasicInfo_model->isExsitDeviceIp($device_ip))
			{
				echo json_encode(array("state" => 11, "ret" => "ip exsit"));
				die;
			}
		}
		$IsExsit = $this->isExsitOutdoorByID($building_id, $unit_id, "", $outdoor_no, "add");
		if ($IsExsit)
		{
			echo json_encode(array("state" => 2, "ret" => "exsit"));
			die;
		}
		$this->load->model('Sip_model');
		$isSuccessFlag = $this->Sip_model->addGuardAndOutdoorSip("02", $building_id, $unit_id, $building, $unit, $outdoor_no, $device_type, $device_ip, $remark, "");

		if ($isSuccessFlag === FALSE)
		{
			echo json_encode(array("state" => 10, "ret" => "Database Error"));
		}
		else
		{
			echo json_encode(array("state" => 1, "ret" => "Success"));
		}


	}

	//编辑门口机
	function editOutdoor()
	{
		$outdoor_id = $this->input->post("outdoor_id");
		$building_id = $this->input->post("building_id");
		$unit_id = $this->input->post("unit_id");
		$outdoor_no = $this->input->post("outdoor_no");
		$device_type = $this->input->post("device_type");
		$device_ip = $this->input->post("device_ip");
		$remark = $this->input->post("remark");
		$outdoor_no = placeholderLocation($outdoor_no, "room");
		if (check_is_chinese($device_ip))
		{
			echo json_encode(array("state" => 4, "ret" => "ip error"));
			die;
		}
		$this->load->model('BasicInfo_model');
		$deviceIp = $this->BasicInfo_model->getOutdoorDeviceIpByID($outdoor_id);

		if ($device_ip != "")
		{
			if ($deviceIp != $device_ip)
			{
				if ($this->BasicInfo_model->isExsitDeviceIp($device_ip))
				{
					echo json_encode(array("state" => 11, "ret" => "ip exsit"));
					die;
				}
			}
		}
		$IsExsit = $this->isExsitOutdoorByID($building_id, $unit_id, $outdoor_id, $outdoor_no, "edit");
		if ($IsExsit)
		{
			echo json_encode(array("state" => 2, "ret" => "exsit"));
			die;
		}
		$data = array(
			'building_id' => $building_id,
			'unit_id' => $unit_id,
			'outdoor_no' => $outdoor_no,
			'device_type' => $device_type,
			'device_ip' => $device_ip,
			'remark' => $remark
		);
		$this->db->where('outdoor_id', $outdoor_id);
		$result = $this->db->update('base_outdoor_info', $data);
		if ($result)
		{
			echo json_encode(array("state" => 1, "ret" => "success"));
		}
	}


	//删除门口机
	public function removeOutdoor()
	{
		$outdoor_id = $this->input->post('outdoor_id');
		$this->load->model('BasicInfo_model');
		$this->load->model('Sip_model');
		$deviceID = $this->BasicInfo_model->getOutdoorDeviceIdByID($outdoor_id);

		$this->db->trans_begin();

		$this->db->delete('base_outdoor_info', array('outdoor_id' => $outdoor_id));
		$this->db->delete('device', array('name' => $deviceID));
		
		$this->Sip_model->removeSipNoByID($deviceID);

		if ($this->db->trans_status() === FALSE)
		{
			$this->db->trans_rollback();
			echo json_encode(array("state" => 10, "ret" => "Database Error"));
			die;
		}
		else
		{
			$this->db->trans_commit();
			echo json_encode(array("state" => 1, "ret" => "Success"));
			die;
		}
	}

	public function IsExsitOutdoor()
	{
		$building_id = $this->input->post("building_id");
		$unit_id = $this->input->post("unit_id");
		$outdoor_no = $this->input->post("outdoor_no");
		$outdoor_no = placeholderLocation($outdoor_no, "room");
		$result = $this->db->get_where('base_outdoor_info',
			array("building_id" => $building_id, "unit_id" => $unit_id, "outdoor_no" => $outdoor_no))->result();
		$count = count($result);
		if ($count > 0)
		{
			echo json_encode(array("state" => 1, "ret" => "success"));
		}
	}

	//获取门口机列表
	public function getOutdoors()
	{

		$building_id = $this->input->post("building_id");
		$unit_id = $this->input->post("unit_id");

		$rpp = $this->input->get('rpp');
		$page = $this->input->get('page');
		$rpp = empty($rpp) ? RPP : $this->input->get('rpp');
		$page = empty($page) ? 1 : $this->input->get('page');
		
		$fromIndex		= ($page-1)*$rpp;
		$sql_condition="limit ".$fromIndex.",".$rpp;
		$sql="SELECT outdoor_id,outdoor_no,device_ip,device_type,remark FROM base_outdoor_info  
			WHERE `building_id` = '".$building_id."' AND `unit_id` = '".$unit_id."'
			ORDER BY outdoor_no ASC ";
		$result			= $this->db->query($sql.$sql_condition)->result();
		$total			= count($this->db->query($sql)->result());
		echo json_encode(array("state" => 1, "ret" => $result, "total" => $total));
	}


	#############################业主信息相关服务###############################

	/**
	 * User: Paul
	 * Date: 2018/04/26
	 * 根据业主房间号获取业主联系方式
	 */
	public function getOwnerInfoByHouseID()
	{
		$houseId = $this->input->post("houseId");
		if (strlen($houseId) == 9)
		{
			$building = substr($houseId, 0, 3);
			$unit = substr($houseId, 3, 2);
			$room = substr($houseId, 5, 4);
			$sql = "SELECT building,unit,room, name,phone_primary FROM base_owner_info 
			   WHERE is_receive_msg=1 and building='" . $building . "' and unit='" . $unit . "' and room='" . $room . "' ";
			$result = $this->db->query($sql)->result();
			echo json_encode(array("state" => 1, "ret" => $result));
		}
		else
		{
			echo json_encode(array("state" => 0, "ret" => "房间号不是9位"));
			die;
		}
	}

	//添加业主信息
	public function addBaseOwnerInfo()
	{
		$name = $this->input->post("name");
		$avatar = $this->input->post("avatar");
		$building_id = $this->input->post("building_id");
		$unit_id = $this->input->post("unit_id");
		$room_id = $this->input->post("room_id");
		$phone_primary = $this->input->post("phone_primary");
		$is_receive_msg = $this->input->post("is_receive_msg");
		$remark = $this->input->post("remark");
		$building = $this->input->post("building");
		$unit = $this->input->post("unit");
		$room = $this->input->post("room");
		$data = array(
			'name' => $name,
			'avatar' => $avatar,
			'building_id' => $building_id,
			'unit_id' => $unit_id,
			'room_id' => $room_id,
			'phone_primary' => $phone_primary,
			'is_receive_msg' => $is_receive_msg,
			'remark' => $remark,
			'building' => $building,
			'unit' => $unit,
			'room' => $room
		);
		$result = $this->db->insert('base_owner_info', $data);
		if ($result)
		{
			echo json_encode(array("state" => 1, "ret" => "success"));
		}
	}

	//编辑业主信息
	public function editBaseOwnerInfo()
	{
		$owner_id = $this->input->post("owner_id");
		$name = $this->input->post("name");
		$avatar = $this->input->post("avatar");

		$phone_primary = $this->input->post("phone_primary");
		$is_receive_msg = $this->input->post("is_receive_msg");
		$remark = $this->input->post("remark");

		$data = array(
			'name' => $name,
			'avatar' => $avatar,

			'phone_primary' => $phone_primary,
			'is_receive_msg' => $is_receive_msg,
			'remark' => $remark
		);
		$this->db->where('owner_id', $owner_id);
		$result = $this->db->update('base_owner_info', $data);
		if ($result)
		{
			echo json_encode(array("state" => 1, "ret" => "success"));
		}
	}

	//删除业主信息
	public function removeBaseOwnerInfo()
	{
		$owner_id = $this->input->post('owner_id');
		$qurey = $this->db->query('select avatar from base_owner_info where owner_id=' . $owner_id);
		$result = $this->db->delete('base_owner_info', array('owner_id' => $owner_id));

		$row = $qurey->row();
		$avatar_path = $row->avatar;

		if ($result)
		{
			$filePath = dirname(dirname(dirname(__FILE__))) . $avatar_path;

			if (file_exists($filePath))
			{
				unlink($filePath);
			}
			echo json_encode(array("state" => 1, "ret" => "success"));
		}
	}

	//获取业主信息
	public function getBaseOwnerInfo()
	{
		$filter_building = $this->input->post("building_id");
		$filter_unit = $this->input->post("unit_id");
		$filter_room = $this->input->post("room_id");

		$rpp = $this->input->get('rpp');
		$page = $this->input->get('page');
		$rpp = empty($rpp) ? RPP : $this->input->get('rpp');
		$page = empty($page) ? 1 : $this->input->get('page');

		$all_result = $this->db->get_where('base_owner_info', array("building_id" => $filter_building,
			"unit_id" => $filter_unit, "room_id" => $filter_room))->result();
		$this->db->order_by('owner_id', 'ASC');

		$this->db->limit($rpp, ($page - 1) * $rpp);

		if (empty($filter_building) && empty($filter_unit) && empty($filter_room))
		{
			$result = $this->db->get('base_owner_info')->result();
		}
		else
		{
			$result = $this->db->get_where('base_owner_info', array("building_id" => $filter_building,
				"unit_id" => $filter_unit, "room_id" => $filter_room))->result();
		}
		$total = count($all_result);
		$res = array();
		foreach ($result as $k => $v)
		{
			$building_info = $this->db->get_where('base_building_info', array("building_id" => $v->building_id))->row();
			$unit_info = $this->db->get_where('base_unit_info', array("unit_id" => $v->unit_id))->row();
			$room_info = $this->db->get_where('base_room_info', array("room_id" => $v->room_id))->row();
			$res[$k]['owner_id'] = $v->owner_id;
			$res[$k]['name'] = $v->name;
			$res[$k]['avatar'] = $v->avatar;

			$res[$k]['building_id'] = $v->building_id;                 //楼栋ID
			$res[$k]['building'] = $building_info->building;//楼栋编号

			$res[$k]['unit_id'] = $v->unit_id;            //单元ID
			$res[$k]['unit'] = $unit_info->unit;//单元编号

			$res[$k]['room_id'] = $v->room_id;            //房间ID
			$res[$k]['room'] = $room_info->room;//房间编号

			$res[$k]['phone_primary'] = $v->phone_primary;
			$res[$k]['is_receive_msg'] = $v->is_receive_msg;
			$res[$k]['remark'] = $v->remark;
		}
		echo json_encode(array("state" => 1, "ret" => $res, "total" => $total));
	}

	/**
	 * Date: 2018/1/12
	 * 查询业主信息带业主姓名(模糊查询)
	 */
	public function getBaseOwnerInfoByName()
	{
		$filter_name = $this->input->post("name");
		$filter_building = $this->input->post("building_id");
		$filter_unit = $this->input->post("unit_id");
		$filter_room = $this->input->post("room_id");

		$rpp = $this->input->get('rpp');
		$page = $this->input->get('page');
		$rpp = empty($rpp) ? RPP : $this->input->get('rpp');
		$page = empty($page) ? 1 : $this->input->get('page');
		if ($filter_name != '')
		{
			$this->db->like('name', $filter_name);
		}
		if ($filter_building != '0')
		{
			$this->db->where('building_id', $filter_building);
		}
		if ($filter_unit != '0')
		{
			$this->db->where('unit_id', $filter_unit);
		}
		if ($filter_room != '0')
		{
			$this->db->where('room_id', $filter_room);
		}
		$this->db->order_by('owner_id', 'ASC');
		$all_result = $this->db->get('base_owner_info')->result();
		$total = count($all_result);

		$this->db->limit($rpp, ($page - 1) * $rpp);

		if ($filter_name != '')
		{
			$this->db->like('name', $filter_name);
		}
		if ($filter_building != '0')
		{
			$this->db->where('building_id', $filter_building);
		}
		if ($filter_unit != '0')
		{
			$this->db->where('unit_id', $filter_unit);
		}
		if ($filter_room != '0')
		{
			$this->db->where('room_id', $filter_room);
		}
		$result = $this->db->get('base_owner_info')->result();
		$res = array();
		foreach ($result as $k => $v)
		{
			$building_info = $this->db->get_where('base_building_info', array("building_id" => $v->building_id))->row();
			$unit_info = $this->db->get_where('base_unit_info', array("unit_id" => $v->unit_id))->row();
			$room_info = $this->db->get_where('base_room_info', array("room_id" => $v->room_id))->row();
			$res[$k]['owner_id'] = $v->owner_id;
			$res[$k]['name'] = $v->name;
			$res[$k]['avatar'] = $v->avatar;

			$res[$k]['building_id'] = $v->building_id;                 //楼栋ID
			$res[$k]['building'] = $building_info->building;//楼栋编号

			$res[$k]['unit_id'] = $v->unit_id;            //单元ID
			$res[$k]['unit'] = $unit_info->unit;//单元编号

			$res[$k]['room_id'] = $v->room_id;            //房间ID
			$res[$k]['room'] = $room_info->room;//房间编号

			$res[$k]['phone_primary'] = $v->phone_primary;
			$res[$k]['is_receive_msg'] = $v->is_receive_msg;
			$res[$k]['remark'] = $v->remark;
		}
		echo json_encode(array("state" => 1, "ret" => $res, "total" => $total));
	}

	/**
	 * User: Paul
	 * Date: 2018/1/5
	 * $wall_id 围墙机id
	 * 判断围墙机编号是否存在信息
	 */
	private function isExsitWallByID($wall_id, $wall_no, $action)
	{
		$wall_no = placeholderLocation($wall_no, "room");
		$this->db->escape();
		if ($action == "add")
		{
			$row = $this->db->query("SELECT  count(1) ct FROM base_wall_info where  wall_no= '" . $wall_no . "'")->row();
			if ($row->ct == 0)
			{
				return FALSE;
			}
			return TRUE;
		}
		else
		{
			$row = $this->db->query("SELECT count(1) ct FROM base_wall_info 
										WHERE wall_id <> " . $wall_id . " AND wall_no='" . $wall_no . "'")->row();

			if ($row->ct == 0)
			{
				return FALSE;
			}
			return TRUE;
		}

	}

	public function addWallInfo()
	{
		$device_type = $this->input->post("device_type");
		$wall_no = $this->input->post("wall_no");
		$device_ip = $this->input->post("device_ip");
		$remark = $this->input->post("remark");
		$wall_no = placeholderLocation($wall_no, "room");
		if (check_is_chinese($device_ip))
		{
			echo json_encode(array("state" => 4, "ret" => "ip error"));
			die;
		}
		$this->load->model('BasicInfo_model');
		if ($device_ip != "")
		{
			if ($this->BasicInfo_model->isExsitDeviceIp($device_ip))
			{
				echo json_encode(array("state" => 11, "ret" => "ip exsit"));
				die;
			}
		}
		$IsExsit = $this->isExsitWallByID("", $wall_no, "add");

		if ($IsExsit)
		{
			echo json_encode(array("state" => 2, "ret" => "exsit"));
			die;
		}

		$this->load->model('Sip_model');
		$isSuccessFlag = $this->Sip_model->addWallAndSip($wall_no, $device_type, $device_ip, $remark, "");

		if ($isSuccessFlag === FALSE)
		{
			echo json_encode(array("state" => 10, "ret" => "Database Error"));
		}
		else
		{
			echo json_encode(array("state" => 1, "ret" => "Success"));
		}
	}

	public function editWallInfo()
	{

		$wall_id = $this->input->post("wall_id");
		$wall_no = $this->input->post("wall_no");
		$device_type = $this->input->post("device_type");
		$device_ip = $this->input->post("device_ip");
		$remark = $this->input->post("remark");
		$wall_no = placeholderLocation($wall_no, "room");
		if (check_is_chinese($device_ip))
		{
			echo json_encode(array("state" => 4, "ret" => "ip error"));
			die;
		}
		$this->load->model('BasicInfo_model');
		$deviceIp = $this->BasicInfo_model->getWallDeviceIpByID($wall_id);

		if ($device_ip != "")
		{
			if ($deviceIp != $device_ip)
			{
				if ($this->BasicInfo_model->isExsitDeviceIp($device_ip))
				{
					echo json_encode(array("state" => 11, "ret" => "ip exsit"));
					die;
				}
			}
		}
		$IsExsit = $this->isExsitWallByID($wall_id, $wall_no, "edit");
		if ($IsExsit)
		{
			echo json_encode(array("state" => 2, "ret" => "exsit"));
			die;
		}
		$data = array(
			'wall_no' => $wall_no,
			'device_type' => $device_type,
			'device_ip' => $device_ip,
			'remark' => $remark
		);
		$this->db->where('wall_id', $wall_id);
		$result = $this->db->update('base_wall_info', $data);
		if ($result)
		{
			echo json_encode(array("state" => 1, "ret" => "success"));
		}
	}


	public function removeWallInfo()
	{
		$wall_id = $this->input->post('wall_id');

		$this->load->model('BasicInfo_model');
		$this->load->model('Sip_model');
		$deviceID = $this->BasicInfo_model->getWallDeviceIdByID($wall_id);

		$this->db->trans_begin();

		$this->db->delete('base_wall_info', array('wall_id' => $wall_id));
		$this->db->delete('device', array('name' => $deviceID));
		
		$this->Sip_model->removeSipNoByID($deviceID);
		if ($this->db->trans_status() === FALSE)
		{
			$this->db->trans_rollback();
			echo json_encode(array("state" => 10, "ret" => "Database Error"));
			die;
		}
		else
		{
			$this->db->trans_commit();
			echo json_encode(array("state" => 1, "ret" => "Success"));
			die;
		}
	}

	public function IsExsitWall()
	{
		$wall_no = $this->input->post("wall_no");
		$wall_no = placeholderLocation($wall_no, "room");
		$result = $this->db->get_where('base_wall_info', array("wall_no" => $wall_no))->result();
		$count = count($result);
		if ($count > 0)
		{
			echo json_encode(array("state" => 1, "ret" => "success"));
		}
	}

	public function getWallInfo()
	{
		$rpp = $this->input->get('rpp');
		$page = $this->input->get('page');
		$rpp = empty($rpp) ? RPP : $this->input->get('rpp');
		$page = empty($page) ? 1 : $this->input->get('page');

		$fromIndex		= ($page-1)*$rpp;
		$sql_condition="limit ".$fromIndex.",".$rpp;
		$sql="SELECT wall_id,wall_no,device_ip,device_type,remark FROM base_wall_info  ORDER BY wall_no ASC ";
		$result			= $this->db->query($sql.$sql_condition)->result();
		$total			= count($this->db->query($sql)->result());
		echo json_encode(array("state" => 1, "ret" => $result, "total" => $total));
	}

	/**
	 * User: Paul
	 * Date: 2017/12/07
	 * 判断门卫机编号是否重复
	 */
	private function isExsitGuardByID($building_id, $unit_id, $guard_id, $guard_no, $action)
	{
		$guard_no = placeholderLocation($guard_no, "room");
		if ($action == "add")
		{

			$row = $this->db->query("SELECT  count(1) ct FROM base_guard_info where  
			building_id=" . $building_id . " and unit_id=" . $unit_id . " and guard_no= '" . $guard_no . "'")->row();
			if ($row->ct == 0)
			{
				return FALSE;
			}
			return TRUE;
		}
		else
		{

			$this->db->escape();
			$row = $this->db->query("SELECT count(guard_no) ct  FROM base_guard_info 
				WHERE building_id=" . $building_id . " AND unit_id=" . $unit_id .
				" AND guard_id !=" . $guard_id . " AND guard_no='" . $guard_no . "'")->row();
			if ($row->ct == 0)
			{
				return FALSE;
			}
			return TRUE;
		}

	}

	public function addGuardInfo()
	{
		$building_id = $this->input->post("building_id");
		$unit_id = $this->input->post("unit_id");
		$building = $this->input->post("building");
		$unit = $this->input->post("unit");
		$guard_no = $this->input->post("guard_no");
		$device_type = $this->input->post("device_type");
		$device_ip = $this->input->post("device_ip");
		$remark = $this->input->post("remark");
		if (check_is_chinese($device_ip))
		{
			echo json_encode(array("state" => 4, "ret" => "ip error"));
			die;
		}
		$this->load->model('BasicInfo_model');
		if ($device_ip != "")
		{
			if ($this->BasicInfo_model->isExsitDeviceIp($device_ip))
			{
				echo json_encode(array("state" => 11, "ret" => "ip exsit"));
				die;
			}
		}
		$guard_no = placeholderLocation($guard_no, "room");
		$IsExsit = $this->isExsitGuardByID($building_id, $unit_id, "", $guard_no, "add");
		if ($IsExsit)
		{
			echo json_encode(array("state" => 2, "ret" => "exsit"));
			die;
		}

		$this->load->model('Sip_model');
		$isSuccessFlag = $this->Sip_model->addGuardAndOutdoorSip("07", $building_id, $unit_id, $building, $unit, $guard_no, $device_type, $device_ip, $remark, "");

		if ($isSuccessFlag === FALSE)
		{
			echo json_encode(array("state" => 10, "ret" => "Database Error"));
		}
		else
		{
			echo json_encode(array("state" => 1, "ret" => "Success"));
		}
	}

	public function editGuardInfo()
	{
		$guard_id = $this->input->post("guard_id");
		$building_id = $this->input->post("building_id");
		$unit_id = $this->input->post("unit_id");
		$guard_no = $this->input->post("guard_no");
		$device_type = $this->input->post("device_type");
		$device_ip = $this->input->post("device_ip");
		$remark = $this->input->post("remark");
		if (check_is_chinese($device_ip))
		{
			echo json_encode(array("state" => 4, "ret" => "ip error"));
			die;
		}
		$this->load->model('BasicInfo_model');
		$deviceIp = $this->BasicInfo_model->getGuardDeviceIpByID($guard_id);

		if ($device_ip != "")
		{
			if ($deviceIp != $device_ip)
			{
				if ($this->BasicInfo_model->isExsitDeviceIp($device_ip))
				{
					echo json_encode(array("state" => 11, "ret" => "ip exsit"));
					die;
				}
			}
		}
		$guard_no = placeholderLocation($guard_no, "room");
		$IsExsit = $this->isExsitGuardByID($building_id, $unit_id, $guard_id, $guard_no, "edit");
		if ($IsExsit)
		{
			echo json_encode(array("state" => 2, "ret" => "exsit"));
			die;
		}
		$data = array(
			'building_id' => $building_id,
			'unit_id' => $unit_id,
			'guard_no' => $guard_no,
			'device_type' => $device_type,
			'device_ip' => $device_ip,
			'remark' => $remark
		);
		$this->db->where('guard_id', $guard_id);
		$result = $this->db->update('base_guard_info', $data);
		if ($result)
		{
			echo json_encode(array("state" => 1, "ret" => "success"));
		}
	}


	public function removeGuardInfo()
	{
		$guard_id = $this->input->post('guard_id');
		$this->load->model('BasicInfo_model');
		$this->load->model('Sip_model');
		$deviceID = $this->BasicInfo_model->getGuardDeviceIdByID($guard_id);

		$this->db->trans_begin();

		$this->db->delete('base_guard_info', array('guard_id' => $guard_id));
		$this->db->delete('device', array('name' => $deviceID));

		
		$this->Sip_model->removeSipNoByID($deviceID);

		if ($this->db->trans_status() === FALSE)
		{
			$this->db->trans_rollback();
			echo json_encode(array("state" => 10, "ret" => "Database Error"));
			die;
		}
		else
		{
			$this->db->trans_commit();
			echo json_encode(array("state" => 1, "ret" => "Success"));
			die;
		}
	}

	public function IsExsitGuard()
	{
		$building_id = $this->input->post("building_id");
		$unit_id = $this->input->post("unit_id");
		$guard_no = $this->input->post("guard_no");
		$guard_no = placeholderLocation($guard_no, "room");
		$result = $this->db->get_where('base_guard_info', array("guard_no" => $guard_no))->result();
		$count = count($result);
		if ($count > 0)
		{
			echo json_encode(array("state" => 1, "ret" => "success"));
		}
	}

	public function getGuardInfo()
	{
		$building_id	= $this->input->post("building_id");
		$unit_id		= $this->input->post("unit_id");
		$rpp			= $this->input->get('rpp');
		$page			= $this->input->get('page');
		$rpp			= empty($rpp) ? RPP : $this->input->get('rpp');
		$page			= empty($page) ? 1 : $this->input->get('page');
		$fromIndex		= ($page-1)*$rpp;
		$sql_condition="limit ".$fromIndex.",".$rpp;
		$sql="SELECT guard_id,guard_no,device_ip,device_type,remark FROM `base_guard_info` A 
			WHERE `building_id` = '".$building_id."' AND `unit_id` = '".$unit_id."'
			ORDER BY `guard_no` ASC ";
		$result			= $this->db->query($sql.$sql_condition)->result();
		$total			= count($this->db->query($sql)->result());
		echo json_encode(array("state" => 1, "ret" => $result, "total" => $total));
	}

	/**
	 * User: Paul
	 * Date: 2017/12/07
	 * 管理员信息
	 */

	public function addUserInfo()
	{
		$username = $this->input->post("username");
		$password = $this->input->post("password");
		$privilege = $this->input->post("privilege");
		$remark = $this->input->post("remark");

		$data = array(
			'username' => $username,
			'password' => $password,
			'privilege' => $privilege,
			'remark' => $remark
		);
		$result = $this->db->insert('base_user_info', $data);
		if ($result)
		{
			echo json_encode(array("state" => 1, "ret" => "success"));
		}
	}

	public function editUserInfo()
	{
		$user_id = $this->input->post("user_id");
		$username = $this->input->post("username");
		$password = $this->input->post("password");
		$privilege = $this->input->post("privilege");
		$remark = $this->input->post("remark");

		$data = array(
			'username' => $username,
			'password' => $password,
			'privilege' => $privilege,
			'remark' => $remark
		);
		$this->db->where('user_id', $user_id);
		$result = $this->db->update('base_user_info', $data);
		if ($result)
		{
			echo json_encode(array("state" => 1, "ret" => "success"));
		}
	}


	public function removeUserInfo()
	{
		$user_id = $this->input->post('user_id');

		$this->load->model('BasicInfo_model');
		$this->load->model('Sip_model');
		$deviceID = $this->BasicInfo_model->getUserDeviceIdByID($user_id);

		$this->db->trans_begin();

		$this->db->delete('base_user_info', array('user_id' => $user_id));
		$this->db->delete('device', array('name' => $deviceID));
		
		$this->Sip_model->removeSipNoByID($deviceID);
		if ($this->db->trans_status() === FALSE)
		{
			$this->db->trans_rollback();
			echo json_encode(array("state" => 10, "ret" => "Database Error"));
			die;
		}
		else
		{
			$this->db->trans_commit();
			echo json_encode(array("state" => 1, "ret" => "Success"));
			die;
		}
	}

	public function IsExsitUser()
	{
		$username = $this->input->post("username");
		$result = $this->db->get_where('base_user_info', array("username" => $username))->result();
		$count = count($result);
		if ($count > 0)
		{
			echo json_encode(array("state" => 1, "ret" => "success"));
		}
	}

	public function getUserInfo()
	{
		$rpp = $this->input->get('rpp');
		$page = $this->input->get('page');
		$rpp = empty($rpp) ? RPP : $this->input->get('rpp');
		$page = empty($page) ? 1 : $this->input->get('page');
		$this->db->order_by('username', 'ASC');
		$this->db->limit($rpp, ($page - 1) * $rpp);

		$result = $this->db->get('base_user_info')->result();
		$total = $this->db->count_all_results('base_user_info');
		$res = array();
		foreach ($result as $k => $v)
		{
			$res[$k]['username'] = $v->username;
			$res[$k]['privilege'] = $v->privilege;
			$res[$k]['remark'] = $v->remark;
		}
		echo json_encode(array("state" => 1, "ret" => $res, "total" => $total));
	}

	public function getUserDetail()
	{
		$user_id = $this->input->post("user_id");
		$this->db->where('user_id', $user_id);
		$result = $this->db->get('base_user_info')->result();
		$res = array();
		foreach ($result as $k => $v)
		{

			$res[$k]['username'] = $v->username;
			$res[$k]['privilege'] = $v->privilege;
			$res[$k]['remark'] = $v->remark;
		}
		echo json_encode(array("state" => 1, "ret" => $res, "total" => $total));
	}

	//根据设备ip 楼栋 单元 房间号获取设备列表
	public function getAllDeviceInfo()
	{
		$device_ip = $this->input->post("device_ip");
		$building = $this->input->post("building");
		$unit = $this->input->post("unit");
		$room = $this->input->post("room");

		$rpp = $this->input->get('rpp');
		$page = $this->input->get('page');
		$rpp = empty($rpp) ? RPP : $this->input->get('rpp');
		$page = empty($page) ? 1 : $this->input->get('page');

		if ($device_ip != '')
		{
			$sql_condition.=" AND device_ip='".$device_ip."'";
		}
		if ($building != '0')
		{
			$sql_condition.=" AND building='".$building."'";
		}
		if ($unit != '0')
		{
			$sql_condition.=" AND unit='".$unit."'";
		}
		if ($room != '0')
		{
			$sql_condition.=" AND room='".$room."'";
		}


		
		/*$result = $this->db->get('View_GetALLDeviceList')->result();

		echo json_encode(array("state" => 1, "ret" => $result, "total" => $total));*/
		$sql_condition .= " ORDER BY deviceTypeNo, building,unit,room,deviceNo ";
		$fromIndex = ($page-1)*$rpp;
		$sql_limit .=" limit ".$fromIndex.",".$rpp;
		
		$sql="SELECT * from View_GetALLDeviceList  WHERE 1=1 ";
		
		$result = $this->db->query($sql.$sql_condition.$sql_limit)->result();
		$total	 = count($this->db->query($sql.$sql_condition)->result());
		echo json_encode(array("state" => 1, "ret" => $result, "total" => $total));

	}


	public function getDeviceTypeList()
	{

		$result = $this->db->query('select * from base_device_type')->result();
		echo json_encode(array("state" => 1, "ret" => $result));
	}

	private function isExsitDeviceTypeByName($device_type_id, $device_type_name, $action)
	{
		$this->db->escape();
		if ($action == "add")
		{
			$row = $this->db->query("SELECT  count(1) ct FROM base_device_type where device_type_name='" . $device_type_name . "'")->row();
			if ($row->ct == 0)
			{
				return FALSE;
			}
			return TRUE;
		}
		else
		{
			$row = $this->db->query("SELECT count(device_type_name) ct FROM base_device_type 
									 WHERE device_type_id <> " . $device_type_id . " AND device_type_name='" . $device_type_name . "'")->row();
			if ($row->ct == 0)
			{
				return FALSE;
			}
			return TRUE;
		}

	}

	public function addDeviceType()
	{
		$device_type_name = $this->input->post("device_type_name");
		$device_type = $this->input->post("device_type");
		$remark = $this->input->post("remark");
		$IsExsit = $this->isExsitDeviceTypeByName("", $device_type_name, "add");

		if ($IsExsit)
		{
			echo json_encode(array("state" => 2, "ret" => "exsit"));
			die;
		}
		$data = array(
			'device_type' => $device_type,
			'device_type_name' => $device_type_name,
			'remark' => $remark

		);

		$result = $this->db->insert('base_device_type', $data);
		if ($result)
		{
			echo json_encode(array("state" => 1, "ret" => "success"));
		}
	}

	public function editDeviceType()
	{
		$device_type_id = $this->input->post("device_type_id");
		$device_type_name = $this->input->post("device_type_name");
		$remark = $this->input->post("remark");

		$IsExsit = $this->isExsitDeviceTypeByName($device_type_id, $device_type_name, "edit");
		if ($IsExsit)
		{
			echo json_encode(array("state" => 2, "ret" => "exsit"));
			die;
		}

		$data = array(
			'device_type_name' => $device_type_name,
			'remark' => $remark

		);

		$this->db->where('device_type_id', $device_type_id);
		$result = $this->db->update('base_device_type', $data);
		if ($result)
		{
			echo json_encode(array("state" => 1, "ret" => "success"));
		}
	}

	function removeDeviceType()
	{
		$device_type_id = $this->input->post("device_type_id");
		$this->db->delete('base_device_type', array('device_type_id' => $device_type_id));
		echo json_encode(array("state" => 1, "ret" => "success"));
	}

}
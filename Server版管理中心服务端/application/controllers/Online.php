<?php

//创建在线监测实体
class Online extends CI_Controller {
	public function __construct()
	{
		parent::__construct();
	}


	//获取在线设备列表
	public function getOnlineDevices()
	{

		$baseDevices = array();
		$mqttDevices = array();
		$result = array();
		//建立设备类型和数据表关系
		$type = array
		(
			"01" => "base_indoor_info",   //室内机
			"02" => "base_outdoor_info",  //门口机
			"03" => "base_wall_info",     //围墙机
			"07" => "base_guard_info",    //门卫机
		);
		//获取设备视图列表
		foreach ($this->db->query("select * from View_GetALLDeviceList")->result() as $key => $value)
		{
			if (empty($value->building))
			{
				$building = "000";
			}
			else
			{
				$building = $value->building;
			}
			if (empty($value->unit))
			{
				$unit = "00";
			}
			else
			{
				$unit = $value->unit;
			}
			if (empty($value->room))
			{
				$room = "0000";
			}
			else
			{
				$room = $value->room;
			}
			$baseDevices[$key]['id'] = $value->sipNo;
			$baseDevices[$key]['ip'] = $value->device_ip;
			$baseDevices[$key]['mac'] = $value->mac;
			$baseDevices[$key]['location'] = substr($baseDevices[$key]['id'], 2, 9);
			$baseDevices[$key]['typeCode'] = substr($baseDevices[$key]['id'], 0, 2);
			$baseDevices[$key]['device_type'] = $value->device_type;
		}

		//获取MQTT在线设备服务
		$raw_data = _getHTTPS("http://" . EMQTTD_IP . ":" . EMQTTD_API_PORT . "/api/v2/nodes/emq@127.0.0.1/clients");
		$raw_data = json_decode($raw_data, TRUE);
		$i = 0;
		for ($page = 1; $page <= $raw_data['result']['total_page']; $page++)
		{
			$raw_data = _getHTTPS("http://" . EMQTTD_IP . ":" . EMQTTD_API_PORT . "/api/v2/nodes/emq@127.0.0.1/clients?curr_page=" . $page . "&page_size=20");
			$raw_data = json_decode($raw_data, TRUE);
			foreach ($raw_data['result']['objects'] as $key => $value)
			{
				$mqttDevices[$i]['id'] = strtoupper(end(explode("?", $value['client_id'])));
				$mqttDevices[$i]['ip'] = $value['ipaddress'];
				$mqttDevices[$i]['location'] = substr($mqttDevices[$i]['id'], 2, 9);
				$mqttDevices[$i]['mac'] = current(explode("?", $value['client_id']));
				$mqttDevices[$i]['typeCode'] = substr($mqttDevices[$i]['id'], 0, 2);
				$sql = "select * from View_GetALLDeviceList where sipNo='" . $mqttDevices[$i]['id'] . "'";
				file_put_contents("sewd", $sql . "\r\n", FILE_APPEND);
				if (empty($this->db->query($sql)->row()->device_type))
				{
					$mqttDevices[$i]['device_type'] = "N/A";
				}
				else
				{
					$mqttDevices[$i]['device_type'] = $this->db->query($sql)->row()->device_type;
				}

				$i++;
			}
		}

		$result = array();
		/*
		$mqttDevices = array(
			array("id" => "0188888888803", "mac" => "1c:87:76:51:99:52", "ip" => "192.168.1.71", "location" => "888888888", "typeCode" => "01"),
			array("id" => "0188888888802", "mac" => "1c:87:76:51:99:96", "ip" => "192.168.1.174", "location" => "888888888", "typeCode" => "01"),
			array("id" => "0000000000000", "mac" => "1c:87:76:51:99:98", "ip" => "192.168.1.160", "location" => "000000000", "typeCode" => "00"));
		*/
		$baseIPSets = $this->getNewSets("ip", $baseDevices);
		$baseIDSets = $this->getNewSets("id", $baseDevices);
//过滤本地信息(127.0.0.1)服务
		foreach ($mqttDevices as $key_mqtt => $value_mqtt)
		{
			if ($value_mqtt['ip'] === "127.0.0.1")
			{
				unset($mqttDevices[$key_mqtt]);
			}
		}

//print_r($mqttDevices);

		foreach ($mqttDevices as $key_mqtt => $value_mqtt)
		{
			if (in_array($value_mqtt['id'], $baseIDSets))
			{
				if (empty($baseIPSets[array_search($value_mqtt['id'], $baseIDSets)]))
				{

					if (in_array($value_mqtt['ip'], $baseIPSets) && $value_mqtt['id'] != $baseIDSets[array_search($value_mqtt['ip'], $baseIPSets)])
					{
						$temp = array();
						$temp = array_merge($value_mqtt, array("status" => 4));
						if ( ! in_array($temp, $result))
						{
							$result[$key_mqtt] = array_merge($value_mqtt, array("status" => 4));//设备IP冲突
						}
					}
					else
					{
						if ( ! in_array($value_mqtt['mac'], $this->getNewSets("mac", $baseDevices)))
						{
							$temp = array();
							$temp = array_merge($value_mqtt, array("status" => 5));
							if ( ! in_array($temp, $result))
							{
								$result[$key_mqtt] = array_merge($value_mqtt, array("status" => 5));//新设备
							}
						}
						else
						{
							$temp = array();
							$temp = array_merge($value_mqtt, array("status" => 2));//在线，更新mac
							if ( ! in_array($temp, $result))
							{
								$result[$key_mqtt] = array_merge($value_mqtt, array("status" => 2));//在线
							}
						}
					}
				}
				else
				{
					if ($value_mqtt['ip'] == $baseIPSets[array_search($value_mqtt['id'], $baseIDSets)])
					{
						//判断手动录入IP冲突情况

						if (in_array($value_mqtt['ip'], $baseIPSets) && $this->db->query("select count(*) as cnt from View_GetALLDeviceList where device_ip='".$value_mqtt['ip']."'")->row()->cnt>1)
						{
							$temp = array();
							$temp = array_merge($value_mqtt, array("status" => 1));
							if ( ! in_array($temp, $result))
							{
								$result[$key_mqtt] = array_merge($value_mqtt, array("status" => 4));//IP冲突
							}
						}else{
							$temp = array();
							$temp = array_merge($value_mqtt, array("status" => 1));
							if ( ! in_array($temp, $result))
							{
								$result[$key_mqtt] = array_merge($value_mqtt, array("status" => 1));//在线
							}
						}


					}
					else
					{
						$temp = array();
						$temp = array_merge($value_mqtt, array("status" => 4));
						if ( ! in_array($temp, $result))
						{
							$result[$key_mqtt] = array_merge($value_mqtt, array("status" => 4));//设备IP错误
						}
					}
				}
			}
			else
			{

				if (in_array($value_mqtt['ip'], $baseIPSets))
				{
					$temp = array();
					$temp = array_merge($value_mqtt, array("status" => 4));
					if ( ! in_array($temp, $result))
					{
						$result[$key_mqtt] = array_merge($value_mqtt, array("status" => 4));//设备IP冲突
					}
				}
				else
				{
					if ( ! in_array($value_mqtt['mac'], $this->getNewSets("mac", $baseDevices)))
					{
						$temp = array();
						$temp = array_merge($value_mqtt, array("status" => 5));
						if ( ! in_array($temp, $result))
						{
							$result[$key_mqtt] = array_merge($value_mqtt, array("status" => 5));//新设备
						}
					}
					else
					{
						$temp = array();
						$temp = array_merge($value_mqtt, array("status" => 3));
						if ( ! in_array($temp, $result))
						{
							$result[$key_mqtt] = array_merge($value_mqtt, array("status" => 3));//配置错误

						}
					}
				}
			}
		}
		//过滤在线设备列表服务
		foreach ($result as $key => $value)
		{
			if ($value['ip'] === "127.0.0.1")
			{
				unset($result[$key]);
			}

			if ( ! array_key_exists($value['typeCode'], $type))
			{
				unset($result[$key]);
			}
		}


		//筛选条件服务
		foreach ($result as $key => $value)
		{
			$filter_temp_result[$key]['location'] = $value['location'];
			$filter_temp_result[$key]['type'] = $value['typeCode'];
		}
		if ($this->input->post("type"))
		{
			$filter_result = array();
			foreach ($result as $key => $value)
			{
				if (in_array($value['typeCode'], $this->input->post("type")))
				{
					$filter_result[] = $value;
				}
			}
			echo json_encode(array("state" => 1, "ret" => $filter_result));
			die;
		}
		if ($result)
		{
			echo json_encode(array("state" => 1, "ret" => $result));
		}
		else
		{
			echo json_encode(array("state" => 0, "ret" => "Error"));
		}
	}


	//根据栋单元室筛选设备编号
	function getDevicesByLocation()
	{
		$filter_building = $this->input->get("building");
		$filter_unit = $this->input->get("unit");
		foreach ($this->db->query("select * from View_GetALLDeviceList WHERE building='" . $filter_building . "' and unit='" . $filter_unit . "'")->result() as $key => $value)
		{

			$res[$key]['building'] = $value->building;
			$res[$key]['unit'] = $value->unit;
			$res[$key]['room'] = $value->room;
			$res[$key]['deviceNo'] = $value->deviceNo;
		}
		echo json_encode(array("state" => 1, "ret" => $res));
	}

	//根据设备类型获取筛选条件
	function getDevicesByType()
	{
		$deviceTypeNo = $this->input->post('type');
		$res = array();
		if ($deviceTypeNo === "01")
		{
			$filter_building = $this->input->post("building");
			$filter_unit = $this->input->post("unit");
			if (empty($filter_building) && empty($filter_unit))
			{
				foreach ($this->db->query("select * from View_GetALLDeviceList WHERE deviceTypeNo='" . $deviceTypeNo . "'")->result() as $key => $value)
				{
					$res[$key]['building'] = $value->building;
					$res[$key]['unit'] = $value->unit;
					$res[$key]['room'] = $value->room;
				}
			}
			else
			{
				$sql = "SELECT DISTINCT unit,building,room FROM View_GetALLDeviceList WHERE deviceTypeNo='" . $deviceTypeNo . "' and 1=1";
				if ($filter_building != "")
				{
					$sql .= " AND building='" . $filter_building . "'";
				}

				if ($filter_unit != "")
				{
					$sql .= " AND unit='" . $filter_unit . "'";
				}
				foreach ($this->db->query($sql)->result() as $key => $value)
				{
					$res[$key]['building'] = $value->building;
					$res[$key]['unit'] = $value->unit;
					$res[$key]['room'] = $value->room;
				}
			}

		}
		elseif ($deviceTypeNo === "02")
		{
			$filter_building = $this->input->post("building");
			$filter_unit = $this->input->post("unit");
			if (empty($filter_building) && empty($filter_unit))
			{
				foreach ($this->db->query("select DISTINCT unit,building,room from View_GetALLDeviceList WHERE deviceTypeNo='" . $deviceTypeNo . "'")->result() as $key => $value)
				{
					$res[$key]['building'] = $value->building;
					$res[$key]['unit'] = $value->unit;
					$res[$key]['room'] = $value->room;
				}
			}
			else
			{

				$sql = "SELECT DISTINCT unit,building,room FROM View_GetALLDeviceList WHERE deviceTypeNo='" . $deviceTypeNo . "' and 1=1";
				if ($filter_building != "")
				{
					$sql .= " AND building='" . $filter_building . "'";
				}

				if ($filter_unit != "")
				{
					$sql .= " AND unit='" . $filter_unit . "'";
				}
				foreach ($this->db->query($sql)->result() as $key => $value)
				{
					$res[$key]['building'] = $value->building;
					$res[$key]['unit'] = $value->unit;
					$res[$key]['room'] = $value->room;
				}
			}

		}
		elseif ($deviceTypeNo === "07")
		{
			$filter_building = $this->input->post("building");
			$filter_unit = $this->input->post("unit");
			if (empty($filter_building) && empty($filter_unit))
			{
				foreach ($this->db->query("select DISTINCT unit,building,room from View_GetALLDeviceList WHERE deviceTypeNo='" . $deviceTypeNo . "'")->result() as $key => $value)
				{
					$res[$key]['building'] = $value->building;
					$res[$key]['unit'] = $value->unit;
					$res[$key]['room'] = $value->room;
				}
			}
			else
			{
				$sql = "SELECT DISTINCT unit,building,room FROM View_GetALLDeviceList WHERE deviceTypeNo='" . $deviceTypeNo . "' and 1=1";
				if ($filter_building != "")
				{
					$sql .= " AND building='" . $filter_building . "'";
				}

				if ($filter_unit != "")
				{
					$sql .= " AND unit='" . $filter_unit . "'";
				}

				foreach ($this->db->query($sql)->result() as $key => $value)
				{
					$res[$key]['building'] = $value->building;
					$res[$key]['unit'] = $value->unit;
					$res[$key]['room'] = $value->room;
				}
			}

		}
		else
		{
			foreach ($this->db->query("select * from View_GetALLDeviceList WHERE deviceTypeNo='" . $deviceTypeNo . "'")->result() as $key => $value)
			{
				$res[$key]['building'] = $value->building;
				$res[$key]['unit'] = $value->unit;
				$res[$key]['room'] = $value->room;
				$res[$key]['deviceNo'] = $value->deviceNo;
			}
		}
		echo json_encode(array("state" => 1, "ret" => $res));
	}


	//添加新设备服务
	function addNewDevices()
	{
		$building = substr($this->input->post("deviceID"), 2, 3);
		$unit = substr($this->input->post("deviceID"), 5, 2);
		$room = substr($this->input->post("deviceID"), 7, 4);
		$type = $this->input->post("type");
		$ip = $this->input->post("ip");
		$remark = ""; //删除备注服务 BUG：816
		$mac = $this->input->post("mac");
		$deviceID = strtoupper(trim($this->input->post("deviceID")));
		$device_type = $this->input->post("device_type");

		$type_array = array
		(
			"01" => "base_indoor_info",   //室内机
			"02" => "base_outdoor_info",  //门口机
			"03" => "base_wall_info",     //围墙机
			"07" => "base_guard_info",    //门卫机
		);

		$this->load->model('Sip_model');
		if ($type == "01")
		{
			//根据楼栋名称获取ID服务
			$this->load->model('BasicInfo_model');
			$this->BasicInfo_model->addRoom($building, $unit, $room);
			$this->Sip_model->addIndoorAndSipByNO($building, $unit, $room, $type, $ip, $mac, $remark, substr($deviceID, 11, 2),$device_type);//修改BUG：707

		}
		elseif ($type == "02" || $type == "07")
		{
			//根据楼栋名称获取ID服务

			$this->load->model('BasicInfo_model');
			$this->BasicInfo_model->addUnit($building, $unit);
			$building_id = $this->db->query("select building_id from base_building_info where building='" . $building . "'")->row()->building_id;
			//根据单元名称获取ID服务
			$unit_id = $this->db->query("select unit_id from base_unit_info where unit='" . $unit . "' and building_id=" . $building_id)->row()->unit_id;

			//判定是否在device表中存在服务 解决BUG:816
			$this->db->like('name', $deviceID);
			$this->db->from('device');
			if ($this->db->count_all_results() > 0)
			{
				if ($type == "02")
				{
					$sql = "UPDATE `base_outdoor_info` SET `device_ip`='{$ip}',`mac`='{$mac}' WHERE `device_id`='{$deviceID}'";
				}
				elseif ($type == "07")
				{
					$sql = "UPDATE `base_guard_info` SET `device_ip`='{$ip}',`mac`='{$mac}' WHERE `device_id`='{$deviceID}'";
				}
				$this->db->query($sql);
			}
			else
			{
				$this->Sip_model->addGuardAndOutdoorSip($type, $building_id, $unit_id, $building, $unit, $room, $device_type, $ip, $remark, $mac);
			}


		}
		elseif ($type == "03")
		{
			$this->Sip_model->addWallAndSip($room, $device_type, $ip, $remark, $mac);
		}

		//设备类型对应关系列表
		$device_type_res = array(
			"01" => "indoor",
			"02" => "outdoor",
			"03" => "wall",
			"04" => "independent",
			"05" => "扩展安防",
			"06" => "独立安防",
			"07" => "guard"
		);

		echo json_encode(array("state" => 1, "ret" => "ok"));
		die;


	}

	//获取所有门卫机与门口机列表服务
	function getAllGuardAndOutdoor()
	{
		$baseSets = array();
		$mqttSets = array();
		foreach ($this->db->query("select * from View_GetALLDeviceList")->result() as $key => $value)
		{
			if ($value->deviceTypeNo == "07" || $value->deviceTypeNo == "02")
			{
				$baseSets[] = array("id" => $value->sipNo, "ip" => $value->device_ip, "mac" => $value->mac, "type" => $value->deviceTypeNo);
			}
		}

		//获取MQTT在线设备服务
		$mqttDevices = array();
		$raw_data = _getHTTPS("http://" . EMQTTD_IP . ":" . EMQTTD_API_PORT . "/api/v2/nodes/emq@127.0.0.1/clients");
		$raw_data = json_decode($raw_data, TRUE);
		$i = 0;
		for ($page = 1; $page <= $raw_data['result']['total_page']; $page++)
		{
			$raw_data = _getHTTPS("http://" . EMQTTD_IP . ":" . EMQTTD_API_PORT . "/api/v2/nodes/emq@127.0.0.1/clients?curr_page=" . $page . "&page_size=20");
			$raw_data = json_decode($raw_data, TRUE);
			foreach ($raw_data['result']['objects'] as $key => $value)
			{

				$mqttDevices[$i]['id'] = strtoupper(end(explode("?", $value['client_id'])));
				$mqttDevices[$i]['ip'] = $value['ipaddress'];
				$mqttDevices[$i]['location'] = substr($mqttDevices[$i]['id'], 2, 9);
				$mqttDevices[$i]['mac'] = current(explode("?", $value['client_id']));
				$mqttDevices[$i]['typeCode'] = substr($mqttDevices[$i]['id'], 0, 2);
				$i++;
			}
		}

		foreach ($mqttDevices as $key => $value)
		{
			if (substr($value['id'], 0, 2) == "02" || substr($value['id'], 0, 2) == "07")
			{
				$mqttSets[] = array("id" => strtoupper($value['id']), "ip" => $value['ip'], "mac" => $value['mac'], "type" => substr($value['id'], 0, 2), "status" => 1);
			}
		}
		$mqttIds = $this->getNewSets("id", $mqttSets);
		foreach ($baseSets as $k => $v)
		{
			if (in_array($v['id'], $mqttIds))
			{
				unset($baseSets[$k]);
			}
			else
			{
				$baseSets[$k]["status"] = 0;
			}
		}
		foreach ($baseSets as $key => $value)
		{
			foreach ($mqttSets as $k => $v)
			{
				if ($value['id'] == $v['id'] && $value['mac'] == $v['mac'] && $value['ip'] != $v['ip'] && $value['status'] != $v['status'])
				{
					unset($baseSets[$key]);
				}
			}
		}
		echo json_encode(array("state" => 1, "ret" => array_merge($baseSets, $mqttSets)));
		die;

	}


	function getNewSets($field_value, $array)
	{
		$ret = array();
		foreach ($array as $key => $value)
		{
			$ret[] = $value[$field_value];
		}
		return $ret;
	}


}
<?php
//SIp控制器
class Sip extends CI_Controller
{
	public function __construct()
	{
		parent::__construct();
		
		$this->load->model('BasicInfo_model');
		$this->load->model('Sip_model');
	}
	//终端请求分配DeviceID=SipNo
	public function getDeviceInfoById()
	{
		$mac		= $this->input->get("mac");
		$deviceID	= $this->input->get("deviceID");
		$deviceType= $this->input->get("type");
		$version	= $this->input->get("version");
		if(!isset($deviceID) || strlen($deviceID)!=13)
		{
			echo json_encode(array("state" => 0, "ret" => "deviceID error"));
			die;
		}
		$deviceTypeFlag	= substr($deviceID,0,2);
		$this->BasicInfo_model->addDeviceModel($deviceTypeFlag,strtoupper($deviceType));
		switch(strtoupper($deviceType))
		{
			//MC CLIENT
			//case "00":
			//	
			//	$row = $this->getDeviceIdByMac($mac,"mcClient");
			//	if(empty($row))
			//	{
			//		$isSuccessFlag = $this->Sip_model->addMcClientAndSip($mac);
			//		
			//		if (!$isSuccessFlag)
			//		{
			//			echo json_encode(array("state" => 0, "ret" => "Database Error"));
			//			die;
			//		}
			//		$row = $this->getDeviceIdByMac($mac,"mcClient");
			//		echo json_encode(array("state" => 1, "deviceID" => $row->device_id,"sipPassword" =>$row->SipPassword));
			//		die;
			//	}
			//	else
			//	{
			//		echo json_encode(array("state" => 1, "deviceID" => $row->device_id,"sipPassword" =>$row->SipPassword));
			//		die;
			//	}
			//	break;
			//indoor
			case "DMT-7A":
				
			case "DMT-10A":
				
				$building		= substr($deviceID,2,3);
				$unit			= substr($deviceID,5,2);
				$room			= substr($deviceID,7,4);
				
				$building_id	= $this->BasicInfo_model->addBuilding($building);
				if($building_id=="")
				{
					echo json_encode(array("state" => 0, "ret" => "Database Error","deviceID" =>"","sipPassword" =>""));
					die;
				}
				
				$unit_id		= $this->BasicInfo_model->addUnit($building,$unit);
				if($unit_id=="")
				{
					echo json_encode(array("state" => 0, "ret" => "Database Error","deviceID" =>"","sipPassword" =>""));
					die;
				}
				
				$room_id		= $this->BasicInfo_model->addRoom($building,$unit,$room);
				if($room_id=="")
				{
					echo json_encode(array("state" => 0, "ret" => "Database Error","deviceID" =>"","sipPassword" =>""));
					die;
				}
				/*$isExsit		= $this->isExsitHouseNo($building,$unit,$room);
				if(!$isExsit)
				{
					echo json_encode(array("state1" => 0, "ret" => "100","deviceID" =>"","sipPassword" =>""));
					die;	
				}
				
				$building_id	= $this->BasicInfo_model->getBuildIdByBuilding($building);
				$unit_id		= $this->BasicInfo_model->getUnitIdByUnit($unit);
				$room_id		= $this->BasicInfo_model->getRoomIdByRoom($room);*/
				
				if( $this->isExsitDeviceIdByMac($mac) == "0" )
				{
					$row = $this->getDeviceIdByHouseNo($building,$unit,$room,"no");//top 1 
					
					if(empty($row))
					{
						$isSuccessFlag	= $this->Sip_model->addIndoorAndSip($building,$unit,$room,strtoupper($deviceType),"",$mac,"");
						
						if (!$isSuccessFlag)
						{
							echo json_encode(array("state" => 0, "ret" => "Database Error","deviceID" =>"","sipPassword" =>""));
							die;
						}
						$row =	$this->getDeviceIdByMac($mac,"indoor");
						echo json_encode(array("state" => 1,"ret" => "Success", "deviceID" => $row->device_id,"sipPassword" =>$row->SipPassword));
						die;
					}
					else
					{
						$row_mac = $this->getDeviceIdByHouseNo($building,$unit,$room,"yes");
						
						if(empty($row_mac->sipNo))
						{
							$isSuccessFlag	= $this->Sip_model->addIndoorAndSip($building,$unit,$room,strtoupper($deviceType),"",$mac,"");
							if (!$isSuccessFlag)
							{
								echo json_encode(array("state" => 0, "ret" => "Database Error","deviceID" =>"","sipPassword" =>""));
								die;
							}
							else
							{
								$row =	$this->getDeviceIdByMac($mac,"indoor");
								echo json_encode(array("state" => 1, "ret" => "Success","deviceID" => $row->device_id,"sipPassword" =>$row->SipPassword));
								die;
							}
						}
						else
						{
							$result =	$this->updateIndoorMacByDeviceID($row_mac->sipNo,$mac);
							if($result)
							{
								$row =	$this->getDeviceIdByMac($mac,"indoor");
								echo json_encode(array("state" => 1, "ret" => "Success","deviceID" => $row->device_id,"sipPassword" =>$row->SipPassword));
								die;
							}
						}
					}
				}
				else
				{

					$row	= $this->getDeviceIdByMac($mac,"indoor");
					if(	$row->building	== $building	&& 
						$row->unit		== $unit		&& 
						$row->room		== $room)
					{
						echo json_encode(array("state" => 1, "ret" => "Success", "deviceID" => $row->device_id,"sipPassword" =>$row->SipPassword));
						die;
					}
					else
					{
						$oldSipNo = $row->device_id;

						$maxSipNo = $this->Sip_model->getMaxSipNo($building,$unit,$room,"indoor")+1;
						$maxSipNo = strlen($maxSipNo)==1?"0".$maxSipNo:$maxSipNo;
						$newSipNo = "01".$building.$unit.$room.$maxSipNo;
						
						$result =	$this->Sip_model->updateIndoorAndSipByMac($building_id,$unit_id,$room_id,$oldSipNo,$newSipNo,$mac);
						if($result)
						{
							$row_mac1 = $this->getDeviceIdByMac($mac,"indoor");
							echo json_encode(array("state" => 1, "ret" => "Success", "deviceID" => $row_mac1->device_id,"sipPassword" =>$row_mac1->SipPassword));
							die;
						}
					}
				}
			break;
	
			case "DVP-40":break;
			case "DVP-50":break;
			case "DVP-100":break;
		
			case "DCP-100":break;
		
			case "GAT":break;
						
		}
	}
	private function isExsitHouseNo($building,$unit,$room)
	{
		$sql	="SELECT count(room) ct  from base_room_info A ,base_unit_info B,base_building_info C
				  WHERE  A.unit_id=B.unit_id AND B.building_id=C.building_id 
				  AND building='".$building."' and unit='".$unit."' and room='".$room."' ";
		$row	= $this->db->query($sql)->row();
		
		if($row->ct==0)
		{	
			return FALSE;
		}
		else
		{
			return TRUE;
		}
	}

	private function getDeviceIdByHouseNo($building,$unit,$room,$isHaveMAC)
	{
		$sql_condition="  ";
		
		if($isHaveMAC == "yes")
		{
			$sql_condition=" and A.mac is null ";
		}
		$sql_order=" ORDER BY A.sipNo ASC LIMIT 1 ";
		$sql	="SELECT A.sipNo,B.`password` from View_GetALLDeviceList A INNER JOIN device B
				  ON A.sipNo=B.`name` 
				  where deviceTypeNo='01' and building='".$building."' and unit='".$unit."' and room='".$room."' 
				  and  1=1 ";
			
		$sql_result=$sql.$sql_condition.$sql_order;
		
		$row	= $this->db->query($sql_result)->row();
		/*echo $this->db->last_query();
		die;*/
		return $row;
	}

	private function updateIndoorMacByDeviceID($deviceID,$mac)
	{
		$sql	="UPDATE  base_indoor_info set mac='".$mac."'  where device_id='".$deviceID."'";
		$result = $this->db->query($sql);
		return $result;
	}

	private function getDeviceIdByMac($mac,$deviceType)
	{
		switch($deviceType)
		{
			case "indoor":
				$sql = "SELECT device_id,SUBSTR(device_id,3,3) building,
					SUBSTR(device_id,6,2) unit,
					SUBSTR(device_id,8,4) room,
					B.`password` SipPassword 
					FROM base_indoor_info A INNER JOIN
					device B ON A.device_id=B.`name` where A.mac='".$mac."'";
				$row	= $this->db->query($sql)->row();
				
				break;
			case "mcClient":
				
				$sql = "SELECT deviceID as device_id,SUBSTR(A.deviceID,3,3) building,
					SUBSTR(A.deviceID,6,2) unit,
					SUBSTR(A.deviceID,8,4) room,
					mac,
					B.`password` SipPassword 
					FROM base_client_info A INNER JOIN
					device B ON A.deviceID=B.`name` where A.mac='".$mac."'";
				$row	= $this->db->query($sql)->row();
				
				break;
		}
		return $row;
		
	}
	
	private function isExsitDeviceIdByMac($mac)
	{
		$sql	="SELECT count(device_id) ct  FROM base_indoor_info A INNER JOIN
					device B ON A.device_id=B.`name` where A.mac='".$mac."'";
		$row	= $this->db->query($sql)->row();
		
		return $row->ct;
	}
	
	
	public function getSipGroup()
	{
		$groupType	= $this->input->get("groupType");
		if($groupType=="custom")
		{
			$sql	="SELECT id,name,IFNULL(members,'') members,IFNULL(transfer,'') transfer,remark from device_group 
					  where name not in ('9901000000000','9902000000000','9907000000000') ";
		}
		else
		{
			$sql	="SELECT A.id,A.name,IFNULL(A.members,'') members,IFNULL(A.transfer,'') transfer,SUBSTR(name,3,2) deviceType from device_group A where A.name  in ('9901000000000','9902000000000','9907000000000') ";
		}
		$result	= $this->db->query($sql)->result();
		
		echo json_encode(array("state" => 1, "ret" => $result));
	}
	
	public function addSipGroup()
	{
		$groupname	= $this->input->post("remark");
		$members	= $this->input->post("members");
		/*$groupType	= $this->input->post("groupType");*/
		
		$IsExsit	= $this->isExsitSipGroup("",$groupname);
		if ($IsExsit) 
		{
			echo json_encode(array("state" => 2, "ret" => "exsit"));
			die;
		}
		
		
		$maxSipNo	= $this->Sip_model->getMaxSipNo("","","","device_group")+1;
		
		$maxSipNo	= strlen($maxSipNo)==1?"0".$maxSipNo:$maxSipNo;
		$deviceID	= "990000000".$maxSipNo."00";
		$data = array(
			"name"		=> $deviceID,
			"members"	=> $members, 
			"remark"	=> $groupname
			);

		$result = $this->db->insert('device_group', $data);
		
		if ($result) 
		{
			echo json_encode(array("state" => 1, "ret" => "success"));
		}
	}
	public function editSipGroup()
	{
		$sipGroupId	= $this->input->post("id");
		$groupname		= $this->input->post("remark");
		$members		= $this->input->post("members");
		$IsExsit		= $this->isExsitSipGroup($sipGroupId,$groupname);
		if ($IsExsit) 
		{
			echo json_encode(array("state" => 2, "ret" => "exsit"));
			die;
		}
		
		$data = array(
			"members"	=> $members, 
			"remark"	=> $groupname
			);
		$this->db->where('id', $sipGroupId);
		$result = $this->db->update('device_group', $data);
		if ($result) 
		{
			echo json_encode(array("state" => 1, "ret" => "success"));
		}
	}
	public	function deleteSipGroup()
	{
		$sipGroupId = $this->input->post('sipGroupId');
		$device_id	 = $this->Sip_model->getSipGroupDeviceIdByID($sipGroupId);
		
		$this->db->trans_begin();
		$this->Sip_model->removeSipNoByID($device_id);
		$this->db->delete('device_group', array('id' => $sipGroupId));
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
	private function isExsitSipGroup($sipGroupId,$groupname)
	{
		$this->db->escape();
		$sql="SELECT  count(remark) count FROM device_group where remark='".$groupname."' and 1=1 ";
		if(!empty($sipGroupId))
		{
			$sql = $sql." and id !=".$sipGroupId;
		}
		
		$row = $this->db->query($sql)->row();
		if ($row->count == 0) 
		{
			return FALSE;
		} 
		else
		{
			return TRUE;
		}
	}
	
	
	public function getTransferList()
	{
		$rpp	= $this->input->get('rpp');
		$page	= $this->input->get('page');
		$rpp	= empty($rpp)	 ? RPP	: $this->input->get('rpp');
		$page	= empty($page)	 ? 1	: $this->input->get('page');

		$this->db->limit($rpp, ($page - 1) * $rpp);
		
		$sql="select A.id,A.name,IFNULL(B.username,'') username,A.transfer,A.remark from device A 
			   LEFT JOIN  base_user_info B ON A.name=B.sipNo 
			   where A.transfer is not null";
		$result = $this->db->query($sql)->result();
		
		//$newResult = array();
		//foreach($result as $k => $v)
		//{
		//	$newResult[$k]['name']		= $v->name;
		//	$newResult[$k]['username']	= $v->username;
		//	$newResult[$k]['transfer']	= $v->transfer;
		//	$newResult[$k]['remark']	= $v->remark;
		//}
		echo json_encode(array("state" => 1, "ret" => $result,"total" => $this->db->count_all_results('device')));
	}
	public function addTransfer()
	{
		$isAdd		= $this->input->post('isAdd');
		$sourceSip	= $this->input->post('sourceSip');
		$transfer	= $this->input->post('transfer');
		$remark		= $this->input->post('remark');
		if($isAdd=="true")
		{
			$isExsit		= $this->isExsitSipTransfer($sourceSip);
			if($isExsit)
			{
				echo json_encode(array("state" => 2, "ret" => "exsit"));
				die;	
			}
		}
		$data = array(
			'transfer'		=> $transfer,
			'remark'		=> $remark
			);
		
		$this->db->where('name', $sourceSip);
		$result = $this->db->update('device', $data);
		//echo $this->db->last_query();die;
		if ($result) {
			echo json_encode(array("state" => 1, "ret" => "success"));
		}
	}

	private function isExsitSipTransfer($sourceSip)
	{
		$this->db->escape();
		$sql="SELECT  count(1) count FROM device where name='".$sourceSip."' and  transfer is not null ";
		
		$row = $this->db->query($sql)->row();
		if ($row->count == 0) 
		{
			return FALSE;
		} 
		else
		{
			return TRUE;
		}
	}
	public	function deleteTransfer()
	{
		$id	= $this->input->post('id');
		$data = array(
			'transfer'		=> Null
			);
		
		$this->db->where('id', $id);
		$result = $this->db->update('device', $data);
		if ($result) {
			echo json_encode(array("state" => 1, "ret" => "success"));
		}
	}
	/*
	 * 固定响铃组
	 * indoor:9901000000000; outdoor9902000000000; guard:9907000000000
	*/
	public function editDefaultSipGroup()
	{
		$sipGroupId	= $this->input->post("id");
		$members		= $this->input->post("members");
		$transfer		= $this->input->post("transfer");
				
		$data = array(
			"members"	=> $members, 
			"transfer"	=> $transfer
			);
		$this->db->where('id', $sipGroupId);
		$result = $this->db->update('device_group', $data);
		if ($result) 
		{
			echo json_encode(array("state" => 1, "ret" => "success"));
		}
	}

}



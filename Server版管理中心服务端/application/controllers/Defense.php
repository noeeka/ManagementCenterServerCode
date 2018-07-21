<?php
/**
 * Created by PhpStorm.
 * User: Eric
 * Date: 2017/8/15
 * Time: 13:44
 */

//创建安防实体
class Defense extends CI_Controller
{
    public function __construct()
    {
        parent::__construct();
		getToken();
    }
	/**
	* User: Paul
	* Date: 2018/03/29
	* 获取安防布撤防记录列表
	*/
	public function getDefenseList(){
        $rpp	= $this->input->get('rpp');
        $page	= $this->input->get('page');
		$rpp	= empty($rpp)	 ? RPP	: $this->input->get('rpp');
		$page	= empty($page)	 ? 1	: $this->input->get('page');

		$fromIndex = ($page-1)*$rpp;
		$sql_condition=" limit ".$fromIndex.",".$rpp;
		$sql="SELECT defenseID,building,unit,room,
				zoneID,zoneType,sensorType,eventType,description, 
				left(FROM_UNIXTIME(datetime),19) datetime,datetime dt
				FROM defense_record ORDER BY datetime DESC ";
		$result = $this->db->query($sql.$sql_condition)->result();
		$total	 = count($this->db->query($sql)->result());
		echo json_encode(array("state" => 1, "ret" => $result,"total" =>$total));
	}

	/**
	* User: Paul
	* Date: 2018/03/29
	* 获取安防报警记录列表
	*/
	public function getDefenseAlarmList()
	{
        $rpp	= $this->input->get('rpp');
        $page	= $this->input->get('page');
		$rpp	= empty($rpp)	 ? RPP	: $this->input->get('rpp');
		$page	= empty($page)	 ? 1	: $this->input->get('page');

		$fromIndex = ($page-1)*$rpp;
		$sql_condition="limit ".$fromIndex.",".$rpp;
		$sql="SELECT defenseAlarmID,building,unit,room,
				 zoneID,zoneType,sensorType,eventType,alarmType,description, 
				left(FROM_UNIXTIME(datetime),19) datetime,datetime dt,
				ifnull(dealUser,'') dealUser,
				ifnull(left(FROM_UNIXTIME(dealTime),19),'') dealTime,dealTime dealtimes,
				ifnull(remark,'') remark  
				FROM defense_alarm_record ORDER BY datetime DESC  ";
		$result = $this->db->query($sql.$sql_condition)->result();
		$total	 = count($this->db->query($sql)->result());
		echo json_encode(array("state" => 1, "ret" => $result,"total" =>$total));
	}

	/**
	* User: Paul
	* Date: 2018/04/16
	* 获取安防报警未处理记录列表
	*/
	public function getAlarmListByNoFinish()
	{
		$sql="SELECT defenseAlarmID,building 
				FROM defense_alarm_record where isFinished=0 ORDER BY datetime DESC  ";
		$result = $this->db->query($sql)->result();
		$total	 = count($result);
		echo json_encode(array("state" => 1, "ret" => $result,"total" =>$total));
	}
	/**
	* User: Paul
	* Date: 2018/04/19
	* 通过报警ID获取安防报警记录明细
	*/
	public function getAlarmDetailByID()
	{
		$defenseAlarmID = $this->input->post("defenseAlarmID");
		$result = $this->db->get_where('defense_alarm_record', array('defenseAlarmID' => $defenseAlarmID))->row();
		$res['defenseAlarmID']=$result->defenseAlarmID;
		$res['building']=$result->building;
		$res['unit']=$result->unit;
		$res['room']=$result->room;
		$res['sensorType']=$result->sensorType;
		$res['datetime']=date("Y-m-d H:i:s",$result->datetime);
		$res['isFinished']=$result->isFinished;
		$res['dealTime']=date("Y-m-d H:i:s",$result->dealTime);
		$res['dealUser']=$result->dealUser;
		$res['remark']=$result->remark;
		$res['alarmType']=$result->alarmType;
		$res['eventType']=$result->eventType;
		$res['zoneType']=$result->zoneType;
		$res['zoneID']=$result->zoneID;

		echo json_encode(array("state" => 1, "ret" => $res));
	}

    //保存报警记录
    public function saveAlarm()
    {
        //验证登录token服务
        if (get_access_token() === false) {
            getMsg(TOKEN_ERROR);
        }
        $data = $this->input->post();
        $data["datetime"] =time();
        $flag = $this->db->insert("defense_alarm_record", $data);
        if ($flag) {
            echo json_encode(array("state" => 1, "ret"=>"Success"));
        } else {
            echo json_encode(array("state" => 0, "ret"=>"Error"));
        }
		
		
    }

    // 处理报警记录
    public function solveAlarm()
    {
		$defenseAlarmID	= $this->input->post("defenseAlarmID");
		$dealUser			= $this->input->post("dealUser");
		$remark				= $this->input->post("remark");
		
		$data = array(
			"isFinished"	=> 1,
			"dealUser"		=> $dealUser,
			"remark"		=> $remark,
			"dealTime"		=> time()
			);
		$isDealedFlag = $this->isDealedAlarm($defenseAlarmID);
		if($isDealedFlag)
		{
			
			$sql = "SELECT 
				left(FROM_UNIXTIME(ifnull(dealTime,'')),19) dealTime,
				dealTime dealtimes,
				ifnull(dealUser,'') dealUser,ifnull(remark,'') remark 
				FROM defense_alarm_record where defenseAlarmID=".$defenseAlarmID;
			$result = $this->db->query($sql)->result();
			echo json_encode(array("state" => 2, "ret" => "dealed","result"=>$result));
			die;
		}
		$this->db->where('defenseAlarmID', $defenseAlarmID);
		$result = $this->db->update('defense_alarm_record', $data);
		if ($result) 
		{
			echo json_encode(array("state" => 1, "ret" => "success"));
		}
    }
	private function isDealedAlarm($defenseAlarmID)
	{
		$sql="Select isFinished From defense_alarm_record where defenseAlarmID=".$defenseAlarmID;
		$row=$this->db->query($sql)->row();
		if($row->isFinished>0)
		{
			return TRUE;
		}
		else
		{
			return FALSE;
		}
	}

}
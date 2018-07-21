<?php
//测试控制器
class Test extends CI_Controller
{
    public function __construct()
    {
        parent::__construct();
    }

    //获取在线设备列表
    public function getOnlineDevices()
    {
        $baseDevices = array();
        $mqttDevices = array();
        $result=array();
        //获取设备视图列表
        foreach ($this->db->query("select * from View_GetALLDeviceList")->result() as $key => $value) {
            if (empty($value->building)) {
                $building = "000";
            } else {
                $building = $value->building;
            }


            if (empty($value->unit)) {
                $unit = "00";
            } else {
                $unit = $value->unit;
            }
            if (empty($value->room)) {
                $room = "0000";
            } else {
                $room = $value->room;
            }
            $baseDevices[$key]['id'] = $value->sipNo;
            $baseDevices[$key]['ip'] = $value->device_ip;
            $baseDevices[$key]['mac'] = $value->mac;
        }

        //获取MQTT在线设备服务
        $raw_data = _getHTTPS("http://" . EMQTTD_IP . ":" . EMQTTD_API_PORT . "/api/v2/nodes/emq@127.0.0.1/clients");
        $raw_data = json_decode($raw_data, true);
        $i = 0;
        for ($page = 1; $page <= $raw_data['result']['total_page']; $page++) {
            $raw_data = _getHTTPS("http://" . EMQTTD_IP . ":" . EMQTTD_API_PORT . "/api/v2/nodes/emq@127.0.0.1/clients?curr_page=" . $page . "&page_size=20");
            $raw_data = json_decode($raw_data, true);
            foreach ($raw_data['result']['objects'] as $key => $value) {
                $mqttDevices[$i]['id'] = end(explode("?", $value['client_id']));
                $mqttDevices[$i]['ip'] = $value['ipaddress'];
                $mqttDevices[$i]['mac'] = current(explode("?", $value['client_id']));
                $i++;
            }
        }
        foreach ($mqttDevices as $key_mqtt => $value_mqtt) {
            foreach ($baseDevices as $key_base => $value_base) {
                if ($value_mqtt['id'] == $value_base['id']) {
                    if($value_mqtt['ip']!=$value_base['ip'])
                    $result[] = array_merge($value_mqtt,array("status"=>4));
                }else{

                }
            }
        }
        print_r($result);
        die;

    }


    //通过房间号查询未被分配的设备 mac<>''
    private function getDeviceIdByHouseNo($building, $unit, $room, $isHaveMAC)
    {
        $sql_condition = "  ";

        if ($isHaveMAC == TRUE) {
            $sql_condition = " and A.mac='' ";
        }
        $sql_order = " ORDER BY A.sipNo ASC LIMIT 1 ";
        $sql = "SELECT A.sipNo,B.`password` from View_GetALLDeviceList A INNER JOIN device B
				  ON A.sipNo=B.`name` 
				  where deviceTypeNo='01' and building='" . $building . "' and unit='" . $unit . "' and room='" . $room . "' 
				  and  1=1 ";

        $sql_result = $sql . $sql_condition . $sql_order;

        $row = $this->db->query($sql_result)->row();
        /*echo $this->db->last_query();
        die;*/
        return $row;
    }

    //通过设备ID更新室内机mac
    private function updateIndoorMacByDeviceID($deviceID, $mac)
    {
        $sql = "UPDATE  base_indoor_info set mac='" . $mac . "'  where device_id='" . $deviceID . "'";
        $result = $this->db->query($sql);
        return $result;
    }

    //通过mac查询该设备信息
    private function getDeviceIdByMac($mac, $deviceType)
    {
        switch ($deviceType) {
            case "indoor":
                $sql = "SELECT device_id,SUBSTR(device_id,3,3) building,
					SUBSTR(device_id,6,2) unit,
					SUBSTR(device_id,8,4) room,
					B.`password` SipPassword 
					FROM base_indoor_info A INNER JOIN
					device B ON A.device_id=B.`name` where A.mac='" . $mac . "'";
                $row = $this->db->query($sql)->row();

                break;
            case "mcClient":

                $sql = "SELECT deviceID as device_id,SUBSTR(A.deviceID,3,3) building,
					SUBSTR(A.deviceID,6,2) unit,
					SUBSTR(A.deviceID,8,4) room,
					mac,
					B.`password` SipPassword 
					FROM base_client_info A INNER JOIN
					device B ON A.deviceID=B.`name` where A.mac='" . $mac . "'";
                $row = $this->db->query($sql)->row();

                break;
        }
        return $row;

    }

    //通过mac查询是否存在该设备
    private function isExsitDeviceIdByMac($mac)
    {
        $sql = "SELECT count(device_id) ct  FROM base_indoor_info A INNER JOIN
					device B ON A.device_id=B.`name` where A.mac='" . $mac . "'";
        $row = $this->db->query($sql)->row();

        return $row->ct;
    }


    public function getSipGroup()
    {
        $sql = "SELECT *  FROM device_group";
        $result = $this->db->query($sql)->result();

        echo json_encode(array("state" => 1, "ret" => $result));
    }

    //设置sip组，账号自动累加
    public function addSipGroup()
    {
        $groupname = $this->input->post("remark");
        $members = $this->input->post("members");
        $groupType = $this->input->post("groupType");

        $IsExsit = $this->isExsitSipGroup("", $groupname);
        if ($IsExsit) {
            echo json_encode(array("state" => 2, "ret" => "exsit"));
            die;
        }
        $this->load->model('Sip_model');
        $maxSipNo = $this->Sip_model->getMaxSipNo("", "", "", "", "", "", "device_group") + 1;

        $maxSipNo = strlen($maxSipNo) == 1 ? "0" . $maxSipNo : $maxSipNo;
        $deviceID = "990000000" . $maxSipNo . "00";

        $data = array(
            "name" => $deviceID,
            "members" => $members,
            "remark" => $groupname,
            "groupType" => $groupType
        );

        $result = $this->db->insert('device_group', $data);
        echo $this->db->last_query();
        die;
        if ($result) {
            echo json_encode(array("state" => 1, "ret" => "success"));
        }
    }

    public function editSipGroup()
    {
        $sipGroupId = $this->input->post("id");
        $groupname = $this->input->post("remark");
        $members = $this->input->post("members");
        $IsExsit = $this->isExsitSipGroup($sipGroupId, $groupname);
        if ($IsExsit) {
            echo json_encode(array("state" => 2, "ret" => "exsit"));
            die;
        }

        $data = array(
            "members" => $members,
            "remark" => $groupname
        );
        $this->db->where('id', $sipGroupId);
        $result = $this->db->update('device_group', $data);
        if ($result) {
            echo json_encode(array("state" => 1, "ret" => "success"));
        }
    }

    public function deleteSipGroup()
    {
        $sipGroupId = $this->input->post('sipGroupId');
        $this->db->delete('device_group', array('id' => $sipGroupId));
        echo json_encode(array("state" => 1, "ret" => "success"));
    }

    private function isExsitSipGroup($sipGroupId, $groupname)
    {
        $this->db->escape();
        $sql = "SELECT  count(remark) count FROM device_group where remark='" . $groupname . "' and 1=1 ";
        if (!empty($sipGroupId)) {
            $sql = $sql . " and id !=" . $sipGroupId;
        }

        $row = $this->db->query($sql)->row();
        if ($row->count == 0) {
            return FALSE;
        } else {
            return TRUE;
        }
    }

	public function trunckDefence(){
		$aa=$this->db->truncate('defense_alarm_record');
		$bb=$this->db->truncate('defense_record');
		if($aa && $bb){
			echo "ok";
		}
	}


}



<?php
//注册控制器
class Register extends CI_Controller
{
	public function __construct()
	{
		parent::__construct();
	}
	public function addClient()
	{
		$ip		= $this->input->post("ip");
		if(!isset($ip))
		{
			echo json_encode(array("state" => 0,"ret" => "fail"));
			die;
		}
		$row	= $this->db->query("select count(1) ct from base_client_info")->row();
		$count = $row->ct+1;
		switch(strlen($count))
		{
			case 1:$count="000".$count;	break;
			case 2:$count="00".$count;		break;
			case 3:$count="0".$count;		break;
			case 4:$count=$count;			break;
		}
		$deviceID="0000000".$count."00";
		//00 000 00 0001 00
		$data = array(
			'ip'		=> $ip,
			'deviceID'	=> $deviceID
			);

		$result = $this->db->insert('base_client_info', $data);
		if ($result) 
		{
			echo json_encode(array("state" => 1,"deviceID"=>$deviceID, "ret" => "success"));
		}
	}
}

<?php
//兑奖控制器
class Intercom extends CI_Controller
{
	public function __construct()
	{
		parent::__construct();
		//getToken();
	}
	public function getList()
	{
		$rpp	= $this->input->get('rpp');
		$page	= $this->input->get('page');
		$rpp	= empty($rpp)	 ? RPP	: $this->input->get('rpp');
		$page	= empty($page)	 ? 1	: $this->input->get('page');

		$fromIndex = ($page-1)*$rpp;
		$sql_condition=" limit ".$fromIndex.",".$rpp;

		$sql="SELECT * FROM base_intercom_info ORDER BY intercomID DESC ";
		foreach ($this->db->query($sql.$sql_condition)->result() as $key=>$value){
			$result[$key]['intercomID']=$value->intercomID;
			$result[$key]['caller']=$value->caller;
			$result[$key]['receiver']=$value->receiver;
			$result[$key]['caller_name']=$value->caller_name;
			$result[$key]['receiver_name']=$value->receiver_name;
			$result[$key]['duration']=$value->duration;
			$result[$key]['datetime']=date("Y-m-d H:i:s",$value->datetime);
			$result[$key]['state']=$value->state;
			$result[$key]['path']=$value->path;
		}
		echo json_encode(array("state" => 1, "ret" => $result,"total" =>$this->db->count_all_results('base_intercom_info')));
	}
	public function add()
	{
		if (!$_POST)
		{
			die;
		}
		$caller		= $this->input->post("caller");
		$receiver	= $this->input->post("receiver");
		$duration	= $this->input->post("duration");
		$state		= $this->input->post("state");
		$path		= $this->input->post("path");
		
		
		$this->load->model('Users_model');
		
		if(strlen($caller)!=13)
		{
			echo json_encode(array("state" => 0, "ret" => "caller length error"));
			die;
		}
		
		if(strlen($receiver)!=13)
		{
			echo json_encode(array("state" => 0, "ret" => "receiver length error"));
			die;
		}
		if(substr($caller,0,2)=="00")
		{
			$row			= $this->Users_model->getUserBySipNo($caller);
			$caller_name	= $row->username;
		}
		else
		{
			$caller_name	= $caller;
		}
		
		if(substr($receiver,0,2)=="00")
		{
			$row			= $this->Users_model->getUserBySipNo($receiver);
			$receiver_name	= $row->username;
		}
		else
		{
			$receiver_name	= $receiver;
		}
		$data = array(

			'caller'		=> $caller,
			'receiver'		=> $receiver,
			'caller_name'	=> $caller_name,
			'receiver_name'	=> $receiver_name,
			'duration'		=> $duration,
			'datetime'		=> time(),
			'state'			=> $state,
			'path'			=> $path
			);

		$result = $this->db->insert('base_intercom_info', $data);
		
		if ($result)
		{
			echo json_encode(array("state" => 1, "ret" => "success"));
		}
	}
}

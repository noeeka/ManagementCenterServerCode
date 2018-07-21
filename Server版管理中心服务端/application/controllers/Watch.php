<?php
//监控控制器
class Watch extends CI_Controller
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
		$sql="SELECT * FROM base_watch_info ORDER BY datetime DESC ";

		foreach ($this->db->query($sql.$sql_condition)->result() as $key=>$value){
			$result[$key]['watchID']=$value->watchID;
			$result[$key]['caller']=$value->caller;
			$result[$key]['receiver']=$value->receiver;
			$result[$key]['duration']=$value->duration;
			$result[$key]['datetime']=date("Y-m-d H:i:s",$value->datetime);
			$result[$key]['state']=$value->state;
			$result[$key]['path']=$value->path;
		}
		echo json_encode(array("state" => 1, "ret" => $result,"total" =>$this->db->count_all_results('base_watch_info')));
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
		$data = array(
			'caller'	=> $caller,
			'receiver'	=> $receiver,
			'duration'	=> $duration,
			'datetime'	=> time(),
			'state'		=> $state,
			'path'		=> $path
			);

		$result = $this->db->insert('base_watch_info', $data);
		if ($result) 
		{
			echo json_encode(array("state" => 1, "ret" => "success"));
		}
	}
}



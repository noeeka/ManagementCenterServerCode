<?php
//角色控制器
class Role extends CI_Controller
{

	public function __construct()
	{
		parent::__construct();
		
	}
	public function getRoleList()
	{
		$rpp	= $this->input->get('rpp');
		$page	= $this->input->get('page');
		$rpp	= empty($rpp)	 ? RPP	: $this->input->get('rpp');
		$page	= empty($page)	 ? 1	: $this->input->get('page');
				
		$fromIndex = ($page-1)*$rpp;
		$sql_condition="limit ".$fromIndex.",".$rpp;
		$sql="select * from base_role_info  order by roleID desc ";
		
		$this->db->escape();
		$result = $this->db->query($sql.$sql_condition)->result();
		echo json_encode(array("state" => 1, "ret" => $result,"total" =>$this->db->count_all_results('base_role_info')));

	}
	
	public function add()
	{
		$rolename	= $this->input->post("roleName");
		$remark		= $this->input->post("remark");
		$IsExsit	= $this->isExsitRole("",$rolename);
		if ($IsExsit) 
		{
			echo json_encode(array("state" => 2, "ret" => "exsit"));
			die;
		}
		$data = array(
			"roleName"	=> $rolename, 
			"remark"	=> $remark
			);

		$result = $this->db->insert('base_role_info', $data);
		if ($result) 
		{
			echo json_encode(array("state" => 1, "ret" => "success"));
		}
	}
	
	public function edit()
	{
		$roleid		= $this->input->post("roleID");
		$rolename	= $this->input->post("roleName");
		$remark		= $this->input->post("remark");
		$IsExsit	= $this->isExsitRole($roleid,$rolename);
		if ($IsExsit) 
		{
			echo json_encode(array("state" => 2, "ret" => "exsit"));
			die;
		}
		$data = array(
			"roleName"	=> $rolename,
			"remark"	=> $remark
			);
		$this->db->where('roleID', $roleid);
		$result = $this->db->update('base_role_info', $data);
	
		if ($result) 
		{
			echo json_encode(array("state" => 1, "ret" => "success"));
		}
	}
	private function isExsitRole($roleid,$rolename)
	{
		$this->db->escape();
		$sql="SELECT  count(roleID) count FROM base_role_info where   roleName='".$rolename."' and 1=1 ";
		if($roleid!="")
		{
			$sql_condition  =" and roleID<> ".$roleid."";
		}
		$row = $this->db->query($sql.$sql_condition)->row();
		if ($row->count == 0) 
		{
			return FALSE;
		} 
		else
		{
			return TRUE;
		}
	}
	public	function delete()
	{
		$roleID = $this->input->post('roleID');
		$this->db->escape();
		$this->load->model('Users_model');
		$isExsit = $this->Users_model->isExsitUserByRoleID($roleID);
		if ($isExsit) 
		{
			echo json_encode(array("state" => 2, "ret" => "role is used"));
			die;
		}
		$this->db->delete('base_role_info',	array('roleID' => $roleID));
		echo json_encode(array("state" => 1, "ret" => "success"));
	}

}

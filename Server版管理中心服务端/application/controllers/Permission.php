<?php
//权限控制器
class Permission extends CI_Controller
{	
	public function __construct()
	{
		parent::__construct();
		
	}
	public function getPermissionByUser()
	{
		$username	= $this->input->post("username");
		$this->load->model('Users_model');
		$row		= $this->Users_model->getPermissionByUser($username);
		echo json_encode(array("state" => 1, "ret" => $row));
		die;
	}
	public function getPermissionByRoleID()
	{
		$roleID	= $this->input->post("roleID");
		$sql	="select roleID,ifnull(permission,'') permission from base_permission_info where roleID= ".$roleID;
		
		$result=array();
		$this->db->escape();
		
		$result = $this->db->query($sql)->result();
		echo json_encode(array("state" => 1, "ret" => $result));

	}
	public function edit()
	{
		$roleID			= $this->input->post("roleID");
		$permission	= $this->input->post("permission");
		
		$data = array(
			"roleID"		=> $roleID,
			"permission"	=> $permission 
			);
		$IsExsit		= $this->isExsitRolePermission($roleID);
		if ($IsExsit) 
		{
			$this->db->where('roleID', $roleID);
			$result = $this->db->update('base_permission_info', $data);
			if ($result) 
			{
				echo json_encode(array("state" => 1, "ret" => "success"));
				die;
			}
		}
		$result = $this->db->insert('base_permission_info', $data);
		if ($result) 
		{
			echo json_encode(array("state" => 1, "ret" => "success"));
			die;
		}
		
	}
	private function isExsitRolePermission($roleID)
	{
		$this->db->escape();
		$row = $this->db->query("SELECT  count(roleID) count FROM base_permission_info where roleID=".$roleID)->row();
		if ($row->count == 0) 
		{
			return FALSE;
		} 
		else
		{
			return TRUE;
		}
	}
}

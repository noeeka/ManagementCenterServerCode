<?php
//用户信息model
class Users_model extends CI_Model
{
    public function __construct()
    {
        parent::__construct();
    }

    public function get_users_list($offset = 1, $rpp = 20)
    {
        $query = $this->db->query('SELECT * FROM base_user_info order by id LIMIT ' . ($offset - 1) * $rpp . ',' . $rpp);
        return $query->result();
    }
	public function getPermissionByUser($username)
	{
		$sql		="SELECT A.username,ifnull(B.permission,'') permission, 
					  A.sipNo,A.sipPassword 
					  From base_user_info A LEFT JOIN  base_permission_info B
					  ON A.roleID=B.roleID WHERE username='".$username."'";
		
		if(strtoupper($username)==SUPER || strtoupper($username)==ADMIN)
		{
			echo json_encode(array("state" => 2, "ret" => "super is all permission"));
			die;
		}
		$this->db->escape();
		$row = $this->db->query($sql)->row();
		return  $row;
	}
	public function getSipInfoBySuperUser($username)
	{
		$sql ="SELECT A.username,A.password,A.sipNo,A.sipPassword,
		'intercom,notice,message,bookingDetail,bookingManage,alarm,infoSearch,infoEdit,online' permission 
		 From base_user_info A  WHERE username='".$username."'";
		$this->db->escape();
		$row = $this->db->query($sql)->row();
		return  $row;
	}
	public function getUserBySipNo($sipNo)
	{
		$this->db->escape();
		$row   = $this->db->query("SELECT  IFNULL(username,'') username FROM base_user_info where sipNo='".$sipNo."'")->row();
		return $row;
		 
	}
	public function isExsitUserByRoleID($roleID)
	{
		$this->db->escape();
		$row = $this->db->query("SELECT  count(username) ct FROM base_user_info where roleID=".$roleID)->row();
		
		if ($row->ct == 0) 
		{
			return FALSE;
		} 
		else
		{
			return TRUE;
		}
	}
	
}
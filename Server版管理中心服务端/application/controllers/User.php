
<?php

class User extends CI_Controller
{

    public function __construct()
    {
        parent::__construct();
		
    }
	private function createTaken($username)
	{
		$key = TOKEN;
		$token = array(
			"iss" => "www.systec.com",
			"username" => $username
			);

		/**
		 * IMPORTANT:
		 * You must specify supported algorithms for your application. See
		 * https://tools.ietf.org/html/draft-ietf-jose-json-web-algorithms-40
		 * for a list of spec-compliant algorithms.
		 */
		$jwt = \Firebase\JWT\JWT::encode($token, $key);
		return $jwt;
		//$decoded = \Firebase\JWT\JWT::decode($jwt, $key, array('HS256'));
	}
    public function login(){

        $username = $this->input->post("username");
        $password = md5($this->input->post("password"));
		
		
		$_SESSION['token'] =$this->createTaken($username);
		$token	= $_SESSION['token'];
        //$token=base64_encode(json_encode(array("username"=>$username,"salt"=>SALT)));
		
		$this->db->escape();
		$this->load->model('Users_model');
		$IsExsit	= $this->isExsitUser($username);
		$row		= $this->Users_model->getSipInfoBySuperUser($username);
		
		$admin_pwd = $IsExsit==TRUE ? $row->password : ADMIN_PASSWORD;
		

		if((strtoupper($username)==SUPER && $password==PASSWORD) || (strtoupper($username)==ADMIN && $password==$admin_pwd))
		{
			$isExsit	= $this->isExsitUser($username);
			
			if(!$isExsit)
			{
				$isSuccess = $this->addSuperUserSip($username,$password,"super info");
				if(!$isSuccess)
				{
					$ret = array("state" => 2, "ret" =>"create super fail");
					echo json_encode($ret);
					die;
				}
			}
			setcookie('username', $username, time() + 864000000);
			
			$row	= $this->Users_model->getSipInfoBySuperUser($username);
			$ret = array("state" => 1, "ret" =>$row,"token"=>$token);
			echo json_encode($ret);
			die;
		}
		
		$row = $this->db->query('SELECT  count(1) ct FROM base_user_info where MD5(username)="'.md5($username).'" and password="'.$password.'"')->row();
		if ($row->ct==0) 
		{
            $ret = array("state" => 0, "ret" => "Login fail");
            echo json_encode($ret);

        }
		else
		{
			
			$row	= $this->Users_model->getPermissionByUser($username);
			
            setcookie('username', $username, time() + 864000000);
			$ret = array("state" => 1, "ret" =>$row,"token"=>$token);
            echo json_encode($ret);
        }
    }
	public function logout()
	{
		if (isset($_SESSION['token'])) 
		{
			unset($_SESSION['token']);
			echo json_encode(array("state" => 1, "ret" => "logoutSuccess"));
			die;
		} 
		else 
		{
			echo json_encode(array("state" => 0, "ret" => "logoutFail"));
			die;
		}
	}
	private function addSuperUserSip($username,$password,$remark)
	{
		$this->load->model('Sip_model');
		$maxSipNo	= $this->Sip_model->getMaxSipNo("","","","mcUser")+1;
		$maxSipNo	= strlen($maxSipNo)==1?"0".$maxSipNo:$maxSipNo;
		$deviceID	= "000000000".$maxSipNo."00";
		$privilege = strtoupper($username)==ADMIN ? 0:1;
		
		$user_data = array(
			"roleID"		=> 0,
			"username"		=> $username, 
			"password"		=> $password,
			"remark"		=> $remark,
			"sipNo"			=> $deviceID,
			"sipPassword"	=> $deviceID,
			"privilege"		=> $privilege
			);

		$device_data=array(
			'name'		=> $deviceID,
			'password'	=> $deviceID
			);
		
		$this->db->trans_begin();
		$this->db->insert('base_user_info',$user_data);
		$this->db->insert('device',$device_data);
		
		if ($this->db->trans_status() === FALSE)
		{
			$this->db->trans_rollback();
			return FALSE;
			die;
		}
		else
		{
			$this->db->trans_commit();
			return true;
			die;
		} 
	}
    public function add()
    {
		$roleID		= $this->input->post("roleID");
		$username	= $this->input->post("username");
		$password	= $this->input->post("password");
		$remark		= $this->input->post("remark");
		if(check_is_chinese($username))
		{
			echo json_encode(array("state" => 4, "ret" => "username is chinese"));
			die;
		}
		if(strtoupper($username)==SUPER || strtoupper($username)==ADMIN)
		{
			echo json_encode(array("state" => 3, "ret" => "super is admin,don't create this user"));
			die;
		}
		$IsExsit	= $this->isExsitUser(strtolower($username));
		if ($IsExsit) 
		{
			echo json_encode(array("state" => 2, "ret" => "exsit"));
			die;
		}
		$this->load->model('Sip_model');
		$maxSipNo	= $this->Sip_model->getMaxSipNo("","","","mcUser")+1;
		$maxSipNo	= strlen($maxSipNo)==1?"0".$maxSipNo:$maxSipNo;
		$deviceID	= "000000000".$maxSipNo."00";
        $user_data = array(
			"roleID"		=> $roleID,
			"username"		=> strtolower($username), 
			"password"		=> md5($password),
			"remark"		=> $remark,
			"sipNo"			=> $deviceID,
			"sipPassword"	=> $deviceID
		);

		$device_data=array(
			'name'		=> $deviceID,
			'password'	=> $deviceID
			);
		
		$this->db->trans_begin();
		$this->db->insert('base_user_info',$user_data);
		$this->db->insert('device',$device_data);
		
		if ($this->db->trans_status() === FALSE)
		{

			$this->db->trans_rollback();
			echo json_encode(array("state" => 0, "ret" => "fail"));
			die;
		}
		else
		{

			$this->db->trans_commit();
			echo json_encode(array("state" => 1, "ret" => "success"));
			die;
		}  
    }
	
	public function edit()
	{
		$userid		= $this->input->post("user_id");
		//$roleID		= $this->input->post("roleID");
		$password	= $this->input->post("password");

		$remark		= $this->input->post("remark");

		if(empty($password))
		{
			//"roleID"	=> $roleID,
			$data = array(
				
				"remark"	=> $remark
				);
		}
		else
		{
			//"roleID"	=> $roleID,
			$data = array(

				"password"	=> md5($password),

				"remark"	=> $remark
				);
		}
		
		$this->db->where('user_id', $userid);
		$result = $this->db->update('base_user_info', $data);
		if ($result) 
		{
			echo json_encode(array("state" => 1, "ret" => "success"));
		}
	}
	private function isExsitUser($username)
	{
		$this->db->escape();
		$row = $this->db->query("SELECT  count(username) count FROM base_user_info where username='".$username."'")->row();
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
		$user_id = $this->input->post('user_id');	
		
		$this->load->model('BasicInfo_model');
		$deviceID = $this->BasicInfo_model->getUserDeviceIdByID($user_id);

		$this->db->trans_begin();
		
		$this->db->delete('base_user_info', array('user_id' => $user_id));
		$this->db->delete('device', array('name' => $deviceID));
		$this->load->model('Sip_model');
		$this->Sip_model->removeSipNoByID($deviceID);
		if ($this->db->trans_status() === FALSE)
		{
			$this->db->trans_rollback();
			echo json_encode(array("state" => 0, "ret" => "Database Error"));
			die;
		}
		else
		{
			$this->db->trans_commit();
			echo json_encode(array("state" => 1, "ret" => "Success"));
			die;
		} 
	}
	public function getUserList()
    {
		$rpp		= $this->input->get('rpp');
		$page		= $this->input->get('page');
		$rpp		= empty($rpp)	 ? RPP	: $this->input->get('rpp');
		$page		= empty($page)	 ? 1	: $this->input->get('page');
	
		$fromIndex = ($page-1)*$rpp;
		$sql_condition="limit ".$fromIndex.",".$rpp;
		$sql="select A.user_id,A.username,A.remark,B.roleID,B.roleName from base_user_info A left join base_role_info B 
			  ON A.roleID=B.roleID where privilege=0 ORDER BY A.roleID asc ";
		
		$this->db->escape();
		$result = $this->db->query($sql.$sql_condition)->result();
		$total	 = count($this->db->query($sql)->result());
		echo json_encode(array("state" => 1, "ret" => $result,"total" =>$total));

    }
	public function getUserBySipNo()
	{
		$this->db->escape();
		$sipNo = $this->input->get('sipNo');
		$this->load->model('Users_model');
		$row   = $this->Users_model->getUserBySipNo($sipNo);
		echo json_encode(array("state" => 1, "ret" => $row->username==null?"":$row->username));
		 
	}
}


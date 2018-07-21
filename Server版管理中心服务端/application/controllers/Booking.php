<?php
/**
 * Created by PhpStorm.
 * User: Eric
 * Date: 2017/8/15
 * Modifier: 
 * Description:
 */

//创建预订实体
class Booking extends CI_Controller
{
    public function __construct()
    {
        parent::__construct();
		//getToken();
    }
	/**
	* User: Paul
	* Date: 2018/03/16
	* 通过某天获取各种活动的预订率统计
	*/
	public function getActBookedPercertByDay()
	{
		$day	= $this->input->post("day");
		$sql="select A.act_info_id,B.name,open_date,time_from,time_to,
				ifnull(CT,0) CT,B.max, concat(round((ifnull(CT,0)/B.max)*100,2),'%') per 
				from 
				(
					select act_info_id, 
				   COUNT(act_info_id) CT
					from booking_act_record
					group by act_info_id
				) A 
				right join booking_act_info B on A.act_info_id=B.act_info_id 
				where open_date='".$day."'";
		$result = $this->db->query($sql)->result();
		echo json_encode(array("state" => 1, "ret" => $result));
	}
	/**
	* User: Paul
	* Date: 2018/03/13
	* 通过时间段关闭资源
	*/
	public function closeResByTime()
	{
		$date			= $this->input->post("date");
		$res_info_id	= $this->input->post("res_info_id");
		$time_from		= $this->input->post("time_from");
		$time_to		= $this->input->post("time_to");
		$user			= $this->input->post("user");
		if (strtotime(date("Y-m-d") . " " . $time_from) >= strtotime(date("Y-m-d") . " " . $time_to)) 
		{
			echo json_encode(array("state" => 2, "ret" => "Time from should greater than Time to"));
			die;
		}
		
		$this->load->model('booking_model');
		
		$isInvalidResFlag = $this->booking_model->isInvalidResById($res_info_id,$time_from,$time_to);

		if($isInvalidResFlag)
		{
			echo json_encode(array("state"=>3,"ret"=>"InvalidRes"));
			die;
		}
		
		$isBookedClosed = $this->booking_model->chkBookedOrClosed($res_info_id,$date,$time_from,$time_to);
		if($isBookedClosed)
		{
			echo json_encode(array("state"=>0,"ret"=>"exsit"));
			die;
		}

		$now	= time();
		$data	= array("res_info_id" => $res_info_id, "booking_date" => strtotime($date), 
			"time_from"   => $time_from, "time_to" => $time_to, "status" => BOOKING_CLOSED,
			"user" => $user, "datetime" => $now );

		if ($this->booking_model->saveBookingRecord($data))
		{
			echo json_encode(array("state" => 1, "ret" => "Success"));
			die;
		} 
		
	}
	/**
	* User: Paul
	* Date: 2018/03/14
	* 根据选中开放资源
	*/
	public function openResById()
	{
		$res_record_id	= $this->input->post("res_record_id");
		$this->load->model('booking_model');
		if ($this->booking_model->deleteResRecord($res_record_id))
		{
			echo json_encode(array("state" => 1, "ret" => "Success"));
			die;
		} 
	}
	/**
	* User: Paul
	* Date: 2018/03/13
	* 获取资源列表
	*/
	public function getResInfoList()
	{
		$rpp	= $this->input->get('rpp');
		$page	= $this->input->get('page');
		$rpp	= empty($rpp)	 ? RPP	: $this->input->get('rpp');
		$page	= empty($page)	 ? 1	: $this->input->get('page');
		$fromIndex = ($page-1)*$rpp;
		$sql_condition="limit ".$fromIndex.",".$rpp;
		$sql="select res_info_id,name,type,time_from,time_to,max_num from booking_res_info ";
		$result = $this->db->query($sql.$sql_condition)->result();
		$total	 = count($this->db->query($sql)->result());
		echo json_encode(array("state" => 1, "ret" => $result,"total" =>$total));
	}
	/**
	* User: Paul
	* Date: 2018/03/13
	* 获取资源预订记录列表
	*/
	public function getResBookedList()
	{
		$rpp	= $this->input->get('rpp');
		$page	= $this->input->get('page');
		$rpp	= empty($rpp)	 ? RPP	: $this->input->get('rpp');
		$page	= empty($page)	 ? 1	: $this->input->get('page');
		$fromIndex = ($page-1)*$rpp;
		$sql_condition="limit ".$fromIndex.",".$rpp;
		$sql="select B.name,
			A.user,
			concat(left(A.user,3),'栋',substring(A.user, 4, 2),'单元',right(A.user,4),'室') user,

			left(A.user,3) buildingNo,
			substring(A.user, 4, 2) unitNo,
			right(A.user,4) roomNo,

			left(FROM_UNIXTIME(A.booking_date),10) day,A.time_from,A.time_to,
			left(FROM_UNIXTIME(A.datetime),16) datetime from booking_res_record A 
			left join booking_res_info B
				
			on A.res_info_id=B.res_info_id 
			where A.status<>1 order by A.datetime desc   ";
		$result = $this->db->query($sql.$sql_condition)->result();
		$total	 = count($this->db->query($sql)->result());
		echo json_encode(array("state" => 1, "ret" => $result,"total" =>$total));
	}
	/**
	* User: Paul
	* Date: 2018/03/13
	* 添加预订资源
	*/
	public function addRes()
	{
		$name		= $this->input->post("name");
		$type		= $this->input->post("type");
		$time_from = $this->input->post("time_from");
		$time_to	= $this->input->post("time_to");
		$max_num	= $this->input->post("max_num");
		$min_time	= $this->input->post("min_time");
		$buffer		= $this->input->post("buffer");
		
		$this->load->model('Booking_model');
		$exsit = $this->Booking_model->isExsitResName("booking_res_info",$name);
		if($exsit)
		{
			echo json_encode(array("state" => 3, "ret" => "exsit"));
			die;
		}
		if (strtotime(date("Y-m-d") . " " . $time_from) >= strtotime(date("Y-m-d") . " " . $time_to)) 
		{
			echo json_encode(array("state" => 2, "ret" => "开始时间必须小于结束时间"));
			die;
		}
		$data=array(
			'name'		=>$name,
			'type'		=>$type,
			'time_from'	=>$time_from,
			'time_to'	=>$time_to,
			'max_num'	=>$max_num,
			'min_time'	=>$min_time,
			'buffer'	=>$buffer
		);
		$result = $this->db->insert("booking_res_info", $data);
		if($result)
		{
            //添加消息通知服务，文案待定
			sendMQTTMSG("Booking",'{"cate":"booking","subcate":"notice","title":"有新的预定资源","datetime":'.time().'}');
			echo json_encode(array("state" => 1, "ret" => "success"));
		}
		else
		{	
			echo json_encode(array("state" => 0, "ret" => "fail"));
		}
	}
	/**
	* User: Paul
	* Date: 2018/03/13
	* 删除预订资源
	*/
	public function deleteRes()
	{
		$res_info_id		= $this->input->post("res_info_id");
		$this->load->model("booking_model");
			
		$isResRecord	= $this->booking_model->isResRcdCountById($res_info_id);
		$isResExpire	= $this->booking_model->isResRecordExpireById($res_info_id);
		
		if($isResRecord && !$isResExpire)
		{
			echo json_encode(array("state" => 2, "ret" => "the res is booked!"));
			die;
		}
		$this->db->trans_begin();
		$this->db->delete("booking_res_info",  array('res_info_id'=>$res_info_id));
		$this->db->delete("booking_res_record",array('res_info_id'=>$res_info_id));
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

	/**
	* User: Paul
	* Date: 2018/03/08
	* 根据时间段获取资源预订明细信息
	*/
	public function getResBookingDetailByTime()
	{
		$date			= $this->input->post("date");
		$res_info_id	= $this->input->post("res_info_id");
		$time_from		= $this->input->post("time_from");
		$time_to		= $this->input->post("time_to");
		
		$this->load->model('booking_model');
		$result=$this->booking_model->getResBookingDetailByTime($date,$res_info_id,$time_from,$time_to);
		//这里后续取基础信息业主相关信息
		echo json_encode(array("state" => 1, "ret" => $result));
	}
	/**
	* User: Paul
	* Date: 2018/02/11
	* 根据资源ID获取资源预订一览表
	*/
	public function getResInfoStatusById()
	{

		$res_info_id	= $this->input->post("res_info_id");
		$location		= $this->input->post("location");
		$date			= $this->input->post("date");
		
		$result			= array();
		 //加载预订模型
		$this->load->model('booking_model');
		$all_result		= $this->booking_model->getResBookedById($res_info_id,$location,$date);
		
		//$this->load->helper('booking');
		foreach($all_result as $k=>$v)
		{
			$res_record_id			= $v->res_record_id;
			$minutes_from			= current(explode(":", $v->time_from))*60+end(explode(":", $v->time_from));
			$time_from				= $v->time_from;
			$time_from_minutes		= $minutes_from;
			
			$minutes_to				= current(explode(":", $v->time_to))*60+end(explode(":", $v->time_to));
			$time_to				= $v->time_to;
			$time_to_minutes		= $minutes_to;
			
			$status					= $v->status;
			$result[$k] = array(
				"res_record_id"		=>$res_record_id,
				"time_from"			=>$time_from, 
				"time_from_minutes"	=>$time_from_minutes,
				"time_to"			=>$time_to, 
				"time_to_minutes"	=>$time_to_minutes,
				"status"			=>$status);
		}
		
		echo json_encode(array("state" => 1, "ret" => $result));
	}


	/**
	* User: Paul
	* Date: 2018/02/11
	* 获取预订资源信息
	*/
	public function getResourceInfo()
	{
		$sql="select res_info_id,name,min_time from booking_res_info";
		$res=$this->db->query($sql)->result();
		echo json_encode(array("state" => 1, "ret" => $res));
	}
	/**
	* User: Paul
	* Date: 2018/02/09
	* 获取某用户某月的预订信息提示
	*/
	public function getBookingInfoByMonth()
	{
		$month		= $this->input->post("month");
		$location	= $this->input->post("location");
		$sql="select day from (
				select 
				left(FROM_UNIXTIME(booking_date),7) mon,
				left(FROM_UNIXTIME(booking_date),10) day from booking_res_record  
				where user='".$location."' 
				group by day 
			) B where mon='".$month."'
			union
			
			select day from (
				select 
				SUBSTRING(B.open_date,1,7) mon,
				B.open_date day from booking_act_record  A 
				LEFT JOIN booking_act_info B ON A.act_info_id=B.act_info_id
				where A.user='".$location."' 
				group by day 
			) B where mon='".$month."'";
		
		$res=$this->db->query($sql)->result();
		
		echo json_encode(array("state" => 1, "ret" => $res));
	}
	
    /**
     * 预订某资源
     */
    public function acceptRes()
	{
		
        $data			= $this->input->post();
		$res_info_id	= $data["id"];
		$dateStr		= $data["date"];//$dateStr =2018-03-25日期格式
		 
		
        $timeFrom		= $data["time_from"];
        $timeTo			= $data["time_to"];
        $location		= $data["location"];
				
        //加载预订模型
        $this->load->model('booking_model');

        $this->load->helper('booking');
        //获取最预定时间
		$res_info_result	= $this->db->get_where('booking_res_info',array("res_info_id"=>$res_info_id))->row();
		$res_info_type		= $res_info_result->type;
		$maxNum				= $res_info_result->max_num;
		$minTimeInterval	= $res_info_result->min_time;
		
		$isClosed = $this->booking_model->chkIsClosed($res_info_id, date('Y-m-d',strtotime($dateStr)), $timeFrom, $timeTo);
		if($isClosed)
		{
			echo json_encode(array("state" => 8, "ret" => "The current time is closed"));
			die;
		}
		//做一些基本的验证
		if (strtotime(date("Y-m-d") . " " . $timeFrom) > strtotime(date("Y-m-d") . " " . $timeTo)) 
		{
			echo json_encode(array("state" => 2, "ret" => "Time from should greater than Time to"));
			die;
		}

		if (strtotime($dateStr . " " . $timeFrom) < strtotime($dateStr . " " . $res_info_result->time_from) ||
			strtotime($dateStr . " " . $timeTo) > strtotime($dateStr . " " . $res_info_result->time_to))
		{
			echo json_encode(array("state" => 3, "ret" => "Time Range is fatal"));
			die;
		}

		if (((strtotime(date("Y-m-d") . " " . $timeTo) - strtotime(date("Y-m-d") . " " . $timeFrom)) / 60) < $minTimeInterval) 
		{
			echo json_encode(array("state" => 4, "ret" => "The minimal time inteval is not availble"));
			die;
		}

		if (strtotime(date('Y-m-d',strtotime($dateStr)) . " " . $timeFrom) < time())
		{
			echo json_encode(array("state" => 5, "ret" => "Time from or Time to should not less than current time"));
			die;
		}
		
		$timeArray			= getTimeArrayByTime($timeFrom, $timeTo,BOOKING_MIN_TIME);
        // 获取起始时间列表
        foreach($timeArray as $k => $v)
        {
            $timeFromArray[$k] = $v["timeFrom"];
        }
						
		if ($res_info_type == RES_MONOMER)
		{
			// 独立资源，判断是否可以预订
			$bookedFlag = $this->booking_model->chkBookedOrClosed($res_info_id, date('Y-m-d',strtotime($dateStr)), $timeFrom, $timeTo);
			if (!$bookedFlag)
			{
				$now = time();
				$recordData = array("res_info_id" => $res_info_id, "booking_date" => strtotime($dateStr), 
					"time_from" => $timeFrom, "time_to" => $timeTo, 
					"user" => $location, "datetime" => $now, "status" => BOOKING_BOOKED);

				if ($this->booking_model->saveBookingRecord($recordData))
				{
					echo json_encode(array("state" => 1, "ret" => "Success"));
					die;
				} 
				else 
				{
					echo json_encode(array("state" => 10, "ret" => "Database Error"));
					die;
				}
			} 
			else 
			{
				echo json_encode(array("state" => 7, "ret" => "自己已预订"));
				die;
			}
		} 
		else if ($res_info_type == RES_SHARE) 
		{
            // 先判断是否自己已预订
			$bookedFlag = $this->booking_model->chkBookedSelf($res_info_id, date('Y-m-d',strtotime($dateStr)), $timeFrom, $timeTo, $location);
            if ($bookedFlag)
            {
                // 自己已预订
				echo json_encode(array("state" => 7, "ret" => "自己已预订"));
                die;
            }
            // 判断当前资源是否关闭和已满 add by paul 2018-03-13
			$bookableFlag =  $this->booking_model->chkBookable($res_info_id, strtotime($dateStr), $timeFromArray);
			if (!$bookableFlag)
            {
				$this->db->trans_begin();

                //保存共享资源预订记录
                $recordData	= array();
                $now			= time();
				$recordData = array("res_info_id" => $res_info_id, "booking_date" => strtotime($dateStr), "time_from" => $timeFrom, "time_to" => $timeTo, "user" => $location, "datetime" => $now, "status" => BOOKING_BOOKED);
                if ($this->booking_model->saveBookingRecord($recordData))
                {
					//获取到交集
					$statusResult = $this->booking_model->getBookingStatus($res_info_id, strtotime($dateStr), $timeFromArray);
					
                    foreach ($statusResult as $k => $v)
                    {
                        $statusId	= $v->res_status_id;                        
                        $timeFrom	= $v->time_from;
						$key		= array_search($timeFrom, $timeFromArray);//从后面数组中搜索前面$timeFrom
						unset($timeFromArray[$key]);//从$timeFromArray删除搜索到的数组

                        // 预订之后修改状态
						$this->booking_model->updateBookingStatus($statusId);
						
						//echo $this->db->last_query();
                    }
                    // 取不到交集，即可插入新状态数据
                    $addBookingStatusData = array();
                    foreach($timeFromArray as $k=> $v)
                    {
                        $timeFromTime	= strtotime($v);
						$timeToStr		= date("H:i", $timeFromTime + BOOKING_MIN_TIME*60);
                        if ($maxNum == 1)
                        {
                            $tmpStatus = BOOKING_FULL;
                        } 
						else 
						{
                            $tmpStatus = BOOKING_NOT_FULL;
                        }
						$addBookingStatusData[$k] = array("res_info_id" => $res_info_id, "booking_date" => strtotime($dateStr), "time_from" => $v, "time_to" => $timeToStr, "status" => $tmpStatus,"remaining"=>($maxNum-1));
                    }
					
                    $this->booking_model->addBookingStatus($addBookingStatusData);
					
										
					if ($this->db->trans_status() === FALSE)
					{
						$this->db->trans_rollback();
						echo json_encode(array("state" => 10, "ret" => "Database Error"));
						die;
					}
					else
					{
						$this->db->trans_commit();
						echo json_encode(array("state" => 1, "ret" => "Success"));
						die;
					}                    
                } 
				else 
				{
					echo json_encode(array("state" => 10, "ret" => "Database Error"));
                    die;
                }
            } 
			else 
			{
                // 预订已满 
				echo json_encode(array("state" => 6, "ret" => "已满"));
                die;
            }
        }
    }


    // 取消预订
    public function cancelRes()
    {
        //验证登录token服务
       /* if (get_access_token() === false) {
            getMsg(TOKEN_ERROR);
        }*/
        //加载预订模型
        $this->load->model('booking_model');
        $data			= $this->input->post();
		$res_record_id	= $data["res_record_id"];
        // 单体和共享通用
		$flag= $this->booking_model->acceptCancel($res_record_id);
		switch($flag)
		{
			case "none":
			case "fail":
				echo json_encode(array("state" => 0, "ret" => ""));
				die;
				break;
				
			case "ok":
				echo json_encode(array("state" => 1, "ret" => ""));
				die;
				break;
			
			case "doing":
				echo json_encode(array("state" => 2, "ret" => ""));
				die;
				break;
		}

    }


	/************************************以下预订活动业务****************************************************/
	/**
	* User: Paul
	* Date: 2018/03/15
	* 获取活动列表
	*/
	function getActList(){
		
		$rpp	= $this->input->get('rpp');
		$page	= $this->input->get('page');
		$rpp	= empty($rpp)	 ? RPP	: $this->input->get('rpp');
		$page	= empty($page)	 ? 1	: $this->input->get('page');
		$fromIndex = ($page-1)*$rpp;
		$sql_condition="limit ".$fromIndex.",".$rpp;
		$sql="select act_info_id,name,max,open_date,time_from date_start,
				time_to date_end,IFNULL(remark,'') remark from booking_act_info 
				order by act_info_id desc ";

		$result = $this->db->query($sql.$sql_condition)->result();
		$total	 = count($this->db->query($sql)->result());
		echo json_encode(array("state" => 1, "ret" => $result,"total" =>$total));
	}

	/**
	* User: Paul
	* Date: 2018/03/15
	* 获取活动预订记录列表
	*/
	public function getActBookedList()
	{
		$rpp	= $this->input->get('rpp');
		$page	= $this->input->get('page');
		$rpp	= empty($rpp)	 ? RPP	: $this->input->get('rpp');
		$page	= empty($page)	 ? 1	: $this->input->get('page');
		$fromIndex = ($page-1)*$rpp;
		$sql_condition=" Order by A.datetime DESC limit ".$fromIndex.",".$rpp;
		$sql="select B.name,
			concat(left(A.user,3),'栋',substring(A.user, 4, 2),'单元',right(A.user,4),'室') user,
			left(A.user,3) buildingNo,substring(A.user, 4, 2) unitNo,right(A.user,4) roomNo,
			concat(open_date,' ',time_from) date_start,
			concat(open_date,' ',time_to)  date_end,
			left(FROM_UNIXTIME(A.datetime),16) datetime  from booking_act_record A 
			LEFT JOIN booking_act_info B ON A.act_info_id=B.act_info_id ";
		$result = $this->db->query($sql.$sql_condition)->result();
		$total	 = count($this->db->query($sql)->result());
		echo json_encode(array("state" => 1, "ret" => $result,"total" =>$total));
	}
	/**
	* User: Paul
	* Date: 2018/03/15
	* 添加活动
	*/
	public function addAct()
	{
		$name		= $this->input->post("name");
		$open_date = $this->input->post("open_date");
		$time_from = $this->input->post("time_from");
		$time_to	= $this->input->post("time_to");
		$max		= $this->input->post("max");
		$remark		= $this->input->post("remark");
		$this->load->model('Booking_model');
		$exsit = $this->Booking_model->isExsitResName("booking_act_info",$name);
		if($exsit)
		{
			echo json_encode(array("state" => 3, "ret" => "exsit"));
			die;
		}
		if (strtotime(date('Y-m-d',strtotime($open_date)) . " " . $time_from) < time())
		{
			echo json_encode(array("state" => 5, "ret" => "Time from or Time to should not less than current time"));
			die;
		}
		if (strtotime(date("Y-m-d") . " " . $time_from) >= strtotime(date("Y-m-d") . " " . $time_to)) 
		{
			echo json_encode(array("state" => 2, "ret" => "开始时间必须小于结束时间"));
			die;
		}
		$data=array(
			'name'		=>$name,
			'open_date'	=>$open_date,
			'time_from'	=>$time_from,
			'time_to'	=>$time_to,
			'max'		=>$max,
			'remark'	=>$remark
			);
		$result = $this->db->insert("booking_act_info", $data);


		if($result)
		{
            //添加消息通知服务，文案待定
			sendMQTTMSG("Booking",'{"cate":"booking","subcate":"notice","title":"有新的预定资源","datetime":'.time().'}');
			echo json_encode(array("state" => 1, "ret" => "success"));
		}
		else
		{	
			echo json_encode(array("state" => 0, "ret" => "fail"));
		}
	}
	/**
	* User: Paul
	* Date: 2018/03/15
	* 删除活动
	*/
	public function deleteAct()
	{
		$act_info_id	= $this->input->post("act_info_id");
		$this->load->model("booking_model");
		$isActRecord		= $this->booking_model->isActRecordCountById($act_info_id);
		$isActExpire	= $this->booking_model->isActRecordExpireById($act_info_id);
		
		if($isActRecord && !$isActExpire)
		{
			echo json_encode(array("state" => 2, "ret" => "该活动已被预订不能删除!"));
			die;
		}
		$this->db->trans_begin();
		$this->db->delete("booking_act_info",  array('act_info_id'=>$act_info_id));
		$this->db->delete("booking_act_record",array('act_info_id'=>$act_info_id));
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

	//室内机用-获取活动列表带状态
	function getBookingActByLoaction()
	{
		$data = $this->input->post();
		$location = $data["location"];
		$resRcdList = $this->db->query("select A.*,concat(open_date,' ',time_from) open_time from booking_act_info A 
											ORDER BY open_time ASC")->result();
		#print_r($resRcdList);
		$res=array();
		foreach ($resRcdList as $key => $value) 
		{
			if (strtotime($value->open_time) > time()) 
			{
				$this->db->where('act_info_id', $value->act_info_id);
				$this->db->where('user', $location);
				$this->db->from('booking_act_record');
				if ($this->db->count_all_results() > 0) {
					$res[$key]['status'] = 1; //自己已预订
				} else {
					$res[$key]['status'] = 0; //自己未预订
				}

				$cnt = $this->db->query("select count(*) as cnt from booking_act_record where act_info_id=" . $value->act_info_id)->row();
				$res[$key]['remain']		= $value->max - $cnt->cnt;
				$res[$key]['act_info_id']	= $value->act_info_id;
				$res[$key]['name']			= $value->name;
				$res[$key]['max']			= $value->max;
				$res[$key]['datetime']		= $value->open_time.'-'.$value->time_to;
				$res[$key]['remark']		= $value->remark;
			}
		}
		echo json_encode(array("state" => 1, "ret" => $res, "totalNum" => count($res)));
		die();

	}
	//室内机用-获取某人某天自己预定的场馆列表
	public function getBookingRes()
	{
		$data = $this->input->post();
		$location = $data["location"];
		$theTime = $data['date'];
		//如果有日期和用户参数，在室内机总览日历中显示某天预定详情
		if (isset($_POST['date']) && isset($_POST['location'])) {
			$resRcdList = $this->db->query("select I.name,I.remark,R.booking_date,R.time_from,R.time_to,R.datetime 
		from booking_res_record R,booking_res_info I 
		where R.res_info_id=I.res_info_id and R.user='" . $location . "' 
		and left(FROM_UNIXTIME(R.booking_date),10)='" . $theTime . "' order by R.booking_date,R.time_from ASC")->result();
			foreach ($resRcdList as $key => $value) {
				$res[$key]['res_record_id'] = $value->res_record_id;
				$res[$key]['res_info_id'] = $value->res_info_id;
				$res[$key]['name'] = $value->name;
				$res[$key]['remark'] = $value->remark;
				$res[$key]['booking_date'] = $value->booking_date;
				$res[$key]['time_from'] = $value->time_from;
				$res[$key]['time_to'] = $value->time_to;
				$res[$key]['datetime'] = $value->datetime;
			}
			if ($res == null) {
				$res = array();
			}
			echo json_encode(array("state" => 1, "ret" => $res, "totalNum" => count($res)));
			die;


		} //如果设置了用户参数，在室内机我的预定列表中显示预定列表
		elseif (isset($_POST['location'])) 
		{
			$resRcdList = $this->db->query("select R.res_record_id,I.res_info_id, I.name,I.remark,R.booking_date,R.time_from,R.time_to,R.datetime,
				 CONCAT(left(FROM_UNIXTIME(R.booking_date),10),' ',R.time_to) dtEnd
				 from booking_res_record R,booking_res_info I 
				 where R.res_info_id=I.res_info_id and R.user='" . $location . "' order by R.booking_date,R.time_from ASC")->result();
		} //如果什么都没有，则显示室内机资源列表
		elseif (!isset($_POST['date']) && !isset($_POST['location'])) 
		{
			$resRcdList = $this->db->query("select * from booking_res_info")->result();
		} 
		else 
		{

		}
		//echo $this->db->last_query();
		
		foreach ($resRcdList as $key => $value) {
			//判断预订的结束时间大于当前系统的时间 add by paul 2018-03-09
			if (strtotime($value->dtEnd) > time()) {
				$res[$key]['res_record_id'] = $value->res_record_id;
				$res[$key]['res_info_id'] = $value->res_info_id;
				$res[$key]['name'] = $value->name;
				$res[$key]['remark'] = $value->remark;
				$res[$key]['booking_date'] = $value->booking_date;
				$res[$key]['time_from'] = $value->time_from;
				$res[$key]['time_to'] = $value->time_to;
				$res[$key]['datetime'] = $value->datetime;
			}
		}
		if ($res == null) {
			$res = array();
		}
		echo json_encode(array("state" => 1, "ret" => $res, "totalNum" => count($res)));
		die;
	}
	//室内机用-获取某人某天自己预定的活动列表
	public function getBookingAct()
	{
		$data = $this->input->post();
		$location = $data["location"];
		$theTime = $data['date'];
		//如果有日期和用户参数，在室内机总览日历中显示某天预定详情
		if (isset($_POST['date']) && isset($_POST['location'])) {
			$res = array();
			$resRcdList = $this->db->query("select I.max,R.act_record_id, I.name,I.remark,R.datetime booking_date,I.time_from,I.time_to 
			from booking_act_record R,booking_act_info I 
			where R.act_info_id=I.act_info_id and R.user='" . $location . "' and 
			I.open_date='".$theTime."' order by  I.open_date,I.time_from ASC")->result();
			foreach ($resRcdList as $key => $value) {
				$res[$key]['act_record_id']	= $value->act_record_id;
				$res[$key]['name']				= $value->name;
				$res[$key]['remark']			= $value->remark;
				$res[$key]['booking_date']		= $value->booking_date;
				$res[$key]['time_from']		= $value->time_from;
				$res[$key]['time_to']			= $value->time_to;
				/*if(strtotime($value->booking_date." ".$value->time_to)<time()){
					unset($res[$key]);
				}*/
			}


		} //如果设置了用户参数，在室内机我的预定列表中显示预定列表
		elseif (isset($_POST['location'])) {
			$res = array();
			$resRcdList = $this->db->query("
				select I.act_info_id,
				R.act_record_id,I.name,
				concat(open_date,' ',time_from) open_start_time,
				concat(open_date,' ',time_from,'-',time_to) open_time, I.max,I.remark
				from booking_act_record R,booking_act_info I 
				where R.act_info_id=I.act_info_id and R.user='" . $location . "' order by  I.open_date,I.time_from ASC")->result();
			//获取剩余人数
			foreach ($resRcdList as $key => $value) {
				if (strtotime($value->open_start_time) > time()) {
					$cnt = $this->db->query("select count(*) as cnt from booking_act_record where act_info_id=" . $value->act_info_id)->row();
					$res[$key]['remain']		= $value->max - $cnt->cnt;
					$res[$key]['act_record_id']= $value->act_record_id;
					$res[$key]['name']			= $value->name;
					$res[$key]['remark']		= $value->remark;
					$res[$key]['datetime']		= $value->open_time;
					$res[$key]['remain']		= $value->max - $cnt->cnt;
				}
				if(strtotime($value->booking_date." ".$value->time_to)<time()){
					unset($res[$key]);
				}
			}

		} //如果什么都没有，则显示室内机资源列表
		elseif (!isset($_POST['date']) && !isset($_POST['location'])) {
			$res = array();
			$resRcdList = $this->db->query("select I.act_info_id,I.max,R.act_record_id,I.name,I.remark,R.datetime booking_date,I.time_from,I.time_to from booking_act_record R,booking_act_info I where R.act_info_id=I.act_info_id")->result();
			//获取剩余人数
			foreach ($resRcdList as $key => $value) {
				$cnt = $this->db->query("select count(*) as cnt from booking_act_record where act_info_id=" . $value->act_info_id)->row();
				$res[$key]['act_record_id']	= $value->act_record_id;
				$res[$key]['name']				= $value->name;
				$res[$key]['remark']			= $value->remark;
				$res[$key]['booking_date']		= $value->booking_date;
				$res[$key]['time_from']			= $value->time_from;
				$res[$key]['time_to']			= $value->time_to;
				$res[$key]['remain']			= $value->max - $cnt->cnt;
				if(strtotime($value->booking_date." ".$value->time_to)<time()){
					unset($res[$key]);
				}
			}
		} else {


		}
		echo json_encode(array("state" => 1, "ret" => $res, "totalNum" => count($resRcdList)));
		die;
	}

    /**
     * 预订某活动
     */
    public function acceptAct()
    {
        //验证登录token服务
        //加载预订模型
        $this->load->model('booking_model');
        $data			= $this->input->post();
        $id				= $data["actId"];
        $location		= $data["location"];
        $actInfoResult	= $this->booking_model->getActInfoById($id);
        if (isset($actInfoResult))
        {
            $actTimeFrom = $actInfoResult->open_date.' '.$actInfoResult->time_from;
            $max = $actInfoResult->max;
            $now = time();
			if (strtotime($actTimeFrom) > $now)
            {
                // 时间有效，可以预订该活动
                $notBookedFlag = $this->booking_model->chkActExist($id, $location);
                // 判断是否已预订过，防止重复提交
                if ($notBookedFlag)
                {
                    // 可以进行下一步预订
                    $notFullFlag = $this->booking_model->chkActFull($id, $max);
                    if ($notFullFlag)
                    {
                        // 活动未满
						$recordData = array("act_info_id" => $id, "user"=>$location,"datetime" => $now);

                        if ($this->booking_model->saveActivityRecord($recordData)) {
                            echo json_encode(array("state" => 1, "ret" => "Success"));
                            die;
                        } else {
                            echo json_encode(array("state" => 0, "ret" => "Error"));
                            die;
                        }
                    } else {
                        // 活动已满
                        echo json_encode(array("state" => 0, "ret" => "Error"));
                        die;
                    }
                } else {
                    // 已经预订过该活动了
                    echo json_encode(array("state" => 0, "ret" => "Error"));
                    die;
                }
            }
        } else {
            echo json_encode(array("state" => 0, "ret" => "Error"));
            die;
        }
    }

    // 取消活动
    public function cancelAct()
    {
        //验证登录token服务
        /*if (get_access_token() === false) {
            getMsg(TOKEN_ERROR);
        }*/
        //加载预订模型
        $this->load->model('booking_model');
        $data			= $this->input->post();
		$act_record_id = $data["act_record_id"];
        // 判断活动是否过期
        $now = time();
		$actResult = $this->booking_model->getActInfoByRcdId($act_record_id);
        if (isset($actResult))
        {
            // 判断活动是否过期
			$actTime = $actResult->open_start_time;
			if (strtotime($actTime) > $now)
            {
                // 取消活动
				if ($this->booking_model->acceptActCancel($act_record_id))
                {
                    echo json_encode(array("state" => 1, "ret" => ""));
                    die;
                } else {
                    echo json_encode(array("state" => 0, "ret" => ""));
                    die;
                }
            } else {
                // 活动已过期
                echo json_encode(array("state" => 0, "ret" => ""));
                die;
            }
        } else {
            echo json_encode(array("state" => 0, "ret" => ""));
            die;
        }
    }

}
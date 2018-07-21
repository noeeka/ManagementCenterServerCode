<?php
//预定model
class Booking_model extends CI_Model {
	public function __construct()
	{
		parent::__construct();
	}

	public function isExsitResName($tableName,$resName)
	{
		$this->db->escape();
		$row = $this->db->query("SELECT  count(1) ct FROM ".$tableName." where  name='".$resName."'")->row();
		if ($row->ct == 0) 
		{
			return FALSE;
		} 
		return TRUE;

	}
	/**
	 * User: Paul
	 * Date: 2018/03/14
	 * 根据预订资源ID删除资源
	 */
	public function deleteResRecord($res_record_id)
	{
		$sql = "delete from booking_res_record where res_record_id=" . $res_record_id;
		$result = $this->db->query($sql);
		return $result;
	}

	/**
	 * User: Paul
	 * Date: 2018/03/08
	 * 根据时间段获取资源预订明细信息
	 */
	public function getResBookingDetailByTime($date, $res_info_id, $time_from, $time_to)
	{

		$sql = "select user,B.building,B.unit,B.room,booking_date,dtStart,dtEnd,ifnull(C.phone_primary,'') phone_primary from 
				(
					select A.user,
					substring(A.user,1,3) building,
					substring(A.user,4,2) unit,
					substring(A.user,6,9) room,
					left(FROM_UNIXTIME(A.booking_date),16) booking_date,
					left(FROM_UNIXTIME(A.booking_date),10) day,
					CONCAT(left(FROM_UNIXTIME(A.booking_date),10),' ',A.time_from) dtStart,
					CONCAT(left(FROM_UNIXTIME(A.booking_date),10),' ',A.time_to) dtEnd 
					from booking_res_record A where res_info_id=" . $res_info_id . "  
				) B 
				left JOIN 
				(select building,unit,room,phone_primary from  base_owner_info where phone_primary<>'' group by building,unit,room) C 
				ON B.building=C.building and B.unit=C.unit and B.room=C.room
				where  B.dtStart<'" . $date . " " . $time_to . "'  and  B.dtEnd>'" . $date . " " . $time_from . "'";

		$result = $this->db->query($sql)->result();

		return $result;
	}

	/**
	 * User: Paul
	 * Date: 2018/02/11
	 * 根据资源、日期获取已预定的资源信息
	 * 用户自己预订为整段时间和别人预订满的为分段时间
	 */
	public function getResBookedById($res_info_id, $location, $date)
	{
		if (isset($location))
		{
			$user_where = " and user='" . $location . "' union ";
		}
		else
		{
			$user_where = " union ";

		}
		$sql_record = "select '0' res_record_id,'00:00' time_from,time_from time_to,'1' status 
				from booking_res_info where  res_info_id=" . $res_info_id . "
				
				union 
				Select res_record_id,time_from, time_to,status from booking_res_record 
				where  res_info_id=" . $res_info_id . "  and booking_date='" . $date . "' and 1=1 ";

		$sql_record = $sql_record . $user_where;

		$sql_status = " 
				
				Select res_status_id,time_from, time_to,status from booking_res_status 
				where  res_info_id=" . $res_info_id . "  and booking_date='" . $date . "' and status=3
				
				union 

				select '0' res_record_id,time_to time_from,'24:00' time_to  ,'1' status 
				from booking_res_info where  res_info_id=" . $res_info_id . "
				";
		//每天资源关闭
		$sql_close = " 
				union 
				select res_record_id,time_from,time_to,status 
				from booking_res_record where  res_info_id=" . $res_info_id . "  and booking_date='" . $date . "' and status=1 ";

		$sql = $sql_record . $sql_status . $sql_close;

		//单体，预订即吗满
		$sqlSingleBook = " union 
						Select A.res_record_id,A.time_from, A.time_to,'3' status from booking_res_record A
						LEFT JOIN 
						booking_res_info B ON A.res_info_id=B.res_info_id
						 
						where B.type=1 and A.res_info_id=" . $res_info_id . "  and A.booking_date='" . $date . "' and A.status=2  ";


		$res = $this->db->query($sql . $sqlSingleBook)->result();
		/*echo $this->db->last_query();
		die;*/
		return $res;
	}


	// 根据ID获取资源信息
	public function getResInfoById($res_info_id)
	{
		$query = $this->db->query('SELECT * FROM booking_res_info WHERE res_info_id=' . $res_info_id);
		$row = $query->row();
		return $row;
	}


	public function isActRecordCountById($act_info_id)
	{	
		$sql="  SELECT COUNT(*) ct 
					FROM booking_act_record  
					WHERE act_info_id=".$act_info_id."";
				
		$row = $this->db->query($sql)->row();
		if ($row->ct == 0)
		{
			return FALSE;
		}
		else
		{
			return TRUE;
		}
	}
	
	/*通过资源ID判断当前时间是否超过资源预订的结束时间*/
	public function isResRecordExpireById($res_info_id)
	{	
		$sql="SELECT count(1) ct from (
				SELECT 
				CONCAT(left(FROM_UNIXTIME(booking_date),10),' ',time_to) Booking_Endtime, 
				user from booking_res_record WHERE  res_info_id=".$res_info_id." 
				) C
				WHERE NOW()>C.Booking_Endtime ";
		$row = $this->db->query($sql)->row();
		
		if ($row->ct == 0)
		{
			return FALSE;
		}
		else
		{
			return TRUE;
		}
	}
	/*通过活动ID判断当前时间是否超过活动的结束时间*/
	public function isActRecordExpireById($act_info_id)
	{	
		$sql="SELECT count(*) ct FROM 
				(   SELECT user,
					CONCAT(B.open_date,' ',B.time_from) dtActStart,
					CONCAT(B.open_date,' ',B.time_to) dtActEnd 
					FROM booking_act_record A LEFT JOIN
					booking_act_info B ON A.act_info_id=B.act_info_id
					WHERE A.act_info_id=".$act_info_id."
				) C 
				WHERE NOW() > C.dtActEnd ";
		//WHERE NOW() > str_to_date(C.dtActEnd, '%Y-%m-%d %H:%i:%s')
		$row = $this->db->query($sql)->row();
		
		if ($row->ct == 0)
		{
			return FALSE;
		}
		else
		{
			return TRUE;
		}
	}
	// 根据活动ID获取活动信息
	public function getActInfoById($act_record_id)
	{
		$query = $this->db->query('SELECT * FROM booking_act_info WHERE act_info_id=' . $act_record_id);
		$row = $query->row();
		return $row;
	}

	// 根据记录ID获取资源预订记录信息
	public function getResRcdInfoById($id)
	{
		$query = $this->db->query('SELECT * FROM booking_res_record WHERE res_record_id=' . $id);
		$row = $query->row();
		return $row;
	}

	public function isResRcdCountById($res_info_id)
	{
		$query = $this->db->query('SELECT count(res_record_id) ct FROM booking_res_record WHERE res_info_id=' . $res_info_id);
		$row = $query->row();
		if ($row->ct == 0)
		{
			return FALSE;
		}
		else
		{
			return TRUE;
		}
	}

	// 为了取消某个资源，先获取资源信息
	public function getResRcdForCancelById($res_record_id)
	{
		$query = $this->db->query("SELECT A.res_info_id,A.booking_date,
					
					A.time_from,A.time_to,B.type,B.min_time,B.max_num   
					FROM booking_res_record A left join booking_res_info B  on B.res_info_id=A.res_info_id 
					where A.res_record_id='" . $res_record_id . "'");
		$row = $query->row();
		return $row;
	}

	// 取消记录
	public function deleteBookingRecord($res_record_id)
	{
		$query = $this->db->query('DELETE FROM booking_res_record WHERE res_record_id=' . $res_record_id);
		return $query;
	}

	// 根据记录获取相关的状态信息
	public function getBookingStatus($res_info_id, $bookingDate, $timeFromArray)
	{
		$this->db->select("*");
		$this->db->from("booking_res_status");
		$this->db->where("res_info_id", $res_info_id);
		$this->db->where("booking_date", $bookingDate);
		//$this->db->where("res_info_id", $bookingId);
		$this->db->where_in("time_from", $timeFromArray);
		$this->db->order_by("time_from", "ASC");
		$query = $this->db->get();
		$result = $query->result();
		return $result;
	}

	// 取消预订后修改预订中某个状态的剩余值
	public function updateStatusRemaining($res_status_id, $maxNum)
	{
		$query = $this->db->query('UPDATE booking_res_status SET status=' . BOOKING_NOT_FULL . ',
									 remaining=remaining+1 WHERE res_status_id=' . $res_status_id);


		return $query;
	}

	// 预订成功后修改状态表
	public function updateBookingStatus($res_status_id)
	{
		$query = $this->db->query("UPDATE booking_res_status SET status=if(remaining=1," . BOOKING_FULL . "," . BOOKING_NOT_FULL . "),
									 remaining=remaining-1 WHERE res_status_id=" . $res_status_id);
		return $query;
	}


	// 删除预订状态表中的某个时间段的状态
	public function deleteBookingStatus($res_status_id)
	{
		$query = $this->db->query('DELETE FROM booking_res_status WHERE res_status_id=' . $res_status_id);
		return $query;
	}

	// 插入预订状态
	public function addBookingStatus($dataArray)
	{
		$query = FALSE;
		foreach ($dataArray as $k => $v)
		{
			$query = $this->db->insert("booking_res_status", $v);
		}
		return $query;
	}

	


	// 根据记录ID获取活动记录信息
	public function getActRcdInfoById($id)
	{
		$query = $this->db->query('SELECT * FROM booking_act_record WHERE act_record_id=' . $id);
		$row = $query->row();
		return $row;
	}


	// 根据记录ID获取活动信息
	public function getActInfoByRcdId($act_record_id)
	{
		$query = $this->db->query("SELECT A.*,concat(open_date,' ',time_from) open_start_time FROM booking_act_info A,booking_act_record B 
									WHERE A.act_info_id=B.act_info_id and B.act_record_id=" . $act_record_id);
		$row = $query->row();
		return $row;
	}

	//判断是否属于不可预订的资源范围 add by paul
	public function isInvalidResById($res_info_id, $time_from, $time_to)
	{
		$sql = "select * from 
				(
				select '0' res_record_id,'00:00' time_from,time_from time_to,'1' status 
								from booking_res_info where  res_info_id=" . $res_info_id . "
				) A
				where  time_from<'" . $time_to . "'  and  time_to>'" . $time_from . "'
				
				union 
				select * from 
				(
								select '0' res_record_id,time_to time_from,'24:00' time_to  ,'1' status 
								from booking_res_info where  res_info_id=" . $res_info_id . "
				) A
				where  time_from<'" . $time_to . "'  and  time_to>'" . $time_from . "'";
		$res = $this->db->query($sql)->result();
		if (count($res) > 0)
		{
			return TRUE;
		}
		else
		{
			return FALSE;
		}
	}
	// 检查该资源是否关闭状态
	public function chkIsClosed($res_info_id, $date, $time_from, $time_to)
	{
		$sql = "select count(*) ct from 
				(
					select A.user,left(FROM_UNIXTIME(A.booking_date),16) booking_date,
					left(FROM_UNIXTIME(A.booking_date),10) day,
					CONCAT(left(FROM_UNIXTIME(A.booking_date),10),' ',A.time_from) dtStart,
					CONCAT(left(FROM_UNIXTIME(A.booking_date),10),' ',A.time_to) dtEnd 
					from booking_res_record A where status=1 AND res_info_id=" . $res_info_id . " 
				) B
				where dtStart<'" . $date . " " . $time_to . "'  and  dtEnd>'" . $date . " " . $time_from . "'";
		$row = $this->db->query($sql)->row();
		$count = $row->ct;
		if ($count > 0)
		{
			return TRUE;
		}
		else
		{
			return FALSE;
		}
	}
	// 检查该预订是否已存在
	public function chkBookedOrClosed($res_info_id, $date, $time_from, $time_to)
	{
		$sql = "select dtStart,dtEnd from 
				(
					select A.user,left(FROM_UNIXTIME(A.booking_date),16) booking_date,
					left(FROM_UNIXTIME(A.booking_date),10) day,
					CONCAT(left(FROM_UNIXTIME(A.booking_date),10),' ',A.time_from) dtStart,
					CONCAT(left(FROM_UNIXTIME(A.booking_date),10),' ',A.time_to) dtEnd 
					from booking_res_record A where res_info_id=" . $res_info_id . " 
				) B
				where dtStart<'" . $date . " " . $time_to . "'  and  dtEnd>'" . $date . " " . $time_from . "'";
		$query = $this->db->query($sql);
		$count = count($query->result());
		if ($count > 0)
		{
			return TRUE;
		}
		else
		{
			return FALSE;
		}
	}

	// 判断是否自己已预订该共享资源
	public function chkBookedSelf($res_info_id, $date, $timeFrom, $timeTo, $location)
	{

		/*$sql = "SELECT res_record_id FROM booking_res_record WHERE res_info_id=? AND booking_date=? AND ((time_from>='".$timeFrom."' AND time_from<'".$timeTo."')
         or (time_to>'".$timeFrom."' AND time_to<='".$timeTo."')) AND user=?";
        $query = $this->db->query($sql, array($id, $date, $location));*/

		$sql = "select dtStart,dtEnd from 
				(
					select A.user,left(FROM_UNIXTIME(A.booking_date),16) booking_date,
					left(FROM_UNIXTIME(A.booking_date),10) day,
					CONCAT(left(FROM_UNIXTIME(A.booking_date),10),' ',A.time_from) dtStart,
					CONCAT(left(FROM_UNIXTIME(A.booking_date),10),' ',A.time_to) dtEnd 
					from booking_res_record A where res_info_id=" . $res_info_id . " and A.user='" . $location . "'
				) B
				where dtStart<'" . $date . " " . $timeTo . "'  and  dtEnd>'" . $date . " " . $timeFrom . "'";
		$query = $this->db->query($sql);

		$count = count($query->result());
		if ($count > 0)
		{
			return TRUE;
		}
		else
		{
			return FALSE;
		}
	}

	

	// 检查该资源是否已关闭
	public function chkBookableForClosed($id, $date, $timeArray)
	{
		$sql = "SELECT res_record_id FROM booking_res_record where res_info_id={$id} AND booking_date={$date} AND status=" . BOOKING_CLOSED . " AND time_from in (";
		foreach ($timeArray as $k => $v)
		{
			$sql .= "'" . $v["timeFrom"] . "',";
		}
		$sql = substr($sql, 0, -1);
		$sql .= ")";
		$query = $this->db->query($sql);
		$count = count($query->result());
		if ($count == 0)
		{
			return TRUE;
		}
		else
		{
			return FALSE;
		}
	}


	// 判断是否可以再预订
	public function chkBookable($id, $date, $timeArray)
	{
		$this->db->select("res_status_id");
		$this->db->from("booking_res_status");
		$this->db->where("res_info_id", $id);
		$this->db->where("booking_date", $date);
		$this->db->where_in("status", array(BOOKING_CLOSED, BOOKING_FULL));
		$this->db->where_in("time_from", $timeArray);
		$query = $this->db->get();

		$count = count($query->result());
		if ($count == 0)
		{
			return FALSE;
		}
		else
		{
			return TRUE;
		}
	}

	// 保存预订记录业务（独立和共享都适用）
	public function saveBookingRecord($data)
	{
		$query = $this->db->insert("booking_res_record", $data);
		return $query;
	}


	// 取消资源多个预订
	public function acceptCancel($res_record_id)
	{

		$recordResult = $this->getResRcdForCancelById($res_record_id);
		$bookingDate = 0;
		$bookedFrom = "";
		if (count($recordResult) > 0)
		{
			$bookingType = $recordResult->type;
			$res_info_id = $recordResult->res_info_id;
			$bookingDate = $recordResult->booking_date;
			$timeFrom = $recordResult->time_from;
			$timeTo = $recordResult->time_to;
			$maxNum = $recordResult->max_num;
			//$min_time		= $recordResult->min_time;
		}
		else
		{
			return "none";
		}

		$timeFromTime = strtotime($timeFrom);
		//预订改资源的开始时间 add by paul 2018-03-12

		$BookingStartTime = strtotime(date('Y-m-d', $bookingDate) . " " . $timeFrom);
		$now = time();
		if ($BookingStartTime > $now) //预订资源没到期，可以取消 add by paul 2018-03-09
		{
			$this->db->trans_begin();
			if ($bookingType == RES_SHARE) //共享资源
			{
				// 共享资源
				$startTime = strtotime($timeFrom);
				$endTime = strtotime($timeTo);
				$timeFromArray = array();
				for ($i = $startTime; $i < $endTime; $i = $i + BOOKING_MIN_TIME * 60)
				{
					$timeFromArray[] = date("H:i", $i);
				}

				$statusResult = $this->getBookingStatus($res_info_id, $bookingDate, $timeFromArray);
				foreach ($statusResult as $k => $v)
				{
					$res_status_id = $v->res_status_id;
					$status = $v->status;
					$remaining = $v->remaining;
					//add by paul 判断取消该资源后，是否有别的预订，如有更新该资源状态，如没有，将该资源直接删除
					if ($remaining < $maxNum - 1)
					{
						// 取消之后还可以预订，未满
						$this->updateStatusRemaining($res_status_id, $maxNum);

					}
					else
					{
						// 取消之后就没人预订该时段了
						$this->deleteBookingStatus($res_status_id);
					}
				}
			}
			$canceledResult = $this->deleteBookingRecord($res_record_id);

			if ($this->db->trans_status() === FALSE)
			{
				$this->db->trans_rollback();
				return "fail";
			}
			else
			{
				$this->db->trans_commit();
				return "ok";
			}
		}
		else
		{
			return "doing";//当前系统时间在 改资源预订的开始与结束时间之间
		}
	}


	// 检查该用户是否预订了该活动
	public function chkActExist($id, $location)
	{
		$sql = "SELECT * FROM booking_act_record WHERE act_info_id={$id} AND user='.$location.'";
		$query = $this->db->query($sql);
		$count = count($query->result());
		if ($count > 0)
		{
			return FALSE;
		}
		else
		{
			return TRUE;
		}
	}

	// 判断该活动是否已预订满
	public function chkActFull($id, $max)
	{
		$sql = "SELECT count(act_record_id) as count FROM booking_act_record WHERE act_info_id={$id}";
		$query = $this->db->query($sql);
		$result = $query->result();
		$count = count($result);
		if ($count > 0)
		{
			$recordNum = $result[0]->count;
			if ($recordNum < $max)
			{
				return TRUE;
			}
			else
			{
				return FALSE;
			}
		}
		else
		{
			return FALSE;
		}
	}

	// 保存活动预订记录业务
	public function saveActivityRecord($data)
	{
		$query = FALSE;
		$query = $this->db->insert("booking_act_record", $data);
		return $query;
	}


	// 取消活动预订
	public function acceptActCancel($act_record_id)
	{
		//$recordResult = $this->getActRcdInfoById($act_record_id);

		$excuteSql = "delete from booking_act_record where act_record_id=" . $act_record_id;
		$result = $this->db->query($excuteSql);
		return $result;

	}



	// 获取所有未完成的活动
	public function getActList($location, $page, $rpp)
	{
		$fromIndex = ($page - 1) * $rpp;
		$now = time();
		$excuteSql = "select DISTINCT(I.act_info_id),(select count(act_info_id) from booking_act_record where act_info_id=I.act_info_id) as bookedNum,
                       I.name,I.max,I.time_from,I.time_to,I.remark,
                       (case D.user when '" . $location . "' then 1 else 0 end) as bookedFlag from booking_act_info I left join booking_act_record D
                       on (I.act_info_id = D.act_info_id and D.user='" . $location . "') where
                       I.time_from>" . $now . " order by I.time_from,I.time_to,I.act_info_id  LIMIT " . $fromIndex . "," . $rpp;

		$query = $this->db->query($excuteSql);
		$result = $query->result();
		return $result;
	}

}

<?php

/**
 * Created by PhpStorm.
 * User: James
 * Date: 2018/04/14
 * Time: 14:52
 * usage: Device classify and type controllor
 */
class Category extends CI_Controller
{
    public function __construct()
    {
        parent::__construct();
        //getToken();
    }

    /*
     * 获取设备类型和分类关系服务
     *
     */

    function getDeviceCateAndType(){
        //设备类型对应关系列表
        $device_type_res = array(
            "01" => "室内机",
            "02" => "门口机",
            "03" => "围墙机",
            "04" => "独立门禁",
            "05" => "扩展安防",
            "06" => "独立安防",
            "07" => "门卫机",
            "09" => "二次确认门口机",
            "11" => "电梯连接器",
            "12" => "HomeLink",
            "13" => "移动终端"
        );
        echo json_encode(array("state"=>1,"ret"=>$device_type_res));
        die;
    }

    /*
     * 添加设备分类服务
     * POST @name
     * return {"state":1,"ret":"success"}
     */
    function addDeviceCate()
    {
        $cate_name = $this->input->post("name");
        $data = array("device_type_parent_id" => "0", "device_type_name" => $cate_name);
        $result = $this->db->insert('base_device_type', $data);
        if ($result) {
            echo json_encode(array("state" => 1, "ret" => "success"));
        }

    }

    /*
     * 获取设备分类服务
     * return {"state":1,"ret":[{"id":"1","name":"\u95e8\u53e3\u673a"},{"id":"2","name":"\u5ba4\u5185\u673a"},{"id":"3","name":"\u95e8\u536b\u673a"}]}
     */
    function getDeviceCate()
    {
        $sql = "select * from `base_device_type` where device_type_parent_id='0'";
        $result = $this->db->query($sql)->result();
        foreach ($result as $key => $value) {
            $res[$key]['id'] = $value->device_type_id;
            $res[$key]['name'] = $value->device_type_name;
        }
        echo json_encode(array("state" => 1, "ret" => $res));
    }

    /*
     * 修改设备分类服务
     * POST @id @name
     * return {"state":1,"ret":"success"}
     */
    function updateDeviceCate()
    {
        $id = $this->input->post("id");
        $name = $this->input->post("name");
        $sql = "update base_device_type set device_type_name='{$name}' where device_type_id={$id}";
        $result = $this->db->query($sql);
        if ($result) {
            echo json_encode(array("state" => 1, "ret" => "success"));
        }
    }

    /*
     * 删除设备分类服务
     * POST @id
     * return {"state":1,"ret":"success"}
     */
    function removeDeviceCate()
    {
        $id = $this->input->post("id");
        $sql_removeCate = "delete from base_device_type where device_type_id={$id}";
        $sql_removeType = "delete from base_device_type where device_type_parent_id='{$id}'";
        $result = $this->db->query($sql_removeCate);
        $result = $this->db->query($sql_removeType);
        if ($result) {
            echo json_encode(array("state" => 1, "ret" => "success"));
        }
    }

    /*
     * 根据设备分类添加设备类型服务
     * POST @cate_id @name
     * return {"state":1,"ret":"success"}
     */
    function addDeviceTypeByCate()
    {
        $cate_id = $this->input->post("cate_id");
        $name = $this->input->post("name");
        $data = array("device_type_parent_id" => $cate_id, "device_type_name" => $name);
        $result = $this->db->insert('base_device_type', $data);
        if ($result) {
            echo json_encode(array("state" => 1, "ret" => "success"));
        }
    }

    /*
     * 根据设备分类列出所有设备类型服务
     * GET <@page> <@rpp> <@cate_id>
     * 若page和rpp同时为0，不带分页取所有类型
     * return {"state":1,"ret":[{"id":"4","cate_id":"2","name":"DMT10"},{"id":"5","cate_id":"2","name":"DMT7"}]}
     */
    function getDeviceTypeByCate()
    {
        $rpp = $this->input->get('rpp');
        $page = $this->input->get('page');
        $cate_id = $this->input->get("cate_id");
        $rpp = empty($rpp) ? RPP : $this->input->get('rpp');
        $page = empty($page) ? 1 : $this->input->get('page');

        //若没有设备分类，获取所有设备类型
        if (empty($cate_id)) {
            $all_result = $this->db->query("select * from base_device_type where device_type_parent_id!='0'")->result();
            foreach ($all_result as $key => $value) {
                $res[$key]['id'] = $value->device_type_id;
                $res[$key]['cate_id'] = $value->device_type_parent_id;
                $res[$key]['name'] = $value->device_type_name;
            }
            echo json_encode(array("state" => 1, "ret" => $res));
            die;
        }

        //不带分页，获取所有类型
        if ($this->input->get('page') == 0 && $this->input->get('rpp') == 0) {
            $all_result = $this->db->get_where('base_device_type', array("device_type_parent_id" => $cate_id))->result();

            $this->db->where('device_type_parent_id', $cate_id);
            $this->db->from('base_device_type');
            foreach ($all_result as $key => $value) {
                $res[$key]['id'] = $value->device_type_id;
                $res[$key]['cate_id'] = $value->device_type_parent_id;
                $res[$key]['name'] = $value->device_type_name;
            }
            echo json_encode(array("state" => 1, "ret" => $res, "total" => $this->db->count_all_results()));
            die;

        } else {
            $this->db->limit($rpp, ($page - 1) * $rpp);
            $all_result = $this->db->get_where('base_device_type', array("device_type_parent_id" => $cate_id))->result();
            $this->db->where('device_type_parent_id', $cate_id);
            $this->db->from('base_device_type');
            foreach ($all_result as $key => $value) {
                $res[$key]['id'] = $value->device_type_id;
                $res[$key]['cate_id'] = $value->device_type_parent_id;
                $res[$key]['name'] = $value->device_type_name;
            }
            echo json_encode(array("state" => 1, "ret" => $res, "total" => $this->db->count_all_results()));
            die;
        }
    }

    /*
     * 根据设备分类修改设备类型服务
     * POST @id @cate_id @name
     * return {"state":1,"ret":"success"}
     */
    function updateDeviceTypeByCate()
    {
        $id = $this->input->post("id");
        $cate_id = $this->input->post("cate_id");
        $name = $this->input->post("name");
        $sql = "Update base_device_type set device_type_name='{$name}' where device_type_id={$id} and device_type_parent_id='{$cate_id}'";

        $result = $this->db->query($sql);
        if ($result) {
            echo json_encode(array("state" => 1, "ret" => "success"));
        }
    }

    /*
     * 删除设备类型服务
     * POST @id
     * return {"state":1,"ret":"success"}
     */

    function removeDeviceType()
    {
        $id = $this->input->post("id");
        $sql = "delete from base_device_type where device_type_id={$id}";
        $result = $this->db->query($sql);
        if ($result) {
            echo json_encode(array("state" => 1, "ret" => "success"));
        }
    }


}


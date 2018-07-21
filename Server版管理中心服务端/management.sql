/*
Navicat MySQL Data Transfer

Source Server         : 192.168.1.143
Source Server Version : 50560
Source Host           : localhost:3306
Source Database       : management

Target Server Type    : MYSQL
Target Server Version : 50560
File Encoding         : 65001

Date: 2018-06-12 17:23:06
*/

USE mysql;
grant all privileges  on *.* to root@'%' identified by "root";
flush privileges;

DROP DATABASE IF EXISTS `management`;
CREATE DATABASE `management` character set utf8;
USE `management`;

-- ----------------------------
-- Table structure for access_card_info
-- ----------------------------
DROP TABLE IF EXISTS `access_card_info`;
CREATE TABLE `access_card_info` (
  `id` int(32) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `card_no` varchar(100) NOT NULL COMMENT '卡号',
  `user_id` int(32) NOT NULL COMMENT '用户卡ID',
  `status` tinyint(2) DEFAULT NULL COMMENT '卡状态 1:正常 2:挂失 3:注销',
  `card_type` varchar(2) DEFAULT NULL COMMENT '卡类型1：卡，2：蓝牙，3：二维码',
  `remark` text COMMENT '备注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户卡关系表';

-- ----------------------------
-- Records of access_card_info
-- ----------------------------

-- ----------------------------
-- Table structure for access_card_privilege
-- ----------------------------
DROP TABLE IF EXISTS `access_card_privilege`;
CREATE TABLE `access_card_privilege` (
  `id` int(32) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `card_no` varchar(100) DEFAULT NULL COMMENT '卡号',
  `device_id` varchar(50) DEFAULT NULL COMMENT '设备ID',
  `time_group` varchar(50) DEFAULT NULL COMMENT '时间组名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='卡权限关系表';

-- ----------------------------
-- Records of access_card_privilege
-- ----------------------------

-- ----------------------------
-- Table structure for access_card_record
-- ----------------------------
DROP TABLE IF EXISTS `access_card_record`;
CREATE TABLE `access_card_record` (
  `id` int(32) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `access_user` varchar(100) NOT NULL COMMENT '使用者',
  `device_id` varchar(50) NOT NULL COMMENT '设备ID',
  `device_ip` varchar(50) NOT NULL COMMENT '设备IP',
  `building` varchar(3) DEFAULT NULL COMMENT '栋',
  `unit` varchar(2) DEFAULT NULL COMMENT '单元',
  `room` varchar(4) DEFAULT NULL COMMENT '室',
  `open_flag` tinyint(1) NOT NULL COMMENT '开门状态 0:失败 1:成功 2:报警',
  `card_type` tinyint(2) NOT NULL COMMENT '开门方式',
  `open_time` int(32) NOT NULL COMMENT '开门时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='刷卡记录表';

-- ----------------------------
-- Records of access_card_record
-- ----------------------------

-- ----------------------------
-- Table structure for access_card_user
-- ----------------------------
DROP TABLE IF EXISTS `access_card_user`;
CREATE TABLE `access_card_user` (
  `id` int(32) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `user_type` varchar(2) DEFAULT NULL COMMENT '用户类型 1:业主 2:非业主',
  `building` varchar(3) DEFAULT NULL COMMENT '栋',
  `unit` varchar(3) DEFAULT NULL COMMENT '单元',
  `room` varchar(4) DEFAULT NULL COMMENT '室',
  `manager` varchar(20) DEFAULT NULL COMMENT '非业主姓名',
  `remark` text COMMENT '非业主备注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='卡用户表';

-- ----------------------------
-- Records of access_card_user
-- ----------------------------

-- ----------------------------
-- Table structure for access_time_group
-- ----------------------------
DROP TABLE IF EXISTS `access_time_group`;
CREATE TABLE `access_time_group` (
  `id` int(32) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `name` varchar(50) DEFAULT NULL COMMENT '时间组名称',
  `type` tinyint(1) DEFAULT NULL COMMENT '类型 1:永久 2:普通 3:临时',
  `detail` text COMMENT '详细时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='时间组表';

-- ----------------------------
-- Records of access_time_group
-- ----------------------------

-- ----------------------------
-- Table structure for base_building_info
-- ----------------------------
DROP TABLE IF EXISTS `base_building_info`;
CREATE TABLE `base_building_info` (
  `building_id` int(32) NOT NULL AUTO_INCREMENT,
  `building` varchar(50) DEFAULT NULL COMMENT '楼栋名称',
  `x` varchar(50) DEFAULT NULL COMMENT '栋横坐标楼',
  `y` varchar(50) DEFAULT NULL COMMENT '楼栋纵坐标',
  `remark` text,
  PRIMARY KEY (`building_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='楼栋信息表';

-- ----------------------------
-- Records of base_building_info
-- ----------------------------

-- ----------------------------
-- Table structure for base_client_info
-- ----------------------------
DROP TABLE IF EXISTS `base_client_info`;
CREATE TABLE `base_client_info` (
  `clientID` int(32) NOT NULL AUTO_INCREMENT,
  `clientName` varchar(20) DEFAULT NULL COMMENT '客户端名称',
  `ip` varchar(15) DEFAULT NULL,
  `deviceID` varchar(13) DEFAULT NULL,
  `mac` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`clientID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of base_client_info
-- ----------------------------

-- ----------------------------
-- Table structure for base_device_type
-- ----------------------------
DROP TABLE IF EXISTS `base_device_type`;
CREATE TABLE `base_device_type` (
  `device_type_id` int(32) NOT NULL AUTO_INCREMENT COMMENT '设备类型ID',
  `device_type` varchar(255) DEFAULT '0' COMMENT '父节点，用于无限分类',
  `device_type_name` varchar(255) DEFAULT NULL COMMENT '设备类型名称',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`device_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of base_device_type
-- ----------------------------

-- ----------------------------
-- Table structure for base_guard_info
-- ----------------------------
DROP TABLE IF EXISTS `base_guard_info`;
CREATE TABLE `base_guard_info` (
  `guard_id` int(32) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `building_id` int(32) DEFAULT NULL COMMENT '栋ID',
  `unit_id` int(32) DEFAULT NULL COMMENT '单元ID',
  `guard_no` varchar(15) DEFAULT NULL COMMENT '编号',
  `device_ip` varchar(15) NOT NULL COMMENT '设备IP',
  `remark` text NOT NULL COMMENT '备注',
  `device_type` varchar(50) DEFAULT NULL,
  `device_id` varchar(50) DEFAULT NULL,
  `mac` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`guard_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='门卫机信息表';

-- ----------------------------
-- Records of base_guard_info
-- ----------------------------

-- ----------------------------
-- Table structure for base_independent_info
-- ----------------------------
DROP TABLE IF EXISTS `base_independent_info`;
CREATE TABLE `base_independent_info` (
  `independent_id` int(32) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `device_id` varchar(50) NOT NULL COMMENT '设备id',
  `device_name` varchar(50) NOT NULL COMMENT '设备名称',
  `device_ip` varchar(15) NOT NULL COMMENT '设备IP',
  `mask` varchar(50) DEFAULT NULL COMMENT '子网掩码',
  `gateway` varchar(50) DEFAULT NULL COMMENT '网关',
  `syn_time` int(32) DEFAULT NULL COMMENT '同步时间',
  `update_time` int(32) DEFAULT NULL COMMENT '更新时间',
  `remark` text COMMENT '备注',
  PRIMARY KEY (`independent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='独立门禁信息表';

-- ----------------------------
-- Records of base_independent_info
-- ----------------------------

-- ----------------------------
-- Table structure for base_indoor_info
-- ----------------------------
DROP TABLE IF EXISTS `base_indoor_info`;
CREATE TABLE `base_indoor_info` (
  `indoor_id` int(32) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `building_id` int(32) NOT NULL COMMENT '栋ID',
  `unit_id` int(32) NOT NULL COMMENT '单元ID',
  `room_id` int(32) NOT NULL COMMENT '室ID',
  `device_ip` varchar(15) DEFAULT NULL COMMENT '设备IP',
  `remark` text COMMENT '描述',
  `device_type` varchar(50) DEFAULT NULL,
  `device_id` varchar(50) DEFAULT NULL,
  `mac` varchar(50) DEFAULT NULL COMMENT '设备MAC地址',
  PRIMARY KEY (`indoor_id`),
  UNIQUE KEY `device_id` (`device_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='室内机信息表';

-- ----------------------------
-- Records of base_indoor_info
-- ----------------------------

-- ----------------------------
-- Table structure for base_intercom_info
-- ----------------------------
DROP TABLE IF EXISTS `base_intercom_info`;
CREATE TABLE `base_intercom_info` (
  `intercomID` int(11) NOT NULL AUTO_INCREMENT,
  `caller` varchar(30) DEFAULT NULL,
  `receiver` varchar(30) DEFAULT NULL,
  `duration` varchar(30) DEFAULT NULL,
  `datetime` int(11) DEFAULT NULL,
  `state` varchar(10) DEFAULT NULL,
  `caller_name` varchar(255) DEFAULT NULL,
  `receiver_name` varchar(255) DEFAULT NULL,
  `path` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`intercomID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



-- ----------------------------
-- Records of base_intercom_info
-- ----------------------------

-- ----------------------------
-- Table structure for base_outdoor_info
-- ----------------------------
DROP TABLE IF EXISTS `base_outdoor_info`;
CREATE TABLE `base_outdoor_info` (
  `outdoor_id` int(32) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `building_id` int(32) NOT NULL COMMENT '栋ID',
  `unit_id` int(32) NOT NULL COMMENT '单元ID',
  `outdoor_no` varchar(15) NOT NULL COMMENT '编号',
  `device_ip` varchar(15) NOT NULL COMMENT '设备IP',
  `syn_time` int(32) DEFAULT NULL COMMENT '同步时间',
  `update_time` int(32) DEFAULT NULL COMMENT '更新时间',
  `remark` text COMMENT '备注',
  `device_type` varchar(50) DEFAULT NULL,
  `device_id` varchar(50) DEFAULT NULL,
  `mac` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`outdoor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='门口机信息表';

-- ----------------------------
-- Records of base_outdoor_info
-- ----------------------------

-- ----------------------------
-- Table structure for base_owner_info
-- ----------------------------
DROP TABLE IF EXISTS `base_owner_info`;
CREATE TABLE `base_owner_info` (
  `owner_id` int(32) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `name` varchar(50) NOT NULL COMMENT '业主姓名',
  `avatar` varchar(100) DEFAULT NULL COMMENT '业主头像',
  `building_id` int(32) NOT NULL COMMENT '栋ID',
  `unit_id` int(32) NOT NULL COMMENT '单元ID',
  `room_id` int(32) NOT NULL COMMENT '室ID',
  `phone_primary` varchar(20) DEFAULT NULL COMMENT '联系方式1',
  `is_receive_msg` int(11) DEFAULT '1' COMMENT '是否接收短信',
  `remark` text COMMENT '住户描述',
  `building` varchar(3) DEFAULT NULL,
  `unit` varchar(2) DEFAULT NULL,
  `room` varchar(4) DEFAULT NULL,
  PRIMARY KEY (`owner_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='业主信息表';

-- ----------------------------
-- Records of base_owner_info
-- ----------------------------

-- ----------------------------
-- Table structure for base_permission_info
-- ----------------------------
DROP TABLE IF EXISTS `base_permission_info`;
CREATE TABLE `base_permission_info` (
  `perID` int(32) NOT NULL AUTO_INCREMENT,
  `roleID` int(32) DEFAULT NULL,
  `permission` text,
  PRIMARY KEY (`perID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of base_permission_info
-- ----------------------------

-- ----------------------------
-- Table structure for base_role_info
-- ----------------------------
DROP TABLE IF EXISTS `base_role_info`;
CREATE TABLE `base_role_info` (
  `roleID` int(11) NOT NULL AUTO_INCREMENT,
  `roleName` varchar(30) DEFAULT NULL,
  `remark` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`roleID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of base_role_info
-- ----------------------------

-- ----------------------------
-- Table structure for base_room_info
-- ----------------------------
DROP TABLE IF EXISTS `base_room_info`;
CREATE TABLE `base_room_info` (
  `room_id` int(11) NOT NULL AUTO_INCREMENT,
  `building_id` int(32) DEFAULT NULL COMMENT '楼栋ID',
  `unit_id` int(32) DEFAULT NULL COMMENT '单元ID',
  `room` varchar(50) DEFAULT NULL COMMENT '房间号',
  `remark` text,
  PRIMARY KEY (`room_id`),
  KEY `building_id` (`building_id`) USING BTREE,
  KEY `unit_id` (`unit_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='房间号信息';

-- ----------------------------
-- Records of base_room_info
-- ----------------------------

-- ----------------------------
-- Table structure for base_unit_info
-- ----------------------------
DROP TABLE IF EXISTS `base_unit_info`;
CREATE TABLE `base_unit_info` (
  `unit_id` int(32) NOT NULL AUTO_INCREMENT,
  `building_id` int(32) DEFAULT NULL COMMENT '楼栋ID',
  `unit` varchar(50) DEFAULT NULL COMMENT '单元名称',
  `remark` text,
  PRIMARY KEY (`unit_id`),
  KEY `building_id` (`building_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='单元信息';

-- ----------------------------
-- Records of base_unit_info
-- ----------------------------

-- ----------------------------
-- Table structure for base_user_info
-- ----------------------------
DROP TABLE IF EXISTS `base_user_info`;
CREATE TABLE `base_user_info` (
  `user_id` int(32) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `roleID` int(32) DEFAULT NULL,
  `username` varchar(50) NOT NULL COMMENT '账号',
  `password` varchar(50) NOT NULL COMMENT '密码',
  `privilege` tinyint(2) NOT NULL COMMENT '权限等级 1：超级管理员,2：管理员,3：用户',
  `remark` text COMMENT '备注',
  `sipNo` varchar(20) DEFAULT NULL,
  `sipPassword` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='管理员表';

-- ----------------------------
-- Records of base_user_info
-- ----------------------------

-- ----------------------------
-- Table structure for base_wall_info
-- ----------------------------
DROP TABLE IF EXISTS `base_wall_info`;
CREATE TABLE `base_wall_info` (
  `wall_id` int(32) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `wall_no` varchar(15) NOT NULL COMMENT '设备编号',
  `device_ip` varchar(15) NOT NULL COMMENT '设备IP',
  `syn_time` int(32) DEFAULT NULL COMMENT '同步时间',
  `update_time` int(32) DEFAULT NULL COMMENT '更新时间',
  `remark` text COMMENT '备注',
  `device_type` varchar(50) DEFAULT NULL,
  `device_id` varchar(50) DEFAULT NULL,
  `mac` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`wall_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='围墙机信息表';

-- ----------------------------
-- Records of base_wall_info
-- ----------------------------

-- ----------------------------
-- Table structure for base_watch_info
-- ----------------------------
DROP TABLE IF EXISTS `base_watch_info`;
CREATE TABLE `base_watch_info` (
  `watchID` int(11) NOT NULL AUTO_INCREMENT,
  `caller` varchar(30) DEFAULT NULL,
  `receiver` varchar(30) DEFAULT NULL,
  `duration` varchar(30) DEFAULT NULL,
  `datetime` int(11) DEFAULT NULL,
  `state` varchar(10) DEFAULT NULL,
  `path` text,
  PRIMARY KEY (`watchID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of base_watch_info
-- ----------------------------

-- ----------------------------
-- Table structure for booking_act_info
-- ----------------------------
DROP TABLE IF EXISTS `booking_act_info`;
CREATE TABLE `booking_act_info` (
  `act_info_id` int(32) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `name` varchar(50) NOT NULL COMMENT '活动名称',
  `max` int(10) DEFAULT NULL COMMENT '限额',
  `open_date` varchar(15) DEFAULT NULL COMMENT '开放日期',
  `time_from` varchar(10) DEFAULT NULL COMMENT '活动起始时间',
  `time_to` varchar(10) DEFAULT NULL COMMENT '活动结束时间',
  `remark` text COMMENT '备注',
  PRIMARY KEY (`act_info_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='活动预定表';

-- ----------------------------
-- Records of booking_act_info
-- ----------------------------

-- ----------------------------
-- Table structure for booking_act_record
-- ----------------------------
DROP TABLE IF EXISTS `booking_act_record`;
CREATE TABLE `booking_act_record` (
  `act_record_id` int(32) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `act_info_id` int(32) DEFAULT NULL COMMENT '活动ID',
  `user` varchar(50) DEFAULT NULL COMMENT '预定者',
  `datetime` int(32) DEFAULT NULL COMMENT '预定时间',
  `type` tinyint(2) DEFAULT NULL COMMENT '预定类型 1:室内机 2:手机',
  PRIMARY KEY (`act_record_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='预定活动详情记录表';

-- ----------------------------
-- Records of booking_act_record
-- ----------------------------

-- ----------------------------
-- Table structure for booking_res_info
-- ----------------------------
DROP TABLE IF EXISTS `booking_res_info`;
CREATE TABLE `booking_res_info` (
  `res_info_id` int(32) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `name` varchar(50) NOT NULL COMMENT '资源名称',
  `type` tinyint(2) DEFAULT NULL COMMENT '资源类型 1:独立 2:共享',
  `time_from` varchar(50) DEFAULT NULL COMMENT '起始时间',
  `time_to` varchar(50) DEFAULT NULL COMMENT '终止时间',
  `max_num` int(32) DEFAULT NULL COMMENT '限额',
  `price` decimal(4,2) DEFAULT NULL COMMENT '价格',
  `min_time` int(32) DEFAULT NULL COMMENT '最短预订时间',
  `buffer` int(32) DEFAULT NULL COMMENT '单体预订间隔时间',
  `remark` text COMMENT '描述',
  PRIMARY KEY (`res_info_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='资源预定表';

-- ----------------------------
-- Records of booking_res_info
-- ----------------------------

-- ----------------------------
-- Table structure for booking_res_record
-- ----------------------------
DROP TABLE IF EXISTS `booking_res_record`;
CREATE TABLE `booking_res_record` (
  `res_record_id` int(32) NOT NULL AUTO_INCREMENT,
  `res_info_id` int(32) NOT NULL COMMENT '资源ID',
  `booking_date` int(32) DEFAULT NULL COMMENT '预订生效的日期',
  `time_from` varchar(50) DEFAULT NULL COMMENT '预定起始时间',
  `time_to` varchar(50) DEFAULT NULL COMMENT '预定终止时间',
  `status` tinyint(4) DEFAULT NULL COMMENT '预定状态',
  `user` varchar(50) DEFAULT NULL COMMENT '预定者',
  `datetime` int(32) DEFAULT NULL COMMENT '预定时间',
  PRIMARY KEY (`res_record_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='预订记录表';

-- ----------------------------
-- Records of booking_res_record
-- ----------------------------

-- ----------------------------
-- Table structure for booking_res_status
-- ----------------------------
DROP TABLE IF EXISTS `booking_res_status`;
CREATE TABLE `booking_res_status` (
  `res_status_id` int(32) NOT NULL AUTO_INCREMENT,
  `res_info_id` int(32) NOT NULL COMMENT '资源ID',
  `booking_date` int(32) NOT NULL COMMENT '预订日期',
  `time_from` varchar(50) DEFAULT NULL COMMENT '预定起始时间',
  `time_to` varchar(50) DEFAULT NULL COMMENT '预定终止时间',
  `status` int(32) NOT NULL COMMENT '状态',
  `remaining` int(32) DEFAULT NULL COMMENT '剩余数',
  PRIMARY KEY (`res_status_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='资源状态表';

-- ----------------------------
-- Records of booking_res_status
-- ----------------------------

-- ----------------------------
-- Table structure for call_record
-- ----------------------------
DROP TABLE IF EXISTS `call_record`;
CREATE TABLE `call_record` (
  `id` int(32) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `device_ip` varchar(50) DEFAULT NULL COMMENT '设备IP',
  `device_type` varchar(2) DEFAULT NULL COMMENT '设备类型',
  `datetime` int(32) DEFAULT NULL COMMENT '日期',
  `duration` time DEFAULT NULL COMMENT '通话时长',
  `status` varchar(20) DEFAULT NULL COMMENT '通话状态 1：正常通话，2：未接听、忙，3：未连接上',
  `image` varchar(255) DEFAULT NULL COMMENT '抓拍图片',
  `type` varchar(2) DEFAULT NULL COMMENT '记录类型',
  `caller` varchar(25) DEFAULT NULL COMMENT '呼叫者',
  `receiver` varchar(25) DEFAULT NULL COMMENT '接听者',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='对讲记录表';

-- ----------------------------
-- Records of call_record
-- ----------------------------

-- ----------------------------
-- Table structure for city_info
-- ----------------------------
DROP TABLE IF EXISTS `city_info`;
CREATE TABLE `city_info` (
  `city_id` varchar(9) NOT NULL,
  `province` varchar(20) NOT NULL,
  `city` varchar(20) NOT NULL,
  `district` varchar(20) NOT NULL,
  PRIMARY KEY (`city_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='utf8_general_ci';

-- ----------------------------
-- Records of city_info
-- ----------------------------
INSERT INTO `city_info` VALUES ('101010100', '北京', '北京', '北京');
INSERT INTO `city_info` VALUES ('101010200', '北京', '北京', '海淀');
INSERT INTO `city_info` VALUES ('101010300', '北京', '北京', '朝阳');
INSERT INTO `city_info` VALUES ('101010400', '北京', '北京', '顺义');
INSERT INTO `city_info` VALUES ('101010500', '北京', '北京', '怀柔');
INSERT INTO `city_info` VALUES ('101010600', '北京', '北京', '通州');
INSERT INTO `city_info` VALUES ('101010700', '北京', '北京', '昌平');
INSERT INTO `city_info` VALUES ('101010800', '北京', '北京', '延庆');
INSERT INTO `city_info` VALUES ('101010900', '北京', '北京', '丰台');
INSERT INTO `city_info` VALUES ('101011000', '北京', '北京', '石景山');
INSERT INTO `city_info` VALUES ('101011100', '北京', '北京', '大兴');
INSERT INTO `city_info` VALUES ('101011200', '北京', '北京', '房山');
INSERT INTO `city_info` VALUES ('101011300', '北京', '北京', '密云');
INSERT INTO `city_info` VALUES ('101011400', '北京', '北京', '门头沟');
INSERT INTO `city_info` VALUES ('101011500', '北京', '北京', '平谷');
INSERT INTO `city_info` VALUES ('101020100', '上海', '上海', '上海');
INSERT INTO `city_info` VALUES ('101020200', '上海', '上海', '闵行');
INSERT INTO `city_info` VALUES ('101020300', '上海', '上海', '宝山');
INSERT INTO `city_info` VALUES ('101020500', '上海', '上海', '嘉定');
INSERT INTO `city_info` VALUES ('101020600', '上海', '上海', '浦东南汇');
INSERT INTO `city_info` VALUES ('101020700', '上海', '上海', '金山');
INSERT INTO `city_info` VALUES ('101020800', '上海', '上海', '青浦');
INSERT INTO `city_info` VALUES ('101020900', '上海', '上海', '松江');
INSERT INTO `city_info` VALUES ('101021000', '上海', '上海', '奉贤');
INSERT INTO `city_info` VALUES ('101021100', '上海', '上海', '崇明');
INSERT INTO `city_info` VALUES ('101021200', '上海', '上海', '徐家汇');
INSERT INTO `city_info` VALUES ('101021300', '上海', '上海', '浦东');
INSERT INTO `city_info` VALUES ('101030100', '天津', '天津', '天津');
INSERT INTO `city_info` VALUES ('101030200', '天津', '天津', '武清');
INSERT INTO `city_info` VALUES ('101030300', '天津', '天津', '宝坻');
INSERT INTO `city_info` VALUES ('101030400', '天津', '天津', '东丽');
INSERT INTO `city_info` VALUES ('101030500', '天津', '天津', '西青');
INSERT INTO `city_info` VALUES ('101030600', '天津', '天津', '北辰');
INSERT INTO `city_info` VALUES ('101030700', '天津', '天津', '宁河');
INSERT INTO `city_info` VALUES ('101030800', '天津', '天津', '汉沽');
INSERT INTO `city_info` VALUES ('101030900', '天津', '天津', '静海');
INSERT INTO `city_info` VALUES ('101031000', '天津', '天津', '津南');
INSERT INTO `city_info` VALUES ('101031100', '天津', '天津', '塘沽');
INSERT INTO `city_info` VALUES ('101031200', '天津', '天津', '大港');
INSERT INTO `city_info` VALUES ('101031400', '天津', '天津', '蓟县');
INSERT INTO `city_info` VALUES ('101040100', '重庆', '重庆', '重庆');
INSERT INTO `city_info` VALUES ('101040200', '重庆', '重庆', '永川');
INSERT INTO `city_info` VALUES ('101040300', '重庆', '重庆', '合川');
INSERT INTO `city_info` VALUES ('101040400', '重庆', '重庆', '南川');
INSERT INTO `city_info` VALUES ('101040500', '重庆', '重庆', '江津');
INSERT INTO `city_info` VALUES ('101040600', '重庆', '重庆', '万盛');
INSERT INTO `city_info` VALUES ('101040700', '重庆', '重庆', '渝北');
INSERT INTO `city_info` VALUES ('101040800', '重庆', '重庆', '北碚');
INSERT INTO `city_info` VALUES ('101040900', '重庆', '重庆', '巴南');
INSERT INTO `city_info` VALUES ('101041000', '重庆', '重庆', '长寿');
INSERT INTO `city_info` VALUES ('101041100', '重庆', '重庆', '黔江');
INSERT INTO `city_info` VALUES ('101041300', '重庆', '重庆', '万州');
INSERT INTO `city_info` VALUES ('101041400', '重庆', '重庆', '涪陵');
INSERT INTO `city_info` VALUES ('101041500', '重庆', '重庆', '开县');
INSERT INTO `city_info` VALUES ('101041600', '重庆', '重庆', '城口');
INSERT INTO `city_info` VALUES ('101041700', '重庆', '重庆', '云阳');
INSERT INTO `city_info` VALUES ('101041800', '重庆', '重庆', '巫溪');
INSERT INTO `city_info` VALUES ('101041900', '重庆', '重庆', '奉节');
INSERT INTO `city_info` VALUES ('101042000', '重庆', '重庆', '巫山');
INSERT INTO `city_info` VALUES ('101042100', '重庆', '重庆', '潼南');
INSERT INTO `city_info` VALUES ('101042200', '重庆', '重庆', '垫江');
INSERT INTO `city_info` VALUES ('101042300', '重庆', '重庆', '梁平');
INSERT INTO `city_info` VALUES ('101042400', '重庆', '重庆', '忠县');
INSERT INTO `city_info` VALUES ('101042500', '重庆', '重庆', '石柱');
INSERT INTO `city_info` VALUES ('101042600', '重庆', '重庆', '大足');
INSERT INTO `city_info` VALUES ('101042700', '重庆', '重庆', '荣昌');
INSERT INTO `city_info` VALUES ('101042800', '重庆', '重庆', '铜梁');
INSERT INTO `city_info` VALUES ('101042900', '重庆', '重庆', '璧山');
INSERT INTO `city_info` VALUES ('101043000', '重庆', '重庆', '丰都');
INSERT INTO `city_info` VALUES ('101043100', '重庆', '重庆', '武隆');
INSERT INTO `city_info` VALUES ('101043200', '重庆', '重庆', '彭水');
INSERT INTO `city_info` VALUES ('101043300', '重庆', '重庆', '綦江');
INSERT INTO `city_info` VALUES ('101043400', '重庆', '重庆', '酉阳');
INSERT INTO `city_info` VALUES ('101043600', '重庆', '重庆', '秀山');
INSERT INTO `city_info` VALUES ('101050101', '黑龙江', '哈尔滨', '哈尔滨');
INSERT INTO `city_info` VALUES ('101050102', '黑龙江', '哈尔滨', '双城');
INSERT INTO `city_info` VALUES ('101050103', '黑龙江', '哈尔滨', '呼兰');
INSERT INTO `city_info` VALUES ('101050104', '黑龙江', '哈尔滨', '阿城');
INSERT INTO `city_info` VALUES ('101050105', '黑龙江', '哈尔滨', '宾县');
INSERT INTO `city_info` VALUES ('101050106', '黑龙江', '哈尔滨', '依兰');
INSERT INTO `city_info` VALUES ('101050107', '黑龙江', '哈尔滨', '巴彦');
INSERT INTO `city_info` VALUES ('101050108', '黑龙江', '哈尔滨', '通河');
INSERT INTO `city_info` VALUES ('101050109', '黑龙江', '哈尔滨', '方正');
INSERT INTO `city_info` VALUES ('101050110', '黑龙江', '哈尔滨', '延寿');
INSERT INTO `city_info` VALUES ('101050111', '黑龙江', '哈尔滨', '尚志');
INSERT INTO `city_info` VALUES ('101050112', '黑龙江', '哈尔滨', '五常');
INSERT INTO `city_info` VALUES ('101050113', '黑龙江', '哈尔滨', '木兰');
INSERT INTO `city_info` VALUES ('101050201', '黑龙江', '齐齐哈尔', '齐齐哈尔');
INSERT INTO `city_info` VALUES ('101050202', '黑龙江', '齐齐哈尔', '讷河');
INSERT INTO `city_info` VALUES ('101050203', '黑龙江', '齐齐哈尔', '龙江');
INSERT INTO `city_info` VALUES ('101050204', '黑龙江', '齐齐哈尔', '甘南');
INSERT INTO `city_info` VALUES ('101050205', '黑龙江', '齐齐哈尔', '富裕');
INSERT INTO `city_info` VALUES ('101050206', '黑龙江', '齐齐哈尔', '依安');
INSERT INTO `city_info` VALUES ('101050207', '黑龙江', '齐齐哈尔', '拜泉');
INSERT INTO `city_info` VALUES ('101050208', '黑龙江', '齐齐哈尔', '克山');
INSERT INTO `city_info` VALUES ('101050209', '黑龙江', '齐齐哈尔', '克东');
INSERT INTO `city_info` VALUES ('101050210', '黑龙江', '齐齐哈尔', '泰来');
INSERT INTO `city_info` VALUES ('101050301', '黑龙江', '牡丹江', '牡丹江');
INSERT INTO `city_info` VALUES ('101050302', '黑龙江', '牡丹江', '海林');
INSERT INTO `city_info` VALUES ('101050303', '黑龙江', '牡丹江', '穆棱');
INSERT INTO `city_info` VALUES ('101050304', '黑龙江', '牡丹江', '林口');
INSERT INTO `city_info` VALUES ('101050305', '黑龙江', '牡丹江', '绥芬河');
INSERT INTO `city_info` VALUES ('101050306', '黑龙江', '牡丹江', '宁安');
INSERT INTO `city_info` VALUES ('101050307', '黑龙江', '牡丹江', '东宁');
INSERT INTO `city_info` VALUES ('101050401', '黑龙江', '佳木斯', '佳木斯');
INSERT INTO `city_info` VALUES ('101050402', '黑龙江', '佳木斯', '汤原');
INSERT INTO `city_info` VALUES ('101050403', '黑龙江', '佳木斯', '抚远');
INSERT INTO `city_info` VALUES ('101050404', '黑龙江', '佳木斯', '桦川');
INSERT INTO `city_info` VALUES ('101050405', '黑龙江', '佳木斯', '桦南');
INSERT INTO `city_info` VALUES ('101050406', '黑龙江', '佳木斯', '同江');
INSERT INTO `city_info` VALUES ('101050407', '黑龙江', '佳木斯', '富锦');
INSERT INTO `city_info` VALUES ('101050501', '黑龙江', '绥化', '绥化');
INSERT INTO `city_info` VALUES ('101050502', '黑龙江', '绥化', '肇东');
INSERT INTO `city_info` VALUES ('101050503', '黑龙江', '绥化', '安达');
INSERT INTO `city_info` VALUES ('101050504', '黑龙江', '绥化', '海伦');
INSERT INTO `city_info` VALUES ('101050505', '黑龙江', '绥化', '明水');
INSERT INTO `city_info` VALUES ('101050506', '黑龙江', '绥化', '望奎');
INSERT INTO `city_info` VALUES ('101050507', '黑龙江', '绥化', '兰西');
INSERT INTO `city_info` VALUES ('101050508', '黑龙江', '绥化', '青冈');
INSERT INTO `city_info` VALUES ('101050509', '黑龙江', '绥化', '庆安');
INSERT INTO `city_info` VALUES ('101050510', '黑龙江', '绥化', '绥棱');
INSERT INTO `city_info` VALUES ('101050601', '黑龙江', '黑河', '黑河');
INSERT INTO `city_info` VALUES ('101050602', '黑龙江', '黑河', '嫩江');
INSERT INTO `city_info` VALUES ('101050603', '黑龙江', '黑河', '孙吴');
INSERT INTO `city_info` VALUES ('101050604', '黑龙江', '黑河', '逊克');
INSERT INTO `city_info` VALUES ('101050605', '黑龙江', '黑河', '五大连池');
INSERT INTO `city_info` VALUES ('101050606', '黑龙江', '黑河', '北安');
INSERT INTO `city_info` VALUES ('101050701', '黑龙江', '大兴安岭', '大兴安岭');
INSERT INTO `city_info` VALUES ('101050702', '黑龙江', '大兴安岭', '塔河');
INSERT INTO `city_info` VALUES ('101050703', '黑龙江', '大兴安岭', '漠河');
INSERT INTO `city_info` VALUES ('101050704', '黑龙江', '大兴安岭', '呼玛');
INSERT INTO `city_info` VALUES ('101050705', '黑龙江', '大兴安岭', '呼中');
INSERT INTO `city_info` VALUES ('101050706', '黑龙江', '大兴安岭', '新林');
INSERT INTO `city_info` VALUES ('101050708', '黑龙江', '大兴安岭', '加格达奇');
INSERT INTO `city_info` VALUES ('101050801', '黑龙江', '伊春', '伊春');
INSERT INTO `city_info` VALUES ('101050802', '黑龙江', '伊春', '乌伊岭');
INSERT INTO `city_info` VALUES ('101050803', '黑龙江', '伊春', '五营');
INSERT INTO `city_info` VALUES ('101050804', '黑龙江', '伊春', '铁力');
INSERT INTO `city_info` VALUES ('101050805', '黑龙江', '伊春', '嘉荫');
INSERT INTO `city_info` VALUES ('101050901', '黑龙江', '大庆', '大庆');
INSERT INTO `city_info` VALUES ('101050902', '黑龙江', '大庆', '林甸');
INSERT INTO `city_info` VALUES ('101050903', '黑龙江', '大庆', '肇州');
INSERT INTO `city_info` VALUES ('101050904', '黑龙江', '大庆', '肇源');
INSERT INTO `city_info` VALUES ('101050905', '黑龙江', '大庆', '杜尔伯特');
INSERT INTO `city_info` VALUES ('101051002', '黑龙江', '七台河', '七台河');
INSERT INTO `city_info` VALUES ('101051003', '黑龙江', '七台河', '勃利');
INSERT INTO `city_info` VALUES ('101051101', '黑龙江', '鸡西', '鸡西');
INSERT INTO `city_info` VALUES ('101051102', '黑龙江', '鸡西', '虎林');
INSERT INTO `city_info` VALUES ('101051103', '黑龙江', '鸡西', '密山');
INSERT INTO `city_info` VALUES ('101051104', '黑龙江', '鸡西', '鸡东');
INSERT INTO `city_info` VALUES ('101051201', '黑龙江', '鹤岗', '鹤岗');
INSERT INTO `city_info` VALUES ('101051202', '黑龙江', '鹤岗', '绥滨');
INSERT INTO `city_info` VALUES ('101051203', '黑龙江', '鹤岗', '萝北');
INSERT INTO `city_info` VALUES ('101051301', '黑龙江', '双鸭山', '双鸭山');
INSERT INTO `city_info` VALUES ('101051302', '黑龙江', '双鸭山', '集贤');
INSERT INTO `city_info` VALUES ('101051303', '黑龙江', '双鸭山', '宝清');
INSERT INTO `city_info` VALUES ('101051304', '黑龙江', '双鸭山', '饶河');
INSERT INTO `city_info` VALUES ('101051305', '黑龙江', '双鸭山', '友谊');
INSERT INTO `city_info` VALUES ('101060101', '吉林', '长春', '长春');
INSERT INTO `city_info` VALUES ('101060102', '吉林', '长春', '农安');
INSERT INTO `city_info` VALUES ('101060103', '吉林', '长春', '德惠');
INSERT INTO `city_info` VALUES ('101060104', '吉林', '长春', '九台');
INSERT INTO `city_info` VALUES ('101060105', '吉林', '长春', '榆树');
INSERT INTO `city_info` VALUES ('101060106', '吉林', '长春', '双阳');
INSERT INTO `city_info` VALUES ('101060201', '吉林', '吉林', '吉林');
INSERT INTO `city_info` VALUES ('101060202', '吉林', '吉林', '舒兰');
INSERT INTO `city_info` VALUES ('101060203', '吉林', '吉林', '永吉');
INSERT INTO `city_info` VALUES ('101060204', '吉林', '吉林', '蛟河');
INSERT INTO `city_info` VALUES ('101060205', '吉林', '吉林', '磐石');
INSERT INTO `city_info` VALUES ('101060206', '吉林', '吉林', '桦甸');
INSERT INTO `city_info` VALUES ('101060301', '吉林', '延边', '延吉');
INSERT INTO `city_info` VALUES ('101060302', '吉林', '延边', '敦化');
INSERT INTO `city_info` VALUES ('101060303', '吉林', '延边', '安图');
INSERT INTO `city_info` VALUES ('101060304', '吉林', '延边', '汪清');
INSERT INTO `city_info` VALUES ('101060305', '吉林', '延边', '和龙');
INSERT INTO `city_info` VALUES ('101060307', '吉林', '延边', '龙井');
INSERT INTO `city_info` VALUES ('101060308', '吉林', '延边', '珲春');
INSERT INTO `city_info` VALUES ('101060309', '吉林', '延边', '图们');
INSERT INTO `city_info` VALUES ('101060401', '吉林', '四平', '四平');
INSERT INTO `city_info` VALUES ('101060402', '吉林', '四平', '双辽');
INSERT INTO `city_info` VALUES ('101060403', '吉林', '四平', '梨树');
INSERT INTO `city_info` VALUES ('101060404', '吉林', '四平', '公主岭');
INSERT INTO `city_info` VALUES ('101060405', '吉林', '四平', '伊通');
INSERT INTO `city_info` VALUES ('101060501', '吉林', '通化', '通化');
INSERT INTO `city_info` VALUES ('101060502', '吉林', '通化', '梅河口');
INSERT INTO `city_info` VALUES ('101060503', '吉林', '通化', '柳河');
INSERT INTO `city_info` VALUES ('101060504', '吉林', '通化', '辉南');
INSERT INTO `city_info` VALUES ('101060505', '吉林', '通化', '集安');
INSERT INTO `city_info` VALUES ('101060506', '吉林', '通化', '通化县');
INSERT INTO `city_info` VALUES ('101060601', '吉林', '白城', '白城');
INSERT INTO `city_info` VALUES ('101060602', '吉林', '白城', '洮南');
INSERT INTO `city_info` VALUES ('101060603', '吉林', '白城', '大安');
INSERT INTO `city_info` VALUES ('101060604', '吉林', '白城', '镇赉');
INSERT INTO `city_info` VALUES ('101060605', '吉林', '白城', '通榆');
INSERT INTO `city_info` VALUES ('101060701', '吉林', '辽源', '辽源');
INSERT INTO `city_info` VALUES ('101060702', '吉林', '辽源', '东丰');
INSERT INTO `city_info` VALUES ('101060703', '吉林', '辽源', '东辽');
INSERT INTO `city_info` VALUES ('101060801', '吉林', '松原', '松原');
INSERT INTO `city_info` VALUES ('101060802', '吉林', '松原', '乾安');
INSERT INTO `city_info` VALUES ('101060803', '吉林', '松原', '前郭');
INSERT INTO `city_info` VALUES ('101060804', '吉林', '松原', '长岭');
INSERT INTO `city_info` VALUES ('101060805', '吉林', '松原', '扶余');
INSERT INTO `city_info` VALUES ('101060901', '吉林', '白山', '白山');
INSERT INTO `city_info` VALUES ('101060902', '吉林', '白山', '靖宇');
INSERT INTO `city_info` VALUES ('101060903', '吉林', '白山', '临江');
INSERT INTO `city_info` VALUES ('101060904', '吉林', '白山', '东岗');
INSERT INTO `city_info` VALUES ('101060905', '吉林', '白山', '长白');
INSERT INTO `city_info` VALUES ('101060906', '吉林', '白山', '抚松');
INSERT INTO `city_info` VALUES ('101060907', '吉林', '白山', '江源');
INSERT INTO `city_info` VALUES ('101070101', '辽宁', '沈阳', '沈阳');
INSERT INTO `city_info` VALUES ('101070103', '辽宁', '沈阳', '辽中');
INSERT INTO `city_info` VALUES ('101070104', '辽宁', '沈阳', '康平');
INSERT INTO `city_info` VALUES ('101070105', '辽宁', '沈阳', '法库');
INSERT INTO `city_info` VALUES ('101070106', '辽宁', '沈阳', '新民');
INSERT INTO `city_info` VALUES ('101070201', '辽宁', '大连', '大连');
INSERT INTO `city_info` VALUES ('101070202', '辽宁', '大连', '瓦房店');
INSERT INTO `city_info` VALUES ('101070203', '辽宁', '大连', '金州');
INSERT INTO `city_info` VALUES ('101070204', '辽宁', '大连', '普兰店');
INSERT INTO `city_info` VALUES ('101070205', '辽宁', '大连', '旅顺');
INSERT INTO `city_info` VALUES ('101070206', '辽宁', '大连', '长海');
INSERT INTO `city_info` VALUES ('101070207', '辽宁', '大连', '庄河');
INSERT INTO `city_info` VALUES ('101070301', '辽宁', '鞍山', '鞍山');
INSERT INTO `city_info` VALUES ('101070302', '辽宁', '鞍山', '台安');
INSERT INTO `city_info` VALUES ('101070303', '辽宁', '鞍山', '岫岩');
INSERT INTO `city_info` VALUES ('101070304', '辽宁', '鞍山', '海城');
INSERT INTO `city_info` VALUES ('101070401', '辽宁', '抚顺', '抚顺');
INSERT INTO `city_info` VALUES ('101070402', '辽宁', '抚顺', '新宾');
INSERT INTO `city_info` VALUES ('101070403', '辽宁', '抚顺', '清原');
INSERT INTO `city_info` VALUES ('101070404', '辽宁', '抚顺', '章党');
INSERT INTO `city_info` VALUES ('101070501', '辽宁', '本溪', '本溪');
INSERT INTO `city_info` VALUES ('101070502', '辽宁', '本溪', '本溪县');
INSERT INTO `city_info` VALUES ('101070504', '辽宁', '本溪', '桓仁');
INSERT INTO `city_info` VALUES ('101070601', '辽宁', '丹东', '丹东');
INSERT INTO `city_info` VALUES ('101070602', '辽宁', '丹东', '凤城');
INSERT INTO `city_info` VALUES ('101070603', '辽宁', '丹东', '宽甸');
INSERT INTO `city_info` VALUES ('101070604', '辽宁', '丹东', '东港');
INSERT INTO `city_info` VALUES ('101070701', '辽宁', '锦州', '锦州');
INSERT INTO `city_info` VALUES ('101070702', '辽宁', '锦州', '凌海');
INSERT INTO `city_info` VALUES ('101070704', '辽宁', '锦州', '义县');
INSERT INTO `city_info` VALUES ('101070705', '辽宁', '锦州', '黑山');
INSERT INTO `city_info` VALUES ('101070706', '辽宁', '锦州', '北镇');
INSERT INTO `city_info` VALUES ('101070801', '辽宁', '营口', '营口');
INSERT INTO `city_info` VALUES ('101070802', '辽宁', '营口', '大石桥');
INSERT INTO `city_info` VALUES ('101070803', '辽宁', '营口', '盖州');
INSERT INTO `city_info` VALUES ('101070901', '辽宁', '阜新', '阜新');
INSERT INTO `city_info` VALUES ('101070902', '辽宁', '阜新', '彰武');
INSERT INTO `city_info` VALUES ('101071001', '辽宁', '辽阳', '辽阳');
INSERT INTO `city_info` VALUES ('101071002', '辽宁', '辽阳', '辽阳县');
INSERT INTO `city_info` VALUES ('101071003', '辽宁', '辽阳', '灯塔');
INSERT INTO `city_info` VALUES ('101071004', '辽宁', '辽阳', '弓长岭');
INSERT INTO `city_info` VALUES ('101071101', '辽宁', '铁岭', '铁岭');
INSERT INTO `city_info` VALUES ('101071102', '辽宁', '铁岭', '开原');
INSERT INTO `city_info` VALUES ('101071103', '辽宁', '铁岭', '昌图');
INSERT INTO `city_info` VALUES ('101071104', '辽宁', '铁岭', '西丰');
INSERT INTO `city_info` VALUES ('101071105', '辽宁', '铁岭', '调兵山');
INSERT INTO `city_info` VALUES ('101071201', '辽宁', '朝阳', '朝阳');
INSERT INTO `city_info` VALUES ('101071203', '辽宁', '朝阳', '凌源');
INSERT INTO `city_info` VALUES ('101071204', '辽宁', '朝阳', '喀左');
INSERT INTO `city_info` VALUES ('101071205', '辽宁', '朝阳', '北票');
INSERT INTO `city_info` VALUES ('101071207', '辽宁', '朝阳', '建平县');
INSERT INTO `city_info` VALUES ('101071301', '辽宁', '盘锦', '盘锦');
INSERT INTO `city_info` VALUES ('101071302', '辽宁', '盘锦', '大洼');
INSERT INTO `city_info` VALUES ('101071303', '辽宁', '盘锦', '盘山');
INSERT INTO `city_info` VALUES ('101071401', '辽宁', '葫芦岛', '葫芦岛');
INSERT INTO `city_info` VALUES ('101071402', '辽宁', '葫芦岛', '建昌');
INSERT INTO `city_info` VALUES ('101071403', '辽宁', '葫芦岛', '绥中');
INSERT INTO `city_info` VALUES ('101071404', '辽宁', '葫芦岛', '兴城');
INSERT INTO `city_info` VALUES ('101080101', '内蒙古', '呼和浩特', '呼和浩特');
INSERT INTO `city_info` VALUES ('101080102', '内蒙古', '呼和浩特', '土左旗');
INSERT INTO `city_info` VALUES ('101080103', '内蒙古', '呼和浩特', '托县');
INSERT INTO `city_info` VALUES ('101080104', '内蒙古', '呼和浩特', '和林');
INSERT INTO `city_info` VALUES ('101080105', '内蒙古', '呼和浩特', '清水河');
INSERT INTO `city_info` VALUES ('101080106', '内蒙古', '呼和浩特', '呼市郊区');
INSERT INTO `city_info` VALUES ('101080107', '内蒙古', '呼和浩特', '武川');
INSERT INTO `city_info` VALUES ('101080201', '内蒙古', '包头', '包头');
INSERT INTO `city_info` VALUES ('101080202', '内蒙古', '包头', '白云鄂博');
INSERT INTO `city_info` VALUES ('101080203', '内蒙古', '包头', '满都拉');
INSERT INTO `city_info` VALUES ('101080204', '内蒙古', '包头', '土右旗');
INSERT INTO `city_info` VALUES ('101080205', '内蒙古', '包头', '固阳');
INSERT INTO `city_info` VALUES ('101080206', '内蒙古', '包头', '达茂旗');
INSERT INTO `city_info` VALUES ('101080207', '内蒙古', '包头', '希拉穆仁');
INSERT INTO `city_info` VALUES ('101080301', '内蒙古', '乌海', '乌海');
INSERT INTO `city_info` VALUES ('101080401', '内蒙古', '乌兰察布', '乌兰察布');
INSERT INTO `city_info` VALUES ('101080402', '内蒙古', '乌兰察布', '卓资');
INSERT INTO `city_info` VALUES ('101080403', '内蒙古', '乌兰察布', '化德');
INSERT INTO `city_info` VALUES ('101080404', '内蒙古', '乌兰察布', '商都');
INSERT INTO `city_info` VALUES ('101080406', '内蒙古', '乌兰察布', '兴和');
INSERT INTO `city_info` VALUES ('101080407', '内蒙古', '乌兰察布', '凉城');
INSERT INTO `city_info` VALUES ('101080408', '内蒙古', '乌兰察布', '察右前旗');
INSERT INTO `city_info` VALUES ('101080409', '内蒙古', '乌兰察布', '察右中旗');
INSERT INTO `city_info` VALUES ('101080410', '内蒙古', '乌兰察布', '察右后旗');
INSERT INTO `city_info` VALUES ('101080411', '内蒙古', '乌兰察布', '四子王旗');
INSERT INTO `city_info` VALUES ('101080412', '内蒙古', '乌兰察布', '丰镇');
INSERT INTO `city_info` VALUES ('101080501', '内蒙古', '通辽', '通辽');
INSERT INTO `city_info` VALUES ('101080502', '内蒙古', '通辽', '舍伯吐');
INSERT INTO `city_info` VALUES ('101080503', '内蒙古', '通辽', '科左中旗');
INSERT INTO `city_info` VALUES ('101080504', '内蒙古', '通辽', '科左后旗');
INSERT INTO `city_info` VALUES ('101080505', '内蒙古', '通辽', '青龙山');
INSERT INTO `city_info` VALUES ('101080506', '内蒙古', '通辽', '开鲁');
INSERT INTO `city_info` VALUES ('101080507', '内蒙古', '通辽', '库伦');
INSERT INTO `city_info` VALUES ('101080508', '内蒙古', '通辽', '奈曼');
INSERT INTO `city_info` VALUES ('101080509', '内蒙古', '通辽', '扎鲁特');
INSERT INTO `city_info` VALUES ('101080510', '内蒙古', '兴安盟', '兴安盟');
INSERT INTO `city_info` VALUES ('101080511', '内蒙古', '通辽', '巴雅尔吐胡硕');
INSERT INTO `city_info` VALUES ('101080601', '内蒙古', '赤峰', '赤峰');
INSERT INTO `city_info` VALUES ('101080603', '内蒙古', '赤峰', '阿鲁旗');
INSERT INTO `city_info` VALUES ('101080604', '内蒙古', '赤峰', '浩尔吐');
INSERT INTO `city_info` VALUES ('101080605', '内蒙古', '赤峰', '巴林左旗');
INSERT INTO `city_info` VALUES ('101080606', '内蒙古', '赤峰', '巴林右旗');
INSERT INTO `city_info` VALUES ('101080607', '内蒙古', '赤峰', '林西');
INSERT INTO `city_info` VALUES ('101080608', '内蒙古', '赤峰', '克什克腾');
INSERT INTO `city_info` VALUES ('101080609', '内蒙古', '赤峰', '翁牛特');
INSERT INTO `city_info` VALUES ('101080610', '内蒙古', '赤峰', '岗子');
INSERT INTO `city_info` VALUES ('101080611', '内蒙古', '赤峰', '喀喇沁');
INSERT INTO `city_info` VALUES ('101080612', '内蒙古', '赤峰', '八里罕');
INSERT INTO `city_info` VALUES ('101080613', '内蒙古', '赤峰', '宁城');
INSERT INTO `city_info` VALUES ('101080614', '内蒙古', '赤峰', '敖汉');
INSERT INTO `city_info` VALUES ('101080615', '内蒙古', '赤峰', '宝国吐');
INSERT INTO `city_info` VALUES ('101080701', '内蒙古', '鄂尔多斯', '鄂尔多斯');
INSERT INTO `city_info` VALUES ('101080703', '内蒙古', '鄂尔多斯', '达拉特');
INSERT INTO `city_info` VALUES ('101080704', '内蒙古', '鄂尔多斯', '准格尔');
INSERT INTO `city_info` VALUES ('101080705', '内蒙古', '鄂尔多斯', '鄂前旗');
INSERT INTO `city_info` VALUES ('101080706', '内蒙古', '鄂尔多斯', '河南');
INSERT INTO `city_info` VALUES ('101080707', '内蒙古', '鄂尔多斯', '伊克乌素');
INSERT INTO `city_info` VALUES ('101080708', '内蒙古', '鄂尔多斯', '鄂托克');
INSERT INTO `city_info` VALUES ('101080709', '内蒙古', '鄂尔多斯', '杭锦旗');
INSERT INTO `city_info` VALUES ('101080710', '内蒙古', '鄂尔多斯', '乌审旗');
INSERT INTO `city_info` VALUES ('101080711', '内蒙古', '鄂尔多斯', '伊金霍洛');
INSERT INTO `city_info` VALUES ('101080712', '内蒙古', '鄂尔多斯', '乌审召');
INSERT INTO `city_info` VALUES ('101080713', '内蒙古', '鄂尔多斯', '东胜');
INSERT INTO `city_info` VALUES ('101080801', '内蒙古', '巴彦淖尔', '巴彦淖尔');
INSERT INTO `city_info` VALUES ('101080802', '内蒙古', '巴彦淖尔', '五原');
INSERT INTO `city_info` VALUES ('101080803', '内蒙古', '巴彦淖尔', '磴口');
INSERT INTO `city_info` VALUES ('101080804', '内蒙古', '巴彦淖尔', '乌前旗');
INSERT INTO `city_info` VALUES ('101080805', '内蒙古', '巴彦淖尔', '大佘太');
INSERT INTO `city_info` VALUES ('101080806', '内蒙古', '巴彦淖尔', '乌中旗');
INSERT INTO `city_info` VALUES ('101080807', '内蒙古', '巴彦淖尔', '乌后旗');
INSERT INTO `city_info` VALUES ('101080808', '内蒙古', '巴彦淖尔', '海力素');
INSERT INTO `city_info` VALUES ('101080809', '内蒙古', '巴彦淖尔', '那仁宝力格');
INSERT INTO `city_info` VALUES ('101080810', '内蒙古', '巴彦淖尔', '杭锦后旗');
INSERT INTO `city_info` VALUES ('101080901', '内蒙古', '锡林郭勒', '锡林郭勒');
INSERT INTO `city_info` VALUES ('101080903', '内蒙古', '锡林郭勒', '二连浩特');
INSERT INTO `city_info` VALUES ('101080904', '内蒙古', '锡林郭勒', '阿巴嘎');
INSERT INTO `city_info` VALUES ('101080906', '内蒙古', '锡林郭勒', '苏左旗');
INSERT INTO `city_info` VALUES ('101080907', '内蒙古', '锡林郭勒', '苏右旗');
INSERT INTO `city_info` VALUES ('101080908', '内蒙古', '锡林郭勒', '朱日和');
INSERT INTO `city_info` VALUES ('101080909', '内蒙古', '锡林郭勒', '东乌旗');
INSERT INTO `city_info` VALUES ('101080910', '内蒙古', '锡林郭勒', '西乌旗');
INSERT INTO `city_info` VALUES ('101080911', '内蒙古', '锡林郭勒', '太仆寺');
INSERT INTO `city_info` VALUES ('101080912', '内蒙古', '锡林郭勒', '镶黄旗');
INSERT INTO `city_info` VALUES ('101080913', '内蒙古', '锡林郭勒', '正镶白旗');
INSERT INTO `city_info` VALUES ('101080914', '内蒙古', '锡林郭勒', '正蓝旗');
INSERT INTO `city_info` VALUES ('101080915', '内蒙古', '锡林郭勒', '多伦');
INSERT INTO `city_info` VALUES ('101080916', '内蒙古', '锡林郭勒', '博克图');
INSERT INTO `city_info` VALUES ('101080917', '内蒙古', '锡林郭勒', '乌拉盖');
INSERT INTO `city_info` VALUES ('101081001', '内蒙古', '呼伦贝尔', '呼伦贝尔');
INSERT INTO `city_info` VALUES ('101081002', '内蒙古', '呼伦贝尔', '小二沟');
INSERT INTO `city_info` VALUES ('101081003', '内蒙古', '呼伦贝尔', '阿荣旗');
INSERT INTO `city_info` VALUES ('101081004', '内蒙古', '呼伦贝尔', '莫力达瓦');
INSERT INTO `city_info` VALUES ('101081005', '内蒙古', '呼伦贝尔', '鄂伦春旗');
INSERT INTO `city_info` VALUES ('101081006', '内蒙古', '呼伦贝尔', '鄂温克旗');
INSERT INTO `city_info` VALUES ('101081007', '内蒙古', '呼伦贝尔', '陈旗');
INSERT INTO `city_info` VALUES ('101081008', '内蒙古', '呼伦贝尔', '新左旗');
INSERT INTO `city_info` VALUES ('101081009', '内蒙古', '呼伦贝尔', '新右旗');
INSERT INTO `city_info` VALUES ('101081010', '内蒙古', '呼伦贝尔', '满洲里');
INSERT INTO `city_info` VALUES ('101081011', '内蒙古', '呼伦贝尔', '牙克石');
INSERT INTO `city_info` VALUES ('101081012', '内蒙古', '呼伦贝尔', '扎兰屯');
INSERT INTO `city_info` VALUES ('101081014', '内蒙古', '呼伦贝尔', '额尔古纳');
INSERT INTO `city_info` VALUES ('101081015', '内蒙古', '呼伦贝尔', '根河');
INSERT INTO `city_info` VALUES ('101081016', '内蒙古', '呼伦贝尔', '图里河');
INSERT INTO `city_info` VALUES ('101081101', '内蒙古', '兴安盟', '乌兰浩特');
INSERT INTO `city_info` VALUES ('101081102', '内蒙古', '兴安盟', '阿尔山');
INSERT INTO `city_info` VALUES ('101081103', '内蒙古', '兴安盟', '科右中旗');
INSERT INTO `city_info` VALUES ('101081104', '内蒙古', '兴安盟', '胡尔勒');
INSERT INTO `city_info` VALUES ('101081105', '内蒙古', '兴安盟', '扎赉特');
INSERT INTO `city_info` VALUES ('101081106', '内蒙古', '兴安盟', '索伦');
INSERT INTO `city_info` VALUES ('101081107', '内蒙古', '兴安盟', '突泉');
INSERT INTO `city_info` VALUES ('101081108', '内蒙古', '通辽', '霍林郭勒');
INSERT INTO `city_info` VALUES ('101081109', '内蒙古', '兴安盟', '科右前旗');
INSERT INTO `city_info` VALUES ('101081201', '内蒙古', '阿拉善盟', '阿拉善盟');
INSERT INTO `city_info` VALUES ('101081202', '内蒙古', '阿拉善盟', '阿右旗');
INSERT INTO `city_info` VALUES ('101081203', '内蒙古', '阿拉善盟', '额济纳');
INSERT INTO `city_info` VALUES ('101081204', '内蒙古', '阿拉善盟', '拐子湖');
INSERT INTO `city_info` VALUES ('101081205', '内蒙古', '阿拉善盟', '吉兰太');
INSERT INTO `city_info` VALUES ('101081206', '内蒙古', '阿拉善盟', '锡林高勒');
INSERT INTO `city_info` VALUES ('101081207', '内蒙古', '阿拉善盟', '头道湖');
INSERT INTO `city_info` VALUES ('101081208', '内蒙古', '阿拉善盟', '中泉子');
INSERT INTO `city_info` VALUES ('101081209', '内蒙古', '阿拉善盟', '诺尔公');
INSERT INTO `city_info` VALUES ('101081210', '内蒙古', '阿拉善盟', '雅布赖');
INSERT INTO `city_info` VALUES ('101081211', '内蒙古', '阿拉善盟', '乌斯泰');
INSERT INTO `city_info` VALUES ('101081212', '内蒙古', '阿拉善盟', '孪井滩');
INSERT INTO `city_info` VALUES ('101090101', '河北', '石家庄', '石家庄');
INSERT INTO `city_info` VALUES ('101090102', '河北', '石家庄', '井陉');
INSERT INTO `city_info` VALUES ('101090103', '河北', '石家庄', '正定');
INSERT INTO `city_info` VALUES ('101090104', '河北', '石家庄', '栾城');
INSERT INTO `city_info` VALUES ('101090105', '河北', '石家庄', '行唐');
INSERT INTO `city_info` VALUES ('101090106', '河北', '石家庄', '灵寿');
INSERT INTO `city_info` VALUES ('101090107', '河北', '石家庄', '高邑');
INSERT INTO `city_info` VALUES ('101090108', '河北', '石家庄', '深泽');
INSERT INTO `city_info` VALUES ('101090109', '河北', '石家庄', '赞皇');
INSERT INTO `city_info` VALUES ('101090110', '河北', '石家庄', '无极');
INSERT INTO `city_info` VALUES ('101090111', '河北', '石家庄', '平山');
INSERT INTO `city_info` VALUES ('101090112', '河北', '石家庄', '元氏');
INSERT INTO `city_info` VALUES ('101090113', '河北', '石家庄', '赵县');
INSERT INTO `city_info` VALUES ('101090114', '河北', '石家庄', '辛集');
INSERT INTO `city_info` VALUES ('101090115', '河北', '石家庄', '藁城');
INSERT INTO `city_info` VALUES ('101090116', '河北', '石家庄', '晋州');
INSERT INTO `city_info` VALUES ('101090117', '河北', '石家庄', '新乐');
INSERT INTO `city_info` VALUES ('101090118', '河北', '石家庄', '鹿泉');
INSERT INTO `city_info` VALUES ('101090201', '河北', '保定', '保定');
INSERT INTO `city_info` VALUES ('101090202', '河北', '保定', '满城');
INSERT INTO `city_info` VALUES ('101090203', '河北', '保定', '阜平');
INSERT INTO `city_info` VALUES ('101090204', '河北', '保定', '徐水');
INSERT INTO `city_info` VALUES ('101090205', '河北', '保定', '唐县');
INSERT INTO `city_info` VALUES ('101090206', '河北', '保定', '高阳');
INSERT INTO `city_info` VALUES ('101090207', '河北', '保定', '容城');
INSERT INTO `city_info` VALUES ('101090209', '河北', '保定', '涞源');
INSERT INTO `city_info` VALUES ('101090210', '河北', '保定', '望都');
INSERT INTO `city_info` VALUES ('101090211', '河北', '保定', '安新');
INSERT INTO `city_info` VALUES ('101090212', '河北', '保定', '易县');
INSERT INTO `city_info` VALUES ('101090214', '河北', '保定', '曲阳');
INSERT INTO `city_info` VALUES ('101090215', '河北', '保定', '蠡县');
INSERT INTO `city_info` VALUES ('101090216', '河北', '保定', '顺平');
INSERT INTO `city_info` VALUES ('101090217', '河北', '保定', '雄县');
INSERT INTO `city_info` VALUES ('101090218', '河北', '保定', '涿州');
INSERT INTO `city_info` VALUES ('101090219', '河北', '保定', '定州');
INSERT INTO `city_info` VALUES ('101090220', '河北', '保定', '安国');
INSERT INTO `city_info` VALUES ('101090221', '河北', '保定', '高碑店');
INSERT INTO `city_info` VALUES ('101090222', '河北', '保定', '涞水');
INSERT INTO `city_info` VALUES ('101090223', '河北', '保定', '定兴');
INSERT INTO `city_info` VALUES ('101090224', '河北', '保定', '清苑');
INSERT INTO `city_info` VALUES ('101090225', '河北', '保定', '博野');
INSERT INTO `city_info` VALUES ('101090301', '河北', '张家口', '张家口');
INSERT INTO `city_info` VALUES ('101090302', '河北', '张家口', '宣化');
INSERT INTO `city_info` VALUES ('101090303', '河北', '张家口', '张北');
INSERT INTO `city_info` VALUES ('101090304', '河北', '张家口', '康保');
INSERT INTO `city_info` VALUES ('101090305', '河北', '张家口', '沽源');
INSERT INTO `city_info` VALUES ('101090306', '河北', '张家口', '尚义');
INSERT INTO `city_info` VALUES ('101090307', '河北', '张家口', '蔚县');
INSERT INTO `city_info` VALUES ('101090308', '河北', '张家口', '阳原');
INSERT INTO `city_info` VALUES ('101090309', '河北', '张家口', '怀安');
INSERT INTO `city_info` VALUES ('101090310', '河北', '张家口', '万全');
INSERT INTO `city_info` VALUES ('101090311', '河北', '张家口', '怀来');
INSERT INTO `city_info` VALUES ('101090312', '河北', '张家口', '涿鹿');
INSERT INTO `city_info` VALUES ('101090313', '河北', '张家口', '赤城');
INSERT INTO `city_info` VALUES ('101090314', '河北', '张家口', '崇礼');
INSERT INTO `city_info` VALUES ('101090402', '河北', '承德', '承德');
INSERT INTO `city_info` VALUES ('101090403', '河北', '承德', '承德县');
INSERT INTO `city_info` VALUES ('101090404', '河北', '承德', '兴隆');
INSERT INTO `city_info` VALUES ('101090405', '河北', '承德', '平泉');
INSERT INTO `city_info` VALUES ('101090406', '河北', '承德', '滦平');
INSERT INTO `city_info` VALUES ('101090407', '河北', '承德', '隆化');
INSERT INTO `city_info` VALUES ('101090408', '河北', '承德', '丰宁');
INSERT INTO `city_info` VALUES ('101090409', '河北', '承德', '宽城');
INSERT INTO `city_info` VALUES ('101090410', '河北', '承德', '围场');
INSERT INTO `city_info` VALUES ('101090501', '河北', '唐山', '唐山');
INSERT INTO `city_info` VALUES ('101090502', '河北', '唐山', '丰南');
INSERT INTO `city_info` VALUES ('101090503', '河北', '唐山', '丰润');
INSERT INTO `city_info` VALUES ('101090504', '河北', '唐山', '滦县');
INSERT INTO `city_info` VALUES ('101090505', '河北', '唐山', '滦南');
INSERT INTO `city_info` VALUES ('101090506', '河北', '唐山', '乐亭');
INSERT INTO `city_info` VALUES ('101090507', '河北', '唐山', '迁西');
INSERT INTO `city_info` VALUES ('101090508', '河北', '唐山', '玉田');
INSERT INTO `city_info` VALUES ('101090509', '河北', '唐山', '唐海');
INSERT INTO `city_info` VALUES ('101090510', '河北', '唐山', '遵化');
INSERT INTO `city_info` VALUES ('101090511', '河北', '唐山', '迁安');
INSERT INTO `city_info` VALUES ('101090512', '河北', '唐山', '曹妃甸');
INSERT INTO `city_info` VALUES ('101090601', '河北', '廊坊', '廊坊');
INSERT INTO `city_info` VALUES ('101090602', '河北', '廊坊', '固安');
INSERT INTO `city_info` VALUES ('101090603', '河北', '廊坊', '永清');
INSERT INTO `city_info` VALUES ('101090604', '河北', '廊坊', '香河');
INSERT INTO `city_info` VALUES ('101090605', '河北', '廊坊', '大城');
INSERT INTO `city_info` VALUES ('101090606', '河北', '廊坊', '文安');
INSERT INTO `city_info` VALUES ('101090607', '河北', '廊坊', '大厂');
INSERT INTO `city_info` VALUES ('101090608', '河北', '廊坊', '霸州');
INSERT INTO `city_info` VALUES ('101090609', '河北', '廊坊', '三河');
INSERT INTO `city_info` VALUES ('101090701', '河北', '沧州', '沧州');
INSERT INTO `city_info` VALUES ('101090702', '河北', '沧州', '青县');
INSERT INTO `city_info` VALUES ('101090703', '河北', '沧州', '东光');
INSERT INTO `city_info` VALUES ('101090704', '河北', '沧州', '海兴');
INSERT INTO `city_info` VALUES ('101090705', '河北', '沧州', '盐山');
INSERT INTO `city_info` VALUES ('101090706', '河北', '沧州', '肃宁');
INSERT INTO `city_info` VALUES ('101090707', '河北', '沧州', '南皮');
INSERT INTO `city_info` VALUES ('101090708', '河北', '沧州', '吴桥');
INSERT INTO `city_info` VALUES ('101090709', '河北', '沧州', '献县');
INSERT INTO `city_info` VALUES ('101090710', '河北', '沧州', '孟村');
INSERT INTO `city_info` VALUES ('101090711', '河北', '沧州', '泊头');
INSERT INTO `city_info` VALUES ('101090712', '河北', '沧州', '任丘');
INSERT INTO `city_info` VALUES ('101090713', '河北', '沧州', '黄骅');
INSERT INTO `city_info` VALUES ('101090714', '河北', '沧州', '河间');
INSERT INTO `city_info` VALUES ('101090716', '河北', '沧州', '沧县');
INSERT INTO `city_info` VALUES ('101090801', '河北', '衡水', '衡水');
INSERT INTO `city_info` VALUES ('101090802', '河北', '衡水', '枣强');
INSERT INTO `city_info` VALUES ('101090803', '河北', '衡水', '武邑');
INSERT INTO `city_info` VALUES ('101090804', '河北', '衡水', '武强');
INSERT INTO `city_info` VALUES ('101090805', '河北', '衡水', '饶阳');
INSERT INTO `city_info` VALUES ('101090806', '河北', '衡水', '安平');
INSERT INTO `city_info` VALUES ('101090807', '河北', '衡水', '故城');
INSERT INTO `city_info` VALUES ('101090808', '河北', '衡水', '景县');
INSERT INTO `city_info` VALUES ('101090809', '河北', '衡水', '阜城');
INSERT INTO `city_info` VALUES ('101090810', '河北', '衡水', '冀州');
INSERT INTO `city_info` VALUES ('101090811', '河北', '衡水', '深州');
INSERT INTO `city_info` VALUES ('101090901', '河北', '邢台', '邢台');
INSERT INTO `city_info` VALUES ('101090902', '河北', '邢台', '临城');
INSERT INTO `city_info` VALUES ('101090904', '河北', '邢台', '内丘');
INSERT INTO `city_info` VALUES ('101090905', '河北', '邢台', '柏乡');
INSERT INTO `city_info` VALUES ('101090906', '河北', '邢台', '隆尧');
INSERT INTO `city_info` VALUES ('101090907', '河北', '邢台', '南和');
INSERT INTO `city_info` VALUES ('101090908', '河北', '邢台', '宁晋');
INSERT INTO `city_info` VALUES ('101090909', '河北', '邢台', '巨鹿');
INSERT INTO `city_info` VALUES ('101090910', '河北', '邢台', '新河');
INSERT INTO `city_info` VALUES ('101090911', '河北', '邢台', '广宗');
INSERT INTO `city_info` VALUES ('101090912', '河北', '邢台', '平乡');
INSERT INTO `city_info` VALUES ('101090913', '河北', '邢台', '威县');
INSERT INTO `city_info` VALUES ('101090914', '河北', '邢台', '清河');
INSERT INTO `city_info` VALUES ('101090915', '河北', '邢台', '临西');
INSERT INTO `city_info` VALUES ('101090916', '河北', '邢台', '南宫');
INSERT INTO `city_info` VALUES ('101090917', '河北', '邢台', '沙河');
INSERT INTO `city_info` VALUES ('101090918', '河北', '邢台', '任县');
INSERT INTO `city_info` VALUES ('101091001', '河北', '邯郸', '邯郸');
INSERT INTO `city_info` VALUES ('101091002', '河北', '邯郸', '峰峰');
INSERT INTO `city_info` VALUES ('101091003', '河北', '邯郸', '临漳');
INSERT INTO `city_info` VALUES ('101091004', '河北', '邯郸', '成安');
INSERT INTO `city_info` VALUES ('101091005', '河北', '邯郸', '大名');
INSERT INTO `city_info` VALUES ('101091006', '河北', '邯郸', '涉县');
INSERT INTO `city_info` VALUES ('101091007', '河北', '邯郸', '磁县');
INSERT INTO `city_info` VALUES ('101091008', '河北', '邯郸', '肥乡');
INSERT INTO `city_info` VALUES ('101091009', '河北', '邯郸', '永年');
INSERT INTO `city_info` VALUES ('101091010', '河北', '邯郸', '邱县');
INSERT INTO `city_info` VALUES ('101091011', '河北', '邯郸', '鸡泽');
INSERT INTO `city_info` VALUES ('101091012', '河北', '邯郸', '广平');
INSERT INTO `city_info` VALUES ('101091013', '河北', '邯郸', '馆陶');
INSERT INTO `city_info` VALUES ('101091014', '河北', '邯郸', '魏县');
INSERT INTO `city_info` VALUES ('101091015', '河北', '邯郸', '曲周');
INSERT INTO `city_info` VALUES ('101091016', '河北', '邯郸', '武安');
INSERT INTO `city_info` VALUES ('101091101', '河北', '秦皇岛', '秦皇岛');
INSERT INTO `city_info` VALUES ('101091102', '河北', '秦皇岛', '青龙');
INSERT INTO `city_info` VALUES ('101091103', '河北', '秦皇岛', '昌黎');
INSERT INTO `city_info` VALUES ('101091104', '河北', '秦皇岛', '抚宁');
INSERT INTO `city_info` VALUES ('101091105', '河北', '秦皇岛', '卢龙');
INSERT INTO `city_info` VALUES ('101091106', '河北', '秦皇岛', '北戴河');
INSERT INTO `city_info` VALUES ('101100101', '山西', '太原', '太原');
INSERT INTO `city_info` VALUES ('101100102', '山西', '太原', '清徐');
INSERT INTO `city_info` VALUES ('101100103', '山西', '太原', '阳曲');
INSERT INTO `city_info` VALUES ('101100104', '山西', '太原', '娄烦');
INSERT INTO `city_info` VALUES ('101100105', '山西', '太原', '古交');
INSERT INTO `city_info` VALUES ('101100106', '山西', '太原', '尖草坪区');
INSERT INTO `city_info` VALUES ('101100107', '山西', '太原', '小店区');
INSERT INTO `city_info` VALUES ('101100201', '山西', '大同', '大同');
INSERT INTO `city_info` VALUES ('101100202', '山西', '大同', '阳高');
INSERT INTO `city_info` VALUES ('101100203', '山西', '大同', '大同县');
INSERT INTO `city_info` VALUES ('101100204', '山西', '大同', '天镇');
INSERT INTO `city_info` VALUES ('101100205', '山西', '大同', '广灵');
INSERT INTO `city_info` VALUES ('101100206', '山西', '大同', '灵丘');
INSERT INTO `city_info` VALUES ('101100207', '山西', '大同', '浑源');
INSERT INTO `city_info` VALUES ('101100208', '山西', '大同', '左云');
INSERT INTO `city_info` VALUES ('101100301', '山西', '阳泉', '阳泉');
INSERT INTO `city_info` VALUES ('101100302', '山西', '阳泉', '盂县');
INSERT INTO `city_info` VALUES ('101100303', '山西', '阳泉', '平定');
INSERT INTO `city_info` VALUES ('101100401', '山西', '晋中', '晋中');
INSERT INTO `city_info` VALUES ('101100402', '山西', '晋中', '榆次');
INSERT INTO `city_info` VALUES ('101100403', '山西', '晋中', '榆社');
INSERT INTO `city_info` VALUES ('101100404', '山西', '晋中', '左权');
INSERT INTO `city_info` VALUES ('101100405', '山西', '晋中', '和顺');
INSERT INTO `city_info` VALUES ('101100406', '山西', '晋中', '昔阳');
INSERT INTO `city_info` VALUES ('101100407', '山西', '晋中', '寿阳');
INSERT INTO `city_info` VALUES ('101100408', '山西', '晋中', '太谷');
INSERT INTO `city_info` VALUES ('101100409', '山西', '晋中', '祁县');
INSERT INTO `city_info` VALUES ('101100410', '山西', '晋中', '平遥');
INSERT INTO `city_info` VALUES ('101100411', '山西', '晋中', '灵石');
INSERT INTO `city_info` VALUES ('101100412', '山西', '晋中', '介休');
INSERT INTO `city_info` VALUES ('101100501', '山西', '长治', '长治');
INSERT INTO `city_info` VALUES ('101100502', '山西', '长治', '黎城');
INSERT INTO `city_info` VALUES ('101100503', '山西', '长治', '屯留');
INSERT INTO `city_info` VALUES ('101100504', '山西', '长治', '潞城');
INSERT INTO `city_info` VALUES ('101100505', '山西', '长治', '襄垣');
INSERT INTO `city_info` VALUES ('101100506', '山西', '长治', '平顺');
INSERT INTO `city_info` VALUES ('101100507', '山西', '长治', '武乡');
INSERT INTO `city_info` VALUES ('101100508', '山西', '长治', '沁县');
INSERT INTO `city_info` VALUES ('101100509', '山西', '长治', '长子');
INSERT INTO `city_info` VALUES ('101100510', '山西', '长治', '沁源');
INSERT INTO `city_info` VALUES ('101100511', '山西', '长治', '壶关');
INSERT INTO `city_info` VALUES ('101100601', '山西', '晋城', '晋城');
INSERT INTO `city_info` VALUES ('101100602', '山西', '晋城', '沁水');
INSERT INTO `city_info` VALUES ('101100603', '山西', '晋城', '阳城');
INSERT INTO `city_info` VALUES ('101100604', '山西', '晋城', '陵川');
INSERT INTO `city_info` VALUES ('101100605', '山西', '晋城', '高平');
INSERT INTO `city_info` VALUES ('101100606', '山西', '晋城', '泽州');
INSERT INTO `city_info` VALUES ('101100701', '山西', '临汾', '临汾');
INSERT INTO `city_info` VALUES ('101100702', '山西', '临汾', '曲沃');
INSERT INTO `city_info` VALUES ('101100703', '山西', '临汾', '永和');
INSERT INTO `city_info` VALUES ('101100704', '山西', '临汾', '隰县');
INSERT INTO `city_info` VALUES ('101100705', '山西', '临汾', '大宁');
INSERT INTO `city_info` VALUES ('101100706', '山西', '临汾', '吉县');
INSERT INTO `city_info` VALUES ('101100707', '山西', '临汾', '襄汾');
INSERT INTO `city_info` VALUES ('101100708', '山西', '临汾', '蒲县');
INSERT INTO `city_info` VALUES ('101100709', '山西', '临汾', '汾西');
INSERT INTO `city_info` VALUES ('101100710', '山西', '临汾', '洪洞');
INSERT INTO `city_info` VALUES ('101100711', '山西', '临汾', '霍州');
INSERT INTO `city_info` VALUES ('101100712', '山西', '临汾', '乡宁');
INSERT INTO `city_info` VALUES ('101100713', '山西', '临汾', '翼城');
INSERT INTO `city_info` VALUES ('101100714', '山西', '临汾', '侯马');
INSERT INTO `city_info` VALUES ('101100715', '山西', '临汾', '浮山');
INSERT INTO `city_info` VALUES ('101100716', '山西', '临汾', '安泽');
INSERT INTO `city_info` VALUES ('101100717', '山西', '临汾', '古县');
INSERT INTO `city_info` VALUES ('101100801', '山西', '运城', '运城');
INSERT INTO `city_info` VALUES ('101100802', '山西', '运城', '临猗');
INSERT INTO `city_info` VALUES ('101100803', '山西', '运城', '稷山');
INSERT INTO `city_info` VALUES ('101100804', '山西', '运城', '万荣');
INSERT INTO `city_info` VALUES ('101100805', '山西', '运城', '河津');
INSERT INTO `city_info` VALUES ('101100806', '山西', '运城', '新绛');
INSERT INTO `city_info` VALUES ('101100807', '山西', '运城', '绛县');
INSERT INTO `city_info` VALUES ('101100808', '山西', '运城', '闻喜');
INSERT INTO `city_info` VALUES ('101100809', '山西', '运城', '垣曲');
INSERT INTO `city_info` VALUES ('101100810', '山西', '运城', '永济');
INSERT INTO `city_info` VALUES ('101100811', '山西', '运城', '芮城');
INSERT INTO `city_info` VALUES ('101100812', '山西', '运城', '夏县');
INSERT INTO `city_info` VALUES ('101100813', '山西', '运城', '平陆');
INSERT INTO `city_info` VALUES ('101100901', '山西', '朔州', '朔州');
INSERT INTO `city_info` VALUES ('101100902', '山西', '朔州', '平鲁');
INSERT INTO `city_info` VALUES ('101100903', '山西', '朔州', '山阴');
INSERT INTO `city_info` VALUES ('101100904', '山西', '朔州', '右玉');
INSERT INTO `city_info` VALUES ('101100905', '山西', '朔州', '应县');
INSERT INTO `city_info` VALUES ('101100906', '山西', '朔州', '怀仁');
INSERT INTO `city_info` VALUES ('101101001', '山西', '忻州', '忻州');
INSERT INTO `city_info` VALUES ('101101002', '山西', '忻州', '定襄');
INSERT INTO `city_info` VALUES ('101101003', '山西', '忻州', '五台县');
INSERT INTO `city_info` VALUES ('101101004', '山西', '忻州', '河曲');
INSERT INTO `city_info` VALUES ('101101005', '山西', '忻州', '偏关');
INSERT INTO `city_info` VALUES ('101101006', '山西', '忻州', '神池');
INSERT INTO `city_info` VALUES ('101101007', '山西', '忻州', '宁武');
INSERT INTO `city_info` VALUES ('101101008', '山西', '忻州', '代县');
INSERT INTO `city_info` VALUES ('101101009', '山西', '忻州', '繁峙');
INSERT INTO `city_info` VALUES ('101101010', '山西', '忻州', '五台山');
INSERT INTO `city_info` VALUES ('101101011', '山西', '忻州', '保德');
INSERT INTO `city_info` VALUES ('101101012', '山西', '忻州', '静乐');
INSERT INTO `city_info` VALUES ('101101013', '山西', '忻州', '岢岚');
INSERT INTO `city_info` VALUES ('101101014', '山西', '忻州', '五寨');
INSERT INTO `city_info` VALUES ('101101015', '山西', '忻州', '原平');
INSERT INTO `city_info` VALUES ('101101100', '山西', '吕梁', '吕梁');
INSERT INTO `city_info` VALUES ('101101101', '山西', '吕梁', '离石');
INSERT INTO `city_info` VALUES ('101101102', '山西', '吕梁', '临县');
INSERT INTO `city_info` VALUES ('101101103', '山西', '吕梁', '兴县');
INSERT INTO `city_info` VALUES ('101101104', '山西', '吕梁', '岚县');
INSERT INTO `city_info` VALUES ('101101105', '山西', '吕梁', '柳林');
INSERT INTO `city_info` VALUES ('101101106', '山西', '吕梁', '石楼');
INSERT INTO `city_info` VALUES ('101101107', '山西', '吕梁', '方山');
INSERT INTO `city_info` VALUES ('101101108', '山西', '吕梁', '交口');
INSERT INTO `city_info` VALUES ('101101109', '山西', '吕梁', '中阳');
INSERT INTO `city_info` VALUES ('101101110', '山西', '吕梁', '孝义');
INSERT INTO `city_info` VALUES ('101101111', '山西', '吕梁', '汾阳');
INSERT INTO `city_info` VALUES ('101101112', '山西', '吕梁', '文水');
INSERT INTO `city_info` VALUES ('101101113', '山西', '吕梁', '交城');
INSERT INTO `city_info` VALUES ('101110101', '陕西', '西安', '西安');
INSERT INTO `city_info` VALUES ('101110102', '陕西', '西安', '长安');
INSERT INTO `city_info` VALUES ('101110103', '陕西', '西安', '临潼');
INSERT INTO `city_info` VALUES ('101110104', '陕西', '西安', '蓝田');
INSERT INTO `city_info` VALUES ('101110105', '陕西', '西安', '周至');
INSERT INTO `city_info` VALUES ('101110106', '陕西', '西安', '户县');
INSERT INTO `city_info` VALUES ('101110107', '陕西', '西安', '高陵');
INSERT INTO `city_info` VALUES ('101110200', '陕西', '咸阳', '咸阳');
INSERT INTO `city_info` VALUES ('101110201', '陕西', '咸阳', '三原');
INSERT INTO `city_info` VALUES ('101110202', '陕西', '咸阳', '礼泉');
INSERT INTO `city_info` VALUES ('101110203', '陕西', '咸阳', '永寿');
INSERT INTO `city_info` VALUES ('101110204', '陕西', '咸阳', '淳化');
INSERT INTO `city_info` VALUES ('101110205', '陕西', '咸阳', '泾阳');
INSERT INTO `city_info` VALUES ('101110206', '陕西', '咸阳', '武功');
INSERT INTO `city_info` VALUES ('101110207', '陕西', '咸阳', '乾县');
INSERT INTO `city_info` VALUES ('101110208', '陕西', '咸阳', '彬县');
INSERT INTO `city_info` VALUES ('101110209', '陕西', '咸阳', '长武');
INSERT INTO `city_info` VALUES ('101110210', '陕西', '咸阳', '旬邑');
INSERT INTO `city_info` VALUES ('101110211', '陕西', '咸阳', '兴平');
INSERT INTO `city_info` VALUES ('101110300', '陕西', '延安', '延安');
INSERT INTO `city_info` VALUES ('101110301', '陕西', '延安', '延长');
INSERT INTO `city_info` VALUES ('101110302', '陕西', '延安', '延川');
INSERT INTO `city_info` VALUES ('101110303', '陕西', '延安', '子长');
INSERT INTO `city_info` VALUES ('101110304', '陕西', '延安', '宜川');
INSERT INTO `city_info` VALUES ('101110305', '陕西', '延安', '富县');
INSERT INTO `city_info` VALUES ('101110306', '陕西', '延安', '志丹');
INSERT INTO `city_info` VALUES ('101110307', '陕西', '延安', '安塞');
INSERT INTO `city_info` VALUES ('101110308', '陕西', '延安', '甘泉');
INSERT INTO `city_info` VALUES ('101110309', '陕西', '延安', '洛川');
INSERT INTO `city_info` VALUES ('101110310', '陕西', '延安', '黄陵');
INSERT INTO `city_info` VALUES ('101110311', '陕西', '延安', '黄龙');
INSERT INTO `city_info` VALUES ('101110312', '陕西', '延安', '吴起');
INSERT INTO `city_info` VALUES ('101110401', '陕西', '榆林', '榆林');
INSERT INTO `city_info` VALUES ('101110402', '陕西', '榆林', '府谷');
INSERT INTO `city_info` VALUES ('101110403', '陕西', '榆林', '神木');
INSERT INTO `city_info` VALUES ('101110404', '陕西', '榆林', '佳县');
INSERT INTO `city_info` VALUES ('101110405', '陕西', '榆林', '定边');
INSERT INTO `city_info` VALUES ('101110406', '陕西', '榆林', '靖边');
INSERT INTO `city_info` VALUES ('101110407', '陕西', '榆林', '横山');
INSERT INTO `city_info` VALUES ('101110408', '陕西', '榆林', '米脂');
INSERT INTO `city_info` VALUES ('101110409', '陕西', '榆林', '子洲');
INSERT INTO `city_info` VALUES ('101110410', '陕西', '榆林', '绥德');
INSERT INTO `city_info` VALUES ('101110411', '陕西', '榆林', '吴堡');
INSERT INTO `city_info` VALUES ('101110412', '陕西', '榆林', '清涧');
INSERT INTO `city_info` VALUES ('101110413', '陕西', '榆林', '榆阳');
INSERT INTO `city_info` VALUES ('101110501', '陕西', '渭南', '渭南');
INSERT INTO `city_info` VALUES ('101110502', '陕西', '渭南', '华县');
INSERT INTO `city_info` VALUES ('101110503', '陕西', '渭南', '潼关');
INSERT INTO `city_info` VALUES ('101110504', '陕西', '渭南', '大荔');
INSERT INTO `city_info` VALUES ('101110505', '陕西', '渭南', '白水');
INSERT INTO `city_info` VALUES ('101110506', '陕西', '渭南', '富平');
INSERT INTO `city_info` VALUES ('101110507', '陕西', '渭南', '蒲城');
INSERT INTO `city_info` VALUES ('101110508', '陕西', '渭南', '澄城');
INSERT INTO `city_info` VALUES ('101110509', '陕西', '渭南', '合阳');
INSERT INTO `city_info` VALUES ('101110510', '陕西', '渭南', '韩城');
INSERT INTO `city_info` VALUES ('101110511', '陕西', '渭南', '华阴');
INSERT INTO `city_info` VALUES ('101110601', '陕西', '商洛', '商洛');
INSERT INTO `city_info` VALUES ('101110602', '陕西', '商洛', '洛南');
INSERT INTO `city_info` VALUES ('101110603', '陕西', '商洛', '柞水');
INSERT INTO `city_info` VALUES ('101110604', '陕西', '商洛', '商州');
INSERT INTO `city_info` VALUES ('101110605', '陕西', '商洛', '镇安');
INSERT INTO `city_info` VALUES ('101110606', '陕西', '商洛', '丹凤');
INSERT INTO `city_info` VALUES ('101110607', '陕西', '商洛', '商南');
INSERT INTO `city_info` VALUES ('101110608', '陕西', '商洛', '山阳');
INSERT INTO `city_info` VALUES ('101110701', '陕西', '安康', '安康');
INSERT INTO `city_info` VALUES ('101110702', '陕西', '安康', '紫阳');
INSERT INTO `city_info` VALUES ('101110703', '陕西', '安康', '石泉');
INSERT INTO `city_info` VALUES ('101110704', '陕西', '安康', '汉阴');
INSERT INTO `city_info` VALUES ('101110705', '陕西', '安康', '旬阳');
INSERT INTO `city_info` VALUES ('101110706', '陕西', '安康', '岚皋');
INSERT INTO `city_info` VALUES ('101110707', '陕西', '安康', '平利');
INSERT INTO `city_info` VALUES ('101110708', '陕西', '安康', '白河');
INSERT INTO `city_info` VALUES ('101110709', '陕西', '安康', '镇坪');
INSERT INTO `city_info` VALUES ('101110710', '陕西', '安康', '宁陕');
INSERT INTO `city_info` VALUES ('101110801', '陕西', '汉中', '汉中');
INSERT INTO `city_info` VALUES ('101110802', '陕西', '汉中', '略阳');
INSERT INTO `city_info` VALUES ('101110803', '陕西', '汉中', '勉县');
INSERT INTO `city_info` VALUES ('101110804', '陕西', '汉中', '留坝');
INSERT INTO `city_info` VALUES ('101110805', '陕西', '汉中', '洋县');
INSERT INTO `city_info` VALUES ('101110806', '陕西', '汉中', '城固');
INSERT INTO `city_info` VALUES ('101110807', '陕西', '汉中', '西乡');
INSERT INTO `city_info` VALUES ('101110808', '陕西', '汉中', '佛坪');
INSERT INTO `city_info` VALUES ('101110809', '陕西', '汉中', '宁强');
INSERT INTO `city_info` VALUES ('101110810', '陕西', '汉中', '南郑');
INSERT INTO `city_info` VALUES ('101110811', '陕西', '汉中', '镇巴');
INSERT INTO `city_info` VALUES ('101110901', '陕西', '宝鸡', '宝鸡');
INSERT INTO `city_info` VALUES ('101110903', '陕西', '宝鸡', '千阳');
INSERT INTO `city_info` VALUES ('101110904', '陕西', '宝鸡', '麟游');
INSERT INTO `city_info` VALUES ('101110905', '陕西', '宝鸡', '岐山');
INSERT INTO `city_info` VALUES ('101110906', '陕西', '宝鸡', '凤翔');
INSERT INTO `city_info` VALUES ('101110907', '陕西', '宝鸡', '扶风');
INSERT INTO `city_info` VALUES ('101110908', '陕西', '宝鸡', '眉县');
INSERT INTO `city_info` VALUES ('101110909', '陕西', '宝鸡', '太白');
INSERT INTO `city_info` VALUES ('101110910', '陕西', '宝鸡', '凤县');
INSERT INTO `city_info` VALUES ('101110911', '陕西', '宝鸡', '陇县');
INSERT INTO `city_info` VALUES ('101110912', '陕西', '宝鸡', '陈仓');
INSERT INTO `city_info` VALUES ('101111001', '陕西', '铜川', '铜川');
INSERT INTO `city_info` VALUES ('101111002', '陕西', '铜川', '耀县');
INSERT INTO `city_info` VALUES ('101111003', '陕西', '铜川', '宜君');
INSERT INTO `city_info` VALUES ('101111004', '陕西', '铜川', '耀州');
INSERT INTO `city_info` VALUES ('101111101', '陕西', '杨凌', '杨凌');
INSERT INTO `city_info` VALUES ('101120101', '山东', '济南', '济南');
INSERT INTO `city_info` VALUES ('101120102', '山东', '济南', '长清');
INSERT INTO `city_info` VALUES ('101120103', '山东', '济南', '商河');
INSERT INTO `city_info` VALUES ('101120104', '山东', '济南', '章丘');
INSERT INTO `city_info` VALUES ('101120105', '山东', '济南', '平阴');
INSERT INTO `city_info` VALUES ('101120106', '山东', '济南', '济阳');
INSERT INTO `city_info` VALUES ('101120201', '山东', '青岛', '青岛');
INSERT INTO `city_info` VALUES ('101120202', '山东', '青岛', '崂山');
INSERT INTO `city_info` VALUES ('101120204', '山东', '青岛', '即墨');
INSERT INTO `city_info` VALUES ('101120205', '山东', '青岛', '胶州');
INSERT INTO `city_info` VALUES ('101120206', '山东', '青岛', '胶南');
INSERT INTO `city_info` VALUES ('101120207', '山东', '青岛', '莱西');
INSERT INTO `city_info` VALUES ('101120208', '山东', '青岛', '平度');
INSERT INTO `city_info` VALUES ('101120301', '山东', '淄博', '淄博');
INSERT INTO `city_info` VALUES ('101120302', '山东', '淄博', '淄川');
INSERT INTO `city_info` VALUES ('101120303', '山东', '淄博', '博山');
INSERT INTO `city_info` VALUES ('101120304', '山东', '淄博', '高青');
INSERT INTO `city_info` VALUES ('101120305', '山东', '淄博', '周村');
INSERT INTO `city_info` VALUES ('101120306', '山东', '淄博', '沂源');
INSERT INTO `city_info` VALUES ('101120307', '山东', '淄博', '桓台');
INSERT INTO `city_info` VALUES ('101120308', '山东', '淄博', '临淄');
INSERT INTO `city_info` VALUES ('101120401', '山东', '德州', '德州');
INSERT INTO `city_info` VALUES ('101120402', '山东', '德州', '武城');
INSERT INTO `city_info` VALUES ('101120403', '山东', '德州', '临邑');
INSERT INTO `city_info` VALUES ('101120404', '山东', '德州', '陵县');
INSERT INTO `city_info` VALUES ('101120405', '山东', '德州', '齐河');
INSERT INTO `city_info` VALUES ('101120406', '山东', '德州', '乐陵');
INSERT INTO `city_info` VALUES ('101120407', '山东', '德州', '庆云');
INSERT INTO `city_info` VALUES ('101120408', '山东', '德州', '平原');
INSERT INTO `city_info` VALUES ('101120409', '山东', '德州', '宁津');
INSERT INTO `city_info` VALUES ('101120410', '山东', '德州', '夏津');
INSERT INTO `city_info` VALUES ('101120411', '山东', '德州', '禹城');
INSERT INTO `city_info` VALUES ('101120501', '山东', '烟台', '烟台');
INSERT INTO `city_info` VALUES ('101120502', '山东', '烟台', '莱州');
INSERT INTO `city_info` VALUES ('101120503', '山东', '烟台', '长岛');
INSERT INTO `city_info` VALUES ('101120504', '山东', '烟台', '蓬莱');
INSERT INTO `city_info` VALUES ('101120505', '山东', '烟台', '龙口');
INSERT INTO `city_info` VALUES ('101120506', '山东', '烟台', '招远');
INSERT INTO `city_info` VALUES ('101120507', '山东', '烟台', '栖霞');
INSERT INTO `city_info` VALUES ('101120508', '山东', '烟台', '福山');
INSERT INTO `city_info` VALUES ('101120509', '山东', '烟台', '牟平');
INSERT INTO `city_info` VALUES ('101120510', '山东', '烟台', '莱阳');
INSERT INTO `city_info` VALUES ('101120511', '山东', '烟台', '海阳');
INSERT INTO `city_info` VALUES ('101120601', '山东', '潍坊', '潍坊');
INSERT INTO `city_info` VALUES ('101120602', '山东', '潍坊', '青州');
INSERT INTO `city_info` VALUES ('101120603', '山东', '潍坊', '寿光');
INSERT INTO `city_info` VALUES ('101120604', '山东', '潍坊', '临朐');
INSERT INTO `city_info` VALUES ('101120605', '山东', '潍坊', '昌乐');
INSERT INTO `city_info` VALUES ('101120606', '山东', '潍坊', '昌邑');
INSERT INTO `city_info` VALUES ('101120607', '山东', '潍坊', '安丘');
INSERT INTO `city_info` VALUES ('101120608', '山东', '潍坊', '高密');
INSERT INTO `city_info` VALUES ('101120609', '山东', '潍坊', '诸城');
INSERT INTO `city_info` VALUES ('101120701', '山东', '济宁', '济宁');
INSERT INTO `city_info` VALUES ('101120702', '山东', '济宁', '嘉祥');
INSERT INTO `city_info` VALUES ('101120703', '山东', '济宁', '微山');
INSERT INTO `city_info` VALUES ('101120704', '山东', '济宁', '鱼台');
INSERT INTO `city_info` VALUES ('101120705', '山东', '济宁', '兖州');
INSERT INTO `city_info` VALUES ('101120706', '山东', '济宁', '金乡');
INSERT INTO `city_info` VALUES ('101120707', '山东', '济宁', '汶上');
INSERT INTO `city_info` VALUES ('101120708', '山东', '济宁', '泗水');
INSERT INTO `city_info` VALUES ('101120709', '山东', '济宁', '梁山');
INSERT INTO `city_info` VALUES ('101120710', '山东', '济宁', '曲阜');
INSERT INTO `city_info` VALUES ('101120711', '山东', '济宁', '邹城');
INSERT INTO `city_info` VALUES ('101120801', '山东', '泰安', '泰安');
INSERT INTO `city_info` VALUES ('101120802', '山东', '泰安', '新泰');
INSERT INTO `city_info` VALUES ('101120804', '山东', '泰安', '肥城');
INSERT INTO `city_info` VALUES ('101120805', '山东', '泰安', '东平');
INSERT INTO `city_info` VALUES ('101120806', '山东', '泰安', '宁阳');
INSERT INTO `city_info` VALUES ('101120901', '山东', '临沂', '临沂');
INSERT INTO `city_info` VALUES ('101120902', '山东', '临沂', '莒南');
INSERT INTO `city_info` VALUES ('101120903', '山东', '临沂', '沂南');
INSERT INTO `city_info` VALUES ('101120904', '山东', '临沂', '苍山');
INSERT INTO `city_info` VALUES ('101120905', '山东', '临沂', '临沭');
INSERT INTO `city_info` VALUES ('101120906', '山东', '临沂', '郯城');
INSERT INTO `city_info` VALUES ('101120907', '山东', '临沂', '蒙阴');
INSERT INTO `city_info` VALUES ('101120908', '山东', '临沂', '平邑');
INSERT INTO `city_info` VALUES ('101120909', '山东', '临沂', '费县');
INSERT INTO `city_info` VALUES ('101120910', '山东', '临沂', '沂水');
INSERT INTO `city_info` VALUES ('101121001', '山东', '菏泽', '菏泽');
INSERT INTO `city_info` VALUES ('101121002', '山东', '菏泽', '鄄城');
INSERT INTO `city_info` VALUES ('101121003', '山东', '菏泽', '郓城');
INSERT INTO `city_info` VALUES ('101121004', '山东', '菏泽', '东明');
INSERT INTO `city_info` VALUES ('101121005', '山东', '菏泽', '定陶');
INSERT INTO `city_info` VALUES ('101121006', '山东', '菏泽', '巨野');
INSERT INTO `city_info` VALUES ('101121007', '山东', '菏泽', '曹县');
INSERT INTO `city_info` VALUES ('101121008', '山东', '菏泽', '成武');
INSERT INTO `city_info` VALUES ('101121009', '山东', '菏泽', '单县');
INSERT INTO `city_info` VALUES ('101121101', '山东', '滨州', '滨州');
INSERT INTO `city_info` VALUES ('101121102', '山东', '滨州', '博兴');
INSERT INTO `city_info` VALUES ('101121103', '山东', '滨州', '无棣');
INSERT INTO `city_info` VALUES ('101121104', '山东', '滨州', '阳信');
INSERT INTO `city_info` VALUES ('101121105', '山东', '滨州', '惠民');
INSERT INTO `city_info` VALUES ('101121106', '山东', '滨州', '沾化');
INSERT INTO `city_info` VALUES ('101121107', '山东', '滨州', '邹平');
INSERT INTO `city_info` VALUES ('101121201', '山东', '东营', '东营');
INSERT INTO `city_info` VALUES ('101121202', '山东', '东营', '河口');
INSERT INTO `city_info` VALUES ('101121203', '山东', '东营', '垦利');
INSERT INTO `city_info` VALUES ('101121204', '山东', '东营', '利津');
INSERT INTO `city_info` VALUES ('101121205', '山东', '东营', '广饶');
INSERT INTO `city_info` VALUES ('101121301', '山东', '威海', '威海');
INSERT INTO `city_info` VALUES ('101121302', '山东', '威海', '文登');
INSERT INTO `city_info` VALUES ('101121303', '山东', '威海', '荣成');
INSERT INTO `city_info` VALUES ('101121304', '山东', '威海', '乳山');
INSERT INTO `city_info` VALUES ('101121305', '山东', '威海', '成山头');
INSERT INTO `city_info` VALUES ('101121306', '山东', '威海', '石岛');
INSERT INTO `city_info` VALUES ('101121401', '山东', '枣庄', '枣庄');
INSERT INTO `city_info` VALUES ('101121402', '山东', '枣庄', '薛城');
INSERT INTO `city_info` VALUES ('101121403', '山东', '枣庄', '峄城');
INSERT INTO `city_info` VALUES ('101121404', '山东', '枣庄', '台儿庄');
INSERT INTO `city_info` VALUES ('101121405', '山东', '枣庄', '滕州');
INSERT INTO `city_info` VALUES ('101121501', '山东', '日照', '日照');
INSERT INTO `city_info` VALUES ('101121502', '山东', '日照', '五莲');
INSERT INTO `city_info` VALUES ('101121503', '山东', '日照', '莒县');
INSERT INTO `city_info` VALUES ('101121601', '山东', '莱芜', '莱芜');
INSERT INTO `city_info` VALUES ('101121701', '山东', '聊城', '聊城');
INSERT INTO `city_info` VALUES ('101121702', '山东', '聊城', '冠县');
INSERT INTO `city_info` VALUES ('101121703', '山东', '聊城', '阳谷');
INSERT INTO `city_info` VALUES ('101121704', '山东', '聊城', '高唐');
INSERT INTO `city_info` VALUES ('101121705', '山东', '聊城', '茌平');
INSERT INTO `city_info` VALUES ('101121706', '山东', '聊城', '东阿');
INSERT INTO `city_info` VALUES ('101121707', '山东', '聊城', '临清');
INSERT INTO `city_info` VALUES ('101121709', '山东', '聊城', '莘县');
INSERT INTO `city_info` VALUES ('101130101', '新疆', '乌鲁木齐', '乌鲁木齐');
INSERT INTO `city_info` VALUES ('101130103', '新疆', '乌鲁木齐', '小渠子');
INSERT INTO `city_info` VALUES ('101130105', '新疆', '乌鲁木齐', '达坂城');
INSERT INTO `city_info` VALUES ('101130108', '新疆', '乌鲁木齐', '乌鲁木齐牧试站');
INSERT INTO `city_info` VALUES ('101130109', '新疆', '乌鲁木齐', '天池');
INSERT INTO `city_info` VALUES ('101130110', '新疆', '乌鲁木齐', '白杨沟');
INSERT INTO `city_info` VALUES ('101130201', '新疆', '克拉玛依', '克拉玛依');
INSERT INTO `city_info` VALUES ('101130202', '新疆', '克拉玛依', '乌尔禾');
INSERT INTO `city_info` VALUES ('101130203', '新疆', '克拉玛依', '白碱滩');
INSERT INTO `city_info` VALUES ('101130301', '新疆', '石河子', '石河子');
INSERT INTO `city_info` VALUES ('101130302', '新疆', '石河子', '炮台');
INSERT INTO `city_info` VALUES ('101130303', '新疆', '石河子', '莫索湾');
INSERT INTO `city_info` VALUES ('101130401', '新疆', '昌吉', '昌吉');
INSERT INTO `city_info` VALUES ('101130402', '新疆', '昌吉', '呼图壁');
INSERT INTO `city_info` VALUES ('101130403', '新疆', '昌吉', '米泉');
INSERT INTO `city_info` VALUES ('101130404', '新疆', '昌吉', '阜康');
INSERT INTO `city_info` VALUES ('101130405', '新疆', '昌吉', '吉木萨尔');
INSERT INTO `city_info` VALUES ('101130406', '新疆', '昌吉', '奇台');
INSERT INTO `city_info` VALUES ('101130407', '新疆', '昌吉', '玛纳斯');
INSERT INTO `city_info` VALUES ('101130408', '新疆', '昌吉', '木垒');
INSERT INTO `city_info` VALUES ('101130409', '新疆', '昌吉', '蔡家湖');
INSERT INTO `city_info` VALUES ('101130501', '新疆', '吐鲁番', '吐鲁番');
INSERT INTO `city_info` VALUES ('101130502', '新疆', '吐鲁番', '托克逊');
INSERT INTO `city_info` VALUES ('101130504', '新疆', '吐鲁番', '鄯善');
INSERT INTO `city_info` VALUES ('101130601', '新疆', '巴音郭楞', '库尔勒');
INSERT INTO `city_info` VALUES ('101130602', '新疆', '巴音郭楞', '轮台');
INSERT INTO `city_info` VALUES ('101130603', '新疆', '巴音郭楞', '尉犁');
INSERT INTO `city_info` VALUES ('101130604', '新疆', '巴音郭楞', '若羌');
INSERT INTO `city_info` VALUES ('101130605', '新疆', '巴音郭楞', '且末');
INSERT INTO `city_info` VALUES ('101130606', '新疆', '巴音郭楞', '和静');
INSERT INTO `city_info` VALUES ('101130607', '新疆', '巴音郭楞', '焉耆');
INSERT INTO `city_info` VALUES ('101130608', '新疆', '巴音郭楞', '和硕');
INSERT INTO `city_info` VALUES ('101130610', '新疆', '巴音郭楞', '巴音布鲁克');
INSERT INTO `city_info` VALUES ('101130611', '新疆', '巴音郭楞', '铁干里克');
INSERT INTO `city_info` VALUES ('101130612', '新疆', '巴音郭楞', '博湖');
INSERT INTO `city_info` VALUES ('101130613', '新疆', '巴音郭楞', '塔中');
INSERT INTO `city_info` VALUES ('101130614', '新疆', '巴音郭楞', '巴仑台');
INSERT INTO `city_info` VALUES ('101130701', '新疆', '阿拉尔', '阿拉尔');
INSERT INTO `city_info` VALUES ('101130801', '新疆', '阿克苏', '阿克苏');
INSERT INTO `city_info` VALUES ('101130802', '新疆', '阿克苏', '乌什');
INSERT INTO `city_info` VALUES ('101130803', '新疆', '阿克苏', '温宿');
INSERT INTO `city_info` VALUES ('101130804', '新疆', '阿克苏', '拜城');
INSERT INTO `city_info` VALUES ('101130805', '新疆', '阿克苏', '新和');
INSERT INTO `city_info` VALUES ('101130806', '新疆', '阿克苏', '沙雅');
INSERT INTO `city_info` VALUES ('101130807', '新疆', '阿克苏', '库车');
INSERT INTO `city_info` VALUES ('101130808', '新疆', '阿克苏', '柯坪');
INSERT INTO `city_info` VALUES ('101130809', '新疆', '阿克苏', '阿瓦提');
INSERT INTO `city_info` VALUES ('101130901', '新疆', '喀什', '喀什');
INSERT INTO `city_info` VALUES ('101130902', '新疆', '喀什', '英吉沙');
INSERT INTO `city_info` VALUES ('101130903', '新疆', '喀什', '塔什库尔干');
INSERT INTO `city_info` VALUES ('101130904', '新疆', '喀什', '麦盖提');
INSERT INTO `city_info` VALUES ('101130905', '新疆', '喀什', '莎车');
INSERT INTO `city_info` VALUES ('101130906', '新疆', '喀什', '叶城');
INSERT INTO `city_info` VALUES ('101130907', '新疆', '喀什', '泽普');
INSERT INTO `city_info` VALUES ('101130908', '新疆', '喀什', '巴楚');
INSERT INTO `city_info` VALUES ('101130909', '新疆', '喀什', '岳普湖');
INSERT INTO `city_info` VALUES ('101130910', '新疆', '喀什', '伽师');
INSERT INTO `city_info` VALUES ('101130911', '新疆', '喀什', '疏附');
INSERT INTO `city_info` VALUES ('101130912', '新疆', '喀什', '疏勒');
INSERT INTO `city_info` VALUES ('101131001', '新疆', '伊犁', '伊宁');
INSERT INTO `city_info` VALUES ('101131002', '新疆', '伊犁', '察布查尔');
INSERT INTO `city_info` VALUES ('101131003', '新疆', '伊犁', '尼勒克');
INSERT INTO `city_info` VALUES ('101131004', '新疆', '伊犁', '伊宁县');
INSERT INTO `city_info` VALUES ('101131005', '新疆', '伊犁', '巩留');
INSERT INTO `city_info` VALUES ('101131006', '新疆', '伊犁', '新源');
INSERT INTO `city_info` VALUES ('101131007', '新疆', '伊犁', '昭苏');
INSERT INTO `city_info` VALUES ('101131008', '新疆', '伊犁', '特克斯');
INSERT INTO `city_info` VALUES ('101131009', '新疆', '伊犁', '霍城');
INSERT INTO `city_info` VALUES ('101131010', '新疆', '伊犁', '霍尔果斯');
INSERT INTO `city_info` VALUES ('101131011', '新疆', '伊犁', '奎屯');
INSERT INTO `city_info` VALUES ('101131101', '新疆', '塔城', '塔城');
INSERT INTO `city_info` VALUES ('101131102', '新疆', '塔城', '裕民');
INSERT INTO `city_info` VALUES ('101131103', '新疆', '塔城', '额敏');
INSERT INTO `city_info` VALUES ('101131104', '新疆', '塔城', '和布克赛尔');
INSERT INTO `city_info` VALUES ('101131105', '新疆', '塔城', '托里');
INSERT INTO `city_info` VALUES ('101131106', '新疆', '塔城', '乌苏');
INSERT INTO `city_info` VALUES ('101131107', '新疆', '塔城', '沙湾');
INSERT INTO `city_info` VALUES ('101131201', '新疆', '哈密', '哈密');
INSERT INTO `city_info` VALUES ('101131203', '新疆', '哈密', '巴里坤');
INSERT INTO `city_info` VALUES ('101131204', '新疆', '哈密', '伊吾');
INSERT INTO `city_info` VALUES ('101131301', '新疆', '和田', '和田');
INSERT INTO `city_info` VALUES ('101131302', '新疆', '和田', '皮山');
INSERT INTO `city_info` VALUES ('101131303', '新疆', '和田', '策勒');
INSERT INTO `city_info` VALUES ('101131304', '新疆', '和田', '墨玉');
INSERT INTO `city_info` VALUES ('101131305', '新疆', '和田', '洛浦');
INSERT INTO `city_info` VALUES ('101131306', '新疆', '和田', '民丰');
INSERT INTO `city_info` VALUES ('101131307', '新疆', '和田', '于田');
INSERT INTO `city_info` VALUES ('101131401', '新疆', '阿勒泰', '阿勒泰');
INSERT INTO `city_info` VALUES ('101131402', '新疆', '阿勒泰', '哈巴河');
INSERT INTO `city_info` VALUES ('101131405', '新疆', '阿勒泰', '吉木乃');
INSERT INTO `city_info` VALUES ('101131406', '新疆', '阿勒泰', '布尔津');
INSERT INTO `city_info` VALUES ('101131407', '新疆', '阿勒泰', '福海');
INSERT INTO `city_info` VALUES ('101131408', '新疆', '阿勒泰', '富蕴');
INSERT INTO `city_info` VALUES ('101131409', '新疆', '阿勒泰', '青河');
INSERT INTO `city_info` VALUES ('101131501', '新疆', '克州', '阿图什');
INSERT INTO `city_info` VALUES ('101131502', '新疆', '克州', '乌恰');
INSERT INTO `city_info` VALUES ('101131503', '新疆', '克州', '阿克陶');
INSERT INTO `city_info` VALUES ('101131504', '新疆', '克州', '阿合奇');
INSERT INTO `city_info` VALUES ('101131601', '新疆', '博尔塔拉', '博乐');
INSERT INTO `city_info` VALUES ('101131602', '新疆', '博尔塔拉', '温泉');
INSERT INTO `city_info` VALUES ('101131603', '新疆', '博尔塔拉', '精河');
INSERT INTO `city_info` VALUES ('101131606', '新疆', '博尔塔拉', '阿拉山口');
INSERT INTO `city_info` VALUES ('101140101', '西藏', '拉萨', '拉萨');
INSERT INTO `city_info` VALUES ('101140102', '西藏', '拉萨', '当雄');
INSERT INTO `city_info` VALUES ('101140103', '西藏', '拉萨', '尼木');
INSERT INTO `city_info` VALUES ('101140104', '西藏', '拉萨', '林周');
INSERT INTO `city_info` VALUES ('101140105', '西藏', '拉萨', '堆龙德庆');
INSERT INTO `city_info` VALUES ('101140106', '西藏', '拉萨', '曲水');
INSERT INTO `city_info` VALUES ('101140107', '西藏', '拉萨', '达孜');
INSERT INTO `city_info` VALUES ('101140108', '西藏', '拉萨', '墨竹工卡');
INSERT INTO `city_info` VALUES ('101140201', '西藏', '日喀则', '日喀则');
INSERT INTO `city_info` VALUES ('101140202', '西藏', '日喀则', '拉孜');
INSERT INTO `city_info` VALUES ('101140203', '西藏', '日喀则', '南木林');
INSERT INTO `city_info` VALUES ('101140204', '西藏', '日喀则', '聂拉木');
INSERT INTO `city_info` VALUES ('101140205', '西藏', '日喀则', '定日');
INSERT INTO `city_info` VALUES ('101140206', '西藏', '日喀则', '江孜');
INSERT INTO `city_info` VALUES ('101140207', '西藏', '日喀则', '帕里');
INSERT INTO `city_info` VALUES ('101140208', '西藏', '日喀则', '仲巴');
INSERT INTO `city_info` VALUES ('101140209', '西藏', '日喀则', '萨嘎');
INSERT INTO `city_info` VALUES ('101140210', '西藏', '日喀则', '吉隆');
INSERT INTO `city_info` VALUES ('101140211', '西藏', '日喀则', '昂仁');
INSERT INTO `city_info` VALUES ('101140212', '西藏', '日喀则', '定结');
INSERT INTO `city_info` VALUES ('101140213', '西藏', '日喀则', '萨迦');
INSERT INTO `city_info` VALUES ('101140214', '西藏', '日喀则', '谢通门');
INSERT INTO `city_info` VALUES ('101140216', '西藏', '日喀则', '岗巴');
INSERT INTO `city_info` VALUES ('101140217', '西藏', '日喀则', '白朗');
INSERT INTO `city_info` VALUES ('101140218', '西藏', '日喀则', '亚东');
INSERT INTO `city_info` VALUES ('101140219', '西藏', '日喀则', '康马');
INSERT INTO `city_info` VALUES ('101140220', '西藏', '日喀则', '仁布');
INSERT INTO `city_info` VALUES ('101140301', '西藏', '山南', '山南');
INSERT INTO `city_info` VALUES ('101140302', '西藏', '山南', '贡嘎');
INSERT INTO `city_info` VALUES ('101140303', '西藏', '山南', '扎囊');
INSERT INTO `city_info` VALUES ('101140304', '西藏', '山南', '加查');
INSERT INTO `city_info` VALUES ('101140305', '西藏', '山南', '浪卡子');
INSERT INTO `city_info` VALUES ('101140306', '西藏', '山南', '错那');
INSERT INTO `city_info` VALUES ('101140307', '西藏', '山南', '隆子');
INSERT INTO `city_info` VALUES ('101140308', '西藏', '山南', '泽当');
INSERT INTO `city_info` VALUES ('101140309', '西藏', '山南', '乃东');
INSERT INTO `city_info` VALUES ('101140310', '西藏', '山南', '桑日');
INSERT INTO `city_info` VALUES ('101140311', '西藏', '山南', '洛扎');
INSERT INTO `city_info` VALUES ('101140312', '西藏', '山南', '措美');
INSERT INTO `city_info` VALUES ('101140313', '西藏', '山南', '琼结');
INSERT INTO `city_info` VALUES ('101140314', '西藏', '山南', '曲松');
INSERT INTO `city_info` VALUES ('101140401', '西藏', '林芝', '林芝');
INSERT INTO `city_info` VALUES ('101140402', '西藏', '林芝', '波密');
INSERT INTO `city_info` VALUES ('101140403', '西藏', '林芝', '米林');
INSERT INTO `city_info` VALUES ('101140404', '西藏', '林芝', '察隅');
INSERT INTO `city_info` VALUES ('101140405', '西藏', '林芝', '工布江达');
INSERT INTO `city_info` VALUES ('101140406', '西藏', '林芝', '朗县');
INSERT INTO `city_info` VALUES ('101140407', '西藏', '林芝', '墨脱');
INSERT INTO `city_info` VALUES ('101140501', '西藏', '昌都', '昌都');
INSERT INTO `city_info` VALUES ('101140502', '西藏', '昌都', '丁青');
INSERT INTO `city_info` VALUES ('101140503', '西藏', '昌都', '边坝');
INSERT INTO `city_info` VALUES ('101140504', '西藏', '昌都', '洛隆');
INSERT INTO `city_info` VALUES ('101140505', '西藏', '昌都', '左贡');
INSERT INTO `city_info` VALUES ('101140506', '西藏', '昌都', '芒康');
INSERT INTO `city_info` VALUES ('101140507', '西藏', '昌都', '类乌齐');
INSERT INTO `city_info` VALUES ('101140508', '西藏', '昌都', '八宿');
INSERT INTO `city_info` VALUES ('101140509', '西藏', '昌都', '江达');
INSERT INTO `city_info` VALUES ('101140510', '西藏', '昌都', '察雅');
INSERT INTO `city_info` VALUES ('101140511', '西藏', '昌都', '贡觉');
INSERT INTO `city_info` VALUES ('101140601', '西藏', '那曲', '那曲');
INSERT INTO `city_info` VALUES ('101140602', '西藏', '那曲', '尼玛');
INSERT INTO `city_info` VALUES ('101140603', '西藏', '那曲', '嘉黎');
INSERT INTO `city_info` VALUES ('101140604', '西藏', '那曲', '班戈');
INSERT INTO `city_info` VALUES ('101140605', '西藏', '那曲', '安多');
INSERT INTO `city_info` VALUES ('101140606', '西藏', '那曲', '索县');
INSERT INTO `city_info` VALUES ('101140607', '西藏', '那曲', '聂荣');
INSERT INTO `city_info` VALUES ('101140608', '西藏', '那曲', '巴青');
INSERT INTO `city_info` VALUES ('101140609', '西藏', '那曲', '比如');
INSERT INTO `city_info` VALUES ('101140610', '西藏', '那曲', '双湖');
INSERT INTO `city_info` VALUES ('101140701', '西藏', '阿里', '阿里');
INSERT INTO `city_info` VALUES ('101140702', '西藏', '阿里', '改则');
INSERT INTO `city_info` VALUES ('101140703', '西藏', '阿里', '申扎');
INSERT INTO `city_info` VALUES ('101140704', '西藏', '阿里', '狮泉河');
INSERT INTO `city_info` VALUES ('101140705', '西藏', '阿里', '普兰');
INSERT INTO `city_info` VALUES ('101140706', '西藏', '阿里', '札达');
INSERT INTO `city_info` VALUES ('101140707', '西藏', '阿里', '噶尔');
INSERT INTO `city_info` VALUES ('101140708', '西藏', '阿里', '日土');
INSERT INTO `city_info` VALUES ('101140709', '西藏', '阿里', '革吉');
INSERT INTO `city_info` VALUES ('101140710', '西藏', '阿里', '措勤');
INSERT INTO `city_info` VALUES ('101150101', '青海', '西宁', '西宁');
INSERT INTO `city_info` VALUES ('101150102', '青海', '西宁', '大通');
INSERT INTO `city_info` VALUES ('101150103', '青海', '西宁', '湟源');
INSERT INTO `city_info` VALUES ('101150104', '青海', '西宁', '湟中');
INSERT INTO `city_info` VALUES ('101150201', '青海', '海东', '海东');
INSERT INTO `city_info` VALUES ('101150202', '青海', '海东', '乐都');
INSERT INTO `city_info` VALUES ('101150203', '青海', '海东', '民和');
INSERT INTO `city_info` VALUES ('101150204', '青海', '海东', '互助');
INSERT INTO `city_info` VALUES ('101150205', '青海', '海东', '化隆');
INSERT INTO `city_info` VALUES ('101150206', '青海', '海东', '循化');
INSERT INTO `city_info` VALUES ('101150207', '青海', '海东', '冷湖');
INSERT INTO `city_info` VALUES ('101150208', '青海', '海东', '平安');
INSERT INTO `city_info` VALUES ('101150301', '青海', '黄南', '黄南');
INSERT INTO `city_info` VALUES ('101150302', '青海', '黄南', '尖扎');
INSERT INTO `city_info` VALUES ('101150303', '青海', '黄南', '泽库');
INSERT INTO `city_info` VALUES ('101150304', '青海', '黄南', '河南');
INSERT INTO `city_info` VALUES ('101150305', '青海', '黄南', '同仁');
INSERT INTO `city_info` VALUES ('101150401', '青海', '海南', '海南');
INSERT INTO `city_info` VALUES ('101150404', '青海', '海南', '贵德');
INSERT INTO `city_info` VALUES ('101150406', '青海', '海南', '兴海');
INSERT INTO `city_info` VALUES ('101150407', '青海', '海南', '贵南');
INSERT INTO `city_info` VALUES ('101150408', '青海', '海南', '同德');
INSERT INTO `city_info` VALUES ('101150409', '青海', '海南', '共和');
INSERT INTO `city_info` VALUES ('101150501', '青海', '果洛', '果洛');
INSERT INTO `city_info` VALUES ('101150502', '青海', '果洛', '班玛');
INSERT INTO `city_info` VALUES ('101150503', '青海', '果洛', '甘德');
INSERT INTO `city_info` VALUES ('101150504', '青海', '果洛', '达日');
INSERT INTO `city_info` VALUES ('101150505', '青海', '果洛', '久治');
INSERT INTO `city_info` VALUES ('101150506', '青海', '果洛', '玛多');
INSERT INTO `city_info` VALUES ('101150507', '青海', '果洛', '多县');
INSERT INTO `city_info` VALUES ('101150508', '青海', '果洛', '玛沁');
INSERT INTO `city_info` VALUES ('101150601', '青海', '玉树', '玉树');
INSERT INTO `city_info` VALUES ('101150602', '青海', '玉树', '称多');
INSERT INTO `city_info` VALUES ('101150603', '青海', '玉树', '治多');
INSERT INTO `city_info` VALUES ('101150604', '青海', '玉树', '杂多');
INSERT INTO `city_info` VALUES ('101150605', '青海', '玉树', '囊谦');
INSERT INTO `city_info` VALUES ('101150606', '青海', '玉树', '曲麻莱');
INSERT INTO `city_info` VALUES ('101150701', '青海', '海西', '海西');
INSERT INTO `city_info` VALUES ('101150708', '青海', '海西', '天峻');
INSERT INTO `city_info` VALUES ('101150709', '青海', '海西', '乌兰');
INSERT INTO `city_info` VALUES ('101150712', '青海', '海西', '茫崖');
INSERT INTO `city_info` VALUES ('101150713', '青海', '海西', '大柴旦');
INSERT INTO `city_info` VALUES ('101150716', '青海', '海西', '德令哈');
INSERT INTO `city_info` VALUES ('101150801', '青海', '海北', '海北');
INSERT INTO `city_info` VALUES ('101150802', '青海', '海北', '门源');
INSERT INTO `city_info` VALUES ('101150803', '青海', '海北', '祁连');
INSERT INTO `city_info` VALUES ('101150804', '青海', '海北', '海晏');
INSERT INTO `city_info` VALUES ('101150806', '青海', '海北', '刚察');
INSERT INTO `city_info` VALUES ('101150901', '青海', '格尔木', '格尔木');
INSERT INTO `city_info` VALUES ('101150902', '青海', '格尔木', '都兰');
INSERT INTO `city_info` VALUES ('101160101', '甘肃', '兰州', '兰州');
INSERT INTO `city_info` VALUES ('101160102', '甘肃', '兰州', '皋兰');
INSERT INTO `city_info` VALUES ('101160103', '甘肃', '兰州', '永登');
INSERT INTO `city_info` VALUES ('101160104', '甘肃', '兰州', '榆中');
INSERT INTO `city_info` VALUES ('101160201', '甘肃', '定西', '定西');
INSERT INTO `city_info` VALUES ('101160202', '甘肃', '定西', '通渭');
INSERT INTO `city_info` VALUES ('101160203', '甘肃', '定西', '陇西');
INSERT INTO `city_info` VALUES ('101160204', '甘肃', '定西', '渭源');
INSERT INTO `city_info` VALUES ('101160205', '甘肃', '定西', '临洮');
INSERT INTO `city_info` VALUES ('101160206', '甘肃', '定西', '漳县');
INSERT INTO `city_info` VALUES ('101160207', '甘肃', '定西', '岷县');
INSERT INTO `city_info` VALUES ('101160208', '甘肃', '定西', '安定');
INSERT INTO `city_info` VALUES ('101160301', '甘肃', '平凉', '平凉');
INSERT INTO `city_info` VALUES ('101160302', '甘肃', '平凉', '泾川');
INSERT INTO `city_info` VALUES ('101160303', '甘肃', '平凉', '灵台');
INSERT INTO `city_info` VALUES ('101160304', '甘肃', '平凉', '崇信');
INSERT INTO `city_info` VALUES ('101160305', '甘肃', '平凉', '华亭');
INSERT INTO `city_info` VALUES ('101160306', '甘肃', '平凉', '庄浪');
INSERT INTO `city_info` VALUES ('101160307', '甘肃', '平凉', '静宁');
INSERT INTO `city_info` VALUES ('101160308', '甘肃', '平凉', '崆峒');
INSERT INTO `city_info` VALUES ('101160401', '甘肃', '庆阳', '西峰');
INSERT INTO `city_info` VALUES ('101160403', '甘肃', '庆阳', '环县');
INSERT INTO `city_info` VALUES ('101160404', '甘肃', '庆阳', '华池');
INSERT INTO `city_info` VALUES ('101160405', '甘肃', '庆阳', '合水');
INSERT INTO `city_info` VALUES ('101160406', '甘肃', '庆阳', '正宁');
INSERT INTO `city_info` VALUES ('101160407', '甘肃', '庆阳', '宁县');
INSERT INTO `city_info` VALUES ('101160408', '甘肃', '庆阳', '镇原');
INSERT INTO `city_info` VALUES ('101160409', '甘肃', '庆阳', '庆城');
INSERT INTO `city_info` VALUES ('101160501', '甘肃', '武威', '武威');
INSERT INTO `city_info` VALUES ('101160502', '甘肃', '武威', '民勤');
INSERT INTO `city_info` VALUES ('101160503', '甘肃', '武威', '古浪');
INSERT INTO `city_info` VALUES ('101160505', '甘肃', '武威', '天祝');
INSERT INTO `city_info` VALUES ('101160601', '甘肃', '金昌', '金昌');
INSERT INTO `city_info` VALUES ('101160602', '甘肃', '金昌', '永昌');
INSERT INTO `city_info` VALUES ('101160701', '甘肃', '张掖', '张掖');
INSERT INTO `city_info` VALUES ('101160702', '甘肃', '张掖', '肃南');
INSERT INTO `city_info` VALUES ('101160703', '甘肃', '张掖', '民乐');
INSERT INTO `city_info` VALUES ('101160704', '甘肃', '张掖', '临泽');
INSERT INTO `city_info` VALUES ('101160705', '甘肃', '张掖', '高台');
INSERT INTO `city_info` VALUES ('101160706', '甘肃', '张掖', '山丹');
INSERT INTO `city_info` VALUES ('101160801', '甘肃', '酒泉', '酒泉');
INSERT INTO `city_info` VALUES ('101160803', '甘肃', '酒泉', '金塔');
INSERT INTO `city_info` VALUES ('101160804', '甘肃', '酒泉', '阿克塞');
INSERT INTO `city_info` VALUES ('101160805', '甘肃', '酒泉', '瓜州');
INSERT INTO `city_info` VALUES ('101160806', '甘肃', '酒泉', '肃北');
INSERT INTO `city_info` VALUES ('101160807', '甘肃', '酒泉', '玉门');
INSERT INTO `city_info` VALUES ('101160808', '甘肃', '酒泉', '敦煌');
INSERT INTO `city_info` VALUES ('101160901', '甘肃', '天水', '天水');
INSERT INTO `city_info` VALUES ('101160903', '甘肃', '天水', '清水');
INSERT INTO `city_info` VALUES ('101160904', '甘肃', '天水', '秦安');
INSERT INTO `city_info` VALUES ('101160905', '甘肃', '天水', '甘谷');
INSERT INTO `city_info` VALUES ('101160906', '甘肃', '天水', '武山');
INSERT INTO `city_info` VALUES ('101160907', '甘肃', '天水', '张家川');
INSERT INTO `city_info` VALUES ('101160908', '甘肃', '天水', '麦积');
INSERT INTO `city_info` VALUES ('101161001', '甘肃', '陇南', '武都');
INSERT INTO `city_info` VALUES ('101161002', '甘肃', '陇南', '成县');
INSERT INTO `city_info` VALUES ('101161003', '甘肃', '陇南', '文县');
INSERT INTO `city_info` VALUES ('101161004', '甘肃', '陇南', '宕昌');
INSERT INTO `city_info` VALUES ('101161005', '甘肃', '陇南', '康县');
INSERT INTO `city_info` VALUES ('101161006', '甘肃', '陇南', '西和');
INSERT INTO `city_info` VALUES ('101161007', '甘肃', '陇南', '礼县');
INSERT INTO `city_info` VALUES ('101161008', '甘肃', '陇南', '徽县');
INSERT INTO `city_info` VALUES ('101161009', '甘肃', '陇南', '两当');
INSERT INTO `city_info` VALUES ('101161101', '甘肃', '临夏', '临夏');
INSERT INTO `city_info` VALUES ('101161102', '甘肃', '临夏', '康乐');
INSERT INTO `city_info` VALUES ('101161103', '甘肃', '临夏', '永靖');
INSERT INTO `city_info` VALUES ('101161104', '甘肃', '临夏', '广河');
INSERT INTO `city_info` VALUES ('101161105', '甘肃', '临夏', '和政');
INSERT INTO `city_info` VALUES ('101161106', '甘肃', '临夏', '东乡');
INSERT INTO `city_info` VALUES ('101161107', '甘肃', '临夏', '积石山');
INSERT INTO `city_info` VALUES ('101161201', '甘肃', '甘南', '合作');
INSERT INTO `city_info` VALUES ('101161202', '甘肃', '甘南', '临潭');
INSERT INTO `city_info` VALUES ('101161203', '甘肃', '甘南', '卓尼');
INSERT INTO `city_info` VALUES ('101161204', '甘肃', '甘南', '舟曲');
INSERT INTO `city_info` VALUES ('101161205', '甘肃', '甘南', '迭部');
INSERT INTO `city_info` VALUES ('101161206', '甘肃', '甘南', '玛曲');
INSERT INTO `city_info` VALUES ('101161207', '甘肃', '甘南', '碌曲');
INSERT INTO `city_info` VALUES ('101161208', '甘肃', '甘南', '夏河');
INSERT INTO `city_info` VALUES ('101161301', '甘肃', '白银', '白银');
INSERT INTO `city_info` VALUES ('101161302', '甘肃', '白银', '靖远');
INSERT INTO `city_info` VALUES ('101161303', '甘肃', '白银', '会宁');
INSERT INTO `city_info` VALUES ('101161304', '甘肃', '白银', '平川');
INSERT INTO `city_info` VALUES ('101161305', '甘肃', '白银', '景泰');
INSERT INTO `city_info` VALUES ('101161401', '甘肃', '嘉峪关', '嘉峪关');
INSERT INTO `city_info` VALUES ('101170101', '宁夏', '银川', '银川');
INSERT INTO `city_info` VALUES ('101170102', '宁夏', '银川', '永宁');
INSERT INTO `city_info` VALUES ('101170103', '宁夏', '银川', '灵武');
INSERT INTO `city_info` VALUES ('101170104', '宁夏', '银川', '贺兰');
INSERT INTO `city_info` VALUES ('101170201', '宁夏', '石嘴山', '石嘴山');
INSERT INTO `city_info` VALUES ('101170202', '宁夏', '石嘴山', '惠农');
INSERT INTO `city_info` VALUES ('101170203', '宁夏', '石嘴山', '平罗');
INSERT INTO `city_info` VALUES ('101170204', '宁夏', '石嘴山', '陶乐');
INSERT INTO `city_info` VALUES ('101170301', '宁夏', '吴忠', '吴忠');
INSERT INTO `city_info` VALUES ('101170302', '宁夏', '吴忠', '同心');
INSERT INTO `city_info` VALUES ('101170303', '宁夏', '吴忠', '盐池');
INSERT INTO `city_info` VALUES ('101170306', '宁夏', '吴忠', '青铜峡');
INSERT INTO `city_info` VALUES ('101170401', '宁夏', '固原', '固原');
INSERT INTO `city_info` VALUES ('101170402', '宁夏', '固原', '西吉');
INSERT INTO `city_info` VALUES ('101170403', '宁夏', '固原', '隆德');
INSERT INTO `city_info` VALUES ('101170404', '宁夏', '固原', '泾源');
INSERT INTO `city_info` VALUES ('101170406', '宁夏', '固原', '彭阳');
INSERT INTO `city_info` VALUES ('101170501', '宁夏', '中卫', '中卫');
INSERT INTO `city_info` VALUES ('101170502', '宁夏', '中卫', '中宁');
INSERT INTO `city_info` VALUES ('101170504', '宁夏', '中卫', '海原');
INSERT INTO `city_info` VALUES ('101180101', '河南', '郑州', '郑州');
INSERT INTO `city_info` VALUES ('101180102', '河南', '郑州', '巩义');
INSERT INTO `city_info` VALUES ('101180103', '河南', '郑州', '荥阳');
INSERT INTO `city_info` VALUES ('101180104', '河南', '郑州', '登封');
INSERT INTO `city_info` VALUES ('101180105', '河南', '郑州', '新密');
INSERT INTO `city_info` VALUES ('101180106', '河南', '郑州', '新郑');
INSERT INTO `city_info` VALUES ('101180107', '河南', '郑州', '中牟');
INSERT INTO `city_info` VALUES ('101180108', '河南', '郑州', '上街');
INSERT INTO `city_info` VALUES ('101180201', '河南', '安阳', '安阳');
INSERT INTO `city_info` VALUES ('101180202', '河南', '安阳', '汤阴');
INSERT INTO `city_info` VALUES ('101180203', '河南', '安阳', '滑县');
INSERT INTO `city_info` VALUES ('101180204', '河南', '安阳', '内黄');
INSERT INTO `city_info` VALUES ('101180205', '河南', '安阳', '林州');
INSERT INTO `city_info` VALUES ('101180301', '河南', '新乡', '新乡');
INSERT INTO `city_info` VALUES ('101180302', '河南', '新乡', '获嘉');
INSERT INTO `city_info` VALUES ('101180303', '河南', '新乡', '原阳');
INSERT INTO `city_info` VALUES ('101180304', '河南', '新乡', '辉县');
INSERT INTO `city_info` VALUES ('101180305', '河南', '新乡', '卫辉');
INSERT INTO `city_info` VALUES ('101180306', '河南', '新乡', '延津');
INSERT INTO `city_info` VALUES ('101180307', '河南', '新乡', '封丘');
INSERT INTO `city_info` VALUES ('101180308', '河南', '新乡', '长垣');
INSERT INTO `city_info` VALUES ('101180401', '河南', '许昌', '许昌');
INSERT INTO `city_info` VALUES ('101180402', '河南', '许昌', '鄢陵');
INSERT INTO `city_info` VALUES ('101180403', '河南', '许昌', '襄城');
INSERT INTO `city_info` VALUES ('101180404', '河南', '许昌', '长葛');
INSERT INTO `city_info` VALUES ('101180405', '河南', '许昌', '禹州');
INSERT INTO `city_info` VALUES ('101180501', '河南', '平顶山', '平顶山');
INSERT INTO `city_info` VALUES ('101180502', '河南', '平顶山', '郏县');
INSERT INTO `city_info` VALUES ('101180503', '河南', '平顶山', '宝丰');
INSERT INTO `city_info` VALUES ('101180504', '河南', '平顶山', '汝州');
INSERT INTO `city_info` VALUES ('101180505', '河南', '平顶山', '叶县');
INSERT INTO `city_info` VALUES ('101180506', '河南', '平顶山', '舞钢');
INSERT INTO `city_info` VALUES ('101180507', '河南', '平顶山', '鲁山');
INSERT INTO `city_info` VALUES ('101180508', '河南', '平顶山', '石龙');
INSERT INTO `city_info` VALUES ('101180601', '河南', '信阳', '信阳');
INSERT INTO `city_info` VALUES ('101180602', '河南', '信阳', '息县');
INSERT INTO `city_info` VALUES ('101180603', '河南', '信阳', '罗山');
INSERT INTO `city_info` VALUES ('101180604', '河南', '信阳', '光山');
INSERT INTO `city_info` VALUES ('101180605', '河南', '信阳', '新县');
INSERT INTO `city_info` VALUES ('101180606', '河南', '信阳', '淮滨');
INSERT INTO `city_info` VALUES ('101180607', '河南', '信阳', '潢川');
INSERT INTO `city_info` VALUES ('101180608', '河南', '信阳', '固始');
INSERT INTO `city_info` VALUES ('101180609', '河南', '信阳', '商城');
INSERT INTO `city_info` VALUES ('101180701', '河南', '南阳', '南阳');
INSERT INTO `city_info` VALUES ('101180702', '河南', '南阳', '南召');
INSERT INTO `city_info` VALUES ('101180703', '河南', '南阳', '方城');
INSERT INTO `city_info` VALUES ('101180704', '河南', '南阳', '社旗');
INSERT INTO `city_info` VALUES ('101180705', '河南', '南阳', '西峡');
INSERT INTO `city_info` VALUES ('101180706', '河南', '南阳', '内乡');
INSERT INTO `city_info` VALUES ('101180707', '河南', '南阳', '镇平');
INSERT INTO `city_info` VALUES ('101180708', '河南', '南阳', '淅川');
INSERT INTO `city_info` VALUES ('101180709', '河南', '南阳', '新野');
INSERT INTO `city_info` VALUES ('101180710', '河南', '南阳', '唐河');
INSERT INTO `city_info` VALUES ('101180711', '河南', '南阳', '邓州');
INSERT INTO `city_info` VALUES ('101180712', '河南', '南阳', '桐柏');
INSERT INTO `city_info` VALUES ('101180801', '河南', '开封', '开封');
INSERT INTO `city_info` VALUES ('101180802', '河南', '开封', '杞县');
INSERT INTO `city_info` VALUES ('101180803', '河南', '开封', '尉氏');
INSERT INTO `city_info` VALUES ('101180804', '河南', '开封', '通许');
INSERT INTO `city_info` VALUES ('101180805', '河南', '开封', '兰考');
INSERT INTO `city_info` VALUES ('101180901', '河南', '洛阳', '洛阳');
INSERT INTO `city_info` VALUES ('101180902', '河南', '洛阳', '新安');
INSERT INTO `city_info` VALUES ('101180903', '河南', '洛阳', '孟津');
INSERT INTO `city_info` VALUES ('101180904', '河南', '洛阳', '宜阳');
INSERT INTO `city_info` VALUES ('101180905', '河南', '洛阳', '洛宁');
INSERT INTO `city_info` VALUES ('101180906', '河南', '洛阳', '伊川');
INSERT INTO `city_info` VALUES ('101180907', '河南', '洛阳', '嵩县');
INSERT INTO `city_info` VALUES ('101180908', '河南', '洛阳', '偃师');
INSERT INTO `city_info` VALUES ('101180909', '河南', '洛阳', '栾川');
INSERT INTO `city_info` VALUES ('101180910', '河南', '洛阳', '汝阳');
INSERT INTO `city_info` VALUES ('101180911', '河南', '洛阳', '吉利');
INSERT INTO `city_info` VALUES ('101181001', '河南', '商丘', '商丘');
INSERT INTO `city_info` VALUES ('101181003', '河南', '商丘', '睢县');
INSERT INTO `city_info` VALUES ('101181004', '河南', '商丘', '民权');
INSERT INTO `city_info` VALUES ('101181005', '河南', '商丘', '虞城');
INSERT INTO `city_info` VALUES ('101181006', '河南', '商丘', '柘城');
INSERT INTO `city_info` VALUES ('101181007', '河南', '商丘', '宁陵');
INSERT INTO `city_info` VALUES ('101181008', '河南', '商丘', '夏邑');
INSERT INTO `city_info` VALUES ('101181009', '河南', '商丘', '永城');
INSERT INTO `city_info` VALUES ('101181101', '河南', '焦作', '焦作');
INSERT INTO `city_info` VALUES ('101181102', '河南', '焦作', '修武');
INSERT INTO `city_info` VALUES ('101181103', '河南', '焦作', '武陟');
INSERT INTO `city_info` VALUES ('101181104', '河南', '焦作', '沁阳');
INSERT INTO `city_info` VALUES ('101181106', '河南', '焦作', '博爱');
INSERT INTO `city_info` VALUES ('101181107', '河南', '焦作', '温县');
INSERT INTO `city_info` VALUES ('101181108', '河南', '焦作', '孟州');
INSERT INTO `city_info` VALUES ('101181201', '河南', '鹤壁', '鹤壁');
INSERT INTO `city_info` VALUES ('101181202', '河南', '鹤壁', '浚县');
INSERT INTO `city_info` VALUES ('101181203', '河南', '鹤壁', '淇县');
INSERT INTO `city_info` VALUES ('101181301', '河南', '濮阳', '濮阳');
INSERT INTO `city_info` VALUES ('101181302', '河南', '濮阳', '台前');
INSERT INTO `city_info` VALUES ('101181303', '河南', '濮阳', '南乐');
INSERT INTO `city_info` VALUES ('101181304', '河南', '濮阳', '清丰');
INSERT INTO `city_info` VALUES ('101181305', '河南', '濮阳', '范县');
INSERT INTO `city_info` VALUES ('101181401', '河南', '周口', '周口');
INSERT INTO `city_info` VALUES ('101181402', '河南', '周口', '扶沟');
INSERT INTO `city_info` VALUES ('101181403', '河南', '周口', '太康');
INSERT INTO `city_info` VALUES ('101181404', '河南', '周口', '淮阳');
INSERT INTO `city_info` VALUES ('101181405', '河南', '周口', '西华');
INSERT INTO `city_info` VALUES ('101181406', '河南', '周口', '商水');
INSERT INTO `city_info` VALUES ('101181407', '河南', '周口', '项城');
INSERT INTO `city_info` VALUES ('101181408', '河南', '周口', '郸城');
INSERT INTO `city_info` VALUES ('101181409', '河南', '周口', '鹿邑');
INSERT INTO `city_info` VALUES ('101181410', '河南', '周口', '沈丘');
INSERT INTO `city_info` VALUES ('101181501', '河南', '漯河', '漯河');
INSERT INTO `city_info` VALUES ('101181502', '河南', '漯河', '临颍');
INSERT INTO `city_info` VALUES ('101181503', '河南', '漯河', '舞阳');
INSERT INTO `city_info` VALUES ('101181601', '河南', '驻马店', '驻马店');
INSERT INTO `city_info` VALUES ('101181602', '河南', '驻马店', '西平');
INSERT INTO `city_info` VALUES ('101181603', '河南', '驻马店', '遂平');
INSERT INTO `city_info` VALUES ('101181604', '河南', '驻马店', '上蔡');
INSERT INTO `city_info` VALUES ('101181605', '河南', '驻马店', '汝南');
INSERT INTO `city_info` VALUES ('101181606', '河南', '驻马店', '泌阳');
INSERT INTO `city_info` VALUES ('101181607', '河南', '驻马店', '平舆');
INSERT INTO `city_info` VALUES ('101181608', '河南', '驻马店', '新蔡');
INSERT INTO `city_info` VALUES ('101181609', '河南', '驻马店', '确山');
INSERT INTO `city_info` VALUES ('101181610', '河南', '驻马店', '正阳');
INSERT INTO `city_info` VALUES ('101181701', '河南', '三门峡', '三门峡');
INSERT INTO `city_info` VALUES ('101181702', '河南', '三门峡', '灵宝');
INSERT INTO `city_info` VALUES ('101181703', '河南', '三门峡', '渑池');
INSERT INTO `city_info` VALUES ('101181704', '河南', '三门峡', '卢氏');
INSERT INTO `city_info` VALUES ('101181705', '河南', '三门峡', '义马');
INSERT INTO `city_info` VALUES ('101181706', '河南', '三门峡', '陕县');
INSERT INTO `city_info` VALUES ('101181801', '河南', '济源', '济源');
INSERT INTO `city_info` VALUES ('101190101', '江苏', '南京', '南京');
INSERT INTO `city_info` VALUES ('101190102', '江苏', '南京', '溧水');
INSERT INTO `city_info` VALUES ('101190103', '江苏', '南京', '高淳');
INSERT INTO `city_info` VALUES ('101190104', '江苏', '南京', '江宁');
INSERT INTO `city_info` VALUES ('101190105', '江苏', '南京', '六合');
INSERT INTO `city_info` VALUES ('101190106', '江苏', '南京', '江浦');
INSERT INTO `city_info` VALUES ('101190107', '江苏', '南京', '浦口');
INSERT INTO `city_info` VALUES ('101190201', '江苏', '无锡', '无锡');
INSERT INTO `city_info` VALUES ('101190202', '江苏', '无锡', '江阴');
INSERT INTO `city_info` VALUES ('101190203', '江苏', '无锡', '宜兴');
INSERT INTO `city_info` VALUES ('101190204', '江苏', '无锡', '锡山');
INSERT INTO `city_info` VALUES ('101190301', '江苏', '镇江', '镇江');
INSERT INTO `city_info` VALUES ('101190302', '江苏', '镇江', '丹阳');
INSERT INTO `city_info` VALUES ('101190303', '江苏', '镇江', '扬中');
INSERT INTO `city_info` VALUES ('101190304', '江苏', '镇江', '句容');
INSERT INTO `city_info` VALUES ('101190305', '江苏', '镇江', '丹徒');
INSERT INTO `city_info` VALUES ('101190401', '江苏', '苏州', '苏州');
INSERT INTO `city_info` VALUES ('101190402', '江苏', '苏州', '常熟');
INSERT INTO `city_info` VALUES ('101190403', '江苏', '苏州', '张家港');
INSERT INTO `city_info` VALUES ('101190404', '江苏', '苏州', '昆山');
INSERT INTO `city_info` VALUES ('101190405', '江苏', '苏州', '吴中');
INSERT INTO `city_info` VALUES ('101190407', '江苏', '苏州', '吴江');
INSERT INTO `city_info` VALUES ('101190408', '江苏', '苏州', '太仓');
INSERT INTO `city_info` VALUES ('101190501', '江苏', '南通', '南通');
INSERT INTO `city_info` VALUES ('101190502', '江苏', '南通', '海安');
INSERT INTO `city_info` VALUES ('101190503', '江苏', '南通', '如皋');
INSERT INTO `city_info` VALUES ('101190504', '江苏', '南通', '如东');
INSERT INTO `city_info` VALUES ('101190507', '江苏', '南通', '启东');
INSERT INTO `city_info` VALUES ('101190508', '江苏', '南通', '海门');
INSERT INTO `city_info` VALUES ('101190509', '江苏', '南通', '通州');
INSERT INTO `city_info` VALUES ('101190601', '江苏', '扬州', '扬州');
INSERT INTO `city_info` VALUES ('101190602', '江苏', '扬州', '宝应');
INSERT INTO `city_info` VALUES ('101190603', '江苏', '扬州', '仪征');
INSERT INTO `city_info` VALUES ('101190604', '江苏', '扬州', '高邮');
INSERT INTO `city_info` VALUES ('101190605', '江苏', '扬州', '江都');
INSERT INTO `city_info` VALUES ('101190606', '江苏', '扬州', '邗江');
INSERT INTO `city_info` VALUES ('101190701', '江苏', '盐城', '盐城');
INSERT INTO `city_info` VALUES ('101190702', '江苏', '盐城', '响水');
INSERT INTO `city_info` VALUES ('101190703', '江苏', '盐城', '滨海');
INSERT INTO `city_info` VALUES ('101190704', '江苏', '盐城', '阜宁');
INSERT INTO `city_info` VALUES ('101190705', '江苏', '盐城', '射阳');
INSERT INTO `city_info` VALUES ('101190706', '江苏', '盐城', '建湖');
INSERT INTO `city_info` VALUES ('101190707', '江苏', '盐城', '东台');
INSERT INTO `city_info` VALUES ('101190708', '江苏', '盐城', '大丰');
INSERT INTO `city_info` VALUES ('101190709', '江苏', '盐城', '盐都');
INSERT INTO `city_info` VALUES ('101190801', '江苏', '徐州', '徐州');
INSERT INTO `city_info` VALUES ('101190802', '江苏', '徐州', '铜山');
INSERT INTO `city_info` VALUES ('101190803', '江苏', '徐州', '丰县');
INSERT INTO `city_info` VALUES ('101190804', '江苏', '徐州', '沛县');
INSERT INTO `city_info` VALUES ('101190805', '江苏', '徐州', '邳州');
INSERT INTO `city_info` VALUES ('101190806', '江苏', '徐州', '睢宁');
INSERT INTO `city_info` VALUES ('101190807', '江苏', '徐州', '新沂');
INSERT INTO `city_info` VALUES ('101190901', '江苏', '淮安', '淮安');
INSERT INTO `city_info` VALUES ('101190902', '江苏', '淮安', '金湖');
INSERT INTO `city_info` VALUES ('101190903', '江苏', '淮安', '盱眙');
INSERT INTO `city_info` VALUES ('101190904', '江苏', '淮安', '洪泽');
INSERT INTO `city_info` VALUES ('101190905', '江苏', '淮安', '涟水');
INSERT INTO `city_info` VALUES ('101190906', '江苏', '淮安', '淮阴区');
INSERT INTO `city_info` VALUES ('101190908', '江苏', '淮安', '淮安区');
INSERT INTO `city_info` VALUES ('101191001', '江苏', '连云港', '连云港');
INSERT INTO `city_info` VALUES ('101191002', '江苏', '连云港', '东海');
INSERT INTO `city_info` VALUES ('101191003', '江苏', '连云港', '赣榆');
INSERT INTO `city_info` VALUES ('101191004', '江苏', '连云港', '灌云');
INSERT INTO `city_info` VALUES ('101191005', '江苏', '连云港', '灌南');
INSERT INTO `city_info` VALUES ('101191101', '江苏', '常州', '常州');
INSERT INTO `city_info` VALUES ('101191102', '江苏', '常州', '溧阳');
INSERT INTO `city_info` VALUES ('101191103', '江苏', '常州', '金坛');
INSERT INTO `city_info` VALUES ('101191104', '江苏', '常州', '武进');
INSERT INTO `city_info` VALUES ('101191201', '江苏', '泰州', '泰州');
INSERT INTO `city_info` VALUES ('101191202', '江苏', '泰州', '兴化');
INSERT INTO `city_info` VALUES ('101191203', '江苏', '泰州', '泰兴');
INSERT INTO `city_info` VALUES ('101191204', '江苏', '泰州', '姜堰');
INSERT INTO `city_info` VALUES ('101191205', '江苏', '泰州', '靖江');
INSERT INTO `city_info` VALUES ('101191301', '江苏', '宿迁', '宿迁');
INSERT INTO `city_info` VALUES ('101191302', '江苏', '宿迁', '沭阳');
INSERT INTO `city_info` VALUES ('101191303', '江苏', '宿迁', '泗阳');
INSERT INTO `city_info` VALUES ('101191304', '江苏', '宿迁', '泗洪');
INSERT INTO `city_info` VALUES ('101191305', '江苏', '宿迁', '宿豫');
INSERT INTO `city_info` VALUES ('101200101', '湖北', '武汉', '武汉');
INSERT INTO `city_info` VALUES ('101200102', '湖北', '武汉', '蔡甸');
INSERT INTO `city_info` VALUES ('101200103', '湖北', '武汉', '黄陂');
INSERT INTO `city_info` VALUES ('101200104', '湖北', '武汉', '新洲');
INSERT INTO `city_info` VALUES ('101200105', '湖北', '武汉', '江夏');
INSERT INTO `city_info` VALUES ('101200106', '湖北', '武汉', '东西湖');
INSERT INTO `city_info` VALUES ('101200201', '湖北', '襄阳', '襄阳');
INSERT INTO `city_info` VALUES ('101200202', '湖北', '襄阳', '襄州');
INSERT INTO `city_info` VALUES ('101200203', '湖北', '襄阳', '保康');
INSERT INTO `city_info` VALUES ('101200204', '湖北', '襄阳', '南漳');
INSERT INTO `city_info` VALUES ('101200205', '湖北', '襄阳', '宜城');
INSERT INTO `city_info` VALUES ('101200206', '湖北', '襄阳', '老河口');
INSERT INTO `city_info` VALUES ('101200207', '湖北', '襄阳', '谷城');
INSERT INTO `city_info` VALUES ('101200208', '湖北', '襄阳', '枣阳');
INSERT INTO `city_info` VALUES ('101200301', '湖北', '鄂州', '鄂州');
INSERT INTO `city_info` VALUES ('101200302', '湖北', '鄂州', '梁子湖');
INSERT INTO `city_info` VALUES ('101200401', '湖北', '孝感', '孝感');
INSERT INTO `city_info` VALUES ('101200402', '湖北', '孝感', '安陆');
INSERT INTO `city_info` VALUES ('101200403', '湖北', '孝感', '云梦');
INSERT INTO `city_info` VALUES ('101200404', '湖北', '孝感', '大悟');
INSERT INTO `city_info` VALUES ('101200405', '湖北', '孝感', '应城');
INSERT INTO `city_info` VALUES ('101200406', '湖北', '孝感', '汉川');
INSERT INTO `city_info` VALUES ('101200407', '湖北', '孝感', '孝昌');
INSERT INTO `city_info` VALUES ('101200501', '湖北', '黄冈', '黄冈');
INSERT INTO `city_info` VALUES ('101200502', '湖北', '黄冈', '红安');
INSERT INTO `city_info` VALUES ('101200503', '湖北', '黄冈', '麻城');
INSERT INTO `city_info` VALUES ('101200504', '湖北', '黄冈', '罗田');
INSERT INTO `city_info` VALUES ('101200505', '湖北', '黄冈', '英山');
INSERT INTO `city_info` VALUES ('101200506', '湖北', '黄冈', '浠水');
INSERT INTO `city_info` VALUES ('101200507', '湖北', '黄冈', '蕲春');
INSERT INTO `city_info` VALUES ('101200508', '湖北', '黄冈', '黄梅');
INSERT INTO `city_info` VALUES ('101200509', '湖北', '黄冈', '武穴');
INSERT INTO `city_info` VALUES ('101200510', '湖北', '黄冈', '团风');
INSERT INTO `city_info` VALUES ('101200601', '湖北', '黄石', '黄石');
INSERT INTO `city_info` VALUES ('101200602', '湖北', '黄石', '大冶');
INSERT INTO `city_info` VALUES ('101200603', '湖北', '黄石', '阳新');
INSERT INTO `city_info` VALUES ('101200604', '湖北', '黄石', '铁山');
INSERT INTO `city_info` VALUES ('101200605', '湖北', '黄石', '下陆');
INSERT INTO `city_info` VALUES ('101200606', '湖北', '黄石', '西塞山');
INSERT INTO `city_info` VALUES ('101200701', '湖北', '咸宁', '咸宁');
INSERT INTO `city_info` VALUES ('101200702', '湖北', '咸宁', '赤壁');
INSERT INTO `city_info` VALUES ('101200703', '湖北', '咸宁', '嘉鱼');
INSERT INTO `city_info` VALUES ('101200704', '湖北', '咸宁', '崇阳');
INSERT INTO `city_info` VALUES ('101200705', '湖北', '咸宁', '通城');
INSERT INTO `city_info` VALUES ('101200706', '湖北', '咸宁', '通山');
INSERT INTO `city_info` VALUES ('101200801', '湖北', '荆州', '荆州');
INSERT INTO `city_info` VALUES ('101200802', '湖北', '荆州', '江陵');
INSERT INTO `city_info` VALUES ('101200803', '湖北', '荆州', '公安');
INSERT INTO `city_info` VALUES ('101200804', '湖北', '荆州', '石首');
INSERT INTO `city_info` VALUES ('101200805', '湖北', '荆州', '监利');
INSERT INTO `city_info` VALUES ('101200806', '湖北', '荆州', '洪湖');
INSERT INTO `city_info` VALUES ('101200807', '湖北', '荆州', '松滋');
INSERT INTO `city_info` VALUES ('101200901', '湖北', '宜昌', '宜昌');
INSERT INTO `city_info` VALUES ('101200902', '湖北', '宜昌', '远安');
INSERT INTO `city_info` VALUES ('101200903', '湖北', '宜昌', '秭归');
INSERT INTO `city_info` VALUES ('101200904', '湖北', '宜昌', '兴山');
INSERT INTO `city_info` VALUES ('101200906', '湖北', '宜昌', '五峰');
INSERT INTO `city_info` VALUES ('101200907', '湖北', '宜昌', '当阳');
INSERT INTO `city_info` VALUES ('101200908', '湖北', '宜昌', '长阳');
INSERT INTO `city_info` VALUES ('101200909', '湖北', '宜昌', '宜都');
INSERT INTO `city_info` VALUES ('101200910', '湖北', '宜昌', '枝江');
INSERT INTO `city_info` VALUES ('101200911', '湖北', '宜昌', '三峡');
INSERT INTO `city_info` VALUES ('101200912', '湖北', '宜昌', '夷陵');
INSERT INTO `city_info` VALUES ('101201001', '湖北', '恩施', '恩施');
INSERT INTO `city_info` VALUES ('101201002', '湖北', '恩施', '利川');
INSERT INTO `city_info` VALUES ('101201003', '湖北', '恩施', '建始');
INSERT INTO `city_info` VALUES ('101201004', '湖北', '恩施', '咸丰');
INSERT INTO `city_info` VALUES ('101201005', '湖北', '恩施', '宣恩');
INSERT INTO `city_info` VALUES ('101201006', '湖北', '恩施', '鹤峰');
INSERT INTO `city_info` VALUES ('101201007', '湖北', '恩施', '来凤');
INSERT INTO `city_info` VALUES ('101201008', '湖北', '恩施', '巴东');
INSERT INTO `city_info` VALUES ('101201101', '湖北', '十堰', '十堰');
INSERT INTO `city_info` VALUES ('101201102', '湖北', '十堰', '竹溪');
INSERT INTO `city_info` VALUES ('101201103', '湖北', '十堰', '郧西');
INSERT INTO `city_info` VALUES ('101201104', '湖北', '十堰', '郧县');
INSERT INTO `city_info` VALUES ('101201105', '湖北', '十堰', '竹山');
INSERT INTO `city_info` VALUES ('101201106', '湖北', '十堰', '房县');
INSERT INTO `city_info` VALUES ('101201107', '湖北', '十堰', '丹江口');
INSERT INTO `city_info` VALUES ('101201108', '湖北', '十堰', '茅箭');
INSERT INTO `city_info` VALUES ('101201109', '湖北', '十堰', '张湾');
INSERT INTO `city_info` VALUES ('101201201', '湖北', '神农架', '神农架');
INSERT INTO `city_info` VALUES ('101201301', '湖北', '随州', '随州');
INSERT INTO `city_info` VALUES ('101201302', '湖北', '随州', '广水');
INSERT INTO `city_info` VALUES ('101201401', '湖北', '荆门', '荆门');
INSERT INTO `city_info` VALUES ('101201402', '湖北', '荆门', '钟祥');
INSERT INTO `city_info` VALUES ('101201403', '湖北', '荆门', '京山');
INSERT INTO `city_info` VALUES ('101201404', '湖北', '荆门', '掇刀');
INSERT INTO `city_info` VALUES ('101201405', '湖北', '荆门', '沙洋');
INSERT INTO `city_info` VALUES ('101201406', '湖北', '荆州', '沙市');
INSERT INTO `city_info` VALUES ('101201501', '湖北', '天门', '天门');
INSERT INTO `city_info` VALUES ('101201601', '湖北', '仙桃', '仙桃');
INSERT INTO `city_info` VALUES ('101201701', '湖北', '潜江', '潜江');
INSERT INTO `city_info` VALUES ('101210101', '浙江', '杭州', '杭州');
INSERT INTO `city_info` VALUES ('101210102', '浙江', '杭州', '萧山');
INSERT INTO `city_info` VALUES ('101210103', '浙江', '杭州', '桐庐');
INSERT INTO `city_info` VALUES ('101210104', '浙江', '杭州', '淳安');
INSERT INTO `city_info` VALUES ('101210105', '浙江', '杭州', '建德');
INSERT INTO `city_info` VALUES ('101210106', '浙江', '杭州', '余杭');
INSERT INTO `city_info` VALUES ('101210107', '浙江', '杭州', '临安');
INSERT INTO `city_info` VALUES ('101210108', '浙江', '杭州', '富阳');
INSERT INTO `city_info` VALUES ('101210201', '浙江', '湖州', '湖州');
INSERT INTO `city_info` VALUES ('101210202', '浙江', '湖州', '长兴');
INSERT INTO `city_info` VALUES ('101210203', '浙江', '湖州', '安吉');
INSERT INTO `city_info` VALUES ('101210204', '浙江', '湖州', '德清');
INSERT INTO `city_info` VALUES ('101210301', '浙江', '嘉兴', '嘉兴');
INSERT INTO `city_info` VALUES ('101210302', '浙江', '嘉兴', '嘉善');
INSERT INTO `city_info` VALUES ('101210303', '浙江', '嘉兴', '海宁');
INSERT INTO `city_info` VALUES ('101210304', '浙江', '嘉兴', '桐乡');
INSERT INTO `city_info` VALUES ('101210305', '浙江', '嘉兴', '平湖');
INSERT INTO `city_info` VALUES ('101210306', '浙江', '嘉兴', '海盐');
INSERT INTO `city_info` VALUES ('101210401', '浙江', '宁波', '宁波');
INSERT INTO `city_info` VALUES ('101210403', '浙江', '宁波', '慈溪');
INSERT INTO `city_info` VALUES ('101210404', '浙江', '宁波', '余姚');
INSERT INTO `city_info` VALUES ('101210405', '浙江', '宁波', '奉化');
INSERT INTO `city_info` VALUES ('101210406', '浙江', '宁波', '象山');
INSERT INTO `city_info` VALUES ('101210408', '浙江', '宁波', '宁海');
INSERT INTO `city_info` VALUES ('101210410', '浙江', '宁波', '北仑');
INSERT INTO `city_info` VALUES ('101210411', '浙江', '宁波', '鄞州');
INSERT INTO `city_info` VALUES ('101210412', '浙江', '宁波', '镇海');
INSERT INTO `city_info` VALUES ('101210501', '浙江', '绍兴', '绍兴');
INSERT INTO `city_info` VALUES ('101210502', '浙江', '绍兴', '诸暨');
INSERT INTO `city_info` VALUES ('101210503', '浙江', '绍兴', '上虞');
INSERT INTO `city_info` VALUES ('101210504', '浙江', '绍兴', '新昌');
INSERT INTO `city_info` VALUES ('101210505', '浙江', '绍兴', '嵊州');
INSERT INTO `city_info` VALUES ('101210601', '浙江', '台州', '台州');
INSERT INTO `city_info` VALUES ('101210603', '浙江', '台州', '玉环');
INSERT INTO `city_info` VALUES ('101210604', '浙江', '台州', '三门');
INSERT INTO `city_info` VALUES ('101210605', '浙江', '台州', '天台');
INSERT INTO `city_info` VALUES ('101210606', '浙江', '台州', '仙居');
INSERT INTO `city_info` VALUES ('101210607', '浙江', '台州', '温岭');
INSERT INTO `city_info` VALUES ('101210609', '浙江', '台州', '洪家');
INSERT INTO `city_info` VALUES ('101210610', '浙江', '台州', '临海');
INSERT INTO `city_info` VALUES ('101210611', '浙江', '台州', '椒江');
INSERT INTO `city_info` VALUES ('101210612', '浙江', '台州', '黄岩');
INSERT INTO `city_info` VALUES ('101210613', '浙江', '台州', '路桥');
INSERT INTO `city_info` VALUES ('101210701', '浙江', '温州', '温州');
INSERT INTO `city_info` VALUES ('101210702', '浙江', '温州', '泰顺');
INSERT INTO `city_info` VALUES ('101210703', '浙江', '温州', '文成');
INSERT INTO `city_info` VALUES ('101210704', '浙江', '温州', '平阳');
INSERT INTO `city_info` VALUES ('101210705', '浙江', '温州', '瑞安');
INSERT INTO `city_info` VALUES ('101210706', '浙江', '温州', '洞头');
INSERT INTO `city_info` VALUES ('101210707', '浙江', '温州', '乐清');
INSERT INTO `city_info` VALUES ('101210708', '浙江', '温州', '永嘉');
INSERT INTO `city_info` VALUES ('101210709', '浙江', '温州', '苍南');
INSERT INTO `city_info` VALUES ('101210801', '浙江', '丽水', '丽水');
INSERT INTO `city_info` VALUES ('101210802', '浙江', '丽水', '遂昌');
INSERT INTO `city_info` VALUES ('101210803', '浙江', '丽水', '龙泉');
INSERT INTO `city_info` VALUES ('101210804', '浙江', '丽水', '缙云');
INSERT INTO `city_info` VALUES ('101210805', '浙江', '丽水', '青田');
INSERT INTO `city_info` VALUES ('101210806', '浙江', '丽水', '云和');
INSERT INTO `city_info` VALUES ('101210807', '浙江', '丽水', '庆元');
INSERT INTO `city_info` VALUES ('101210808', '浙江', '丽水', '松阳');
INSERT INTO `city_info` VALUES ('101210809', '浙江', '丽水', '景宁');
INSERT INTO `city_info` VALUES ('101210901', '浙江', '金华', '金华');
INSERT INTO `city_info` VALUES ('101210902', '浙江', '金华', '浦江');
INSERT INTO `city_info` VALUES ('101210903', '浙江', '金华', '兰溪');
INSERT INTO `city_info` VALUES ('101210904', '浙江', '金华', '义乌');
INSERT INTO `city_info` VALUES ('101210905', '浙江', '金华', '东阳');
INSERT INTO `city_info` VALUES ('101210906', '浙江', '金华', '武义');
INSERT INTO `city_info` VALUES ('101210907', '浙江', '金华', '永康');
INSERT INTO `city_info` VALUES ('101210908', '浙江', '金华', '磐安');
INSERT INTO `city_info` VALUES ('101211001', '浙江', '衢州', '衢州');
INSERT INTO `city_info` VALUES ('101211002', '浙江', '衢州', '常山');
INSERT INTO `city_info` VALUES ('101211003', '浙江', '衢州', '开化');
INSERT INTO `city_info` VALUES ('101211004', '浙江', '衢州', '龙游');
INSERT INTO `city_info` VALUES ('101211005', '浙江', '衢州', '江山');
INSERT INTO `city_info` VALUES ('101211006', '浙江', '衢州', '衢江');
INSERT INTO `city_info` VALUES ('101211101', '浙江', '舟山', '舟山');
INSERT INTO `city_info` VALUES ('101211102', '浙江', '舟山', '嵊泗');
INSERT INTO `city_info` VALUES ('101211104', '浙江', '舟山', '岱山');
INSERT INTO `city_info` VALUES ('101211105', '浙江', '舟山', '普陀');
INSERT INTO `city_info` VALUES ('101211106', '浙江', '舟山', '定海');
INSERT INTO `city_info` VALUES ('101220101', '安徽', '合肥', '合肥');
INSERT INTO `city_info` VALUES ('101220102', '安徽', '合肥', '长丰');
INSERT INTO `city_info` VALUES ('101220103', '安徽', '合肥', '肥东');
INSERT INTO `city_info` VALUES ('101220104', '安徽', '合肥', '肥西');
INSERT INTO `city_info` VALUES ('101220201', '安徽', '蚌埠', '蚌埠');
INSERT INTO `city_info` VALUES ('101220202', '安徽', '蚌埠', '怀远');
INSERT INTO `city_info` VALUES ('101220203', '安徽', '蚌埠', '固镇');
INSERT INTO `city_info` VALUES ('101220204', '安徽', '蚌埠', '五河');
INSERT INTO `city_info` VALUES ('101220301', '安徽', '芜湖', '芜湖');
INSERT INTO `city_info` VALUES ('101220302', '安徽', '芜湖', '繁昌');
INSERT INTO `city_info` VALUES ('101220303', '安徽', '芜湖', '芜湖县');
INSERT INTO `city_info` VALUES ('101220304', '安徽', '芜湖', '南陵');
INSERT INTO `city_info` VALUES ('101220401', '安徽', '淮南', '淮南');
INSERT INTO `city_info` VALUES ('101220402', '安徽', '淮南', '凤台');
INSERT INTO `city_info` VALUES ('101220403', '安徽', '淮南', '潘集');
INSERT INTO `city_info` VALUES ('101220501', '安徽', '马鞍山', '马鞍山');
INSERT INTO `city_info` VALUES ('101220502', '安徽', '马鞍山', '当涂');
INSERT INTO `city_info` VALUES ('101220601', '安徽', '安庆', '安庆');
INSERT INTO `city_info` VALUES ('101220602', '安徽', '安庆', '枞阳');
INSERT INTO `city_info` VALUES ('101220603', '安徽', '安庆', '太湖');
INSERT INTO `city_info` VALUES ('101220604', '安徽', '安庆', '潜山');
INSERT INTO `city_info` VALUES ('101220605', '安徽', '安庆', '怀宁');
INSERT INTO `city_info` VALUES ('101220606', '安徽', '安庆', '宿松');
INSERT INTO `city_info` VALUES ('101220607', '安徽', '安庆', '望江');
INSERT INTO `city_info` VALUES ('101220608', '安徽', '安庆', '岳西');
INSERT INTO `city_info` VALUES ('101220609', '安徽', '安庆', '桐城');
INSERT INTO `city_info` VALUES ('101220701', '安徽', '宿州', '宿州');
INSERT INTO `city_info` VALUES ('101220702', '安徽', '宿州', '砀山');
INSERT INTO `city_info` VALUES ('101220703', '安徽', '宿州', '灵璧');
INSERT INTO `city_info` VALUES ('101220704', '安徽', '宿州', '泗县');
INSERT INTO `city_info` VALUES ('101220705', '安徽', '宿州', '萧县');
INSERT INTO `city_info` VALUES ('101220801', '安徽', '阜阳', '阜阳');
INSERT INTO `city_info` VALUES ('101220802', '安徽', '阜阳', '阜南');
INSERT INTO `city_info` VALUES ('101220803', '安徽', '阜阳', '颍上');
INSERT INTO `city_info` VALUES ('101220804', '安徽', '阜阳', '临泉');
INSERT INTO `city_info` VALUES ('101220805', '安徽', '阜阳', '界首');
INSERT INTO `city_info` VALUES ('101220806', '安徽', '阜阳', '太和');
INSERT INTO `city_info` VALUES ('101220901', '安徽', '亳州', '亳州');
INSERT INTO `city_info` VALUES ('101220902', '安徽', '亳州', '涡阳');
INSERT INTO `city_info` VALUES ('101220903', '安徽', '亳州', '利辛');
INSERT INTO `city_info` VALUES ('101220904', '安徽', '亳州', '蒙城');
INSERT INTO `city_info` VALUES ('101221001', '安徽', '黄山', '黄山市');
INSERT INTO `city_info` VALUES ('101221002', '安徽', '黄山', '黄山区');
INSERT INTO `city_info` VALUES ('101221003', '安徽', '黄山', '屯溪');
INSERT INTO `city_info` VALUES ('101221004', '安徽', '黄山', '祁门');
INSERT INTO `city_info` VALUES ('101221005', '安徽', '黄山', '黟县');
INSERT INTO `city_info` VALUES ('101221006', '安徽', '黄山', '歙县');
INSERT INTO `city_info` VALUES ('101221007', '安徽', '黄山', '休宁');
INSERT INTO `city_info` VALUES ('101221008', '安徽', '黄山', '黄山风景区');
INSERT INTO `city_info` VALUES ('101221101', '安徽', '滁州', '滁州');
INSERT INTO `city_info` VALUES ('101221102', '安徽', '滁州', '凤阳');
INSERT INTO `city_info` VALUES ('101221103', '安徽', '滁州', '明光');
INSERT INTO `city_info` VALUES ('101221104', '安徽', '滁州', '定远');
INSERT INTO `city_info` VALUES ('101221105', '安徽', '滁州', '全椒');
INSERT INTO `city_info` VALUES ('101221106', '安徽', '滁州', '来安');
INSERT INTO `city_info` VALUES ('101221107', '安徽', '滁州', '天长');
INSERT INTO `city_info` VALUES ('101221201', '安徽', '淮北', '淮北');
INSERT INTO `city_info` VALUES ('101221202', '安徽', '淮北', '濉溪');
INSERT INTO `city_info` VALUES ('101221301', '安徽', '铜陵', '铜陵');
INSERT INTO `city_info` VALUES ('101221401', '安徽', '宣城', '宣城');
INSERT INTO `city_info` VALUES ('101221402', '安徽', '宣城', '泾县');
INSERT INTO `city_info` VALUES ('101221403', '安徽', '宣城', '旌德');
INSERT INTO `city_info` VALUES ('101221404', '安徽', '宣城', '宁国');
INSERT INTO `city_info` VALUES ('101221405', '安徽', '宣城', '绩溪');
INSERT INTO `city_info` VALUES ('101221406', '安徽', '宣城', '广德');
INSERT INTO `city_info` VALUES ('101221407', '安徽', '宣城', '郎溪');
INSERT INTO `city_info` VALUES ('101221501', '安徽', '六安', '六安');
INSERT INTO `city_info` VALUES ('101221502', '安徽', '六安', '霍邱');
INSERT INTO `city_info` VALUES ('101221503', '安徽', '六安', '寿县');
INSERT INTO `city_info` VALUES ('101221505', '安徽', '六安', '金寨');
INSERT INTO `city_info` VALUES ('101221506', '安徽', '六安', '霍山');
INSERT INTO `city_info` VALUES ('101221507', '安徽', '六安', '舒城');
INSERT INTO `city_info` VALUES ('101221601', '安徽', '巢湖', '巢湖');
INSERT INTO `city_info` VALUES ('101221602', '安徽', '巢湖', '庐江');
INSERT INTO `city_info` VALUES ('101221603', '安徽', '巢湖', '无为');
INSERT INTO `city_info` VALUES ('101221604', '安徽', '巢湖', '含山');
INSERT INTO `city_info` VALUES ('101221605', '安徽', '巢湖', '和县');
INSERT INTO `city_info` VALUES ('101221701', '安徽', '池州', '池州');
INSERT INTO `city_info` VALUES ('101221702', '安徽', '池州', '东至');
INSERT INTO `city_info` VALUES ('101221703', '安徽', '池州', '青阳');
INSERT INTO `city_info` VALUES ('101221704', '安徽', '池州', '九华山');
INSERT INTO `city_info` VALUES ('101221705', '安徽', '池州', '石台');
INSERT INTO `city_info` VALUES ('101230101', '福建', '福州', '福州');
INSERT INTO `city_info` VALUES ('101230102', '福建', '福州', '闽清');
INSERT INTO `city_info` VALUES ('101230103', '福建', '福州', '闽侯');
INSERT INTO `city_info` VALUES ('101230104', '福建', '福州', '罗源');
INSERT INTO `city_info` VALUES ('101230105', '福建', '福州', '连江');
INSERT INTO `city_info` VALUES ('101230107', '福建', '福州', '永泰');
INSERT INTO `city_info` VALUES ('101230108', '福建', '福州', '平潭');
INSERT INTO `city_info` VALUES ('101230110', '福建', '福州', '长乐');
INSERT INTO `city_info` VALUES ('101230111', '福建', '福州', '福清');
INSERT INTO `city_info` VALUES ('101230201', '福建', '厦门', '厦门');
INSERT INTO `city_info` VALUES ('101230202', '福建', '厦门', '同安');
INSERT INTO `city_info` VALUES ('101230301', '福建', '宁德', '宁德');
INSERT INTO `city_info` VALUES ('101230302', '福建', '宁德', '古田');
INSERT INTO `city_info` VALUES ('101230303', '福建', '宁德', '霞浦');
INSERT INTO `city_info` VALUES ('101230304', '福建', '宁德', '寿宁');
INSERT INTO `city_info` VALUES ('101230305', '福建', '宁德', '周宁');
INSERT INTO `city_info` VALUES ('101230306', '福建', '宁德', '福安');
INSERT INTO `city_info` VALUES ('101230307', '福建', '宁德', '柘荣');
INSERT INTO `city_info` VALUES ('101230308', '福建', '宁德', '福鼎');
INSERT INTO `city_info` VALUES ('101230309', '福建', '宁德', '屏南');
INSERT INTO `city_info` VALUES ('101230401', '福建', '莆田', '莆田');
INSERT INTO `city_info` VALUES ('101230402', '福建', '莆田', '仙游');
INSERT INTO `city_info` VALUES ('101230403', '福建', '莆田', '秀屿港');
INSERT INTO `city_info` VALUES ('101230404', '福建', '莆田', '涵江');
INSERT INTO `city_info` VALUES ('101230405', '福建', '莆田', '秀屿');
INSERT INTO `city_info` VALUES ('101230406', '福建', '莆田', '荔城');
INSERT INTO `city_info` VALUES ('101230407', '福建', '莆田', '城厢');
INSERT INTO `city_info` VALUES ('101230501', '福建', '泉州', '泉州');
INSERT INTO `city_info` VALUES ('101230502', '福建', '泉州', '安溪');
INSERT INTO `city_info` VALUES ('101230504', '福建', '泉州', '永春');
INSERT INTO `city_info` VALUES ('101230505', '福建', '泉州', '德化');
INSERT INTO `city_info` VALUES ('101230506', '福建', '泉州', '南安');
INSERT INTO `city_info` VALUES ('101230507', '福建', '泉州', '崇武');
INSERT INTO `city_info` VALUES ('101230508', '福建', '泉州', '惠安');
INSERT INTO `city_info` VALUES ('101230509', '福建', '泉州', '晋江');
INSERT INTO `city_info` VALUES ('101230510', '福建', '泉州', '石狮');
INSERT INTO `city_info` VALUES ('101230601', '福建', '漳州', '漳州');
INSERT INTO `city_info` VALUES ('101230602', '福建', '漳州', '长泰');
INSERT INTO `city_info` VALUES ('101230603', '福建', '漳州', '南靖');
INSERT INTO `city_info` VALUES ('101230604', '福建', '漳州', '平和');
INSERT INTO `city_info` VALUES ('101230605', '福建', '漳州', '龙海');
INSERT INTO `city_info` VALUES ('101230606', '福建', '漳州', '漳浦');
INSERT INTO `city_info` VALUES ('101230607', '福建', '漳州', '诏安');
INSERT INTO `city_info` VALUES ('101230608', '福建', '漳州', '东山');
INSERT INTO `city_info` VALUES ('101230609', '福建', '漳州', '云霄');
INSERT INTO `city_info` VALUES ('101230610', '福建', '漳州', '华安');
INSERT INTO `city_info` VALUES ('101230701', '福建', '龙岩', '龙岩');
INSERT INTO `city_info` VALUES ('101230702', '福建', '龙岩', '长汀');
INSERT INTO `city_info` VALUES ('101230703', '福建', '龙岩', '连城');
INSERT INTO `city_info` VALUES ('101230704', '福建', '龙岩', '武平');
INSERT INTO `city_info` VALUES ('101230705', '福建', '龙岩', '上杭');
INSERT INTO `city_info` VALUES ('101230706', '福建', '龙岩', '永定');
INSERT INTO `city_info` VALUES ('101230707', '福建', '龙岩', '漳平');
INSERT INTO `city_info` VALUES ('101230801', '福建', '三明', '三明');
INSERT INTO `city_info` VALUES ('101230802', '福建', '三明', '宁化');
INSERT INTO `city_info` VALUES ('101230803', '福建', '三明', '清流');
INSERT INTO `city_info` VALUES ('101230804', '福建', '三明', '泰宁');
INSERT INTO `city_info` VALUES ('101230805', '福建', '三明', '将乐');
INSERT INTO `city_info` VALUES ('101230806', '福建', '三明', '建宁');
INSERT INTO `city_info` VALUES ('101230807', '福建', '三明', '明溪');
INSERT INTO `city_info` VALUES ('101230808', '福建', '三明', '沙县');
INSERT INTO `city_info` VALUES ('101230809', '福建', '三明', '尤溪');
INSERT INTO `city_info` VALUES ('101230810', '福建', '三明', '永安');
INSERT INTO `city_info` VALUES ('101230811', '福建', '三明', '大田');
INSERT INTO `city_info` VALUES ('101230901', '福建', '南平', '南平');
INSERT INTO `city_info` VALUES ('101230902', '福建', '南平', '顺昌');
INSERT INTO `city_info` VALUES ('101230903', '福建', '南平', '光泽');
INSERT INTO `city_info` VALUES ('101230904', '福建', '南平', '邵武');
INSERT INTO `city_info` VALUES ('101230905', '福建', '南平', '武夷山');
INSERT INTO `city_info` VALUES ('101230906', '福建', '南平', '浦城');
INSERT INTO `city_info` VALUES ('101230907', '福建', '南平', '建阳');
INSERT INTO `city_info` VALUES ('101230908', '福建', '南平', '松溪');
INSERT INTO `city_info` VALUES ('101230909', '福建', '南平', '政和');
INSERT INTO `city_info` VALUES ('101230910', '福建', '南平', '建瓯');
INSERT INTO `city_info` VALUES ('101240101', '江西', '南昌', '南昌');
INSERT INTO `city_info` VALUES ('101240102', '江西', '南昌', '新建');
INSERT INTO `city_info` VALUES ('101240103', '江西', '南昌', '南昌县');
INSERT INTO `city_info` VALUES ('101240104', '江西', '南昌', '安义');
INSERT INTO `city_info` VALUES ('101240105', '江西', '南昌', '进贤');
INSERT INTO `city_info` VALUES ('101240201', '江西', '九江', '九江');
INSERT INTO `city_info` VALUES ('101240202', '江西', '九江', '瑞昌');
INSERT INTO `city_info` VALUES ('101240203', '江西', '九江', '庐山');
INSERT INTO `city_info` VALUES ('101240204', '江西', '九江', '武宁');
INSERT INTO `city_info` VALUES ('101240205', '江西', '九江', '德安');
INSERT INTO `city_info` VALUES ('101240206', '江西', '九江', '永修');
INSERT INTO `city_info` VALUES ('101240207', '江西', '九江', '湖口');
INSERT INTO `city_info` VALUES ('101240208', '江西', '九江', '彭泽');
INSERT INTO `city_info` VALUES ('101240209', '江西', '九江', '星子');
INSERT INTO `city_info` VALUES ('101240210', '江西', '九江', '都昌');
INSERT INTO `city_info` VALUES ('101240212', '江西', '九江', '修水');
INSERT INTO `city_info` VALUES ('101240301', '江西', '上饶', '上饶');
INSERT INTO `city_info` VALUES ('101240302', '江西', '上饶', '鄱阳');
INSERT INTO `city_info` VALUES ('101240303', '江西', '上饶', '婺源');
INSERT INTO `city_info` VALUES ('101240305', '江西', '上饶', '余干');
INSERT INTO `city_info` VALUES ('101240306', '江西', '上饶', '万年');
INSERT INTO `city_info` VALUES ('101240307', '江西', '上饶', '德兴');
INSERT INTO `city_info` VALUES ('101240308', '江西', '上饶', '上饶县');
INSERT INTO `city_info` VALUES ('101240309', '江西', '上饶', '弋阳');
INSERT INTO `city_info` VALUES ('101240310', '江西', '上饶', '横峰');
INSERT INTO `city_info` VALUES ('101240311', '江西', '上饶', '铅山');
INSERT INTO `city_info` VALUES ('101240312', '江西', '上饶', '玉山');
INSERT INTO `city_info` VALUES ('101240313', '江西', '上饶', '广丰');
INSERT INTO `city_info` VALUES ('101240401', '江西', '抚州', '抚州');
INSERT INTO `city_info` VALUES ('101240402', '江西', '抚州', '广昌');
INSERT INTO `city_info` VALUES ('101240403', '江西', '抚州', '乐安');
INSERT INTO `city_info` VALUES ('101240404', '江西', '抚州', '崇仁');
INSERT INTO `city_info` VALUES ('101240405', '江西', '抚州', '金溪');
INSERT INTO `city_info` VALUES ('101240406', '江西', '抚州', '资溪');
INSERT INTO `city_info` VALUES ('101240407', '江西', '抚州', '宜黄');
INSERT INTO `city_info` VALUES ('101240408', '江西', '抚州', '南城');
INSERT INTO `city_info` VALUES ('101240409', '江西', '抚州', '南丰');
INSERT INTO `city_info` VALUES ('101240410', '江西', '抚州', '黎川');
INSERT INTO `city_info` VALUES ('101240411', '江西', '抚州', '东乡');
INSERT INTO `city_info` VALUES ('101240501', '江西', '宜春', '宜春');
INSERT INTO `city_info` VALUES ('101240502', '江西', '宜春', '铜鼓');
INSERT INTO `city_info` VALUES ('101240503', '江西', '宜春', '宜丰');
INSERT INTO `city_info` VALUES ('101240504', '江西', '宜春', '万载');
INSERT INTO `city_info` VALUES ('101240505', '江西', '宜春', '上高');
INSERT INTO `city_info` VALUES ('101240506', '江西', '宜春', '靖安');
INSERT INTO `city_info` VALUES ('101240507', '江西', '宜春', '奉新');
INSERT INTO `city_info` VALUES ('101240508', '江西', '宜春', '高安');
INSERT INTO `city_info` VALUES ('101240509', '江西', '宜春', '樟树');
INSERT INTO `city_info` VALUES ('101240510', '江西', '宜春', '丰城');
INSERT INTO `city_info` VALUES ('101240601', '江西', '吉安', '吉安');
INSERT INTO `city_info` VALUES ('101240602', '江西', '吉安', '吉安县');
INSERT INTO `city_info` VALUES ('101240603', '江西', '吉安', '吉水');
INSERT INTO `city_info` VALUES ('101240604', '江西', '吉安', '新干');
INSERT INTO `city_info` VALUES ('101240605', '江西', '吉安', '峡江');
INSERT INTO `city_info` VALUES ('101240606', '江西', '吉安', '永丰');
INSERT INTO `city_info` VALUES ('101240607', '江西', '吉安', '永新');
INSERT INTO `city_info` VALUES ('101240608', '江西', '吉安', '井冈山');
INSERT INTO `city_info` VALUES ('101240609', '江西', '吉安', '万安');
INSERT INTO `city_info` VALUES ('101240610', '江西', '吉安', '遂川');
INSERT INTO `city_info` VALUES ('101240611', '江西', '吉安', '泰和');
INSERT INTO `city_info` VALUES ('101240612', '江西', '吉安', '安福');
INSERT INTO `city_info` VALUES ('101240613', '江西', '吉安', '宁冈');
INSERT INTO `city_info` VALUES ('101240701', '江西', '赣州', '赣州');
INSERT INTO `city_info` VALUES ('101240702', '江西', '赣州', '崇义');
INSERT INTO `city_info` VALUES ('101240703', '江西', '赣州', '上犹');
INSERT INTO `city_info` VALUES ('101240704', '江西', '赣州', '南康');
INSERT INTO `city_info` VALUES ('101240705', '江西', '赣州', '大余');
INSERT INTO `city_info` VALUES ('101240706', '江西', '赣州', '信丰');
INSERT INTO `city_info` VALUES ('101240707', '江西', '赣州', '宁都');
INSERT INTO `city_info` VALUES ('101240708', '江西', '赣州', '石城');
INSERT INTO `city_info` VALUES ('101240709', '江西', '赣州', '瑞金');
INSERT INTO `city_info` VALUES ('101240710', '江西', '赣州', '于都');
INSERT INTO `city_info` VALUES ('101240711', '江西', '赣州', '会昌');
INSERT INTO `city_info` VALUES ('101240712', '江西', '赣州', '安远');
INSERT INTO `city_info` VALUES ('101240713', '江西', '赣州', '全南');
INSERT INTO `city_info` VALUES ('101240714', '江西', '赣州', '龙南');
INSERT INTO `city_info` VALUES ('101240715', '江西', '赣州', '定南');
INSERT INTO `city_info` VALUES ('101240716', '江西', '赣州', '寻乌');
INSERT INTO `city_info` VALUES ('101240717', '江西', '赣州', '兴国');
INSERT INTO `city_info` VALUES ('101240718', '江西', '赣州', '赣县');
INSERT INTO `city_info` VALUES ('101240801', '江西', '景德镇', '景德镇');
INSERT INTO `city_info` VALUES ('101240802', '江西', '景德镇', '乐平');
INSERT INTO `city_info` VALUES ('101240803', '江西', '景德镇', '浮梁');
INSERT INTO `city_info` VALUES ('101240901', '江西', '萍乡', '萍乡');
INSERT INTO `city_info` VALUES ('101240902', '江西', '萍乡', '莲花');
INSERT INTO `city_info` VALUES ('101240903', '江西', '萍乡', '上栗');
INSERT INTO `city_info` VALUES ('101240904', '江西', '萍乡', '安源');
INSERT INTO `city_info` VALUES ('101240905', '江西', '萍乡', '芦溪');
INSERT INTO `city_info` VALUES ('101240906', '江西', '萍乡', '湘东');
INSERT INTO `city_info` VALUES ('101241001', '江西', '新余', '新余');
INSERT INTO `city_info` VALUES ('101241002', '江西', '新余', '分宜');
INSERT INTO `city_info` VALUES ('101241101', '江西', '鹰潭', '鹰潭');
INSERT INTO `city_info` VALUES ('101241102', '江西', '鹰潭', '余江');
INSERT INTO `city_info` VALUES ('101241103', '江西', '鹰潭', '贵溪');
INSERT INTO `city_info` VALUES ('101250101', '湖南', '长沙', '长沙');
INSERT INTO `city_info` VALUES ('101250102', '湖南', '长沙', '宁乡');
INSERT INTO `city_info` VALUES ('101250103', '湖南', '长沙', '浏阳');
INSERT INTO `city_info` VALUES ('101250104', '湖南', '长沙', '马坡岭');
INSERT INTO `city_info` VALUES ('101250105', '湖南', '长沙', '望城');
INSERT INTO `city_info` VALUES ('101250201', '湖南', '湘潭', '湘潭');
INSERT INTO `city_info` VALUES ('101250202', '湖南', '湘潭', '韶山');
INSERT INTO `city_info` VALUES ('101250203', '湖南', '湘潭', '湘乡');
INSERT INTO `city_info` VALUES ('101250301', '湖南', '株洲', '株洲');
INSERT INTO `city_info` VALUES ('101250302', '湖南', '株洲', '攸县');
INSERT INTO `city_info` VALUES ('101250303', '湖南', '株洲', '醴陵');
INSERT INTO `city_info` VALUES ('101250305', '湖南', '株洲', '茶陵');
INSERT INTO `city_info` VALUES ('101250306', '湖南', '株洲', '炎陵');
INSERT INTO `city_info` VALUES ('101250401', '湖南', '衡阳', '衡阳');
INSERT INTO `city_info` VALUES ('101250402', '湖南', '衡阳', '衡山');
INSERT INTO `city_info` VALUES ('101250403', '湖南', '衡阳', '衡东');
INSERT INTO `city_info` VALUES ('101250404', '湖南', '衡阳', '祁东');
INSERT INTO `city_info` VALUES ('101250405', '湖南', '衡阳', '衡阳县');
INSERT INTO `city_info` VALUES ('101250406', '湖南', '衡阳', '常宁');
INSERT INTO `city_info` VALUES ('101250407', '湖南', '衡阳', '衡南');
INSERT INTO `city_info` VALUES ('101250408', '湖南', '衡阳', '耒阳');
INSERT INTO `city_info` VALUES ('101250409', '湖南', '衡阳', '南岳');
INSERT INTO `city_info` VALUES ('101250501', '湖南', '郴州', '郴州');
INSERT INTO `city_info` VALUES ('101250502', '湖南', '郴州', '桂阳');
INSERT INTO `city_info` VALUES ('101250503', '湖南', '郴州', '嘉禾');
INSERT INTO `city_info` VALUES ('101250504', '湖南', '郴州', '宜章');
INSERT INTO `city_info` VALUES ('101250505', '湖南', '郴州', '临武');
INSERT INTO `city_info` VALUES ('101250507', '湖南', '郴州', '资兴');
INSERT INTO `city_info` VALUES ('101250508', '湖南', '郴州', '汝城');
INSERT INTO `city_info` VALUES ('101250509', '湖南', '郴州', '安仁');
INSERT INTO `city_info` VALUES ('101250510', '湖南', '郴州', '永兴');
INSERT INTO `city_info` VALUES ('101250511', '湖南', '郴州', '桂东');
INSERT INTO `city_info` VALUES ('101250512', '湖南', '郴州', '苏仙');
INSERT INTO `city_info` VALUES ('101250601', '湖南', '常德', '常德');
INSERT INTO `city_info` VALUES ('101250602', '湖南', '常德', '安乡');
INSERT INTO `city_info` VALUES ('101250603', '湖南', '常德', '桃源');
INSERT INTO `city_info` VALUES ('101250604', '湖南', '常德', '汉寿');
INSERT INTO `city_info` VALUES ('101250605', '湖南', '常德', '澧县');
INSERT INTO `city_info` VALUES ('101250606', '湖南', '常德', '临澧');
INSERT INTO `city_info` VALUES ('101250607', '湖南', '常德', '石门');
INSERT INTO `city_info` VALUES ('101250608', '湖南', '常德', '津市');
INSERT INTO `city_info` VALUES ('101250700', '湖南', '益阳', '益阳');
INSERT INTO `city_info` VALUES ('101250701', '湖南', '益阳', '赫山区');
INSERT INTO `city_info` VALUES ('101250702', '湖南', '益阳', '南县');
INSERT INTO `city_info` VALUES ('101250703', '湖南', '益阳', '桃江');
INSERT INTO `city_info` VALUES ('101250704', '湖南', '益阳', '安化');
INSERT INTO `city_info` VALUES ('101250705', '湖南', '益阳', '沅江');
INSERT INTO `city_info` VALUES ('101250801', '湖南', '娄底', '娄底');
INSERT INTO `city_info` VALUES ('101250802', '湖南', '娄底', '双峰');
INSERT INTO `city_info` VALUES ('101250803', '湖南', '娄底', '冷水江');
INSERT INTO `city_info` VALUES ('101250805', '湖南', '娄底', '新化');
INSERT INTO `city_info` VALUES ('101250806', '湖南', '娄底', '涟源');
INSERT INTO `city_info` VALUES ('101250901', '湖南', '邵阳', '邵阳');
INSERT INTO `city_info` VALUES ('101250902', '湖南', '邵阳', '隆回');
INSERT INTO `city_info` VALUES ('101250903', '湖南', '邵阳', '洞口');
INSERT INTO `city_info` VALUES ('101250904', '湖南', '邵阳', '新邵');
INSERT INTO `city_info` VALUES ('101250905', '湖南', '邵阳', '邵东');
INSERT INTO `city_info` VALUES ('101250906', '湖南', '邵阳', '绥宁');
INSERT INTO `city_info` VALUES ('101250907', '湖南', '邵阳', '新宁');
INSERT INTO `city_info` VALUES ('101250908', '湖南', '邵阳', '武冈');
INSERT INTO `city_info` VALUES ('101250909', '湖南', '邵阳', '城步');
INSERT INTO `city_info` VALUES ('101250910', '湖南', '邵阳', '邵阳县');
INSERT INTO `city_info` VALUES ('101251001', '湖南', '岳阳', '岳阳');
INSERT INTO `city_info` VALUES ('101251002', '湖南', '岳阳', '华容');
INSERT INTO `city_info` VALUES ('101251003', '湖南', '岳阳', '湘阴');
INSERT INTO `city_info` VALUES ('101251004', '湖南', '岳阳', '汨罗');
INSERT INTO `city_info` VALUES ('101251005', '湖南', '岳阳', '平江');
INSERT INTO `city_info` VALUES ('101251006', '湖南', '岳阳', '临湘');
INSERT INTO `city_info` VALUES ('101251101', '湖南', '张家界', '张家界');
INSERT INTO `city_info` VALUES ('101251102', '湖南', '张家界', '桑植');
INSERT INTO `city_info` VALUES ('101251103', '湖南', '张家界', '慈利');
INSERT INTO `city_info` VALUES ('101251104', '湖南', '张家界', '武陵源');
INSERT INTO `city_info` VALUES ('101251201', '湖南', '怀化', '怀化');
INSERT INTO `city_info` VALUES ('101251203', '湖南', '怀化', '沅陵');
INSERT INTO `city_info` VALUES ('101251204', '湖南', '怀化', '辰溪');
INSERT INTO `city_info` VALUES ('101251205', '湖南', '怀化', '靖州');
INSERT INTO `city_info` VALUES ('101251206', '湖南', '怀化', '会同');
INSERT INTO `city_info` VALUES ('101251207', '湖南', '怀化', '通道');
INSERT INTO `city_info` VALUES ('101251208', '湖南', '怀化', '麻阳');
INSERT INTO `city_info` VALUES ('101251209', '湖南', '怀化', '新晃');
INSERT INTO `city_info` VALUES ('101251210', '湖南', '怀化', '芷江');
INSERT INTO `city_info` VALUES ('101251211', '湖南', '怀化', '溆浦');
INSERT INTO `city_info` VALUES ('101251212', '湖南', '怀化', '中方');
INSERT INTO `city_info` VALUES ('101251213', '湖南', '怀化', '洪江');
INSERT INTO `city_info` VALUES ('101251401', '湖南', '永州', '永州');
INSERT INTO `city_info` VALUES ('101251402', '湖南', '永州', '祁阳');
INSERT INTO `city_info` VALUES ('101251403', '湖南', '永州', '东安');
INSERT INTO `city_info` VALUES ('101251404', '湖南', '永州', '双牌');
INSERT INTO `city_info` VALUES ('101251405', '湖南', '永州', '道县');
INSERT INTO `city_info` VALUES ('101251406', '湖南', '永州', '宁远');
INSERT INTO `city_info` VALUES ('101251407', '湖南', '永州', '江永');
INSERT INTO `city_info` VALUES ('101251408', '湖南', '永州', '蓝山');
INSERT INTO `city_info` VALUES ('101251409', '湖南', '永州', '新田');
INSERT INTO `city_info` VALUES ('101251410', '湖南', '永州', '江华');
INSERT INTO `city_info` VALUES ('101251411', '湖南', '永州', '冷水滩');
INSERT INTO `city_info` VALUES ('101251501', '湖南', '湘西', '吉首');
INSERT INTO `city_info` VALUES ('101251502', '湖南', '湘西', '保靖');
INSERT INTO `city_info` VALUES ('101251503', '湖南', '湘西', '永顺');
INSERT INTO `city_info` VALUES ('101251504', '湖南', '湘西', '古丈');
INSERT INTO `city_info` VALUES ('101251505', '湖南', '湘西', '凤凰');
INSERT INTO `city_info` VALUES ('101251506', '湖南', '湘西', '泸溪');
INSERT INTO `city_info` VALUES ('101251507', '湖南', '湘西', '龙山');
INSERT INTO `city_info` VALUES ('101251508', '湖南', '湘西', '花垣');
INSERT INTO `city_info` VALUES ('101260101', '贵州', '贵阳', '贵阳');
INSERT INTO `city_info` VALUES ('101260102', '贵州', '贵阳', '白云');
INSERT INTO `city_info` VALUES ('101260103', '贵州', '贵阳', '花溪');
INSERT INTO `city_info` VALUES ('101260104', '贵州', '贵阳', '乌当');
INSERT INTO `city_info` VALUES ('101260105', '贵州', '贵阳', '息烽');
INSERT INTO `city_info` VALUES ('101260106', '贵州', '贵阳', '开阳');
INSERT INTO `city_info` VALUES ('101260107', '贵州', '贵阳', '修文');
INSERT INTO `city_info` VALUES ('101260108', '贵州', '贵阳', '清镇');
INSERT INTO `city_info` VALUES ('101260109', '贵州', '贵阳', '小河');
INSERT INTO `city_info` VALUES ('101260110', '贵州', '贵阳', '云岩');
INSERT INTO `city_info` VALUES ('101260111', '贵州', '贵阳', '南明');
INSERT INTO `city_info` VALUES ('101260201', '贵州', '遵义', '遵义');
INSERT INTO `city_info` VALUES ('101260202', '贵州', '遵义', '遵义县');
INSERT INTO `city_info` VALUES ('101260203', '贵州', '遵义', '仁怀');
INSERT INTO `city_info` VALUES ('101260204', '贵州', '遵义', '绥阳');
INSERT INTO `city_info` VALUES ('101260205', '贵州', '遵义', '湄潭');
INSERT INTO `city_info` VALUES ('101260206', '贵州', '遵义', '凤冈');
INSERT INTO `city_info` VALUES ('101260207', '贵州', '遵义', '桐梓');
INSERT INTO `city_info` VALUES ('101260208', '贵州', '遵义', '赤水');
INSERT INTO `city_info` VALUES ('101260209', '贵州', '遵义', '习水');
INSERT INTO `city_info` VALUES ('101260210', '贵州', '遵义', '道真');
INSERT INTO `city_info` VALUES ('101260211', '贵州', '遵义', '正安');
INSERT INTO `city_info` VALUES ('101260212', '贵州', '遵义', '务川');
INSERT INTO `city_info` VALUES ('101260213', '贵州', '遵义', '余庆');
INSERT INTO `city_info` VALUES ('101260214', '贵州', '遵义', '汇川');
INSERT INTO `city_info` VALUES ('101260215', '贵州', '遵义', '红花岗');
INSERT INTO `city_info` VALUES ('101260301', '贵州', '安顺', '安顺');
INSERT INTO `city_info` VALUES ('101260302', '贵州', '安顺', '普定');
INSERT INTO `city_info` VALUES ('101260303', '贵州', '安顺', '镇宁');
INSERT INTO `city_info` VALUES ('101260304', '贵州', '安顺', '平坝');
INSERT INTO `city_info` VALUES ('101260305', '贵州', '安顺', '紫云');
INSERT INTO `city_info` VALUES ('101260306', '贵州', '安顺', '关岭');
INSERT INTO `city_info` VALUES ('101260401', '贵州', '黔南', '都匀');
INSERT INTO `city_info` VALUES ('101260402', '贵州', '黔南', '贵定');
INSERT INTO `city_info` VALUES ('101260403', '贵州', '黔南', '瓮安');
INSERT INTO `city_info` VALUES ('101260404', '贵州', '黔南', '长顺');
INSERT INTO `city_info` VALUES ('101260405', '贵州', '黔南', '福泉');
INSERT INTO `city_info` VALUES ('101260406', '贵州', '黔南', '惠水');
INSERT INTO `city_info` VALUES ('101260407', '贵州', '黔南', '龙里');
INSERT INTO `city_info` VALUES ('101260408', '贵州', '黔南', '罗甸');
INSERT INTO `city_info` VALUES ('101260409', '贵州', '黔南', '平塘');
INSERT INTO `city_info` VALUES ('101260410', '贵州', '黔南', '独山');
INSERT INTO `city_info` VALUES ('101260411', '贵州', '黔南', '三都');
INSERT INTO `city_info` VALUES ('101260412', '贵州', '黔南', '荔波');
INSERT INTO `city_info` VALUES ('101260501', '贵州', '黔东南', '凯里');
INSERT INTO `city_info` VALUES ('101260502', '贵州', '黔东南', '岑巩');
INSERT INTO `city_info` VALUES ('101260503', '贵州', '黔东南', '施秉');
INSERT INTO `city_info` VALUES ('101260504', '贵州', '黔东南', '镇远');
INSERT INTO `city_info` VALUES ('101260505', '贵州', '黔东南', '黄平');
INSERT INTO `city_info` VALUES ('101260507', '贵州', '黔东南', '麻江');
INSERT INTO `city_info` VALUES ('101260508', '贵州', '黔东南', '丹寨');
INSERT INTO `city_info` VALUES ('101260509', '贵州', '黔东南', '三穗');
INSERT INTO `city_info` VALUES ('101260510', '贵州', '黔东南', '台江');
INSERT INTO `city_info` VALUES ('101260511', '贵州', '黔东南', '剑河');
INSERT INTO `city_info` VALUES ('101260512', '贵州', '黔东南', '雷山');
INSERT INTO `city_info` VALUES ('101260513', '贵州', '黔东南', '黎平');
INSERT INTO `city_info` VALUES ('101260514', '贵州', '黔东南', '天柱');
INSERT INTO `city_info` VALUES ('101260515', '贵州', '黔东南', '锦屏');
INSERT INTO `city_info` VALUES ('101260516', '贵州', '黔东南', '榕江');
INSERT INTO `city_info` VALUES ('101260517', '贵州', '黔东南', '从江');
INSERT INTO `city_info` VALUES ('101260601', '贵州', '铜仁', '铜仁');
INSERT INTO `city_info` VALUES ('101260602', '贵州', '铜仁', '江口');
INSERT INTO `city_info` VALUES ('101260603', '贵州', '铜仁', '玉屏');
INSERT INTO `city_info` VALUES ('101260604', '贵州', '铜仁', '万山');
INSERT INTO `city_info` VALUES ('101260605', '贵州', '铜仁', '思南');
INSERT INTO `city_info` VALUES ('101260607', '贵州', '铜仁', '印江');
INSERT INTO `city_info` VALUES ('101260608', '贵州', '铜仁', '石阡');
INSERT INTO `city_info` VALUES ('101260609', '贵州', '铜仁', '沿河');
INSERT INTO `city_info` VALUES ('101260610', '贵州', '铜仁', '德江');
INSERT INTO `city_info` VALUES ('101260611', '贵州', '铜仁', '松桃');
INSERT INTO `city_info` VALUES ('101260701', '贵州', '毕节', '毕节');
INSERT INTO `city_info` VALUES ('101260702', '贵州', '毕节', '赫章');
INSERT INTO `city_info` VALUES ('101260703', '贵州', '毕节', '金沙');
INSERT INTO `city_info` VALUES ('101260704', '贵州', '毕节', '威宁');
INSERT INTO `city_info` VALUES ('101260705', '贵州', '毕节', '大方');
INSERT INTO `city_info` VALUES ('101260706', '贵州', '毕节', '纳雍');
INSERT INTO `city_info` VALUES ('101260707', '贵州', '毕节', '织金');
INSERT INTO `city_info` VALUES ('101260708', '贵州', '毕节', '黔西');
INSERT INTO `city_info` VALUES ('101260801', '贵州', '六盘水', '水城');
INSERT INTO `city_info` VALUES ('101260802', '贵州', '六盘水', '六枝');
INSERT INTO `city_info` VALUES ('101260804', '贵州', '六盘水', '盘县');
INSERT INTO `city_info` VALUES ('101260901', '贵州', '黔西南', '兴义');
INSERT INTO `city_info` VALUES ('101260902', '贵州', '黔西南', '晴隆');
INSERT INTO `city_info` VALUES ('101260903', '贵州', '黔西南', '兴仁');
INSERT INTO `city_info` VALUES ('101260904', '贵州', '黔西南', '贞丰');
INSERT INTO `city_info` VALUES ('101260905', '贵州', '黔西南', '望谟');
INSERT INTO `city_info` VALUES ('101260907', '贵州', '黔西南', '安龙');
INSERT INTO `city_info` VALUES ('101260908', '贵州', '黔西南', '册亨');
INSERT INTO `city_info` VALUES ('101260909', '贵州', '黔西南', '普安');
INSERT INTO `city_info` VALUES ('101270101', '四川', '成都', '成都');
INSERT INTO `city_info` VALUES ('101270102', '四川', '成都', '龙泉驿');
INSERT INTO `city_info` VALUES ('101270103', '四川', '成都', '新都');
INSERT INTO `city_info` VALUES ('101270104', '四川', '成都', '温江');
INSERT INTO `city_info` VALUES ('101270105', '四川', '成都', '金堂');
INSERT INTO `city_info` VALUES ('101270106', '四川', '成都', '双流');
INSERT INTO `city_info` VALUES ('101270107', '四川', '成都', '郫县');
INSERT INTO `city_info` VALUES ('101270108', '四川', '成都', '大邑');
INSERT INTO `city_info` VALUES ('101270109', '四川', '成都', '蒲江');
INSERT INTO `city_info` VALUES ('101270110', '四川', '成都', '新津');
INSERT INTO `city_info` VALUES ('101270111', '四川', '成都', '都江堰');
INSERT INTO `city_info` VALUES ('101270112', '四川', '成都', '彭州');
INSERT INTO `city_info` VALUES ('101270113', '四川', '成都', '邛崃');
INSERT INTO `city_info` VALUES ('101270114', '四川', '成都', '崇州');
INSERT INTO `city_info` VALUES ('101270201', '四川', '攀枝花', '攀枝花');
INSERT INTO `city_info` VALUES ('101270202', '四川', '攀枝花', '仁和');
INSERT INTO `city_info` VALUES ('101270203', '四川', '攀枝花', '米易');
INSERT INTO `city_info` VALUES ('101270204', '四川', '攀枝花', '盐边');
INSERT INTO `city_info` VALUES ('101270301', '四川', '自贡', '自贡');
INSERT INTO `city_info` VALUES ('101270302', '四川', '自贡', '富顺');
INSERT INTO `city_info` VALUES ('101270303', '四川', '自贡', '荣县');
INSERT INTO `city_info` VALUES ('101270401', '四川', '绵阳', '绵阳');
INSERT INTO `city_info` VALUES ('101270402', '四川', '绵阳', '三台');
INSERT INTO `city_info` VALUES ('101270403', '四川', '绵阳', '盐亭');
INSERT INTO `city_info` VALUES ('101270404', '四川', '绵阳', '安县');
INSERT INTO `city_info` VALUES ('101270405', '四川', '绵阳', '梓潼');
INSERT INTO `city_info` VALUES ('101270406', '四川', '绵阳', '北川');
INSERT INTO `city_info` VALUES ('101270407', '四川', '绵阳', '平武');
INSERT INTO `city_info` VALUES ('101270408', '四川', '绵阳', '江油');
INSERT INTO `city_info` VALUES ('101270501', '四川', '南充', '南充');
INSERT INTO `city_info` VALUES ('101270502', '四川', '南充', '南部');
INSERT INTO `city_info` VALUES ('101270503', '四川', '南充', '营山');
INSERT INTO `city_info` VALUES ('101270504', '四川', '南充', '蓬安');
INSERT INTO `city_info` VALUES ('101270505', '四川', '南充', '仪陇');
INSERT INTO `city_info` VALUES ('101270506', '四川', '南充', '西充');
INSERT INTO `city_info` VALUES ('101270507', '四川', '南充', '阆中');
INSERT INTO `city_info` VALUES ('101270601', '四川', '达州', '达州');
INSERT INTO `city_info` VALUES ('101270602', '四川', '达州', '宣汉');
INSERT INTO `city_info` VALUES ('101270603', '四川', '达州', '开江');
INSERT INTO `city_info` VALUES ('101270604', '四川', '达州', '大竹');
INSERT INTO `city_info` VALUES ('101270605', '四川', '达州', '渠县');
INSERT INTO `city_info` VALUES ('101270606', '四川', '达州', '万源');
INSERT INTO `city_info` VALUES ('101270607', '四川', '达州', '通川');
INSERT INTO `city_info` VALUES ('101270608', '四川', '达州', '达县');
INSERT INTO `city_info` VALUES ('101270701', '四川', '遂宁', '遂宁');
INSERT INTO `city_info` VALUES ('101270702', '四川', '遂宁', '蓬溪');
INSERT INTO `city_info` VALUES ('101270703', '四川', '遂宁', '射洪');
INSERT INTO `city_info` VALUES ('101270801', '四川', '广安', '广安');
INSERT INTO `city_info` VALUES ('101270802', '四川', '广安', '岳池');
INSERT INTO `city_info` VALUES ('101270803', '四川', '广安', '武胜');
INSERT INTO `city_info` VALUES ('101270804', '四川', '广安', '邻水');
INSERT INTO `city_info` VALUES ('101270805', '四川', '广安', '华蓥');
INSERT INTO `city_info` VALUES ('101270901', '四川', '巴中', '巴中');
INSERT INTO `city_info` VALUES ('101270902', '四川', '巴中', '通江');
INSERT INTO `city_info` VALUES ('101270903', '四川', '巴中', '南江');
INSERT INTO `city_info` VALUES ('101270904', '四川', '巴中', '平昌');
INSERT INTO `city_info` VALUES ('101271001', '四川', '泸州', '泸州');
INSERT INTO `city_info` VALUES ('101271003', '四川', '泸州', '泸县');
INSERT INTO `city_info` VALUES ('101271004', '四川', '泸州', '合江');
INSERT INTO `city_info` VALUES ('101271005', '四川', '泸州', '叙永');
INSERT INTO `city_info` VALUES ('101271006', '四川', '泸州', '古蔺');
INSERT INTO `city_info` VALUES ('101271007', '四川', '泸州', '纳溪');
INSERT INTO `city_info` VALUES ('101271101', '四川', '宜宾', '宜宾');
INSERT INTO `city_info` VALUES ('101271103', '四川', '宜宾', '宜宾县');
INSERT INTO `city_info` VALUES ('101271104', '四川', '宜宾', '南溪');
INSERT INTO `city_info` VALUES ('101271105', '四川', '宜宾', '江安');
INSERT INTO `city_info` VALUES ('101271106', '四川', '宜宾', '长宁');
INSERT INTO `city_info` VALUES ('101271107', '四川', '宜宾', '高县');
INSERT INTO `city_info` VALUES ('101271108', '四川', '宜宾', '珙县');
INSERT INTO `city_info` VALUES ('101271109', '四川', '宜宾', '筠连');
INSERT INTO `city_info` VALUES ('101271110', '四川', '宜宾', '兴文');
INSERT INTO `city_info` VALUES ('101271111', '四川', '宜宾', '屏山');
INSERT INTO `city_info` VALUES ('101271201', '四川', '内江', '内江');
INSERT INTO `city_info` VALUES ('101271202', '四川', '内江', '东兴');
INSERT INTO `city_info` VALUES ('101271203', '四川', '内江', '威远');
INSERT INTO `city_info` VALUES ('101271204', '四川', '内江', '资中');
INSERT INTO `city_info` VALUES ('101271205', '四川', '内江', '隆昌');
INSERT INTO `city_info` VALUES ('101271301', '四川', '资阳', '资阳');
INSERT INTO `city_info` VALUES ('101271302', '四川', '资阳', '安岳');
INSERT INTO `city_info` VALUES ('101271303', '四川', '资阳', '乐至');
INSERT INTO `city_info` VALUES ('101271304', '四川', '资阳', '简阳');
INSERT INTO `city_info` VALUES ('101271401', '四川', '乐山', '乐山');
INSERT INTO `city_info` VALUES ('101271402', '四川', '乐山', '犍为');
INSERT INTO `city_info` VALUES ('101271403', '四川', '乐山', '井研');
INSERT INTO `city_info` VALUES ('101271404', '四川', '乐山', '夹江');
INSERT INTO `city_info` VALUES ('101271405', '四川', '乐山', '沐川');
INSERT INTO `city_info` VALUES ('101271406', '四川', '乐山', '峨边');
INSERT INTO `city_info` VALUES ('101271407', '四川', '乐山', '马边');
INSERT INTO `city_info` VALUES ('101271408', '四川', '乐山', '峨眉');
INSERT INTO `city_info` VALUES ('101271409', '四川', '乐山', '峨眉山');
INSERT INTO `city_info` VALUES ('101271501', '四川', '眉山', '眉山');
INSERT INTO `city_info` VALUES ('101271502', '四川', '眉山', '仁寿');
INSERT INTO `city_info` VALUES ('101271503', '四川', '眉山', '彭山');
INSERT INTO `city_info` VALUES ('101271504', '四川', '眉山', '洪雅');
INSERT INTO `city_info` VALUES ('101271505', '四川', '眉山', '丹棱');
INSERT INTO `city_info` VALUES ('101271506', '四川', '眉山', '青神');
INSERT INTO `city_info` VALUES ('101271601', '四川', '凉山', '凉山');
INSERT INTO `city_info` VALUES ('101271603', '四川', '凉山', '木里');
INSERT INTO `city_info` VALUES ('101271604', '四川', '凉山', '盐源');
INSERT INTO `city_info` VALUES ('101271605', '四川', '凉山', '德昌');
INSERT INTO `city_info` VALUES ('101271606', '四川', '凉山', '会理');
INSERT INTO `city_info` VALUES ('101271607', '四川', '凉山', '会东');
INSERT INTO `city_info` VALUES ('101271608', '四川', '凉山', '宁南');
INSERT INTO `city_info` VALUES ('101271609', '四川', '凉山', '普格');
INSERT INTO `city_info` VALUES ('101271610', '四川', '凉山', '西昌');
INSERT INTO `city_info` VALUES ('101271611', '四川', '凉山', '金阳');
INSERT INTO `city_info` VALUES ('101271612', '四川', '凉山', '昭觉');
INSERT INTO `city_info` VALUES ('101271613', '四川', '凉山', '喜德');
INSERT INTO `city_info` VALUES ('101271614', '四川', '凉山', '冕宁');
INSERT INTO `city_info` VALUES ('101271615', '四川', '凉山', '越西');
INSERT INTO `city_info` VALUES ('101271616', '四川', '凉山', '甘洛');
INSERT INTO `city_info` VALUES ('101271617', '四川', '凉山', '雷波');
INSERT INTO `city_info` VALUES ('101271618', '四川', '凉山', '美姑');
INSERT INTO `city_info` VALUES ('101271619', '四川', '凉山', '布拖');
INSERT INTO `city_info` VALUES ('101271701', '四川', '雅安', '雅安');
INSERT INTO `city_info` VALUES ('101271702', '四川', '雅安', '名山');
INSERT INTO `city_info` VALUES ('101271703', '四川', '雅安', '荥经');
INSERT INTO `city_info` VALUES ('101271704', '四川', '雅安', '汉源');
INSERT INTO `city_info` VALUES ('101271705', '四川', '雅安', '石棉');
INSERT INTO `city_info` VALUES ('101271706', '四川', '雅安', '天全');
INSERT INTO `city_info` VALUES ('101271707', '四川', '雅安', '芦山');
INSERT INTO `city_info` VALUES ('101271708', '四川', '雅安', '宝兴');
INSERT INTO `city_info` VALUES ('101271801', '四川', '甘孜', '甘孜');
INSERT INTO `city_info` VALUES ('101271802', '四川', '甘孜', '康定');
INSERT INTO `city_info` VALUES ('101271803', '四川', '甘孜', '泸定');
INSERT INTO `city_info` VALUES ('101271804', '四川', '甘孜', '丹巴');
INSERT INTO `city_info` VALUES ('101271805', '四川', '甘孜', '九龙');
INSERT INTO `city_info` VALUES ('101271806', '四川', '甘孜', '雅江');
INSERT INTO `city_info` VALUES ('101271807', '四川', '甘孜', '道孚');
INSERT INTO `city_info` VALUES ('101271808', '四川', '甘孜', '炉霍');
INSERT INTO `city_info` VALUES ('101271809', '四川', '甘孜', '新龙');
INSERT INTO `city_info` VALUES ('101271810', '四川', '甘孜', '德格');
INSERT INTO `city_info` VALUES ('101271811', '四川', '甘孜', '白玉');
INSERT INTO `city_info` VALUES ('101271812', '四川', '甘孜', '石渠');
INSERT INTO `city_info` VALUES ('101271813', '四川', '甘孜', '色达');
INSERT INTO `city_info` VALUES ('101271814', '四川', '甘孜', '理塘');
INSERT INTO `city_info` VALUES ('101271815', '四川', '甘孜', '巴塘');
INSERT INTO `city_info` VALUES ('101271816', '四川', '甘孜', '乡城');
INSERT INTO `city_info` VALUES ('101271817', '四川', '甘孜', '稻城');
INSERT INTO `city_info` VALUES ('101271818', '四川', '甘孜', '得荣');
INSERT INTO `city_info` VALUES ('101271901', '四川', '阿坝', '阿坝');
INSERT INTO `city_info` VALUES ('101271902', '四川', '阿坝', '汶川');
INSERT INTO `city_info` VALUES ('101271903', '四川', '阿坝', '理县');
INSERT INTO `city_info` VALUES ('101271904', '四川', '阿坝', '茂县');
INSERT INTO `city_info` VALUES ('101271905', '四川', '阿坝', '松潘');
INSERT INTO `city_info` VALUES ('101271906', '四川', '阿坝', '九寨沟');
INSERT INTO `city_info` VALUES ('101271907', '四川', '阿坝', '金川');
INSERT INTO `city_info` VALUES ('101271908', '四川', '阿坝', '小金');
INSERT INTO `city_info` VALUES ('101271909', '四川', '阿坝', '黑水');
INSERT INTO `city_info` VALUES ('101271910', '四川', '阿坝', '马尔康');
INSERT INTO `city_info` VALUES ('101271911', '四川', '阿坝', '壤塘');
INSERT INTO `city_info` VALUES ('101271912', '四川', '阿坝', '若尔盖');
INSERT INTO `city_info` VALUES ('101271913', '四川', '阿坝', '红原');
INSERT INTO `city_info` VALUES ('101272001', '四川', '德阳', '德阳');
INSERT INTO `city_info` VALUES ('101272002', '四川', '德阳', '中江');
INSERT INTO `city_info` VALUES ('101272003', '四川', '德阳', '广汉');
INSERT INTO `city_info` VALUES ('101272004', '四川', '德阳', '什邡');
INSERT INTO `city_info` VALUES ('101272005', '四川', '德阳', '绵竹');
INSERT INTO `city_info` VALUES ('101272006', '四川', '德阳', '罗江');
INSERT INTO `city_info` VALUES ('101272101', '四川', '广元', '广元');
INSERT INTO `city_info` VALUES ('101272102', '四川', '广元', '旺苍');
INSERT INTO `city_info` VALUES ('101272103', '四川', '广元', '青川');
INSERT INTO `city_info` VALUES ('101272104', '四川', '广元', '剑阁');
INSERT INTO `city_info` VALUES ('101272105', '四川', '广元', '苍溪');
INSERT INTO `city_info` VALUES ('101280101', '广东', '广州', '广州');
INSERT INTO `city_info` VALUES ('101280102', '广东', '广州', '番禺');
INSERT INTO `city_info` VALUES ('101280103', '广东', '广州', '从化');
INSERT INTO `city_info` VALUES ('101280104', '广东', '广州', '增城');
INSERT INTO `city_info` VALUES ('101280105', '广东', '广州', '花都');
INSERT INTO `city_info` VALUES ('101280201', '广东', '韶关', '韶关');
INSERT INTO `city_info` VALUES ('101280202', '广东', '韶关', '乳源');
INSERT INTO `city_info` VALUES ('101280203', '广东', '韶关', '始兴');
INSERT INTO `city_info` VALUES ('101280204', '广东', '韶关', '翁源');
INSERT INTO `city_info` VALUES ('101280205', '广东', '韶关', '乐昌');
INSERT INTO `city_info` VALUES ('101280206', '广东', '韶关', '仁化');
INSERT INTO `city_info` VALUES ('101280207', '广东', '韶关', '南雄');
INSERT INTO `city_info` VALUES ('101280208', '广东', '韶关', '新丰');
INSERT INTO `city_info` VALUES ('101280209', '广东', '韶关', '曲江');
INSERT INTO `city_info` VALUES ('101280210', '广东', '韶关', '浈江');
INSERT INTO `city_info` VALUES ('101280211', '广东', '韶关', '武江');
INSERT INTO `city_info` VALUES ('101280301', '广东', '惠州', '惠州');
INSERT INTO `city_info` VALUES ('101280302', '广东', '惠州', '博罗');
INSERT INTO `city_info` VALUES ('101280303', '广东', '惠州', '惠阳');
INSERT INTO `city_info` VALUES ('101280304', '广东', '惠州', '惠东');
INSERT INTO `city_info` VALUES ('101280305', '广东', '惠州', '龙门');
INSERT INTO `city_info` VALUES ('101280401', '广东', '梅州', '梅州');
INSERT INTO `city_info` VALUES ('101280402', '广东', '梅州', '兴宁');
INSERT INTO `city_info` VALUES ('101280403', '广东', '梅州', '蕉岭');
INSERT INTO `city_info` VALUES ('101280404', '广东', '梅州', '大埔');
INSERT INTO `city_info` VALUES ('101280406', '广东', '梅州', '丰顺');
INSERT INTO `city_info` VALUES ('101280407', '广东', '梅州', '平远');
INSERT INTO `city_info` VALUES ('101280408', '广东', '梅州', '五华');
INSERT INTO `city_info` VALUES ('101280409', '广东', '梅州', '梅县');
INSERT INTO `city_info` VALUES ('101280501', '广东', '汕头', '汕头');
INSERT INTO `city_info` VALUES ('101280502', '广东', '汕头', '潮阳');
INSERT INTO `city_info` VALUES ('101280503', '广东', '汕头', '澄海');
INSERT INTO `city_info` VALUES ('101280504', '广东', '汕头', '南澳');
INSERT INTO `city_info` VALUES ('101280601', '广东', '深圳', '深圳');
INSERT INTO `city_info` VALUES ('101280701', '广东', '珠海', '珠海');
INSERT INTO `city_info` VALUES ('101280702', '广东', '珠海', '斗门');
INSERT INTO `city_info` VALUES ('101280703', '广东', '珠海', '金湾');
INSERT INTO `city_info` VALUES ('101280800', '广东', '佛山', '佛山');
INSERT INTO `city_info` VALUES ('101280801', '广东', '佛山', '顺德');
INSERT INTO `city_info` VALUES ('101280802', '广东', '佛山', '三水');
INSERT INTO `city_info` VALUES ('101280803', '广东', '佛山', '南海');
INSERT INTO `city_info` VALUES ('101280804', '广东', '佛山', '高明');
INSERT INTO `city_info` VALUES ('101280901', '广东', '肇庆', '肇庆');
INSERT INTO `city_info` VALUES ('101280902', '广东', '肇庆', '广宁');
INSERT INTO `city_info` VALUES ('101280903', '广东', '肇庆', '四会');
INSERT INTO `city_info` VALUES ('101280905', '广东', '肇庆', '德庆');
INSERT INTO `city_info` VALUES ('101280906', '广东', '肇庆', '怀集');
INSERT INTO `city_info` VALUES ('101280907', '广东', '肇庆', '封开');
INSERT INTO `city_info` VALUES ('101280908', '广东', '肇庆', '高要');
INSERT INTO `city_info` VALUES ('101281001', '广东', '湛江', '湛江');
INSERT INTO `city_info` VALUES ('101281002', '广东', '湛江', '吴川');
INSERT INTO `city_info` VALUES ('101281003', '广东', '湛江', '雷州');
INSERT INTO `city_info` VALUES ('101281004', '广东', '湛江', '徐闻');
INSERT INTO `city_info` VALUES ('101281005', '广东', '湛江', '廉江');
INSERT INTO `city_info` VALUES ('101281006', '广东', '湛江', '赤坎');
INSERT INTO `city_info` VALUES ('101281007', '广东', '湛江', '遂溪');
INSERT INTO `city_info` VALUES ('101281008', '广东', '湛江', '坡头');
INSERT INTO `city_info` VALUES ('101281009', '广东', '湛江', '霞山');
INSERT INTO `city_info` VALUES ('101281010', '广东', '湛江', '麻章');
INSERT INTO `city_info` VALUES ('101281101', '广东', '江门', '江门');
INSERT INTO `city_info` VALUES ('101281103', '广东', '江门', '开平');
INSERT INTO `city_info` VALUES ('101281104', '广东', '江门', '新会');
INSERT INTO `city_info` VALUES ('101281105', '广东', '江门', '恩平');
INSERT INTO `city_info` VALUES ('101281106', '广东', '江门', '台山');
INSERT INTO `city_info` VALUES ('101281107', '广东', '江门', '蓬江');
INSERT INTO `city_info` VALUES ('101281108', '广东', '江门', '鹤山');
INSERT INTO `city_info` VALUES ('101281109', '广东', '江门', '江海');
INSERT INTO `city_info` VALUES ('101281201', '广东', '河源', '河源');
INSERT INTO `city_info` VALUES ('101281202', '广东', '河源', '紫金');
INSERT INTO `city_info` VALUES ('101281203', '广东', '河源', '连平');
INSERT INTO `city_info` VALUES ('101281204', '广东', '河源', '和平');
INSERT INTO `city_info` VALUES ('101281205', '广东', '河源', '龙川');
INSERT INTO `city_info` VALUES ('101281206', '广东', '河源', '东源');
INSERT INTO `city_info` VALUES ('101281301', '广东', '清远', '清远');
INSERT INTO `city_info` VALUES ('101281302', '广东', '清远', '连南');
INSERT INTO `city_info` VALUES ('101281303', '广东', '清远', '连州');
INSERT INTO `city_info` VALUES ('101281304', '广东', '清远', '连山');
INSERT INTO `city_info` VALUES ('101281305', '广东', '清远', '阳山');
INSERT INTO `city_info` VALUES ('101281306', '广东', '清远', '佛冈');
INSERT INTO `city_info` VALUES ('101281307', '广东', '清远', '英德');
INSERT INTO `city_info` VALUES ('101281308', '广东', '清远', '清新');
INSERT INTO `city_info` VALUES ('101281401', '广东', '云浮', '云浮');
INSERT INTO `city_info` VALUES ('101281402', '广东', '云浮', '罗定');
INSERT INTO `city_info` VALUES ('101281403', '广东', '云浮', '新兴');
INSERT INTO `city_info` VALUES ('101281404', '广东', '云浮', '郁南');
INSERT INTO `city_info` VALUES ('101281406', '广东', '云浮', '云安');
INSERT INTO `city_info` VALUES ('101281501', '广东', '潮州', '潮州');
INSERT INTO `city_info` VALUES ('101281502', '广东', '潮州', '饶平');
INSERT INTO `city_info` VALUES ('101281503', '广东', '潮州', '潮安');
INSERT INTO `city_info` VALUES ('101281601', '广东', '东莞', '东莞');
INSERT INTO `city_info` VALUES ('101281701', '广东', '中山', '中山');
INSERT INTO `city_info` VALUES ('101281801', '广东', '阳江', '阳江');
INSERT INTO `city_info` VALUES ('101281802', '广东', '阳江', '阳春');
INSERT INTO `city_info` VALUES ('101281803', '广东', '阳江', '阳东');
INSERT INTO `city_info` VALUES ('101281804', '广东', '阳江', '阳西');
INSERT INTO `city_info` VALUES ('101281901', '广东', '揭阳', '揭阳');
INSERT INTO `city_info` VALUES ('101281902', '广东', '揭阳', '揭西');
INSERT INTO `city_info` VALUES ('101281903', '广东', '揭阳', '普宁');
INSERT INTO `city_info` VALUES ('101281904', '广东', '揭阳', '惠来');
INSERT INTO `city_info` VALUES ('101281905', '广东', '揭阳', '揭东');
INSERT INTO `city_info` VALUES ('101282001', '广东', '茂名', '茂名');
INSERT INTO `city_info` VALUES ('101282002', '广东', '茂名', '高州');
INSERT INTO `city_info` VALUES ('101282003', '广东', '茂名', '化州');
INSERT INTO `city_info` VALUES ('101282004', '广东', '茂名', '电白');
INSERT INTO `city_info` VALUES ('101282005', '广东', '茂名', '信宜');
INSERT INTO `city_info` VALUES ('101282006', '广东', '茂名', '茂港');
INSERT INTO `city_info` VALUES ('101282101', '广东', '汕尾', '汕尾');
INSERT INTO `city_info` VALUES ('101282102', '广东', '汕尾', '海丰');
INSERT INTO `city_info` VALUES ('101282103', '广东', '汕尾', '陆丰');
INSERT INTO `city_info` VALUES ('101282104', '广东', '汕尾', '陆河');
INSERT INTO `city_info` VALUES ('101290101', '云南', '昆明', '昆明');
INSERT INTO `city_info` VALUES ('101290103', '云南', '昆明', '东川');
INSERT INTO `city_info` VALUES ('101290104', '云南', '昆明', '寻甸');
INSERT INTO `city_info` VALUES ('101290105', '云南', '昆明', '晋宁');
INSERT INTO `city_info` VALUES ('101290106', '云南', '昆明', '宜良');
INSERT INTO `city_info` VALUES ('101290107', '云南', '昆明', '石林');
INSERT INTO `city_info` VALUES ('101290108', '云南', '昆明', '呈贡');
INSERT INTO `city_info` VALUES ('101290109', '云南', '昆明', '富民');
INSERT INTO `city_info` VALUES ('101290110', '云南', '昆明', '嵩明');
INSERT INTO `city_info` VALUES ('101290111', '云南', '昆明', '禄劝');
INSERT INTO `city_info` VALUES ('101290112', '云南', '昆明', '安宁');
INSERT INTO `city_info` VALUES ('101290113', '云南', '昆明', '太华山');
INSERT INTO `city_info` VALUES ('101290201', '云南', '大理', '大理');
INSERT INTO `city_info` VALUES ('101290202', '云南', '大理', '云龙');
INSERT INTO `city_info` VALUES ('101290203', '云南', '大理', '漾濞');
INSERT INTO `city_info` VALUES ('101290204', '云南', '大理', '永平');
INSERT INTO `city_info` VALUES ('101290205', '云南', '大理', '宾川');
INSERT INTO `city_info` VALUES ('101290206', '云南', '大理', '弥渡');
INSERT INTO `city_info` VALUES ('101290207', '云南', '大理', '祥云');
INSERT INTO `city_info` VALUES ('101290208', '云南', '大理', '巍山');
INSERT INTO `city_info` VALUES ('101290209', '云南', '大理', '剑川');
INSERT INTO `city_info` VALUES ('101290210', '云南', '大理', '洱源');
INSERT INTO `city_info` VALUES ('101290211', '云南', '大理', '鹤庆');
INSERT INTO `city_info` VALUES ('101290212', '云南', '大理', '南涧');
INSERT INTO `city_info` VALUES ('101290301', '云南', '红河', '红河');
INSERT INTO `city_info` VALUES ('101290302', '云南', '红河', '石屏');
INSERT INTO `city_info` VALUES ('101290303', '云南', '红河', '建水');
INSERT INTO `city_info` VALUES ('101290304', '云南', '红河', '弥勒');
INSERT INTO `city_info` VALUES ('101290305', '云南', '红河', '元阳');
INSERT INTO `city_info` VALUES ('101290306', '云南', '红河', '绿春');
INSERT INTO `city_info` VALUES ('101290307', '云南', '红河', '开远');
INSERT INTO `city_info` VALUES ('101290308', '云南', '红河', '个旧');
INSERT INTO `city_info` VALUES ('101290309', '云南', '红河', '蒙自');
INSERT INTO `city_info` VALUES ('101290310', '云南', '红河', '屏边');
INSERT INTO `city_info` VALUES ('101290311', '云南', '红河', '泸西');
INSERT INTO `city_info` VALUES ('101290312', '云南', '红河', '金平');
INSERT INTO `city_info` VALUES ('101290313', '云南', '红河', '河口');
INSERT INTO `city_info` VALUES ('101290401', '云南', '曲靖', '曲靖');
INSERT INTO `city_info` VALUES ('101290402', '云南', '曲靖', '沾益');
INSERT INTO `city_info` VALUES ('101290403', '云南', '曲靖', '陆良');
INSERT INTO `city_info` VALUES ('101290404', '云南', '曲靖', '富源');
INSERT INTO `city_info` VALUES ('101290405', '云南', '曲靖', '马龙');
INSERT INTO `city_info` VALUES ('101290406', '云南', '曲靖', '师宗');
INSERT INTO `city_info` VALUES ('101290407', '云南', '曲靖', '罗平');
INSERT INTO `city_info` VALUES ('101290408', '云南', '曲靖', '会泽');
INSERT INTO `city_info` VALUES ('101290409', '云南', '曲靖', '宣威');
INSERT INTO `city_info` VALUES ('101290501', '云南', '保山', '保山');
INSERT INTO `city_info` VALUES ('101290503', '云南', '保山', '龙陵');
INSERT INTO `city_info` VALUES ('101290504', '云南', '保山', '施甸');
INSERT INTO `city_info` VALUES ('101290505', '云南', '保山', '昌宁');
INSERT INTO `city_info` VALUES ('101290506', '云南', '保山', '腾冲');
INSERT INTO `city_info` VALUES ('101290601', '云南', '文山', '文山');
INSERT INTO `city_info` VALUES ('101290602', '云南', '文山', '西畴');
INSERT INTO `city_info` VALUES ('101290603', '云南', '文山', '马关');
INSERT INTO `city_info` VALUES ('101290604', '云南', '文山', '麻栗坡');
INSERT INTO `city_info` VALUES ('101290605', '云南', '文山', '砚山');
INSERT INTO `city_info` VALUES ('101290606', '云南', '文山', '丘北');
INSERT INTO `city_info` VALUES ('101290607', '云南', '文山', '广南');
INSERT INTO `city_info` VALUES ('101290608', '云南', '文山', '富宁');
INSERT INTO `city_info` VALUES ('101290701', '云南', '玉溪', '玉溪');
INSERT INTO `city_info` VALUES ('101290702', '云南', '玉溪', '澄江');
INSERT INTO `city_info` VALUES ('101290703', '云南', '玉溪', '江川');
INSERT INTO `city_info` VALUES ('101290704', '云南', '玉溪', '通海');
INSERT INTO `city_info` VALUES ('101290705', '云南', '玉溪', '华宁');
INSERT INTO `city_info` VALUES ('101290706', '云南', '玉溪', '新平');
INSERT INTO `city_info` VALUES ('101290707', '云南', '玉溪', '易门');
INSERT INTO `city_info` VALUES ('101290708', '云南', '玉溪', '峨山');
INSERT INTO `city_info` VALUES ('101290709', '云南', '玉溪', '元江');
INSERT INTO `city_info` VALUES ('101290801', '云南', '楚雄', '楚雄');
INSERT INTO `city_info` VALUES ('101290802', '云南', '楚雄', '大姚');
INSERT INTO `city_info` VALUES ('101290803', '云南', '楚雄', '元谋');
INSERT INTO `city_info` VALUES ('101290804', '云南', '楚雄', '姚安');
INSERT INTO `city_info` VALUES ('101290805', '云南', '楚雄', '牟定');
INSERT INTO `city_info` VALUES ('101290806', '云南', '楚雄', '南华');
INSERT INTO `city_info` VALUES ('101290807', '云南', '楚雄', '武定');
INSERT INTO `city_info` VALUES ('101290808', '云南', '楚雄', '禄丰');
INSERT INTO `city_info` VALUES ('101290809', '云南', '楚雄', '双柏');
INSERT INTO `city_info` VALUES ('101290810', '云南', '楚雄', '永仁');
INSERT INTO `city_info` VALUES ('101290901', '云南', '普洱', '普洱');
INSERT INTO `city_info` VALUES ('101290902', '云南', '普洱', '景谷');
INSERT INTO `city_info` VALUES ('101290903', '云南', '普洱', '景东');
INSERT INTO `city_info` VALUES ('101290904', '云南', '普洱', '澜沧');
INSERT INTO `city_info` VALUES ('101290906', '云南', '普洱', '墨江');
INSERT INTO `city_info` VALUES ('101290907', '云南', '普洱', '江城');
INSERT INTO `city_info` VALUES ('101290908', '云南', '普洱', '孟连');
INSERT INTO `city_info` VALUES ('101290909', '云南', '普洱', '西盟');
INSERT INTO `city_info` VALUES ('101290911', '云南', '普洱', '镇沅');
INSERT INTO `city_info` VALUES ('101290912', '云南', '普洱', '宁洱');
INSERT INTO `city_info` VALUES ('101291001', '云南', '昭通', '昭通');
INSERT INTO `city_info` VALUES ('101291002', '云南', '昭通', '鲁甸');
INSERT INTO `city_info` VALUES ('101291003', '云南', '昭通', '彝良');
INSERT INTO `city_info` VALUES ('101291004', '云南', '昭通', '镇雄');
INSERT INTO `city_info` VALUES ('101291005', '云南', '昭通', '威信');
INSERT INTO `city_info` VALUES ('101291006', '云南', '昭通', '巧家');
INSERT INTO `city_info` VALUES ('101291007', '云南', '昭通', '绥江');
INSERT INTO `city_info` VALUES ('101291008', '云南', '昭通', '永善');
INSERT INTO `city_info` VALUES ('101291009', '云南', '昭通', '盐津');
INSERT INTO `city_info` VALUES ('101291010', '云南', '昭通', '大关');
INSERT INTO `city_info` VALUES ('101291011', '云南', '昭通', '水富');
INSERT INTO `city_info` VALUES ('101291101', '云南', '临沧', '临沧');
INSERT INTO `city_info` VALUES ('101291102', '云南', '临沧', '沧源');
INSERT INTO `city_info` VALUES ('101291103', '云南', '临沧', '耿马');
INSERT INTO `city_info` VALUES ('101291104', '云南', '临沧', '双江');
INSERT INTO `city_info` VALUES ('101291105', '云南', '临沧', '凤庆');
INSERT INTO `city_info` VALUES ('101291106', '云南', '临沧', '永德');
INSERT INTO `city_info` VALUES ('101291107', '云南', '临沧', '云县');
INSERT INTO `city_info` VALUES ('101291108', '云南', '临沧', '镇康');
INSERT INTO `city_info` VALUES ('101291201', '云南', '怒江', '怒江');
INSERT INTO `city_info` VALUES ('101291203', '云南', '怒江', '福贡');
INSERT INTO `city_info` VALUES ('101291204', '云南', '怒江', '兰坪');
INSERT INTO `city_info` VALUES ('101291205', '云南', '怒江', '泸水');
INSERT INTO `city_info` VALUES ('101291206', '云南', '怒江', '六库');
INSERT INTO `city_info` VALUES ('101291207', '云南', '怒江', '贡山');
INSERT INTO `city_info` VALUES ('101291301', '云南', '迪庆', '香格里拉');
INSERT INTO `city_info` VALUES ('101291302', '云南', '迪庆', '德钦');
INSERT INTO `city_info` VALUES ('101291303', '云南', '迪庆', '维西');
INSERT INTO `city_info` VALUES ('101291304', '云南', '迪庆', '中甸');
INSERT INTO `city_info` VALUES ('101291401', '云南', '丽江', '丽江');
INSERT INTO `city_info` VALUES ('101291402', '云南', '丽江', '永胜');
INSERT INTO `city_info` VALUES ('101291403', '云南', '丽江', '华坪');
INSERT INTO `city_info` VALUES ('101291404', '云南', '丽江', '宁蒗');
INSERT INTO `city_info` VALUES ('101291501', '云南', '德宏', '德宏');
INSERT INTO `city_info` VALUES ('101291503', '云南', '德宏', '陇川');
INSERT INTO `city_info` VALUES ('101291504', '云南', '德宏', '盈江');
INSERT INTO `city_info` VALUES ('101291506', '云南', '德宏', '瑞丽');
INSERT INTO `city_info` VALUES ('101291507', '云南', '德宏', '梁河');
INSERT INTO `city_info` VALUES ('101291508', '云南', '德宏', '潞西');
INSERT INTO `city_info` VALUES ('101291601', '云南', '西双版纳', '景洪');
INSERT INTO `city_info` VALUES ('101291603', '云南', '西双版纳', '勐海');
INSERT INTO `city_info` VALUES ('101291605', '云南', '西双版纳', '勐腊');
INSERT INTO `city_info` VALUES ('101300101', '广西', '南宁', '南宁');
INSERT INTO `city_info` VALUES ('101300103', '广西', '南宁', '邕宁');
INSERT INTO `city_info` VALUES ('101300104', '广西', '南宁', '横县');
INSERT INTO `city_info` VALUES ('101300105', '广西', '南宁', '隆安');
INSERT INTO `city_info` VALUES ('101300106', '广西', '南宁', '马山');
INSERT INTO `city_info` VALUES ('101300107', '广西', '南宁', '上林');
INSERT INTO `city_info` VALUES ('101300108', '广西', '南宁', '武鸣');
INSERT INTO `city_info` VALUES ('101300109', '广西', '南宁', '宾阳');
INSERT INTO `city_info` VALUES ('101300201', '广西', '崇左', '崇左');
INSERT INTO `city_info` VALUES ('101300202', '广西', '崇左', '天等');
INSERT INTO `city_info` VALUES ('101300203', '广西', '崇左', '龙州');
INSERT INTO `city_info` VALUES ('101300204', '广西', '崇左', '凭祥');
INSERT INTO `city_info` VALUES ('101300205', '广西', '崇左', '大新');
INSERT INTO `city_info` VALUES ('101300206', '广西', '崇左', '扶绥');
INSERT INTO `city_info` VALUES ('101300207', '广西', '崇左', '宁明');
INSERT INTO `city_info` VALUES ('101300301', '广西', '柳州', '柳州');
INSERT INTO `city_info` VALUES ('101300302', '广西', '柳州', '柳城');
INSERT INTO `city_info` VALUES ('101300304', '广西', '柳州', '鹿寨');
INSERT INTO `city_info` VALUES ('101300305', '广西', '柳州', '柳江');
INSERT INTO `city_info` VALUES ('101300306', '广西', '柳州', '融安');
INSERT INTO `city_info` VALUES ('101300307', '广西', '柳州', '融水');
INSERT INTO `city_info` VALUES ('101300308', '广西', '柳州', '三江');
INSERT INTO `city_info` VALUES ('101300401', '广西', '来宾', '来宾');
INSERT INTO `city_info` VALUES ('101300402', '广西', '来宾', '忻城');
INSERT INTO `city_info` VALUES ('101300403', '广西', '来宾', '金秀');
INSERT INTO `city_info` VALUES ('101300404', '广西', '来宾', '象州');
INSERT INTO `city_info` VALUES ('101300405', '广西', '来宾', '武宣');
INSERT INTO `city_info` VALUES ('101300406', '广西', '来宾', '合山');
INSERT INTO `city_info` VALUES ('101300501', '广西', '桂林', '桂林');
INSERT INTO `city_info` VALUES ('101300503', '广西', '桂林', '龙胜');
INSERT INTO `city_info` VALUES ('101300504', '广西', '桂林', '永福');
INSERT INTO `city_info` VALUES ('101300505', '广西', '桂林', '临桂');
INSERT INTO `city_info` VALUES ('101300506', '广西', '桂林', '兴安');
INSERT INTO `city_info` VALUES ('101300507', '广西', '桂林', '灵川');
INSERT INTO `city_info` VALUES ('101300508', '广西', '桂林', '全州');
INSERT INTO `city_info` VALUES ('101300509', '广西', '桂林', '灌阳');
INSERT INTO `city_info` VALUES ('101300510', '广西', '桂林', '阳朔');
INSERT INTO `city_info` VALUES ('101300511', '广西', '桂林', '恭城');
INSERT INTO `city_info` VALUES ('101300512', '广西', '桂林', '平乐');
INSERT INTO `city_info` VALUES ('101300513', '广西', '桂林', '荔浦');
INSERT INTO `city_info` VALUES ('101300514', '广西', '桂林', '资源');
INSERT INTO `city_info` VALUES ('101300601', '广西', '梧州', '梧州');
INSERT INTO `city_info` VALUES ('101300602', '广西', '梧州', '藤县');
INSERT INTO `city_info` VALUES ('101300604', '广西', '梧州', '苍梧');
INSERT INTO `city_info` VALUES ('101300605', '广西', '梧州', '蒙山');
INSERT INTO `city_info` VALUES ('101300606', '广西', '梧州', '岑溪');
INSERT INTO `city_info` VALUES ('101300701', '广西', '贺州', '贺州');
INSERT INTO `city_info` VALUES ('101300702', '广西', '贺州', '昭平');
INSERT INTO `city_info` VALUES ('101300703', '广西', '贺州', '富川');
INSERT INTO `city_info` VALUES ('101300704', '广西', '贺州', '钟山');
INSERT INTO `city_info` VALUES ('101300801', '广西', '贵港', '贵港');
INSERT INTO `city_info` VALUES ('101300802', '广西', '贵港', '桂平');
INSERT INTO `city_info` VALUES ('101300803', '广西', '贵港', '平南');
INSERT INTO `city_info` VALUES ('101300901', '广西', '玉林', '玉林');
INSERT INTO `city_info` VALUES ('101300902', '广西', '玉林', '博白');
INSERT INTO `city_info` VALUES ('101300903', '广西', '玉林', '北流');
INSERT INTO `city_info` VALUES ('101300904', '广西', '玉林', '容县');
INSERT INTO `city_info` VALUES ('101300905', '广西', '玉林', '陆川');
INSERT INTO `city_info` VALUES ('101300906', '广西', '玉林', '兴业');
INSERT INTO `city_info` VALUES ('101301001', '广西', '百色', '百色');
INSERT INTO `city_info` VALUES ('101301002', '广西', '百色', '那坡');
INSERT INTO `city_info` VALUES ('101301003', '广西', '百色', '田阳');
INSERT INTO `city_info` VALUES ('101301004', '广西', '百色', '德保');
INSERT INTO `city_info` VALUES ('101301005', '广西', '百色', '靖西');
INSERT INTO `city_info` VALUES ('101301006', '广西', '百色', '田东');
INSERT INTO `city_info` VALUES ('101301007', '广西', '百色', '平果');
INSERT INTO `city_info` VALUES ('101301008', '广西', '百色', '隆林');
INSERT INTO `city_info` VALUES ('101301009', '广西', '百色', '西林');
INSERT INTO `city_info` VALUES ('101301010', '广西', '百色', '乐业');
INSERT INTO `city_info` VALUES ('101301011', '广西', '百色', '凌云');
INSERT INTO `city_info` VALUES ('101301012', '广西', '百色', '田林');
INSERT INTO `city_info` VALUES ('101301101', '广西', '钦州', '钦州');
INSERT INTO `city_info` VALUES ('101301102', '广西', '钦州', '浦北');
INSERT INTO `city_info` VALUES ('101301103', '广西', '钦州', '灵山');
INSERT INTO `city_info` VALUES ('101301201', '广西', '河池', '河池');
INSERT INTO `city_info` VALUES ('101301202', '广西', '河池', '天峨');
INSERT INTO `city_info` VALUES ('101301203', '广西', '河池', '东兰');
INSERT INTO `city_info` VALUES ('101301204', '广西', '河池', '巴马');
INSERT INTO `city_info` VALUES ('101301205', '广西', '河池', '环江');
INSERT INTO `city_info` VALUES ('101301206', '广西', '河池', '罗城');
INSERT INTO `city_info` VALUES ('101301207', '广西', '河池', '宜州');
INSERT INTO `city_info` VALUES ('101301208', '广西', '河池', '凤山');
INSERT INTO `city_info` VALUES ('101301209', '广西', '河池', '南丹');
INSERT INTO `city_info` VALUES ('101301210', '广西', '河池', '都安');
INSERT INTO `city_info` VALUES ('101301211', '广西', '河池', '大化');
INSERT INTO `city_info` VALUES ('101301301', '广西', '北海', '北海');
INSERT INTO `city_info` VALUES ('101301302', '广西', '北海', '合浦');
INSERT INTO `city_info` VALUES ('101301303', '广西', '北海', '涠洲岛');
INSERT INTO `city_info` VALUES ('101301401', '广西', '防城港', '防城港');
INSERT INTO `city_info` VALUES ('101301402', '广西', '防城港', '上思');
INSERT INTO `city_info` VALUES ('101301403', '广西', '防城港', '东兴');
INSERT INTO `city_info` VALUES ('101301405', '广西', '防城港', '防城');
INSERT INTO `city_info` VALUES ('101310101', '海南', '海口', '海口');
INSERT INTO `city_info` VALUES ('101310201', '海南', '三亚', '三亚');
INSERT INTO `city_info` VALUES ('101310202', '海南', '东方', '东方');
INSERT INTO `city_info` VALUES ('101310203', '海南', '临高', '临高');
INSERT INTO `city_info` VALUES ('101310204', '海南', '澄迈', '澄迈');
INSERT INTO `city_info` VALUES ('101310205', '海南', '儋州', '儋州');
INSERT INTO `city_info` VALUES ('101310206', '海南', '昌江', '昌江');
INSERT INTO `city_info` VALUES ('101310207', '海南', '白沙', '白沙');
INSERT INTO `city_info` VALUES ('101310208', '海南', '琼中', '琼中');
INSERT INTO `city_info` VALUES ('101310209', '海南', '定安', '定安');
INSERT INTO `city_info` VALUES ('101310210', '海南', '屯昌', '屯昌');
INSERT INTO `city_info` VALUES ('101310211', '海南', '琼海', '琼海');
INSERT INTO `city_info` VALUES ('101310212', '海南', '文昌', '文昌');
INSERT INTO `city_info` VALUES ('101310214', '海南', '保亭', '保亭');
INSERT INTO `city_info` VALUES ('101310215', '海南', '万宁', '万宁');
INSERT INTO `city_info` VALUES ('101310216', '海南', '陵水', '陵水');
INSERT INTO `city_info` VALUES ('101310217', '海南', '西沙', '西沙');
INSERT INTO `city_info` VALUES ('101310220', '海南', '南沙', '南沙');
INSERT INTO `city_info` VALUES ('101310221', '海南', '乐东', '乐东');
INSERT INTO `city_info` VALUES ('101310222', '海南', '五指山', '五指山');
INSERT INTO `city_info` VALUES ('101320101', '香港', '香港', '香港');
INSERT INTO `city_info` VALUES ('101320102', '香港', '香港', '九龙');
INSERT INTO `city_info` VALUES ('101320103', '香港', '香港', '新界');
INSERT INTO `city_info` VALUES ('101330101', '澳门', '澳门', '澳门');
INSERT INTO `city_info` VALUES ('101330102', '澳门', '澳门', '氹仔岛');
INSERT INTO `city_info` VALUES ('101330103', '澳门', '澳门', '路环岛');
INSERT INTO `city_info` VALUES ('101340101', '台湾', '台北', '台北');
INSERT INTO `city_info` VALUES ('101340102', '台湾', '台北', '桃园');
INSERT INTO `city_info` VALUES ('101340103', '台湾', '台北', '新竹');
INSERT INTO `city_info` VALUES ('101340104', '台湾', '台北', '宜兰');
INSERT INTO `city_info` VALUES ('101340201', '台湾', '高雄', '高雄');
INSERT INTO `city_info` VALUES ('101340202', '台湾', '高雄', '嘉义');
INSERT INTO `city_info` VALUES ('101340203', '台湾', '高雄', '台南');
INSERT INTO `city_info` VALUES ('101340204', '台湾', '高雄', '台东');
INSERT INTO `city_info` VALUES ('101340205', '台湾', '高雄', '屏东');
INSERT INTO `city_info` VALUES ('101340401', '台湾', '台中', '台中');
INSERT INTO `city_info` VALUES ('101340402', '台湾', '台中', '苗栗');
INSERT INTO `city_info` VALUES ('101340403', '台湾', '台中', '彰化');
INSERT INTO `city_info` VALUES ('101340404', '台湾', '台中', '南投');
INSERT INTO `city_info` VALUES ('101340405', '台湾', '台中', '花莲');
INSERT INTO `city_info` VALUES ('101340406', '台湾', '台中', '云林');

-- ----------------------------
-- Table structure for configuration
-- ----------------------------
DROP TABLE IF EXISTS `configuration`;
CREATE TABLE `configuration` (
  `location` varchar(255) CHARACTER SET latin1 DEFAULT NULL COMMENT '地理信息类',
  `traffic` varchar(255) CHARACTER SET latin1 DEFAULT NULL COMMENT '交通信息类',
  `map` varchar(255) CHARACTER SET latin1 DEFAULT NULL COMMENT '地图类',
  `news` varchar(255) CHARACTER SET latin1 DEFAULT NULL COMMENT '新闻类'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of configuration
-- ----------------------------
INSERT INTO `configuration` VALUES ('{\"citycode\":\"101030100\",\"cityname\":\"\\u5929\\u6d25\\/\\u5929\\u6d25\"}', '{\"lng\":\"117.0003385\",\"lat\":\"39.110046499999996\",\"zoom\":\"14\"}', '', '{\"newsid\":\"http://www.people.com.cn/rss/politics.xml\",\"newsname\":\"\\u4eba\\u6c11\\u7f51\"}');

-- ----------------------------
-- Table structure for defense_alarm_record
-- ----------------------------
DROP TABLE IF EXISTS `defense_alarm_record`;
CREATE TABLE `defense_alarm_record` (
  `defenseAlarmID` int(32) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `deviceID` varchar(50) NOT NULL COMMENT '设备ID(参见说明文档定义)',
  `building` varchar(3) DEFAULT NULL COMMENT '楼栋',
  `unit` varchar(2) DEFAULT NULL COMMENT '单元',
  `room` varchar(4) DEFAULT NULL COMMENT '室',
  `zoneID` int(10) DEFAULT '0' COMMENT '防区ID',
  `zoneType` int(10) DEFAULT '0' COMMENT '防区类型',
  `sensorType` int(10) DEFAULT '0' COMMENT '传感器类型',
  `eventType` int(10) DEFAULT '0' COMMENT '事件类型',
  `alarmType` int(10) DEFAULT '0' COMMENT '报警类型',
  `description` varchar(255) DEFAULT NULL COMMENT '事件描述',
  `datetime` int(32) NOT NULL COMMENT '布撤防时间',
  `isFinished` int(1) DEFAULT '0' COMMENT '是否处理 0：未处理；1：处理',
  `remark` varchar(50) DEFAULT NULL,
  `dealTime` int(32) DEFAULT NULL,
  `dealUser` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`defenseAlarmID`),
  KEY `device_id` (`deviceID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='布撤防记录表';

-- ----------------------------
-- Records of defense_alarm_record
-- ----------------------------

-- ----------------------------
-- Table structure for defense_info
-- ----------------------------
DROP TABLE IF EXISTS `defense_info`;
CREATE TABLE `defense_info` (
  `id` int(32) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `device_id` varchar(50) NOT NULL COMMENT '设备ID',
  `device_ip` varchar(50) NOT NULL COMMENT '设备IP',
  `building` varchar(3) DEFAULT NULL COMMENT '栋',
  `unit` varchar(2) DEFAULT '' COMMENT '单元',
  `room` varchar(4) DEFAULT '' COMMENT '室',
  `datetime` int(32) NOT NULL COMMENT '布撤防时间',
  `status` tinyint(1) DEFAULT NULL COMMENT '布撤防状态 1：布防，0：撤防',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='布撤防状态表';

-- ----------------------------
-- Records of defense_info
-- ----------------------------

-- ----------------------------
-- Table structure for defense_record
-- ----------------------------
DROP TABLE IF EXISTS `defense_record`;
CREATE TABLE `defense_record` (
  `defenseID` int(32) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `deviceID` varchar(50) NOT NULL COMMENT '设备ID(参见说明文档定义)',
  `building` varchar(3) DEFAULT NULL COMMENT '楼栋',
  `unit` varchar(2) DEFAULT NULL COMMENT '单元',
  `room` varchar(4) DEFAULT NULL COMMENT '室',
  `zoneID` int(10) DEFAULT '0' COMMENT '防区ID',
  `zoneType` int(10) DEFAULT '0' COMMENT '防区类型',
  `sensorType` int(10) DEFAULT '0' COMMENT '传感器类型',
  `eventType` int(10) DEFAULT '0' COMMENT '事件类型',
  `description` varchar(255) DEFAULT NULL COMMENT '事件描述',
  `datetime` int(32) NOT NULL COMMENT '布撤防时间',
  PRIMARY KEY (`defenseID`),
  KEY `device_id` (`deviceID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='布撤防记录表';

-- ----------------------------
-- Records of defense_record
-- ----------------------------

-- ----------------------------
-- Table structure for device
-- ----------------------------
DROP TABLE IF EXISTS `device`;
CREATE TABLE `device` (
  `id` int(32) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `name` varchar(40) NOT NULL COMMENT '用户名',
  `nickname` varchar(40) DEFAULT NULL COMMENT '昵称',
  `password` varchar(40) DEFAULT NULL COMMENT '密码',
  `transfer` varchar(40) DEFAULT NULL COMMENT '异常转接',
  `remark` varchar(255) DEFAULT NULL COMMENT '设备备注',
  PRIMARY KEY (`id`),
  UNIQUE KEY `extension` (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='分机号信息';

-- ----------------------------
-- Records of device
-- ----------------------------

-- ----------------------------
-- Table structure for device_group
-- ----------------------------
DROP TABLE IF EXISTS `device_group`;
CREATE TABLE `device_group` (
  `id` int(32) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `name` varchar(40) NOT NULL COMMENT '组名称',
  `members` text COMMENT '组成员, JSON数组',
  `transfer` varchar(40) DEFAULT NULL COMMENT '异常转接',
  `remark` varchar(255) DEFAULT NULL COMMENT '组备注',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of device_group
-- ----------------------------
INSERT INTO `device_group` VALUES ('1', '9901000000000', '', '', null);
INSERT INTO `device_group` VALUES ('2', '9907000000000', '', null, null);
INSERT INTO `device_group` VALUES ('4', '9902000000000', '', null, null);
-- ----------------------------
-- Records of device_group
-- ----------------------------

-- ----------------------------
-- Table structure for device_ip_info
-- ----------------------------
DROP TABLE IF EXISTS `device_ip_info`;
CREATE TABLE `device_ip_info` (
  `id` int(32) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `device_id` varchar(50) NOT NULL COMMENT '设备ID',
  `device_ip` varchar(50) DEFAULT NULL COMMENT '设备ip',
  `device_type` int(4) DEFAULT NULL COMMENT '设备类型',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='设备IP记录表';

-- ----------------------------
-- Records of device_ip_info
-- ----------------------------

-- ----------------------------
-- Table structure for message_event
-- ----------------------------
DROP TABLE IF EXISTS `message_event`;
CREATE TABLE `message_event` (
  `event_id` int(32) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL COMMENT '事件标题',
  `datetime` int(32) DEFAULT NULL COMMENT '发布时间',
  PRIMARY KEY (`event_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of message_event
-- ----------------------------

-- ----------------------------
-- Table structure for message_flight
-- ----------------------------
DROP TABLE IF EXISTS `message_flight`;
CREATE TABLE `message_flight` (
  `id` int(32) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `flightNum` varchar(255) NOT NULL,
  `airline` varchar(255) DEFAULT NULL,
  `flightType` varchar(50) NOT NULL,
  `flightDetail` longtext NOT NULL,
  `departure` varchar(200) NOT NULL,
  `arrival` varchar(200) NOT NULL,
  `takeoff` varchar(200) NOT NULL,
  `langding` varchar(200) NOT NULL,
  `type` varchar(200) NOT NULL,
  `datetime` int(32) NOT NULL,
  `crawlTime` int(32) DEFAULT NULL COMMENT '抓取时间分组',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of message_flight
-- ----------------------------

-- ----------------------------
-- Table structure for message_news
-- ----------------------------
DROP TABLE IF EXISTS `message_news`;
CREATE TABLE `message_news` (
  `id` int(32) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `cateid` varchar(50) DEFAULT NULL COMMENT '分类ID',
  `cate` varchar(50) DEFAULT NULL COMMENT '新闻分类',
  `docid` varchar(50) DEFAULT NULL COMMENT '新闻id',
  `digest` text COMMENT '新闻摘要',
  `imgsrc` varchar(255) DEFAULT NULL COMMENT '新闻图片',
  `mtime` varchar(255) DEFAULT NULL COMMENT '新闻发布时间',
  `source` varchar(50) DEFAULT NULL COMMENT '新闻来源',
  `title` text COMMENT '新闻标题',
  `url` varchar(255) DEFAULT NULL COMMENT '新闻url',
  `datetime` int(32) DEFAULT NULL COMMENT '抓取时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of message_news
-- ----------------------------
INSERT INTO `message_news` VALUES ('1', 'T1467284926140', 'News', 'c2f42b19931b1cb89304196d2f847ee6', '<p style=\"text-indent: 2em;\"> 新华社北京6月12日电 国家主席习近平2018年6月10日在上海合作组织成员国元首理事会第十八次会议上的讲话《弘扬“上海精神” 构建命运共同体》单行本，已由人民出版社出版，即日起在全国新华书店发行。</p>', 'http://politics.people.com.cn/n1/2018/0612/c1001-30053364.html', '2018-06-12', 'http://politics.people.com.cn/n1/2018/0612/c1001-3', '习近平《弘扬“上海精神”　构建命运共同体》单行本出版', 'http://politics.people.com.cn/n1/2018/0612/c1001-30053364.html', '1528795504');
INSERT INTO `message_news` VALUES ('2', 'T1467284926140', 'News', 'fb6633c5546658f9fc58e46600c47dea', '<p style=\"text-indent: 2em;\"> 新华社北京6月12日电（记者叶昊鸣）记者12日从应急管理部了解到，应急管理部近日将通过自查、互查、抽查等方式，组织对全国大型综合体进行消防安全治理。</p> <p style=\"text-indent: 2em;\"> 应急管理部日前召开会议研究当前安全生产工作。应急管理部党组书记黄明要求各地立即行动起来，组织对大型城市综合体进行全面消防安全治理。重点整治擅自改变综合体建筑使用性质、建筑消防设施损坏故障、防火分隔不到位、用火用电混乱、多产权业主消防安全责任不落实等突出问题；集中整改火灾隐患，对隐患突出的单位，推动政府挂牌督办；督促落实地方党政领导安全生产责任、部门监管责任和企业主体责任，切实维护人民群众生命财产安全。</p>', 'http://politics.people.com.cn/n1/2018/0612/c1001-30053280.html', '2018-06-12', 'http://politics.people.com.cn/n1/2018/0612/c1001-3', '应急管理部将对全国大型综合体进行消防安全治理', 'http://politics.people.com.cn/n1/2018/0612/c1001-30053280.html', '1528795504');
INSERT INTO `message_news` VALUES ('3', 'T1467284926140', 'News', 'a233109017e4865b3e82402bb417f262', '<p style=\"text-indent: 2em;\"> 人民网北京6月12日电&nbsp; 据吉林省纪委监委消息：吉林省人大常委会正厅级退休干部周化辰涉嫌严重违纪违法，目前正接受纪律审查和监察调查。</p> <p style=\"text-indent: 2em;\"> <strong>周化辰简历：</strong></p> <p style=\"text-indent: 2em;\"> 周化辰，男，汉族，1952年6月出生，1968年3月参加工作，1976年4月加入中国共产党。</p> <p style=\"text-indent: 2em;\"> 1997年8月，任吉林省敦化市委书记；1999年2月，任吉林省延边州副州长；2001年7月，任吉林省政府副秘书长兼办公厅党组成员、副主任；2003年12月，任吉林省白山市委副书记、代市长；2004年2月，任吉林省白山市委副书记、市长；2006年7月，任吉林省白山市委书记；2008年1月，任吉林省吉林市委书记；2011年2月，任吉林省人大常委会党组成员、副主任；2016年1月，退休。</p> <p style=\"text-indent: 2em;\"> 2017年3月，因严重违纪按正厅级确定退休待遇。</p>', 'http://politics.people.com.cn/n1/2018/0612/c1001-30053116.html', '2018-06-12', 'http://politics.people.com.cn/n1/2018/0612/c1001-3', '吉林省人大常委会正厅级退休干部周化辰被查', 'http://politics.people.com.cn/n1/2018/0612/c1001-30053116.html', '1528795504');
INSERT INTO `message_news` VALUES ('4', 'T1467284926140', 'News', 'd4322b3ba89035c1d99de6dc16835b95', '<p style=\"text-indent: 2em;\"> “组织生活是否正常开展？”“‘三会一课’制度有没有按规定落实？”在党建考核中，经常会听到这样的问题。</p> <p style=\"text-indent: 2em;\"> 江苏句容市运用“互联网+”和大数据技术，引入可视化的理念，建立了覆盖市、镇、村三级的标准化记实管理系统，对“三会一课”、组织生活会、民主评议党员、发展党员、党员志愿活动等党内生活开展情况全程记实，形成“任务统一发布、活动记实管理、结果实时监测、自动考核评分”四步闭环工作流程，实现了组织生活“全程留痕”，有力提高了党建管理的精准化、科学化水平。</p> <p style=\"text-indent: 2em;\"> <strong>规范组织生活，为党员设定“生物钟”</strong></p> <p style=\"text-indent: 2em;\"> 4月20日上午，句容市边城镇大华村党员钱之华早早的就来到村大会议室，“今天上午，我们村专门邀请了市委党校的老师来上党课，像这样的组织生活，我们村是严格按照‘三会一课’制度要求来的。说实话，刚开始还有点不习惯，现在习惯了以后，到时间就想起来要参加组织活动。”大华村党员钱之华说道。</p> <p style=\"text-indent: 2em;\"> 从“有点不习惯”到组织生活正常化，正是靠记实管理系统这一“良方”。句容市委组织部在年初充分调研的基础上，按季度拟定村级党组织党建工作任务清单，对全年党组织活动进行安排并录入记实系统；镇、村党组织根据系统中清单任务，组织党员按规定时限开展组织生活。这样，既为组织生活装上了“电子眼”，又为党员设定了健康“生物钟”。</p> <p style=\"text-indent: 2em;\"> <strong>一键式汇总，让数据多跑路</strong></p> <p style=\"text-indent: 2em;\"> “今天召集大家来，主要是讨论研究下本月的重点工作。”支委会一开始，下蜀镇祝里村党总支书记曹当贵就打开了记实系统和安装在会议室里的摄像头。这个摄像头将随机抓拍会议实时画面，通过远程教育网络传送到市标准化记实管理系统的镇级平台审核，并最终提交至市级平台汇总。</p> <p style=\"text-indent: 2em;\"> “以前，我们在督查组织生活落实情况时，还需要逐村去落实；现在，我们只要点击系统中的统计汇总，村里什么时候开的会、会议开了多长时间、多少人参会，哪些村开了、哪些村还没开，在大数据技术下一目了然。”后白镇党委组织委员张巍介绍说，“对那些会议时间、参会人数明显不‘正常’的会议，在审核时将不予通过，并要求在规定时间内重新召开。”这就是标准化记实管理系统的“基本活动”模块功能。该系统依托远程教育、互联网和手机动等平台架设，主要包含基本活动、基本阵地、基本队伍、综合考核等7个模块功能，目前已覆盖句容全市162个村。</p> <p style=\"text-indent: 2em;\"> <strong>大数据分析，助力精准施策</strong></p> <p style=\"text-indent: 2em;\"> “解塘村完成了二季度党课任务，经审核通过后，系统加了10分，现在是100分；倪塘村三月份支委会任务在规定时限内没完成，现在只有60分，目前我们镇党委考核得分是76分。”句容市白兔镇党委组织委员吴凌华介绍说，“现在有了记实系统的综合考核功能，实现了组织生活的自动化考核，我们镇15个村的组织生活落实情况怎么样，我们在后台看的一清二楚。”在记实系统中，市委组织部发布任务时，会给每个任务设置一定分值；村党组织每完成一个任务，便可获得对应分值；镇党委的考核分值根据所辖村的得分情况，取平均得分。到年底，记实系统根据各村实际得分和市级发布任务总分，自动换算成百分<span style=\"text-indent: 2em;\">制形成最终得分。</span></p> <p style=\"text-indent: 2em;\"> 通过采用百分制计分模式、可视化数据展示、对比式数据分析，不仅市级可以看到镇村的考核得分，而且镇党委可实时掌握所辖村党组织的任务执行情况和考核得分，有效调动了党支部开展党建工作的积极性。</p> <p style=\"text-indent: 2em;\"> “依托记实管理系统，我们可获取全市农村党组织开展党建活动和党员参与党建活动纪实情况的大数据，并通过大数据分析来进行精准施策，精准把控全市农村党组织和党员的工作学习动态，真正让组织生活严起来、实起来。”句容市委常委、组织部长、统战部长蒋建中说道。（句组宣）&nbsp;</p>', 'http://politics.people.com.cn/n1/2018/0612/c1001-30053095.html', '2018-06-12', 'http://politics.people.com.cn/n1/2018/0612/c1001-3', '江苏句容：大数据让“三会一课”严起来', 'http://politics.people.com.cn/n1/2018/0612/c1001-30053095.html', '1528795504');
INSERT INTO `message_news` VALUES ('5', 'T1467284926140', 'News', 'e55df34d6e84c8cf1ff6d44584625192', '<p> 　　<strong>《国际歌》到中国</strong></p> <p> 　　1888年6月16日，工人作曲家皮埃尔·狄盖特为巴黎公社战士、诗人鲍狄埃的诗歌谱好了旋律,《国际歌》诞生。当月23日，里尔工人合唱团在卖报工人集会上，首次演唱了这首歌，引发热烈反响，随即印刷发行了6000份单页歌谱。</p> <p> 　　1923年，瞿秋白从苏联回国，担任《新青年》主编。他在苏联出席了第九次全俄苏维埃大会，见到了列宁。在那个新生的社会主义国家里，他受到了蓬勃发展的各项事业和革命精神的鼓舞。瞿秋白下定决心，要让《国际歌》的中译版在中国广泛流传，成为中国无产阶级革命的一首战歌。当年6月15日，他翻译的中文版《国际歌》发表在《新青年》上。</p> <p align=\"center\" style=\"text-align: center;\"> <img alt=\"\" src=\"http://www.people.com.cn/mediafile/pic/GQ/20180612/35/4297915917384873519.png\" style=\"height: 322px; width: 550px;\" /></p> <p align=\"center\" class=\"pictext\"> 　　瞿秋白翻译的《国际歌》，发表在《新青年》第一期</p> <p> 　　这是一段足以让听者热泪盈眶的华章。有网友评论：当我意志消沉的时候我就听国际歌。当我斗志昂扬的时候我还听国际歌。</p> <p> 　　在中国，也有众多脍炙人口、直击人心的红色经典歌曲。抗日战争背景下的《黄河大合唱》体现了中华儿女保家卫国的英雄气魄；抗美援朝背景下的《我的祖国》在对祖国河山的歌颂中展现了乐观深沉的爱国情怀；新中国万象更新背景下的《歌唱祖国》则咏唱了全国各族人民携手共建美丽祖国的豪迈情怀。这些歌曲都成了久久传唱的经典。</p> <p> 　　<strong>保卫家乡！保卫黄河！保卫华北！保卫全中国！</strong></p> <p align=\"center\" style=\"text-align: center;\"> <img alt=\"\" src=\"http://www.people.com.cn/mediafile/pic/GQ/20180612/42/11913465614120622774.jpg\" style=\"height: 367px; width: 550px;\" /></p> <p> 　　1944年，陕甘宁边区政府交际处赠给国际友人爱泼斯坦的《黄河大合唱》总谱。1981年，由爱泼斯坦捐赠军事博物馆。</p> <p> 　　第一个故事，要从上面这份总谱说起。</p> <p> 　　这份歌曲《黄河大合唱》的总谱，现藏于中国人民革命军事博物馆。1944年6月，国际著名记者、波兰人爱泼斯坦随中外记者团到访延安，从陕甘宁边区政府交际处得到这本总谱。后来，他把这首歌曲带到了美国，并举办了演唱会，《黄河大合唱》的高昂之音传遍海内外。</p> <p> 　　“风在吼、马在叫，黄河在咆哮，黄河在咆哮……”穿越历史时空，当这首歌曲的旋律再次响起时，我们仍然感到热血涌动。</p> <p> 　　《黄河大合唱》是用音乐吹响的警号。</p> <p> 　　1938年，抗日战争正处在危急关头。这一年10月，青年诗人光未然带领着抗敌演剧三队的同志们准备东渡黄河，转入吕梁山抗日根据地。途经壶口瀑布时，光未然被黄河的磅礴气势震撼了。他联想起黄河的船夫拼着性命和惊涛骇浪搏战的情景。这不正反映了中国人民的抗战精神吗？</p> <p> 　　1939年，辗转到达延安的光未然，下定决心要把黄河的精、气、神写进诗中。经过一个月的创作，一首长诗《黄河大合唱》诞生。整诗以黄河为背景,痛斥侵略者的残暴和人民遭受的深重灾难，热情歌颂中华民族源远流长的光荣历史和中国人民坚强不屈的斗争精神，生动地展现了抗日战争的壮丽图景。</p> <p align=\"center\"> <img alt=\"\" src=\"http://www.people.com.cn/mediafile/pic/GQ/20180612/26/7428157065358685466.png\" /></p> <p align=\"center\" class=\"pictext\"> 　　《黄河大合唱》的词作者光未然。资料图片</p> <p> 　　黄河震撼了光未然，光未然的诗也深深打动了作曲家冼星海。</p> <p> 　　在看到诗歌的那一刻，冼星海潜伏许久的创作激情一下子被激发了出来，在延安的窑洞里立刻开始了创作。创作过程中，他常处于一种无法自抑的兴奋状态，脑子里涌动着乐符，轻易不愿意停下来。</p> <p> 　　据冼星海的夫人钱韵玲回忆：早春延安的夜是很冷的，我们用一小盆炭火取暖。我有时看他写累了，就煮一点红枣给他吃。那时候，延安的木炭还是很短缺的，夜深人静时，炭火熄了，窑洞里非常冷，但星海的创作热情却比火焰还要炽热！</p> <p> 　　终于，用了整整6天6夜的时间，冼星海以惊人的速度完成了这部大型音乐作品。《黄河船夫曲》《黄河颂》《黄河之水天上来》《黄水谣》《河边对口曲》《黄河怨》《保卫黄河》《怒吼吧！黄河》8个乐章，汇成了壮丽的交响史诗。</p> <p align=\"center\"> <img alt=\"\" src=\"http://www.people.com.cn/mediafile/pic/GQ/20180612/49/8097657684246681549.png\" /></p> <p align=\"center\" class=\"pictext\"> 　　《黄河大合唱》曲作者冼星海</p> <p> 　　《黄河大合唱》演出后，轰动了整个延安。1939年5月11日，在庆祝鲁迅艺术学院成立一周年的晚会上，毛泽东观看了冼星海亲自指挥的演出，连声称赞。同年7月，周恩来也观看了《黄河大合唱》的演出，并亲笔给冼星海题词：“为抗战发出怒吼！为大众谱出呼声！”</p> <p align=\"center\" style=\"text-align: center;\"> <img alt=\"\" src=\"http://www.people.com.cn/mediafile/pic/GQ/20180612/3/9306202174107352035.png\" style=\"height: 352px; width: 550px;\" /></p> <p align=\"center\" class=\"pictext\"> 　　冼星海指挥延安鲁迅艺术学院学生练唱《黄河大合唱》（1939年）</p> <p> 　　很快，《黄河大合唱》在全国各地广泛流传开来，成为时代的最强音，激励着许多热血青年奔赴抗日战场，对抗日民族解放斗争起了巨大的鼓舞作用。</p> <p> 　　如今，当年激亢高昂的歌声犹在耳畔回响，《黄河大合唱》曲谱上的音符，是中华儿女保卫祖国的一声声呐喊，激荡在每一个中国人心间……</p> <p align=\"center\"> <img alt=\"\" src=\"http://www.people.com.cn/mediafile/pic/GQ/20180612/6/2638225782824296578.png\" /></p> <p> 　　在国内某档综艺节目中，诸多青年偶像参与合唱《黄河大合唱》，在爱国情怀与现场氛围的感染下，不少人流下了热泪。视频截图</p> <p> 　　<strong>这是美丽的祖国</strong></p> <p> 　　第二个故事，要从电影《上甘岭》说起。</p> <p> 　　1956年，一部讲述抗美援朝战争的电影《上甘岭》拍摄完成，导演沙蒙找到熟识的作曲家刘炽，请他为电影创作音乐。刘炽向沙蒙举荐了词作家乔羽，让他来为电影插曲作词。</p> <p> 　　那个时候，为创作一部以第二次国内革命战争时期苏区少年儿童生活为题材的电影文学剧本，乔羽在赣东南、闽西一带原中央苏区体验生活，搜集素材，正处在采访的紧要阶段。然而，沙蒙一封接一封的电报却一直催着乔羽，让他赶往长春电影制片厂，为电影《上甘岭》创作插曲。</p> <p> 　　放不下手头工作的乔羽再三拒绝，没想到却收到了沙蒙一份长达数页的电报。在这份电报中不仅为乔羽安排好了启程的路线，电文最后还一连用了三个“切”字、加三个惊叹号。预感到事情紧急，接到电报的当晚乔羽便连夜出发了。</p> <p align=\"center\"> <img alt=\"\" src=\"http://www.people.com.cn/mediafile/pic/GQ/20180612/27/6881752303917991855.png\" /></p> <p align=\"center\" class=\"pictext\"> 　　《我的祖国》词作者乔羽。资料图</p> <p> 　　到了长春，沙蒙一见到乔羽便把情况和盘托出：为了这首插曲，摄制组停机坐等，即使什么也不干，每天也要耗费2000块钱。沙蒙摆出这一切的意思，是催乔羽快写。</p> <p> 　　乔羽问沙蒙，你认为这首歌应该写成什么样子呢？沙蒙回答说，想怎么写就怎么写，只希望将来这部片子没有人看了，这首歌还有人唱。</p> <p align=\"center\"> <img alt=\"\" src=\"http://www.people.com.cn/mediafile/pic/GQ/20180612/43/6312635426841075167.png\" /></p> <p align=\"center\" class=\"pictext\"> 　　乔羽手迹</p> <p> 　　时间紧迫，乔羽马上要来样片，钻进了长春电影制片厂的小白楼里，翻来覆去看了整整一天。</p> <p> 　　他想到了自己在太行山里经历的3年战争岁月。太行山的生活，既有枪炮相伴的日子，也有欢声笑语，乔羽是最有感受的。他想用这首歌表现战士们在残酷战争面前的镇定、乐观、从容；他想告诉人们，战士们能赢得这场战争不是仅凭血气之勇；他要寻找一个新的角度，这首歌要体现战争，更要体现出战争之后的和平，硝烟弥漫后的江山如画……</p> <p align=\"center\"> <img alt=\"\" src=\"http://www.people.com.cn/mediafile/pic/GQ/20180612/32/17157967840989723848.jpg\" /></p> <p align=\"center\" class=\"pictext\"> 　　乔羽《我的祖国》手迹</p> <p> 　　写歌词的这段时间，长春下了一场大雨。雨过天晴后乔羽在外溜达寻找灵感，忽然，几个雨点打在他的脸上，灵光一闪间一个画面出现在了乔羽的脑海里——一条长而宽广的大河波光流淌，水很清，天很蓝，点点白帆点缀在河面上，一直延伸到天边——那是乔羽去中央苏区江西坐轮渡经过长江时的情景，在北方长大的他第一次见到长江，见到南方鱼米之乡的景象，那个壮观画面他一直不曾忘记……乔羽匆匆赶回房间，拿起笔，“一条大河波浪宽”便从笔尖“流淌”了出来……</p> <p> 　　歌词创作出来了，乔羽拿给沙蒙看。沙蒙一声不吭地看了半个多小时，一拍腿说，“就它了！”乔羽心里想，怎么这么容易，也不讨论讨论？</p> <p> 　　果不其然，第二天沙蒙拿着歌词又回来找乔羽，问乔羽一条大河写的是不是长江。乔羽说是。沙蒙当即反问，既然是长江，为什么不用“万里长江波浪宽”或者“长江万里波浪宽”，那样不是更有气势吗？</p> <p> 　　乔羽说他以前只见过黄河，没见过长江，印象之强烈便引出了这首歌词，但这只是一种引发，不能代替别人的亲身感受。而用‘一条大河’就不同了，每个人心里都会有一条故乡的河，无论将来你到了哪里，想起它来一切都如在眼前。沙蒙思考了片刻，“就它了”，拿起稿子就走。</p> <p> 　　定稿后，沙蒙将歌词交给刘炽，请他谱曲。诗情画意的歌词把刘炽带进一个新境界。怎样才能让全国人民爱唱这首歌呢？刘炽经过调查，统计出1949年至1955年间人们最喜欢的10首歌曲，然后，他把自己关在房子里整整一个星期，一遍遍地唱这10首歌，唱累了就用笛子吹，以分析它们的旋律。</p> <p align=\"center\"> <img alt=\"\" src=\"http://www.people.com.cn/mediafile/pic/GQ/20180612/91/494215241719139083.png\" /></p> <p align=\"center\" class=\"pictext\"> 　　《我的祖国》曲作者刘炽</p> <p> 　　为了防止被干扰，那段时间刘炽不会客，连吃饭都是让人送进屋里，甚至还在门上贴了一个“刘炽死了”的条子。最终，曲谱写成，听者无不叫好。</p> <p align=\"center\"> <img alt=\"\" src=\"http://www.people.com.cn/mediafile/pic/GQ/20180612/86/15523313267233721210.jpg\" /></p> <p align=\"center\" class=\"pictext\"> 　　电影《上甘岭》中《我的祖国》片段截图</p> <p> 　　随后，沙蒙找来民歌歌手郭兰英来演唱歌曲，在中央人民广播电台进行了录音，第二天，电台便播放了这首歌，迅速火遍全国，歌里的“一条大河”成为了人们口口相传的经典——不管你是哪里的人，家门口总会有一条河，河上发生的事情与生命息息相关，寄托着你的喜怒哀乐。只要一想起这条河，就会想到故乡，想到祖国……</p> <p> 　　<strong>从今走向繁荣富强</strong></p> <p align=\"center\" style=\"text-align: center;\"> <img alt=\"\" src=\"http://www.people.com.cn/mediafile/pic/GQ/20180612/92/15024624179988624220.png\" style=\"height: 704px; width: 550px;\" /></p> <p align=\"center\" class=\"pictext\"> 　　《人民日报》刊登的《歌唱祖国》歌词</p> <p> 　　第三个故事，要从上面这份报纸说起。</p> <p> 　　1951年9月15日《人民日报》刊登了一首歌曲《歌唱祖国》的歌词——“五星红旗迎风飘扬，胜利歌声多么响亮；歌唱我们亲爱的祖国，从今走向繁荣富强……”这首歌曲现在仍在广为传唱，表达了中华儿女对祖国繁荣昌盛的深深祝福。</p> <p> 　　说起这首歌曲的创作历程，还要追溯到新中国成立的那一刻。</p> <p> 　　1949年10月1日，毛泽东主席在天安门城楼上正式宣布，中华人民共和国中央人民政府今天成立了！当时，在现场参加开国大典的作曲家王莘热泪盈眶，激动的心情不知该如何表达。回到天津的家后，他告诉妻子王惠芬，自己一定要写一首歌颂祖国的歌，并开始构思，如何将心中的感受用音乐表达出来。</p> <p> 　　转眼一年过去了，1950年国庆节前夕，王莘去北京购买乐器，再次来到天安门广场。此时，广场上已经开始装点准备迎接新中国成立一周年。金色晚霞笼罩着的广场，抬头看，一面鲜红的五星红旗在霞光中高高飘扬；平视四周，鲜花如海，一派热闹非凡的景象，令人心潮澎湃。此情此景，顿时王莘产生了强烈的创作激情，他灵感突现，“五星红旗迎风飘扬，胜利歌声多么响亮；歌唱我们亲爱的祖国，从今走向繁荣富强。”四句歌词，脱口而出。</p> <p align=\"center\"> <img alt=\"\" src=\"http://www.people.com.cn/mediafile/pic/GQ/20180612/57/17048784528668755657.jpg\" /></p> <p align=\"center\" class=\"pictext\"> 　　青年时代的王莘</p> <p> 　　王莘非常兴奋，边走边哼唱，思绪如飞。在从北京回程的火车上，跟着火车行驶的节奏谱起曲来，边唱边写边打拍子，歌词与曲谱几乎同时喷涌而出：“越过高山，越过平原，跨过奔腾的黄河长江……”这首《歌唱祖国》的第一段歌词和曲谱在回津的列车上一气呵成。</p> <p> 　　不知不觉，列车到达天津已经凌晨两点，王莘一口气跑回家，把妻子王惠芬叫起来，在钢琴前弹唱他创作的新歌。王惠芬听完后，情不自禁地叫起好来。于是，王莘连夜写完第二、三段的歌词，并进行了反复修改，很快就完成了整首歌曲。</p> <p align=\"center\"> <img alt=\"\" src=\"http://www.people.com.cn/mediafile/pic/GQ/20180612/89/14670216041848503317.jpg\" /></p> <p align=\"center\" class=\"pictext\"> 　　王莘手稿</p> <p> 　　《歌唱祖国》最初由14岁的钢琴手靳凯华和19岁的男高音王巍弹唱，在耀华中学首演后，又传到天津大学、南开大学。渐渐的，这首歌从天津传到了北京。</p> <p align=\"center\" style=\"text-align: center;\"> <img alt=\"\" src=\"http://www.people.com.cn/mediafile/pic/GQ/20180612/95/364942762757214563.png\" style=\"height: 315px; width: 550px;\" /></p> <p align=\"center\" class=\"pictext\"> 　　1951年全国政协会议上毛泽东为王莘签名</p> <p> 　　1951年国庆前夕，王莘接到从北京打来的电话，中国音乐家协会秘书长孙慎询问他《歌唱祖国》的作者是谁，王莘笑了，说那首歌词曲作者正是自己。</p> <p> 　　9月，《人民日报》《人民文学》相继刊登了《歌唱祖国》的歌词，继而中央人民广播电台播放了中央乐团大合唱《歌唱祖国》，这首歌开始广为流传。</p> <p align=\"center\"> <img alt=\"\" src=\"http://www.people.com.cn/mediafile/pic/GQ/20180612/99/2298555545572348631.png\" /></p> <p align=\"center\" class=\"pictext\"> 　　1965年周总理和群众共同高唱《歌唱祖国》，指挥者为王莘</p> <p> 　　10月，在全国政协会议上，毛泽东主席见到王莘谈到《歌唱祖国》时说：“这首歌好”，并特地送给王莘一本刚出版的《毛泽东选集》并为其签字留念。这本书，王莘一直珍藏着。2007年10月，王莘因病逝世。</p> <p> 　　2008年8月8号晚8时，《歌唱祖国》唱响在北京奥运会开幕式上空，歌声传向了全世界，让全世界见证中国的繁荣昌盛，让全世界倾听全国各族人民为建设美丽祖国而不懈奋斗的心声！</p> <p> 　　2017年6月30日晚，中共中央总书记、国家主席、中央军委主席习近平在香港会展中心观看《心连心·创未来》庆祝香港回归祖国20周年文艺晚会。晚会最后，习近平走上舞台，同主要演职人员一一握手，并同全场一起高唱《歌唱祖国》，祝愿伟大祖国繁荣昌盛，祝福香港明天更加美好。</p> <p align=\"center\" style=\"text-align: center;\"> <img alt=\"\" src=\"http://www.people.com.cn/mediafile/pic/GQ/20180612/4/582253326289095940.png\" style=\"height: 314px; width: 550px;\" /></p> <p> 　　2017年6月30日晚，习近平主席在香港会展中心同全场一起高唱《歌唱祖国》新华社记者马占成摄</p> <p> 　　每一首红色经典歌曲背后，都是创作者们呕心沥血的付出，理应受到尊重，绝不允许任何人去恶搞。近期正式实施的《英烈保护法》对维护社会公共利益，传承弘扬英雄烈士精神，培育和践行社会主义核心价值观将发挥重要作用。最高人民法院日前下发通知要求各级人民法院正确审理涉及保护红色经典传承和英雄烈士合法权益纠纷案件，依法保护红色经典传承和英雄烈士合法权益。恶搞凝结着家国情怀与时代记忆的红色经典歌曲的跳梁小丑，终将受到法律制裁。</p> <p> 　　（整理：档案君）</p> <p> 　　本文档案资料参考自中国人民革命军事博物馆、“不忘初心——马克思主义在中国早期传播陈列”、《光明日报》、新华网、人民网、环球网</p>', 'http://politics.people.com.cn/n1/2018/0612/c1001-30052798.html', '2018-06-12', 'http://politics.people.com.cn/n1/2018/0612/c1001-3', '档案君|耳熟能详的旋律，鲜为人知的故事', 'http://politics.people.com.cn/n1/2018/0612/c1001-30052798.html', '1528795504');
INSERT INTO `message_news` VALUES ('6', 'T1467284926140', 'News', 'fdd99f48200799e261f95807b0988daf', '<p style=\"text-indent: 2em;\"> 人民网沈阳6月12日电（记者何勇）6月11日，辽宁省编制办副主任陈相元介绍，辽宁省直机构公益性659家事业单位，按照政事分开、事企分开、管办分离原则，将相关单位职能相近的该合并合并，整合为65家大型事业单位。</p> <p style=\"text-indent: 2em;\"> 目前，辽宁有事业单位35000余家、事业编制超过110万名。其中，省直公益性事业单位有990家，去掉医疗、高校、地税系统，为659家。长期以来，这些事业单位存在着小、散、弱的特点，特别是随着改革不断深化，政事职责不清，管理体制不顺，生机活力不足，资源配置不合理等问题日益凸显，成为辽宁体制机制不活的重要因素之一。有的名存实亡，有的规模过小，有的重复设置，有的人浮于事，有的与民争利，破坏营商环境。</p> <p style=\"text-indent: 2em;\"> 去年以来，辽宁加大力度加快速度推进事业单位改革，对经营性事业单位应转尽转，对公益性事业单位严格管控。</p> <p style=\"text-indent: 2em;\"> 辽宁此次事业单位改革重点解决“有的人没事干、有的事没人干”的矛盾，释放现有资源的活力。省工信委、省农委、省科技厅等原有30多家事业单位，和经济发展密切相关，却力量分散，难以形成拳头。此次，围绕省委的先进装备制造业基地、重大技术装备战略基地和国家新型原材料基地等五大基地建设目标，整合设置五大服务中心，为五大基地提供服务保障支撑。这五大中心分别是，先进制造业基地建设工程中心，重大技术装备战略基地工程中心、新兴原材料建设工程中心、农委农垦等15家单位组建现代农业生产基地建设工程中心、重要技术创新与研发基地建设工程中心。</p> <p style=\"text-indent: 2em;\"> 跨部门组建整合职能相近部门。这种机构面向社会提供公益服务，分散在多个部门，职责任务内容相似，服务对象差不多，重复设置较多，组建大型综合性事业单位，集中力量、集中资源，统一面向社会提供公益服务。比如20个检验检测单位整合为一个检验检测认证中心；省委党校和社会主义学院、行政学院组建新的省委党校；辽宁日报和党刊集团组建辽宁报刊传媒集团；农业、林业、渔业相关科研机构组建农林科学院。</p> <p style=\"text-indent: 2em;\"> 相关负责人介绍，比如此次新成立的省信息中心，整合了30多家不同省直部门的信息中心。辽宁省直各部门以前几乎家家有信息中心，一共30多家，每家单位都有一班人员、一套系统、一条线路，都重复建设，却又不具备系统开发的技术力量，还要大量外包服务。今后政务信息资源，统一由省信息中心一家建设和维护，大幅压缩机构编制规模、节约资金，提高提供信息服务的专业化水平。省公共资源交易中心也属于此种情况。</p> <p style=\"text-indent: 2em;\"> 辽宁要求经营性事业单位应转尽转。经营性事业单位转企改制组建企业集团，通过依法赋予转制单位法人财产权和经营自主权，实现事企分开，把本应由市场配置资源的经营活动交给市场。前不久，省辽勤、担保、旅游、体育、健康产业等5家企业集团挂牌成立。近两年，全省各市也组建了32家企业集团，资产总额超过2400亿元，涉及事业单位110余家。</p> <p style=\"text-indent: 2em;\"> 2016年以来，全省通过组建企业集团、推动经营性事业单位转企和收空编等一系列措施，共撤销事业单位1171家、收回事业编制15万名。2016年，省政府组建交投、水资源、环保、城乡建设、工程咨询、地矿和粮食等7家企业集团，将原来分散在14个部门的企事业单位近3000亿元资产整合起来，不仅撤销事业单位100多家，收回事业编制1.6万余名，而且实现了经济效益的明显提升。2017年，7家企业集团合计实现营业收入238亿元，同比增长22.6%；实现利润超8亿元，同比增长149.8%。通过改革，既提高了国有资产收益，又减轻了政府偿债压力和财政供养负担，还使职工收入有大幅增长。</p> <p style=\"text-indent: 2em;\"> 前不久，辽宁召开省市县乡四级全覆盖的电视电话会议，吹响了事业单位全面改革攻坚战的冲锋号。辽宁要求7月底前，省直事业单位改革到位。根据安排，改革后，省政府直属部门原则上一家不超过一个事业单位。群团组织的事业单位，此次改革并未涉及，将来根据国家安排一并进行。</p>', 'http://politics.people.com.cn/n1/2018/0612/c1001-30052742.html', '2018-06-12', 'http://politics.people.com.cn/n1/2018/0612/c1001-3', '辽宁：省直659家事业单位整合为65家', 'http://politics.people.com.cn/n1/2018/0612/c1001-30052742.html', '1528795504');
INSERT INTO `message_news` VALUES ('7', 'T1467284926140', 'News', 'c04b109ee5893455fb36bf33f6586f5d', '<p style=\"text-indent: 2em;\"> 开栏的话</p> <p style=\"text-indent: 2em;\"> 没有残疾人的小康，就不是真正意义上的全面小康。改革开放以来，中国残疾人事业取得举世瞩目的成就。目前，有数十部法律作出具体规定，保障残疾人在康复、就业、社保、参与公共事务和社会生活等方面的权利。</p> <p style=\"text-indent: 2em;\"> 如何让残疾人的生活更便利、更精彩？如何帮助残疾人更好地就业？在康复治疗、集中托养等方面，残疾人的权益又该如何保障？即日起，本版推出“关爱残疾人”系列报道，为读者介绍一些地方的好做法、好经验。</p> <p style=\"text-indent: 2em;\"> 6月1日儿童节，在云南昆明五华区新萌学校，一群可爱的孩子正翩翩起舞，尽显童趣。他们动作并不整齐，但脸上的自信和快乐感染着现场每一个人。</p> <p style=\"text-indent: 2em;\"> 新萌学校是一所全日制智力障碍特殊教育机构，受到了来自地方政府、社会志愿者的关爱与帮助。为了让这群特殊的孩子健康成长，各界联手付出了辛勤的努力。</p> <p style=\"text-indent: 2em;\"> 新萌学校的发展是云南扶残助残工作的缩影。量身定做的志愿服务、智能化的科技产品、多元化的文化活动……云南通过一系列方式，聚集起关爱残疾人的社会力量，形成扶残助残的良好风尚。</p> <p style=\"text-indent: 2em;\"> <strong>为近万户残疾人家庭实施无障碍改造</strong></p> <p style=\"text-indent: 2em;\"> 这天，家住云南昆明金马东华小区的老人杜福喜，迎来了官渡区残联上门服务的志愿者。</p> <p style=\"text-indent: 2em;\"> 杜福喜今年95岁，有肢体残疾，长期借助轮椅代步。因为家庭贫困，老人的轮椅已长时间未经更换。器具的老化，给老人的行动带来很大不便。</p> <p style=\"text-indent: 2em;\"> 借助官渡区残联“流动服务车”这个品牌，志愿者们根据行动不便的残疾人所提出的需求，为他们提供入户帮助，并在调研之后免费发放辅助器具。“我们发放的主要有电动轮椅、电动三轮车、拐杖等。这些都是残障人士最迫切需要的。”官渡区残联有关负责人说。</p> <p style=\"text-indent: 2em;\"> 针对不同情况，各地志愿者纷纷行动。官渡区残联对疑似残障儿童进行免费精准筛查，已输送62名残障儿童进入市残联认证过的康复机构，为他们提供手术治疗和康复训练；五华区残联以“防聋治聋&nbsp;精准服务”为主题，开展义诊活动和爱耳宣传；每个月，云南财经大学会计学院的大学生志愿者都会到新萌学校，教特殊儿童写字、画画。</p> <p style=\"text-indent: 2em;\"> 为了让残疾人生活得更便利，从2011年起云南省启动了贫困残疾人家庭无障碍改造工程。</p> <p style=\"text-indent: 2em;\"> “现在家里装了无障碍扶手和坐便器，房子也粉刷了，不只方便，也干净、整洁了。”家住昆明五华区眠山社区的曾玲（化名）说，因为自己患有小儿麻痹，日常起居十分困难，因此改造时选择了这个方案。</p> <p style=\"text-indent: 2em;\"> 闪光门铃、扶手抓杆、低位灶台、多功能床……五华区残联理事长陈永谦介绍，残疾人家庭无障碍改造，都是由残联志愿者入户调查，根据残疾人具体居家需求和意愿而量身定做的，以满足残疾人的日常所需，提高他们的生活质量。</p> <p style=\"text-indent: 2em;\"> 截至去年，云南省共投入资金近6000万元，为近万户贫困残疾人家庭实施了无障碍设施改造。今年，还将有2500多户贫困残疾人家庭受惠于这项工程。</p> <p style=\"text-indent: 2em;\"> <strong>助盲耳机会读报，智能手表能求救</strong></p> <p style=\"text-indent: 2em;\"> “在您面前的是一位20多岁，穿着红色上衣、蓝色裤子，微笑着的女性。”Eye&nbsp;See视障人智能助盲耳机发出了上述提示。</p> <p style=\"text-indent: 2em;\"> 在昆明理工大学城市学院的电子创新实验室里，不少慕名而来的盲人正在试用这款智能助盲耳机。“它可以提醒我现在的环境，还能通过语音辅助我读书看报，解决了生活中的难题。”一位试用者说。</p> <p style=\"text-indent: 2em;\"> 这款耳机由昆明理工大学Eye&nbsp;See团队设计研发，目前已开发出人脸识别、体貌特征识别、场景识别、文字识别和智能避障等功能。“它利用图像识别、语音交互、激光测距等技术，并结合人工智能，来帮助盲人感受世界。”团队指导老师胡寅介绍。</p> <p style=\"text-indent: 2em;\"> Eye&nbsp;See耳机只是昆明理工大学针对残障人士研发的智能产品之一。早在3年前，昆明理工大学就设计出一款智能手表，主要解决听障人士与常人交流的问题：听障人士在手表上输入想说的话，能转换成语音；常人的语音，则会转换成文字，显示在手表上。</p> <p style=\"text-indent: 2em;\"> “这款手表具有便签、翻译、语音识别、实时字幕等功能。”胡寅介绍，“最关键的是，这款手表还有警示提醒和急救定位功能：可以通过分贝频率、声纹识别等判断和检测外界的信号，提醒听障人士附近环境有危险；当听障人士发出求救信息时，手表也会将精准的地理位置发送到亲友的手机上。”</p> <p style=\"text-indent: 2em;\"> 智能助残产品的研发都是经过了无数次试用、沟通、升级而来的。以Eye&nbsp;See耳机为例，“耳机的前身是一个智能头盔。但盲人朋友们试用过后，觉得不够轻便，又在头盔的基础上进行改良，才有了现在的智能耳机。”胡寅说，“针对残障人士的产品设计，必须要更多地考虑他们真正的生活需求和实际体验。”</p> <p style=\"text-indent: 2em;\"> 这些智能产品的成本一般控制在500元以内。“在市场推广上，尚有一定难度。希望有更多的社会力量给予关心和支持。”胡寅表示。</p> <p style=\"text-indent: 2em;\"> <strong>残疾人投身公益，能领爱心奖励卡</strong></p> <p style=\"text-indent: 2em;\"> “参加社会活动，还能到超市兑换生活品，动力更足了。”在五华区残疾人爱心超市，残疾人吴苹凭着爱心奖励卡，领取了菜籽油、洗衣粉和香皂等价值150元的物品。这张爱心奖励卡是她积极参加“美丽春城、清洁昆明”志愿活动所得来的。</p> <p style=\"text-indent: 2em;\"> 为了动员残疾人参加社区公益活动，五华区对积极投身公益活动的残疾人先进分子进行奖励。爱心奖励卡分为50分、100分、150分等不同档次，获奖人员可以凭卡到爱心超市领取物品。</p> <p style=\"text-indent: 2em;\"> 陈永谦介绍，除了爱心奖励，残联每年都会积极组织趣味运动会、文艺汇演，让辖区内的残疾人参与进来。“通过号召残疾人参加力所能及的体育活动、文艺表演，让大家自尊自强，获得幸福感、归属感。”</p> <p style=\"text-indent: 2em;\"> 双眼弱视的闫阿姨在退休后，凭着毅力把乒乓球重新练了起来，还在运动会上大展风采。“在这里，我遇到了很多志同道合的好朋友。”闫阿姨说，“参加比赛让我找回了自信，觉得自己还是很有价值的。”</p> <p style=\"text-indent: 2em;\"> 在五华区残疾人文化体育活动中心，残疾人书法绘画培训室、视听室等处经常热闹非凡。“周边的残疾人组织或家属，经常到教室组织各种活动。我们要做的是为他们提供活动场所和展示空间。”陈永谦说。</p> <p style=\"text-indent: 2em;\"> 不久前，在官渡区社区里，举行了一场别开生面的残疾人知识竞赛。各位选手精心准备，来自矣六街道的居民李玮答题时势如破竹，赢得了本次“学习之星”的称号。在活动间隙，残障朋友们还为大家表演了手鼓、黄梅戏等节目。</p> <p style=\"text-indent: 2em;\"> “不仅要满足残疾人朋友的生活需求，更要满足他们的文化需求。”官渡区残联有关负责人说，“这样才能让他们敞开心扉，融入社会大家庭中。”</p> <p style=\"text-indent: 2em;\"> ■链接</p> <p style=\"text-indent: 2em;\"> <strong>内蒙古推进无障碍环境建设</strong></p> <p style=\"text-indent: 2em;\"> 本报呼和浩特6月11日电&nbsp;（记者张枨）11日，记者从内蒙古自治区政府召开的吹风会上获悉：为推动内蒙古无障碍环境建设，规范无障碍设施的管理和使用，新修订的《内蒙古自治区无障碍环境建设办法》（以下简称《办法》）将于今年7月1日起施行。</p> <p style=\"text-indent: 2em;\"> 新修订的《办法》明确规定了无障碍环境建设的内容，将无障碍环境建设界定为：为便于残疾人、老年人、伤病患者、孕妇和儿童等社会成员自主安全地通行道路、出入相关建筑物、搭乘公共交通工具、交流信息、获得社区服务所进行的建设活动。</p> <p style=\"text-indent: 2em;\"> 《办法》明确规定了各级政府及其部门在无障碍环境建设工作中的职责分工及无障碍设施建设的要求和标准。城镇新建、改建、扩建的道路、城市广场、城市绿地、公共交通设施、居住建筑应当符合无障碍设施工程建设标准。设计、施工、监理、验收要严格按照无障碍建设标准进行，符合安全、适用和便利要求。</p> <p style=\"text-indent: 2em;\"> <span id=\"paper_num\" style=\"text-indent: 2em; display: block;\">《 人民日报 》（ 2018年06月12日 13 版）</span></p>', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051999.html', '2018-06-12', 'http://politics.people.com.cn/n1/2018/0612/c1001-3', '让残疾人生活更便利（民生调查·关爱残疾人①）', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051999.html', '1528795504');
INSERT INTO `message_news` VALUES ('8', 'T1467284926140', 'News', 'bb7eb0e95592da239716c07786d27428', '<p style=\"text-indent: 2em;\"> 广西南宁市长湖立交桥下，一间不大的平房里，20多名外卖配送员坐成几排，两名交警正讲解注意事项。而后，配送员在手中的《交通安全事前信用承诺书》上，签下名字。承诺书一式三份，其中一份由交警部门留存。</p> <p style=\"text-indent: 2em;\"> 当下，外卖送餐越来越多，配送员骑行不规范也带来各种安全隐患，日前，公安部出台《关于警企共治创新外卖行业电动自行车交通违法治理工作的通知》，部署各地公安交管部门加强警社合作、警企共治。</p> <p style=\"text-indent: 2em;\"> 南宁市交警与外卖企业合作，实施准入培训、信用惩戒和制定文明骑行公约等具体措施，试图破解外卖骑行交通违法难题。规定施行以来，效果如何，有哪些经验值得借鉴？</p> <p style=\"text-indent: 2em;\"> <strong>外卖违规骑行常发</strong></p> <p style=\"text-indent: 2em;\"> <strong>配送员屡罚屡犯，亟待加强规范管理</strong></p> <p style=\"text-indent: 2em;\"> 中午，正值外卖订单高峰期，配送员小李手里有7个订单，取餐的店里顾客很多，出餐慢，客户着急，小李也着急。取餐后为了尽快送到，他只好开足马力，一骑绝尘。电动车骑得飞快不说，小李和他的同事们还边骑行边看手机，手动“抢单”，一旦平台发布新订单，谁抢到算谁的，送得快，抢得多，赚钱自然也多。</p> <p style=\"text-indent: 2em;\"> 一个中午，小李逆行一次，违规变道了两次，停放也不太注意位置，曾经，这是“小李”们的工作常态。</p> <p style=\"text-indent: 2em;\"> “南宁的电动车数量多，下班高峰期很拥挤，一次我下班骑车回家，旁边一辆外卖电动车骑得飞快，可能嫌非机动车车道堵，还一下子窜到了机动车道上，差点被后面开来的一辆汽车撞上，特别危险。”南宁市民黄先生回忆当时的情景，不免为外卖配送员捏了一把汗。</p> <p style=\"text-indent: 2em;\"> 外卖配送员守法意识、安全意识参差不齐，闯红灯、逆行、违反标志标线指示、随意变更车道、乱停放等现象屡屡发生，外卖送餐交通安全问题已成为城市治理的痛点。</p> <p style=\"text-indent: 2em;\"> 南宁市交警支队一大队副大队长莫民超说：“有一次我在路口巡查，看到有位外卖配送员逆行，立即拦住他进行教育处罚。一查记录才发现，这段时间他已经因为交通违法被处罚5次了，每次都是简单接受了半小时学习教育。因为违规成本较低，他屡教不改。”</p> <p style=\"text-indent: 2em;\"> 外卖骑行同样关乎企业形象，配送员的服装和车尾送餐箱都印有外卖企业标识，如果扰乱交通秩序也会损害企业形象。因此，外卖送餐企业也需要加强规范管理。</p> <p style=\"text-indent: 2em;\"> <strong>警企联合信用惩戒</strong></p> <p style=\"text-indent: 2em;\"> <strong>将制定外卖配送员安全记分管理办法</strong></p> <p style=\"text-indent: 2em;\"> 2018年4月，南宁市公安局交警支队与外卖企业美团外卖正式签订战略合作协议，联合实施准入培训、信用惩戒等12项具体措施，规范和加强外卖送餐电动车的通行管理。</p> <p style=\"text-indent: 2em;\"> “我们建立三级沟通协调机制：交警支队与美团外卖南宁专送渠道团队对接、交警大队与片区配送站对接、交警中队岗组与企业维护岗对接，明确各层级的对接负责人，通过印发通讯录、建立微信群等方式沟通协调。”&nbsp;南宁市公安局交警支队副支队长罗义学介绍。</p> <p style=\"text-indent: 2em;\"> 同时，各层级定期相互通报情况，实时响应需求，提高双方沟通协调和处置问题的效率。南宁交警支队秩序科长梁宇新说，微信群是一个微型协作平台，同时，还是一个宣传平台，近期交通管理重点、突出的交通违法和安全事故案例、需要宣教的文明出行要求等，都会通过微信群传递到每一个站点和外卖配送员。“我们双方会定期交换配送员、配送车辆的交通违法和事故等数据，企业会提供骑行送餐的热力图分析，通过在线交互和实时推送，及时发现隐患，迅速整治乱象。”梁宇新说。</p> <p style=\"text-indent: 2em;\"> 合作协议中还明确：“凡在南宁片区申请成为美团外卖配送员的，需先做出配送期间遵守道路交通安全法律法规的事前信用承诺，并经联合审核，方可准入。”通过审核后，“准配送员”还要以交通安全志愿者身份参与一次路口执勤，才能成为正式配送员。</p> <p style=\"text-indent: 2em;\"> 对于配送员的交通违法行为，交警处理完，企业也要处理，实施联合惩戒，并将其纳入社会信用体系。“肇事逃逸扣36分，逆向行驶扣12分……”在企业的安全记分管理办法初稿中，机动车违规与处罚措施挂钩，分数扣光则会被拉黑辞退，分数偏低则需参加交通安全学习。目前，警企双方正在讨论制定最终稿。</p> <p style=\"text-indent: 2em;\"> <strong>信息互通促管理升级</strong></p> <p style=\"text-indent: 2em;\"> <strong>交警精准整治，企业合理调度，推动行业自律</strong></p> <p style=\"text-indent: 2em;\"> “骑车路过之前站过岗的交通路口，就能想起当时自己也在那儿指挥过交通。”配送员梁守宇说，“在路口体验站岗执勤后，从交警的角度更能体会违法行为的严重性。”</p> <p style=\"text-indent: 2em;\"> 南宁交警七大队中队长洪基清说：“我们跟辖区的配送站点建立联系后，管理和宣传教育针对性更强。”平日里，交警会定期对配送员进行交通安全培训教育。平台也会给外卖配送员100%推送交警部门制作的电动车安全规范课件。每日晨会，配送站还会进行交通安全骑行宣教。“现在辖区的外卖电动车交通违法行为少了一大半。”洪基清说。</p> <p style=\"text-indent: 2em;\"> 在警企合作中，双方也尝试相互提供便利服务支持。南宁市青秀区某购物中心地处繁华商业街区，每逢用餐时间，外卖电动车就蜂拥而至，购物中心不允许外卖电动车在门前停放，配送员为了尽快取餐送餐，经常把电动车停在非机动车道上，既干扰交通秩序，也增加安全风险。了解这一情况后，南宁交警居中协调，促成购物中心与外卖企业协商。不久前，购物中心设置了两个停放点共60个车位，专门供外卖电动车停放，问题得到妥善解决。</p> <p style=\"text-indent: 2em;\"> 通过警方的及时反馈，企业内部管理也不断升级。现在，美团外卖升级智能调度体系，精准派单，逐步取消“平均送达时长”等考核指标，改变了“有单赶紧抢、送餐拼命骑”的局面，同时正在试点配送员蓝牙耳机接单模式，避免配送员骑行时操作手机带来危险。</p> <p style=\"text-indent: 2em;\"> 据了解，南宁交警正在与饿了么等多家外卖企业积极沟通，努力将警企合作拓展为警方与整个外卖行业合作。同时，交警还联合企业共同制定了外卖电动自行车配送员文明骑行公约，号召外卖行业企业参与公约履行，共同推动形成行业自律。</p> <p style=\"text-indent: 2em;\"> 南宁市公安局交警支队支队长蒋卫红说：“解决交通安全问题，不能只靠交警强力整治，必须树立共建共治共享新理念，多角度、多层次强化警社合作、警企共治，实现监管部门的依法治理与行业、企业自律管理相结合。”</p> <p style=\"text-indent: 2em;\"> <span id=\"paper_num\" style=\"text-indent: 2em; display: block;\">《 人民日报 》（ 2018年06月12日 11 版）</span></p>', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051984.html', '2018-06-12', 'http://politics.people.com.cn/n1/2018/0612/c1001-3', '外卖送餐 拼快更要拼安全', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051984.html', '1528795504');
INSERT INTO `message_news` VALUES ('9', 'T1467284926140', 'News', '76807aae6a379ccdb4e23259edb49bb3', '<p style=\"text-indent: 2em;\"> 本报南宁6月11日电&nbsp;&nbsp;（庞革平、甘孝雷）日前，广西壮族自治区工商局印发《广西“智慧工商”建设方案》，以信息化驱动市场监管现代化为主线，积极加快推进工商和市场监管创新，运用新思维、新技术、新模式，打造智慧工商和市场监管，进一步优化营商环境，更好地服务群众，助推经济社会发展。</p> <p style=\"text-indent: 2em;\"> 建设一个基础支撑平台。建成广西工商数据服务平台，汇聚工商内部各业务系统以及其他委办局的涉企信息，为各级党委和政府部门提供数据汇集、统计分析、数据存储等功能；建设国家法人基础信息库（广西），升级改造网上办事、信息公示等公共服务平台；完成应用系统灾备设备采购项目建设，为信息化建设提供基础资源保障。</p> <p style=\"text-indent: 2em;\"> <span id=\"paper_num\" style=\"text-indent: 2em; display: block;\">《 人民日报 》（ 2018年06月12日 10 版）</span></p>', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051975.html', '2018-06-12', 'http://politics.people.com.cn/n1/2018/0612/c1001-3', '广西推进智慧工商建设', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051975.html', '1528795504');
INSERT INTO `message_news` VALUES ('10', 'T1467284926140', 'News', '18eb52e59088db0bfe739389e9045cd4', '<p style=\"text-indent: 2em;\"> 本报沈阳6月11日电&nbsp;&nbsp;（记者何勇）记者从11日在沈阳举行的辽宁—中东欧国家经贸友好合作推介会获悉：辽宁目前正在建设“16+1”经贸合作示范区，积极推动包括中国与中东欧国家间合作等众多开放平台和合作机制落户辽宁。</p> <p style=\"text-indent: 2em;\"> 此外，大连将推动中国—中东欧（大连）先进制造产业园和大连天呈（捷克）工业园搭建双向投资平台，并计划在大连达沃斯会议期间面向中东欧企业进行重点经贸交流合作，在软交会设立“中东欧主题日”。营口市将继续推动在罗马尼亚和塞尔维亚的工业园建设，结合区域性国际物流中心建设推动中欧班列集结中心建设，逐步提高中欧班列的开行数量。</p> <p style=\"text-indent: 2em;\"> 2017年，辽宁对中东欧国家进口额为14亿美元，同比增长38%；出口额为6.3亿美元，同比增长21%；完成中欧班列1143列次，集装箱货运量9.2万标准箱。2018年，辽宁加快对外开放，辽宁自由贸易试验区是辽宁对外开放的新平台和新引擎，包括沈阳、大连、营口3个片区，从去年4月1日设立以来，已新增注册企业2.5万家，注册资本3700亿元，其中外资企业331户，注册资金69.4亿美元。</p> <p style=\"text-indent: 2em;\"> 据悉，中国—中东欧“16+1”经贸合作示范区，是2012年4月由中国与中东欧地区16国共同创建的跨区域合作平台。</p> <p style=\"text-indent: 2em;\"> <span id=\"paper_num\" style=\"text-indent: 2em; display: block;\">《 人民日报 》（ 2018年06月12日 10 版）</span></p>', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051974.html', '2018-06-12', 'http://politics.people.com.cn/n1/2018/0612/c1001-3', '辽宁推动“16+1”经贸合作示范区建设', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051974.html', '1528795504');
INSERT INTO `message_news` VALUES ('11', 'T1467284926140', 'News', '85661edf077f78aa85d7fab5fc3687c4', '<p style=\"text-indent: 2em;\"> 本报北京6月11日电&nbsp;&nbsp;（记者王观）根据中国人民银行此前发布的《中国人民银行关于试点取消企业银行账户开户许可证核发的通知》要求，11日起，在江苏省泰州市及下辖县（市、区）、浙江省台州市及下辖县（市、区）开展取消企业银行账户开户许可证核发的试点工作，试点地区人民银行分支机构对银行为企业开立基本存款账户由核准制调整为备案制。</p> <p style=\"text-indent: 2em;\"> 根据《通知》要求，试点地区银行按规定审核企业身份、开户意愿真实性以及基本存款账户唯一性后，为符合条件的企业开立基本存款账户。该账户后续办理变更、撤销业务也由核准制调整为备案制，无需经人民银行分支机构核准。</p> <p style=\"text-indent: 2em;\"> 《通知》还指出，加强事前事中事后管理。试点地区银行为企业开立基本存款账户实行面签制度；与企业签订账户管理协议进一步明确双方权利、义务和责任；强化基本存款账户向个人银行结算账户支付款项管理，健全企业重要信息发生变化未办理变更、证件到期未更换、不配合对账、账户连续一年未发生收付活动等异常情形处置机制。</p> <p style=\"text-indent: 2em;\"> 据悉，此次试点业务处理分为两个阶段，自6月11日起为第一阶段，第二阶段自12月1日起，试点地区银行为企业开立基本存款账户时，除按照第一阶段业务处理办法执行外，增加完善账户管理协议、增加身份验证方式、加强“公转私”管理、健全异常情况处理机制、加强销户管理等试点内容。</p> <p style=\"text-indent: 2em;\"> <span id=\"paper_num\" style=\"text-indent: 2em; display: block;\">《 人民日报 》（ 2018年06月12日 10 版）</span></p>', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051973.html', '2018-06-12', 'http://politics.people.com.cn/n1/2018/0612/c1001-3', '央行试点企业银行账户备案制', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051973.html', '1528795504');
INSERT INTO `message_news` VALUES ('12', 'T1467284926140', 'News', '501be72e7ebe727bfd992f6a58c33e1f', '<p style=\"text-indent: 2em;\"> 本报福州6月11日电&nbsp;&nbsp;（记者何璐）记者日前从福建省人社厅获悉：从2015年至今，福建每年遴选一批技术水平高、创新能力强、发展潜力大的互联网经济优秀人才创业项目，按重点项目、优秀项目、入选项目三类，分别给予100万元、50万元、30万元的创业资金支持。3年来，共安排扶持资金5810万元，对120个互联网经济优秀创业人才（团队）和项目予以资金扶持。</p> <p style=\"text-indent: 2em;\"> 近日，福建省人社厅公布2017年互联网经济优秀人才创业启动支持对象名单，确定高钦泉等50人（团队）及其项目为支持对象，并按规定给予创业资金支持。据悉，此次申报人数由2015年的80人、2016年的99人上升到2017年的179人，同比增长80%；支持资金总数由2015年的1730万元、2016年的1980万元增加到2017年的2100万元。</p> <p style=\"text-indent: 2em;\"> <span id=\"paper_num\" style=\"text-indent: 2em; display: block;\">《 人民日报 》（ 2018年06月12日 09 版）</span></p>', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051957.html', '2018-06-12', 'http://politics.people.com.cn/n1/2018/0612/c1001-3', '福建扶持互联网经济人才创新创业', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051957.html', '1528795504');
INSERT INTO `message_news` VALUES ('13', 'T1467284926140', 'News', 'a56c1ff61331c33c24046a31d6866e6a', '<p style=\"text-indent: 2em;\"> 本报北京6月11日电&nbsp;&nbsp;（记者杨昊）全国工商联11日召开“工商联系统援藏援疆电视电话动员会”，部署“精准扶贫西藏行”和“光彩事业南疆行”工作任务，助力西藏地区和新疆南疆四地州打赢脱贫攻坚战。全国政协副主席、全国工商联主席高云龙出席会议并讲话。</p> <p style=\"text-indent: 2em;\"> 高云龙指出，组织民营企业参与援藏援疆，是工商联学习贯彻习近平新时代中国特色社会主义思想的重要内容。各级工商联要通过“万企帮万村”行动领导小组的工作机制和平台，将民营企业的帮扶力量引入深度贫困地区。各对口支援省市工商联要将援藏援疆工作纳入重要议事日程，建立工作机制，细化量化目标任务，抓好工作督促落实。要在做好项目推介和精准对接基础上，着力加强对项目落地的跟踪服务。要注重宣传表彰，激发和带动民营企业参与援藏援疆的热情，传递民营企业正能量。</p> <p style=\"text-indent: 2em;\"> <span id=\"paper_num\" style=\"text-indent: 2em; display: block;\">《 人民日报 》（ 2018年06月12日 09 版）</span></p>', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051956.html', '2018-06-12', 'http://politics.people.com.cn/n1/2018/0612/c1001-3', '全国工商联召开电视电话动员会 助力西藏新疆打赢脱贫攻坚战', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051956.html', '1528795504');
INSERT INTO `message_news` VALUES ('14', 'T1467284926140', 'News', 'e1e78d2aa854f55d5cd5e37a06b224fe', '<p style=\"text-indent: 2em;\"> 本报合肥6月11日电&nbsp;&nbsp;（记者孙振）安徽省与上海市、江苏省和浙江省近日签署了《长三角地区打通省际断头路合作框架协议》，明确将按“规划明确、需求对接、就近接入、先易后难”的总体原则，根据地区经济发展、交通需求、路网规划和前期方案成熟度，共同全面推进省际对接道路各项工作。优先确保高速公路、国道骨干路网建设项目的全面连通，重点实施在省界处未连通的断头道路以及现已连通但省界处存在瓶颈的道路。</p> <p style=\"text-indent: 2em;\"> 根据协议安排，三省一市将分批制定项目计划。第一批优先安排双方对接意愿强烈、规划方案一致、建设规划明确、交通作用明显且对路网完善有积极作用的项目。后续将结合省界处重点地区经济社会发展情况，共同协商，做好项目前期工作和项目储备，落实项目规划、建设计划，滚动推进建设，实现省际断头路全面对接。三省一市约定，共同推进前期审批工作，细化工程施工配合。同时还将加强后期养护管理，确保省际道路“畅、安、舒、美”。</p> <p style=\"text-indent: 2em;\"> <span id=\"paper_num\" style=\"text-indent: 2em; display: block;\">《 人民日报 》（ 2018年06月12日 09 版）</span></p>', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051955.html', '2018-06-12', 'http://politics.people.com.cn/n1/2018/0612/c1001-3', '长三角地区将合力打通省际交通瓶颈', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051955.html', '1528795504');
INSERT INTO `message_news` VALUES ('15', 'T1467284926140', 'News', '7f2290b96aaa085061ce418bd003121c', '<p style=\"text-indent: 2em;\"> 本报南京6月11日电&nbsp;&nbsp;（记者姚雪青）近日，一起典型的民商事案件在江苏省泰州市海陵区法院审理。当地部分人大代表、政协委员受邀观摩庭审、进行监督。和以往不同的是，现在他们可以在自己的办公室里通过观看视频直播的方式，实时进行远程观摩，不需要再到海陵法院庭审现场旁听了。</p> <p style=\"text-indent: 2em;\"> 这是江苏法院庭审直播的一个缩影。截至今年5月底，江苏法院共在中国庭审直播网上直播案件282526场，占全国直播总数的29.1%，直播数量位居全国首位；在全国庭审直播数量前20名的基层法院中，有15家法院为江苏地区的基层法院，其中泰州兴化市人民法院直播数量总计4985件。</p> <p style=\"text-indent: 2em;\"> “庭审直播可以保障人民群众对司法审判的知情权、监督权，同时也有助于推进以审判为中心的诉讼制度改革，帮助法官排除内外干扰，依法审慎地行使审判权、依法规范地行使自由裁量权，提高裁判的公正性。”江苏省高院审管办主任刘坤介绍，江苏法院庭审直播工作从2011年起步，首先在全省有条件的法院实现庭审过程互联网同步直播，后逐步向全省各级法院推开。2012年建成“江苏法院庭审直播网”，实现全省法院庭审直播“统一播出、统一回放、统一管理”，此后，通过信息技术不断升级，全面覆盖手机移动终端观看，并在省内各法院逐步推广。2016年，江苏法院在全国率先实现全省123家法院全部接入中国庭审公开网。</p> <p style=\"text-indent: 2em;\"> 今年3月下旬，江苏省高院下发了《江苏省高级人民法院关于全面开展庭审网络直播工作的通知》，要求全省各级法院“以直播为原则、不直播为例外”，全面推进庭审直播，实现所有案件、所有法官、所有法庭全覆盖。</p> <p style=\"text-indent: 2em;\"> 那么，“例外情况”有哪些呢？《通知》也做了明确规定，依法不公开审理案件以及离婚诉讼或者涉及未成年子女抚养、监护等5类不宜扩大受众范围的公开审理案件，不进行庭审网络直播。</p> <p style=\"text-indent: 2em;\"> 实践表明，网上庭审直播的普及不断推动案件审理过程的公开化、透明化，提高了案件的服判息诉率，减少了纠纷处理时间。在“全国庭审直播优秀法院”淮安中院，全部法庭都安装了庭审直播设施。该院民一庭书记员宋诚坦言，庭审直播不仅规范了法官、书记员、法警等司法人员的庭审行为，进一步促进了庭审规范化、提升了司法形象，同时，也规范了当事人的庭审行为，有效预防了“庭闹”等行为发生。</p> <p style=\"text-indent: 2em;\"> 记者在采访中了解到，为了吸引更多公众收看和互动，各地法院会定期组织学校、公务员、行业部门集中收看有关青少年犯罪、职务犯罪、合同纠纷类案件等的庭审直播。类似的“法治公开课”成为“谁执法谁普法”的生动方式，起到了以案释法和警示教育作用。下一步，江苏法院将增加庭审直播互动环节和互动方式，以提高庭审直播的社会知晓度。</p> <p style=\"text-indent: 2em;\"> 刘坤介绍，江苏高院已将庭审直播工作纳入对中级人民法院工作综合考评，各级法院将直播情况作为审判业务部门、法官业绩考核的重要内容，并纳入院纪检监察部门审务督察、巡察范围。今年7月1日以后，江苏高院评选的优秀庭审必须是庭审直播的案件。</p> <p style=\"text-indent: 2em;\"> <span id=\"paper_num\" style=\"text-indent: 2em; display: block;\">《 人民日报 》（ 2018年06月12日 09 版）</span></p>', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051954.html', '2018-06-12', 'http://politics.people.com.cn/n1/2018/0612/c1001-3', '江苏法院庭审网络直播成常态', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051954.html', '1528795504');
INSERT INTO `message_news` VALUES ('16', 'T1467284926140', 'News', '82024513b5e4df55c68d66f0d991a4cd', '<p style=\"text-indent: 2em;\"> 本报沈阳6月11日电&nbsp;&nbsp;（记者刘洪超）记者从辽宁省防汛抗旱指挥部获悉：针对今年汛期形势，辽宁省安排部署多项防汛准备工作，共储备4.24亿元的各类防汛抗旱物资，用以安全度汛。</p> <p style=\"text-indent: 2em;\"> 辽宁省防汛抗旱指挥部目前已完善了与辽宁省军区、武警辽宁省总队的协调联络机制。全省储备各类防汛抗旱物资总价值4.24亿元，分储在2个省级仓库、8个定点仓库（6个市级、2个县级）和40个县级仓库、812个乡镇、13支抢险应急分队和9个省直水库，形成了布局合理、调用快捷的省级防汛抗旱物资保障体系。</p> <p style=\"text-indent: 2em;\"> 据辽宁省气象部门预测分析，今年气象年景总体偏差。针对这一特点，辽宁省防汛抗旱指挥部科学研判防汛抗旱形势，提早进行安排部署，落实了以行政首长负责制为核心，覆盖省、市、县、乡、村，4万多人组成的防汛抗旱责任网络，落实了9900名村级水管员、1370名小型水库库管员的防汛职责和培训工作，进一步提升基层防汛抗旱的组织能力和应对能力。</p> <p style=\"text-indent: 2em;\"> 另外，辽宁积极开展汛前检查，对雨水情测报设备、防汛网络线路、视频会议系统、视频监控系统进行了专项排查维修，逐项排除故障隐患，确保雨水情监测、数据传输顺利进行。目前，辽宁55个受山洪灾害威胁的县完成了非工程措施平台建设，能够有针对性和科学性地对洪涝灾害的防御工作进行指挥调度和应急决策。</p> <p style=\"text-indent: 2em;\"> 据辽宁省防汛抗旱指挥部办公室介绍，面对今年复杂多变的防汛形势，辽宁要求各地科学制定群众逃避险预案。根据预警预报情况，及时启动应急响应，当洪水来临或灾情出现时，能够做到第一时间由各级干部引领受威胁地区群众到既定的安置地点转移避险。</p> <p style=\"text-indent: 2em;\"> <span id=\"paper_num\" style=\"text-indent: 2em; display: block;\">《 人民日报 》（ 2018年06月12日 04 版）</span></p>', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051932.html', '2018-06-12', 'http://politics.people.com.cn/n1/2018/0612/c1001-3', '辽宁储备4.24亿元物资用于度汛', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051932.html', '1528795504');
INSERT INTO `message_news` VALUES ('17', 'T1467284926140', 'News', 'e4637cf54eabb83532415cd3689e342a', '<p style=\"text-indent: 2em;\"> 本报南昌6月11日电&nbsp;&nbsp;（记者魏本貌）江西近日启动实施传统产业优化升级三年行动计划，到2020年，重点传统产业的主导产品和主流技术总体上达到国内先进水平。</p> <p style=\"text-indent: 2em;\"> 江西将以有色、石化、钢铁、建材、纺织、食品、家具、船舶等八个产业为重点，推进实施技术创新、技术改造、数字化、绿色制造、产能治理、质量品牌、优质企业培养、产业集群优化等提升行动。</p> <p style=\"text-indent: 2em;\"> 江西将在传统产业企业全面落实研发费用加计扣除、专用设备税额抵免等税收优惠政策。计划到2020年，重点传统产业研发投入和新产品贡献率明显提升，规模以上工业企业技术改造投资年均增长30%左右，研发经费支出占主营业务收入比重达到1%以上。</p> <p style=\"text-indent: 2em;\"> <span id=\"paper_num\" style=\"text-indent: 2em; display: block;\">《 人民日报 》（ 2018年06月12日 02 版）</span></p>', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051890.html', '2018-06-12', 'http://politics.people.com.cn/n1/2018/0612/c1001-3', '江西启动传统产业优化升级行动', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051890.html', '1528795504');
INSERT INTO `message_news` VALUES ('18', 'T1467284926140', 'News', 'fbc28d26c86c812517c76943dfa26775', '<p style=\"text-indent: 2em;\"> 本报北京6月11日电&nbsp;（记者曲哲涵）近日，中国银行保险监督管理委员会召开偿付能力监管委员会第四十二次工作会议，分析研究2018年第一季度保险业偿付能力和风险状况，并对下一阶段偿付能力监管工作和风险防控工作做出安排部署。</p> <p style=\"text-indent: 2em;\"> 当前保险业偿付能力充足稳定。2018年第一季度末，173家保险公司的平均综合偿付能力充足率为248%，较上季末下降3个百分点；平均核心偿付能力充足率为237%，较上季末下降2.9个百分点。其中，财产险公司、人身险公司、再保险公司的平均综合偿付能力充足率分别为264%、243%和309%。经审议，120家保险公司在风险综合评级中被评为A类公司，48家被评为B类公司，2家被评为C类公司，2家被评为D类公司。</p> <p style=\"text-indent: 2em;\"> 当前保险业风险总体可控，但风险形势依然复杂严峻。银保监会将对公司治理存在问题的公司采取必要措施，督促公司及时进行整改。对流动性风险较大的公司继续加强跟踪监测，督促公司切实抓好风险防控工作。</p> <p style=\"text-indent: 2em;\"> <span id=\"paper_num\" style=\"text-indent: 2em; display: block;\">《 人民日报 》（ 2018年06月12日 02 版）</span></p>', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051888.html', '2018-06-12', 'http://politics.people.com.cn/n1/2018/0612/c1001-3', '保险业偿付能力充足整体风险可控', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051888.html', '1528795504');
INSERT INTO `message_news` VALUES ('19', 'T1467284926140', 'News', '881b6a21961d903b67c217e65603d077', '<p style=\"text-indent: 2em;\"> 本报北京6月11日电&nbsp;&nbsp;（记者赵展慧）11日，国家发展改革委、生态环境部和北京市联合在京举办“2018年全国节能宣传周全国低碳日暨北京市节能宣传周低碳日活动启动仪式”。今年全国节能宣传周为6月11日至17日，宣传主题是“节能降耗&nbsp;保卫蓝天”；6月13日为全国低碳日，主题是“提升气候变化意识，强化低碳行动力度”。</p> <p style=\"text-indent: 2em;\"> 我国节能工作取得明显成效，2013—2017年我国万元生产总值能耗累计下降20.9%，节能10.3亿吨标准煤。2017年全国能源消费总量44.9亿吨，以年均2.2%的能源消费增速支持了国内生产总值年均7.1%的增长，为生态文明建设、高质量发展提供了重要支撑。</p> <p style=\"text-indent: 2em;\"> 国家发改委副主任宁吉喆在启动仪式上表示，要把节能提效作为打好污染防治攻坚战、打赢蓝天保卫战的源头措施，不断强化工作力度。严格落实能源消耗总量和强度“双控”制度，强化“十三五”“双控”目标完成情况评估，加强目标责任考核。</p> <p style=\"text-indent: 2em;\"> 生态环境部副部长庄国泰表示，2017年我国碳强度比2005年下降约46%，初步扭转了过去一段时期碳排放快速增长的局面，为实现“十三五”碳强度约束性目标和落实2030年国家自主贡献目标奠定了坚实基础。</p> <p style=\"text-indent: 2em;\"> 当天，多项节能降耗措施启动。北京市启动推广不停车收费活动，同时发出“空调温度再提高一度”倡议；全国重点用能单位能耗在线监测系统首批8省市能耗数据接入国家平台；拟采用合同能源管理方式进行节能改造的“百栋公共建筑”目录发布，现场组织3家公共机构与节能服务公司签约……</p> <p style=\"text-indent: 2em;\"> 今年全国节能宣传周和全国低碳日活动期间，各地方和有关部门将举行节能进校园进企业进社区等活动，传播节能理念、普及节能知识、推广节能技术、提升全民意识，推动形成崇尚节约节能、绿色低碳消费与低碳环保的社会风尚。</p> <p style=\"text-indent: 2em;\"> 据新华社南昌6月11日电&nbsp;&nbsp;（记者吴锺昊）记者从国家机关事务管理局在江西南昌举行的公共机构节能十周年宣传活动上获悉：与2012年相比，2017年全国公共机构人均能耗下降15.21%，单位建筑面积能耗下降12.39%，人均水耗下降16.18%。</p> <p style=\"text-indent: 2em;\"> 今年是《公共机构节能条例》实施十周年。有关负责人表示，各级公共机构节能管理部门和广大公共机构要立足深化工作成效，不断夯实公共机构节约能源资源工作的发展基础。</p> <p style=\"text-indent: 2em;\"> <span id=\"paper_num\" style=\"text-indent: 2em; display: block;\">《 人民日报 》（ 2018年06月12日 02 版）</span></p>', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051887.html', '2018-06-12', 'http://politics.people.com.cn/n1/2018/0612/c1001-3', '2018年全国节能宣传周启动', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051887.html', '1528795504');
INSERT INTO `message_news` VALUES ('20', 'T1467284926140', 'News', '7c91725a49ba24f2debf2230d9f10484', '<p> 　　本报讯 记者从天安门地区管委会获悉，天安门城楼及城台修缮方案已获国家文物局批准，将于今年6月15日正式开工。为避免修缮工程施工期间施工人员、设备设施与游人交叉造成安全隐患，结合施工计划安排，15日起天安门城楼停止对外开放。</p> <p> 　　据文物专家介绍，明清时期，天安门城楼曾进行过两次重大修建；新中国成立后，1970年对天安门城楼进行了翻建，翻建后的天安门城楼具有较强的抗震能力，同时增添了广播电视转播等设施。</p> <p> 　　近年来，经专业机构检测，天安门城楼及城台总体处于安全状态，但也出现了城台渗水、墙体抹灰局部空鼓，城楼彩画开裂，部分设备设施老化等问题，影响了天安门城楼的日常开放和重大活动使用需求。</p> <p> 　　本次主要针对上述问题进行修缮，预计明年4月底恢复对外开放，5月底全部完工。</p>', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051184.html', '2018-06-12', 'http://politics.people.com.cn/n1/2018/0612/c1001-3', '天安门6月15日启动修缮 预计明年4月底恢复对外开放', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051184.html', '1528795504');
INSERT INTO `message_news` VALUES ('21', 'T1467284926140', 'News', '1aafdbebf60e8162c30c132753507b44', '<p> 　　前不久，中央纪委通报曝光了6起生态环境损害责任追究典型问题，涉及天津、河北、江苏、安徽、重庆和甘肃六省市，被通报人数达40多人。值得注意的是，这是中央纪委首次就该领域的责任追究典型问题进行通报。</p> <p> 　　“地方各级党委和政府主要领导是本行政区域生态环境保护第一责任人，各相关部门要履行好生态环境保护职责，使各部门守土有责、守土尽责，分工协作、共同发力。”“对那些损害生态环境的领导干部，要真追责、敢追责、严追责，做到终身追责。”今年5月，习近平总书记在全国生态环境保护大会上强调，坚决打好污染防治攻坚战，并指出对于损害生态环境的领导干部要严肃追责。</p> <p> 　　监督执纪问责，护卫绿水青山。党的十八大以来，以习近平同志为核心的党中央高度重视生态环境保护，各有关部门协同推进生态环保工作，中央和各级纪检监察机关强化监督执纪问责，为贯彻落实党中央决策部署、推进生态环保工作提供坚强的纪律保障。</p> <p> <strong>　　形成政治自觉，强化对监督的再监督</strong></p> <p> 　　中央纪委在通报中措辞严厉地指出，这些地方和单位的负责同志政治站位不高，作风不严不实，抓生态环境保护的意识不强，重经济效益、轻环境保护的错误政绩观犹在，形式主义、官僚主义问题突出，导致群众反映强烈的环境污染问题长期得不到有效解决，对违反生态环境保护政策法规的行为查处不力，严重偏离了中央决策部署，侵害群众切身利益，制约经济社会可持续发展，必须严肃查处问责。</p> <p> 　　为什么环保问题会反映出领导干部的政治站位不高、作风不实？“习近平总书记在全国生态环境保护大会上强调，生态环境是关系党的使命宗旨的重大政治问题，也是关系民生的重大社会问题。”中国纪检监察学院党委副书记、纪委书记蔡志强分析，“生态环保不是一个简单的业务问题，而是党中央的重大战略部署，各级领导干部要提高政治站位，对于环保工作是否履职尽责，直接关系到是否认真贯彻落实党中央的决策部署。”</p> <p> 　　同时，通报还指出，贯彻落实习近平总书记重要讲话精神，为打好污染防治攻坚战这场大仗、硬仗、苦仗提供坚强纪律保障，是当前和今后一个时期各级纪检监察机关的重大政治任务。</p> <p> 　　党建专家认为，这是纪检监察机关忠实履行党章赋予的职责。“‘绿水青山就是金山银山’的理念是写进党章的，并且党章明确党的纪律检查机关主要任务，是维护党的章程和其他党内法规，检查党的路线、方针、政策和决议的执行情况，协助党的委员会推进全面从严治党、加强党风建设和组织协调反腐败工作。”蔡志强说，“纪检监察机关对生态环保领域的监督执纪问责，可以说就是在检查党的方针政策的执行情况，也是在协助党委推进全面从严治党。”</p> <p> 　　实践中，纪检监察机关正加大生态环保领域的监督执纪问责力度，为生态文明建设保驾护航。一方面，自中央环保督察开展以来，各级纪检监察机关配合中央环保督察组的督察，紧盯环保领域违规违纪违法问题；另一方面，各地也出台政策措施，进一步明确纪检监察机关在生态环保领域的职责和工作方法等。如北京市纪委监委将环境治理重点工作纳入市区两级巡视巡察重要内容；海南省纪委监委对生态环保部门已调查核实、按规定需问责的，要求第一时间介入。</p> <p> 　　“这里需要区分纪检监察机关和环保部门的职责定位，环保部门是在一线对生态环境问题进行业务督察，而纪检监察机关则是对有关部门在环保方面履职尽责情况的监督检查，是对监督的再监督。”党建专家分析。</p> <p> <strong>　　严查腐败案件，加强对环保重点领域、关键环节监督</strong></p> <p> 　　环保系统有哪些领域易发腐败问题？一则通报或可窥斑见豹：2015年2月，原环保部通报6省13起环保人员违纪违法案件，多名领导干部因利用职务谋利、收受贿赂而锒铛入狱。分析这13起案例可以发现，环评审批、执法督查、固废管理、环境监测、专项资金申报审批等重点领域成为腐败问题易发环节。</p> <p> 　　中央纪委国家监委驻生态环境部纪检监察组有关负责人接受中央纪委国家监委网站采访时表示，近年全国查处的环保领域腐败案件主要有三个特点：一是较为重大的腐败案件主要发生在环境审批、项目资金分配、环保执法、环境监测、固废管理等重要业务领域；二是涉案金额较大，党的十八大以来查处的环保系统厅局级干部涉案金额超千万元的案件时有发生，社会影响恶劣；三是地方环保系统窝案、串案较多，群体性腐败案件数量不少，有的恶化了一方政治生态。</p> <p> 　　从趋势分析来看，该负责人认为，一方面，随着全面从严治党向纵深推进，严重腐败案件呈总体下降趋势。以2017年为例，环保部门人员涉嫌犯罪移送司法机关人数比2016年下降40％，全国环保系统全面从严治党工作成效显著；另一方面，“微腐败”“四风”等问题仍然突出。纪检监察机关在执纪审查中发现，人情督察、人情执法、利用监管考核谋利、吃拿卡要等“微腐败”问题，公车私用、接受宴请及其他隐性违反中央八项规定精神、不作为乱作为现象仍然突出。党的十八大以来，环保部门人员受党纪轻处分的人数呈逐年上升趋势，年均增长61％。</p> <p> 　　“生态环境工程建设投资力度不断加大，执法和工程领域廉政风险将显著提高。”该负责人强调，对此必须高度重视，坚持标本兼治，切实减少腐败存量，坚决遏制腐败增量。</p> <p> 　　党建专家表示，针对近年来环保系统出现的腐败案件特点，纪检监察机关应加强对重点领域、关键环节的监督，对违纪违法行为严惩不贷，形成震慑；有关部门也应完善制度漏洞，在环境审批、项目资金分配、环保执法等领域进一步压缩腐败空间。</p> <p> <strong>　　强追责硬问责，促生态环保责任落地有声</strong></p> <p> 　　“生态环境状况明显好转，推进生态文明建设决心之大、力度之大、成效之大前所未有，大气、水、土壤污染防治行动成效明显。”2017年12月召开的中央经济工作会议这样总结过去5年的生态环保工作。在取得如此成效的合力中，严肃追责问责功不可没。</p> <p> 　　今年3月，第二批接受中央环境保护督察的北京、上海、湖北等7省市公开了督察组移交案件的问责情况，共问责1048人。生态环境部新闻发言人刘友宾表示，7省市注重追究领导责任、管理责任和监督责任，尤其突出了领导责任，为不断强化地方党委政府环境保护责任意识发挥了重要作用。</p> <p> 　　实践证明，生态环保责任能否落到实处，关键在领导干部。一些重大生态环境事件背后，往往有领导干部不负责任不作为的问题，往往有环保意识不强、履职不到位、执行不严格的问题，往往有环保有关部门执法监督作用发挥不到位、强制力不够的问题。</p> <p> 　　随着中央对生态文明建设的要求不断提高、环保法律法规的日益完善和人民群众环保意识的增强，对损害生态环境行为的追责力度也不断增强：3月，湖北全省221人因生态环境损害被严肃问责；5月，长春通报6起环保领域问责典型案例；5月，成都通报5起生态环境保护领域责任追究典型案例……</p> <p> 　　与此同时，制度建设也不断完善：2015年8月，中办、国办印发《党政领导干部生态环境损害责任追究办法（试行）》，用制度来引领和规范领导干部用权，划出了领导干部在生态环境领域的责任红线；2016年12月，中办、国办印发《生态文明建设目标评价考核办法》，明确对徇私舞弊、瞒报谎报、篡改数据、伪造资料等造成评价考核结果失真失实的，由纪检监察机关和组织（人事）部门按照有关规定严肃追究有关单位和人员责任。</p> <p> 　　各地也出台办法，强化纪检监察机关在环保领域的追责问责力度，如湖南新出台的环境保护工作责任规定和重大环境问题（事件）责任追究办法；四川明确了生态环境损害责任“终身追究”制，强化了生态环境保护党政同责、一岗双责。</p> <p> 　　“制度的生命力在于执行，这离不开各级党委政府高度重视，纪检监察机关、组织（人事）部门和有关监管部门各尽其责、形成合力、追责到底。”蔡志强说。</p> <br /> <p> <span id=\"paper_num\">　　《 人民日报 》（ 2018年06月12日 17 版）</span></p>', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051136.html', '2018-06-12', 'http://politics.people.com.cn/n1/2018/0612/c1001-3', '正风肃纪，护卫绿水青山（前沿观察）', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051136.html', '1528795504');
INSERT INTO `message_news` VALUES ('22', 'T1467284926140', 'News', '9cfff6fb21a64aa6bb83806ee83893af', '<p>　　本报北京6月11日电&nbsp;&nbsp;在人民日报创刊70周年即将到来之际，人民日报社今天举行仪式，宣布全国移动新媒体聚合平台“人民号”正式上线。人民日报英文客户端2.0版和人民日报创作大脑、人民日报智慧党建平台同时对外发布。</p><p>　　人民日报社总编辑庹震，国务院新闻办副主任郭卫民、人民日报社副总编辑卢新宁、新华社副社长刘思扬、中央广播电视总台副台长阎晓明和中央网信办有关领导出席仪式。</p><p>　　人民号将依托人民日报客户端，充分运用人工智能技术，为媒体、党政机关和自媒体提供移动端内容生产和分发全流程服务，共同构建兼具主流价值和创新活力的内容生态。并通过与百度百家号的紧密合作，为内容生产者带来一定收益。目前，已有2000多家主流媒体、党政机关、高校、优质自媒体和名人入驻。</p><p>　　人民日报英文客户端2.0版在界面设计、用户体验上进行了大幅优化，增加了个性化推荐、智能问答等新功能。为更好满足英文用户使用习惯，从设计到开发，都引入了微软等国际化团队参与其中。创作大脑由人民日报社与百度联合开发，具备智能写作、智能推荐、智能分发功能。智慧党建平台由人民日报新媒体中心和京东集团联合开发，具备党务工作在线服务、党建活动组织、党建新闻阅读、党员社区互动等功能。</p><p>　　百度公司董事长兼首席执行官李彦宏，联合国驻华协调员、联合国开发计划署驻华代表罗世礼，阿尔及利亚驻华大使艾哈桑·布哈利法，微软全球资深副总裁王永东及各界代表共300多人参加活动。</p> <br /><span id=\"paper_num\">　　《 人民日报 》（ 2018年06月12日 04 版）</span>', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051170.html', '2018-06-12', 'http://politics.people.com.cn/n1/2018/0612/c1001-3', '全国移动新媒体聚合平台“人民号”上线', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051170.html', '1528795504');
INSERT INTO `message_news` VALUES ('23', 'T1467284926140', 'News', '30536771fb406bc45bc516096ed59f21', '<p> 　　本报北京6月11日电&nbsp;企业职工基本养老保险基金中央调剂制度贯彻实施工作会议6月11日在京召开。中共中央政治局常委、国务院总理李克强作出重要批示。批示指出：建立企业职工基本养老保险基金中央调剂制度，对于增强基本养老保险制度可持续性、均衡地区间养老保险基金负担、促进实现广大人民群众基本养老保险权益公平共享具有重要意义。各地区、各部门要以习近平新时代中国特色社会主义思想为指导，认真贯彻党中央、国务院决策部署，统一思想认识，坚持从全局出发，加强统筹协调，切实做好中央调剂基金筹集、拨付、管理等工作，健全考核奖惩机制，确保中央调剂制度顺利平稳实施。各地区要切实履行基本养老金发放的主体责任，进一步加强收支管理，加快完善省级统筹制度，通过盘活存量资金、划转部分国有资本等充实社保基金，确保基本养老金按时足额发放，有效防范和化解支付风险。有关部门要与各方面密切配合，形成合力，不断完善基金中央调剂制度，推进养老保险全国统筹，努力为人民群众提供更高质量、更有效率、更加公平、更可持续的养老保障。</p> <p> 　　中共中央政治局常委、国务院副总理韩正出席会议并讲话，中共中央政治局委员、国务院副总理胡春华主持。</p> <p> 　　韩正表示，建立企业职工基本养老保险基金中央调剂制度，是实现养老保险全国统筹的重要举措。习近平总书记主持召开中央全面深化改革委员会第二次会议并发表重要讲话，强调要从我国基本国情和养老保险制度建设实际出发，在不增加社会整体负担和不提高养老保险缴费比例的基础上，通过建立企业职工基本养老保险基金中央调剂制度，合理均衡地区间基金负担，实现基金安全可持续，实现财政负担可控，确保各地养老金按时足额发放。我们要按照习近平总书记重要讲话精神和李克强总理批示要求，实施好企业职工基本养老保险基金中央调剂制度，有力有序推进养老保险全国统筹。</p> <p> 　　韩正强调，要依法做好基本养老保险费征收工作，扩大制度覆盖面，提高征缴率，夯实缴费基数，增强中央调剂基金制度可持续性。要加快推进省级基本养老保险基金统收统支，2020年全面实现省级统筹，为养老保险全国统筹打好基础。要扎实做好中央调剂基金管理工作，强化基金预算严肃性和硬约束，确保基金专款专用。要认真做好基金缺口弥补工作，加大财政支持力度，确保全国退休职工按时足额领取养老金。</p> <p> 　　韩正表示，各地区、各部门要深入学习贯彻习近平新时代中国特色社会主义思想和党的十九大精神，全面贯彻落实《中华人民共和国社会保险法》，加强组织领导，健全保障措施，确保企业职工基本养老保险基金中央调剂制度顺利实施，为决胜全面建成小康社会、夺取新时代中国特色社会主义伟大胜利作出新的贡献。</p> <br /> <p> <span id=\"paper_num\">　　《 人民日报 》（ 2018年06月12日 01 版）</span></p>', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051072.html', '2018-06-12', 'http://politics.people.com.cn/n1/2018/0612/c1001-3', '切实做好中央调剂基金筹集拨付管理等工作 确保基本养老金按时足额发放', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051072.html', '1528795505');
INSERT INTO `message_news` VALUES ('24', 'T1467284926140', 'News', '82f39d714156c9d4b77baae97290039b', '<p> 　　凭阑观潮起，逐浪扬风帆。</p> <p> 　　6月9日至10日，国家主席习近平在中国青岛主持上海合作组织成员国元首理事会第十八次会议。欢迎晚宴、小范围会谈、大范围会谈、双边会见、三方会晤……短短两天时间，20余场正式活动，峰会达成广泛共识、取得丰硕成果，引领上海合作组织迈上新起点。</p> <p> 　　面对世界百年未有之大变局，习近平主席立足欧亚、放眼全球，同与会各方论“上海精神”、提中国方案、谋地区合作、绘发展蓝图，尽显世界级领导人的自信从容与责任担当。</p> <p> 　　黄海之滨，浮山湾畔。风景秀丽的“帆船之都”，奔涌着开放包容、合作共赢的澎湃力量。</p> <p> <strong>　　海纳百川，见证开放包容的大国襟怀</strong></p> <p> 　　一年前，上合组织阿斯塔纳峰会，中国接棒轮值主席国。青岛峰会筹备期间，习近平主席亲笔签署的一份份邀请信函，送达成员国、观察员国领导人手中。</p> <p> 　　应约而至，风云际会。</p> <p> 　　6月8日至9日下午，一架架飞机降落在青岛流亭国际机场。上合组织领导人齐聚黄海之滨，共商合作发展大计。</p> <p> 　　“有朋自远方来，不亦乐乎？”</p> <p> 　　9日晚，国际会议中心宴会厅，巨幅工笔画《花开盛世》赏心悦目。</p> <p> 　　习近平主席微笑同远道而来的各国贵宾一一握手寒暄，表达东道主的真诚与热情。</p> <p> 　　这是习近平主席作为中国国家元首首次主持上合组织峰会。阔别6年，上合组织再次回到诞生地，国际社会热切期待，进入新时代的中国为上合组织注入新动力。</p> <p> 　　齐鲁大地、孔孟之乡，人文气息扑面而来。</p> <p> 　　“儒家倡导‘大道之行，天下为公’，主张‘协和万邦，和衷共济，四海一家’。这种‘和合’理念同‘上海精神’有很多相通之处。”欢迎宴会上，习近平主席致祝酒辞，道出中国理念和“上海精神”的内在联系。</p> <p> 　　互信、互利、平等、协商、尊重多样文明、谋求共同发展的“上海精神”是上合组织发展的灵魂和根基；和而不同、世界大同，是“和合”思想的时代思辨，是中国理念同“上海精神”的琴瑟和鸣。</p> <p> 　　这是一次展示理念的生动实践——</p> <p> 　　6日下午5时许，北京人民大会堂东门外广场。新改革的国事访问欢迎仪式首次启用，习近平主席热情欢迎首位抵达中国的上合组织外方领导人——吉尔吉斯斯坦总统热恩别科夫。</p> <p> 　　“中国有礼仪之大，故称夏；有服章之美，谓之华。”外交礼宾细节之变，折射出日益走向世界舞台中央的东方大国，从容自信的心态、沉稳大气的仪态、诚挚友好的姿态。</p> <p> 　　源远流长的儒家文化、会场内的亭台楼阁元素、地方特色的节目表演……上合组织青岛峰会一个个细节凸显中国传统底蕴。</p> <p> 　　这是一次新的“大家庭”聚会——</p> <p> 　　作为上合组织接收印度、巴基斯坦为成员国，实现组织扩员后首次举行的元首理事会会议，青岛峰会承载着承前启后、继往开来的特殊意义。</p> <p> 　　“这是巴基斯坦首次以正式成员身份参加上海合作组织峰会，所以会议具有新的意义。”9日下午，国际会议中心安仁厅，习近平主席会见巴基斯坦总统侯赛因，强调了这次峰会特别之处。</p> <p> 　　一个多月前，习近平主席同印度总理莫迪刚刚在武汉举行非正式会晤。再次见面，两人十分高兴。习近平主席对印方首次作为上合组织成员国与会表示欢迎。</p> <p> 　　“现在，上海合作组织站在新的历史起点上，我们要发扬优良传统，积极应对内外挑战，全面推进各领域合作，推动上海合作组织行稳致远……”习近平主席主持小范围会谈时的讲话，提出中国倡议，赋予“上海精神”新的时代内涵。现场嘉宾频频颔首，表示赞同。</p> <p> 　　这是一个不断深化的发展历程——</p> <p> 　　由中国参与创建、以中国城市命名、秘书处设在中国境内……作为创始成员国之一，中国对上合组织成长一路倾力而为，把推动上合组织发展作为外交优先方向之一。</p> <p> 　　吉尔吉斯斯坦比什凯克、塔吉克斯坦杜尚别、俄罗斯乌法、乌兹别克斯坦塔什干、哈萨克斯坦阿斯塔纳……5年来，习近平主席出席历次峰会，为丰富发展“上海精神”贡献中国智慧，注入源源不断的思想动力。</p> <p> 　　今天，辽阔丰沃的齐鲁大地，见证中国同上合组织相融相生的历史际会；开放包容的中华民族，再次谱写与世界携手前行的时代篇章。</p> <p> 　　9日的夜色中，青岛国际会议中心宴会厅在灯光的映照下美轮美奂，犹如海浪中的风帆，蓄势待发。浮山湾防波堤向大海深处延伸，远端的白色灯塔为过往船只指引航向。</p> <p> 　　宴会厅内，灯火通明，各方嘉宾静静聆听。</p> <p> 　　“青岛是世界著名的‘帆船之都’，许多船只从这里扬帆起航、追逐梦想。明天，我们将在这里举行上海合作组织扩员后的首次峰会，全面规划本组织未来发展蓝图。”习近平主席的话道出了选择青岛为峰会举办地的深意。</p> <p> <strong>　　砥柱中流，镌刻合作发展的大国担当</strong></p> <p> 　　巍峨泰山，旭日喷薄而出，霞光照耀大河山川。国际会议中心迎宾厅正面，一幅题为《国泰民安》的国画气势磅礴。</p> <p> 　　10日上午9时许，印度总理莫迪、乌兹别克斯坦总统米尔济约耶夫、塔吉克斯坦总统拉赫蒙、巴基斯坦总统侯赛因、吉尔吉斯斯坦总统热恩别科夫、哈萨克斯坦总统纳扎尔巴耶夫、俄罗斯总统普京先后抵达。</p> <p> 　　习近平主席同上合组织成员国领导人亲切握手，并邀请大家合影。这张新的“全家福”，定格上合组织发展进程中的历史瞬间。</p> <p> 　　走过17年不平凡发展历程，上合组织开创了区域合作新模式，为地区和平发展作出了重大贡献，未来前景光明但道路并不平坦。</p> <p> 　　“弘扬‘上海精神’，加强团结协作”；“推进安全合作，携手应对挑战”；“深化务实合作，促进共同发展”；“发挥积极影响，展现国际担当”……国际会议中心黄河厅，习近平主席在小范围会谈发表讲话，为上合组织发展明确路径。</p> <p> 　　登东山而小鲁，登泰山而小天下。</p> <p> 　　10日上午11时许，国际会议中心泰山厅，习近平主席主持大范围会谈。成员国领导人、常设机构负责人、观察员国领导人及联合国等国际组织负责人，围坐一起，共同描绘合作发展的新蓝图。</p> <p> 　　——提倡创新、协调、绿色、开放、共享的发展观；</p> <p> 　　——践行共同、综合、合作、可持续的安全观；</p> <p> 　　——秉持开放、融通、互利、共赢的合作观；</p> <p> 　　——树立平等、互鉴、对话、包容的文明观；</p> <p> 　　——坚持共商共建共享的全球治理观。</p> <p> 　　习近平主席登高望远，把握时代潮流，提出中国方案。</p> <p> 　　支持在青岛建设中国—上合组织地方经贸合作示范区、在上合组织银行联合体框架内设立300亿元人民币等值专项贷款、未来3年为各成员国提供3000个人力资源开发培训名额、利用风云二号气象卫星为各方提供气象服务……</p> <p> 　　一项项实实在在的举措，展现中国推动建设共同家园的真诚态度。</p> <p> 　　10日下午1时25分许，习近平主席敲下木槌，宣布峰会结束。</p> <p> 　　此时，国际会议中心二楼大厅里，早已坐满中外媒体记者。</p> <p> 　　习近平主席同上合组织其他各成员国领导人一道步入，在主席台就座。</p> <p> 　　共同发表《上海合作组织成员国元首理事会青岛宣言》《上海合作组织成员国元首关于贸易便利化的联合声明》，批准《上海合作组织成员国长期睦邻友好合作条约》未来5年实施纲要，见证经贸、海关、旅游等领域合作文件签署……一份份沉甸甸的成果文件，体现各方凝聚的最新共识。</p> <p> 　　外界评价，上合组织从此进入一个历史新阶段。</p> <p> 　　“我坚信，在大家共同努力下，上海合作组织的明天一定会更加美好。”面对各国媒体，习近平主席对上合组织的未来之路信心满怀，铿锵有力的话语通过电视直播信号传递到世界各个角落。</p> <p> <strong>　　大道之行，彰显天下为公的大国信念</strong></p> <p> 　　9日的青岛夜空，云开雾散，璀璨焰火，当空绽放。</p> <p> 　　习近平主席为各方贵宾准备的灯光焰火艺术表演，处处体现东道主的独到用心。《天涯明月》《齐风鲁韵》《国泰民安》《筑梦未来》《命运共同体》，5个篇章一气呵成，传递出中国同上合组织和世界各国和衷共济、携手并进的坚定决心。</p> <p> 　　“继续加强政策沟通、设施联通、贸易畅通、资金融通、民心相通，发展安全、能源、农业等领域合作，推动建设相互尊重、公平正义、合作共赢的新型国际关系，确立构建人类命运共同体的共同理念。”</p> <p> 　　在通过的成果文件中，“五通”“构建新型国际关系”“构建人类命运共同体”等中国理念、中国方案正式写入了上合组织青岛宣言。</p> <p> 　　初夏时节的青岛，成为中国又一“国际会客厅”，见证中国特色大国外交的成功实践。</p> <p> 　　构建新型国际关系，中国步履坚实、步伐稳健——</p> <p> 　　北京、天津、青岛，一天跨三地。6月8日，可以称为习近平主席繁忙外交日程“教科书式”的一页。</p> <p> 　　同普京总统举行大小范围会谈、共同出席签字仪式并会见记者、授予普京总统“友谊勋章”、同乘高铁前往天津并共同观看中俄青少年冰球赛……中俄领导人之间亲密互动，彰显两国全面战略协作伙伴关系成熟、稳定、牢固，树立了发展新型国际关系的典范。</p> <p> 　　同吉尔吉斯斯坦总统热恩别科夫宣布中吉建立全面战略伙伴关系；同哈萨克斯坦总统纳扎尔巴耶夫就巩固中哈传统友谊、在民族复兴征途上携手前行达成重要共识；两个月内同印度总理莫迪再次会晤，中印政治互信进一步加强……</p> <p> 　　峰会期间，习近平主席特别安排同上合组织各成员国、观察员国11位外方领导人举行双边会晤，元首外交引领国际关系更进一步。</p> <p> 　　构建人类命运共同体，中国领导人天下为公的信念感召世界——</p> <p> 　　“我们要继续在‘上海精神’指引下，同舟共济，精诚合作，齐心协力构建上海合作组织命运共同体，推动建设新型国际关系，携手迈向持久和平、普遍安全、共同繁荣、开放包容、清洁美丽的世界。”习近平主席的话掷地有声，启迪未来。</p> <p> 　　时间回到5年前，习近平主席首次提出构建人类命运共同体伟大倡议。从此，中国实践波澜壮阔，中国理念全球激荡——</p> <p> 　　从写入中共党章到载入中国宪法，一个个历史坐标铸熔着中国共产党人“为人类进步事业而奋斗”的庄严承诺；从写入联合国决议到载入上合组织合作文件，构建人类命运共同体理念赢得国际社会广泛认同，成为新时代指引国际关系发展的重要指南。</p> <p> 　　舆论分析，当今世界，只有中国领导人能够提出如此宏远博大的理念。</p> <p> 　　进入国际会议中心迎宾厅，两侧墙壁上的浮雕颇具深意：一侧关于丝绸之路经济带，一侧关于21世纪海上丝绸之路。</p> <p> 　　共享古丝绸之路历史记忆，共创“一带一路”建设发展机遇。5年来，“一带一路”建设在上合组织所在区域先行先试，硕果累累，为地区各国人民带来实实在在的利益，成为构建人类命运共同体的重要平台。</p> <p> 　　峰会期间，“一带一路”倡议再次得到广泛欢迎和支持，“一带一路”建设对拉动共同发展的引擎作用愈发凸显。</p> <p> 　　涓涓细流汇成大海，点点星光照亮银河。</p> <p> 　　“我们愿同各方一道，不忘初心，携手前进，推动上海合作组织实现新发展，构建更加紧密的命运共同体，为维护世界和平稳定、促进人类发展繁荣作出新的更大贡献。”</p> <p> 　　海之情，合之韵。从青岛再出发，中国同上合组织各国携手，与世界各国同行，必将迈向更加美好的明天！</p> <p> 　　（新华社青岛6月11日电&nbsp;&nbsp;记者霍小光、李忠发、刘华）</p> <br /> <p> <span id=\"paper_num\">　　《 人民日报 》（ 2018年06月12日 01 版）</span></p>', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051069.html', '2018-06-12', 'http://politics.people.com.cn/n1/2018/0612/c1001-3', '携手前进，开启上合发展新征程', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051069.html', '1528795505');
INSERT INTO `message_news` VALUES ('25', 'T1467284926140', 'News', '9ba4af25f1e69016443ca7c3f4e29e41', '<p>　　本报梅州6月11日电&nbsp;&nbsp;（记者常钦）6月10日—11日，由中国老区建设促进会、广东省老区建设促进会主办的全国老区宣传工作会议在广东省梅州市召开。“老区既是改革开放的推动者，也是改革成果的共享者。”中国老促会会长王健在会上说，改革开放40年，老区发生了翻天覆地的变化，人均GDP增长幅度最大的10个省份，都是老区大省。</p><p>　　王健介绍，目前，井冈山、兰考率先脱贫，全国首批脱贫摘帽的28个贫困县中，有12个是老区县。老促会成为促进老区建设的重要力量。同时，由于历史、自然等因素，目前，全国还有345个老区县是国家扶贫工作重点县，不少老区贫困程度深、扶贫投入高、脱贫难度大，是脱贫攻坚的重中之重。</p><p>　　据了解，下一步，老促会将以讲好老区革命故事、讲好老区脱贫攻坚和振兴发展故事、讲好老促会故事为重点，为弘扬老区精神、助力脱贫攻坚做出新贡献。</p> <br /><span id=\"paper_num\">　　《 人民日报 》（ 2018年06月12日 09 版）</span>', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051144.html', '2018-06-12', 'http://politics.people.com.cn/n1/2018/0612/c1001-3', '老促会弘扬老区精神助力脱贫攻坚', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051144.html', '1528795505');
INSERT INTO `message_news` VALUES ('26', 'T1467284926140', 'News', 'a2533f409bdbacdc76db7883d3b2c247', '<p>　　广西南宁市长湖立交桥下，一间不大的平房里，20多名外卖配送员坐成几排，两名交警正讲解注意事项。而后，配送员在手中的《交通安全事前信用承诺书》上，签下名字。承诺书一式三份，其中一份由交警部门留存。</p><p>　　当下，外卖送餐越来越多，配送员骑行不规范也带来各种安全隐患，日前，公安部出台《关于警企共治创新外卖行业电动自行车交通违法治理工作的通知》，部署各地公安交管部门加强警社合作、警企共治。</p><p>　　南宁市交警与外卖企业合作，实施准入培训、信用惩戒和制定文明骑行公约等具体措施，试图破解外卖骑行交通违法难题。规定施行以来，效果如何，有哪些经验值得借鉴？</p><p>　　外卖违规骑行常发</p><p>　　配送员屡罚屡犯，亟待加强规范管理</p><p>　　中午，正值外卖订单高峰期，配送员小李手里有7个订单，取餐的店里顾客很多，出餐慢，客户着急，小李也着急。取餐后为了尽快送到，他只好开足马力，一骑绝尘。电动车骑得飞快不说，小李和他的同事们还边骑行边看手机，手动“抢单”，一旦平台发布新订单，谁抢到算谁的，送得快，抢得多，赚钱自然也多。</p><p>　　一个中午，小李逆行一次，违规变道了两次，停放也不太注意位置，曾经，这是“小李”们的工作常态。</p><p>　　“南宁的电动车数量多，下班高峰期很拥挤，一次我下班骑车回家，旁边一辆外卖电动车骑得飞快，可能嫌非机动车车道堵，还一下子窜到了机动车道上，差点被后面开来的一辆汽车撞上，特别危险。”南宁市民黄先生回忆当时的情景，不免为外卖配送员捏了一把汗。</p><p>　　外卖配送员守法意识、安全意识参差不齐，闯红灯、逆行、违反标志标线指示、随意变更车道、乱停放等现象屡屡发生，外卖送餐交通安全问题已成为城市治理的痛点。</p><p>　　南宁市交警支队一大队副大队长莫民超说：“有一次我在路口巡查，看到有位外卖配送员逆行，立即拦住他进行教育处罚。一查记录才发现，这段时间他已经因为交通违法被处罚5次了，每次都是简单接受了半小时学习教育。因为违规成本较低，他屡教不改。”</p><p>　　外卖骑行同样关乎企业形象，配送员的服装和车尾送餐箱都印有外卖企业标识，如果扰乱交通秩序也会损害企业形象。因此，外卖送餐企业也需要加强规范管理。</p><p>　　警企联合信用惩戒</p><p>　　将制定外卖配送员安全记分管理办法</p><p>　　2018年4月，南宁市公安局交警支队与外卖企业美团外卖正式签订战略合作协议，联合实施准入培训、信用惩戒等12项具体措施，规范和加强外卖送餐电动车的通行管理。</p><p>　　“我们建立三级沟通协调机制：交警支队与美团外卖南宁专送渠道团队对接、交警大队与片区配送站对接、交警中队岗组与企业维护岗对接，明确各层级的对接负责人，通过印发通讯录、建立微信群等方式沟通协调。”&nbsp;南宁市公安局交警支队副支队长罗义学介绍。</p><p>　　同时，各层级定期相互通报情况，实时响应需求，提高双方沟通协调和处置问题的效率。南宁交警支队秩序科长梁宇新说，微信群是一个微型协作平台，同时，还是一个宣传平台，近期交通管理重点、突出的交通违法和安全事故案例、需要宣教的文明出行要求等，都会通过微信群传递到每一个站点和外卖配送员。“我们双方会定期交换配送员、配送车辆的交通违法和事故等数据，企业会提供骑行送餐的热力图分析，通过在线交互和实时推送，及时发现隐患，迅速整治乱象。”梁宇新说。</p><p>　　合作协议中还明确：“凡在南宁片区申请成为美团外卖配送员的，需先做出配送期间遵守道路交通安全法律法规的事前信用承诺，并经联合审核，方可准入。”通过审核后，“准配送员”还要以交通安全志愿者身份参与一次路口执勤，才能成为正式配送员。</p><p>　　对于配送员的交通违法行为，交警处理完，企业也要处理，实施联合惩戒，并将其纳入社会信用体系。“肇事逃逸扣36分，逆向行驶扣12分……”在企业的安全记分管理办法初稿中，机动车违规与处罚措施挂钩，分数扣光则会被拉黑辞退，分数偏低则需参加交通安全学习。目前，警企双方正在讨论制定最终稿。</p><p>　　信息互通促管理升级</p><p>　　交警精准整治，企业合理调度，推动行业自律</p><p>　　“骑车路过之前站过岗的交通路口，就能想起当时自己也在那儿指挥过交通。”配送员梁守宇说，“在路口体验站岗执勤后，从交警的角度更能体会违法行为的严重性。”</p><p>　　南宁交警七大队中队长洪基清说：“我们跟辖区的配送站点建立联系后，管理和宣传教育针对性更强。”平日里，交警会定期对配送员进行交通安全培训教育。平台也会给外卖配送员100%推送交警部门制作的电动车安全规范课件。每日晨会，配送站还会进行交通安全骑行宣教。“现在辖区的外卖电动车交通违法行为少了一大半。”洪基清说。</p><p>　　在警企合作中，双方也尝试相互提供便利服务支持。南宁市青秀区某购物中心地处繁华商业街区，每逢用餐时间，外卖电动车就蜂拥而至，购物中心不允许外卖电动车在门前停放，配送员为了尽快取餐送餐，经常把电动车停在非机动车道上，既干扰交通秩序，也增加安全风险。了解这一情况后，南宁交警居中协调，促成购物中心与外卖企业协商。不久前，购物中心设置了两个停放点共60个车位，专门供外卖电动车停放，问题得到妥善解决。</p><p>　　通过警方的及时反馈，企业内部管理也不断升级。现在，美团外卖升级智能调度体系，精准派单，逐步取消“平均送达时长”等考核指标，改变了“有单赶紧抢、送餐拼命骑”的局面，同时正在试点配送员蓝牙耳机接单模式，避免配送员骑行时操作手机带来危险。</p><p>　　据了解，南宁交警正在与饿了么等多家外卖企业积极沟通，努力将警企合作拓展为警方与整个外卖行业合作。同时，交警还联合企业共同制定了外卖电动自行车配送员文明骑行公约，号召外卖行业企业参与公约履行，共同推动形成行业自律。</p><p>　　南宁市公安局交警支队支队长蒋卫红说：“解决交通安全问题，不能只靠交警强力整治，必须树立共建共治共享新理念，多角度、多层次强化警社合作、警企共治，实现监管部门的依法治理与行业、企业自律管理相结合。”</p> <br /><span id=\"paper_num\">　　《 人民日报 》（ 2018年06月12日 11 版）</span>', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051148.html', '2018-06-12', 'http://politics.people.com.cn/n1/2018/0612/c1001-3', '外卖送餐 拼快更要拼安全', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051148.html', '1528795505');
INSERT INTO `message_news` VALUES ('27', 'T1467284926140', 'News', '23d87cfd7c4adfae65d680a0637a9b34', '<p>　　本报沈阳6月11日电&nbsp;&nbsp;（记者何勇）6月11日，辽宁省编制办副主任陈相元介绍，辽宁省直机构659家公益性事业单位，按照政事分开、事企分开、管办分离原则，将职能相近的单位合并，已整合为65家大型事业单位。</p><p>　　目前，辽宁有事业单位3.5万余家，其中，省直公益性事业单位990家，去掉医疗、高校、地税系统为659家。长期以来，这些单位存在着小、散、弱的特点，存在政事职责不清、管理体制不顺、资源配置不合理等问题，有的人浮于事，有的与民争利，破坏营商环境。去年以来，辽宁加大力度推进事业单位改革，对经营性事业单位应转尽转，对公益性事业单位严格管控。</p><p>　　辽宁此次事业单位改革重点解决“有的人没事干、有的事没人干”的矛盾，跨部门整合职能相近的部门机构。此类机构面向社会提供公益服务，分散在多个部门，职责、任务、服务对象相似，重复设置较多。改革后，组建大型综合性事业单位，将集中力量、集中资源，统一提供公益服务。</p><p>　　相关负责人介绍，比如，辽宁省直各部门以前几乎家家有信息中心，共30多家，各有一班人员、一套系统、一条线路，并需要大量外包服务。此次新成立的省信息中心，将这30多家信息中心整合起来，所有政务信息资源统一由省信息中心一家建设和维护，大幅压缩机构编制规模，节约资金，提高信息服务的专业化水平。</p><p>　　此外，辽宁还要求经营性事业单位应转尽转。经营性事业单位转企改制组建企业集团，通过依法赋予转制单位法人财产权和经营自主权，实现事企分开，把本应由市场配置资源的经营活动交给市场。前不久，辽宁省辽勤、担保、旅游、体育、健康产业等5家企业集团挂牌成立。2016年以来，辽宁省通过组建企业集团、推动经营性事业单位转企和收空编等一系列措施，共撤销事业单位1171家、收回事业编制15万名。</p><p>　　日前，辽宁召开省市县乡四级全覆盖的电视电话会议，要求7月底前，省直事业单位改革到位。根据安排，改革后，省政府直属部门原则上一家不超过一个事业单位。</p> <br /><span id=\"paper_num\">　　《 人民日报 》（ 2018年06月12日 11 版）</span>', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051149.html', '2018-06-12', 'http://politics.people.com.cn/n1/2018/0612/c1001-3', '六百余家单位整合为六十五家', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051149.html', '1528795505');
INSERT INTO `message_news` VALUES ('28', 'T1467284926140', 'News', 'be06681602e758ecae6cae9e1f9840c3', '<p>　　本报福州6月11日电&nbsp;&nbsp;（记者邵玉姿）日前，福建省福州市发布《关于进一步激励广大干部新时代新担当新作为的若干措施》，从加强教育增动力、树立导向鼓干劲、科学考核重激励、容错纠错促担当、提升本领强作为、关心关爱除顾虑、齐抓共管聚合力等7个方面，推出27条具体措施。</p><p>　　在树立导向鼓干劲方面，《若干措施》明确提出把政治忠诚、政治定力、政治担当、政治能力、政治自律作为干部选拔任用的首要标准；突出实干实绩，对在重点工作中表现突出，获市委、市政府三等功以上表彰的干部落实“五个优先”，即优先宣传褒奖、选送培训、评先评优、提拔重用、解决诉求；突出基层一线，注重选拔优秀乡镇（街道）、县（市）区直部门主要领导交流担任市直部门领导职务，注重从乡镇（街道）事业编制人员、优秀村干部、大学生村官中选拔乡镇（街道）领导干部。</p><p>　　《若干措施》强调科学考核重激励。深化现场考核，考准考实干部在急难险重一线担当作为情况，以及干部在日常一线履职尽责情况；做实蹲点调研，把蹲点调研作为深化和完善干部日常考核的重要抓手，全面了解领导班子和干部队伍情况；改进年度考核，建立差异化考核评价指标体系，根据不同地区发展定位、资源禀赋、阶段性工作重点，合理确定考核评价的重点内容、核心指标，坚持多元评价，加大群众满意度在考核评价中的权重，全面推进市、县职能部门、市直机关处室民主测评，并将测评结果作为年度考核重要依据；强化结果运用，广泛吸纳巡视巡察、效能、综治、审计、环保督察等成果，形成全面、客观、公正的综合评价意见，作为干部选拔任用、评先评优、问责追责的重要依据。</p><p>　　《若干措施》还提出要容错纠错促担当，正确看待、评价和宽容干部在改革创新、担当履职中的失误错误，明确了在贯彻落实上级工作部署中，先行先试，敢于担当，但因政策界限不明确或缺乏经验而出现失误等可以启动容错免责程序的10种情形，同时还对容错纠错规程、防错预警机制、澄清保护措施等作了明确规定。此外，《若干措施》在注重政治激励、强化工作支持、落实待遇保障、加强人文关怀等方面加大了对广大干部的关心关爱力度。</p> <br /><span id=\"paper_num\">　　《 人民日报 》（ 2018年06月12日 11 版）</span>', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051150.html', '2018-06-12', 'http://politics.people.com.cn/n1/2018/0612/c1001-3', '福州出台27条措施激励干部担当作为', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051150.html', '1528795505');
INSERT INTO `message_news` VALUES ('29', 'T1467284926140', 'News', '59993d28d562e569f31eb2067e6e7188', '<p>　　“导师手把手教，遇到问题耐心指导，我们在项目攻坚中增长了本领，工作底气更足了。”近日，浙江省永康市花街镇干部胡爽冒雨来到吴坑村，查看暴雨过后该村重点项目建设情况。胡爽口中的导师，是花街镇村镇建设办主任王章亮。按照镇里“导师帮带1+1”的安排，“老乡镇”王章亮带着胡爽、王晖等4名年轻干部组成攻坚小组，懂政策、找方法、有韧劲、能吃苦、多沟通……王章亮把基层工作的“十八般武艺”悉数传授，年轻干部学以致用，劲头十足。</p><p>　　据了解，永康市创新年轻干部培养模式，推行“成长伙伴计划”，通过多种形式结对，积极选派年轻干部到重点工作、重点工程、重点项目一线历练。同时采取“政治引领、导师帮带、一线压担、火线练兵、挂职锻炼、读书研讨”等方法，引导各单位互比互学；实行容错免责机制，为担当敢为的干部撑腰鼓劲。</p><p>　　花街镇是浙江省小城镇环境综合整治试点单位，镇里组建6个工作组，每个组由1名镇领导、1名“老乡镇”和三四名年轻干部组成，倒排时间、压实担子，立下“军令状”，对集镇范围内6个村“线乱拉”“道乱占”“车乱停”等乱象进行清理。截至目前，已规划停车泊位1696个、清理街面垃圾1800余车、净化河道沟渠2760米、拆除违建12.2万平方米……“‘成长伙伴计划’让花街镇跑出了发展‘加速度’，年轻干部也在攻坚一线得到了锻炼，6名‘85后’干部在工作中表现出色得到提拔。”相关负责人告诉记者。</p><p>　　与此同时，永康市突出抓好拜一名老师、开展一次“双向挂职”、开展一次实践锻炼、开设一个读书大讲堂、每季一次述职交流、每月一次专项考察等“十个一”举措，制订个性化培养锻炼计划，不断提高全市年轻干部的思想政治素质和实际工作能力。</p><p>　　此外，永康市还专门安排机关部门优秀年轻干部直接联系1个重大项目或联系服务1个难点村，帮助协调各部门关系、落实工作计划、破解各类难题。永康市委书记金政说，把年轻干部放到基层历练，就是要让他们在急难险重任务中增强党性、改进作风、锻炼筋骨，用过硬本领展现担当与作为。</p> <br /><span id=\"paper_num\">　　《 人民日报 》（ 2018年06月12日 11 版）</span>', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051151.html', '2018-06-12', 'http://politics.people.com.cn/n1/2018/0612/c1001-3', '让年轻干部到基层成长', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051151.html', '1528795505');
INSERT INTO `message_news` VALUES ('30', 'T1467284926140', 'News', '253a60054015e9b2dd44ca26b1ea4bed', '<p>　　为实现基本建成具有国际竞争力的技能人才高地的目标，上海将实施技能提升计划，到2021年技能人才待遇明显提高，技能人才政策环境和社会氛围明显改善。据统计，截至2017年底，上海技能人才总量超过330万人。这意味着，他们不仅将迎来更好的待遇，还有更好的职业发展机遇。</p><p>　　近日，上海发布《技能提升计划（2018—2021年）》（以下简称《计划》），将持续加大劳动者技能提升力度，从提升技能人才政治地位、提高技能人才收入水平、解决技能人才切身问题、提供技能人才保障服务等方面切实提升技能人才待遇。</p><p>　　10名东航首席技师入选上海市首席技师千人计划资助项目，5名上汽集团技师获评“上海工匠”称号……目前，上海全市各行各业的产业大军里有一大批技能人才代表。上海市人社局最新数据显示，2017年，全市职业培训规模首次突破百万，达到106.7万人；到2017年底，全市高技能人才总量106.8万人，占技能劳动者比重达32.08%。</p><p>　　已建成102家高技能人才培养基地</p><p>　　东航运控中心是东航生产运行的大脑和指挥中枢，这里决定着东航每天650余架飞机、2500多个架次航班是否起飞，何时起飞，飞往何处。在这里，有一批以首席签派师宁立国、首席气象师王秀春为代表的高技能人才，他们为航班安全运行提高正点率、有效增大空域流量和公司“降本增效”保驾护航。</p><p>　　东航集团总经济师胡际东告诉记者，公司相继出台领军人才和首席技师制度，健全完善高技能人才培养体制体系，培养造就了一大批高精尖人才，包括4名东航领军人才、33名东航首席技师，其中10名东航首席技师入选上海市首席技师千人计划资助项目。</p><p>　　截至2017年底，上汽集团全部从业人员22.7万人，其中高技能人才逾2.5万人。已累计投入超过6.5亿元用于高技能人才培养基地建设，实训基地总建筑面积达3.2万平方米，建成实训室46个。据介绍，上汽已建立起3个国家级“技能大师工作室”、8个上海市“技能大师工作室”，有5名技师获评“上海工匠”称号。</p><p>　　数据显示，2011年起，上海依托重点产业领域的大型企业、协会、园区建立了102家高技能人才培养基地，认定资助首席技师1417人、技能大师工作室165个。</p><p>　　每年将完成100万名劳动者技能培训</p><p>　　根据《计划》，上海市每年将完成100万名劳动者技能培训，其中技能提升培训和新技能培训占比80%以上。各级政府、行业企业、职业院校、社会力量多方协同的职业教育与培训体系也将基本形成。具有辐射带动作用的高技能人才培养基地达120家。</p><p>　　在高技能领军人才方面，到2021年，市级首席技师等高技能领军人才达2000名，市级技能大师工作室达200个；高技能人才占技能劳动者的比重达到35%以上，达到或接近发达国家和地区的水平。此外，技能提升对上海经济社会发展的促进作用进一步发挥。在重点产业、重点区域、重大工程中，培养形成若干个具有国际竞争力的产业化、区域性的技能人才高地。</p><p>　　《计划》涵盖了技能人才培养、评价、竞赛、引进、待遇、激励、保障等各方面。如支持职业院校广泛开展技能人才培养培训工作，根据上海高技能人才培养需要，探索在符合相关条件的应用型本科院校、职业院校设立技师学院；深化细化职业教育校企合作培养，完善职业教育“双师型”教师定期到企业实践锻炼制度，在中等职业学校设置正高级职称等。</p><p>　　同时，全面推广“招工即招生、入企即入校、企校双师联合培养”的企业新型学徒制，加大对企业新型学徒制的培训补贴力度，对企业实施培训费补贴，对带教师傅给予带教津贴；突破职业培训时空限制，引进优质互联网培训资源，创设网上培训课程，搭建职业培训云平台，建立产教融合信息服务平台。</p><p>　　据透露，上海高技能人才的生活和住房问题将充分纳入考虑，并鼓励各区加大住房补贴、落户引进的力度。同时，支持引进能真正在先进制造业发挥重要作用的海外高级人才，并鼓励上海人才走出去学习海外经验。</p><p>　　坚持产业发展方向培育人才</p><p>　　上海市委、市政府历来高度重视技能人才队伍建设。市委书记李强多次批示“加强高技能人才队伍建设很有必要，要明确举措，扎实推进”。市长应勇明确表示“产业工人的源头在职业教育培训，职业教育培训要契合产业发展，产业发展方向就是职业教育培训的方向”。</p><p>　　技能人才的培养，将主要围绕全力打响上海“四大品牌”而展开。比如，围绕打响“上海服务”“上海购物”品牌，实施现代服务业技能提升计划。包括加大银行柜员、保险理赔员、金融客服人员等金融业技能人才培养力度，服务国际金融中心建设；围绕国际消费城市建设、对外贸易能级提升等任务，加快电子商务、商贸服务、对外贸易类技能人才队伍建设等。</p><p>　　围绕打响“上海制造”品牌，实施先进制造业和战略性新兴产业技能提升计划。包括加强与新一代信息技术、智能制造装备、新能源与智能网联汽车、生物医药与高端医疗器械、航空航天等世界级先进制造业集群相关产业发展相匹配的技能人才队伍建设，加强与改造提升传统优势制造业相适应的技能人才队伍建设等。</p><p>　　上海的发展既需要金领、白领，也需要蓝领；既需要企业经营管理人才，也需要一线的高技能人才和社会工作人才。上海市人社局副局长张岚表示，《计划》将对推进全社会关注技能、重视技能、崇尚技能起到非常重要的作用。</p> <br /><span id=\"paper_num\">　　《 人民日报 》（ 2018年06月12日 02 版）</span>', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051083.html', '2018-06-12', 'http://politics.people.com.cn/n1/2018/0612/c1001-3', '技能人才 有待遇更有机遇（政策解读·聚焦）', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051083.html', '1528795505');
INSERT INTO `message_news` VALUES ('31', 'T1467284926140', 'News', '49a86586e0ed19ca48ace3715e8f71c5', '<table class=\"pci_c\" width=\"400\"><tbody><tr><td align=\"center\"><img src=\"http://paper.people.com.cn/rmrb/res/1/20180612/1528746957819_1.jpg\" /></td></tr> <tr><td><p>　　83岁的牛犇庄严宣誓，加入中国共产党。<br />　　资料图片 </p></td></tr></tbody></table><p>　　6天前，鲜红的党旗前，83岁高龄的电影表演艺术家、上影演员剧团演员牛犇举起右手，在他的入党介绍人、上影集团党委书记任仲伦领誓下，和上影其他青年党员一起庄严宣誓，加入中国共产党。</p> <p>　　宣誓现场，老人的眼眶一次次湿润。他激动地说，“不管组织上对自己考验多长，我一点儿不气馁，党的考验是永远的，只要我们的目标坚定不移，就一定能实现。”</p> <p>　　1946年，11岁的牛犇参演抗日影片《圣城记》，自此开启了他的电影人生。进入上海电影制片厂后，牛犇相继参演了《海魂》《沙漠追匪记》《红色娘子军》《天云山传奇》《牧马人》《泉水叮咚》等影片，形成了独特的表演风格。2017年，他获得第三十一届中国电影金鸡奖终身成就奖。</p> <p>　　牛犇从青年时期就树立了“跟党走”的信念，始终以党员的标准要求自己。他的另一位入党介绍人、表演艺术家秦怡说，“牛犇是个好同志，我愿意做他的入党介绍人，我相信他会做得很好。”</p> <p>　　“我打小父母双亡，如今终于实现了夙愿，今后我要把入党这一天作为我的生日！”个子不高、银白头发、腰板笔直，6月9日，上影演员剧团办公室，佩戴着鲜红的共产党员徽章，牛犇接受了本报记者的专访。</p> <p>　　“我接受党的教育已经60多年了”</p> <p>　　记者：作为电影表演艺术家，您已经拿到了很多奖项和荣誉，为什么在耄耋之年希望加入中国共产党？</p> <p>　　牛犇：这不是冲动，我一直有这个心，有这个追求，只是默默地在心里，没有张扬。从我戴上团徽开始，我就想加入中国共产党，团徽我保存着，这份心愿也保存着。</p> <p>　　我接受党的教育已经60多年了，中间虽然经历过各种艰苦，这个信念从来没变过。早在上个世纪50年代未满18岁时，我听了上影厂老书记丁一的党课，那个时候就想做党的同路人。退休后，自己依然积极参加上影和演员剧团的各项活动，不忘初心，牢记自己曾经许下的诺言，时刻以一个共产党员的标准来要求自己。</p> <p>　　近年来，特别是在聆听了习近平总书记在党的十九大上作的报告后，看到近些年在党的领导下国家发展欣欣向荣，我打心底里钦佩，要求入党的愿望更强烈了。</p> <p>　　“成为中国共产党党员，是我一生中最大的幸事”</p> <p>　　记者：是什么让您再次写下入党申请书？</p> <p>　　牛犇：以前，“文革”等动荡的时候没能入党，后来又阴差阳错没入成党。再后来一段时间，我觉得现实中有的党员表现也未必就那么先进，我没有入党也是一样为党和人民作贡献，就耽搁了下来。现在想想，这是自我原谅，实际上是晚了，应该早入党。</p> <p>　　前不久，我和我们上影演员剧团团长佟瑞欣一起拍了电影《邹碧华》。邹碧华是一个真正的党员，事迹十分感人。正好那回上影集团开会，任仲伦在会上表扬我们剧组，我就觉得，我不是党员，但我应该努力，奔赴这个目标，成为一名真正的党员，我就给佟瑞欣写了张字条，“我们一块从今天起考虑塑造自己成为一个合格的中国共产党党员吧！”</p> <p>　　记者：听说您写入党申请书差不多写了一夜？</p> <p>　　牛犇：今年1月，我正式提交了入党申请书。申请书我写了几乎一整夜，很多内容的年份必须准确，等查清楚都半夜了，脑子已经迷糊了，就在桌前趴着睡了两个钟头，醒了就凌晨三四点了，继续写。那大段的入党志愿是一气呵成的，没有打草稿。我自己都没有想到，写得这么顺，大概是这些话搁在心里大半辈子了。</p> <p>　　这半年来，我一直心潮澎湃，我和组织说心里话，好几次我都说不下去了，激动。成为中国共产党党员，是我一生中最大的幸事。我人生中最重要的时刻，就是现在！我可以骄傲地说：从今天起，我是你们的同志了！</p> <p>　　“耄耋之年，更要追求思想和行动上的进步”</p> <p>　　记者：入党是一件神圣的事，在您身上体现得十分明显。您对党的感情，来自哪里？是什么让您矢志不渝追求进步？</p> <p>　　牛犇：我年幼时父母双亡，靠哥哥接济。一个偶然的机会，被沈浮等老一辈电影人发掘，在多部抗战爱国影片中扮演儿童角色，从此演了一辈子的电影。</p> <p>　　从小，我深受前辈对我的影响，他们教会我如何处事生活。我学的第一首歌，就是我拍第一部片子时一位场记老师教我的《卖报歌》，她非常关心我，那时我还不到11岁，总觉得她待我像自己的母亲，后来才知道，她是一位地下党员。</p> <p>　　新中国成立那天，我当时在香港拍戏，好几名演员兴奋地一路跑到大屿山，以每个人的身体作为一根线条，手拉手在山上拼出五角星。大哥哥大姐姐们告诉我，“中国人民解放了，共产党是太阳，照到哪里哪里亮，是共产党解救了大家，给了我们新生活。”我当时太小了，似懂非懂，他们就拍拍我的脑袋说，“从今后，你有饱饭吃了。”</p> <p>　　共产党救了中国，我认准了跟共产党干革命的道理。我加入上海电影制片厂，是上影的小青年，必须要求进步。我儿时失去父母，到上海又远离亲人，靠的就是组织。我敬佩的演员们，赵丹、黄宗英、王文娟、白杨、刘琼、秦怡，都纷纷加入了中国共产党。他们把入党当成一件神圣的事。我怎么比得上他们呢？但我暗下决心，一定要跟共产党干革命，一辈子不放弃，要求进步，以共产党员的标准来衡量自己，努力为党为人民工作，党指到哪里，我就到哪里。</p> <p>　　耄耋之年，更要追求思想和行动上的进步。就像邹碧华说的那样，“我们生活的世界本来不完美，但正因为它的不完美才需要我们去努力，去奋斗，我们的存在才有价值。”我觉得，我人生尚未完成的最大心愿就是加入中国共产党。所以，我正式递交了入党申请书。</p> <p>　　记者：宣誓入党时，您心情怎样？</p> <p>　　牛犇：今年5月31日，上影演员剧团支部党员大会上，我被投票吸收为预备党员。当时，我向大家读我的入党志愿，“我是在旧中国受苦受难下成长的城市贫民，家里穷，没吃过饱饭，从小便死了父母，随着哥哥流浪……儿时，又去了香港，在英国殖民统治下的中国人民依然是受苦受难……是共产党解救了我们的家，给我新生活……我也暗下决心，要跟着共产党干革命，一辈子不回头。”</p> <p>　　当时，我眼里都是泪，看不清字，抑制不住的哽咽，抑制不住的情绪。其实，我何止哭了一次两次？这是我的一件大事，我从小没有妈妈，我觉得，党就像我的母亲，入党的日子，就是我的生日！</p> <p>　　“只有跟着党，才能把有限的生命活得更有意义”</p> <p>　　记者：您是耄耋老人，也是一名“年轻”的党员。今后的工作中，您有怎样的打算？</p> <p>　　牛犇：我已经80多岁了，为党工作，我一定要珍惜。只有跟着党，才能把有限的生命活得更有意义。有生之年，我愿为党的电影事业努力地工作。</p> <p>　　回想我这几十年拍戏，我在上影厂曾经担任过电视部的主任，负责看剧本。我首先要看剧本的社会效益，就是这部戏对社会起什么作用。今后，这个标准不能放弃，也是我终身的标准。将来呢，肩上的责任更大了，因为我是一名党员，接个剧本、做什么事，不能仅凭个人的好恶，更要看它对社会的效应是什么。不管给不给酬劳，只要对社会有贡献，我就去演；如果没有，我跟以前一样，不管怎样，都不会去的。过去是这么做的，今后更要这样做。</p> <br /><span id=\"paper_num\">　　《 人民日报 》（ 2018年06月12日 18 版）</span>', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051126.html', '2018-06-12', 'http://politics.people.com.cn/n1/2018/0612/c1001-3', '“从今天起，我是你们的同志了”（深度关注）', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051126.html', '1528795505');
INSERT INTO `message_news` VALUES ('32', 'T1467284926140', 'News', '2079b10ed9fad6f4ccc44455956a9b2e', '<p>　　鸦片战争后，中国处于深重的民族危机之中。1916年，袁世凯被迫取消帝制。同年，李大钊留日归来，受梁启超等邀请主持《晨钟报》编辑工作。在创刊号上，李大钊发表《〈晨钟〉之使命——青春中华之创造》。</p><p>　　文中李大钊第一次阐明自己的“青春中华”理想，向青年发出奋起自觉的召唤。他指出，中华民族亟须解决的，不是亡与不亡的问题，而是如何再造青春；中国的出路在于摆脱旧传统、旧观念束缚，勇往奋进，急起直追，创造一个面向未来充满活力的青春中华。不久，李大钊的另一篇《青春》在《新青年》杂志社上发表。文章再次将爱国与救国高度统一，指出中国正处于黑暗与黎明之交，鼓励青年为建设蓬勃朝气的国家而奋斗，“不在龈龈辩证白首中国之不死，乃在汲汲孕育青春中国之再生”。</p><p>　　1918年，李大钊任北京大学图书馆主任，成为新文化运动主将，成为中国最早的马克思主义传播者之一。李大钊认为，古老的民族能否再现青春，关键“系乎青年之自觉如何耳”，因此致力于青年启蒙，做青年的良师挚友。</p><p>　　按照当时北京大学的薪酬待遇，李大钊每月240大洋。但他“茹苦食淡，冬一絮衣，夏一布衫”，夫人赵纫兰常为家中生计发愁——原因是李大钊常倾家纾难，接济贫寒学生。最后，北大校长蔡元培不得不关照会计科，每月发薪时先扣下一部分，亲手交给李夫人，免得李家“难为无米之炊”。</p><p>　　毛泽东后来回忆说，他去北大求职，受李大钊赏识，安排当助理员。在北大工作期间，他常旁听哲学和新闻课，想找名流请教，可“他们都是些大忙人，没有时间听一个图书馆助理员讲南方话”。而当时已是学界权威的李大钊，对这位只有中等师范学历的属员不仅有问必答，还常推荐新书。1949年，毛泽东率中央领导机关自西柏坡进入北平，感慨地说：30年前我为了寻求救国救民的真理而奔波……在北平遇到了一个大好人，就是李大钊同志。</p><p>　　“青春中华”之理想，奠定了李大钊一生为中华民族谋复兴的崇高使命感和不懈奋斗精神，让他成长为中国共产党最重要的创始人和革命家之一。1927年4月6日，李大钊被捕入狱。据当时报纸报道，他受审时“精神甚为焕发，态度极为镇静”，从容就义时未满38岁。</p><p>　　（作者单位：中国浦东干部学院）&nbsp;</p> <br /><span id=\"paper_num\">　　《 人民日报 》（ 2018年06月12日 18 版）</span>', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051127.html', '2018-06-12', 'http://politics.people.com.cn/n1/2018/0612/c1001-3', '“青春中华”理想的先行者（党史一叶）', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051127.html', '1528795505');
INSERT INTO `message_news` VALUES ('33', 'T1467284926140', 'News', '2e7c1d3f519e9a7cf4373959afa2d90a', '<p>　　“仅审核一份绿化工程合同，就为村里省了3.5万元！”日前，江苏泰州市姜堰区张甸镇张甸村党支部书记任荣寿，对村党组织纪检委员“三责一体”联督机制赞不绝口。</p><p>　　为解决长期以来村务监督容易“灯下黑”问题，姜堰区纪委2017年探索建立村党组织纪检委员“三责一体”联督机制，纪检委员同时担任党组织副书记、村务监督委员会主任。</p><p>　　去年7月，姜堰区纪委的一份“微官微权微腐败”专项治理行动总结材料显示：2017年二季度，共排查发现村组党员干部执行纪律不严、侵害集体和群众利益等不正之风和腐败问题线索107条，其中立案审查47人。“这47人中，竟然有村务监督委员会主任3人、村务监督委员会成员11人！”姜堰区纪委书记刘文来介绍，调研发现，村监会主任不是村党组织班子成员，党组织日常监督缺失；同时，村党组织未配备纪检委员，纪律监督缺位；此外，一些村监会成员年龄老化、业务不熟、责任心不强。</p><p>　　很快，区纪委从加强党内监督入手，推动全区262个村（居）配备党组织纪检委员，将党内监督责任延伸至基层一线。去年9月底，区纪委将推进村务监督作为履行专责监督的重要内容，在张甸镇探索建立村级党组织纪检委员“三责一体”试点，并向全区推开。“经过实践完善，村务监督逐步形成了制度链条。”张甸镇党委书记李伯群说，我们探索了村级会计集中委派、村级阳光财务“五个一”系统化监管、预算一村一晒单等制度，积极推行农村“三资”管理“制度+平台”新模式。</p><p>　　按照这一新机制要求，村纪检委员原则上由村党组织副书记兼任，并经镇（街道）纪（工）委牵头考察后，由党组织提名按规范程序担任村监会主任，实行“三责一体”联督机制，在村党组织书记领导下，除了开展日常监督工作外，负责村监会全面工作，发现涉嫌违纪问题线索直接向镇（街道）纪（工）委报告，并按镇（街道）纪（工）委要求配合做好相关协查处置工作。</p><p>　　这项新机制明确了村纪检委员日常监督、纪律监督、民主监督三项职责，赋予了村纪检委员知情权、审核权、询问权、建议权4项监督权力。此外，为了让村纪检委员履责村务监督有章可循，区纪委建立健全了履责记实、派单督导、重大事项双报告等11项工作制度，制定出台了村务监督“一卡通”、委派会计双报告、异村交叉“小巡察”等7项配套制度，进一步丰富了村纪检委员履责的监督手段和工作载体。</p><p>　　在监管考核方面，姜堰区强化组织保障机制，严把入口关，规定对村纪检委员的选拔任用，事先征求镇（街道）纪（工）委的意见，统一建档管理。特别是，区纪委专门出台挂联督导“两个责任”落实的工作制度，每月对各镇（街道）推动村纪检委员履职尽责情况进行专题督导和质效评估，对于工作滞后的，及时约谈督改；对于能力强、素质高、成绩突出的，优先选拔任用。</p><p>　　“刚开始有些不习惯，觉得干什么事都被盯着，慢慢就适应了。”张甸镇沙梓村第一书记兼村党支部书记刘林坦言，这既是一种监督，更是一种提醒和帮助。去年底，在农村集体“三资”监管平台数据录入过程中，张甸镇有9个村被所在村纪检委员审核发现存在鱼塘发包、店面出租、道路建设贴青补偿等集体收入少报、漏报问题，核增集体资产10多万元。</p><p>　　据悉，自村纪检委员“三责一体”联督机制全面推行以来，全区已有167个村的纪检委员发现并上报各类违纪违规问题线索229个，成案35件，对项目建设、农村低保、村庄规划、土地流转等103个村务事项提议进行政策把关，叫停或纠正27项。</p><p>　　“村纪检委员‘三责一体’联督机制，有助于破解过去村务监督弱化、纪律监督缺位、民主监督乏力等问题，有助于推动日常监督系统化、纪律监督全面化、民主监督立体化。”姜堰区委书记李文飙说。</p> <br /><span id=\"paper_num\">　　《 人民日报 》（ 2018年06月12日 18 版）</span>', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051128.html', '2018-06-12', 'http://politics.people.com.cn/n1/2018/0612/c1001-3', '让村务监督远离“灯下黑”', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051128.html', '1528795505');
INSERT INTO `message_news` VALUES ('34', 'T1467284926140', 'News', '6fdcfe5484d3e094d2f4b8ef99a43fda', '<table class=\"pci_c\" width=\"400\"><tbody><tr><td align=\"center\"><img src=\"http://paper.people.com.cn/rmrb/res/1/20180612/1528746964028_1.jpg\" /></td></tr> <tr><td><p></p></td></tr></tbody></table><p>　　近年来，山东平原县建立党员与贫困户利益联结机制，通过项目发展带动农民脱贫致富，取得了明显成效。</p> <p>　　图为近日平原县党员服务队队员（右）来到坊子乡任铺村大棚扶贫项目的农户蔬菜大棚，向农户讲解大棚种植技术和电商销售技巧。</p> <p>　　张&nbsp;&nbsp;峰摄&nbsp;&nbsp;</p> <br /><span id=\"paper_num\">　　《 人民日报 》（ 2018年06月12日 18 版）</span>', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051129.html', '2018-06-12', 'http://politics.people.com.cn/n1/2018/0612/c1001-3', '党员服务队 扶贫到一线', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051129.html', '1528795505');
INSERT INTO `message_news` VALUES ('35', 'T1467284926140', 'News', 'fe7eec5149b4d4c6e09efd28949770a4', '<table class=\"pci_c\" width=\"400\"><tbody><tr><td align=\"center\"><img src=\"http://paper.people.com.cn/rmrb/res/1/20180612/1528746745690_1.jpg\" /></td></tr> <tr><td><p></p></td></tr></tbody></table><p>　　为广泛宣传习近平新时代中国特色社会主义思想，河南漯河源汇区在辖区社区老党员家中建成10所讲习所，聘请党校教师、驻区企业党组织负责人、基层党组织书记、退休老教师、老党员等组成讲师团，采取集中讲习、流动讲习等形式，广泛宣讲党的路线方针政策、法律法规、廉政党课等知识。</p> <p>　　图为近日源汇区委党校教师田丽娜（右一）来到东安街老党员陈红乐家中的讲习所为东安街党小组宣讲法律法规。</p> <p>　　尤亚辉摄（人民视觉）&nbsp;&nbsp;</p> <br /><span id=\"paper_num\">　　《 人民日报 》（ 2018年06月12日 17 版）</span>', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051137.html', '2018-06-12', 'http://politics.people.com.cn/n1/2018/0612/c1001-3', '社区有了讲习所', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051137.html', '1528795505');
INSERT INTO `message_news` VALUES ('36', 'T1467284926140', 'News', '8f750dc05962211f126d991273174892', '<p>　　“这件事后，我酒醒了，心里也彻底醒悟了，对此产生的恶劣影响懊悔不已……”今年4月，四川凉山彝族自治州普格县荞窝镇党委书记李宗强在检讨中这样写道。</p> <p>　　3月27日，州委脱贫攻坚督导组来到荞窝镇，准备对之前反馈给该镇并要求限时整改的10个问题进行督查。闻讯赶来的李宗强满身酒气地出现在督导组面前，既不能按要求提供脱贫攻坚整改相关材料，也不能汇报清已经整改到位的8项相关内容。</p> <p>　　经查，27日当天，为感谢村镇干部对自家烤烟生产的支持，荞窝镇云盘山村的烟农何早日准备了猪羊、香烟、啤酒等，在镇政府食堂请客。中饭时，李宗强和镇村干部等11人陆续赶来赴宴。酒足饭饱后，李宗强回宿舍休息，下午3时，他又喝了20多杯啤酒，直至下午4时知晓州委督导组已到荞窝镇后才匆匆离开饭桌，而其余人继续饮酒，直至当晚7时才结束。</p> <p>　　“为什么在工作日带头饮酒？”调查人员问。</p> <p>　　“我考虑干部们下村都辛苦了，喝点酒没什么大事……是我太缺乏纪律意识，竟然默许服务对象宴请干部，不仅没及时制止，还参与饮酒，带头违反纪律……”李宗强后悔不迭。</p> <p>　　针对“四风”问题出现的新变种，2月9日，州委州政府在《关于印发〈改进工作作风、密切联系群众十项规定实施细则〉的通知》中明文规定“公务接待一律禁止饮酒，工作时间内和工作日午间一律不准饮酒”。毫无疑问，李宗强此举正是顶风违纪的典型案例。</p> <p>　　问题查实后，4月5日，普格县委召开全县干部大会，专题通报李宗强等干部违反中央八项规定精神问题，以及脱贫攻坚督导反馈问题整改资料收集归档责任不落实等问题，要求全县各级各部门引以为戒、自查自纠。4月9日，普格县纪委给予李宗强党内严重警告处分；给予镇计生专干勒尔沙曲党内严重警告处分；给予小田坝村代理村支书和代理村委会主任党内警告处分。镇党委副书记、纪委书记刘雪松因监督责任缺失被诫勉谈话。其他参与饮酒的干部均按违纪情节被诫勉谈话和批评教育。</p> <p>　　</p> <p>　　【执纪者说】</p> <p>　　分析本案，李宗强的行为表面是吃吃喝喝的小毛病，根子里折射的是纪律规矩意识淡薄、群众观念淡漠、工作作风漂浮的大问题。基层干部离群众最近，一言一行事关组织形象。当前，凉山正值脱贫攻坚的关键时期，要打赢脱贫攻坚战，必须打赢作风攻坚战。我们将以“公务接待一律不喝酒、工作日午间一律不喝酒”为作风建设突破口，把贯彻落实中央八项规定精神往深里抓、往实里做，抓长抓常、久久为功。</p> <p>　　——四川省凉山彝族自治州纪委书记、监委主任&nbsp;张&nbsp;力&nbsp;</p> <br /><span id=\"paper_num\">　　《 人民日报 》（ 2018年06月12日 17 版）</span>', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051138.html', '2018-06-12', 'http://politics.people.com.cn/n1/2018/0612/c1001-3', '工作日醉酒迎检查——查！（监督哨）', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051138.html', '1528795505');
INSERT INTO `message_news` VALUES ('37', 'T1467284926140', 'News', '8f2c0e1cffc5deb7f665aaf9149b8b71', '<p>　　新华社北京6月11日电&nbsp;&nbsp;中共中央总书记、国家主席、中央军委主席习近平近日对脱贫攻坚工作作出重要指示强调，脱贫攻坚时间紧、任务重，必须真抓实干、埋头苦干。各级党委和政府要以更加昂扬的精神状态、更加扎实的工作作风，团结带领广大干部群众坚定信心、顽强奋斗，万众一心夺取脱贫攻坚战全面胜利。</p><p>　　习近平指出，打赢脱贫攻坚战，对全面建成小康社会、实现“两个一百年”奋斗目标具有十分重要的意义。行百里者半九十。各级党委和政府要把打赢脱贫攻坚战作为重大政治任务，强化中央统筹、省负总责、市县抓落实的管理体制，强化党政一把手负总责的领导责任制，明确责任、尽锐出战、狠抓实效。要坚持党中央确定的脱贫攻坚目标和扶贫标准，贯彻精准扶贫精准脱贫基本方略，既不急躁蛮干，也不消极拖延，既不降低标准，也不吊高胃口，确保焦点不散、靶心不变。要聚焦深度贫困地区和特殊贫困群体，确保不漏一村不落一人。要深化东西部扶贫协作和党政机关定点扶贫，调动社会各界参与脱贫攻坚积极性，实现政府、市场、社会互动和行业扶贫、专项扶贫、社会扶贫联动。</p><p>　　中共中央政治局常委、国务院总理李克强作出批示指出，实现精准脱贫是全面建成小康社会必须打赢的攻坚战，是促进区域协调发展的重要抓手。各地区各部门要全面贯彻党的十九大精神，以习近平新时代中国特色社会主义思想为指导，认真落实党中央、国务院关于打赢脱贫攻坚战三年行动的决策部署，进一步增强责任感紧迫感，坚持精准扶贫精准脱贫基本方略，聚焦深度贫困地区和特殊贫困群体，细化实化政策措施，落实到村到户到人，加强项目资金管理，压实责任，严格考核，凝聚起更大力量，真抓实干，确保一年一个新进展。要注重精准扶贫与经济社会发展相互促进，注重脱贫攻坚与实施乡村振兴战略相互衔接，注重外部帮扶与激发内生动力有机结合，推动实现贫困群众稳定脱贫、逐步致富，确保三年如期完成脱贫攻坚目标任务。</p><p>　　打赢脱贫攻坚战三年行动电视电话会议11日上午在京举行。中共中央政治局委员、国务院扶贫开发领导小组组长胡春华出席会议并讲话。他强调，各地区、各有关部门要深入学习贯彻习近平总书记关于脱贫攻坚的重要指示精神，落实李克强总理批示要求，按照党中央、国务院决策部署，旗帜鲜明地把抓落实、促攻坚工作导向树立起来，坚持目标标准，贯彻精准方略，压实攻坚责任，打造过硬的攻坚队伍，完善督战机制，加强作风建设，扎扎实实地把各项攻坚举措落到实处，坚决打赢脱贫攻坚战。</p><p>　　会议传达了习近平重要指示和李克强批示，安排部署今后三年脱贫攻坚工作。有关省区负责同志在会上发言。</p><p>　　国务院扶贫开发领导小组成员、中央和国家机关有关部门负责同志、省部级干部“学习贯彻习近平新时代中国特色社会主义思想，坚决打好精准脱贫攻坚战”专题研讨班学员参加会议。各省、自治区、直辖市和新疆生产建设兵团，中央党校（国家行政学院）设分会场。</p> <br /><span id=\"paper_num\">　　《 人民日报 》（ 2018年06月12日 01 版）</span>', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051070.html', '2018-06-12', 'http://politics.people.com.cn/n1/2018/0612/c1001-3', '真抓实干埋头苦干万众一心 夺取脱贫攻坚战全面胜利', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051070.html', '1528795505');
INSERT INTO `message_news` VALUES ('38', 'T1467284926140', 'News', '694b5bcd5f607a7234ff3e4f1cdddb0e', '<p>　　本报北京6月11日电&nbsp;&nbsp;（记者王比学）十三届全国人大常委会第五次委员长会议11日上午在北京人民大会堂举行。会议决定，十三届全国人大常委会第三次会议6月19日至22日在北京举行。栗战书委员长主持会议。</p><p>　　委员长会议建议，十三届全国人大常委会第三次会议的议程是：审议电子商务法草案、人民法院组织法修订草案、人民检察院组织法修订草案；审议全国人大常委会委员长会议关于提请审议关于宪法和法律委员会职责问题的决定草案的议案，中央军委关于提请审议关于中国海警局履行海上维权执法职权的决定草案的议案等。</p><p>　　委员长会议建议的议程还有：审议国务院关于2017年中央决算的报告，审查和批准2017年中央决算；审议国务院关于2017年度中央预算执行和其他财政收支的审计工作报告；审议国务院关于坚持创新驱动发展深入推进国家科技重大专项工作情况的报告，关于研究处理固体废物污染环境防治法执法检查报告及审议意见情况的报告；审议全国人大常委会执法检查组关于检查统计法实施情况的报告；审议栗战书委员长访问埃塞俄比亚、莫桑比克、纳米比亚情况的书面报告；审议全国人大常委会代表资格审查委员会关于个别代表的代表资格的报告；审议有关任免案。</p><p>　　委员长会议上，全国人大常委会秘书长杨振武就常委会第三次会议议程草案、日程安排意见等作了汇报。全国人大常委会有关副秘书长，全国人大有关专门委员会、常委会有关工作委员会负责人就常委会第三次会议有关议题作了汇报。</p><p>　　全国人大常委会副委员长曹建明、张春贤、沈跃跃、吉炳轩、艾力更·依明巴海、万鄂湘、陈竺、王东明、白玛赤林、丁仲礼、郝明金、蔡达峰、武维华出席会议。</p> <br /><span id=\"paper_num\">　　《 人民日报 》（ 2018年06月12日 01 版）</span>', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051073.html', '2018-06-12', 'http://politics.people.com.cn/n1/2018/0612/c1001-3', '栗战书主持召开第五次委员长会议', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051073.html', '1528795505');
INSERT INTO `message_news` VALUES ('39', 'T1467284926140', 'News', '12d51f86df40d1d8501f46de027e150d', '<p>　　新华社北京6月11日电&nbsp;近日，中共中央办公厅、国务院办公厅、中央军委办公厅印发《关于深入推进军队全面停止有偿服务工作的指导意见》，为军地各级深入推进军队全面停止有偿服务工作提供了重要遵循。</p> <p>　　《指导意见》指出，军队全面停止有偿服务，是党中央、中央军委和习近平总书记着眼实现党在新时代的强军目标、全面建成世界一流军队作出的重大战略决策，是深化国防和军队改革的重要内容。这项工作自2016年年初开展以来，经过各方共同努力，组织领导、政策制度、军地联动、司法保障体系逐步建立完善，项目清理停止成效明显，人员分流安置顺利，善后问题处理平稳，保持了部队和社会两个大局稳定。当前，军队全面停止有偿服务工作正处在决战决胜的关键时期，部队各级、地方各级党委和政府必须坚定信心决心，强化工作统筹，密切军地配合，聚力攻坚克难，确保如期完成军队全面停止有偿服务这一政治任务、国家任务、强军任务。</p> <p>　　《指导意见》强调，要准确把握军队全面停止有偿服务重大战略决策意图，按照军队不经营、资产不流失、融合要严格、收支两条线的标准，坚持坚决全面、积极稳妥、军民融合，按计划分步骤稳妥推进，到2018年年底前全面停止军队一切有偿服务活动，为永葆我军性质宗旨和本色、提高部队战斗力创造有利条件。坚决停止一切以营利为目的、偏离部队主责主业、单纯为社会提供服务的项目。开展有偿服务的项目，合同协议已到期的应予终止，不得续签，全部收回军队资产；合同协议未到期的，通过协商或司法程序能够终止的项目，应提前解除合同协议，确需补偿的，按照国家法律规定给予经济补偿。</p> <p>　　《指导意见》明确，对复杂敏感项目，区分不同情况，主要采取委托管理、资产置换、保障社会化等方式进行处理，国家和地方政府在政策上给予支持。对已融入驻地城市发展规划，直接影响社会经济发展和民生稳定，合同协议期限较长、承租户投资大，有潜在军事利用价值，确实难以关停收回的项目，可以实行委托管理。对独立坐落或者能够与在用营区相对分离，军事利用价值不高，已经形成事实转让的项目，由中央军委审批确定后，可以采取置换等方式处理。对部队营区内引进社会力量服务官兵工作、生活的房地产租赁项目，纳入保障社会化范围，规范准入条件、运行方式、优惠措施、经费管理等，更好地服务部队、惠及官兵。</p> <p>　　《指导意见》明确，军队全面停止有偿服务后，将国家赋予任务、军队有能力完成的，军队特有或优势明显、国家建设确有需要的，以及军队引进社会力量服务官兵的项目，纳入军民融合发展体系。对需纳入军民融合发展体系的行业项目，由军地有关部门研究提出有关标准条件、准入程序、审批权限、运行管理等政策办法，实行规范管理，严格落实收支两条线政策规定。对军队全面停止有偿服务后空余房地产、农副业生产用地、大型招待接待资产，全部由中央军委集中管理、统筹调控。</p> <p>　　《指导意见》强调，军队全面停止有偿服务是军队、中央和国家机关、地方党委和政府的共同责任。各有关方面要高度重视，牢固树立“四个意识”，加强组织领导和工作统筹，党委领导同志要敢于担当、勇于负责，对复杂敏感项目要亲自上手、一抓到底。要严肃工作纪律，适时开展专项巡视和审计，查处违纪违法问题。要以严实作风推动工作高标准落实，确保如期圆满完成军队全面停止有偿服务任务。</p> <p>&nbsp;&nbsp;&nbsp;&nbsp;（相关报道见第四、十六版）</p> <br /><span id=\"paper_num\">　　《 人民日报 》（ 2018年06月12日 01 版）</span>', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051071.html', '2018-06-12', 'http://politics.people.com.cn/n1/2018/0612/c1001-3', '《关于深入推进军队全面停止有偿服务工作的指导意见》', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051071.html', '1528795505');
INSERT INTO `message_news` VALUES ('40', 'T1467284926140', 'News', '74651982f72b5195bda1fcd29e24e088', '<p>　　新华社北京6月11日电&nbsp;&nbsp;根据国务院常务会议关于推进政务服务“一网通办”和企业群众办事“只进一扇门”“最多跑一次”的部署，为广泛听取群众和企业意见，充分发挥社会监督作用，切实解决企业和群众在政务服务中遇到的困难和问题，6月11日起，国务院办公厅在中国政府网开通“政务服务举报投诉平台”信箱（liuyan.www.gov.cn/zwfwjbts/），统一接受社会各界对涉企乱收费、涉企政策不落实、未实现政务服务“一网通办”、群众和企业办事不便利，以及其他政务服务不到位等问题的投诉。</p><p>　　国务院办公厅将对投诉事项进行核查处理，督促有关地方和部门查清问题、查明原因、整改解决，确保国家优化政务服务的政策措施落实到位，加快营造稳定公平透明可预期的营商环境，切实增强群众和企业对“放管服”改革的获得感。对存在失职渎职、懒政怠政情况的，依法依规严肃问责。</p> <br /><span id=\"paper_num\">　　《 人民日报 》（ 2018年06月12日 02 版）</span>', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051082.html', '2018-06-12', 'http://politics.people.com.cn/n1/2018/0612/c1001-3', '统一接受社会各界关于政务服务事项的投诉', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051082.html', '1528795505');
INSERT INTO `message_news` VALUES ('41', 'T1467284926140', 'News', '4ecb6aefb3498b1ea9cfe162c9fd5b4f', '<p>　　新华社北京6月11日电&nbsp;&nbsp;日前，国务院办公厅印发《关于推进奶业振兴保障乳品质量安全的意见》（以下简称《意见》），全面部署加快奶业振兴，保障乳品质量安全工作。</p><p>　　《意见》要求，要全面贯彻党的十九大和十九届二中、三中全会精神，以习近平新时代中国特色社会主义思想为指导，按照高质量发展的要求，以优质安全、绿色发展为目标，以推进供给侧结构性改革为主线，以降成本、优结构、提质量、创品牌、增活力为着力点，加快构建现代奶业产业体系、生产体系、经营体系和质量安全体系，不断提高奶业发展质量效益和竞争力，大力推进奶业现代化，为决胜全面建成小康社会提供有力支撑。</p><p>　　《意见》提出，到2020年，奶业供给侧结构性改革取得实质性成效，奶业现代化建设取得明显进展。100头以上规模养殖比重超过65%，奶源自给率保持在70%以上。婴幼儿配方乳粉的品质、竞争力和美誉度显著提升，乳制品供给和消费需求更加契合。乳品质量安全水平大幅提高，消费信心显著增强。到2025年，奶业实现全面振兴，奶源基地、产品加工、乳品质量和产业竞争力整体水平进入世界先进行列。</p><p>　　《意见》明确了实现上述目标的主要任务和工作措施。一是加强优质奶源基地建设。优化奶源基地布局，丰富奶源结构，发展标准化规模养殖，加强良种繁育及推广，打造高产奶牛核心育种群，促进优质饲草料生产，提高奶牛生产效率和养殖收益。二是完善乳制品加工和流通体系。优化乳制品产品结构，建立现代乳制品流通体系，不断满足消费多元化需求。密切养殖加工利益联结，培育壮大奶农专业合作组织，促进养殖加工一体化发展，规范生鲜乳购销行为。三是强化乳品质量安全监管。修订提高生鲜乳、灭菌乳、巴氏杀菌乳等乳品国家标准，监督指导企业按标依规生产。落实乳品企业质量安全第一责任，建立健全养殖、加工、流通等全过程乳品质量安全追溯体系。严格执行相关法律法规和标准，进一步提升国产婴幼儿配方乳粉的品质和竞争力。四是加大乳制品消费引导。积极宣传奶牛养殖、乳制品加工和质量安全监管等发展成效，定期发布乳品质量安全抽检监测信息，展示国产乳制品良好品质。实施奶业品牌战略，培育优质品牌。推广国家学生饮用奶计划，倡导科学饮奶，培育国民食用乳制品的习惯。</p><p>　　《意见》强调，各地区、各有关部门要按照职责分工，加大工作力度，强化协同配合，制定和完善具体政策措施，抓好贯彻落实，确保完成工作目标。</p> <br /><span id=\"paper_num\">　　《 人民日报 》（ 2018年06月12日 02 版）</span>', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051081.html', '2018-06-12', 'http://politics.people.com.cn/n1/2018/0612/c1001-3', '推进奶业振兴保障乳品质量安全', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051081.html', '1528795505');
INSERT INTO `message_news` VALUES ('42', 'T1467284926140', 'News', '1c53db11c33511de4efe0c1e8eecc5a4', '<p>　　“有3个案件已经亮起了黄灯，小林，通知承办部门加快办案进度！”广东省惠州市惠城区纪委案管室主任胡火仲每天上班第一件事，就是打开“纪检监察信息管理系统”平台，跟踪所有案件办理进度。</p><p>　　据介绍，“纪检监察信息管理系统”是惠城区纪委打造的数字化、信息化、智能化平台，该平台延伸到镇、街道，对案件实行统一归口管理。</p><p>　　在惠城区纪检监察信息管理系统指挥中心，记者看到，轻敲键盘，输入案件编号，就能立刻调取案件的所有资料，看到每个案件进展。从线索录入开始，所有环节都置于“监控”之下——谁在办、如何办；已结案或未超时的案件，显示“绿灯”，距办结时限15天的显示“黄灯”，已经超过办结时限的触发“红灯”。</p><p>　　近期，因被系统亮“红灯”，部分工作履职不力、严重超期办理案件的部门和工作人员已被通报批评。</p><p>　　“在使用信息管理系统之前，每次一统计数据需要翻阅一本又一本的卷宗，不仅效率低下，还极容易出现数据不完整情况。”提起之前找数据的“狼狈”，惠城区纪委案管室的纪检干部小张有些无奈。这种情况，在“纪检监察信息管理系统”平台使用以后就再也没有出现过了。</p><p>　　“你看，被反映人的职级、身份、违反纪律的类型、处分类型都有显示，分类非常科学。”除此之外，还可自动生成可视化的图表，根据这些数据，纪委可以针对反映较集中的问题和对象开展提醒谈话，抓早抓小，防微杜渐。</p><p>　　效率高了，办案成本也更节省了。“我们芦洲是惠城区最偏远的镇，离惠城区中心区100多公里。以前每办一个案件，光纸质材料就有好几箱，为了请示、盖章等，最少要往返中心区十几趟，来回一趟超过200公里，仅路程花费时间就将近4个小时。自从用了信息化管理系统，实现无纸化办公，网上呈批，节省了大量人力物力。”芦洲镇纪委的一名老纪检干部，对信息系统赞不绝口。</p><p>　　记者看到，信息系统还具有文书自动生成功能，通过事先设定好的程序，根据录入案件信息时输入的基本信息，自动生成初核报告、立案报告、审理报告等纪检文书模板。“根据案件需要，我们工作人员再对报告进一步完善补充，短时间内就可以完成一份审理报告。”惠城区纪委审理室的一名“老审理”感叹。</p><p>　　“纪检监察信息管理系统”平台上线3年，惠城区纪委立案数量翻了一番，办案效率大大提高，实现问题线索“零暂存”，问题线索100%初核。</p> <br /><span id=\"paper_num\">　　《 人民日报 》（ 2018年06月12日 11 版）</span>', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051152.html', '2018-06-12', 'http://politics.people.com.cn/n1/2018/0612/c1001-3', '监督效率高了 办案成本低了', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051152.html', '1528795505');
INSERT INTO `message_news` VALUES ('43', 'T1467284926140', 'News', '19e7c0de799d98cdc30a16234f7dba3b', '<div align=\"center\" id=\"paper_pc_play\" style=\"padding: 10px 0 15px 0;\"> </div> <table class=\"pci_c\" width=\"400\"><tbody><tr><td align=\"center\"><img src=\"http://paper.people.com.cn/rmrb/res/2018-06/12/17/rmrb2018061217p9_b.jpg\" /></td></tr> <tr><td><p></p></td></tr></tbody></table><p>　　扶珂村盛产煤炭，曾是远近闻名的富裕村，按理说“家底”应当挺厚实，为何会沦为省级贫困村？如何让这个衰落的小村庄摘掉穷帽子，重新走上振兴之路？2016年10月底，带着重重疑问，我从涟源市扶贫办来到扶珂村，担任第一书记。</p><p>　　驻村伊始，我花大量的时间摸清扶珂村从贫穷到致富、再到“返贫”的发展脉络，找准了“病根”。扶珂村地处涟源市与冷水江市交界处，这里曾经满地都是“黑金”。1989年，村里开始发展煤炭产业，家家户户靠着煤炭赚生计。上世纪90年代，村里就涌现出第一批“百万户”。2012年下半年，煤炭业突然变天，煤价大跌，煤矿相继关停。2014年，随着村里最后一家煤炭企业因经营不善停产，扶珂村正式告别“黑金时代”。全村920户、3000多人，2014年的贫困发生率高于23%，被认定为省级贫困村。</p><p>　　过去，村里许多人习惯了“赚快钱”，既不愿重拾锄头，也不想外出打工，“懒贫”现象十分突出，受“等靠要”思想影响，大家争当贫困户，村里把贫困户的“帽子”当福利，评议时搞“平均主义”。</p><p>　　精准识别，是脱贫攻坚的第一步。2016年底，我召集村“两委”开会，宣讲精准扶贫的政策精神，决定重新评议贫困户。这一下在村里掀起不小波澜，一些夹杂在贫困户中的“非贫困户”意见很大。对此，驻村工作队和村“两委”一道，在村里广泛宣传“贫困户不是荣誉”，大力营造脱贫光荣的氛围，并反复上门，做那些“非贫困户”的思想疏导工作。</p><p>　　2017年4月，村里召开评议大会，55名党员、27个村民小组组长，以及村民代表共141人参加评议。经上级审核，我们重新评定了150户贫困户、621人，比整改前减少了46户、59人。评议公开透明，群众满意。被“评议”的一些贫困户也不再消极懈怠，下定决心改变贫困的面貌。</p><p>　　脱贫攻坚，需要找到确保长期稳定脱贫的产业路子。年长的村民多次提到开矿前的扶珂村，那时山林秀美、流水潺潺、稻花飘香。可如今，煤炭开采区水土流失严重，还有不少山林田地被撂荒。摸索致富道路时，我认识到，应当把产业脱贫和生态修复结合起来。</p><p>　　发展绿色经济，我们相中的是名叫玳玳酸橙的橘科植物。玳玳酸橙极具观赏价值，果实可入药，可制作食品工业中常用的高倍甜味剂，市场紧俏、卖得上价。最重要的是，涟源气候湿润温和，非常适宜种植。</p><p>　　做好“前期功课”，我和村“两委”到福建建阳考察中国最大的玳玳酸橙基地，学习种植技术，又找到一家省级龙头企业，签订果实收购协议。我们仔细测算过，除去养护、采摘、运输及加工成本，每亩纯收入超过6000元。</p><p>　　瞄准产业，说干就干。回到村里，我们流转了670亩荒山。春天是种植的好时节，今年3月，我们共种植了450亩玳玳酸橙，70多户贫困户以及4户非贫困户参与进来。放眼望去，过去杂草丛生、岩石裸露的山坡萌发出新的绿意。市里有“联村建绿”项目，在我们争取下，项目也顺利落地。如今，村前屋后、道路两旁种上了1800多株樱花、200多株茶花。利用荒废的秧田，我们种植了70亩荷花，既可赏花，还能品莲，还有企业找上门来，愿意保底回收莲子。了解到油茶对土壤“要求不严”，拥有能耐瘠薄土地等特点，我们规划在开采区种植500亩油茶……如今在扶珂村，一条绿色发展道路，正在把“荒土地”变成“聚宝盆”。</p><p>　　（本报记者王云娜采访整理）&nbsp;</p> <br /><span id=\"paper_num\">　　《 人民日报 》（ 2018年06月12日 17 版）</span> <div id=\"xgyd\" style=\"padding: 5px 15px 25px;\"> <h4 style=\"border-bottom: 1px dashed #a01211;\"></h4> <span class=\"tz_input\" style=\"width: 104px; height: 26px; font-size: 16px; display: block; vertical-align: middle; text-align: center; line-height: 26px; margin-top: 20px; margin-bottom: 20px;\"><a href=\"http://tv.people.com.cn/n1/2018/0510/c364580-29978368.html\" style=\"color: #A01211; font-weight: bold; display: block; text-decoration: none; border: 1px dotted red;\" target=\"_blank\">延伸阅读</a></span> </div>', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051139.html', '2018-06-12', 'http://politics.people.com.cn/n1/2018/0612/c1001-3', '把“荒土地”变成“聚宝盆”（扶贫手记）', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051139.html', '1528795505');
INSERT INTO `message_news` VALUES ('44', 'T1467284926140', 'News', 'f50d9e419b32d753631eef837b7b14d7', '<p> 　　本报北京6月11日电&nbsp;&nbsp;（记者杨昊）全国工商联11日召开“工商联系统援藏援疆电视电话动员会”，部署“精准扶贫西藏行”和“光彩事业南疆行”工作任务，助力西藏地区和新疆南疆四地州打赢脱贫攻坚战。全国政协副主席、全国工商联主席高云龙出席会议并讲话。</p> <p> 　　高云龙指出，组织民营企业参与援藏援疆，是工商联学习贯彻习近平新时代中国特色社会主义思想的重要内容。各级工商联要通过“万企帮万村”行动领导小组的工作机制和平台，将民营企业的帮扶力量引入深度贫困地区。各对口支援省市工商联要将援藏援疆工作纳入重要议事日程，建立工作机制，细化量化目标任务，抓好工作督促落实。要在做好项目推介和精准对接基础上，着力加强对项目落地的跟踪服务。要注重宣传表彰，激发和带动民营企业参与援藏援疆的热情，传递民营企业正能量。</p> <br /> <p> <span id=\"paper_num\">　　《 人民日报 》（ 2018年06月12日 09 版）</span></p>', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051142.html', '2018-06-12', 'http://politics.people.com.cn/n1/2018/0612/c1001-3', '全国工商联召开电视电话动员会 助力西藏新疆打赢脱贫攻坚战', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051142.html', '1528795505');
INSERT INTO `message_news` VALUES ('45', 'T1467284926140', 'News', '36fad28857a0f668d7ab464f0ea0c600', '<p>　　本报福州6月11日电&nbsp;&nbsp;（记者何璐）记者日前从福建省人社厅获悉：从2015年至今，福建每年遴选一批技术水平高、创新能力强、发展潜力大的互联网经济优秀人才创业项目，按重点项目、优秀项目、入选项目三类，分别给予100万元、50万元、30万元的创业资金支持。3年来，共安排扶持资金5810万元，对120个互联网经济优秀创业人才（团队）和项目予以资金扶持。</p><p>　　近日，福建省人社厅公布2017年互联网经济优秀人才创业启动支持对象名单，确定高钦泉等50人（团队）及其项目为支持对象，并按规定给予创业资金支持。据悉，此次申报人数由2015年的80人、2016年的99人上升到2017年的179人，同比增长80%；支持资金总数由2015年的1730万元、2016年的1980万元增加到2017年的2100万元。</p> <br /><span id=\"paper_num\">　　《 人民日报 》（ 2018年06月12日 09 版）</span>', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051143.html', '2018-06-12', 'http://politics.people.com.cn/n1/2018/0612/c1001-3', '福建扶持互联网经济人才创新创业', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051143.html', '1528795505');
INSERT INTO `message_news` VALUES ('46', 'T1467284926140', 'News', 'dffb4be408dd2e72e15b5de2a1d6db4b', '<p> 　　新华社青岛6月11日电 <strong>题：携手前进，开启上合发展新征程——习近平主席主持上合组织青岛峰会并举行系列活动纪实</strong></p> <p> 　　新华社记者霍小光、李忠发、刘华</p> <p> 　　凭阑观潮起，逐浪扬风帆。</p> <p> 　　6月9日至10日，国家主席习近平在中国青岛主持上海合作组织成员国元首理事会第十八次会议。欢迎晚宴、小范围会谈、大范围会谈、双边会见、三方会晤……短短两天时间，20余场正式活动，峰会达成广泛共识、取得丰硕成果，引领上海合作组织迈上新起点。</p> <p> 　　面对世界百年未有之大变局，习近平主席立足欧亚、放眼全球，同与会各方论“上海精神”、提中国方案、谋地区合作、绘发展蓝图，尽显世界级领导人的自信从容与责任担当。</p> <p> 　　黄海之滨，浮山湾畔。风景秀丽的“帆船之都”，奔涌着开放包容、合作共赢的澎湃力量。</p> <p> 　　<strong>海纳百川，见证开放包容的大国襟怀</strong></p> <p> 　　一年前，上合组织阿斯塔纳峰会，中国接棒轮值主席国。青岛峰会筹备期间，习近平主席亲笔签署的一份份邀请信函，送达成员国、观察员国领导人手中。</p> <p> 　　应约而至，风云际会。</p> <p> 　　6月8日至9日下午，一架架飞机降落在青岛流亭国际机场。上合组织领导人齐聚黄海之滨，共商合作发展大计。</p> <p> 　　“有朋自远方来，不亦乐乎？”</p> <p> 　　9日晚，国际会议中心宴会厅，巨幅工笔画《花开盛世》赏心悦目。</p> <p> 　　习近平主席微笑同远道而来的各国贵宾一一握手寒暄，表达东道主的真诚与热情。</p> <p> 　　这是习近平主席作为中国国家元首首次主持上合组织峰会。阔别6年，上合组织再次回到诞生地，国际社会热切期待，进入新时代的中国为上合组织注入新动力。</p> <p> 　　齐鲁大地、孔孟之乡，人文气息扑面而来。</p> <p> 　　“儒家倡导‘大道之行，天下为公’，主张‘协和万邦，和衷共济，四海一家’。这种‘和合’理念同‘上海精神’有很多相通之处。”欢迎宴会上，习近平主席致祝酒辞，道出中国理念和“上海精神”的内在联系。</p> <p> 　　互信、互利、平等、协商、尊重多样文明、谋求共同发展的“上海精神”是上合组织发展的灵魂和根基；和而不同、世界大同，是“和合”思想的时代思辨，是中国理念同“上海精神”的琴瑟和鸣。</p> <p> 　　这是一次展示理念的生动实践——</p> <p> 　　6日下午5时许，北京人民大会堂东门外广场。新改革的国事访问欢迎仪式首次启用，习近平主席热情欢迎首位抵达中国的上合组织外方领导人——吉尔吉斯斯坦总统热恩别科夫。</p> <p> 　　“中国有礼仪之大，故称夏；有服章之美，谓之华。”外交礼宾细节之变，折射出日益走向世界舞台中央的东方大国，从容自信的心态、沉稳大气的仪态、诚挚友好的姿态。</p> <p> 　　源远流长的儒家文化、会场内的亭台楼阁元素、地方特色的节目表演……上合组织青岛峰会一个个细节凸显中国传统底蕴。</p> <p> 　　这是一次新的“大家庭”聚会——</p> <p> 　　作为上合组织接收印度、巴基斯坦为成员国，实现组织扩员后首次举行的元首理事会会议，青岛峰会承载着承前启后、继往开来的特殊意义。</p> <p> 　　“这是巴基斯坦首次以正式成员身份参加上海合作组织峰会，所以会议具有新的意义。”9日下午，国际会议中心安仁厅，习近平主席会见巴基斯坦总统侯赛因，强调了这次峰会特别之处。</p> <p> 　　一个多月前，习近平主席同印度总理莫迪刚刚在武汉举行非正式会晤。再次见面，两人十分高兴。习近平主席对印方首次作为上合组织成员国与会表示欢迎。</p> <p> 　　“现在，上海合作组织站在新的历史起点上，我们要发扬优良传统，积极应对内外挑战，全面推进各领域合作，推动上海合作组织行稳致远……”习近平主席主持小范围会谈时的讲话，提出中国倡议，赋予“上海精神”新的时代内涵。现场嘉宾频频颔首，表示赞同。</p> <p> 　　这是一个不断深化的发展历程——</p> <p> 　　由中国参与创建、以中国城市命名、秘书处设在中国境内……作为创始成员国之一，中国对上合组织成长一路倾力而为，把推动上合组织发展作为外交优先方向之一。</p> <p> 　　吉尔吉斯斯坦比什凯克、塔吉克斯坦杜尚别、俄罗斯乌法、乌兹别克斯坦塔什干、哈萨克斯坦阿斯塔纳……5年来，习近平主席出席历次峰会，为丰富发展“上海精神”贡献中国智慧，注入源源不断的思想动力。</p> <p> 　　今天，辽阔丰沃的齐鲁大地，见证中国同上合组织相融相生的历史际会；开放包容的中华民族，再次谱写与世界携手前行的时代篇章。</p> <p> 　　9日的夜色中，青岛国际会议中心宴会厅在灯光的映照下美轮美奂，犹如海浪中的风帆，蓄势待发。浮山湾防波堤向大海深处延伸，远端的白色灯塔为过往船只指引航向。</p> <p> 　　宴会厅内，灯火通明，各方嘉宾静静聆听。</p> <p> 　　“青岛是世界著名的‘帆船之都’，许多船只从这里扬帆起航、追逐梦想。明天，我们将在这里举行上海合作组织扩员后的首次峰会，全面规划本组织未来发展蓝图。”习近平主席的话道出了选择青岛为峰会举办地的深意。</p> <p> 　　<strong>砥柱中流，镌刻合作发展的大国担当</strong></p> <p> 　　巍峨泰山，旭日喷薄而出，霞光照耀大河山川。国际会议中心迎宾厅正面，一幅题为《国泰民安》的国画气势磅礴。</p> <p> 　　10日上午9时许，印度总理莫迪、乌兹别克斯坦总统米尔济约耶夫、塔吉克斯坦总统拉赫蒙、巴基斯坦总统侯赛因、吉尔吉斯斯坦总统热恩别科夫、哈萨克斯坦总统纳扎尔巴耶夫、俄罗斯总统普京先后抵达。</p> <p> 　　习近平主席同上合组织成员国领导人亲切握手，并邀请大家合影。这张新的“全家福”，定格上合组织发展进程中的历史瞬间。</p> <p> 　　走过17年不平凡发展历程，上合组织开创了区域合作新模式，为地区和平发展作出了重大贡献，未来前景光明但道路并不平坦。</p> <p> 　　“弘扬‘上海精神’，加强团结协作”；“推进安全合作，携手应对挑战”；“深化务实合作，促进共同发展”；“发挥积极影响，展现国际担当”……国际会议中心黄河厅，习近平主席在小范围会谈发表讲话，为上合组织发展明确路径。</p> <p> 　　登东山而小鲁，登泰山而小天下。</p> <p> 　　10日上午11时许，国际会议中心泰山厅，习近平主席主持大范围会谈。成员国领导人、常设机构负责人、观察员国领导人及联合国等国际组织负责人，围坐一起，共同描绘合作发展的新蓝图。</p> <p> 　　——提倡创新、协调、绿色、开放、共享的发展观；</p> <p> 　　——践行共同、综合、合作、可持续的安全观；</p> <p> 　　——秉持开放、融通、互利、共赢的合作观；</p> <p> 　　——树立平等、互鉴、对话、包容的文明观；</p> <p> 　　——坚持共商共建共享的全球治理观。</p> <p> 　　习近平主席登高望远，把握时代潮流，提出中国方案。</p> <p> 　　支持在青岛建设中国－上合组织地方经贸合作示范区、在上合组织银行联合体框架内设立300亿元人民币等值专项贷款、未来3年为各成员国提供3000个人力资源开发培训名额、利用风云二号气象卫星为各方提供气象服务……</p> <p> 　　一项项实实在在的举措，展现中国推动建设共同家园的真诚态度。</p> <p> 　　10日下午1时25分许，习近平主席敲下木槌，宣布峰会结束。</p> <p> 　　此时，国际会议中心二楼大厅里，早已坐满中外媒体记者。</p> <p> 　　习近平主席同上合组织其他各成员国领导人一道步入，在主席台就座。</p> <p> 　　共同发表《上海合作组织成员国元首理事会青岛宣言》《上海合作组织成员国元首关于贸易便利化的联合声明》，批准《上海合作组织成员国长期睦邻友好合作条约》未来5年实施纲要，见证经贸、海关、旅游等领域合作文件签署……一份份沉甸甸的成果文件，体现各方凝聚的最新共识。</p> <p> 　　外界评价，上合组织从此进入一个历史新阶段。</p> <p> 　　“我坚信，在大家共同努力下，上海合作组织的明天一定会更加美好。”面对各国媒体，习近平主席对上合组织的未来之路信心满怀，铿锵有力的话语通过电视直播信号传递到世界各个角落。</p> <p> 　　<strong>大道之行，彰显天下为公的大国信念</strong></p> <p> 　　9日的青岛夜空，云开雾散，璀璨焰火，当空绽放。</p> <p> 　　习近平主席为各方贵宾准备的灯光焰火艺术表演，处处体现东道主的独到用心。《天涯明月》《齐风鲁韵》《国泰民安》《筑梦未来》《命运共同体》，5个篇章一气呵成，传递出中国同上合组织和世界各国和衷共济、携手并进的坚定决心。</p> <p> 　　“继续加强政策沟通、设施联通、贸易畅通、资金融通、民心相通，发展安全、能源、农业等领域合作，推动建设相互尊重、公平正义、合作共赢的新型国际关系，确立构建人类命运共同体的共同理念。”</p> <p> 　　在通过的成果文件中，“五通”“构建新型国际关系”“构建人类命运共同体”等中国理念、中国方案正式写入了上合组织青岛宣言。</p> <p> 　　初夏时节的青岛，成为中国又一“国际会客厅”，见证中国特色大国外交的成功实践。</p> <p> 　　构建新型国际关系，中国步履坚实、步伐稳健——</p> <p> 　　北京、天津、青岛，一天跨三地。6月8日，可以称为习近平主席繁忙外交日程“教科书式”的一页。</p> <p> 　　同普京总统举行大小范围会谈、共同出席签字仪式并会见记者、授予普京总统“友谊勋章”、同乘高铁前往天津并共同观看中俄青少年冰球赛……中俄领导人之间亲密互动，彰显两国全面战略协作伙伴关系成熟、稳定、牢固，树立了发展新型国际关系的典范。</p> <p> 　　同吉尔吉斯斯坦总统热恩别科夫宣布建立全面战略伙伴关系；同哈萨克斯坦总统纳扎尔巴耶夫就巩固中哈传统友谊、在民族复兴征途上携手前行达成重要共识；两个月内同印度总理莫迪再次会晤，中印政治互信进一步加强……</p> <p> 　　峰会期间，习近平主席特别安排同上合组织各成员国、观察员国11位外方领导人举行双边会晤，元首外交引领国际关系更进一步。</p> <p> 　　构建人类命运共同体，中国领导人天下为公的信念感召世界——</p> <p> 　　“我们要继续在‘上海精神’指引下，同舟共济，精诚合作，齐心协力构建上海合作组织命运共同体，推动建设新型国际关系，携手迈向持久和平、普遍安全、共同繁荣、开放包容、清洁美丽的世界。”习近平主席的话掷地有声，启迪未来。</p> <p> 　　时间回到5年前，习近平主席首次提出构建人类命运共同体伟大倡议。从此，中国实践波澜壮阔，中国理念全球激荡——</p> <p> 　　从写入中共党章到载入中国宪法，一个个历史坐标铸熔着中国共产党人“为人类进步事业而奋斗”的庄严承诺；从写入联合国决议到载入上合组织合作文件，构建人类命运共同体理念赢得国际社会广泛认同，成为新时代指引国际关系发展的重要指南。</p> <p> 　　舆论分析，当今世界，只有中国领导人能够提出如此宏远博大的理念。</p> <p> 　　进入国际会议中心迎宾厅，两侧墙壁上的浮雕颇具深意：一侧关于丝绸之路经济带，一侧关于21世纪海上丝绸之路。</p> <p> 　　共享古丝绸之路历史记忆，共创“一带一路”建设发展机遇。5年来，“一带一路”建设在上合组织所在区域先行先试，硕果累累，为地区各国人民带来实实在在的利益，成为构建人类命运共同体的重要平台。</p> <p> 　　峰会期间，“一带一路”倡议再次得到广泛欢迎和支持，“一带一路”建设对拉动共同发展的引擎作用愈发凸显。</p> <p> 　　涓涓细流汇成大海，点点星光照亮银河。</p> <p> 　　“我们愿同各方一道，不忘初心，携手前进，推动上海合作组织实现新发展，构建更加紧密的命运共同体，为维护世界和平稳定、促进人类发展繁荣作出新的更大贡献。”</p> <p> 　　海之情，合之韵。从青岛再出发，中国同上合组织各国携手，与世界各国同行，必将迈向更加美好的明天！</p>', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051051.html', '2018-06-12', 'http://politics.people.com.cn/n1/2018/0612/c1001-3', '习近平主席主持上合组织青岛峰会并举行系列活动纪实', 'http://politics.people.com.cn/n1/2018/0612/c1001-30051051.html', '1528795505');
INSERT INTO `message_news` VALUES ('47', 'T1467284926140', 'News', 'feda968787c196940d2dfe5f08475dfa', '<p style=\"text-align: center;\"> <strong>李克强对企业职工基本养老保险基金中央调剂制度贯彻实施工作会议作出重要批示强调</strong></p> <p style=\"text-align: center;\"> <strong>切实做好中央调剂基金筹集拨付管理等工作</strong></p> <p style=\"text-align: center;\"> <strong>确保基本养老金按时足额发放</strong></p> <p style=\"text-align: center;\"> <strong>韩正出席会议并讲话　胡春华主持</strong></p> <p style=\"text-indent: 2em;\"> 新华社北京6月11日电 企业职工基本养老保险基金中央调剂制度贯彻实施工作会议6月11日在京召开。中共中央政治局常委、国务院总理李克强作出重要批示。批示指出：建立企业职工基本养老保险基金中央调剂制度，对于增强基本养老保险制度可持续性、均衡地区间养老保险基金负担、促进实现广大人民群众基本养老保险权益公平共享具有重要意义。各地区、各部门要以习近平新时代中国特色社会主义思想为指导，认真贯彻党中央、国务院决策部署，统一思想认识，坚持从全局出发，加强统筹协调，切实做好中央调剂基金筹集、拨付、管理等工作，健全考核奖惩机制，确保中央调剂制度顺利平稳实施。各地区要切实履行基本养老金发放的主体责任，进一步加强收支管理，加快完善省级统筹制度，通过盘活存量资金、划转部分国有资本等充实社保基金，确保基本养老金按时足额发放，有效防范和化解支付风险。有关部门要与各方面密切配合，形成合力，不断完善基金中央调剂制度，推进养老保险全国统筹，努力为人民群众提供更高质量、更有效率、更加公平、更可持续的养老保障。</p> <p style=\"text-indent: 2em;\"> 中共中央政治局常委、国务院副总理韩正出席会议并讲话，中共中央政治局委员、国务院副总理胡春华主持。</p> <p style=\"text-indent: 2em;\"> 韩正表示，建立企业职工基本养老保险基金中央调剂制度，是实现养老保险全国统筹的重要举措。习近平总书记主持召开中央全面深化改革委员会第二次会议并发表重要讲话，强调要从我国基本国情和养老保险制度建设实际出发，在不增加社会整体负担和不提高养老保险缴费比例的基础上，通过建立企业职工基本养老保险基金中央调剂制度，合理均衡地区间基金负担，实现基金安全可持续，实现财政负担可控，确保各地养老金按时足额发放。我们要按照习近平总书记重要讲话精神和李克强总理批示要求，实施好企业职工基本养老保险基金中央调剂制度，有力有序推进养老保险全国统筹。</p> <p style=\"text-indent: 2em;\"> 韩正强调，要依法做好基本养老保险费征收工作，扩大制度覆盖面，提高征缴率，夯实缴费基数，增强中央调剂基金制度可持续性。要加快推进省级基本养老保险基金统收统支，2020年全面实现省级统筹，为养老保险全国统筹打好基础。要扎实做好中央调剂基金管理工作，强化基金预算严肃性和硬约束，确保基金专款专用。要认真做好基金缺口弥补工作，加大财政支持力度，确保全国退休职工按时足额领取养老金。</p> <p style=\"text-indent: 2em;\"> 韩正表示，各地区、各部门要深入学习贯彻习近平新时代中国特色社会主义思想和党的十九大精神，全面贯彻落实《中华人民共和国社会保险法》，加强组织领导，健全保障措施，确保企业职工基本养老保险基金中央调剂制度顺利实施，为决胜全面建成小康社会、夺取新时代中国特色社会主义伟大胜利作出新的贡献。</p>', 'http://politics.people.com.cn/n1/2018/0611/c1024-30051049.html', '2018-06-11', 'http://politics.people.com.cn/n1/2018/0611/c1024-3', '李克强：切实做好中央调剂基金筹集拨付管理等工作 确保基本养老金按时足额发放', 'http://politics.people.com.cn/n1/2018/0611/c1024-30051049.html', '1528795505');
INSERT INTO `message_news` VALUES ('48', 'T1467284926140', 'News', '6ab51e35d8ce65113a14f09277980f6f', '<p style=\"text-indent: 2em;\"> 人民网北京6月11日电 据内蒙古自治区纪委监委消息：内蒙古自治区社科院党委委员、副院长张志华涉嫌严重违纪违法，目前正在接受纪律审查和监察调查。</p> <p style=\"text-indent: 2em;\"> <strong>个人简历</strong></p> <p style=\"text-indent: 2em;\"> 张志华，女，汉族，1966年10月出生，内蒙古凉城人，内蒙古党校在职研究生学历，1986年8月参加工作，1986年5月加入中国共产党。</p> <p style=\"text-indent: 2em;\"> 1983年9月至1986年8月，伊克昭盟卫生学校学习；1986年8月至1987年9月，准格尔旗中蒙医院工作；1987年9月至1992年10月，准格尔旗直属机关党委组宣干事；1992年10月至2001年11月，准格尔旗煤炭工业管理局政工科副科长、党委办公室副主任、主任科员；2001年11月至2003年4月，内蒙古社科院秘书；2003年4月至2006年5月，内蒙古社科院办公室副主任；2006年5月至2011年11月，内蒙古社科院办公室主任；2011年11月至今，内蒙古社科院党委委员、副院长。</p>', 'http://politics.people.com.cn/n1/2018/0611/c1001-30051047.html', '2018-06-11', 'http://politics.people.com.cn/n1/2018/0611/c1001-3', '内蒙古自治区社科院党委委员、副院长张志华接受纪律审查和监察调查', 'http://politics.people.com.cn/n1/2018/0611/c1001-30051047.html', '1528795505');
INSERT INTO `message_news` VALUES ('49', 'T1467284926140', 'News', 'e8c9b64976090d440f67d32c5bb61c59', '<p style=\"text-indent: 2em;\"> 人民网北京6月11日电 据内蒙古自治区纪委监委消息：内蒙古自治区扶贫开发办公室党组成员、副主任王幂生涉嫌严重违纪违法，目前正在接受纪律审查和监察调查。</p> <p style=\"text-indent: 2em;\"> <strong>个人简历</strong></p> <p style=\"text-indent: 2em;\"> 王幂生，男，汉族，内蒙古察右中旗人，1965年9月出生，1987年8月参加工作，1992年7月加入中国共产党，大学学历，农学学士。1993年12月至2011年12月，先后任卓资县大榆树乡科技副乡长、马盖图乡科技副乡长、东河子乡乡长、福生庄乡党委书记，集宁市委常委、办公室主任，集宁市副市长、集宁区副区长，乌兰察布市城市建设投资开发有限公司经理、市城建委副主任、党组成员（正处级），乌兰察布市金融办主任、城市建设投资开发有限公司经理、土地储备中心主任等职；2011年12月至2015年12月，任兴和县委书记；2015年12月至今，任自治区扶贫办党组成员、副主任。</p>', 'http://politics.people.com.cn/n1/2018/0611/c1001-30051046.html', '2018-06-11', 'http://politics.people.com.cn/n1/2018/0611/c1001-3', '内蒙古自治区扶贫开发办公室党组成员、副主任王幂生接受纪律审查和监察调查', 'http://politics.people.com.cn/n1/2018/0611/c1001-30051046.html', '1528795505');
INSERT INTO `message_news` VALUES ('50', 'T1467284926140', 'News', '66e4816ae6ad95cc2e0c3530157bf305', '<p align=\"center\" style=\"text-align: center;\"> <img alt=\" \" src=\"http://www.people.com.cn/mediafile/pic/GQ/20180611/27/16409977277292062243.gif\" style=\"height: 330px; width: 600px;\" /></p> <p style=\"text-indent: 2em;\"> 6月10日，国家主席习近平在上合组织青岛峰会上发表题为《弘扬“上海精神” 构建命运共同体》的重要讲话，深刻阐释了“上海精神”的时代内涵，并就构建上合组织命运共同体提出了中国理念和中国倡议，为该组织在新起点上实现新跨越注入强劲的中国新动力。</p> <p style=\"text-indent: 2em;\"> “上海精神”是上合组织的旗帜和灵魂，是该组织始终保持健康稳定发展的力量源泉。习主席就新形势下进一步弘扬“上海精神”提出发展观、安全观、合作观、文明观和全球治理观，为“上海精神”注入了新的时代内涵，是对国际关系理论和区域合作理论的新发展。习主席就打造命运共同体提出五点倡议，既有高屋建瓴的顶层设计，也有具体可行的目标要求，为上合组织永立时代潮头指明了方向与路径。</p> <p style=\"text-indent: 2em;\"> 立黄海之滨，聚八方合力。此次青岛峰会成果丰硕，成为上合组织发展进程中新的里程碑。我们相信，从青岛开启新航程的上合组织将继续高扬“上海精神”的风帆，不断书写构建命运共同体的新华章。（作者系中国现代国际关系研究院世界经济研究所张茂荣 漫画作者迟颖）</p>', 'http://politics.people.com.cn/n1/2018/0611/c1001-30051041.html', '2018-06-11', 'http://politics.people.com.cn/n1/2018/0611/c1001-3', '“习主席主持上合青岛峰会”漫评②：为上合新航程注入中国新动力', 'http://politics.people.com.cn/n1/2018/0611/c1001-30051041.html', '1528795505');
INSERT INTO `message_news` VALUES ('51', 'T1467284926140', 'News', '5e88856ef27b6f972c8dc4445de9a54c', '<p style=\"text-indent: 2em;\"> 新华社北京6月11日电（记者王卓伦）中共中央政治局委员、中央政法委书记、中白政府间合作委员会中方主席郭声琨11日在京会见白俄罗斯总统办公厅副主任、中白政府间合作委员会白方主席斯诺普科夫。</p> <p style=\"text-indent: 2em;\"> 郭声琨说，习近平主席关于构建人类命运共同体的重要理念，以及在上合组织青岛峰会期间同卢卡申科总统达成的诸多共识，为中白扩大合作开辟了广阔空间。希望双方发挥好合作委员会机制作用，推动各领域合作和“一带一路”建设，把两国元首共识转化为更多实际成果，造福两国人民。</p>', 'http://politics.people.com.cn/n1/2018/0611/c1001-30051007.html', '2018-06-11', 'http://politics.people.com.cn/n1/2018/0611/c1001-3', '郭声琨会见白俄罗斯总统办公厅副主任斯诺普科夫', 'http://politics.people.com.cn/n1/2018/0611/c1001-30051007.html', '1528795506');
INSERT INTO `message_news` VALUES ('52', 'T1467284926140', 'News', '06033a7111b0a439004be86c8fe2dedf', '<p style=\"text-indent: 2em;\"> 6月9日至10日，上海合作组织成员国元首理事会第十八次会议在山东省青岛市举行，这是中方时隔六年再次主办上海合作组织峰会，也上海合作组织扩员后召开的首次峰会。</p> <p style=\"text-indent: 2em;\"> 青岛峰会达成了广泛共识、取得丰硕成果，其中的许多与你我息息相关，五大福利，在此为您一一列出。</p> <p style=\"text-indent: 2em;\"> <strong>福利一：生活环境将更加安全</strong></p> <p style=\"text-indent: 2em;\"> 多年来，上合组织各成员国通过加强合作，制止了数百起恐怖袭击案件，抓捕了大批国际恐怖组织成员，缴获了大量枪支弹药、爆炸物，摧毁了很多本地区内的武装分子培训基地。继往开来，此次上合组织青岛峰会公报指出，将继续在有效应对安全挑战和威胁方面保持协调。</p> <p style=\"text-indent: 2em;\"> 此次峰会的“青岛宣言”指出，未来上合组织的成员国将在事关区域稳定安全的方方面面做出努力：打击恐怖主义、分裂主义、极端主义“三股势力”；打击利用互联网传播和宣传恐怖主义思想；打击旨在吸收青年参与恐怖主义、分裂主义、极端主义团伙活动的企图；打击毒品及易制毒化学品非法贩运等等。</p> <p style=\"text-indent: 2em;\"> 可以预见，在未来，上合组织将筑牢和平安全的共同基础，为我们创造和平稳定安全的生存生活环境。</p> <p style=\"text-indent: 2em;\"> <strong>福利二：留学、出国交流将更加便利</strong></p> <p style=\"text-indent: 2em;\"> 6月10日，习近平在峰会上强调，我们要积极落实成员国环保合作构想等文件，继续办好青年交流营等品牌项目，扎实推进教育、科技、文化、旅游、卫生、减灾、媒体等各领域合作。</p> <p style=\"text-indent: 2em;\"> 在“青岛宣言”中，成员国指出，将继续积极落实《上合组织成员国政府间教育合作协定》，扩大教学科研人员交流规模，联合培养高素质人才。成员国将本着相互尊重原则，积极推动在师生交流、联合科研、学术访问、语言教学、职业教育、青少年交流等领域开展务实合作。</p> <p style=\"text-indent: 2em;\"> 这一系列举措将成为拉紧上合组织各成员国之间人文交流合作的共同纽带，人们留学、出国交流将更加便利。</p> <p style=\"text-indent: 2em;\"> <strong>福利三：食品安全、健康保障进一步提升</strong></p> <p style=\"text-indent: 2em;\"> 如何让我们的食品更安全、医疗更有保障？上合组织青岛峰会给出了答案。</p> <p style=\"text-indent: 2em;\"> 成员国承诺，将在跨境动物疫病防控、农产品准入政策和质量安全、卫生检疫等领域开展交流与合作，以保障粮食安全。</p> <p style=\"text-indent: 2em;\"> 成员国指出应积极开展卫生应急、居民卫生防疫保障、打击假冒医疗产品、防止传染病扩散、慢性病防控、传统医药、医学教育与科研、落实促进国际发展的合作纲要、医疗服务、医务人员交流、保障食品安全及质量等领域合作，共同维护居民健康，促进卫生发展和创新合作。</p> <p style=\"text-indent: 2em;\"> 同时，峰会发表了成员国领导人关于《上海合作组织成员国元首关于在上海合作组织地区共同应对流行病威胁的声明》。</p> <p style=\"text-indent: 2em;\"> <strong>福利四：文化体育交流将更加多样</strong></p> <p style=\"text-indent: 2em;\"> 文化的交流与合作是各个国家之间和平稳定的纽带，上合组织各成员国将为此做出多方面努力。</p> <p style=\"text-indent: 2em;\"> 早在2007年8月16日，各成员国就在比什凯克签署了《上合组织成员国政府间文化合作协定》。</p> <p style=\"text-indent: 2em;\"> 此次青岛峰会，各成员国承诺将在此基础上继续促进发展上合组织框架内的文化联系，巩固人民之间的相互理解，尊重成员国的文化传统和习俗，保护并鼓励文化的多样性，举办国际艺术节和竞赛，深化在音乐、戏剧、造型艺术、电影、档案、博物馆及图书馆领域的合作，开展包括古丝绸之路沿线在内的本地区文化与自然遗产研究与维护领域的合作。</p> <p style=\"text-indent: 2em;\"> 青岛峰会也给体育迷带来了好消息。成员国指出，体育作为促进民间对话的有效因素具有重要意义，应脱离政治。成员国坚信，即将于2018年在俄罗斯举办的国际足联世界杯足球赛、2018年5月18日至19日在重庆举办的上合组织武术散打比赛、定期举办的上合组织马拉松赛和一年一度的国际瑜珈日将促进友谊、和平、包容与和谐。</p> <p style=\"text-indent: 2em;\"> <strong>福利五：中小微企业合作将更加紧密</strong></p> <p style=\"text-indent: 2em;\"> 在此次青岛峰会上，“中小微企业”备受关注，在“青岛宣言”中，成员国认为，在上合组织框架内加强电子商务合作、发展服务业和服务贸易、支持中小微企业发展对于发展经济、提高就业、增进人民福祉意义重大，支持进一步巩固本领域法律基础。</p> <p style=\"text-indent: 2em;\"> 成员国也强调进一步深化中小微企业领域的合作十分重要，有关部门签署了《上海合作组织成员国经贸部门间促进中小微企业合作的谅解备忘录》。</p> <p style=\"text-indent: 2em;\"> 另外，此次峰会，《上海合作组织成员国元首关于贸易便利化的联合声明》的签署备受瞩目。专家指出，推进贸易和投资便利化，打造区域融合发展新格局，将为地区各国人民谋福祉，为世界经济发展增动力。</p> <p style=\"text-indent: 2em;\"> 可以预见，乘着贸易便利化的东风，上合组织各成员国之间中小微企业的合作将更加紧密。&nbsp;</p>', 'http://politics.people.com.cn/n1/2018/0611/c1001-30050966.html', '2018-06-11', 'http://politics.people.com.cn/n1/2018/0611/c1001-3', '上合青岛峰会与你我无关？错啦，看看这五大福利', 'http://politics.people.com.cn/n1/2018/0611/c1001-30050966.html', '1528795506');
INSERT INTO `message_news` VALUES ('53', 'T1467284926140', 'News', 'dcbaeef5f645ae31e69160bcf5c06fce', '<p style=\"text-indent: 2em;\"> 新华社北京6月11日电 近日，中共中央办公厅、国务院办公厅、中央军委办公厅印发《关于深入推进军队全面停止有偿服务工作的指导意见》，为军地各级深入推进军队全面停止有偿服务工作提供了重要遵循。</p> <p style=\"text-indent: 2em;\"> 《指导意见》指出，军队全面停止有偿服务，是党中央、中央军委和习近平总书记着眼实现党在新时代的强军目标、全面建成世界一流军队作出的重大战略决策，是深化国防和军队改革的重要内容。这项工作自2016年年初开展以来，经过各方共同努力，组织领导、政策制度、军地联动、司法保障体系逐步建立完善，项目清理停止成效明显，人员分流安置顺利，善后问题处理平稳，保持了部队和社会两个大局稳定。当前，军队全面停止有偿服务工作正处在决战决胜的关键时期，部队各级、地方各级党委和政府必须坚定信心决心，强化工作统筹，密切军地配合，聚力攻坚克难，确保如期完成军队全面停止有偿服务这一政治任务、国家任务、强军任务。</p> <p style=\"text-indent: 2em;\"> 《指导意见》强调，要准确把握军队全面停止有偿服务重大战略决策意图，按照军队不经营、资产不流失、融合要严格、收支两条线的标准，坚持坚决全面、积极稳妥、军民融合，按计划分步骤稳妥推进，到2018年年底前全面停止军队一切有偿服务活动，为永葆我军性质宗旨和本色、提高部队战斗力创造有利条件。坚决停止一切以营利为目的、偏离部队主责主业、单纯为社会提供服务的项目。开展有偿服务的项目，合同协议已到期的应予终止，不得续签，全部收回军队资产；合同协议未到期的，通过协商或司法程序能够终止的项目，应提前解除合同协议，确需补偿的，按照国家法律规定给予经济补偿。</p> <p style=\"text-indent: 2em;\"> 《指导意见》明确，对复杂敏感项目，区分不同情况，主要采取委托管理、资产置换、保障社会化等方式进行处理，国家和地方政府在政策上给予支持。对已融入驻地城市发展规划，直接影响社会经济发展和民生稳定，合同协议期限较长、承租户投资大，有潜在军事利用价值，确实难以关停收回的项目，可以实行委托管理。对独立坐落或者能够与在用营区相对分离，军事利用价值不高，已经形成事实转让的项目，由中央军委审批确定后，可以采取置换等方式处理。对部队营区内引进社会力量服务官兵工作、生活的房地产租赁项目，纳入保障社会化范围，规范准入条件、运行方式、优惠措施、经费管理等，更好地服务部队、惠及官兵。</p> <p style=\"text-indent: 2em;\"> 《指导意见》明确，军队全面停止有偿服务后，将国家赋予任务、军队有能力完成的，军队特有或优势明显、国家建设确有需要的，以及军队引进社会力量服务官兵的项目，纳入军民融合发展体系。对需纳入军民融合发展体系的行业项目，由军地有关部门研究提出有关标准条件、准入程序、审批权限、运行管理等政策办法，实行规范管理，严格落实收支两条线政策规定。对军队全面停止有偿服务后空余房地产、农副业生产用地、大型招待接待资产，全部由中央军委集中管理、统筹调控。</p> <p style=\"text-indent: 2em;\"> 《指导意见》强调，军队全面停止有偿服务是军队、中央和国家机关、地方党委和政府的共同责任。各有关方面要高度重视，牢固树立“四个意识”，加强组织领导和工作统筹，党委领导同志要敢于担当、勇于负责，对复杂敏感项目要亲自上手、一抓到底。要严肃工作纪律，适时开展专项巡视和审计，查处违纪违法问题。要以严实作风推动工作高标准落实，确保如期圆满完成军队全面停止有偿服务任务。</p>', 'http://politics.people.com.cn/n1/2018/0611/c1001-30050960.html', '2018-06-11', 'http://politics.people.com.cn/n1/2018/0611/c1001-3', '中共中央办公厅、国务院办公厅、中央军委办公厅 印发《关于深入推进军队全面停止有偿服务工作的指导意见》', 'http://politics.people.com.cn/n1/2018/0611/c1001-30050960.html', '1528795506');
INSERT INTO `message_news` VALUES ('54', 'T1467284926140', 'News', 'a0075248f89ae84e7d5576c7a2dc4064', '<p style=\"text-align: center;\"> <strong>习近平对脱贫攻坚工作作出重要指示强调</strong></p> <p style=\"text-align: center;\"> <strong>真抓实干埋头苦干万众一心 夺取脱贫攻坚战全面胜利</strong></p> <p style=\"text-align: center;\"> <strong>李克强作出批示</strong></p> <p style=\"text-indent: 2em;\"> 新华社北京6月11日电 中共中央总书记、国家主席、中央军委主席习近平近日对脱贫攻坚工作作出重要指示强调，脱贫攻坚时间紧、任务重，必须真抓实干、埋头苦干。各级党委和政府要以更加昂扬的精神状态、更加扎实的工作作风，团结带领广大干部群众坚定信心、顽强奋斗，万众一心夺取脱贫攻坚战全面胜利。</p> <p style=\"text-indent: 2em;\"> 习近平指出，打赢脱贫攻坚战，对全面建成小康社会、实现“两个一百年”奋斗目标具有十分重要的意义。行百里者半九十。各级党委和政府要把打赢脱贫攻坚战作为重大政治任务，强化中央统筹、省负总责、市县抓落实的管理体制，强化党政一把手负总责的领导责任制，明确责任、尽锐出战、狠抓实效。要坚持党中央确定的脱贫攻坚目标和扶贫标准，贯彻精准扶贫精准脱贫基本方略，既不急躁蛮干，也不消极拖延，既不降低标准，也不吊高胃口，确保焦点不散、靶心不变。要聚焦深度贫困地区和特殊贫困群体，确保不漏一村不落一人。要深化东西部扶贫协作和党政机关定点扶贫，调动社会各界参与脱贫攻坚积极性，实现政府、市场、社会互动和行业扶贫、专项扶贫、社会扶贫联动。</p> <p style=\"text-indent: 2em;\"> 中共中央政治局常委、国务院总理李克强作出批示指出，实现精准脱贫是全面建成小康社会必须打赢的攻坚战，是促进区域协调发展的重要抓手。各地区各部门要全面贯彻党的十九大精神，以习近平新时代中国特色社会主义思想为指导，认真落实党中央、国务院关于打赢脱贫攻坚战三年行动的决策部署，进一步增强责任感紧迫感，坚持精准扶贫精准脱贫基本方略，聚焦深度贫困地区和特殊贫困群体，细化实化政策措施，落实到村到户到人，加强项目资金管理，压实责任，严格考核，凝聚起更大力量，真抓实干，确保一年一个新进展。要注重精准扶贫与经济社会发展相互促进，注重脱贫攻坚与实施乡村振兴战略相互衔接，注重外部帮扶与激发内生动力有机结合，推动实现贫困群众稳定脱贫、逐步致富，确保三年如期完成脱贫攻坚目标任务。</p> <p style=\"text-indent: 2em;\"> 打赢脱贫攻坚战三年行动电视电话会议11日上午在京举行。中共中央政治局委员、国务院扶贫开发领导小组组长胡春华出席会议并讲话。他强调，各地区、各有关部门要深入学习贯彻习近平总书记关于脱贫攻坚的重要指示精神，落实李克强总理批示要求，按照党中央、国务院决策部署，旗帜鲜明地把抓落实、促攻坚工作导向树立起来，坚持目标标准，贯彻精准方略，压实攻坚责任，打造过硬的攻坚队伍，完善督战机制，加强作风建设，扎扎实实地把各项攻坚举措落到实处，坚决打赢脱贫攻坚战。</p> <p style=\"text-indent: 2em;\"> 会议传达了习近平重要指示和李克强批示，安排部署今后三年脱贫攻坚工作。有关省区负责同志在会上发言。</p> <p style=\"text-indent: 2em;\"> 国务院扶贫开发领导小组成员、中央和国家机关有关部门负责同志、省部级干部“学习贯彻习近平新时代中国特色社会主义思想，坚决打好精准脱贫攻坚战”专题研讨班学员参加会议。各省、自治区、直辖市和新疆生产建设兵团，中央党校（国家行政学院）设分会场。</p>', 'http://politics.people.com.cn/n1/2018/0611/c1024-30050941.html', '2018-06-11', 'http://politics.people.com.cn/n1/2018/0611/c1024-3', '习近平：真抓实干埋头苦干万众一心 夺取脱贫攻坚战全面胜利', 'http://politics.people.com.cn/n1/2018/0611/c1024-30050941.html', '1528795506');
INSERT INTO `message_news` VALUES ('55', 'T1467284926140', 'News', 'cd5458fa7a84e4f1b1d6ff1b88489f8b', '<p style=\"text-indent: 2em;\"> 人民网北京6月11日电 据重庆市纪委监委消息：重庆市纪委驻市环保局纪检组组长、市环保局党组成员陶志刚涉嫌严重违纪违法，目前正接受重庆市纪委监委纪律审查和监察调查。</p> <p style=\"text-indent: 2em;\"> <strong>陶志刚简历</strong></p> <p style=\"text-indent: 2em;\"> 陶志刚，男，汉族，1959年3月出生，重庆綦江人，大学本科文化，1976年7月参加工作，1986年1月加入中国共产党。</p> <p style=\"text-indent: 2em;\"> 1976.07—1977.09 四川省綦江县北渡公社花坝大队知青</p> <p style=\"text-indent: 2em;\"> 1977.09—1978.09 四川省綦江中学代课教师</p> <p style=\"text-indent: 2em;\"> 1978.09—1982.07 四川大学历史系历史专业学习，获历史学学士学位</p> <p style=\"text-indent: 2em;\"> 1982.07—1984.06 广东省湛江市委党校教师</p> <p style=\"text-indent: 2em;\"> 1984.06—1988.10 四川省重庆市委党校教师</p> <p style=\"text-indent: 2em;\"> 1988.10—1992.04 四川省重庆市监察局举报中心主任科员</p> <p style=\"text-indent: 2em;\"> 1992.04—1993.05 四川省重庆市监察局研究室副处级监察员</p> <p style=\"text-indent: 2em;\"> 1993.05—1994.11 四川省重庆市纪委监察综合室副处级纪检员</p> <p style=\"text-indent: 2em;\"> 1994.11—1997.06 四川省重庆市纪委信访室副主任</p> <p style=\"text-indent: 2em;\"> 1997.06—1998.05 重庆市纪委信访室副主任</p> <p style=\"text-indent: 2em;\"> 1998.05—2002.09 重庆市纪委第四纪检监察室主任</p> <p style=\"text-indent: 2em;\"> 2002.09—2004.02 重庆市纪委案件管理室主任</p> <p style=\"text-indent: 2em;\"> 2004.02—2014.10 重庆市委巡视组副厅局长级巡视专员</p> <p style=\"text-indent: 2em;\"> 2014.10—2016.08 重庆市纪委、市监察局派驻市环保局纪检组组长、监察专员，市环保局党组成员</p> <p style=\"text-indent: 2em;\"> 2016.08— 重庆市纪委驻市环保局纪检组组长，市环保局党组成员</p>', 'http://politics.people.com.cn/n1/2018/0611/c1001-30050940.html', '2018-06-11', 'http://politics.people.com.cn/n1/2018/0611/c1001-3', '重庆市纪委驻市环保局纪检组组长、市环保局党组成员陶志刚接受纪律审查和监察调查', 'http://politics.people.com.cn/n1/2018/0611/c1001-30050940.html', '1528795506');
INSERT INTO `message_news` VALUES ('56', 'T1467284926140', 'News', '3ce438df3cbff987936bf6ac27483885', '<p style=\"text-align: center;\"> <img alt=\"\" src=\"/NMediaFile/2018/0611/MAIN201806111725000394113482115.jpg\" style=\"width: 600px; height: 4584px;\" /></p> <p style=\"text-align: center;\"> <img alt=\"\" src=\"/NMediaFile/2018/0611/MAIN201806111726000051074380770.jpg\" style=\"width: 600px; height: 6348px;\" /></p>', 'http://politics.people.com.cn/n1/2018/0611/c1001-30050901.html', '2018-06-11', 'http://politics.people.com.cn/n1/2018/0611/c1001-3', '图解：点赞！习主席青岛峰会忙碌的两个日夜', 'http://politics.people.com.cn/n1/2018/0611/c1001-30050901.html', '1528795506');
INSERT INTO `message_news` VALUES ('57', 'T1467284926140', 'News', '06a05d66ef8989c27bb5bab476aaaf52', '<p style=\"text-indent: 2em;\"> 新华社北京6月11日电 根据国务院常务会议关于推进政务服务“一网通办”和企业群众办事“只进一扇门”“最多跑一次”的部署，为广泛听取群众和企业意见，充分发挥社会监督作用，切实解决企业和群众在政务服务中遇到的困难和问题，6月11日起，国务院办公厅在中国政府网开通“政务服务举报投诉平台”信箱（liuyan.www.gov.cn/zwfwjbts/），统一接受社会各界对涉企乱收费、涉企政策不落实、未实现政务服务“一网通办”、群众和企业办事不便利，以及其他政务服务不到位等问题的投诉。</p> <p style=\"text-indent: 2em;\"> 国务院办公厅将对投诉事项进行核查处理，督促有关地方和部门查清问题、查明原因、整改解决，确保国家优化政务服务的政策措施落实到位，加快营造稳定公平透明可预期的营商环境，切实增强群众和企业对“放管服”改革的获得感。对存在失职渎职、懒政怠政情况的，依法依规严肃问责。</p>', 'http://politics.people.com.cn/n1/2018/0611/c1001-30050926.html', '2018-06-11', 'http://politics.people.com.cn/n1/2018/0611/c1001-3', '国务院办公厅开通“政务服务举报投诉平台”信箱 统一接受社会各界关于政务服务事项的投诉', 'http://politics.people.com.cn/n1/2018/0611/c1001-30050926.html', '1528795506');
INSERT INTO `message_news` VALUES ('58', 'T1467284926140', 'News', '3e997af78d2f31cb9fac6e55f31da934', '<p style=\"text-indent: 2em;\"> 新华社北京6月11日电 日前，国务院办公厅印发《关于推进奶业振兴保障乳品质量安全的意见》，全面部署加快奶业振兴，保障乳品质量安全工作。</p> <p style=\"text-indent: 2em;\"> 《意见》要求，要全面贯彻党的十九大和十九届二中、三中全会精神，以习近平新时代中国特色社会主义思想为指导，按照高质量发展的要求，以优质安全、绿色发展为目标，以推进供给侧结构性改革为主线，以降成本、优结构、提质量、创品牌、增活力为着力点，加快构建现代奶业产业体系、生产体系、经营体系和质量安全体系，不断提高奶业发展质量效益和竞争力，大力推进奶业现代化，为决胜全面建成小康社会提供有力支撑。</p> <p style=\"text-indent: 2em;\"> 《意见》提出，到2020年，奶业供给侧结构性改革取得实质性成效，奶业现代化建设取得明显进展。100头以上规模养殖比重超过65%，奶源自给率保持在70%以上。婴幼儿配方乳粉的品质、竞争力和美誉度显著提升，乳制品供给和消费需求更加契合。乳品质量安全水平大幅提高，消费信心显著增强。到2025年，奶业实现全面振兴，奶源基地、产品加工、乳品质量和产业竞争力整体水平进入世界先进行列。</p> <p style=\"text-indent: 2em;\"> 《意见》明确了实现上述目标的主要任务和工作措施。一是加强优质奶源基地建设。优化奶源基地布局，丰富奶源结构，发展标准化规模养殖，加强良种繁育及推广，打造高产奶牛核心育种群，促进优质饲草料生产，提高奶牛生产效率和养殖收益。二是完善乳制品加工和流通体系。优化乳制品产品结构，建立现代乳制品流通体系，不断满足消费多元化需求。密切养殖加工利益联结，培育壮大奶农专业合作组织，促进养殖加工一体化发展，规范生鲜乳购销行为。三是强化乳品质量安全监管。修订提高生鲜乳、灭菌乳、巴氏杀菌乳等乳品国家标准，监督指导企业按标依规生产。落实乳品企业质量安全第一责任，建立健全养殖、加工、流通等全过程乳品质量安全追溯体系。严格执行相关法律法规和标准，进一步提升国产婴幼儿配方乳粉的品质和竞争力。四是加大乳制品消费引导。积极宣传奶牛养殖、乳制品加工和质量安全监管等发展成效，定期发布乳品质量安全抽检监测信息，展示国产乳制品良好品质。实施奶业品牌战略，培育优质品牌。推广国家学生饮用奶计划，倡导科学饮奶，培育国民食用乳制品的习惯。</p> <p style=\"text-indent: 2em;\"> 《意见》强调，各地区、各有关部门要按照职责分工，加大工作力度，强化协同配合，制定和完善具体政策措施，抓好贯彻落实，确保完成工作目标。</p>', 'http://politics.people.com.cn/n1/2018/0611/c1001-30050925.html', '2018-06-11', 'http://politics.people.com.cn/n1/2018/0611/c1001-3', '国务院办公厅印发《关于推进奶业振兴保障乳品质量安全的意见》', 'http://politics.people.com.cn/n1/2018/0611/c1001-30050925.html', '1528795506');
INSERT INTO `message_news` VALUES ('59', 'T1467284926140', 'News', '8d7c40ef1f9524297c1065f55c5c28a3', '<p style=\"text-indent: 2em;\"> 人民网北京6月11日电 （记者章斐然）随着十九大报告提出“守住不发生系统性金融风险的底线”，以及一系列监管新规的出台和监管部门的改革，中国金融行业迈入了“稳”字当头的强监管时代。</p> <p style=\"text-indent: 2em;\"> 波士顿咨询公司（BCG）在近日发布的两份报告中指出，2017年是中国金融行业监管发展的一个分水岭，强监管、严监管将成为常态。而全球银行业在过去几年中所经历的强监管时代的风险相关表现和竞争趋势对中国银行业具有参考意义。</p> <p style=\"text-indent: 2em;\"> 报告指出，受风险、监管和合规成本上升及高额罚款冲击，2016年全球银行业平均经济利润在经历连续五年增长后首度下滑。只有愿意进行全方位数字化转型的公司银行才能得以生存和发展。</p> <p style=\"text-indent: 2em;\"> 一些公司银行家正逐渐意识到目前的挑战。BCG在2017年对公司银行业高管定性调查显示，86%的受访者表示，数字化将改变其业务的竞争格局和经济环境。但令人遗憾的是，只有43%的受访者表示他们拥有明确的数字化战略。只有19％的受访者认为他们的组织具备市场领先的数字化能力。</p> <p style=\"text-indent: 2em;\"> BCG总结，大多数成功的数字转型计划都建立在四大支柱上：1、重塑客户旅程，包括精简和缩短开户及贷款流程等；2、发掘数据的力量；3、重新定义运营模式；4、建立数字化驱动组织。</p> <p style=\"text-indent: 2em;\"> BCG全球合伙人兼董事总经理何大勇在回答人民网记者提问时表示，中国银行业在科技方面的投入毫不吝啬，但数字化转型主要仍发生在零售银行领域，公司银行业务方面仍处在点状创新阶段，尚未形成全行业认可的成功转型模式。“由于零售银行数字化转型到一定程度时边际收入会降低，所以我们呼吁银行业加快在公司银行业务数字化转型方面的投入。”</p>', 'http://politics.people.com.cn/n1/2018/0611/c1001-30050737.html', '2018-06-11', 'http://politics.people.com.cn/n1/2018/0611/c1001-3', '中国金融业进入强监管时代 银行业复苏需依赖数字化转型', 'http://politics.people.com.cn/n1/2018/0611/c1001-30050737.html', '1528795506');
INSERT INTO `message_news` VALUES ('60', 'T1467284926140', 'News', 'be4690503bc73251a90a39269f0ec5e2', '<p style=\"text-indent: 2em; text-align: center;\"> <strong>栗战书主持召开十三届全国人大常委会第五次委员长会议</strong></p> <p style=\"text-indent: 2em; text-align: center;\"> <strong>决定十三届全国人大常委会第三次会议6月19日至22日举行</strong></p> <p style=\"text-indent: 2em;\"> 新华社北京6月11日电 十三届全国人大常委会第五次委员长会议11日上午在北京人民大会堂举行。会议决定，十三届全国人大常委会第三次会议6月19日至22日在北京举行。栗战书委员长主持会议。</p> <p style=\"text-indent: 2em;\"> 委员长会议建议，十三届全国人大常委会第三次会议的议程是：审议电子商务法草案、人民法院组织法修订草案、人民检察院组织法修订草案；审议全国人大常委会委员长会议关于提请审议关于宪法和法律委员会职责问题的决定草案的议案，中央军委关于提请审议关于中国海警局履行海上维权执法职权的决定草案的议案等。</p> <p style=\"text-indent: 2em;\"> 委员长会议建议的议程还有：审议国务院关于2017年中央决算的报告，审查和批准2017年中央决算；审议国务院关于2017年度中央预算执行和其他财政收支的审计工作报告；审议国务院关于坚持创新驱动发展深入推进国家科技重大专项工作情况的报告，关于研究处理固体废物污染环境防治法执法检查报告及审议意见情况的报告；审议全国人大常委会执法检查组关于检查统计法实施情况的报告；审议栗战书委员长访问埃塞俄比亚、莫桑比克、纳米比亚情况的书面报告；审议全国人大常委会代表资格审查委员会关于个别代表的代表资格的报告；审议有关任免案。</p> <p style=\"text-indent: 2em;\"> 委员长会议上，全国人大常委会秘书长杨振武就常委会第三次会议议程草案、日程安排意见等作了汇报。全国人大常委会有关副秘书长，全国人大有关专门委员会、常委会有关工作委员会负责人就常委会第三次会议有关议题作了汇报。</p> <p style=\"text-indent: 2em;\"> 全国人大常委会副委员长曹建明、张春贤、沈跃跃、吉炳轩、艾力更·依明巴海、万鄂湘、陈竺、王东明、白玛赤林、丁仲礼、郝明金、蔡达峰、武维华出席会议。</p>', 'http://politics.people.com.cn/n1/2018/0611/c1024-30050581.html', '2018-06-11', 'http://politics.people.com.cn/n1/2018/0611/c1024-3', '栗战书主持召开十三届全国人大常委会第五次委员长会议 决定十三届全国人大常委会第三次会议6月19日至22日举行', 'http://politics.people.com.cn/n1/2018/0611/c1024-30050581.html', '1528795506');
INSERT INTO `message_news` VALUES ('61', 'T1467284926140', 'News', 'e04f37af9c6b4c201f73e6f6e5af10c0', '<p class=\"pictext\" style=\"text-indent: 2em; text-align: center;\"> <img alt=\"\" src=\"/NMediaFile/2018/0611/MAIN201806111424000430041489749.jpg\" style=\"width: 300px; height: 378px;\" /></p> <p class=\"pictext\" style=\"text-indent: 2em;\"> 策划/《中国报道》编辑部</p> <p style=\"text-indent: 2em;\"> 撰文/《中国报道》记者 徐豪</p> <p style=\"text-indent: 2em;\"> 奔流过11个省市、全长6300公里的长江，是中华民族的母亲河，也是中国发展的“黄金经济带”。保护母亲河，不仅关系到长江流域4亿多人民的民生、全国经济社会可持续发展的大局，更关系到中华民族子孙万代的福祉。</p> <p style=\"text-indent: 2em;\"> 面对川流不息的江水，习近平总书记曾多次满怀深情地说：“推动长江经济带发展必须从中华民族长远利益考虑，走生态优先、绿色发展之路，使绿水青山产生巨大生态效益、经济效益、社会效益，使母亲河永葆生机活力。”</p> <p style=\"text-indent: 2em;\"> 2018年4月24日至26日，习近平总书记来到长江沿岸，三天两省四地，不顾舟车劳顿，登大坝、乘江船、进企业、访村落，实地考察调研长江经济带发展战略实施情况，并于26日下午在武汉主持召开深入推动长江经济带发展座谈会，为长江经济带发展把脉定向。“推动长江经济带发展，这是党中央作出的重大决策，是关系发展全局的重大战略，对实现‘两个一百年’奋斗目标、实现中国梦具有重要意义。”总书记在座谈会上开宗明义。</p> <p style=\"text-indent: 2em;\"> 早在2016年1月，习近平总书记在重庆召开推动长江经济带发展座谈会时就强调，“当前和今后相当长一个时期，要把修复长江生态环境摆在压倒性位置，共抓大保护，不搞大开发。”时隔两年，习近平总书记在武汉发表的重要讲话，从全局角度和战略高度提出了更为具体的思路，为更加富有成效地推进长江经济带发展提供了重要方法论，也为进入新时代的中国经济如何转向高质量发展作出了新的战略部署。</p> <p style=\"text-indent: 2em;\"> 万里长江寄托着习近平总书记的深深牵挂。党的十八大以来，总书记对长江经济带发展倾注了更多心血。“共抓大保护、不搞大开发。”“推动长江经济带发展是一个系统工程，不可能毕其功于一役。”“一定要给子孙后代留下一条清洁美丽的万里长江!” 习近平总书记站在历史和全局的高度，从中华民族长远利益出发，亲自谋划、推动长江经济带生态优先、绿色发展，擘画了新时代的“万里长江图”。</p> <p align=\"center\" style=\"text-align: center;\"> <img src=\"http://www.people.com.cn/mediafile/pic/GQ/20180611/47/18099064634160711375.jpg\" style=\"height: 378px; width: 550px;\" /></p> <p align=\"center\" class=\"pictext\"> <span style=\"color: rgb(0, 0, 205); text-indent: 2em; display: block;\"><span style=\"font-size: 18px; text-indent: 2em; display: block;\"><strong>总书记的“长江足迹”</strong></span></span></p> <p align=\"center\"> <strong>从上海的崇明岛，到青藏高原的三江源，习近平总书记的足迹遍及大江上下。他多次发表重要讲话，强调推动长江经济带发展必须走生态优先、绿色发展之路</strong></p> <p style=\"text-indent: 2em;\"> 从地方到中央，习近平总书记都心系长江，念兹在兹。</p> <p style=\"text-indent: 2em;\"> 据新华社报道，早在2001年，担任福建省省长的习近平就曾提出，福建“要注意从国家发展的全局找准自己的位置，将正在建设的海峡西岸繁荣带既与海峡东岸相对应相衔接，又与相邻的珠江三角洲、长江三角洲两大经济活跃地区相连接相贯通”。</p> <p style=\"text-indent: 2em;\"> 这一重要论述，站在全局角度谋划一省发展，充分体现了将“长江经济带作为流域经济”“全面把握、统筹谋划”“实现上中下游协同发展、东中西部互动合作”的宏阔格局。</p> <p style=\"text-indent: 2em;\"> 2004年5月，担任浙江省委书记的习近平专门率浙江省党政代表团赴长江沿线的四川、重庆、武汉考察，并登上正在施工的三峡大坝。担任浙江省委书记期间，习近平多次论述推进长三角地区一体化发展战略，明确提出“加强区域生态建设和环境保护，集约利用有限资源，加快建立可持续发展的资源环境支撑体系”发展思路。</p> <p style=\"text-indent: 2em;\"> 2005年8月，习近平提出了著名的“两座山论”。他指出，“我们追求人与自然的和谐，经济与社会的和谐，通俗地讲，就是既要绿水青山，又要金山银山。”“绿水青山可带来金山银山，但金山银山却买不到绿水青山。绿水青山与金山银山既会产生矛盾，又可辩证统一。”</p> <p style=\"text-indent: 2em;\"> “绝不能以牺牲生态环境为代价换取经济的一时发展。”这是习近平总书记对生态环境保护的一贯态度，也体现在对长江经济带发展的规划理念中。</p> <p style=\"text-indent: 2em;\"> 2014年12月，习近平总书记作出重要批示，强调建设长江经济带要坚持一盘棋思想，理顺体制机制，加强统筹协调，更好发挥长江黄金水道作用，为全国统筹发展提供新的支撑。</p> <p style=\"text-indent: 2em;\"> 2016年1月5日，习近平总书记在重庆主持召开推动长江经济带发展座谈会，就推动长江经济带发展听取上海、江苏、浙江、安徽、江西、湖北、湖南、重庆、四川、贵州、云南党委主要负责同志和国务院有关部门负责同志的意见和建议并发表重要讲话，提出推动长江经济带发展必须从中华民族长远利益考虑，全面深刻阐述了长江经济带发展战略的重大意义、推进思路和重点任务。</p> <p style=\"text-indent: 2em;\"> 2016年1月26日，习近平总书记主持召开中央财经领导小组第十二次会议，研究长江经济带发展规划。他强调，涉及长江的一切经济活动都要以不破坏生态环境为前提。</p> <p style=\"text-indent: 2em;\"> 2016年3月，习近平总书记主持召开中共中央政治局会议，审议通过了《长江经济带发展规划纲要》，会议强调，长江经济带发展的战略定位必须坚持生态优先、绿色发展，共抓大保护，不搞大开发。中央决策层关于建设国家重点战略区域长江经济带的顶层设计逐步完善，“共抓大保护”格局逐步形成。</p> <p align=\"center\" style=\"text-align: center;\"> <img src=\"http://www.people.com.cn/mediafile/pic/GQ/20180611/37/3118733237452781969.jpg\" style=\"height: 347px; width: 550px;\" /></p> <p style=\"text-indent: 2em;\"> 从上海的崇明岛，到青藏高原的三江源，习近平总书记的足迹遍及大江上下。他多次发表重要讲话，强调推动长江经济带发展必须走生态优先、绿色发展之路，涉及长江的一切经济活动都要以不破坏生态环境为前提，共抓大保护、不搞大开发。</p> <p style=\"text-indent: 2em;\"> 2017年10月18日，习近平总书记在党的十九大报告中明确指出，以共抓大保护、不搞大开发为导向推动长江经济带发展。</p> <p style=\"text-indent: 2em;\"> 2018年3月全国两会期间，习近平总书记在重庆代表团参加审议时强调，如果长江经济带搞大开发，下面的积极性会很高、投资驱动会非常强烈，一哄而上，最后损害的是生态环境。</p> <p style=\"text-indent: 2em;\"> 2018年4月26日，习近平主持召开深入推动长江经济带发展座谈会，明确提出了新形势下推动长江经济带发展需要正确把握整体推进和重点突破、生态环境保护和经济发展、总体谋划和久久为功、破除旧动能和培育新动能、自我发展和协同发展的5个关系。</p> <p style=\"text-indent: 2em;\"> “习近平总书记关于长江经济带发展的一系列讲话，从人与自然、人与水的关系的高度，夯实了长江经济带‘共抓大保护、不搞大开发’的哲学基础、历史基础和现实基础。”中国社会科学院城市发展与环境研究所所长助理李学锋告诉《中国报道》记者，“长江经济带发展坚持生态优先、绿色发展的战略定位，不仅是对自然规律的尊重，也是对历史规律、经济规律的尊重。”</p> <p align=\"center\" style=\"text-align: center;\"> <img src=\"http://www.people.com.cn/mediafile/pic/GQ/20180611/77/10689536438621771181.jpg\" style=\"height: 569px; width: 550px;\" /></p> <p align=\"center\" class=\"pictext\"> 4月25日上午，习近平总书记考察长江湖南岳阳段，在甲板上凭栏眺望。</p> <p align=\"center\"> <span style=\"color: rgb(0, 0, 205); text-indent: 2em; display: block;\"><span style=\"font-size: 18px; text-indent: 2em; display: block;\"><strong>总书记擘画长江经济带发展</strong></span></span></p> <p align=\"center\"> <strong>习近平总书记提出正确把握5个关系，为当前和今后很长一段时间内长江经济带的发展指明了方向和道路，闪烁着马克思主义理论光芒</strong></p> <p style=\"text-indent: 2em;\"> 新中国成立以来特别是改革开放以来，长江流域经济社会迅猛发展，综合实力快速提升，是我国经济重心所在、活力所在。</p> <p style=\"text-indent: 2em;\"> 2013年7月，习近平总书记在湖北调研时强调，“长江流域要加强合作，充分发挥内河航运作用，发展江海联运，把全流域打造成黄金水道。”长江流域的开发正式被国家层面提上议事日程。2014年国务院政府工作报告明确提出：“依托黄金水道，建设长江经济带。”这一战略被正式确定为国家战略。</p> <p style=\"text-indent: 2em;\"> 作为我国经济发展的“黄金带”，长江经济带覆盖11个省市，面积约205万平方公里，人口和经济总量均占全国的40%以上，生态地位重要、综合实力较强、发展潜力巨大。但另一方面，长江经济带发展面临诸多亟待解决的困难和问题，主要是生态环境状况形势严峻、长江水道存在瓶颈制约、区域发展不平衡问题突出、产业转型升级任务艰巨、区域合作机制尚不健全等。</p> <p style=\"text-indent: 2em;\"> “必须从中华民族长远利益考虑，把修复长江生态环境摆在压倒性位置，共抓大保护、不搞大开发，努力把长江经济带建设成为生态更优美、交通更顺畅、经济更协调、市场更统一、机制更科学的黄金经济带，探索出一条生态优先、绿色发展新路子。”习近平总书记一句“把修复长江生态环境摆在压倒性位置”，为深入推动长江经济带发展定下了基调。</p> <p style=\"text-indent: 2em;\"> “习近平总书记关于长江经济带发展的论述，充分体现了总书记坚持以人民为中心的发展思想，体现了新发展理念对当前我国社会经济发展的指导作用。”中央党校(国家行政学院)副校长(副院长)王东京对《中国报道》记者表示。</p> <p style=\"text-indent: 2em;\"> “绿色发展也涉及到生产关系与利益关系的调整，是中国特色社会主义政治经济学的重要组成部分。众所周知，欧美国家曾走过一条‘先污染后治理’的路，中国作为一个发展中大国，面临资源约束趋紧、环境污染严重、生态系统退化的严峻形势，走欧美国家的老路肯定行不通。有鉴于此，总书记指出‘建设生态文明是中华民族永续发展的千年大计’，并强调‘必须树立和践行绿水青山就是金山银山的理念’。”王东京说。</p> <p style=\"text-indent: 2em;\"> 2016年1月5日，习近平总书记在重庆召开的推动长江经济带发展座谈会上表示，“当前和今后相当长一个时期，要把修复长江生态环境摆在压倒性位置，共抓大保护，不搞大开发。”彼时，正是沿岸一些地方快马加鞭上项目之际。</p> <p style=\"text-indent: 2em;\"> 两年后，习近平总书记再次就长江经济带发展阐述了重要思想。习近平总书记强调，“新发展理念要体现到长江经济带发展中。”</p> <p style=\"text-indent: 2em;\"> “新发展理念是对我国经济发展实践规律的提炼，是一个完整的体系，贯彻落实发展理念，是以长江经济带发展推动经济高质量发展的关键。”王东京说。</p> <p style=\"text-indent: 2em;\"> 习近平总书记明确提出，推动长江经济带发展需要正确把握5个关系：</p> <p style=\"text-indent: 2em;\"> ——正确把握整体推进和重点突破的关系，全面做好长江生态环境保护修复工作。“要坚持整体推进，增强各项措施的关联性和耦合性，防止畸重畸轻、单兵突进、顾此失彼。”</p> <p style=\"text-indent: 2em;\"> ——正确把握生态环境保护和经济发展的关系，探索协同推进生态优先和绿色发展新路子。“生态环境保护和经济发展不是矛盾对立的关系，而是辩证统一的关系。”</p> <p style=\"text-indent: 2em;\"> ——正确把握总体谋划和久久为功的关系，坚定不移将一张蓝图干到底。“要对实现既定目标制定明确的时间表、路线图，稳扎稳打，分步推进。”</p> <p style=\"text-indent: 2em;\"> ——正确把握破除旧动能和培育新动能的关系，推动长江经济带建设现代化经济体系。“要扎实推进供给侧结构性改革，推动长江经济带发展动力转换，建设现代化经济体系。”</p> <p style=\"text-indent: 2em;\"> ——正确把握自身发展和协同发展的关系，努力将长江经济带打造成为有机融合的高效经济体。“要运用系统论的方法，正确把握自身发展和协同发展的关系。”</p> <p style=\"text-indent: 2em;\"> “习近平总书记提出正确把握5个关系，为当前和今后很长一段时间内长江经济带的发展指明了方向和道路，闪烁着马克思主义理论光芒，体现了对新时代中国经济如何转向高质量发展的全局性、长期性、战略性考量。”中国国际经济交流中心首席研究员张燕生告诉《中国报道》记者。</p> <p align=\"center\" style=\"text-align: center;\"> <img src=\"http://www.people.com.cn/mediafile/pic/GQ/20180611/6/5174658215192760798.jpg\" style=\"height: 376px; width: 550px;\" /></p> <p style=\"text-align: center;\"> 4月26日下午，习近平总书记在武汉主持召开深入推动长江经济带发展座谈会并发表重要讲话。座谈会前，总书记于25日下午在岳阳城陵矶水文站考察。</p> <p align=\"center\"> <span style=\"color: rgb(0, 0, 205); text-indent: 2em; display: block;\"><span style=\"font-size: 18px; text-indent: 2em; display: block;\"><strong>打造一个高质量发展的样板</strong></span></span></p> <p align=\"center\"> <strong>在长江沿岸，“保护”与“开发”的矛盾一度突出，而破解这对矛盾的钥匙就是推动实现高质量发展</strong></p> <p style=\"text-indent: 2em;\"> 长江经济带是我国的经济重心所在。根据长江经济带发展统计监测数据，2018年一季度，长江经济带沿线上海、江苏、浙江、安徽、江西、湖北、湖南、四川、重庆、云南、贵州11省市共实现生产总值87813.54亿元，占全国44.18%。</p> <p style=\"text-indent: 2em;\"> 长江经济带也是我国创新驱动的重要集聚带。这里集中了全国1/3的高等院校、科研机构和全国1/2左右的两院院士、科技人员，拥有7个国家自主创新示范区和500多家各类国家级创新平台。</p> <p style=\"text-indent: 2em;\"> 针对生态环境保护和经济发展的关系，习近平总书记指出，不搞大开发不是不要开发，而是不搞破坏性开发，要走生态优先、绿色发展之路。</p> <p style=\"text-indent: 2em;\"> “在长江沿岸，‘保护’与‘开发’的矛盾一度突出，而破解这对矛盾的钥匙就是推动实现高质量发展，高质量发展才能实现‘保护’与‘开发’的统一。”中国社会科学院城市发展与环境研究所所长助理李学锋对《中国报道》记者表示。</p> <p style=\"text-indent: 2em;\"> 根据推动长江经济带发展领导小组办公室2018年年初的信息，以《长江经济带发展规划纲要》为统领的10个专项规划、沿江11省市实施方案印发施行，顶层、中层设计体系基本完成。生态环境保护6项专项行动、5项制度建设、10项重大工程加快推进，959座非法码头已彻底拆除，其中85%完成生态复绿。2017年前三季度，长江经济带地表水水质优良(Ⅲ类水以上)比例平均为77.3%、同比上升2.5个百分点。</p> <p style=\"text-indent: 2em;\"> 习近平总书记强调：“发展也要讲兵法，兵无常势。有所为是发展，有所不为也是发展，要因时而宜。”</p> <p style=\"text-indent: 2em;\"> 宜昌市兴发集团新材料产业园曾经资源消耗大，污染严重。从2017年开始，企业对园区临江生产设施拆除或整体搬迁，关闭了排污口，并对拆除区域进行全面绿化。2017年，该园区还斥资1.2亿元，打造了三级应急系统，防止发生事故时污染长江水体。</p> <p style=\"text-indent: 2em;\"> 4月24日，习近平总书记到达宜昌，第一个考察点就是兴发集团新材料产业园，聚焦的是破解“化工围江”问题。听闻宜昌推动沿江134家化工企业关、转、搬，引导向高端产业发展，他赞许地说，这样做才是领会党的十九大精神，才是贯彻新发展理念。</p> <p style=\"text-indent: 2em;\"> “新时代的长江经济带应当成为中国经济高质量发展的一个样板，成为构建现代化经济体系的一个新引擎和增长极。”张燕生对《中国报道》记者表示，长江经济带的发展，要围绕创新链配置资金链，围绕资金链配置产业链，围绕产业链配置供应链和市场布局，从要素、规模、低端驱动转到创新、人才、服务驱动;从高碳增长转到绿色发展。</p> <p style=\"text-indent: 2em;\"> 根据国家发改委、科技部、工业和信息化部2016年3月联合发布的《长江经济带创新驱动产业转型升级方案》，以创新驱动促进产业转型升级是长江经济带实现经济提质增效和绿色发展的重要任务，到2020年，长江经济带在创新能力、产业结构、经济发展等方面取得突破性进展。到2030年，创新驱动型产业体系和经济格局全面建成，创新能力进入世界前列，区域协同合作一体化发展成效显著，成为引领我国经济转型升级、支撑全国统筹发展的重要引擎。</p> <p style=\"text-indent: 2em;\"> 长江经济带的生态与发展互促互长的发展模式已经取得良好效应。数据显示，2017年前三季度，沿江11省市GDP增速全部高于全国平均增幅，经济发展质量和效益不断提高，其中浙江、安徽、江西、重庆、四川、贵州、云南等省市增速均在8%以上。</p> <p style=\"text-indent: 2em;\"> 产业升级助力生态保护，生态保护倒逼经济转型。以武汉为例，这座曾经以重工业为引领的中部城市，正进行着一场更深层次的结构调整和新旧动能转换，武汉信息技术、生物医药、智能制造等为代表的“新武汉造”强势崛起;以“中国光谷”闻名的东湖高新区成为第二个国家自主创新示范区。武汉青山区因武钢设区，工业“三废”排放一度占武汉市的60%，现在正着力发展高端制造业、高品质服务业和高新技术产业。</p> <p style=\"text-indent: 2em;\"> 张燕生表示，新旧动能的转换不是“喜新厌旧”，一方面要大力发展新业态新动能，另一方面要跳出过去发展的老思路，在破除无效供给的同时，实现转型升级，让旧产业旧动能也能插上“新”翅膀。</p> <p align=\"center\" style=\"text-align: center;\"> <img src=\"http://www.people.com.cn/mediafile/pic/GQ/20180611/17/12204329123898966197.jpg\" style=\"height: 366px; width: 550px;\" /></p> <p align=\"center\" class=\"pictext\"> 4月24日下午，习近平总书记在三峡大坝坝顶察看三峡工程和坝区周边生态环境。</p> <p align=\"center\"> <span style=\"color: rgb(0, 0, 205); text-indent: 2em; display: block;\"><span style=\"font-size: 18px; text-indent: 2em; display: block;\"><strong>树立“一盘棋”思想，一张蓝图干到底</strong></span></span></p> <p align=\"center\"> <strong>总书记提出树立“一盘棋”思想，明确了长江经济带实现错位发展、协调发展、有机融合的战略思维</strong></p> <p style=\"text-indent: 2em;\"> “长江经济带不是一个个独立单元，要树立一盘棋思想。”“加强改革创新、战略统筹、规划引导，以长江经济带发展推动经济高质量发展。”</p> <p style=\"text-indent: 2em;\"> “要有‘功成不必在我’的精神境界和‘功成必定有我’的历史担当。我们都是其中一个建设者。做好顶层设计后，只要一锤接着一锤敲，必然大有成效。”“对环境的贡献也要写入功劳簿，以此作为重要指标考量干部的奖惩。”</p> <p style=\"text-indent: 2em;\"> 习近平总书记为长江经济带发展提供了方法论、树立了政绩观。</p> <p style=\"text-indent: 2em;\"> 国务院发展研究中心资源与环境政策研究所副所长李佐军说，习近平总书记提出树立“一盘棋”思想，明确了长江经济带实现错位发展、协调发展、有机融合的战略思维。一方面，各地要发挥自身优势，避免同质化竞争;另一方面，要通过建立统一市场和规则，让生产要素优化配置。</p> <p style=\"text-indent: 2em;\"> 张燕生也表示，长江经济带的发展思路就是要统筹各地改革、各项区际政策、各类资源要素，实现各自为政的孤立式发展转向区域协同的联动式发展，促进沿线地区效率最大化和长江经济带发展一体化。</p> <p style=\"text-indent: 2em;\"> 《人民日报》这样表示：牵住体制机制的“牛鼻子”，结合机构改革、职能转换，长江经济带发展进一步明晰职能：“落实中央统筹、省负总责、市县抓落实的管理体制。中央管两头，一头在政策资金方面创造条件，一头是加强全流域、跨地区的事务协调和督促检查。省一级要承上启下，把大政方针决策部署转化为实施方案，加强指导和督导。市县层面，因地制宜推动工作落地生根。”</p> <p style=\"text-indent: 2em;\"> 南京大学江苏长江产业经济研究院院长刘志彪认为，要以供给侧结构性改革主导长江流域重化工业调整，特别要注意10个方面：我国作为一个发展中大国，经济的特点决定了无法回避能源重化工业发展阶段;能源重化工业同样应走科学发展、和谐发展、绿色发展之路;机械电子工业应是重化工业的主要内容;长江经济带应为宜于人居的经济聚集带;必须彻底改革传统的地方增长优先、分割的体制机制;必须建立和完善长江生态补偿机制;解决好中央和地方财政分权体制的内在矛盾，建立修复和保护长江生态环境的激励约束机制;不能低估长江流域环保过程中的“邻避主义”困难;先污染后治理的老路不能再继续下去;改变分散竞争的格局，才能实现长江沿线沿海重化工业的自动产业聚集。</p> <p align=\"center\" style=\"text-align: center;\"> <img src=\"http://www.people.com.cn/mediafile/pic/GQ/20180611/83/14238265997965108139.jpg\" style=\"height: 378px; width: 550px;\" /></p> <p style=\"text-indent: 2em;\"> 四川省社会科学院副院长盛毅表示，要推动长江中上游大城市集约发展，把不分层次地集聚要素数量转变为着重集聚中高端要素;把平面推进的城市开发转变为立体推进的城市开发;把摊大饼式的布局方式转变为组团式的布局方式;把偏重生产功能的配置转变为兼具良好生活功能的配置;把单个城市的独立集聚转变为网络型城市体系的集聚;把城市大量废弃排放物转变为可以综合利用的资源。</p> <p style=\"text-indent: 2em;\"> 李学锋对《中国报道》记者表示，可以在长江沿岸城市全面推广“正面清单”和“负面清单”制度，鼓励和引导各省市走差异化发展路径，构筑各具特色、合理分工、有序竞争、共同发展的产业格局。也要明确高质量发展的指标体系和考核体系，促使高质量发展要求落地生根。</p> <p style=\"text-indent: 2em;\"> “在推进长江经济带发展中，要把握几个层面的重点：一是长江经济带的谋划和发展要真正贯彻新发展理念，二是要吃透高质量发展与新发展理念的关系，三是要准确执行中央既定方针，四是要抓住、落实推动长江经济带发展的五大关系。”李学锋说。</p> <p style=\"text-indent: 2em;\"> (本文刊发于《中国报道》2018年6月刊)</p>', 'http://politics.people.com.cn/n1/2018/0611/c1001-30050448.html', '2018-06-11', 'http://politics.people.com.cn/n1/2018/0611/c1001-3', '新时代 “万里长江图”', 'http://politics.people.com.cn/n1/2018/0611/c1001-30050448.html', '1528795506');
INSERT INTO `message_news` VALUES ('62', 'T1467284926140', 'News', 'e28743a4a898bf11042cd5346f283cd5', '<p> 　　核心阅读</p> <p> 　　一季度，全国银保监系统共接收保险消费投诉22651件，虽较去年同期下降9.90%，但仍在高位运行。究其根本是保险公司没有真正树立客户至上的经营理念，消费者权益保护意识淡薄，主体责任落实不到位，特别是对销售行为管控不力。对此，监管部门进一步强化了对保险销售误导的查处惩戒力度，组织开展“精准打击行动”，从严整治、从快处理、从重问责，发挥警示和震慑作用，将消费者合法权益保护更好地落到实处。</p> <p> 　　</p> <p> 　　近日，中国银行保险监督管理委员会结合2017年度保险消费投诉处理考评情况，对投诉处理考评排名靠后的新华人寿、中国人寿、人民人寿、阳光人寿、泰康人寿、中华财险、永安财险、太平财险、英大财险、众安在线等10家保险公司主要负责人分别进行监管谈话。</p> <p> 　　业内人士表示，各公司高管被监管部门分别约谈，在行业还是头一遭，体现出监管部门保护消费者权益的决心。</p> <p> 　　近年来，随着人民生活水平的提高，保险产品和服务不仅覆盖各行各业，也更加深入百姓生活。在居民保险消费意识显著提高的同时，各类消费纠纷也如影随形，消费投诉随之大量产生。</p> <p> 　　这些投诉有哪些“热点”？背后反映出行业发展的哪些深层问题？如何改进？本报记者采访了银保监会有关部门负责人。</p> <p> 　　保险投诉仍高位运行，理赔纠纷和销售纠纷问题较为突出</p> <p> 　　数据显示，今年一季度，全国银保监系统共接收保险消费投诉22651件，虽较去年同期下降9.90%，但仍在高位运行。财产险方面，消费者投诉涉及财产保险10944件。其中，理赔纠纷投诉8628件，占财产保险投诉总量的78.84%，理赔纠纷仍以车险理赔为主，主要反映定核损和核赔阶段的责任认定争议、理赔时效慢、理赔金额无法达成一致、拒赔理由争议、承保未尽说明义务导致理赔争议等问题。</p> <p> 　　人身险方面，消费者投诉涉及人身保险11707件。其中，销售纠纷投诉4907件，占人身保险投诉总量的41.92%，主要反映夸大保险责任或收益，未如实说明保险期间、不按期交费后果、解约损失和满期给付年限等重要合同内容，以及虚假不实宣传等问题；理赔纠纷投诉3246件，占比27.73%，主要反映核赔阶段责任认定争议、核赔时效慢、核赔金额争议等问题；退保纠纷投诉1140件，占比9.74%，主要反映退保金额争议、退保时效慢等问题。分险种看，疾病保险、医疗保险等保障型业务投诉显著增加，同比增长41.63%。</p> <p> 　　“投诉数据与监管部门掌握的市场运行情况也相互印证。”银保监会有关负责同志说，“比如人身险投诉中，销售纠纷问题比较集中，2017年因保险销售引发的投诉占人身险投诉的45.60%，其中误导保险责任或收益所导致的投诉又占销售纠纷投诉的八成以上。”</p> <p> 　　“保险投诉较多，究其根本是保险公司没有真正树立客户至上的经营理念，消费者权益保护意识淡薄，主体责任落实不到位，特别是对销售行为管控不力。”他表示，部分保险公司“重前端销售轻后端理赔、重业绩轻服务”的问题比较突出，难以满足消费者日益增长的保险需求。同时，部分营销人员存在片面解释产品条款、故意隐瞒保险合同重要内容等情况，侵害保险消费者的知情权和合法利益。</p> <p> 　　“急功近利的销售行为，既损害了消费者合法权益，也损害了保险机构的自身信誉和行业的社会形象。”这位负责人表示。</p> <p> 　　互联网保险投诉增多，航班延误险、旅行意外险等是投诉热点</p> <p> 　　痼疾未除，烦恼又至。这几年，互联网销售渠道投诉集中快速增长。2017年，保险监管机构共接收互联网销售渠道投诉4303件，较2016年同期增长52.64%。其中，通过互联网销售的航班延误险、旅行意外险、退货运费险、酒店取消险等是投诉的“重灾区”。</p> <p> 　　业内人士指出，互联网保险投诉猛增的原因，一是销售方式与充分保护消费者合法权益存在不适应。与面对面销售不同，网销保险大多采用“勾选阅读”方式向消费者解释说明保险条款、保险责任等内容，容易造成消费者忽视或误解影响其投保的重要信息，导致后期理赔时发生矛盾纠纷。二是服务配套与业务发展速度不匹配。线上新业务开疆拓土，线下却没有足够的实体服务网点、人员与之匹配；部分第三方互联网平台数据系统建设滞后，与保险公司业务系统未能实时对接，造成消费者投保后不能查询保单、无法及时享受保险服务等问题。三是部分大型互联网平台与保险公司合作时，在资本、信息、客户资源等方面处于优势地位，后者难以对其销售行为进行有效管控，极易引发投诉。</p> <p> 　　“还有部分保险公司为追求爆款、吸引眼球，产品设计开发的科学性和严谨性等方面存在欠缺，易引发保险消费纠纷。”银保监会这位负责同志表示，对老毛病、新问题，监管部门一直在持续打击。</p> <p> 　　今年5月28日，银保监会通报了对人保寿险泉州中心支公司的行政处罚决定，该公司一方面欺骗投保人，谎称产品“限时7天”销售，以及“6%已秒杀各大银行最新利率”“年年享有分红金”的表述，同时还拒不向检查组提供相关资料，妨碍依法监督检查。为此，该公司被处以25万元的罚款，相关责任人受到严肃处理。</p> <p> 　　监管部门将持续保持严处罚、严问责态势</p> <p> 　　这次被约谈的10家保险公司，存在的主要问题集中在保险消费投诉数量较高、投诉处理制度落实不到位、销售纠纷和理赔纠纷投诉较多等方面。除了一把手，引发投诉较多的业务部门负责人也被要求参加监管谈话。</p> <p> 　　接受谈话的保险公司负责人均表示，将严格落实监管要求，限期整改，以有效措施妥善处理投诉纠纷，不断提升经营水平和服务质量，切实保护消费者合法权益。</p> <p> 　　“净化保险市场，保护消费者权益，要打攻坚战，也要打持久战。”银保监会这位负责同志表示，监管部门将坚持“以人民为中心”监管理念，扎实推进整治市场乱象各项工作，严厉查处各类损害消费者合法权益的违法违规行为，继续加大对保险销售误导和理赔难的治理力度。</p> <p> 　　近期，中国银保监会进一步强化了对保险销售误导的查处惩戒力度，组织开展“精准打击行动”，从严整治、从快处理、从重问责，发挥警示和震慑作用。“监管部门将持续保持对违法违规行为严处罚、严问责的高压态势，整顿规范市场秩序，将消费者合法权益保护更好地落到实处，形成常态。”这位负责人说。</p> <p> 　　业内人士指出，银保监会合并后，监管表现出更强的执行力——针对银行保险销售误导问题，银保监会日前打出一记重拳。根据银保监会官网6月6日通报，对阳光人寿销售产品时所宣称保险期间和年化收益率等内容与保险合同规定严重不符、欺骗投保人的违法违规行为，对中国银行呼和浩特市呼和佳地支行允许保险公司工作人员驻点销售、参与银行代理保险销售工作和“双录”工作的违法违规行为，依法作出行政处罚：涉事保险机构被停止接受银行代理新业务1年并处罚款60万元，涉事银行停止接受代理保险新业务1年并处罚款30万元，相关负责人也都受到警告和罚款。</p> <br /> <p> <span id=\"paper_num\">　　《 人民日报 》（ 2018年06月11日 23 版）</span></p>', 'http://politics.people.com.cn/n1/2018/0611/c1001-30049471.html', '2018-06-11', 'http://politics.people.com.cn/n1/2018/0611/c1001-3', '保险销售误导和理赔难，严查！', 'http://politics.people.com.cn/n1/2018/0611/c1001-30049471.html', '1528795506');
INSERT INTO `message_news` VALUES ('63', 'T1467284926140', 'News', '7a3ab66b4198b910b7d74908c14ff51c', '<p style=\"text-indent: 2em;\"> 本报北京6月10日电&nbsp;&nbsp;（记者欧阳洁）银保监会拟发布《中国银行保险监督管理委员会关于废止和修改部分规章的决定（征求意见稿）》（简称《决定》），取消中资银行和金融资产管理公司外资持股比例限制，实施内外资一致的股权投资比例规则，持续推进外资投资便利化。</p> <p style=\"text-indent: 2em;\"> 《决定》遵循国民待遇原则，不对外资入股中资金融机构作单独规定，中外资适用统一的市场准入和行政许可办法。删去关于单个境外金融机构及其关联方作为发起人或战略投资者向单个中资商业银行、农村商业银行以及作为战略投资者向单个金融资产管理公司的投资入股比例不得超过20%、多个境外金融机构及其关联方投资上述机构入股比例合计不得超过25%的规定。</p> <p style=\"text-indent: 2em;\"> 按照中外资同等对待的原则，《决定》明确境外金融机构投资入股中资商业银行和农村中小金融机构的，按入股时该机构的机构类型实施监督管理，不因外资入股调整银行的机构类型。为中外资入股银行业创造公平、公开、透明的规则体系，保持监管规则和监管体系的稳定性和连续性。同时明确境外金融机构投资入股中资银行，除需符合相关的金融审慎监管规定外，还应遵守我国关于外国投资者在中国境内投资的外资基础性法律。</p> <p style=\"text-indent: 2em;\"> <span id=\"paper_num\" style=\"text-indent: 2em; display: block;\">《 人民日报 》（ 2018年06月11日 15 版）</span></p>', 'http://politics.people.com.cn/n1/2018/0611/c1001-30049432.html', '2018-06-11', 'http://politics.people.com.cn/n1/2018/0611/c1001-3', '银保监会推进外资投资便利化', 'http://politics.people.com.cn/n1/2018/0611/c1001-30049432.html', '1528795506');
INSERT INTO `message_news` VALUES ('64', 'T1467284926140', 'News', 'db00bdcac33933b18bf89b296c32517c', '<p style=\"text-indent: 2em;\"> 本报福州6月10日电&nbsp;&nbsp;（记者何璐）近日，福建出台《福建省新一轮促进工业和信息化龙头企业改造升级行动计划（2018—2020年）》，推动龙头企业改造升级、持续做大做优做强。</p> <p style=\"text-indent: 2em;\"> 《行动计划》明确，到2020年在全省工业和信息化领域重点培育300家以上规模体量大、带动力强的龙头企业，其中营业收入（产值）超百亿元的企业达到50家以上，带动形成12个以上规模超千亿的产业集群，带动培育100家以上单项冠军和一批“隐形冠军”企业、100家以上省级服务型制造示范企业、500家以上“专精特新”中小企业、500家以上科技小巨人领军企业。各地要更好地发挥政策叠加效应，强化龙头企业引领示范，带动中小企业发展，带动产业集群建设，带动生产性服务业提升，进一步促进经济稳定增长，实现产业高质量发展，加快建设先进制造业大省。</p> <p style=\"text-indent: 2em;\"> <span id=\"paper_num\" style=\"text-indent: 2em; display: block;\">《 人民日报 》（ 2018年06月11日 15 版）</span></p>', 'http://politics.people.com.cn/n1/2018/0611/c1001-30049431.html', '2018-06-11', 'http://politics.people.com.cn/n1/2018/0611/c1001-3', '福建推动龙头企业改造升级', 'http://politics.people.com.cn/n1/2018/0611/c1001-30049431.html', '1528795506');
INSERT INTO `message_news` VALUES ('65', 'T1467284926140', 'News', '26cf86bffae71beadf8446f85a697d5d', '<table class=\"pci_c\" width=\"400\"> <tbody> <tr> <td align=\"middle\"> <img src=\"http://paper.people.com.cn/rmrb/res/1/20180611/1528662515260_1.jpg\" /></td> </tr> <tr> <td> <p style=\"text-indent: 2em;\"> 图为市民来到首农食品集团王致和公司参观。<br /> 　　本报记者 徐 烨摄</p> </td> </tr> </tbody> </table> <p style=\"text-indent: 2em;\"> 本报北京6月10日电&nbsp;（记者贺勇）在三元现代化的乳制品加工生产线，见证一杯健康牛奶的诞生；在古船面粉加工基地，亲身体验日常面点的制作……6月10日，由北京市委宣传部、北京市国资委等9家单位联合主办的第三届2018年“首都国企开放日”活动正式启动，首农食品集团向广大市民开放了4条主要参观线路共15个参观点，从食品加工到农耕文化，再到科普体验，每条线路都各具特色。</p> <p style=\"text-indent: 2em;\"> 据介绍，活动当天共有76家企业报名，开放线路总数达155条，其中57条为新开线路，充分满足广大市民参观、探秘的需求，使广大市民进一步了解国企，认知国企，理解国企，支持国企。此外，开放日活动还有一大特点——首都国企走出北京，走向全国，走向海外。同仁堂集团今年将在南非约翰内斯堡开放同仁堂中医针灸中心、同仁堂博物馆和非洲商贸城同仁堂药店。</p> <p style=\"text-indent: 2em;\"> 截至2017年底，北京市属企业资产总额突破4.5万亿元，比2012年翻了一番，营业收入、利润总额、上交税费较2012年分别增长了73%、118%和130%。14家企业资产超千亿元，2家企业利润超百亿元，17家企业进入中国500强。</p> <p style=\"text-indent: 2em;\"> <span id=\"paper_num\" style=\"text-indent: 2em; display: block;\">《 人民日报 》（ 2018年06月11日 15 版）</span></p>', 'http://politics.people.com.cn/n1/2018/0611/c1001-30049430.html', '2018-06-11', 'http://politics.people.com.cn/n1/2018/0611/c1001-3', '北京举行国企开放日活动', 'http://politics.people.com.cn/n1/2018/0611/c1001-30049430.html', '1528795506');
INSERT INTO `message_news` VALUES ('66', 'T1467284926140', 'News', '8b442c80e4d040b394d23202a6b6fba3', '<p style=\"text-indent: 2em;\"> 本报上海6月10日电&nbsp;&nbsp;（记者田泓）上海浦东新区、宁波市、南通市、舟山市海洋主管部门日前签订《长三角区域海洋经济协同创新发展联盟》协议，上海临港海洋高新技术产业化基地、宁波梅山海洋战略性新兴产业示范基地、江苏省通州湾江海联动开发示范区、舟山群岛新区海洋产业集聚区、彩虹鱼（舟山）海洋战略新兴产业示范园等四地5个涉海园区开展广泛合作，建立运筹涉海类人才、科技、金融、项目、市场等资源的跨区域协同平台。</p> <p style=\"text-indent: 2em;\"> 据介绍，平台将提升产业协作水平，全面梳理产业项目和产业资源，定期举办重大招商推介活动；深化科技创新和人才合作，积极筹备、探索建设长三角海洋产业创新联盟，推动科研院所和企业建立合作研发机构及联合技术转移中心，做好涉海类人才引进互融互通、人才培养共育共培、人才评价互认互准、创新平台共建共享等。</p> <p style=\"text-indent: 2em;\"> <span id=\"paper_num\" style=\"text-indent: 2em; display: block;\">《 人民日报 》（ 2018年06月11日 15 版）</span></p>', 'http://politics.people.com.cn/n1/2018/0611/c1001-30049429.html', '2018-06-11', 'http://politics.people.com.cn/n1/2018/0611/c1001-3', '长三角四地加强海洋经济协同发展', 'http://politics.people.com.cn/n1/2018/0611/c1001-30049429.html', '1528795506');
INSERT INTO `message_news` VALUES ('67', 'T1467284926140', 'News', '4aec2ba96e8fe7f7078fcd29745685df', '<p style=\"text-indent: 2em;\"> 本报北京6月10日电&nbsp;&nbsp;（记者林丽鹂）市场监管总局近日召开“6·18”网络集中促销行政指导座谈会，要求网络交易平台（网站）经营者切实履行网络经营主体责任，切实做到以下几点：</p> <p style=\"text-indent: 2em;\"> 自觉遵守《网络交易管理办法》《网络商品和服务集中促销活动管理暂行规定》等相关规定；自觉落实促销信息事先公示、平台进入把关、促销信息记录和保存义务；禁止通过协议等方式限制、排斥促销经营者参加其他平台组织的促销活动。</p> <p style=\"text-indent: 2em;\"> 监督促销经营者自觉履行促销活动义务，遵守《网络购买商品七日无理由退货暂行办法》等相关规定，不得利用格式条款侵害消费者合法权益，不得因促销降低商品质量，借机以次充好，以假充真；自觉遵守促销信息规范和促销广告规范，不得对商品和服务作引人误解的虚假宣传和表示，不得发布虚假广告，不得先涨价再打折，不得虚报特价揽客，实施有价无货的欺诈行为；禁止采用虚构交易、成交量或者虚假用户评价等虚抬商誉的方式进行促销。</p> <p style=\"text-indent: 2em;\"> 采取必要的技术手段保障平台正常运行，自觉加强售后服务队伍管理，及时处理消费者投诉和商标权利人投诉，制定促销活动物流配送应急预案，多向消费者提供质量优、价格实、服务好的商品和服务；禁止违背合法、正当、必要的原则，收集、使用、泄露、出售消费者和经营者个人信息。</p> <p style=\"text-indent: 2em;\"> 京东、阿里巴巴、苏宁易购、国美在线、当当网、网易考拉、贝贝网、唯品会等12家网络交易平台（网站）相关负责人出席座谈会。</p> <p style=\"text-indent: 2em;\"> <span id=\"paper_num\" style=\"text-indent: 2em; display: block;\">《 人民日报 》（ 2018年06月11日 15 版）</span></p>', 'http://politics.people.com.cn/n1/2018/0611/c1001-30049428.html', '2018-06-11', 'http://politics.people.com.cn/n1/2018/0611/c1001-3', '网络促销不得先涨再折', 'http://politics.people.com.cn/n1/2018/0611/c1001-30049428.html', '1528795506');
INSERT INTO `message_news` VALUES ('68', 'T1467284926140', 'News', 'cc57d7027cbab763549e3530208a7f98', '<p style=\"text-indent: 2em;\"> 本报北京6月10日电&nbsp;&nbsp;（记者寇江泽）生态环境部日前印发《2018—2019年蓝天保卫战重点区域强化督查方案》，将于6月11日启动强化督查。</p> <p style=\"text-indent: 2em;\"> 当前，我国京津冀及周边地区、汾渭平原及长三角地区等重点区域空气质量继续改善，但个别地区污染仍然较重。</p> <p style=\"text-indent: 2em;\"> 生态环境部环境监察局负责人表示，强化督查将突出重点区域、重点指标、重点时段和重点领域，围绕产业结构、能源结构、运输结构和用地结构4项重点任务，检查“散乱污”企业综合整治情况、工业企业环境问题治理情况、清洁取暖及燃煤替代情况等13项督查任务。该负责人介绍，“本次强化督查从2018年6月11日开始，将持续到2019年4月28日结束，共动用约1.8万人次。”</p> <p style=\"text-indent: 2em;\"> 该负责人表示，生态环境部专项督查办公室统一负责指挥、调度、协调强化督查工作。排查发现的问题，由专项办审核后，第一时间向各城市推送下发电子督办单，增强交办时效性。每两轮督查结束后，安排一周时间，由督查组对之前交办问题进行核查，确保按期整改到位。</p> <p style=\"text-indent: 2em;\"> <span id=\"paper_num\" style=\"text-indent: 2em; display: block;\">《 人民日报 》（ 2018年06月11日 14 版）</span></p>', 'http://politics.people.com.cn/n1/2018/0611/c1001-30049384.html', '2018-06-11', 'http://politics.people.com.cn/n1/2018/0611/c1001-3', '重点区域强化督查启动', 'http://politics.people.com.cn/n1/2018/0611/c1001-30049384.html', '1528795506');
INSERT INTO `message_news` VALUES ('69', 'T1467284926140', 'News', '00bc7ef621de97036241cef6c6191138', '<p style=\"text-indent: 2em;\"> 今年6月17日是第二十四个“世界防治荒漠化和干旱日”。我国宣传的主题是“防治土地荒漠化&nbsp;助力脱贫攻坚战”，旨在进一步激励和动员广大人民群众积极参与土地荒漠化防治，逐步改善沙区生态状况，加快发展沙区绿色产业，实现治沙增绿和脱贫致富协调发展。</p> <p style=\"text-indent: 2em;\"> 荒漠化是全球面临的重大生态问题，世界上许多地方的人民饱受荒漠化之苦。《联合国防治荒漠化公约》生效20多年来，在各方共同努力下，全球荒漠化防治取得了明显成效。中国是世界上荒漠化面积最大、受风沙危害严重的国家。全国有荒漠化土地261.16万平方公里，占国土面积的27.2%；沙化土地172.12万平方公里，占国土面积的17.9%。中国政府历来高度重视荒漠化防治工作，认真履行《联合国防治荒漠化公约》，采取了一系列行之有效的政策措施，加大荒漠化防治力度。经过半个多世纪的积极探索和不懈努力，走出了一条生态与经济并重、治沙与治穷共赢的荒漠化防治之路。全国荒漠化土地面积自2004年以来已连续三个监测期持续净减少，荒漠化扩展的态势得到有效遏制，实现了由“沙进人退”到“绿进沙退”的历史性转变，成为全球荒漠化防治的成功典范，为实现全球土地退化零增长目标提供了“中国方案”和“中国模式”，为全球生态治理贡献了“中国经验”和“中国智慧”，受到国际社会的广泛赞誉。</p> <p style=\"text-indent: 2em;\"> 土地荒漠化与贫困相伴相生，互为因果。我国近35%的贫困县、近30%的贫困人口分布在西北沙区。沙区既是全国生态脆弱区，又是深度贫困地区；既是生态建设主战场，也是脱贫攻坚的重点难点地区，改善生态与发展经济的任务都十分繁重。打好沙区精准脱贫与生态保护修复两大攻坚战，必须深入学习贯彻习近平生态文明思想，牢固树立绿水青山就是金山银山的理念，坚持治沙与治穷相结合，增绿与增收相统一，采取更大的支持力度、更实的工作举措，通过生态保护脱贫、生态建设脱贫、生态产业脱贫，让沙地变绿、让农民变富、让乡村变美，实现防沙治沙与精准脱贫互利共赢。</p> <p style=\"text-indent: 2em;\"> 一要加强生态保护修复，促进沙区生态改善。生态问题是沙区最突出的问题，严重制约沙区经济社会可持续发展。要牢固树立尊重自然、顺应自然、保护自然的理念，坚持生态优先、保护优先、自然修复为主的方针，实行最严格的保护制度，全面落实荒漠生态保护红线，严格保护荒漠天然植被，促进自然植被休养生息。要认真实施《防沙治沙法》，全面落实防沙治沙目标责任考核奖惩、沙化土地封禁保护等制度。要坚持科学治沙，充分考虑水分平衡问题，以水定需、量水而行，宜林则林、宜草则草、宜灌则灌。对适宜治理的区域，要深入实施三北防护林、京津风沙源治理等重大生态工程，采取综合治理措施，着力增加林草植被，加快改善沙区生态状况和人居环境。</p> <p style=\"text-indent: 2em;\"> 二要发展特色沙产业，助力沙区精准脱贫。荒漠化防治，不仅是生态问题，也是经济问题，更是民生问题。沙区具有独特的光热土等资源优势，发展沙产业大有作为。防沙治沙要深入践行绿色发展理念，主动承担起生态惠民、绿色富民、促进精准脱贫的历史使命，在保护优先的前提下，正确处理防沙、治沙、用沙之间的关系。要继续扩大沙化土地封禁保护区范围，增加生态护林员规模，帮助更多贫困人口实现沙地就业和家门口脱贫，通过保护沙区生态获得实实在在的收益。要引导更多有劳动能力的贫困人口参与林业重点工程建设，大力推进造林种草劳务扶贫，有效增加贫困人口经济收入。要充分利用沙区光热资源充足、土地资源广阔的优势，积极发展以灌草饲料、中药材、经济林果等为重点的沙区特色种植业、精深加工业、生物质能源、沙漠旅游业等绿色产业，构建企业带大户、大户带小户、千家万户共同参与的发展格局，使沙害变沙利，黄沙变黄金，实现治沙与治穷双赢。</p> <p style=\"text-indent: 2em;\"> 三要坚持改革创新，促进沙区共治共享。改革创新是防治荒漠化的动力源泉。防沙治沙既要有守护生态的底线思维，也要有穷则思变的创新理念；既要依靠政府主导，也要撬动市场力量，才能形成防沙治沙的强大合力。我国防沙治沙之所以能取得巨大成绩，其中很重要的一条经验就是坚持改革创新。在新的形势下，防沙治沙要进一步加大改革创新力度，努力探索更多可复制可推广的成果和模式。要着力创新体制机制，探索建立沙化土地资产产权制度，推动建立荒漠生态效益补偿制度和防沙治沙奖励补助政策，深化投融资体制改革，大力推动政府和社会资本合作治沙，认真总结推广库布其防沙治沙模式，坚持政府主导、企业主体、群众参与、科技引领，努力实现防沙治沙人人参与、建设成果人人共享。</p> <p style=\"text-indent: 2em;\"> 四要积极宣传发动，发挥群众主体作用。防沙治沙最大的力量是人民群众的创造和奉献。在长期防沙治沙实践中，沙区广大干部群众与沙害进行不懈、顽强的抗争，涌现出了“治沙英雄”石光银、“时代楷模”苏和等先进人物和内蒙古赤峰、陕西榆林、甘肃民勤等治沙典型，形成了沙害不除、治沙不止的胡杨精神。这些都是我们继续推进防沙治沙的宝贵财富。要加大典型人物和事迹的宣传力度，用榜样的力量鼓舞人民群众，激发内生动力，调动沙区贫困群众以更大的积极性、主动性、创造性参与防沙治沙事业。要教育广大群众破除“等、靠、要”思想，改变简单给钱、给物、给牛羊的做法，多采用生产奖补、劳务补助等机制，加大防沙治沙技能培训，激励群众依靠辛勤劳动脱贫致富，用实际行动建设美好家园、创造美好生活。</p> <p style=\"text-indent: 2em;\"> （作者为国家林业和草原局局长）&nbsp;</p> <p style=\"text-indent: 2em;\"> <span id=\"paper_num\" style=\"text-indent: 2em; display: block;\">《 人民日报 》（ 2018年06月11日 14 版）</span></p>', 'http://politics.people.com.cn/n1/2018/0611/c1001-30049382.html', '2018-06-11', 'http://politics.people.com.cn/n1/2018/0611/c1001-3', '防治土地荒漠化 助力脱贫攻坚战', 'http://politics.people.com.cn/n1/2018/0611/c1001-30049382.html', '1528795506');
INSERT INTO `message_news` VALUES ('70', 'T1467284926140', 'News', 'd5fe7e6a729eae7531086ecae3c97c06', '<p style=\"text-indent: 2em;\"> 本报南昌6月10日电&nbsp;&nbsp;（记者魏本貌）传统民事纠纷，一场官司打下来，当事人往往要跑法院好几趟，费时又费力。日前，江西抚州市中级人民法院、乐安县人民法院、南丰县人民法院借助多元化解E平台，通过互联网在线有效化解纠纷。该平台依托法院和相关部门建立的多元化纠纷解决机制，利用移动互联网、大数据、视频云等技术，为多元化解纠纷提供全程智能化服务，当事人足不出门就可以参加在线调解。</p> <p style=\"text-indent: 2em;\"> 据介绍，在立案登记阶段，案件进行繁简分流，征得当事人同意后，案情相对简单的纠纷将进入该平台，由当地特邀调解员或相关部门组织调解人员进行诉前调解。多元化解E平台管理人员将调解日期、平台链接等信息，以手机短信的形式通知当事人。到调解时间，当事人只要点开网络链接，便能登录多元化解E平台参与调解。远程在线调解时，当事人可以通过视频、语音、文字留言等方式发表意见。</p> <p style=\"text-indent: 2em;\"> 多元化解E平台与法院诉讼材料收转发中心相关联，调解员可以申请在线阅卷，及时了解到案情基本情况。在线达成调解意向后，调解员在线制作调解协议书，并反馈给双方当事人确认。经当事人确认后，调解员向法院申请司法确认协议法律效力。如果纠纷超过调解期限或者调解不成功，则转由法院立案处理。在线诉前纠纷调解，法院不向当事人收取任何费用。此外，线上调解数据资料和录音录像信息，均全程记录并长期保存。</p> <p style=\"text-indent: 2em;\"> 目前江西省这三家法院依托多元化解E平台，诉前化解了153件民事纠纷、2件民事诉讼纠纷，平均办结时间不到10天，为当事人节省交通、食宿费用等4万余元。</p> <p style=\"text-indent: 2em;\"> <span id=\"paper_num\" style=\"text-indent: 2em; display: block;\">《 人民日报 》（ 2018年06月11日 13 版）</span></p>', 'http://politics.people.com.cn/n1/2018/0611/c1001-30049369.html', '2018-06-11', 'http://politics.people.com.cn/n1/2018/0611/c1001-3', '纠纷调解有了“高速通道”', 'http://politics.people.com.cn/n1/2018/0611/c1001-30049369.html', '1528795506');
INSERT INTO `message_news` VALUES ('71', 'T1467284926140', 'News', 'a94cb01ecfc70c3370fabb5285212543', '<p style=\"text-indent: 2em;\"> 本报北京6月10日电&nbsp;&nbsp;（记者潘跃）2018年全国社会工作者职业水平考试于6月9日至10日顺利举行。据统计，2018年全国社会工作者职业水平考试报考总人数为42.45万人，增长率达27.6%。其中，报考人数最多的三个省份为：浙江8.4万人、广东6.1万人、江苏4.2万人。上海、北京、山东、四川、吉林、湖北、重庆、湖南、辽宁、福建等地报考人数均突破万人。</p> <p style=\"text-indent: 2em;\"> 全国社会工作者职业水平考试自2008年起实施，目前全国已有32.6万余人通过考试取得了社会工作者职业资格证书。这些专业人才广泛分布于社区服务、社会救助、社会福利、公益慈善、防灾减灾、心理健康、矫治帮教、职工帮扶、青少年事务等多个与社会服务和社会治理密切相关的领域，围绕满足群众需求和解决具体民生问题开展了大量卓有成效的专业服务，在促进完善社会服务体系、创新基层社会治理、引领社会向上向善等方面发挥了重要作用。</p> <p style=\"text-indent: 2em;\"> 随着社会工作职业化、专业化步伐的加快，社会工作者的职业身份和专业作用进一步明确。2015年修订的《中华人民共和国职业分类大典》将社会工作者明确列入“专业技术人员”大类；2017年公布的《国家职业资格目录》将社会工作者职业资格明确为“水平评价类专业技术资格”；今年3月，人力资源社会保障部、民政部发布了《高级社会工作师评价办法》，标志着我国初、中、高级相衔接的社会工作者职业资格制度体系基本建成。</p> <p style=\"text-indent: 2em;\"> <span id=\"paper_num\" style=\"text-indent: 2em; display: block;\">《 人民日报 》（ 2018年06月11日 11 版）</span></p>', 'http://politics.people.com.cn/n1/2018/0611/c1001-30049357.html', '2018-06-11', 'http://politics.people.com.cn/n1/2018/0611/c1001-3', '三十二万多人取得社会工作者职业资格', 'http://politics.people.com.cn/n1/2018/0611/c1001-30049357.html', '1528795506');
INSERT INTO `message_news` VALUES ('72', 'T1467284926140', 'News', '5ba0525fb4d7b9c4bd9539f687c4f5de', '<table class=\"pci_c\" width=\"400\"> <tbody> <tr> <td align=\"middle\"> <img src=\"http://paper.people.com.cn/rmrb/res/2018-06/11/11/rmrb2018061111p10_b.jpg\" /></td> </tr> <tr> <td> <p style=\"text-indent: 2em;\"> 数据来源：《省级政府网上政务服务能力调查评估报告（2018）》、国家市场监督管理总局、《2018年全球营商环境报告》<br /> 　　统筹：本版编辑 吕中正 臧春蕾<br /> 　　制图：沈亦伶</p> </td> </tr> </tbody> </table> <p style=\"text-indent: 2em;\"> 核心阅读</p> <p style=\"text-indent: 2em;\"> 指尖一点，就能办事。电子政务与传统办事窗口相比，在速度上无疑拥有先天优势。如今，在提升政务效能的同时，电子政务在平台功能优化上也下足功夫。根据用户访问行为进行大数据分析，对涉及面广、群众办理量大、需求度高的重点事项进行服务升级，甚至以信息推送的方式实现“主动服务”，不断提高群众办事速度，改善群众办事体验。</p> <p style=\"text-indent: 2em;\"> “政府网站变得更好看、更好用了！”江苏苏州市民吴女士所说的，可不只是苏州市政府网站的界面变成了清爽又大气的蓝色调，更重要的是，在页面布局上更加简洁清晰，自己最关心的内容都在醒目的重点位置，使用起来更加方便快捷，也大大提升了网上办事的效率。</p> <p style=\"text-indent: 2em;\"> 网站提速</p> <p style=\"text-indent: 2em;\"> 重视动态管理，持续完善功能布局、栏目设置和操作体验</p> <p style=\"text-indent: 2em;\"> “政府门户网站上有关于生活、工作、学习等方方面面的便民服务，大到企业开办、小到交通出行、细到生育二孩，随时随地都能查询获得最新政策和办事流程。”吴女士告诉记者，这些实用信息不仅来源权威可靠，而且更新及时，给自己带来了不少便利。</p> <p style=\"text-indent: 2em;\"> 苏州市政府门户网站经过多次改版重建，在板块设计上更加科学合理、清晰明确。在栏目设置方面，通过对网站访问情况和用户访问行为进行大数据分析，掌握公众访问需求，持续完善功能布局、栏目设置和操作体验，在页面布局上将百姓最为需要和关注的内容放在重要位置。目前，该网站共有户口办理、身份证办理、保障性住房申请等10个办事导航，并进一步充实了社保民政、就业创业、医疗卫生等12项专题服务和十二大类150项查询。同时，为老年人、妇女、儿童、残疾人、低保户、投资者等6类特殊群体建立绿色通道，提供全方位信息服务，体现了网站建设的人性化。</p> <p style=\"text-indent: 2em;\"> 不同于以往政府网站的管理模式，如今，各地更加重视动态管理，不断提升门户网站使用效率。广东佛山市禅城区对业务办理量大、涉及面广、需求度高的重点事项的服务优化升级，集中展现；参照政府咨询热线中市民关注的热点问题、网上热搜词顺序、预约办事数量等，策划“新市民积分、人才公寓、居民医保、加装电梯”等多个热点服务专题，设计相关政策、办理指南、常见问题、在线咨询和7×24小时市民热线互动等栏目。每到入学招生季节，区政府门户网便开设公办小学和初中入学、公办幼儿园招生以及政策解读等专题，方便家长了解最新招生政策，并可在线完成报名手续。</p> <p style=\"text-indent: 2em;\"> 考虑到互联网受众特点，如今的政府网站建设更加注重互动环节，在多个栏目都设有留言、反馈功能。在倾听民声、接受监督方面，苏州市政府门户网站公众监督栏目为公众提供了更加友好的交流界面，年均来帖近万条，增设了公众评价满意度的功能并公开满意度评价结果。</p> <p style=\"text-indent: 2em;\"> “发展电子政务，就是要构建全流程、一体化的办事平台。”国家发改委国际合作中心主任黄勇表示，“解决群众反映强烈的办事难、办事慢、办事繁的问题，是电子政务建设的出发点与落脚点。”</p> <p style=\"text-indent: 2em;\"> 推送加速</p> <p style=\"text-indent: 2em;\"> 根据事项关联、群众需求等主动推送办事信息</p> <p style=\"text-indent: 2em;\"> 项目申请通过网络提交、数字化审图让企业不必送图晒图……“各部门通过网上联合审批，极大缩短了审批时间，为企业创造了更多空间。”谈及江苏政务服务网的使用体验，江苏常州星宇车灯股份有限公司财务总监李树军这样点赞。网上政府的建设，不仅缩短了群众办事时间，也让政府服务意识和服务方式发生巨大变化。</p> <p style=\"text-indent: 2em;\"> “一个高水平的政府门户网站，必须以用户为中心、以需求为导向、以服务为重点。”禅城区委书记刘东豪介绍，除区政府网站外，他们还通过微信、空中“一门式”、实体大厅“一门式”服务系统，多渠道推送信息，提升办事效率。</p> <p style=\"text-indent: 2em;\"> 2014年9月，禅城率先借助信息技术，在市民接触最频繁的行政审批领域推行“一门式”改革，即以串联、并联、跳转等方式，破除壁垒、共享信息、协同审批。每个服务窗口职能相同，对接所有行政审批服务，一口受理，一窗通办。</p> <p style=\"text-indent: 2em;\"> 如今，在“一门式”的基础上，禅城创新服务内容，研究自然人全生命周期服务，用图表形式告诉每个市民“人生大事”有多少、怎么办。2017年2月，禅城区政府网站归纳出服务事项136个，并主动向市民进行相关信息推送，防止市民对政策信息掌握不全、错过办理某项业务而没有享受应有福利。1年多来，仅“一门式”系统短信推送人生周期服务事项就达48499人次，市民回馈申办事项达15803人次，占“推送办”服务总量32.58%。</p> <p style=\"text-indent: 2em;\"> 例如，家属在为新生儿办理入户手续后，预留的手机号将会收到系统发送的短信，提醒接下来应该办理身份证、居民医保参保等手续了。大学毕业生到禅城区就业，来窗口办理报到事项后，“一门式”系统会主动以短信形式，把对应就业阶段内调档、社保转入、入户等事项推送到他手机上。</p> <p style=\"text-indent: 2em;\"> “推送办”根据事项关联、群众需求等主动推送办事信息，让政府从“被动服务”向“主动服务”的模式转变，不仅有利于打造服务性政府，也让群众避免了考虑不周导致的东奔西跑，大大节约了办事时间。</p> <p style=\"text-indent: 2em;\"> “数据和技术应落脚在增强服务能力上，要通过整合数据打造信息共享平台，创新协同监管、快速联动审批、监管风险预防等模式，为群众提供优质便捷服务，促进经济社会发展。”中国电子技术标准化研究院院长赵波说。</p> <p style=\"text-indent: 2em;\"> 服务增速</p> <p style=\"text-indent: 2em;\"> 云平台“秒级响应”，政府数据开放满足社会需求</p> <p style=\"text-indent: 2em;\"> 大数据的出现，改变了政务决策凭经验甚至拍脑袋的方式，如何利用好大数据，让政府服务提速？</p> <p style=\"text-indent: 2em;\"> 禅城打造大数据开放平台，设立“智能问答”自助查询平台，创建“智能型”政府服务模式。全区统一采集、开放和管理相关数据，建立市区联动数据开放机制。迄今，禅城整合了教育、社保、医疗、住房、就业、劳动保障、企业开办、证件办理、公用事业、经营活动、财务税务、行业准营、婚育收养等领域2700多条常见问题，并提供自助服务。在依法保障数据安全和保护隐私前提下，禅城探索开放审批服务、交通、医疗、食品安全和教育等700多万条数据，方便市民查询。</p> <p style=\"text-indent: 2em;\"> 苏州市政府门户网站也于去年底上线了政府数据开放平台，首批开放181个数据集，以社会对政府数据需求为导向，涉及医疗健康、社会保障、价格监督、信用体系、政务服务等领域。平台提供数据集的检索、浏览、下载等功能。截至目前，政府数据开放平台数据和接口总浏览次数超过2万次，数据总下载次数已逾6500次。</p> <p style=\"text-indent: 2em;\"> 禅城还打造了社会综合治理云平台，唤醒沉睡的3亿多条数据，打通区、镇（街道）、片区、村（居）、网格等信息“孤岛”，建立了921个“微”网格，实时监控，自动抓取，一旦有事可实现“秒级响应”。</p> <p style=\"text-indent: 2em;\"> “数据背后代表的是政府职能，打通信息孤岛，打破信息壁垒，不单单是一个技术上的概念，更是一个行政体制改革创新的范畴。”中央党校（国家行政学院）电子政务研究中心主任、国家电子政务专家委员会副主任王益民表示，“要提升电子政务的服务功能，就要以整合共享盘活数据资源，进一步强化数据质量、释放数据红利。”</p> <p style=\"text-indent: 2em;\"> <span id=\"paper_num\" style=\"text-indent: 2em; display: block;\">《 人民日报 》（ 2018年06月11日 11 版）</span></p>', 'http://politics.people.com.cn/n1/2018/0611/c1001-30049356.html', '2018-06-11', 'http://politics.people.com.cn/n1/2018/0611/c1001-3', '“协同审”“主动推”，办事不再慢（大数据观察·聚焦电子政务）', 'http://politics.people.com.cn/n1/2018/0611/c1001-30049356.html', '1528795506');
INSERT INTO `message_news` VALUES ('73', 'T1467284926140', 'News', 'f238e3b4912ade461eda7c1d1baa77ee', '<p style=\"text-indent: 2em;\"> 本报成都6月10日电&nbsp;&nbsp;（记者张文）10日，四川省启动地质灾害和防汛安全隐患排查，省内各地将按照“坡要到顶、沟要到头”的原则，确保对地质灾害和洪涝灾害易发区内凡是有人居住、有工程活动的地段和区域逐点逐段排查，科学评估风险。</p> <p style=\"text-indent: 2em;\"> 根据四川印发的《关于开展地质灾害和防汛安全隐患排查工作的紧急通知》，省内各地将从6月10日起，用一个月左右时间，集中开展地质灾害和防汛安全隐患排查。</p> <p style=\"text-indent: 2em;\"> 目前，四川已查明地质灾害隐患点4万余处，地质灾害威胁人口164万人。据了解，排查出的隐患点将逐一登记造册入库，逐一完善防灾预案，落实责任单位和部门，明确防灾责任人，落实专职监测员。对险情紧迫的，将第一时间组织受威胁人员疏散转移，确保安全。</p> <p style=\"text-indent: 2em;\"> <span id=\"paper_num\" style=\"text-indent: 2em; display: block;\">《 人民日报 》（ 2018年06月11日 10 版）</span></p>', 'http://politics.people.com.cn/n1/2018/0611/c1001-30049340.html', '2018-06-11', 'http://politics.people.com.cn/n1/2018/0611/c1001-3', '四川启动地质灾害和防汛安全隐患排查', 'http://politics.people.com.cn/n1/2018/0611/c1001-30049340.html', '1528795506');
INSERT INTO `message_news` VALUES ('74', 'T1467284926140', 'News', 'f51da6fb238a695253c35aa451f5d1e4', '<p> 　　新华社青岛6月10日电 国务委员兼外交部长王毅10日在青岛接受媒体采访，介绍上海合作组织青岛峰会成果。全文如下：</p> <p> 　　一、问：中方时隔六年再次主办上海合作组织峰会，同时，这也是上海合作组织扩员后召开的首次峰会，国际社会高度关注。您如何看待本次峰会的特点和意义？</p> <p> 　　答：同以往的上合会议相比，此次青岛峰会可谓规模最大、级别最高，成果最多，创造了一系列上合组织的纪录。这次是上合扩员后首次召开的峰会。上合组织现在已拥有8个成员国、4个观察员国、6个对话伙伴国，经济和人口总量分别占到全球的20%和40%以上，成为当今世界幅员最广、人口最多的综合性区域组织。来自12个国家的国家元首或政府首脑、10个国际组织或机构的负责人齐聚青岛，注册外宾超过2000人，采访峰会的中外记者超过3000人。在习近平主席主持下，“上合大家庭”的各国领导人共同回顾了上合组织17年来走过的不平凡历程，全面规划了组织未来的路径和方向，并且达成了一系列重要共识。成员国领导人签署、见证了23份合作文件，也是历届峰会成果最多的一次。可以说，在中方和各成员国共同努力下，青岛峰会的成果超出预期，是上合组织发展进程中一座新的里程碑，对上合组织的发展具有承前启后、继往开来的重要意义。其中最重要的是以下三个方面：</p> <p> 　　一是突出了“上海精神”。“上海精神”就是20个字：互信、互利、平等、协商、尊重多样文明、谋求共同发展。习近平主席在峰会上强调，上合组织之所以能够保持旺盛生命力，根本原因就在于始终践行“上海精神”。青岛宣言也重申，正是遵循“上海精神”，上合组织才经受住了国际风云变幻的考验，成为当今充满不确定性国际局势中一支极为重要的稳定力量。“上海精神”同中国传统的“和合”理念高度契合，超越了文明冲突、冷战思维、零和博弈等陈旧观念，已成为上合组织的核心价值，将继续为上合组织的发展壮大提供强有力保障。同时，“上海精神”实际上揭示了国与国交往应当遵循的基本准则，完全符合联合国宪章的宗旨和原则，必将对各国构建新型国际关系产生积极和深远影响。</p> <p> 　　二是形成了命运共同体意识。构建人类命运共同体，是习近平主席站立时代潮头，把握人类进步方向，着眼各国共同利益提出的一项重大倡议。上合组织成员国比邻而居，发展任务相似，命运紧密相连，理应为构建命运共同体发挥先导作用。此次各方在青岛宣言中确立了人类命运共同体这一共同理念，发出“同呼吸、共命运”的时代强音，这将有利于深化上合组织成员国之间的互利合作，为上合组织的发展注入不竭动力，也将促进本地区乃至世界的共同发展与繁荣。</p> <p> 　　三是提出了全球治理的上合主张。习近平主席指出，我们要坚持共商共建共享的全球治理观，不断改革完善全球治理体系，推动各国携手建设人类命运共同体。青岛宣言也强调，上合组织将以平等、共同、综合、合作、可持续安全为基础，推动国际秩序更加公正、平衡。这是成员国基于共同需要达成的政治共识，为完善全球治理贡献了上合智慧。全球治理是各国共同的事业，上合组织有责任、也有能力为此发挥建设性作用。我相信，随着上合组织不断发展壮大，上合组织必将成为全球治理进程中的重要和积极力量。</p> <p> 　　二、问：青岛峰会通过了一系列合作文件，涵盖政治、安全、经济、人文等多个领域。您如何评价本次峰会所取得的成果？</p> <p> 　　答：上合组织的初心就是共谋稳定、共促发展，这也是上合组织始终不变的主题。青岛峰会上，各方一致同意要为构建命运共同体加强各方面合作。概括起来，有五方面的重要成果：</p> <p> 　　一是组织发展有了新规划。“上合大家庭”的规模越来越大，成员越来越多，但团结互信是上合的优良传统。青岛宣言重申，各方将进一步发展睦邻友好关系，将共同边界建设成为永久和平友好的边界。青岛峰会通过了《上海合作组织成员国长期睦邻友好合作条约》未来5年实施纲要，提出了一系列重大合作举措，为今后5年上合组织发展规划了路线图。</p> <p> 　　二是安全合作推出新举措。青岛峰会批准了打击“三股势力”未来3年合作纲要等重要文件。这些文件聚焦影响地区安全的主要威胁，符合各方的共同需求，精准发力，切实可行，具有重要现实意义。青岛峰会还坚持前瞻性眼光，注重防范极端思想的传播，并为此制定了应对措施。峰会通过成员国元首致青年的共同寄语，呼吁广大青年树立正确价值观念，自觉抵御极端思想，为地区和平稳定发挥正能量。</p> <p> 　　三是经济合作注入新动力。青岛峰会通过多份务实合作文件，涉及贸易便利化、粮食安全、海关协作等众多领域，可以说分量重、覆盖广，有助于各国间的合作进一步走深走实。尤其是发表关于贸易便利化的联合声明，呼吁维护以世贸组织规则为核心的多边贸易体制，建设开放型世界经济，发出了坚持多边主义、反对保护主义的一致声音。越来越多的国家意识到，关起门来搞建设是行不通的，协同发展是大势所趋。我们高兴地看到，“一带一路”倡议获得越来越广泛的支持，各国发展战略和区域合作倡议对接不断取得新的进展。</p> <p> 　　四是人文合作取得新成果。上合组织高度重视环保问题。成员国领导人共同批准了环保合作构想，确立了致力于维护生态平衡、实现绿色和可持续发展的战略目标。此外，各方还商定继续在文化、教育、科技、卫生、旅游、青年、妇女、媒体、体育等领域开展富有成效的合作。</p> <p> 　　五是对外交往开辟新局面。上合组织在对外交往上始终秉持开放平等、包容透明的原则，我们的“朋友圈”不断扩大。本次峰会不仅有联合国等长期合作伙伴派负责人与会，还首次迎来欧亚经济联盟、国际货币基金组织、世界银行的高级代表。上合组织秘书处还同联合国教科文组织签署了合作文件。这些都反映出，国际社会高度认同上合组织的合作理念，越来越重视上合组织与日俱增的影响力。</p> <p> 　　三、问：习近平主席在本次青岛峰会上发表了重要讲话，我们注意到习主席的讲话中有很多新的提法。习主席的这些提法和论述将对上合组织的未来发展产生什么样的重要影响？</p> <p> 　　答：在本次青岛峰会上，习近平主席发表了数篇重要讲话，就上合组织成立17年来的发展历程和有益经验进行了全面总结，并为上合组织今后的发展作出了系统规划，明确了总体方向。</p> <p> 　　习主席强调，“上海精神”是上合组织的灵魂和共同财富，必须加以坚持和弘扬。我们要继续在“上海精神”指引下同舟共济，精诚合作，推动上合组织这一新型综合性组织成为区域合作的典范。</p> <p> 　　习主席提出发展观、安全观、合作观、文明观和全球治理观。这五大观念概括总结了建设新型国际关系的基本理念，为“上海精神”增添了新的时代内涵，赋予了上合组织新的历史使命。</p> <p> 　　习主席呼吁各方齐心协力构建上合组织命运共同体，推动建设新型国际关系，携手迈向持久和平、普遍安全、共同繁荣、开放包容、清洁美丽的世界。经各方协商一致，“确立人类命运共同体的共同理念”被写入青岛宣言，成为上合组织8国最重要的政治共识和努力目标。</p> <p> 　　习主席还建议上合组织本着共商共建共享原则，推进“一带一路”建设，促进各国发展战略对接，打造共同发展繁荣的新引擎，为上合组织开展互利合作开辟了更加广阔的空间和前景。</p> <p> 　　习近平主席提出的上述重要主张，完全契合上合组织的发展需要，完全契合世界各国的共同利益，完全契合世界发展进步的时代潮流，不仅将有力促进上合组织的自身发展，也将有利于推动本地区乃至世界的和平与繁荣。</p> <p> 　　四、问：青岛峰会之后，上合组织将踏上新征程。面临新形势新任务，上合组织应聚焦哪些问题？为推动上合组织发展，中方将采取哪些举措？</p> <p> 　　答：正如习近平主席在青岛峰会发表的讲话中所说，当前世界的发展既充满希望，也面临挑战。我们的未来无比光明，但前进的道路不会平坦。这就是上合组织今后所面临的总体形势和环境。我们认为，上合组织要保持健康稳定发展，应当不折不扣地落实好各国领导人在本次青岛峰会中所达成的各项共识。</p> <p> 　　首先要坚持组织的发展定位。上合成立之初就确定了“不针对其他国家和国际组织”的原则，形成了结伴而不结盟、对话而不对抗的合作模式。各成员国应当继续秉持“上海精神”，高举和平发展合作的旗帜，不搞封闭排外的小圈子，不打地缘博弈的小算盘，积极推动建设相互尊重、公平正义、合作共赢的新型国际关系，合力构建人类命运共同体。</p> <p> 　　其次要着力深化务实合作。成员国应抓住未来5至10年的发展期和机遇期，进一步夯实上合组织的合作基础，创新合作方式，丰富合作内涵，确保安全、经济、人文三大支柱领域合作齐头并进，使上合组织在维护地区和平稳定、谋求共同发展繁荣、促进文明交流互鉴方面释放出越来越强劲的合作潜力，为地区各国人民带来更多实实在在的安全与发展红利。</p> <p> 　　第三要推动完善全球治理。青岛宣言提出，各成员国支持完善全球治理体系，支持联合国为此发挥核心作用。上合正式成员有8个国家，再加上4个观察员国和6个对话伙伴国，就能形成18个国家的合力，如果再积极开展同联合国等国际和地区组织的交流合作，就能够为全球治理体系的充实完善、为推动国际秩序朝着更加公正合理的方向发展贡献上合的力量。</p> <p> 　　中国作为上合组织创始成员国，始终将上合组织作为外交优先方向之一。青岛峰会期间，习近平主席宣布了中方支持上合组织合作的一系列重要举措，包括未来3年为各方培训2000名执法人员，提供3000个人力资源开发培训名额，在上合组织银联体框架内设立300亿元人民币等值专项贷款，设立“中国－上海合作组织法律服务委员会”，在青岛建设中国－上合组织地方经贸合作示范区等等。这些举措结合中方优势，紧扣各方需求，有利于组织发展，受到普遍欢迎。</p> <p> 　　“欲知收获，但问耕耘”。上合组织是一个以先进理念凝聚起来的新型组织。今天，上合组织从中国再出发，从青岛再启航。中方将一如既往，同各成员国一道，全面落实峰会成果，使上合组织团结更紧密、合作更高效、行动更有力、前景更光明。</p>', 'http://politics.people.com.cn/n1/2018/0611/c1001-30049282.html', '2018-06-11', 'http://politics.people.com.cn/n1/2018/0611/c1001-3', '王毅就上海合作组织青岛峰会接受媒体采访', 'http://politics.people.com.cn/n1/2018/0611/c1001-30049282.html', '1528795506');
INSERT INTO `message_news` VALUES ('75', 'T1467284926140', 'News', '87954867c47758c97b6b6a66750a16b0', '<p style=\"text-indent: 2em;\"> 新华社青岛6月10日电</p> <p style=\"text-indent: 2em; text-align: center;\"> <strong>上海合作组织成员国元首理事会青岛宣言</strong></p> <p style=\"text-indent: 2em;\"> 上海合作组织（以下称“上合组织”或“本组织”）成员国领导人于2018年6月10日在中国青岛举行元首理事会会议，并发表宣言如下：</p> <p style=\"text-indent: 2em;\"> 当今世界正处在大发展大变革大调整时期，地缘政治版图日益多元化、多极化，国与国相互依存更加紧密。</p> <p style=\"text-indent: 2em;\"> 同时，世界面临的不稳定性不确定性因素不断增加，世界经济形势明显向好，但仍不稳定，经济全球化进程遭遇贸易保护主义、单边主义等更多挑战，部分地区冲突加剧、恐怖主义、非法贩运毒品和有组织犯罪、传染性疾病、气候变化等威胁急剧上升引发的风险持续增加。国际社会迫切需要制定共同立场，有效应对上述全球挑战。</p> <p style=\"text-indent: 2em;\"> 上合组织遵循“互信、互利、平等、协商、尊重多样文明、谋求共同发展”的“上海精神”，经受住国际风云变幻的严峻考验，不断加强政治、安全、经济、人文等领域合作，成为当代国际关系体系中极具影响力的参与者。</p> <p style=\"text-indent: 2em;\"> 上合组织在睦邻、友好、合作、相互尊重成员国文化文明多样性和社会价值观、开展信任对话和建设性伙伴关系的基础上树立了密切和富有成效的合作典范，致力于以平等、共同、综合、合作、可持续安全为基础构建更加公正、平衡的国际秩序，根据国际法准则和原则维护所有国家和每个国家的利益。</p> <p style=\"text-indent: 2em;\"> 成员国重申恪守《上合组织宪章》宗旨和任务，遵循《上合组织至2025年发展战略》，继续加强政策沟通、设施联通、贸易畅通、资金融通、民心相通，发展安全、能源、农业等领域合作，推动建设相互尊重、公平正义、合作共赢的新型国际关系，确立构建人类命运共同体的共同理念。</p> <p style=\"text-indent: 2em;\"> 一</p> <p style=\"text-indent: 2em;\"> 成员国将继续深化旨在促进上合组织地区和平稳定与发展繁荣的全方位合作。为此，成员国支持中亚国家为加强政治、经济、人文等领域合作所作努力，欢迎2018年3月15日在阿斯塔纳举行的首次中亚国家元首峰会成果。</p> <p style=\"text-indent: 2em;\"> 成员国指出，上合组织吸收印度共和国、巴基斯坦伊斯兰共和国加入后各领域合作迈上新台阶。成员国将在严格遵循上合组织国际条约和文件基础上，进一步挖掘本组织各项工作潜力。</p> <p style=\"text-indent: 2em;\"> 成员国愿在互利平等基础上，深化同上合组织观察员国和对话伙伴的合作，扩大上合组织同联合国及其专门机构及其他国际和地区组织的交流合作。</p> <p style=\"text-indent: 2em;\"> 二</p> <p style=\"text-indent: 2em;\"> 成员国主张恪守《联合国宪章》宗旨和原则，特别是关于平等、国家主权、不干涉内政、相互尊重领土完整、边界不可侵犯、不侵略他国、和平解决争端、不使用武力或以武力相威胁等原则，以及旨在维护和平与安全、发展国家间合作、巩固独立、保障自主决定国家命运和政治、经济社会和文化发展道路的权利等其他公认的国际法准则。</p> <p style=\"text-indent: 2em;\"> 成员国重申恪守2007年8月16日在比什凯克签署的《上合组织成员国长期睦邻友好合作条约》规定，在共同关心的领域进一步发展睦邻友好关系，包括将共同边界建设成为永久和平友好的边界。</p> <p style=\"text-indent: 2em;\"> 成员国重申坚定支持联合国作为综合性多边组织在维护国际和平与安全、推动全球发展、促进和保护人权方面所作的努力，支持巩固《联合国宪章》规定的联合国安理会作为维护国际和平与安全主要机构的关键作用。</p> <p style=\"text-indent: 2em;\"> 成员国注意到吉尔吉斯共和国和塔吉克斯坦共和国竞选联合国安理会非常任理事国席位的愿望。</p> <p style=\"text-indent: 2em;\"> 成员国将继续在裁军、军控、和平利用核能、利用政治外交手段解决防扩散机制面临的挑战等问题上开展协作。</p> <p style=\"text-indent: 2em;\"> 作为《不扩散核武器条约》缔约国的成员国，支持恪守条约规定，全面平衡推进该文件中规定的各项宗旨和原则，兼顾影响全球稳定的全部因素，加强国际核不扩散体系，推进核裁军进程，促进和平利用核能领域平等互利合作。</p> <p style=\"text-indent: 2em;\"> 成员国认为，《中亚无核武器区条约》议定书尽快对所有签署国生效将为维护地区安全、巩固国际核不扩散体系作出重要贡献。</p> <p style=\"text-indent: 2em;\"> 成员国重申，个别国家或国家集团单方面不受限制地发展反导系统，损害国际安全、破坏世界局势稳定。成员国认为，实现自身安全不能以损害他国安全为代价。</p> <p style=\"text-indent: 2em;\"> 成员国指出，应维护外空非武器化，支持采取切实措施防止外空军备竞赛，欢迎联大裁军与国际安全委员会通过《防止外空军备竞赛的进一步切实措施》决议，成立政府专家组，就防止外空军备竞赛特别是防止在外空部署武器的具有法律约束力的国际文书进行审议并提出建议。</p> <p style=\"text-indent: 2em;\"> 成员国支持旨在恪守《禁止化学武器公约》、提高禁化武组织权威及巩固《禁止生物武器公约》规范的努力和倡议。</p> <p style=\"text-indent: 2em;\"> 成员国强烈谴责一切形式和表现的恐怖主义，认为必须努力推动建立联合国发挥中心协调作用、以国际法为基础、摒弃政治化和双重标准的全球反恐统一战线。重申国家及其主管机构在本国境内打击恐怖主义、分裂主义和极端主义及在上合组织和其他国际机制框架内合作问题上的关键作用。</p> <p style=\"text-indent: 2em;\"> 成员国主张在《联合国宪章》等联合国文件基础上以协商一致方式通过联合国关于打击国际恐怖主义的全面公约。强调反恐应综合施策，促进和平解决国际和地区冲突，加大力度打击恐怖主义及其思想，消除恐怖主义和极端主义滋生因素，标本兼治。不能以任何理由为任何恐怖主义和极端主义行径开脱。成员国欢迎哈萨克斯坦关于在联合国框架内制定实现和平、无恐怖主义世界行为准则的倡议。</p> <p style=\"text-indent: 2em;\"> 成员国强调不允许以打击恐怖主义和极端主义为名干涉别国内政，不允许利用恐怖主义、极端主义和激进团伙谋取私利。</p> <p style=\"text-indent: 2em;\"> 成员国指出，必须有效执行联合国安理会相关决议，加强多边合作打击一切形式的恐怖主义融资和物质技术支持，包括查处与恐怖分子有经济联系的自然人和法人。</p> <p style=\"text-indent: 2em;\"> 鉴于当前西亚北非地区形势，成员国指出外国武装恐怖分子返回原籍国或在第三国寻找栖息地以在上合组织地区继续实施恐怖和极端活动的威胁上升。成员国将完善此类人群及其潜入潜出的情报交换机制，根据上合组织成员国国家法律实施更快捷的外国武装恐怖分子引渡机制，加强政治层面和情报部门间的国际合作。</p> <p style=\"text-indent: 2em;\"> 成员国欢迎乌兹别克斯坦共和国在2017年9月于纽约举行的联合国大会第72次会议上提出的关于通过《教育与宗教包容》联大特别决议的倡议。</p> <p style=\"text-indent: 2em;\"> 成员国肯定上合组织地区反恐怖机构在共同打击恐怖主义、分裂主义、极端主义“三股势力”和维护地区安全方面的特殊作用，将挖掘主管机关在上述领域的合作潜力。成员国指出，进一步完善上合组织地区反恐怖机构工作，包括研究建立监测和应对全球信息空间潜在的威胁系统问题，十分重要。</p> <p style=\"text-indent: 2em;\"> 成员国将重点关注落实《上合组织成员国打击恐怖主义、分裂主义和极端主义2019年至2021年合作纲要》，认为推动2017年6月9日在阿斯塔纳签署的《上合组织反极端主义公约》尽快生效十分重要。</p> <p style=\"text-indent: 2em;\"> 成员国高度评价2018年5月3日至4日在杜尚别举行的打击恐怖主义和极端主义国际会议成果，会议为各方开展上述领域合作提供了重要平台。</p> <p style=\"text-indent: 2em;\"> 成员国将继续定期举行包括“和平使命”军事反恐演习在内的联合反恐演习，进一步扩大防务和安全领域、大型活动安保和人员培训合作，提高各方武装力量和主管机关实战能力。</p> <p style=\"text-indent: 2em;\"> 成员国对大规模杀伤性武器落入恐怖组织之手的危险表示担忧，主张巩固打击该威胁的国际法律基础，支持在裁军谈判会议上制定打击生化恐怖主义行为国际公约的倡议。</p> <p style=\"text-indent: 2em;\"> 成员国将进一步加强协作，打击利用互联网传播和宣传恐怖主义思想，包括利用互联网公开洗白恐怖主义、为一系列恐怖组织招募成员、教唆和资助实施恐怖主义行径并指导实施方法。各方充分肯定2017年在中国举办的“厦门－2017”网络反恐演习成果。</p> <p style=\"text-indent: 2em;\"> 成员国指出，国际社会应合力打击旨在吸收青年参与恐怖主义、分裂主义、极端主义团伙活动的企图。鉴此，成员国通过了《上合组织成员国元首致青年共同寄语》，强调上合组织框架内将在青年教育、精神和道德培养方面开展综合性工作。</p> <p style=\"text-indent: 2em;\"> 成员国对毒品制贩和滥用增多、“以毒资恐”加剧引起的威胁上升表示担忧，强调必须在打击毒品及易制毒化学品非法贩运包括网上贩运问题上制定共同平衡立场。</p> <p style=\"text-indent: 2em;\"> 为此，成员国肯定本次峰会通过《2018－2023年上合组织成员国禁毒战略》及其落实行动计划和《上合组织预防麻醉药品和精神药品滥用构想》。</p> <p style=\"text-indent: 2em;\"> 成员国重申继续执行以国际法准则和原则、联合国相关公约和上合组织文件为基础的现行国际禁毒体系。在此背景下，成员国积极评价上合组织与联合国毒品与犯罪问题办公室2018年3月12日在维也纳联合举办的“上合组织与联合国打击毒品犯罪：新威胁与联合行动”活动。</p> <p style=\"text-indent: 2em;\"> 成员国强调将继续完善上合组织成员国禁毒部门领导人、高官、专家工作组合作机制，定期开展联合行动打击非法贩运麻醉药品、精神药品及其前体，采取有效措施防止合成毒品及新精神活性物质扩散。高度评价2018年5月17日在天津举行的成员国禁毒部门领导人会议成果。</p> <p style=\"text-indent: 2em;\"> 成员国将遵循2015年7月10日在乌法签署的《上合组织成员国边防合作协定》规定，继续通过实施有效边境管控，交换涉恐人员信息，对跨国恐怖组织犯罪开展联合调查，防范外国恐怖分子和恐怖团伙活动和潜入潜出。</p> <p style=\"text-indent: 2em;\"> 成员国呼吁国际社会努力构建和平、安全、开放、合作、有序的信息空间，强调联合国在制定各方可普遍接受的信息空间负责任国家行为国际规则、原则和规范方面发挥核心作用，认为有必要在联合国框架内根据公平地域分配原则建立工作机制，以制定信息空间负责任国家行为规范、规则或原则并以联合国大会决议形式确定下来。</p> <p style=\"text-indent: 2em;\"> 成员国认为所有国家应平等参与互联网的发展和治理。互联网核心资源的管理架构应当国际化、更具代表性和更加民主。</p> <p style=\"text-indent: 2em;\"> 成员国将继续在2009年6月16日在叶卡捷琳堡签署的《上合组织成员国保障国际信息安全政府间合作协定》基础上加强务实合作，共同应对信息空间威胁与挑战，包括在打击使用信息和通信技术从事有害活动特别是从事恐怖主义及犯罪活动方面深化国际合作，呼吁在联合国主导协调下，制定打击使用信息和通信技术实施犯罪行为的国际法律文书。</p> <p style=\"text-indent: 2em;\"> 成员国指出，一切形式的腐败对国家和地区安全构成威胁，导致国家治理效率低下，对投资吸引力产生消极影响，阻碍经济社会可持续发展。成员国主张进一步开展包括经验和信息交流在内的反腐败领域全面国际合作。</p> <p style=\"text-indent: 2em;\"> 成员国重申愿通过就司法鉴定经验与方法交流、提高司法专家职业水平形成共同立场，开展法律、司法及司法鉴定领域的务实合作。成员国主张通过签署上合组织相关公约在上合组织框架内制定的条约法律基础，就包括商事在内的民事、刑事等案件向个人及法人提供法律帮助，上合组织观察员国亦可在承担公约义务的前提下加入。</p> <p style=\"text-indent: 2em;\"> 成员国认为加强立法机关、政党间交流与合作，开展治国理政和发展经验交流十分重要。</p> <p style=\"text-indent: 2em;\"> 成员国高度评价上合组织派观察员团观察有关国家总统、议会选举和全民公决方面所进行的实践。</p> <p style=\"text-indent: 2em;\"> 三</p> <p style=\"text-indent: 2em;\"> 成员国支持在国际法基本准则和原则框架内采取政治外交手段解决世界各地区冲突，以实现普遍安全与稳定。</p> <p style=\"text-indent: 2em;\"> 成员国支持阿富汗伊斯兰共和国政府和人民为维护安全，促进经济发展，打击恐怖主义、极端主义、毒品犯罪所作努力，认为阿富汗的和平与稳定以及经济复兴将促进本地区安全和可持续发展。成员国强调，政治对话和“阿人主导、阿人所有”的包容性和解进程是解决阿富汗问题的唯一出路，呼吁在联合国发挥中心协调作用下加强合作，实现该国稳定与发展。</p> <p style=\"text-indent: 2em;\"> 成员国肯定2017年10月11日在莫斯科和2018年5月28日在北京举行的“上合组织－阿富汗联络组”会议成果，支持“莫斯科模式”等阿富汗调解对话与合作机制进一步积极开展工作。</p> <p style=\"text-indent: 2em;\"> 成员国认为2018年3月27日在塔什干举行的“和平进程、安全合作与地区互联互通”阿富汗问题高级别国际会议为阿富汗和平重建进程作出积极贡献，对其成果表示欢迎。</p> <p style=\"text-indent: 2em;\"> 成员国重申化解叙利亚危机的唯一出路是根据联合国安理会第2254号决议条款精神，在维护叙利亚主权、独立和领土完整的基础上，推进“叙人主导、叙人所有”的包容性政治进程。</p> <p style=\"text-indent: 2em;\"> 成员国支持联合国主导的日内瓦和谈，指出阿斯塔纳进程的有效性，呼吁冲突各方采取切实措施，落实建立冲突降级区备忘录，为政治调解叙利亚局势创造有利条件。鉴此，成员国欢迎2018年1月30日在索契举行的叙利亚全国对话大会成果，视其为推动叙利亚政治进程的重要贡献。</p> <p style=\"text-indent: 2em;\"> 成员国反对任何人、在任何地点、在任何情况下、出于任何目的使用化学武器，支持根据《禁止化学武器公约》规定对化武袭击展开全面、公正、客观调查，并基于确凿可信证据得出经得起检验的结论。</p> <p style=\"text-indent: 2em;\"> 成员国指出持续履行伊朗核问题全面协议十分重要，呼吁协议参与方恪守义务，确保全面协议得到完整、有效执行，促进全世界和地区和平与稳定。</p> <p style=\"text-indent: 2em;\"> 成员国主张只能通过对话协商以政治外交方式解决朝鲜半岛问题，支持包括中国和俄罗斯在内的国际社会为缓和朝鲜半岛局势、促进半岛无核化、维护东北亚地区持久和平提出的和平倡议。</p> <p style=\"text-indent: 2em;\"> 为此，成员国支持朝韩、朝美对话接触，呼吁所有相关方积极促进对话进程。</p> <p style=\"text-indent: 2em;\"> 成员国重申应在尽早全面执行2015年2月12日明斯克协议基础上政治解决乌克兰危机。</p> <p style=\"text-indent: 2em;\"> 四</p> <p style=\"text-indent: 2em;\"> 成员国支持完善全球经济治理体系，发展经贸和投资合作。成员国认为，世界贸易组织是讨论国际贸易议题、制定多边贸易规则的重要平台，支持共同构建开放型世界经济，不断巩固开放、包容、透明、非歧视、以规则为基础的多边贸易体制，维护世贸组织规则的权威性和有效性，反对国际贸易关系的碎片化和任何形式的贸易保护主义。</p> <p style=\"text-indent: 2em;\"> 成员国主张遵循《上合组织宪章》，推动贸易和投资便利化，以逐步实现商品、资本、服务和技术的自由流通。为此，通过了上合组织成员国元首关于贸易便利化的联合声明。</p> <p style=\"text-indent: 2em;\"> 成员国认为，在上合组织框架内加强电子商务合作、发展服务业和服务贸易、支持中小微企业发展对于发展经济、提高就业、增进人民福祉意义重大，支持进一步巩固本领域法律基础。</p> <p style=\"text-indent: 2em;\"> 成员国重申支持联合国在推动落实全球可持续发展议程方面的核心作用，呼吁发达国家根据此前承担的义务，为发展中国家提供资金、技术和能力建设支持。</p> <p style=\"text-indent: 2em;\"> 成员国指出，深化区域经济合作，特别是利用联合国亚太经社理事会在交通、能源、信息通信、贸易等重要方向的潜能，对促进成员国经济社会持续发展十分重要。成员国强调，应落实旨在发展区域经济合作的上合组织框架内有关文件。</p> <p style=\"text-indent: 2em;\"> 成员国欢迎2018年6月6日在北京举行的有成员国、观察员国和对话伙伴实业界和商界代表参与的上合组织工商论坛成果，支持将于2018年11月在上海举办的中国国际进口博览会。</p> <p style=\"text-indent: 2em;\"> 成员国认为，开展上合组织成员国经济智库间合作十分重要。</p> <p style=\"text-indent: 2em;\"> 成员国支持进一步深化金融领域务实合作，研究扩大本币在贸易和投资中使用的前景。成员国指出，加强金融监管交流，在宏观审慎管理和金融机构监管等方面进行合作，为金融机构和金融服务网络化布局提供便利的准入安排和公平监管环境具有现实意义。</p> <p style=\"text-indent: 2em;\"> 成员国将加强在上合组织银联体、亚洲基础设施投资银行、新开发银行、丝路基金、中国－欧亚经济合作基金等本地区现有多边银行和金融机构框架下的合作，为本组织合作项目提供融资保障。成员国将继续研究建立上合组织开发银行和发展基金（专门账户）问题的共同立场。</p> <p style=\"text-indent: 2em;\"> 成员国强调，通过新建和升级国际交通线路中的路段，发展包括高铁在内的公路和铁路交通，建设多式联运物流中心，引进先进创新技术，简化和协调货物通关时边境、海关和检疫程序，提升自动化建设水平，落实基础设施合作项目等方式，发展交通、扩大过境运输潜力和区域交通运输潜能等领域的多边合作十分重要。</p> <p style=\"text-indent: 2em;\"> 成员国指出有必要切实落实2014年9月12日在杜尚别签署的《上合组织成员国政府间国际道路运输便利化协定》，继续就制定《上合组织成员国公路发展规划》开展工作。</p> <p style=\"text-indent: 2em;\"> 成员国支持乌兹别克斯坦关于举行首次上合组织成员国铁路部门负责人会晤的倡议，以提升交通通达性和互联互通。</p> <p style=\"text-indent: 2em;\"> 成员国欢迎上合组织与联合国亚太经社理事会2017年11月23日在曼谷共同举办的“向地区交通互联互通前行”高级别活动。</p> <p style=\"text-indent: 2em;\"> 成员国欢迎建立上合组织地方领导人论坛，开展地区间合作，注意到关于2018年在俄罗斯联邦车里雅宾斯克市举办论坛首次会议的建议。</p> <p style=\"text-indent: 2em;\"> 成员国指出，在相互尊重、平等互利原则基础上协调旨在上合组织地区推进经济可持续发展方面合作，扩大投资规模、拓展交通联系、提升能源合作、发展农业、促进创新和保障就业的国际、地区、国家发展项目和发展战略拥有广阔前景。</p> <p style=\"text-indent: 2em;\"> 哈萨克斯坦共和国、吉尔吉斯共和国、巴基斯坦伊斯兰共和国、俄罗斯联邦、塔吉克斯坦共和国和乌兹别克斯坦共和国重申支持中华人民共和国提出的“一带一路”倡议，肯定各方为共同实施“一带一路”倡议，包括为促进“一带一路”和欧亚经济联盟对接所做的工作。各方支持利用地区国家、国际组织和多边合作机制的潜力，在上合组织地区构建广泛、开放、互利和平等的伙伴关系。</p> <p style=\"text-indent: 2em;\"> 成员国强调，发展并深化互利合作，在包括数字经济在内的信息和通信技术领域开展知识、信息及先进实践方法的交流具有重要意义，有利于成员国经济社会发展。</p> <p style=\"text-indent: 2em;\"> 成员国基于维护上合组织地区生态平衡、恢复生物多样性的重要性，为居民生活和可持续发展创造良好条件，造福子孙后代，通过了《上合组织成员国环保合作构想》。</p> <p style=\"text-indent: 2em;\"> 成员国高度评价塔吉克斯坦共和国倡议的、联合国大会2016年12月21日通过的2018－2028年“水促进可持续发展”国际行动十年的第71/222号决议，并欢迎将于2018年6月20日至22日在杜尚别举行该主题的高级别国际会议。成员国支持为推动第73届联合国大会通过关于旨在实现水资源可持续发展目标与任务中期综述的决议草案所作的努力。</p> <p style=\"text-indent: 2em;\"> 成员国将在跨境动物疫病防控、农产品准入政策和质量安全、卫生检疫等领域开展交流与合作，以保障粮食安全。成员国指出有必要在这方面采取包括制定相关合作纲要在内的具体措施。</p> <p style=\"text-indent: 2em;\"> 成员国支持加强创新领域合作，指出成员国就创新领域政策，包括在建立创新生态环境、技术平台、创新产业群、高科技公司及落实创新合作项目等方面协调立场十分重要。成员国指出，进一步深化在海关、农业、电信、中小微企业等领域的合作十分重要。</p> <p style=\"text-indent: 2em;\"> 成员国将致力于进一步发挥上合组织实业家委员会和银行联合体潜力，推动落实金融、高科技、基础设施互联互通、能源、投资等领域合作项目。鉴此，成员国欢迎上合组织银联体在吸收新成员方面所作努力。</p> <p style=\"text-indent: 2em;\"> 五</p> <p style=\"text-indent: 2em;\"> 成员国将继续在文化、教育、科技、卫生、旅游、民族手工艺、环保、青年交流、媒体、体育等领域开展富有成效的多边和双边合作，促进文化互鉴、民心相通。</p> <p style=\"text-indent: 2em;\"> 成员国将在2007年8月16日在比什凯克签署的《上合组织成员国政府间文化合作协定》基础上继续促进发展上合组织框架内的文化联系，巩固人民之间的相互理解，尊重成员国的文化传统和习俗，保护并鼓励文化的多样性，举办国际艺术节和竞赛，深化在音乐、戏剧、造型艺术、电影、档案、博物馆及图书馆领域的合作，开展包括古丝绸之路沿线在内的本地区文化与自然遗产研究与维护领域的合作。</p> <p style=\"text-indent: 2em;\"> 鉴此，成员国欢迎2018年9月在吉尔吉斯共和国举办第三届世界游牧民族运动会。</p> <p style=\"text-indent: 2em;\"> 成员国指出，在上合组织秘书处举办的“上合组织－我们共同的家园”框架下的活动，以及有青年参与的开放日活动、研讨会和圆桌会议具有重要意义。</p> <p style=\"text-indent: 2em;\"> 成员国欢迎上合组织秘书处与联合国教科文组织签署合作谅解备忘录，认为该文件反映了两组织在人文领域发展建设性合作的愿望，包括为宣传文化及其成就以及上合组织成员国历史遗产所开展的工作。</p> <p style=\"text-indent: 2em;\"> 成员国欢迎2017年7月2日至4日在新西伯利亚举办的上合组织与金砖国家妇女论坛和2018年5月15日至17日在北京举办的上合组织妇女论坛，强调开展该领域合作前景广阔。</p> <p style=\"text-indent: 2em;\"> 成员国将鼓励发展媒体领域合作，支持举办上合组织媒体峰会。</p> <p style=\"text-indent: 2em;\"> 成员国指出，体育作为促进民间对话的有效因素具有重要意义，应脱离政治。成员国坚信，即将于2018年在俄罗斯举办的国际足联世界杯足球赛、2018年5月18日至19日在重庆举办的上合组织武术散打比赛、定期举办的上合组织马拉松赛和一年一度的国际瑜珈日将促进友谊、和平、包容与和谐。</p> <p style=\"text-indent: 2em;\"> 成员国将继续积极落实《上合组织成员国政府间教育合作协定》，扩大教学科研人员交流规模，联合培养高素质人才。成员国将本着相互尊重原则，积极推动在师生交流、联合科研、学术访问、语言教学、职业教育、青少年交流等领域开展务实合作。</p> <p style=\"text-indent: 2em;\"> 成员国指出应积极开展卫生应急、居民卫生防疫保障、打击假冒医疗产品、防止传染病扩散、慢性病防控、传统医药、医学教育与科研、落实促进国际发展的合作纲要、医疗服务、医务人员交流、保障食品安全及质量等领域合作，共同维护居民健康，促进卫生发展和创新合作。</p> <p style=\"text-indent: 2em;\"> ***</p> <p style=\"text-indent: 2em;\"> 成员国高度评价2017－2018年中方主席国工作，其成果巩固了上合组织成员国人民之间的相互理解与信任、富有成果的建设性合作和睦邻友好关系。</p> <p style=\"text-indent: 2em;\"> 成员国将继续开展建设性对话，扩大并深化伙伴合作，旨在有效解决地区和全球问题，促进政治和经济稳定，构建公正、平等的国际秩序。</p> <p style=\"text-align: right;\"> 印度共和国总理 莫迪</p> <p style=\"text-align: right;\"> 哈萨克斯坦共和国总统 纳扎尔巴耶夫</p> <p style=\"text-align: right;\"> 中华人民共和国主席 习近平</p> <p style=\"text-align: right;\"> 吉尔吉斯共和国总统 热恩别科夫</p> <p style=\"text-align: right;\"> 巴基斯坦伊斯兰共和国总统 侯赛因</p> <p style=\"text-align: right;\"> 俄罗斯联邦总统 普京</p> <p style=\"text-align: right;\"> 塔吉克斯坦共和国总统 拉赫蒙</p> <p style=\"text-align: right;\"> 乌兹别克斯坦共和国总统 米尔济约耶夫</p> <p style=\"text-align: right;\"> 2018年6月10日于青岛</p>', 'http://politics.people.com.cn/n1/2018/0611/c1001-30049333.html', '2018-06-11', 'http://politics.people.com.cn/n1/2018/0611/c1001-3', '上海合作组织成员国元首理事会青岛宣言', 'http://politics.people.com.cn/n1/2018/0611/c1001-30049333.html', '1528795506');
INSERT INTO `message_news` VALUES ('76', 'T1467284926140', 'News', '3fecb6a7be192fe7bee357c32aaa227b', '<p> 　　新华社记者</p> <p> 　　风帆高扬，世界瞩目东方。一个正值芳华的区域性组织，今年重回诞生的国度，凝聚新共识，踏上新征程。</p> <p> 　　6月9日至10日，上海合作组织迎来其扩员后的首次峰会——上海合作组织成员国元首理事会第十八次会议在中国青岛成功召开。</p> <p> 　　8个成员国、4个观察员国领导人，以及联合国等国际组织和机构负责人共商合作大计，成员国领导人发表体现一致立场的青岛宣言，举行10多场双多边会晤，签署、见证了23份合作文件……呈现出一幅让世界赞叹的“青岛上合图”，镌刻下鲜明的“中国印记”。</p> <p> 　　“我们要进一步弘扬‘上海精神’，破解时代难题，化解风险挑战。”“携手迈向持久和平、普遍安全、共同繁荣、开放包容、清洁美丽的世界。”习近平主席首次以中国国家元首身份主持上合峰会时发表的重要讲话隽永深长，引发强烈反响。</p> <p> 　　和衷共济，四海一家。</p> <p> 　　上合组织这艘巨轮汇聚起新动力，高扬起“上海精神”的风帆，从青岛再起航，乘风破浪胜利驶向构建人类命运共同体充满希望的明天……</p> <p> 　　<strong>青岛“合”声，大海作证——描绘上合组织进入历史新阶段的蓝图，为世界贡献“上合力量”</strong></p> <p> 　　面朝浩瀚黄海的青岛国际会议中心，形如腾飞的海鸥，见证上合组织发展进程又一历史性时刻。</p> <p> 　　10日上午，10时55分许，一楼迎宾厅。</p> <p> 　　习近平主席面带微笑，站在前排中央，同其他上合组织成员国、观察员国领导人和国际组织负责人等与会各方合影。他们身后的蓝色海洋背景板上以橄榄枝等构成的圆形会徽传递出上合组织这个世界上幅员最广、人口最多的综合性区域组织的理念。</p> <p> 　　这是全球瞩目的上合组织大家庭“全家福”，是上合组织力量壮大的历史性定格。</p> <p> 　　承前启后、继往开来，青岛峰会成为上合组织发展进程中的重要里程碑——</p> <p> 　　“欢迎印度总理莫迪、巴基斯坦总统侯赛因首次以成员国领导人身份出席峰会。”泰山厅内，习近平主席在开幕辞中欢迎新成员国领导人，指出这次峰会是上海合作组织实现扩员以来举办的首次峰会，具有承前启后的重要意义。</p> <p> 　　再过5天，上合组织将迎来17岁生日。</p> <p> 　　从黄浦江畔的上海扬帆起航，到黄海之滨的青岛再度聚首，上海合作组织走过不平凡的发展历程，各成员国秉持“互信、互利、平等、协商、尊重多样文明、谋求共同发展”的“上海精神”，不仅在安全、经济、人文等合作领域取得丰硕成果，在机制建设方面也迈出历史性步伐。</p> <p> 　　17年风雨兼程，17年携手共进。</p> <p> 　　如今，随着印度和巴基斯坦的加入，上海合作组织成员国的经济和人口总量分别约占全球的20%和40%，已是世界上幅员最广、人口最多的综合性区域合作组织，开创了区域合作新模式，为地区和平与发展作出了新贡献。</p> <p> 　　“上合组织成员国倡导的‘上海精神’是该组织的根基。”在本世纪初参与上合组织缔造的哈萨克斯坦总统纳扎尔巴耶夫，如此评价上合组织历程，“这一精神不仅是处理国与国关系的经验总结，而且对推动全球治理具有重要的现实意义。”</p> <p> 　　大道之行、天下为公，青岛峰会赋予“上海精神”新的时代内涵——</p> <p> 　　9日晚，青岛浮山湾畔，名为《有朋自远方来》的灯光焰火表演让人叹为观止，生动展现中华文明、“上海精神”、命运共同体等主题，意蕴丰富、给人启迪。</p> <p> 　　青岛所在的山东省是孔孟之乡、儒家文化发祥地。“儒家思想是中华文明的重要组成部分。”“这种‘和合’理念同‘上海精神’有很多相通之处。”习近平主席在上合组织青岛峰会欢迎宴会上发表祝酒辞，以东道主的传统智慧致敬历史、谋划未来。</p> <p> 　　志合者，山海为证。</p> <p> 　　习近平主席在10日会议上发表重要讲话，提出促进上合组织发展的五大务实建议，系统阐述要倡导和践行的“五大观念”——发展观、安全观、合作观、文明观、全球治理观，为“上海精神”注入新内涵。</p> <p> 　　凝聚新共识、规划新蓝图，青岛峰会成为上合组织筑安全、谋发展的新起点——</p> <p> 　　经过数小时的会议，上合组织成员国领导人10日下午发表《上海合作组织成员国元首理事会青岛宣言》。这份八千多字的文件，全面总结17年来上合组织发展经验，大力弘扬“上海精神”，提升组织的凝聚力、行动力、影响力。</p> <p> 　　从《上海合作组织成员国长期睦邻友好合作条约》未来5年实施纲要，到未来3年打击“三股势力”合作纲要，从提倡创新、协调、绿色、开放、共享的发展观，到推动各方加强发展战略对接、推进“一带一路”建设……青岛峰会期间，成员国领导人谋划区域合作新篇，把各方政治共识转化为更多务实成果，构建上合组织命运共同体迈出坚实步伐。</p> <p> 　　上合组织秘书长阿利莫夫认为，中国担任上合组织主席国的一年来，成功举办政治、安全、经济、人文、对外交往、机制建设等领域200余项活动，相信青岛宣言将有助于上合组织成员国在加强相互信任、推进互利合作方面打开崭新局面。</p> <p> 　　“这次峰会，是多边主义的再出发。”与会的联合国常务副秘书长阿明娜说，跨国犯罪、气候变化、恐怖主义等问题，不是一个国家可以解决的，需要形成合力，“《上合组织至2025年发展战略》正是这样一个形成合力的愿景。”</p> <p> 　　<strong>同舟共济，务实合作——筑牢和平安全的共同基础，打造共同繁荣的强劲引擎</strong></p> <p> 　　初夏的胶州湾畔，青岛港码头沉浸在一片忙碌有序的景象中。在占地1800亩的中铁联集青岛中心，一排排巨型龙门吊繁忙作业，数以万计的集装箱等待着被装上国际班列，一路驶向亚欧大陆深处……</p> <p> 　　海陆相接，互联互通。</p> <p> 　　着眼长远发展的青岛宣言进一步弘扬“上海精神”，构建人类命运共同体的愿景在黄海之滨擘画崭新篇章。</p> <p> 　　筑牢基础、普遍安全，凝聚团结互信的强大力量——</p> <p> 　　超越文明冲突、冷战思维、零和博弈等陈旧观念，政治互信是上合组织各领域合作的前提所在。</p> <p> 　　“我们要践行共同、综合、合作、可持续的安全观，摒弃冷战思维、集团对抗，反对以牺牲别国安全换取自身绝对安全的做法，实现普遍安全。”习近平主席在10日讲话中对上合组织加强安全合作提出新期望。</p> <p> 　　山水相依、守望相助。</p> <p> 　　安全是上海合作组织可持续发展的基石。成立伊始，上合组织成员国始终把维护地区安全稳定作为优先方向，努力打造地区安全的“稳定之锚”。</p> <p> 　　会议期间，成员国领导人深入分析国际及地区安全形势，明确应对风险挑战的努力方向，提出一系列安全合作新举措：</p> <p> 　　——批准《&lt;上合组织成员国长期睦邻友好合作条约&gt;实施纲要（2018-2022年）》，明确未来五年深化各领域合作的重要举措；</p> <p> 　　——通过《上合组织成员国打击恐怖主义、分裂主义和极端主义2019年至2021年合作纲要》，进一步推动安全领域务实合作，上合组织地区反恐怖机构将发挥更大作用；</p> <p> 　　——将继续推动打击非法贩运毒品领域的合作；</p> <p> 　　……</p> <p> 　　外交学院副院长王帆表示，一系列共筑安全的新举措，将充分发挥安秘会机制的作用，妥善应对各类安全威胁和挑战，共同营造良好的地区安全环境，推动上合组织“安全合作之轮”越转越顺。</p> <p> 　　命运与共、合作共赢，打造共同发展繁荣的强劲引擎——</p> <p> 　　互惠互利，共同繁荣。</p> <p> 　　6月8日，一辆满载青岛啤酒的中亚班列从胶州发车前往阿拉木图。青岛啤酒在上合组织国家备受青睐：2017年，青啤在俄罗斯销售量增长78%，在哈萨克斯坦销量同比增长102%……</p> <p> 　　青啤销量的增长正是上海合作组织拓展务实合作的一个缩影。</p> <p> 　　今年前4个月，青岛对7个上合组织成员国进出口额达93.1亿元人民币；截至今年3月底，中国对上合组织成员国各类投资存量约为840亿美元，在上合组织成员国工程承包累计营业额达到1569亿美元。</p> <p> 　　“一带一路”建设使上合组织经济合作进入“快车道”，早期收获硕果累累，展示这个世界上潜力巨大的综合性区域组织的勃勃生机。</p> <p> 　　尽管单边主义、贸易保护主义、逆全球化思潮不乏抬头表现，但各国日益利益交融、命运与共，合作共赢仍将是全球发展大势所趋——这是青岛峰会与会各国和国际机构的共同心声。</p> <p> 　　上合组织不是“清谈馆”，而是“行动队”。</p> <p> 　　发表成员国领导人关于《上海合作组织成员国元首关于贸易便利化的联合声明》、有关部门签署了《上海合作组织成员国经贸部门间促进中小微企业合作的谅解备忘录》等文件……峰会上，上合组织成员国用一系列具体行动扩大务实合作、实现共同发展。</p> <p> 　　“我们要秉持开放、融通、互利、共赢的合作观，拒绝自私自利、短视封闭的狭隘政策，维护世界贸易组织规则，支持多边贸易体制，构建开放型世界经济。”习近平主席在青岛峰会上的讲话掷地有声，宣示了继续扩大开放、加强互利共赢的决心和魄力。</p> <p> 　　中国—上海合作组织地方经贸合作示范区将落户青岛；“中国—上海合作组织法律服务委员会”将设立，为经贸合作提供法律支持……峰会上，中国正在将共识转化为实实在在的行动。</p> <p> 　　平等互鉴、对话包容，拉紧人文交流合作的共同纽带——</p> <p> 　　青岛西海岸新区，架设在朝阳山半山腰的“东方影都”四个大字，格外醒目。</p> <p> 　　3天后，首届上合组织国家电影节将在这里开幕。届时，将有来自上合组织8个成员国和4个观察员国的约60部影片参与活动。</p> <p> 　　文化互鉴、民心相通。</p> <p> 　　上合组织成员国覆盖多种文明。尽管文明冲突、文明优越等论调不时沉渣泛起，但文明多样性是人类进步的不竭动力，不同文明交流互鉴是各国人民共同愿望。</p> <p> 　　一年来，在中国担任上合组织轮值主席国期间，首届上合组织妇女论坛、首届上合组织文化艺术高峰论坛、首届上合组织医院合作论坛……一个个“首创”成功实践，推动成员国间的互动与交往不断加深。</p> <p> 　　在青岛峰会上，各方表示愿在相互尊重文化多样性和社会价值观的基础上，继续在文化、教育、科技、环保、卫生、旅游、青年、媒体、体育等领域开展富有成效的多边和双边合作；成员国通过了《上合组织成员国环保合作构想》、签署了《2019-2020年落实&lt;上合组织成员国旅游合作发展纲要&gt;联合行动计划》……这些务实举措将汇聚起促进民心相通的人文力量，夯实上合组织未来发展的民意基础。</p> <p> 　　来自俄罗斯的中国石油大学（华东）文学院外教伊娜，如今已在青岛生活了三年多，她和中国同事合作完成了一本《青岛旅游俄语》。</p> <p> 　　“这次峰会的召开让更多的人了解了青岛，我希望让更多的俄罗斯朋友来青岛、到中国多走一走，看一看。”她说。</p> <p> 　　<strong>登高望远，扬帆起航——贡献中国理念，展现责任担当，着力推动构建人类命运共同体</strong></p> <p> 　　青岛国际会议中心外，由中、俄双语“互信互利、合作共赢”大字托举起上合组织会徽的雕塑分外醒目，辉耀“上海精神”的时代光芒。</p> <p> 　　１７年不忘初心，不懈耕耘，上合组织铸就相互尊重、公平正义、合作共赢的新型国际关系典范，锻造上合组织命运共同体。</p> <p> 　　这是引人瞩目的时刻——</p> <p> 　　１０日１３时４５分许，８个成员国领导人走上会议台。他们签署、见证了23份合作文件，这是历届峰会成果最多的一次。</p> <p> 　　“确立构建人类命运共同体的共同理念”被写入青岛宣言，体现了上合组织成员国对这一理念的认同，成为上合组织8国最重要的政治共识和努力目标。</p> <p> 　　放眼全球，当今世界正处在大发展大变革大调整时期，世界多极化、经济全球化深入发展，国与国相互依存更加紧密。构建人类命运共同体，这是增进福祉的全球共识。</p> <p> 　　立时代之潮头，发思想之先声，习近平主席为“上合组织命运共同体”行稳致远指明方向。</p> <p> 　　“我们要继续在‘上海精神’指引下，同舟共济，精诚合作，齐心协力构建上海合作组织命运共同体，推动建设新型国际关系，携手迈向持久和平、普遍安全、共同繁荣、开放包容、清洁美丽的世界。”１０日上午，习近平主席发表题为《弘扬“上海精神”　构建命运共同体》的重要讲话。</p> <p> 　　为推动构建“上合组织命运共同体”，习近平主席宣布一系列务实举措：</p> <p> 　　——中方将在上海合作组织银行联合体框架内设立３００亿元人民币等值专项贷款；</p> <p> 　　——未来３年，中方愿利用中国—上海合作组织国际司法交流合作培训基地等平台，为各方培训２０００名执法人员，强化执法能力建设；</p> <p> 　　——未来３年，中方将为各成员国提供３０００个人力资源开发培训名额；</p> <p> 　　——中方愿利用风云二号气象卫星为各方提供气象服务；</p> <p> 　　……</p> <p> 　　“中国担当”促成一个个“上合方案”，破解时代难题，是构建人类命运共同体理念的清晰实践，体现了中国领导人面向未来的长远眼光、博大胸襟和历史担当。</p> <p> 　　变革的时代，呼唤伟大的思想；伟大的思想，启迪人类的未来。</p> <p> 　　一年前，联合国日内瓦总部。面对“世界怎么了、我们怎么办”的时代之问，到访的习近平主席郑重作答：“让和平的薪火代代相传，让发展的动力源源不断，让文明的光芒熠熠生辉，是各国人民的期待，也是我们这一代政治家应有的担当。中国方案是：构建人类命运共同体，实现共赢共享。”</p> <p> 　　从首提构建人类命运共同体倡议到阐述“吹灭别人的灯，会烧掉自己的胡子”等理念，从搭建“一带一路”等合作平台到构建上合组织命运共同体，习近平主席对构建人类命运共同体的擘画与推动，在世界各地赢得越来越多的认同。</p> <p> 　　从ＡＰＥＣ北京会议到Ｇ２０杭州峰会，从“一带一路”国际合作高峰论坛到金砖国家领导人厦门会晤，从博鳌亚洲论坛再到上合组织青岛峰会，一次次中国主场外交，都是推动建设新型国际关系、构建人类命运共同体理念的生动实践，在世界范围内提升中国的影响力、感召力。</p> <p> 　　一年前，在上合组织阿斯塔纳峰会上，习近平主席提出“构建平等相待、守望相助、休戚与共、安危共担的命运共同体”。</p> <p> 　　一年后，在青岛峰会上，习近平主席提出五大建议：从“凝聚团结互信的强大力量”到“筑牢和平安全的共同基础”，从“打造共同发展繁荣的强劲引擎”到“拉紧人文交流合作的共同纽带”再到“共同拓展国际合作的伙伴网络”——为推动构建上合组织命运共同体标注出清晰“路线图”。</p> <p> 　　开放包容，方能开创光明未来；</p> <p> 　　命运共同，方能汇聚前行动力。</p> <p> 　　在上合青岛峰会新闻中心，展台上摆放一批介绍中国和上合组织发展的书籍、音像资料。其中，中、英、俄文版的《习近平谈治国理政》第二卷备受各国记者欢迎。</p> <p> 　　“习近平主席倡议的人类命运共同体理念和‘一带一路’建设，表明中国领导人胸怀天下，把全世界看成一个大家庭，愿与其他国家分享中国发展经验。”首次来华报道的巴基斯坦国家电视台记者祖白鲁丁说。</p> <p> 　　从青岛出发，上合组织将再次扬帆起航，携手推动构建人类命运共同体。</p> <p> 　　以上合组织青岛峰会为里程碑，视构建人类命运共同体为己任的中国特色大国外交继续向前铺展——</p> <p> 　　９月，以“一带一路”建设为主旋律的中非合作论坛北京峰会，将为中非全面战略伙伴关系注入新动力。</p> <p> 　　１１月，高举“市场开放”旗帜的首届中国国际进口博览会，将欢迎世界各国分享中国发展新机遇。</p> <p> 　　“孔子登东山而小鲁，登泰山而小天下。”</p> <p> 　　登高望远，把握世界大势和时代潮流，中国将继续与各国携手构建人类命运共同体，为促进世界和平、稳定、繁荣作出新的更大贡献。（记者余孝忠、张旭东、熊争艳、侯丽军、荣启涵、罗博、席敏）</p>', 'http://politics.people.com.cn/n1/2018/0611/c1001-30049294.html', '2018-06-11', 'http://politics.people.com.cn/n1/2018/0611/c1001-3', '构建命运共同体 书写上合新篇章——写在上海合作组织青岛峰会闭幕之际', 'http://politics.people.com.cn/n1/2018/0611/c1001-30049294.html', '1528795506');
INSERT INTO `message_news` VALUES ('77', 'T1467284926140', 'News', 'a9c3deb96dcacf86380716a1cc767f11', '<p align=\"center\"> <img alt=\"\" src=\"http://www.people.com.cn/mediafile/pic/GQ/20180611/66/9240623375962826514.jpg\" /></p> <p> 　　6月10日，国家主席习近平在青岛同伊朗总统鲁哈尼举行会谈。新华社记者 丁林 摄</p> <p> 　　新华社青岛6月10日电（记者侯丽军、徐冰）国家主席习近平10日在青岛同伊朗总统鲁哈尼举行会谈。</p> <p> 　　习近平欢迎鲁哈尼访华并出席上海合作组织青岛峰会。习近平指出，我2016年对伊朗进行国事访问期间，中伊两国宣布建立全面战略伙伴关系。两年多来，双方密切合作，全面落实我和总统先生达成的共识。双方各领域合作取得丰富成果，人文交流日益密切。中伊关系具有深入发展的潜力。中方愿同伊方一道努力，共同推动中伊全面战略伙伴关系行稳致远。</p> <p> 　　习近平强调，中伊双方要以深化政治关系为统领，不断增进战略互信，加强各层级交往，继续在涉及彼此核心利益的重大关切问题上相互理解、相互支持。要以共建“一带一路”为主线，引领务实合作，以打击恐怖主义为重点，推进执法安全合作，以增进中伊友好为目标，深化人文交流合作。</p> <div> <span style=\"display: none;\">&nbsp;</span></div> <p align=\"center\"> <img alt=\"\" src=\"http://www.people.com.cn/mediafile/pic/GQ/20180611/35/1564989812506248095.jpg\" /></p> <p> 　　6月10日，国家主席习近平在青岛同伊朗总统鲁哈尼举行会谈。新华社记者 谢环驰 摄</p> <p> 　　习近平指出，伊朗核问题全面协议是多边主义重要成果，有助于维护中东地区和平稳定及国际核不扩散体系，应该继续得到切实执行。中方一贯主张和平解决国际争端和热点问题，愿同伊方加强在多边框架内合作，推动构建新型国际关系。</p> <p> 　　鲁哈尼表示，祝贺上海合作组织青岛峰会圆满闭幕。习近平主席两年前对伊朗的访问极大提升了我们两国关系。伊方对伊中全面战略伙伴关系顺利发展感到高兴，愿深化两国各领域务实合作，落实好两国共建“一带一路”合作协议。当前，伊核问题全面协议存续面临挑战，伊朗期待着包括中国在内的国际社会为妥善应对有关问题发挥积极作用。</p> <p> 　　会谈后，两国元首共同见证了有关双边合作文件的签署。</p> <p> 　　丁薛祥、杨洁篪、王毅、何立峰等参加会谈。</p>', 'http://politics.people.com.cn/n1/2018/0611/c1024-30049226.html', '2018-06-11', 'http://politics.people.com.cn/n1/2018/0611/c1024-3', '习近平同伊朗总统鲁哈尼举行会谈', 'http://politics.people.com.cn/n1/2018/0611/c1024-30049226.html', '1528795506');
INSERT INTO `message_news` VALUES ('78', 'T1467284926140', 'News', '91032fe41f8f1acf2d71c96dfacf327c', '<p style=\"text-indent: 2em;\"> 人民网北京6月11日电 据中央纪委国家监委网站消息， 今年以来，贵州省各级纪检监察机关坚持把问责贯穿全面从严治党全过程，着力破解主体责任“虚化”、监督责任“弱化”、监管职责“软化”等突出问题，持续释放失责必问、问责必严的强烈信号。前5月，全省共有83个党组织、1121名党员领导干部因落实管党治党责任不力受到责任追究，204人受到党纪政务处分。</p> <p style=\"text-indent: 2em;\"> 健全制度机制。建立定期研判、台账管理、线索移交三项制度，实现纪律审查、专项监察、作风督查、信访举报与问责工作无缝对接。定期梳理分析纪律审查工作情况，规范失责问题的适用范围、追究方式和实施程序，精准实施问责。树立“尽职免责、失职追责”的鲜明导向，认真落实容错纠错实施办法，旗帜鲜明鼓励担当者、惩治不为者。</p> <p style=\"text-indent: 2em;\"> 突出问责重点。提高政治站位，增强政治觉悟，紧盯党的领导弱化、党的建设缺失、全面从严治党不力等问题，共问责402人，占问责总数的35.86%。围绕推进党风廉政建设和反腐败工作不力等问题，共问责114人，占问责总数的10.16%。聚焦维护党的政治纪律、组织纪律、廉洁纪律、群众纪律、工作纪律、生活纪律不力问题，共问责113人，占问责总数的10.08%。</p> <p style=\"text-indent: 2em;\"> 强化曝光震慑。围绕因落实“两个责任”不力，导致发生顶风违纪问题和严重违纪违法问题的情况，借助网站、微信、报刊等媒体平台，对情节严重、性质恶劣、社会关注度高的案件及时给予通报曝光，最大限度地发挥警示震慑作用。截至目前，共点名道姓通报曝光落实“两个责任”不力典型案例18件23人。</p>', 'http://politics.people.com.cn/n1/2018/0611/c1001-30048625.html', '2018-06-11', 'http://politics.people.com.cn/n1/2018/0611/c1001-3', '贵州:1121名党员领导干部因管党治党不力被问责', 'http://politics.people.com.cn/n1/2018/0611/c1001-30048625.html', '1528795506');
INSERT INTO `message_news` VALUES ('79', 'T1467284926140', 'News', '353ed7c72c1005b7b88eac0c53615016', '<table class=\"pci_c\" width=\"400\"><tbody><tr><td align=\"center\"><img src=\"http://paper.people.com.cn/rmrb/res/1/20180611/1528662361912_1.jpg\" /></td></tr> <tr><td><p>　　10日，船舶有序通过三峡五级船闸。<br />　　王爱平摄（新华社发） </p></td></tr></tbody></table><p>　　本报北京6月10日电&nbsp;（记者程远州、王浩、赵贝佳、张枨）长江水文网实时水情数据显示，10日14时，三峡水库水位145.32米，持续逼近145米防洪限制水位，这说明三峡水库基本腾出了221.5亿立方米的全部防洪库容。目前，长江流域及两湖水系大部分水库已消落至汛限水位以下或附近，为防汛创造有利条件。据水利部长江水利委员会水文局预测，今年主汛期长江上游降雨正常偏多，上游部分地区可能发生严重洪涝灾害，中下游局地也可能发生洪涝灾害。</p><p>　　10日，国家防总组织开展了大清河洪水调度和抗洪抢险演练，利用现代化手段模拟了大清河防御大洪水的全过程，检验了海河防汛的应急处置能力。海河流域主汛期即将来临，海河防总和相关省市进一步强化防汛责任，切实做好防汛抗洪工作。</p><p>　　中央气象台预计，10日夜间至15日，云南南部和西部、西藏东南部将出现持续性降雨，部分地区大到暴雨。11日—14日，西南地区东部、江南中南部、华南大部等地自西向东将出现中到大雨，部分地区暴雨。</p><p>　　此外，记者从内蒙古自治区气象局获悉：今春是内蒙古1961年以来气温最高的春天，由于气温偏高、降水偏少，赤峰等地出现重大旱情。</p> <br /><span id=\"paper_num\">　　《 人民日报 》（ 2018年06月11日 14 版）</span>', 'http://politics.people.com.cn/n1/2018/0611/c1001-30048581.html', '2018-06-11', 'http://politics.people.com.cn/n1/2018/0611/c1001-3', '国家防总开展大清河防汛演练', 'http://politics.people.com.cn/n1/2018/0611/c1001-30048581.html', '1528795506');
INSERT INTO `message_news` VALUES ('80', 'T1467284926140', 'News', 'f7093bf61ba7788485765935998c0019', '<p>　　本报北京6月10日电&nbsp;&nbsp;（记者寇江泽）生态环境部日前印发《2018—2019年蓝天保卫战重点区域强化督查方案》，将于6月11日启动强化督查。</p><p>　　当前，我国京津冀及周边地区、汾渭平原及长三角地区等重点区域空气质量继续改善，但个别地区污染仍然较重。</p><p>　　生态环境部环境监察局负责人表示，强化督查将突出重点区域、重点指标、重点时段和重点领域，围绕产业结构、能源结构、运输结构和用地结构4项重点任务，检查“散乱污”企业综合整治情况、工业企业环境问题治理情况、清洁取暖及燃煤替代情况等13项督查任务。该负责人介绍，“本次强化督查从2018年6月11日开始，将持续到2019年4月28日结束，共动用约1.8万人次。”</p><p>　　该负责人表示，生态环境部专项督查办公室统一负责指挥、调度、协调强化督查工作。排查发现的问题，由专项办审核后，第一时间向各城市推送下发电子督办单，增强交办时效性。每两轮督查结束后，安排一周时间，由督查组对之前交办问题进行核查，确保按期整改到位。</p> <br /><span id=\"paper_num\">　　《 人民日报 》（ 2018年06月11日 14 版）</span>', 'http://politics.people.com.cn/n1/2018/0611/c1001-30048582.html', '2018-06-11', 'http://politics.people.com.cn/n1/2018/0611/c1001-3', '重点区域强化督查启动', 'http://politics.people.com.cn/n1/2018/0611/c1001-30048582.html', '1528795506');
INSERT INTO `message_news` VALUES ('81', 'T1467284926140', 'News', '05a9b9c1096f3271c1b30889c34551a6', '<p>　　本报西宁6月10日电&nbsp;&nbsp;（记者姜峰）记者从日前召开的青海省纪委监委新闻发布会上获悉：青海各级监委成立以来，经过4个月的探索实践，各级纪检监察机关初步建立了规范高效的运行机制，监察体制改革取得重要阶段性成果；今年1—5月，全省纪检监察机关处置问题线索1962件，同比增长65.2%；立案285件，同比增长42.5%；党纪处分322人，政务处分104人，组织处理27人，移送司法机关10人；运用监督执纪“四种形态”处理1611人，同比增长33.8%；青海省监委和海东、海北等6个市州监委及8个县区监委已对42名调查对象采取了留置措施。</p><p>　　据介绍，监察体制改革在全国推开试点工作以来，青海省、市州、县市区三级党委加强组织领导，全面落实主体责任，确保改革始终沿着正确方向顺利推进。今年2月13日，青海全省8个市州、43个县市区监委全部依法设立。</p><p>　　改革中，青海实现了机构、编制、职数三个不增加，工作力量向监督执纪执法一线倾斜。青海省纪委监委机关设立内设机构18个，监督执纪执法部门的机构数、编制数分别占总数的77.8%和66.5%；市州纪委监委机关平均设立内设机构11个，监督执纪执法部门的机构数、编制数分别占总数的74.2%和72.8%；县市区纪委监委机关平均设立内设机构7个，监督执纪执法部门的机构数、编制数分别占总数的81.2%和82.1%。将派驻纪检组统一更名为派驻纪检监察组，授予部分监察职能，实现监察职能横向扩展。三级纪委监委坚持转隶干部、纪委干部交叉配备、混合编成，转隶干部绝大部分安排在监督执纪执法一线。为有效提升纪检监察干部思想政治水准和执纪执法能力，省纪委监委加强了对全省纪检监察干部的培训力度。同时，各级纪委监委加强了对《监察法》的学习、培训、宣传工作，不断增强贯彻监察法的坚定性和自觉性。</p><p>　　面对改革后全省监察对象从8.94万人扩大到18.09万人、工作量翻倍的实际，青海全省三级纪委监委始终把讲政治放在首位，严格依法运用调查措施，保持惩治腐败高压态势，有效运用监督执纪“四种形态”，推动形成风清气正的良好政治生态。</p><p>　　着眼于权力制约，青海省纪委监委强化建章立制工作，立足实现执纪审查与依法调查、监察程序与司法程序有序衔接，谋划梳理了5大类17项改革急需的制度建设清单。目前已经制定出台《青海省纪检监察机关监督执纪监察工作实施办法（试行）》《省纪委监委审（调）查措施使用规范（试行）》《青海省监察机关与人民检察院办理职务犯罪案件衔接办法（试行）》《青海省公安机关配合监察委员会查办案件工作办法》等7项制度和133种执纪监督、审查调查、案件审理文书，并以资料形式印发全省纪检监察机关，规范监督执纪执法工作。</p> <br /><span id=\"paper_num\">　　《 人民日报 》（ 2018年06月11日 13 版）</span>', 'http://politics.people.com.cn/n1/2018/0611/c1001-30048569.html', '2018-06-11', 'http://politics.people.com.cn/n1/2018/0611/c1001-3', '青海 监督执纪力量向一线倾斜', 'http://politics.people.com.cn/n1/2018/0611/c1001-30048569.html', '1528795506');
INSERT INTO `message_news` VALUES ('82', 'T1467284926140', 'News', 'e74520fbab4ef03d244123ea9458df0c', '<p>　　本报北京6月10日电&nbsp;&nbsp;（记者寇江泽）近日，中央第二环保督察组和中央第五环保督察组分别在内蒙古和林格尔县、广西钦州市发现两起虚假整改情况。</p><p>　　6日—7日，中央第二环保督察组接到群众举报：呼和浩特市和林格尔县西沟门移民新村一木器加工厂喷漆味道浓重、噪声污染严重，且无环评手续。</p><p>　　督察人员发现，对这家企业非法生产的电话举报，在2016年开展的第一轮中央环保督察中已受理，并于2016年向社会公示已办结。此次督察人员又发现，该厂在第一轮中央环保督察中被举报、在被查封之后继续生产，而今刚停产一周，正是为了“迎接”督察组。这正是应付整改、敷衍整改的典型做法。</p><p>　　9日，中央第五环保督察组检查发现，钦州市一批应淘汰的“散乱污”小冶炼企业仍在违法生产，严重污染环境，但钦州市政府和广西壮族自治区发改委、工信委等有关部门公示其已整改到位。督察认为，广西壮族自治区有关部门及钦州市以虚假整改、表面整改的方式应对中央环保督察，情节严重，性质恶劣。</p><p>　　中央第五环保督察组副组长、生态环境部副部长翟青专门约见了钦州市党政主要负责同志，强调必须认真贯彻落实习近平生态文明思想，切实提高政治站位，坚决杜绝虚假整改、表面整改；要借势借力，举一反三，坚决抓好整改落实工作。</p> <br /><span id=\"paper_num\">　　《 人民日报 》（ 2018年06月11日 14 版）</span>', 'http://politics.people.com.cn/n1/2018/0611/c1001-30048580.html', '2018-06-11', 'http://politics.people.com.cn/n1/2018/0611/c1001-3', '中央环保督察“回头看” 发现两起虚假整改案例', 'http://politics.people.com.cn/n1/2018/0611/c1001-30048580.html', '1528795506');
INSERT INTO `message_news` VALUES ('83', 'T1467284926140', 'News', '04a27c5c075ca952b78028dfbac98a47', '<p>各位同事，</p> <p>各位记者朋友，</p> <p>女士们，先生们：</p> <p>　　大家下午好！很高兴同大家见面。</p> <p>　　上海合作组织成员国、观察员国领导人以及有关国际和地区组织负责人齐聚美丽的黄海之滨，共同描绘上海合作组织进入历史新阶段的发展蓝图，并就重大国际和地区问题深入交换意见，达成广泛共识。</p> <p>　　这次峰会期间，我们充分肯定印度、巴基斯坦加入以来本组织取得的新发展，共同发表了《上海合作组织成员国元首理事会青岛宣言》、《上海合作组织成员国元首关于贸易便利化的联合声明》等文件，批准了《上海合作组织成员国长期睦邻友好合作条约》未来5年实施纲要。我们商定，恪守《上海合作组织宪章》宗旨和原则，弘扬互信、互利、平等、协商、尊重多样文明、谋求共同发展的“上海精神”，坚持睦邻友好，深化务实合作，共谋地区和平、稳定、发展大计。</p> <p>　　我们一致认为，当今世界正处在大发展大变革大调整时期，世界多极化、经济全球化深入发展，国与国相互依存更加紧密。世界经济复苏艰难曲折，国际和地区热点问题频发，各国面临许多共同威胁和挑战，没有哪个国家能够独自应对或独善其身。各国只有加强团结协作，深化和平合作、平等相待、开放包容、共赢共享的伙伴关系，才能实现持久稳定和发展。</p> <p>　　我们一致主张，安全是上海合作组织可持续发展的基石。各方将秉持共同、综合、合作、可持续的安全观，落实打击“三股势力”上海公约、反恐怖主义公约、反极端主义公约等合作文件，深化反恐情报交流和联合行动，加强相关法律基础和能力建设，有效打击“三股势力”、毒品贩运、跨国有组织犯罪、网络犯罪，发挥“上海合作组织—阿富汗联络组”作用，共同维护地区安全稳定。</p> <p>　　我们一致指出，经济全球化和区域一体化是大势所趋。各方将维护世界贸易组织规则的权威性和有效性，巩固开放、包容、透明、非歧视、以规则为基础的多边贸易体制，反对任何形式的贸易保护主义。各方将继续秉持互利共赢原则，完善区域经济合作安排，加强“一带一路”建设合作和发展战略对接，深化经贸、投资、金融、互联互通、农业等领域合作，推进贸易和投资便利化，打造区域融合发展新格局，为地区各国人民谋福祉，为世界经济发展增动力。</p> <p>　　我们一致强调，各国悠久历史和灿烂文化是人类的共同财富。各方愿在相互尊重文化多样性和社会价值观的基础上，继续在文化、教育、科技、环保、卫生、旅游、青年、媒体、体育等领域开展富有成效的多边和双边合作，促进文化互鉴、民心相通。</p> <p>　　我们一致认为，上海合作组织扩大国际交往和合作十分重要。各方愿在平等互利基础上，深化同观察员国、对话伙伴等地区国家的合作，扩大同联合国及其他国际和地区组织的对话和交流，共同致力于促进世界持久和平和共同繁荣。</p> <p>　　我们一致商定，本次峰会后，吉尔吉斯共和国将担任上海合作组织轮值主席国。各方将积极支持和配合吉方履行主席国职责，办好明年峰会。</p> <p>　　女士们、先生们、朋友们！</p> <p>　　借此机会，我要感谢各国领导人和国际组织负责人出席这次峰会，感谢各方各界对中方担任上海合作组织主席国和筹办峰会期间给予的大力支持和协助，感谢媒体朋友们对上海合作组织发展和青岛峰会的关注。</p> <p>　　我坚信，在大家共同努力下，上海合作组织的明天一定会更加美好！</p> <p>　　谢谢大家。</p> <p>　　（本报青岛6月10日电）&nbsp;</p> <br /><span id=\"paper_num\">　　《 人民日报 》（ 2018年06月11日 03 版）</span>', 'http://politics.people.com.cn/n1/2018/0611/c1001-30048529.html', '2018-06-11', 'http://politics.people.com.cn/n1/2018/0611/c1001-3', '同上海合作组织成员国领导人共同会见记者时的讲话', 'http://politics.people.com.cn/n1/2018/0611/c1001-30048529.html', '1528795506');
INSERT INTO `message_news` VALUES ('84', 'T1467284926140', 'News', 'b41b942bb8f0e6afb42f7838b69c3659', '<table class=\"pci_c\" width=\"400\"><tbody><tr><td align=\"center\"><img src=\"http://paper.people.com.cn/rmrb/res/1/20180611/1528662212448_1.jpg\" /></td></tr> <tr><td><p>　　市中区二七新村街道铁一社区梦新街。<br />　　杨守美摄 </p></td></tr></tbody></table><p>　　辛安，作为一名为当地市民熟知的“网红志愿者”，曾向市委、市政府建言献策，累计20余万字。</p><p>　　6月初，68岁的辛安又带领他的济南市市中区市民巡访团，检查了铁路沿线环境整治情况。</p><p>　　自去年年底济南创建全国文明城市成功后，辛安就一直担心，创城的成果能否保住？城市的品质能否进一步提升？这些问题，一直压在他的心头挥之不去。</p><p>　　半年过去了，辛安的心渐渐安了。经常骑着自行车走街串巷，他看到这座城市的点滴变化。“城市提升工程‘十大行动’开展后，高铁沿线的安全隐患没了，老旧小区的电梯装上了，遛弯锻炼的公园多了，这座城市，越来越好了。”</p><p>　　创建到建设</p><p>　　制度先行，文明城市管理常态化、规范化</p><p>　　创城会不会是一阵风？辛安曾经的担心并非杞人忧天，很多市民也有过这样的担忧。而且，据辛安观察，创城之后，少数地方确实一度出现了松懈。</p><p>　　“创城不是一劳永逸，我们清醒地认识到，济南仍存在诸多不足：城乡环境差距较大；部分公共设施破损严重，维修不及时……”济南市文明办主任周鸿雁表示，济南在创城成功之初，就高度警惕降低标准、放松管理等情况的出现。</p><p>　　创城绝不仅仅是为了那一块“金字招牌”，而是让市民能在一个宜业宜居的城市中生活，是为了满足人民对于美好生活的向往。提升城市品质只有起点，没有终点。如果说“创建”强调的是一个“创”字，那如今就是要将城市提升转变为常态化、长效化的“建设”行动。</p><p>　　今年5月初，济南就开展了城市提升工程“十大行动”，主要围绕生态环境、市容秩序、居住环境、文明素质等十个方面进行提升，要求质量和效率兼顾。其中，老旧小区电梯加装工作，从材料申报到首笔财政补助资金发到业主手中，只用了12个工作日，获得市民称赞。同时，济南市还正在酝酿出台《新时代文明城市创建工作长效机制》，推进文明城市创建工作走上常态化、规范化、制度化的良性轨道。</p><p>　　让辛安感触最深的，还是拆违拆临和及时跟进的见绿透绿。创城之后，拆违拆临工作并没有因此停下，同时，拆出来的空地很快还绿于民，一个个“口袋公园”出现在街头巷尾，市民多了不少休闲锻炼的场地。“在拥挤的城市中，家门口就有这么一个惬意的休憩之地，太幸福了。”辛安说。</p><p>　　对标“考点”到全面提标</p><p>　　敢于创新，提升精细治理水平</p><p>　　6月5日，针对快递、外卖配送引发的交通安全问题，济南交警支队联合相关行业协会携手共管，推出济南市关于加强快递、外卖行业管理的“十二条规定”，具体包括严格追究事故责任，采用人脸识别抓拍等措施强化科技管控，明确快递外卖车辆3次以上违法退出机制等内容。</p><p>　　规定一经推出，不仅本地市民拍手叫好，很多外地人也对济南刮目相看。因为工作需要经常来济南出差的王立强说，去过国内不少城市，对于快递外卖车辆横冲直撞，很多地方都很头疼却也没什么好办法，济南的方案值得观察和借鉴。</p><p>　　参与《新时代文明城市创建工作长效机制》研究制定的济南社科院社会问题研究所所长朱冬梅认为，如果说创建全国文明城市是一场大考，我们需要精准对标每个“考点”，那么成功之后，更是要跟上时代发展，全面提标，解决新问题，满足百姓更高的生活期待。除了加强对快递外卖配送交通秩序的治理，我们还实现了对共享单车的有序管理，既鼓励新生事物发展，又不扰乱正常的出行秩序。</p><p>　　“济南以前总被人调侃为‘大农村’，我听了心里很不是滋味。”辛安说，“这半年来，情况有了很大改善，我们不但奋力追赶，对标先进城市，更有了一股敢于超越、创新的冲劲，自身定位高了，城市管理水平也在这个过程中不断提高。”</p><p>　　文明城市到城市文明</p><p>　　法治护航，提升市民文明素养</p><p>　　“五一”前后，一首《济南济南》突然间在短视频网站火了起来，济南一夜间成了“网红”，成了很多人的“向往之城”。有人说，济南的意外“走红”是因为这个城市正变得越来越有魅力，越来越有温度，越来越文明。</p><p>　　“全国文明城市是梦寐以求的荣誉，下一步，济南将继续探索以文明城市创建进一步升级城市文明。”周鸿雁说，“我们希望，通过日积月累地坚持，能把整洁、美丽、温暖融进这座城市的日常，融进这座城市的灵魂。”</p><p>　　长效化建设，离不开法律法规的支撑。济南市人大常委会将《济南市文明行为促进条例》的立法调研工作列入立法调研项目，尝试德法兼治，提升社会文明程度和市民文明素养。</p><p>　　5月6日晚，酝酿已久的明湖秀在大明湖北岸正式开演。绚丽多彩的灯光和美景从波光粼粼的湖面上奔涌而出，喷泉、月屏、浮台在夜色中交相辉映。“以泉为形、以泉为景、以泉为魂”的明湖秀，让泉城济南从历史走向未来。</p><p>　　在辛安看来，明湖秀实在是济南城市提升中浓墨重彩的一笔。“别看只是个灯光秀，却把济南的精气神、历史底蕴一下子亮了出来，济南的夜不再乏味。”</p><p>　　山东省委常委、济南市委书记王忠林认为，济南正以前所未有的自信和激情，提升城市品质和美誉度，打造一座宜居宜业宜游的现代泉城，让济南成为更多人的“向往之城”。</p> <br /><span id=\"paper_num\">　　《 人民日报 》（ 2018年06月11日 13 版）</span>', 'http://politics.people.com.cn/n1/2018/0611/c1001-30048568.html', '2018-06-11', 'http://politics.people.com.cn/n1/2018/0611/c1001-3', '全面提升城市品质没有终点', 'http://politics.people.com.cn/n1/2018/0611/c1001-30048568.html', '1528795507');
INSERT INTO `message_news` VALUES ('85', 'T1467284926140', 'News', 'c99943f462ec6c58fabffb3a52a96ff6', '<table class=\"pci_c\" width=\"400\"><tbody><tr><td align=\"center\"><img src=\"http://paper.people.com.cn/rmrb/res/2018-06/11/02/rmrb2018061102p10_b.jpg\" /></td></tr> <tr><td><p>　　6月10日，国家主席习近平在青岛会见蒙古国总统巴特图勒嘎。<br />　　新华社记者 燕 雁摄 </p></td></tr></tbody></table><p>　　本报青岛6月10日电&nbsp;&nbsp;（记者殷新宇、王远）国家主席习近平10日在青岛会见蒙古国总统巴特图勒嘎。</p><p>　　习近平指出，中蒙是山水相连的近邻。中蒙关系发展符合两国人民根本利益。我赞赏总统先生就任后多次表示重视中蒙关系，愿推动中蒙全面战略伙伴关系不断发展。中方愿同蒙方一道，本着互信、合作、共赢原则，把握机遇，排除干扰，扎实开展各领域交往和合作，丰富中蒙全面战略伙伴关系内涵，开创两国合作新局面。</p><p>　　习近平强调，双方要从战略高度和长远角度把握好两国友好合作关系正确方向，在涉及彼此核心利益和重大关切的问题上相互理解和尊重。双方要保持高层交往势头，加强各领域各层级往来，增进政治互信。要结合各自优势开展互利合作，发挥好大项目合作对两国务实合作的带动和引领作用，加快推动“一带一路”倡议同“发展之路”倡议对接落实。要加强人文交流，办好明年中蒙建交70周年纪念交流活动。</p><p>　　习近平指出，蒙古国是上海合作组织首个观察员国，中方支持蒙方提升同上海合作组织合作水平。中方愿同蒙古国、俄罗斯一道，落实好建设中蒙俄经济走廊规划纲要，推动三方合作取得更多进展。</p><p>　　巴特图勒嘎表示，祝贺中方成功举办上海合作组织青岛峰会。蒙方愿努力提升与上海合作组织合作水平。我感谢习近平主席亲自关心、推动蒙中关系发展，高度赞赏中方为维护东北亚地区和平稳定作出的重要贡献。发展对华友好关系和互利合作是蒙古国外交优先方向。蒙方坚持奉行一个中国原则，认为台湾和西藏事务都是中国的内政，将本着上述原则妥善处理涉台、涉藏问题。蒙方希望同中方保持高层交往，密切各领域交流合作，增进民间友好。</p><p>　　丁薛祥、杨洁篪、王毅、何立峰等参加会见。</p> <br /><span id=\"paper_num\">　　《 人民日报 》（ 2018年06月11日 02 版）</span>', 'http://politics.people.com.cn/n1/2018/0611/c1001-30048525.html', '2018-06-11', 'http://politics.people.com.cn/n1/2018/0611/c1001-3', '习近平会见蒙古国总统巴特图勒嘎', 'http://politics.people.com.cn/n1/2018/0611/c1001-30048525.html', '1528795507');
INSERT INTO `message_news` VALUES ('86', 'T1467284926140', 'News', '351e93d46551dbf90ad984b2e1b92576', '<p> 尊敬的各位同事：</p> <p> 　　六月的青岛，风景如画。在这美好的时节，欢迎大家来到这里，出席上海合作组织成员国元首理事会第十八次会议。早在2500多年前，中国古代伟大的思想家孔子就说：“有朋自远方来，不亦乐乎？”今天，孔子的故乡山东喜迎远道而来的各方贵宾，我们在这里共商上海合作组织发展大计，具有特殊意义。</p> <p> 　　再过5天，上海合作组织将迎来17岁生日。抚今追昔，本组织走过了不平凡的发展历程，取得了重大成就。</p> <p> 　　17年来，我们以《上海合作组织宪章》、《上海合作组织成员国长期睦邻友好合作条约》为遵循，构建起不结盟、不对抗、不针对第三方的建设性伙伴关系。这是国际关系理论和实践的重大创新，开创了区域合作新模式，为地区和平与发展作出了新贡献。</p> <p> 　　今天，上海合作组织是世界上幅员最广、人口最多的综合性区域合作组织，成员国的经济和人口总量分别约占全球的20%和40%。上海合作组织拥有4个观察员国、6个对话伙伴，并同联合国等国际和地区组织建立了广泛的合作关系，国际影响力不断提升，已经成为促进世界和平与发展、维护国际公平正义不可忽视的重要力量。</p> <p> 　　上海合作组织始终保持旺盛生命力、强劲合作动力，根本原因在于它创造性地提出并始终践行“上海精神”，主张互信、互利、平等、协商、尊重多样文明、谋求共同发展。这超越了文明冲突、冷战思维、零和博弈等陈旧观念，掀开了国际关系史崭新的一页，得到国际社会日益广泛的认同。</p> <p> 　　各位同事！</p> <p> 　　“孔子登东山而小鲁，登泰山而小天下”。面对世界大发展大变革大调整的新形势，为更好推进人类文明进步事业，我们必须登高望远，正确认识和把握世界大势和时代潮流。</p> <p> 　　尽管当今世界霸权主义和强权政治依然存在，但推动国际秩序朝着更加公正合理方向发展的呼声不容忽视，国际关系民主化已成为不可阻挡的时代潮流。</p> <p> 　　尽管各种传统和非传统安全威胁不断涌现，但捍卫和平的力量终将战胜破坏和平的势力，安全稳定是人心所向。</p> <p> 　　尽管单边主义、贸易保护主义、逆全球化思潮不断有新的表现，但“地球村”的世界决定了各国日益利益交融、命运与共，合作共赢是大势所趋。</p> <p> 　　尽管文明冲突、文明优越等论调不时沉渣泛起，但文明多样性是人类进步的不竭动力，不同文明交流互鉴是各国人民共同愿望。</p> <p> 　　各位同事！</p> <p> 　　当前，世界发展既充满希望，也面临挑战，我们的未来无比光明，但前方的道路不会平坦。我们要进一步弘扬“上海精神”，破解时代难题，化解风险挑战。</p> <p> 　　——我们要提倡创新、协调、绿色、开放、共享的发展观，实现各国经济社会协同进步，解决发展不平衡带来的问题，缩小发展差距，促进共同繁荣。</p> <p> 　　——我们要践行共同、综合、合作、可持续的安全观，摒弃冷战思维、集团对抗，反对以牺牲别国安全换取自身绝对安全的做法，实现普遍安全。</p> <p> 　　——我们要秉持开放、融通、互利、共赢的合作观，拒绝自私自利、短视封闭的狭隘政策，维护世界贸易组织规则，支持多边贸易体制，构建开放型世界经济。</p> <p> 　　——我们要树立平等、互鉴、对话、包容的文明观，以文明交流超越文明隔阂，以文明互鉴超越文明冲突，以文明共存超越文明优越。</p> <p> 　　——我们要坚持共商共建共享的全球治理观，不断改革完善全球治理体系，推动各国携手建设人类命运共同体。</p> <p> 　　各位同事！</p> <p> 　　“上海精神”是我们共同的财富，上海合作组织是我们共同的家园。我们要继续在“上海精神”指引下，同舟共济，精诚合作，齐心协力构建上海合作组织命运共同体，推动建设新型国际关系，携手迈向持久和平、普遍安全、共同繁荣、开放包容、清洁美丽的世界。为此，我愿提出以下建议。</p> <p> 　　第一，凝聚团结互信的强大力量。我们要全面落实青岛宣言、长期睦邻友好合作条约实施纲要等文件，尊重各自选择的发展道路，兼顾彼此核心利益和重大关切，通过换位思考增进相互理解，通过求同存异促进和睦团结，不断增强组织的凝聚力和向心力。</p> <p> 　　第二，筑牢和平安全的共同基础。我们要积极落实打击“三股势力”2019至2021年合作纲要，继续举行“和平使命”等联合反恐演习，强化防务安全、执法安全、信息安全合作。要发挥“上海合作组织—阿富汗联络组”作用，促进阿富汗和平重建进程。未来3年，中方愿利用中国—上海合作组织国际司法交流合作培训基地等平台，为各方培训2000名执法人员，强化执法能力建设。</p> <p> 　　第三，打造共同发展繁荣的强劲引擎。我们要促进发展战略对接，本着共商共建共享原则，推进“一带一路”建设，加快地区贸易便利化进程，加紧落实国际道路运输便利化协定等合作文件。中国欢迎各方积极参与今年11月将在上海举办的首届中国国际进口博览会。中国政府支持在青岛建设中国—上海合作组织地方经贸合作示范区，还将设立“中国—上海合作组织法律服务委员会”，为经贸合作提供法律支持。</p> <p> 　　我宣布，中方将在上海合作组织银行联合体框架内设立300亿元人民币等值专项贷款。</p> <p> 　　第四，拉紧人文交流合作的共同纽带。我们要积极落实成员国环保合作构想等文件，继续办好青年交流营等品牌项目，扎实推进教育、科技、文化、旅游、卫生、减灾、媒体等各领域合作。未来3年，中方将为各成员国提供3000个人力资源开发培训名额，增强民众对上海合作组织大家庭的了解和认同。中方愿利用风云二号气象卫星为各方提供气象服务。</p> <p> 　　第五，共同拓展国际合作的伙伴网络。我们要强化同观察员国、对话伙伴等地区国家交流合作，密切同联合国等国际和地区组织的伙伴关系，同国际货币基金组织、世界银行等国际金融机构开展对话，为推动化解热点问题、完善全球治理作出贡献。</p> <p> 　　各位同事！</p> <p> 　　一年来，在各成员国大力支持和帮助下，中方完成了主席国工作，并举办了本次峰会。在这里，我向大家表示诚挚的谢意。中方愿同各成员国一道，本着积极务实、友好合作的精神，全面落实本次会议的共识，支持下一任主席国吉尔吉斯斯坦的工作，携手创造本组织更加光明的美好未来！</p> <p> 　　谢谢各位。</p> <p> 　　（本报青岛6月10日电）&nbsp;</p> <br /> <p> <span id=\"paper_num\">　　《 人民日报 》（ 2018年06月11日 03 版）</span></p>', 'http://politics.people.com.cn/n1/2018/0611/c1001-30048528.html', '2018-06-11', 'http://politics.people.com.cn/n1/2018/0611/c1001-3', '弘扬“上海精神” 构建命运共同体', 'http://politics.people.com.cn/n1/2018/0611/c1001-30048528.html', '1528795507');
INSERT INTO `message_news` VALUES ('87', 'T1467284926140', 'News', 'cae3dcf3a1d999188a71d017e41932b9', '<table class=\"pci_c\" width=\"400\"><tbody><tr><td align=\"center\"><img src=\"http://paper.people.com.cn/rmrb/res/2018-06/11/02/rmrb2018061102p17_b.jpg\" /></td></tr> <tr><td><p>　　6月10日，国家主席习近平在青岛会见阿富汗总统加尼。 <br />　　新华社记者 高 洁摄</p></td></tr></tbody></table><p>　　本报青岛6月10日电&nbsp;&nbsp;（记者徐隽、肖新新）国家主席习近平10日在青岛会见阿富汗总统加尼。</p><p>　　习近平指出，中国和阿富汗是传统友好邻邦，两国始终相互理解、信任、支持。巩固和发展中阿传统友好关系是中国政府坚定不移的方针。双方要保持高层交往，密切政府部门、立法机构、政党、军队各层级交流，加强地方合作。要深化经贸务实合作，中方愿继续为阿富汗经济社会发展提供力所能及的帮助，支持阿富汗参与“一带一路”建设，加快实现同地区国家互联互通。要加强反恐安全合作，中方将继续坚定支持阿富汗政府维护国内安全的努力。要促进人文交流，增进两国人民相互了解和友谊。</p><p>　　习近平强调，阿富汗实现长治久安的关键在于坚持“阿人主导，阿人所有”的政治和解进程。我赞赏总统先生今年年初向塔利班发出和平倡议，近日又宣布临时停火。中方支持阿富汗政府推进和解进程，通过政治对话解决阿富汗问题。</p><p>　　加尼表示，祝贺中国成功主办上海合作组织青岛峰会，此次峰会为上海合作组织发展规划了美好愿景。阿富汗钦佩中国经济社会发展成就，感谢中方长期以来对阿富汗的大力帮助，特别感谢中方对阿富汗和平和解进程的宝贵支持。阿富汗支持中方“一带一路”倡议和加强区域合作的重要主张，愿深化阿中双边各领域及地区事务中合作。</p><p>　　丁薛祥、杨洁篪、王毅、何立峰等参加会见。</p> <br /><span id=\"paper_num\">　　《 人民日报 》（ 2018年06月11日 02 版）</span>', 'http://politics.people.com.cn/n1/2018/0611/c1001-30048524.html', '2018-06-11', 'http://politics.people.com.cn/n1/2018/0611/c1001-3', '习近平会见阿富汗总统加尼', 'http://politics.people.com.cn/n1/2018/0611/c1001-30048524.html', '1528795507');
INSERT INTO `message_news` VALUES ('88', 'T1467284926140', 'News', '5eddd3db43564cedb83ac457a5d91cca', '<table class=\"pci_c\" width=\"400\"><tbody><tr><td align=\"center\"><img src=\"http://paper.people.com.cn/rmrb/res/2018-06/11/02/rmrb2018061102p20_b.jpg\" /></td></tr> <tr><td><p>　　6月10日，国家主席习近平在青岛会见白俄罗斯总统卢卡申科。<br />　　新华社记者 燕 雁摄 </p></td></tr></tbody></table><p>　　本报青岛6月10日电&nbsp;&nbsp;（记者杜尚泽、王斯雨）国家主席习近平10日在青岛会见白俄罗斯总统卢卡申科。</p><p>　　习近平指出，在双方共同努力下，中白全面战略伙伴关系迈入相互信任、合作共赢的新阶段。我和总统先生达成的合作共识得到有效落实，双方各领域、各层级交流合作达到历史最高水平，两国人民共享合作成果带来的获得感不断增强。</p><p>　　习近平强调，中国视白俄罗斯为共建“一带一路”的重要合作伙伴，赞赏白方积极参与。几年来，中白共建“一带一路”合作全面发力、多点突破、纵深推进、成果显著。双方要再接再厉，争取更多合作成果惠及于民，实现共赢发展。双方要加强战略对接和政策沟通，深化经贸、投资合作，推进中白工业园建设，确保有关合作项目取得应有经济和社会效益，促进人员交往，增进两国人民相互了解和友谊。中方支持白方参与上海合作组织合作，同各方一道，为本地区国家和人民创造更多福祉。</p><p>　　卢卡申科祝贺习近平主席成功主持了上海合作组织青岛峰会，强调青岛峰会的精彩和中方在办会过程中体现的平等和民主精神令人赞赏。白中是全天候伙伴和朋友，在彼此关心的重大问题上始终相互支持。白俄罗斯坚定支持并积极参与“一带一路”倡议，愿不断深化同中方在经贸、人文等领域交流合作。</p><p>　　会见后，两国元首共同见证了有关双边合作文件的签署。</p><p>　　丁薛祥、杨洁篪、王毅、何立峰等参加会见。</p> <br /><span id=\"paper_num\">　　《 人民日报 》（ 2018年06月11日 02 版）</span>', 'http://politics.people.com.cn/n1/2018/0611/c1001-30048523.html', '2018-06-11', 'http://politics.people.com.cn/n1/2018/0611/c1001-3', '习近平会见白俄罗斯总统卢卡申科', 'http://politics.people.com.cn/n1/2018/0611/c1001-30048523.html', '1528795507');
INSERT INTO `message_news` VALUES ('89', 'T1467284926140', 'News', '7db69b49c2a79facc378e262fca168df', '<table class=\"pci_c\" width=\"400\"><tbody><tr><td align=\"center\"><img src=\"http://paper.people.com.cn/rmrb/res/1/20180611/1528663298522_1.jpg\" /></td></tr> <tr><td><p>　　6月10日，国家主席习近平在青岛同伊朗总统鲁哈尼举行会谈。<br />　　新华社记者 丁 林摄 </p></td></tr></tbody></table><p>　　本报青岛6月10日电&nbsp;&nbsp;（记者宦翔）国家主席习近平10日在青岛同伊朗总统鲁哈尼举行会谈。</p><p>　　习近平欢迎鲁哈尼访华并出席上海合作组织青岛峰会。习近平指出，我2016年对伊朗进行国事访问期间，中伊两国宣布建立全面战略伙伴关系。两年多来，双方密切合作，全面落实我和总统先生达成的共识。双方各领域合作取得丰富成果，人文交流日益密切。中伊关系具有深入发展的潜力。中方愿同伊方一道努力，共同推动中伊全面战略伙伴关系行稳致远。</p><p>　　习近平强调，中伊双方要以深化政治关系为统领，不断增进战略互信，加强各层级交往，继续在涉及彼此核心利益的重大关切问题上相互理解、相互支持。要以共建“一带一路”为主线，引领务实合作，以打击恐怖主义为重点，推进执法安全合作，以增进中伊友好为目标，深化人文交流合作。</p><p>　　习近平指出，伊朗核问题全面协议是多边主义重要成果，有助于维护中东地区和平稳定及国际核不扩散体系，应该继续得到切实执行。中方一贯主张和平解决国际争端和热点问题，愿同伊方加强在多边框架内合作，推动构建新型国际关系。</p><p>　　鲁哈尼表示，祝贺上海合作组织青岛峰会圆满闭幕。习近平主席两年前对伊朗的访问极大提升了我们两国关系。伊方对伊中全面战略伙伴关系顺利发展感到高兴，愿深化两国各领域务实合作，落实好两国共建“一带一路”合作协议。当前，伊核问题全面协议存续面临挑战，伊朗期待着包括中国在内的国际社会为妥善应对有关问题发挥积极作用。</p><p>　　会谈后，两国元首共同见证了有关双边合作文件的签署。</p><p>　　丁薛祥、杨洁篪、王毅、何立峰等参加会谈。</p> <br /><span id=\"paper_num\">　　《 人民日报 》（ 2018年06月11日 02 版）</span>', 'http://politics.people.com.cn/n1/2018/0611/c1001-30048522.html', '2018-06-11', 'http://politics.people.com.cn/n1/2018/0611/c1001-3', '习近平同伊朗总统鲁哈尼举行会谈', 'http://politics.people.com.cn/n1/2018/0611/c1001-30048522.html', '1528795507');
INSERT INTO `message_news` VALUES ('90', 'T1467284926140', 'News', '36960d6580d30eded47e49e8856da8a9', '<table class=\"pci_c\" width=\"400\"><tbody><tr><td align=\"center\"><img src=\"http://paper.people.com.cn/rmrb/res/2018-06/11/02/rmrb2018061102p19_b.jpg\" /></td></tr> <tr><td><p>　　6月10日，上海合作组织成员国领导人共同会见记者。国家主席习近平作为主席国元首发表讲话。印度总理莫迪、哈萨克斯坦总统纳扎尔巴耶夫、吉尔吉斯斯坦总统热恩别科夫、巴基斯坦总统侯赛因、俄罗斯总统普京、塔吉克斯坦总统拉赫蒙、乌兹别克斯坦总统米尔济约耶夫出席。<br />　　新华社记者 燕 雁摄 </p></td></tr></tbody></table><p>　　本报青岛6月10日电&nbsp;&nbsp;（记者吴绮敏、裴广江、张光政）上海合作组织成员国领导人10日共同会见记者。国家主席习近平作为主席国元首发表讲话。印度总理莫迪、哈萨克斯坦总统纳扎尔巴耶夫、吉尔吉斯斯坦总统热恩别科夫、巴基斯坦总统侯赛因、俄罗斯总统普京、塔吉克斯坦总统拉赫蒙、乌兹别克斯坦总统米尔济约耶夫出席。</p><p>　　习近平介绍了上海合作组织青岛峰会达成的重要共识和成果：各方同意加强团结协作，深化和平合作、平等相待、开放包容、共赢共享的伙伴关系；秉持共同、综合、合作、可持续的安全观，维护地区安全稳定；维护世界贸易组织规则的权威性和有效性，巩固开放、包容、透明、非歧视、以规则为基础的多边贸易体制，反对任何形式的贸易保护主义，加强“一带一路”建设合作和发展战略对接；继续在文化、教育、科技、环保、卫生、旅游、青年、媒体、体育等领域开展合作，促进文化互鉴、民心相通；扩大上海合作组织的国际交往和合作，同联合国及其他国际和地区组织共同致力于促进世界持久和平和共同繁荣；积极支持和配合吉尔吉斯斯坦接任主席国工作，办好明年峰会。</p><p>　　习近平强调，上海合作组织成员国、观察员国领导人以及有关国际和地区组织负责人商定，恪守《上海合作组织宪章》宗旨和原则，弘扬“上海精神”，坚持睦邻友好，深化务实合作，共谋地区和平、稳定、发展大计。我坚信，在大家共同努力下，上海合作组织的明天一定会更加美好。（讲话全文见第三版）</p><p>　　会见记者前，成员国领导人签署了《上海合作组织成员国元首理事会青岛宣言》（宣言全文见第三版）以及一系列决议，包括批准《〈上海合作组织成员国长期睦邻友好合作条约〉实施纲要（2018—2022年）》，批准《上海合作组织成员国打击恐怖主义、分裂主义和极端主义2019年至2021年合作纲要》，批准《2018—2023年上海合作组织成员国禁毒战略》及其落实行动计划，批准《上海合作组织预防麻醉药品和精神药品滥用构想》，制定《上海合作组织成员国粮食安全合作纲要》草案，批准《上海合作组织成员国环保合作构想》，批准《〈上海合作组织成员国元首致青年共同寄语〉实施纲要》，批准《上海合作组织秘书长关于上海合作组织过去一年工作的报告》，批准《上海合作组织地区反恐怖机构理事会关于地区反恐怖机构2017年工作的报告》，签署《上海合作组织秘书处与联合国教科文组织合作谅解备忘录（2018—2022年）》，任命上海合作组织秘书长、上海合作组织地区反恐怖机构执行委员会主任等，见证了经贸、海关、旅游、对外交往等领域合作文件的签署。</p><p>　　丁薛祥、杨洁篪、王毅、何立峰等参加上述活动。</p> <br /><span id=\"paper_num\">　　《 人民日报 》（ 2018年06月11日 02 版）</span>', 'http://politics.people.com.cn/n1/2018/0611/c1001-30048521.html', '2018-06-11', 'http://politics.people.com.cn/n1/2018/0611/c1001-3', '上海合作组织成员国领导人共同会见记者', 'http://politics.people.com.cn/n1/2018/0611/c1001-30048521.html', '1528795507');
INSERT INTO `message_news` VALUES ('91', 'T1467284926140', 'News', '0393dbf7f4184f6e48a3c4c531fdcaa5', '<table class=\"pci_c\" width=\"400\"><tbody><tr><td align=\"center\"><img src=\"http://paper.people.com.cn/rmrb/res/2018-06/11/01/rmrb2018061101p18_b.jpg\" /></td></tr> <tr><td><p>　　6月10日，上海合作组织成员国元首理事会第十八次会议小范围会谈在青岛国际会议中心举行。国家主席习近平主持。这是上海合作组织成员国领导人集体合影。<br />　　新华社记者 高 洁摄 </p></td></tr></tbody></table><p>　　本报青岛6月10日电&nbsp;（记者管克江、杜尚泽、王远、宦翔）上海合作组织成员国元首理事会第十八次会议小范围会谈10日在青岛国际会议中心举行。国家主席习近平主持。印度总理莫迪、哈萨克斯坦总统纳扎尔巴耶夫、吉尔吉斯斯坦总统热恩别科夫、巴基斯坦总统侯赛因、俄罗斯总统普京、塔吉克斯坦总统拉赫蒙、乌兹别克斯坦总统米尔济约耶夫出席会议。各成员国领导人就上海合作组织发展以及重大国际和地区问题交换意见。</p> <p>　　上午9时许，上海合作组织成员国领导人陆续抵达会场。习近平热情迎接，并同他们一一握手寒暄，随后集体合影。</p> <p>　　习近平在讲话中指出，上海合作组织成立17年来，面对国际风云变幻，秉持“上海精神”，取得重大成就，成为世界上具有重要影响的综合性区域组织。现在，上海合作组织站在新的历史起点上，我们要发扬优良传统，积极应对内外挑战，全面推进各领域合作，推动上海合作组织行稳致远。</p> <p>　　习近平就上海合作组织发展提出4点建议。</p> <p>　　第一，弘扬“上海精神”，加强团结协作。我们要坚持互信、互利、平等、协商、尊重多样文明、谋求共同发展，要深化团结互信，加大相互支持，把扩员带来的潜力和机遇转化为更多实实在在的合作成果。</p> <p>　　第二，推进安全合作，携手应对挑战。我们要秉持共同、综合、合作、可持续的安全观，统筹应对传统和非传统安全威胁，有效打击“三股势力”，切实维护地区和平、安全、稳定。</p> <p>　　第三，深化务实合作，促进共同发展。我们要在产业协调、市场融合、技术交流等方面迈出更大步伐。要本着共商共建共享原则，加强基础设施建设、互联互通、产业园区、科技创新等领域交流合作，分享欧亚大陆巨大发展机遇。要发出支持贸易自由化便利化的共同声音，维护全球多边贸易体制。</p> <p>　　第四，发挥积极影响，展现国际担当。我们要坚定维护以联合国宪章宗旨和原则为核心的国际秩序和国际体系，推动建设相互尊重、公平正义、合作共赢的新型国际关系。要坚持政治外交解决热点问题。</p> <p>　　习近平强调，上海合作组织是顺应时代发展潮流、符合各国共同利益的事业。我们愿同各方一道，不忘初心，携手前进，推动上海合作组织实现新发展，构建更加紧密的命运共同体，为维护世界和平稳定、促进人类发展繁荣作出新的更大贡献。</p> <p>　　各成员国领导人高度评价中方担任主席国一年来为推进成员国合作和本组织发展所作贡献，一致认为，本次会议是上海合作组织扩员后举行的首次峰会，具有重大现实和历史意义。新成员国的加入提升了上海合作组织各领域合作能力。上海合作组织在维护地区安全稳定、促进发展繁荣方面承担的责任也越来越大。新形势下，上海合作组织要坚持弘扬“上海精神”，继续密切沟通协调，充分抓住机遇，妥善应对挑战，推进经贸、金融、农业、互联互通、人文等全方位合作，坚持打击“三股势力”，确保本组织持续健康稳定发展。</p> <p>　　会议决定，2019年上海合作组织峰会在吉尔吉斯斯坦举行。</p> <p>　　王毅参加上述活动。</p> <br /><span id=\"paper_num\">　　《 人民日报 》（ 2018年06月11日 01 版）</span>', 'http://politics.people.com.cn/n1/2018/0611/c1001-30048520.html', '2018-06-11', 'http://politics.people.com.cn/n1/2018/0611/c1001-3', '习近平主持上海合作组织青岛峰会小范围会谈', 'http://politics.people.com.cn/n1/2018/0611/c1001-30048520.html', '1528795507');
INSERT INTO `message_news` VALUES ('92', 'T1467284926140', 'News', '5417817bec37a76abb53121765774344', '<table class=\"pci_c\" width=\"400\"> <tbody> <tr> <td align=\"center\"> <img src=\"http://paper.people.com.cn/rmrb/res/2018-06/11/01/rmrb2018061101p17_b.jpg\" /></td> </tr> <tr> <td> <p> 　　6月10日，上海合作组织成员国元首理事会第十八次会议在青岛国际会议中心举行。国家主席习近平主持会议并发表重要讲话。<br /> 　　新华社记者 李学仁摄</p> </td> </tr> </tbody> </table> <table class=\"pci_c\" width=\"400\"> <tbody> <tr> <td align=\"center\"> <img src=\"http://paper.people.com.cn/rmrb/res/2018-06/11/01/rmrb2018061101p20_b.jpg\" /></td> </tr> <tr> <td> <p> 　　六月十日，上海合作组织成员国元首理事会第十八次会议在青岛国际会议中心举行。国家主席习近平主持会议并发表重要讲话。这是会前，习近平同与会各方在迎宾厅集体合影。<br /> 　　新华社记者 高 洁摄</p> </td> </tr> </tbody> </table> <table class=\"pci_c\" width=\"400\"> <tbody> <tr> <td align=\"center\"> <img src=\"http://paper.people.com.cn/rmrb/res/2018-06/11/01/rmrb2018061101p19_b.jpg\" /></td> </tr> <tr> <td> <p> 　　6月10日，上海合作组织成员国元首理事会第十八次会议在青岛国际会议中心举行。国家主席习近平主持会议并发表重要讲话。<br /> 　　新华社记者 丁 林摄</p> </td> </tr> </tbody> </table> <p> 　　本报青岛6月10日电&nbsp;（记者徐锦庚、汪晓东、杜尚泽、王远）上海合作组织成员国元首理事会第十八次会议10日在青岛国际会议中心举行。中国国家主席习近平主持会议并发表重要讲话。上海合作组织成员国领导人、常设机构负责人、观察员国领导人及联合国等国际组织负责人出席会议。与会各方共同回顾上海合作组织发展历程，就本组织发展现状、任务、前景深入交换意见，就重大国际和地区问题协调立场，达成了广泛共识。</p> <p> 　　6月的青岛，风景如画。国际会议中心外，碧海蓝天，与会各国国旗、上海合作组织会旗和与会国际组织旗帜迎风飘扬。上午11时许，会议正式开始。</p> <p> 　　习近平在开幕辞中首先感谢各方一年来对中方担任上海合作组织主席国工作的大力支持和密切配合，指出这次峰会是上海合作组织实现扩员以来举办的首次峰会，具有承前启后的重要意义。欢迎印度总理莫迪、巴基斯坦总统侯赛因首次以成员国领导人身份出席峰会。</p> <p> 　　习近平随后发表题为《弘扬“上海精神”&nbsp;构建命运共同体》的重要讲话（讲话全文见第三版）。习近平指出，上海合作组织成立17年来，走过了不平凡的发展历程，取得了重大成就。我们以《上海合作组织宪章》、《上海合作组织成员国长期睦邻友好合作条约》为遵循，构建起不结盟、不对抗、不针对第三方的建设性伙伴关系。这是国际关系理论和实践的重大创新，开创了区域合作新模式，为地区和平与发展作出了新贡献。今天，上海合作组织是世界上幅员最广、人口最多的综合性区域合作组织，国际影响力不断提升，已经成为促进世界和平与发展、维护国际公平正义不可忽视的重要力量。</p> <p> 　　习近平指出，上海合作组织始终保持旺盛生命力、强劲合作动力，根本原因在于它创造性地提出并始终践行“上海精神”，主张互信、互利、平等、协商、尊重多样文明、谋求共同发展。当今世界，国际关系民主化已成为不可阻挡的时代潮流，安全稳定是人心所向，合作共赢是大势所趋，不同文明交流互鉴是各国人民共同愿望。我们要进一步弘扬“上海精神”，提倡创新、协调、绿色、开放、共享的发展观，践行共同、综合、合作、可持续的安全观，秉持开放、融通、互利、共赢的合作观，树立平等、互鉴、对话、包容的文明观，坚持共商共建共享的全球治理观，破解时代难题，化解风险挑战。</p> <p> 　　习近平强调，“上海精神”是我们共同的财富，上海合作组织是我们共同的家园。我们要继续在“上海精神”指引下，同舟共济，精诚合作，齐心协力构建上海合作组织命运共同体，推动建设新型国际关系，携手迈向持久和平、普遍安全、共同繁荣、开放包容、清洁美丽的世界。</p> <p> 　　第一，凝聚团结互信的强大力量。我们要尊重各自选择的发展道路，兼顾彼此核心利益和重大关切，不断增强组织的凝聚力和向心力。&nbsp;</p> <p> 　　第二，筑牢和平安全的共同基础。我们要强化防务安全、执法安全、信息安全合作，促进阿富汗和平重建进程。未来3年，中方愿为各方培训2000名执法人员，强化执法能力建设。</p> <p> 　　第三，打造共同发展繁荣的强劲引擎。我们要促进发展战略对接，推进“一带一路”建设，加快地区贸易便利化进程。中方将在上海合作组织银行联合体框架内设立300亿元人民币等值专项贷款。</p> <p> 　　第四，拉紧人文交流合作的共同纽带。我们要扎实推进教育、科技、文化、旅游、卫生、减灾、媒体、环保、青少年等领域交流合作。未来3年，中方将为各成员国提供3000个人力资源开发培训名额，愿利用风云二号气象卫星为各方提供气象服务。</p> <p> 　　第五，共同拓展国际合作的伙伴网络。我们要强化同观察员国、对话伙伴等地区国家交流合作，密切同联合国等国际和地区组织的伙伴关系，同国际金融机构开展对话，为推动化解热点问题、完善全球治理作出贡献。</p> <p> 　　习近平最后强调，中方愿同各成员国一道，本着积极务实、友好合作的精神，全面落实本次会议的共识，支持下一任主席国吉尔吉斯斯坦的工作，携手创造上海合作组织更加光明的美好未来。</p> <p> 　　印度总理莫迪、哈萨克斯坦总统纳扎尔巴耶夫、吉尔吉斯斯坦总统热恩别科夫、巴基斯坦总统侯赛因、俄罗斯总统普京、塔吉克斯坦总统拉赫蒙、乌兹别克斯坦总统米尔济约耶夫，上海合作组织秘书长阿利莫夫、上海合作组织地区反恐怖机构执委会主任瑟索耶夫，阿富汗总统加尼、白俄罗斯总统卢卡申科、伊朗总统鲁哈尼、蒙古国总统巴特图勒嘎，联合国常务副秘书长阿明娜先后发言。他们高度评价中方为推动上海合作组织发展所作贡献和在担任主席国期间所作工作，积极评价上海合作组织接收印度、巴基斯坦加入的重要意义。各方一致表示，将继续遵循“上海精神”，不断巩固政治、安全、经济、人文等领域务实合作，完善全球经济治理体系，巩固和发展多边贸易体制，在国际法准则框架内解决地区热点问题，推动构建人类命运共同体。“一带一路”倡议再次受到了广泛欢迎和支持。</p> <p> 　　会议发表了《上海合作组织成员国元首理事会会议新闻公报》（公报全文见第三版）、《上海合作组织成员国元首关于贸易便利化的联合声明》、《上海合作组织成员国元首致青年共同寄语》、《上海合作组织成员国元首关于在上海合作组织地区共同应对流行病威胁的声明》。</p> <p> 　　会前，习近平同与会各方在迎宾厅集体合影。</p> <p> 　　丁薛祥、杨洁篪、王毅、何立峰等参加会议。</p> <br /> <p> <span id=\"paper_num\">　　《 人民日报 》（ 2018年06月11日 01 版）</span></p>', 'http://politics.people.com.cn/n1/2018/0611/c1001-30048519.html', '2018-06-11', 'http://politics.people.com.cn/n1/2018/0611/c1001-3', '上海合作组织青岛峰会举行', 'http://politics.people.com.cn/n1/2018/0611/c1001-30048519.html', '1528795507');
INSERT INTO `message_news` VALUES ('93', 'T1467284926140', 'News', 'e32ccf57d75bb44864e84682459c5a4c', '<p style=\"text-indent: 2em;\"> 新华社青岛6月10日电（记者侯丽军、徐冰）国家主席习近平10日在青岛同伊朗总统鲁哈尼举行会谈。</p> <p style=\"text-indent: 2em;\"> 习近平欢迎鲁哈尼访华并出席上海合作组织青岛峰会。习近平指出，我2016年对伊朗进行国事访问期间，中伊两国宣布建立全面战略伙伴关系。两年多来，双方密切合作，全面落实我和总统先生达成的共识。双方各领域合作取得丰富成果，人文交流日益密切。中伊关系具有深入发展的潜力。中方愿同伊方一道努力，共同推动中伊全面战略伙伴关系行稳致远。</p> <p style=\"text-indent: 2em;\"> 习近平强调，中伊双方要以深化政治关系为统领，不断增进战略互信，加强各层级交往，继续在涉及彼此核心利益的重大关切问题上相互理解、相互支持。要以共建“一带一路”为主线，引领务实合作，以打击恐怖主义为重点，推进执法安全合作，以增进中伊友好为目标，深化人文交流合作。</p> <p style=\"text-indent: 2em;\"> 习近平指出，伊朗核问题全面协议是多边主义重要成果，有助于维护中东地区和平稳定及国际核不扩散体系，应该继续得到切实执行。中方一贯主张和平解决国际争端和热点问题，愿同伊方加强在多边框架内合作，推动构建新型国际关系。</p> <p style=\"text-indent: 2em;\"> 鲁哈尼表示，祝贺上海合作组织青岛峰会圆满闭幕。习近平主席两年前对伊朗的访问极大提升了我们两国关系。伊方对伊中全面战略伙伴关系顺利发展感到高兴，愿深化两国各领域务实合作，落实好两国共建“一带一路”合作协议。当前，伊核问题全面协议存续面临挑战，伊朗期待着包括中国在内的国际社会为妥善应对有关问题发挥积极作用。</p> <p style=\"text-indent: 2em;\"> 会谈后，两国元首共同见证了有关双边合作文件的签署。</p> <p style=\"text-indent: 2em;\"> 丁薛祥、杨洁篪、王毅、何立峰等参加会谈。（完）&nbsp;</p>', 'http://politics.people.com.cn/n1/2018/0610/c1024-30048498.html', '2018-06-10', 'http://politics.people.com.cn/n1/2018/0610/c1024-3', '习近平同伊朗总统鲁哈尼举行会谈', 'http://politics.people.com.cn/n1/2018/0610/c1024-30048498.html', '1528795507');
INSERT INTO `message_news` VALUES ('94', 'T1467284926140', 'News', '8c5df40386cb483f2d6438d9939f7556', '<p style=\"text-indent: 2em;\"> 新华社青岛6月10日电</p> <p style=\"text-indent: 2em; text-align: center;\"> <strong>弘扬“上海精神”　构建命运共同体</strong></p> <p style=\"text-indent: 2em; text-align: center;\"> <strong>——在上海合作组织成员国元首理事会第十八次会议上的讲话</strong></p> <p style=\"text-indent: 2em; text-align: center;\"> （2018年6月10日，青岛）</p> <p style=\"text-indent: 2em; text-align: center;\"> 中华人民共和国主席 习近平</p> <p style=\"text-indent: 2em;\"> 尊敬的各位同事：</p> <p style=\"text-indent: 2em;\"> 六月的青岛，风景如画。在这美好的时节，欢迎大家来到这里，出席上海合作组织成员国元首理事会第十八次会议。早在2500多年前，中国古代伟大的思想家孔子就说：“有朋自远方来，不亦乐乎？”今天，孔子的故乡山东喜迎远道而来的各方贵宾，我们在这里共商上海合作组织发展大计，具有特殊意义。</p> <p style=\"text-indent: 2em;\"> 再过5天，上海合作组织将迎来17岁生日。抚今追昔，本组织走过了不平凡的发展历程，取得了重大成就。</p> <p style=\"text-indent: 2em;\"> 17年来，我们以《上海合作组织宪章》、《上海合作组织成员国长期睦邻友好合作条约》为遵循，构建起不结盟、不对抗、不针对第三方的建设性伙伴关系。这是国际关系理论和实践的重大创新，开创了区域合作新模式，为地区和平与发展作出了新贡献。</p> <p style=\"text-indent: 2em;\"> 今天，上海合作组织是世界上幅员最广、人口最多的综合性区域合作组织，成员国的经济和人口总量分别约占全球的20%和40%。上海合作组织拥有4个观察员国、6个对话伙伴，并同联合国等国际和地区组织建立了广泛的合作关系，国际影响力不断提升，已经成为促进世界和平与发展、维护国际公平正义不可忽视的重要力量。</p> <p style=\"text-indent: 2em;\"> 上海合作组织始终保持旺盛生命力、强劲合作动力，根本原因在于它创造性地提出并始终践行“上海精神”，主张互信、互利、平等、协商、尊重多样文明、谋求共同发展。这超越了文明冲突、冷战思维、零和博弈等陈旧观念，掀开了国际关系史崭新的一页，得到国际社会日益广泛的认同。</p> <p style=\"text-indent: 2em;\"> 各位同事！</p> <p style=\"text-indent: 2em;\"> “孔子登东山而小鲁，登泰山而小天下”。面对世界大发展大变革大调整的新形势，为更好推进人类文明进步事业，我们必须登高望远，正确认识和把握世界大势和时代潮流。</p> <p style=\"text-indent: 2em;\"> 尽管当今世界霸权主义和强权政治依然存在，但推动国际秩序朝着更加公正合理方向发展的呼声不容忽视，国际关系民主化已成为不可阻挡的时代潮流。</p> <p style=\"text-indent: 2em;\"> 尽管各种传统和非传统安全威胁不断涌现，但捍卫和平的力量终将战胜破坏和平的势力，安全稳定是人心所向。</p> <p style=\"text-indent: 2em;\"> 尽管单边主义、贸易保护主义、逆全球化思潮不断有新的表现，但“地球村”的世界决定了各国日益利益交融、命运与共，合作共赢是大势所趋。</p> <p style=\"text-indent: 2em;\"> 尽管文明冲突、文明优越等论调不时沉渣泛起，但文明多样性是人类进步的不竭动力，不同文明交流互鉴是各国人民共同愿望。</p> <p style=\"text-indent: 2em;\"> 各位同事！</p> <p style=\"text-indent: 2em;\"> 当前，世界发展既充满希望，也面临挑战，我们的未来无比光明，但前方的道路不会平坦。我们要进一步弘扬“上海精神”，破解时代难题，化解风险挑战。</p> <p style=\"text-indent: 2em;\"> ——我们要提倡创新、协调、绿色、开放、共享的发展观，实现各国经济社会协同进步，解决发展不平衡带来的问题，缩小发展差距，促进共同繁荣。</p> <p style=\"text-indent: 2em;\"> ——我们要践行共同、综合、合作、可持续的安全观，摒弃冷战思维、集团对抗，反对以牺牲别国安全换取自身绝对安全的做法，实现普遍安全。</p> <p style=\"text-indent: 2em;\"> ——我们要秉持开放、融通、互利、共赢的合作观，拒绝自私自利、短视封闭的狭隘政策，维护世界贸易组织规则，支持多边贸易体制，构建开放型世界经济。</p> <p style=\"text-indent: 2em;\"> ——我们要树立平等、互鉴、对话、包容的文明观，以文明交流超越文明隔阂，以文明互鉴超越文明冲突，以文明共存超越文明优越。</p> <p style=\"text-indent: 2em;\"> ——我们要坚持共商共建共享的全球治理观，不断改革完善全球治理体系，推动各国携手建设人类命运共同体。</p> <p style=\"text-indent: 2em;\"> 各位同事！</p> <p style=\"text-indent: 2em;\"> “上海精神”是我们共同的财富，上海合作组织是我们共同的家园。我们要继续在“上海精神”指引下，同舟共济，精诚合作，齐心协力构建上海合作组织命运共同体，推动建设新型国际关系，携手迈向持久和平、普遍安全、共同繁荣、开放包容、清洁美丽的世界。为此，我愿提出以下建议。</p> <p style=\"text-indent: 2em;\"> 第一，凝聚团结互信的强大力量。我们要全面落实青岛宣言、长期睦邻友好合作条约实施纲要等文件，尊重各自选择的发展道路，兼顾彼此核心利益和重大关切，通过换位思考增进相互理解，通过求同存异促进和睦团结，不断增强组织的凝聚力和向心力。</p> <p style=\"text-indent: 2em;\"> 第二，筑牢和平安全的共同基础。我们要积极落实打击“三股势力”2019至2021年合作纲要，继续举行“和平使命”等联合反恐演习，强化防务安全、执法安全、信息安全合作。要发挥“上海合作组织－阿富汗联络组”作用，促进阿富汗和平重建进程。未来3年，中方愿利用中国－上海合作组织国际司法交流合作培训基地等平台，为各方培训2000名执法人员，强化执法能力建设。</p> <p style=\"text-indent: 2em;\"> 第三，打造共同发展繁荣的强劲引擎。我们要促进发展战略对接，本着共商共建共享原则，推进“一带一路”建设，加快地区贸易便利化进程，加紧落实国际道路运输便利化协定等合作文件。中国欢迎各方积极参与今年11月将在上海举办的首届中国国际进口博览会。中国政府支持在青岛建设中国－上海合作组织地方经贸合作示范区，还将设立“中国－上海合作组织法律服务委员会”，为经贸合作提供法律支持。</p> <p style=\"text-indent: 2em;\"> 我宣布，中方将在上海合作组织银行联合体框架内设立300亿元人民币等值专项贷款。</p> <p style=\"text-indent: 2em;\"> 第四，拉紧人文交流合作的共同纽带。我们要积极落实成员国环保合作构想等文件，继续办好青年交流营等品牌项目，扎实推进教育、科技、文化、旅游、卫生、减灾、媒体等各领域合作。未来3年，中方将为各成员国提供3000个人力资源开发培训名额，增强民众对上海合作组织大家庭的了解和认同。中方愿利用风云二号气象卫星为各方提供气象服务。</p> <p style=\"text-indent: 2em;\"> 第五，共同拓展国际合作的伙伴网络。我们要强化同观察员国、对话伙伴等地区国家交流合作，密切同联合国等国际和地区组织的伙伴关系，同国际货币基金组织、世界银行等国际金融机构开展对话，为推动化解热点问题、完善全球治理作出贡献。</p> <p style=\"text-indent: 2em;\"> 各位同事！</p> <p style=\"text-indent: 2em;\"> 一年来，在各成员国大力支持和帮助下，中方完成了主席国工作，并举办了本次峰会。在这里，我向大家表示诚挚的谢意。中方愿同各成员国一道，本着积极务实、友好合作的精神，全面落实本次会议的共识，支持下一任主席国吉尔吉斯斯坦的工作，携手创造本组织更加光明的美好未来！</p> <p style=\"text-indent: 2em;\"> 谢谢各位。</p>', 'http://politics.people.com.cn/n1/2018/0610/c1024-30048495.html', '2018-06-10', 'http://politics.people.com.cn/n1/2018/0610/c1024-3', '习近平在上海合作组织成员国元首理事会 第十八次会议上的讲话（全文）', 'http://politics.people.com.cn/n1/2018/0610/c1024-30048495.html', '1528795507');
INSERT INTO `message_news` VALUES ('95', 'T1467284926140', 'News', 'cafbeb7de2b03fdcdea1bb0a0e6d0230', '<p> 　　新华社青岛6月10日电（记者谭晶晶、席敏）国家主席习近平10日在青岛会见蒙古国总统巴特图勒嘎。</p> <p> 　　习近平指出，中蒙是山水相连的近邻。中蒙关系发展符合两国人民根本利益。我赞赏总统先生就任后多次表示重视中蒙关系，愿推动中蒙全面战略伙伴关系不断发展。中方愿同蒙方一道，本着互信、合作、共赢原则，把握机遇，排除干扰，扎实开展各领域交往和合作，丰富中蒙全面战略伙伴关系内涵，开创两国合作新局面。</p> <p> 　　习近平强调，双方要从战略高度和长远角度把握好两国友好合作关系正确方向，在涉及彼此核心利益和重大关切的问题上相互理解和尊重。双方要保持高层交往势头，加强各领域各层级往来，增进政治互信。要结合各自优势开展互利合作，发挥好大项目合作对两国务实合作的带动和引领作用，加快推动“一带一路”倡议同“发展之路”倡议对接落实。要加强人文交流，办好明年中蒙建交70周年纪念交流活动。</p> <p> 　　习近平指出，蒙古国是上海合作组织首个观察员国，中方支持蒙方提升同上海合作组织合作水平。中方愿同蒙古国、俄罗斯一道，落实好建设中蒙俄经济走廊规划纲要，推动三方合作取得更多进展。</p> <p> 　　巴特图勒嘎表示，祝贺中方成功举办上海合作组织青岛峰会。蒙方愿努力提升与上海合作组织合作水平。我感谢习近平主席亲自关心、推动蒙中关系发展，高度赞赏中方为维护东北亚地区和平稳定作出的重要贡献。发展对华友好关系和互利合作是蒙古国外交优先方向。蒙方坚持奉行一个中国原则，认为台湾和西藏事务都是中国的内政，将本着上述原则妥善处理涉台、涉藏问题。蒙方希望同中方保持高层交往，密切各领域交流合作，增进民间友好。</p> <p> 　　丁薛祥、杨洁篪、王毅、何立峰等参加会见。</p>', 'http://politics.people.com.cn/n1/2018/0610/c1024-30048485.html', '2018-06-10', 'http://politics.people.com.cn/n1/2018/0610/c1024-3', '习近平会见蒙古国总统巴特图勒嘎', 'http://politics.people.com.cn/n1/2018/0610/c1024-30048485.html', '1528795507');
INSERT INTO `message_news` VALUES ('96', 'T1467284926140', 'News', '45978ba455cfb0f4f214de02a5cfcf47', '<p style=\"text-indent: 2em;\"> “再过5天，上海合作组织将迎来17岁生日。”6月10日，黄海之滨，习近平在上海合作组织成员国元首理事会第十八次会议上发表重要讲话，高屋建瓴地总结回顾上合17年不平凡的历程。</p> <p style=\"text-indent: 2em;\"> 17岁的上合，已成长为世界上幅员最广、人口最多的综合性区域合作组织。</p> <p style=\"text-indent: 2em;\"> 17岁的上合，面对复杂的国际形势，面对不断涌现的各种安全威胁，如何看？怎么办？</p> <p style=\"text-indent: 2em;\"> 习近平在青岛峰会讲话中，给出新时代中国的答案。</p> <p style=\"text-indent: 2em;\"> <strong>弘扬“上海精神”，破解时代难题</strong></p> <p style=\"text-indent: 2em;\"> “孔子登东山而小鲁，登泰山而小天下”。</p> <p style=\"text-indent: 2em;\"> “国际关系民主化已成为不可阻挡的时代潮流。”习近平用四个“尽管”开头的转折句，登高望远，对当今国际世界大势和时代潮流作出深刻判断。</p> <p style=\"text-indent: 2em;\"> 习近平指出，尽管单边主义、贸易保护主义、逆全球化思潮不断有新的表现，但“地球村”的世界决定了各国日益利益交融、命运与共，合作共赢是大势所趋。</p> <p style=\"text-indent: 2em;\"> 中国上合组织研究中心常务理事石泽在接受人民网记者专访时表示，“习主席的讲话审时度势、立意高远，他对当前国际形势的重要判断，必将对推动上合组织开展深入合作、持续健康发展产生深远影响”。</p> <p style=\"text-indent: 2em;\"> “对于当前所面临的一些时代难题和风险挑战，习主席特别强调要进一步弘扬‘上海精神’。”石泽谈到，习近平对“上海精神”的重视是一以贯之的。</p> <p style=\"text-indent: 2em;\"> 2015年7月10日，俄罗斯，乌法。习近平在上海合作组织成员国元首理事会第十五次会议上指出，要让“上海精神”在本地区更加深入人心、发扬光大，成为本组织成员国打造命运共同体、共建和谐家园的精神纽带。</p> <p style=\"text-indent: 2em;\"> 2016年6月24日，乌兹别克斯坦，塔什干。习近平在上海合作组织成员国元首理事会第十六次会议上指出，“上海精神”具有超越时代和地域的生命力和价值。</p> <p style=\"text-indent: 2em;\"> 此次峰会，习近平再次作出精辟阐述：“上海合作组织始终保持旺盛生命力、强劲合作动力，根本原因在于它创造性地提出并始终践行‘上海精神’”。</p> <p style=\"text-indent: 2em;\"> <strong>倡导“五观”理念，构建命运共同体</strong></p> <p style=\"text-indent: 2em;\"> “大道之行，天下为公”。</p> <p style=\"text-indent: 2em;\"> 中国儒家的“和合”理念同“上海精神”有很多相通之处。在6月9日的上海合作组织青岛峰会欢迎宴会上，习近平一连引用了四个儒家经典。</p> <p style=\"text-indent: 2em;\"> 在这个夏季，各国嘉宾齐聚孔子的故乡山东。习近平峰会讲话中闪耀出的东方智慧，令与会嘉宾由衷赞叹。</p> <p style=\"text-indent: 2em;\"> 尤为引人注目的是，习近平在讲话中首次系统性提出弘扬“上海精神”的“五观”：一是创新、协调、绿色、开放、共享的发展观；二是共同、综合、合作、可持续的安全观；三是开放、融通、互利、共赢的合作观；四是平等、互鉴、对话、包容的文明观；五是共商共建共享的全球治理观。</p> <p style=\"text-indent: 2em;\"> 专家指出，发展观、安全观、合作观、文明观、全球治理观，这“五观”从多个方面凝聚发展共识，对上合组织的发展起到重要引领作用。</p> <p style=\"text-indent: 2em;\"> 社科院俄罗斯东欧中亚研究所研究员姜毅向人民网记者谈到，从长远来看，这些倡议与构建人类命运共同体，是完全契合的，上合组织是践行人类命运共同体理念的一个非常好的平台，也是构建新型国际关系和地区合作模式的重要尝试。</p> <p style=\"text-indent: 2em;\"> 石泽认为，“五观”的提出，是超越了民族国家和意识形态的“全球观”，是我国重要的外交理念，为构建人类命运共同体注入了新的内涵。</p> <p style=\"text-indent: 2em;\"> <strong>释放中国红利，提升上合行动力</strong></p> <p style=\"text-indent: 2em;\"> “未来3年，中方愿利用中国－上海合作组织国际司法交流合作培训基地等平台，为各方培训2000名执法人员，强化执法能力建设。”</p> <p style=\"text-indent: 2em;\"> “中国欢迎各方积极参与今年11月将在上海举办的首届中国国际进口博览会。”</p> <p style=\"text-indent: 2em;\"> “我宣布，中方将在上海合作组织银行联合体框架内设立300亿元人民币等值专项贷款。”</p> <p style=\"text-indent: 2em;\"> ……</p> <p style=\"text-indent: 2em;\"> 习近平在上海合作组织成员国元首理事会第十八次会议上的重要讲话，干货满满，释放出实实在在的中国红利。</p> <p style=\"text-indent: 2em;\"> 专家认为，习主席的讲话既有宏观的阐述，也有具体的举措，中国以更加开放的姿态，提供公共产品，促进上合组织各成员国共同发展。</p> <p style=\"text-indent: 2em;\"> 姜毅指出，上合组织成立17年来，中国一直都是重要的推动力量，在未来发展中，中国仍将在维护地区安全、加强经贸合作、促进人文交流等方面发挥重要作用，从各国企业到普通游客，都将从中受益。</p> <p style=\"text-indent: 2em;\"> “上合组织命运共同体的构建，意味着参与各方应是共生共荣的关系。这种关系不仅凝聚合力、求同存异、求同化异，更催生出新的合作关系。”石泽指出，习主席讲话中的承诺，均是依据上合组织发展的需要所提出的，这将有助于进一步挖掘合作潜力。</p> <p style=\"text-indent: 2em;\"> 石泽注意到，习主席在讲话中谈到，“本着共商共建共享原则，推进‘一带一路’建设”。</p> <p style=\"text-indent: 2em;\"> 石泽指出，“发展战略的对接，关系着上合组织的可持续发展。‘一带一路’建设与上合组织发展具有内在的统一性和互补性，一方面两者的地域比较吻合，另一方面，多边合作和双边合作可以互相促进。”</p> <p style=\"text-indent: 2em;\"> 浩渺行无极，扬帆但信风。上海合作组织站在新的起点，风帆正满、破浪前行。&nbsp; &nbsp;</p>', 'http://politics.people.com.cn/n1/2018/0610/c1024-30048459.html', '2018-06-10', 'http://politics.people.com.cn/n1/2018/0610/c1024-3', '习近平上合青岛峰会提出“五观” 贡献新时代中国智慧', 'http://politics.people.com.cn/n1/2018/0610/c1024-30048459.html', '1528795507');
INSERT INTO `message_news` VALUES ('97', 'T1467284926140', 'News', 'bc5f7ed99db7f5e351e502a2bce10cf7', '<p> 　　新华社青岛6月10日电（记者谭晶晶、徐冰）国家主席习近平10日在青岛会见阿富汗总统加尼。</p> <p> 　　习近平指出，中国和阿富汗是传统友好邻邦，两国始终相互理解、信任、支持。巩固和发展中阿传统友好关系是中国政府坚定不移的方针。双方要保持高层交往，密切政府部门、立法机构、政党、军队各层级交流，加强地方合作。要深化经贸务实合作，中方愿继续为阿富汗经济社会发展提供力所能及的帮助，支持阿富汗参与“一带一路”建设，加快实现同地区国家互联互通。要加强反恐安全合作，中方将继续坚定支持阿富汗政府维护国内安全的努力。要促进人文交流，增进两国人民相互了解和友谊。</p> <p> 　　习近平强调，阿富汗实现长治久安的关键在于坚持“阿人主导，阿人所有”的政治和解进程。我赞赏总统先生今年年初向塔利班发出和平倡议，近日又宣布临时停火。中方支持阿富汗政府推进和解进程，通过政治对话解决阿富汗问题。</p> <p> 　　加尼表示，祝贺中国成功主办上海合作组织青岛峰会，此次峰会为上海合作组织发展规划了美好愿景。阿富汗钦佩中国经济社会发展成就，感谢中方长期以来对阿富汗的大力帮助，特别感谢中方对阿富汗和平和解进程的宝贵支持。阿富汗支持中方“一带一路”倡议和加强区域合作的重要主张，愿深化阿中双边各领域及地区事务中合作。</p> <p> 　　丁薛祥、杨洁篪、王毅、何立峰等参加会见。</p>', 'http://politics.people.com.cn/n1/2018/0610/c1024-30048442.html', '2018-06-10', 'http://politics.people.com.cn/n1/2018/0610/c1024-3', '习近平会见阿富汗总统加尼', 'http://politics.people.com.cn/n1/2018/0610/c1024-30048442.html', '1528795507');
INSERT INTO `message_news` VALUES ('98', 'T1467284926140', 'News', '0936e055d6f9e0ccffe6cc529fbef7fd', '<p> 　　新华社青岛6月10日电（记者谭晶晶、潘林清）国家主席习近平10日在青岛会见白俄罗斯总统卢卡申科。</p> <p> 　　习近平指出，在双方共同努力下，中白全面战略伙伴关系迈入相互信任、合作共赢的新阶段。我和总统先生达成的合作共识得到有效落实，双方各领域、各层级交流合作达到历史最高水平，两国人民共享合作成果带来的获得感不断增强。</p> <p> 　　习近平强调，中国视白俄罗斯为共建“一带一路”的重要合作伙伴，赞赏白方积极参与。几年来，中白共建“一带一路”合作全面发力、多点突破、纵深推进、成果显著。双方要再接再厉，争取更多合作成果惠及于民，实现共赢发展。双方要加强战略对接和政策沟通，深化经贸、投资合作，推进中白工业园建设，确保有关合作项目取得应有经济和社会效益，促进人员交往，增进两国人民相互了解和友谊。中方支持白方参与上海合作组织合作，同各方一道，为本地区国家和人民创造更多福祉。</p> <p> 　　卢卡申科祝贺习近平主席成功主持了上海合作组织青岛峰会，强调青岛峰会的精彩和中方在办会过程中体现的平等和民主精神令人赞赏。白中是全天候伙伴和朋友，在彼此关心的重大问题上始终相互支持。白俄罗斯坚定支持并积极参与“一带一路”倡议，愿不断深化同中方在经贸、人文等领域交流合作。</p> <p> 　　会见后，两国元首共同见证了有关双边合作文件的签署。</p> <p> 　　丁薛祥、杨洁篪、王毅、何立峰等参加会见。</p>', 'http://politics.people.com.cn/n1/2018/0610/c1024-30048441.html', '2018-06-10', 'http://politics.people.com.cn/n1/2018/0610/c1024-3', '习近平会见白俄罗斯总统卢卡申科', 'http://politics.people.com.cn/n1/2018/0610/c1024-30048441.html', '1528795507');
INSERT INTO `message_news` VALUES ('99', 'T1467284926140', 'News', 'b688fdfcbee343b2292a651df9e32116', '<p> 　　新华社拉萨６月１０日电（记者刘洪明）为进一步改善学生学习生活条件，持续增强教育“三包”政策保障能力，日前西藏进一步提高教育“三包”政策补助标准，在现行基础上年生均增加２４０元，自今年秋季学期开始执行。</p> <p> 　　记者日前从西藏自治区财政厅获悉，调整后的资金标准为，学前教育阶段：二类区３１２０元、三类区３２２０元、四类区或边境县３３２０元；义务教育阶段：二类区３６２０元、三类区３７２０元、四类区或边境县３８２０元；高中教育阶段：二类区４１２０元、三类区４２２０元、四类区或边境县４３２０元。经费结构比例为伙食费占８０%至８７%，服装费及装备费占１０%至１５%，作业本和学习用品费占３%至５%。</p> <p> 　　西藏自１９８５年实施教育“三包”政策，在免费接受义务教育的基础上，对农牧民子女实行了包吃、包住、包学习费用的“三包”政策，对城镇困难家庭子女实行了同等标准的助学金制度和财政补助政策。</p>', 'http://politics.people.com.cn/n1/2018/0610/c1001-30048437.html', '2018-06-10', 'http://politics.people.com.cn/n1/2018/0610/c1001-3', '西藏进一步提高教育“三包”政策补助标准', 'http://politics.people.com.cn/n1/2018/0610/c1001-30048437.html', '1528795507');
INSERT INTO `message_news` VALUES ('100', 'T1467284926140', 'News', '0be0fcaf9b79993fd1974afae4f68f57', '<p style=\"text-indent: 2em;\"> 人民网西宁6月10日电 （记者 姜峰）记者10日从青海省旅发委获悉：为将旅游业培育成为青海省战略性支柱产业和人民群众更加满意的现代服务业龙头产业，推动青海省从旅游名省向旅游大省转变，青海出台《关于加快全域旅游发展的实施意见》，力争到2020年，初步形成全域统筹规划、全域合理布局、全域整体营销、全域服务提升的全域旅游体系，2025年旅游接待总人数达到1亿人次，旅游总收入超过1000亿元，实现旅游效应最大化，跨入旅游大省行列。</p> <p style=\"text-indent: 2em;\"> 《意见》提出，推动青海全域旅游高质量发展，力促旅游业从门票经济向产业经济转变，从粗放低效方式向精细高效方式转变，从封闭的旅游自循环向开放的“旅游+”转变，从企业单打独斗向社会共建共享转变，从景区内部管理向全面依法治理转变，从部门行为向政府统筹推进转变，从单一景点景区建设向综合目的地服务转变，把旅游业打造成为现代服务业的龙头产业，切实增强人民群众的获得感和幸福感。</p> <p style=\"text-indent: 2em;\"> 同时，坚持保护优先、绿色发展，牢固树立绿水青山就是金山银山理念，正确处理保护与发展的关系，坚持生态优先，合理有序利用，防止破坏环境，摒弃盲目开发，实现经济效益、社会效益、生态效益相互促进、共同提升。注重产品、设施与项目的特色，不搞一个模式，防止千城一面、千村一面、千景一面，推行各具特色、差异化推进的全域旅游发展新方式。</p> <p style=\"text-indent: 2em;\"> 《意见》要求，推进国家全域旅游示范区创建，扎实推进西宁市、海东市、海西州、门源县、民和县、互助县6个省级全域旅游示范区创建，到2020年，全域旅游示范区达到10个，其中国家级全域旅游示范区5个以上。同时，加快生态旅游示范区建设，率先探索自然生态型A级景区标准，建立旅游生态环境预警机制，完善旅游目的地与景区环境容量发布制度，将发展生态旅游作为旅游产业转型升级的重要抓手，编制《青海生态旅游发展规划》，在国家公园、国家森林公园、自然保护区等的科普游憩区组织生态旅游，力争到2020年建成省级生态示范区10个。</p> <p style=\"text-indent: 2em;\"> 《意见》明确，不断打造精品旅游景区，加快祁连卓尔山·阿咪东索旅游区、金银滩—原子城景区、茶卡盐湖景区、西宁市博物馆群等国家5A级旅游景区创建工作。同时，积极推动乡村旅游，到2020年，全省乡村旅游接待点达到4000家；星级乡村旅游接待点达到1200家；省级休闲农业与乡村旅游示范点达到150家。</p> <p style=\"text-indent: 2em;\"> 在保障措施方面，《意见》要求强化财政金融扶持力度，建立全域旅游发展资金投入稳定增长机制，各级财政投入每年保持10%以上的增速；加强人才保障，健全与全域旅游相适应的教育体系和培训机制，开展全域旅游全员培训，每年实现旅游从业人员培训1万人（次）；强化旅游工作监督考核，建立推进全域旅游发展工作目标责任制、协调机制和考核奖罚机制，明确任务分工，形成推进全域旅游发展合力。建立完善干部考核机制，将推动全域旅游发展成果纳入各级干部考核内容。</p>', 'http://politics.people.com.cn/n1/2018/0610/c1001-30048435.html', '2018-06-10', 'http://politics.people.com.cn/n1/2018/0610/c1001-3', '青海出台加快全域旅游发展实施意见 力争“十四五”旅游总收入超千亿元', 'http://politics.people.com.cn/n1/2018/0610/c1001-30048435.html', '1528795507');

-- ----------------------------
-- Table structure for message_photo
-- ----------------------------
DROP TABLE IF EXISTS `message_photo`;
CREATE TABLE `message_photo` (
  `dateline` int(32) DEFAULT NULL COMMENT '抓取时间',
  `url` text COMMENT '图片地址',
  `created_at` varchar(255) DEFAULT NULL COMMENT '拍摄时间',
  `camera` varchar(255) DEFAULT NULL COMMENT '所用相机',
  `description` text COMMENT '图片描述',
  `name` varchar(255) DEFAULT NULL COMMENT '图片名称',
  `userid` int(32) DEFAULT NULL COMMENT '用户ID',
  `pid` int(32) DEFAULT NULL COMMENT '图片ID',
  `id` int(32) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  PRIMARY KEY (`id`),
  KEY `pid` (`pid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of message_photo
-- ----------------------------

-- ----------------------------
-- Table structure for message_record
-- ----------------------------
DROP TABLE IF EXISTS `message_record`;
CREATE TABLE `message_record` (
  `id` int(32) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `mid` varchar(50) DEFAULT NULL,
  `title` varchar(50) NOT NULL COMMENT '主题',
  `important` tinyint(1) NOT NULL COMMENT '是否重要',
  `content` text COMMENT '消息内容',
  `receiver` longtext COMMENT '接受者',
  `sender` varchar(50) DEFAULT NULL COMMENT '发送者',
  `datetime` int(32) NOT NULL COMMENT '发送日期',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='短消息发送成功表';

-- ----------------------------
-- Records of message_record
-- ----------------------------

-- ----------------------------
-- Table structure for message_template
-- ----------------------------
DROP TABLE IF EXISTS `message_template`;
CREATE TABLE `message_template` (
  `id` int(32) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `title` varchar(50) DEFAULT '' COMMENT '主题',
  `important` tinyint(1) NOT NULL COMMENT '是否重要',
  `content` text COMMENT '内容',
  `datetime` int(32) NOT NULL COMMENT '发送日期',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='消息模板表';

-- ----------------------------
-- Records of message_template
-- ----------------------------

-- ----------------------------
-- Table structure for message_traffic_ban_city
-- ----------------------------
DROP TABLE IF EXISTS `message_traffic_ban_city`;
CREATE TABLE `message_traffic_ban_city` (
  `id` int(32) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `citycode` int(32) DEFAULT NULL COMMENT '城市代码',
  `name` varchar(50) DEFAULT NULL COMMENT '城市名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of message_traffic_ban_city
-- ----------------------------

-- ----------------------------
-- Table structure for message_traffic_ban_info
-- ----------------------------
DROP TABLE IF EXISTS `message_traffic_ban_info`;
CREATE TABLE `message_traffic_ban_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `citycode` int(32) DEFAULT NULL COMMENT '城市ID',
  `trafficinfo` text COMMENT '限行信息',
  `rspcode` int(32) DEFAULT NULL COMMENT 'API返回状态码',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of message_traffic_ban_info
-- ----------------------------

-- ----------------------------
-- Table structure for message_weather
-- ----------------------------
DROP TABLE IF EXISTS `message_weather`;
CREATE TABLE `message_weather` (
  `id` int(32) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `data_uptime` int(32) DEFAULT NULL COMMENT '发布时间',
  `weather` longtext COMMENT '天气数据',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of message_weather
-- ----------------------------
INSERT INTO `message_weather` VALUES ('4', '1528792920', '{\"historyWeather\":{\"history\":{}},\"area\":[[\"天津\",\"10103\"],[\"天津\",\"1010301\"],[\"天津\",\"101030100\"]],\"life\":{\"date\":\"2018-06-12\",\"info\":{\"kongtiao\":[\"部分时间开启\",\"天气热，到中午的时候您将会感到有点热，因此建议在午后较热时开启制冷空调。\"],\"daisan\":[\"不带伞\",\"阴天，但降水概率很低，因此您在出门的时候无须带雨伞。\"],\"ziwaixian\":[\"弱\",\"紫外线强度较弱，建议出门前涂擦SPF在12-15之间、PA+的防晒护肤品。\"],\"yundong\":[\"较适宜\",\"阴天，较适宜进行各种户内外运动。\"],\"ganmao\":[\"少发\",\"各项气象条件适宜，发生感冒机率较低。但请避免长期处于空调房间中，以防感冒。\"],\"xiche\":[\"不宜\",\"不宜洗车，未来24小时内有雨，如果在此期间洗车，雨水和路上的泥水可能会再次弄脏您的爱车。\"],\"diaoyu\":[\"较适宜\",\"较适合垂钓，但天气稍热，会对垂钓产生一定的影响。\"],\"guomin\":[\"不易发\",\"天气条件不易诱发过敏，可放心外出，除特殊体质外，无需担心过敏问题。\"],\"xianxing\":[\"5和0\",\"外环线(不含)以内道路。本市号牌尾号限行，外地号牌工作日07:00-09:00、17:00-19:00全部限行，其他限行时间内尾号限行。\"],\"wuran\":[\"良\",\"气象条件有利于空气污染物稀释、扩散和清除，可在室外正常活动。\"],\"chuanyi\":[\"热\",\"天气热，建议着短裙、短裤、短薄外套、T恤等夏季服装。\"]}},\"realtime\":{\"mslp\":\"\",\"wind\":{\"windspeed\":\"3.1\",\"direct\":\"东南风\",\"power\":\"2级\"},\"time\":\"16:42:00\",\"pressure\":\"995\",\"weather\":{\"humidity\":\"46\",\"img\":\"2\",\"info\":\"阴\",\"temperature\":\"29\"},\"feelslike_c\":\"28\",\"dataUptime\":\"1528792920\",\"date\":\"2018-06-12\"},\"alert\":[{\"content\":\"天津市气象台于2018年06月12日15时10分发布天津地区雷电黄色预警信号：预计今天傍晚到前半夜（17时到23时）我市将出现雷阵雨，局地伴有短时强降水和风雹天气，请有关单位和人员作好防范准备。\",\"pubTime\":\"2018-06-12 15:12\",\"originUrl\":\"http://mobile.weathercn.com/alert.do?id=12000041600000_20180612151157\",\"alarmTp2\":\"黄色\",\"alarmTp1\":\"雷电\",\"type\":1,\"alarmPic2\":\"02\",\"alarmPic1\":\"09\"}],\"trafficalert\":[],\"weather\":[{\"aqi\":\"75\",\"date\":\"2018-06-11\",\"info\":{\"night\":[\"0\",\"晴\",\"21\",\"南风\",\"微风\",\"19:36\"],\"day\":[\"0\",\"晴\",\"29\",\"南风\",\"3-5级\",\"04:45\"]}},{\"aqi\":\"126\",\"date\":\"2018-06-12\",\"info\":{\"night\":[\"4\",\"雷阵雨\",\"21\",\"东风\",\"3-5级\",\"19:37\"],\"day\":[\"4\",\"雷阵雨\",\"31\",\"东南风\",\"3-5级\",\"04:45\"]}},{\"aqi\":\"91\",\"date\":\"2018-06-13\",\"info\":{\"night\":[\"4\",\"雷阵雨\",\"22\",\"东北风\",\"微风\",\"19:37\"],\"day\":[\"4\",\"雷阵雨\",\"30\",\"东南风\",\"微风\",\"04:45\"]}},{\"aqi\":\"67\",\"date\":\"2018-06-14\",\"info\":{\"night\":[\"2\",\"阴\",\"23\",\"东北风\",\"微风\",\"19:38\"],\"day\":[\"2\",\"阴\",\"32\",\"东南风\",\"微风\",\"04:45\"]}},{\"aqi\":\"74\",\"date\":\"2018-06-15\",\"info\":{\"night\":[\"0\",\"晴\",\"23\",\"南风\",\"微风\",\"19:38\"],\"day\":[\"2\",\"阴\",\"31\",\"东南风\",\"微风\",\"04:45\"]}},{\"aqi\":\"70\",\"date\":\"2018-06-16\",\"info\":{\"night\":[\"2\",\"阴\",\"24\",\"东南风\",\"3-5级\",\"19:39\"],\"day\":[\"1\",\"多云\",\"32\",\"西南风\",\"3-5级\",\"04:45\"]}},{\"aqi\":\"67\",\"date\":\"2018-06-17\",\"info\":{\"night\":[\"2\",\"阴\",\"21\",\"东南风\",\"微风\",\"19:39\"],\"day\":[\"2\",\"阴\",\"32\",\"南风\",\"3-5级\",\"04:45\"]}},{\"aqi\":\"76\",\"date\":\"2018-06-18\",\"info\":{\"night\":[\"7\",\"小雨\",\"22\",\"持续无风向\",\"微风\",\"19:39\"],\"day\":[\"0\",\"晴\",\"30\",\"东风\",\"3-5级\",\"04:45\"]}},{\"aqi\":\"\",\"date\":\"2018-06-19\",\"info\":{\"night\":[\"1\",\"多云\",\"22\",\"东南风\",\"微风\",\"19:40\"],\"day\":[\"7\",\"小雨\",\"31\",\"东南风\",\"微风\",\"04:45\"]}},{\"aqi\":\"\",\"date\":\"2018-06-20\",\"info\":{\"night\":[\"2\",\"阴\",\"24\",\"东北风\",\"微风\",\"19:40\"],\"day\":[\"2\",\"阴\",\"34\",\"南风\",\"微风\",\"04:45\"]}},{\"aqi\":\"\",\"date\":\"2018-06-21\",\"info\":{\"night\":[\"2\",\"阴\",\"22\",\"北风\",\"微风\",\"19:40\"],\"day\":[\"7\",\"小雨\",\"33\",\"北风\",\"微风\",\"04:45\"]}},{\"aqi\":\"\",\"date\":\"2018-06-22\",\"info\":{\"night\":[\"1\",\"多云\",\"20\",\"东北风\",\"微风\",\"19:40\"],\"day\":[\"1\",\"多云\",\"33\",\"东北风\",\"微风\",\"04:45\"]}},{\"aqi\":\"\",\"date\":\"2018-06-23\",\"info\":{\"night\":[\"1\",\"多云\",\"20\",\"东北风\",\"微风\",\"19:41\"],\"day\":[\"2\",\"阴\",\"31\",\"东风\",\"微风\",\"04:46\"]}},{\"aqi\":\"\",\"date\":\"2018-06-24\",\"info\":{\"night\":[\"1\",\"多云\",\"20\",\"东风\",\"微风\",\"19:41\"],\"day\":[\"1\",\"多云\",\"30\",\"东南风\",\"微风\",\"04:46\"]}},{\"aqi\":\"\",\"date\":\"2018-06-25\",\"info\":{\"night\":[\"0\",\"晴\",\"22\",\"东南风\",\"微风\",\"19:41\"],\"day\":[\"1\",\"多云\",\"31\",\"东南风\",\"3-5级\",\"04:46\"]}},{\"aqi\":\"\",\"date\":\"2018-06-26\",\"info\":{\"night\":[\"1\",\"多云\",\"23\",\"东南风\",\"微风\",\"19:41\"],\"day\":[\"0\",\"晴\",\"33\",\"东南风\",\"3-5级\",\"04:46\"]}}],\"pm25\":{\"so2\":7,\"o3\":260,\"co\":\"1.0\",\"level\":3,\"color\":\"#ff7e00\",\"no2\":24,\"aqi\":130,\"quality\":\"轻度污染\",\"pm10\":87,\"pm25\":53,\"advice\":\"易感人群症状有轻度加剧，健康人群出现刺激症状。建议儿童、老年人及心脏病和呼吸系统疾病患者应减少长时间、高强度的户外锻炼。\",\"chief\":\"O3\",\"upDateTime\":1528790400000},\"hourly_forecast\":[{\"img\":\"04\",\"wind_speed\":\"6\",\"hour\":\"17\",\"wind_direct\":\"东北风\",\"temperature\":\"29\",\"info\":\"雷阵雨\"},{\"img\":\"04\",\"wind_speed\":\"5\",\"hour\":\"18\",\"wind_direct\":\"东北风\",\"temperature\":\"30\",\"info\":\"雷阵雨\"},{\"img\":\"01\",\"wind_speed\":\"4\",\"hour\":\"19\",\"wind_direct\":\"东风\",\"temperature\":\"29\",\"info\":\"多云\"},{\"img\":\"01\",\"wind_speed\":\"4\",\"hour\":\"20\",\"wind_direct\":\"东南风\",\"temperature\":\"28\",\"info\":\"多云\"},{\"img\":\"01\",\"wind_speed\":\"4\",\"hour\":\"21\",\"wind_direct\":\"东南风\",\"temperature\":\"26\",\"info\":\"多云\"},{\"img\":\"01\",\"wind_speed\":\"5\",\"hour\":\"22\",\"wind_direct\":\"西南风\",\"temperature\":\"25\",\"info\":\"多云\"},{\"img\":\"01\",\"wind_speed\":\"6\",\"hour\":\"23\",\"wind_direct\":\"西南风\",\"temperature\":\"24\",\"info\":\"多云\"},{\"img\":\"01\",\"wind_speed\":\"5\",\"hour\":\"0\",\"wind_direct\":\"西南风\",\"temperature\":\"24\",\"info\":\"多云\"},{\"img\":\"01\",\"wind_speed\":\"4\",\"hour\":\"1\",\"wind_direct\":\"东南风\",\"temperature\":\"24\",\"info\":\"多云\"},{\"img\":\"01\",\"wind_speed\":\"4\",\"hour\":\"2\",\"wind_direct\":\"东风\",\"temperature\":\"23\",\"info\":\"多云\"},{\"img\":\"04\",\"wind_speed\":\"4\",\"hour\":\"3\",\"wind_direct\":\"东北风\",\"temperature\":\"23\",\"info\":\"雷阵雨\"},{\"img\":\"04\",\"wind_speed\":\"4\",\"hour\":\"4\",\"wind_direct\":\"东北风\",\"temperature\":\"22\",\"info\":\"雷阵雨\"},{\"img\":\"01\",\"wind_speed\":\"4\",\"hour\":\"5\",\"wind_direct\":\"东北风\",\"temperature\":\"21\",\"info\":\"多云\"},{\"img\":\"01\",\"wind_speed\":\"4\",\"hour\":\"6\",\"wind_direct\":\"东北风\",\"temperature\":\"22\",\"info\":\"多云\"},{\"img\":\"01\",\"wind_speed\":\"3\",\"hour\":\"7\",\"wind_direct\":\"东南风\",\"temperature\":\"22\",\"info\":\"多云\"},{\"img\":\"01\",\"wind_speed\":\"4\",\"hour\":\"8\",\"wind_direct\":\"东南风\",\"temperature\":\"23\",\"info\":\"多云\"},{\"img\":\"01\",\"wind_speed\":\"4\",\"hour\":\"9\",\"wind_direct\":\"东南风\",\"temperature\":\"24\",\"info\":\"多云\"},{\"img\":\"01\",\"wind_speed\":\"4\",\"hour\":\"10\",\"wind_direct\":\"东南风\",\"temperature\":\"25\",\"info\":\"多云\"},{\"img\":\"01\",\"wind_speed\":\"4\",\"hour\":\"11\",\"wind_direct\":\"东南风\",\"temperature\":\"26\",\"info\":\"多云\"},{\"img\":\"01\",\"wind_speed\":\"4\",\"hour\":\"12\",\"wind_direct\":\"东南风\",\"temperature\":\"27\",\"info\":\"多云\"},{\"img\":\"01\",\"wind_speed\":\"4\",\"hour\":\"13\",\"wind_direct\":\"东南风\",\"temperature\":\"28\",\"info\":\"多云\"},{\"img\":\"04\",\"wind_speed\":\"4\",\"hour\":\"14\",\"wind_direct\":\"东南风\",\"temperature\":\"24\",\"info\":\"雷阵雨\"},{\"img\":\"01\",\"wind_speed\":\"4\",\"hour\":\"15\",\"wind_direct\":\"东南风\",\"temperature\":\"30\",\"info\":\"多云\"},{\"img\":\"01\",\"wind_speed\":\"4\",\"hour\":\"16\",\"wind_direct\":\"东南风\",\"temperature\":\"28\",\"info\":\"多云\"}]}');

-- ----------------------------
-- Table structure for monitor_record
-- ----------------------------
DROP TABLE IF EXISTS `monitor_record`;
CREATE TABLE `monitor_record` (
  `id` int(32) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `username` varchar(50) DEFAULT NULL COMMENT '管理员账号',
  `device_id` varchar(50) DEFAULT NULL COMMENT '设备ID',
  `device_ip` varchar(50) DEFAULT NULL COMMENT '设备IP',
  `datetime` int(32) DEFAULT NULL COMMENT '日期',
  `status` tinyint(2) DEFAULT NULL COMMENT '监视状态 1：正常，2：异常',
  `image` varchar(255) DEFAULT NULL COMMENT '抓拍图片',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='监视记录表';

-- ----------------------------
-- Records of monitor_record
-- ----------------------------

-- ----------------------------
-- Table structure for notice_info
-- ----------------------------
DROP TABLE IF EXISTS `notice_info`;
CREATE TABLE `notice_info` (
  `id` int(32) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `content` text COMMENT '公告内容',
  `raw` longtext COMMENT '图文公告原始内容',
  `author` varchar(50) DEFAULT NULL COMMENT '作者',
  `deadline` int(32) DEFAULT NULL COMMENT '显示截止日期',
  `datetime` int(32) DEFAULT NULL COMMENT '发布时间',
  `type` tinyint(2) DEFAULT '0' COMMENT '公告类型 0:图文 1:视频 2:纯文本',
  `bgcolor` varchar(255) DEFAULT NULL COMMENT '图文公告背景颜色',
  `thumb` varchar(255) DEFAULT NULL COMMENT '视频缩略图地址',
    `target` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='公告信息表';

-- ----------------------------
-- Records of notice_info
-- ----------------------------

DROP TABLE IF EXISTS `notice_encode_transfer`;
CREATE TABLE `notice_encode_transfer` (
  `notice_encode_transfer_id` int(32) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `pid` int(32) DEFAULT NULL COMMENT '进程ID',
  `file_name` varchar(255) DEFAULT NULL COMMENT '文件名',
  `description` varchar(255) DEFAULT NULL COMMENT '文件名称',
  PRIMARY KEY (`notice_encode_transfer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for offline_record
-- ----------------------------
DROP TABLE IF EXISTS `offline_record`;
CREATE TABLE `offline_record` (
  `id` int(32) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `device_id` varchar(50) NOT NULL COMMENT '设备id',
  `device_ip` varchar(50) DEFAULT NULL COMMENT '设备ip',
  `device_name` varchar(50) DEFAULT '' COMMENT '设备名称',
  `datetime` int(32) DEFAULT NULL COMMENT '日期',
  `remark` text NOT NULL COMMENT '注备',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='断线记录表';

-- ----------------------------
-- Records of offline_record
-- ----------------------------

-- ----------------------------
-- Table structure for operate_record
-- ----------------------------
DROP TABLE IF EXISTS `operate_record`;
CREATE TABLE `operate_record` (
  `id` int(32) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `operator` varchar(50) NOT NULL DEFAULT '' COMMENT '操作者',
  `content` text NOT NULL COMMENT '操作内容',
  `datetime` int(32) DEFAULT NULL COMMENT '操作时间',
  `ip` varchar(50) DEFAULT NULL COMMENT '登录IP',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='登录登出记录表';

-- ----------------------------
-- Records of operate_record
-- ----------------------------

-- ----------------------------
-- Table structure for sippeers
-- ----------------------------
DROP TABLE IF EXISTS `sippeers`;
CREATE TABLE `sippeers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(40) NOT NULL,
  `ipaddr` varchar(45) DEFAULT NULL,
  `port` int(11) DEFAULT NULL,
  `regseconds` int(11) DEFAULT NULL,
  `defaultuser` varchar(40) DEFAULT NULL,
  `fullcontact` varchar(80) DEFAULT NULL,
  `regserver` varchar(20) DEFAULT NULL,
  `useragent` varchar(20) DEFAULT NULL,
  `lastms` int(11) DEFAULT NULL,
  `host` varchar(40) DEFAULT 'dynamic',
  `type` enum('friend','user','peer') DEFAULT 'peer',
  `context` varchar(40) DEFAULT 'DLPN_systec',
  `permit` varchar(95) DEFAULT NULL,
  `deny` varchar(95) DEFAULT NULL,
  `secret` varchar(40) DEFAULT NULL,
  `md5secret` varchar(40) DEFAULT NULL,
  `remotesecret` varchar(40) DEFAULT NULL,
  `transport` enum('udp','tcp','tls','ws','wss','udp,tcp','tcp,udp') DEFAULT NULL,
  `dtmfmode` enum('rfc2833','info','shortinfo','inband','auto') DEFAULT NULL,
  `directmedia` enum('yes','no','nonat','update') DEFAULT 'no',
  `nat` varchar(29) DEFAULT 'force_rport,comedia',
  `callgroup` varchar(40) DEFAULT NULL,
  `pickupgroup` varchar(40) DEFAULT NULL,
  `language` varchar(40) DEFAULT NULL,
  `disallow` varchar(200) DEFAULT NULL,
  `allow` varchar(200) DEFAULT 'ulaw,h264',
  `insecure` varchar(40) DEFAULT NULL,
  `trustrpid` enum('yes','no') DEFAULT NULL,
  `progressinband` enum('yes','no','never') DEFAULT NULL,
  `promiscredir` enum('yes','no') DEFAULT NULL,
  `useclientcode` enum('yes','no') DEFAULT NULL,
  `accountcode` varchar(40) DEFAULT NULL,
  `setvar` varchar(200) DEFAULT NULL,
  `callerid` varchar(40) DEFAULT NULL,
  `amaflags` varchar(40) DEFAULT NULL,
  `callcounter` enum('yes','no') DEFAULT NULL,
  `busylevel` int(11) DEFAULT NULL,
  `allowoverlap` enum('yes','no') DEFAULT NULL,
  `allowsubscribe` enum('yes','no') DEFAULT NULL,
  `videosupport` enum('yes','no') DEFAULT NULL,
  `maxcallbitrate` int(11) DEFAULT NULL,
  `rfc2833compensate` enum('yes','no') DEFAULT NULL,
  `mailbox` varchar(40) DEFAULT NULL,
  `session-timers` enum('accept','refuse','originate') DEFAULT NULL,
  `session-expires` int(11) DEFAULT NULL,
  `session-minse` int(11) DEFAULT NULL,
  `session-refresher` enum('uac','uas') DEFAULT NULL,
  `t38pt_usertpsource` varchar(40) DEFAULT NULL,
  `regexten` varchar(40) DEFAULT NULL,
  `fromdomain` varchar(40) DEFAULT NULL,
  `fromuser` varchar(40) DEFAULT NULL,
  `qualify` varchar(40) DEFAULT NULL,
  `defaultip` varchar(45) DEFAULT NULL,
  `rtptimeout` int(11) DEFAULT NULL,
  `rtpholdtimeout` int(11) DEFAULT NULL,
  `sendrpid` enum('yes','no') DEFAULT NULL,
  `outboundproxy` varchar(40) DEFAULT NULL,
  `callbackextension` varchar(40) DEFAULT NULL,
  `timert1` int(11) DEFAULT NULL,
  `timerb` int(11) DEFAULT NULL,
  `qualifyfreq` int(11) DEFAULT NULL,
  `constantssrc` enum('yes','no') DEFAULT NULL,
  `contactpermit` varchar(95) DEFAULT NULL,
  `contactdeny` varchar(95) DEFAULT NULL,
  `usereqphone` enum('yes','no') DEFAULT NULL,
  `textsupport` enum('yes','no') DEFAULT NULL,
  `faxdetect` enum('yes','no') DEFAULT NULL,
  `buggymwi` enum('yes','no') DEFAULT NULL,
  `auth` varchar(40) DEFAULT NULL,
  `fullname` varchar(40) DEFAULT NULL,
  `trunkname` varchar(40) DEFAULT NULL,
  `cid_number` varchar(40) DEFAULT NULL,
  `callingpres` enum('allowed_not_screened','allowed_passed_screen','allowed_failed_screen','allowed','prohib_not_screened','prohib_passed_screen','prohib_failed_screen','prohib') DEFAULT NULL,
  `mohinterpret` varchar(40) DEFAULT NULL,
  `mohsuggest` varchar(40) DEFAULT NULL,
  `parkinglot` varchar(40) DEFAULT NULL,
  `hasvoicemail` enum('yes','no') DEFAULT NULL,
  `subscribemwi` enum('yes','no') DEFAULT NULL,
  `vmexten` varchar(40) DEFAULT NULL,
  `autoframing` enum('yes','no') DEFAULT NULL,
  `rtpkeepalive` int(11) DEFAULT NULL,
  `call-limit` int(11) DEFAULT NULL,
  `g726nonstandard` enum('yes','no') DEFAULT NULL,
  `ignoresdpversion` enum('yes','no') DEFAULT NULL,
  `allowtransfer` enum('yes','no') DEFAULT NULL,
  `dynamic` enum('yes','no') DEFAULT NULL,
  `path` varchar(256) DEFAULT NULL,
  `supportpath` enum('yes','no') DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sippeers
-- ----------------------------

-- ----------------------------
-- Table structure for sippeers_status
-- ----------------------------
DROP TABLE IF EXISTS `sippeers_status`;
CREATE TABLE `sippeers_status` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `name` varchar(40) NOT NULL COMMENT '设备号码',
  `regseconds` int(11) DEFAULT '0' COMMENT '时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `extension` (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='设备状态';

-- ----------------------------
-- Records of sippeers_status
-- ----------------------------

-- ----------------------------
-- Table structure for ticket_info
-- ----------------------------
DROP TABLE IF EXISTS `ticket_info`;
CREATE TABLE `ticket_info` (
  `id` int(32) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `tid` varchar(20) NOT NULL DEFAULT '' COMMENT '工单ID',
  `sponsor` varchar(50) DEFAULT NULL COMMENT '发起者',
  `title` varchar(50) DEFAULT NULL COMMENT '工单标题',
  `remark` text COMMENT '问题描述',
  `photo` varchar(255) DEFAULT NULL COMMENT '照片',
  `datetime` int(11) DEFAULT NULL COMMENT '发起时间',
  `updatetime` int(11) DEFAULT NULL COMMENT '更新时间',
  `status` tinyint(2) DEFAULT NULL COMMENT '工单状态1:正常，2：处理中，3：关闭',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='工单信息表';

-- ----------------------------
-- Records of ticket_info
-- ----------------------------

-- ----------------------------
-- View structure for View_GetALLDeviceList
-- ----------------------------
DROP VIEW IF EXISTS `View_GetALLDeviceList`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `View_GetALLDeviceList` AS SELECT
	`B`.`building` AS `building`,
	`C`.`unit` AS `unit`,
	'' AS `room`,
	`A`.`guard_no` AS `deviceNo`,
	concat(
		'07',
		`B`.`building`,
		`C`.`unit`,
		`A`.`guard_no`,
		'00'
	) AS `sipNo`,
	`A`.`device_ip` AS `device_ip`,
	`A`.`device_type` AS `device_type`,
	`A`.`remark` AS `remark`,
	`A`.`mac` AS `mac`,
	'07' AS `deviceTypeNo`
FROM
	(
		(
			`base_guard_info` `A`
			JOIN `base_building_info` `B` ON (
				(
					`A`.`building_id` = `B`.`building_id`
				)
			)
		)
		JOIN `base_unit_info` `C` ON (
			(
				`A`.`unit_id` = `C`.`unit_id`
			)
		)
	)
UNION
	SELECT
		'' AS `building`,
		'' AS `unit`,
		'' AS `room`,
		`A`.`wall_no` AS `deviceNo`,
		concat(
			'03',
			'000',
			'00',
			`A`.`wall_no`,
			'00'
		) AS `sipNo`,
		`A`.`device_ip` AS `device_ip`,
		`A`.`device_type` AS `device_type`,
		`A`.`remark` AS `remark`,
		`A`.`mac` AS `mac`,
		'03' AS `deviceTypeNo`
	FROM
		`base_wall_info` `A`
	UNION
		SELECT
			`B`.`building` AS `building`,
			`C`.`unit` AS `unit`,
			'' AS `room`,
			`A`.`outdoor_no` AS `deviceNo`,
			concat(
				'02',
				`B`.`building`,
				`C`.`unit`,
				`A`.`outdoor_no`,
				'00'
			) AS `sipNo`,
			`A`.`device_ip` AS `device_ip`,
			`A`.`device_type` AS `device_type`,
			`A`.`remark` AS `remark`,
			`A`.`mac` AS `mac`,
			'02' AS `deviceTypeNo`
		FROM
			(
				(
					`base_outdoor_info` `A`
					JOIN `base_building_info` `B` ON (
						(
							`A`.`building_id` = `B`.`building_id`
						)
					)
				)
				JOIN `base_unit_info` `C` ON (
					(
						`A`.`unit_id` = `C`.`unit_id`
					)
				)
			)
		UNION
			SELECT
				`B`.`building` AS `building`,
				`C`.`unit` AS `unit`,
				`D`.`room` AS `room`,
				'' AS `deviceNo`,
				`A`.`device_id` AS `sipNo`,
				`A`.`device_ip` AS `device_ip`,
				`A`.`device_type` AS `device_type`,
				`A`.`remark` AS `remark`,
				`A`.`mac` AS `mac`,
				'01' AS `deviceTypeNo`
			FROM
				(
					(
						(
							`base_indoor_info` `A`
							JOIN `base_building_info` `B` ON (
								(
									`A`.`building_id` = `B`.`building_id`
								)
							)
						)
						JOIN `base_unit_info` `C` ON (
							(
								`A`.`unit_id` = `C`.`unit_id`
							)
						)
					)
					JOIN `base_room_info` `D` ON (
						(
							`A`.`room_id` = `D`.`room_id`
						)
					)
				);
DROP TRIGGER IF EXISTS `device_after_insert`;
DELIMITER ;;
CREATE TRIGGER `device_after_insert` AFTER INSERT ON `device` FOR EACH ROW BEGIN
	SET @deviceid = NEW.name;
	INSERT INTO sippeers (name, secret, fullname) VALUES (@deviceid, NEW.password, NEW.nickname);
	INSERT INTO sippeers_status (name) VALUES (@deviceid);
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `device_after_update`;
DELIMITER ;;
CREATE TRIGGER `device_after_update` AFTER UPDATE ON `device` FOR EACH ROW BEGIN
	SET @olddeviceid = OLD.name;
	SET @deviceid = NEW.name;
	UPDATE sippeers SET sippeers.name=@deviceid, sippeers.secret=NEW.password, sippeers.fullname=NEW.nickname WHERE sippeers.name=@olddeviceid;
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `device_after_delete`;
DELIMITER ;;
CREATE TRIGGER `device_after_delete` AFTER DELETE ON `device` FOR EACH ROW BEGIN
	SET @deviceid = OLD.name;
	DELETE FROM sippeers WHERE sippeers.name = @deviceid;
	DELETE FROM sippeers_status WHERE sippeers_status.name = @deviceid;
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `sippeers_after_update`;
DELIMITER ;;
CREATE TRIGGER `sippeers_after_update` AFTER UPDATE ON `sippeers` FOR EACH ROW BEGIN
	if NEW.regseconds then
		UPDATE sippeers_status SET sippeers_status.regseconds=UNIX_TIMESTAMP() WHERE sippeers_status.name=NEW.name;
	end if;
END
;;
DELIMITER ;

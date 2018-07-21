#!/usr/bin/env python
# -*- coding: utf-8 -*-
import uuid
import MySQLdb
import time
import sys
import mqtt.publish as publish
import urllib2
import json
import datetime
import paho.mqtt.client as mqtt
from MySQLdb.cursors import DictCursor
from DBUtils.PooledDB import PooledDB
import logging
import logging.config

# from MySqlConn import Mysql

# from PooledDB import PooledDB


reload(sys)
sys.setdefaultencoding('utf-8')
logging.basicConfig(
    level=logging.DEBUG,
    filename='/home/wwwroot/default/log.txt',
    format='[%(asctime)s] %(levelname)s [%(funcName)s: %(filename)s, %(lineno)d] %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S',
    filemode='a'
)


# 数据库操作类
class Mysql(object):
    # 连接池对象
    __pool = None

    def __init__(self):
        # 数据库构造函数，从连接池中取出连接，并生成操作游标
        self._conn = Mysql.__getConn()
        self._cursor = self._conn.cursor()

    @staticmethod
    def __getConn():
        """
        @summary: 静态方法，从连接池中取出连接
        @return MySQLdb.connection
        """
        if Mysql.__pool is None:
            try:
                __pool = PooledDB(creator=MySQLdb, mincached=1, maxcached=20,
                                  host="127.0.0.1", port=3306, user="root", passwd="root",
                                  db="management", use_unicode=False, charset="utf8", cursorclass=DictCursor)
            except:
                logging.error("DB connect fail!")
        return __pool.connection()

    def getAll(self, sql, param=None):
        """
        @summary: 执行查询，并取出所有结果集
        @param sql:查询ＳＱＬ，如果有查询条件，请只指定条件列表，并将条件值使用参数[param]传递进来
        @param param: 可选参数，条件列表值（元组/列表）
        @return: result list(字典对象)/boolean 查询到的结果集
        """
        if param is None:
            count = self._cursor.execute(sql)
        else:
            count = self._cursor.execute(sql, param)
        if count > 0:
            result = self._cursor.fetchall()
        else:
            result = False
        return result

    def getOne(self, sql, param=None):
        """
        @summary: 执行查询，并取出第一条
        @param sql:查询ＳＱＬ，如果有查询条件，请只指定条件列表，并将条件值使用参数[param]传递进来
        @param param: 可选参数，条件列表值（元组/列表）
        @return: result list/boolean 查询到的结果集
        """
        if param is None:
            count = self._cursor.execute(sql)
        else:
            count = self._cursor.execute(sql, param)
        if count > 0:
            result = self._cursor.fetchone()
        else:
            result = False
        return result

    def getMany(self, sql, num, param=None):
        """
        @summary: 执行查询，并取出num条结果
        @param sql:查询ＳＱＬ，如果有查询条件，请只指定条件列表，并将条件值使用参数[param]传递进来
        @param num:取得的结果条数
        @param param: 可选参数，条件列表值（元组/列表）
        @return: result list/boolean 查询到的结果集
        """
        if param is None:
            count = self._cursor.execute(sql)
        else:
            count = self._cursor.execute(sql, param)
        if count > 0:
            result = self._cursor.fetchmany(num)
        else:
            result = False
        return result

    def insertOne(self, sql):
        """
        @summary: 向数据表插入一条记录
        @param sql:要插入的ＳＱＬ格式
        @param value:要插入的记录数据tuple/list
        @return: insertId 受影响的行数
        """
        logging.info("insertOne: " + sql)
        try:
            self._cursor.execute(sql)
        except Exception as e:
            logging.error(sql + " message:" + e.message)
        return self.__getInsertId()

    def insertMany(self, sql, values):
        """
        @summary: 向数据表插入多条记录
        @param sql:要插入的ＳＱＬ格式
        @param values:要插入的记录数据tuple(tuple)/list[list]
        @return: count 受影响的行数
        """
        count = self._cursor.executemany(sql, values)
        return count

    def __getInsertId(self):
        """
        获取当前连接最后一次插入操作生成的id,如果没有则为０
        """
        self._cursor.execute("SELECT @@IDENTITY AS id")
        result = self._cursor.fetchall()
        return result[0]['id']

    def __query(self, sql, param=None):
        if param is None:
            count = self._cursor.execute(sql)
        else:
            count = self._cursor.execute(sql, param)
        return count

    def update(self, sql, param=None):
        """
        @summary: 更新数据表记录
        @param sql: ＳＱＬ格式及条件，使用(%s,%s)
        @param param: 要更新的  值 tuple/list
        @return: count 受影响的行数
        """
        return self.__query(sql, param)

    def delete(self, sql, param=None):
        """
        @summary: 删除数据表记录
        @param sql: ＳＱＬ格式及条件，使用(%s,%s)
        @param param: 要删除的条件 值 tuple/list
        @return: count 受影响的行数
        """
        return self.__query(sql, param)

    def begin(self):
        """
        @summary: 开启事务
        """
        self._conn.autocommit(0)

    def end(self, option='commit'):
        """
        @summary: 结束事务
        """
        if option == 'commit':
            self._conn.commit()
        else:
            self._conn.rollback()

    def dispose(self, isEnd=1):
        """
        @summary: 释放连接池资源
        """
        if isEnd == 1:
            self.end('commit')
        else:
            self.end('rollback');
        self._cursor.close()
        self._conn.close()


# 调用API授权认证通用方法
def getHTTPAuthorize(url):
    password_mgr = urllib2.HTTPPasswordMgrWithDefaultRealm()
    # MQTT API授权用户名和密码
    password_mgr.add_password(None, url, "admin", "public")
    handler = urllib2.HTTPBasicAuthHandler(password_mgr)
    opener = urllib2.build_opener(handler)
    opener.open(url)
    urllib2.install_opener(opener)
    return urllib2.urlopen(url).read()


# 获取在线设备列表服务
def getOnlineDevices():
    page_flag = getHTTPAuthorize(
        "http://127.0.0.1:18083/api/v2/nodes/emq@127.0.0.1/clients?curr_page=1&page_size=100")
    devices = []
    for i in range(1, json.loads(page_flag)['result']['total_page'] + 1):
        devices_recursion = getHTTPAuthorize(
            "http://127.0.0.1:18083/api/v2/nodes/emq@127.0.0.1/clients?curr_page=" + str(i) + "&page_size=100")
        for key, value in enumerate(json.loads(devices_recursion)['result']['objects']):
            devices.append(str(value['client_id']))
    return devices


# 根据特定topic获取在线设备和订阅主题服务
def getOnlineTopics(topic):
    page_flag = getHTTPAuthorize(
        "http://127.0.0.1:18083/api/v2/nodes/emq@127.0.0.1/subscriptions?curr_page=1&page_size=100")
    devices = []
    for i in range(1, json.loads(page_flag)['result']['total_page'] + 1):
        devices_recursion = getHTTPAuthorize(
            "http://127.0.0.1:18083/api/v2/nodes/emq@127.0.0.1/subscriptions?curr_page=" + str(
                i) + "&page_size=100")
        for key, value in enumerate(json.loads(devices_recursion)['result']['objects']):
            devices.append({"topic": str(value['topic']), "clientID": str(value['client_id'])})

    res = []
    for v in devices:
        if topic in str(v['topic']):
            if str(v['clientID']) in getOnlineDevices():
                res.append({"topic": str(v['topic']), "clientID": str(v['clientID'])})
    return res


# 获取MAC地址服务
def get_mac_address():
    mac = uuid.UUID(int=uuid.getnode()).hex[-12:]
    return ":".join([mac[e:e + 2] for e in range(0, 11, 2)])


# 注册MQTT服务订阅主题
def on_connect(client, userdata, flags, rc):
    try:
        client.subscribe("Security/alarm")
        logging.info("Register Security/alarm success")
    except:
        logging.error("Register Security/alarm fail")


# 判断有误楼栋单元服务
# return Bool
def hasBuildingAndUnit(deviceID):
    mysql = Mysql()
    hasBuild = mysql.getOne("SELECT `building_id` FROM `base_building_info` WHERE `building`='" + deviceID[2:5] + "'")
    if hasBuild:
        hasUnit = mysql.getOne(
            "SELECT `unit_id` FROM `base_unit_info` WHERE `building_id`=" + str(
                hasBuild['building_id']) + " and `unit`='" + deviceID[5:7] + "'")
        if hasUnit:
            hasRoom = mysql.getOne("SELECT `room_id` FROM `base_room_info` WHERE `building_id`=" + str(
                hasBuild['building_id']) + " and `unit_id`=" + str(hasUnit['unit_id']) + " and `room`='" + deviceID[
                                                                                                           7:11] + "'")
            if hasRoom:
                return True
            else:
                return hasRoom
        else:
            return hasUnit
    else:
        return hasBuild


# 接收单个布撤防服务
def receiveOneDeployment(deviceID, eventType, zoneID, zoneType, sensorType, descripton):
    mysql = Mysql()
    logging.info("Mysql instances for receiveOneDeployment message:")
    flag = hasBuildingAndUnit(deviceID)
    if flag:
        ret = mysql.insertOne("INSERT INTO `defense_record` SET `deviceID`='" + str(deviceID) + "',`building`='" + str(
            deviceID[2:5]) + "',`unit`='" + str(deviceID[5:7]) + "',`room`='" + str(
            deviceID[7:11]) + "',`zoneID`=" + str(zoneID) + ",`zoneType`=" + str(zoneType) + ",`sensorType`=" + str(
            sensorType) + ",`eventType`=" + str(eventType) + ",`description`='" + str(
            descripton) + "',`datetime`=" + str(int(time.time())))
        logging.info("Mysql insert success for receiveOneDeployment message:")

        mysql.dispose()
        if ret:
            return True
        else:
            return False
    else:
        return False


# 接收一键布撤防服务
def receiveAllDeployment(deviceID, eventType):
    mysql = Mysql()
    logging.info("Mysql instances for receiveAllDeployment message:")
    flag = hasBuildingAndUnit(deviceID)
    if flag:
        ret = mysql.insertOne(
            "INSERT INTO `defense_record` SET `deviceID`='%s',`building`='%s',`unit`='%s',`room`='%s',`eventType`=%d,`datetime`=%d" % (
                deviceID, deviceID[2:5], deviceID[5:7], deviceID[7:11], eventType, int(time.time())))
        logging.info("Mysql insert success for receiveAllDeployment message:")
        mysql.dispose()
        if ret:
            return True
        else:
            return False
    else:
        return False


# 接收防区报警服务(servitization)
def receiveZoneAlarm(deviceID, eventType, zoneID, zoneType, sensorType, descripton):
    mysql = Mysql()
    logging.info("Mysql instances for receiveZoneAlarm message:")
    flag = hasBuildingAndUnit(deviceID)
    if flag:
        ret = mysql.insertOne(
            "INSERT INTO `defense_alarm_record` SET `deviceID`='%s',`building`='%s',`unit`='%s',`room`='%s',`zoneID`=%d,`zoneType`=%d,`sensorType`=%d,`eventType`=%d,`description`='%s',`datetime`=%d" % (
                deviceID, deviceID[2:5], deviceID[5:7], deviceID[7:11], zoneID, zoneType, sensorType, eventType,
                descripton,
                int(time.time())))
        logging.info("Mysql insert success for receiveZoneAlarm message:")
        mysql.dispose()
        if ret:
            return True
        else:
            return False
    else:
        return False


# 接收模块报警服务(servitization)
def receiveModuleAlarm(deviceID, eventType, alarmType, descripton):
    mysql = Mysql()
    logging.info("Mysql instances for receiveModuleAlarm message:")
    flag = hasBuildingAndUnit(deviceID)
    if flag:
        ret = mysql.insertOne(
            "INSERT INTO `defense_alarm_record` SET `deviceID`='%s',`building`='%s',`unit`='%s',`room`='%s',`eventType`=%d,`alarmType`=%d,`description`='%s',`datetime`=%d" % (
                deviceID, deviceID[2:5], deviceID[5:7], deviceID[7:11], eventType, alarmType, descripton,
                int(time.time())))
        logging.info("Mysql insert success for receiveModuleAlarm message:")
        mysql.dispose()
        if ret:
            return True
        else:
            return False
    else:
        return False


# The callback for when a PUBLISH message is received from the server.
def on_message(client, userdata, msg):
    logging.info("on_message success message: " + msg.payload)
    raw_data = eval(msg.payload)
    if str(raw_data['eventType']) == "1":
        ret = receiveOneDeployment(str(raw_data['deviceID']).upper(), int(raw_data['eventType']),
                                   int(raw_data['zoneID']),
                                   int(raw_data['zoneType']), int(raw_data['sensorType']), str(raw_data['description']))
        if ret:
            for v in getOnlineTopics("Defense"):
                try:
                    client.publish(v['topic'], '{"cate":"defense","subcate":"single","eventType":1,"zoneID":' + str(
                        raw_data['zoneID']) + ',"alarmType":1,"zoneType":' + str(
                        raw_data['zoneType']) + ',"sensorType":' + str(
                        raw_data['sensorType']) + ',"description":"' + str(raw_data['description']) + '"}')
                except Exception as e:
                    logging.error("eventType 1:" + e.message)

    elif str(raw_data['eventType']) == "2":
        ret = receiveOneDeployment(str(raw_data['deviceID']).upper(), int(raw_data['eventType']),
                                   int(raw_data['zoneID']),
                                   int(raw_data['zoneType']), int(raw_data['sensorType']), str(raw_data['description']))
        if ret:
            for v in getOnlineTopics("Defense"):
                try:
                    client.publish(v['topic'], '{"cate":"defense","subcate":"single","eventType":2,"zoneID":' + str(
                        raw_data['zoneID']) + ',"alarmType":1,"zoneType":' + str(
                        raw_data['zoneType']) + ',"sensorType":' + str(
                        raw_data['sensorType']) + ',"description":"' + str(raw_data['description']) + '"}')
                except Exception as e:
                    logging.error("eventType 2:" + e.message)

    elif str(raw_data['eventType']) == "3":
        ret = receiveAllDeployment(str(raw_data['deviceID']).upper(), int(raw_data['eventType']))
        if ret:
            for v in getOnlineTopics("Defense"):
                try:
                    client.publish(v['topic'], '{"cate":"defense","subcate":"key","eventType":3}')
                except Exception as e:
                    logging.error("eventType 3:" + e.message)

    elif str(raw_data['eventType']) == "4":
        ret = receiveAllDeployment(str(raw_data['deviceID']).upper(), int(raw_data['eventType']))
        if ret:
            for v in getOnlineTopics("Defense"):
                try:
                    client.publish(v['topic'], '{"cate":"defense","subcate":"key","eventType":4}')
                except Exception as e:
                    logging.error("eventType 4:" + e.message)

    elif str(raw_data['eventType']) == "5":
        ret = receiveZoneAlarm(str(raw_data['deviceID']).upper(), int(raw_data['eventType']), int(raw_data['zoneID']),
                               int(raw_data['zoneType']), int(raw_data['sensorType']), str(raw_data['description']))
        if ret:
            for v in getOnlineTopics("Alarm"):
                try:
                    client.publish(v['topic'], '{"cate":"alarm","subcate":"zone","deviceID":"' + str(
                        raw_data['deviceID']).upper() + '","eventType":5,"zoneID":' + str(
                        raw_data['zoneID']) + ',"zoneType":' + str(raw_data['zoneType']) + ',"sensorType":' + str(
                        raw_data['sensorType']) + ',"description":"' + str(
                        raw_data['description']) + '","datetime":' + str(int(time.time())) + '}')
                except Exception as e:
                    logging.error("eventType 4:" + e.message)

    elif str(raw_data['eventType']) == "6":
        ret = receiveModuleAlarm(str(raw_data['deviceID']).upper(), int(raw_data['eventType']),
                                 int(raw_data['alarmType']),
                                 str(raw_data['description']))
        if ret:
            for v in getOnlineTopics("Alarm"):
                try:
                    client.publish(v['topic'], '{"cate":"alarm","subcate":"type","deviceID":"' + str(
                        raw_data['deviceID']).upper() + '","eventType":6,"alarmType":' + str(
                        raw_data['alarmType']) + ',"description":"' + str(
                        raw_data['description']) + '","datetime":' + str(int(time.time())) + '}')
                except Exception as e:
                    logging.error("eventType 6:" + e.message)


client = mqtt.Client(get_mac_address() + "?0000000000000")
client.on_connect = on_connect
client.on_message = on_message
client.connect("127.0.0.1", 1883, 60)
client.loop_forever()

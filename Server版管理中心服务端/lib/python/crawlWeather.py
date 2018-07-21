# -*- coding: utf-8 -*-
import json
import math
import re
import sys
import time
import urllib2
import smtplib
from email.mime.text import MIMEText
from email.header import Header

import MySQLdb

reload(sys)
sys.setdefaultencoding('utf-8')


def microtime(get_as_float=False):
    if get_as_float:
        return time.time()
    else:
        return '%f %d' % math.modf(time.time())


def _mtime():
    time_tmp = microtime().split(' ')
    time_float = str(time_tmp[1]) + str(float(time_tmp[0]) * 1000)

    return time_float.split('/')[0].split('.')[0]


def request_url(city_code, hdr, cookie, retries=5):
    request = urllib2.Request(
        url="http://tq.360.cn/api/weatherquery/querys?app=tq360&code=" + city_code + "&t=" + str(
            _mtime()) + "&c=" + str(
            int(
                int(_mtime()) + int(city_code))) + "&_jsonp=renderData&_=1429882481226",
        headers=hdr
    )
    request.add_header("Cookie", cookie)

    try:
        data = urllib2.urlopen(request).read()
    except Exception, ex:
        if retries > 0:
            return request_url(city_code=city_code, hdr=hdr, cookie=cookie, retries=retries - 1)
        else:
            print 'GET Failed'
            return ''
    return data


conn = MySQLdb.connect(host="127.0.0.1", user="root", passwd="root", db="management", charset="utf8")
cursor = conn.cursor()

cursor.execute("SELECT `location` from `configuration`")
results = eval(cursor.fetchone()[0])
city_code = str(results["citycode"])

cursor.execute("select * from city_info WHERE city_id='%s'" % (city_code))
city_name = str(cursor.fetchone()[3])

hdr = {
    'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.64 '
                  'Safari/537.11',
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
    'Accept-Charset': 'ISO-8859-1,utf-8;q=0.7,*;q=0.3',
    'Accept-Encoding': 'none',
    'Accept-Language': 'en-US,en;q=0.8',
    'Connection': 'keep-alive',
    'Refer': 'http://tq.360.cn/',
    'Host': 'tq.360.cn'
}

cookie = '__guid=156009789.3772326042686718500.1508810564607.229; ' \
         '__gid=156009789.717289807.1508810564607.1508810720702.4; citycode=' + city_code

request = urllib2.Request(
    url="http://tq.360.cn/api/weatherquery/querys?app=tq360&code=" + city_code + "&t=" + str(_mtime()) + "&c=" + str(
        int(
            int(_mtime()) + int(city_code))) + "&_jsonp=renderData&_=1429882481226",
    headers=hdr
)
request.add_header("Cookie", cookie)
rule = r'renderData\((.*)\}\)'

data = request_url(city_code, hdr, cookie, 50)
decode_json = json.loads(re.findall(rule, data)[0] + '}')
cursor.execute("DELETE FROM `message_weather`")
sql = "INSERT INTO `message_weather` SET `data_uptime`=%d,`weather`='%s'" % (
int(decode_json['realtime']['dataUptime']), MySQLdb.escape_string(re.findall(rule, data)[0] + '}'))
cursor.execute(sql)
conn.commit()

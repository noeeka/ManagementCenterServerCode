# -*- coding: utf-8 -*-
import datetime
import hashlib
import io
import json
import sys
import time
import urllib
import urllib2
import requests
import MySQLdb
import feedparser

reload(sys)
sys.setdefaultencoding('utf-8')
conn = MySQLdb.connect(host="127.0.0.1", user="root", passwd="root", db="management", charset="utf8")
cursor = conn.cursor()
cursor.execute("SELECT count(*) as cnt FROM `message_news`")
results_ori = int(cursor.fetchone()[0])
cursor.execute("SELECT * FROM `configuration`")
results_config_news = cursor.fetchone()[3]
site = json.loads(results_config_news)['newsid']
cate = json.loads(results_config_news)['newsname']
hdr = {
    'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.64 Safari/537.11',
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
    'Accept-Charset': 'ISO-8859-1,utf-8;q=0.7,*;q=0.3',
    'Accept-Encoding': 'none',
    'Accept-Language': 'en-US,en;q=0.8',
    'Connection': 'keep-alive'
}
cursor.execute("TRUNCATE `message_news`")
conn.commit()
try:
    web_page = requests.get(site, timeout=20)
except:
    print('{"state":3,"ret":"timeout"}')
    sys.exit()
content = web_page.content.strip()
d = feedparser.parse(content)
if (type(d) == type('null')):
    if (d == 'null'):
        print('{"state":0,"ret":"this source has problem"}')
        cursor.execute("TRUNCATE `message_news`")
        conn.commit()
        sys.exit()

    if (d == ""):
        print('{"state":2,"ret":"this source items less than 10"}')
        cursor.execute("TRUNCATE `message_news`")
        conn.commit()
        sys.exit()

for a in d["items"]:
    cateid = MySQLdb.escape_string("T1467284926140")
    cate = MySQLdb.escape_string("News")
    m2 = hashlib.md5()
    m2.update(a['link'])
    docid = MySQLdb.escape_string(m2.hexdigest())
    digest = MySQLdb.escape_string(a['summary_detail']['value'])

    imgsrc = MySQLdb.escape_string(a['link'])
    mtime = MySQLdb.escape_string(a['published'])
    source = MySQLdb.escape_string(imgsrc)
    title = MySQLdb.escape_string(a['title'])
    url = imgsrc
    datetime = int(time.time())
    sql = "INSERT INTO message_news SET cateid='%s',cate='%s',docid='%s',digest='%s',imgsrc='%s',mtime='%s',source='%s', title='%s',url='%s',datetime=%d" % (
        cateid, cate, docid, digest, imgsrc, mtime, source, title, url, datetime)
    cursor.execute(sql)
    conn.commit()
print('{"state":1,"ret":"ok"}')
sys.exit()

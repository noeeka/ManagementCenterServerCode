#!/usr/bin/env python
# -*- coding: utf-8 -*-
import logging
import datetime
import sys

'''
create time :2018-03-22
author      :Paul
description : python logging
modify author:
description :
'''
class Logging():
    def __init__(self):
        pass
    def __del__():#显示析构函数
        pass #del object

    @staticmethod
    def writeLog(msg):
        logger = logging.getLogger(__name__)
        logger.setLevel(level = logging.INFO)
        handler = logging.FileHandler("/home/wwwroot/default/log.txt")
        handler.setLevel(logging.INFO)
        formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
        handler.setFormatter(formatter)
        logger.addHandler(handler)
       
        logger.debug("Do something")
        #logger.warning("Something maybe fail.")
        #logger.info("Finish")
        #pass
    @staticmethod
    def debug(msg):
       Logging.writeLog(msg)

    @staticmethod
    def info(msg):
        print "--------"+msg
        Logging.writeLog(msg)

    @staticmethod
    def warn(msg):
        Logging.writeLog(msg)
        

    @staticmethod
    def error(msg):
        Logging.writeLog(msg) 

    @staticmethod
    def fatal(msg):
        Logging.writeLog(msg)


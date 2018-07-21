#! /usr/bin/env python
# -*- coding: utf-8 -*-
import logging,os
import datetime

'''
create time :2018-03-22
author      :Paul
description : python logger
modify author:
description :
'''
class Logger:

 def __init__(self, path,clevel = logging.DEBUG,Flevel = logging.DEBUG):
  self.logger = logging.getLogger(path)
  self.logger.setLevel(logging.DEBUG)
  fmt = logging.Formatter('[%(asctime)s] [%(levelname)s] %(message)s', '%Y-%m-%d %H:%M:%S')
  #设置CMD日志
  sh = logging.StreamHandler()
  sh.setFormatter(fmt)
  sh.setLevel(clevel)
  #设置文件日志
  fh = logging.FileHandler(path)
  fh.setFormatter(fmt)
  fh.setLevel(Flevel)
  self.logger.addHandler(sh)
  self.logger.addHandler(fh)
 

 def debug(self,message):
  self.logger.debug(message)
 
 def info(self,message):
  self.logger.info(message)
 
 def warn(self,message):
  self.logger.warn(message)
 
 def error(self,message):
  self.logger.error(message)
 
 def fatal(self,message):
  self.logger.fatal(message)




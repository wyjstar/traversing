#coding: utf-8
'''
Created on 2015-5-2

@author: hack
'''
from gfirefly.utils.singleton import Singleton

class PushMessage(object):
    def __init__(self):
        self.send_time = None
        self.message = None
        self.uid = None
        self.msg_type = None
        

class Pusher(object):
    __metaclass__ = Singleton
    def __init__(self):
        self.register = {} #key:uid, value:deviceToken
        self.to_push = []
        
    def add_task(self):
# coding:utf8
'''
Created on 2014-2-23

@author: lan (www.9miao.com)
'''
from shared.utils.const import const
import time

class Connection(object):
    '''
    '''

    def __init__(self, _conn):
        ''' transport 连接的通道'''
        self.instance = _conn
        self.last_heart_beat_time = 0
        self.set_time()

    def loseConnection(self):
        '''断开与客户端的连接
        '''
        self.instance.transport.close()

    def safeToWriteData(self, topicID, msg):
        """发送消息
        """
        self.instance.safeToWriteData(msg, topicID)

    @property
    def dynamic_id(self):
        return self.instance.transport.sessionno

    @dynamic_id.setter
    def dynamic_id(self, value):
        self.instance.transport.sessionno = value

    @property
    def ipaddress(self):
        return self.instance.transport.getAddress()[0]

    @property
    def time_out(self):
        """判断链接是否过期"""
        if time.time() - self.last_heart_beat_time > const.TIME_OUT:
            return True
        return False

    def set_time(self):
        """设置当前时间为上次心跳时间"""
        self.last_heart_beat_time = time.time()

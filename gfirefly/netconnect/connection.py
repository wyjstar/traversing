# coding:utf8
'''
Created on 2014-2-23

@author: lan (www.9miao.com)
'''


class Connection:
    '''
    '''

    def __init__(self, _conn):
        ''' transport 连接的通道'''
        self.instance = _conn

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
        print '-=-'*6, self.instance.transport.sessionno
        self.instance.transport.sessionno = value
        print '-=-'*6, self.instance.transport.sessionno

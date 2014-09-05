# coding:utf8
'''
Created on 2014-2-23
连接管理器
@author: lan (www.9miao.com)
'''

from gtwisted.utils import log
from connection import Connection
from shared.utils.const import const
import collections


class ConnectionManager:
    ''' 连接管理器
    @param _connections: dict {connID:conn Object}管理的所有连接
    '''

    def __init__(self):
        '''初始化
        @param _connections: dict {connID:conn Object}
        '''
        self._connections = {}
        self._queue_conns = collections.OrderedDict()

    def getNowConnCnt(self):
        '''获取当前连接数量'''
        return len(self._connections.items())

    @property
    def queue_num(self):
        return len(self._queue_conns)

    @property
    def connect_ids(self):
        print "_connections", self._connections
        print "_queue_conns", self._queue_conns.keys()
        return self._connections.keys()

    def hasConnection(self, dynamic_id):
        """是否包含连接"""
        print self._connections.keys()
        return dynamic_id in self._connections.keys()

    def addConnection(self, conn):
        '''加入一条连接
        @param _conn: Conn object
        '''

        _conn = Connection(conn)
        if self._connections.has_key(_conn.dynamic_id):
            raise Exception("系统记录冲突")

        # 连接数达到上限，将连接缓存到队列中
        if const.MAX_CONNECTION <= len(self._connections):
            self._queue_conns[_conn.dynamic_id] = _conn
            return

        self._connections[_conn.dynamic_id] = _conn

    def dropConnectionByID(self, connID):
        '''更加连接的id删除连接实例
        @param connID: int 连接的id
        '''
        try:
            del self._connections[connID]
        except Exception as e:
            log.msg(str(e))

    def getConnectionByID(self, connID):
        """根据ID获取一条连接
        @param connID: int 连接的id
        """
        return self._connections.get(connID, None)

    def loseConnection(self, connID):
        """根据连接ID主动端口与客户端的连接
        """
        conn = self.getConnectionByID(connID)
        if conn:
            conn.loseConnection()

    def change_id(self, new_id, cur_id):
        connection = self._connections[cur_id]
        if not connection:
            return False

        if new_id in self._connections:
            old_connection = self._connections[new_id]
            old_connection.loseConnection()
            old_connection.dynamic_id = 0

        del self._connections[cur_id]
        self._connections[new_id] = connection
        connection.dynamic_id = new_id
        return True

    def pop_queue(self):
        print "pop"
        if len(self._queue_conns) <= 0:
            return
        tmp = self._queue_conns.popitem(False)
        self._connections[tmp[0]] = tmp[1]
        return tmp[1]

    def pushObject(self, topicID, msg, sendList):
        """主动推送消息
        """
        try:
            for target in sendList:
                conn = self.getConnectionByID(target)
                if conn:
                    print "normal conn:", topicID, msg
                    conn.safeToWriteData(topicID, msg)
                conn = self._queue_conns.get(target, None)
                if conn:
                    print "queue conn:", topicID, msg
                    conn.safeToWriteData(topicID, msg)
        except Exception, e:
            print 'topic id:', topicID, '**', sendList
            log.err(str(e))

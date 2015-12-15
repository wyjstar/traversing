# coding:utf8
"""
Created on 2014-2-23
连接管理器
@author: lan (www.9miao.com)
"""
# from gfirefly.server.globalobject import GlobalObject
from app.proto_file.account_pb2 import AccountKick
from gfirefly.server.logobj import logger
from connection import Connection
from shared.utils.const import const
import traceback
import collections
import gevent
# import errno


class ConnectionManager:
    """ 连接管理器
    @param _connections: dict {connID:conn Object}管理的所有连接
    """

    def __init__(self):
        """初始化
        @param _connections: dict {connID:conn Object}
        """
        self._connections = {}
        self._queue_conns = collections.OrderedDict()
        self.loop_check()

    def getNowConnCnt(self):
        """获取当前连接数量"""
        return len(self._connections.items())

    @property
    def queue_num(self):
        return len(self._queue_conns)

    @property
    def connect_ids(self):
        return self._connections.keys()

    def hasConnection(self, dynamic_id):
        """是否包含连接"""
        return dynamic_id in self._connections.keys()

    def addConnection(self, conn):
        """加入一条连接
        @param _conn: Conn object
        """
        _conn = Connection(conn)
        if _conn.dynamic_id in self._connections:
            raise Exception("系统记录冲突")

        # 连接数达到上限，将连接缓存到队列中
        if const.MAX_CONNECTION <= len(self._connections):
            self._queue_conns[_conn.dynamic_id] = _conn
            return

        self._connections[_conn.dynamic_id] = _conn

    def dropConnectionByID(self, connID):
        """更加连接的id删除连接实例
        @param connID: int 连接的id
        """
        if connID in self._connections:
            del self._connections[connID]
        if connID in self._queue_conns:
            del self._queue_conns[connID]

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
        logger.debug("change_id %s>>>>>>%s", cur_id, new_id)
        if cur_id not in self._connections:
            logger.debug("change_id error %s>>>>>>%s", cur_id, new_id)
            return False

        connection = self._connections[cur_id]
        if new_id in self._connections:
            old_connection = self._connections[new_id]
            msg = AccountKick()
            msg.id = 1
            self.__write_data(old_connection, 11, msg.SerializeToString())
            old_connection.loseConnection()
            old_connection.dynamic_id = 0

        del self._connections[cur_id]
        self._connections[new_id] = connection
        connection.dynamic_id = new_id
        return True

    def kick(self, msg, pid):
        logger.debug("kick>>>%s", pid)
        if pid not in self._connections:
            logger.error("kick err>>>%s", pid)
            return False

        old_connection = self._connections[pid]
        self.__write_data(old_connection, 11, msg)
        old_connection.loseConnection()
        old_connection.dynamic_id = 0

        del self._connections[pid]
        return True

    def get_ipaddress(self, pid):
        if pid not in self._connections:
            logger.error("kick err>>>%s", pid)
            return None

        connection = self._connections[pid]
        return connection.ipaddress

    def pop_queue(self):
        if len(self._queue_conns) <= 0:
            return
        tmp = self._queue_conns.popitem(False)
        self._connections[tmp[0]] = tmp[1]
        return tmp[1]

    def _write_data(self, connection_id, topic_id, msg):
        connection = self.getConnectionByID(connection_id)
        if not connection:
            logger.error('cant not find :%s--%s', connection_id, topic_id)
            return
        self.__write_data(connection, topic_id, msg)

    def __write_data(self, connection, topic_id, msg):
        # connection_id = connection.dynamic_id
        try:
            connection.safeToWriteData(topic_id, msg)
        except Exception, e:
            logger.exception(e)
            e = "%s, %s:%s" % (e, topic_id, msg)
            logger.error(e)
            # self.dropConnectionByID(connection_id)
            # dynamic_id = connection.transport.sessionno
            # if dynamic_id != 0:
            #     remote_gate = GlobalObject().remote['gate']
            #     remote_gate.net_conn_lost_remote_noresult(connection_id)
        except IOError as e:
            logger.error(e)
            # if e.errno == errno.EPIPE:
            #     pass
        except:
            logger.error(traceback.format_exc())

    def pushObject(self, topicID, msg, sendList):
        """主动推送消息"""
        if isinstance(sendList, list):
            for target in sendList:
                self._write_data(target, topicID, msg)
        else:
            self._write_data(sendList, topicID, msg)

    def pushAllObject(self, topic_id, msg):
        """
        向所有连接推送消息。
        """
        for connection in self._connections.values():
            if not connection:
                continue
            self.__write_data(connection, topic_id, msg)

    def check_timeout(self):
        for k, v in self._connections.items():
            if v.time_out:
                logger.error('closing one connection which without heart%s', k)
                v.loseConnection()

    def loop_check(self):
        loop = gevent.get_hub().loop
        t = loop.timer(0.0, const.TIME_OUT / 4)
        t.start(self.check_timeout)

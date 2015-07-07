# coding:utf8
"""
Created on 2013-8-14
分布式根节点
@author: lan (www.9miao.com)
"""
from gfirefly.server.logobj import logger
from gfirefly.server.globalobject import GlobalObject
from gtwisted.core import rpc
from manager import ChildsManager
from child import Child


class BilateralBroker(rpc.PBServerProtocl):
    def connectionLost(self, reason):
        clientID = self.transport.sessionno
        logger.info("node [%d] lose" % clientID)
        self.factory.root.dropChildSessionId(clientID)

    def remote_takeProxy(self, name):
        """设置代理通道
        @param name: 根节点的名称
        """
        self.factory.root.remote_takeProxy(name, self)

    def remote_transit(self, node, command, *arg, **kw):
        _node = GlobalObject().remote.get(node)
        if _node:
            return _node.__getattr__(command)(*arg, **kw)
        _node = GlobalObject().child(node)
        if _node:
            return _node.__getattr__(command)(*arg, **kw)
        logger.error('remote_transit:%s-%s', node, command)
        return None

    def remote_callTarget(self, command, *args, **kw):
        """远程调用方法
        @param commandId: int 指令号
        @param data: str 调用参数
        """
        data = self.factory.root.remote_callTarget(command, *args, **kw)
        return data


class BilateralFactory(rpc.PBServerFactory):
    protocol = BilateralBroker

    def __init__(self, root):
        rpc.PBServerFactory.__init__(self)
        self.root = root


class PBRoot:
    """PB 协议
    """

    def __init__(self, dnsmanager=ChildsManager()):
        """初始化根节点"""
        self._index = 1
        self.service = None
        self.childsmanager = dnsmanager

    def child(self, key):
        return self.childsmanager.child(key)

    def addServiceChannel(self, service):
        """添加服务通道
        @param service: Service Object(In bilateral.services)
        """
        self.service = service

    def remote_takeProxy(self, name, transport):
        """设置代理通道
        @param name: 根节点的名称
        """
        logger.info('>1 node [%s] takeProxy ready' % name)
        child = Child(self._index, name)
        self._index += 1
        self.childsmanager.addChild(child)
        child.setTransport(transport)
        self.doChildConnect(name, transport)
        logger.info('>2 node [%s] takeProxy ready' % name)

    @property
    def childsmanager(self):
        return self.childsmanager

    def doChildConnect(self, name, transport):
        """当node节点连接时的处理
        """
        pass

    def remote_callTarget(self, command, *args, **kw):
        """远程调用方法
        @param commandId: int 指令号
        @param data: str 调用参数
        """
        data = self.service.callTarget(command, *args, **kw)
        return data

    def dropChild(self, *args, **kw):
        """删除子节点记录"""
        self.childsmanager.dropChild(*args, **kw)

    def dropChildByID(self, childId):
        """删除子节点记录"""
        self.doChildLostConnect(childId)
        self.childsmanager.dropChildByID(childId)

    def dropChildSessionId(self, session_id):
        """删除子节点记录"""
        child = self.childsmanager.getChildBYSessionId(session_id)
        if not child:
            return
        child_id = child._id
        self.doChildLostConnect(child_id)
        self.childsmanager.dropChildByID(child_id)

    def doChildLostConnect(self, childId):
        """当node节点连接时的处理"""
        pass

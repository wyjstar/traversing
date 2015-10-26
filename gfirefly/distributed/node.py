# coding:utf8
"""
Created on 2013-8-14

@author: lan (www.9miao.com)
"""
from gtwisted.core import rpc
from gtwisted.core import reactor

reactor = reactor
from reference import ProxyReference


class BilateralClientProtocol(rpc.PBClientProtocl):
    def setProxyReference(self, pr):
        """设置代理接口提供对象 """
        self.reference = pr

    def getRemoteMethod(self, _name):
        """重写获取接口对象的方法，从代理接口提供对象中获取 """
        method = getattr(self.reference, "remote_%s" % _name)
        return method


class BilateralClientFactory(rpc.PBClientFactory):
    protocol = BilateralClientProtocol


class RemoteObject(object):
    """远程调用对象"""

    def __init__(self, name, timeout=600):
        """初始化远程调用对象
        @param port: int 远程分布服的端口号
        @param rootaddr: 根节点服务器地址
        """
        self._name = name
        self._factory = BilateralClientFactory()
        self._reference = ProxyReference()
        self._addr = None
        self._timeout = timeout

    def __getattr__(self, fun):
        class RpcFunctionWrapper:
            def __init__(self, fun, handle):
                self._fun = fun
                self._handle = handle

            def __call__(self, *arg):
                if not self._handle:
                    return False
                return self._handle('callTarget', self._fun, *arg)

        deferedRemote = self._factory.getRootObject(timeout=self._timeout)
        if not deferedRemote:
            return RpcFunctionWrapper(fun, None)

        if fun.endswith('remote'):
            return RpcFunctionWrapper(fun, deferedRemote.callRemoteForResult)

        if fun.endswith('remote_noresult'):
            return RpcFunctionWrapper(fun,
                                      deferedRemote.callRemoteNotForResult)

        raise Exception('error rpc name, must endwith <remote>:%s' % fun)
        return None

    def __getitem__(self, node):
        class NodeWrapper:
            def __init__(self, node, handle):
                self._handle = handle
                self._node = node

            def __getattr__(self, fun):
                class RpcFunctionWrapper:
                    def __init__(self, node, fun, handle):
                        self._fun = fun
                        self._node = node
                        self._handle = handle

                    def __call__(self, *arg):
                        if not self._handle:
                            return False
                        return self._handle('transit',
                                            self._node,
                                            self._fun, *arg)

                if fun.endswith('remote'):
                    return RpcFunctionWrapper(self._node,
                                              fun,
                                              self._handle.callRemoteForResult)

                if fun.endswith('remote_noresult'):
                    return RpcFunctionWrapper(self._node,
                                              fun,
                                              self._handle.callRemoteNotForResult)

        deferedRemote = self._factory.getRootObject(timeout=self._timeout)
        return NodeWrapper(node, deferedRemote)

    def setName(self, name):
        """设置节点的名称"""
        self._name = name

    def getName(self):
        """获取节点的名称"""
        return self._name

    def connect(self, addr):
        """初始化远程调用对象"""
        self._addr = addr
        reactor.connectTCP(addr[0], addr[1], self._factory)
        self.takeProxy()


    def reconnect(self, addr=()):
        """重新连接"""
        if addr:
            self.connect(addr)
        else:
            self.connect(self._addr)

    def addServiceChannel(self, service):
        """设置引用对象"""
        self._reference.addService(service)

    def takeProxy(self):
        """像远程服务端发送代理通道对象 """
        self._factory._protocol.setProxyReference(self._reference)
        deferedRemote = self._factory.getRootObject(timeout=self._timeout)
        deferedRemote.callRemoteNotForResult('takeProxy', self._name)

    def is_connected(self):
        deferedRemote = self._factory.getRootObject(timeout=self._timeout)
        if deferedRemote.broker:
            return True
        else:
            return False

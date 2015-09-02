# coding:utf8
"""
Created on 2013-8-14

@author: lan (www.9miao.com)
"""


class Child(object):
    """子节点对象"""

    def __init__(self, cid, name):
        """初始化子节点对象"""
        self._id = cid
        self._name = name
        self._transport = None

    @property
    def name(self):
        return self._name

    @property
    def id(self):
        return self._id

    def __getattr__(self, fun):
        class RpcFunctionWrapper:
            def __init__(self, fun, handle):
                self._fun = fun
                self._handle = handle

            def __call__(self, *arg, **kw):
                if not self._handle:
                    return False
                return self._handle('callChild', self._fun, *arg, **kw)

        remote = self._transport.getRootObject()
        if not remote:
            return RpcFunctionWrapper(fun, None)

        if fun.endswith('remote'):
            return RpcFunctionWrapper(fun, remote.callRemoteForResult)

        if fun.endswith('remote_noresult'):
            return RpcFunctionWrapper(fun, remote.callRemoteNotForResult)

        raise Exception('error rpc child, must endwith <remote>:%s' % fun)
        return None

    def setTransport(self, transport):
        """设置子节点的通道"""
        self._transport = transport

    def get_remote(self):
        return self._transport.getRootObject()

    def callbackChild(self, *args, **kw):
        """回调子节点的接口\n
        return a Defered Object (recvdata)
        """
        return self.callbackChildForResult(*args, **kw)

    def callbackChildNotForResult(self, *args, **kw):
        """回调子节点的接口\n
        return a Defered Object (recvdata)
        """
        remote = self._transport.getRootObject()
        remote.callRemoteNotForResult('callChild', *args, **kw)

    def callbackChildForResult(self, *args, **kw):
        """回调子节点的接口\n
        return a Defered Object (recvdata)
        """
        remote = self._transport.getRootObject()
        recvdata = remote.callRemoteForResult('callChild', *args, **kw)
        return recvdata

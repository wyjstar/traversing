# coding:utf8
"""
Created on 2013-8-14

@author: lan (www.9miao.com)
"""
from gfirefly.server.logobj import logger


class ChildsManager(object):
    """子节点管理器"""

    def __init__(self):
        """初始化子节点管理器"""
        self._childs = {}

    @property
    def childs(self):
        return self._childs

    def child(self, key):
        if isinstance(key, int):
            return self._childs.get(key)
        elif isinstance(key, str):
            for k, child in self._childs.items():
                if child.name == key:
                    return self._childs[k]
            raise Exception("child key error name:%s" % key)
        else:
            raise Exception("child key error type:%s" % type(key))

    def addChild(self, child):
        """添加一个child节点\n
        @param child: Child object
        """
        key = child._id
        if key in self._childs:
            raise Exception("child node %s exists" % key)
        self._childs[key] = child

    def dropChild(self, child):
        """删除一个child 节点\n
        @param child: Child Object
        """
        key = child._id
        try:
            del self._childs[key]
        except Exception, e:
            logger.info(str(e))

    def dropChildByID(self, childId):
        """删除一个child 节点\n
        @param childId: Child ID
        """
        try:
            del self._childs[childId]
        except Exception, e:
            logger.info(str(e))

    def callChild(self, childId, *args, **kw):
        """调用子节点的接口\n
        @param childId: int 子节点的id
        """
        child = self._childs.get(childId, None)
        if not child:
            logger.error("child %s doesn't exists" % childId)
            return
        return child.callbackChild(*args, **kw)

    def callChildNotForResult(self, childId, *args, **kw):
        """调用子节点的接口\n
        @param childId: int 子节点的id
        """
        child = self._childs.get(childId, None)
        if not child:
            logger.error("child %s doesn't exists" % childId)
            return
        child.callbackChildNotForResult(*args, **kw)

    def callChildByName(self, childname, *args, **kw):
        """调用子节点的接口\n
        @param childname: str 子节点的名称
        """
        child = self.child(childname)
        if not child:
            logger.error("child %s doesn't exists" % childname)
            return
        return child.callbackChild(*args, **kw)

    def callChildByNameNotForResult(self, childname, *args, **kw):
        """调用子节点的接口\n
        @param childId: int 子节点的id
        """
        child = self.child(childname)
        if not child:
            logger.error("child %s doesn't exists" % childname)
            return
        child.callbackChildNotForResult(*args, **kw)

    def getChildBYSessionId(self, session_id):
        """根据sessionID获取child节点信息
        """
        for child in self._childs.values():
            if child._transport.transport.sessionno == session_id:
                return child
        return None

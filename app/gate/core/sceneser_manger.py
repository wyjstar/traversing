# coding:utf8
"""
Created on 2012-3-19
场景服务器管理者
@author: Administrator
"""
from gfirefly.utils.singleton import Singleton
from gfirefly.server.logobj import logger
from gfirefly.server.globalobject import GlobalObject


UP = 20  # 每个场景服承载的角色上限


class SceneSer:

    def __init__(self, sceneid):
        self.id = sceneid
        self._clients = set()

    def add_client(self, clientid):
        """添加一个客户端到场景服务器"""
        self._clients.add(clientid)

    def drop_client(self, clientid):
        """移除一个客户端"""
        self._clients.remove(clientid)

    def get_client_count(self):
        """获取场景中的客户端数量"""
        return len(self._clients)


class SceneSerManager:

    __metaclass__ = Singleton

    def __init__(self):
        """初始化"""
        self._scenesers = {}
        self.init_scene()

    def init_scene(self):
        print("scene %s" % GlobalObject().root.childsmanager._childs.values())
        for child in GlobalObject().root.childsmanager._childs.values():
            if "game" in child.name:
                self.add_scene(child.id)

    def add_scene(self, sceneid):
        """添加一个场景服务器"""
        sceneser = SceneSer(sceneid)
        self._scenesers[sceneser.id] = sceneser
        return sceneser

    def get_scene_by_id(self, sceneid):
        """返回场景服务的实例"""
        sceneser = self._scenesers.get(sceneid)
        if not sceneser:
            sceneser = self.add_scene(sceneid)
        return sceneser

    def add_client(self, sceneid, clientid):
        """添加一个客户端"""
        sceneser = self.get_scene_by_id(sceneid)
        if not sceneser:
            return False
        sceneser.add_client(clientid)
        return True

    def drop_client(self, sceneid, clientid):
        """清除一个客户端"""
        sceneser = self.get_scene_by_id(sceneid)

        if sceneser:
            try:
                sceneser.drop_client(clientid)
            except Exception as e:
                msg = "sceneId:%d-------clientId:%d" % (sceneid, clientid)
                logger.error(msg)
                logger.error(e.message)

    def get_all_client_count(self):
        """获取公共场景中所有的客户端数量"""
        return sum([ser.get_client_count() for ser in self._scenesers])

    def get_best_sceneid(self):
        """获取最佳的game服务器
        """
        for child in GlobalObject().root.childsmanager._childs.values():
            if "game" in child.name and child.id not in self._scenesers:
                self.add_scene(child.id)

        serverlist = self._scenesers.values()
        print("serverlist: %s" % serverlist)
        slist = sorted(serverlist, reverse=False, key=lambda ser: ser.get_client_count())
        if slist:
            return slist[0].id

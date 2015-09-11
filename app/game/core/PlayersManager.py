#-*- coding:utf-8 -*-
"""
created by server on 14-5-27下午5:21.
"""
from gfirefly.utils.singleton import Singleton


class PlayersManager:
    """在线角色单例管理器
    """

    __metaclass__ = Singleton

    def __init__(self):
        """初始化单例管理器
        """
        self._players = {}  # {'id': player obj}

    def get_all(self):
        """ 取得全部角色
        @return: list
        """
        all_list = self._players.values()
        return all_list

    def add_player(self, player):
        """添加一个在线角色
        @param player:
        @return:
        """
        if player.base_info.id in self._players:
            #raise Exception("系统记录冲突")
            return
        self._players[player.base_info.id] = player

    def get_player_by_id(self, pid):
        """根据角色id获取玩家角色实例
        """
        return self._players.get(pid, None)

    def get_player_by_dynamic_id(self, dynamic_id):
        """根据角色动态id获取玩家角色实例
        @dynamicId （int） 角色动态id
        """
        for player in self._players.values():
            if player.dynamic_id == dynamic_id:
                return player
        return None

    def get_player_by_nickname(self, nickname):
        """根据角色昵称获取玩家角色实例
        @nickname （str） 角色昵称
        """
        for k in self._players.values():
            if k.base_info.get_nickname == nickname:
                return k
        return None

    def drop_player(self, player):
        """移除在线角色
        @player （PlayerCharacter）角色实例
        """
        player_id = player.base_info.id
        self.drop_player_by_id(player_id)

    def drop_player_by_id(self, pid):
        """移除在线角色
        @id （int） 角色id
        """
        try:
            del self._players[pid]
        except:
            pass

    def is_player_online(self, pid):
        """判断角色是否在线
        """
        return pid in self._players

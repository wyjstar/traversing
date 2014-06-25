# -*- coding:utf-8 -*-
"""
created by server on 14-6-4下午3:04.
"""
from gtwisted.utils import log
from app.game.core.character.Character import Character
from app.game.redis_mode import tb_character_info
from shared.utils.const import const


class PlayerCharacter(Character):
    """玩家角色类
    """

    def __init__(self, cid, name=u'MLGB', dynamic_id=-1, status=1):
        """构造方法
        @dynamic_id （int） 角色登陆的动态ID socket连接产生的id
        """
        Character.__init__(self, cid, name)

        self.character_type = const.PLAYER_TYPE  # 设置角色类型为玩家角色
        self.dynamic_id = dynamic_id   # 角色登陆服务器时的动态id
        #--------角色的各个组件类------------
        # TODO

        if status:
            self.__init_player_info()  #初始化角色

    def __init_player_info(self):
        """初始化角色信息
        """
        pid = self.base_info.id
        print pid
        data = tb_character_info.getObjData(pid)
        if not data:
            log.msg("Inint_player _" + str(self.baseInfo.id))
        #------------初始化角色基础信息组件---------
        log.msg(data)
        print data['nickname']
        a = data['nickname']
        self.base_info.base_name = a

        print '11111111111'
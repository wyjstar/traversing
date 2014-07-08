# -*- coding:utf-8 -*-
"""
created by server on 14-6-4下午3:04.
"""
from app.game.component.character_line_up import CharacterLineUpComponent
from app.game.component.equipment.character_equipment_chip import CharacterEquipmentChipComponent
from app.game.component.pack.character_equipment_package import CharacterEquipmentPackageComponent
from app.game.component.pack.character_item_package import CharacterItemPackageComponent
from gtwisted.utils import log
from app.game.core.character.Character import Character
from app.game.core.hero import Hero
from app.game.core.hero_chip import HeroChip
from app.game.redis_mode import tb_character_info, tb_character_hero_chip
from shared.utils.const import const
from app.game.component.character_herolist import CharacterHeroListComponent
from app.game.component.character_fiance_component import CharacterFinanceComponent
from app.game.component.character_hero_chip import CharacterHeroChipComponent
import json


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

        self._hero_list = CharacterHeroListComponent(self)  # 武将列表
        self._finance = CharacterFinanceComponent(self)  # 金币
        self._hero_chip_list = CharacterHeroChipComponent(self)  # 武将碎片
        self._item_package = CharacterItemPackageComponent(self)  # 游戏道具背包
        self._line_up = CharacterLineUpComponent(self)  # 阵容
        #self._equipment = CharacterEquipmentPackageComponent(self)  # 装备
        #self._equipment_chip = CharacterEquipmentChipComponent(self)  # 装备碎片

        self._mmode = None

        if status:
            self.__init_player_info()  # 初始化角色

    def __init_player_info(self):
        """初始化角色信息
        """
        pid = self.base_info.id
        character_mmode = tb_character_info.getObj(pid)
        if not character_mmode:
            log.err("初始化玩家角色出错,mmode==None！")
        # if not data:
        #     log.msg("Init_player %s error!" + str(self.base_info.id))
        #     return
        #------------初始化角色基础信息组件---------

        self.base_info.base_name = character_mmode.get('data').get('nickname')  #初始化基本信息
        self._hero_list.init_hero_list(pid)  # 初始化武将列表
        self._item_package.init_data()
        self._line_up.init_data()
        #self._equipment.init_data()
        #self._equipment_chip.init_data()

        return
        self.finance.init_data(character_mmode)  #初始化金币
        self._hero_chip_list.init_hero_chip_list(pid)  #初始化武将碎片

    @property
    def hero_list(self):
        return self._hero_list

    @hero_list.setter
    def hero_list(self, value):
        self._hero_list = value

    @property
    def finance(self):
        return self._finance

    @finance.setter
    def finance(self, value):
        self._finance = value

    @property
    def hero_chip_list(self):
        return self._hero_chip_list

    @hero_chip_list.setter
    def hero_chip_list(self, value):
        self._hero_chip_list = value

    @property
    def item_package(self):
        return self._item_package

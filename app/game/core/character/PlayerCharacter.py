# -*- coding:utf-8 -*-
"""
created by server on 14-6-4下午3:04.
"""
from app.game.redis_mode import tb_character_info
from app.game import component


class PlayerCharacter(object):
    """玩家角色类
    """

    def __init__(self, pid, name=u'MLGB', dynamic_id=-1, status=1):
        """构造方法
        @dynamic_id （int） 角色登陆的动态ID socket连接产生的id
        """
        self._pid = pid
        self._dynamic_id = dynamic_id  # 角色登陆服务器时的动态id
        self._components = {}

        # --------角色的各个组件类------------
        self._base_info = component.CharacterBaseInfoComponent(self)
        self._hero_component = component.CharacterHerosComponent(self)  # 武将列表
        self._finance = component.CharacterFinanceComponent(self)  # 金币
        self._hero_chip_component = component.CharacterHeroChipsComponent(self)  # 武将碎片
        self._item_package = component.CharacterItemPackageComponent(self)  # 游戏道具背包
        self._equipment = component.CharacterEquipmentPackageComponent(self)  # 装备
        self._equipment_chip = component.CharacterEquipmentChipComponent(self)  # 装备碎片
        self._line_up = component.CharacterLineUpComponent(self)  # 阵容
        self._stage = component.CharacterStageComponent(self)  # 关卡
        self._last_pick_time = component.CharacterLastPickTimeComponent(self)  # 上次抽取时间

        self._fight_cache = component.CharacterFightCacheComponent(self)  # 关卡战斗缓存
        self._friends = component.FriendComponent(self)  # friend system
        self._guild = component.CharacterGuildComponent(self)  # 公会组件
        self._mail = component.CharacterMailComponent(self)  # 邮箱组件
        self._sign_in = component.CharacterSignInComponent(self)  # 签到组件
        self._feast = component.CharacterFeastComponent(self)
        self._online_gift = component.CharacterOnlineGift(self)  # online gift
        self._level_gift = component.CharacterLevelGift(self)  # level gift
        self._login_gift = component.CharacterLoginGiftComponent(self)  # Login gift
        self._world_boss = component.CharacterWorldBoss(self)  # world boss

        self._stamina = component.CharacterStaminaComponent(self)  # 体力
        self._shop = component.CharacterShopComponent(self)  # 商店
        self._brew = component.CharacterBrewComponent(self)

        self._tasks = component.UserAchievement(self)
        self._mine = component.UserMine(self)
        self._stone = component.UserStone(self)

        self._travel = component.CharacterTravelComponent(self)
        self._runt = component.CharacterRuntComponent(self)

        self._components['base_info'] = self._base_info
        self._components['hero_component'] = self._hero_component
        self._components['finance'] = self._finance
        self._components['hero_chip_component'] = self._hero_chip_component
        self._components['item_package'] = self._item_package
        self._components['equipment'] = self._equipment
        self._components['equipment_chip'] = self._equipment_chip
        self._components['line_up'] = self._line_up
        self._components['stage'] = self._stage
        self._components['last_pick_time'] = self._last_pick_time
        self._components['fight_cache'] = self._fight_cache
        self._components['friends'] = self._friends
        self._components['guild'] = self._guild
        self._components['mail'] = self._mail
        self._components['sign_in'] = self._sign_in
        self._components['feast'] = self._feast
        self._components['online_gift'] = self._online_gift
        self._components['level_gift'] = self._level_gift
        self._components['login_gift'] = self._login_gift
        self._components['world_boss'] = self._world_boss
        self._components['stamina'] = self._stamina
        self._components['shop'] = self._shop
        self._components['brew'] = self._brew
        self._components['tasks'] = self._tasks
        self._components['mine'] = self._mine
        self._components['stone'] = self._stone
        self._components['travel'] = self._travel
        self._components['runt'] = self._runt

    def init_player_info(self):
        character_obj = tb_character_info.getObj(self._pid)
        character_info = character_obj.hgetall()
        # print len(character_info), character_info
        for c in self._components.values():
            c.init_data(character_info)

    def is_new_character(self):
        character_info = tb_character_info.getObj(self._pid)
        # print 'exist:', self._pid, not character_info.exists()
        return not character_info.exists()

    def create_character_data(self):
        character_info = {'id': self._pid}
        for k, c in self._components.items():
            newdict = c.new_data()
            # print '='*88
            # print k, newdict
            character_info.update(newdict)
        char_obj = tb_character_info.getObj(self._pid)
        # print len(character_info), character_info
        char_obj.new(character_info)

    @property
    def base_info(self):
        return self._base_info

    @property
    def dynamic_id(self):
        return self._dynamic_id

    @dynamic_id.setter
    def dynamic_id(self, value):
        self._dynamic_id = value

    @property
    def hero_component(self):
        return self._hero_component

    @hero_component.setter
    def hero_component(self, value):
        self._hero_component = value

    @property
    def finance(self):
        return self._finance

    @finance.setter
    def finance(self, value):
        self._finance = value

    @property
    def last_pick_time(self):
        return self._last_pick_time

    @last_pick_time.setter
    def last_pick_time(self, value):
        self._last_pick_time = value

    @property
    def hero_chip_component(self):
        return self._hero_chip_component

    @hero_chip_component.setter
    def hero_chip_component(self, value):
        self._hero_chip_component = value

    @property
    def item_package(self):
        return self._item_package

    @property
    def equipment_component(self):
        return self._equipment

    @property
    def equipment_chip_component(self):
        return self._equipment_chip

    @property
    def line_up_component(self):
        return self._line_up

    def check_dynamic_id(self, dynamic_id):
        if self._dynamic_id == dynamic_id:
            return True
        return False

    @property
    def stage_component(self):
        return self._stage

    @property
    def fight_cache_component(self):
        return self._fight_cache

    @property
    def friends(self):
        return self._friends

    @property
    def guild(self):
        return self._guild

    @property
    def mail_component(self):
        return self._mail

    @property
    def sign_in_component(self):
        return self._sign_in

    @property
    def online_gift(self):
        return self._online_gift

    @property
    def level_gift(self):
        return self._level_gift

    @property
    def login_gift(self):
        return self._login_gift

    # @login_gift.setter
    # def login_gift(self, value):
    #     self._login_gift = value

    @property
    def world_boss(self):
        return self._world_boss

    # @world_boss.setter
    # def world_boss(self, value):
    #     self._world_boss = value

    @property
    def feast(self):
        return self._feast

    @property
    def travel_component(self):
        return self._travel

    @feast.setter
    def feast(self, value):
        self._feast = value

    @property
    def stamina(self):
        return self._stamina

    @property
    def shop(self):
        return self._shop

    @property
    def tasks(self):
        return self._tasks

    @property
    def brew(self):
        return self._brew

    @property
    def mine(self):
        return self._mine

    @property
    def stone(self):
        return self._stone

    @property
    def runt(self):
        return self._runt

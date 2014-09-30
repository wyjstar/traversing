# -*- coding:utf-8 -*-
"""
created by server on 14-6-4下午3:04.
"""
from app.game.component.character_line_up import CharacterLineUpComponent
from app.game.component.character_online_gift import CharacterOnlineGift
from app.game.component.equipment.character_equipment_chip import CharacterEquipmentChipComponent
from app.game.component.fight.fight_cache import CharacterFightCacheComponent
from app.game.component.level.character_level import CharacterLevelComponent
from app.game.component.pack.character_equipment_package import CharacterEquipmentPackageComponent
from app.game.component.pack.character_item_package import CharacterItemPackageComponent
from app.game.component.stage.character_stage import CharacterStageComponent
from gtwisted.utils import log
from app.game.core.character.Character import Character
from app.game.redis_mode import tb_character_info
from shared.utils.const import const
from app.game.component.character_heros import CharacterHerosComponent
from app.game.component.fiance.character_fiance_component import CharacterFinanceComponent
from app.game.component.character_hero_chips import CharacterHeroChipsComponent
from app.game.component.character_last_pick_time import CharacterLastPickTimeComponent
from app.game.component.friend.friend import FriendComponent
from app.game.component.character_guild import CharacterGuildComponent
from app.game.component.tb_character_mail import CharacterMailComponent
from app.game.component.character_sign_in import CharacterSignInComponent
from app.game.component.character_feast import CharacterFeastComponent
from app.game.component.character_login_gift import CharacterLoginGiftComponent
from app.game.component.character_level_gift import CharacterLevelGift
from app.game.component.character_vip import CharacterVIPComponent
from app.game.component.character_stamina import CharacterStaminaComponent



class PlayerCharacter(Character):
    """玩家角色类
    """

    def __init__(self, cid, name=u'MLGB', dynamic_id=-1, status=1):
        """构造方法
        @dynamic_id （int） 角色登陆的动态ID socket连接产生的id
        """
        Character.__init__(self, cid, name)

        self._character_type = const.PLAYER_TYPE  # 设置角色类型为玩家角色
        self._dynamic_id = dynamic_id  # 角色登陆服务器时的动态id
        # --------角色的各个组件类------------
        # TODO

        self._hero_component = CharacterHerosComponent(self)  # 武将列表
        self._finance = CharacterFinanceComponent(self)  # 金币
        self._hero_chip_component = CharacterHeroChipsComponent(self)  # 武将碎片
        self._item_package = CharacterItemPackageComponent(self)  # 游戏道具背包
        self._equipment = CharacterEquipmentPackageComponent(self)  # 装备
        self._equipment_chip = CharacterEquipmentChipComponent(self)  # 装备碎片
        self._level = CharacterLevelComponent(self)  # 等级
        self._line_up = CharacterLineUpComponent(self)  # 阵容
        self._stage = CharacterStageComponent(self)  # 关卡
        self._last_pick_time = CharacterLastPickTimeComponent(self)  # 上次抽取时间

        self._fight_cache = CharacterFightCacheComponent(self)  # 关卡战斗缓存
        self._friends = FriendComponent(self)  # friend system
        self._guild = CharacterGuildComponent(self)  # 公会组件
        self._mail = CharacterMailComponent(self)  # 邮箱组件
        self._sign_in = CharacterSignInComponent(self)  # 签到组件
        self._feast = CharacterFeastComponent(self)
        self._online_gift = CharacterOnlineGift(self)  # online gift
        self._level_gift = CharacterLevelGift(self)  # level gift
        self._login_gift = CharacterLoginGiftComponent(self)  # Login gift
        self._vip = CharacterVIPComponent(self)  # VIP level

        self._stamina = CharacterStaminaComponent(self)  # 体力
        self._pvp_times = 0  # pvp次数
        self._soul_shop_refresh_times = 0  # 武魂商店刷新次数
        self._mmode = None

        if status:
            self.__init_player_info()  # 初始化角色

    def __init_player_info(self):
        """初始化角色信息
        """
        pid = self.base_info.id

        character_info = tb_character_info.getObjData(pid)
        if not character_info:
            log.msg("Init_player %s error!" + str(pid))
            return
        print 'character_id', pid
        # ------------角色信息表数据---------------
        nickname = character_info['nickname']
        coin = character_info['coin']
        gold = character_info['gold']
        hero_soul = character_info['hero_soul']
        level = character_info['level']
        exp = character_info['exp']
        junior_stone = character_info['junior_stone']
        middle_stone = character_info['middle_stone']
        high_stone = character_info['high_stone']
        fine_hero_last_pick_time = character_info['fine_hero_last_pick_time']
        excellent_hero_last_pick_time = character_info['excellent_hero_last_pick_time']
        fine_equipment_last_pick_time = character_info['fine_equipment_last_pick_time']
        excellent_equipment_last_pick_time = character_info['excellent_equipment_last_pick_time']
        pvp_times = character_info['pvp_times']
        vip_level = character_info['vip_level']
        soul_shop_refresh_times = character_info.get('soul_shop_refresh_times', 0)

        # ------------初始化角色基础信息组件---------
        self.base_info.base_name = nickname  # 角色昵称

        #------------初始化角色货币信息------------
        self._finance.coin = coin
        self._finance.gold = gold
        self._finance.hero_soul = hero_soul
        self._finance.junior_stone = junior_stone
        self._finance.middle_stone = middle_stone
        self._finance.high_stone = high_stone

        #------------初始化上次抽取信息------------
        self._last_pick_time.fine_hero = fine_hero_last_pick_time
        self._last_pick_time.excellent_hero = excellent_hero_last_pick_time
        self._last_pick_time.fine_equipment = fine_equipment_last_pick_time
        self._last_pick_time.excellent_equipment = excellent_equipment_last_pick_time

        #------------初始化角色等级信息------------
        self._level.level = level
        self._level.exp = exp
        self._soul_shop_refresh_times = soul_shop_refresh_times


        #------------初始化角色其他组件------------
        self._hero_component.init_heros()  # 初始化武将列表
        self._item_package.init_data()
        self._line_up.init_data()
        self._equipment.init_data()
        self._equipment_chip.init_data()
        self._hero_chip_component.init_hero_chips()  # 初始化武将碎片
        self._mail.init_data()  # 初始化邮箱
        self._friends.init_data()
        self._guild.init_data()
        self._stage.init_data()
        self._stamina.init_data()
        self._pvp_times = pvp_times
        self._sign_in.init_sign_in()
        self._online_gift.init_data()
        self._level_gift.init_data()
        self._feast.init_feast()
        self._login_gift.init_data()
        self._vip.init_vip(vip_level)

    @property
    def character_type(self):
        return self._character_type

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
    def level(self):
        return self._level

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
        """检测客户端ID是否匹配
        @param dynamic_id: 客户端动态ID
        @return:
        """
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
    def pvp_times(self):
        return self._pvp_times

    @pvp_times.setter
    def pvp_times(self, value):
        self._pvp_times = value

    @property
    def mail_component(self):
        return self._mail

    @property
    def sign_in_component(self):
        return self._sign_in

    @property
    def vip_component(self):
        return self._vip

    @property
    def online_gift(self):
        return self._online_gift

    @property
    def level_gift(self):
        return self._level_gift

    @property
    def login_gift(self):
        return self._login_gift

    @login_gift.setter
    def login_gift(self, value):
        self._login_gift = value

    @property
    def feast(self):
        return self._feast

    @feast.setter
    def feast(self, value):
        self._feast = value

    @property
    def stamina(self):
        """体力组件"""
        return self._stamina

    @property
    def soul_shop_refresh_times(self):
        return self._soul_shop_refresh_times

    @soul_shop_refresh_times.setter
    def soul_shop_refresh_times(self, value):
        self._soul_shop_refresh_times = value

    def save_data(self):
        pid = self.base_info.id
        character_info = tb_character_info.getObj(pid)
        character_info.update_multi(dict(level=self._level.level, exp=self.level.exp,
                                         pvp_times=self._pvp_times,
                                         vip_level = self._vip.vip_level,
                                         soul_shop_refresh_times=self._soul_shop_refresh_times))

# -*- coding:utf-8 -*-
"""
created by server on 14-6-4下午3:04.
"""
from app.game.component.character_line_up import CharacterLineUpComponent
from app.game.component.character_online_gift import CharacterOnlineGift
from app.game.component.equipment.character_equipment_chip\
    import CharacterEquipmentChipComponent
from app.game.component.fight.fight_cache import CharacterFightCacheComponent
from app.game.component.level.character_level import CharacterLevelComponent
from app.game.component.pack.character_equipment_package\
    import CharacterEquipmentPackageComponent
from app.game.component.pack.character_item_package\
    import CharacterItemPackageComponent
from app.game.component.stage.character_stage import CharacterStageComponent
from app.game.core.character.Character import Character
from app.game.redis_mode import tb_character_info
from shared.utils.const import const
from app.game.component.character_heros import CharacterHerosComponent
from app.game.component.finance.finance import CharacterFinanceComponent
from app.game.component.character_hero_chips import CharacterHeroChipsComponent
from app.game.component.character_last_pick_time\
    import CharacterLastPickTimeComponent
from app.game.component.friend.friend import FriendComponent
from app.game.component.character_guild import CharacterGuildComponent
from app.game.component.tb_character_mail import CharacterMailComponent
from app.game.component.character_sign_in import CharacterSignInComponent
from app.game.component.character_feast import CharacterFeastComponent
from app.game.component.character_login_gift import CharacterLoginGiftComponent
from app.game.component.character_level_gift import CharacterLevelGift
from app.game.component.character_world_boss import CharacterWorldBoss
from app.game.component.character_vip import CharacterVIPComponent
from app.game.component.character_stamina import CharacterStaminaComponent
from app.game.component.character_shop import CharacterShopComponent
from app.game.component.brew.brew import CharacterBrewComponent
from app.game.component.character_travel import CharacterTravelComponent
import time
from app.game.component.achievement.user_achievement import UserAchievement
from app.game.component.mine.user_mine import UserMine
from app.game.component.stone.user_stone import UserStone
from app.game.component.character_runt import CharacterRuntComponent
from shared.db_opear.configs_data.game_configs import base_config


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
        self._world_boss = CharacterWorldBoss(self)  # world boss
        self._vip = CharacterVIPComponent(self)  # VIP level

        self._stamina = CharacterStaminaComponent(self)  # 体力
        self._shop = CharacterShopComponent(self)  # 商店
        self._brew = CharacterBrewComponent(self)

        self._tasks = UserAchievement(self)
        self._mine = UserMine(self)
        self._stone = UserStone(self)

        self._pvp_times = 0  # pvp次数
        self._newbee_guide_id = 0

        self._travel = CharacterTravelComponent(self)
        self._runt = CharacterRuntComponent(self)

    def init_player_info(self):
        """初始化角色信息
        """
        pid = self.base_info.id
        character_info = tb_character_info.getObjData(pid)
        # ------------角色信息表数据---------------
        nickname = character_info['nickname']
        level = character_info['level']
        exp = character_info['exp']
        fine_hero_last_pick_time = character_info['fine_hero_last_pick_time']
        excellent_hero_last_pick_time =\
            character_info['excellent_hero_last_pick_time']
        fine_equipment_last_pick_time =\
            character_info['fine_equipment_last_pick_time']
        excellent_equipment_last_pick_time =\
            character_info['excellent_equipment_last_pick_time']
        pvp_times = character_info['pvp_times']
        pvp_refresh_time = character_info['pvp_refresh_time']
        vip_level = character_info['vip_level']

        # ------------初始化角色基础信息组件---------
        self.base_info.base_name = nickname  # 角色昵称
        self._newbee_guide_id = character_info['newbee_guide_id']

        # ------------初始化角色货币信息------------
        self._finance.init_data(character_info)

        # ------------初始化上次抽取信息------------
        self._last_pick_time.fine_hero = fine_hero_last_pick_time
        self._last_pick_time.excellent_hero = excellent_hero_last_pick_time
        self._last_pick_time.fine_equipment = fine_equipment_last_pick_time
        self._last_pick_time.excellent_equipment =\
            excellent_equipment_last_pick_time

        # ------------初始化角色等级信息------------
        self._level.level = level
        self._level.exp = exp

        # ------------初始化角色其他组件------------
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

        self._pvp_times = pvp_times
        self._pvp_refresh_time = pvp_refresh_time
        self._sign_in.init_sign_in()
        self._online_gift.init_data()
        self._level_gift.init_data()
        self._feast.init_feast()
        self._login_gift.init_data()
        self._world_boss.init_data()
        self._vip.init_vip(vip_level)
        self._stamina.init_stamina(character_info.get('stamina'))
        self._shop.init_data()
        self._brew.init_data(character_info)
        self._travel.init_data()
        # 活跃度
        self._tasks.init_data()
        self._mine.init_data()
        self._stone.init_data()
        self._runt.init_data()

    def is_new_character(self):
        """is new character or not"""
        pid = self.base_info.id

        character_info = tb_character_info.getObjData(pid)
        # print 'character info:', character_info
        if character_info:
            return False
        return True

    def create_character_data(self):
        """docstring for create_character_data"""
        pid = self.base_info.id

        finances = [0] * const.RESOURCE_MAX
        for t, v in base_config.get('resource_for_InitUser').items():
            finances[t] = v

        character_info = {'id': pid,
                          'nickname': u'',
                          'level': 1,
                          'exp': 0,
                          'fine_hero_last_pick_time': 0,
                          'excellent_hero_last_pick_time': 0,
                          'fine_equipment_last_pick_time': 0,
                          'excellent_equipment_last_pick_time': 0,
                          'pvp_times': 0,
                          'pvp_refresh_time': 0,
                          'newbee_guide_id': 0,
                          'create_time': int(time.time()),
                          'vip_level': base_config.get('initialVipLevel'),
                          'stamina': self._stamina.detail_data,
                          'last_login_time': int(time.time()),
                          'finances': finances

                          }
        tb_character_info.new(character_info)

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
    def newbee_guide_id(self):
        return self._newbee_guide_id

    @newbee_guide_id.setter
    def newbee_guide_id(self, value):
        self._newbee_guide_id = value

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
    def pvp_refresh_time(self):
        return self._pvp_refresh_time

    @pvp_refresh_time.setter
    def pvp_refresh_time(self, value):
        self._pvp_refresh_time = value

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
    def world_boss(self):
        return self._world_boss

    @world_boss.setter
    def world_boss(self, value):
        self._world_boss = value

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
        """体力组件"""
        return self._stamina

    @property
    def shop(self):
        return self._shop

    @property
    def tasks(self):
        """
        活跃度
        """
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

    def save_data(self):
        pid = self.base_info.id
        character_info = tb_character_info.getObj(pid)
        character_info.update_multi(dict(level=self._level.level,
                                         exp=self.level.exp,
                                         pvp_times=self._pvp_times,
                                         pvp_refresh_time=self.pvp_refresh_time,
                                         newbee_guide_id=self._newbee_guide_id,
                                         vip_level=self._vip.vip_level))

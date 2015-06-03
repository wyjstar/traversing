# -*- coding:utf-8 -*-
"""
created by server on 14-6-4下午3:04.
"""
from shared.db_opear.configs_data import game_configs
from app.game.redis_mode import tb_character_info
from gfirefly.server.logobj import logger
from app.game import component


class OtherPlayerCharacter(object):
    """玩家角色类 """

    def __init__(self, pid, name=u'MLGB', dynamic_id=-1, status=1):
        """构造方法
        @dynamic_id （int） 角色登陆的动态ID socket连接产生的id
        """
        self._pid = pid
        self._dynamic_id = dynamic_id  # 角色登陆服务器时的动态id
        a = dict(base_info=component.CharacterBaseInfoComponent(self),
                 hero_component=component.CharacterHerosComponent(self),
                 #finance=component.CharacterFinanceComponent(self),
                 #hero_chip_component=component.CharacterHeroChipsComponent(self),
                 #item_package=component.CharacterItemPackageComponent(self),
                 equipment=component.CharacterEquipmentPackageComponent(self),
                 #equipment_chip=component.CharacterEquipmentChipComponent(self),
                 line_up=component.CharacterLineUpComponent(self),
                 #stage=component.CharacterStageComponent(self),
                 #last_pick_time=component.CharacterLastPickTimeComponent(self),
                 #fight_cache=component.CharacterFightCacheComponent(self),
                 #friends=component.FriendComponent(self),
                 guild=component.CharacterGuildComponent(self),
                 #mail=component.CharacterMailComponent(self),
                 #sign_in=component.CharacterSignInComponent(self),
                 #feast=component.CharacterFeastComponent(self),
                 #online_gift=component.CharacterOnlineGift(self),
                 #level_gift=component.CharacterLevelGift(self),
                 #login_gift=component.CharacterLoginGiftComponent(self),
                 #world_boss=component.CharacterWorldBoss(self),
                 #stamina=component.CharacterStaminaComponent(self),
                 #shop=component.CharacterShopComponent(self),
                 #brew=component.CharacterBrewComponent(self),
                 #tasks=component.UserAchievement(self),
                 #mine=component.UserMine(self),
                 #stone=component.UserStone(self),
                 travel=component.CharacterTravelComponent(self),
                 #runt=component.CharacterRuntComponent(self),
                 #recharge=component.CharacterRechargeGift(self),
                 #rebate=component.Rebate(self),
                 #buy_coin=component.CharacterBuyCoinActivity(self)
                 )
        self._components = a
        self._pay = component.CharacterPay(self)

    def init_player_info(self):
        character_obj = tb_character_info.getObj(self._pid)
        character_info = character_obj.hgetall()
        for c in self._components.values():
            c.init_data(character_info)

    def is_new_character(self):
        character_info = tb_character_info.getObj(self._pid)
        logger.debug('is_new_character,pid:%s', self._pid)
        return not character_info.exists()

    def create_character_data(self):
        character_info = {'id': self._pid}
        for k, c in self._components.items():
            newdict = c.new_data()
            character_info.update(newdict)
        char_obj = tb_character_info.getObj(self._pid)
        logger.debug('new player db:%s:level:%s',
                     character_info['id'],
                     character_info['level'])
        char_obj.new(character_info)
        tb_character_info.sadd('new', self._pid)

        # fake============================================
        if self._pid != 999:
            logger.debug('add hero %s', game_configs.base_config.get('initialHero'))
            for pos, hero_id in game_configs.base_config.get('initialHero').items():
                hero = self.hero_component.add_hero(hero_id)
                hero.hero_no = hero_id
                hero.level = 1
                hero.break_level = 0
                hero.exp = 0
                hero.save_data()
                self.line_up_component.change_hero(1, hero_id, 0)
                self.line_up_component.save_data()
            self.friends.add_applicant(999)
            self.friends.add_friend(999)
            self.friends.save_data()

    @property
    def character_id(self):
        return self._pid

    @property
    def dynamic_id(self):
        return self._dynamic_id

    @dynamic_id.setter
    def dynamic_id(self, value):
        self._dynamic_id = value

    @property
    def base_info(self):
        return self._components['base_info']

    @property
    def hero_component(self):
        return self._components['hero_component']

    @property
    def finance(self):
        return self._components['finance']

    @property
    def last_pick_time(self):
        return self._components['last_pick_time']

    @property
    def hero_chip_component(self):
        return self._components['hero_chip_component']

    @property
    def item_package(self):
        return self._components['item_package']

    @property
    def equipment_component(self):
        return self._components['equipment']

    @property
    def equipment_chip_component(self):
        return self._components['equipment_chip']

    @property
    def line_up_component(self):
        return self._components['line_up']

    @property
    def stage_component(self):
        return self._components['stage']

    @property
    def fight_cache_component(self):
        return self._components['fight_cache']

    @property
    def friends(self):
        return self._components['friends']

    @property
    def guild(self):
        return self._components['guild']

    @property
    def mail_component(self):
        return self._components['mail']

    @property
    def sign_in_component(self):
        return self._components['sign_in']

    @property
    def online_gift(self):
        return self._components['online_gift']

    @property
    def level_gift(self):
        return self._components['level_gift']

    @property
    def login_gift(self):
        return self._components['login_gift']

    @property
    def world_boss(self):
        return self._components['world_boss']

    @property
    def feast(self):
        return self._components['feast']

    @property
    def travel_component(self):
        return self._components['travel']

    @property
    def stamina(self):
        return self._components['stamina']

    @property
    def shop(self):
        return self._components['shop']

    @property
    def tasks(self):
        return self._components['tasks']

    @property
    def brew(self):
        return self._components['brew']

    @property
    def mine(self):
        return self._components['mine']

    @property
    def stone(self):
        return self._components['stone']

    @property
    def runt(self):
        return self._components['runt']

    @property
    def recharge(self):
        return self._components['recharge']
    @property
    def pay(self):
        return self._pay

    @property
    def rebate(self):
        return self._components['rebate']

    @property
    def buy_coin(self):
        return self._components['buy_coin']


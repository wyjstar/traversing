# -*- coding:utf-8 -*-
"""
created by server on 14-6-4下午3:04.
"""
import cPickle
from shared.db_opear.configs_data import game_configs
from app.game.redis_mode import tb_character_info
from gfirefly.server.logobj import logger
from app.game import component
from collections import OrderedDict
from gfirefly.dbentrust import util

CHARACTER_TABLE_NAME = 'tb_character_info'


class PlayerCharacter(object):
    """玩家角色类 """

    def __init__(self, pid, name=u'MLGB', dynamic_id=-1, status=1):
        """构造方法
        @dynamic_id （int） 角色登陆的动态ID socket连接产生的id
        """
        self._pid = pid
        self._dynamic_id = dynamic_id  # 角色登陆服务器时的动态id
        a = OrderedDict()
        a['act'] = component.CharacterActComponent(self)
        a['base_info'] = component.CharacterBaseInfoComponent(self)
        a['hero_component'] = component.CharacterHerosComponent(self)
        a['finance'] = component.CharacterFinanceComponent(self)
        a['hero_chip_component'] = component.CharacterHeroChipsComponent(self)
        a['item_package'] = component.CharacterItemPackageComponent(self)
        a['equipment'] = component.CharacterEquipmentPackageComponent(self)
        a['equipment_chip'] = component.CharacterEquipmentChipComponent(self)
        a['task'] = component.CharacterTaskComponent(self)
        a['line_up'] = component.CharacterLineUpComponent(self)
        a['stage'] = component.CharacterStageComponent(self)
        a['last_pick_time'] = component.CharacterLastPickTimeComponent(self)
        a['fight_cache'] = component.CharacterFightCacheComponent(self)
        a['friends'] = component.FriendComponent(self)
        a['guild'] = component.CharacterGuildComponent(self)
        a['mail'] = component.CharacterMailComponent(self)
        a['sign_in'] = component.CharacterSignInComponent(self)
        a['feast'] = component.CharacterFeastComponent(self)
        a['online_gift'] = component.CharacterOnlineGift(self)
        a['level_gift'] = component.CharacterLevelGift(self)
        a['login_gift'] = component.CharacterLoginGiftComponent(self)
        a['world_boss'] = component.CharacterWorldBoss(self)
        a['stamina'] = component.CharacterStaminaComponent(self)
        a['shop'] = component.CharacterShopComponent(self)
        a['brew'] = component.CharacterBrewComponent(self)
        a['mine'] = component.CharacterMine(self)
        a['stone'] = component.UserStone(self)
        a['travel'] = component.CharacterTravelComponent(self)
        a['runt'] = component.CharacterRuntComponent(self)
        a['recharge'] = component.CharacterRechargeGift(self)
        a['limit_hero'] = component.CharacterLimitHeroComponent(self)
        a['rebate'] = component.Rebate(self)
        a['buy_coin'] = component.CharacterBuyCoinActivity(self)
        a['pvp'] = component.CharacterPvpComponent(self)
        a['hjqy'] = component.CharacterHjqyComponent(self)
        a['rob_treasure'] = component.CharacterRobTreasureComponent(self)
        a['escort_component'] = component.CharacterEscortComponent(self)
        a['guild_activity'] = component.CharacterGuildActivityComponent(self)
        a['add_activity'] = component.CharacterAddActivityComponent(self)
        logger.debug("keys %s" % a.keys())
        self._components = a
        self._pay = component.CharacterPay(self)

    def init_player_info(self):
        logger.debug("init_player_info===========")
        character_obj = tb_character_info.getObj(self._pid)
        character_info = character_obj.hgetall()
        for k, c in self._components.items():
            print(k)
            c.init_data(character_info)

    def is_new_character(self):
        character_info = tb_character_info.getObj(self._pid)
        logger.debug('is_new_character,pid:%s', self._pid)
        if not character_info.exists():
            pwere = dict(id=self._pid)
            result = util.GetOneRecordInfo(CHARACTER_TABLE_NAME, pwere)
            if result:
                logger.info('loads player in redis:%s-%s-%s', self._pid,
                            len(result.get('base_info')), result['base_info'])
                character_info.hmset(cPickle.loads(result['base_info']))
                equipments = cPickle.loads(result['equipments'])
                if equipments:
                    character_info.getObj('equipments').hmset(equipments)
                mails = cPickle.loads(result['mails'])
                if mails:
                    character_info.getObj('mails').hmset(mails)
                heroes = cPickle.loads(result['heroes'])
                if heroes:
                    character_info.getObj('heroes').hmset(heroes)
                tb_character_info.sadd('all', self._pid)

        return not character_info.exists()

    def create_character_data(self):
        character_info = {'id': self._pid}
        for k, c in self._components.items():
            newdict = c.new_data()
            character_info.update(newdict)
        char_obj = tb_character_info.getObj(self._pid)
        logger.debug('new player db:%s:level:%s', character_info['id'],
                     character_info['level'])
        char_obj.new(character_info)
        tb_character_info.sadd('new', self._pid)

        # fake============================================
        self.line_up_component.update_guild_attr()
        if self._pid != 999:

            logger.debug('add hero %s',
                         game_configs.base_config.get('initialHero'))
            self.line_up_component.update_guild_attr()
            for pos, hero_id in game_configs.base_config.get(
                    'initialHero').items():
                hero = self.hero_component.add_hero(hero_id)
                hero.hero_no = hero_id
                hero.level = 1
                hero.break_level = 0
                hero.exp = 0
                hero.save_data()
                self.line_up_component.change_hero(pos, hero_id, 0)
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
    def rob_treasure(self):
        return self._components['rob_treasure']

    @property
    def hero_component(self):
        return self._components['hero_component']

    @property
    def limit_hero(self):
        return self._components['limit_hero']

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
    def task(self):
        return self._components['task']

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

    @property
    def pvp(self):
        return self._components['pvp']

    @property
    def hjqy_component(self):
        return self._components['hjqy']

    @property
    def act(self):
        return self._components['act']

    @property
    def escort_component(self):
        return self._components['escort_component']

    @property
    def guild_activity(self):
        return self._components['guild_activity']

    @property
    def add_activity(self):
        return self._components['add_activity']

    def set_level_related(self, level=0):
        """docstring for set_level"""
        if level:
            self.base_info.level = level
            self.base_info.save_data()

        # 更新卡槽位
        self.line_up_component.update_slot_activation()
        self.line_up_component.save_data(['line_up_slots', 'sub_slots'])

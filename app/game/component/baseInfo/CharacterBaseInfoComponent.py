# -*- coding:utf-8 -*-
"""
created by server on 14-5-27下午5:21.
"""

from shared.db_opear.configs_data import game_configs
from app.game.component.mine.monster_mine import MineOpt
from app.game.component.Component import Component
from app.game.redis_mode import tb_character_info
from app.proto_file.db_pb2 import Heads_DB
from gfirefly.server.logobj import logger
from shared.tlog import tlog_action
import time
import uuid


class CharacterBaseInfoComponent(Component):
    """玩家基础信息组件类
    """
    def __init__(self, owner):
        """
        Constructor
        """
        Component.__init__(self, owner)
        self._base_name = u''       # 基本名字
        self._level = 1  # 当前等级
        self._exp = 0  # 当前等级获得的经验

        self._newbee_guide_id = 0
        self._gag = 1    # 禁言到这个时间戳
        self._closure = 1    # 封停到这个时间戳

        self._heads = Heads_DB()
        self._heads.now_head = game_configs.base_config.get('initialHead')

        self._vip_level = 0  # VIP等级
        self._upgrade_time = int(time.time())
        self._register_time = int(time.time())  # 注册时间
        self._google_consume_id = ''
        self._google_consume_data = ''
        self._apple_transaction_id = ''
        self._first_recharge_ids = []
        self._recharge = 0  # 累积充值
        self._gen_balance = 0  # 累积赠送
        self._login_time = int(time.time())  # 登录时间
        self._tomorrow_gift = 0
        self._battle_speed = 1
        self._plat_id = -1

    def init_data(self, character_info):
        self._base_name = character_info['nickname']
        self._level = character_info['level']
        MineOpt.asadd('user_level', self.owner.base_info.id, self._level)
        self._exp = character_info['exp']

        self._newbee_guide_id = character_info['newbee_guide_id']

        self._gag = character_info['gag']
        self._closure = character_info['closure']

        self._heads.ParseFromString(character_info['heads'])
        self._vip_level = character_info.get('vip_level')
        self._upgrade_time = character_info.get('upgrade_time',
                                                self._upgrade_time)
        self._register_time = character_info.get('register_time',
                                                 self._register_time)
        self._google_consume_id = character_info.get('google_consume_id', '')
        self._google_consume_data = character_info.get('google_consume_data', '')
        self._apple_transaction_id = character_info.get('apple_transaction_id', '')
        self._first_recharge_ids = character_info.get('first_recharge_ids', [])
        self._recharge = character_info.get('recharge_accumulation')
        self._gen_balance = character_info.get('gen_balance', 0)
        self._tomorrow_gift = character_info.get('tomorrow_gift', 0)
        self._battle_speed = character_info.get('battle_speed', 1)

        vip_content = game_configs.vip_config.get(self._vip_level)
        if vip_content is None:
            logger.error('cant find vip item%d', self._vip_level)
        self.check_time()

        self.save_data()

    def save_data(self):
        character_info = tb_character_info.getObj(self.id)
        self._upgrade_time = int(time.time())

        data = dict(level=self._level,
                    nickname=self._base_name,
                    exp=self.exp,
                    gag=self._gag,
                    closure=self._closure,
                    newbee_guide_id=self._newbee_guide_id,
                    vip_level=self._vip_level,
                    upgrade_time=self._upgrade_time,
                    heads=self._heads.SerializeToString(),
                    google_consume_id=self._google_consume_id,
                    google_consume_data=self._google_consume_data,
                    apple_transaction_id=self._apple_transaction_id,
                    first_recharge_ids=self._first_recharge_ids,
                    recharge_accumulation=self._recharge,
                    gen_balance=self._gen_balance,
                    tomorrow_gift=self._tomorrow_gift,
                    battle_speed=self._battle_speed)
        character_info.hmset(data)
        # logger.debug("save level:%s,%s", str(self.id), str(data))

    def new_data(self):
        self._level = game_configs.base_config.get('initialPlayerLevel')
        self._vip_level = game_configs.base_config.get('initialVipLevel')
        data = dict(level=self._level,
                    exp=self.exp,
                    gag=self._gag,
                    closure=self._closure,
                    nickname=u'',
                    newbee_guide_id=self._newbee_guide_id,
                    vip_level=self._vip_level,
                    upgrade_time=self._upgrade_time,
                    heads=self._heads.SerializeToString(),
                    register_time=self._register_time,
                    google_consume_id=self._google_consume_id,
                    google_consume_data=self._google_consume_data,
                    apple_transaction_id=self._apple_transaction_id,
                    first_recharge_ids=self._first_recharge_ids,
                    recharge_accumulation=self._recharge,
                    gen_balance=self._gen_balance,
                    tomorrow_gift=self._tomorrow_gift,
                    battle_speed=self._battle_speed)
        return data

    def check_time(self):
        pass
        tm = time.localtime(self._pvp_refresh_time)
        local_tm = time.localtime()
        if local_tm.tm_year != tm.tm_year or local_tm.tm_yday != tm.tm_yday:
            self._pvp_times += game_configs.base_config.get('arena_free_times')
            self._pvp_refresh_count = 0
            self._pvp_refresh_time = time.time()
            self.save_data()

    def is_firstday_from_register(self):
        tm = time.localtime(self._register_time)
        local_tm = time.localtime()
        if local_tm.tm_year == tm.tm_year and local_tm.tm_yday == tm.tm_yday:
            return True
        return False

    def addexp(self, exp, reason):
        self._exp += exp
        before_level = self._level
        max_level = game_configs.base_config.get('player_level_max')
        if self._level == max_level:
            return

        while self._exp >= game_configs.player_exp_config.get(self._level).get('exp'):
            self._exp -= game_configs.player_exp_config.get(self._level).get('exp')
            self._level += 1
            logger.info('player id:%s level up ++ %s>>%s', self.id, before_level, self._level)
            MineOpt.updata_level('user_level', self.owner.base_info.id,
                                 self._level-1, self._level)
            if self._level == max_level:
                return

        # =====Tlog================
        tlog_action.log('PlayerExpFlow', self.owner, before_level, exp, reason)

    def generate_google_id(self, channel):
        if self._google_consume_id == '':
            self._google_consume_id = '%s_%s_%s' % (self.id, channel,
                                                    uuid.uuid1().get_hex())
        self.save_data()
        return self._google_consume_id

    def reset_google_id(self):
        self._google_consume_id = ''
        self.save_data()

    def set_google_consume_data(self, data):
        self._google_consume_data = data
        self.save_data()

    def first_recharge(self, recharge_item, response):
        if recharge_item.get('id') in self._first_recharge_ids:
            logger.error('first recharge is repeated:%s:%s', self.id,
                         recharge_item.get('fristGift'))
            return False

        self._first_recharge_ids.append(recharge_item.get('id'))
        self.save_data()

        logger.info('first recharge :%s:%s:%s', self.id,
                    recharge_item.get('fristGift'), self._first_recharge_ids)
        return True

    @property
    def id(self):
        return self.owner.character_id

    @property
    def base_name(self):
        return self._base_name

    @base_name.setter
    def base_name(self, base_name):
        self._base_name = base_name

    @property
    def level(self):
        return self._level

    @level.setter
    def level(self, value):
        self._level = value

    @property
    def login_time(self):
        return self._login_time

    @login_time.setter
    def login_time(self, value):
        self._login_time = value

    @property
    def exp(self):
        return self._exp

    @exp.setter
    def exp(self, value):
        self._exp = value

    @property
    def vip_level(self):
        return self._vip_level

    @vip_level.setter
    def vip_level(self, vip_level):
        self._vip_level = vip_level
        vip_content = game_configs.vip_config.get(self._vip_level)
        if vip_content is None:
            logger.error('cant find vip item%d', self._vip_level)

    @property
    def open_sweep(self):
        """解锁扫荡"""
        vip_content = game_configs.vip_config.get(self._vip_level)
        return vip_content.openSweep

    @property
    def open_sweep_ten(self):
        """解锁扫荡十次"""
        vip_content = game_configs.vip_config.get(self._vip_level)
        return vip_content.openSweepTen

    @property
    def free_sweep_times(self):
        """每日免费扫荡次数"""
        vip_content = game_configs.vip_config.get(self._vip_level)
        return vip_content.freeSweepTimes

    @property
    def reset_stage_times(self):
        """关卡重置次数"""
        vip_content = game_configs.vip_config.get(self._vip_level)
        return vip_content.resetStageTimes

    @property
    def reset_arena_cd(self):
        """重置竞技场CD"""
        vip_content = game_configs.vip_config.get(self._vip_level)
        return vip_content.resetArenaCD

    @property
    def buy_arena_times(self):
        """购买竞技场次数"""
        vip_content = game_configs.vip_config.get(self._vip_level)
        return vip_content.buyArenaTimes

    @property
    def buy_stamina_max(self):
        """每日购买体力上限"""
        vip_content = game_configs.vip_config.get(self._vip_level)
        return vip_content.buyStaminaMax

    @property
    def equipment_strength_one_key(self):
        """装备一键强化"""
        vip_content = game_configs.vip_config.get(self._vip_level)
        return vip_content.equipmentStrengthOneKey

    @property
    def all_equipment_strength_one_key(self):
        """装备一键强化"""
        vip_content = game_configs.vip_config.get(self._vip_level)
        return vip_content.allStrength

    @property
    def shop_refresh_times(self):
        """每日商店刷新次数"""
        vip_content = game_configs.vip_config.get(self._vip_level)
        return vip_content.shopRefreshTimes

    @property
    def activity_copy_times(self):
        """每日活动副本次数"""
        vip_content = game_configs.vip_config.get(self._vip_level)
        return vip_content.activityCopyTimes

    @property
    def elite_copy_times(self):
        """每日精英副本次数"""
        vip_content = game_configs.vip_config.get(self._vip_level)
        return vip_content.eliteCopyTimes

    @property
    def equipment_strength_cli_times(self):
        """装备强化暴击次数"""
        vip_content = game_configs.vip_config.get(self._vip_level)
        return vip_content.equipmentStrengthCliTimes

    @property
    def gifts(self):
        """获得礼包"""
        # todo: send mail
        vip_content = game_configs.vip_config.get(self._vip_level)
        return vip_content.gifts

    @property
    def buy_gifts(self):
        """可购买的礼包"""
        # todo: 礼包ID
        vip_content = game_configs.vip_config.get(self._vip_level)
        return vip_content.buyGifts

    @property
    def guild_worship_times(self):
        """公会膜拜次数"""
        vip_content = game_configs.vip_config.get(self._vip_level)
        return vip_content.guildWorshipTimes

    @property
    def war_refresh_times(self):
        vip_content = game_configs.vip_config.get(self._vip_level)
        return vip_content.warFogRefreshNum

    @property
    def heads(self):
        return self._heads

    @heads.setter
    def heads(self, value):
        self._heads = value

    @property
    def head(self):
        return self._heads.now_head

    @property
    def newbee_guide_id(self):
        return self._newbee_guide_id

    @newbee_guide_id.setter
    def newbee_guide_id(self, value):
        self._newbee_guide_id = value

    @property
    def upgrade_time(self):
        return self._upgrade_time

    @property
    def register_time(self):
        return self._register_time

    @register_time.setter
    def register_time(self, value):
        self._register_time = value

    @property
    def google_consume_id(self):
        return self._google_consume_id

    @property
    def google_consume_data(self):
        return self._google_consume_data

    @property
    def apple_transaction_id(self):
        return self._apple_transaction_id

    @apple_transaction_id.setter
    def apple_transaction_id(self, value):
        self._apple_transaction_id = value

    @property
    def first_recharge_ids(self):
        return self._first_recharge_ids

    def set_vip_level(self, gold):
        """
        充值后升级vip
        """
        for i in range(16):
            vip_content = game_configs.vip_config.get(i)
            if gold >= vip_content.rechargeAmount:
                self.vip_level = i
                self.save_data()

    @property
    def gag(self):
        return self._gag

    @gag.setter
    def gag(self, value):
        self._gag = value

    @property
    def tomorrow_gift(self):
        return self._tomorrow_gift

    @tomorrow_gift.setter
    def tomorrow_gift(self, value):
        self._tomorrow_gift = value

    @property
    def battle_speed(self):
        return self._battle_speed

    @battle_speed.setter
    def battle_speed(self, value):
        self._battle_speed = value

    @property
    def closure(self):
        return self._closure

    @closure.setter
    def closure(self, value):
        self._closure = value

    @property
    def recharge(self):
        return self._recharge

    @recharge.setter
    def recharge(self, value):
        self._recharge = value

    @property
    def gen_balance(self):
        return self._gen_balance

    @gen_balance.setter
    def gen_balance(self, value):
        self._gen_balance = value

    @property
    def buy_coin_times(self):
        """招财进宝次数"""
        vip_content = game_configs.vip_config.get(self._vip_level)
        return vip_content.buyGetMoneyTimes

    @property
    def plat_id(self):
        return self._plat_id

    @plat_id.setter
    def plat_id(self, value):
        self._plat_id = value

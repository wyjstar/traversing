# -*- coding:utf-8 -*-
"""
created by server on 14-5-27下午5:21.
"""

from shared.db_opear.configs_data import game_configs
from app.game.component.Component import Component
from app.game.redis_mode import tb_character_info
from app.game.redis_mode import tb_character_level
from app.proto_file.db_pb2 import Heads_DB
from gfirefly.server.logobj import logger
from shared.tlog import tlog_action
from shared.utils.date_util import days_to_current
from shared.utils.date_util import get_current_timestamp
from shared.utils.date_util import string_to_timestamp_hms
import time
import uuid
from app.game.core.task import hook_task, CONDITIONId
from shared.utils.const import const
from app.game.core.activity import target_update
from shared.common_logic import feature_open


class CharacterBaseInfoComponent(Component):
    """玩家基础信息组件类
    """

    def __init__(self, owner):
        """
        Constructor
        """
        Component.__init__(self, owner)
        self._base_name = u''  # 基本名字
        self._level = 1  # 当前等级
        self._exp = 0  # 当前等级获得的经验

        self._newbee_guide = {}
        self._current_newbee_guide = 0
        self._gag = 1  # 禁言到这个时间戳
        self._closure = 1  # 封停到这个时间戳

        self._heads = Heads_DB()
        self._heads.now_head = game_configs.base_config.get('initialHead')

        self._vip_level = 0  # VIP等级
        self._upgrade_time = int(time.time())
        self._register_time = int(time.time())  # 注册时间
        self._google_consume_id = ''
        self._google_consume_data = ''
        self._apple_transaction_id = ''
        self._first_recharge_ids = []
        self._max_single_recharge = 0  # 累积充值
        self._recharge = 0  # 累积充值
        self._gen_balance = 0  # 累积赠送
        self._login_time = int(time.time())  # 登录时间
        self._tomorrow_gift = 0
        self._battle_speed = 1
        self._plat_id = -1
        self._is_open_next_day_activity = False
        self._first_recharge_activity = -1  # -1 没领 1 领过
        self._story_id = 0
        self._button_one_time = [0] * 3  # 0. 第二天活动开启后的按钮 1. 首次充值奖励 2. 关卡点我有惊喜
        self._hero_awake_time = int(time.time())  # 武将觉醒时间，用于次日清除相关武将觉醒进度。
        self._flowid = 0  # 流水号
        self._one_dollar_flowid = 0

    def init_data(self, character_info):
        self._base_name = character_info['nickname']
        self._level = character_info['level']
        tb_character_level.zadd(self._level, self.id)
        self._exp = character_info['exp']

        self._newbee_guide = character_info.get('newbee_guide', {})
        self._current_newbee_guide = character_info.get('current_newbee_guide',
                                                        0)

        self._gag = character_info['gag']
        self._closure = character_info['closure']

        self._heads.ParseFromString(character_info['heads'])
        self._vip_level = character_info.get('vip_level')
        self._upgrade_time = character_info.get('upgrade_time',
                                                self._upgrade_time)
        self._register_time = character_info.get('register_time',
                                                 self._register_time)
        self._google_consume_id = character_info.get('google_consume_id', '')
        self._google_consume_data = character_info.get('google_consume_data',
                                                       '')
        self._apple_transaction_id = character_info.get('apple_transaction_id',
                                                        '')
        self._first_recharge_ids = character_info.get('first_recharge_ids', [])
        self._recharge = character_info.get('recharge_accumulation')
        self._gen_balance = character_info.get('gen_balance', 0)
        self._tomorrow_gift = character_info.get('tomorrow_gift', 0)
        self._battle_speed = character_info.get('battle_speed', 1)
        self._story_id = character_info.get('story_id', 0)
        self._is_open_next_day_activity = character_info.get(
            'is_open_next_day_activity', False)
        self._first_recharge_activity = character_info.get(
            'first_recharge_activity', False)
        self._button_one_time = character_info.get('button_one_time', [0, 0,
                                                                       0])
        self._hero_awake_time = character_info.get('hero_awake_time',
                                                   int(time.time()))
        self._max_single_recharge = character_info.get('max_single_recharge',
                                                       0)
        self._one_dollar_flowid = character_info.get('one_dollar_flowid', 0)

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
                    newbee_guide=self._newbee_guide,
                    current_newbee_guide=self._current_newbee_guide,
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
                    battle_speed=self._battle_speed,
                    is_open_next_day_activity=self._is_open_next_day_activity,
                    first_recharge_activity=self._first_recharge_activity,
                    story_id=self._story_id,
                    button_one_time=self._button_one_time,
                    hero_awake_time=self._hero_awake_time,
                    max_single_recharge=self._max_single_recharge,
                    flowid=self._flowid,
                    one_dollar_flowid=self._one_dollar_flowid)
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
                    newbee_guide=self._newbee_guide,
                    current_newbee_guide=self.current_newbee_guide,
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
                    battle_speed=self._battle_speed,
                    is_open_next_day_activity=self._is_open_next_day_activity,
                    first_recharge_activity=self._first_recharge_activity,
                    story_id=self._story_id,
                    button_one_time=self._button_one_time,
                    hero_awake_time=self._hero_awake_time,
                    flowid=self._flowid,
                    one_dollar_flowid=self._one_dollar_flowid)
        return data

    def check_time(self):
        pass
        # tm = time.localtime(self._pvp_refresh_time)
        # local_tm = time.localtime()
        # if local_tm.tm_year != tm.tm_year or local_tm.tm_yday != tm.tm_yday:
        #     self._pvp_times += game_configs.base_config.get('arena_free_times')
        #     self._pvp_refresh_count = 0
        #     self._pvp_refresh_time = time.time()
        #     self.save_data()

    def is_firstday_from_register(self, feature_type):
        """
        feature_type: 功能类型(世界boss， 活跃度， 黄巾起义， 过关斩将)
        """
        open_info = None
        if feature_type == const.OPEN_FEATURE_HJQY:
            open_info = game_configs.base_config.get("hjqyOpenDay")
        elif feature_type == const.OPEN_FEATURE_TASK:
            open_info = game_configs.base_config.get("activityOpenDay")
        elif feature_type == const.OPEN_FEATURE_WORLD_BOSS:
            open_info = game_configs.base_config.get("worldbossOpenDay")
        elif feature_type == const.OPEN_FEATURE_GGZJ:
            open_info = game_configs.base_config.get("ggzjOpenDay")

        if not open_info:
            logger.error("open feature next day config error! feature_type %s"
                         % feature_type)
            return True
        if self.check_open_date(open_info):
            return False
        return True

    def check_open_date(self, open_info):
        logger.debug("open_info============%s" % open_info)
        days = open_info.keys()[0]
        ts = open_info.values()[0][0]

        register_time = self._owner.base_info.register_time
        logger.debug("days %s tocurrent_days %s %s %s" %
                     (days, days_to_current(register_time),
                      string_to_timestamp_hms(ts), get_current_timestamp()))
        if days_to_current(register_time) > days - 1 or (
                days_to_current(register_time) == days - 1 and
                string_to_timestamp_hms(ts) < get_current_timestamp()):
            logger.debug("check open date True")
            return True
        return False

    def addexp(self, exp, reason):
        before_lv = self.level
        max_level = game_configs.base_config.get('player_level_max')
        if self.level == max_level:
            return
        self._exp += exp

        exp_config = game_configs.player_exp_config
        while self._exp >= exp_config.get(self.level).get('exp'):
            self._exp -= exp_config.get(self.level).get('exp')
            self.level += 1
            if self.level == max_level:
                self._exp = 0
                break
        # =====Tlog================
        tlog_action.log('PlayerExpFlow', self.owner, before_lv, exp, reason)

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
        if self._level != value:
            logger.info('player id:%s level up ++ %s>>%s', self.id,
                        self._level, value)
            # hook task
            hook_task(self.owner, CONDITIONId.LEVEL, self._level)
            target_update(self.owner, [43])
            self._level = value
            tb_character_level.zadd(self._level, self.id)

            # feature open
            if feature_open.is_not_open(self.owner, feature_open.FO_MINE):
                self.owner.mine.reset_data()

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
        return vip_content.shopRefreshTime

    @property
    def vip_shop_open(self):
        vip_content = game_configs.vip_config.get(self._vip_level)
        return vip_content.shopOpen

    @property
    def activity_copy_times1(self):
        """每日活动宝库副本次数"""
        vip_content = game_configs.vip_config.get(self._vip_level)
        return vip_content.activityCopyTimes1

    @property
    def activity_copy_times2(self):
        """每日活动校场副本次数"""
        vip_content = game_configs.vip_config.get(self._vip_level)
        return vip_content.activityCopyTimes2

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
    def buyGgzj_times(self):
        vip_content = game_configs.vip_config.get(self._vip_level)
        return vip_content.buyGgzjTimes

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
    def newbee_guide(self):
        return self._newbee_guide

    @newbee_guide.setter
    def newbee_guide(self, value):
        self._newbee_guide = value

    @property
    def current_newbee_guide(self):
        return self._current_newbee_guide

    @current_newbee_guide.setter
    def current_newbee_guide(self, value):
        self._current_newbee_guide = value

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
                self._vip_level = i
                self.save_data()
        hook_task(self.owner, CONDITIONId.VIP_LEVEL, self._vip_level)

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
    def story_id(self):
        return self._story_id

    @story_id.setter
    def story_id(self, value):
        self._story_id = value

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
    def max_single_recharge(self):
        return self._max_single_recharge

    @max_single_recharge.setter
    def max_single_recharge(self, value):
        self._max_single_recharge = value

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

    @property
    def is_open_next_day_activity(self):
        return self._is_open_next_day_activity

    @is_open_next_day_activity.setter
    def is_open_next_day_activity(self, value):
        self._is_open_next_day_activity = value

    @property
    def first_recharge_activity(self):
        return self._first_recharge_activity

    @first_recharge_activity.setter
    def first_recharge_activity(self, value):
        self._first_recharge_activity = value

    @property
    def buy_hjqy_max(self):
        """每日购买讨伐令上限"""
        vip_content = game_configs.vip_config.get(self._vip_level)
        return vip_content.buyhjqyCopyTimes

    @property
    def buy_shoe_max(self):
        """每日购买鞋子上限"""
        vip_content = game_configs.vip_config.get(self._vip_level)
        return vip_content.buyShoeTimes

    @property
    def buy_energy_max(self):
        """每日购买精力上限"""
        vip_content = game_configs.vip_config.get(self._vip_level)
        return vip_content.buyEnergyMax

    @property
    def num_gold_comsume(self):
        return self._recharge + self._gen_balance - self.owner.finance.gold

    def guild_escort_rob_times_max(self):
        """每日购买上限"""
        return 0

    @property
    def flowid(self):
        return self._flowid

    @flowid.setter
    def flowid(self, value):
        self._flowid = value

    @property
    def one_dollar_flowid(self):
        return self._one_dollar_flowid

    @one_dollar_flowid.setter
    def one_dollar_flowid(self, value):
        self._one_dollar_flowid = value

    @property
    def login_day(self):
        now = int(time.time())
        register_time = self.register_time
        time.localtime(register_time)

        time0 = get_time0(now)
        time1 = get_time0(register_time)
        day = (time0 - time1) / (24 * 60 * 60) + 1
        return day


def get_time0(t):
    # 时间戳当天的零点时间戳
    t1 = time.localtime(t)
    return int(time.mktime(time.strptime(
        time.strftime('%Y-%m-%d 00:00:00', t1), '%Y-%m-%d %H:%M:%S')))

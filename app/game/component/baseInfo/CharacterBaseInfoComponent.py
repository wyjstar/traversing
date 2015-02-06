# -*- coding:utf-8 -*-
"""
created by server on 14-5-27下午5:21.
"""

from shared.db_opear.configs_data.game_configs import player_exp_config
from shared.db_opear.configs_data.game_configs import base_config
from shared.db_opear.configs_data.game_configs import vip_config
from app.game.component.mine.monster_mine import MineOpt
from app.game.component.Component import Component
from app.game.redis_mode import tb_character_info
from app.proto_file.db_pb2 import Heads_DB
from gfirefly.server.logobj import logger
import time
from shared.tlog import tlog_action


class CharacterBaseInfoComponent(Component):
    """玩家基础信息组件类
    """
    def __init__(self, owner):
        """
        Constructor
        """
        Component.__init__(self, owner)
        self._id = 0                   # owner的id
        self._base_name = u''       # 基本名字
        self._level = 1  # 当前等级
        self._exp = 0  # 当前等级获得的经验

        self._newbee_guide_id = 0
        self._pvp_times = 0  # pvp次数
        self._pvp_refresh_time = 0
        self._pvp_refresh_count = 0
        self._pvp_high_rank = 999999  # 玩家pvp最高排名
        self._pvp_high_rank_award = []  # 已经领取的玩家pvp排名奖励

        self._heads = Heads_DB()
        self._heads.now_head = base_config.get('initialHead')

        self._vip_level = 0  # VIP等级
        self._vip_content = None  # VIP 相关内容，从config中获得
        self._upgrade_time = int(time.time())
        self._register_time  = int(time.time()) # 注册时间

    def init_data(self, character_info):
        self._id = character_info['id']
        self._base_name = character_info['nickname']
        self._level = character_info['level']
        MineOpt.asadd('user_level', self.owner.base_info.id, self._level)
        self._exp = character_info['exp']

        self._newbee_guide_id = character_info['newbee_guide_id']
        self._pvp_times = character_info['pvp_times']
        self._pvp_refresh_time = character_info['pvp_refresh_time']
        self._pvp_refresh_count = character_info['pvp_refresh_count']

        self._heads.ParseFromString(character_info['heads'])
        self._vip_level = character_info.get('vip_level')
        self._upgrade_time = character_info.get('upgrade_time', self._upgrade_time)
        self._register_time = character_info.get('register_time', self._register_time)

        self.update_vip()
        self.check_time()

    def save_data(self):
        character_info = tb_character_info.getObj(self._id)

        data = dict(level=self._level,
                    exp=self.exp,
                    pvp_times=self._pvp_times,
                    pvp_refresh_time=self._pvp_refresh_time,
                    pvp_refresh_count=self._pvp_refresh_count,
                    newbee_guide_id=self._newbee_guide_id,
                    vip_level=self._vip_level,
                    upgrade_time=self._upgrade_time,
                    heads=self._heads.SerializeToString(),
                    register_time=self._register_time)
        character_info.hmset(data)
        logger.debug("save level:%s,%s", str(self._id), str(data))

    def new_data(self):
        init_level = base_config.get('initialPlayerLevel')
        init_vip_level = base_config.get('initialVipLevel')
        data = dict(level=init_level,
                    exp=self.exp,
                    nickname=u'',
                    pvp_times=self._pvp_times,
                    pvp_refresh_time=self._pvp_refresh_time,
                    pvp_refresh_count=self._pvp_refresh_count,
                    newbee_guide_id=self._newbee_guide_id,
                    vip_level=init_vip_level,
                    upgrade_time=self._upgrade_time,
                    heads=self._heads.SerializeToString(),
                    register_time=self._register_time)
        return data

    def check_time(self):
        tm = time.localtime(self._pvp_refresh_time)
        local_tm = time.localtime()
        if local_tm.tm_year != tm.tm_year or local_tm.tm_yday != tm.tm_yday:
            self._pvp_times = 0
            self._pvp_refresh_count = 0
            self._pvp_refresh_time = time.time()
            self.save_data()

    def addexp(self, exp, reason):
        self._exp += exp
        before_level = self._level

        while self._exp >= player_exp_config.get(self._level).get('exp'):
            self._exp -= player_exp_config.get(self._level).get('exp')
            self._level += 1
            logger.info('player id:%s level up ++ %s>>%s', self._id, before_level, self._level)
            MineOpt.updata_level('user_level', self.owner.base_info.id,
                                 self._level-1, self._level)
            if not player_exp_config.get(self._level):
                return

        # =====Tlog================
        tlog_action.log('PlayerExpFlow', self.owner, before_level,
                        exp, reason)

    @property
    def id(self):
        return self._id

    @id.setter
    def id(self, bid):
        self._id = bid

    @property
    def base_name(self):
        return self._base_name

    @base_name.setter
    def base_name(self, base_name):
        self._base_name = base_name

    @property
    def level(self):
        return self._level

    @property
    def exp(self):
        return self._exp

    @property
    def vip_level(self):
        return self._vip_level

    @vip_level.setter
    def vip_level(self, vip_level):
        self._vip_level = vip_level
        self.update_vip()

    @property
    def open_sweep(self):
        """解锁扫荡"""
        return self._vip_content.openSweep

    @property
    def open_sweep_ten(self):
        """解锁扫荡十次"""
        return self._vip_content.openSweepTen

    @property
    def free_sweep_times(self):
        """每日免费扫荡次数"""
        return self._vip_content.freeSweepTimes

    @property
    def reset_stage_times(self):
        """关卡重置次数"""
        return self._vip_content.resetStageTimes

    @property
    def reset_arena_cd(self):
        """重置竞技场CD"""
        return self._vip_content.resetArenaCD

    @property
    def buy_arena_times(self):
        """购买竞技场次数"""
        return self._vip_content.buyArenaTimes

    @property
    def buy_stamina_max(self):
        """每日购买体力上限"""
        return self._vip_content.buyStaminaMax

    @property
    def equipment_strength_one_key(self):
        """装备一键强化"""
        return self._vip_content.equipmentStrengthOneKey

    @property
    def shop_refresh_times(self):
        """每日商店刷新次数"""
        return self._vip_content.shopRefreshTimes

    @property
    def activity_copy_times(self):
        """每日活动副本次数"""
        return self._vip_content.activityCopyTimes

    @property
    def elite_copy_times(self):
        """每日精英副本次数"""
        return self._vip_content.eliteCopyTimes

    @property
    def equipment_strength_cli_times(self):
        """装备强化暴击次数"""
        return self._vip_content.equipmentStrengthCliTimes

    @property
    def gifts(self):
        """获得礼包"""
        # todo: send mail
        return self._vip_content.gifts

    @property
    def buy_gifts(self):
        """可购买的礼包"""
        # todo: 礼包ID
        return self._vip_content.buyGifts

    @property
    def guild_worship_times(self):
        """公会膜拜次数"""
        return self._vip_content.guildWorshipTimes

    def update_vip(self):
        """更新VIP组件"""
        self._vip_content = vip_config.get(self._vip_level)

    @property
    def war_refresh_times(self):
        return self._vip_content.warFogRefreshNum

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
    def pvp_times(self):
        return self._pvp_times

    @pvp_times.setter
    def pvp_times(self, value):
        self._pvp_times = value

    @property
    def pvp_refresh_count(self):
        return self._pvp_refresh_count

    @pvp_refresh_count.setter
    def pvp_refresh_count(self, value):
        self._pvp_refresh_count = value

    @property
    def pvp_refresh_time(self):
        return self._pvp_refresh_time

    @pvp_refresh_time.setter
    def pvp_refresh_time(self, value):
        self._pvp_refresh_time = value

    @property
    def upgrade_time(self):
        return self._upgrade_time

    @upgrade_time.setter
    def upgrade_time(self, value):
        self._upgrade_time = value

    @property
    def register_time(self):
        return self._register_time

    @register_time.setter
    def register_time(self, value):
        self._register_time = value

    @property
    def pvp_high_rank(self):
        return self._pvp_high_rank

    @pvp_high_rank.setter
    def pvp_high_rank(self, value):
        self._pvp_high_rank = value

    @property
    def pvp_high_rank_award(self):
        return self._pvp_high_rank_award

    @pvp_high_rank_award.setter
    def pvp_high_rank_award(self, value):
        self._pvp_high_rank_award = value

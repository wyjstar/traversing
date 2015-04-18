#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
created by wzp.
"""
from shared.utils.date_util import get_current_timestamp
from shared.utils.date_util import str_time_period_to_timestamp
from shared.utils.ranking import Ranking
from gfirefly.dbentrust.redis_mode import RedisObject
from gfirefly.server.logobj import logger
from app.world.core.base_boss import BaseBoss
from shared.db_opear.configs_data import game_configs
from gtwisted.core import reactor
import cPickle
import random
import time
from gfirefly.server.globalobject import GlobalObject
from app.proto_file.db_pb2 import Mail_PB, WorldBossAwardDB
from shared.utils.date_util import str_time_to_timestamp
from app.world.action.gateforwarding import push_all_object_message
from app.proto_file.notice_pb2 import NoticeResponse
from shared.utils.random_pick import random_pick_with_percent
from shared.utils.date_util import string_to_timestamp
from shared.utils.const import const
from gfirefly.server.logobj import logger


tb_boss = RedisObject('tb_worldboss')


class WorldBoss(BaseBoss):
    """docstring for WorldBoss"""
    def __init__(self, boss_name, rank_instance, config_name):
        super(WorldBoss, self).__init__(boss_name, rank_instance, config_name, tb_boss)
        self._stage_id_am = 0         # 关卡id am
        self._stage_id_pm = 0         # 关卡id pm
        self._state = 0               # boss状态：用于boss到期, 重置状态

        self.init_data()
        self.init_time()
        reactor.callLater(1, self.loop_update)

    def init_data(self):
        """docstring for init_data"""
        str_data = tb_boss.get(self._boss_name)
        if not str_data:
            logger.debug("init data...")
            self.update_boss()
            return
        world_boss_data = cPickle.loads(str_data)
        self.init_base_data(world_boss_data)
        self._stage_id_am = world_boss_data.get("stage_id_am")
        self._stage_id_pm = world_boss_data.get("stage_id_pm")

    def init_time(self):
        am_period = self.get_stage_period(self._stage_id_am)
        # pm_period = self.get_stage_period(self._stage_id_pm)

        current = get_current_timestamp()
        if current < am_period[1]:
            self._stage_id = self._stage_id_am
        elif current > am_period[1]:
            self._stage_id = self._stage_id_pm

    def save_data(self):
        base_boss_data = self.get_data_dict()
        world_boss_data = dict(stage_id_am=self._stage_id_am,
                               stage_id_pm=self._stage_id_pm,)
        world_boss_data.update(base_boss_data)
        str_data = cPickle.dumps(world_boss_data)
        tb_boss.set(self._boss_name, str_data)

    def loop_update(self):
        # notice
        notice_item = game_configs.notes_config.get(1001)
        current_time = time.time()
        #logger.debug("current_time:%s, target_time:%s" % (current_time, str_time_to_timestamp(notice_item.parameter1[0])))
        time1 = str_time_to_timestamp(notice_item.parameter1[0])
        time2 = str_time_to_timestamp(notice_item.parameter1[1])
        if (current_time < time1 and current_time > time1-1) or (current_time < time2 and current_time > time2-1):
            response = NoticeResponse()
            response.notice_id = 1001
            push_all_object_message(2000, response.SerializePartialToString())

        if self._stage_id and self.in_the_time_period() and self._state == 0:
            self.start_boss()
            self._state = 1

        if self._stage_id and self._state == 1 and (not self.in_the_time_period()):
            self.update_boss()
            self._state = 0
        reactor.callLater(1, self.loop_update)

    def start_boss(self):
        self._rank_instance.clear_rank()  # 重置排行
        self._last_shot_item = {}  # 重置最后击杀

    def update_lucky_hero(self):
        # 初始化幸运武将
        lucky_heros = {}
        hero_infos = self.get_lucky_hero_items_in_time()
        for k, hero_info in hero_infos.items():
            hero_pool = hero_info.hero
            for _, v in lucky_heros.items():
                hero_no = unicode(v.get('hero_no'))
                if hero_no in hero_pool:
                    del hero_pool[hero_no]
            res = random_pick_with_percent(hero_pool)
            temp = {}
            temp['lucky_hero_info_id'] = k
            temp['hero_no']  = int(res)
            lucky_heros[hero_info.set] = temp
        self._lucky_heros = lucky_heros

    def get_lucky_hero_items_in_time(self):
        """docstring for get_lucky_hero_items_in_time"""
        items = {}
        current = time.time()
        for k, v in game_configs.lucky_hero_config.items():
            start = string_to_timestamp(v.timeStart)
            end = string_to_timestamp(v.timeEnd)
            if current > start and current < end:
                items[k] = v
        return items


    def update_boss(self):
        """
        boss被打死或者boss到期后，更新下一个boss相关信息。
        """
        self.set_next_stage(self._hp <= 0)
        self.update_lucky_hero()
        self.update_base_boss(game_configs.base_config.get("world_boss"))

        self.save_data()

        # 发放奖励：前十名, 累积伤害, 最后击杀, 参与奖
        self.send_award_top_ten()
        self.send_award_add_up()
        self.send_award_kill()

    def send_award_top_ten(self):
        """
        排行奖励, top 10
        """
        award_info = game_configs.base_config.get('hurt_rank_rewards')
        for up, down, big_bag_id in award_info.values():
            ranks = self._rank_instance.get(up, down)
            for player_id, v in ranks:
                self.send_award(player_id, const.PVB_TOP_TEN_AWARD, big_bag_id)

    def send_award_add_up(self):
        """
        累积奖励
        """
        i = 0
        hp_max = self.get_hp()
        accumulated_rewards = game_configs.base_config.get('accumulated_rewards')
        while True and i < 1000:
            i+=1
            ranks = self._rank_instance.get(100*(i-1)+1, 100*i)
            logger.debug("send_award_add_up: %s" % ranks)
            if len(ranks) == 0:
                return
            for player_id, v in ranks:
                for i in range(5, 1, -1):
                    reward_info = accumulated_rewards.get(i)
                    if hp_max * reward_info[0] < v:
                        self.send_award(player_id, const.PVB_TOP_TEN_AWARD, reward_info[1])
                        break
                    else:
                        return

    def send_award_last(self):
        """
        最后击杀
        """
        player_id = self._last_shot_item['player_id']
        big_bag_id = game_configs.base_config.get('accumulated_rewards')
        self.send_award(player_id, const.PVB_LAST_AWARD, big_bag_id)

    def send_award(self, player_id, award_type, award):
        """
        发送奖励
        """
        award_data = WorldBossAwardDB()
        award_data.award_type = award_type
        award_data.award = cPickle.dumps(award)
        remote_gate = GlobalObject().root.childsmanager.childs.values()[0]
        remote_gate.push_message_to_transit_remote('receive_pvb_award_remote',
                                                    int(player_id), award_data)
    def send_award_damage(self):
        award_mail = game_configs.base_config.get('hurt_rewards_worldboss_rank')
        for up, down, mail_id in award_mail.values():
            ranks = self._rank_instance.get(up, down)
            for player_id, v in ranks:
                mail = Mail_PB()
                mail.config_id = mail_id
                mail.receive_id = int(player_id)
                mail.send_time = int(time.time())
                mail_data = mail.SerializePartialToString()

                remote_gate = GlobalObject().root.childsmanager.childs.values()[0]
                remote_gate.push_message_to_transit_remote('receive_mail_remote',
                                                           int(player_id), mail_data)

    def send_award_kill(self):
        if not self._last_shot_item:
            return
        mail_id = game_configs.base_config.get('kill_rewards_worldboss')

        player_id = self._last_shot_item['player_id']
        mail = Mail_PB()
        mail.config_id = mail_id
        mail.receive_id = player_id
        mail.send_time = int(time.time())
        mail_data = mail.SerializePartialToString()
        remote_gate = GlobalObject().root.childsmanager.childs.values()[0]
        remote_gate.push_message_to_transit_remote('receive_mail_remote',
                                                   player_id, mail_data)

    def set_next_stage(self, kill_or_not=False):
        """
        根据id规则确定下一个关卡
        如果boss未被击杀则不升级
        """
        logger.debug("current_stage_id1%s" % self._stage_id)
        current_stage_id = self._stage_id
        origin_stage_id_am = self._stage_id_am
        if current_stage_id == 0:
            self._stage_id_am = 800101
            self._stage_id_pm = 800102
            self._stage_id = 800101
            return
        if kill_or_not:  # 如果boss被击杀，则升级boss
            if current_stage_id == self._stage_id_am: # am
                self._stage_id_am = current_stage_id + 100
            else:  # pm
                self._stage_id_pm = current_stage_id + 100

        if current_stage_id == origin_stage_id_am:
            self._stage_id = self._stage_id_pm
        else:
            self._stage_id = self._stage_id_am

        logger.debug("current_stage_id3%s" % self._stage_id)
        logger.debug("current_stage_id_am%s" % self._stage_id_am)
        logger.debug("current_stage_id_pm%s" % self._stage_id_pm)

    def get_stage_period(self, stage_id):
        """docstring for get_am_period"""
        stage_info = self.get_stage_info(stage_id)
        time_start, time_end = str_time_period_to_timestamp(stage_info.timeControl)
        return time_start, time_end

    @property
    def open_or_not(self):
        return self.in_the_time_period()


world_boss = WorldBoss("world_boss",
                       Ranking.instance("WorldBossDemage"),
                       "world_boss_stages")

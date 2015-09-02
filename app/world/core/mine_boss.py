#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
created by wzp.
"""
from shared.utils.ranking import Ranking
from gfirefly.dbentrust.redis_mode import RedisObject
from gfirefly.server.logobj import logger
from app.world.core.base_boss import BaseBoss
from shared.db_opear.configs_data import game_configs
from shared.utils.date_util import is_next_day
from gfirefly.server.globalobject import GlobalObject
from app.proto_file.db_pb2 import Mail_PB
import cPickle
import time


tb_boss = RedisObject('tb_mineboss')
tb_boss_manager = RedisObject('tb_minebossmanager')


class MineBossManager(object):
    """docstring for MineBoss"""
    def __init__(self):
        super(MineBossManager, self).__init__()
        # self._bosses = {}  # 所有boss
        self._boss = None  # current boss
        self._base_data_name = "mine_boss"
        self._base_demage_name = "MineBossDemage"
        self._last_time = 0
        self._boss_num = 0

        str_data = tb_boss_manager.get("")
        if str_data:
            data = cPickle.loads(str_data)
            self._last_time = data.get("boss_num")
            self._boss_num = data.get("last_time")

        #boss_name, boss_demage_name = self.get_boss_name()
        #Ranking.init(boss_demage_name, 10)
        #boss = MineBoss(boss_name, Ranking.instance(boss_demage_name),
                        #"mine_boss_stages")
        #self._boss = boss


    def add(self):
        """docstring for add"""
        boss_name, boss_demage_name = self.get_boss_name()
        Ranking.init(boss_demage_name, 10)
        boss = MineBoss(boss_name, Ranking.instance(boss_demage_name),
                        "mine_boss_stages")
        self._boss = boss
        current_time = time.time()
        self._last_time = current_time
        self._boss_num += 1
        self.save_data()
        return "boss_id", boss

    def get_boss_name(self):
        """docstring for get_boss_name"""
        return "mine_boss", "mine_boss_demage"

    def get_current_boss(self):
        return self._boss

    def remove(self):
        self._boss = None

    def get_boss_num(self):
        """
        获取boss数量
        """
        current_time = time.time()
        if is_next_day(current_time, self._last_time):
            self._boss_num = 0
        return self._boss_num

    def current_has_boss(self):
        #return len(self._bosses) == 1
        return self._boss != None

    def save_data(self):
        data = dict(boss_num=self._boss_num, last_time=self._last_time)
        str_data = cPickle.dumps(data)
        tb_boss_manager.set("", str_data)


class MineBoss(BaseBoss):
    """随机boss"""
    def __init__(self, boss_name, rank_instance, config_name):
        super(MineBoss, self).__init__(boss_name, rank_instance, config_name, tb_boss)
        self.init_data()

    def init_data(self):
        """docstring for init_data"""
        str_data = tb_boss.get(self._boss_name)
        if not str_data:
            logger.debug("init data...")
            self.update_boss()
            return
        world_boss_data = cPickle.loads(str_data)
        self.init_base_data(world_boss_data)

    def update_boss(self):
        self._stage_id = 820001
        self.update_base_boss(game_configs.base_config.get("mine_boss"))

        # todo:对前十名和最后击杀者发放奖励
        if self._last_shot_item:
            self.send_award_mail_kill()
        self.send_award_mail_damage()

    def send_award_mail_damage(self):
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

    def send_award_mail_kill(self):
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

    @property
    def open_or_not(self):
        return True

    def save_data(self):
        base_boss_data = self.get_data_dict()

        str_data = cPickle.dumps(base_boss_data)
        tb_boss.set(self._boss_name, str_data)


mine_boss_manager = MineBossManager()

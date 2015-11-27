# -*- coding:utf-8 -*-

#from shared.db_opear.configs_data import game_configs
from gfirefly.server.logobj import logger
from shared.utils.date_util import get_current_timestamp
#from shared.utils.pyuuid import get_uuid
#from app.game.action.node._fight_start_logic import assemble

class EscortTask(object):
    """粮草押运任务"""

    def __init__(self, owner):
        self._owner = owner
        self._task_id = ''
        self._task_no = 0
        self._state = 0 # 0: 初始状态；1：接受任务2：开始押运3已经完成
        self._receive_task_time = 0 #
        self._start_protect_time = 0 #
        self._protect_guild_info = {}
        self._protecters = []

        self._rob_task_infos = {}

    def init_data(self, info):
        self.load(info)


    def add_player(self, player_info, protect_or_rob, header=0, guild_info={}):
        if protect_or_rob == 1:
            if not self._protecters:
                logger.debug("receive task add player==============")
                self._protect_guild_info = guild_info
                self._receive_task_time = int(get_current_timestamp())
            self._protecters.append(player_info)
        elif protect_or_rob == 2:
            if not header:
                rob_task_info = {}
                rob_task_info["robbers"] = []
                rob_task_info["robbers"].append(player_info)
                rob_task_info["rob_result"] = False
                rob_task_info["rob_state"] = 1
                rob_task_info["rob_receive_task_time"] = int(get_current_timestamp())
                rob_task_info["rob_guild_info"] = guild_info
                self._rob_task_infos[player_info.get("id")] = rob_task_info
            else:
                rob_task_info = self._rob_task_infos.get(header)
                rob_task_info["robbers"].append(player_info)
        # add player position to player_info
        guild_position = 3
        p_list = guild_info.get("p_list", {})
        player_id = player_info.get("id")
        if player_id in p_list:
            guild_position = 1
        if player_id in p_list:
            guild_position = 2
        player_info["guild_position"] = guild_position

        return True

    def update_state(self, task_item):
        self.update_finish(task_item)
        self.update_start(task_item)
        self.update_rob_cancel(task_item)

    def is_finished(self, task_item):
        if self.state == -1: return False
        if self._start_protect_time and self._start_protect_time + task_item.taskTime < get_current_timestamp():
            return True
        elif not self._start_protect_time and self._receive_task_time + task_item.wait + task_item.taskTime < get_current_timestamp():
            return True
        return False
    def is_started(self, task_item):
        if self.state == 1 and \
            self._receive_task_time + task_item.wait > get_current_timestamp() and \
            self._receive_task_time + task_item.wait + task_item.taskTime < get_current_timestamp():
            return True
        return False
    def update_rob_state(self, task_item):
        for _, rob_task_info in self._rob_task_infos.items():
            if rob_task_info.get("rob_state") == 1 and \
                rob_task_info.get("rob_receive_task_time") + 60 < get_current_timestamp():
                rob_task_info["rob_state"] = 0

        if self.state == 1 and \
            self._receive_task_time + task_item.wait > get_current_timestamp() and \
            self._receive_task_time + task_item.wait + task_item.taskTime < get_current_timestamp():
            return True
        return False


    def rob_success_times(self):
        """
        劫运成功的次数
        """
        times = 0
        for rob_task_info in self._rob_task_infos:
            if rob_task_info.get("rob_result"):
                times = times + 1
        return times

    def save_data(self):
        """
        保存
        """
        tb_guild = self._owner._tb_guild_info.getObj(self._owner.g_id).getObj('escort_tasks')
        data = self.property_dict()
        if not tb_guild.hset(data['task_id'], data):
            logger.error('save escort task error:%s', data['task_id'])

    def property_dict(self):
        """docstring for property_dict"""
        return {
                "task_id": self._task_id,
                "task_no": self._task_no,
                "state": self._state,
                "receive_task_time": self._receive_task_time,
                "start_protect_time": self._start_protect_time,
                "protect_guild_info": self._protect_guild_info,
                "protecters": self._protecters,
                "rob_task_infos": self._rob_task_infos,
                }

    def load(self, task_info):
        """
        根据字典类型的数据初始化对象
        """

        self._task_id = task_info.get("task_id")
        self._task_no = task_info.get("task_no")
        self._state = task_info.get("state")
        self._receive_task_time = int(task_info.get("receive_task_time"))
        self._start_protect_time = int(task_info.get("start_protect_time"))
        self._protect_guild_info = task_info.get("protect_guild_info")
        self._protecters = task_info.get("protecters")
        self._rob_task_infos = task_info.get("rob_task_infos")

    def update_rob_task_info(self, rob_task_info, header):
        __rob_task_info = self._rob_task_infos.get(header)
        __rob_task_info["seed1"] = rob_task_info["seed1"]
        __rob_task_info["seed2"] = rob_task_info["seed2"]
        __rob_task_info["rob_reward"] = rob_task_info["rob_reward"]
        __rob_task_info["rob_result"] = rob_task_info["rob_result"]
        __rob_task_info["rob_time"] = int(rob_task_info["rob_time"])

    def cancel_rob_task(self, header):
        """取消劫运"""
        rob_task_info = self._rob_task_infos[header]
        rob_task_info["rob_state"] = 0
        return rob_task_info

    @property
    def task_id(self):
        return self._task_id

    @task_id.setter
    def task_id(self, value):
        self._task_id = value

    @property
    def task_no(self):
        return self._task_no

    @task_no.setter
    def task_no(self, value):
        self._task_no = value

    @property
    def state(self):
        print("state get", self._state)
        return self._state

    @state.setter
    def state(self, value):
        print("state set %s-> %s" % (self._state, value))
        self._state = value

    @property
    def receive_task_time(self):
        return self._receive_task_time

    @receive_task_time.setter
    def receive_task_time(self, value):
        self._receive_task_time = value

    @property
    def start_protect_time(self):
        return self._start_protect_time

    @start_protect_time.setter
    def start_protect_time(self, value):
        self._start_protect_time = value

    @property
    def protect_guild_info(self):
        return self._protect_guild_info

    @protect_guild_info.setter
    def protect_guild_info(self, value):
        self._protect_guild_info = value

    @property
    def protecters(self):
        return self._protecters

    @protecters.setter
    def protecters(self, value):
        self._protecters = value

    @property
    def rob_task_infos(self):
        return self._rob_task_infos

    @rob_task_infos.setter
    def rob_task_infos(self, value):
        self._rob_task_infos = value

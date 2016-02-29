# -*- coding:utf-8 -*-

from shared.db_opear.configs_data import game_configs
from gfirefly.server.logobj import logger
from shared.utils.date_util import get_current_timestamp
from gfirefly.dbentrust.redis_mode import RedisObject
from shared.utils.mail_helper import deal_mail
from gfirefly.server.globalobject import GlobalObject
from shared.db_opear.configs_data.data_helper import convert_common_resource2mail

tb_guild_info = RedisObject('tb_guild_info')
#from shared.utils.pyuuid import get_uuid
#from app.game.action.node._fight_start_logic import assemble

def get_remote_gate():
    """docstring for get_remote_gate"""
    return GlobalObject().child('gate')


def send_mail(conf_id, receive_id, prize):
        mail_data, _ = deal_mail(conf_id=conf_id, receive_id=int(receive_id), prize=prize)
        get_remote_gate().push_message_to_transit_remote('receive_mail_remote',
                                                   int(receive_id), mail_data)


def calculate_reward(peoplePercentage, robbedPercentage, formula_name, task_item, guild):
    """docstring for calculate_reward"""
    logger.debug("peoplePercentage robbedPercentage %s %s %s" % (peoplePercentage, robbedPercentage, guild.g_id))
    logger.debug("reward %s %s %s" % (task_item.reward1, task_item.reward2, task_item.reward3))
    escort_formula = game_configs.formula_config.get(formula_name).get("formula")
    assert escort_formula!=None, "escort_formula can not be None!"
    percent = eval(escort_formula, {"peoplePercentage": peoplePercentage, "robbedPercentage": robbedPercentage})

    # add contribution
    #reward2 = task_item.reward2
    #if reward2:
        #guild.contribution += task_item.reward2[0].num
        #guild.all_contribution += task_item.reward2[0].num
        #guild.save_data()
    # send reward mail
    mail_arg1 = []
    mail_arg1.extend(convert_common_resource2mail(task_item.get("reward1")))
    mail_arg1.extend(convert_common_resource2mail(task_item.get("reward2")))
    mail_arg1.extend(convert_common_resource2mail(task_item.get("reward3")))
    logger.debug("mail_arg1 %s percent %s" % (mail_arg1, percent))
    for tmp in mail_arg1:
        for _, tmp_info in tmp.items():
            tmp_info[0] = int(tmp_info[0] * percent)
            tmp_info[1] = int(tmp_info[1] * percent)

    logger.debug("mail_arg1 %s percent %s" % (mail_arg1, percent))
    return mail_arg1

def get_reward(reward, guild):
    """添加贡献值，分别处理"""
    logger.debug("reward %s guildid %s" % (reward, guild.g_id))
    mail_reward = []
    for reward_item in reward:
        if not reward_item:
            continue
        item = reward_item.values()[0]
        if item[2] == 5:
            guild.contribution += item[0]
            guild.all_contribution += item[0]
            guild.save_data()
        else:
            mail_reward.append(reward_item)
    return mail_reward

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
        self._reward = []
        self._last_send_invite_time = 0

        self._rob_task_infos = []

    def init_data(self, info):
        self.load(info)


    def add_player(self, player_info, protect_or_rob, rob_no=-1, guild_info={}):
        if protect_or_rob == 1 and len(self._protecters) < 3:
            if not self._protecters:
                logger.debug("receive task add player==============")
                self._protect_guild_info = guild_info
                self._receive_task_time = int(get_current_timestamp())
            self._protecters.append(player_info)
        elif protect_or_rob == 2:
            if rob_no == -1:
                rob_task_info = {}
                rob_task_info["robbers"] = []
                rob_task_info["robbers"].append(player_info)
                rob_task_info["rob_result"] = False
                rob_task_info["rob_state"] = 1
                rob_task_info["rob_receive_task_time"] = int(get_current_timestamp())
                rob_task_info["rob_guild_info"] = guild_info
                rob_no = len(self._rob_task_infos)
                rob_task_info["rob_no"] = rob_no
                self._rob_task_infos.append(rob_task_info)
            else:
                rob_task_info = self._rob_task_infos[rob_no]
                if len(rob_task_info["robbers"]) < 3:
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

        return dict(rob_no=rob_no)


    def is_finished(self, task_item):
        if self.state == -1: return False
        if self._start_protect_time and self._start_protect_time + task_item.taskTime < get_current_timestamp():
            return True
        elif not self._start_protect_time and self._receive_task_time + task_item.wait + task_item.taskTime < get_current_timestamp():
            self._start_protect_time = self._receive_task_time + task_item.wait
            return True
        return False

    def is_started(self, task_item):
        if self.state == 1 and \
            self._receive_task_time + task_item.wait < get_current_timestamp() and \
            self._receive_task_time + task_item.wait + task_item.taskTime > get_current_timestamp():
            self._start_protect_time = int(get_current_timestamp())
            return True
        return False

    def update_rob_state(self, task_item):

        for rob_task_info in self._rob_task_infos:
            if rob_task_info.get("rob_state") == 1 and \
                rob_task_info.get("rob_receive_task_time") + task_item.wait < get_current_timestamp():
                rob_task_info["rob_state"] = 0

    def update_task_state(self):
        guild = self._owner
        task_item = game_configs.guild_task_config.get(self._task_no)
        if self.is_started(task_item):
            self.state = 2
            guild.escort_tasks_can_rob.append(self.task_id)
        if self.is_finished(task_item):
            self.state = -1
            self.update_reward(task_item)
            for player_info in self.protecters:
                print '===================================abc', self._reward
                send_mail(conf_id=1001, receive_id=player_info.get("id"),
                                      prize=str(get_reward(self._reward, guild)))
            if self.task_id in guild.escort_tasks_can_rob:
                guild.escort_tasks_can_rob.remove(self._task_id)
            # add guild activity times
            for protecter in self.protecters:
                get_remote_gate().push_message_to_transit_remote('add_guild_activity_times_remote',
                                                   int(protecter.get("id")), self.task_no, 1)

        self.update_rob_state(task_item)
        self.save_data()


    def update_reward(self, task_item={}):
        logger.debug("update_reward================")
        if not task_item:
            task_item = game_configs.guild_task_config.get(self._task_no)

        protecters_num = len(self.protecters)
        print(task_item.peoplePercentage, protecters_num, "update_task_state")
        peoplePercentage = task_item.peoplePercentage.get(protecters_num)
        robbedPercentage = 0
        for t in range(self.rob_success_times()):
            robbedPercentage = robbedPercentage + task_item.robbedPercentage.get(t+1)


        mail_arg1 = calculate_reward(peoplePercentage, robbedPercentage, "EscortReward", task_item, self._owner)
        self._reward = mail_arg1


    def rob_success_times(self):
        """
        劫运成功的次数
        """
        times = 0
        for rob_task_info in self._rob_task_infos:
            if rob_task_info.get("rob_result"):
                times = times + 1
        logger.debug("rob_success_times %s" % times)
        if times > 2:
            times = 2
        return times

    def has_robbed(self, player_id):
        """
        已经劫过了
        """
        res = False
        for rob_task_info in self._rob_task_infos:
            if rob_task_info.get("rob_result") and rob_task_info.get("robbers")[0].get("id") == player_id:
                logger.debug("has_robbed %s %s" %(player_id, rob_task_info.get("robbers")[0].get("id")))
                res = True
        return res

    def has_robbing(self, player_id):
        """
        存在正在劫运的任务
        """
        res = False
        for rob_task_info in self._rob_task_infos:
            if rob_task_info.get("rob_state") == 1 and rob_task_info.get("robbers")[0].get("id") == player_id:
                res = True
        return res


    def save_data(self):
        """
        保存
        """
        tb_guild = tb_guild_info.getObj(self._owner.g_id).getObj('escort_tasks')
        data = self.property_dict()
        if not tb_guild.hset(data['task_id'], data):
            logger.error('save escort task error:%s', data['task_id'])

    def property_dict(self, rob_no=-1):
        """docstring for property_dict"""
        rob_task_infos = self._rob_task_infos
        logger.debug("rob_no %s len rob_task_infos %s" % (rob_no, len(rob_task_infos)))
        if rob_no != -1 and self._rob_task_infos:
            rob_task_infos = [self._rob_task_infos[rob_no]]


        return {
                "task_id": self._task_id,
                "task_no": self._task_no,
                "state": self._state,
                "receive_task_time": self._receive_task_time,
                "start_protect_time": self._start_protect_time,
                "protect_guild_info": self._protect_guild_info,
                "protecters": self._protecters,
                "rob_task_infos": rob_task_infos,
                "reward": self._reward,
                "last_send_invite_time": self._last_send_invite_time,
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
        self._last_send_invite_time = task_info.get("last_send_invite_time", 0)
        self._reward = task_info.get("reward", [])

    #def update_rob_task_info(self, rob_task_info, header):
        #__rob_task_info = self._rob_task_infos.get(header)
        #__rob_task_info["seed1"] = rob_task_info["seed1"]
        #__rob_task_info["seed2"] = rob_task_info["seed2"]
        #__rob_task_info["rob_reward"] = rob_task_info["rob_reward"]
        #__rob_task_info["rob_result"] = rob_task_info["rob_result"]
        #__rob_task_info["rob_time"] = int(rob_task_info["rob_time"])

    def cancel_rob_task(self, rob_no):
        """取消劫运"""
        rob_task_info = self._rob_task_infos[rob_no]
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

    @property
    def last_send_invite_time(self):
        return self._last_send_invite_time

    @last_send_invite_time.setter
    def last_send_invite_time(self, value):
        self._last_send_invite_time = value

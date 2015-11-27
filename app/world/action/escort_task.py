#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
created by wzp.
"""
from gfirefly.server.globalobject import rootserviceHandle
from app.battle.server_process import guild_pvp_start
import cPickle
#from shared.utils.date_util import get_current_timestamp
#from app.world.action.gateforwarding import push_all_object_message
from gfirefly.server.logobj import logger
from shared.db_opear.configs_data import game_configs
from shared.utils.mail_helper import deal_mail
from app.game.action.node._fight_start_logic import get_seeds
from shared.utils.date_util import get_current_timestamp
from app.world.core.guild_manager import guild_manager_obj
from shared.db_opear.configs_data.data_helper import convert_common_resource2mail
from gfirefly.server.globalobject import GlobalObject

@rootserviceHandle
def get_guild_task_records_remote(guild_id):
    """
    获取军团押劫记录
    """
    tasks = {}
    guild = guild_manager_obj.get_guild_obj(guild_id)
    for task_id, task in guild.escort_tasks.items():
        if task.state in [2, -1]:
            tasks[task_id] = construct_task_data(task)

    return tasks

@rootserviceHandle
def get_invite_remote(guild_id, protect_or_rob):
    """
    获取邀请
    """
    tasks = {}
    guild = guild_manager_obj.get_guild_obj(guild_id)
    if protect_or_rob == 1:
        for task_id, guild_id in guild.escort_tasks_invite_protect.items():
            task = guild.get_task_by_id(task_id)
            tasks[task_id] = construct_task_data(task)
    if protect_or_rob == 2:
        for task_id, guild_id in guild.escort_tasks_invite_rob.items():
            guild = guild_manager_obj.get_guild_obj(guild_id)
            task = guild.get_task_by_id(task_id)
            tasks[task_id] = construct_task_data(task)

    return tasks

@rootserviceHandle
def get_can_rob_tasks_remote(g_id):
    """
    获取可押劫的任务
    """
    tasks = {}
    for task_id, task in guild_manager_obj.get_can_rob_escort_tasks(g_id).items():
        tasks[task_id] = construct_task_data(task)
    logger.debug("get_can_rob_tasks_remote %s" % tasks)
    return tasks

def construct_task_data(task):
    return task.property_dict()

@rootserviceHandle
def get_task_by_id_remote(guild_id, task_id):
    guild = guild_manager_obj.get_guild_obj(guild_id)
    task = guild.get_task_by_id(task_id)
    return construct_task_data(task)

@rootserviceHandle
def get_tasks_by_ids_remote(task_ids):
    tasks = {}
    for task_id, guild_id in task_ids.items():
        guild = guild_manager_obj.get_guild_obj(guild_id)
        task = guild.get_task_by_id(task_id)
        tasks[task_id] = construct_task_data(task)
    return tasks

@rootserviceHandle
def add_task_remote(guild_id, task_info):
    guild = guild_manager_obj.get_guild_obj(guild_id)
    guild.add_task(task_info)
    return True

@rootserviceHandle
def add_player_remote(guild_id, task_id, player_info, protect_or_rob, header):
    logger.debug("add_player_remote %s %s %s %s %s" % (guild_id, task_id, player_info, protect_or_rob, header))
    guild = guild_manager_obj.get_guild_obj(guild_id)
    task = guild.get_task_by_id(task_id)

    player_guild = guild_manager_obj.get_guild_obj(player_info.get("g_id"))
    task.add_player(player_info, protect_or_rob, header, player_guild.guild_info())

    #task.state = 1
    task.save_data()
    return construct_task_data(task)


@rootserviceHandle
def start_protect_task_remote(guild_id, task_id):
    """
    开始保护押运任务
    """
    guild = guild_manager_obj.get_guild_obj(guild_id)
    task = guild.get_task_by_id(task_id)
    logger.debug("task state %s" % task.state)
    task.state = 2
    logger.debug("task state %s" % task.state)
    task.start_protect_time = int(get_current_timestamp())
    guild.escort_tasks_can_rob.append(task_id)
    guild.save_data()
    task.save_data()

@rootserviceHandle
def send_escort_task_invite_remote(guild_id, task_id, player_guild_id, protect_or_rob):
    """
    发送邀请到玩家所在公会
    """
    guild = guild_manager_obj.get_guild_obj(player_guild_id)
    if protect_or_rob == 1:
        guild.escort_tasks_invite_protect[task_id] = guild_id
    elif protect_or_rob == 2:
        guild.escort_tasks_invite_rob[task_id] = guild_id

    return construct_task_data(guild.get_task_by_id(task_id))

@rootserviceHandle
def cancel_rob_task_remote(guild_id, task_id, header):
    """取消劫运任务"""
    guild = guild_manager_obj.get_guild_obj(guild_id)
    task = guild.get_task_by_id(task_id)
    task.cancel_rob_task(header)
    task.save_data()

#@rootserviceHandle
#def push_to_guild_members(guild_id, data, members):
    #pass
    #remote_gate = GlobalObject().child('gate')
    #remote_gate.push_message_to_transit_remote('receive_mail_remote',
                                               #int(player_id), mail_data)
@rootserviceHandle
def start_rob_escort_remote(guild_id, task_id, header):

    guild = guild_manager_obj.get_guild_obj(guild_id)
    task = guild.get_task_by_id(task_id)
    # get robbed success num
    robbed_num = 0
    for _, tmp in task.rob_task_infos.items():
        if tmp["rob_result"]:
            robbed_num = robbed_num + 1
    if robbed_num > 2:
        return {"result": False, "result_no": 190911}
    # construct battle units
    # update rob task
    task_item = game_configs.guild_task_config.get(task.task_no)
    rob_task_info = task.rob_task_infos.get(header)
    seed1, seed2 = get_seeds()
    rob_task_info["seed1"] = seed1
    rob_task_info["seed2"] = seed2
    red_groups = []
    blue_groups = []
    for player_info in task.protecters:
        red_group = cPickle.loads(player_info.get("BattleUnitGrop"))
        red_groups.append(red_group)

    for player_info in rob_task_info.get("robbers"):
        blue_group = cPickle.loads(player_info.get("BattleUnitGrop"))
        blue_groups.append(blue_group)
    logger.debug("red_groups %s" % red_groups)
    logger.debug("blue_groups %s" % blue_groups)

    # pvp battle
    rob_result = guild_pvp_start(red_groups, blue_groups, seed1, seed2)

    rob_task_info["rob_result"] = rob_result
    rob_task_info["rob_time"] = int(get_current_timestamp())
    if rob_result:
        robbers_num = len(rob_task_info.get("robbers"))
        peoplePercentage = task_item.peoplePercentage.get(robbers_num)
        robbedPercentage = task_item.robbedPercentage.get(robbed_num+1)
        mail_arg1 = calculate_reward(peoplePercentage, robbedPercentage, "SnatchReward", task_item)

        rob_task_info["rob_reward"] = mail_arg1
        for player_info in rob_task_info.get("robbers"):
            send_mail(conf_id=1002,  receive_id=player_info.get("id"), arg1=str(mail_arg1))
    task.state = -1
    task.save_data()
    res = {"result": True, "protecters": task.protecters, "rob_task_info": rob_task_info}
    logger.debug("res %s" % res)
    return res

def get_remote_gate():
    """docstring for get_remote_gate"""
    return GlobalObject().child('gate')


def send_mail(conf_id, receive_id, arg1):
        mail_data, _ = deal_mail(conf_id=conf_id, receive_id=int(receive_id), arg1=arg1)
        get_remote_gate().push_message_to_transit_remote('receive_mail_remote',
                                                   int(receive_id), mail_data)


@rootserviceHandle
def update_task_state_remote(protect_records, rob_records):
    """
    根据时间调整任务状态
    """
    records = {}
    rob_records.update(protect_records)

    for task_id, guild_id in rob_records.items():
        guild = guild_manager_obj.get_guild_obj(guild_id)
        records[task_id] = guild

    for task_id, guild in records.items():
        task = guild.get_task_by_id(task_id)
        task_item = game_configs.guild_task_config.get(task.task_no)
        if task.is_started(task_item):
            task.state = 2
            guild.escort_tasks_can_rob.append(task.task_id)
        if task.is_finished(task_item):
            task.state = -1
            protecters_num = len(task.protecters)
            peoplePercentage = task_item.peoplePercentage.get(protecters_num)
            robbedPercentage = 0
            for t in range(task.rob_success_times()):
                robbedPercentage = robbedPercentage + task_item.robbedPercentage.get(t+1)


            mail_arg1 = calculate_reward(peoplePercentage, robbedPercentage, "EscortReward", task_item)
            task.reward = mail_arg1
            for player_info in task.protecters:
                send_mail(conf_id=1001,  receive_id=player_info.get("id"),
                                      nickname=player_info.get("nickname"), arg1=str(mail_arg1))
        task.update_rob_state(task_item)
        task.save_data()


def calculate_reward(peoplePercentage, robbedPercentage, formula_name, task_item):
    """docstring for calculate_reward"""
    logger.debug("peoplePercentage robbedPercentage %s %s " % (peoplePercentage, robbedPercentage))
    escort_formula = game_configs.formula_config.get("EscortReward").get("formula")
    assert escort_formula!=None, "escort_formula can not be None!"
    percent = eval(escort_formula, {"peoplePercentage": peoplePercentage, "robbedPercentage": robbedPercentage})

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

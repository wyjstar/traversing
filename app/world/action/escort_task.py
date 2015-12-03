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
from gfirefly.server.globalobject import GlobalObject
from shared.common_logic.escort_task import calculate_reward

@rootserviceHandle
def get_guild_task_records_remote(guild_id):
    """
    获取军团押劫记录
    """
    tasks = {}
    guild = guild_manager_obj.get_guild_obj(guild_id)
    for task_id, task in guild.escort_tasks.items():
        task.update_task_state()
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
    #logger.debug("get_can_rob_tasks_remote %s" % tasks)
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
def add_player_remote(guild_id, task_id, player_info, protect_or_rob, rob_no):
    logger.debug("add_player_remote %s %s %s %s %s" % (guild_id, task_id, player_info, protect_or_rob, rob_no))
    guild = guild_manager_obj.get_guild_obj(guild_id)
    task = guild.get_task_by_id(task_id)

    for protecter in task.protecters:
        if protecter.get("id") == player_info.get("id"):
            return {'result': False, 'result_no': 190802}


    player_guild = guild_manager_obj.get_guild_obj(player_info.get("g_id"))
    task.add_player(player_info, protect_or_rob, rob_no, player_guild.guild_info())
    if len(task.protecters)==3 and protect_or_rob == 1:
        logger.debug("team up, then auto start task!")
        start_task(task, guild)

    return dict(result=True,
            task=construct_task_data(task))


@rootserviceHandle
def start_protect_task_remote(guild_id, task_id):
    """
    开始保护押运任务
    """
    guild = guild_manager_obj.get_guild_obj(guild_id)
    task = guild.get_task_by_id(task_id)
    logger.debug("task state %s" % task.state)
    start_task(task, guild)
    return dict(result=True,
            task=construct_task_data(task))

def start_task(task, guild):
    task.state = 2
    logger.debug("task state %s" % task.state)
    task.start_protect_time = int(get_current_timestamp())
    task.update_reward()
    guild.escort_tasks_can_rob.append(task.task_id)
    guild.save_data()
    task.save_data()

@rootserviceHandle
def send_escort_task_invite_remote(guild_id, task_id, player_guild_id, rob_no, protect_or_rob):
    """
    发送邀请到玩家所在公会
    """
    guild = guild_manager_obj.get_guild_obj(player_guild_id)
    if protect_or_rob == 1:
        guild.escort_tasks_invite_protect[task_id] = {"guild_id" : guild_id, "no": rob_no}
    elif protect_or_rob == 2:
        guild.escort_tasks_invite_rob[task_id] = {"guild_id" : guild_id, "no": rob_no}
    guild.save_data()

    task_guild = guild_manager_obj.get_guild_obj(guild_id)
    return construct_task_data(task_guild.get_task_by_id(task_id))

@rootserviceHandle
def cancel_rob_task_remote(guild_id, task_id, rob_no):
    """取消劫运任务"""
    guild = guild_manager_obj.get_guild_obj(guild_id)
    task = guild.get_task_by_id(task_id)
    task.cancel_rob_task(rob_no)
    task.save_data()

#@rootserviceHandle
#def push_to_guild_members(guild_id, data, members):
    #pass
    #remote_gate = GlobalObject().child('gate')
    #remote_gate.push_message_to_transit_remote('receive_mail_remote',
                                               #int(player_id), mail_data)
@rootserviceHandle
def start_rob_escort_remote(guild_id, task_id, rob_no):

    guild = guild_manager_obj.get_guild_obj(guild_id)
    task = guild.get_task_by_id(task_id)
    # get robbed success num
    robbed_num = 0
    has_rob = False
    for tmp in task.rob_task_infos:
        if tmp["rob_result"]:
            robbed_num = robbed_num + 1
        if tmp.get("rob_no") == rob_no and tmp["rob_result"]:
            has_rob = True
    if robbed_num > 2:
        return {"result": False, "result_no": 190911}
    if has_rob > 2:
        return {"result": False, "result_no": 190911}
    # construct battle units
    # update rob task
    task_item = game_configs.guild_task_config.get(task.task_no)
    rob_task_info = task.rob_task_infos[rob_no]
    seed1, seed2 = get_seeds()
    rob_task_info["seed1"] = seed1
    rob_task_info["seed2"] = seed2
    red_groups = []
    blue_groups = []
    for player_info in task.protecters:
        blue_group = cPickle.loads(player_info.get("BattleUnitGrop"))
        blue_groups.append(blue_group)

    for player_info in rob_task_info.get("robbers"):
        red_group = cPickle.loads(player_info.get("BattleUnitGrop"))
        red_groups.append(red_group)
    logger.debug("blue_groups %s" % blue_groups)
    logger.debug("red_groups %s" % red_groups)

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
    rob_task_info["rob_state"] = -1
    task.update_reward(task_item)
    task.save_data()
    res = {"result": True, "protecters": task.protecters, "rob_task_info": rob_task_info, "task": construct_task_data(task)}
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
        if not task: continue
        task.update_task_state()



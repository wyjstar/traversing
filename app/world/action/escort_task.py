#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
created by wzp.
"""
from gfirefly.server.globalobject import rootserviceHandle
from app.world.core.hjqy_boss import hjqy_manager
from app.battle.server_process import hjqy_start
import cPickle
#from shared.utils.date_util import get_current_timestamp
#from app.world.action.gateforwarding import push_all_object_message
from gfirefly.server.logobj import logger
from shared.db_opear.configs_data import game_configs
from shared.utils.mail_helper import deal_mail
from shared.utils.date_util import get_current_timestamp
from app.world.core.guild_manager import guild_manager_obj

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
def get_tasks_by_ids_remote(guild_id, task_ids):
    guild = guild_manager_obj.get_guild_obj(guild_id)
    tasks = {}
    for task_id in task_ids:
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
    task.add_player(player_info, protect_or_rob, header)
    #task.state = 1
    task.save_data()
    return construct_task_data(task)

@rootserviceHandle
def start_rob_escort_remote(guild_id, task_id, rob_task_info, header):
    """
    更新劫运信息
    """
    guild = guild_manager_obj.get_guild_obj(guild_id)
    task = guild.get_task_by_id(task_id)
    task.update_rob_task_info(rob_task_info, header)
    task.save_data()

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
def send_escort_task_invite_remote(guild_id, task_id, protect_or_rob):
    guild = guild_manager_obj.get_guild_obj(guild_id)
    if protect_or_rob == 1:
        guild.escort_tasks_invite_protect.append(task_id)
    elif protect_or_rob == 2:
        guild.escort_tasks_invite_rob.append(task_id)

    return construct_task_data(guild.get_task_by_id(task_id))

@rootserviceHandle
def cancel_rob_task_remote(guild_id, task_id, header):
    """取消劫运任务"""
    guild = guild_manager_obj.get_guild_obj(guild_id)
    task = guild.get_task_by_id(task_id)
    task.cancel_rob_task(header)
    task.save_data()


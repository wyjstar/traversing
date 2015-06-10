# -*- coding:utf-8 -*-
"""
created by server on 14-7-17上午11:07.
"""
from gfirefly.server.globalobject import remoteserviceHandle
from app.proto_file import task_pb2
from shared.db_opear.configs_data import game_configs
from gfirefly.server.logobj import logger
from app.game.core.item_group_helper import gain, get_return
from shared.utils.const import const
from app.game.core.task import task_status, get_condition_info, \
    CONDITIONId


@remoteserviceHandle('gate')
def get_task_info_1821(data, player):
    """获取任务信息"""
    args = task_pb2.TaskInfoRequest()
    args.ParseFromString(data)
    sort = args.sort
    response = task_pb2.TaskInfoResponse()

    sort_conf = game_configs.achievement_config.get('sort').get(sort)
    first_tasks = game_configs.achievement_config.get('first_task')
    for tid in sort_conf:
        if tid not in first_tasks:
            continue
        task_status(player, tid, response)

    return response.SerializeToString()


@remoteserviceHandle('gate')
def get_task_reward_1822(data, player):
    """获取任务信息"""
    args = task_pb2.TaskRewardRequest()
    args.ParseFromString(data)
    tid = args.tid
    response = task_pb2.TaskRewardResponse()
    task_conf = game_configs.achievement_config.get('tasks').get(tid)

    state = player.task.tasks.get(tid)
    if state and state == 3:
        response.res.result = False
        response.res.result_no = 800
        return response.SerializeToString()

    res = get_condition_info(player, task_conf)
    if state == 1 and not res.get('state'):
        response.res.result = False
        response.res.result_no = 800
        return response.SerializeToString()
    gain_data = gain(player, task_conf.reward, const.TASK)
    get_return(player, gain_data, response.gain)
    player.task._tasks[tid] = 3
    player.task.save_data()

    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def share_1823(data, player):
    """获取任务信息"""
    args = task_pb2.ShareRequest()
    args.ParseFromString(data)
    tid = args.tid
    response = task_pb2.ShareResponse()

    task_conf = game_configs.achievement_config.get('tasks').get(tid)
    if task_conf.sort != 4:
        response.res.result = False
        response.res.result_no = 800
        return response.SerializeToString()

    res = get_condition_info(player, task_conf)

    condition_info = res.get('condition_info')
    for x in condition_info:
        if not x[1] and task_conf.condition.get(x[0])[0] != CONDITIONId.SHARE:
            response.res.result = False
            response.res.result_no = 800
            return response.SerializeToString()

    player.task._tasks[tid] = 2
    player.task.save_data()

    response.tid = tid
    response.res.result = True
    return response.SerializeToString()

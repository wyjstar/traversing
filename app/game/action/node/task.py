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
    CONDITIONId, UPDATE_CONDITION_ADD, UPDATE_CONDITION_COVER, \
    UPDATE_CONDITION_COVER_RANK
from shared.tlog import tlog_action


@remoteserviceHandle('gate')
def get_task_info_1821(data, player):
    """获取任务信息"""
    args = task_pb2.TaskInfoRequest()
    args.ParseFromString(data)
    sort = args.sort
    response = task_pb2.TaskInfoResponse()

    player.task.update()

    sort_conf = game_configs.achievement_config.get('sort').get(sort)
    first_tasks = game_configs.achievement_config.get('first_task')
    for tid in sort_conf:
        if tid not in first_tasks:
            continue
        task_status(player, tid, response)

    return response.SerializeToString()


@remoteserviceHandle('gate')
def get_task_reward_1822(data, player):
    """获取任务奖励"""
    args = task_pb2.TaskRewardRequest()
    args.ParseFromString(data)
    tid = args.tid
    response = task_pb2.TaskRewardResponse()

    player.task.update()

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

    if player.base_info.is_firstday_from_register(const.OPEN_FEATURE_TASK) and task_conf.sort != 4:
        response.res.result = False
        logger.debug('error_no:150901')
        response.res.result_no = 150901
        return response.SerializeToString()

    gain_data = gain(player, task_conf.reward, const.TASK)
    get_return(player, gain_data, response.gain)
    player.task._tasks[tid] = 3
    player.task.save_data()

    response.tid = tid
    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def share_1823(data, player):
    """分享"""
    args = task_pb2.ShareRequest()
    args.ParseFromString(data)
    tid = args.tid
    share_type = 0
    if args.share_type:
        share_type = args.share_type
    response = task_pb2.ShareResponse()

    player.task.update()

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

    player.task.tasks[tid] = 2
    player.task.save_data()
    tlog_action.log('Share', player, tid, share_type)

    response.tid = tid
    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def get_condition_info_1825(data, player):
    """成长引导"""
    response = task_pb2.ConditionsResponse()
    cids = UPDATE_CONDITION_ADD + UPDATE_CONDITION_COVER + \
        UPDATE_CONDITION_COVER_RANK

    player.task.update()

    for cid in cids:
        num = player.task.conditions_day.get(cid)
        if not num:
            num = 0
        condition_info = response.condition_info.add()
        condition_info.cid = cid
        condition_info.num = num

    return response.SerializeToString()

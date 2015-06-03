# -*- coding:utf-8 -*-
"""
created by server on 14-7-17上午11:07.
"""
from gfirefly.server.globalobject import remoteserviceHandle
from app.proto_file import task_pb2
from shared.db_opear.configs_data import game_configs


@remoteserviceHandle('gate')
def get_task_info_1821(data, player):
    """获取任务信息"""
    args = task_pb2.TaskInfoRequest()
    args.ParseFromString(data)
    sort = args.sort
    response = TaskInfoResponse()

    sort_conf = game_configs.achievement_config.get('sort')
    first_tasks = game_configs.achievement_config.get('first_task')
    for tid in sort_conf:
        if tid not in first_tasks:
            player.tasks.task_status(tid, pesponse)

    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def get_task_reward_1822(data, player):
    """获取任务信息"""
    args = task_pb2.TaskRewardRequest()
    args.ParseFromString(data)
    sort = args.sort
    response = TaskRewardResponse()

    sort_conf = game_configs.achievement_config.get('sort')
    first_tasks = game_configs.achievement_config.get('first_task')
    for tid in sort_conf:
        if tid not in first_tasks:
            player.tasks.task_status(tid, pesponse)

    response.res.result = True
    return response.SerializeToString()

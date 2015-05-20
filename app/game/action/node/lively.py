# -*- coding:utf-8 -*-

from gfirefly.server.globalobject import remoteserviceHandle
from app.proto_file.lively_pb2 import TaskUpdate, rewardRequest, rewardResponse
from app.proto_file.common_pb2 import CommonResponse
from shared.db_opear.configs_data import game_configs
from app.game.core import item_group_helper
from shared.db_opear.configs_data import data_helper
from app.game.core.lively import task_status
from gfirefly.server.globalobject import GlobalObject
from app.game.core.item_group_helper import get_return
remote_gate = GlobalObject().remote.get('gate')
from shared.utils.const import const


@remoteserviceHandle('gate')
def query_status_1234(data, player):
    task_status = player.tasks.task_status()
    player.tasks.save_data()
    response = TaskUpdate()
    for status in task_status:
        ts = response.tasks.add()
        print 'query_status_1234', status
        ts.tid = status[0]
        ts.current = status[1]
        ts.target = status[2]
        ts.status = status[3]
    return response.SerializePartialToString()


def add_items(player, task_id, gain):
    """
    添加道具给玩家
    """
    if task_id in game_configs.achievement_config:
        task = game_configs.achievement_config[task_id]
        reward = data_helper.parse(task.reward)
        return_data = item_group_helper.gain(player, reward, const.LIVELY)
        get_return(player, return_data, gain)


@remoteserviceHandle('gate')
def draw_reward_1235(data, player):

    response = rewardResponse()

    open_stage_id = game_configs.base_config.get('activityOpenStage')
    if player.stage_component.get_stage(open_stage_id).state != 1:
        res = CommonResponse()
        response.res.result = False
        response.res.result_no = 837
        return res.SerializeToString()

    request = rewardRequest()
    request.ParseFromString(data)
    status = player.tasks.reward(request.tid)
    player.tasks.save_data()
    if status == 0:
        response.res.result = True
        response.tid = request.tid
        add_items(player, request.tid, response.gain)
        task_data = task_status(player)
        remote_gate.push_object_remote(1234, task_data, [player.dynamic_id])
        # print 'draw_reward_1235::', response
        return response.SerializePartialToString()
    else:
        response.res.result = False
        # response.res.result_no = status
        response.res.message = "未完成" if status == 1 else "已领取"
        if status == -1:
            response.res.message = "任务不存在"
        return response.SerializePartialToString()

# -*- coding:utf-8 -*-

from gfirefly.server.globalobject import remoteserviceHandle
from app.proto_file.lively_pb2 import TaskUpdate, rewardRequest, rewardResponse
from app.proto_file.common_pb2 import CommonResponse
from shared.db_opear.configs_data.game_configs import achievement_config

@remoteserviceHandle('gate')
def query_status(data, player):
    task_status = player.lively.status()
    response = TaskUpdate()
    for status in task_status:
        ts = response.tasks.add()
        ts.tid = status[0]
        ts.current = status[1]
        ts.target = status[2]
    return response.SerializePartialToString()

def add_items(task_id):
    """
    添加道具给玩家
    """
    add_items = []
    if task_id in achievement_config:
        task = achievement_config[task_id]

    return add_items

@remoteserviceHandle('gate')
def draw_reward(data, player):
    request = rewardRequest()
    request.ParseFromString(data)
    status = player.lively.reward(request.task_id)
    if status == 0:
        items = add_items(request.task_id)
        response = rewardResponse()
        for item in items:
            add_item = response.items.add()
            add_item.item_no = item.item_no
            add_item.item_num = item.item_num
        return response.SerializePartialToString()
    else:
        common = CommonResponse
        common.result = False
        common.result_no = status
        common.message = "领奖错误"
        return common.SerializePartialToString()


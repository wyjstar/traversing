# -*- coding:utf-8 -*-

from gfirefly.server.globalobject import remoteserviceHandle
from app.proto_file.lively_pb2 import TaskUpdate, rewardRequest, rewardResponse
from app.proto_file.common_pb2 import CommonResponse
from shared.db_opear.configs_data.game_configs import achievement_config
from app.game.core import item_group_helper
from shared.db_opear.configs_data import data_helper
from app.game.core.lively import task_status
from app.game import GlobalObject
remote_gate = GlobalObject().remote['gate']

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

def add_items(player, task_id):
    """
    添加道具给玩家
    """
    add_items = []
    if task_id in achievement_config:
        task = achievement_config[task_id]
        reward = data_helper.parse(task.reward)
        item_group_helper.gain(player, reward, add_items)
    return add_items

@remoteserviceHandle('gate')
def draw_reward_1235(data, player):
    request = rewardRequest()
    request.ParseFromString(data)
    status = player.tasks.reward(request.tid)
    player.tasks.save_data()
    if status == 0:
        items = add_items(player, request.tid)
        response = rewardResponse()
        response.tid = request.tid
        for item in items:
            add_item = response.items.add()
            add_item.item_no = item[2]
            add_item.item_num = item[1]
        task_data = task_status(player)
        remote_gate.push_object_remote(1234, task_data, [player.dynamic_id])
        return response.SerializePartialToString()
    else:
        common = CommonResponse
        common.result = False
        common.result_no = status
        common.message = "未完成" if status == 1  else "已领取"
        if status == -1:
            common.message = "任务不存在"
        return common.SerializePartialToString()

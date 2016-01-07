# -*- coding:utf-8 -*-
"""
created by server on 14-8-12下午2:17.
"""
from gfirefly.server.globalobject import remoteserviceHandle
from gfirefly.server.globalobject import GlobalObject
from app.proto_file import activity_pb2
from gfirefly.server.logobj import logger

remote_gate = GlobalObject().remote.get('gate')


@remoteserviceHandle('gate')
def init_2501(pro_data, player):
    """获取guild_activity初始化信息
    """
    response = activity_pb2.GuildActivityInitResponse()
    remote_gate["world"].get_tasks_by_ids_remote(player.escort_component.protect_records)
    player.guild_activity.check_time()
    player.guild_activity.update_pb(response)
    logger.debug("response %s" % response)
    return response.SerializeToString()

@remoteserviceHandle('gate')
def get_reward_2502(pro_data, player):
    """获取get_reward初始化信息
    """
    request = activity_pb2.GuildActivityGetRewardRequest()
    request.ParseFromString(pro_data)
    act_id = request.act_id
    logger.debug("request %s" % request)
    response = activity_pb2.GuildActivityGetRewardResponse()
    res = player.guild_activity.get_reward(act_id, response)

    response.res.result = res.get("result")
    if not res.get("result"):
        response.res.result_no = res.get("result_no")
        return response.SerializeToString()
    logger.debug("response %s" % response)
    return response.SerializeToString()

@remoteserviceHandle('gate')
def test_add_times_2503(pro_data, player):
    """获取get_reward初始化信息
    """
    act_infos = player.guild_activity.act_info
    for act_info in act_infos.values():
        act_info["act_times"] = 10

    logger.debug("response %s" % act_infos)
    return ""



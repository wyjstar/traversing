# -*- coding:utf-8 -*-
"""
created by server on 15-7-22
"""
from gfirefly.server.globalobject import remoteserviceHandle
# from shared.db_opear.configs_data import game_configs
from gfirefly.server.logobj import logger
from app.proto_file import kuaiyong


@remoteserviceHandle('gate')
def kuaiyong_flowid_12000(data, player):
    response = kuaiyong.KuaiyongFlowIdResponse()
    response.flow_id = str(player.character_id)
    return response.SerializeToString()


@remoteserviceHandle('gate')
def kuaiyong_recharge_remote(subject, is_online, player):
    logger.debug('kuaiyong_recharge_remote:%s', subject)
    return True

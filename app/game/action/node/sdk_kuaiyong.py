# -*- coding:utf-8 -*-
"""
created by server on 15-7-22
"""
from gfirefly.server.globalobject import remoteserviceHandle
from shared.db_opear.configs_data import game_configs
from gfirefly.server.globalobject import GlobalObject
from gfirefly.server.logobj import logger
from app.proto_file import kuaiyong_pb2
from app.proto_file import apple_pb2
import time


remote_gate = GlobalObject().remote.get('gate')


@remoteserviceHandle('gate')
def kuaiyong_flowid_12000(data, player):
    response = kuaiyong_pb2.KuaiyongFlowIdResponse()
    response.flow_id = str(player.character_id) + '_%s' % time.time()
    return response.SerializeToString()


@remoteserviceHandle('gate')
def kuaiyong_recharge_remote(subject, fee, is_online, player):
    logger.debug('kuaiyong_recharge_remote:%s', subject)

    recharge_item = game_configs.recharge_config.get('ios').get(subject)
    if recharge_item is None:
        logger.error('not in rechargeconfig:%s', subject)
        return False
    if fee != recharge_item.get('currence'):
        logger.error('recharge fee is wrong:%s-%s',
                     fee, recharge_item.get('currence'))
        return False

    response = apple_pb2.AppleConsumeVerifyResponse()
    response.res.result = True
    player.recharge.recharge_gain(recharge_item, response)  # 发送奖励邮件

    remote_gate.push_object_remote(12001,
                                   response.SerializeToString(),
                                   [player.dynamic_id])
    logger.debug('kuaiyong response:%s', response)
    return True

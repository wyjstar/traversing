# -*- coding:utf-8 -*-
"""
created by server on 15-7-22
"""
from gfirefly.server.globalobject import remoteserviceHandle
from shared.db_opear.configs_data import game_configs
from gfirefly.server.globalobject import GlobalObject
from gfirefly.server.logobj import logger
from app.proto_file import sdk_pb2
import time

@remoteserviceHandle('gate')
def xiaomi_flowid_13000(data, player):
    response = sdk_pb2.KuaiyongFlowIdResponse()
    response.flow_id = str(player.character_id) + '_%s' % time.time()
    player.base_info.flowid = response.flow_id
    logger.debug("flow_id %s" % player.base_info.flowid)
    player.base_info.save_data()
    return response.SerializeToString()

remote_gate = GlobalObject().remote.get('gate')


@remoteserviceHandle('gate')
def xiaomi_recharge_remote(subject, fee, cpOrderId, is_online, player):
    logger.debug('xiaomi_recharge_remote:%s', subject)

    if cpOrderId != player.pay.flowid:
        logger.debug("cpOrderId %s %s" % (cpOrderId, player.recharge.flowid))
        return 1506

    recharge_item = game_configs.recharge_config.get('ios').get(subject)
    if recharge_item is None:
        logger.error('not in rechargeconfig:%s', subject)
        return 1525
    if float(fee) != recharge_item.get('currence'):
        logger.error('recharge fee is wrong:%s-%s',
                     fee, recharge_item.get('currence'))
        #return 1525
    response = sdk_pb2.XiaomiRechargeResponse()
    response.res.result = True
    player.recharge.recharge_gain(recharge_item, response)  # 发送奖励邮件

    remote_gate.push_object_remote(13001,
                                   response.SerializeToString(),
                                   [player.dynamic_id])
    logger.debug('xiaomi response:%s', response)
    return 200

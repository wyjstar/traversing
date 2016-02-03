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
    flow_id = str(player.character_id) + '_%s' % int(time.time())
    player.base_info.flow_orders.append(flow_id)
    player.base_info.save_data()
    response.flow_id = flow_id
    return response.SerializeToString()


@remoteserviceHandle('gate')
def kuaiyong_flowid_12100(data, player):
    response = kuaiyong_pb2.KuaiyongFlowIdResponse()
    if player.base_info.one_dollar_flowid == 'done':
        response.flow_id = 'done'
    else:
        flowid = str(player.character_id) + '_%s' % int(time.time())
        player.base_info.one_dollar_flowid = flowid
        player.base_info.save_data()
        response.flow_id = flowid
    logger.debug('one flowid:%s', response.flow_id)
    return response.SerializeToString()


@remoteserviceHandle('gate')
def kuaiyong_recharge_remote(product_id, fee, is_online, player):
    logger.debug('kuaiyong_recharge_remote:%s', product_id)

    recharge_item = game_configs.recharge_config.get('ios').get(product_id)
    if recharge_item is None:
        logger.error('not in rechargeconfig:%s', product_id)
        return False
    if float(fee) != recharge_item.get('currence'):
        logger.error('recharge fee is wrong:%s-%s', fee,
                     recharge_item.get('currence'))
        return False

    response = apple_pb2.AppleConsumeVerifyResponse()
    response.res.result = True
    player.recharge.recharge_gain(recharge_item, response, 4)  # 发送奖励邮件

    remote_gate.push_object_remote(12001, response.SerializeToString(),
                                   [player.dynamic_id])
    logger.debug('kuaiyong response:%s', response)
    return True


@remoteserviceHandle('gate')
def q360_recharge_remote(product_id, order_id, is_online, player):
    logger.debug('q360_recharge_remote:%s-%s', product_id, order_id)
    if player.base_info.one_dollar_flowid == order_id:
        player.base_info.one_dollar_flowid = 'done'
        logger.debug('one dollar is ok! %s', product_id)

    if order_id not in player.base_info.flow_orders:
        logger.error('error flow id:%s-%s', order_id,
                     player.base_info.flow_orders)
        return False
    player.base_info.flow_orders.remove(order_id)
    player.base_info.save_data()

    recharge_item = game_configs.recharge_config.get('android').get(product_id)
    if recharge_item is None:
        logger.error('not in rechargeconfig:%s', product_id)
        return False
    # if float(fee) != recharge_item.get('currence'):
    #     logger.error('recharge fee is wrong:%s-%s', fee,
    #                  recharge_item.get('currence'))
    #     return False

    response = apple_pb2.AppleConsumeVerifyResponse()
    response.res.result = True
    player.recharge.recharge_gain(recharge_item, response, 1)  # 发送奖励邮件

    remote_gate.push_object_remote(12002, response.SerializeToString(),
                                   [player.dynamic_id])
    logger.debug('360 response:%s', response)
    return True


@remoteserviceHandle('gate')
def baidu_recharge_remote(product_id, fee, order_id, is_online, player):
    logger.debug('baidu_recharge_remote:%s-fee:%s-order:%s', product_id, fee,
                 order_id)
    if player.base_info.one_dollar_flowid == order_id:
        player.base_info.one_dollar_flowid = 'done'
        logger.debug('one dollar is ok! %s', product_id)

    recharge_item = game_configs.recharge_config.get('android').get(product_id)
    if recharge_item is None:
        logger.error('not in rechargeconfig:%s', product_id)
        return False

    if float(fee) != recharge_item.get('currence'):
        logger.error('recharge fee is wrong:%s-%s', fee,
                     recharge_item.get('currence'))
        return False

    response = apple_pb2.AppleConsumeVerifyResponse()
    response.res.result = True
    player.recharge.recharge_gain(recharge_item, response, 7)  # 发送奖励邮件

    remote_gate.push_object_remote(12003, response.SerializeToString(),
                                   [player.dynamic_id])
    logger.debug('baidu response:%s', response)
    return True


@remoteserviceHandle('gate')
def huawei_recharge_remote(product_id, fee, order_id, is_online, player):
    logger.debug('huawei_recharge_remote:%s-fee:%s-order:%s', product_id, fee,
                 order_id)
    if player.base_info.one_dollar_flowid == order_id:
        player.base_info.one_dollar_flowid = 'done'
        logger.debug('one dollar is ok! %s', product_id)

    if order_id not in player.base_info.flow_orders:
        logger.error('error flow id:%s-%s', order_id,
                     player.base_info.flow_orders)
        return False
    player.base_info.flow_orders.remove(order_id)
    player.base_info.save_data()

    recharge_item = game_configs.recharge_config.get('android').get(product_id)
    if recharge_item is None:
        logger.error('not in rechargeconfig:%s', product_id)
        return False

    if float(fee) != recharge_item.get('currence'):
        logger.error('recharge fee is wrong:%s-%s', fee,
                     recharge_item.get('currence'))
        return False

    response = apple_pb2.AppleConsumeVerifyResponse()
    response.res.result = True
    player.recharge.recharge_gain(recharge_item, response, 8)  # 发送奖励邮件

    remote_gate.push_object_remote(12004, response.SerializeToString(),
                                   [player.dynamic_id])
    logger.debug('hauwei response:%s', response)
    return True


@remoteserviceHandle('gate')
def meizu_recharge_remote(product_id, fee, order_id, is_online, player):
    logger.debug('meizu_recharge_remote:%s-fee:%s-order:%s', product_id, fee,
                 order_id)
    if player.base_info.one_dollar_flowid == order_id:
        player.base_info.one_dollar_flowid = 'done'
        logger.debug('one dollar is ok! %s', product_id)

    recharge_item = game_configs.recharge_config.get('android').get(product_id)
    if recharge_item is None:
        logger.error('not in rechargeconfig:%s', product_id)
        return False

    if float(fee) != recharge_item.get('currence'):
        logger.error('recharge fee is wrong:%s-%s', fee,
                     recharge_item.get('currence'))
        return False

    response = apple_pb2.AppleConsumeVerifyResponse()
    response.res.result = True
    player.recharge.recharge_gain(recharge_item, response, 9)  # 发送奖励邮件

    remote_gate.push_object_remote(12004, response.SerializeToString(),
                                   [player.dynamic_id])
    logger.debug('hauwei response:%s', response)
    return True

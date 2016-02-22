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
from sdk.api import meizu
from sdk.api.vivo import generat_orderid
import time

remote_gate = GlobalObject().remote.get('gate')
SERVER_NO = GlobalObject().allconfig.get('server_no')

VIVO_RECHARGE_URL = GlobalObject().allconfig["vivosdk"]["recharge_url"]


@remoteserviceHandle('gate')
def recharge_flowid_12000(data, player):
    response = kuaiyong_pb2.KuaiyongFlowIdResponse()
    response.flow_id = str(player.character_id) + '_%s_%s' % (SERVER_NO,
                                                              int(time.time()))
    return response.SerializeToString()


@remoteserviceHandle('gate')
def recharge_flowid_12100(data, player):
    response = kuaiyong_pb2.KuaiyongFlowIdResponse()
    if player.base_info.one_dollar_flowid == 'done':
        response.flow_id = 'done'
    else:
        flowid = str(player.character_id) + '_%s_%s' % (SERVER_NO,
                                                        int(time.time()))
        player.base_info.one_dollar_flowid = flowid
        player.base_info.save_data()
        response.flow_id = flowid
    logger.debug('one flowid:%s', response.flow_id)
    return response.SerializeToString()


@remoteserviceHandle('gate')
def meizu_flowid_12200(data, player):
    request = kuaiyong_pb2.MeizuFlowIdRequest()
    request.ParseFromString(data)

    response = kuaiyong_pb2.MeizuFlowIdResponse()
    response.flow_id = str(player.character_id) + '_%s_%s' % (SERVER_NO,
                                                              int(time.time()))
    recharge_info = request.recharge_info.replace(
        'cp_order_id=', 'cp_order_id=' + str(response.flow_id))
    response.sign = meizu.generate_sign(recharge_info)
    logger.debug('meizu flowid:%s', response)
    return response.SerializeToString()


@remoteserviceHandle('gate')
def meizu_flowid_12201(data, player):
    request = kuaiyong_pb2.MeizuFlowIdRequest()
    request.ParseFromString(data)

    response = kuaiyong_pb2.MeizuFlowIdResponse()
    if player.base_info.one_dollar_flowid == 'done':
        response.flow_id = 'done'
    else:
        flowid = str(player.character_id) + '_%s_%s' % (SERVER_NO,
                                                        int(time.time()))
        player.base_info.one_dollar_flowid = flowid
        player.base_info.save_data()
        response.flow_id = flowid
        recharge_info = request.recharge_info.replace(
            'cp_order_id=', 'cp_order_id=' + str(flowid))
        response.sign = meizu.generate_sign(recharge_info)
    logger.debug('one flowid:%s', response.flow_id)
    return response.SerializeToString()


@remoteserviceHandle('gate')
def vivo_flowid_12300(data, player):
    request = kuaiyong_pb2.VivoFlowIdRequest()
    request.ParseFromString(data)

    response = kuaiyong_pb2.VivoFlowIdResponse()
    flow_id = str(player.character_id) + '_%s_%s' % (SERVER_NO,
                                                     int(time.time()))
    rechargeid = request.rechargeid
    recharge_item = game_configs.recharge_config.get('android').get(rechargeid)
    if recharge_item is None:
        logger.error('not in rechargeconfig:%s', rechargeid)
        return response.SerializeToString()
    title = request.title
    desc = request.desc
    amount = int(recharge_item.get('currence') * 100)
    orderid, accesskey = generat_orderid(flow_id, VIVO_RECHARGE_URL, amount,
                                         title, desc, rechargeid)
    response.transNo = orderid
    response.accessKey = accesskey

    logger.debug('vivo flowid:%s', response)
    return response.SerializeToString()


@remoteserviceHandle('gate')
def vivo_flowid_12301(data, player):
    request = kuaiyong_pb2.VivoFlowIdRequest()
    request.ParseFromString(data)

    response = kuaiyong_pb2.VivoFlowIdResponse()
    if player.base_info.one_dollar_flowid == 'done':
        response.flow_id = 'done'
    else:
        flow_id = str(player.character_id) + '_%s_%s' % (SERVER_NO,
                                                         int(time.time()))
        rechargeid = request.rechargeid
        recharge_item = game_configs.recharge_config.get('android').get(
            rechargeid)
        if recharge_item is None:
            logger.error('not in rechargeconfig:%s', rechargeid)
            return response.SerializeToString()
        title = request.title
        desc = request.desc
        amount = int(recharge_item.get('currence') * 100)
        orderid, accesskey = generat_orderid(flow_id, VIVO_RECHARGE_URL,
                                             amount, title, desc, rechargeid)
        response.transNo = orderid
        response.accessKey = accesskey

        player.base_info.save_data()
    logger.debug('vivo one flowid:%s', response)
    return response.SerializeToString()


@remoteserviceHandle('gate')
def xiaomi_recharge_remote(subject, fee, cpOrderId, is_online, player):
    logger.debug('xiaomi_recharge_remote:%s', subject)

    # if str(cpOrderId) != str(player.base_info.flowid):
    # logger.error("cpOrderId %s %s" % (cpOrderId, player.base_info.flowid))
    # return 1506
    # else:
    player.base_info.flowid = 0
    player.base_info.save_data()

    recharge_item = game_configs.recharge_config.get('android').get(subject)
    if recharge_item is None:
        logger.error('not in rechargeconfig:%s', subject)
        return 1525
    if float(fee) != recharge_item.get('currence'):
        logger.error('recharge fee is wrong:%s-%s', fee,
                     recharge_item.get('currence'))
        # return 1525
    response = apple_pb2.AppleConsumeVerifyResponse()
    response.res.result = True
    player.recharge.recharge_gain(recharge_item, response, 6)  # 发送奖励邮件

    remote_gate.push_object_remote(13001, response.SerializeToString(),
                                   [player.dynamic_id])
    logger.debug('xiaomi response:%s', response)
    return 200


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


@remoteserviceHandle('gate')
def lenovo_recharge_remote(product_id, fee, order_id, is_online, player):
    logger.debug('lenovo_recharge_remote:%s-fee:%s-order:%s', product_id, fee,
                 order_id)
    if player.base_info.one_dollar_flowid == order_id:
        player.base_info.one_dollar_flowid = 'done'
        logger.debug('one dollar is ok! %s', product_id)

    recharge_item = game_configs.recharge_config.get('android').get(product_id)
    if recharge_item is None:
        logger.error('not in rechargeconfig:%s', product_id)
        return False

    if float(fee) / 100 != recharge_item.get('currence'):
        logger.error('recharge fee is wrong:%s-%s', fee,
                     recharge_item.get('currence'))
        return False

    response = apple_pb2.AppleConsumeVerifyResponse()
    response.res.result = True
    player.recharge.recharge_gain(recharge_item, response, 11)  # 发送奖励邮件

    remote_gate.push_object_remote(12006, response.SerializeToString(),
                                   [player.dynamic_id])
    logger.debug('hauwei response:%s', response)
    return True


@remoteserviceHandle('gate')
def vivo_recharge_remote(product_id, fee, order_id, is_online, player):
    logger.debug('vivo_recharge_remote:%s-fee:%s-order:%s', product_id, fee,
                 order_id)
    if player.base_info.one_dollar_flowid == order_id:
        player.base_info.one_dollar_flowid = 'done'
        logger.debug('one dollar is ok! %s', product_id)

    recharge_item = game_configs.recharge_config.get('android').get(product_id)
    if recharge_item is None:
        logger.error('not in rechargeconfig:%s', product_id)
        return False

    if float(fee) / 100 != recharge_item.get('currence'):
        logger.error('recharge fee is wrong:%s-%s', fee,
                     recharge_item.get('currence'))
        return False

    response = apple_pb2.AppleConsumeVerifyResponse()
    response.res.result = True
    player.recharge.recharge_gain(recharge_item, response, 10)  # 发送奖励邮件

    remote_gate.push_object_remote(12005, response.SerializeToString(),
                                   [player.dynamic_id])
    logger.debug('hauwei response:%s', response)
    return True


@remoteserviceHandle('gate')
def oppo_recharge_remote(product_id, order_id, is_online, player):
    logger.debug('oppo_recharge_remote:%s-%s', product_id, order_id)
    if player.base_info.one_dollar_flowid == order_id:
        player.base_info.one_dollar_flowid = 'done'
        logger.debug('one dollar is ok! %s', product_id)

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
    player.recharge.recharge_gain(recharge_item, response, 11)  # 发送奖励邮件

    remote_gate.push_object_remote(12006, response.SerializeToString(),
                                   [player.dynamic_id])
    logger.debug('oppo response:%s', response)
    return True


@remoteserviceHandle('gate')
def uc_recharge_remote(product_id, order_id, is_online, player):
    logger.debug('uc_recharge_remote:%s-%s', product_id, order_id)
    if player.base_info.one_dollar_flowid == order_id:
        player.base_info.one_dollar_flowid = 'done'
        logger.debug('one dollar is ok! %s', product_id)

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
    player.recharge.recharge_gain(recharge_item, response, 12)  # 发送奖励邮件

    remote_gate.push_object_remote(12007, response.SerializeToString(),
                                   [player.dynamic_id])
    logger.debug('uc response:%s', response)
    return True

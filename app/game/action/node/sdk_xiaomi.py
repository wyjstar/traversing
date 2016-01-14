# -*- coding:utf-8 -*-
"""
created by server on 15-7-22
"""
from gfirefly.server.globalobject import remoteserviceHandle
from shared.db_opear.configs_data import game_configs
from gfirefly.server.globalobject import GlobalObject
from gfirefly.server.logobj import logger
from app.proto_file import sdk_pb2
from flask import request
from gfirefly.server.globalobject import webserviceHandle
from app.gate.core.virtual_character_manager import VCharacterManager
import time

@remoteserviceHandle('gate')
def xiaomi_flowid_13000(data, player):
    response = sdk_pb2.KuaiyongFlowIdResponse()
    response.flow_id = str(player.character_id) + '_%s' % time.time()
    player.recharge.flowid = response.flow_id
    return response.SerializeToString()

remote_gate = GlobalObject().remote.get('gate')

AppId = GlobalObject().allconfig["xmsdk"]["AppId"]
AppKey = GlobalObject().allconfig["xmsdk"]["AppKey"]
AppSecret = GlobalObject().allconfig["xmsdk"]["AppSecret"]
VerifySession_URL = GlobalObject().allconfig["xmsdk"]["VerifySession_URL"]

@webserviceHandle('/xmpay', methods=['post', 'get'])
def recharge_response():
    logger.debug('xiaomi recharge:%s', request.args)
    appId = request.args.get('appId')
    cpOrderId = request.args.get('cpOrderId')
    cpUserInfo = request.args.get('cpUserInfo')
    uid = request.args.get('uid')
    orderId = request.args.get('orderId')
    orderStatus = request.args.get('orderStatus')
    payFee = request.args.get('payFee')
    productCode = request.args.get('productCode')
    productName = request.args.get('productName')
    productCount = request.args.get('productCount')
    payTime = request.args.get('payTime')
    orderConsumeType = request.args.get('orderConsumeType')
    signature = request.args.get('signature')


    if int(appId) != int(AppId):
        return {'errcode': 1515}
    if int(uid) != int(uid):
        return {'errcode': 1516}

    if orderStatus == "TRADE_SUCCESS":
        player_id = int(cpOrderId.split('_')[0])

        oldvcharacter = VCharacterManager().get_by_id(player_id)
        if not oldvcharacter:
            logger.error('fail get player node:%s', player_id)
            return 'failed'
        child_node = GlobalObject().child(oldvcharacter.node)
        result = child_node.xiaomi_recharge_remote(oldvcharacter.dynamic_id,
                                                     productCode, payFee, cpOrderId,
                                                     True)
        return result

    return {'errcode': 1525}

@remoteserviceHandle('gate')
def xiaomi_recharge_remote(subject, fee, cpOrderId, is_online, player):
    logger.debug('xiaomi_recharge_remote:%s', subject)

    if cpOrderId != player.pay.flowid:
        return {'errcode': 1506}

    recharge_item = game_configs.recharge_config.get('ios').get(subject)
    if recharge_item is None:
        logger.error('not in rechargeconfig:%s', subject)
        return False
    if float(fee) != recharge_item.get('currence'):
        logger.error('recharge fee is wrong:%s-%s',
                     fee, recharge_item.get('currence'))
        return False

    response = sdk_pb2.XiaomiRechargeResponse()
    response.res.result = True
    player.recharge.recharge_gain(recharge_item, response)  # 发送奖励邮件

    remote_gate.push_object_remote(13001,
                                   response.SerializeToString(),
                                   [player.dynamic_id])
    logger.debug('xiaomi response:%s', response)
    return {'errcode': 200}

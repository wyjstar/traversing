# -*- coding:utf-8 -*-
"""
created by server on 15-2-11下午3:49.
"""
from gfirefly.server.globalobject import remoteserviceHandle
from shared.db_opear.configs_data import game_configs
from gfirefly.server.logobj import logger
from sdk.api.google.google_check import verify_signature
from app.proto_file import google_pb2


@remoteserviceHandle('gate')
def test_1000000(data, player):
    request = google_pb2.RechargeTest()
    request.ParseFromString(data)
    response = google_pb2.GoogleConsumeVerifyResponse()
    player.recharge.charge(request.recharge_num)
    player.recharge.save_data()
    return ''


@remoteserviceHandle('gate')
def google_generate_id_10000(data, player):
    request = google_pb2.GoogleGenerateIDRequest()
    request.ParseFromString(data)

    response = google_pb2.GoogleGenerateIDResponse()
    response.uid = player.base_info.generate_google_id(request.channel)
    logger.debug(response)
    return response.SerializeToString()


@remoteserviceHandle('gate')
def google_consume_10001(data, player):
    request = google_pb2.GoogleConsumeRequest()
    request.ParseFromString(data)
    logger.debug(request)

    player.base_info.set_google_consume_data(request.data)

    response = google_pb2.GoogleConsumeResponse()
    response.res.result = True

    data = eval(request.data)
    recharge_item = game_configs.recharge_config.get('android').get(data.get('productId'))
    if recharge_item is None:
        response.res.result = False
        logger.debug('google product id is not in rechargeconfig:%s',
                     data.get('productId'))

    logger.debug(response)
    return response.SerializeToString()


@remoteserviceHandle('gate')
def google_consume_verify_10002(data, player):
    request = google_pb2.GoogleConsumeVerifyRequest()
    request.ParseFromString(data)
    logger.debug(request)

    response = google_pb2.GoogleConsumeVerifyResponse()
    response.res.result = False
    result = verify_signature(request.signature, request.data)
    logger.debug('verify_signature:%s', result)

    data = eval(request.data)
    recharge_item = game_configs.recharge_config.get('android').get(data.get('productId'))

    if result:
        if recharge_item is None:
            logger.debug('google consume goodid not in rechargeconfig:%s',
                         data.get('productId'))
        else:
            player.recharge.recharge_gain(recharge_item, response, 3) #发送奖励邮件
            response.res.result = True

    logger.debug(response)
    return response.SerializeToString()

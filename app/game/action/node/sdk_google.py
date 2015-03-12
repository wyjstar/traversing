# -*- coding:utf-8 -*-
"""
created by server on 15-2-11下午3:49.
"""
from gfirefly.server.globalobject import remoteserviceHandle
from sdk.api.google.google_check import verify_signature
from shared.db_opear.configs_data import game_configs
from app.game.core.item_group_helper import get_return
from app.game.core.item_group_helper import gain
from gfirefly.server.logobj import logger
from app.proto_file import google_pb2
from shared.utils.const import const


@remoteserviceHandle('gate')
def test_1000000(data, player):
    request = google_pb2.RechargeTest()
    request.ParseFromString(data)
    player.recharge.charge(request.recharge_num)
    return ''


@remoteserviceHandle('gate')
def google_generate_id_10000(data, player):
    request = google_pb2.GoogleGenerateIDRequest()
    request.ParseFromString(data)

    response = google_pb2.GoogleGenerateIDResponse()
    response.uid = player.base_info.generate_google_id(request.channel)
    print response, ' GoogleGenerateIDRequest'
    return response.SerializeToString()


@remoteserviceHandle('gate')
def google_consume_10001(data, player):
    request = google_pb2.GoogleConsumeRequest()
    request.ParseFromString(data)
    print request, ' GoogleConsumeRequest'

    player.base_info.set_google_consume_data(request.data)

    response = google_pb2.GoogleConsumeResponse()
    response.res.result = True

    data = eval(request.data)
    recharge_item = game_configs.recharge_config.get(data.get('productId'))
    if recharge_item is None:
        response.res.result = False
        logger.debug('google product id is not in rechargeconfig:%s',
                     data.get('productId'))

    return response.SerializeToString()


@remoteserviceHandle('gate')
def google_consume_verify_10002(data, player):
    request = google_pb2.GoogleConsumeVerifyRequest()
    request.ParseFromString(data)
    print request, ' GoogleConsumeVerifyRequest'

    response = google_pb2.GoogleConsumeVerifyResponse()
    response.res.result = True
    result = verify_signature('', request.data)
    print result

    data = eval(request.data)
    recharge_item = game_configs.recharge_config.get(data.get('productId'))

    if result:
        if recharge_item is None:
            response.res.result = False
            logger.debug('google consume goodid not in rechargeconfig:%s',
                         data.get('productId'))
        else:
            return_data = gain(player, recharge_item.get('setting'),
                               const.RECHARGE)  # 获取
            get_return(player, return_data, response.gain)

    return response.SerializeToString()

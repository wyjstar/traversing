# -*- coding:utf-8 -*-
"""
created by server on 15-2-11下午3:49.
"""
from gfirefly.server.globalobject import remoteserviceHandle
from shared.db_opear.configs_data import game_configs
from gfirefly.server.logobj import logger
from sdk.api.apple.iapsdk import IAPSDK
from app.proto_file import apple_pb2

RECHARGE_FAIL_CODE = '3300010002'  # 支付失败
RECHARGE_SUCCESS_CODE = '3300010003'  # 充值成功
RECHARGE_REPEATED = '3300010004'  # 您已购买成功，不可重复


@remoteserviceHandle('gate')
def apple_consume_verify_11002(data, player):
    request = apple_pb2.AppleConsumeVerifyRequest()
    request.ParseFromString(data)
    logger.debug(request)

    response = apple_pb2.AppleConsumeVerifyResponse()
    response.res.message = RECHARGE_FAIL_CODE
    response.transaction_id = request.transaction_id
    response.res.result = False

    if player.base_info.apple_transaction_id == request.transaction_id:
        logger.debug("recharge repeated!")
        logger.error('transaction id is not same:%s--%s',
                     request.transaction_id,
                     player.base_info.apple_transaction_id)
        response.res.message = RECHARGE_REPEATED
        return response.SerializeToString()

    player.base_info.apple_transaction_id = request.transaction_id

    result = IAPSDK().verify(request.purchase_info, request.transaction_id)
    logger.debug(result)

    recharge_item = game_configs.recharge_config.get('ios').get(result.get('goodscode'))

    if result:
        if recharge_item is None:
            logger.debug('apple consume goodid not in rechargeconfig:%s',
                         result.get('goodscode'))
        else:
            player.recharge.recharge_gain(recharge_item, response, 2) #发送奖励邮件
            response.res.message = RECHARGE_SUCCESS_CODE
            response.res.result = True

    logger.debug(response)
    return response.SerializeToString()

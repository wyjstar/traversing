# -*- coding:utf-8 -*-
"""
created by server on 15-2-11下午3:49.
"""
from gfirefly.server.globalobject import remoteserviceHandle
from app.game.core.item_group_helper import get_return
from shared.db_opear.configs_data import game_configs
from app.game.core.item_group_helper import gain
from gfirefly.server.logobj import logger
from sdk.api.apple.iapsdk import IAPSDK
from app.proto_file import apple_pb2
from shared.utils.const import const

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
        response.res.message = RECHARGE_REPEATED
        return response.SerializeToString()

    player.base_info.apple_transaction_id = request.transaction_id

    result = IAPSDK().verify(request.purchase_info, request.transaction_id)
    logger.debug(result)

    recharge_item = game_configs.recharge_config.get(result.get('goodscode'))

    if result:
        if recharge_item is None:
            logger.debug('apple consume goodid not in rechargeconfig:%s',
                         result.get('goodscode'))
        else:
            return_data = gain(player, recharge_item.get('setting'),
                               const.RECHARGE)  # 获取
            get_return(player, return_data, response.gain)

            if player.base_info.is_first_recharge:
                logger.info('apple first recharge :%s:%s',
                            player.character_id,
                            recharge_item.get('fristGift'))
                player.base_info.first_recharge(recharge_item, response)

            response.res.message = RECHARGE_SUCCESS_CODE
            response.res.result = True

    logger.debug(response)
    return response.SerializeToString()

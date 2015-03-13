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


@remoteserviceHandle('gate')
def apple_consume_verify_11002(data, player):
    request = apple_pb2.AppleConsumeVerifyRequest()
    request.ParseFromString(data)
    logger.debug(request)

    response = apple_pb2.AppleConsumeVerifyResponse()
    response.res.result = False
    result = IAPSDK().verify(request.purchase_info,
                             request.transaction_id)
    print '==='*14, result

    recharge_item = game_configs.recharge_config.get(result.get('goodscode'))

    if result:
        if recharge_item is None:
            logger.debug('apple consume goodid not in rechargeconfig:%s',
                         result.get('goodscode'))
        else:
            return_data = gain(player, recharge_item.get('setting'),
                               const.RECHARGE)  # 获取
            get_return(player, return_data, response.gain)
            response.res.result = True
    response.res.result = True
    logger.debug(response)
    return response.SerializeToString()

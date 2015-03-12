# -*- coding:utf-8 -*-
"""
created by server on 15-2-11下午3:49.
"""
from gfirefly.server.globalobject import remoteserviceHandle
from app.game.core.item_group_helper import get_return
from app.game.core.item_group_helper import gain
from sdk.api.apple.iapsdk import IAPSDK
from app.proto_file import apple_pb2
from shared.utils.const import const


@remoteserviceHandle('gate')
def apple_consume_verify_11002(data, player):
    request = apple_pb2.AppleConsumeVerifyRequest()
    request.ParseFromString(data)
    print request, ' GoogleConsumeVerifyRequest'

    response = apple_pb2.AppleConsumeVerifyResponse()
    result = IAPSDK().verify(request.purchase_info,
                             request.transaction_id)

    # if result:
    #     if recharge_item is None:
    #         response.res.result = False
    #         logger.debug('apple consume goodid not in rechargeconfig:%s',
    #                      data.get('productId'))
    #     else:
    #         return_data = gain(player, recharge_item.get('setting'),
    #                            const.RECHARGE)  # 获取
    #         get_return(player, return_data, response.gain)
    response.res.result = result
    return response.SerializeToString()

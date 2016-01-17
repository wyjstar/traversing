# -*- coding:utf-8 -*-
"""
created by server on 15-2-11下午3:49.
"""
from gfirefly.server.globalobject import remoteserviceHandle
from gfirefly.server.logobj import logger
from app.proto_file.common_pb2 import GetGoldResponse
from app.proto_file.game_pb2 import GameLoginRequest
from shared.db_opear.configs_data import game_configs


@remoteserviceHandle('gate')
def get_gold_2001(data, player):
    """客户端充值完成后，获取充值币信息"""
    request = GameLoginRequest()
    request.ParseFromString(data)
    pay_arg = dict(openkey=request.open_key,
                   pay_token=request.pay_token,
                   pf=request.pf,
                   pfkey=request.pfkey)
    response = GetGoldResponse()
    player.pay.refresh_pay_arg(pay_arg)  # 设置支付参数

    logger.debug("recharge_id %s" % request.recharge_id)
    # add 月卡
    recharge_item = game_configs.recharge_config.get(request.recharge_id)
    if recharge_item is None:
        logger.debug('not in rechargeconfig:%s', data.get('productId'))
    else:
        player.recharge.recharge_gain(recharge_item, response, 5,
                                      True)  # 发送奖励邮件
        response.res.result = True

    player.pay.recharge()
    response.res.result = True
    player.recharge.get_recharge_response(response)
    logger.debug("get_gold_2001============%s" % response)
    return response.SerializeToString()

# -*- coding:utf-8 -*-
"""
created by server on 15-2-11下午3:49.
"""
from gfirefly.server.globalobject import remoteserviceHandle
from gfirefly.server.logobj import logger
from app.proto_file.tencent_pb2 import GetGoldReponse

@remoteserviceHandle('gate')
def get_gold_2001(data, player):
    """客户端充值完成后，获取充值币信息"""
    player.pay.get_balance()
    response = GetGoldReponse()
    response.gold = player.finance.gold
    response.vip_level = player.base_info.vip_level
    logger.debug("get_gold_2001====== %s" % response.gold)
    return response.SerializeToString()

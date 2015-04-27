#coding: utf-8
'''
Created on 2015-4-27

@author: hack
'''
from gfirefly.server.globalobject import remoteserviceHandle
from app.game.core.rebate_fun import rebate_info
from app.proto_file.rebate_pb2 import rebateDraw, rebateResp
from shared.db_opear.configs_data import game_configs
from app.game.core.item_group_helper import gain, get_return
from shared.utils.const import const

@remoteserviceHandle('gate')
def rebate_info_5432(data, player):
    """
    获取当前返利卡状态
    """
    response = rebate_info(player)
    
    return response.SerializePartialToString()

@remoteserviceHandle('gate')
def draw_rebate_5433(data, player):
    """
    领取返利卡日常奖励
    """
    req = rebateDraw()
    req.ParseFromString(data)
    response = rebateResp()
    response.rid = req.rid
    response.res.result = True
    recharge_item = game_configs.recharge_config.get(req.rid)
    if recharge_item and recharge_item.get('type') == 2:
        _, last, can_draw = player.rebate.rebate_status(req.rid, recharge_item.get('giftDays'))
        if last > 0 and can_draw:
            rebate = player.rebate.rebate_info(req.rid)
            rebate.draw()
            player.rebate.set_rebate(req.rid, rebate)
            player.rebate.save_data()
            return_data = gain(player, recharge_item.get('everydayGift'),
                               const.RECHARGE)  # 获取
            get_return(player, return_data, response.gain)
        else:
            response.res.result = False
            response.res.result_no = 54332
    else:
        response.res.result = False
        response.res.result_no = 54331
    return response.SerializePartialToString()

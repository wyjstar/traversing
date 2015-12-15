#coding: utf-8
'''
Created on 2015-4-27

@author: hack
'''
from gfirefly.server.globalobject import remoteserviceHandle
from app.game.core.rebate_fun import rebate_info
from app.proto_file.rebate_pb2 import rebateDraw, rebateResp
from shared.db_opear.configs_data import game_configs, data_helper
from app.game.core.item_group_helper import gain, get_return
from shared.utils.const import const
from shared.tlog import tlog_action

@remoteserviceHandle('gate')
def rebate_info_5432(data, player):
    """
    获取当前返利卡状态
    """
    print 'rebate_info_5432'
    response = rebate_info(player)
    print 'rebate_info_5432', response
    
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
    recharge_item = None
    plat = 'ios'
    if player.base_info.plat_id == 1:
        plat = 'android'
    for item in game_configs.recharge_config[plat].values():
        if item.get('id') == req.rid:
            recharge_item = item
    if recharge_item and recharge_item.get('type') == 2:
        _, last, can_draw = player.rebate.rebate_status(req.rid, recharge_item.get('giftDays'))
        if last > 0 and can_draw:
            rebate = player.rebate.rebate_info(req.rid)
            rebate.draw()
            player.rebate.set_rebate(req.rid, rebate)
            player.rebate.save_data()
            day_reward = data_helper.parse(recharge_item.get('everydayGift'))
            return_data = gain(player, day_reward,
                               const.RECHARGE)  # 获取
            get_return(player, return_data, response.gain)
            tlog_action.log('DrawRebate', player, req.rid)
        else:
            response.res.result = False
            response.res.result_no = 54332
    else:
        response.res.result = False
        response.res.result_no = 54331
    print 'draw_rebate_5433', response
    return response.SerializePartialToString()

#coding: utf-8
'''
Created on 2015-4-27

@author: hack
'''
from gfirefly.server.globalobject import remoteserviceHandle
from app.proto_file.rebate_pb2 import rebateInfo
from app.game.component.rebate.rebate import WEEK_REBATE, MONTH_REBATE
from shared.db_opear.configs_data.game_configs import base_config

@remoteserviceHandle('gate')
def rebate_info_5432(data, player):
    """
    获取当前返利卡状态
    """
    response = rebateInfo()
    
    week = base_config['weekCardMaxDays']
    week_refresh = base_config['weekCardFreshTime']
    
    month = base_config['moonCardMaxDays']
    month_refresh = base_config['moonCardFreshTime']
    
    week_switch, week_last = player.rebate.rebate_status(WEEK_REBATE, week, week_refresh)
    response.week.switch = week_switch
    response.week.last = week_last
    
    month_switch, month_last = player.rebate.rebate_status(MONTH_REBATE, month, month_refresh)
    response.month.switch = month_switch
    response.month.last = month_last
    
    return response.SerializePartialToString()
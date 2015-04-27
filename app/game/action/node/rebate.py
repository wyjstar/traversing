#coding: utf-8
'''
Created on 2015-4-27

@author: hack
'''
from gfirefly.server.globalobject import remoteserviceHandle

@remoteserviceHandle('gate')
def rebate_info_5432(data, player):
    """
    获取当前返利卡状态
    """
    
    rebate = player.rebate
    

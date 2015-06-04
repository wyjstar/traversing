# -*- coding:utf-8 -*-
"""
created by server on 14-5-20下午12:11.
"""
from app.mine.service.node.minegateservice import nodeservice_handle
from app.mine.core.mine import MineData

@nodeservice_handle
def mine_add_field_remote(uid, seq, data):
    """
    玩家攻占野怪矿
    @param nickname: 昵称
    """
    MineData.add_field(uid, seq, data)
    
    return True

@nodeservice_handle
def mine_update_remote(uid, seq):
    """
    更新信息
    """
    data = MineData.get_toupdata(seq)
    return data

@nodeservice_handle
def mine_query_info_remote(uid, seq):
    """
    请求矿点信息
    @param seq: 矿点ID
    """
    info = MineData.get_info(seq)
        
    return info

@nodeservice_handle
def mine_detail_info_remote(uid, seq):
    """
    请求矿点详细信息
    """
    detail_info = MineData.get_detail_info(seq)
    return detail_info

@nodeservice_handle
def mine_ask_battle_remote(uid, seq):
    """
    请求攻占玩家占领的野怪矿
    """
    
    result = MineData.lock_mine(uid, seq)
    
    return result

@nodeservice_handle
def mine_settle_remote(uid, seq, result, nickname, hold):
    """
    请求结算玩家占领的野怪矿
    @param seq: 矿点ID
    @param result: 战斗结果
    @param nickname: 攻占着昵称
    """
    data, uid, nickname = MineData.settle(seq, result, uid, nickname, hold)
    return data, uid, nickname

@nodeservice_handle
def mine_guard_remote(uid, seq, nickname, data):
    """
    请求更换驻守卡牌
    @param data: 卡牌数据
    """
    code = MineData.guard(uid, seq, nickname, data)
    return code

@nodeservice_handle
def mine_harvest_remote(uid, seq):
    """
    收获
    """
    status, data = MineData.harvest(uid, seq)
    return status, data

    
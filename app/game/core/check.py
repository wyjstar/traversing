# -*- coding:utf-8 -*-
"""
created by server on 14-7-9下午4:19.
"""
from app.game.core.PlayersManager import PlayersManager
from gfirefly.server.logobj import logger


def have_player(func):
    """根据动态ID 判断玩家是否存在
    """
    def wrapper(dynamic_id, *args, **kwargs):
        player = PlayersManager().get_player_by_dynamic_id(dynamic_id)
        if not player:
            logger.error('have_player cant find%s', dynamic_id)
            return {'result': False, 'result_no': 1, 'message': u''}
        if player.dynamic_id != dynamic_id:
            logger.error('have_player cant find%s:%s',
                         dynamic_id, player.dynamic_id)
            return {'result': False, 'result_no': 2, 'message': u''}
        kwargs['player'] = player
        ret = func(*args, **kwargs)
        return ret
    return wrapper


def check_have_equipment(player, equipment_id):
    """ 校验用户是否有该装备
    @param player: 用户对象
    @param equipment_id: 装备ID
    @return: 有：True
    """
    equipments_obj = player.equipment_component.equipments_obj
    equ_ids = equipments_obj.keys()
    if equipment_id in equ_ids:
        return True
    return False

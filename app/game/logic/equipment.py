# -*- coding:utf-8 -*-
"""
created by server on 14-7-9上午11:42.
"""
from app.game.logic.common.check import have_player


@have_player
def get_equipments_info(dynamic_id, get_type, get_id, **kwargs):
    """
    @param get_type: 装备类型 -1：一件 0：全部 1：武器 2：头盔 3：衣服 4：项链 5：饰品 6：宝物
    @param get_id: 装备ID
    @return: 装备的详细信息 []
    """
    player = kwargs.get('player')

    equipments = []
    if get_type == -1:
        obj = player.equipment.get_by_id(get_id)
        if obj:
            equipments.append(obj)
    elif get_type == 0:
        equipments.extend(player.equipment.get_all())
    else:
        equipments.extend(player.equipment.get_by_type(get_type))

    return equipments






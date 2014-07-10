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


@have_player
def enhance_equipment(dynamic_id, equipment_id, enhance_type, enhance_num, **kwargs):
    """
    @param dynamic_id:  客户端动态ID
    @param equipment_id: 装备ID
    @param enhance_type: 强化类型
    @param enhance_num: 强化次数
    @param kwargs:
    @return:
    """
    player = kwargs.get('player')

    equipment_obj = player.equipment.get_by_id(equipment_id)
    if not equipment_obj:
        return {'result': False, 'result_no': 401, 'message': u''}

    enhance_record = []
    if enhance_type == 1:
        #  强化1次
        if (not enhance_num) or enhance_num == 1:
            result = __do_enhance(player, equipment_obj)
            if not result:  # 金币不足
                return {'result': False, 'result_no': 101, 'message': u''}
            enhance_record.append(result)
        else:  # 强化多次
            for i in xrange(1, enhance_num):
                result = __do_enhance(player, equipment_obj)
                if not result:
                    break
                enhance_record.append(result)
    else:
        # 强化到没钱
        while True:
            result = __do_enhance(player, equipment_obj)
            if not result:
                break
            enhance_record.append(result)

    # TODO 更新
    return {'result': True, 'enhance_record': enhance_record}


def __do_enhance(player, equipment_obj):
    """
    @param player:  用户对象
    @param equipment_obj: 装备对象
    @return: {'before_lv':1, 'after_lv':2, 'cost_coin':21}
    """
    curr_coin = player.finance.coin  # 用户金币
    # curr_coin = 1000000
    enhance_cost = equipment_obj.attribute.enhance_cost  # 强化消耗
    if not enhance_cost or curr_coin < enhance_cost:
        return False
    before_lv, after_lv = equipment_obj.enhance()
    player.finance.modify_single_attr('coin', enhance_cost, add=False)
    return before_lv, after_lv, enhance_cost












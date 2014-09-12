# -*- coding:utf-8 -*-
"""
created by server on 14-7-9上午11:42.
"""
from app.game.logic.common.check import have_player
from app.game.logic import item_group_helper


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
        obj = player.equipment_component.get_equipment(get_id)
        if obj:
            equipments.append(obj)
    elif get_type == 0:
        equipments.extend(player.equipment_component.get_all())
    else:
        equipments.extend(player.equipment_component.get_by_type(get_type))

    return equipments


@have_player
def enhance_equipment(dynamic_id, equipment_id, enhance_type, enhance_num, **kwargs):
    """装备强化
    @param dynamic_id:  客户端动态ID
    @param equipment_id: 装备ID
    @param enhance_type: 强化类型
    @param enhance_num: 强化次数
    @param kwargs:
    @return:
    """
    player = kwargs.get('player')
    print player, "player"

    equipment_obj = player.equipment_component.get_equipment(equipment_id)
    print equipment_obj, "equipment_obj"
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
            for i in xrange(0, enhance_num):
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

    print "return succ"
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
    print before_lv, after_lv, "before_lv, after_lv"
    player.finance.modify_single_attr('coin', enhance_cost, add=False)
    return before_lv, after_lv, enhance_cost


@have_player
def compose_equipment(dynamic_id, chip_no, **kwargs):
    """合成装备
    """
    player = kwargs.get('player')

    chip = player.equipment_chip_component.get_chip(chip_no)
    print "chip", chip
    # 没有碎片
    if not chip:
        return {'result': False, 'result_no': 102, 'message': u''}

    compose_num = chip.compose_num
    chip_num = chip.chip_num
    print "chip_num", compose_num, chip_num
    # 碎片不足
    if chip_num < compose_num:
        return {'result': False, 'result_no': 102, 'message': u''}
    equipment_obj = player.equipment_component.add_equipment(chip.combine_result)
    chip.chip_num -= compose_num
    print "equipment_obj", equipment_obj
    return {'result': True, 'equipment_obj': equipment_obj}


@have_player
def nobbing_equipment(dynamic_id, equipment_id, **kwargs):
    player = kwargs.get('player')

    pass


@have_player
def melting_equipment(dynamic_id, equipment_ids, response, **kwargs):
    """熔炼
    @param dynamic_id:
    @param equipment_ids:
    @param kwargs:
    @return:
    """
    player = kwargs.get('player')

    equipment_obj = player.equipment_component.get_equipment(equipment_ids)
    if not equipment_obj:
        return {'result': False, 'result_no': 401, 'message': u''}
    melting_items = equipment_obj.melting_item
    gain = item_group_helper.gain(player, melting_items)
    print melting_items, 'aaaaaaaa,bdgasdflkjl;sakfj;'
    item_group_helper.get_return(player, gain, response.cgr)


@have_player
def awakening_equipment(dynamic_id, equipment_id, **kwargs):
    """觉醒
    @param dynamic_id:
    @param equipment_id:
    @param kwargs:
    @return:
    """
    pass
    # player = kwargs.get('player')
    # equipment_obj = player.equipment.get_by_id(equipment_id)
    # if not equipment_obj:
    #     return {'result': False, 'result_no': 401, 'message': u''}
    #
    #
    # equipment_chip = player.equipment_chip_component.get_chip()
    #
    # return {'result': True, 'player': player}
















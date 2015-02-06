# -*- coding:utf-8 -*-
"""
created by server on 14-7-14下午5:25.
"""
from app.proto_file import line_up_pb2
from gfirefly.server.globalobject import remoteserviceHandle
import cPickle
from app.game.core.PlayersManager import PlayersManager
from app.game.core.hero import Hero
from app.game.redis_mode import tb_character_info
from app.game.core.check import check_have_equipment
from gfirefly.server.logobj import logger
from app.proto_file.common_pb2 import CommonResponse


@remoteserviceHandle('gate')
def get_line_up_info_701(pro_data, player):
    """取得阵容信息 """
    response = line_up_info(player)
    # logger.debug(response)
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def get_target_line_up_info_706(pro_data, player):
    """取得目标玩家阵容信息
    """
    request = line_up_pb2.GetLineUpRequest()
    request.ParseFromString(pro_data)
    target_id = request.target_id

    invitee_player = PlayersManager().get_player_by_id(target_id)
    if invitee_player:  # 在线
        response = line_up_info(invitee_player)
    else:
        response = line_up_pb2.LineUpResponse()

        heros_obj = {}
        char_obj = tb_character_info.getObj(target_id)
        heros = char_obj.smem('heroes')
        equipments = char_obj.smem('equipments')

        for data in heros:
            hero = Hero(target_id)
            hero.init_data(data)
            heros_obj[hero.hero_no] = hero

        line_up_data = tb_character_info.getObj(target_id)

        if line_up_data:
            # 阵容位置信息
            line_up_slots = line_up_data.hget('line_up_slots')

            for slot_no, slot1 in line_up_slots.items():
                slot = cPickle.loads(slot1)
                add_slot = response.slot.add()
                add_slot.slot_no = slot.get('slot_no')

                add_slot.activation = slot.get('activation')
                if not slot.get('activation'):  # 如果卡牌位未激活，则不初始化信息
                    continue

                hero_obj = heros_obj.get(slot.get('hero_no'))
                if hero_obj:
                    hero = add_slot.hero
                    hero.hero_no = hero_obj.hero_no
                    hero.level = hero_obj.level
                    hero.exp = hero_obj.exp
                    hero.break_level = hero_obj.break_level

                    t_data = {'ids': [], 'datas': {}}
                    equipment_ids = slot.get('equipment_ids').values()
                    for equ_id in equipment_ids:
                        if equ_id:
                            for equ_data in equipments:
                                if equ_id == equ_data['id']:
                                    t_data['ids'].append(equ_data['equipment_info']['equipment_no'])
                                    t_data['datas'][equ_id] = equ_data

                    link_data = {}
                    for i in range(1, 6):
                        link_no = getattr(hero_obj.hero_links, 'link%s' % i)  # 羁绊技能
                        trigger_list = getattr(hero_obj.hero_links, 'trigger%s' % i)  # 羁绊触发条件
                        if not link_no:
                            continue

                        activation = 0
                        if trigger_list:
                            activation = 1

                            for no in trigger_list:
                                if len('%s' % no) == 5:  # 英雄ID
                                    if no not in hero_ids:  # 羁绊需要英雄不在阵容中
                                        activation = 0
                                        break
                                elif len('%s' % no) == 6:  # 装备ID
                                    if no not in t_data.get('ids'):  # 羁绊需要的装备不在阵容中
                                        activation = 0
                                        break
                        link_data[link_no] = activation

                    link_info = link_data
                    for key, value in link_info.items():
                        add_link = hero.links.add()
                        add_link.link_no = key
                        add_link.is_activation = value

                    for key, equipment_id in slot.get('equipment_ids').items():
                        equ_add = add_slot.equs.add()
                        equ_add.no = key

                        equipment_obj = t_data.get('datas').get(equipment_id)
                        if equipment_obj:
                            equ = equ_add.equ
                            equ.id = equipment_id
                            equ.no = equipment_obj.get('equipment_info').get('equipment_no')
                            equ.strengthen_lv = equipment_obj.get('equipment_info').get('slv')
                            equ.awakening_lv = equipment_obj.get('equipment_info').get('alv')
                            for (attr_type, [attr_value_type, attr_value, attr_increment]) in equipment_obj.get('equipment_info').get('main_attr').items():
                                main_attr_pb = equ.main_attr.add()
                                main_attr_pb.attr_type = attr_type
                                main_attr_pb.attr_value_type = attr_value_type
                                main_attr_pb.attr_value = attr_value
                                main_attr_pb. attr_increment = attr_increment

                            for (attr_type, [attr_value_type, attr_value, attr_increment]) in equipment_obj.get('equipment_info').get('minor_attr').items():
                                minor_attr_pb = equ.minor_attr.add()
                                minor_attr_pb.attr_type = attr_type
                                minor_attr_pb.attr_value_type = attr_value_type
                                minor_attr_pb.attr_value = attr_value
                                minor_attr_pb.attr_increment = attr_increment

            # 助威位置信息
            line_sub_slots = line_up_data.hget('sub_slots')
            for sub_slot_no, sub_slot in line_sub_slots.items():
                slot = cPickle.loads(sub_slot)

                add_slot = response.sub.add()
                add_slot.slot_no = slot.get('slot_no')
                add_slot.activation = slot.get('activation')
                if not slot.get('activation'):  # 如果卡牌位未激活，则不初始化信息
                    continue

                hero_obj = heros_obj.get(slot.get('hero_no'))

                if hero_obj:

                    hero = add_slot.hero
                    hero.hero_no = hero_obj.hero_no
                    hero.level = hero_obj.level
                    hero.exp = hero_obj.exp
                    hero.break_level = hero_obj.break_level
                    hero.refine = hero_obj.refine

    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def change_hero_702(pro_data, player):
    """更换英雄
    """
    request = line_up_pb2.ChangeHeroRequest()
    request.ParseFromString(pro_data)
    slot_no = request.slot_no
    change_type = request.change_type  # 更换类型
    hero_no = request.hero_no
    return change_hero(slot_no, hero_no, change_type, player)


@remoteserviceHandle('gate')
def change_equipments_703(pro_data, player):
    """更换装备
    """
    request = line_up_pb2.ChangeEquipmentsRequest()
    request.ParseFromString(pro_data)
    response = line_up_pb2.LineUpResponse()
    slot_no = request.slot_no
    no = request.no
    equipment_id = request.equipment_id
    res = change_equipment(slot_no, no, equipment_id, player)
    response.res.result = res.get("result")
    if res.get("result"):
        response = line_up_info(player)
    else:
        response.res.result_no = res.get("result_no")
    logger.debug("change_equipments_703")
    logger.debug(response)
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def change_multi_equipments_704(pro_data, player):
    """更换装备
    """
    request = line_up_pb2.ChangeMultiEquipmentsRequest()
    request.ParseFromString(pro_data)
    response = line_up_pb2.LineUpResponse()

    for temp in request.equs:
        slot_no = temp.slot_no
        no = temp.no
        equipment_id = temp.equipment_id
        change_equipment(slot_no, no, equipment_id, player)

    response = line_up_info(player)
    response.res.result = True
    logger.debug("change_multi_equipments_704")
    logger.debug(response)
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def unpar_upgrade_705(pro_data, player):
    request = line_up_pb2.LineUpUnparUpgrade()
    request.ParseFromString(pro_data)
    response = CommonResponse()
    __line_up = player.line_up_component
    response.result = __line_up.unpar_upgrade(request.skill_id,
                                              request.skill_level)
    return response.SerializePartialToString()


def change_hero(slot_no, hero_no, change_type, player):
    """
    @param dynamic_id:
    @param slot_no:
    @param hero_no:
    @param kwargs:
    @return:
    """
    logger.debug("change hero: slot_no:%d, hero_no:%d, change_type:%d",
                 slot_no, hero_no, change_type)

    # 校验该武将是否已经上阵
    response = line_up_pb2.LineUpResponse()
    if hero_no != 0 and hero_no in player.line_up_component.hero_nos:
        logger.debug("hero already in the line up+++++++")
        response.res.result = False
        response.res.result_no = 701
        return response.SerializePartialToString()

    player.line_up_component.change_hero(slot_no, hero_no, change_type)
    player.line_up_component.save_data()

    response = line_up_info(player)

    for slot in response.slot:
        logger.debug("slot no %d, %d", slot.slot_no, slot.hero.hero_no)
        for equip in slot.equs:
            logger.debug("equip no %d", equip.no)

    return response.SerializePartialToString()


def change_equipment(slot_no, no, equipment_id, player):
    """
    @param dynamic_id: 动态ID
    @param slot_no: 阵容位置
    @param no: 装备位置
    @param equipment_id: 装备ID
    @return:
    """
    logger.debug("change equipment id %s %s %s", slot_no, no, equipment_id)

    # 检验装备是否存在
    if equipment_id != '0' and not check_have_equipment(player, equipment_id):
        logger.debug("1check_have_equipment %s", equipment_id)
        return {"result":False, "result_no":702}

    # 校验该装备是否已经装备
    if equipment_id != '0' and equipment_id in player.line_up_component.on_equipment_ids:
        logger.debug("2check_have_equipment")
        return {"result":False, "result_no":703}

    # 校验装备类型
    if not player.line_up_component.change_equipment(slot_no, no, equipment_id):
        logger.debug("3check_have_equipment")
        return {"result":False, "result_no":704}
    player.line_up_component.save_data()
    return {"result":True}


def line_up_info(player):
    """取得用户的阵容信息
    """
    response = line_up_pb2.LineUpResponse()
    for temp in player.line_up_component.line_up_order:
        response.order.append(temp)
    response.unpar_id = player.line_up_component.current_unpar

    # 武将和装备
    line_up_info_detail(player.line_up_component.line_up_slots, player.line_up_component.sub_slots, response)

    # 风物志
    player.travel_component.update_travel_item(response)

    # 公会等级
    response.guild_level = player.guild.get_guild_level()

    # 无双
    for k, v in player.line_up_component.unpars.items():
        add_unpar = response.unpars.add()
        add_unpar.unpar_id = k
        add_unpar.unpar_level = v

    return response

def line_up_info_detail(line_up_slots, sub_slots, response):
    assembly_slots(line_up_slots, response)
    assembly_sub_slots(sub_slots, response)


def assembly_slots(line_up_slots, response):
    """组装阵容单元格
    """
    if line_up_slots == None:
        return
    for slot in line_up_slots.values():
        add_slot = response.slot.add()
        add_slot.slot_no = slot.slot_no

        add_slot.activation = slot.activation
        if not slot.activation:  # 如果卡牌位未激活，则不初始化信息
            continue
        hero_obj = slot.hero_slot.hero_obj  # 英雄实例
        if hero_obj:
            hero = add_slot.hero
            hero_obj.update_pb(hero)
            link_info = slot.hero_slot.link
            for key, value in link_info.items():
                add_link = hero.links.add()
                add_link.link_no = key
                add_link.is_activation = value
        for key, equipment_slot in slot.equipment_slots.items():
            equ_add = add_slot.equs.add()
            equ_add.no = key
            equipment_obj = equipment_slot.equipment_obj
            if equipment_obj:
                equ = equ_add.equ
                equipment_obj.update_pb(equ)
                equ.set.no = equipment_slot.suit.get('suit_no', 0)
                equ.set.num = equipment_slot.suit.get('num', 0)


def assembly_sub_slots(sub_slots, response):
    """组装助威阵容
    """
    for slot in sub_slots.values():
        add_slot = response.sub.add()
        add_slot.slot_no = slot.slot_no

        add_slot.activation = slot.activation
        if not slot.activation:  # 如果卡牌位未激活，则不初始化信息
            continue
        hero_obj = slot.hero_slot.hero_obj  # 英雄实例
        if hero_obj:
            hero = add_slot.hero
            hero_obj.update_pb(hero)
            link_info = slot.hero_slot.link
            for key, value in link_info.items():
                add_link = hero.links.add()
                add_link.link_no = key
                add_link.is_activation = value

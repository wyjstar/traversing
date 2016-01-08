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
from app.game.action.node.equipment import enhance_equipment
from shared.tlog import tlog_action
from app.game.core.activity import target_update
from shared.db_opear.configs_data import game_configs
from app.game.core.item_group_helper import consume, is_afford
from shared.utils.const import const
from shared.common_logic.feature_open import is_not_open, FO_CHANGE_EQUIPMENT


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

    char_obj = tb_character_info.getObj(target_id)
    if target_id >= 10000 and char_obj.exists():
        response = char_obj.hget('copy_slots')
        if response:
            return response
    else:
        robot_obj = tb_character_info.getObj('robot')
        if robot_obj.hexists(target_id):
            robot_obj = robot_obj.hget(target_id)
            response = robot_obj.get('copy_slots')
            return response

    logger.error('get_target_line_up_info_706 cant find player:%s', target_id)
    response = line_up_pb2.LineUpResponse()
    response.res.result = False
    response.res.result_no = 70601
    return response.SerializePartialToString()

    # ========================remove========================
    invitee_player = PlayersManager().get_player_by_id(target_id)
    if invitee_player:  # 在线
        response = line_up_info(invitee_player)
    else:
        response = line_up_pb2.LineUpResponse()

        heros_obj = {}
        char_obj = tb_character_info.getObj(target_id)
        heros = char_obj.getObj('heroes').hgetall()
        equipments = char_obj.getObj('equipments').hgetall()
        hero_ids = heros.keys()

        for data in heros.values():
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
                            for equ_data in equipments.values():
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
    logger.debug("request %s" % request)
    res = change_equipment(slot_no, no, equipment_id, player)
    response.res.result = res.get("result")
    if res.get("result"):
        response = line_up_info(player)
    else:
        response.res.result_no = res.get("result_no")
    # logger.debug("change_equipments_703")
    # logger.debug(response)
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
    # logger.debug("change_multi_equipments_704")
    # logger.debug(response)
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def unpar_upgrade_705(pro_data, player):
    """
    无双升级
    """
    response = CommonResponse()
    response.result = True
    _line_up = player.line_up_component
    peerless_grade_info = game_configs.skill_peerless_grade_config.get(_line_up._unpar_level)
    resource1 = peerless_grade_info.resource1
    resource2 = peerless_grade_info.resource2
    if not is_afford(player, resource1) or not is_afford(player, resource2):
        logger.error("resource not enough!")
        response.result = False
        response.result_no = 70501
        return response.SerializePartialToString()

    consume(player, resource1, const.UNPAR_UPGRADE)
    consume(player, resource2, const.UNPAR_UPGRADE)
    _line_up.unpar_level = _line_up.unpar_level + 1
    _line_up.save_data()
    tlog_action.log('UnparUpgrade', player,
                    _line_up.unpar_level)
    logger.debug("response %s" % response)
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def one_key_strength_equipment_707(pro_data, player):
    """
    一键强化阵容装备
    """
    request = line_up_pb2.AllEquipmentsStrengthRequest()
    request.ParseFromString(pro_data)
    slot_no = request.slot_no   #卡牌槽
    response = line_up_pb2.AllEquipmentsStrengthResponse() # 响应

    # 校验
    if not player.base_info.all_equipment_strength_one_key:
        logger.debug('one_key_strength_equipment_707 vip level not reach!%d' % player.base_info.all_equipment_strength_one_key)
        response.res.result = False
        response.res.result_no = 403
        return response.SerializePartialToString()

    line_up_slot = player.line_up_component.line_up_slots[slot_no]
    equip_slots = line_up_slot.equipment_slots.values()
    equ_slots = [] # 去掉不能强化的装备
    for item in equip_slots:
        if not item.equipment_obj or item.equipment_obj.equipment_config_info.type in [5, 6]:
            continue
        equ_slots.append(item)

    def compare(a, b):
        if a.equipment_obj.attribute.strengthen_lv < b.equipment_obj.attribute.strengthen_lv:
            return 1
        elif a.equipment_obj.attribute.strengthen_lv > b.equipment_obj.attribute.strengthen_lv:
            return -1
        else:
            if a.equipment_obj.equipment_config_info.quality < b.equipment_obj.equipment_config_info.quality:
                return 1
            elif a.equipment_obj.equipment_config_info.quality < b.equipment_obj.equipment_config_info.quality:
                return -1
            else:
                for i in [2,3,1,4]: # 强化顺序武器2》铠甲3》头盔1》战靴4
                    if a.equipment_obj.equipment_config_info.type == i:
                        return 1
                    if b.equipment_obj.equipment_config_info.type == i:
                        return -1
                return 1

    results = []

    origin_coin = player.finance.coin
    while len(results) < len(equ_slots):
        sorted_equip_slots = sorted(equ_slots, cmp=compare, reverse=True)

        for equ in sorted_equip_slots:
            enhance_info_pb = response.infos.add()
            equipment_id = equ.equipment_obj.base_info.id
            logger.debug("equ slot no: %s id:%s" % (equ.id, equ.equipment_obj.base_info.id))
            enhance_info = enhance_equipment(equipment_id, 1, player)
            if not enhance_info.get('result'):
                if equ.id not in results: results.append(equ.id)
                logger.debug("equ slot no fail: %s %s" % (equ.id, enhance_info.get("result_no")))
                continue
            logger.debug("equ slot no succ: %s" % equ.id)

            enhance_info_pb.slot_no = equ.id
            enhance_record = enhance_info.get('enhance_record')
            for before_lv, after_lv, enhance_cost in enhance_record:
                data_format = enhance_info_pb.data.add()
                data_format.before_lv = before_lv
                data_format.after_lv = after_lv
                data_format.cost_coin = enhance_cost
                tlog_action.log('EquipmentEnhance', player,
                                enhance_info.get('equipment_no'),
                                equipment_id, before_lv, after_lv)
            break

    after_coin = player.finance.coin

    line_up_info(player, response.line_up)
    response.coin = origin_coin - after_coin
    response.slot_no = slot_no
    response.res.result = True

    logger.debug(response.coin)
    logger.debug(response.infos)
    return response.SerializePartialToString()

def change_hero_logic(slot_no, hero_no, change_type, player):
    if hero_no != 0 and hero_no in player.line_up_component.hero_nos:
        # 校验该武将是否已经上阵
        return {"result": False, "result_no": 701}

    player.line_up_component.change_hero(slot_no, hero_no, change_type)
    player.line_up_component.save_data()
    return {"result": True }

def change_hero(slot_no, hero_no, change_type, player):
    """
    @param dynamic_id:
    @param slot_no:
    @param hero_no:
    @param kwargs:
    @return:
    """
    # logger.debug("change hero: slot_no:%d, hero_no:%d, change_type:%d",
                 # slot_no, hero_no, change_type)

    res = change_hero_logic(slot_no, hero_no, change_type, player)
    response = line_up_pb2.LineUpResponse()
    if not res.get("result"):
        # logger.debug("hero already in the line up+++++++")
        response.res.result = res.get("result")
        response.res.result_no = res.get("result_no")
        return response.SerializePartialToString()

    response = line_up_info(player)

    for slot in response.slot:
        # logger.debug("slot no %d, %d", slot.slot_no, slot.hero.hero_no)
        for equip in slot.equs:
            # logger.debug("equip no %d", equip.no)
            pass

    return response.SerializePartialToString()


def change_equipment(slot_no, no, equipment_id, player):
    """
    @param dynamic_id: 动态ID
    @param slot_no: 阵容位置
    @param no: 装备位置
    @param equipment_id: 装备ID
    @return:
    """
    # logger.debug("change equipment id %s %s %s", slot_no, no, equipment_id)
    if is_not_open(player, FO_CHANGE_EQUIPMENT):
        return {"result": False, "result_no": 837}

    # 检验装备是否存在
    if equipment_id != '0' and not check_have_equipment(player, equipment_id):
        logger.debug("1check_have_equipment %s", equipment_id)
        return {"result": False, "result_no": 702}

    # 校验该装备是否已经装备
    if equipment_id != '0' and equipment_id in player.line_up_component.on_equipment_ids:
        logger.debug("2check_have_equipment")
        return {"result": False, "result_no": 703}

    # 校验装备类型
    if not player.line_up_component.change_equipment(slot_no, no, equipment_id):
        logger.debug("3check_have_equipment")
        return {"result": False, "result_no": 704}
    player.line_up_component.save_data()
    # 更新 七日奖励
    target_update(player, [55])
    return {"result": True}


def line_up_info(player, response=None):
    """取得用户的阵容信息
    """
    _line_up = player.line_up_component
    if not response:
        response = line_up_pb2.LineUpResponse()
        response.res.result = True
    for temp in _line_up.line_up_order:
        response.order.append(temp)

    # 武将和装备
    line_up_info_detail(_line_up.line_up_slots, _line_up.sub_slots, response)

    # 风物志
    player.travel_component.update_travel_item(response)

    # 公会等级
    # response.guild_level = player.guild.get_guild_level()
    response.guild_level = 1

    # 无双
    response.unpar_level = _line_up.unpar_level
    response.unpar_type = _line_up.unpar_type
    response.unpar_other_id = _line_up.unpar_other_id
    for hero_no in _line_up._ever_have_heros:
        response.ever_have_heros.append(hero_no)
    for name in _line_up.unpar_names:
        response.unpar_names.append(str(name))

    response.caption_pos = _line_up.caption_pos
    logger.debug("line_up_info caption_pos %s" % response.caption_pos)

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
            for key, value in link_info:
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
            for key, value in link_info:
                add_link = hero.links.add()
                add_link.link_no = key
                add_link.is_activation = value

@remoteserviceHandle('gate')
def save_line_order_708(pro_data, player):
    """
    保存布阵信息
    """
    request = line_up_pb2.SaveLineUpOrderRequest()
    request.ParseFromString(pro_data)
    response = CommonResponse()
    response.result = True
    line_up_info = []  # {hero_id:pos}
    for line in request.lineup:
        line_up_info.append(line)
    if len(line_up_info) != 6:
        logger.error("line up order error %s !" % len(line_up_info))
        response.result = False
        return
    logger.debug("line_up %s, unpar_type%s, unpar_other_id%s" % (request.lineup, request.unpar_type, request.unpar_other_id))
    player.line_up_component.line_up_order = line_up_info
    player.line_up_component._unpar_type = request.unpar_type
    player.line_up_component._unpar_other_id = request.unpar_other_id
    player.line_up_component.save_data(["line_up_order", "unpar_type", "unpar_other_id"])

    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def set_captain_709(pro_data, player):
    """
    设置队长
    """
    request = line_up_pb2.SetCaptainRequest()
    request.ParseFromString(pro_data)
    caption_pos = request.caption_pos
    logger.debug("request %s" % request.caption_pos)

    response = CommonResponse()
    line_up_slots = player.line_up_component.line_up_slots
    if caption_pos not in line_up_slots or (not line_up_slots[caption_pos].hero_slot.hero_obj):
        response.result = False
        return response.SerializePartialToString()

    player.line_up_component.caption_pos = caption_pos
    player.line_up_component.save_data(["caption_pos"])
    response.result = True
    logger.debug(response)
    return response.SerializePartialToString()

@remoteserviceHandle('gate')
def active_unpar_710(pro_data, player):
    """
    激活无双
    """
    request = line_up_pb2.ActiveUnparaRequest()
    request.ParseFromString(pro_data)
    logger.debug("request %s" % request)
    unpar_names = player.line_up_component.unpar_names
    if request.name not in unpar_names:
        unpar_names.append(request.name)
    player.line_up_component.save_data()
    response = CommonResponse()
    response.result = True
    return response.SerializePartialToString()

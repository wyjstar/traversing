# -*- coding:utf-8 -*-
"""
created by.
"""
from gfirefly.server.globalobject import remoteserviceHandle
from gfirefly.server.globalobject import GlobalObject
from app.proto_file import start_target_pb2
from shared.db_opear.configs_data import game_configs
from gfirefly.server.logobj import logger
from app.game.core.item_group_helper import gain, get_return
from shared.utils.const import const
import time
from shared.tlog import tlog_action


remote_gate = GlobalObject().remote.get('gate')


@remoteserviceHandle('gate')
def get_target_info_1826(data, player):
    """获取任务信息"""
    args = start_target_pb2.GetStartTargetInfoRequest()
    args.ParseFromString(data)
    # day = args.day  # 0为所有
    response = start_target_pb2.GetStartTargetInfoResponse()

    # 第几天登录
    day = player.base_info.login_day

    # 更新一下 登录奖励的状态
    # player.start_target.update_29()

    response.day = day
    # 需要查询的目标ID
    target_ids = {}
    if args.day:
        ids = []
        for a, b in game_configs.base_config.get('seven'+str(args.day)).items():
            ids += b
        target_ids[args.day] = ids
    else:
        for x in [1, 2, 3, 4, 5, 6, 7]:
            if x > day:
                continue
            ids = []
            for a, b in game_configs.base_config.get('seven'+str(x)).items():
                ids += b
            target_ids[x] = ids

    for _, ids in target_ids.items():
        for target_id in ids:
            if not player.act.is_activiy_open(target_id):
                continue

            logger.debug("target_id %s" % target_id)
            info = get_act_info(player, target_id)
            target_info_pro = response.start_target_info.add()
            target_info_pro.target_id = target_id
            if info.get('jindu'):
                target_info_pro.jindu = info.get('jindu')
            if info.get('state'):
                target_info_pro.state = info.get('state')

    player.act.save_data()

    logger.debug("response %s" % response)
    response.res.result = True
    return response.SerializeToString()


def line_up_activity_jindu(player, target_conf):
    """docstring for line_up_activity"""

    HERO_QUALITY = 1
    HERO_BREAK_LEVEL = 2
    HERO_AWAKE_LEVEL = 3
    HERO_LEVEL = 4
    HERO_REFINE = 5
    EQU_QUALITY = 6
    EQU_NUM = 7
    EQU_LEVEL = 8
    RUNT_QUALITY = 9
    RUNT_NUM = 10
    jindu = 0
    line_up_slots = player.line_up_component.line_up_slots
    parameterE = target_conf.parameterE
    for slot in line_up_slots.values():
        if not slot.activation:  # 如果卡牌位未激活
            continue
        hero_obj = slot.hero_slot.hero_obj  # 英雄实例
        if not hero_obj:
            continue
        if hero_obj.hero_info.quality < parameterE.get(HERO_QUALITY, 0):
            # 3 武将品质
            continue
        if hero_obj.break_level < parameterE.get(HERO_BREAK_LEVEL, 0):
            # 4 武将突破等级
            continue
        if hero_obj.awake_level < parameterE.get(HERO_AWAKE_LEVEL, 0):
            # 5 武将觉醒等级
            continue
        if hero_obj.level < parameterE.get(HERO_LEVEL, 0):
            # 6 武将等级
            continue
        pulse = hero_obj.finished_pulse()
        if pulse < parameterE.get(HERO_REFINE, 0):
            # 7 武将练体
            continue
        print(hero_obj.hero_info.quality, hero_obj.break_level, hero_obj.awake_level, hero_obj.level, hero_obj.refine, pulse)

        runt_num = 0
        for (runt_type, item) in hero_obj.runt.items():
            for (runt_po, runt_info) in item.items():
                quality = game_configs.stone_config.get('stones'). \
                    get(runt_info[1]).quality
                if quality >= parameterE.get(RUNT_QUALITY, 0):
                    runt_num += 1

        logger.debug("runt_num %s" % runt_num)
        if runt_num < parameterE.get(RUNT_NUM, 0):
            # 11 符文数量
            continue

        equ_num = 0
        for equ_slot_no in range(1, 5):
            equ_slot = slot.equipment_slots.get(equ_slot_no)
            if not equ_slot.equipment_id:
                continue
            equipment_obj = equ_slot.equipment_obj
            if equipment_obj.equipment_config_info.quality < parameterE.get(EQU_QUALITY, 0):
                continue
            if equipment_obj.attribute.strengthen_lv < parameterE.get(EQU_LEVEL, 0):
                continue
            equ_num += 1
        logger.debug("equ_num %s" % equ_num)

        if equ_num < parameterE.get(EQU_NUM, 0):
            # 9 装备数量
            continue
        jindu += 1
    return jindu


@remoteserviceHandle('gate')
def get_target_info_1827(data, player):
    """获取任务奖励"""
    args = start_target_pb2.GetStartTargetRewardRequest()
    args.ParseFromString(data)
    target_id = args.target_id
    response = start_target_pb2.GetStartTargetRewardResponse()

    if not player.act.is_activiy_open(target_id):
        response.res.result = False
        logger.error("start target dont open")
        response.res.result_no = 890  # 不在活动时间内
        return response.SerializeToString()
    # 第几天登录
    day = player.base_info.login_day

    target_ids = []
    for x in [1, 2, 3, 4, 5, 6, 7]:
        if x > day:
            continue
        for a, b in game_configs.base_config.get('seven'+str(x)).items():
            target_ids += b

    if target_id not in target_ids:
        response.res.result = False
        logger.error("this start target dont open")
        response.res.result_no = 800
        return response.SerializeToString()

    target_info = player.act.act_infos.get(target_id)
    target_conf = game_configs.activity_config.get(target_id)

    info = get_target_info(player, target_id)
    if (target_conf.type != 30 and info.get('state') != 2) or (target_conf.type == 30 and info.get('state') == 3):
        response.res.result = False
        logger.error("this start target 条件不满足")
        response.res.result_no = 800
        return response.SerializeToString()

    need_gold = 0
    if target_conf.type == 30:
        need_gold = target_conf.parameterB

    def func():
        return_data = gain(player, target_conf.reward, const.START_TARGET)  # 获取
        get_return(player, return_data, response.gain)
        if target_conf.type == 30:
            if target_conf.count <= (info.get('jindu') + 1):
                player.act.act_infos[target_id] = [3, 0]
            else:
                player.act.act_infos[target_id] = [1, info.get('jindu') + 1]
        else:
            player.act.act_infos[target_id] = [3, 0]

        tlog_action.log('StartTargetGetGift', player, target_id)

    player.pay.pay(need_gold, const.START_TARGET, func)
    player.act.save_data()

    response.res.result = True
    return response.SerializeToString()


def target_update(player, conditions):
    """
    conditions: [], 要更新的活动类型ID
    """
    print 'target_update, conditions:', conditions
    # 第几天登录
    if player.base_info.id < 10000:
        return

    day = player.base_info.login_day

    # 更新状态的，如果完成就同志客户端，首先判断了，有没有开启可以领取（七日）。
    target_ids = []
    for x in [1, 2, 3, 4, 5, 6, 7]:
        if x > day:
            continue
        for a, b in game_configs.base_config.get('seven'+str(x)).items():
            target_ids += b

    for target_id in target_ids:
        target_info = player.act.act_infos.get(target_id)
        target_conf = game_configs.activity_config.get(target_id)
        if target_conf.type not in conditions:
            continue
        if not player.act.is_activiy_open(target_id):
            continue

        if target_info and target_info[0] == 3:
            continue
        else:
            info = get_target_info(player, target_id)
            if info.get('state') == 2:
                remote_gate.push_object_remote(1841,
                                               u'',
                                               [player.dynamic_id])
                logger.debug("target_update, push message")
                return

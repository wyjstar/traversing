# -*- coding:utf-8 -*-
"""
created by cui.
"""
from gfirefly.server.globalobject import remoteserviceHandle
from gfirefly.server.globalobject import GlobalObject
from shared.db_opear.configs_data import game_configs
from gfirefly.server.logobj import logger
from shared.utils.const import const
import time
from shared.tlog import tlog_action
from shared.utils.date_util import days_to_current, get_current_timestamp


remote_gate = GlobalObject().remote.get('gate')


def get_act_info(player, act_id):
    act_info = player.act.act_infos.get(act_id)
    act_conf = game_configs.activity_config.get(act_id)
    jindu = 0
    day = player.base_info.login_day
    print act_conf, '==========get act info , act config'
    if act_conf.type not in [65, 70, 72, 74]:  # 每日的
        if act_info and act_info[0] == 3:
            return {'state': 3, 'jindu': act_info[1]}
        elif act_info and act_info[0] == 2:
            return {'state': 2, 'jindu': act_info[1]}

    if act_conf.type == 1:
        # 累计登录
        if not act_info:
            player.act.act_infos[act_id] = [1, [1, int(time.time())]]
            act_info = player.act.act_infos.get(act_id)
            jindu = 1
        else:
            if days_to_current(act_info[1][1]) > 0:
                act_info[1][0] += 1
                act_info[1][1] = int(time.time())
            jindu = act_info[1][0]
        if jindu >= act_conf.parameterA:
            act_info[0] = 2
        print act_info, '==========get act info 1'
        return {'state': act_info[0], 'jindu': act_info[1][0]}
    elif act_conf.type == 18:
        # 连续登录
        if not act_info:
            player.act.act_infos[act_id] = [1, [1, int(time.time())]]
            act_info = player.act.act_infos.get(act_id)
            jindu = 1
        else:
            if days_to_current(act_info[1][1]) == 1:
                act_info[1][0] += 1
                act_info[1][1] = int(time.time())
            elif days_to_current(act_info[1][1]) > 1:
                act_info[1][0] = 1
                act_info[1][1] = int(time.time())
                # 重置前面的天数里的活动
                for up_act_id in act_conf.parameterC:
                    up_act_info = player.act.act_infos.get(up_act_id)
                    up_act_conf = game_configs.activity_config.get(up_act_id)
                    if not up_act_info or not up_act_conf:
                        continue
                    up_act_state = 1
                    if up_act_conf.parameterA == 1:
                        up_act_state = 2
                    player.act.act_infos[up_act_id] = [up_act_state, [1, int(time.time())]]
            jindu = act_info[1][0]
        if jindu >= act_conf.parameterA:
            act_info[0] = 2
        print act_info, '==========get act info 18'
        return {'state': act_info[0], 'jindu': act_info[1][0]}
    elif act_conf.type == 29:
        # jindu = get_condition(conditions, 29)
        # if jindu and jindu[int(act_conf.parameterA)-1]:
        if day >= act_conf.parameterA:
            return {'state': 2}
        else:
            return {'state': 1}
    elif act_conf.type == 30:
        if not act_info:
            player.act.act_infos[act_id] = [2, 0]
            return {'state': 2}
        else:
            return {'state': act_info[0], 'jindu': act_info[1]}
    elif act_conf.type == 31:
        if act_info and act_info[0] == 2:
            return {'state': 2}
        state = 1
        jindu = 0
        # 上阵全部武将达到20级
        line_up_slots = player.line_up_component.line_up_slots
        for slot in line_up_slots.values():
            if not slot.activation:  # 如果卡牌位未激活
                continue
            hero_obj = slot.hero_slot.hero_obj  # 英雄实例
            if hero_obj:
                if hero_obj.level >= act_conf.parameterA:
                    jindu += 1
            if jindu >= act_conf.parameterB:
                state = 2
        if state == 2:
            player.act.act_infos[act_id][0] = 2
            return {'state': 2}
        else:
            if jindu and act_info and act_info[0] < jindu:
                player.act.act_infos[act_id] = [1, jindu]
            return {'state': state, 'jindu': jindu}
    elif act_conf.type == 32:
        state = 1
        jindu = 0
        # 拥有3名突破1的武将
        line_up_slots = player.line_up_component.line_up_slots
        for slot in line_up_slots.values():
            if not slot.activation:  # 如果卡牌位未激活
                continue
            hero_obj = slot.hero_slot.hero_obj  # 英雄实例
            if hero_obj:
                if hero_obj.break_level >= act_conf.parameterA:
                    jindu += 1
            if jindu >= act_conf.parameterB:
                state = 2

        if state == 2:
            player.act.act_infos[act_id][0] = 2
            return {'state': 2}
        else:
            if jindu and act_info and act_info[0] < jindu:
                player.act.act_infos[act_id] = [1, jindu]
            return {'state': state, 'jindu': jindu}
    elif act_conf.type == 33:
        # 竞技场排名到1500名
        jindu = player.pvp.pvp_high_rank
        if jindu <= act_conf.parameterA:
            state = 2
            player.act.act_infos[act_id] = [2, jindu]
            return {'state': 2}
        else:
            if not act_info or jindu < act_info[1]:
                player.act.act_infos[act_id] = [1, jindu]
                return {'state': 1, 'jindu': jindu}
            else:
                return {'state': 1, 'jindu': act_info[1]}
    elif act_conf.type == 34:
        state = 1
        jindu = 0
        # 每个上阵武将经脉激活3个穴位
        line_up_slots = player.line_up_component.line_up_slots
        for slot in line_up_slots.values():
            if not slot.activation:  # 如果卡牌位未激活
                continue
            hero_obj = slot.hero_slot.hero_obj  # 英雄实例
            if hero_obj:
                if hero_obj.refine >= act_conf.parameterA:
                    jindu += 1

        if jindu >= act_conf.parameterB:
            state = 2

        if state == 2:
            player.act.act_infos[act_id][0] = 2
            return {'state': 2}
        else:
            if jindu and act_info and act_info[0] < jindu:
                player.act.act_infos[act_id] = [1, jindu]
            return {'state': state, 'jindu': jindu}

    elif act_conf.type == 35:
        # 过关斩将通关第十关
        jindu = player.pvp.pvp_overcome_current - 1
        if jindu >= act_conf.parameterA:
            player.act.act_infos[act_id] = [2, jindu]
            return {'state': 2}
        else:
            if not act_info or jindu > act_info[1]:
                player.act.act_infos[act_id] = [1, jindu]
                return {'state': 1, 'jindu': jindu}
            else:
                return {'state': 1, 'jindu': act_info[1]}
    elif act_conf.type == 36:
        jindu = 0

        for equipment_id in player.line_up_component.on_equipment_ids:
            equipment_obj = player.equipment_component.get_equipment(equipment_id)
            if equipment_obj.attribute.strengthen_lv >= act_conf.parameterA:
                jindu += 1

        if jindu >= act_conf.parameterB:
            player.act.act_infos[act_id] = [2, jindu]
            return {'state': 2}
        else:
            if not act_info or jindu > act_info[1]:
                player.act.act_infos[act_id] = [1, jindu]
                return {'state': 1, 'jindu': jindu}
            else:
                return {'state': 1, 'jindu': act_info[1]}
    elif act_conf.type == 37:
        # 武将觉醒等级
        jindu = 0
        line_up_slots = player.line_up_component.line_up_slots
        for slot in line_up_slots.values():
            if not slot.activation:  # 如果卡牌位未激活
                continue
            hero_obj = slot.hero_slot.hero_obj  # 英雄实例
            if hero_obj:
                if hero_obj.break_level >= act_conf.parameterA:
                    jindu += 1

        if jindu >= act_conf.parameterB:
            player.act.act_infos[act_id] = [2, jindu]
            return {'state': 2}
        else:
            if not act_info or jindu > act_info[1]:
                player.act.act_infos[act_id] = [1, jindu]
                return {'state': 1, 'jindu': jindu}
            else:
                return {'state': 1, 'jindu': act_info[1]}
    elif act_conf.type == 38:
        #  黄巾起义 累积伤害
        if not act_info:
            player.act.act_infos[act_id] = [1, 0]
            jindu = 0
        else:
            jindu = act_info[1]
    elif act_conf.type == 39:
        #  黄巾起义 最高伤害
        if not act_info:
            player.act.act_infos[act_id] = [1, 0]
            jindu = 0
        else:
            jindu = act_info[1]
    elif act_conf.type == 40:
        # 镶嵌A个B级别宝石
        jindu = 0
        line_up_slots = player.line_up_component.line_up_slots
        for slot in line_up_slots.values():
            if not slot.activation:  # 如果卡牌位未激活
                continue
            hero_obj = slot.hero_slot.hero_obj  # 英雄实例
            if hero_obj:
                for (runt_type, item) in hero_obj.runt.items():
                    for (runt_po, runt_info) in item.items():
                        # [runt_no, runt_id, main_attr, minor_attr] = runt_info
                        quality = game_configs.stone_config.get('stones'). \
                            get(runt_info[1]).quality
                        if quality == act_conf.parameterB:
                            jindu += 1

        if jindu >= act_conf.parameterA:
            player.act.act_infos[act_id] = [2, jindu]
            return {'state': 2}
        else:
            if not act_info or jindu > act_info[1]:
                player.act.act_infos[act_id] = [1, jindu]
                return {'state': 1, 'jindu': jindu}
            else:
                return {'state': 1, 'jindu': act_info[1]}
    elif act_conf.type == 41:
        # 占领矿达到a个
        if not act_info:
            player.act.act_infos[act_id] = [1, 0]
            jindu = 0
        else:
            jindu = act_info[1]
    elif act_conf.type == 45:
        if player.stage_component.get_stage(act_conf.parameterA).state != 1:
            return {'state': 1}
        else:
            return {'state': 2}
    elif act_conf.type == 44:
        if not act_info:
            player.act.act_infos[act_id] = [1, 0]
            jindu = 0
        else:
            jindu = act_info[1]
    elif act_conf.type == 43:
        # 战队等级 达到a
        jindu = player.base_info.level
    elif act_conf.type == 46:
        # 战斗力达到a
        jindu = int(player.line_up_component.hight_power)
    elif act_conf.type == 55:
        # 阵容条件: 武将数量，品质，突破等级
        jindu = line_up_activity_jindu(player, act_conf)
        logger.debug("jindu %s " % jindu)

    elif act_conf.type in [56, 57, 58, 59]:
        # 秘境条件: 刷新秘境，占领矿点，宝石收取，宝石合成
        jindu = player.act.mine_activity_jindu(act_conf)
        if jindu >= act_conf.parameterA:
            return {'state': 2, 'jindu': jindu}
        else:
            return {'state': 1, 'jindu': jindu}
    elif act_conf.type in [60, 61, 62, 63]:
        # 宝物：合成，品质，数量
        jindu = player.act.treasure_activity_jindu(act_conf)
        if jindu >= act_conf.parameterA:
            return {'state': 2, 'jindu': jindu}
        else:
            return {'state': 1, 'jindu': jindu}
    elif act_conf.type == 51:
        if not act_info:
            player.act.act_infos[act_id] = [0, []]
            return {'state': 0, 'jindu': []}
        if len(act_info[1]) < int(act_conf.parameterA):
            return {'state': 1, 'jindu': act_info[1]}

        if act_conf.parameterB > player.base_info.level:
            return {'state': 1, 'jindu': act_info[1]}

        if len(act_conf.parameterC) == 1 and \
                act_conf.parameterC[0] > player.line_up_component.hight_power:
            return {'state': 1, 'jindu': act_info[1]}

        if len(act_conf.parameterD) == 1 and \
           player.stage_component.get_stage(act_conf.parameterD[0]).state != 1:
            return {'state': 1, 'jindu': act_info[1]}

        player.act.act_infos[act_id][0] = 2
        return {'state': 2, 'jindu': act_info[1]}
    elif act_conf.type == 50:
        if not act_info:
            player.act.act_infos[act_id] = [0, [0, 0, 0]]
            return {'state': 1, 'jindu': [0, 0, 0]}

        base_info = player.base_info
        if int(act_conf.parameterA) > base_info.vip_level:
            return {'state': 1, 'jindu': act_info[1]}

        if len(act_conf.parameterC) == 1 and \
                not act_conf.parameterC[0] > act_info[1][0]:
            return {'state': 1, 'jindu': act_info[1]}

        if len(act_conf.parameterD) == 1 and \
                not act_conf.parameterD[0] > act_info[1][1]:
            return {'state': 1, 'jindu': act_info[1]}
        return {'state': 2, 'jindu': act_info[1]}
    elif act_conf.type in [70, 72, 74, 65]:
        if not act_info:
            player.act.act_infos[act_id] = [1, 0, int(time.time())]
            return {'state': 1, 'jindu': 0}
        if days_to_current(act_info[2]) != 0:
            player.act.act_infos[act_id] = [1, 0, int(time.time())]
            return {'state': 1, 'jindu': 0}

        if act_info and act_info[0] == 3:
            return {'state': 3, 'jindu': act_info[1]}
        elif act_info and act_info[0] == 2:
            return {'state': 2, 'jindu': act_info[1]}

        if act_info[1] < int(act_conf.parameterA):
            return {'state': 1, 'jindu': act_info[1]}

        player.act.act_infos[act_id][0] = 2
        return {'state': 2, 'jindu': act_info[1]}
    elif act_conf.type in [71, 73, 75, 76, 77]:
        if not act_info:
            player.act.act_infos[act_id] = [1, 0]
            return {'state': 1, 'jindu': 0}
        if act_info[1] < int(act_conf.parameterA):
            return {'state': 1, 'jindu': act_info[1]}

        player.act.act_infos[act_id][0] = 2
        return {'state': 2, 'jindu': act_info[1]}
    else:
        logger.error('get act info type error')
        return {'state': 0, 'jindu': 0}

    # 到到a的统一在这里返回
    if jindu >= act_conf.parameterA:
        player.act.act_infos[act_id] = [2, jindu]
        return {'state': 2}
    else:
        if not act_info or jindu > act_info[1]:
            player.act.act_infos[act_id] = [1, jindu]
            return {'state': 1, 'jindu': jindu}
        else:
            return {'state': 1, 'jindu': act_info[1]}


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
            info = get_act_info(player, target_id)
            if info.get('state') == 2:
                remote_gate.push_object_remote(1841,
                                               u'',
                                               [player.dynamic_id])
                logger.debug("target_update, push message")
                return

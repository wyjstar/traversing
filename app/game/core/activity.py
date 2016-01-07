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


def get_act_info(player, act_id):
    act_info = player.act.act_infos.get(act_id)
    act_conf = game_configs.activity_config.get(act_id)
    conditions = player.act.conditions
    jindu = 0
    if act_info and act_info[0] == 3:
        return {'state': 3, 'jindu': act_info[1]}
    elif act_info and act_info[0] == 2:
        return {'state': 2}

    elif act_conf.type == 29:
        # jindu = get_condition(conditions, 29)
        # if jindu and jindu[int(act_conf.parameterA)-1]:
        if day >= act_conf.parameterA:
            return {'state': 2}
        else:
            return {'state': 1}
    elif act_conf.type == 30:
        if not act_info:
            player.act.act_infos[act_id] = [1, 0]
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
        jindu = get_condition(conditions, 38)
    elif act_conf.type == 39:
        #  黄巾起义 最高伤害
        jindu = get_condition(conditions, 39)
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
        jindu = get_condition(conditions, 41)
    elif act_conf.type == 42:
        # 夺宝合成数量达到a个
        jindu = 1
    elif act_conf.type == 45:
        if player.stage_component.get_stage(act_conf.parameterA).state != 1:
            return {'state': 1}
        else:
            return {'state': 2}
    elif act_conf.type == 44:
        jindu = get_condition(conditions, 44)
    elif act_conf.type == 43:
        # 战队等级 达到a
        jindu = player.base_info.level
    elif act_conf.type == 46:
        # 战斗力达到a
        jindu = player.line_up_component.hight_power
    elif act_conf.type == 55:
        # 阵容条件: 武将数量，品质，突破等级
        jindu = line_up_activity_jindu(player, act_conf)
        logger.debug("jindu %s " % jindu)

    elif act_conf.type in [56, 57, 58, 59]:
        # 秘境条件: 刷新秘境，占领矿点，宝石收取，宝石合成
        jindu = player.act.mine_activity_jindu(act_conf)
    elif act_conf.type in [60, 61, 62, 63]:
        # 宝物：合成，品质，数量
        jindu = player.act.treasure_activity_jindu(act_conf)
    elif act_conf.type == 51:
        if not act_info:
            return {'state': 0}
        if len(act_info[1]) < int(act_conf.parameterA):
            return {'state': 1, 'jindu': act_info[1]}

        if act_conf.parameterB > player.base_info.level:
            return {'state': 1, 'jindu': act_info[1]}

        if len(act_conf.parameterC) == 1 and \
                act_conf.parameterC[0] > player.line_up_component.hight_power:
            return {'state': 1, 'jindu': act_info[1]}

        if len(act_item.parameterD) == 1 and \
           player.stage_component.get_stage(act_item.parameterD[0]).state != 1:
            return {'state': 1, 'jindu': act_info[1]}

        player.act.act_infos[act_id][0] = 2
        return {'state': 2, 'jindu': act_info[1]}
    elif act_conf.type == 50:
        if not act_info:
            return {'state': 0}
        return {'state': 1, 'jindu': act_info[1]}

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

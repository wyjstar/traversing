# -*- coding:utf-8 -*-
"""
created by.
"""
from gfirefly.server.globalobject import remoteserviceHandle
from app.proto_file import start_target_pb2
from shared.db_opear.configs_data import game_configs
from gfirefly.server.logobj import logger
from app.game.core.item_group_helper import gain, get_return
from shared.utils.const import const
import time


@remoteserviceHandle('gate')
def get_target_info_1826(data, player):
    """获取任务信息"""
    args = start_target_pb2.GetStartTargetInfoRequest()
    args.ParseFromString(data)
    # day = args.day  # 0为所有
    response = start_target_pb2.GetStartTargetInfoResponse()

    # 第几天登录
    is_open, day = player.start_target.is_open()
    if not is_open:
        response.res.result = False
        logger.error("start target dont open")
        response.res.result_no = 890  # 不在活动时间内
        return response.SerializeToString()

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
            info = get_target_info(player, target_id, day)
            target_info_pro = response.start_target_info.add()
            target_info_pro.target_id = target_id
            if info.get('jindu'):
                target_info_pro.jindu = info.get('jindu')
            if info.get('state'):
                target_info_pro.state = info.get('state')

    player.start_target.save_data()

    response.res.result = True
    return response.SerializeToString()


def get_target_info(player, target_id, day):
    if player.start_target.is_underway():
        info = get_target_info1(player, target_id, day)
        if info.get('jindu'):
            a = info.get('jindu')
            info['jindu'] = int(a)
    else:
        target_info = player.start_target.target_info.get(target_id)
        info = {'state': target_info[0]}
        if len(target_info) == 2:
            info['jindu'] = int(target_info[1])
    return info


def get_target_info1(player, target_id, day):
    target_info = player.start_target.target_info.get(target_id)
    target_conf = game_configs.activity_config.get(target_id)
    conditions = player.start_target.conditions
    if target_info and target_info[0] == 3:
        return {'state': 3}
    elif target_info and target_info[0] == 2:
        return {'state': 2}

    elif target_conf.type == 29:
        # jindu = get_condition(conditions, 29)
        # if jindu and jindu[int(target_conf.parameterA)-1]:
        if day >= target_conf.parameterA:
            return {'state': 2}
        else:
            return {'state': 1}
    elif target_conf.type == 30:
        if not target_info:
            player.start_target.target_info[target_id] = [1, 0]
            return {'state': 2, 'jindu': 0}
        else:
            return {'state': target_info[0], 'jindu': target_info[1]}
    elif target_conf.type == 31:
        if target_info and target_info[0] == 2:
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
                if hero_obj.level >= target_conf.parameterA:
                    jindu += 1
            if jindu >= target_conf.parameterB:
                state = 2
        if state == 2:
            player.start_target.target_info[target_id] = \
                [2, target_conf.parameterB]
        else:
            if jindu and target_info and target_info[0] < jindu:
                player.start_target.target_info[target_id] = [1, jindu]
        return {'state': state, 'jindu': jindu}
    elif target_conf.type == 32:
        state = 1
        jindu = 0
        # 拥有3名突破1的武将
        line_up_slots = player.line_up_component.line_up_slots
        for slot in line_up_slots.values():
            if not slot.activation:  # 如果卡牌位未激活
                continue
            hero_obj = slot.hero_slot.hero_obj  # 英雄实例
            if hero_obj:
                if hero_obj.break_level >= target_conf.parameterA:
                    jindu += 1
            if jindu >= target_conf.parameterB:
                state = 2
        if state == 2:
            player.start_target.target_info[target_id] = \
                [2, target_conf.parameterB]
        else:
            if jindu and target_info and target_info[0] < jindu:
                player.start_target.target_info[target_id] = [1, jindu]
        return {'state': state, 'jindu': jindu}
    elif target_conf.type == 33:
        # 竞技场排名到1500名
        jindu = player.pvp.pvp_high_rank
        if jindu <= target_conf.parameterA:
            state = 2
            player.start_target.target_info[target_id] = [2, jindu]
            return {'state': 2, 'jindu': target_conf.parameterA}
        else:
            if not target_info or jindu < target_info[1]:
                player.start_target.target_info[target_id] = [1, jindu]
                return {'state': 1, 'jindu': jindu}
            else:
                return {'state': 1, 'jindu': target_info[1]}
    elif target_conf.type == 34:
        state = 1
        jindu = 0
        # 每个上阵武将经脉激活3个穴位
        line_up_slots = player.line_up_component.line_up_slots
        for slot in line_up_slots.values():
            if not slot.activation:  # 如果卡牌位未激活
                continue
            hero_obj = slot.hero_slot.hero_obj  # 英雄实例
            if hero_obj:
                if hero_obj.refine >= target_conf.parameterA:
                    jindu += 1

        if jindu >= target_conf.parameterB:
            state = 2

        if state == 2:
            player.start_target.target_info[target_id] = \
                [2, target_conf.parameterB]
        else:
            if jindu and target_info and target_info[0] < jindu:
                player.start_target.target_info[target_id] = [1, jindu]
        return {'state': state, 'jindu': jindu}
    elif target_conf.type == 35:
        # 过关斩将通关第十关
        jindu = player.pvp.pvp_overcome_current - 1
        if jindu >= target_conf.parameterA:
            player.start_target.target_info[target_id] = [2, jindu]
            return {'state': 2, 'jindu': target_conf.parameterA}
        else:
            if not target_info or jindu > target_info[1]:
                player.start_target.target_info[target_id] = [1, jindu]
                return {'state': 1, 'jindu': jindu}
            else:
                return {'state': 1, 'jindu': target_info[1]}
    elif target_conf.type == 36:
        equipments = player.equipment_component.get_all()
        jindu = 0
        for equipment in equipments:
            if equipment.attribute.strengthen_lv >= target_conf.parameterA:
                jindu += 1

        if jindu >= target_conf.parameterB:
            player.start_target.target_info[target_id] = [2, jindu]
            return {'state': 2, 'jindu': target_conf.parameterB}
        else:
            if not target_info or jindu > target_info[1]:
                player.start_target.target_info[target_id] = [1, jindu]
                return {'state': 1, 'jindu': jindu}
            else:
                return {'state': 1, 'jindu': target_info[1]}
    elif target_conf.type == 37:
        # 武将觉醒等级
        jindu = 0
        line_up_slots = player.line_up_component.line_up_slots
        for slot in line_up_slots.values():
            if not slot.activation:  # 如果卡牌位未激活
                continue
            hero_obj = slot.hero_slot.hero_obj  # 英雄实例
            if hero_obj:
                if hero_obj.break_level >= target_conf.parameterA:
                    jindu += 1

        if jindu >= target_conf.parameterB:
            player.start_target.target_info[target_id] = [2, jindu]
            return {'state': 2, 'jindu': target_conf.parameterB}
        else:
            if not target_info or jindu > target_info[1]:
                player.start_target.target_info[target_id] = [1, jindu]
                return {'state': 1, 'jindu': jindu}
            else:
                return {'state': 1, 'jindu': target_info[1]}
    elif target_conf.type == 38:
        #  黄巾起义 累积伤害
        jindu = get_condition(conditions, 38)
    elif target_conf.type == 39:
        #  黄巾起义 最高伤害
        jindu = get_condition(conditions, 39)
    elif target_conf.type == 40:
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
                        if quality == target_conf.parameterB:
                            jindu += 1

        if jindu >= target_conf.parameterA:
            player.start_target.target_info[target_id] = [2, jindu]
            return {'state': 2, 'jindu': target_conf.parameterA}
        else:
            if not target_info or jindu > target_info[1]:
                player.start_target.target_info[target_id] = [1, jindu]
                return {'state': 1, 'jindu': jindu}
            else:
                return {'state': 1, 'jindu': target_info[1]}
    elif target_conf.type == 41:
        # 占领矿达到a个
        jindu = get_condition(conditions, 41)
    elif target_conf.type == 42:
        # 夺宝合成数量达到a个
        jindu = 1
    elif target_conf.type == 45:
        if player.stage_component.get_stage(target_conf.parameterA).state != 1:
            return {'state': 1}
        else:
            return {'state': 2}
    elif target_conf.type == 44:
        jindu = get_condition(conditions, 44)
    elif target_conf.type == 43:
        # 战队等级 达到a
        jindu = player.base_info.level
    elif target_conf.type == 46:
        # 战斗力达到a
        jindu = player.line_up_component.hight_power

    # 到到a的统一在这里返回
    if jindu >= target_conf.parameterA:
        player.start_target.target_info[target_id] = [2, jindu]
        return {'state': 2, 'jindu': target_conf.parameterA}
    else:
        if not target_info or jindu > target_info[1]:
            player.start_target.target_info[target_id] = [1, jindu]
            return {'state': 1, 'jindu': jindu}
        else:
            return {'state': 1, 'jindu': target_info[1]}


def get_condition(conditions, type):
    condition = conditions.get(type)
    if condition:
        return condition
    else:
        return 0


@remoteserviceHandle('gate')
def get_target_info_1827(data, player):
    """获取任务奖励"""
    args = start_target_pb2.GetStartTargetRewardRequest()
    args.ParseFromString(data)
    target_id = args.target_id
    response = start_target_pb2.GetStartTargetRewardResponse()

    # 第几天登录
    is_open, day = player.start_target.is_open()
    if not is_open:
        response.res.result = False
        logger.error("start target dont open")
        response.res.result_no = 890  # 不在活动时间内
        return response.SerializeToString()

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

    target_info = player.start_target.target_info.get(target_id)
    target_conf = game_configs.activity_config.get(target_id)

    info = get_target_info(player, target_id, day)
    if target_conf.type != 30 and info.get('state') != 2:
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
                player.start_target.target_info[target_id] = [3, 0]
            else:
                player.start_target.target_info[target_id] = [1, info.get('jindu') + 1]
        else:
            player.start_target.target_info[target_id] = [3, 0]

    player.pay.pay(need_gold, const.START_TARGET, func)
    player.start_target.save_data()

    response.res.result = True
    return response.SerializeToString()

# -*- coding:utf-8 -*-
"""
created by server on 14-7-17上午11:07.
"""
from shared.db_opear.configs_data import game_configs
from app.proto_file import task_pb2
from gfirefly.server.globalobject import GlobalObject


remote_gate = GlobalObject().remote.get('gate')


def task_status(player, tid, response):
    unlock_conf = game_configs.achievement_config.get('unlock')
    task_res = response.tasks.add()
    task_conf = game_configs.achievement_config.get('tasks').get(tid)
    while True:
        task_res.tid = tid
        state = player.task.tasks.get(tid)
        next_task = unlock_conf.get(tid)
        if next_task and state and state == 3:  # 有后续，已领取
            tid = next_task
            task_conf = game_configs.achievement_config.get('tasks').get(tid)
        else:
            if not next_task and state and state == 2:  # 无后续，已完成未领取
                task_res.status = 2
                break
            elif not next_task and state and state == 3:  # 无后续，已领取
                task_res.status = 3
                break
            # 无后续 或 无任务记录 或 未完成
            res = get_condition_info(player, task_conf)
            if res.get('state'):
                player.task.tasks[tid] = 2
                task_res.status = 2
                break
            else:
                condition_info = res.get('condition_info')
                # task_res.status = res.get('state')
                task_res.status = 1
                for x in condition_info:
                    condition_res = task_res.condition.add()
                    condition_res.condition_no = x[0]
                    condition_res.state = x[1]
                    condition_res.current = int(x[2])
                break


def get_condition_info(player, task_conf):
    composition = task_conf.composition
    condition_info = []  # [[no, state, value]]
    task_type = task_conf.type
    for condition_no, condition_conf in task_conf.condition.items():
        res = check_condition(player, condition_conf, task_type)
        condition_info.append([condition_no, res['state'], res['value']])

    if composition == 1:  # 且
        state = 1
        for x in condition_info:
            if x[1]:
                continue
            state = 0
            break
    else:
        state = 0
        for x in condition_info:
            if not x[1]:
                continue
            state = 1
            break
    return {'state': state, 'condition_info': condition_info}


class CONDITIONId:
    STAGE = 1
    LEVEL = 2
    ADD_FRIEND = 3
    ANY_STAGE = 4
    ANY_ELITE_STAGE = 5
    GREEN_HERO = 6
    BLUE_HERO = 7
    STAR6_HERO = 8
    GREEN_EQU = 9
    BLUE_EQU = 10
    STAR6_EQU = 11
    PALD_ITEM = 12
    PVP_RANk_TIMES = 13
    USE_FRIEND = 14
    SEND_STAMINA = 15
    RECEIVE_STAMINA = 16
    JOIN_GUILD = 17
    ANY_ACT_STAGE = 18
    BREW = 19
    MINE_EXPLORE = 20
    GAIN_RUNT = 21
    TRAVEL = 22
    PVBOSS_TIMES = 23
    LIVELY = 24
    PVP_RANK = 25
    PVBOSS = 26
    HJQY = 27  # 南蛮入侵次数
    GGZJ = 28  # 过关斩将通关令个数
    HERO_GET = 29
    FIGHT_POWER = 30
    VIP_LEVEL = 31
    HERO_GET_LIANG = 32
    SHARE = 33
    PROTECT_ESCORT = 34
    ROB_ESCORT = 35
    GUILD_BOSS = 36
    PURPLE_HERO = 38


def update_condition_add(player, cid, num):
    if player.task.conditions.get(cid):
        player.task.conditions[cid] += num
    else:
        player.task.conditions[cid] = num

    if player.task.conditions_day.get(cid):
        player.task.conditions_day[cid] += num
    else:
        player.task.conditions_day[cid] = num
    player.task.save_data()


def update_condition_cover_rank(player, cid, num):
    condition = 0
    condition_day = 0
    if player.task.conditions.get(cid):
        condition = player.task.conditions.get(cid)
    if player.task.conditions_day.get(cid):
        condition_day = player.task.conditions_day.get(cid)
    if num < condition or condition == 0:
        player.task.conditions[cid] = num
    if num < condition_day or condition_day == 0:
        player.task.conditions_day[cid] = num
    player.task.save_data()


def update_condition_cover(player, cid, num):
    condition = 0
    condition_day = 0
    if player.task.conditions.get(cid):
        condition = player.task.conditions.get(cid)
    if player.task.conditions_day.get(cid):
        condition_day = player.task.conditions_day.get(cid)
    if num > condition:
        player.task.conditions[cid] = num
    if num > condition_day:
        player.task.conditions_day[cid] = num
    player.task.save_data()


def update_condition_insert(player, cid, num):
    if player.task.conditions.get(cid):
        if num not in player.task.conditions.get(cid):
            player.task.conditions[cid].append(num)
    else:
        player.task.conditions[cid] = [num]
    if player.task.conditions_day.get(cid):
        if num not in player.task.conditions_day.get(cid):
            player.task.conditions_day[cid].append(num)
    else:
        player.task.conditions_day[cid] = [num]
    player.task.save_data()


# UPDATE_CONDITION_MAP = {}
# UPDATE_CONDITION_MAP[1] = update_condition1
UPDATE_CONDITION_ADD = [3, 4, 5, 12, 13, 14, 15, 16,
                        18, 19, 20, 21, 22, 23, 24, 27, 28, 29, 32, 34,
                        35, 36]  # 增加
UPDATE_CONDITION_COVER = [6, 7, 8, 9, 10, 11, 17, 38]  # 如果比原来值大覆盖
UPDATE_CONDITION_COVER_RANK = [25, 26]  # 如果比原来值小覆盖
UPDATE_CONDITION_INSERT = [33]  # 插入列表


def update_condition(player, cid, num):
    if cid in UPDATE_CONDITION_ADD:
        update_condition_add(player, cid, num)
    elif cid in UPDATE_CONDITION_COVER:
        update_condition_cover(player, cid, num)
    elif cid in UPDATE_CONDITION_COVER_RANK:
        update_condition_cover_rank(player, cid, num)


# ==============
# from app.game.core.task import hook_task, CONDITIONId
# hook(player, cid, num)


def hook_task(player, cid, num, is_lively=False, proto_data=''):
    #import traceback
    #traceback.print_stack()

    player.task.update()

    conf_tids = game_configs.achievement_config.get('conditions').get(cid)
    if not conf_tids:
        conf_tids = []
    tids = []
    lively = 0
    if not is_lively:
        proto_data = task_pb2.FulfilTask()
    for tid in conf_tids:
        state = player.task.tasks.get(tid)
        if not state:
            state = 1
        task_conf = game_configs.achievement_config.get('tasks').get(tid)
        if task_conf.unlock and player.task.tasks.get(task_conf.unlock) != 3:
            continue
        if state and state == 2:
            continue
        if state and state == 3:
            continue
        flag = 0
        if cid == 1:
            for _, v in task_conf.condition.items():
                if num == v[1]:
                    flag = 1
                    # break
        else:
            flag = 1
        if flag:
            tids.append(tid)
    update_condition(player, cid, num)
    if cid == 33:
        return
    if not tids:
        return
    for tid in tids:
        share_cids = game_configs.achievement_config.get('conditions').get(33)
        task_conf = game_configs.achievement_config.get('tasks').get(tid)
        res = get_condition_info(player, task_conf)
        if not res['state'] and tid not in share_cids:
            continue
        if task_conf.sort == 2 and res['state']:
            lively += task_conf.reward[0].num
            player.task.tasks[tid] = 3
        if res['state']:
            proto_data.tid.append(tid)
        else:  # 未完成的分享类
            condition_info = res.get('condition_info')
            state = 1
            for x in condition_info:
                if x[1] or task_conf.condition.get(x[0])[0] == 33:
                    continue
                state = 0
            if state:
                proto_data.tid.append(tid)
    if lively and not is_lively:
        hook_task(player, 24, lively, is_lively=True, proto_data=proto_data)
    elif remote_gate and remote_gate.is_connected():
        remote_gate.push_object_remote(1824,
                                       proto_data.SerializeToString(),
                                       [player.dynamic_id])
    player.task.save_data()


# ==============


def check_condition1(player, condition_conf, task_type):
    if player.stage_component. \
            star_num[condition_conf[2]] >= condition_conf[3]:
                return {'state': 1, 'value': 0}
    return {'state': 0, 'value': 0}


def check_condition37(player, condition_conf, task_type):
    if player.stage_component. \
            get_stage(condition_conf[1]).state == 1:
                return {'state': 1, 'value': 0}
    return {'state': 0, 'value': 0}


def check_condition2(player, condition_conf, task_type):
    if player.base_info.level >= condition_conf[1]:
        return {'state': 1, 'value': 0}
    return {'state': 0, 'value': 0}


def check_condition30(player, condition_conf, task_type):
    if player.line_up_component.combat_power >= condition_conf[1]:
        return {'state': 1, 'value': 0}
    return {'state': 0, 'value': 0}


def check_condition31(player, condition_conf, task_type):
    if player.base_info.vip_level >= condition_conf[1]:
        return {'state': 1, 'value': 0}
    return {'state': 0, 'value': 0}


def check_condition33(player, condition_conf, task_type):
    value = get_condition_value(player, condition_conf, task_type)
    if value and condition_conf[1] in value:
        return {'state': 1, 'value': 0}
    return {'state': 0, 'value': 0}


def check_condition_const(player, condition_conf, task_type):
    value = get_condition_value(player, condition_conf, task_type)
    state = 0
    print task_type, '==========================aaa', condition_conf
    if value >= condition_conf[1]:
        state = 1
    return {'state': state, 'value': value}


def check_condition_rank(player, condition_conf, task_type):
    value = get_condition_value(player, condition_conf, task_type)
    state = 0
    if value <= condition_conf[1] and value:
        state = 1
    return {'state': state, 'value': value}


def get_condition_value(player, condition_conf, task_type):
    condition_id = condition_conf[0]
    value = 0
    if task_type == 1:  # 单次
        value = 0
        if player.task.conditions.get(condition_id):
            value = player.task.conditions.get(condition_id)
    else:  # 2 每日
        value = 0
        if player.task.conditions_day.get(condition_id):
            value = player.task.conditions_day.get(condition_id)
    return value


CHECK_CONDITION_MAP = {}
CHECK_CONDITION_MAP[1] = check_condition1
CHECK_CONDITION_MAP[2] = check_condition2
# CHECK_CONDITION_MAP[5] = check_condition5
# CHECK_CONDITION_MAP[18] = check_condition18
CHECK_CONDITION_MAP[30] = check_condition30
CHECK_CONDITION_MAP[31] = check_condition31
CHECK_CONDITION_MAP[33] = check_condition33
CHECK_CONDITION_MAP[37] = check_condition37
CHEAK_CONDITION_CONST = [3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17,
                         18, 19, 20, 21, 22, 23, 24, 27, 28, 29, 30, 32,
                         34, 35, 36, 38]
CHEAK_CONDITION_RANK = [25, 26]


def check_condition(player, condition_conf, task_type):

    player.task.update()

    cid = condition_conf[0]
    if cid in CHECK_CONDITION_MAP:
        fun = CHECK_CONDITION_MAP[cid]
        return fun(player, condition_conf, task_type)
    elif cid in CHEAK_CONDITION_CONST:
        return check_condition_const(player, condition_conf, task_type)
    elif cid in CHEAK_CONDITION_RANK:
        return check_condition_rank(player, condition_conf, task_type)
    else:
        return {'state': 1, 'value': 1}

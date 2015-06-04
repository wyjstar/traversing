# -*- coding:utf-8 -*-
"""
created by server on 14-7-17上午11:07.
"""
from shared.db_opear.configs_data import game_configs
import time


def task_status(player, tid, response):
    unlock_conf = game_configs.achievement_config.get('unlock')
    task_res = response.tasks.add()
    task_res.tid = tid
    task_conf = game_configs.achievement_config.get('tasks').get(tid)
    print 'AAAAAAAAAAAAAAAAAAA', tid, task_conf
    while True:
        state = player.task.tasks.get(tid)
        next_task = unlock_conf.get(tid)
        # TODO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if next_task and state and state == 3:  # 有后续，已领取
            tid = next_task
            continue
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
                    condition_res.current = x[2]
                break


def get_condition_info(player, task_conf):
    composition = task_conf.composition
    condition_info = []  # [[no, state, value]]
    task_type = task_conf.type
    for condition_no, condition_conf in task_conf.condition.items():
        # condition_conf [condition_id, v, v]
        condition_id = condition_conf[0]
        state = 0

        if condition_id == 1:
            if player.stage_component. \
                    get_stage(condition_conf[1]).state == 1:
                state = 1
            value = 0
        elif condition_id == 24:  # 活跃度
            value = player.task.lively
        else:
            if task_type == 1:  # 单次
                value = 0
                if player.task.conditions.get(condition_id):
                    value = player.task.conditions.get(condition_id)
            else:  # 2 每日
                value = 0
                if player.task.conditions_day.get(condition_id):
                    value = player.task.conditions.get(condition_id)
            if value >= condition_conf[1]:
                state = 1
        condition_info.append([condition_no, state, value])
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
    PVBOSS = 23
    LIVELY = 24
    PVP_RANK = 25
    PVBOSS = 26
    NMRQ = 27
    GGZJ = 28
    HERO_GET = 29
    FIGHT_POWER = 30
    VIP_LEVEL = 31
    SHARE = 32


def update_condition1(player):
    pass


def update_condition2(player):
    pass


def update_condition_default(player, cid, num, isadd=False):
    if cid in []:
        return
    if isadd:
        player.task.conditions[cid] += num
    player.task.conditions[cid] = num
    player.task.save_data()


UPDATE_CONDITION_MAP = {}
UPDATE_CONDITION_MAP[1] = update_condition1
UPDATE_CONDITION_MAP[2] = update_condition2


def update_condition(player, cid, *args, **kw):
    if cid in UPDATE_CONDITION_MAP:
        fun = UPDATE_CONDITION_MAP[cid]
        fun(player, *arg, **kw)
    else:
        update_condition_default(player, cid, *arg, **kw)

    # check()

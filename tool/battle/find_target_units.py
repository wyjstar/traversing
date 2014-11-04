#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
通过技能的作用位置，找到作用对象。
"""

import random

def single_attack(value, attacker, target_units):
    attack_orders = {1:[1,2,3,4,5,6],
            2: [2,3,1,5,6,4],
            3: [3,1,2,6,5,6],
            4: [1,2,3,4,5,6],
            5: [2,3,1,5,6,4],
            6: [3,1,2,6,4,5]}
    order = attack_orders.get(attacker.slot_no)
    target_keys = target_units.keys()
    for i in order:
        unit_i = target_units.get(i)
        if i in target_keys:
            return [unit_i]
    return []

def all_attack(value, attacker, target_units):
    return target_units.values()

def front_attack(value, attacker, target_units):
    front_units = []
    target_keys = target_units.keys()

    for i in [1,2,3]:
        unit_i = target_units.get(i)
        if i in target_keys:
            return front_units.append(unit_i)
    if len(front_units) == 0:
        return target_units.values()

def back_attack(value, attacker, target_units):
    back_units = []
    target_keys = target_units.keys()

    for i in [4,5,6]:
        unit_i = target_units.get(i)
        if i in target_keys:
            return back_units.append(unit_i)

    if len(back_units) == 0:
        return target_units.values()

def vertical_attack(value, attacker, target_units):
    attack_orders = {1:[(1,4), (2,5), (3,6)],
            4: [(1,4), (2,5), (3,6)],
            2: [(2,5), (3,6), (1,4)],
            5: [(2,5), (3,6), (1,4)],
            3: [(3,6), (1,4), (2,5)],
            6: [(3,6), (1,4), (2,5)],
            }
    vertical_units = []
    order = attack_orders.get(attacker.slot_no)
    target_keys = target_units.keys()
    for i, j in order:
        if i in order:
            vertical_units.append(target_units.get(i))
        if j in target_keys:
            vertical_units.append(target_units.get(j))
        if len(vertical_units) == 0:
            continue
        else:
            return vertical_units
    return vertical_units

def random_attack(value, attacker, target_units):
    target_nos = get_random_lst(target_units.keys(), value)
    random_units = []
    for no in target_nos:
        random_units.append(target_units.get(no))
    return random_units

def get_random_lst(population, no):
    return random.sample(population, no)

def get_random_int(start, end):
    return random.randint(start, end)


def hp_max_attack(value, attacker, target_units):
    target_units_lst = target_units.values()
    target_units_lst = sorted(target_units_lst, key=lambda unit: unit.hp_percent, reverse=True)
    hp_units = []

    for i in range(len(target_units)):
        unit = target_units_lst[i]
        if bool(unit):
            hp_units.append(unit)
        if len(hp_units) == value:
            return hp_units
    return hp_units

def hp_min_attack(value, attacker, target_units):
    target_units_lst = target_units.values()
    target_units_lst = sorted(target_units_lst, key=lambda unit: unit.hp_percent)
    hp_units = []

    for i in range(len(target_units)):
        unit = target_units_lst[i]
        if bool(unit):
            hp_units.append(unit)
        if len(hp_units) == value:
            return hp_units
    return hp_units


def mp_max_attack(value, attacker, target_units):
    target_units_lst = target_units.values()
    target_units_lst = sorted(target_units_lst, key=lambda unit: unit.mp, reverse=True)
    mp_units = []

    for i in range(len(target_units)):
        unit = target_units_lst[i]
        if bool(unit):
            mp_units.append(unit)
        if len(mp_units) == value:
            return mp_units
    return mp_units


def mp_min_attack(value, attacker, target_units):
    target_units_lst = target_units.values()
    target_units_lst = sorted(target_units_lst, key=lambda unit: unit.mp)
    mp_units = []

    for i in range(len(target_units)):
        unit = target_units_lst[i]
        if bool(unit):
            mp_units.append(unit)
        if len(mp_units) == value:
            return mp_units
    return mp_units

def self_attack(value, attacker, target_units):
    print attacker, "attacker"
    return [attacker]


target_types = {
        1: single_attack,      # 单体攻击
        2: all_attack,         # 全体攻击
        3: front_attack,       # 前排攻击
        4: back_attack,        # 后排攻击
        5: vertical_attack,    # 竖排攻击
        6: random_attack,      # 随机攻击
        7: hp_max_attack,      # 血量百分比最大攻击
        8: hp_min_attack,      # 血量百分比最小攻击
        9: mp_max_attack,      # 怒气最大攻击
        10: mp_min_attack,     # 怒气最小攻击
        11: self_attack}       # 自己

def find_target_units(attacker, army, enemy, skill_buff_info, main_target_units, target=None):
    """
    根据作用位置找到作用武将。
    """
    target_pos = skill_buff_info.effectPos
    key, value = target_pos.items()[0]

    key = int(key)
    if key == 13: # 反击，作特殊处理
        return [target]

    elif key == 12: # 没有自己的作用位置，做特殊处理
        return main_target_units

    func = target_types.get(key)

    target_units = find_side(skill_buff_info, army, enemy)
    result = func(value, attacker, target_units)
    return result

def find_side(skill_buff_info, army, enemy):
    target_role = skill_buff_info.effectRole
    if target_role == 1: # enemy
        return enemy
    else: # army
        return army











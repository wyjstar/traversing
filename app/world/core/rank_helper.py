# -*- coding:utf-8 -*-
from shared.utils.const import const


def add_level_rank_info(instance, users, tb_character_info):
    for uid in users:
        character_obj = tb_character_info.getObj(uid)
        character_info = character_obj.hmget(['level', 'attackPoint'])
        if character_info['attackPoint']:
            rank_value = int(character_info['attackPoint'])
        else:
            rank_value = 0
        value = character_info['level'] * const.level_rank_xs + rank_value
        instance.add(uid, value)  # 添加rank数据
        # print 'level', value, rank_value, character_info['level'], uid


def add_power_rank_info(instance, users, tb_character_info):
    for uid in users:
        character_obj = tb_character_info.getObj(uid)
        character_info = character_obj.hmget(['level', 'attackPoint'])
        if character_info['attackPoint']:
            rank_value = int(character_info['attackPoint'])
        else:
            rank_value = 0
        value = rank_value * const.power_rank_xs + character_info['level']
        instance.add(uid, value)  # 添加rank数据
        # print 'power', value, rank_value, character_info['level'], uid


def add_star_rank_info(instance, users, tb_character_info):
    for uid in users:
        character_obj = tb_character_info.getObj(uid)
        character_info = character_obj.hmget(['level', 'stage_progress',
                                              'star_num'])
        star_num_list = character_info['star_num']
        star_num = 0
        for x in star_num_list:
            star_num += x

        value = star_num * const.power_rank_xs + character_info['level']
        instance.add(uid, value)  # 添加rank数据
        data = {'rank_stage_progress': character_info['stage_progress']}
        character_obj.hmset(data)
        # print 'star', value, star_num, character_info['level'], uid

# -*- coding:utf-8 -*-
"""
created by K.
"""
from gfirefly.server.globalobject import remoteserviceHandle
from app.game.redis_mode import tb_character_info
# from gfirefly.server.logobj import logger
from app.proto_file import rank_pb2
from shared.utils.const import const
from app.proto_file.db_pb2 import Heads_DB
from app.game.core import rank_helper


@remoteserviceHandle('gate')
def get_rank_info_1805(data, player):
    """查看排行信息 """
    args = rank_pb2.GetRankRequest()
    args.ParseFromString(data)
    first_no = args.first_no
    last_no = args.last_no
    rank_type = args.rank_type

    response = rank_pb2.GetRankResponse()

    mid = player.base_info.id
    if rank_type == 3:
        get_level_rank(first_no, last_no, player, response)
    elif rank_type == 1:
        get_power_rank(first_no, last_no, player, response)
    elif rank_type == 2:
        get_star_rank(first_no, last_no, player, response)
    else:
        response.res.result = False
        response.res.result_no = 838

    return response.SerializeToString()


def get_level_rank(first_no, last_no, player, response):
    rank_name, last_rank_name = rank_helper.get_level_rank_name()

    rank_num = first_no
    rank_info = rank_helper.get_rank(rank_name, first_no, last_no)
    for (pid, rankinfo) in rank_info:
        res_user_info = response.user_info.add()
        res_user_info.id = int(pid)
        res_user_info.level = int(rankinfo)/const.level_rank_xs
        res_user_info.fight_power = int(rankinfo) % const.level_rank_xs
        res_user_info.rank = rank_num

        character_obj = tb_character_info.getObj(pid)
        character_info = character_obj.hmget(['nickname', 'heads'])
        res_user_info.nickname = character_info['nickname']

        heads = Heads_DB()
        heads.ParseFromString(character_info['heads'])
        res_user_info.user_icon = heads.now_head
        rank_num += 1

    if first_no == 1:
        rank_no = rank_helper.get_rank_by_key(rank_name,
                                              player.base_info.id)
        if rank_no:
            [(_id, rankinfo)] = rank_helper.get_rank(
                rank_name, rank_no, rank_no)
            res_my_rank_info = response.my_rank_info
            res_my_rank_info.rank = rank_no
            res_my_rank_info.level = int(rankinfo/const.level_rank_xs)
            res_my_rank_info.fight_power = int(
                rankinfo % const.level_rank_xs)

            last_rank_no = rank_helper.get_rank_by_key(
                last_rank_name, player.base_info.id)
            if last_rank_no:
                res_my_rank_info.last_rank = last_rank_no
        # 前100名有多少人
        ranks = rank_helper.get_rank(rank_name, 1, 99999)
        response.all_num = len(ranks)
    response.res.result = True


def get_power_rank(first_no, last_no, player, response):
    rank_name, last_rank_name = rank_helper.get_power_rank_name()
    rank_num = first_no
    rank_info = rank_helper.get_rank(rank_name, first_no, last_no)
    for (pid, rankinfo) in rank_info:
        res_user_info = response.user_info.add()
        res_user_info.id = int(pid)
        res_user_info.fight_power = int(rankinfo)/const.power_rank_xs
        res_user_info.level = int(rankinfo) % const.power_rank_xs
        res_user_info.rank = rank_num

        character_obj = tb_character_info.getObj(pid)
        character_info = character_obj.hmget(['nickname', 'heads'])
        res_user_info.nickname = character_info['nickname']

        heads = Heads_DB()
        heads.ParseFromString(character_info['heads'])
        res_user_info.user_icon = heads.now_head
        rank_num += 1

    if first_no == 1:
        rank_no = rank_helper.get_rank_by_key(rank_name,
                                              player.base_info.id)
        if rank_no:
            [(_id, rankinfo)] = rank_helper.get_rank(rank_name,
                                                     rank_no, rank_no)
            res_my_rank_info = response.my_rank_info
            res_my_rank_info.rank = rank_no
            res_my_rank_info.fight_power = int(rankinfo/const.power_rank_xs)
            res_my_rank_info.level = int(rankinfo % const.power_rank_xs)

            last_rank_no = rank_helper.get_rank_by_key(
                last_rank_name, player.base_info.id)
            if last_rank_no:
                res_my_rank_info.last_rank = last_rank_no
        # 前100名有多少人
        ranks = rank_helper.get_rank(rank_name, 1, 99999)
        response.all_num = len(ranks)
    response.res.result = True


def get_star_rank(first_no, last_no, player, response):
    rank_name, last_rank_name = rank_helper.get_star_rank_name()

    rank_num = first_no
    rank_info = rank_helper.get_rank(rank_name, first_no, last_no)
    for (pid, rankinfo) in rank_info:
        res_user_info = response.user_info.add()
        res_user_info.id = int(pid)
        res_user_info.star_num = int(rankinfo)/const.power_rank_xs
        res_user_info.level = int(rankinfo) % const.power_rank_xs
        res_user_info.rank = rank_num

        character_obj = tb_character_info.getObj(pid)
        character_info = character_obj.hmget(['nickname', 'heads', 'rank_stage_progress'])
        res_user_info.nickname = character_info['nickname']
        res_user_info.stage_id = character_info['rank_stage_progress']

        heads = Heads_DB()
        heads.ParseFromString(character_info['heads'])
        res_user_info.user_icon = heads.now_head
        rank_num += 1

    if first_no == 1:
        rank_no = rank_helper.get_rank_by_key(rank_name,
                                              player.base_info.id)
        if rank_no:
            [(_id, rankinfo)] = rank_helper.get_rank(rank_name,
                                                     rank_no, rank_no)
            res_my_rank_info = response.my_rank_info
            res_my_rank_info.rank = rank_no
            res_my_rank_info.star_num = int(rankinfo/const.power_rank_xs)
            res_my_rank_info.level = int(rankinfo % const.power_rank_xs)
            res_my_rank_info.stage_id = player.stage_component.rank_stage_progress

            last_rank_no = rank_helper.get_rank_by_key(
                last_rank_name, player.base_info.id)
            if last_rank_no:
                res_my_rank_info.last_rank = last_rank_no
        # 前100名有多少人
        ranks = rank_helper.get_rank(rank_name, 1, 99999)
        response.all_num = len(ranks)
    response.res.result = True

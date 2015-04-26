# -*- coding:utf-8 -*-
"""
created by K.
"""
from gfirefly.server.globalobject import remoteserviceHandle
from gfirefly.server.globalobject import GlobalObject
from shared.db_opear.configs_data import game_configs
from app.game.redis_mode import tb_guild_info, tb_guild_name
from app.game.redis_mode import tb_character_info
from gfirefly.server.logobj import logger
from app.proto_file import rank_pb2
from shared.utils.const import const
import time


remote_gate = GlobalObject().remote['gate']


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
    if flag_doublu_day():
        rank_name = 'LevelRank2'
        last_rank_name = 'LevelRank1'
    else:
        rank_name = 'LevelRank1'
        last_rank_name = 'LevelRank2'

    ranks = remote_gate.get_rank_remote(rank_name, first_no, last_no)
    rank_num = first_no
    for pid, rankinfo in ranks.items():
        res_user_info = response.user_info.add()
        res_user_info.id = int(pid)
        res_user_info.level = int(rankinfo)/const.level_rank_xs
        res_user_info.fight_power = int(rankinfo) % const.level_rank_xs
        res_user_info.rank = rank_num

        character_obj = tb_character_info.getObj(pid)
        character_info = character_obj.hmget(['nickname'])
        res_user_info.nickname = character_info['nickname']
        rank_num += 1

    if first_no == 1:
        rank_no = remote_gate.get_rank_by_key_remote(rank_name, player.base_info.id)
        if rank_no:
            ranks = remote_gate.get_rank_remote(rank_name, rank_no, rank_no)
            res_my_rank_info = response.my_rank_info
            res_my_rank_info.rank = rank_no
            res_my_rank_info.level = int(ranks[str(player.base_info.id)]/const.level_rank_xs)
            res_my_rank_info.fight_power =\
                int(ranks[str(player.base_info.id)] % const.level_rank_xs)

            last_rank_no = remote_gate.get_rank_by_key_remote(last_rank_name, player.base_info.id)
            if last_rank_no:
                res_my_rank_info.last_rank = last_rank_no
        # 前100名有多少人
        ranks = remote_gate.get_rank_remote(rank_name, 1, 99999)
        response.all_num = len(ranks.items())
    response.res.result = True


def get_power_rank(first_no, last_no, player, response):
    if flag_doublu_day():
        rank_name = 'PowerRank2'
        last_rank_name = 'PowerRank1'
    else:
        rank_name = 'PowerRank1'
        last_rank_name = 'PowerRank2'
    ranks = remote_gate.get_rank_remote(rank_name, first_no, last_no)
    rank_num = first_no
    for pid, rankinfo in ranks.items():
        res_user_info = response.user_info.add()
        res_user_info.id = int(pid)
        res_user_info.fight_power = int(rankinfo)/const.power_rank_xs
        res_user_info.level = int(rankinfo) % const.power_rank_xs
        res_user_info.rank = rank_num

        character_obj = tb_character_info.getObj(pid)
        character_info = character_obj.hmget(['nickname'])
        res_user_info.nickname = character_info['nickname']
        rank_num += 1

    if first_no == 1:
        rank_no = remote_gate.get_rank_by_key_remote(rank_name, player.base_info.id)
        if rank_no:
            ranks = remote_gate.get_rank_remote(rank_name, rank_no, rank_no)
            res_my_rank_info = response.my_rank_info
            res_my_rank_info.rank = rank_no
            res_my_rank_info.fight_power = int(ranks[str(player.base_info.id)]/const.power_rank_xs)
            res_my_rank_info.level =\
                int(ranks[str(player.base_info.id)] % const.power_rank_xs)

            last_rank_no = remote_gate.get_rank_by_key_remote(last_rank_name, player.base_info.id)
            if last_rank_no:
                res_my_rank_info.last_rank = last_rank_no
        # 前100名有多少人
        ranks = remote_gate.get_rank_remote(rank_name, 1, 99999)
        response.all_num = len(ranks.items())
    response.res.result = True


def get_star_rank(first_no, last_no, player, response):
    if flag_doublu_day():
        rank_name = 'StarRank2'
        last_rank_name = 'StarRank1'
    else:
        rank_name = 'StarRank1'
        last_rank_name = 'StarRank2'


def flag_doublu_day():
    """
    return 0 or 1
    """
    now = int(time.time())
    t = time.localtime(now)
    time1 = time.mktime(time.strptime(time.strftime('%Y-%m-%d 00:00:00', t),
                        '%Y-%m-%d %H:%M:%S'))
    return int(time1/(24*60*60)) % 2

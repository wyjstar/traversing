# -*- coding:utf-8 -*-
"""
created by sphinx on 28/10/14.
"""
from app.game.logic.common.check import have_player
from app.proto_file import pvp_rank_pb2
from gfirefly.dbentrust import util
from gfirefly.server.logobj import logger

PVP_TABLE_NAME = 'tb_pvp_rank'


@have_player
def pvp_player_rank_request(dynamic_id, data, **kwargs):
    response = pvp_rank_pb2.PlayerRankResponse()

    util.GetOneRecordInfo()

    rank_item = response.rank_items.add()
    rank_item.level = 0
    rank_item.nickname = 0
    rank_item.rank = 0
    return response.SerializeToString()


@have_player
def pvp_player_rank_refresh_request(dynamic_id, data, player):
    response = pvp_rank_pb2.PlayerRankResponse()

    prere = dict(character_id=player.base_info.id)
    record = util.GetOneRecordInfo(PVP_TABLE_NAME, prere, ['id'])
    cur_rank = record.get('id')

    columns = ['id', 'nickname', 'level', 'ap']
    prere = 'id>=%s and id<=%s' % (cur_rank - 9, cur_rank + 1)
    records = util.GetSomeRecordInfo(PVP_TABLE_NAME, prere, columns)
    for record in records:
        rank_item = response.rank_items.add()
        rank_item.level = record.get('level')
        rank_item.nickname = record.get('nickname')
        rank_item.rank = record.get('id')
        rank_item.ap = record.get('ap')
    return response.SerializeToString()


@have_player
def pvp_top_rank_request(dynamic_id, data, **kwargs):
    response = pvp_rank_pb2.PlayerRankResponse()

    columns = ['id', 'nickname', 'level', 'ap']
    records = util.GetSomeRecordInfo(PVP_TABLE_NAME, 'id<=10', columns)
    for record in records:
        rank_item = response.rank_items.add()
        rank_item.level = record.get('level')
        rank_item.nickname = record.get('nickname')
        rank_item.rank = record.get('id')
        rank_item.ap = record.get('ap')
    return response.SerializeToString()


@have_player
def pvp_player_info_request(dynamic_id, data, player):
    request = pvp_rank_pb2.PvpPlayerInfoRequest()
    record = util.GetOneRecordInfo(PVP_TABLE_NAME, dict(id=request.player_rank), ['slots'])
    if record:
        return record.get('slots')
    else:
        logger.error('can not find player rank:', request.player_rank)
        return None


@have_player
def pvp_fight_request(dynamic_id, data, player):
def pvp_fight_request(dynamic_id, data, player):
    pass

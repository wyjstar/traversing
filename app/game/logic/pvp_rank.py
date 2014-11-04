# -*- coding:utf-8 -*-
"""
created by sphinx on 28/10/14.
"""
import cPickle
import random
from app.game.logic.common.check import have_player
from app.proto_file import pvp_rank_pb2
from gfirefly.dbentrust import util
from app.game.action.node.stage import assemble
from gfirefly.server.logobj import logger
from app.game.logic.line_up import line_up_info
from shared.db_opear.configs_data.game_configs import arena_fight_config

PVP_TABLE_NAME = 'tb_pvp_rank'


@have_player
def pvp_player_rank_request(dynamic_id, data, player):
    response = pvp_rank_pb2.PlayerRankResponse()

    prere = dict(character_id=player.base_info.id)
    record = util.GetOneRecordInfo(PVP_TABLE_NAME, prere, ['id'])

    if not record:
        return pvp_player_rank_refresh_request(dynamic_id, data)

    cur_rank = record.get('id')
    columns = ['id', 'nickname', 'level', 'ap', 'hero_ids']
    prere = 'id>=%s and id<=%s' % (cur_rank - 9, cur_rank + 1)
    records = util.GetSomeRecordInfo(PVP_TABLE_NAME, prere, columns)
    for record in records:
        rank_item = response.rank_items.add()
        rank_item.level = record.get('level')
        rank_item.nickname = record.get('nickname')
        rank_item.rank = record.get('id')
        rank_item.ap = record.get('ap')
        hero_ids = cPickle.loads(record.get('hero_ids'))
        rank_item.hero_ids.extend([_ for _ in hero_ids])
    return response.SerializeToString()


@have_player
def pvp_player_rank_refresh_request(dynamic_id, data, player):
    response = pvp_rank_pb2.PlayerRankResponse()

    prere = dict(character_id=player.base_info.id)
    record = util.GetOneRecordInfo(PVP_TABLE_NAME, prere, ['id'])
    if not record:
        cur_rank = 300
    else:
        cur_rank = record.get('id')

    ranks = []
    for v in arena_fight_config.values():
        play_rank = v.get('play_rank')
        if cur_rank in range(play_rank[0], play_rank[1] + 1):
            para = dict(k=cur_rank)
            choose_fields = eval(v.get('choose'), para)
            logger.info('cur:%s choose:%s', cur_rank, choose_fields)
            for x, y, c in choose_fields:
                for _ in range(c):
                    r = random.randint(int(x), int(y))
                    ranks.append(r)
            break

    if not ranks:
        raise Exception('rank field error!')

    caret = ','
    prere = 'id in (%s)' % caret.join(str(_) for _ in ranks)
    logger.info('prere:%s', prere)
    columns = ['id', 'nickname', 'level', 'ap', 'hero_ids']
    records = util.GetSomeRecordInfo(PVP_TABLE_NAME, prere, columns)
    for record in records:
        rank_item = response.rank_items.add()
        rank_item.level = record.get('level')
        rank_item.nickname = record.get('nickname')
        rank_item.rank = record.get('id')
        rank_item.ap = record.get('ap')
        hero_ids = cPickle.loads(record.get('hero_ids'))
        rank_item.hero_ids.extend([_ for _ in hero_ids])
    return response.SerializeToString()


@have_player
def pvp_top_rank_request(dynamic_id, data, **kwargs):
    response = pvp_rank_pb2.PlayerRankResponse()

    columns = ['id', 'nickname', 'level', 'ap', 'hero_ids']
    records = util.GetSomeRecordInfo(PVP_TABLE_NAME, 'id<=10', columns)
    for record in records:
        rank_item = response.rank_items.add()
        rank_item.level = record.get('level')
        rank_item.nickname = record.get('nickname')
        rank_item.rank = record.get('id')
        rank_item.ap = record.get('ap')
        hero_ids = cPickle.loads(record.get('hero_ids'))
        rank_item.hero_ids.extend([_ for _ in hero_ids])
    return response.SerializeToString()


@have_player
def pvp_player_info_request(dynamic_id, data, player):
    request = pvp_rank_pb2.PvpPlayerInfoRequest()
    request.ParseFromString(data)
    record = util.GetOneRecordInfo(PVP_TABLE_NAME,
                                   dict(id=request.player_rank),
                                   ['slots'])
    if record:
        response = record.get('slots')
        response = cPickle.loads(response)
        return response.SerializeToString()
    else:
        logger.error('can not find player rank:%s', request.player_rank)
        return None


@have_player
def pvp_fight_request(dynamic_id, data, player):
    prere = dict(character_id=player.base_info.id)
    record = util.GetOneRecordInfo(PVP_TABLE_NAME, prere, ['id'])
    before_player_rank = 0
    if record:
        before_player_rank = record.get('id')
        refresh_rank_data(player, player.base_info.id)

    request = pvp_rank_pb2.PvpFightRequest()
    request.ParseFromString(data)

    prere = dict(id=request.challenge_rank)
    record = util.GetOneRecordInfo(PVP_TABLE_NAME, prere, ['units'])
    blue_units = record.get('units')
    print "blue_units:", blue_units
    blue_units = cPickle.loads(blue_units)
    print "blue_units:", blue_units
    red_units = player.fight_cache_component.red_unit

    # todo check battle
    # if check_battle(red_units, blue_units)
    #   pass
    if random.randint(0, 1) == 1:
        if before_player_rank != 0:
            pass
            # last_player_rank = record.get('id')
        refresh_rank_data(player, request.challenge)
    else:
        pass

    response = pvp_rank_pb2.PvpFightResponse()
    response.res.result = True
    for red_unit in red_units:
        if not red_unit:
            continue
        red_add = response.red.add()
        assemble(red_add, red_unit)
    for blue_unit in blue_units:
        if not blue_unit:
            continue
        blue_add = response.blue.add()
        assemble(blue_add, blue_unit)
    return response.SerializeToString()


def refresh_rank_data(player, character_id):
    red_units = cPickle.dumps(player.fight_cache_component.red_unit)
    slots = cPickle.dumps(line_up_info(player))
    hero_nos = player.line_up_component.hero_nos
    rank_data = dict(hero_ids=cPickle.dumps(hero_nos),
                     level=player.level,
                     ap=player.line_up_component.combat_power,
                     units=red_units,
                     slots=slots)

    prere = dict(character_id=character_id)
    result = util.UpdateWithDict(PVP_TABLE_NAME, rank_data, prere)
    if not result:
        raise Exception('update pvp data fail!!')

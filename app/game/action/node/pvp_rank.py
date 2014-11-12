# -*- coding:utf-8 -*-
"""
created by sphinx on 27/10/14.
"""
import cPickle
import random
from app.proto_file import pvp_rank_pb2
from app.game.action.node.stage import assemble
from app.game.action.node.line_up import line_up_info
from gfirefly.dbentrust import util
from gfirefly.server.logobj import logger
from gfirefly.server.globalobject import remoteserviceHandle
from shared.db_opear.configs_data.game_configs import arena_fight_config
from app.battle.battle_process import BattlePVPProcess

PVP_TABLE_NAME = 'tb_pvp_rank'


@remoteserviceHandle('gate')
def pvp_top_rank_request_1501(data, player):
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


@remoteserviceHandle('gate')
def pvp_player_rank_request_1502(data, player):
    response = pvp_rank_pb2.PlayerRankResponse()

    prere = dict(character_id=player.base_info.id)
    record = util.GetOneRecordInfo(PVP_TABLE_NAME, prere, ['id'])

    if not record:
        return pvp_player_rank_refresh_request(data, player)

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


@remoteserviceHandle('gate')
def pvp_player_rank_refresh_request_1503(data, player):
    return pvp_player_rank_refresh_request(data, player)


@remoteserviceHandle('gate')
def pvp_player_info_request_1504(data, player):
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


@remoteserviceHandle('gate')
def pvp_fight_request_1505(data, player):
    request = pvp_rank_pb2.PvpFightRequest()
    request.ParseFromString(data)

    line_up = {}  # {hero_id:pos}
    for line in request.lineup:
        if not line.hero_id:
            continue
        line_up[line.hero_id] = line.pos

    player.line_up_component.line_up_order = line_up
    player.line_up_component.save_data()

    prere = dict(character_id=player.base_info.id)
    record = util.GetOneRecordInfo(PVP_TABLE_NAME, prere, ['id'])
    before_player_rank = 0
    if record:
        before_player_rank = record.get('id')
        refresh_rank_data(player, player.base_info.id)

    prere = dict(id=request.challenge_rank)
    record = util.GetOneRecordInfo(PVP_TABLE_NAME, prere, ['units', 'best_skill'])
    blue_units = record.get('units')
    # print "blue_units:", blue_units
    blue_units = cPickle.loads(blue_units)
    # print "blue_units:", blue_units
    red_units = player.fight_cache_component.red_unit


    process = BattlePVPProcess(red_units, request.skill, blue_units, record.get('best_skill', 0))
    fight_result = process.process()

    logger.debug("fight result:%s" % fight_result)

    # todo check battl
    # if check_battle(red_units, blue_units)
    #   pass
    if random.randint(0, 1) == 1:
        if before_player_rank != 0:
            pass
            # last_player_rank = record.get('id')
        # refresh_rank_data(player, request.challenge_rank)
    else:
        pass

    response = pvp_rank_pb2.PvpFightResponse()
    response.res.result = True
    for slot_no, red_unit in red_units.items():
        if not red_unit:
            continue
        red_add = response.red.add()
        assemble(red_add, red_unit)
    for slot_no, blue_unit in blue_units.items():
        if not blue_unit:
            continue
        blue_add = response.blue.add()
        assemble(blue_add, blue_unit)
    response.red_skill = request.skill
    print "*"*80
    return response.SerializeToString()


def pvp_player_rank_refresh_request(data, player):
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


def refresh_rank_data(player, character_id):
    red_units = cPickle.dumps(player.fight_cache_component.red_unit)
    slots = cPickle.dumps(line_up_info(player))
    hero_nos = player.line_up_component.hero_nos
    rank_data = dict(hero_ids=cPickle.dumps(hero_nos),
                     level=player.level.level,
                     ap=player.line_up_component.combat_power,
                     units=red_units,
                     slots=slots)

    prere = dict(character_id=character_id)
    result = util.UpdateWithDict(PVP_TABLE_NAME, rank_data, prere)
    if not result:
        raise Exception('update pvp fail!! character_id:%s' % character_id)

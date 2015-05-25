# -*- coding:utf-8 -*-
"""
created by sphinx on 27/10/14.
"""
import cPickle
import random
import time
from shared.utils.const import const
from app.game.core.item_group_helper import gain
from app.game.core.item_group_helper import get_return
# from shared.utils.const import const
from app.proto_file import pvp_rank_pb2
from app.game.action.node._fight_start_logic import assemble
from app.game.action.node.line_up import line_up_info
from gfirefly.dbentrust import util
from gfirefly.server.logobj import logger
from app.game.action.root.netforwarding import push_message
from gfirefly.server.globalobject import remoteserviceHandle
from shared.db_opear.configs_data import game_configs
from app.game.component.achievement.user_achievement import CountEvent
from app.game.component.achievement.user_achievement import EventType
from gfirefly.server.globalobject import GlobalObject
from app.game.core.lively import task_status
from app.game.action.node._fight_start_logic import pvp_assemble_units
from app.game.action.node._fight_start_logic import pvp_process
from app.game.action.node._fight_start_logic import get_seeds
from app.game.core.item_group_helper import is_afford
from app.game.core.item_group_helper import consume, get_consume_gold_num
# from app.game.core.item_group_helper import get_return
from app.proto_file.shop_pb2 import ShopResponse
from app.game.action.root import netforwarding
from app.game.core.mail_helper import send_mail

remote_gate = GlobalObject().remote.get('gate')
PVP_TABLE_NAME = 'tb_pvp_rank'


@remoteserviceHandle('gate')
def pvp_top_rank_request_1501(data, player):
    response = pvp_rank_pb2.PlayerRankResponse()

    columns = ['id', 'character_id', 'nickname', 'level', 'ap',
               'hero_ids', 'hero_levels', 'head_no']
    records = util.GetSomeRecordInfo(PVP_TABLE_NAME, 'id<=10', columns)
    for record in records:
        rank_item = response.rank_items.add()
        rank_item.level = record.get('level')
        rank_item.nickname = record.get('nickname')
        rank_item.rank = record.get('id')
        rank_item.ap = record.get('ap')
        rank_item.head_no = record.get('head_no')
        rank_item.character_id = record.get('character_id')
        hero_ids = cPickle.loads(record.get('hero_ids'))
        rank_item.hero_ids.extend([_ for _ in hero_ids])
        hero_levels = cPickle.loads(record.get('hero_levels'))
        rank_item.hero_levels.extend([_ for _ in hero_levels])
    response.pvp_score = player.finance[const.PVP]
    return response.SerializeToString()


@remoteserviceHandle('gate')
def pvp_player_rank_request_1502(data, player):
    response = pvp_rank_pb2.PlayerRankResponse()

    prere = dict(character_id=player.base_info.id)
    record = util.GetOneRecordInfo(PVP_TABLE_NAME, prere, ['id'])
    response.player_rank = record.get('id') if record else -1

    if response.player_rank < 9 and response.player_rank > 0:
        columns = ['id', 'character_id', 'nickname', 'level', 'ap',
                   'hero_ids', 'hero_levels', 'head_no']
        records = util.GetSomeRecordInfo(PVP_TABLE_NAME, 'id<=10', columns)
        for record in records:
            rank_item = response.rank_items.add()
            rank_item.level = record.get('level')
            rank_item.nickname = record.get('nickname')
            rank_item.rank = record.get('id')
            rank_item.ap = record.get('ap')
            rank_item.head_no = record.get('head_no')
            rank_item.character_id = record.get('character_id')
            hero_ids = cPickle.loads(record.get('hero_ids'))
            rank_item.hero_ids.extend([_ for _ in hero_ids])
            hero_levels = cPickle.loads(record.get('hero_levels'))
            rank_item.hero_levels.extend([_ for _ in hero_levels])
        response.pvp_score = player.finance[const.PVP]
        return response.SerializeToString()
    # if not record:
    return pvp_player_rank_refresh_request(data, player)

    # cur_rank = record.get('id')
    # columns = ['id', 'nickname', 'level', 'ap', 'hero_ids']
    # prere = 'id>=%s and id<=%s' % (cur_rank - 8, cur_rank + 1)
    # records = util.GetSomeRecordInfo(PVP_TABLE_NAME, prere, columns)
    # for record in records:
    #     rank_item = response.rank_items.add()
    #     rank_item.level = record.get('level')
    #     rank_item.nickname = record.get('nickname')
    #     rank_item.rank = record.get('id')
    #     rank_item.ap = record.get('ap')
    #     hero_ids = cPickle.loads(record.get('hero_ids'))
    #     rank_item.hero_ids.extend([_ for _ in hero_ids])
    # response.pvp_score = player.finance[const.PVP]
    # return response.SerializeToString()


# @remoteserviceHandle('gate')
# def pvp_player_rank_refresh_request_1503(data, player):
#     return pvp_player_rank_refresh_request(data, player)


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


def pvp_fight_assemble_data(red_units, blue_units, red_skill, red_skill_level,
                            blue_skill, blue_skill_level):
    """docstring for pvp_fight_assemble_data"""
    # assemble pvp response
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
    response.red_skill = red_skill
    response.red_skill_level = red_skill_level
    response.blue_skill = blue_skill
    response.blue_skill_level = blue_skill_level

    return response.SerializeToString()


@remoteserviceHandle('gate')
def pvp_fight_request_1505(data, player):
    """
    pvp战斗开始
    """
    request = pvp_rank_pb2.PvpFightRequest()
    response = pvp_rank_pb2.PvpFightResponse()
    request.ParseFromString(data)
    player.base_info.check_time()

    if player.base_info.pvp_times <= 0:
        logger.error('not enough pvp times:%s-%s', player.base_info.pvp_times,
                     game_configs.base_config.get('arena_free_times'))
        response.res.result = False
        response.res.result_no = 836
        return response.SerializeToString()

    line_up = request.lineup
    __skill = request.skill

    open_stage_id = game_configs.base_config.get('arenaOpenStage')
    if player.stage_component.get_stage(open_stage_id).state != 1:
        logger.error('pvp_fight_request_1505, stage not open')
        response.res.result = False
        response.res.result_no = 837
        return response.SerializeToString()

    __best_skill, __skill_level = player.line_up_component.get_skill_info_by_unpar(__skill)
    logger.debug("best_skill=================== %s" % __best_skill)

    prere = dict(character_id=player.base_info.id)
    record = util.GetOneRecordInfo(PVP_TABLE_NAME, prere, ['id'])
    before_player_rank = 0
    if record:
        before_player_rank = record.get('id')
        refresh_rank_data(player, before_player_rank, __skill, __skill_level)

    if before_player_rank == request.challenge_rank:
        logger.error('cant not fight self')
        response.res.result = False
        response.res.result_no = 1505
        return response.SerializeToString()

    prere = dict(id=request.challenge_rank)
    record = util.GetOneRecordInfo(PVP_TABLE_NAME, prere)
    blue_units = record.get('units')
    # print "blue_units:", blue_units
    blue_units = cPickle.loads(blue_units)
    # print "blue_units:", blue_units
    red_units = player.fight_cache_component.get_red_units()

    seed1, seed2 = get_seeds()
    print("seed1, seed2=========%s %s" % (seed1, seed2))
    fight_result = pvp_process(player, line_up, red_units, blue_units,
                               __best_skill, record.get("best_skill"),
                               record.get("level"), __skill, seed1, seed2,
                               const.BATTLE_PVP)

    logger.debug("blue_units: %s" % blue_units)
    logger.debug("fight result:%s" % fight_result)

    target_id = record.get("character_id")

    rank_incr = 0
    if fight_result:
        logger.debug("fight result:True:%s:%s",
                     before_player_rank, request.challenge_rank)

        _arena_win_points = game_configs.base_config.get('arena_win_points')
        if _arena_win_points:
            return_data = gain(player, _arena_win_points, const.ARENA_WIN)
            get_return(player, return_data, response.gain)
        else:
            logger.debug('arena win points is not find')

        push_config = game_configs.push_config[1003]
        rank_count = push_config.conditions[0]
        if request.challenge_rank - before_player_rank >= rank_count:
            txt = game_configs.push_config[1003].text
            message = game_configs.language_config.get(str(txt)).get('cn')
            remote_gate.add_push_message_remote(player.base_info.id, 3, message, int(time.time()))

        push_message('add_blacklist_request_remote', record['character_id'],
                     player.base_info.id)

        if before_player_rank != 0:
            if request.challenge_rank < before_player_rank:
                prere = dict(id=before_player_rank)
                result = util.UpdateWithDict(PVP_TABLE_NAME, record, prere)
                logger.info('update result:%s', result)
                refresh_rank_data(player, request.challenge_rank,
                                  __skill, __skill_level)
        else:
            refresh_rank_data(player, request.challenge_rank,
                              __skill, __skill_level)
            table_max = util.GetTableCount(PVP_TABLE_NAME)
            if record['character_id'] != 1:
                record['id'] = table_max + 1
                util.InsertIntoDB(PVP_TABLE_NAME, record)
            player.base_info.pvp_high_rank = min(player.base_info.pvp_high_rank, table_max)

        if request.challenge_rank < player.base_info.pvp_high_rank:
            rank_incr = player.base_info.pvp_high_rank - request.challenge_rank
        player.base_info.pvp_high_rank = min(player.base_info.pvp_high_rank,
                                             request.challenge_rank)

        # 首次达到某名次的奖励
        arena_rank_up_rewards = game_configs.base_config.get('arenaRankUpRewards')
        if arena_rank_up_rewards:
            return_data = gain(player, arena_rank_up_rewards,
                               const.ARENA_WIN, multiple=rank_incr)
            get_return(player, return_data, response.award)
        else:
            logger.debug('arena rank up points is not find')

        # for (rank, mail_id) in game_configs.base_config.get('arena_rank_points').items():
        #     if rank < request.challenge_rank:
        #         continue
        #     if rank in player.base_info.pvp_high_rank_award:
        #         continue
        #     mail_conf = game_configs.mail_config.get(mail_id)
        #     mail = Mail_PB()
        #     mail.config_id = mail_id
        #     mail.receive_id = player.base_info.id
        #     mail.send_time = int(time.time())
        #     mail_data = mail.SerializePartialToString()
        #     player.base_info.pvp_high_rank_award.append(rank)

        #     if not netforwarding.push_message('receive_mail_remote',
        #                                       player.base_info.id,
        #                                       mail_data):
        #         logger.error('pvp high rank award mail fail. pid:%s',
        #                      player.base_info.id)
        #     else:
        #         logger.debug('pvp high rak award mail,mail_id:%s',
        #                      mail_id)
        #         pass
    else:
        logger.debug("fight result:False")

    if fight_result:
        send_mail(conf_id=123, receive_id=target_id, pvp_rank=record['id'])
    else:
        send_mail(conf_id=124, receive_id=target_id)

    lively_event = CountEvent.create_event(EventType.SPORTS, 1, ifadd=True)
    tstatus = player.tasks.check_inter(lively_event)
    player.tasks.save_data()
    if tstatus:
        task_data = task_status(player)
        remote_gate.push_object_remote(1234, task_data, [player.dynamic_id])

    player.base_info.pvp_times -= 1
    player.base_info.pvp_refresh_time = time.time()
    player.base_info.save_data()
    response.res.result = True
    pvp_assemble_units(red_units, blue_units, response)
    response.fight_result = fight_result
    response.red_skill = __skill
    response.red_skill_level = __skill_level
    response.blue_skill = record.get("unpar_skill")
    response.blue_skill_level = record.get("unpar_skill_level")
    response.seed1 = seed1
    response.seed2 = seed2
    response.top_rank = player.base_info.pvp_high_rank
    response.rank_incr = rank_incr
    logger.debug(response)

    return response.SerializeToString()


@remoteserviceHandle('gate')
def pvp_fight_revenge_1507(data, player):
    request = pvp_rank_pb2.PvpFightRevenge()
    response = pvp_rank_pb2.PvpFightResponse()
    request.ParseFromString(data)
    line_up = request.lineup
    __skill = request.skill

    if not player.friends.can_revenge(request.black_id):
        logger.error('black id is not in blacklist:%s', request.black_id)
        response.res.result = False
        response.res.result_no = 1516
        return response.SerializePartialToString()

    __best_skill, __skill_level = player.line_up_component.get_skill_info_by_unpar(__skill)
    logger.debug("best_skill=================== %s" % __best_skill)

    prere = dict(character_id=request.black_id)
    record = util.GetOneRecordInfo(PVP_TABLE_NAME, prere)
    if not record:
        logger.error('black id is not found:%s', request.black_id)
        response.res.result = False
        response.res.result_no = 1517
        return response.SerializePartialToString()

    blue_units = record.get('units')
    # print "blue_units:", blue_units
    blue_units = cPickle.loads(blue_units)
    # print "blue_units:", blue_units
    red_units = player.fight_cache_component.get_red_units()

    seed1, seed2 = get_seeds()
    fight_result = pvp_process(player, line_up, red_units, blue_units,
                               __best_skill, record.get("best_skill"),
                               record.get("level"), __skill, seed1, seed2,
                               const.BATTLE_PVP)

    logger.debug("fight revenge result:%s" % fight_result)

    if fight_result:
        player.friends.del_blacklist(request.black_id)
        player.friends.save_data()

        _arena_win_points = game_configs.base_config.get('arena_win_points')
        if _arena_win_points:
            return_data = gain(player, _arena_win_points, const.FRIEND_REVENGE)
            get_return(player, return_data, response.gain)
        else:
            logger.debug('friend revenge points is not find')

    response.res.result = True
    pvp_assemble_units(red_units, blue_units, response)
    response.fight_result = fight_result
    response.red_skill = __skill
    response.red_skill_level = __skill_level
    response.blue_skill = record.get("unpar_skill")
    response.blue_skill_level = record.get("unpar_skill_level")

    return response.SerializeToString()


@remoteserviceHandle('gate')
def reset_pvp_time_1506(data, player):
    request = pvp_rank_pb2.ResetPvpTime()
    request.ParseFromString(data)

    player.base_info.check_time()
    response = ShopResponse()
    response.res.result = True
    vip_level = player.base_info.vip_level
    reset_times_max = game_configs.vip_config.get(vip_level).get('buyArenaTimes')
    if player.base_info.pvp_refresh_count + request.times > reset_times_max:
        logger.error('over arenatime could buy:%s+%s>%s',
                     player.base_info.pvp_refresh_count,
                     request.times,
                     reset_times_max)
        response.res.result = False
        response.res.result_no = 15061
        return response.SerializePartialToString()

    _consume = game_configs.base_config.get('arena_times_buy_price')
    result = is_afford(player, _consume)  # 校验
    if not result.get('result'):
        response.res.result = False
        response.res.result_no = 1506
        return response.SerializePartialToString()

    need_gold = get_consume_gold_num(_consume)

    def func():
        return_data = consume(player, _consume)  # 消耗
        get_return(player, return_data, response.consume)
        player.base_info.pvp_times += request.times
        player.base_info.pvp_refresh_time = time.time()
        player.base_info.pvp_refresh_count += request.times
        player.base_info.save_data()
    player.pay.pay(need_gold, func)

    return response.SerializePartialToString()


def pvp_player_rank_refresh_request(data, player):
    table_max = util.GetTableCount(PVP_TABLE_NAME)
    response = pvp_rank_pb2.PlayerRankResponse()

    prere = dict(character_id=player.base_info.id)
    record = util.GetOneRecordInfo(PVP_TABLE_NAME, prere, ['id'])
    response.player_rank = record.get('id') if record else -1
    cur_rank = record.get('id') if record else table_max

    ranks = [cur_rank]
    for v in game_configs.arena_fight_config.values():
        play_rank = v.get('play_rank')
        if cur_rank in range(play_rank[0], play_rank[1] + 1):
            para = dict(k=cur_rank)
            choose_fields = eval(v.get('choose'), para)
            logger.info('cur:%s choose:%s', cur_rank, choose_fields)
            for x, y, c in choose_fields:
                range_nums = range(int(x), int(y)+1)
                for _ in range(c):
                    r = random.choice(range_nums)
                    range_nums.remove(r)
                    ranks.append(r)
            break

    if not ranks:
        raise Exception('rank field error!')

    caret = ','
    prere = 'id in (%s)' % caret.join(str(_) for _ in ranks)
    logger.info('prere:%s', prere)
    columns = ['id', 'character_id', 'nickname', 'level', 'ap',
               'hero_ids', 'hero_levels', 'head_no']
    records = util.GetSomeRecordInfo(PVP_TABLE_NAME, prere, columns)
    for record in records:
        rank_item = response.rank_items.add()
        rank_item.level = record.get('level')
        rank_item.nickname = record.get('nickname')
        rank_item.rank = record.get('id')
        rank_item.ap = record.get('ap')
        rank_item.head_no = record.get('head_no')
        rank_item.character_id = record.get('character_id')
        hero_ids = cPickle.loads(record.get('hero_ids'))
        rank_item.hero_ids.extend([_ for _ in hero_ids])
        hero_levels = cPickle.loads(record.get('hero_levels'))
        rank_item.hero_levels.extend([_ for _ in hero_levels])
    response.pvp_score = player.finance[const.PVP]
    return response.SerializeToString()


def refresh_rank_data(player, rank_id, skill, skill_level):
    red_units = cPickle.dumps(player.fight_cache_component.red_unit)
    slots = cPickle.dumps(line_up_info(player))
    hero_nos = player.line_up_component.hero_nos
    hero_levels = player.line_up_component.hero_levels
    best_skill = player.line_up_component.get_skill_id_by_unpar(skill)
    head = player.base_info.head
    rank_data = dict(hero_ids=cPickle.dumps(hero_nos),
                     hero_levels=cPickle.dumps(hero_levels),
                     level=player.base_info.level,
                     nickname=player.base_info.base_name,
                     best_skill=best_skill,
                     unpar_skill=skill,
                     unpar_skill_level=skill_level,
                     ap=int(player.line_up_component.combat_power),
                     character_id=player.base_info.id,
                     units=red_units,
                     slots=slots,
                     head_no=head)

    prere = dict(id=rank_id)
    result = util.UpdateWithDict(PVP_TABLE_NAME, rank_data, prere)
    if not result:
        raise Exception('update pvp fail!! id:%s' % rank_id)


@remoteserviceHandle('gate')
def pvp_award_remote(pvp_num, is_online, player):
    player.finance[const.PVP] += pvp_num
    player.finance.save_data()
    logger.debug('pvp award!play:%s,%s-%s:on:%s', player.character_id,
                 pvp_num, player.finance[const.PVP], is_online)
    return True

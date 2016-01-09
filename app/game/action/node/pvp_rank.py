# -*- coding:utf-8 -*-
"""
created by sphinx on 27/10/14.
"""
import time
import random
import cPickle
from gfirefly.server.logobj import logger
from shared.utils.const import const
from app.proto_file.db_pb2 import Heads_DB
from app.proto_file import pvp_rank_pb2
from app.proto_file import rob_treasure_pb2
from app.game.core.item_group_helper import gain
from app.game.core.item_group_helper import get_return
from app.game.action.node._fight_start_logic import assemble
from app.game.action.root.netforwarding import push_message
from gfirefly.server.globalobject import remoteserviceHandle
from shared.db_opear.configs_data import game_configs
from gfirefly.server.globalobject import GlobalObject
from app.game.action.node._fight_start_logic import pvp_assemble_units
from app.game.action.node._fight_start_logic import pvp_process
from app.game.action.node._fight_start_logic import get_seeds
from app.game.core.item_group_helper import is_afford
from app.game.core.item_group_helper import consume, get_consume_gold_num
from app.proto_file.shop_pb2 import ShopResponse
from app.proto_file.common_pb2 import CommonResponse
from app.game.core.mail_helper import send_mail
from app.game.redis_mode import tb_character_info, tb_pvp_rank
from app.game.core.task import hook_task, CONDITIONId
from app.game.component.fight.stage_logic.pvp_stage import PvpStageLogic
from app.game.redis_mode import tb_guild_info
from app.game.core.equipment.equipment_chip import EquipmentChip
from shared.db_opear.configs_data.data_helper import parse
import types
from shared.tlog import tlog_action
from shared.common_logic.feature_open import is_not_open, FO_PVP_RANK, FO_ROB_TREASURE
from app.game.core.drop_bag import BigBag

remote_gate = GlobalObject().remote.get('gate')
PVP_TABLE_NAME = 'tb_pvp_rank'


def _get_hero_no_and_level(data):
    hero_nos = []
    hero_levels = []
    for k, v in data.items():
        info = cPickle.loads(v)
        hero_nos.append(info.get('hero_no'))
        hero_levels.append(info.get('hero_level'))
    return hero_nos, hero_levels


def _with_pvp_info(response, character_id):
    char_obj = tb_character_info.getObj(character_id)
    robot_obj = tb_character_info.getObj('robot')
    data = {}
    if character_id >= 10000 and char_obj.exists():
        keys = ['line_up_slots',
                'level',
                'nickname',
                'attackPoint',
                'heads',
                'vip_level',
                'guild_id']
        data = char_obj.hmget(keys)
        heads = Heads_DB()
        heads.ParseFromString(data['heads'])
        data['head_no'] = heads.now_head
        hero_nos, hero_levels = _get_hero_no_and_level(data['line_up_slots'])
        data['hero_ids'] = hero_nos
        data['hero_levels'] = hero_levels
        data['character_id'] = character_id

        response.vip_level = data.get('vip_level')
        g_id = data.get('guild_id')
        if g_id and type(g_id) is types.StringType:
            response.guild_name = tb_guild_info.getObj(g_id).hget('name')

    elif robot_obj.hexists(character_id):
        data = robot_obj.hget(character_id)
    else:
        logger.error('no pvp info:%s', character_id)
        return

    response.level = data.get('level')
    response.nickname = data.get('nickname')
    response.ap = int(data.get('attackPoint'))
    response.hero_ids.extend([_ for _ in data['hero_ids']])
    response.hero_levels.extend([_ for _ in data['hero_levels']])
    response.head_no = data.get('head_no', 0)
    response.character_id = data.get('character_id')


def get_player_pvp_stage(rank):
    for v in game_configs.arena_fight_config.values():
        if v.get('type') != 5:
            continue
        if not v.get('play_rank'):
            continue
        top_begin, top_end = v.get('play_rank')
        if rank >= top_begin and rank <= top_end:
            return v
    return None


@remoteserviceHandle('gate')
def pvp_top_rank_request_1501(data, player):
    response = pvp_rank_pb2.PlayerRankResponse()

    records = tb_pvp_rank.zrangebyscore(1, 20, withscores=True)
    for char_id, rank in records:
        char_id = int(char_id)
        rank = int(rank)
        rank_item = response.rank_items.add()
        rank_item.rank = rank
        _with_pvp_info(rank_item, char_id)
    response.pvp_score = player.finance[const.PVP]
    return response.SerializeToString()


@remoteserviceHandle('gate')
def pvp_player_rank_request_1502(data, player):
    response = pvp_rank_pb2.PlayerRankResponse()

    player_ranks = player.pvp.pvp_arena_players

    if player.pvp.pvp_upstage_challenge_rank != 0:
        _up_stage_rank = player.pvp.pvp_upstage_challenge_rank
        _id = int(tb_pvp_rank.zrangebyscore(_up_stage_rank, _up_stage_rank)[0])
        response.pvp_upstage_challenge_id = _id

        char_obj = tb_character_info.getObj(_id)
        robot_obj = tb_character_info.getObj('robot')
        data = {}
        if _id >= 10000 and char_obj.exists():
            response.pvp_upstage_challenge_nickname = char_obj.hget('nickname')
        elif robot_obj.hexists(_id):
            data = robot_obj.hget(_id)
            response.pvp_upstage_challenge_nickname = data.get('nickname')
        else:
            logger.error('no pvp info:%s', _id)

    rank = tb_pvp_rank.zscore(player.base_info.id)
    response.player_rank = int(rank) if rank else -1
    response.pvp_score = player.finance[const.PVP]
    if not rank:
        rank = tb_pvp_rank.ztotal()

    # top_rank = []
    # stage_info = get_player_pvp_stage(rank)
    # print stage_info, rank
    # if stage_info:
    #     _choose = eval(stage_info.get('choose'))
    #     if _choose:
    #         _min, _max, count = _choose[0]
    #         top_rank.extend(range(_min, _max))
    #     else:
    #         logger.error('pvp stage not found choose:%s', stage_info)

    # print top_rank
    # if top_rank:
    #     records = tb_pvp_rank.zrangebyscore(min(top_rank), max(top_rank),
    #                                         withscores=True)
    #     for char_id, _rank in records:
    #         char_id = int(char_id)
    #         _rank = int(_rank)
    #         if _rank not in top_rank:
    #             continue
    #         rank_item = response.rank_items.add()
    #         rank_item.rank = _rank
    #         _with_pvp_info(rank_item, char_id)

    records = tb_pvp_rank.zrangebyscore(min(player_ranks), max(player_ranks),
                                        withscores=True)

    # print records, rank
    for char_id, _rank in records:
        char_id = int(char_id)
        _rank = int(_rank)
        if _rank not in player_ranks:
            continue
        # if _rank in top_rank:
        #     continue
        rank_item = response.rank_items.add()
        rank_item.rank = _rank
        _with_pvp_info(rank_item, char_id)
    # print response
    return response.SerializeToString()


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


def get_pvp_data(character_id):
    char_obj = tb_character_info.getObj(character_id)
    if character_id >= 10000 and char_obj.exists():
        keys = ['level',
                'attackPoint',
                'best_skill',
                'unpars',
                'current_unpar',
                'copy_units',
                'copy_units2']
        pvp_data = char_obj.hmget(keys)
        pvp_data['character_id'] = character_id
        pvp_data['unpar_skill'] = 0#pvp_data['current_unpar']
        # skill_level = pvp_data['unpars'].get(pvp_data['current_unpar'], 1)
        pvp_data['unpar_skill_level'] = 0 #skill_level
        # print 'get pvp data player:', pvp_data

        return pvp_data

    robot_obj = tb_character_info.getObj('robot')
    if robot_obj.hexists(character_id):
        pvp_data = robot_obj.hget(character_id)
        # print 'get pvp data robot:', pvp_data
        pvp_data['copy_units2'] = pvp_data['copy_units']
        return pvp_data

    return {}


def pvp_fight(player, character_id, line_up, skill, response,
              is_copy_unit=False):
    record = get_pvp_data(character_id)
    if not record:
        logger.error('player id is not found:%s', character_id)
        response.res.result = False
        response.res.result_no = 150001
        return response.SerializePartialToString()

    if is_copy_unit:
        blue_units = record.get('copy_units2')
    else:
        blue_units = record.get('copy_units')
    # save_line_up_order(line_up, player, skill)
    player.fight_cache_component.stage_id = 0  # 设置后，不会出现乱入
    player.fight_cache_component.stage = PvpStageLogic()

    red_units = player.fight_cache_component.get_red_units()

    seed1, seed2 = get_seeds()
    fight_result = pvp_process(player, line_up, red_units, blue_units,
                               seed1, seed2,
                               const.BATTLE_PVP)

    pvp_assemble_units(red_units, blue_units, response)
    response.seed1 = seed1
    response.seed2 = seed2
    response.fight_result = fight_result
    return fight_result


@remoteserviceHandle('gate')
def pvp_fight_request_1505(data, player):
    """
    pvp战斗开始
    """
    request = pvp_rank_pb2.PvpFightRequest()
    response = pvp_rank_pb2.PvpFightResponse()
    request.ParseFromString(data)
    # player.pvp.check_time()
    if is_not_open(player, FO_PVP_RANK):
        response.res.result = False
        response.res.result_no = 837
        return response.SerializePartialToString()

    arena_consume = game_configs.base_config.get('arenaConsume')
    result = is_afford(player, arena_consume)  # 校验
    if not result.get('result'):
        logger.error('not enough consume:%s', arena_consume)
        response.res.result = False
        response.res.result_no = 150501
        return response.SerializePartialToString()

    # if player.pvp.pvp_times <= 0:
    #     logger.error('not enough pvp times:%s-%s', player.pvp.pvp_times,
    #                  game_configs.base_config.get('arena_free_times'))
    #     response.res.result = False
    #     response.res.result_no = 836
    #     return response.SerializeToString()

    challenge_rank = request.challenge_rank
    if challenge_rank < 0 and player.pvp.pvp_upstage_challenge_rank != 0:
        challenge_rank = player.pvp.pvp_upstage_challenge_rank

    if challenge_rank < 0:
        logger.error('pvp challenge rank error!!%s-%s',
                     challenge_rank,
                     player.pvp.pvp_upstage_challenge_rank)
        response.res.result = False
        response.res.result_no = 839
        return response.SerializeToString()

    line_up = request.lineup
    skill = request.skill
    target_id = int(tb_pvp_rank.zrangebyscore(challenge_rank,
                                              challenge_rank)[0])
    if target_id != request.challenge_id:
        logger.error('pvp challenge id changed!!%s-%s',
                     target_id, request.challenge_id)
        response.res.result = False
        response.res.result_no = 150508
        return response.SerializeToString()

    before_player_rank = tb_pvp_rank.zscore(player.base_info.id)
    if not before_player_rank:
        before_player_rank = int(tb_pvp_rank.getObj('incr').incr())
        tb_pvp_rank.zadd(before_player_rank, player.base_info.id)
        player.pvp.pvp_high_rank = before_player_rank
    elif before_player_rank != request.self_rank:
        logger.error('pvp self rank changed!!%s-%s',
                     before_player_rank, request.self_rank)
        response.res.result = False
        response.res.result_no = 150509
        return response.SerializeToString()

    before_player_rank = int(before_player_rank)

    if before_player_rank == challenge_rank:
        logger.error('cant not fight self')
        response.res.result = False
        response.res.result_no = 1505
        return response.SerializeToString()

    return_data = consume(player, arena_consume, const.PVP)
    get_return(player, return_data, response.consume)

    fight_result = pvp_fight(player, target_id, line_up, skill, response)

    rank_incr = 0
    response.top_rank = player.pvp.pvp_high_rank
    response.before_rank = before_player_rank
    if fight_result:
        logger.debug("fight result:True:%s:%s",
                     before_player_rank, challenge_rank)

        _arena_win_points = game_configs.base_config.get('arena_win_points')
        if _arena_win_points:
            return_data = gain(player, _arena_win_points, const.ARENA_WIN)
            get_return(player, return_data, response.gain)
        else:
            logger.debug('arena win points is not find')

        push_config = game_configs.push_config[1003]
        rank_count = push_config.conditions[0]
        if challenge_rank - before_player_rank >= rank_count:
            txt = game_configs.push_config[1003].text
            message = game_configs.language_config.get(str(txt)).get('cn')
            remote_gate['push'].add_push_message_remote(player.base_info.id, 3,
                                                        message,
                                                        int(time.time()))

        push_message('add_blacklist_request_remote', target_id,
                     player.base_info.id)

        if challenge_rank < before_player_rank:
            tb_pvp_rank.zadd(challenge_rank, player.base_info.id,
                             before_player_rank, target_id)
            send_mail(conf_id=123, receive_id=target_id,
                      pvp_rank=before_player_rank,
                      nickname=player.base_info.base_name)

        if challenge_rank < player.pvp.pvp_high_rank:
            rank_incr = player.pvp.pvp_high_rank - challenge_rank
        if player.pvp.pvp_high_rank > challenge_rank:
            hook_task(player, CONDITIONId.PVP_RANK, challenge_rank)
        formula = game_configs.formula_config.get("arenaRankUpRewardsValue").get("formula")
        gain_num = eval(formula, dict(upRank=challenge_rank, highestRank=player.pvp.pvp_high_rank))

        # stage award
        stage_info_before = get_player_pvp_stage(player.pvp.pvp_high_rank)
        stage_info_current = get_player_pvp_stage(challenge_rank)
        before_gradient = stage_info_before.get('Gradient')
        current_gradient = stage_info_current.get('Gradient')
        if stage_info_current and stage_info_current \
           and before_gradient > current_gradient:
            arena_stage_reward = stage_info_current.get('Reward')
            stage_reward_data = gain(player, arena_stage_reward,
                                     const.ARENA_WIN)
            get_return(player, stage_reward_data, response.award2)
            logger.debug('stage award %s %s',
                         stage_info_current, stage_info_before)

        player.pvp.pvp_high_rank = min(player.pvp.pvp_high_rank,
                                       challenge_rank)
        logger.debug("history_high_rank %s current %s" %
                     (player.pvp.pvp_high_rank, before_player_rank))

        # 首次达到某名次的奖励
        arena_rank_rewards = game_configs.base_config.get('arenaRankUpRewards')

        if arena_rank_rewards:
            return_data = gain(player, arena_rank_rewards,
                               const.ARENA_WIN, multiple=int(gain_num))
            get_return(player, return_data, response.award)
        else:
            logger.debug('arena rank up points is not find')
    else:
        logger.debug("fight result:False")
        send_mail(conf_id=124, receive_id=target_id,
                  nickname=player.base_info.base_name)

    hook_task(player, CONDITIONId.PVP_RANk_TIMES, 1)

    player.pvp.pvp_times -= 1
    player.pvp.pvp_refresh_time = time.time()
    player.pvp.save_data()
    response.res.result = True
    # response.top_rank = player.pvp.pvp_high_rank
    response.rank_incr = rank_incr
    logger.debug(response)

    return response.SerializeToString()


@remoteserviceHandle('gate')
def pvp_fight_revenge_1507(data, player):
    request = pvp_rank_pb2.PvpFightRevenge()
    response = pvp_rank_pb2.PvpFightResponse()
    request.ParseFromString(data)
    line_up = request.lineup
    skill = request.skill
    target_id = request.black_id

    if not player.friends.can_revenge(target_id):
        logger.error('black id is not in blacklist:%s', target_id)
        response.res.result = False
        response.res.result_no = 1516
        return response.SerializePartialToString()

    fight_result = pvp_fight(player, target_id, line_up, skill, response)

    logger.debug("fight revenge result:%s" % fight_result)

    if fight_result:
        player.friends.del_blacklist(target_id)
        player.friends.save_data()

        revenge_reward = game_configs.base_config['arenaRevengeRewards']
        return_data = gain(player, revenge_reward, const.FRIEND_REVENGE)
        get_return(player, return_data, response.gain)

    response.res.result = True
    logger.debug("red_units: %s" % response.red)
    return response.SerializeToString()


@remoteserviceHandle('gate')
def pvp_fight_overcome_1508(data, player):
    request = pvp_rank_pb2.PvpFightOvercome()
    response = pvp_rank_pb2.PvpFightResponse()
    request.ParseFromString(data)
    line_up = request.lineup
    skill = request.skill

    if player.pvp.pvp_overcome_failed:
        logger.error('overcome is already failed')
        response.res.result = False
        response.res.result_no = 150805
        return response.SerializeToString()

    if player.base_info.is_firstday_from_register(const.OPEN_FEATURE_GGZJ):
        logger.error('overcome is not open ')
        response.res.result = False
        response.res.result_no = 150801
        return response.SerializeToString()

    ggzj_item = game_configs.ggzj_config.get(request.index)
    if not ggzj_item:
        logger.error('ggzj config id err:%s', request.index)
        response.res.result = False
        response.res.result_no = 150804
        return response.SerializePartialToString()

    if ggzj_item.get('section') != player.pvp.pvp_overcome_current:
        logger.error('overcome index is error:%s-%s',
                     ggzj_item.get('section'), player.pvp.pvp_overcome_current)
        response.res.result = False
        response.res.result_no = 150801
        return response.SerializePartialToString()

    target_id = player.pvp.get_overcome_id(ggzj_item.get('index'))
    if not target_id:
        logger.error('overcome index is not exist:%s', request.index)
        response.res.result = False
        response.res.result_no = 150802
        return response.SerializePartialToString()

    fight_result = pvp_fight(player, target_id, line_up, skill, response,
                             is_copy_unit=True)

    logger.debug("fight revenge result:%s" % fight_result)

    if fight_result:
        player.pvp.pvp_overcome_current += 1
        player.pvp.pvp_overcome_stars += ggzj_item.get('star')
        player.pvp.save_data()

        return_data = gain(player, ggzj_item.get('reward1'),
                           const.PVP_OVERCOME)
        get_return(player, return_data, response.gain)
        return_data = gain(player, ggzj_item.get('reward2'),
                           const.PVP_OVERCOME)
        get_return(player, return_data, response.gain)
    else:
        player.pvp.pvp_overcome_failed = True
        player.pvp.save_data()

    response.res.result = True
    logger.debug("red_units: %s" % response.red)
    return response.SerializeToString()


@remoteserviceHandle('gate')
def reset_overcome_time_1509(data, player):
    request = pvp_rank_pb2.ResetPvpOvercomeTime()
    request.ParseFromString(data)
    response = CommonResponse()

    if player.base_info.is_firstday_from_register(const.OPEN_FEATURE_GGZJ):
        response.result = False
        response.result_no = 150901
        return response.SerializeToString()

    response.result = player.pvp.reset_overcome()
    return response.SerializeToString()


@remoteserviceHandle('gate')
def reset_pvp_time_1506(data, player):
    request = pvp_rank_pb2.ResetPvpTime()
    request.ParseFromString(data)

    player.pvp.check_time()
    response = ShopResponse()
    response.res.result = True
    reset_times_max = player.base_info.buy_arena_times()
    if player.pvp.pvp_refresh_count + request.times > reset_times_max:
        logger.error('over arenatime could buy:%s+%s>%s',
                     player.pvp.pvp_refresh_count,
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

    need_gold = get_consume_gold_num(_consume) * request.times

    def func():
        return_data = consume(player, _consume,
                              const.RESET_PVP_TIME,
                              multiple=request.times)  # 消耗
        get_return(player, return_data, response.consume)
        player.pvp.pvp_times += request.times
        player.pvp.pvp_refresh_time = time.time()
        player.pvp.pvp_refresh_count += request.times
        player.pvp.save_data()
    player.pay.pay(need_gold, const.RESET_PVP_TIME, func)

    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def pvp_award_remote(pvp_num, is_online, player):
    player.finance[const.PVP] += pvp_num
    player.finance.save_data()
    logger.debug('pvp award!play:%s,%s-%s:on:%s', player.character_id,
                 pvp_num, player.finance[const.PVP], is_online)
    return True


@remoteserviceHandle('gate')
def PvpOvercomAward_1510(data, player):
    request = pvp_rank_pb2.PvpOvercomeAwardRequest()
    request.ParseFromString(data)

    player.pvp.check_time()
    response = pvp_rank_pb2.PvpOvercomeAwardResponse()
    ggzj_item = game_configs.ggzj_config.get(request.index)

    if not ggzj_item:
        logger.error('ggzj config id err:%s', request.index)
        response.res.result = False
        response.res.result_no = 151001
        return response.SerializePartialToString()

    if ggzj_item.get('section') > player.pvp.pvp_overcome_current:
        logger.error('ggzj award id err:%s(%s-%s)',
                     request.index,
                     ggzj_item.get('section'),
                     player.pvp.pvp_overcome_current)
        response.res.result = False
        response.res.result_no = 151002
        return response.SerializePartialToString()

    if request.index in player.pvp.pvp_overcome_awards:
        logger.error('ggzj award id repeat:%s-%s',
                     request.index, player.pvp.pvp_overcome_awards)
        response.res.result = False
        response.res.result_no = 151003
        return response.SerializePartialToString()

    award = ggzj_item.get('database')
    if not award:
        logger.error('ggzj database is null:%s', request.index)
        response.res.result = False
        response.res.result_no = 151004
        return response.SerializePartialToString()

    logger.info('ggzj take award %s %s',
                request.index, ggzj_item.get('database'))

    return_data = gain(player, award, const.PVP_OVERCOME)
    get_return(player, return_data, response.gain)
    player.pvp.pvp_overcome_awards.append(request.index)
    player.pvp.save_data()
    tlog_action.log('OvercomeAward', player, request.index)

    response.res.result = True
    return response.SerializePartialToString()


def random_buf(buff):
    wights = 0
    for v in buff.values():
        wights += v[1]

    _rand_num = random.random() * wights
    for item in buff.values():
        star, w, bt, vt, value = item
        if _rand_num < w:
            return item
        else:
            _rand_num -= w


@remoteserviceHandle('gate')
def GetPvpOvercomeBuff_1511(data, player):
    request = pvp_rank_pb2.GetPvpOvercomeBuffRequest()
    request.ParseFromString(data)

    player.pvp.check_time()
    response = pvp_rank_pb2.GetPvpOvercomeBuffResponse()
    ggzj_item = game_configs.ggzj_config.get(request.index)

    if not ggzj_item:
        logger.error('ggzj config id err:%s', request.index)
        response.res.result = False
        response.res.result_no = 151101
        return response.SerializePartialToString()

    if ggzj_item.get('section') > player.pvp.pvp_overcome_current:
        logger.error('ggzj award id err:%s(%s-%s)',
                     request.index,
                     ggzj_item.get('section'),
                     player.pvp.pvp_overcome_current)
        response.res.result = False
        response.res.result_no = 151102
        return response.SerializePartialToString()

    logger.info('ggzj take buff %s %s', request.index, ggzj_item.get('buff1'))

    if request.index not in player.pvp.pvp_overcome_buff_init.keys():
        _buff_data = []

        _buff_data.append(random_buf(ggzj_item.get('buff1')))
        _buff_data.append(random_buf(ggzj_item.get('buff2')))
        _buff_data.append(random_buf(ggzj_item.get('buff3')))
        player.pvp.pvp_overcome_buff_init[request.index] = _buff_data
        player.pvp.save_data()

    _overcome_buf = player.pvp.pvp_overcome_buff_init[request.index]
    for star, _, bt, vt, value in _overcome_buf:
        res_buff = response.buff.add()
        res_buff.index = request.index
        res_buff.star = star
        res_buff.buff_type = bt
        res_buff.value_type = vt
        res_buff.value = value

    response.res.result = True
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def BuyPvpOvercomeBuff_1512(data, player):
    request = pvp_rank_pb2.BuyPvpOvercomeBuffRequest()
    request.ParseFromString(data)

    player.pvp.check_time()
    response = pvp_rank_pb2.BuyPvpOvercomeBuffResponse()

    if request.index not in player.pvp.pvp_overcome_buff_init:
        logger.error('ggzj buff index is null:%s', request.index)
        response.res.result = False
        response.res.result_no = 151204
        return response.SerializePartialToString()

    if request.index in player.pvp.pvp_overcome_buff:
        logger.error('ggzj buff index is repeat:%s-%s',
                     request.index, player.pvp.pvp_overcome_buff)
        response.res.result = False
        response.res.result_no = 151205
        return response.SerializePartialToString()

    logger.info('ggzj take buff %s %s--%s',
                request.index, request.num,
                player.pvp.pvp_overcome_buff_init)

    star, bt, vt, value = 0, 0, 0, 0
    if request.num >= 0:
        _overcome_buf = player.pvp.pvp_overcome_buff_init[request.index]
        star, _, bt, vt, value = _overcome_buf[request.num]
        if star > player.pvp.pvp_overcome_stars:
            logger.error('ggzj buff not enough star:%s-%s',
                         star, player.pvp.pvp_overcome_stars)
            response.res.result = False
            response.res.result_no = 151205
            return response.SerializePartialToString()

    player.pvp.pvp_overcome_stars -= star
    player.pvp.pvp_overcome_buff[request.index] = [bt, vt, value]
    player.pvp.save_data()
    res_buff = response.buff.add()
    res_buff.index = request.index
    res_buff.buff_type = bt
    res_buff.value_type = vt
    res_buff.value = value
    tlog_action.log('OvercomeBuyBuff', player, star, bt, vt, value)

    response.res.result = True
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def GetPvpOvercomeInfo_1513(data, player):
    player.pvp.check_time()
    response = pvp_rank_pb2.GetPvpOvercomeInfo()

    response.pvp_overcome_index = player.pvp.pvp_overcome_current
    response.stars = player.pvp.pvp_overcome_stars
    response.refresh_count = player.pvp.pvp_overcome_refresh_count
    response.awarded.extend(player.pvp.pvp_overcome_awards)
    response.is_failed = player.pvp.pvp_overcome_failed
    for _id, ap in player.pvp.pvp_overcome:
        response.target_fight_powers.append(ap)
    for k, v in player.pvp.pvp_overcome_buff.items():
        res_buff = response.buff.add()
        res_buff.index = k
        bt, vt, value = v
        res_buff.buff_type = bt
        res_buff.value_type = vt
        res_buff.value = value

    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def pvp_rob_treasure_864(data, player):
    request = pvp_rank_pb2.PvpRobTreasureRequest()
    response = pvp_rank_pb2.PvpFightResponse()
    request.ParseFromString(data)
    uid = request.uid
    chip_id = request.chip_id
    chip_conf = check_can_rob(player, uid, chip_id, 1, response)
    check_res, res_no, chip_conf = check_can_rob(player, uid, chip_id, 1, response)
    if not check_res:
        response.res.result = False
        response.res.result_no = res_no
        return response.SerializePartialToString()
    fight_result = deal_pvp_rob_fight(player, uid, chip_id, response, chip_conf)
    player.rob_treasure.truce = [0, 1]
    if fight_result:
        indiana_conf = get_indiana_conf(player, uid, chip_conf)
        player.rob_treasure.can_receive = indiana_conf.id
        player.rob_treasure.save_data()

    player.pvp.reset_rob_treasure()
    player.pvp.save_data()
    response.res.result = True
    logger.debug("response ==================== : %s" % response)
    return response.SerializeToString()


@remoteserviceHandle('gate')
def pvp_rob_treasure_more_times_1504(data, player):
    request = pvp_rank_pb2.RobTreasureMoreTimesRequest()
    response = pvp_rank_pb2.RobTreasureMoreTimesResponse()
    request.ParseFromString(data)
    uid = request.uid
    chip_id = request.chip_id
    times = request.times
    check_res, res_no, chip_conf = check_can_rob(player, uid, chip_id, times, response)
    if not check_res:
        response.res.result = False
        response.res.result_no = res_no
        return response.SerializePartialToString()
    player.rob_treasure.truce = [0, 1]
    for _ in range(times):
        one_times_response = response.one_time_info.add()
        fight_response = one_times_response.fight_info
        fight_result = deal_pvp_rob_fight(player, uid, chip_id, fight_response, chip_conf)
        if fight_result:
            indiana_conf = get_indiana_conf(player, uid, chip_conf)
            common_bag = BigBag(indiana_conf.reward)
            drops = common_bag.get_drop_items()

            x = random.randint(0, 2)
            return_data = gain(player, [drops[x]],
                               const.ROB_TREASURE_REWARD)
            get_return(player, return_data, one_times_response.gain)

    player.pvp.reset_rob_treasure()
    player.pvp.save_data()
    player.rob_treasure.save_data()
    response.res.result = True
    logger.debug("response ==================== : %s" % response)
    return response.SerializeToString()


def check_can_rob(player, uid, chip_id, times, response):
    if is_not_open(player, FO_ROB_TREASURE):
        return False, 837, None

    player_ids = player.pvp.rob_treasure
    flag = 0
    for player_id, ap in player_ids:
        if uid == player_id:
            flag = 1
            break

    if not flag:
        logger.error('pvp_rob_treasure_864, uid error')
        return False, 8641, None

    chip_conf = game_configs.chip_config.get('chips', {}).get(chip_id, None)
    if not chip_conf:
        logger.error('pvp_rob_treasure_864, chip_id error')
        return False, 8642, None
    treasure_id = chip_conf.combineResult

    chips = game_configs.chip_config.get('map').get(treasure_id)

    can_rob = 0
    for x in chips:
        chip = player.equipment_chip_component.get_chip(x)
        # 没有碎片
        if chip and chip.chip_num >= 1:
            can_rob = 1

    default_chips = game_configs.base_config.get('indianaDefaultId')
    if not can_rob and treasure_id not in default_chips:
        logger.error('pvp_rob_treasure_864, dont have one chip')
        return False, 8643, None

    price = game_configs.base_config.get('indianaConsume')
    is_afford_res = is_afford(player, price, multiple=times)  # 校验

    if not is_afford_res.get('result'):
        logger.error('rob_treasure_truce_841, item not enough')
        return False, 8644, None
    print chip_conf, '=====================================chip config'
    return True, 0, chip_conf


def deal_pvp_rob_fight(player, uid, chip_id, one_times_response, chip_conf):
    price = game_configs.base_config.get('indianaConsume')
    return_data = consume(player, price, const.ROB_TREASURE)  # 消耗
    get_return(player, return_data, one_times_response.consume)

    fight_result = pvp_fight(player, uid, [], 0, one_times_response,
                             is_copy_unit=True)

    logger.debug("fight revenge result:%s" % fight_result)

    indiana_conf = get_indiana_conf(player, uid, chip_conf)
    if fight_result:

        if indiana_conf.probability >= random.random():

            gain_items = parse({104: [1, 1, chip_id]})
            return_data = gain(player, gain_items,
                               const.ROB_TREASURE)
            get_return(player, return_data, one_times_response.gain)

            # 处理被打玩家
            deal_target_player(player, uid, chip_id)
    return fight_result


def deal_target_player(player, target_id, chip_id):
    target_data_obj = tb_character_info.getObj(target_id)
    isexist = target_data_obj.exists()
    if not isexist:
        logger.error('deal_target_player, player id error')
        return

    target_data = target_data_obj.hmget(['equipment_chips', 'truce'])
    now = int(time.time())
    truce = target_data.get('truce', [0, 0])
    item_config_item = game_configs.item_config.get(130001)
    end_time = truce[1] + truce[0] * item_config_item.funcArg1 * 60
    if truce[1] and end_time > now:
        return
    chips = target_data.get('equipment_chips')
    chips_obj = {}
    for chip_id_x, chip_num in chips.items():
        equipment_chip = EquipmentChip(chip_id_x, chip_num)
        chips_obj[chip_id_x] = equipment_chip

    chip_obj = chips_obj.get(chip_id)
    if not chip_obj or chip_obj.chip_num == 0:
        return
    # 如果对方有的话
    is_online = remote_gate.is_online_remote(
        'modify_equ_chip_remote', target_id, {'chip_id': chip_id})
    if is_online == "notonline":
        chip_obj.chip_num -= 1

        props = {}
        for chip_id_x, chip_obj in chips_obj.items():
            if chip_obj.chip_num:  # 如果chip num == 0, 则不保存
                props[chip_id_x] = chip_obj.chip_num
        target_data_obj.hset('equipment_chips', props)

    mail_arg1 = [{104: [1, 1, chip_id]}]
    send_mail(conf_id=701,  receive_id=target_id,
              nickname=player.base_info.base_name, arg1=str(mail_arg1))


def get_indiana_conf(player, target_id, chip_conf):
    color_info = player.rob_treasure.get_target_color_info(target_id)
    print target_id, color_info, chip_conf, '====================== get indiana conf'
    quality = chip_conf.quality
    treasure_conf = game_configs.equipment_config.get(chip_conf.combineResult)
    treasure_type = 1
    if treasure_conf.type in [5, 6]:
        treasure_type = 2
    index = color_info.Gradient*100+quality*10+treasure_type
    indiana_conf_id = game_configs.indiana_config.get('indexes').get(index)
    indiana_conf = game_configs.indiana_config.get('indiana').get(indiana_conf_id)
    return indiana_conf


@remoteserviceHandle('gate')
def modify_equ_chip_remote(data, player):
    chip_id = data['chip_id']

    chip = player.equipment_chip_component.get_chip(chip_id)
    # 没有碎片
    if not chip:
        logger.error('modify_equ_chip_remote, dont have chip')
        return

    chip.chip_num -= 1
    player.equipment_chip_component.save_data()

    proto_data = rob_treasure_pb2.BeRobTreasure()
    proto_data.chip_id = chip_id
    remote_gate.push_object_remote(865,
                                   proto_data.SerializeToString(),
                                   [player.dynamic_id])

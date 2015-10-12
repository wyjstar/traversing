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
                'heads']
        data = char_obj.hmget(keys)
        heads = Heads_DB()
        heads.ParseFromString(data['heads'])
        data['head'] = heads.now_head
        hero_nos, hero_levels = _get_hero_no_and_level(data['line_up_slots'])
        data['hero_ids'] = hero_nos
        data['hero_levels'] = hero_levels
        data['character_id'] = character_id
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

    if player.pvp.pvp_upstage_challenge_rank != 0:
        _id = int(tb_pvp_rank.zrangebyscore(player.pvp.pvp_upstage_challenge_rank,
                                            player.pvp.pvp_upstage_challenge_rank)[0])
        response.pvp_upstage_challenge_id = _id
    else:
        response.pvp_upstage_challenge_id = 0

    rank = tb_pvp_rank.zscore(player.base_info.id)
    response.player_rank = int(rank) if rank else -1
    response.pvp_score = player.finance[const.PVP]
    if not rank:
        rank = tb_pvp_rank.ztotal()

    top_rank = []
    stage_info = get_player_pvp_stage(rank)
    print stage_info, rank
    if stage_info:
        _choose = eval(stage_info.get('choose'))
        if _choose:
            _min, _max, count = _choose[0]
            top_rank.extend(range(_min, _max))
        else:
            logger.error('pvp stage not found choose:%s', stage_info)

    print top_rank
    if top_rank:
        records = tb_pvp_rank.zrangebyscore(min(top_rank), max(top_rank),
                                            withscores=True)
        for char_id, _rank in records:
            char_id = int(char_id)
            _rank = int(_rank)
            if _rank not in top_rank:
                continue
            rank_item = response.rank_items.add()
            rank_item.rank = _rank
            _with_pvp_info(rank_item, char_id)

    player_ranks = player.pvp.pvp_arena_players

    records = tb_pvp_rank.zrangebyscore(min(player_ranks), max(player_ranks),
                                        withscores=True)

    # print records, rank
    for char_id, _rank in records:
        char_id = int(char_id)
        _rank = int(_rank)
        if _rank not in player_ranks:
            continue
        rank_item = response.rank_items.add()
        rank_item.rank = _rank
        _with_pvp_info(rank_item, char_id)
    print response
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
        pvp_data['unpar_skill'] = pvp_data['current_unpar']
        skill_level = pvp_data['unpars'].get(pvp_data['current_unpar'], 1)
        pvp_data['unpar_skill_level'] = skill_level
        # print 'get pvp data player:', pvp_data

        return pvp_data

    robot_obj = tb_character_info.getObj('robot')
    if robot_obj.hexists(character_id):
        pvp_data = robot_obj.hget(character_id)
        # print 'get pvp data robot:', pvp_data
        pvp_data['copy_units2'] = pvp_data['copy_units']
        return pvp_data

    return {}


def pvp_fight(player, character_id, line_up, skill, response, callback,
              is_copy_unit=False):
    record = get_pvp_data(character_id)
    if not record:
        logger.error('player id is not found:%s', character_id)
        response.res.result = False
        response.res.result_no = 150001
        return response.SerializePartialToString()

    best_skill, skill_level = player.line_up_component.get_skill_info_by_unpar(skill)
    logger.debug("best_skill=================== %s" % best_skill)

    if is_copy_unit:
        blue_units = record.get('copy_units2')
    else:
        blue_units = record.get('copy_units')
    # save_line_up_order(line_up, player, skill)

    red_units = player.fight_cache_component.get_red_units()

    seed1, seed2 = get_seeds()
    fight_result = pvp_process(player, line_up, red_units, blue_units,
                               best_skill, record.get("best_skill"),
                               record.get("level"), skill, seed1, seed2,
                               const.BATTLE_PVP)

    pvp_assemble_units(red_units, blue_units, response)
    response.seed1 = seed1
    response.seed2 = seed2
    response.fight_result = fight_result
    response.red_skill = skill
    response.red_skill_level = skill_level
    response.blue_skill = record.get("unpar_skill")
    response.blue_skill_level = record.get("unpar_skill_level")
    return callback(player, fight_result)


@remoteserviceHandle('gate')
def pvp_fight_request_1505(data, player):
    """
    pvp战斗开始
    """
    request = pvp_rank_pb2.PvpFightRequest()
    response = pvp_rank_pb2.PvpFightResponse()
    request.ParseFromString(data)
    # player.pvp.check_time()

    arena_consume = game_configs.get('arenaConsume')
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
        logger.error('pvp challenge rank error!!',
                     challenge_rank,
                     player.pvp.pvp_upstage_challenge_rank)
        response.res.result = False
        response.res.result_no = 839
        return response.SerializeToString()

    line_up = request.lineup
    skill = request.skill
    target_id = int(tb_pvp_rank.zrangebyscore(challenge_rank,
                                              challenge_rank)[0])
    # if target_id != request.challenge_id:
    #     logger.error('pvp challenge id changed!!')
    #     response.res.result = False
    #     response.res.result_no = 838
    #     return response.SerializeToString()

    open_stage_id = game_configs.base_config.get('arenaOpenStage')
    if player.stage_component.get_stage(open_stage_id).state != 1:
        logger.error('pvp_fight_request_1505, stage not open')
        response.res.result = False
        response.res.result_no = 837
        return response.SerializeToString()

    before_player_rank = tb_pvp_rank.zscore(player.base_info.id)
    if not before_player_rank:
        before_player_rank = int(tb_pvp_rank.getObj('incr').incr())
        tb_pvp_rank.zadd(before_player_rank, player.base_info.id)
        player.pvp.pvp_high_rank = before_player_rank

    before_player_rank = int(before_player_rank)

    if before_player_rank == challenge_rank:
        logger.error('cant not fight self')
        response.res.result = False
        response.res.result_no = 1505
        return response.SerializeToString()

    return_data = consume(player, arena_consume, const.PVP)
    get_return(player, return_data, response.consume)

    def settle(player, fight_result):
        rank_incr = 0
        response.top_rank = player.pvp.pvp_high_rank
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
                                                            message, int(time.time()))

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

            # stage award
            stage_info_before = get_player_pvp_stage(player.pvp.pvp_high_rank)
            stage_info_current = get_player_pvp_stage(challenge_rank)
            if not stage_info_current and stage_info_before.get('Gradient') > stage_info_current.get('Gradient'):
                arena_stage_reward = stage_info_current.get('Reward')
                stage_reward_data = gain(player, arena_stage_reward,
                                         const.ARENA_WIN)
                get_return(player, stage_reward_data, response.award2)
                logger.debug('stage award',
                             stage_info_current, stage_info_before)

            player.pvp.pvp_high_rank = min(player.pvp.pvp_high_rank,
                                           challenge_rank)
            logger.debug(" history_high_rank %s current %s" % (player.pvp.pvp_high_rank, before_player_rank))

            # 首次达到某名次的奖励
            arena_rank_up_rewards = game_configs.base_config.get('arenaRankUpRewards')
            if arena_rank_up_rewards:
                return_data = gain(player, arena_rank_up_rewards,
                                   const.ARENA_WIN, multiple=rank_incr)
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

    return pvp_fight(player, target_id, line_up, skill, response, settle)


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

    def settle(player, fight_result):
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

    return pvp_fight(player, target_id, line_up, skill, response, settle)


@remoteserviceHandle('gate')
def pvp_fight_overcome_1508(data, player):
    request = pvp_rank_pb2.PvpFightOvercome()
    response = pvp_rank_pb2.PvpFightResponse()
    request.ParseFromString(data)
    line_up = request.lineup
    skill = request.skill

    if player.base_info.is_firstday_from_register(const.OPEN_FEATURE_GGZJ):
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

    def settle(player, fight_result):
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

        response.res.result = True
        logger.debug("red_units: %s" % response.red)
        return response.SerializeToString()

    return pvp_fight(player, target_id, line_up, skill, response,
                     settle, is_copy_unit=True)


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
    vip_level = player.base_info.vip_level
    reset_times_max = game_configs.vip_config.get(vip_level).get('buyArenaTimes')
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

    response.res.result = True
    return response.SerializePartialToString()


def random_buf(buff):
    wights = 0
    for v in buff.values():
        wights += v[1]

    _rand_num = random.randint(0, wights)
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

    print player.pvp.pvp_overcome_buff_init
    for star, _, bt, vt, value in player.pvp.pvp_overcome_buff_init[request.index]:
        res_buff = response.buff.add()
        res_buff.index = request.index
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

    star, _, bt, vt, value = player.pvp.pvp_overcome_buff_init[request.index][request.num]
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
    for k, v in player.pvp.pvp_overcome_buff.items():
        res_buff = response.buff.add()
        res_buff.index = k
        bt, vt, value = v
        res_buff.buff_type = bt
        res_buff.value_type = vt
        res_buff.value = value

    return response.SerializePartialToString()

# -*- coding:utf-8 -*-
"""
created by sphinx on 27/10/14.
"""
import cPickle
import time
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
from app.game.component.achievement.user_achievement import CountEvent
from app.game.component.achievement.user_achievement import EventType
from gfirefly.server.globalobject import GlobalObject
from app.game.core.lively import task_status
from app.game.action.node._fight_start_logic import pvp_assemble_units
from app.game.action.node._fight_start_logic import pvp_process
from app.game.action.node._fight_start_logic import get_seeds
from app.game.core.item_group_helper import is_afford
from app.game.core.item_group_helper import consume, get_consume_gold_num
from app.proto_file.shop_pb2 import ShopResponse
from app.proto_file.common_pb2 import CommonResponse
from app.game.core.mail_helper import send_mail
from app.game.redis_mode import tb_character_info, tb_pvp_rank
from app.game.action.node._fight_start_logic import save_line_up_order

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
    response.hero_ids.extend([_ for _ in data['hero_ids'] if _])
    response.hero_levels.extend([_ for _ in data['hero_levels']])
    response.head_no = data.get('head_no', 0)
    response.character_id = data.get('character_id')


@remoteserviceHandle('gate')
def pvp_top_rank_request_1501(data, player):
    response = pvp_rank_pb2.PlayerRankResponse()

    records = tb_pvp_rank.zrangebyscore(1, 10, withscores=True)
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

    rank = tb_pvp_rank.zscore(player.base_info.id)
    response.player_rank = int(rank) if rank else -1
    response.pvp_score = player.finance[const.PVP]

    player_ranks = player.pvp.pvp_arena_players

    records = tb_pvp_rank.zrangebyscore(min(player_ranks), max(player_ranks),
                                        withscores=True)

    # print records, rank
    for char_id, rank in records:
        char_id = int(char_id)
        rank = int(rank)
        if rank not in player_ranks:
            continue
        rank_item = response.rank_items.add()
        rank_item.rank = rank
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
    keys = ['level',
            'attackPoint',
            'best_skill',
            'unpars',
            'current_unpar',
            'copy_units']
    char_obj = tb_character_info.getObj(character_id)
    if char_obj.exists():
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
        return pvp_data

    return {}


def pvp_fight(player, character_id, line_up, skill, response, callback):
    record = get_pvp_data(character_id)
    if not record:
        logger.error('player id is not found:%s', character_id)
        response.res.result = False
        response.res.result_no = 150001
        return response.SerializePartialToString()

    best_skill, skill_level = player.line_up_component.get_skill_info_by_unpar(skill)
    logger.debug("best_skill=================== %s" % best_skill)

    blue_units = record.get('copy_units')
    save_line_up_order(line_up, player, skill)
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
    player.pvp.check_time()

    if player.pvp.pvp_times <= 0:
        logger.error('not enough pvp times:%s-%s', player.pvp.pvp_times,
                     game_configs.base_config.get('arena_free_times'))
        response.res.result = False
        response.res.result_no = 836
        return response.SerializeToString()

    line_up = request.lineup
    skill = request.skill
    target_id = tb_pvp_rank.zrangebyscore(request.challenge_rank,
                                          request.challenge_rank)[0]

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

    if before_player_rank == request.challenge_rank:
        logger.error('cant not fight self')
        response.res.result = False
        response.res.result_no = 1505
        return response.SerializeToString()

    def settle(player, fight_result):
        rank_incr = 0
        response.top_rank = player.pvp.pvp_high_rank
        if fight_result:
            logger.debug("fight result:True:%s:%s",
                         before_player_rank, request.challenge_rank)
            player.pvp.pvp_player_rank_refresh()

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
                remote_gate.add_push_message_remote(player.base_info.id, 3,
                                                    message, int(time.time()))

            push_message('add_blacklist_request_remote', target_id,
                         player.base_info.id)

            if request.challenge_rank < before_player_rank:
                tb_pvp_rank.zadd(request.challenge_rank, player.base_info.id,
                                 before_player_rank, target_id)

            if request.challenge_rank < player.pvp.pvp_high_rank:
                rank_incr = player.pvp.pvp_high_rank - request.challenge_rank
            player.pvp.pvp_high_rank = min(player.pvp.pvp_high_rank,
                                           request.challenge_rank)

            # 首次达到某名次的奖励
            arena_rank_up_rewards = game_configs.base_config.get('arenaRankUpRewards')
            if arena_rank_up_rewards:
                return_data = gain(player, arena_rank_up_rewards,
                                   const.ARENA_WIN, multiple=rank_incr)
                get_return(player, return_data, response.award)
            else:
                logger.debug('arena rank up points is not find')

            send_mail(conf_id=123, receive_id=target_id,
                      pvp_rank=before_player_rank,
                      nickname=player.base_info.base_name)
            player.pvp.pvp_times -= 1
            player.pvp.pvp_refresh_time = time.time()
        else:
            logger.debug("fight result:False")
            send_mail(conf_id=124, receive_id=target_id,
                      nickname=player.base_info.base_name)

        lively_event = CountEvent.create_event(EventType.SPORTS, 1, ifadd=True)
        tstatus = player.tasks.check_inter(lively_event)
        player.tasks.save_data()
        if tstatus:
            task_data = task_status(player)
            remote_gate.push_object_remote(1234, task_data,
                                           [player.dynamic_id])

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

    if player.base_info.is_firstday_from_register():
        response.res.result = False
        response.res.result_no = 150801
        return response.SerializeToString()

    if request.index != player.pvp.pvp_overcome_current:
        logger.error('overcome index is error:%s', request.index)
        response.res.result = False
        response.res.result_no = 150801
        return response.SerializePartialToString()

    target_id = player.pvp.get_overcome_id(request.index)
    if not target_id:
        logger.error('overcome index is not exist:%s', request.index)
        response.res.result = False
        response.res.result_no = 150802
        return response.SerializePartialToString()

    def settle(player, fight_result):
        logger.debug("fight revenge result:%s" % fight_result)

        if fight_result:
            player.pvp.pvp_overcome_current += 1
            player.pvp.save_data()

            overcome_rewards = game_configs.base_config.get('ggzjReward')
            if request.index not in overcome_rewards:
                logger.error('overcome reward is not exist:%s', request.index)
                response.res.result = False
                response.res.result_no = 150803
                return response.SerializePartialToString()

            overcome_reward = overcome_rewards[request.index]
            return_data = gain(player, overcome_reward, const.PVP_OVERCOME)
            get_return(player, return_data, response.gain)

        response.res.result = True
        logger.debug("red_units: %s" % response.red)
        return response.SerializeToString()

    return pvp_fight(player, target_id, line_up, skill, response, settle)


@remoteserviceHandle('gate')
def reset_overcome_time_1509(data, player):
    request = pvp_rank_pb2.ResetPvpOvercomeTime()
    request.ParseFromString(data)
    response = CommonResponse()

    if player.base_info.is_firstday_from_register():
        response.result = False
        response.result_no = 150901
        return response.SerializeToString()

    response.result = player.pvp.reset_time()
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

    need_gold = get_consume_gold_num(_consume)

    def func():
        return_data = consume(player, _consume)  # 消耗
        get_return(player, return_data, response.consume)
        player.pvp.pvp_times += request.times
        player.pvp.pvp_refresh_time = time.time()
        player.pvp.pvp_refresh_count += request.times
        player.pvp.save_data()
    player.pay.pay(need_gold, func)

    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def pvp_award_remote(pvp_num, is_online, player):
    player.finance[const.PVP] += pvp_num
    player.finance.save_data()
    logger.debug('pvp award!play:%s,%s-%s:on:%s', player.character_id,
                 pvp_num, player.finance[const.PVP], is_online)
    return True

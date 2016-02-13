# !/usr/bin/env python
# -*- coding: utf-8 -*-

from gfirefly.server.globalobject import remoteserviceHandle, GlobalObject
from app.proto_file import world_boss_pb2
from gfirefly.server.logobj import logger
from app.proto_file.world_boss_pb2 import PvbFightResponse, PvbBeforeInfoResponse, EncourageHerosRequest, \
    PvbPlayerInfoRequest, PvbRequest, PvbAwardResponse
from app.proto_file.common_pb2 import CommonResponse
from app.proto_file.db_pb2 import WorldBossAwardDB
from app.game.action.node.line_up import line_up_info
import cPickle
from shared.utils.date_util import get_current_timestamp
from app.game.action.node._fight_start_logic import pve_process, pvp_assemble_units
from shared.db_opear.configs_data import game_configs
from app.game.core.drop_bag import BigBag
from app.game.core.item_group_helper import gain, get_return
from shared.utils.const import const
from random import randint
from shared.utils.random_pick import random_pick_with_percent
from app.game.core.task import hook_task, CONDITIONId, update_condition
from shared.tlog import tlog_action

# from app.proto_file import world_boss_pb2

remote_gate = GlobalObject().remote.get('gate')


@remoteserviceHandle('gate')
def get_before_fight_1701(data, player):
    return get_fight_info(data, player)


@remoteserviceHandle('gate')
def get_after_fight_1706(data, player):
    return get_fight_info(data, player)


def get_fight_info(data, player):
    """
    获取世界boss开战前的信息：
    1. 关卡id
    2. 是否开启
    未开启:
    1. 幸运武将
    2. 奇遇
    3. 伤害排名前十的玩家
    4. 最后击杀boss的玩家
    已开启:
    1. 剩余血量
    2. 鼓舞次数
    """
    request = PvbRequest()
    request.ParseFromString(data)
    print "pvb request:", request
    boss_id = request.boss_id
    print "pvb request:", request, boss_id

    world_data = remote_gate['world'].pvb_get_before_fight_info_remote(player.base_info.id, boss_id)
    response = PvbBeforeInfoResponse()
    response.ParseFromString(world_data)

    boss = player.world_boss.get_boss(boss_id)
    boss.stage_id = response.stage_id

    boss.reset_info()  # 重设信息

    response.encourage_coin_num = boss.encourage_coin_num
    response.encourage_gold_num = boss.encourage_gold_num
    logger.debug("encourage_coin_num %s" % boss.encourage_coin_num)
    logger.debug("encourage_gold_num %s" % boss.encourage_gold_num)
    response.fight_times = boss.fight_times
    response.last_fight_time = int(boss.last_fight_time)
    response.gold_reborn_times = boss.gold_reborn_times
    response.last_coin_encourage_time = int(boss.last_coin_encourage_time)
    logger.debug("gold_reborn_times %s " % response.gold_reborn_times)
    # 奇遇
    if boss.fight_times not in boss.debuff_skill:
        debuff_skill = game_configs.base_config.get("world_boss").get("debuff_skill")
        debuff_skill_no = random_pick_with_percent(debuff_skill)
        boss.debuff_skill = {boss.fight_times: debuff_skill_no}
        logger.debug("debuff_skill %s, debuff_skill_no %s" % (debuff_skill, debuff_skill_no))
    response.debuff_skill_no = boss.debuff_skill_no
    player.world_boss.save_data()
    # logger.debug("response %s" % response)
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def get_player_info_1702(data, player):
    """
    根据玩家排名，查看排行榜内的玩家信息。
    """
    request = PvbPlayerInfoRequest()
    request.ParseFromString(data)
    boss_id = request.boss_id

    line_up_info = remote_gate['world'].pvb_player_info_remote(request.rank_no, boss_id)
    return line_up_info


@remoteserviceHandle('gate')
def encourage_heros_1703(data, player):
    """
    使用金币或者元宝鼓舞士气。
    """
    # 1. 校验金币或者元宝
    # 3. 减少金币
    # 4. 更新战斗力
    response = CommonResponse()

    request = EncourageHerosRequest()
    request.ParseFromString(data)
    boss_id = request.boss_id
    boss = player.world_boss.get_boss(boss_id)
    base_config = boss.get_base_config()

    times= 0
    if request.finance_type == 1:
        # 金币鼓舞
        goldcoin_inspire_price = base_config.get("coin_inspire_price")
        goldcoin_inspire_price_multiple = base_config.get("coin_inspire_price_multi")
        goldcoinInspireLimited = base_config.get("coin_inspire_limit")
        goldcoin_inspire_CD = base_config.get("coin_inspire_cd")
        if get_current_timestamp() - boss.last_coin_encourage_time < goldcoin_inspire_CD:
            logger.debug("coin encourage CD not enough %s, %s" % (boss.last_coin_encourage_time, goldcoin_inspire_CD))
            response.result = False
            response.result_no = 1704
            logger.debug("*" * 80)
            print response
            return response.SerializePartialToString()

        if boss.encourage_coin_num >= goldcoinInspireLimited:
            logger.debug("coin encourage too many times %s, %s" % (boss.encourage_coin_num, goldcoinInspireLimited))
            response.result = False
            response.result_no = 1703
            logger.debug("*" * 80)
            print response
            return response.SerializePartialToString()

        coin = player.finance.coin
        need_coin = goldcoin_inspire_price * (
            pow(goldcoin_inspire_price_multiple, boss.encourage_coin_num))
        if coin < need_coin:
            response.result = False
            response.result_no = 101
            logger.debug("*" * 80)
            print response
            return response.SerializePartialToString()

        player.finance.coin -= need_coin
        player.finance.save_data()
        boss.encourage_coin_num += 1
        times = boss.encourage_coin_num
        boss.last_coin_encourage_time = get_current_timestamp()

    if request.finance_type == 2:
        # 钻石鼓舞
        money_inspire_price = base_config.get("gold_inspire_price")
        moneyInspireLimited = base_config.get("gold_inspire_limit")
        #money_inspire_price_multiple = base_config.get("money_inspire_price_multiple")
        if boss.encourage_gold_num >= moneyInspireLimited:
            logger.error("gold encourage too many times %s, %s" % (boss.encourage_gold_num, moneyInspireLimited))
            response.result = False
            response.result_no = 1704
            logger.debug("*" * 80)
            print response
            return response.SerializePartialToString()
        gold = player.finance.gold
        need_gold = money_inspire_price
        if gold < need_gold:
            response.result = False
            response.result_no = 102
            logger.debug("*" * 80)
            print response
            return response.SerializePartialToString()
        def func():
            boss.encourage_gold_num += 1
        times = boss.encourage_gold_num
        player.pay.pay(need_gold, const.ENCOURAGE_HEROS, func)

    tlog_action.log('WorldBossEncourage', player, request.finance_type, times)
    player.world_boss.save_data()
    response.result = True
    logger.debug("encourage_coin_num %s" % boss.encourage_coin_num)
    logger.debug("encourage_gold_num %s" % boss.encourage_gold_num)
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def pvb_reborn_1704(data, player):
    """
    使用元宝复活。
    """
    request = PvbRequest()
    request.ParseFromString(data)
    boss_id = request.boss_id
    boss = player.world_boss.get_boss(boss_id)
    base_config = boss.get_base_config()

    response = CommonResponse()
    gold = player.finance.gold

    money_relive_price = base_config.get('gold_relive_price')
    need_gold = money_relive_price[-1] if boss.gold_reborn_times >= len(money_relive_price) else money_relive_price[boss.gold_reborn_times]
    current_time = get_current_timestamp()

    not_free = current_time - boss.last_fight_time < base_config.get("free_relive_time")
    if not_free and gold < need_gold:
        logger.debug("reborn CD error: %s" % 1701)
        response.result = False
        response.result_no = 1701
        return response.SerializePartialToString()

    if not_free and need_gold == -1:
        logger.debug("reborn times max : %s" % 1702)
        response.result = False
        response.result_no = 1702

    if not_free:
        def func():
            boss.last_fight_time = 0
            boss.gold_reborn_times += 1
            player.world_boss.save_data()
        player.pay.pay(need_gold, const.PVB_REBORN, func)
    response.result = True
    print response
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def pvb_fight_start_1705(pro_data, player):
    """开始战斗
    """
    logger.debug("fight start..")
    request = world_boss_pb2.PvbStartRequest()
    request.ParseFromString(pro_data)

    best_skill_id = request.unparalleled  # 无双编号
    line_up = request.lineup
    boss_id = request.boss_id
    boss = player.world_boss.get_boss(boss_id)
    base_config = boss.get_base_config()
    debuff_skill_no = boss.debuff_skill_no

    response = PvbFightResponse()
    res = response.res

    if player.base_info.is_firstday_from_register(const.OPEN_FEATURE_WORLD_BOSS):
        response.res.result = False
        response.res.result_no = 150901
        return response.SerializeToString()

    stage_id = boss.stage_id
    logger.debug("stage_id,%s" % stage_id)
    WORLD_BOSS = 7
    stage_info = pve_process(stage_id, WORLD_BOSS, line_up, 0, player)
    result = stage_info.get('result')

    res.result = result
    if stage_info.get('result_no'):
        res.result_no = stage_info.get('result_no')

    if not result:
        logger.info('进入关卡返回数据:%s', response)
        return response.SerializePartialToString(), stage_id

    red_units = stage_info.get('red_units')
    blue_units = stage_info.get('blue_units')

    blue_units = blue_units[0]
    blue_units[5].hp = remote_gate['world'].get_hp_left_remote(boss_id)
    logger.debug("blue_units===========%s" % blue_units[5].hp)
    logger.debug("--" * 40)

    if blue_units[5].hp <= 0:
        logger.debug("world boss already dead!")
        response.res.result = False
        response.res.result_no = 1705
        return response.SerializePartialToString()

    # 根据鼓舞次数，增加伤害百分比
    damage_rate = boss.encourage_coin_num * base_config.get("coin_inspire_atk", 0) + \
               boss.encourage_gold_num * base_config.get("gold_inspire_atk", 0)


    # mock fight.
    player_info = {}
    player_info["player_id"] = player.base_info.id
    player_info["vip_level"] = player.base_info.vip_level
    player_info["now_head"] = player.base_info.heads.now_head
    player_info["nickname"] = player.base_info.base_name
    player_info["level"] = player.base_info.level
    player_info["line_up_info"] = line_up_info(player).SerializePartialToString()

    str_red_units = cPickle.dumps(red_units)
    str_blue_units = cPickle.dumps(blue_units)
    logger.debug("--" * 40)
    print red_units
    print blue_units
    #red_best_skill_no, red_best_skill_level = player.line_up_component.get_skill_info_by_unpar(best_skill_id)

    seed1, seed2 = get_seeds()
    #def pvb_fight_remote(str_red_units, red_best_skill, red_best_skill_level, str_blue_units, player_info, boss_id, seed1, seed2):
    red_unpar_data = player.line_up_component.get_red_unpar_data()
    result, demage_hp = remote_gate['world'].pvb_fight_remote(str_red_units,
                    red_unpar_data, str_blue_units, player_info, boss_id, damage_rate, debuff_skill_no, seed1, seed2)

    if result == -1:
        logger.debug("world boss already gone!")
        response.res.result = False
        response.res.result_no = 1706
        return response.SerializePartialToString()

    response.fight_result = result

    # 玩家信息更新
    boss.fight_times += 1
    boss.demages.append(demage_hp)
    boss.last_fight_time = get_current_timestamp()
    player.world_boss.save_data()

    logger.debug("fight end..")

    pvp_assemble_units(red_units, blue_units, response)
    response.red_best_skill= best_skill_id
    response.red_best_skill_level = 0
    response.debuff_skill_no = debuff_skill_no
    response.seed1 = seed1
    response.seed2 = seed2
    response.damage_rate = damage_rate
    if boss_id == 'world_boss':
        hook_task(player, CONDITIONId.PVBOSS_TIMES, 1)

    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def boss_task_remote(num, is_online, player):
    if is_online:
        hook_task(player, CONDITIONId.PVBOSS, num)
    else:
        update_condition(player, CONDITIONId.PVBOSS, num)
    return True


@remoteserviceHandle('gate')
def receive_pvb_award_remote(pvb_award_data, is_online, player):
    pvb_award = WorldBossAwardDB()
    pvb_award.ParseFromString(pvb_award_data)
    boss = player.world_boss.get_boss("world_boss")
    if pvb_award.award_type == const.PVB_IN_AWARD:
        boss.set_award(const.PVB_IN_AWARD, boss.demages, pvb_award.rank_no)
        boss.demages = []
        player.world_boss.save_data()
    else:
        boss.set_award(pvb_award.award_type, pvb_award.award, pvb_award.rank_no)
    player.world_boss.save_data()
    logger.debug("receive_pvb_award_remote=================%s" % pvb_award.award_type)
    return True


@remoteserviceHandle('gate')
def pvb_get_award_1708(data, player):
    response = PvbAwardResponse()
    boss = player.world_boss.get_boss("world_boss")
    award_type, award, rank_no, is_over = boss.get_award()
    player.world_boss.save_data()
    logger.debug("award_type %s, award %s, is_over %s" % (award_type, award, is_over))
    response.is_over = is_over
    if not award:
        response.SerializePartialToString()
    response.award_type = award_type # award_type
    if award_type == const.PVB_IN_AWARD:
        total_coin = 0
        total_soul = 0
        for demage_hp in award:
            all_vars = dict(damage=demage_hp)
            coin_world_boss_formula = game_configs.formula_config.get("coinWorldboss").get("formula")
            assert coin_world_boss_formula!=None, "isHit formula can not be None!"
            coin = eval(coin_world_boss_formula, all_vars)
            soul_world_boss_formula = game_configs.formula_config.get("soulWorldboss").get("formula")
            assert soul_world_boss_formula!=None, "isHit formula can not be None!"
            soul = eval(soul_world_boss_formula, all_vars)
            total_coin += int(coin)
            total_soul += int(soul)
            print("coin and soul" , coin, soul)

        change = response.gain.finance.finance_changes.add()
        change.item_type = 107
        change.item_num = int(total_coin)
        change.item_no = const.COIN
        change = response.gain.finance.finance_changes.add()
        change.item_type = 107
        change.item_num = int(total_soul)
        change.item_no = const.HERO_SOUL
    elif award_type != 0:
        bigbag = BigBag(award)
        drop_items = bigbag.get_drop_items()
        return_data = gain(player, drop_items, const.WORLD_BOSS_AWARD)
        get_return(player, return_data, response.gain)
    #response.rank_no = remote_gate['world'].get_rank_no_remote(player.base_info.id, "world_boss")
    response.rank_no = rank_no
    logger.debug("pvb_get_award_1708:%s" % response)
    return response.SerializePartialToString()

def get_seeds():
    seed1 = randint(1, 100)
    seed2 = randint(1, 100)
    return seed1, seed2

# !/usr/bin/env python
# -*- coding: utf-8 -*-

from gfirefly.server.globalobject import remoteserviceHandle, GlobalObject
from app.proto_file import world_boss_pb2
from gfirefly.server.logobj import logger
from app.proto_file.world_boss_pb2 import PvbFightResponse, PvbBeforeInfoResponse, EncourageHerosRequest, \
    PvbPlayerInfoRequest, PvbRequest
from app.proto_file.common_pb2 import CommonResponse
from app.game.action.node.line_up import line_up_info
import cPickle
from shared.utils.date_util import get_current_timestamp
from app.game.component.achievement.user_achievement import CountEvent,\
    EventType
from app.game.core.lively import task_status
from app.game.action.node._fight_start_logic import pve_process, pvp_assemble_units

# from app.proto_file import world_boss_pb2

remote_gate = GlobalObject().remote['gate']


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


    print response, "-"*80
    print boss.stage_id

    boss.reset_info()  # 重设信息

    player.world_boss.save_data()
    response.encourage_coin_num = boss.encourage_coin_num
    response.encourage_gold_num = boss.encourage_gold_num
    logger.debug("encourage_coin_num %s" % boss.encourage_coin_num)
    logger.debug("encourage_gold_num %s" % boss.encourage_gold_num)
    response.fight_times = boss.fight_times
    response.last_fight_time = int(boss.last_fight_time)
    print response
    print "*" * 80

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

    if request.finance_type == 1:
        # 金币鼓舞
        goldcoin_inspire_price = base_config.get("coin_inspire_price")
        goldcoin_inspire_price_multiple = base_config.get("coin_inspire_price_multi")
        goldcoinInspireLimited = base_config.get("goldcoinInspireLimited")

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

    if request.finance_type == 2:
        # 钻石鼓舞
        money_inspire_price = base_config.get("gold_inspire_price")
        moneyInspireLimited = base_config.get("moneyInspireLimited")
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
        player.finance.consume_gold(need_gold)
        player.finance.save_data()
        boss.encourage_gold_num += 1

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
    # 1. 校验元宝
    gold = player.finance.gold
    money_relive_price = base_config.get('gold_relive_price')
    need_gold = money_relive_price
    print need_gold, gold, "*"*80
    if gold < need_gold:
        logger.debug("reborn error: %s" % 102)
        response.result = False
        response.result_no = 102
        return response.SerializePartialToString()

    #2. 校验CD
    current_time = get_current_timestamp()
    if current_time - boss.last_fight_time > base_config.get("free_relive_time"):
        logger.debug("reborn error: %s" % 1701)
        response.result = False
        response.result_no = 1701
        return response.SerializePartialToString()

    player.finance.consume_gold(need_gold)
    player.finance.save_data()
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
    print request, "request"

    best_skill_id = request.unparalleled  # 无双编号
    line_up = request.lineup
    boss_id = request.boss_id
    boss = player.world_boss.get_boss(boss_id)
    base_config = boss.get_base_config()



    stage_id = boss.stage_id
    logger.debug("stage_id,%s" % stage_id)
    WORLD_BOSS = 5
    stage_info = pve_process(stage_id, WORLD_BOSS, line_up, 0, player, best_skill_id)
    result = stage_info.get('result')

    response = PvbFightResponse()

    res = response.res
    res.result = result
    if stage_info.get('result_no'):
        res.result_no = stage_info.get('result_no')

    if not result:
        logger.info('进入关卡返回数据:%s', response)
        return response.SerializePartialToString(), stage_id

    red_units = stage_info.get('red_units')
    blue_units = stage_info.get('blue_units')

    blue_units = blue_units[0]

    logger.debug("--" * 40)

    # 根据鼓舞次数，增加ATK百分比
    atk_rate = boss.encourage_coin_num * base_config.get("coin_inspire_atk", 0) + \
               boss.encourage_gold_num * base_config.get("gold_inspire_atk", 0)

    for slot_no, red_unit in red_units.items():
        red_unit.atk *= (1 + atk_rate)

    # mock fight.
    player_info = {}
    player_info["player_id"] = player.base_info.id
    player_info["nickname"] = player.base_info.base_name
    player_info["level"] = player.base_info.level
    player_info["line_up_info"] = line_up_info(player).SerializePartialToString()

    str_red_units = cPickle.dumps(red_units)
    str_blue_units = cPickle.dumps(blue_units)
    logger.debug("--" * 40)
    print red_units
    print blue_units
    result = remote_gate['world'].pvb_fight_remote(str_red_units,
                                                   best_skill_id, str_blue_units, player_info, boss_id)
    response.fight_result = result

    # 玩家信息更新
    boss.fight_times += 1
    boss.last_fight_time = get_current_timestamp()
    player.world_boss.save_data()

    logger.debug("fight end..")

    lively_event = CountEvent.create_event(EventType.BOSS, 1, ifadd=True)
    tstatus = player.tasks.check_inter(lively_event)
    if tstatus:
        task_data = task_status(player)
        remote_gate.push_object_remote(1234, task_data, [player.dynamic_id])

    pvp_assemble_units(red_units, blue_units, response)
    red_best_skill_no, red_best_skill_level = player.line_up_component.get_skill_info_by_unpar(best_skill_id)
    response.red_best_skill= best_skill_id
    response.red_best_skill_level = red_best_skill_level
    print response

    return response.SerializePartialToString()






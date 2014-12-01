# !/usr/bin/env python
# -*- coding: utf-8 -*-

from gfirefly.server.globalobject import remoteserviceHandle, GlobalObject
from app.proto_file import stage_request_pb2
from app.game.action.node.stage import assemble, fight_start
from gfirefly.server.logobj import logger
from app.proto_file.world_boss_pb2 import PvbFightResponse, PvbBeforeInfoResponse, EncourageHerosRequest, \
    PvbPlayerInfoRequest
from app.proto_file.common_pb2 import CommonResponse
from shared.db_opear.configs_data.game_configs import base_config
from app.game.action.node.line_up import line_up_info
import cPickle
from shared.utils.date_util import get_current_timestamp
from app.game.component.achievement.user_achievement import CountEvent,\
    EventType
from app.game.core.lively import task_status

# from app.proto_file import world_boss_pb2

remote_gate = GlobalObject().remote['gate']


@remoteserviceHandle('gate')
def get_before_fight_1701(data, player):
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
    world_data = remote_gate['world'].pvb_get_before_fight_info_remote(player.base_info.id)
    response = PvbBeforeInfoResponse()
    response.ParseFromString(world_data)
    player.world_boss.stage_id = response.stage_id
    player.world_boss.reset_info()  # 重设信息

    player.world_boss.save_data()
    response.encourage_coin_num = player.world_boss.encourage_coin_num
    response.encourage_gold_num = player.world_boss.encourage_gold_num
    logger.debug("encourage_coin_num %s" % player.world_boss.encourage_coin_num)
    logger.debug("encourage_gold_num %s" % player.world_boss.encourage_gold_num)
    response.fight_times = player.world_boss.fight_times
    response.last_fight_time = int(player.world_boss.last_fight_time)
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
    line_up_info = remote_gate['world'].pvb_player_info_remote(request.rank_no)
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

    if request.finance_type == 1:
        # 金币鼓舞
        goldcoin_inspire_price = base_config.get("goldcoin_inspire_price")
        goldcoin_inspire_price_multiple = base_config.get("goldcoin_inspire_price_multiple")
        coin = player.finance.coin
        need_coin = goldcoin_inspire_price * (
            pow(goldcoin_inspire_price_multiple, player.world_boss.encourage_coin_num))
        if coin < need_coin:
            response.result = False
            response.result_no = 101
            logger.debug("*" * 80)
            print response
            return response.SerializePartialToString()

        player.finance.coin -= need_coin
        player.finance.save_data()
        player.world_boss.encourage_coin_num += 1

    if request.finance_type == 2:
        # 钻石鼓舞
        money_inspire_price = base_config.get("money_inspire_price")
        #money_inspire_price_multiple = base_config.get("money_inspire_price_multiple")
        gold = player.finance.gold
        need_gold = money_inspire_price
        if gold < need_gold:
            response.result = False
            response.result_no = 102
            logger.debug("*" * 80)
            print response
            return response.SerializePartialToString()
        player.finance.gold -= need_gold
        player.finance.save_data()
        player.world_boss.encourage_gold_num += 1

    player.world_boss.save_data()
    response.result = True
    logger.debug("encourage_coin_num %s" % player.world_boss.encourage_coin_num)
    logger.debug("encourage_gold_num %s" % player.world_boss.encourage_gold_num)
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def pvb_reborn_1704(data, player):
    """
    使用元宝复活。
    """
    response = CommonResponse()
    # 1. 校验元宝
    gold = player.finance.gold
    money_relive_price = base_config.get('money_relive_price')
    need_gold = money_relive_price
    print need_gold, gold, "*"*80
    if gold < need_gold:
        logger.debug("reborn error: %s" % 102)
        response.result = False
        response.result_no = 102
        return response.SerializePartialToString()

    #2. 校验CD
    current_time = get_current_timestamp()
    if current_time - player.world_boss.last_fight_time > base_config.get("free_relive_time"):
        logger.debug("reborn error: %s" % 1701)
        response.result = False
        response.result_no = 1701
        return response.SerializePartialToString()

    player.finance.gold -= need_gold
    player.finance.save_data()
    response.result = True
    print response
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def pvb_fight_start_1705(pro_data, player):
    """开始战斗
    """
    logger.debug("fight start..")
    request = stage_request_pb2.StageStartRequest()
    request.ParseFromString(pro_data)

    stage_id = request.stage_id  # 关卡编号
    unparalleled = request.unparalleled  # 无双编号

    logger.debug("unparalleled,%s" % unparalleled)

    line_up = {}  # {hero_id:pos}
    for line in request.lineup:
        if not line.hero_id:
            continue
        line_up[line.hero_id] = line.pos

    stage_info = fight_start(stage_id, line_up, unparalleled, 0, player)
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

    logger.debug("--" * 40)

    # 根据鼓舞次数，增加ATK百分比
    atk_rate = player.world_boss.encourage_coin_num * base_config.get("worldbossInspireAtk", 0) + \
               player.world_boss.encourage_gold_num * base_config.get("worldbossInspireAtkMoney", 0)

    for slot_no, red_unit in red_units.items():
        red_unit.atk *= (1 + atk_rate)

    print red_units
    print blue_units
    for slot_no, red_unit in red_units.items():
        red_add = response.red.add()
        assemble(red_add, red_unit)

    blue_units = blue_units[0]
    for no, blue_unit in blue_units.items():
        blue_add = response.blue.add()
        assemble(blue_add, blue_unit)

    response.red_best_skill = unparalleled
    if unparalleled in player.line_up_component.unpars:
        response.red_best_skill_level = player.line_up_component.unpars[unparalleled]


    # mock fight.
    player_info = {}
    player_info["player_id"] = player.base_info.id
    player_info["nickname"] = player.base_info.base_name
    player_info["level"] = player.level.level
    player_info["line_up_info"] = line_up_info(player).SerializePartialToString()

    str_red_units = cPickle.dumps(red_units)
    str_blue_units = cPickle.dumps(blue_units)
    logger.debug("--" * 40)
    print red_units
    print blue_units
    result = remote_gate['world'].pvb_fight_remote(str_red_units,
                                                   unparalleled, str_blue_units, player_info)
    response.fight_result = result

    # 玩家信息更新
    player.world_boss.fight_times += 1
    player.world_boss.last_fight_time = get_current_timestamp()
    player.world_boss.save_data()

    print response
    logger.debug("fight end..")
    
    lively_event = CountEvent.create_event(EventType.WINE, 1, ifadd=True)
    tstatus = player.tasks.check_inter(lively_event)
    if tstatus:
        task_data = task_status(player)
        remote_gate.push_object_remote(1234, task_data, [player.dynamic_id])

    return response.SerializePartialToString()


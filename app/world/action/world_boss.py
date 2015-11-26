#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
created by wzp.
"""
from gfirefly.server.globalobject import rootserviceHandle
from app.proto_file import world_boss_pb2
from app.world.core.world_boss import world_boss
from app.world.core.mine_boss import mine_boss_manager
from app.battle.server_process import world_boss_start
import cPickle
from shared.utils.date_util import get_current_timestamp
from app.world.action.gateforwarding import push_all_object_message
from gfirefly.server.logobj import logger
from shared.db_opear.configs_data import game_configs
#from app.proto_file import line_up_pb2


@rootserviceHandle
def pvb_get_before_fight_info_remote(player_id, boss_id):
    """
    获取世界boss开战前的信息：
    1. 幸运武将
    2. 奇遇
    3. 伤害排名前十的玩家
    4. 最后击杀boss的玩家
    5. 关卡id
    """
    boss = get_boss(boss_id)
    print "boss ", boss
    logger.debug("stage id %s" % boss.stage_id)
    response = world_boss_pb2.PvbBeforeInfoResponse()

    if boss_id == "world_boss":
        for k, hero in boss.lucky_heros.items():
            hero_no = hero.get("hero_no")
            lucky_hero_info_id = hero.get("lucky_hero_info_id")
            logger.debug("lucky_hero_info_id %s" % lucky_hero_info_id)
            lucky_hero_info = game_configs.lucky_hero_config.get(lucky_hero_info_id)

            hero_pb = response.lucky_heros.add()
            hero_pb.hero_no = hero_no
            hero_pb.pos = lucky_hero_info.set
            for k, v in lucky_hero_info.get("attr").items():
                hero_attr = hero_pb.attr.add()
                hero_attr.attr_type = int(k)
                hero_attr.attr_value_type = v[0]
                hero_attr.attr_value = v[1]

    # 返回伤害前十名
    for k, rank_item in enumerate(boss.get_rank_items()):
        rank_item_pb = response.rank_items.add()
        update_rank_items(k+1, rank_item_pb, rank_item)

    # 最后击杀
    update_rank_items(-1, response.last_shot_item, boss.last_shot_item)

    # 关卡id
    response.stage_id = boss.stage_id
    # 是否开启
    response.open_or_not = boss.open_or_not
    # 剩余血量
    response.hp_left = int(boss.hp)
    # 最大血量
    response.hp_max = boss.get_hp()
    # 伤害
    response.demage_hp = int(boss.get_demage_hp(player_id))
    # 名次
    response.rank_no = boss.get_rank_no(player_id)

    return response.SerializeToString()

def update_rank_items(k, rank_item_pb, rank_item):
    rank_item_pb.nickname = rank_item.get("nickname", "")
    rank_item_pb.level = rank_item.get("level", 0)
    rank_item_pb.vip_level = rank_item.get("vip_level", 0)
    rank_item_pb.now_head = rank_item.get("now_head", 0) #rank_item.get("first_hero_no", 0)
    rank_item_pb.demage_hp = int(rank_item.get("demage_hp", 0))
    if rank_item.get("line_up_info"):
        ##rank_item_pb.line_up_info = line_up_pb2.LineUpResponse()
        rank_item_pb.line_up_info.ParseFromString(rank_item.get("line_up_info"))
        #line_up_info = line_up_pb2.LineUpResponse()
        #rank_item_pb.line_up_info.ParseFromString()
    rank_item_pb.player_id = rank_item.get("player_id", 0)
    rank_item_pb.rank_no = k
    logger.debug("player_id %s", rank_item_pb.player_id)
    logger.debug("rank_no %s", rank_item_pb.rank_no)
    logger.debug("demage_hp %s", rank_item_pb.demage_hp)


@rootserviceHandle
def pvb_fight_remote(str_red_units, red_unpar_data, str_blue_units, player_info, boss_id, damage_rate, debuff_skill_no, seed1, seed2):
    """
    战斗
    """
    boss = get_boss(boss_id)
    if not boss.open_or_not:
        return -1, 0
    red_units = cPickle.loads(str_red_units)
    blue_units = cPickle.loads(str_blue_units)
    res = world_boss_start(red_units,  blue_units, red_unpar_data, {}, debuff_skill_no, damage_rate, seed1, seed2, player_info.get("level"))
    result = res.get("result")
    hp_left = res.get("hp_left")

    # 保存worldboss数据
    boss.hp = hp_left

    # 保存排行和玩家信息
    demage_hp = blue_units.get(5).hp - hp_left # 伤害血量
    player_info["demage_hp"] = demage_hp
    boss.add_rank_item(player_info)

    # 如果赢了，保存最后击杀
    if result:
        boss.last_shot_item = player_info
        boss.boss_dead_time = get_current_timestamp()
        push_all_object_message(1790,"")

    boss.save_data()
    return result, demage_hp

@rootserviceHandle
def pvb_player_info_remote(no, boss_id):
    """
    获取玩家阵容信息
    no为玩家排名
    """
    boss = get_boss(boss_id)
    return boss.get_rank_item_by_rankno(no).get("line_up_info")

def get_boss(boss_id):
    """docstring for get_boss_id"""
    if boss_id == "world_boss":
        return world_boss
    else:
        return mine_boss_manager.get_current_boss()

@rootserviceHandle
def mine_get_boss_num_remote():
    return mine_boss_manager.get_boss_num()

@rootserviceHandle
def trigger_mine_boss_remote():
    """
    触发boss
    """
    if mine_boss_manager.get_boss_num() >= 1 or mine_boss_manager.current_has_boss():
        return False
    boss_name, boss = mine_boss_manager.add()
    response = world_boss_pb2.MineBossResponse()
    response.res.result = True
    response.boss_id = boss_name
    response.stage_id = boss.stage_id
    print response

    push_all_object_message(1707, response.SerializeToString())
    return True
@rootserviceHandle
def get_hp_left_remote(boss_id):
    """
    触发boss
    """
    boss = get_boss(boss_id)
    print("+++++++++")
    print(boss)
    return int(boss.hp)
@rootserviceHandle
def get_lucky_heros_remote():
    """
    触发boss
    """
    return cPickle.dumps(world_boss.lucky_heros)

@rootserviceHandle
def get_rank_no_remote(player_id, boss_id):
    """
    触发boss
    """
    boss = get_boss(boss_id)
    return boss.get_rank_no(player_id)

@rootserviceHandle
def get_debuff_skill_no_remote(boss_id):
    """
    奇遇
    """
    boss = get_boss(boss_id)
    return boss.debuff_skill_no

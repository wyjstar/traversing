# -*- coding:utf-8 -*-
"""
created by server on 14-8-12下午2:17.
"""
from gfirefly.server.globalobject import remoteserviceHandle
from shared.db_opear.configs_data import game_configs
from gfirefly.server.globalobject import GlobalObject
from app.proto_file import guild_pb2
from gfirefly.server.logobj import logger
from app.game.core.item_group_helper import gain, get_return, is_afford, consume
from shared.utils.const import const
from app.game.action.node._fight_start_logic import pvp_assemble_units
from app.game.action.node._fight_start_logic import get_seeds
from shared.utils.date_util import get_current_timestamp
import cPickle

remote_gate = GlobalObject().remote.get('gate')


@remoteserviceHandle('gate')
def init_2401(pro_data, player):
    """获取guild_boss信息
    """
    response = guild_pb2.GuildBossInitResponse()
    data = remote_gate['world'].guild_boss_init_remote(player.guild.g_id)
    logger.debug("return data %s" % data)
    response.trigger_times = data.get("guild_boss_trigger_times", 0)
    for skill_type, skill_level in data.get("guild_skills", {}).items():
        skill_pb = response.guild_skill.add()
        skill_pb.skill_type = skill_type
        skill_pb.skill_level = skill_level
    construct_boss_pb(data.get("guild_boss"), response.guild_boss)
    response.last_attack_time = player.guild.guild_boss_last_attack_time

    logger.debug("response %s" % response)
    return response.SerializeToString()


def construct_boss_pb(data, boss_pb):
    """docstring for construct_boss_pb"""
    boss_pb.stage_id = data.get("stage_id")
    boss_pb.trigger_time = data.get("trigger_time", 0)
    boss_pb.hp_max = data.get("hp_max", 0)
    boss_pb.hp_left = data.get("hp_left", 0)
    boss_pb.boss_type = data.get("boss_type", 0)
    boss_pb.player_id = data.get("trigger_player_id", 0)
    boss_pb.player_name = data.get("trigger_player_name", "")

@remoteserviceHandle('gate')
def trigger_boss_2402(pro_data, player):
    """召唤圣兽
    """
    request = guild_pb2.TriggerGuildBossRequest()
    request.ParseFromString(pro_data)
    logger.debug("request %s" % request)
    boss_type = request.boss_type
    trigger_stone_num = 0
    item = player.item_package.get_item(140001)
    if item: trigger_stone_num = item.num
    response = guild_pb2.TriggerGuildBossResponse()
    response.res.result = False

    data = remote_gate['world'].guild_boss_init_remote(player.guild.g_id)
    build = data.get("build")
    guild_boss_trigger_times = data.get("guild_boss_trigger_times")
    guild_boss_item = game_configs.guild_config.get(4).get(build.get(4))
    logger.debug("guild_boss_item %s" % guild_boss_item)
    boss_open_item = guild_boss_item.animalOpen.get(boss_type)
    stage_id = boss_open_item[0]
    consume_num = boss_open_item[2]

    # 召唤石是否足够
    if trigger_stone_num < boss_open_item[2]:
        logger.debug("trigger stone is not enough!")
        response.res.result_no = 240201
        return response.SerializeToString()
    # 召唤次数是否达到上限
    if guild_boss_trigger_times >= guild_boss_item.animalOpenTime:
        logger.debug("trigger times reach the max!")
        response.res.result_no = 240202
        return response.SerializeToString()

    # 军团等级是否满足此类型boss
    if not boss_open_item[1]:
        logger.debug("guild level is not enough!")
        response.res.result_no = 240204
        return response.SerializeToString()

    res = remote_gate['world'].guild_boss_add_remote(player.guild.g_id, stage_id, boss_type, player.base_info.id, player.base_info.base_name)
    response.res.result = res.get("result")
    if not res.get("result"):
        response.res.result_no = res.get("result_no")
        return response.SerializeToString()

    player.item_package.consume_item(140001, consume_num)

    return_data = [[const.ITEM, consume_num, 140001]]
    logger.debug(return_data)
    get_return(player, return_data, response.consume)

    construct_boss_pb(res.get("guild_boss"), response.guild_boss)
    logger.debug("response %s" % response)
    return response.SerializeToString()


@remoteserviceHandle('gate')
def battle_2403(pro_data, player):
    """
    开始战斗
    """
    request = guild_pb2.GuildBossBattleRequest()
    request.ParseFromString(pro_data)
    logger.debug("request %s" % request)
    response = guild_pb2.GuildBossBattleResponse()
    stage_id = request.stage_id

    coolingTime = game_configs.base_config.get("AnimalCoolingTime")
    # 冷却时间
    if player.guild.guild_boss_last_attack_time + coolingTime >= get_current_timestamp():
        logger.error("attack still in colding time!")
        response.res.result = False
        response.res.result_no = 240301
        return response.SerializePartialToString()


    line_up = player.line_up_component
    player.fight_cache_component.stage_id = stage_id
    red_units = player.fight_cache_component.get_red_units()
    str_red_units = cPickle.dumps(red_units)
    seed1, seed2 = get_seeds()
    unpar_type = line_up.unpar_type
    unpar_other_id = line_up.unpar_other_id
    res = remote_gate['world'].guild_boss_battle_remote(player.guild.g_id, str_red_units, unpar_type, unpar_other_id, seed1, seed2)
    boss_info = res.get("guild_boss")
    blue_units = cPickle.loads(boss_info.get("blue_units"))
    pvp_assemble_units(red_units, blue_units, response)

    fight_result = res.get("fight_result")
    stage_item = game_configs.special_stage_config.get("guild_boss_stages").get(stage_id)
    return_data = gain(player,stage_item.Animal_Participate, const.GUILD_BOSS_IN)
    get_return(player, return_data, response.gain)

    if fight_result:
        return_data = gain(player,stage_item.Animal_Kill, const.GUILD_BOSS_KILL)
        get_return(player, return_data, response.gain)
        player.guild.guild_boss_last_attack_time = 0
    player.guild.guild_boss_last_attack_time = int(get_current_timestamp())
    player.guild.save_data()

    response.seed1 = seed1
    response.seed2 = seed2

    response.res.result = res.get("result")
    if not res.get("result"):
        response.res.result_no = res.get("result_no")
        return response.SerializePartialToString()

    logger.debug("response %s" % response)
    return response.SerializePartialToString()

@remoteserviceHandle('gate')
def upgrade_guild_skill_2404(pro_data, player):
    """
    升级军团技能
    """
    request = guild_pb2.UpGuildSkillRequest()
    request.ParseFromString(pro_data)
    logger.debug("request %s" % request)
    response = guild_pb2.UpGuildSkillResponse()
    logger.debug("request %s" % request)
    skill_type = request.skill_type
    data = remote_gate['world'].guild_boss_init_remote(player.guild.g_id)
    guild_skills = data.get("guild_skills")
    build = data.get("build")
    logger.debug("guild_skill_config %s" % game_configs.guild_skill_config.get(skill_type))
    # check
    guild_skill_item = game_configs.guild_skill_config.get(skill_type).get(guild_skills.get(skill_type))
    response.res.result = False
    if not is_afford(player, guild_skill_item.Consume):
        logger.debug("consume not enough!")
        response.res.result_no = 24041
        return response.SerializeToString()

    for condition2 in guild_skill_item.Skill_condition[2]:
        tmp_guild_skill_item = game_configs.guild_skill_config.get(condition2)
        _skill_type = tmp_guild_skill_item.type
        skill_level = tmp_guild_skill_item.Skill_level
        if skill_level > guild_skills[_skill_type]:
            logger.debug("skill level conidtion not enough!")
            response.res.result_no = 24042
            return response.SerializeToString()

    for condition1 in guild_skill_item.Skill_condition[1]:
        tmp_guild_item = game_configs.guild_config.get(condition1)
        guild_type = tmp_guild_item.type
        guild_level = tmp_guild_item.level
        if guild_level > build[guild_type]:
            logger.debug("guild build level not enough!")
            response.res.result_no = 24043
            return response.SerializeToString()

    res = remote_gate['world'].upgrade_guild_skill_remote(player.guild.g_id, skill_type, guild_skills.get(skill_type)+1)
    if res.get("result"):
        # consume
        return_data = consume(player, guild_skill_item.Consume, const.UPGRADE_GUILD_SKILL)
        get_return(player, return_data, response.consume)

    response.res.result = res.get("result")
    logger.debug("response %s" % response)
    return response.SerializeToString()

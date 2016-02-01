# -*- coding:utf-8 -*-
"""
created by server on 14-8-12下午2:17.
"""
from gfirefly.server.globalobject import remoteserviceHandle
from shared.db_opear.configs_data import game_configs
from gfirefly.server.globalobject import GlobalObject
from app.proto_file import guild_pb2
from gfirefly.server.logobj import logger
from app.game.core.item_group_helper import gain, get_return, is_afford
from shared.utils.const import const
from app.game.action.node._fight_start_logic import pvp_assemble_units
from app.game.action.node._fight_start_logic import get_seeds
from shared.utils.date_util import get_current_timestamp, is_in_period
import cPickle
from app.game.core.task import hook_task, CONDITIONId
from shared.tlog import tlog_action

remote_gate = GlobalObject().remote.get('gate')


@remoteserviceHandle('gate')
def init_2401(pro_data, player):
    """获取guild_boss信息
    """
    return construct_init_data(player)

def construct_init_data(player):
    response = guild_pb2.GuildBossInitResponse()
    """docstring for construct_init_boss"""
    res = remote_gate['world'].guild_boss_init_remote(player.guild.g_id)
    response.res.result = res.get("result")
    logger.debug("return res %s" % res)

    if not res.get("result"):
        logger.error("guild boss init error!")
        response.res.result_no = res.get("result_no")
        return response.SerializeToString()

    response.trigger_times = res.get("guild_boss_trigger_times", 0)
    construct_boss_pb(res.get("guild_boss"), response.guild_boss)
    last_attack_time = player.guild.guild_boss_last_attack_time
    if res.get("guild_boss").get("boss_id") != last_attack_time.get("boss_id"):
            last_attack_time["boss_id"] = res.get("guild_boss").get("boss_id")
            last_attack_time["time"] = 0
    response.last_attack_time = last_attack_time.get("time")
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
    guild_boss_open_time_item = game_configs.base_config.get("AnimalOpenTime")
    response = guild_pb2.TriggerGuildBossResponse()
    response.res.result = False
    if not is_in_period(guild_boss_open_time_item):
        logger.debug("feature not open!")
        response.res.result_no = 30000
        return response.SerializeToString()

    request = guild_pb2.TriggerGuildBossRequest()
    request.ParseFromString(pro_data)
    logger.debug("request %s" % request)
    boss_type = request.boss_type
    trigger_stone_num = player.finance[const.GUILD_BOSS_TRIGGER_STONE]

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

    player.finance.consume(const.GUILD_BOSS_TRIGGER_STONE, consume_num, 0)

    return_data = [[const.RESOURCE, consume_num, 15]]
    logger.debug(return_data)
    get_return(player, return_data, response.consume)
    player.guild.guild_boss_last_attack_time["boss_id"] = res.get("guild_boss").get("boss_id")
    player.guild.guild_boss_last_attack_time["time"] = 0
    logger.debug("guild_boss_last_attack_time %s " % (player.guild.guild_boss_last_attack_time))
    construct_boss_pb(res.get("guild_boss"), response.guild_boss)
    logger.debug("response %s" % response)

    remote_gate.push_object_character_remote(24021, construct_init_data(player), player.guild.get_guild_member_ids(res.get("p_list", {})))
    # add guild activity times
    player.guild_activity.add_guild_boss_times(res.get("guild_boss").get("boss_type"))
    player.act.add_guild_boss_times(res.get("guild_boss").get("boss_type"))
    hook_task(player, CONDITIONId.GUILD_BOSS, 1)
    tlog_action.log('TriggerBoss', player, player.guild.g_id, boss_type)

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
    if player.guild.guild_boss_last_attack_time.get("time") + coolingTime >= get_current_timestamp():
        logger.error("attack still in colding time!")
        response.res.result = False
        response.res.result_no = 240301
        return response.SerializePartialToString()

    data = remote_gate['world'].guild_boss_init_remote(player.guild.g_id)
    logger.debug("return data %s" % data)
    boss_info = data.get("guild_boss")

    line_up = player.line_up_component
    player.fight_cache_component.stage_id = stage_id
    red_units = player.fight_cache_component.get_red_units()
    str_red_units = cPickle.dumps(red_units)
    seed1, seed2 = get_seeds()
    red_unpar_data = line_up.get_red_unpar_data()
    res = remote_gate['world'].guild_boss_battle_remote(player.guild.g_id, str_red_units, red_unpar_data, seed1, seed2)
    #boss_info = res.get("guild_boss")
    blue_units = cPickle.loads(boss_info.get("blue_units"))
    pvp_assemble_units(red_units, blue_units, response)

    fight_result = res.get("fight_result")
    stage_item = game_configs.special_stage_config.get("guild_boss_stages").get(stage_id)
    return_data = gain(player,stage_item.Animal_Participate, const.GUILD_BOSS_IN)
    get_return(player, return_data, response.gain)

    response.fight_result = fight_result
    if fight_result:
        player.guild.guild_boss_last_attack_time["time"] = 0
    player.guild.guild_boss_last_attack_time["time"] = int(get_current_timestamp())
    player.guild.save_data()

    response.seed1 = seed1
    response.seed2 = seed2
    response.guild_skill_point = res.get('guild_skill_point')

    response.res.result = res.get("result")
    if not res.get("result"):
        response.res.result_no = res.get("result_no")
        return response.SerializePartialToString()
    # add guild activity times
    player.guild_activity.add_guild_boss_times(boss_info.get("boss_type"))
    player.act.add_guild_boss_times(boss_info.get("boss_type"))
    hook_task(player, CONDITIONId.GUILD_BOSS, 1)
    result = 0
    if fight_result:
        result = 1
    tlog_action.log('GuildBossBattle', player, player.guild.g_id,
                    boss_info.get("boss_type"), result)
    logger.debug("response %s" % response)
    return response.SerializePartialToString()

@remoteserviceHandle('gate')
def upgrade_guild_skill_2404(pro_data, player):
    """
    升级军团技能
    """
    request = guild_pb2.UpGuildSkillRequest()
    request.ParseFromString(pro_data)
    logger.error("request %s" % request)
    response = guild_pb2.UpGuildSkillResponse()
    logger.error("request %s" % request)
    skill_type = request.skill_type
    data = remote_gate['world'].guild_boss_init_remote(player.guild.g_id)
    guild_skills = data.get("guild_skills")
    build = data.get("build")
    skill_level = guild_skills.get(skill_type)
    logger.debug("skill level %s" % skill_level)
    # check
    guild_skill_item = game_configs.guild_skill_config.get(skill_type).get(skill_level)
    logger.debug("guild_skill_config %s" % guild_skill_item)
    response.res.result = False

    if guild_skills.get(skill_type) >= 10:
        logger.debug("guild skill %s has reach the max!" % skill_type)
        response.res.result_no = 24044
        return response.SerializeToString()

    #if not is_afford(player, guild_skill_item.Consume).get('result'):
        #logger.debug("consume not enough!")
        #response.res.result_no = 24041
        #return response.SerializeToString()

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

    res = remote_gate['world'].upgrade_guild_skill_remote(player.guild.g_id, skill_type)
    if res.get("result"):
        # consume
        #return_data = consume(player, guild_skill_item.Consume, const.UPGRADE_GUILD_SKILL)
        #get_return(player, return_data, response.consume)
        response.guild_skill_point = guild_skill_item.Consumption

    response.res.result = res.get("result")
    tlog_action.log('UpgradeGuildSkill', player, player.guild.g_id,
                    skill_type, guild_skills.get(skill_type)+1, guild_skill_item.Consumption)
    logger.debug("response %s" % response)
    return response.SerializeToString()

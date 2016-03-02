#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
created by wzp.
"""
from gfirefly.server.globalobject import rootserviceHandle
from app.world.core.hjqy_boss import hjqy_manager
from app.battle.server_process import guild_boss_start
import cPickle
#from shared.utils.date_util import get_current_timestamp
#from app.world.action.gateforwarding import push_all_object_message
from gfirefly.server.logobj import logger
from shared.db_opear.configs_data import game_configs
from shared.utils.mail_helper import deal_mail
from shared.utils.const import const
from gfirefly.server.globalobject import GlobalObject
from app.world.core.guild_manager import guild_manager_obj
from app.battle.monster_process import assemble_monster

#from app.proto_file import line_up_pb2

@rootserviceHandle
def guild_boss_init_remote(guild_id):
    """
    初始化信息
    """
    guild = guild_manager_obj.get_guild_obj(guild_id)

    if not guild:
        return {'result': False, 'result_no': 844}

    guild.guild_boss.check_time()
    guild.save_data()

    # 重置召唤次数
    guild.reset_guild_boss_trigger_times()

    res = dict(
            result=True,
            guild_skills=guild.guild_skills,
            guild_boss_trigger_times=guild.guild_boss_trigger_times,
            guild_boss=guild.guild_boss.property_dict(),
            build = guild.build,
            )

    logger.debug("result %s" % res)
    return res

@rootserviceHandle
def guild_boss_add_remote(guild_id, stage_id, boss_type, trigger_player_id, trigger_player_name):
    guild = guild_manager_obj.get_guild_obj(guild_id)
    # 是否存在boss
    if guild.guild_boss.stage_id:
        logger.debug("guild boss exist!")
        return {"result": False, "result_no": 240203}

    blue_units = assemble_monster(stage_id, game_configs.special_stage_config, "guild_boss_stages")
    logger.debug("blue_units %s" % blue_units)
    guild_boss = guild.add_guild_boss(stage_id, blue_units[0], boss_type, trigger_player_id, trigger_player_name)


    return {"result": True, "guild_boss": guild_boss.property_dict(), "p_list": guild.p_list}

@rootserviceHandle
def guild_boss_battle_remote(guild_id, str_red_units, red_unpar_data, seed1, seed2):
    """开始战斗
    """
    logger.debug("hjqy_battle_remote======")
    guild = guild_manager_obj.get_guild_obj(guild_id)
    boss = guild.guild_boss
    red_units = cPickle.loads(str_red_units)
    blue_units = boss.blue_units
    logger.debug("blue unit length %s" % len(blue_units))

    origin_hp = boss.hp
    fight_result = guild_boss_start(red_units,  blue_units, red_unpar_data, {}, seed1, seed2)

    logger.debug("blue unit length %s" % len(blue_units))
    boss.blue_units = blue_units

    current_damage_hp = origin_hp - boss.hp
    logger.debug("origin_hp %s, current_hp %s, current_damage_hp %s" % (origin_hp, boss.hp, current_damage_hp))

    guild_skill_point = 0
    if fight_result:
        stage_item = game_configs.special_stage_config.get("guild_boss_stages").get(boss.stage_id)
        guild.skill_point += stage_item.Animal_Kill_Over
        guild_skill_point = stage_item.Animal_Kill_Over
        boss.reset()
        guild.save_data()

    logger.debug("guildboss_battle_remote over===================")
    guild.save_data()
    return dict(
            result=True,
            fight_result = fight_result,
            guild_skill_point = guild_skill_point,
            )
@rootserviceHandle
def upgrade_guild_skill_remote(guild_id, skill_type):
    """ 获取玩家伤害信息
    """
    logger.debug("upgrade_guild_skill_remote : (%s, %s)" % (skill_type, guild_id))
    guild = guild_manager_obj.get_guild_obj(guild_id)

    skill_level = guild.guild_skills.get(skill_type)
    # 消耗技能点
    guild_skill_item = game_configs.guild_skill_config.get(skill_type).get(skill_level)
    if guild.skill_point < guild_skill_item.Consumption:
        logger.debug("consume not enough!")
        return dict(result=False, result_no = 24041)

    guild.skill_point -= guild_skill_item.Consumption

    guild.guild_skills[skill_type] = skill_level + 1
    guild.save_data()

    return dict(
            result=True)


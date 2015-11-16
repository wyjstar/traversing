# -*- coding:utf-8 -*-
"""
created by cui
"""
from gfirefly.server.globalobject import rootserviceHandle
from gfirefly.dbentrust.redis_mode import RedisObject
from gfirefly.server.logobj import logger
import time
import cPickle
from app.world.core.guild_manager import guild_manager_obj
from shared.db_opear.configs_data import game_configs

tb_guild_info = RedisObject('tb_guild_info')


@rootserviceHandle
def create_guild_remote(p_id, g_name, icon_id):
    """
    """
    res = {}
    # 判断有没有重名
    guild_name_data = tb_guild_info.getObj('names')
    _result = guild_name_data.hget(g_name)
    if not _result:
        return cPickle.dumps({'res': False})

    guild_obj = guild_manager_obj.create_guild(p_id, g_name, icon_id)
    guild_name_data.hmset({g_name: guild_obj.g_id})

    return cPickle.dumps({'res', True, 'guild_info': guild_obj.info})


@rootserviceHandle
def del_player_apply_remote(p_id, apply_guilds):
    """
    """
    for g_id in apply_guilds:
        guild_obj = guild_manager_obj.get_guild_obj(g_id)
        if not guild_obj:
            continue
        if p_id in guild_obj.apply:
            guild_obj.apply.remove(p_id)
            guild_obj.save_data()


@rootserviceHandle
def get_guild_info_remote(guild_id):
    """
    """
    guild_obj = guild_manager_obj.get_guild_obj(g_id)
    if not guild_obj:
        return cPickle.dumps({'res': False})
    return cPickle.dumps({'res', True, 'guild_info': guild_obj.info})


@rootserviceHandle
def join_guild_remote(guild_id, p_id):
    """
    no 844 id error 859 申请人数满 845 成员已经满
    """
    guild_obj = guild_manager_obj.get_guild_obj(g_id)
    if not guild_obj:
        logger.error('join_guild_802 guild id error! pid:%d' % p_id)
        return cPickle.dumps({'res': False, 'no': 844})
    if len(guild_obj.apply) >= game_configs.base_config. \
            get('guildApplyMaxNum'):
        # "军团申请人数已满
        return cPickle.dumps({'res': False, 'no': 859})
    if guild_obj.get_p_num() >= game_configs.guild_config. \
            get(guild_obj.level).p_max:
        # "公会已满员"
        return cPickle.dumps({'res': False, 'no': 845})

    guild_obj.join_guild(p_id)
    return cPickle.dumps({'res', True,
                          'captain_id': guild_obj.p_list.get(1)[0]})

"""
from gfirefly.server.globalobject import GlobalObject
remote_gate = GlobalObject().remote.get('gate')
seq = remote_gate['world'].mine_add_field_remote(uid,
                                                 player_field)
return cPickle.dumps(result)
result = cPickle.loads(result)
"""

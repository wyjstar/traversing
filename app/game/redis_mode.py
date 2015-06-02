# -*- coding:utf-8 -*-
"""
created by server on 14-6-10下午9:09.
"""
from gfirefly.dbentrust.redis_mode import RedisObject

# 用户信息表
tb_character_info = RedisObject('tb_character_info')
# 公会信息表
tb_guild_info = RedisObject('tb_guild_info')
# 公会名表
tb_pvp_rank = RedisObject('tb_pvp_rank')

# -*- coding:utf-8 -*-
"""
"""
from gfirefly.dbentrust.redis_mode import RedisObject

# 用户信息表
tb_character_info = RedisObject('tb_character_info')

tb_character_level = RedisObject('tb_character_level_match')

tb_character_ap = RedisObject('tb_character_ap')
# 公会信息表
tb_guild_info = RedisObject('tb_guild_info')
# 公会名表
tb_pvp_rank = RedisObject('tb_pvp_rank')
# mine data
tb_mine = RedisObject('tb_mine')
# 全局基础信息，目前只有世界聊天记录
tb_base_info = RedisObject('tb_base_info')

if __name__ == '__main__':
    from gfirefly.dbentrust.redis_manager import redis_manager
    import json

    mconfig = json.load(open('config.json', 'r'))
    redis_config = mconfig.get('redis').get('urls')
    redis_manager.connection_setup(redis_config)
    print 'fdsfs'
    tb_character_level.zadd(41, 1)
    tb_character_level.zadd(42, 2)
    tb_character_level.zadd(43, 3)
    tb_character_level.zadd(44, 4)
    tb_character_level.zadd(45, 5)

    print tb_character_level.zrangebyscore(42, 44)

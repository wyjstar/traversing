# -*- coding:utf-8 -*-
"""
created by server on 14-6-6上午11:12.
"""

from gfirefly.dbentrust.redis_mode import RedisObject

tb_account = RedisObject('tb_account')  # 帐号表

tb_character_info = RedisObject('tb_character_info')

# 公会信息表
tb_guild_info = RedisObject('tb_guild_info')

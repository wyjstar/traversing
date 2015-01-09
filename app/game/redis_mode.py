# -*- coding:utf-8 -*-
"""
created by server on 14-6-10下午9:09.
"""
from gfirefly.dbentrust.redis_mode import RedisObject

# 用户信息表
tb_character_info = RedisObject('tb_character_info')
# 用户道具背包
tb_character_item_package = RedisObject('tb_character_item_package')
# 用户阵容信息
tb_character_line_up = RedisObject('tb_character_line_up')
# 公会信息表
tb_guild_info = RedisObject('tb_guild_info')
# 公会名表
tb_guild_name = RedisObject('tb_guild_name')
# 关卡信息表
tb_character_stages = RedisObject('tb_character_stages')
# 体力表
tb_character_stamina = RedisObject('tb_character_stamina')
# 活跃度
tb_character_tasks = RedisObject('tb_character_lively')

tb_character_mine = RedisObject('tb_character_mine')

tb_character_stone = RedisObject('tb_character_stone')

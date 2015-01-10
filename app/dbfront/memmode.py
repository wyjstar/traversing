# -*-coding:utf8-*-

from gfirefly.dbentrust.mmode import RedisObject

tb_account = RedisObject('tb_account', 'id')  # 甯���疯〃
tb_account.insert()

# ��ㄦ�蜂俊���琛�
tb_character_info = RedisObject('tb_character_info', 'id')
tb_character_info.insert()

# ��ㄦ�烽�靛�逛俊���
tb_character_line_up = RedisObject('tb_character_line_up', 'id')
tb_character_line_up.insert()

# ���浼�淇℃��琛�
tb_guild_info = RedisObject('tb_guild_info', 'id')
tb_guild_info.insert()

# ���浼����琛�
tb_guild_name = RedisObject('tb_guild_name', 'id')
tb_guild_name.insert()

# 活跃度
tb_character_tasks = RedisObject('tb_character_lively', 'id')
tb_character_tasks.insert()

# -*-coding:utf8-*-

from gfirefly.dbentrust.mmode import RedisObject

tb_account = RedisObject('tb_account', 'id')  # 甯���疯〃
tb_account.insert()

# ��ㄦ�蜂俊���琛�
tb_character_info = RedisObject('tb_character_info', 'id')
tb_character_info.insert()

# ���浼�淇℃��琛�
tb_guild_info = RedisObject('tb_guild_info', 'id')
tb_guild_info.insert()

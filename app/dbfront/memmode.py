# -*-coding:utf8-*-

from gfirefly.dbentrust.mmode import MAdmin

tb_account = MAdmin('tb_account', 'id')  # 甯���疯〃
tb_account.insert()

# ��ㄦ�蜂俊���琛�
tb_character_info = MAdmin('tb_character_info', 'id')
tb_character_info.insert()

# ��遍��淇℃��琛�
tb_character_hero = MAdmin('tb_character_hero', 'id', 1800)
tb_character_hero.insert()

# ��ㄦ�疯�遍��纰����淇℃��琛�
tb_character_hero_chip = MAdmin('tb_character_hero_chip', 'id', 1800)
tb_character_hero_chip.insert()

# ��ㄦ�烽����疯�����
tb_character_item_package = MAdmin('tb_character_item_package', 'id')
tb_character_item_package.insert()

# ��ㄦ�烽�靛�逛俊���
tb_character_line_up = MAdmin('tb_character_line_up', 'id')
tb_character_line_up.insert()

# 瑁�澶�淇℃��琛�
tb_equipment_info = MAdmin('tb_equipment_info', 'id')
tb_equipment_info.insert()

# 瑁�澶�纰����琛�
tb_character_equipment_chip = MAdmin('tb_character_equipment_chip', 'id')
tb_character_equipment_chip.insert()

# friend琛�
tb_character_friend = MAdmin('tb_character_friend', 'id')
tb_character_friend.insert()

# ���浼�淇℃��琛�
tb_guild_info = MAdmin('tb_guild_info', 'id')
tb_guild_info.insert()

# ��╁�跺��浼�琛�
tb_character_guild = MAdmin('tb_character_guild', 'id')
tb_character_guild.insert()

# ���浼����琛�
tb_guild_name = MAdmin('tb_guild_name', 'id')
tb_guild_name.insert()

# ��╁�舵椿��ㄨ〃
tb_character_activity = MAdmin('tb_character_activity', 'id')
tb_character_activity.insert()

# 涓诲��淇℃��琛�
tb_character_lord = MAdmin('tb_character_lord', 'id')
tb_character_lord.insert()

# ��冲�′俊���琛�
tb_character_stages = MAdmin('tb_character_stages', 'id')
tb_character_stages.insert()

# ���浠惰〃
tb_mail_info = MAdmin('tb_mail_info', 'id')
tb_mail_info.insert()

# 活跃度
tb_character_tasks = MAdmin('tb_character_lively', 'id')
tb_character_tasks.insert()

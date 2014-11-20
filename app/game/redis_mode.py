# -*- coding:utf-8 -*-
"""
created by server on 14-6-10下午9:09.
"""
from gfirefly.dbentrust.mmode import MAdmin

# 用户信息表
tb_character_info = MAdmin('tb_character_info', 'id')
tb_character_info.insert()

# 英雄信息表
tb_character_hero = MAdmin('tb_character_hero', 'id', fk='character_id')
tb_character_hero.insert()

# 用户英雄碎片信息表
tb_character_hero_chip = MAdmin('tb_character_hero_chip', 'id')
tb_character_hero_chip.insert()

# 用户道具背包
tb_character_item_package = MAdmin('tb_character_item_package', 'id')
tb_character_item_package.insert()

# 用户阵容信息
tb_character_line_up = MAdmin('tb_character_line_up', 'id')
tb_character_line_up.insert()

# 装备信息表
tb_equipment_info = MAdmin('tb_equipment_info', 'id', fk='character_id')
tb_equipment_info.insert()

# 装备碎片表
tb_character_equipment_chip = MAdmin('tb_character_equipment_chip', 'id')
tb_character_equipment_chip.insert()

# 公会信息表
tb_guild_info = MAdmin('tb_guild_info', 'id')
tb_guild_info.insert()

# 玩家公会表
tb_character_guild = MAdmin('tb_character_guild', 'id')
tb_character_guild.insert()

# 公会名表
tb_guild_name = MAdmin('tb_guild_name', 'g_name')
tb_guild_name.insert()

# friend表
tb_character_friend = MAdmin('tb_character_friend', 'id')
tb_character_friend.insert()


# 关卡信息表
tb_character_stages = MAdmin('tb_character_stages', 'id')
tb_character_stages.insert()

# 邮件表
tb_mail_info = MAdmin('tb_mail_info', 'id', fk='character_id')
tb_mail_info.insert()

# 玩家活动表
tb_character_activity = MAdmin('tb_character_activity', 'id')
tb_character_activity.insert()

# 主将信息表
tb_character_lord = MAdmin('tb_character_lord', 'id')
tb_character_lord.insert()

# 体力表
tb_character_stamina = MAdmin('tb_character_stamina', 'id')
tb_character_stamina.insert()

# brew
tb_character_brew = MAdmin('tb_character_brew', 'id')
tb_character_brew.insert()

#活跃度
tb_character_tasks = MAdmin('tb_character_lively', 'id')
tb_character_tasks.insert()

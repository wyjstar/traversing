# -*- coding:utf-8 -*-
"""
created by server on 14-6-10下午9:09.
"""
from shared.db_entrust.redis_mode import MAdmin

# 用户信息表
tb_character_info = MAdmin('tb_character_info', 'uid')
tb_character_info.insert()

# 用户英雄信息表
tb_character_hero = MAdmin('tb_character_hero', 'id', 1800)
tb_character_hero.insert()

# 用户英雄碎片信息表
tb_character_hero_chip = MAdmin('tb_character_hero_chip', 'id', 1800)
tb_character_hero_chip.insert()

# 用户道具背包
tb_character_item_package = MAdmin('tb_character_item_package', 'id')
tb_character_item_package.insert()

# 用户阵容信息
tb_character_line_up = MAdmin('tb_character_line_up', 'id')
tb_character_line_up.insert()

# 用户装备列表
tb_character_equipments = MAdmin('tb_character_equipments', 'id')
tb_character_equipments.insert()

# 装备信息表
tb_equipment_info = MAdmin('tb_equipment_info', 'equipment_id')
tb_equipment_info.insert()

# 装备碎片表
tb_character_equipment_chip = MAdmin('tb_character_equipment_chip', 'id')
tb_character_equipment_chip.insert()
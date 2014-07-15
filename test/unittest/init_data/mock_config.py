# -*- coding:utf-8 -*-

from shared.db_opear.configs_data.game_configs import hero_config, hero_exp_config, base_config, \
    item_config, hero_breakup_config, chip_config, big_bag_config, small_bag_config
from shared.db_opear.configs_data.common_item import CommonItem
from shared.db_opear.configs_data.hero_breakup_config import HeroBreakupConfig
from shared.db_opear.configs_data.pack.big_bag_config import BigBagsConfig
from shared.db_opear.configs_data.pack.small_bag_config import SmallBagsConfig
from shared.db_opear.configs_data.chip_config import ChipConfig
from shared.utils.const import *

# ------------------------base----------------------------

base_config.clear()
base_config['exp_items'] = [1000101, 1000102, 1000103, 1000104]

# ------------------------hero----------------------------

hero1 = {'id': 10001, 'name': 'hero10001', 'sacrifice_hero_soul': 100}
hero2 = {'id': 10002, 'name': 'hero10002', 'sacrifice_hero_soul': 200}
hero3 = {'id': 10003, 'name': 'hero10003', 'sacrifice_hero_soul': 300}

hero_config.clear()
hero_config[10001] = CommonItem(hero1)
hero_config[10002] = CommonItem(hero2)
hero_config[10003] = CommonItem(hero3)

# ------------------------item----------------------------

item1 = {'id': 1000101, 'func_args1': 100000}
item2 = {'id': 1000102, 'func_args1': 50000}
item3 = {'id': 1000103, 'func_args1': 10000}
item4 = {'id': 1000104, 'func_args1': 1000}

item5 = {'id': 1000105, 'func_args1': 2, 'func_args2': 1}

item_config.clear()
item_config[1000101] = item1
item_config[1000102] = item2
item_config[1000103] = item3
item_config[1000104] = item4

#------------------------hero_exp----------------------------

hero_exp1 = {'level': 1, 'exp': 100}
hero_exp2 = {'level': 2, 'exp': 200}
hero_exp3 = {'level': 3, 'exp': 300}
hero_exp4 = {'level': 4, 'exp': 400}
hero_exp5 = {'level': 5, 'exp': 500}
hero_exp6 = {'level': 6, 'exp': 600}
hero_exp7 = {'level': 7, 'exp': 700}
hero_exp8 = {'level': 8, 'exp': 800}
hero_exp9 = {'level': 9, 'exp': 900}
hero_exp10 = {'level': 10, 'exp': 1000}
hero_exp11 = {'level': 11, 'exp': 1100}
hero_exp12 = {'level': 12, 'exp': 1200}
hero_exp13 = {'level': 13, 'exp': 1300}
hero_exp14 = {'level': 14, 'exp': 1400}
hero_exp15 = {'level': 15, 'exp': 1500}
hero_exp16 = {'level': 16, 'exp': 1600}
hero_exp17 = {'level': 17, 'exp': 1700}

hero_exp_config.clear()
hero_exp_config[1] = hero_exp1
hero_exp_config[2] = hero_exp2
hero_exp_config[3] = hero_exp3
hero_exp_config[4] = hero_exp4
hero_exp_config[5] = hero_exp5
hero_exp_config[6] = hero_exp6
hero_exp_config[7] = hero_exp7
hero_exp_config[8] = hero_exp8
hero_exp_config[9] = hero_exp9
hero_exp_config[10] = hero_exp10
hero_exp_config[11] = hero_exp11
hero_exp_config[12] = hero_exp12
hero_exp_config[13] = hero_exp13
hero_exp_config[14] = hero_exp14
hero_exp_config[15] = hero_exp15
hero_exp_config[16] = hero_exp16


#------------------------hero_breakup----------------------------
# 1 :coin
# 2 :break_pill
# 3 :hero_chip
hero_breakup1 = {'id': 10001, 'break2': 31000102,
                 'consume2': {1: [1000, 1000, 0],
                              5: [2, 2, 1000111],
                              4: [20, 20, 1000112]}}

hero_breakup_config.clear()
hero_breakup_config[10001] = HeroBreakupConfig.HeroBreakupItem(hero_breakup1)


#------------------------hero_chip----------------------------

hero_chip1 = {'id': 1000114, 'combineResult': 10004, 'need_num': 20}
hero_chip2 = {'id': 1010005, 'combineResult': 10005, 'need_num': 20}
chip_config.clear()
config = ChipConfig()
chip_config_mock = config.parser([hero_chip1, hero_chip2])
chip_config['mapping'] = chip_config_mock['mapping']
chip_config['chips'] = chip_config_mock['chips']


#------------------------big_bag----------------------------

big_bag1 = dict(dropId=10001, smallPacketId=[1002, 1003], smallPacketTimes=[5, 1], isUniq=[1, 0])
big_bag_config_mock = BigBagsConfig().parser([big_bag1])
for key, value in big_bag_config_mock.items():
    big_bag_config[key] = value

#------------------------small_bag----------------------------
small_bag1 = dict(id=1001, dropId=1001, subId=1, type=const.COIN, count=1000, detailID=0, weight=1)
small_bag2 = dict(id=1002, dropId=1001, subId=2, type=const.GOLD, count=1000, detailID=0, weight=1)
small_bag3 = dict(id=1003, dropId=1001, subId=3, type=const.HERO_SOUL, count=1000, detailID=0, weight=1)
small_bag4 = dict(id=1004, dropId=1001, subId=4, type=const.HERO, count=1, detailID=10001, weight=1)
small_bag5 = dict(id=1005, dropId=1001, subId=5, type=const.HERO_CHIP, count=100, detailID=1000112, weight=1)
small_bag6 = dict(id=1006, dropId=1001, subId=6, type=const.EQUIPMENT, count=1, detailID=110001, weight=1)
# small_bag7 = dict(id=1007, dropId=1001, subId=7, type=const.EQUIPMENT_CHIP, count=100, detailID=0, weight=1)
small_bag8 = dict(id=1008, dropId=1001, subId=8, type=const.ITEM, count=1, detailID=1000101, weight=1)

small_bag9 = dict(id=1009, dropId=1002, subId=1, type=const.COIN, count=1000, detailID=0, weight=1)
small_bag10 = dict(id=1010, dropId=1002, subId=2, type=const.HERO, count=1, detailID=10006, weight=1)

small_bag11 = dict(id=1011, dropId=1003, subId=1, type=const.COIN, count=1000, detailID=0, weight=1)
small_bag12 = dict(id=1012, dropId=1003, subId=2, type=const.HERO, count=1, detailID=10006, weight=1)

small_bag_config_mock = SmallBagsConfig().parser([small_bag9, small_bag10, small_bag11, small_bag12])

for key, value in small_bag_config_mock.items():
    small_bag_config[key] = value




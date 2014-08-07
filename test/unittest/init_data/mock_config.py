# -*- coding:utf-8 -*-

from shared.db_opear.configs_data.game_configs import hero_config, hero_exp_config, base_config, \
    item_config, hero_breakup_config, chip_config, big_bag_config, small_bag_config, soul_shop_config, shop_config
from shared.db_opear.configs_data.common_item import CommonItem
from shared.db_opear.configs_data.hero_config import HeroConfig
from shared.db_opear.configs_data.hero_breakup_config import HeroBreakupConfig
from shared.db_opear.configs_data.pack.big_bag_config import BigBagsConfig
from shared.db_opear.configs_data.pack.small_bag_config import SmallBagsConfig
from shared.db_opear.configs_data.chip_config import ChipConfig
from shared.db_opear.configs_data.item_config import ItemsConfig
from shared.db_opear.configs_data.soul_shop_config import SoulShopConfig
from shared.db_opear.configs_data.shop_config import ShopConfig

from shared.utils.const import *

# ------------------------base----------------------------

base_config.clear()
base_config_mock = CommonItem(dict(exp_items=[1000101, 1000102, 1000103, 1000104], soul_shop_item_num=6))
for key, value in base_config_mock.items():
    base_config[key] = value

# ------------------------hero----------------------------

hero1 = {'id': 10001, 'name': 'hero10001', 'sacrificeGain': {const.HERO_SOUL: [100, 100, 0]},
         'sellGain': {const.COIN: [100, 100, 0]}, 'breakLimit': 6}
hero2 = {'id': 10002, 'name': 'hero10002', 'sacrificeGain': {const.HERO_SOUL: [200, 200, 0]},
         'sellGain': {const.COIN: [200, 300, 0]}, 'breakLimit': 6}
hero3 = {'id': 10003, 'name': 'hero10003', 'sacrificeGain': {const.HERO_SOUL: [300, 300, 0]},
         'sellGain': {const.COIN: [300, 300, 0]}, 'breakLimit': 6}

hero_config.clear()
hero_config_mock = HeroConfig().parser([hero1, hero2, hero3])
for key, value in hero_config_mock.items():
    hero_config[key] = value

# ------------------------item----------------------------

item1 = {'id': 1000101, 'funcArgs1': 100000}
item2 = {'id': 1000102, 'funcArgs1': 50000}
item3 = {'id': 1000103, 'funcArgs1': 10000}
item4 = {'id': 1000104, 'funcArgs1': 1000}

item5 = {'id': 1000112, 'func': 2, 'funcArgs1': 1000113, 'funcArgs2': 1, 'dropId': 10002}
item6 = {'id': 1000113, 'func': 0}

item_config.clear()
item_config_mock = ItemsConfig().parser([item1, item2, item3, item4, item5, item6])
for key, value in item_config_mock.items():
    item_config[key] = value
# ------------------------hero_exp----------------------------

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


# ------------------------hero_breakup----------------------------
# 1 :coin
# 2 :break_pill
# 3 :hero_chip
hero_breakup1 = {'id': 10001, 'break2': 31000102,
                 'consume1': {const.COIN: [1000, 1000, 0],
                              const.ITEM: [2, 2, 1000111],
                              const.HERO_CHIP: [20, 20, 1000112]},
                 'consume2': {const.COIN: [1000, 1000, 0],
                              const.ITEM: [2, 2, 1000111],
                              const.HERO_CHIP: [20, 20, 1000112]},
                 'consume3': {const.COIN: [1000, 1000, 0],
                              const.ITEM: [2, 2, 1000111],
                              const.HERO_CHIP: [20, 20, 1000112]},
                 'consume4': {const.COIN: [1000, 1000, 0],
                              const.ITEM: [2, 2, 1000111],
                              const.HERO_CHIP: [20, 20, 1000112]},
                 'consume5': {const.COIN: [1000, 1000, 0],
                              const.ITEM: [2, 2, 1000111],
                              const.HERO_CHIP: [20, 20, 1000112]},
                 }

hero_breakup_config.clear()
hero_breakup_config[10001] = HeroBreakupConfig.HeroBreakupItem(hero_breakup1)


# ------------------------hero_chip----------------------------

hero_chip1 = {'id': 1000114, 'combineResult': 10004, 'need_num': 20}
hero_chip2 = {'id': 1010005, 'combineResult': 10005, 'need_num': 20}
chip_config.clear()
config = ChipConfig()
chip_config_mock = config.parser([hero_chip1, hero_chip2])
chip_config['mapping'] = chip_config_mock['mapping']
chip_config['chips'] = chip_config_mock['chips']


# ------------------------big_bag----------------------------

big_bag1 = dict(dropId=10001, smallPacketId=[1002, 1003], smallPacketTimes=[5, 1], isUniq=[1, 0])
big_bag2 = dict(dropId=10002, smallPacketId=[1004], smallPacketTimes=[1], isUniq=[0])
big_bag_config_mock = BigBagsConfig().parser([big_bag1, big_bag2])
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

small_bag13 = dict(id=1013, dropId=1004, subId=1, type=const.COIN, count=1000, detailID=0, weight=1)

small_bag_config_mock = SmallBagsConfig().parser([small_bag9, small_bag10, small_bag11, small_bag12, small_bag13])

for key, value in small_bag_config_mock.items():
    small_bag_config[key] = value

#------------------------soul_shop----------------------------
soul_shop1 = dict(id=1001, consume={const.HERO_SOUL: [20, 20, 0]}, gain={const.HERO_SOUL: [20, 20, 0]}, weight=50)
soul_shop2 = dict(id=1002, consume={const.HERO_SOUL: [20, 20, 0]}, gain={const.HERO_SOUL: [20, 20, 0]}, weight=50)
soul_shop_config_mock = SoulShopConfig().parser([soul_shop1, soul_shop2])
for key, value in soul_shop_config_mock.items():
    soul_shop_config[key] = value

#------------------------shop----------------------------
shop1 = dict(id=1001, type=1, consume={const.HERO_SOUL: [20, 20, 0]}, gain={const.HERO_SOUL: [20, 20, 0]}, extraGain={3: [20, 20, 0]}, freePeriod=2)
shop2 = dict(id=1002, type=2, consume={const.HERO_SOUL: [20, 20, 0]}, gain={const.HERO_SOUL: [20, 20, 0]}, extraGain={3: [20, 20, 0]}, freePeriod=2)
shop3 = dict(id=1003, type=3, consume={const.HERO_SOUL: [20, 20, 0]}, gain={const.HERO_SOUL: [20, 20, 0]}, extraGain={3: [20, 20, 0]}, freePeriod=2)
shop4 = dict(id=1004, type=4, consume={const.HERO_SOUL: [20, 20, 0]}, gain={const.HERO_SOUL: [20, 20, 0]}, extraGain={3: [20, 20, 0]},
             freePeriod=-1)

shop_config_mock = ShopConfig().parser([shop1, shop2, shop3, shop4])
for key, value in shop_config_mock.items():
    shop_config[key] = value


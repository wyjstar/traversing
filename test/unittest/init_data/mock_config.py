# -*- coding:utf-8 -*-

from shared.db_opear.configs_data.game_configs import hero_config, hero_exp_config, base_config, \
    item_config, hero_breakup_config, chip_config
from shared.db_opear.configs_data.common_item import CommonItem
from shared.db_opear.configs_data.hero_breakup_config import HeroBreakupConfig
from shared.db_opear.configs_data.chip_config import ChipConfig


#------------------------base----------------------------

base_config.clear()
base_config['exp_items'] = [1000101, 1000102, 1000103, 1000104]

#------------------------hero----------------------------

hero1 = {'id': 10001, 'name': 'hero10001', 'sacrifice_hero_soul': 100}
hero2 = {'id': 10002, 'name': 'hero10002', 'sacrifice_hero_soul': 200}
hero3 = {'id': 10003, 'name': 'hero10003', 'sacrifice_hero_soul': 300}

hero_config.clear()
hero_config[10001] = CommonItem(hero1)
hero_config[10002] = CommonItem(hero2)
hero_config[10003] = CommonItem(hero3)

#------------------------item----------------------------

item1 = {'id': 1000101, 'func_args': 100000}
item2 = {'id': 1000102, 'func_args': 50000}
item3 = {'id': 1000103, 'func_args': 10000}
item4 = {'id': 1000104, 'func_args': 1000}

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
                              4: [20, 20, 1000112]
                 }}

hero_breakup_config.clear()
hero_breakup_config[10001] = HeroBreakupConfig.HeroBreakupItem(hero_breakup1)


#------------------------hero_chip----------------------------

hero_chip1 = {'id': 1000114, 'hero_id': 10004, 'need_num': 20}
hero_chip2 = {'id': 1010005, 'hero_id': 10005, 'need_num': 20}
chip_config.clear()
config = ChipConfig()
chip_config_mock = config.parser([hero_chip1, hero_chip2])
chip_config['mapping'] = chip_config_mock['mapping']
chip_config['chips'] = chip_config_mock['chips']






# -*- coding:utf-8 -*-
"""
created by server on 14-6-6上午11:05.
"""
import os
from chip_config import ChipConfig
from equipment.equipment_config import EquipmentConfig
from equipment.equipment_strengthen_config import EquipmentStrengthenConfig
from equipment.set_equipment_config import SetEquipmentConfig
from hero_breakup_config import HeroBreakupConfig
from item_config import ItemsConfig
from link_config import LinkConfig
from mail_config import MailConfig
from monster_config import MonsterConfig
from monster_group_config import MonsterGroupConfig
from pack.big_bag_config import BigBagsConfig
from pack.small_bag_config import SmallBagsConfig
from robot_born_config import RobotBornConfig
from shop_config import ShopConfig
from skill_buff_config import SkillBuffConfig
from skill_config import SkillConfig
from stage_break_config import StageBreakConfig
from stage_config import StageConfig
from soul_shop_config import SoulShopConfig
from sign_in_config import SignInConfig
from warriors_config import WarriorsConfig
from activity_config import ActivityConfig
from hero_config import HeroConfig
from hero_exp_config import HeroExpConfig
from base_config import BaseConfig
from guild_config import GuildConfig
from vip_config import VIPConfig
from language_config import LanguageConfig
from special_stage_config import SpecialStageConfig
import json



def get_config_value(config_key):
    """获取所有翻译信息
    """
    data = {}
    root_path = "configs_data/json_data/"
    for file_name in os.listdir(root_path):
        config_key = file_name.rsplit('.', 1)[0]
        file_path = root_path + file_name

        fp = open(file_path)
        data[config_key] = json.load(fp)

    return data

base_config = {}
hero_config = {}
hero_exp_config = {}
hero_breakup_config = {}
chip_config = {}
item_config = {}
small_bag_config = {}
big_bag_config = {}
equipment_config = {}  # 装备配置
equipment_strengthen_config = {}  # 装备强化等级消耗金币路线
set_equipment_config = {}
shop_config = {}
soul_shop_config = {}
link_config = {}
stage_config = {}
monster_config = {}
monster_group_config = {}
skill_config = {}
skill_buff_config = {}
guild_config = {}
sign_in_config = {}
warriors_config = {}
activity_config = {}
vip_config = {}
stage_break_config = {}
special_stage_config = {}
mail_config = {}
robot_born_config = {}
language_config = {}

all_config_name = {
    'base_config': BaseConfig(),
    'hero_config': HeroConfig(),
    'hero_exp_config': HeroExpConfig(),
    'hero_breakup_config': HeroBreakupConfig(),
    'item_config': ItemsConfig(),
    'small_bag_config': SmallBagsConfig(),
    'big_bag_config': BigBagsConfig(),
    'equipment_config': EquipmentConfig(),
    'equipment_strengthen_config': EquipmentStrengthenConfig(),
    'set_equipment_config': SetEquipmentConfig(),
    'chip_config': ChipConfig(),
    'shop_config': ShopConfig(),
    'link_config': LinkConfig(),
    'stage_config': StageConfig(),
    'monster_config': MonsterConfig(),
    'monster_group_config': MonsterGroupConfig(),
    'skill_config': SkillConfig(),
    'skill_buff_config': SkillBuffConfig(),
    'guild_config': GuildConfig(),
    'soul_shop_config': SoulShopConfig(),
    'sign_in_config': SignInConfig(),
    'warriors_config': WarriorsConfig(),
    'activity_config': ActivityConfig(),
    'vip_config': VIPConfig(),
    'stage_break_config': StageBreakConfig(),
    'special_stage_config': SpecialStageConfig(),
    'mail_config': MailConfig(),
    'robot_born_config': RobotBornConfig(),
    'language_config': LanguageConfig()
}


class ConfigFactory(object):

    @classmethod
    def creat_config(cls, config_name, config_value):
        return all_config_name[config_name].parser(config_value)

for config_name in all_config_name.keys():
        game_conf = get_config_value(config_name)

        if not game_conf or (not config_name in game_conf):
            continue
        objs = ConfigFactory.creat_config(config_name, game_conf[config_name])
        exec(config_name + '=objs')

if __name__ == '__main__':
    for k, v in hero_config.items():
        print k, v

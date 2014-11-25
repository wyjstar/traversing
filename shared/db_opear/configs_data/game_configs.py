# -*- coding:utf-8 -*-
"""
created by server on 14-6-6上午11:05.
"""
import cPickle
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
from rand_name_config import RandNameConfig
from player_exp_config import PlayerExpConfig
from robot_born_config import RobotBornConfig
from shop_config import ShopConfig
from skill_buff_config import SkillBuffConfig
from skill_config import SkillConfig
from stage_break_config import StageBreakConfig
from stage_config import StageConfig
from soul_shop_config import SoulShopConfig
from arena_shop_config import ArenaShopConfig
from sign_in_config import SignInConfig
from warriors_config import WarriorsConfig
from activity_config import ActivityConfig
from hero_config import HeroConfig
from hero_exp_config import HeroExpConfig
from base_config import BaseConfig
from guild_config import GuildConfig
from vip_config import VIPConfig
from special_stage_config import SpecialStageConfig
from arena_fight_config import ArenaFightConfig
from hero_breakup_attr_config import HeroBreakupAttrConfig
from language_config import LanguageConfig
from achievement_config import AchievementConfig
from seal_config import SealConfig


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
rand_name_config = {}
player_exp_config = {}
arena_fight_config = {}
arena_shop_config = {}
hero_breakup_attr_config = {}
language_config = {}
achievement_config = {}
seal_config = {}


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
    'rand_name_config': RandNameConfig(),
    'robot_born_config': RobotBornConfig(),
    'player_exp_config': PlayerExpConfig(),
    'arena_fight_config': ArenaFightConfig(),
    'arena_shop_config': ArenaShopConfig(),
    'hero_breakup_attr_config': HeroBreakupAttrConfig(),
    'language_config': LanguageConfig(),
    'achievement_config': AchievementConfig(),
    'seal_config': SealConfig()
}

module = cPickle.load(open('config/excel_cpickle', 'r'))
for config_name in all_config_name.keys():
    config_value = module.get(config_name)
    objs = all_config_name[config_name].parser(config_value)
    exec(config_name + '=objs')

if __name__ == '__main__':
    print warriors_config.get(10001)

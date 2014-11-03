# -*- coding:utf-8 -*-
"""
created by server on 14-6-6上午11:05.
"""
import cPickle
from shared.db_opear.configs_data.chip_config import ChipConfig
from shared.db_opear.configs_data.equipment.equipment_config import EquipmentConfig
from shared.db_opear.configs_data.equipment.equipment_strengthen_config import EquipmentStrengthenConfig
from shared.db_opear.configs_data.equipment.set_equipment_config import SetEquipmentConfig
from shared.db_opear.configs_data.hero_breakup_config import HeroBreakupConfig
from shared.db_opear.configs_data.item_config import ItemsConfig
from shared.db_opear.configs_data.link_config import LinkConfig
from shared.db_opear.configs_data.mail_config import MailConfig
from shared.db_opear.configs_data.monster_config import MonsterConfig
from shared.db_opear.configs_data.monster_group_config import MonsterGroupConfig
from shared.db_opear.configs_data.pack.big_bag_config import BigBagsConfig
from shared.db_opear.configs_data.pack.small_bag_config import SmallBagsConfig
from shared.db_opear.configs_data.rand_name_config import RandNameConfig
from shared.db_opear.configs_data.player_exp_config import PlayerExpConfig
from shared.db_opear.configs_data.robot_born_config import RobotBornConfig
from shared.db_opear.configs_data.shop_config import ShopConfig
from shared.db_opear.configs_data.skill_buff_config import SkillBuffConfig
from shared.db_opear.configs_data.skill_config import SkillConfig
from shared.db_opear.configs_data.stage_break_config import StageBreakConfig
from shared.db_opear.configs_data.stage_config import StageConfig
from shared.db_opear.configs_data.soul_shop_config import SoulShopConfig
from shared.db_opear.configs_data.sign_in_config import SignInConfig
from shared.db_opear.configs_data.warriors_config import WarriorsConfig
from shared.db_opear.configs_data.activity_config import ActivityConfig
from shared.db_opear.configs_data.hero_config import HeroConfig
from shared.db_opear.configs_data.hero_exp_config import HeroExpConfig
from shared.db_opear.configs_data.base_config import BaseConfig
from shared.db_opear.configs_data.guild_config import GuildConfig
from shared.db_opear.configs_data.vip_config import VIPConfig
from shared.db_opear.configs_data.special_stage_config import SpecialStageConfig
from shared.db_opear.configs_data.arena_fight_config import ArenaFightConfig


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
    'arena_fight_config': ArenaFightConfig()
}


module = cPickle.load(open('shared/db_opear/configs_data/excel', 'r'))
for config_name in all_config_name.keys():
    config_value = module.get(config_name)
    objs = all_config_name[config_name].parser(config_value)
    exec(config_name + '=objs')

if __name__ == '__main__':
    for k, v in arena_fight_config.items():
        print k, v, len(v)

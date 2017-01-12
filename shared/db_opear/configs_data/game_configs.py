# -*- coding:utf-8 -*-
"""
created by server on 14-6-6上午11:05.
"""
import cPickle
from gfirefly.server.logobj import logger
from chip_config import ChipConfig
from equipment.equipment_config import EquipmentConfig
from equipment.equipment_strengthen_config import EquipmentStrengthenConfig
from equipment.set_equipment_config import SetEquipmentConfig
from equipment.equipment_attribute_config import EquipmentAttributeConfig
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
from shop_type_config import ShopTypeConfig
from skill_buff_config import SkillBuffConfig
from skill_config import SkillConfig
from stage_break_config import StageBreakConfig
from stage_config import StageConfig
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
from travel_event_config import TravelEventConfig
from language_config import LanguageConfig
from achievement_config import AchievementConfig
from seal_config import SealConfig
from travel_item_config import TravelItemConfig
from mine_config import MineConfig
from formula_config import FormulaConfig
from mine_match_config import MineMatchConfig
from stone_config import StoneConfig
from newbee_guide_config import NewbeeGuideConfig
from travel_item_group_config import TravelItemGroupConfig
from notes_config import NotesConfig
from recharge_config import RechargeConfig
from lucky_hero_config import LuckyHeroConfig
from pseudo_random_config import PseudoRandomConfig
from push_config import PushConfig
from hjqy_config import HjqyConfig
from currency_config import CurrencyConfig
from lottery_config import LotteryConfig
from activity_type_config import ActivityTypeConfig
from ggzj_config import GgzjConfig
from awake_config import AwakeConfig
from indiana_config import IndianaConfig
from skill_peerless_grade_config import PeerlessGradeConfig
from skill_peerless_effect_config import PeerlessEffectConfig
from guild_task_config import GuildTaskConfig
from guild_skill_config import GuildSkillConfig
from features_open_config import FeaturesOpenConfig
from stage_show_config import StageShowConfig

indiana_config = {}
activity_type_config = {}
lottery_config = {}
travel_item_group_config = {}
stone_config = {}
travel_item_config = {}
base_config = {}
hero_config = {}
hero_exp_config = {}
chip_config = {}
item_config = {}
small_bag_config = {}
big_bag_config = {}
equipment_config = {}  # 装备配置
equipment_strengthen_config = {}  # 装备强化等级消耗金币路线
set_equipment_config = {}
equipment_attribute_config = {}
shop_config = {}
shop_type_config = {}
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
travel_event_config = {}
language_config = {}
achievement_config = {}
seal_config = {}
mine_config = {}
formula_config = {}
newbee_guide_config = {}
mine_match_config = {}
notes_config = {}
recharge_config = {}
lucky_hero_config = {}
pseudo_random_config = {}
hjqy_config = {}

push_config = {}
currency_config = {}
ggzj_config = {}
awake_config = {}
skill_peerless_effect_config = {}
skill_peerless_grade_config = {}
guild_task_config = {}
guild_skill_config = {}
features_open_config = {}
stage_show_config = {}

all_config_name = {
    'activity_type_config': ActivityTypeConfig(),
    'lottery_config': LotteryConfig(),
    'travel_item_group_config': TravelItemGroupConfig(),
    'base_config': BaseConfig(),
    'hero_config': HeroConfig(),
    'hero_exp_config': HeroExpConfig(),
    'item_config': ItemsConfig(),
    'small_bag_config': SmallBagsConfig(),
    'big_bag_config': BigBagsConfig(),
    'equipment_config': EquipmentConfig(),
    'equipment_strengthen_config': EquipmentStrengthenConfig(),
    'set_equipment_config': SetEquipmentConfig(),
    'equipment_attribute_config': EquipmentAttributeConfig(),
    'chip_config': ChipConfig(),
    'shop_config': ShopConfig(),
    'shop_type_config': ShopTypeConfig(),
    'link_config': LinkConfig(),
    'stage_config': StageConfig(),
    'monster_config': MonsterConfig(),
    'monster_group_config': MonsterGroupConfig(),
    'skill_config': SkillConfig(),
    'skill_buff_config': SkillBuffConfig(),
    'guild_config': GuildConfig(),
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
    'travel_event_config': TravelEventConfig(),
    'language_config': LanguageConfig(),
    'achievement_config': AchievementConfig(),
    'travel_item_config': TravelItemConfig(),
    'seal_config': SealConfig(),
    'mine_config': MineConfig(),
    'formula_config': FormulaConfig(),
    'mine_match_config': MineMatchConfig(),
    'stone_config': StoneConfig(),
    'newbee_guide_config': NewbeeGuideConfig(),
    'notes_config': NotesConfig(),
    'recharge_config': RechargeConfig(),
    'lucky_hero_config': LuckyHeroConfig(),
    'pseudo_random_config': PseudoRandomConfig(),
    'push_config': PushConfig(),
    'hjqy_config': HjqyConfig(),
    'currency_config': CurrencyConfig(),
    'ggzj_config': GgzjConfig(),
    'awake_config': AwakeConfig(),
    'indiana_config': IndianaConfig(),
    'skill_peerless_grade_config': PeerlessGradeConfig(),
    'skill_peerless_effect_config': PeerlessEffectConfig(),
    'guild_task_config': GuildTaskConfig(),
    'guild_skill_config': GuildSkillConfig(),
    'features_open_config': FeaturesOpenConfig(),
    'stage_show_config': StageShowConfig(),
}

logger.info("=============load game_configs=============")
module = cPickle.load(open('config/excel_cpickle', 'r'))
for config_name in all_config_name.keys():
    config_value = module.get(config_name)
    objs = all_config_name[config_name].parser(config_value)
    exec(config_name + '=objs')

if __name__ == '__main__':
    print(activity_config.get(55002).get("parameterE"))
    print special_stage_config.get("guild_boss_stages").get(920004)
    #print ggzj_config
    #print base_config.get("EscortFresh")
    #print guild_skill_config
    #print arena_fight_config
    #print awake_config

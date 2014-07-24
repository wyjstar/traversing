# -*- coding:utf-8 -*-
"""
created by server on 14-7-17下午6:54.
"""
import random
from app.game.component.Component import Component
from app.game.core.drop_bag import BigBag
from app.game.core.fight.battle_unit import BattleUnit
from app.game.core.fight.buff import Buff
from app.game.core.fight.skill_helper import SkillHelper
from app.game.core.fight.skill import Skill
from shared.db_opear.configs_data import game_configs
from shared.db_opear.configs_data.common_item import CommonItem


class CharacterFightCacheComponent(Component):
    """战斗缓存组件
    """

    def __init__(self, owner):
        super(CharacterFightCacheComponent, self).__init__(owner)

        self._stage_id = 0  # 关卡ID
        self._drop_num = 0  # 关卡小怪掉落数量
        self._common_drop = 0  # 关卡小怪掉落编号
        self._elite_drop = 0  # 关卡boss掉落编号

        self._red_unit = []  # 红方战斗单位
        self._blue_unit = []  # 蓝方战斗单位  [[]] 二维

    def init_data(self):
        """初始创建红方单位
        """
        red_unit = []
        infos = self.__get_hero_obj()
        for info in infos:
            hero = info.get('hero')
            equipments = info.get('equipments')

            if not hero:
                red_unit.append(None)

            red = self.__assemble_hero(hero, equipments)
            red_unit.append(red)
        self._red_unit = red_unit

    @property
    def stage_id(self):
        return self._stage_id

    @stage_id.setter
    def stage_id(self, stage_id):
        self._stage_id = stage_id

    @property
    def drop_num(self):
        return self._drop_num

    @drop_num.setter
    def drop_num(self, drop_num):
        self._drop_num = drop_num

    def __get_stage_config(self):
        """取得关卡配置数据
        """
        stages_config = game_configs.StageConfig.get('stages', {})
        return stages_config.get(self._stage_id)

    def __get_monster_group_config(self, group_id):
        """取得怪物组信息
        """
        monster_group_config = game_configs.monster_group_config.get(group_id)
        return monster_group_config

    def __get_monster_config(self, monster_id):
        """取得怪物信息
        """
        monster_config = game_configs.monster_config.get(monster_id)
        return monster_config

    def __get_drop_num(self):
        """取得关卡小怪掉落数量
        """
        stage_config = self.__get_stage_config()
        low = stage_config.low
        high = stage_config.high
        drop_num = random.randint(low, high)
        self._drop_num = drop_num
        return drop_num

    def __get_line_up(self):
        """阵容编号
        """
        slots = self.owner.line_up_component.line_up_slots
        return slots

    def __get_hero_obj(self):
        """取得阵容武将对象
        """
        slots = self.__get_line_up()

        infos = []  # [{'hero': obj, 'equipment': [obj]}]
        for slot in slots:
            hero_info = {}
            hero_id = slot.hero_no  # 英雄
            if not hero_id:
                hero_info['hero'] = None
                infos.append(hero_info)
                continue
            hero = self.owner.hero_component.get_hero(hero_id)
            hero_info['hero'] = hero
            hero_info['equipments'] = []
            equipment_ids = slot.equipment_ids
            for equipment_id in equipment_ids.vlues():
                if equipment_id:
                    equipment = self.owner.equipments_obj.get_equipment(equipment_id)
                    hero_info['equipments'].append(equipment)

            infos.append(hero_info)

        return infos

    def __get_hero_links(self, hero):
        links = self.owner.line_up_component.get_links()
        if hero.hero_no in links:
            hero_links = links.get(hero.hero_no, {})
            return [key for key, value in hero_links.items() if value]
        return []

    def __parse_buffs(self, buffs):
        """解析buffs
        """
        hp_up = 0  # HP上限增加
        hp_up_rate = 0  # HP上限增加率
        hp_down = 0  # HP上限减少
        hp_down_rate = 0  # HP上限减少率

        atk_up = 0  # ATK上限增加
        atk_up_rate = 0  # ATK上限增加率
        atk_down = 0  # ATK上限减少
        atk_down_rate = 0  # ATK上限减少率

        physical_def_up = 0  # 物理防御增加
        physical_def_up_rate = 0  # 物理防御增加率
        physical_def_down = 0  # 物理防御减少
        physical_def_down_rate = 0  # 物理防御减少率

        magic_def_up = 0  # 魔法防御增加
        magic_def_up_rate = 0  # 魔法防御增加率
        magic_def_down = 0  # 魔法防御减少
        magic_def_down_rate = 0  # 魔法防御减少率

        for buff in buffs:
            if buff.effec_id == 4 and buff.value_type == 1:
                hp_up += buff.value_effect
                continue
            if buff.effec_id == 4 and buff.value_type == 2:
                hp_up_rate += buff.value_effect
                continue

            if buff.effec_id == 5 and buff.value_type == 1:
                hp_down += buff.value_effect
                continue

            if buff.effec_id == 5 and buff.value_type == 2:
                hp_down_rate += buff.value_effect
                continue

            if buff.effec_id == 6 and buff.value_type == 1:
                atk_up += buff.value_effect
                continue

            if buff.effec_id == 6 and buff.value_type == 2:
                atk_up_rate += buff.value_effect
                continue

            if buff.effec_id == 7 and buff.value_type == 1:
                atk_down += buff.value_effect
                continue

            if buff.effec_id == 7 and buff.value_type == 2:
                atk_down_rate += buff.value_effect
                continue

            if buff.effec_id == 10 and buff.value_type == 1:
                physical_def_up += buff.value_effect
                continue

            if buff.effec_id == 10 and buff.value_type == 2:
                physical_def_up_rate += buff.value_effect
                continue

            if buff.effec_id == 11 and buff.value_effect == 1:
                physical_def_down += buff.value_effect
                continue

            if buff.effec_id == 11 and buff.value_type == 2:
                physical_def_down_rate += buff.value_effect
                continue

            if buff.effec_id == 12 and buff.value_effect == 1:
                magic_def_up += buff.value_effect
                continue

            if buff.effec_id == 12 and buff.value_type == 2:
                magic_def_up_rate += buff.value_effect
                continue

            if buff.effec_id == 13 and buff.value_type == 1:
                magic_def_down += buff.value_effect
                continue

            if buff.effec_id == 13 and buff.value_type == 2:
                magic_def_down_rate += buff.value_effect
                continue
        return CommonItem(
            dict(hp_up=hp_up, hp_up_rate=hp_up_rate, hp_down=hp_down, hp_down_rate=hp_down_rate, atk_up=atk_up,
                 atk_up_rate=atk_up_rate, atk_down=atk_down, atk_down_rate=atk_down_rate,
                 physical_def_up=physical_def_up, physical_def_up_rate=physical_def_up_rate,
                 physical_def_down=physical_def_down, physical_def_down_rate=physical_def_down_rate,
                 magic_def_up=magic_def_up, magic_def_up_rate=magic_def_up_rate, magic_def_down=magic_def_down,
                 magic_def_down_rate=magic_def_down_rate))

    def __assemble_hero(self, hero, equipments):
        """组装英雄战斗单位
        """
        # 英雄属性 升级成长
        common_item = hero.calculate_attr()

        # 装备附加属性 强化成长
        equ_atk = 0
        equ_hp = 0
        equ_physical_def = 0
        equ_magic_def = 0

        for equipment in equipments:
            atk, hp, physical_def, magic_def = equipment.calculate_attr()
            equ_atk += atk
            equ_hp += hp
            equ_physical_def += physical_def
            equ_magic_def += magic_def

        # 技能附加属性
        skill_ids = []
        break_skill_ids = common_item.break_skill_ids  # 突破技能
        link_skill_ids = self.__get_hero_links(hero)  # 羁绊技能

        skill_ids.extend(break_skill_ids)
        skill_ids.extend(link_skill_ids)

        skills = []
        for skill_id in skill_ids:
            skill = Skill(skill_id)
            skill.init_attr()
        buff_helper = SkillHelper(skills)
        buff_helper.init_attr()

        common_attr = self.__parse_buffs(buff_helper.buffs)

        no = common_item.hero_no
        quality = common_item.quality
        normal_skill = common_item.normal_skill
        rage_skill = common_item.rage_skill
        hp = common_item.hp + equ_hp + common_attr.hp_up + common_item.hp * common_attr.hp_up_rate - common_attr.hp_down - common_item.hp * common_attr.hp_down_rate
        atk = common_item.atk + equ_atk + common_attr.atk_up + common_item.atk * common_attr.atk_up_rate - common_attr.atk_down - common_item.atk * common_attr.atk_down_rate
        physical_def = common_item.physica_def + equ_physical_def + common_attr.physical_def_up + common_item.physica_def * common_attr.physical_def_up_rate - common_attr.physical_def_down - common_item.physica_def * common_attr.physical_def_down_rate
        magic_dif = common_item.magic_def + equ_magic_def + common_attr.magic_def_up + common_item.magic_def * common_attr.magic_def_up_rate - common_attr.magic_def_down - common_item.magic_def * common_attr.magic_def_down_rate
        hit = common_item.hit
        dodge = common_item.dodge
        cri = common_item.cri
        cri_coeff = common_item.cri_coeff
        cri_ded_coeff = common_item.cri_ded_coeff
        block = common_item.block
        is_boss = 15

        battlt_unit = self.__do_assemble(no, quality, normal_skill, rage_skill, hp, atk, physical_def, magic_dif, hit,
                                         dodge, cri, cri_coeff, cri_ded_coeff, block, is_boss)

        return battlt_unit

    def __do_assemble(self, no, quality, normal_skill, rage_skill, hp, atk, physical_def, magic_dif, hit, dodge,
                      cri, cri_coeff, cri_ded_coeff, block, is_boss=False):
        battle_unit = BattleUnit(no)
        battle_unit.quality = quality
        battle_unit.normal_skill = normal_skill
        battle_unit.rage_skill = rage_skill
        battle_unit.hp = hp
        battle_unit.atk = atk
        battle_unit.physical_def = physical_def
        battle_unit.magic_dif = magic_dif
        battle_unit.hit = hit
        battle_unit.dodge = dodge
        battle_unit.cri = cri
        battle_unit.cri_coeff = cri_coeff
        battle_unit.cri_ded_coeff = cri_ded_coeff
        battle_unit.block = block
        battle_unit.is_boss = is_boss
        return battle_unit

    def __assmble_monsters(self):
        """组装怪物战斗单位
        """
        stage_config = self.__get_stage_config()  # 关卡配置

        monsters = []
        for i in range(3):
            monster_group_config = self.__get_monster_group_config(getattr(stage_config, 'round%s' % (i + 1)))
            round_monsters = []

            boss_position = monster_group_config.bossPosition

            for j in range(6):
                monster_id = getattr(monster_group_config, 'pos%s' % (j + 1))
                if not monster_id:
                    round_monsters.append(None)
                    continue
                is_boss = False
                if j + 1 == boss_position:
                    is_boss = True
                monster_config = self.__get_monster_config(monster_id)
                battle_unit = self.__do_assemble(monster_config.id, monster_config.quality, monster_config.normalSkill,
                                                 monster_config.rageSkill, monster_config.hp, monster_config.atk,
                                                 monster_config.physicalDef, monster_config.magicDef,
                                                 monster_config.hit, monster_config.dodge,
                                                 monster_config.cri, monster_config.criCoeff,
                                                 monster_config.criDedCoeff, monster_config.block,
                                                 monster_config.block, is_boss)
                round_monsters.append(battle_unit)
        monsters.append(round_monsters)

        # 保存关卡怪物信息, 掉落信息
        self._blue_unit = monsters
        self._common_drop = stage_config.commonDrop
        self._elite_drop = stage_config.eliteDrop

        return monsters

    def fighting_start(self):
        """战斗开始
        """
        # heros = self.__get_hero_obj()
        #
        # print '#3:', heros
        #
        # red_units = [self.__assemble_hero(hero) if hero else None for hero in heros]  # 英雄单位

        red_units = self._red_unit

        drop_num = self.__get_drop_num()  # 掉落数量
        blue_units = self.__assmble_monsters()

        return red_units, blue_units, drop_num

    def fighting_settlement(self, result):
        """战斗结算
        """

        # TODO 根据result更新stage信息

        drops = []
        # 关卡掉落
        for _ in range(self._drop_num):
            common_bag = BigBag(self._common_drop)
            common_drop = common_bag.get_drop_items()
            drops.extend(common_drop)

        elite_bag = BigBag(self._common_drop)
        elite_drop = elite_bag.get_drop_items()
        drops.extend(elite_drop)

        return drops














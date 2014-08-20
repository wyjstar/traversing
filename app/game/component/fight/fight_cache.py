# -*- coding:utf-8 -*-
"""
created by server on 14-7-17下午6:54.
"""
import random
from app.game.component.Component import Component
from app.game.core.drop_bag import BigBag
from app.game.core.fight.battle_unit import BattleUnit
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
        for no, slot in self.line_up_slots.items():

            # 英雄
            hero_obj = slot.hero_slot.hero_obj

            if not hero_obj:
                continue

            # hero_no, quality, hp, atk, physica_def, magic_def, hit
            # dodge, cri, cri_coeff, cri_ded_coeff, block, normal_skill
            # rage_skill, break_skills

            hero_base_attr = hero_obj.calculate_attr()  # 英雄基础属性，等级成长

            # hp, hp_rate, atk, atk_rate,physical_def,physical_def_rate,
            # magic_def, magic_def_rate, hit, dodge, cri, cri_coeff, cri_ded_coeff, block

            attr = CommonItem()
            hero_break_attr = hero_obj.bread_attr()  # 英雄突破技能属性
            attr += hero_break_attr

            hero_link_attr = slot.hero_slot.link_attr  # 英雄羁绊技能属性
            attr += hero_link_attr

            # 装备
            equ_slots = slot.equipment_slots

            for equ_no, equ_slot in equ_slots.items():

                # atk,hp, physical_def, magic_def, hit, dodge, cri, cri_coeff, cri_ded_coeff, block
                equipment_base_attr = equ_slot.equipment_obj.calculate_attr()  # 装备基础属性，强化等级
                attr += equipment_base_attr

            equ_suit = slot.equ_suit  # 装备套装技能属性
            attr += equ_suit

            red = self.__assemble_hero(hero_base_attr, attr)
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

    @property
    def line_up_slots(self):
        """阵容
        """
        slots = self.owner.line_up_component.line_up_slots
        return slots

    def __assemble_hero(self, base_attr, attr):
        """组装英雄战斗单位
        """
        # base_attr: 英雄基础，等级 属性
        # hero_no, quality, hp, atk, physica_def, magic_def, hit
        # dodge, cri, cri_coeff, cri_ded_coeff, block, normal_skill
        # rage_skill, break_skills

        # attr: 属性
        # hp, hp_rate, atk, atk_rate,physical_def,physical_def_rate,
        # magic_def, magic_def_rate, hit, dodge, cri, cri_coeff, cri_ded_coeff, block

        no = base_attr.hero_no
        quality = base_attr.quality

        normal_skill = base_attr.normal_skill
        rage_skill = base_attr.rage_skill
        break_skills = base_attr.break_skills

        hp = base_attr.hp + base_attr.hp * attr.hp_rate + attr.hp
        atk = base_attr.atk + base_attr.atk * attr.atk_rate + attr.atk
        physical_def = base_attr.physical_def + base_attr.physical_def * attr.physical_def_rate + attr.physical_def
        magic_dif = base_attr.magic_def + base_attr.magic_def * attr.magic_def_rate + attr.magic_def
        hit = base_attr.hit + attr.hit
        dodge = base_attr.dodge + attr.dodge
        cri = base_attr.cri + attr.cri
        cri_coeff = base_attr.cri_coeff + attr.cri_coeff
        cri_ded_coeff = base_attr.cri_ded_coeff + attr.cri_ded_coeff
        block = base_attr.block + attr.block
        is_boss = False

        battlt_unit = self.__do_assemble(no, quality, normal_skill, rage_skill, break_skills, hp, atk, physical_def,
                                         magic_dif, hit, dodge, cri, cri_coeff, cri_ded_coeff, block, is_boss)

        return battlt_unit

    def __do_assemble(self, no, quality, normal_skill, rage_skill, break_skills, hp, atk, physical_def, magic_dif,
                      hit, dodge, cri, cri_coeff, cri_ded_coeff, block, is_boss=False):
        battle_unit = BattleUnit(no)
        battle_unit.quality = quality
        battle_unit.normal_skill = normal_skill
        battle_unit.rage_skill = rage_skill
        battle_unit.break_skills = break_skills
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
        self.stage_component.settlement(self._stage_id, result)
        self.stage_component.update()
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














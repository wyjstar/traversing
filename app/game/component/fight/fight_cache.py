# -*- coding:utf-8 -*-
"""
created by server on 14-7-17下午6:54.
"""
import random
from app.game.component.Component import Component
from app.game.core.drop_bag import BigBag
from app.game.core.fight.battle_unit import BattleUnit
from shared.db_opear.configs_data import game_configs


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
        heros = self.__get_hero_obj()
        self._red_unit = [self.__assemble_hero(hero) if hero else None for hero in heros]

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
        hero_ids = self.owner.line_up_component.hero_ids
        print '##1:', hero_ids
        return hero_ids

    def __get_hero_obj(self):
        """取得阵容武将对象
        """
        hero_ids = self.__get_line_up()
        heros = self.owner.hero_component.get_multi_hero(*hero_ids)
        return heros

    def __get_hero_links(self, hero):
        links = self.owner.line_up_component.get_links()
        if hero.hero_no in links:
            hero_links = links.get(hero.hero_no, {})
            return [key for key, value in hero_links.items() if value]
        return []

    def __assemble_hero(self, hero):
        """组装英雄战斗单位
        """

        print '#2:', hero

        common_item = hero.calculate_attr()

        break_skill_ids = common_item.break_skill_ids  # 突破技能
        link_skill_ids = self.__get_hero_links(hero)  # 羁绊技能

        # TODO 技能属性显示解析

        no = 1
        quality = 2
        normal_skill = 3
        rage_skill = 4
        hp = 5
        atk = 6
        physical_def = 7
        magic_dif = 8
        hit = 9
        dodge = 10
        cri = 11
        cri_coeff = 12
        cri_ded_coeff = 13
        block = 14
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














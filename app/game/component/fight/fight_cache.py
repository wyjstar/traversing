# -*- coding:utf-8 -*-
"""
created by server on 14-7-17下午6:54.
"""
import random
from app.game.component.Component import Component
from app.game.core.drop_bag import BigBag
from app.game.logic.fight import do_assemble
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

    @property
    def red_unit(self):
        """初始创建红方单位
        """
        red_unit = []
        for no, slot in self.line_up_slots.items():
            red = slot.slot_attr()
            red_unit.append(red)
        self._red_unit = red_unit
        return self._red_unit

    @red_unit.setter
    def red_unit(self, value):
        self._red_unit = value

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
        stages_config = game_configs.stage_config.get('stages')
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
                pos = j + 1
                monster_id = getattr(monster_group_config, 'pos%s' % pos)
                if not monster_id:
                    round_monsters.append(None)
                    continue
                is_boss = False
                if j + 1 == boss_position:
                    is_boss = True
                monster_config = self.__get_monster_config(monster_id)
                monster_normal_config = game_configs.skill_config.get(monster_config.normalSkill)
                monster_rage_config = game_configs.skill_config.get(monster_config.rageSkill)
                # 取得怪物普通技能
                normal_skill = [monster_config.normalSkill]
                normal_skill.extend(monster_normal_config.group)
                # 取得怪物怒气技能
                rage_skill = [monster_config.rageSkill]
                rage_skill.extend(monster_rage_config.group)

                battle_unit = do_assemble(monster_config.id, monster_config.quality, normal_skill,
                                          rage_skill, None, monster_config.hp, monster_config.atk,
                                          monster_config.physicalDef, monster_config.magicDef,
                                          monster_config.hit, monster_config.dodge,
                                          monster_config.cri, monster_config.criCoeff,
                                          monster_config.criDedCoeff, monster_config.block,
                                          pos,
                                          is_boss)
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

        red_units = self.red_unit

        drop_num = self.__get_drop_num()  # 掉落数量
        blue_units = self.__assmble_monsters()

        return red_units, blue_units, drop_num

    def fighting_settlement(self, stage_id, result):
        """战斗结算
        """

        # TODO 根据result更新stage信息; 校验stage_id
        self.owner.stage_component.settlement(self._stage_id, result)
        self.owner.stage_component.update()
        drops = []
        if not result:
            return drops
        # 关卡掉落
        for _ in range(self._drop_num):
            common_bag = BigBag(self._common_drop)
            common_drop = common_bag.get_drop_items()
            drops.extend(common_drop)

        elite_bag = BigBag(self._common_drop)
        elite_drop = elite_bag.get_drop_items()
        drops.extend(elite_drop)

        return drops














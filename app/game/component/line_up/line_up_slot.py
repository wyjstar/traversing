# -*- coding:utf-8 -*-
"""
created by server on 14-7-5下午3:25.
"""
import cPickle
from app.game.component.Component import Component
from app.game.component.line_up.equipment_slot import EquipmentSlotComponent
from app.game.component.line_up.hero_slot import HeroSlotComponent
from app.game.logic.fight import do_assemble
from shared.db_opear.configs_data import game_configs
from shared.db_opear.configs_data.common_item import CommonItem


class LineUpSlotComponent(Component):
    """阵容位置信息组件， 包括1个英雄格子，6个装备格子
    """

    def __init__(self, owner, slot_no, activation=False, hero_no=0, equipment_ids={}.fromkeys([1, 2, 3, 4, 5, 6], 0)):
        """
        """

        super(LineUpSlotComponent, self).__init__(owner)

        self._slot_no = slot_no
        self._activation = activation
        self._hero_slot = HeroSlotComponent(self, slot_no, activation, hero_no)
        self._equipment_slots = dict([(equ_slot_no, EquipmentSlotComponent(self, equ_slot_no, activation, equipment_id))
                                      for equ_slot_no, equipment_id in equipment_ids.items()])

    @property
    def equipment_slots(self):
        return self._equipment_slots

    @property
    def slot_no(self):
        return self._slot_no

    @slot_no.setter
    def slot_no(self, slot_no):
        self._slot_no = slot_no

    @property
    def activation(self):
        return self._activation

    @activation.setter
    def activation(self, activation):
        self._activation = activation

    @property
    def hero_slot(self):
        return self._hero_slot

    @property
    def info(self):
        """卡牌信息
        """
        return dict(slot_no=self._slot_no, activation=self._activation, hero_no=self._hero_slot.hero_no,
                    equipment_ids=dict([(slot.id, slot.equipment_id) for slot in self._equipment_slots.values()]))

    @classmethod
    def loads(cls, owner, data):
        """解压
        """
        info = cPickle.loads(data)
        slot = cls(owner, **info)
        return slot

    def dumps(self):
        """压缩
        """
        return cPickle.dumps(self.info)

    def change_hero(self, hero_no):
        """更换英雄
        @param hero_no: 英雄编号
        @return:
        """
        self._hero_slot.hero_no = hero_no

    def change_equipment(self, no, equipment_id):
        """更换装备
        @param equipment_id:
        @return:
        """
        equipment_slot = self._equipment_slots.get(no)
        equipment_slot.equipment_id = equipment_id

    @property
    def equipment_objs(self):
        """装备obj list
        """
        return [slot.equipment_obj for slot in self._equipment_slots.values()]

    def get_equipment_obj(self, equipment_id):
        """取得装备对象
        """
        return self.owner.get_equipment_obj(equipment_id)

    def get_hero_obj(self, hero_no):
        return self.owner.get_hero_obj(hero_no)

    @property
    def equipment_nos(self):
        """装备编号 list
        """
        return [equipment_obj.base_info.equipment_no for equipment_obj in self.equipment_objs if equipment_obj]

    @property
    def hero_nos(self):
        """英雄编号 list
        """
        return self.owner.hero_nos

    @property
    def equ_suit(self):
        """套装信息
        """
        suit_info = {}  # suit_no:attr
        for no, slot in self._equipment_slots.items():
            suit = slot.suit
            suit_no = suit.get('suit_no')
            if not suit_no or suit_no in suit_info or not slot.suit_attr:
                continue
            suit_info[suit_no] = slot.suit_attr
        return suit_info

    def slot_attr(self):
        """
        """
        # 英雄
        hero_obj = self.hero_slot.hero_obj

        if not hero_obj:
            return None

        # hero_no, quality, hp, atk, physical_def, magic_def, hit
        # dodge, cri, cri_coeff, cri_ded_coeff, block, normal_skill
        # rage_skill, break_skills

        hero_base_attr = hero_obj.calculate_attr()  # 英雄基础属性，等级成长

        # hp, hp_rate, atk, atk_rate,physical_def,physical_def_rate,
        # magic_def, magic_def_rate, hit, dodge, cri, cri_coeff, cri_ded_coeff, block

        attr = CommonItem()
        hero_break_attr = hero_obj.break_attr()  # 英雄突破技能属性
        attr += hero_break_attr
        hero_link_attr = self.hero_slot.link_attr  # 英雄羁绊技能属性
        attr += hero_link_attr

        # 装备
        equ_slots = self.equipment_slots

        for equ_no, equ_slot in equ_slots.items():
            # atk,hp, physical_def, magic_def, hit, dodge, cri, cri_coeff, cri_ded_coeff, block

            equ_obj = equ_slot.equipment_obj
            if not equ_obj:
                continue
            equipment_base_attr = equ_obj.calculate_attr()  # 装备基础属性，强化等级
            attr += equipment_base_attr
        equ_suit = self.equ_suit  # 装备套装技能属性
        for equ_attr in equ_suit.values():
            attr += equ_attr
        red = self.__assemble_hero(hero_base_attr, attr)
        return red

    def __assemble_hero(self, base_attr, attr):
        """组装英雄战斗单位
        """
        # base_attr: 英雄基础，等级 属性
        # hero_no, quality, hp, atk, physical_def, magic_def, hit
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
        magic_def = base_attr.magic_def + base_attr.magic_def * attr.magic_def_rate + attr.magic_def
        hit = base_attr.hit + attr.hit
        dodge = base_attr.dodge + attr.dodge
        cri = base_attr.cri + attr.cri
        cri_coeff = base_attr.cri_coeff + attr.cri_coeff
        cri_ded_coeff = base_attr.cri_ded_coeff + attr.cri_ded_coeff
        block = base_attr.block + attr.block
        is_boss = False
        position = self._position

        battlt_unit = do_assemble(no, quality, normal_skill, rage_skill, break_skills, hp, atk, physical_def,
                                  magic_def, hit, dodge, cri, cri_coeff, cri_ded_coeff, block, position, is_boss)

        return battlt_unit

    def combat_power(self):
        """战斗力
        ((攻击 + 物防 + 魔防) * 血量) ^ 战斗力系数A * （命中率 + 闪避率） * （1 + 暴击率 * （暴击伤害系数 + 暴击伤害减免系数 - 100）/ 10000）*
        (（100 + 格挡率 * （1 - 格挡伤害系数）) / 100 * 战斗力系数B）
        """
        unit = self.slot_attr()
        if not unit:
            return 0
        return (((unit.atk + unit.physical_def + unit.magic_def) * unit.hp) ** game_configs.base_config.get(
            'zhandouli_xishu_a', 0.5)) * (unit.hit + unit.dodge) * (
               1 + unit.cri * (unit.cri_coeff + unit.cri_ded_coeff - 100) / 10000) * ((100 + unit.block * (
               1 - game_configs.base_config.get('a4', 0.7))) / 100 * game_configs.base_config.get(
               'zhandouli_xishu_b', 1))



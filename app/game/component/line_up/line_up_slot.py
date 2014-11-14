# -*- coding:utf-8 -*-
"""
created by server on 14-7-5下午3:25.
"""
import cPickle
from app.game.component.Component import Component
from app.game.component.line_up.equipment_slot import EquipmentSlotComponent
from app.game.component.line_up.hero_slot import HeroSlotComponent
from app.battle.battle_unit import do_assemble
from app.game.redis_mode import tb_character_lord
from shared.db_opear.configs_data import game_configs
from shared.db_opear.configs_data.common_item import CommonItem


class LineUpSlotComponent(Component):
    """阵容位置信息组件， 包括1个英雄格子，6个装备格子
    """

    def __init__(self, owner, slot_no, activation=False, hero_no=0,
                 equipment_ids={}.fromkeys([1, 2, 3, 4, 5, 6], None)):
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

        if equipment_id != '0' and not self.check_equipment_pos(no, equipment_id):
            return False

        equipment_slot = self._equipment_slots.get(no)
        equipment_slot.equipment_id = equipment_id

        return True

    def check_equipment_pos(self, no, equipment_id):
        """校验装备类型
        @param no:
        @param equipment_id:
        @return:
        """
        equ_obj = self.get_equipment_obj(equipment_id)
        equipment_type = equ_obj.attribute.equipment_type
        if no == equipment_type:
            return True
        return False

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

    @property
    def slot_attr(self):
        """
        """
        hero_base_attr, attr, hero_obj = self.hero_attr()

        if not hero_base_attr:
            return None

        equ_attr = self.equ_attr()
        attr += equ_attr
        red = self.__assemble_hero(hero_base_attr, attr, hero_obj)
        return red

    def hero_attr(self):
        """
        英雄属性：包括突破和羁绊
        """
        attr = CommonItem()
        # 英雄
        hero_obj = self.hero_slot.hero_obj

        if not hero_obj:
            return None, attr, hero_obj

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
        return hero_base_attr, attr, hero_obj

    def equ_attr(self):
        """
        装备属性：
        """
        attr = CommonItem()
        # 装备
        equ_slots = self.equipment_slots
        for equ_no, equ_slot in equ_slots.items():
            # atk,hp, physical_def, magic_def, hit, dodge, cri, cri_coeff, cri_ded_coeff, block
            equ_obj = equ_slot.equipment_obj
            if not equ_obj:
                continue
            equipment_base_attr = equ_obj.calculate_attr()  # 装备基础属性，强化等级
            attr += equipment_base_attr
        suit_attr = CommonItem()
        equ_suit = self.equ_suit  # 装备套装技能属性
        for temp in equ_suit.values():
            suit_attr += temp

        attr += suit_attr
        return attr

    def __assemble_hero(self, base_attr, attr, hero_obj):
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


        break_skills = hero_obj.break_skill_buff_ids


        hp = base_attr.hp + base_attr.hp * attr.hp_rate + attr.hp + hero_obj.break_param * hero_obj.hero_info.hp

        atk = base_attr.atk + base_attr.atk * attr.atk_rate + attr.atk + hero_obj.break_param * hero_obj.hero_info.atk
        physical_def = base_attr.physical_def + base_attr.physical_def * attr.physical_def_rate + attr.physical_def + hero_obj.break_param * hero_obj.hero_info.physicalDef
        magic_def = base_attr.magic_def + base_attr.magic_def * attr.magic_def_rate + attr.magic_def + hero_obj.break_param * hero_obj.hero_info.magicDef
        hit = base_attr.hit + attr.hit
        dodge = base_attr.dodge + attr.dodge
        cri = base_attr.cri + attr.cri
        cri_coeff = base_attr.cri_coeff + attr.cri_coeff
        cri_ded_coeff = base_attr.cri_ded_coeff + attr.cri_ded_coeff
        block = base_attr.block + attr.block

        level = base_attr.level
        break_level = base_attr.break_level

        is_boss = False

        line_up_order = self.owner.line_up_order
        position = line_up_order.index(self._slot_no)
        position += 1
        ductility = 0
        battlt_unit = do_assemble(no, quality, break_skills,
                                  hp, atk, physical_def, magic_def, hit, dodge, cri, cri_coeff, cri_ded_coeff, block,
                                  ductility, position,
                                  level, is_boss)

        return battlt_unit

    def combat_power(self):
        """战斗力
        ((攻击 + 物防 + 魔防) * 血量) ^ 战斗力系数A * （命中率 + 闪避率） * （1 + 暴击率 * （暴击伤害系数 + 暴击伤害减免系数 - 100）/ 10000）*
        (（100 + 格挡率 * （1 - 格挡伤害系数）) / 100 * 战斗力系数B）
        """
        unit = self.slot_attr
        if not unit:
            return 0
        return (((unit.atk + unit.physical_def + unit.magic_def) * unit.hp) ** game_configs.base_config.get(
            'zhandouli_xishu_a', 0.5)) * (unit.hit + unit.dodge) * (
                   1 + unit.cri * (unit.cri_coeff + unit.cri_ded_coeff - 100) / 10000) * ((100 + unit.block * (
            1 - game_configs.base_config.get('a4', 0.7))) / 100 * game_configs.base_config.get(
            'zhandouli_xishu_b', 1))

    def update_lord_info(self):
        """
        更新主将属性
        """
        unit = self.slot_attr
        lord_data = tb_character_lord.getObjData(self.owner.character_id)
        if lord_data:
            lord_obj = tb_character_lord.getObj(self.owner.character_id)
            lord_obj.update('attr_info', {'info': unit.dumps(), 'power': self.combat_power()})
        else:
            tb_character_lord.new({'id': self.owner.character_id, 'attr_info': {'info': unit.dumps(),
                                                                                'power': self.combat_power()}})

    @property
    def first_slot(self):
        """取得第一个格子
        """
        return self.owner.line_up_slots.get(1)
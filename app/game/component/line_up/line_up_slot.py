# -*- coding:utf-8 -*-
"""
created by server on 14-7-5下午3:25.
"""
import cPickle
from app.game.component.Component import Component
from app.game.component.line_up.equipment_slot import EquipmentSlotComponent
from app.game.component.line_up.hero_slot import HeroSlotComponent
from app.battle.battle_unit import do_assemble
from app.game.redis_mode import tb_character_info
from shared.db_opear.configs_data import game_configs
from shared.db_opear.configs_data.common_item import CommonItem
from gfirefly.server.logobj import logger
from app.game.component.fight.hero_attr_cal import combat_power


class LineUpSlotComponent(Component):
    """阵容位置信息组件， 包括1个英雄格子，6个装备格子
    """

    def __init__(self, owner, slot_no, activation=False,
                 hero_no=0, hero_level=0,
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
        hero_level = self._hero_slot.hero_obj.level if self._hero_slot.hero_obj else 0
        return dict(slot_no=self._slot_no,
                    activation=self._activation,
                    hero_no=self._hero_slot.hero_no,
                    hero_level=hero_level,
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
        if hero_no == 0:
            for i in range(1, 7):
                self.change_equipment(i, '0')
        self._hero_slot.hero_no = hero_no
        self.update_lord_info()

    def change_equipment(self, no, equipment_id):
        """更换装备
        @param equipment_id:
        @return:
        """

        if equipment_id != '0' and not self.check_equipment_pos(no, equipment_id):
            return False

        equipment_slot = self._equipment_slots.get(no)
        equipment_slot.equipment_id = equipment_id
        self.update_lord_info()

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
    def set_equ_skill_ids(self):
        """套装技能ids"""
        skill_ids = []  # suit_no:attr
        for no, slot in self._equipment_slots.items():
            slot_suit_skills = slot.suit_skills
            skill_ids = list(set(skill_ids).union(set(slot_suit_skills)))

        return skill_ids

    @property
    def slot_attr(self):
        """
        """
        hero = self._hero_slot.hero_obj
        if not hero:
            return None
        return self.assemble_hero(hero)

    #def hero_attr(self):
        #"""
        #英雄属性：包括突破和羁绊
        #"""
        #attr = CommonItem()
        ## 英雄
        #hero_obj = self.hero_slot.hero_obj

        #if not hero_obj:
            #return None, attr, hero_obj

        ## hero_no, quality, hp, atk, physical_def, magic_def, hit
        ## dodge, cri, cri_coeff, cri_ded_coeff, block, normal_skill
        ## rage_skill, break_skills

        #hero_base_attr = hero_obj.calculate_attr()  # 英雄基础属性，等级成长

        ## hp, hp_rate, atk, atk_rate,physical_def,physical_def_rate,
        ## magic_def, magic_def_rate, hit, dodge, cri, cri_coeff, cri_ded_coeff, block

        #attr = CommonItem()
        #hero_break_attr = hero_obj.break_attr()  # 英雄突破技能属性
        #attr += hero_break_attr
        #hero_link_attr = self.hero_slot.link_attr  # 英雄羁绊技能属性
        #attr += hero_link_attr

        #if hero_obj.refine != 0:
            #_refine_attr = game_configs.seal_config.get(hero_obj.refine)
            #if _refine_attr:
                #attr += _refine_attr
                #extra_attr = None
                #for k, v in game_configs.seal_config:
                    #if v.get('allInt') > 0:
                        #continue
                    #if v.get('allInt2') > _refine_attr.get('allInt2'):
                        #continue
                    #extra_attr = v
                #if extra_attr:
                    #attr += extra_attr

            #else:
                #logger.error('cant find refine config:%s', hero_obj.refine)
        #attr += self.owner.owner.travel_component.get_travel_item_attr()

        #return hero_base_attr, attr, hero_obj

    def equ_attr(self, hero_self_attr):
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
            equipment_base_attr = equ_obj.calculate_attr(hero_self_attr)  # 装备基础属性，强化等级
            attr += equipment_base_attr
        return attr

    def set_equ_attr(self):
        """
        套装属性
        """
        suit_attr = CommonItem()
        equ_suit = self.equ_suit  # 装备套装技能属性
        for temp in equ_suit.values():
            suit_attr += temp

        return suit_attr

    def get_battle_unit(self, stage):
        """docstring for get_battle_unit"""
        hero = self._hero_slot.hero_obj
        if not hero:
            return None
        return self.assemble_hero(hero, stage)

    def assemble_hero(self, hero, stage=None):
        """docstring for assemble_hero"""

        line_up_order = self.owner.line_up_order

        attr = combat_power.hero_lineup_attr(self.owner.owner, hero, self._slot_no, stage)
        hero_no = hero.hero_no
        quality = hero.hero_info.get("quality")
        break_skill_buff_ids = []
        hp = attr.get("hpHeroLine")
        atk = attr.get("atkHeroLine")
        physical_def = attr.get("physicalDefHeroLine")
        magic_def = attr.get("magicDefHeroLine")
        hit = attr.get("hitArray")
        dodge = attr.get("dodgeArray")
        cri = attr.get("criArray")
        cri_coeff = attr.get("criCoeffArray")
        cri_ded_coeff = attr.get("criDedCoeffArray")
        block = attr.get("blockArray")
        ductility = attr.get("ductilityArray")

        logger.debug(self._slot_no)
        logger.debug(line_up_order)
        position = line_up_order[self._slot_no - 1]
        logger.debug(position)
        #position += 1
        is_boss = False
        power = self.combat_power_lineup()
        battlt_unit = do_assemble(self._slot_no, hero_no, quality, break_skill_buff_ids,
                                  hp, atk, physical_def, magic_def, hit,
                                  dodge, cri, cri_coeff, cri_ded_coeff,
                                  block, ductility, position, hero.level,
                                  hero.break_level, is_boss, power=power, awake_level=hero.awake_level)

        return battlt_unit

    def combat_power_lineup(self):
        hero = self._hero_slot.hero_obj
        if not hero:
            return 0
        return combat_power.combat_power_hero_lineup(self.owner.owner, self._hero_slot.hero_obj, self._slot_no)

    def combat_power(self):
        """战斗力
        ((攻击 + 物防 + 魔防) * 血量) ^ 战斗力系数A * （命中率 + 闪避率） * （1 + 暴击率 * （暴击伤害系数 + 暴击伤害减免系数 - 100）/ 10000）*
        (（100 + 格挡率 * （1 - 格挡伤害系数）) / 100 * 战斗力系数B）
        """
        #self._owner.update_guild_attr()
        unit = self.slot_attr
        if not unit:
            return 0
        if 'fightValue' not in game_configs.formula_config:
            logger.error('can not find fightValue')
            return 0
        formula = game_configs.formula_config.get('fightValue').formula
        allVars = dict(atk=unit.atk,
                       physicalDef=unit.physical_def,
                       magicDef=unit.magic_def,
                       hp=unit.hp,
                       hit=unit.hit,
                       dodge=unit.dodge,
                       cri=unit.cri,
                       criCoeff=unit.cri_coeff,
                       criDedCoeff=unit.cri_ded_coeff,
                       block=unit.block,
                       ductility=unit.ductility)
        result = eval(formula, allVars, allVars)
        return result

    def update_lord_info(self):
        """
        更新主将属性
        """
        #import traceback
        #traceback.print_stack()
        if self._slot_no != self._owner._caption_pos:
            return
        #self._owner.guild_attr
        logger.debug("update_lord_info========== %s" % self._owner.guild_attr)
        unit = self._owner.get_first_slot().slot_attr
        #logger.debug("update_lord_info========== %s" % unit)
        if not unit:
            return
        lord_obj = tb_character_info.getObj(self._owner._owner.character_id)
        if lord_obj:
            ap = self.combat_power_lineup()
            data = {'info': unit.dumps(), 'power': ap}
            lord_obj.hset('lord_attr_info', data)

    @property
    def first_slot(self):
        """取得第一个格子
        """
        return self.owner.line_up_slots.get(1)

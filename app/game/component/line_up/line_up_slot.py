# -*- coding:utf-8 -*-
"""
created by server on 14-7-5下午3:25.
"""
import cPickle
from app.game.component.Component import Component
from app.game.component.line_up.equipment_slot import EquipmentSlotComponent
from app.game.component.line_up.hero_slot import HeroSlotComponent


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
            if suit_no in suit_info:
                continue
            suit_info[suit_no] = slot.suit_attr
        return suit_info


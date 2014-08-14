# -*- coding:utf-8 -*-
"""
created by server on 14-7-5下午3:25.
"""
import cPickle
from app.game.component.line_up.equipment_slot import EquipmentSlotComponent
from app.game.component.line_up.hero_slot import HeroSlotComponent


class LineUpSlot(object):
    """阵容位置信息， 包括1个英雄格子，6个装备格子
    """

    def __init__(self, slot_no, activation, bid=1, name=''):
        """
        @param bid:  阵容ID  暂时忽略
        @param name:  阵容名称 暂时忽略
        @param slot_no:  阵容格子编号
        @param activation: 格子激活状态
        @return:
        """
        self._slot_no = slot_no
        self._activation = activation
        self._hero_slot = HeroSlotComponent(self, bid, name, slot_no, activation)
        self._equipment_slots = dict([(slot_no, EquipmentSlotComponent(self, bid, name, slot_no, activation)) for \
                                      slot_no in [1, 2, 3, 4, 5, 6]])

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
    def info(self):
        """卡牌信息
        """
        return dict(slot_no=self._slot_no, activation=self._activation, hero_no=self._hero_slot.hero_no,
                    equipment_ids=dict([(slot.slot_no, slot.equipment_id) for slot in self._equipment_slots.values()]))

    # @classmethod
    # def loads(cls, data):
    #     """解压
    #     """
    #     info = cPickle.loads(data)
    #     slot = cls(**info)
    #     return slot

    def dumps(self):
        """压缩
        """
        return cPickle.dumps(self.info)
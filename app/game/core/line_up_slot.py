# -*- coding:utf-8 -*-
"""
created by server on 14-7-5下午3:25.
"""
import cPickle


class LineUpSlot(object):
    """卡牌位"""
    def __init__(self, slot_no, activation=False, hero_no=0, equipment_ids=['']*6):
        self._slot_no = slot_no  # 卡牌位置
        self._activation = activation  # 激活状态
        self._hero_no = hero_no  # 英雄编号
        self._equipment_ids = equipment_ids  # 装备信息

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
    def hero_no(self):
        return self._hero_no

    @hero_no.setter
    def hero_no(self, value):
        self._hero_no = value

    @property
    def equipment_ids(self):
        return self._equipment_ids

    @equipment_ids.setter
    def equipment_ids(self, value):
        self._equipment_ids = value

    @property
    def info(self):
        """卡牌信息
        """
        return dict(hero_no=self._hero_no, equipment_ids=self._equipment_ids)

    @classmethod
    def loads(cls, data):
        """解压
        """
        info = cPickle.loads(data)
        slot = cls(**info)
        return slot

    def dumps(self):
        """压缩
        """
        return cPickle.dumps(self.info)
































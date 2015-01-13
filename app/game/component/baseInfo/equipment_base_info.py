# -*- coding:utf-8 -*-
"""
created by server on 14-7-7下午4:09.
"""
from app.game.component.baseInfo.BaseInfoComponent import BaseInfoComponent


class EquipmentBaseInfoComponent(BaseInfoComponent):
    """装备基础信息组件
    """

    def __init__(self, owner, bid, base_name, equipment_no):
        super(EquipmentBaseInfoComponent, self).__init__(owner, bid, base_name)
        self._equipment_no = equipment_no  # 装备编号

    @property
    def equipment_no(self):
        return self._equipment_no

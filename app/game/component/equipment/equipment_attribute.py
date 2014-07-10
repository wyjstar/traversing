# -*- coding:utf-8 -*-
"""
created by server on 14-7-7下午4:29.
"""
from app.game.component.Component import Component
from shared.db_opear.configs_data import game_configs


class EquipmentAttributeComponent(Component):
    """装备属性
    """

    def __init__(self, owner, strengthen_lv, awakening_lv):
        super(EquipmentAttributeComponent, self).__init__(owner)

        self._strengthen_lv = strengthen_lv  # 强化等级
        self._awakening_lv = awakening_lv  # 觉醒等级

    @property
    def strengthen_lv(self):
        return self._strengthen_lv

    @strengthen_lv.setter
    def strengthen_lv(self, strengthen_lv):
        self._strengthen_lv = strengthen_lv

    @property
    def awakening_lv(self):
        return self._awakening_lv

    @awakening_lv.setter
    def awakening_lv(self, awakening_lv):
        self._awakening_lv = awakening_lv

    @property
    def equipment_type(self):
        """返回装备类型
        """
        equipment_no = self.owner.base_info.equipment_no
        obj = game_configs.equipment_config.get(equipment_no, None)
        if not obj:
            return None
        return obj.type

    @property
    def enhance_cost(self):
        """ 根据强化等级返回强化消耗
        """
        equipment_no = self.owner.base_info.equipment_no
        equipment_no = 110001
        print 'equipment_no:', equipment_no
        print 'strengthen_lv:', self._strengthen_lv
        # 配置数据
        equ_config_obj = game_configs.equipment_config.get(equipment_no, None)
        str_config_obj = game_configs.equipment_strengthen_config.get(self._strengthen_lv, None)
        print '##1:', str_config_obj
        print '##1:', equ_config_obj
        if (not equ_config_obj) or (not str_config_obj):
            return None
        curencydir = equ_config_obj.currencyDir  # 强化路线
        print 'currencyCost%s' % curencydir
        cost = getattr(str_config_obj, 'currencyCost%s' % curencydir)
        print 'cost:', cost
        return cost

    def modify_single_attr(self, attr_name='', num=0, add=True):
        """修改单个属性的值
        @param attr_name:  属性名称
        @param num:  修改的数量
        @param add: 添加或者减少
        @return:
        """
        if add:
            setattr(self, attr_name, getattr(self, attr_name, 0) + int(num))
        else:
            setattr(self, attr_name, getattr(self, attr_name, 0) - int(num))













# -*- coding:utf-8 -*-
"""
created by server on 14-7-7下午9:15.
"""
from shared.db_opear.configs_data import game_configs


class EquipmentChip(object):
    """装备碎片
    """
    def __init__(self, chip_no, chip_num):
        self._chip_no = chip_no  # 碎片编号
        self._chip_num = chip_num  # 碎片数量

    @property
    def chip_no(self):
        return self._chip_no

    @chip_no.setter
    def chip_no(self, chip_no):
        self._chip_no = chip_no

    @property
    def chip_num(self):
        return self._chip_num

    @chip_num.setter
    def chip_num(self, chip_num):
        self._chip_num = chip_num

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

    @property
    def compose_num(self):
        """合成数量配置
        """
        chip_obj = game_configs.chip_config.get('chips', {}).get(self._chip_no, None)
        if not chip_obj:
            return None
        need_num = chip_obj.needNum
        return need_num

    @property
    def combine_result(self):
        """合成后的装备
        """
        chip_obj = game_configs.chip_config.get('chips', {}).get(self._chip_no, None)
        if not chip_obj:
            return None
        return chip_obj.combineResult

    def update_pb(self, equipment_chip_pb):
        equipment_chip_pb.equipment_chip_no = self._chip_no
        equipment_chip_pb.equipment_chip_num = self._chip_num

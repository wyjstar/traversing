# -*- coding:utf-8 -*-
"""
created by server on 14-7-7下午9:15.
"""


class EquipmentChip(object):
    """装备碎片
    """
    def __init__(self, chip_no, chip_num):
        self._chip_no = chip_no  # 碎片编号
        self._chip_num = chip_num  # 碎片数量

    def modify_num(self, num=0, add=True):
        if add:
            self._chip_num += num
        else:
            self._chip_num -= num

    @property
    def chip_no(self):
        return self.chip_no

    @property
    def chip_num(self):
        return self.chip_num

# -*- coding:utf-8 -*-
"""
created by server on 14-7-4下午3:45.
"""


class DropItem(object):
    """掉落物品
    """
    def __init__(self):
        self._drop_id = 0  # 掉落ID
        self._item_no = 0  # 物品编号
        self._item_type = 0  # 物品类型
        self._item_count = 0  # 物品数量
        self._item_weight = 0  # 掉落权重

    @property
    def drop_id(self):
        return self._drop_id

    @drop_id.setter
    def drop_id(self, drop_id):
        self._drop_id = drop_id

    @property
    def item_no(self):
        return self._item_no

    @item_no.setter
    def item_no(self, item_no):
        self._item_no = item_no

    @property
    def item_type(self):
        return self._item_type

    @item_type.setter
    def item_type(self, item_type):
        self._item_type = item_type

    @property
    def item_num(self):
        return self._item_count

    @item_num.setter
    def item_num(self, item_count):
        self._item_count = item_count

    @property
    def item_weight(self):
        return self._item_weight

    @item_weight.setter
    def item_weight(self, item_weight):
        self._item_weight = item_weight

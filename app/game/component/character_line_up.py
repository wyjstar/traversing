# -*- coding:utf-8 -*-
"""
created by server on 14-7-5下午3:07.
"""
from app.game.component.Component import Component
from app.game.core.line_up_item import LineUpItem
from app.game.redis_mode import tb_character_line_up
import cPickle


class CharacterLineUpComponent(Component):
    """用户英雄阵容组件
    """
    def __init__(self, owner):
        super(CharacterLineUpComponent, self).__init__(owner)
        self._line_up_items = []  # 卡牌位列表
        self._line_up_order = [0] * 6
        self._unique = 0  # 无双

    def init_data(self):
        line_up_data = tb_character_line_up.getObjData(self.owner.base_info.id)

        if line_up_data:
            self._line_up_items = cPickle.loads(line_up_data.get("line_up_items"))
            self._line_up_order = cPickle.loads(line_up_data.get("line_up_order"))
        else:
            tb_character_line_up.new({'id': self.owner.base_info.id,
                                      'line_up_items': cPickle.dumps([]),
                                      'line_up_order': cPickle.dumps([]),
                                      })
    @property
    def line_up_order(self):
        return self._line_up_order

    @line_up_order.setter
    def line_up_order(self, value):
        self._line_up_order = value

    def get_line_up_item(self, line_up_item_id):
        return self._line_up_items[line_up_item_id-1]

    def add_hero(self, hero_no):
        line_up_item = LineUpItem(hero_no)
        self._line_up_items.append(line_up_item)
        self._line_up_order.append(len(self._line_up_items))

    def save_data(self):
        tb_character_line_up.update('line_up_items', cPickle.dumps(self._line_up_items))
        tb_character_line_up.update('line_up_order', cPickle.dumps(self._line_up_order))



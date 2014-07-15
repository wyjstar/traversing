# -*- coding:utf-8 -*-
"""
created by server on 14-7-5下午3:07.
"""
from app.game.component.Component import Component
from app.game.core.line_up_slot import LineUpSlot
from app.game.redis_mode import tb_character_line_up
import cPickle


class CharacterLineUpComponent(Component):
    """用户英雄阵容组件
    """
    def __init__(self, owner):
        super(CharacterLineUpComponent, self).__init__(owner)
        self._line_up_slots = []  # 卡牌位列表
        self._line_up_order = []
        self._unique = 0  # 无双

    def init_data(self):
        line_up_data = tb_character_line_up.getObjData(self.owner.base_info.id)

        if line_up_data:
            slots = cPickle.loads(line_up_data.get("line_up_slots"))
            for slot in slots:
                hero_no = slot.get('hero_no')
                equipment_ids = slot.get('equipment_ids')
                temp = LineUpSlot(hero_no, equipment_ids)
                self._line_up_slots.append(temp)

            self._line_up_order = cPickle.loads(line_up_data.get("line_up_order"))
        else:
            tb_character_line_up.new({'id': self.owner.base_info.id,
                                      'line_up_slots': cPickle.dumps([]),
                                      'line_up_order': cPickle.dumps([]),
                                      })

    @property
    def line_up_order(self):
        return self._line_up_order

    @line_up_order.setter
    def line_up_order(self, value):
        self._line_up_order = value

    def get_line_up_slot(self, line_up_slot_id):
        return self._line_up_slots[line_up_slot_id-1]

    def get_all(self):
        return self._line_up_slots

    def add_hero(self, hero_no):
        line_up_slot = LineUpSlot(hero_no)
        self._line_up_slots.append(line_up_slot)
        self._line_up_order.append(len(self._line_up_slots))

    def save_data(self):
        data = []
        for slot in self._line_up_slots:
            data.append({
                'hero_no': slot.hero_no,
                'equipment_ids': slot.equipment_ids
            })
        print "________________"
        print data
        tb_character_line_up.update('line_up_slots', cPickle.dumps(data))
        tb_character_line_up.update('line_up_order', cPickle.dumps(self._line_up_order))



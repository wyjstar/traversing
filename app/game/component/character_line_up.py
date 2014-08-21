# -*- coding:utf-8 -*-
"""
created by server on 14-7-5下午3:07.
"""
from app.game.component.Component import Component
from app.game.component.line_up.line_up_slot import LineUpSlotComponent
from app.game.redis_mode import tb_character_line_up
from shared.db_opear.configs_data import game_configs


class CharacterLineUpComponent(Component):
    """用户英雄阵容组件
    """

    def __init__(self, owner):
        """
        @param owner: character obj
        @param bid:  阵容编号
        @param name:  阵容名称
        """
        super(CharacterLineUpComponent, self).__init__(owner)

        # TODO 有多少个位置 需要读取baseinfo配置表
        self._line_up_slots = dict([(slot_no, LineUpSlotComponent(self, slot_no)) for slot_no in range(1, 7)])  # 卡牌位列表
        self._sub_slots = dict([(slot_no, LineUpSlotComponent(self, slot_no)) for slot_no in range(1, 7)])  # 卡牌位替补

        self._line_up_order = []
        # self._employee = None
        # self._unique = 0  # 无双

    def init_data(self):
        line_up_data = tb_character_line_up.getObjData(self.owner.base_info.id)

        # print '#line up init data:', line_up_data

        if line_up_data:
            # 阵容位置信息
            line_up_slots = line_up_data.get('line_up_slots')
            for slot_no, slot in line_up_slots.items():
                line_up_slot = LineUpSlotComponent.loads(self, slot)
                self._line_up_slots[slot_no] = line_up_slot
            # 助威位置信息
            line_sub_slots = line_up_data.get('sub_slots')
            for sub_slot_no, sub_slot in line_sub_slots.items():
                line_sub_slot = LineUpSlotComponent.loads(self, sub_slot)
                self._sub_slots[sub_slot_no] = line_sub_slot
            self._line_up_order = line_up_data.get('line_up_order')
        else:
            tb_character_line_up.new({'id': self.owner.base_info.id,
                                      'line_up_slots': dict([(slot_no, LineUpSlotComponent(self, slot_no).dumps()) for
                                                             slot_no in self._line_up_slots.keys()]),
                                      'sub_slots': dict([(slot_no, LineUpSlotComponent(self, slot_no).dumps()) for
                                                         slot_no in self._sub_slots.keys()]),
                                      'line_up_order': self._line_up_order})

    @property
    def line_up_slots(self):
        return self._line_up_slots

    @line_up_slots.setter
    def line_up_slots(self, line_up_slots):
        self._line_up_slots = line_up_slots

    @property
    def line_up_order(self):
        return self._line_up_order

    @line_up_order.setter
    def line_up_order(self, value):
        self._line_up_order = value

    @property
    def sub_slots(self):
        return self._sub_slots

    @sub_slots.setter
    def sub_slots(self, sub_slots):
        self._sub_slots = sub_slots

    def change_hero(self, slot_no, hero_no, change_type):
        """更换阵容主将
        @param slot_no:
        @param hero_no:
        @:param change_type: 0:阵容  1：助威
        @return:
        """
        if not change_type:
            slot_obj = self._line_up_slots.get(slot_no)
        else:
            slot_obj = self._sub_slots.get(slot_no)

        slot_obj.change_hero(hero_no)

    def change_equipment(self, slot_no, no, equipment_id):
        """更改装备
        @param slot_no: 阵容位置
        @param no: 装备位置
        @param equipment_id: 装备ID
        @return:
        """
        slot_obj = self._line_up_slots.get(slot_no)
        slot_obj.change_equipment(no, equipment_id)

    @property
    def hero_ids(self):
        """阵容英雄编号列表
        """
        return [slot.hero_no for slot in self._line_up_slots.values()]

    def get_equipment_obj(self, equipment_id):
        """装备对象
        """
        return self.owner.equipment_component.equipments_obj.get(equipment_id, None)

    def get_hero_obj(self, hero_no):
        """英雄对象
        """
        return self.owner.hero_component.heros.get(hero_no, None)

    @property
    def hero_objs(self):
        """英雄对象 list
        """
        heros = []
        for slot in self._line_up_slots.values():
            heros.append(slot.hero_slot.hero_obj)
        for slot in self._sub_slots.values():
            heros.append(slot.hero_slot.hero_obj)
        return heros

    @property
    def hero_nos(self):
        """英雄编号 list
        """
        return [hero_obj.hero_no for hero_obj in self.hero_objs if hero_obj]

    def save_data(self):
        props = {
            'line_up_slots': dict([(slot_no, LineUpSlotComponent(self, slot_no).dumps()) for
                                   slot_no in self._line_up_slots.keys()]),
            'sub_slots': dict([(slot_no, LineUpSlotComponent(self, slot_no).dumps()) for
                               slot_no in self._sub_slots.keys()]),
            'line_up_order': self._line_up_order}

        line_up_obj = tb_character_line_up.getObj(self.owner.base_info.id)
        line_up_obj.update_multi(props)

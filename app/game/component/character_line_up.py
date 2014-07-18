# -*- coding:utf-8 -*-
"""
created by server on 14-7-5下午3:07.
"""
from app.game.component.Component import Component
from app.game.core.line_up_slot import LineUpSlot
from app.game.redis_mode import tb_character_line_up
import cPickle
from shared.db_opear.configs_data import game_configs


class CharacterLineUpComponent(Component):
    """用户英雄阵容组件
    """

    def __init__(self, owner):
        super(CharacterLineUpComponent, self).__init__(owner)
        # TODO 有多少个位置 需要读取baseinfo配置表
        self._line_up_slots = dict([(slot_no, LineUpSlot(slot_no)) for slot_no in range(1, 7)])  # 卡牌位列表
        self._line_up_order = []
        # self._employee = None
        self._unique = 0  # 无双
        self._links = {}   # 羁绊缓存数据 {'hero_no': link_data}

    def init_data(self):
        line_up_data = tb_character_line_up.getObjData(self.owner.base_info.id)
        print 'line_up_data #1:', line_up_data
        if line_up_data:
            slots = line_up_data.get("line_up_slots")
            for slot_no, slot in slots.items():
                line_up_slot = LineUpSlot.loads(slot)
                self._line_up_slots[slot_no] = line_up_slot

            print 'line up init data:', self._line_up_slots

            for key, value in self._line_up_slots.iteritems():
                print key, value.__dict__

            self._line_up_order = line_up_data.get("line_up_order")
        else:
            tb_character_line_up.new({'id': self.owner.base_info.id,
                                      'line_up_slots': dict([(slot_no, LineUpSlot(slot_no).dumps()) for slot_no in
                                                             self._line_up_slots.keys()]),
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

    # @property
    # def employee(self):
    #     return self._employee
    #
    # @employee.setter
    # def employee(self, value):
    #     self._employee = value

    # def get_line_up_slot(self, line_up_slot_id):
    #     return self._line_up_slots[line_up_slot_id - 1]
    #
    # def get_all(self):
    #     return self._line_up_slots

    def change_hero(self, slot_no, hero_no):
        """更换阵容主将
        @param slot_no:
        @param hero_no:
        @return:
        """
        slot_obj = self._line_up_slots.get(slot_no)
        slot_obj.hero_no = hero_no

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
        return [slot.slot_no for slot in self._line_up_slots.values()]

    def get_equipment_ids(self, slot_no):
        """根据位置取得装备no列表
        """
        slot = self._line_up_slots.get(slot_no)

        equipment_no_list = []
        for equipment_id in slot.equipment_ids:
            equipment_obj = self.owner.equipment_component.equipments_obj.get(equipment_id)
            equipment_no = equipment_obj.base_info.equipment_no
            equipment_no_list.append(equipment_no)

        return equipment_no_list

    def save_data(self):
        props = {'line_up_slots': dict([(slot_no, slot.dumps()) for slot_no, slot in
                                        self._line_up_slots.items()]),
                 'line_up_order': self._line_up_order}

        line_up_obj = tb_character_line_up.getObj(self.owner.base_info.id)
        line_up_obj.update_multi(props)

    # ------------------羁绊信息------------------
    def get_links(self):
        """羁绊
        """
        if self._links:
            return self._links

        # 遍历生成
        self._links = {}
        for slot in self._line_up_slots.values():
            hero_no = slot.hero_no  # 阵容英雄编号
            if not hero_no:  # 空位置
                continue
            link_data = self.__hero_links(hero_no, slot.slot_no)
            self._links[hero_no] = link_data
        return self._links

    def __hero_links(self, hero_no, slot_no):
        """英雄的羁绊
        """
        link_data = {}
        links = game_configs.link_config
        hero_links = links.get(hero_no, None)  # 英雄羁绊数据

        if not hero_links:  # 无羁绊
            return link_data

        for i in range(1, 6):
            link_no = getattr(hero_links, 'link%s' % i)  # 羁绊技能
            trigger_list = getattr(hero_links, 'trigger%s' % i)  # 羁绊触发条件

            if not link_no:  # 无羁绊技能
                continue

            result = self.__is_activation(trigger_list, slot_no)
            link_data[link_no] = result

        return link_data

    def __is_activation(self, trigger_list, slot_no):
        """羁绊是否激活
        @param trigger_list: 羁绊触发条件列表
        @param slot_no:  当前位置编号
        @return:
        """
        if not trigger_list:
            return 0
        activation = 1
        equipment_ids = self.get_equipment_ids(slot_no)
        for no in trigger_list:
            if len(no) == 5:  # 英雄ID
                if no not in self.hero_ids:  # 羁绊需要英雄不在阵容中
                    activation = 0
                    break
            elif len(no) == 6:  # 装备ID
                if no not in equipment_ids:  # 羁绊需要的装备不在阵容中
                    activation = 0
                    break
        return activation
    # ------------------羁绊信息------------------






















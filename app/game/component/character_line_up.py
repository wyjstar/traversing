# -*- coding:utf-8 -*-
"""
created by server on 14-7-5下午3:07.
"""
from app.game.component.Component import Component
from app.game.component.line_up.line_up_slot import LineUpSlotComponent
from app.game.redis_mode import tb_character_line_up
from shared.db_opear.configs_data.game_configs import base_config
from shared.db_opear.configs_data.game_configs import warriors_config
from gfirefly.server.logobj import logger


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

        self._line_up_slots = dict([(slot_no,
                                   LineUpSlotComponent(self, slot_no)) for
                                   slot_no in range(1, 7)])  # 卡牌位列表
        self._sub_slots = dict([(slot_no,
                               LineUpSlotComponent(self, slot_no)) for
                               slot_no in range(1, 7)])  # 卡牌位替补

        self._line_up_order = []
        self._unpars = {}  # 无双

    def init_data(self):
        line_up_data = tb_character_line_up.getObjData(self.character_id)

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
            self._unpars = line_up_data.get('unpars')
        else:
            __line_up_slots = dict([(slot_no,
                                   LineUpSlotComponent(self, slot_no).dumps())
                                   for slot_no in self._line_up_slots.keys()])
            __sub_slots = dict([(slot_no,
                               LineUpSlotComponent(self, slot_no).dumps()) for
                               slot_no in self._sub_slots.keys()])
            data = dict(id=self.character_id,
                        line_up_slots=__line_up_slots,
                        sub_slots=__sub_slots,
                        line_up_order=self._line_up_order,
                        unpars=self._unpars)
            tb_character_line_up.new(data)

        self.update_slot_activation()

    def save_data(self):
        props = {
            'line_up_slots': dict([(slot_no, slot.dumps()) for
                                  slot_no, slot in
                                  self._line_up_slots.items()]),
            'sub_slots': dict([(slot_no, sub_slot.dumps()) for
                              slot_no, sub_slot in self._sub_slots.items()]),
            'line_up_order': self._line_up_order,
            'unpars': self._unpars}

        line_up_obj = tb_character_line_up.getObj(self.character_id)
        line_up_obj.update_multi(props)

    def update_slot_activation(self):
        # 根据base_config获取卡牌位激活状态
        for i in range(1, 7):
            slot = self._line_up_slots[i]
            __level = base_config.get("hero_position_open_level").get(i)
            if self.owner.level.level >= __level:
                slot.activation = True
        for i in range(1, 7):
            slot = self._sub_slots[i]
            __level = base_config.get("friend_position_open_level").get(i)
            if self.owner.level.level >= __level:
                slot.activation = True

    def unpar_upgrade(self, skill_id, skill_upgrade_level):
        if skill_id not in self._unpars:
            logger.error('skill is not open yet:%s', skill_id)
            return False
        if skill_upgrade_level != self._unpars[skill_id] + 1:
            logger.error('skill level is right:%s:%s',
                         skill_upgrade_level,
                         self._unpars[skill_id])
            return False
        item = warriors_config.get(skill_id)
        if not item:
            logger.error('skill is not exist:%d', skill_id)
            return False

        expends = item.get('expends')
        if not expends and skill_upgrade_level in expends:
            logger.error('expands, %s', skill_upgrade_level)
            return False

        if skill_upgrade_level not in expends:
            logger.error('expands, %s', skill_upgrade_level)
            return False

        spirit, coin = expends.get(skill_upgrade_level)
        if not self.owner.finance.is_afford(coin):
            return False

        self._unpars[skill_id] = skill_upgrade_level
        self.owner.finance.consume_coin(coin)
        self.owner.finance.save_data()
        self.save_data()

        return True

    def get_skill_id_by_unpar(self, unpar):
        if unpar not in self._unpars:
            logger.error('donot open:%s', unpar)
            return 0

        item = warriors_config.get(unpar)
        if not item:
            logger.error('can not find warrior:%s', unpar)
            return 0
        return item.skill_ids[self._unpars[unpar]]

    @property
    def lead_hero_no(self):
        """主力英雄编号
        """
        slot = self._line_up_slots.get(1)
        if not slot:
            return 0
        hero_no = slot.hero_slot.hero_no
        if not hero_no:
            return 0
        return hero_no

    @property
    def line_up_slots(self):
        return self._line_up_slots

    @line_up_slots.setter
    def line_up_slots(self, line_up_slots):
        self._line_up_slots = line_up_slots

    @property
    def line_up_order(self):
        """取得队形
        """
        if not self._line_up_order:  # 默认队形
            line_up_order = []
            new_list = sorted(self._line_up_slots.items(), key=lambda x: x[0])
            for slot_no, slot in new_list:
                line_up_order.append(slot_no)
            self._line_up_order = line_up_order
        return self._line_up_order

    @line_up_order.setter
    def line_up_order(self, line_up_order):
        new_line_up_order = self.line_up_order[:]  # copy[1,2,3,4,5,6]
        # 更新队形
        for pos, slot_no in enumerate(self._line_up_order):
            slot = self._line_up_slots.get(slot_no)  # 格子对象
            hero_no = slot.hero_slot.hero_no  # 英雄编号
            if not hero_no:
                continue
            new_pos = line_up_order.get(hero_no)  # 新位置

            new_line_up_order[pos], new_line_up_order[new_pos-1] = new_line_up_order[new_pos-1], new_line_up_order[pos]


        self._line_up_order = new_line_up_order

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

        # 如果无双条件不满足，则无双设为空
        hero_nos = set(self.hero_nos)  # 阵容英雄编号
        for skill_id, item in warriors_config.items():
            if skill_id not in self._unpars:
                conditions = item.get('conditions')
                if conditions and hero_nos.issuperset(conditions):
                    self._unpars[skill_id] = 1
        # logger.warning('unpars:%s', str(self._unpars))

    def change_equipment(self, slot_no, no, equipment_id):
        """更改装备
        @param slot_no: 阵容位置
        @param no: 装备位置
        @param equipment_id: 装备ID
        @return:
        """
        slot_obj = self._line_up_slots.get(slot_no)
        return slot_obj.change_equipment(no, equipment_id)

    @property
    def hero_ids(self):
        """阵容英雄编号列表
        """
        return [slot.hero_no for slot in self._line_up_slots.values()]

    def get_equipment_obj(self, equipment_id):
        """装备对象
        """
        return self.owner.equipment_component.equipments_obj.get(equipment_id,
                                                                 None)

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
        # for slot in self._sub_slots.values():
        #     heros.append(slot.hero_slot.hero_obj)
        return heros

    @property
    def hero_nos(self):
        """英雄编号 list
        """
        return [hero_obj.hero_no for hero_obj in self.hero_objs if hero_obj]

    @property
    def on_equipment_ids(self):
        """获取所有已经装备的装备ID"""
        on_equipment_ids = []
        for slot in self._line_up_slots.values():
            temp = [slot.equipment_id for
                    slot in slot.equipment_slots.values() if slot.equipment_id]
            on_equipment_ids.extend(temp)

        return on_equipment_ids

    @property
    def warriors(self):
        """无双列表
        """
        warrior_list = []
        warriors_item = warriors_config
        hero_nos = set(self.hero_nos)  # 阵容英雄编号
        for warrior_id, warrior in warriors_item.items():
            conditions = set()
            for i in range(1, 7):
                condition = getattr(warrior, 'condition%s' % i, None)
                if condition:
                    conditions.add(condition)

            length = len(conditions)  # 无双需求英雄数量
            condition_intersection = hero_nos.intersection(conditions)  # 交集

            if length == len(condition_intersection):  # 激活的无双
                warrior_list.append(warrior_id)
                continue

        return warrior_list

    @property
    def character_id(self):
        return self.owner.base_info.id

    @property
    def combat_power(self):
        """总战斗力
        """
        _power = 0
        for slot in self._line_up_slots.values():
            each_power = slot.combat_power()
            _power += each_power
        return _power

    def get_slot_by_hero(self, hero_no):
        """根据英雄编号拿到格子对象
        :param hero_no:
        :return:
        """
        for slot in self._line_up_slots.values():
            if hero_no == slot.hero_slot.hero_no:
                return slot
        return None

    @property
    def unpars(self):
        return self._unpars

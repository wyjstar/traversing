# -*- coding:utf-8 -*-
"""
created by server on 14-7-5下午3:07.
"""
from app.game.component.Component import Component
from app.game.component.line_up.line_up_slot import LineUpSlotComponent
from app.game.redis_mode import tb_character_info
from shared.db_opear.configs_data import game_configs
from gfirefly.server.logobj import logger
from shared.utils.const import const
from app.game.component.mine.monster_mine import MineOpt
from shared.tlog import tlog_action
from app.game.action.node.line_up import line_up_info
from app.game.core.task import hook_task, CONDITIONId


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

        self._line_up_order = [1, 2, 3, 4, 5, 6]
        self._current_unpar = 0
        self._unpars = {}  # 无双
        self._friend_fight_times = {}  # 小伙伴战斗次数
        self._friend_fight_last_time = 0
        self._hight_power = 0
        self._caption_pos = 1

    def init_data(self, character_info):
        line_up_slots = character_info.get('line_up_slots')
        # 阵容位置信息
        for slot_no, slot in line_up_slots.items():
            line_up_slot = LineUpSlotComponent.loads(self, slot)
            self._line_up_slots[slot_no] = line_up_slot
        # 助威位置信息
        line_sub_slots = character_info.get('sub_slots')
        for sub_slot_no, sub_slot in line_sub_slots.items():
            line_sub_slot = LineUpSlotComponent.loads(self, sub_slot)
            self._sub_slots[sub_slot_no] = line_sub_slot
        self._line_up_order = character_info.get('line_up_order')
        self._unpars = character_info.get('unpars')
        self._current_unpar = character_info.get('current_unpar')
        self._friend_fight_times = character_info.get('friend_fight_times', {})
        self._friend_fight_last_time = character_info.get('friend_fight_last_time', 0)
        self._hight_power = character_info.get('hight_power', 0)
        self._caption_pos = character_info.get('caption_pos', 0)

        self.owner.set_level_related()

    def save_data(self, prop_names=[]):
        power = self.combat_power
        hook_task(self.owner, CONDITIONId.FIGHT_POWER, power)
        props = {
            'line_up_slots': dict([(slot_no, slot.dumps()) for
                                   slot_no, slot in
                                   self._line_up_slots.items()]),
            'sub_slots': dict([(slot_no, sub_slot.dumps()) for
                               slot_no, sub_slot in self._sub_slots.items()]),
            'line_up_order': self._line_up_order,
            'unpars': self._unpars,
            'current_unpar': self._current_unpar,
            'friend_fight_times': self._friend_fight_times,
            'attackPoint': power,
            'hight_power': self._hight_power,
            'best_skill': self.get_skill_id_by_unpar(self._current_unpar),
            'caption_pos': self._caption_pos,
        }
        if ('copy_units' in prop_names) or (not prop_names):
            props['copy_units'] = self.owner.fight_cache_component.red_unit
            props['copy_slots'] = line_up_info(self.owner).SerializeToString()

        line_up_obj = tb_character_info.getObj(self.character_id)
        line_up_obj.hmset(props)

    def new_data(self):
        __line_up_slots = dict([(slot_no,
                                LineUpSlotComponent(self, slot_no).dumps())
                                for slot_no in self._line_up_slots.keys()])
        __sub_slots = dict([(slot_no,
                            LineUpSlotComponent(self, slot_no).dumps()) for
                            slot_no in self._sub_slots.keys()])
        data = dict(line_up_slots=__line_up_slots,
                    sub_slots=__sub_slots,
                    line_up_order=self._line_up_order,
                    unpars=self._unpars,
                    current_unpar=self._current_unpar,
                    friend_fight_times=self._friend_fight_times,
                    best_skill=0,
                    attackPoint=0,
                    hight_power=0,
                    caption_pos=0,
                    copy_units=self.owner.fight_cache_component.red_unit,
                    copy_slots=line_up_info(self.owner).SerializeToString()
                    )
        return data

    def update_slot_activation(self):
        # 根据base_config获取卡牌位激活状态
        for i in range(1, 7):
            slot = self._line_up_slots[i]
            __level = game_configs.base_config.get("hero_position_open_level").get(i)
            if self.owner.base_info.level >= __level:
                slot.activation = True
        for i in range(1, 7):
            slot = self._sub_slots[i]
            __level = game_configs.base_config.get("friend_position_open_level").get(i)
            if self.owner.base_info.level >= __level:
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
        item = game_configs.warriors_config.get(skill_id)
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
        if not self.owner.finance.is_afford(const.COIN, coin):
            return False

        self._unpars[skill_id] = skill_upgrade_level
        self.owner.finance.consume_coin(coin, const.UNPAR_UPGRADE)
        self.owner.finance.consume(const.SPIRIT, spirit, const.UNPAR_UPGRADE)
        self.owner.finance.save_data()
        self.save_data()

        return True

    def get_skill_id_by_unpar(self, unpar):
        if unpar not in self._unpars:
            return 0

        item = game_configs.warriors_config.get(unpar)
        if not item:
            logger.error('can not find warrior:%s', unpar)
            return 0
        return item.skill_ids[self._unpars[unpar]]

    def get_skill_info_by_unpar(self, unpar):
        if unpar not in self._unpars:
            return (0, 0)

        item = game_configs.warriors_config.get(unpar)
        if not item:
            logger.error('can not find warrior:%s', unpar)
            return (0, 0)
        upar_level = self._unpars[unpar]
        return item.skill_ids[upar_level], upar_level

    @property
    def lead_hero_no(self):
        """主力英雄编号
        """
        slot = self._line_up_slots.get(self._caption_pos)
        if not slot:
            return 0
        hero_no = slot.hero_slot.hero_no
        if not hero_no:
            return 0
        return hero_no

    @property
    def caption_pos(self):
        return self._caption_pos

    @caption_pos.setter
    def caption_pos(self, caption_pos):
        self._caption_pos = caption_pos

    @property
    def line_up_slots(self):
        return self._line_up_slots

    @line_up_slots.setter
    def line_up_slots(self, line_up_slots):
        self._line_up_slots = line_up_slots

    @property
    def line_up_slots_has_heros(self):
        res = {}
        for k, v in self._line_up_slots.items():
            if v.hero_slot.hero_obj:
                res[k] = v

        return res

    @property
    def line_up_order(self):
        """取得队形
        """
        return self._line_up_order

    @line_up_order.setter
    def line_up_order(self, line_up_order):
        self._line_up_order = line_up_order

    @property
    def current_unpar(self):
        """取得队形
        """
        return self._current_unpar

    @current_unpar.setter
    def current_unpar(self, current_unpar):
        self._current_unpar = current_unpar

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

        origin_hero_no = slot_obj.hero_slot.hero_no
        origin_hero = self.owner.hero_component.get_hero(origin_hero_no)
        if origin_hero:
            origin_hero.is_online = False
        else:
            origin_hero_no = 0
        slot_obj.change_hero(hero_no)
        if hero_no == 0 and slot_no == self.caption_pos:
            # 队长下阵，更改队长
            self.remove_caption_hero()

        target_hero = self.owner.hero_component.get_hero(hero_no)
        if hero_no != 0:
            assert target_hero != None, "change hero can not be None!"
            target_hero.is_online = True

        tlog_action.log('LineUpChange', self.owner, slot_no, origin_hero_no,
                        hero_no, change_type)
        # 如果无双条件不满足，则无双设为空
        hero_nos = set(self.hero_nos)  # 阵容英雄编号
        for skill_id, item in game_configs.warriors_config.items():
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
        # heros.append(slot.hero_slot.hero_obj)
        return heros

    @property
    def hero_nos(self):
        """英雄编号 list
        """
        return [hero_obj.hero_no for hero_obj in self.hero_objs if hero_obj]

    @property
    def all_lineup_hero_nos(self):
        """英雄编号:阵容+助威
        """
        return [hero_obj.hero_no for hero_obj in self.hero_objs if hero_obj] + \
                [line_up_slot.hero_slot.hero_no for line_up_slot in self.sub_slots.values() if line_up_slot.hero_slot and line_up_slot.hero_slot.hero_no]
    @property
    def hero_levels(self):
        """英雄编号 list
        """
        return [hero_obj.level for hero_obj in self.hero_objs if hero_obj]

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
        warriors_item = game_configs.warriors_config
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
            each_power = slot.combat_power_lineup()
            _power += each_power

        MineOpt.update('sword', self.owner.base_info.id, _power)
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

    def get_first_slot(self):
        """get first slot in the line up"""
        return self._line_up_slots.get(self._caption_pos)

    @property
    def friend_fight_times(self):
        return self._friend_fight_times

    @property
    def friend_fight_last_time(self):
        return self._friend_fight_last_time

    @friend_fight_last_time.setter
    def friend_fight_last_time(self, friend_fight_last_time):
        self._friend_fight_last_time = friend_fight_last_time

    @property
    def hight_power(self):
        return self._hight_power

    @hight_power.setter
    def hight_power(self, v):
        self._hight_power = v

    def remove_caption_hero(self):
        """移除队长"""
        for k in range(1, 7):
            v = self._line_up_slots[k]
            if v.hero_slot.hero_obj:
                self._caption_pos = k
                break



# -*- coding:utf-8 -*-
"""
created by server on 14-7-5下午3:07.
"""
from app.game.component.Component import Component
from app.game.component.line_up.line_up_slot import LineUpSlotComponent
from app.game.redis_mode import tb_character_info
from app.game.redis_mode import tb_character_ap
from shared.db_opear.configs_data import game_configs
from gfirefly.server.logobj import logger
from shared.utils.const import const
from shared.tlog import tlog_action
from app.game.action.node.line_up import line_up_info
from app.game.core.task import hook_task, CONDITIONId
from app.game.core.activity import target_update

from gfirefly.server.globalobject import GlobalObject

remote_gate = GlobalObject().remote.get('gate')


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

        self._unpar_type = 0          # 当前无双类型，战，刺，法，牧
        self._unpar_other_id = 0      # 当前无双附加属性
        self._unpar_level = 1         # 无双等级
        self._ever_have_heros = []    # 点亮的武将列表
        self._unpar_names = []        # 女生名称，用来显示红点

        self._friend_fight_times = {} # 小伙伴战斗次数
        self._friend_fight_last_time = 0
        self._hight_power = 0
        self._caption_pos = 1
        self.guild_attr = {}

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

        self._unpar_level = character_info.get('unpar_level', 1)
        self._unpar_type = character_info.get('unpar_type', 0)
        self._unpar_other_id = character_info.get('unpar_other_id', 0)
        self._ever_have_heros = character_info.get('ever_have_heros', [])
        self._unpar_names = character_info.get('unpar_names', [])

        self._friend_fight_times = character_info.get('friend_fight_times', {})
        self._friend_fight_last_time = character_info.get('friend_fight_last_time', 0)
        self._hight_power = character_info.get('hight_power', 0)
        self._caption_pos = character_info.get('caption_pos', 0)

        self.owner.set_level_related()

    def save_data(self, prop_names=[]):
        props = {
            'line_up_slots': dict([(slot_no, slot.dumps()) for
                                   slot_no, slot in
                                   self._line_up_slots.items()]),
            'sub_slots': dict([(slot_no, sub_slot.dumps()) for
                               slot_no, sub_slot in self._sub_slots.items()]),
            'line_up_order': self._line_up_order,

            'unpar_level': self._unpar_level,
            'unpar_type': self._unpar_type,
            'unpar_other_id': self._unpar_other_id,
            'ever_have_heros': self._ever_have_heros,
            'unpar_names': self._unpar_names,

            'friend_fight_times': self._friend_fight_times,
            'hight_power': self._hight_power,
            'caption_pos': self._caption_pos,
        }
        if not prop_names or 'line_up_slots' in prop_names or 'sub_slots' in prop_names:
            power = self.combat_power
            props['attackPoint'] = power
            hook_task(self.owner, CONDITIONId.FIGHT_POWER, power)
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

                    unpar_level=self._unpar_level,
                    unpar_type=self._unpar_type,
                    unpar_other_id=self._unpar_other_id,
                    ever_have_heros=self._ever_have_heros,

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
            feature_item = game_configs.features_open_config.get(i+5)
            __level = feature_item.open
            if self.owner.base_info.level >= __level:
                slot.activation = True
        for i in range(1, 7):
            slot = self._sub_slots[i]
            feature_item = game_configs.features_open_config.get(i+11)
            __level = feature_item.open
            if self.owner.base_info.level >= __level:
                slot.activation = True

    def unpar_upgrade_unused(self, skill_id, skill_upgrade_level):
        """
        已弃用
        """
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


    def get_skill_info_by_unpar_unused(self, unpar):
        """
        已弃用
        """
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

            # 更新 七日奖励
            target_update(self.owner, [55])

        tlog_action.log('LineUpChange', self.owner, slot_no, origin_hero_no,
                        hero_no, change_type)

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
    def character_id(self):
        return self.owner.base_info.id

    @property
    def combat_power(self):
        """总战斗力
        """
        #import traceback
        #traceback.print_stack()
        print("combat_power===================")
        self.update_guild_attr()
        _power = 0
        for slot in self._line_up_slots.values():
            each_power = slot.combat_power_lineup()
            _power += each_power

        tb_character_ap.zadd(_power, self.owner.base_info.id)
        if _power > self._hight_power:
            self._hight_power = _power
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

    @property
    def unpar_type(self):
        return self._unpar_type

    @unpar_type.setter
    def unpar_type(self, v):
        self._unpar_type = v

    @property
    def unpar_other_id(self):
        return self._unpar_other_id

    @unpar_other_id.setter
    def unpar_other_id(self, v):
        self._unpar_other_id = v

    @property
    def unpar_level(self):
        return self._unpar_level

    @unpar_level.setter
    def unpar_level(self, v):
        self._unpar_level = v

    @property
    def ever_have_heros(self):
        return self._ever_have_heros

    @ever_have_heros.setter
    def ever_have_heros(self, v):
        self._ever_have_heros = v

    @property
    def unpar_names(self):
        return self._unpar_names

    @unpar_names.setter
    def unpar_names(self, v):
        self._unpar_names = v

    def remove_caption_hero(self):
        """移除队长"""
        for k in range(1, 7):
            v = self._line_up_slots[k]
            if v.hero_slot.hero_obj:
                self._caption_pos = k
                break

    def update_guild_attr(self):
        print("update_guild_attr============== %s" % self.guild_attr)
        attr = dict(hp=0, atk=0, physical_def=0, magic_def=0)
        if not self._owner.guild.g_id:
            self.guild_attr = attr
            return
        res = remote_gate['world'].get_guild_info_remote(self._owner.guild.g_id, "guild_skills", 0)
        if not res.get("result"):
            self.guild_attr = attr
            return
        guild_skills = res.get("guild_skills")
        for skill_type, skill_level in guild_skills.items():
            if skill_type == 1:
                attr["hp"] = game_configs.guild_skill_config.get(skill_type).get(skill_level).profit_hp
            if skill_type == 2:
                attr["atk"] = game_configs.guild_skill_config.get(skill_type).get(skill_level).profit_atk
            if skill_type == 3:
                attr["physical_def"] = game_configs.guild_skill_config.get(skill_type).get(skill_level).profit_pdef
            if skill_type == 4:
                attr["magic_def"] = game_configs.guild_skill_config.get(skill_type).get(skill_level).profit_mdef
        self.guild_attr = attr

    def get_red_unpar_data(self):
        """docstring for get_red_unpar_data, 用于战斗逻辑"""

        unpar_other_id = 0
        unpar_job = 0
        unpar_level = self._unpar_level
        unpar_item = game_configs.skill_peerless_grade_config.get(unpar_level)
        unpar_type_id = unpar_item.get("type"+str(self._unpar_type), 0)

        unpar_effect_item = game_configs.skill_peerless_effect_config.get(self._unpar_other_id)
        if unpar_effect_item:
            unpar_job = unpar_effect_item.type
            hero_num = 0
            for hero_no in unpar_effect_item.trigger:
                if hero_no in self._ever_have_heros:
                    hero_num+=1
            unpar_other_id = unpar_effect_item.get("peerless" + str(hero_num), 0)
            logger.debug("hero_num %s unpar_other_id %s" % (hero_num, unpar_other_id))

        red_unpar_data = dict(unpar_type=unpar_type_id, unpar_other_id=unpar_other_id, unpar_level=unpar_level, unpar_job=unpar_job)
        logger.debug("red_unpar_data %s" % red_unpar_data)
        return red_unpar_data


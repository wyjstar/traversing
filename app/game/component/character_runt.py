# -*- coding:utf-8 -*-
"""
created by server on 14-7-17上午11:07.
"""
from app.game.component.Component import Component
from app.game.redis_mode import tb_character_info
from shared.db_opear.configs_data import game_configs
import random
from shared.utils.pyuuid import get_uuid
import copy


class CharacterRuntComponent(Component):
    """玩家符文属性
    """

    def __init__(self, owner):
        super(CharacterRuntComponent, self).__init__(owner)
        self._m_runt = {}  # {id, num} -> {runt_no: [runt_id, mainAtrr{}, minorAtrr{},]}
        self._stone1 = 0  # 晶石
        self._stone2 = 0  # 原石
        self._refresh_runt = []  # 刷新石头id [runt_no, runt_id, mainAtrr, minorAtrr]
        self._refresh_times = [0, 1]  # 已经使用次数，上次使用时间

    def init_data(self, character_info):
        self._m_runt = character_info.get('m_runt')
        self._stone1 = character_info.get('stone1')
        self._stone2 = character_info.get('stone2')
        self._refresh_runt = character_info.get('refresh_runt')
        self._refresh_times = character_info.get('refresh_times')

    def save_data(self):
        self.save()

    def save(self):
        data_obj = tb_character_info.getObj(self.owner.base_info.id)
        data_obj.hmset({'m_runt': self._m_runt,
                        'stone1': self._stone1,
                        'stone2': self._stone2,
                        'refresh_runt': self._refresh_runt,
                        'refresh_times': self._refresh_times})

    def new_data(self):
        return {'m_runt': self._m_runt,
                'stone1': self._stone1,
                'stone2': self._stone2,
                'refresh_runt': self._refresh_runt,
                'refresh_times': self._refresh_times}

    def build_refresh(self):
        refresh_id = None
        x = random.randint(0, game_configs.stone_config.get('weight')[-1][1])
        flag = 0
        for [stone_id, weight] in game_configs.stone_config.get('weight'):
            if flag <= x < weight:
                refresh_id = stone_id
                break
            flag = weight
        return refresh_id

    def bag_is_full(self, num):
        if len(self._m_runt) + num > \
                game_configs.base_config.get('totemStash'):
            return 1
        return 0

    def add_runt(self, runt_id):
        # if len(self._m_runt) + 1 > game_configs.base_config.get('totemStash'):
        #     return 0

        runt_no = get_uuid()
        mainAttr, minorAttr = self.get_attr(runt_id)

        if self._m_runt.get(runt_no):
            return 0
        else:
            self._m_runt[runt_no] = [runt_id, mainAttr, minorAttr]
        return runt_no

    def get_runt_num(self, runt_no):
        num = 1
        for [runt_id, _, _] in self._m_runt.values():
            if runt_id == runt_no:
                num += 1
        return num

    def reduce_runt(self, runt_no):
        if not self._m_runt.get(runt_no):
            return 0
        del self._m_runt[runt_no]
        return 1

    def get_attr(self, runt_id):
        conf = game_configs.stone_config.get('stones').get(runt_id)
        mainAttr, minorAttr = {}, {}

        main_num = conf.mainAttrNum
        if conf.minorAttrNum:
            minor_num = random.randint(conf.minorAttrNum[0], conf.minorAttrNum[1])
        else:
            minor_num = 0

        main_pool = copy.copy(conf.mainAttr)
        minor_pool = copy.copy(conf.minorAttr)

        for _ in range(main_num):
            at, avt, av, ai = self.rand_pick_attr(main_pool)
            mainAttr[at] = [avt, av, ai]
        for _ in range(minor_num):
            at, avt, av, ai = self.rand_pick_attr(minor_pool)
            minorAttr[at] = [avt, av, ai]

        return mainAttr, minorAttr

    def rand_pick_attr(self, attr):
        attrType, attrValueType, attrValue, attrIncrement = -1, -1, -1, 0
        rand_pool = {}
        for at, v in attr.items():
            rand_pool[at] = int(v[0] * 100)
        rand = random.randint(0, sum(rand_pool.values()))

        for k, v in rand_pool.items():
            if v >= rand:
                attrType = k
                if len(attr[k]) == 5:
                    _, attrValueType, valueMin, valueMax, attrIncrement = attr[k]
                else:
                    _, attrValueType, valueMin, valueMax = attr[k]
                attrValue1 = valueMin + random.random() * (valueMax - valueMin)
                if isinstance(valueMin, int):
                    attrValue = int(attrValue1)
                else:
                    attrValue = round(attrValue1, 1)

                del attr[k]
                break
            else:
                rand -= v
        return attrType, attrValueType, attrValue, attrIncrement

    def deal_runt_pb(self, runt_no, runt_id, main_attr, minor_attr, runt_pb):
        runt_pb.runt_no = runt_no
        runt_pb.runt_id = runt_id
        for (attr_type, [attr_value_type, attr_value, attr_increment]) in main_attr.items():
            main_attr_pb = runt_pb.main_attr.add()
            main_attr_pb.attr_type = attr_type
            main_attr_pb.attr_value_type = attr_value_type
            main_attr_pb.attr_value = attr_value
            main_attr_pb.attr_increment = attr_increment

        for (attr_type, [attr_value_type, attr_value, attr_increment]) in minor_attr.items():
            minor_attr_pb = runt_pb.minor_attr.add()
            minor_attr_pb.attr_type = attr_type
            minor_attr_pb.attr_value_type = attr_value_type
            minor_attr_pb.attr_value = attr_value
            minor_attr_pb.attr_increment = attr_increment

    @property
    def m_runt(self):
        return self._m_runt

    @m_runt.setter
    def m_runt(self, value):
        self._m_runt = value

    @property
    def stone1(self):
        return self._stone1

    @stone1.setter
    def stone1(self, value):
        self._stone1 = value

    @property
    def stone2(self):
        return self._stone2

    @stone2.setter
    def stone2(self, value):
        self._stone2 = value

    @property
    def refresh_runt(self):
        return self._refresh_runt

    @refresh_runt.setter
    def refresh_runt(self, value):
        self._refresh_runt = value

    @property
    def refresh_times(self):
        return self._refresh_times

    @refresh_times.setter
    def refresh_times(self, value):
        self._refresh_times = value

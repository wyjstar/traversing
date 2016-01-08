# -*- coding:utf-8 -*-
"""
"""
from app.game.component.Component import Component
from app.game.redis_mode import tb_character_info
from shared.db_opear.configs_data import game_configs
import random
from shared.utils.pyuuid import get_uuid
import copy
import time
from shared.db_opear.configs_data.common_item import CommonItem


class CharacterRobTreasureComponent(Component):
    """夺宝
    """

    def __init__(self, owner):
        super(CharacterRobTreasureComponent, self).__init__(owner)
        # self._treasures_obj = {}  # {no:info}
        # self._treasures_chips = {}  # {id:num}
        self._truce = [0, 0]  # 使用休战道具个数 starttime
        self._truce_item = [0, 1]  # 今日已经使用个数，使用时间戳
        self._refresh_time = 1  # 列表刷新时间
        self._can_receive = 0  # 可以领取翻牌子奖励

    def init_data(self, character_info):
        self._truce = character_info.get('truce', [0, 0])
        self._truce_item = character_info.get('truce_item', [0, 1])
        self._refresh_time = character_info.get('refresh_time', 1)
        self._can_receive = character_info.get('can_receive', 0)

    def save_data(self):
        data_obj = tb_character_info.getObj(self.owner.base_info.id)
        data_obj.hmset({'truce': self._truce,
                        'ltruce_item': self._truce_item,
                        'refresh_time': self._refresh_time,
                        'can_receive': self._can_receive,
                        })

    def new_data(self):
        return {'truce': self._truce,
                'ltruce_item': self._truce_item,
                'refresh_time': self._refresh_time,
                'can_receive': self._can_receive,
                }

    @property
    def can_receive(self):
        return self._can_receive

    @can_receive.setter
    def can_receive(self, v):
        self._can_receive = v

    @property
    def refresh_time(self):
        return self._refresh_time

    @refresh_time.setter
    def refresh_time(self, v):
        self._refresh_time = v

    @property
    def truce(self):
        now = int(time.time())
        item_config_item = game_configs.item_config.get(130001)
        end_time = self._truce[1] + self._truce[0] * item_config_item.funcArg1 * 60
        if self._truce[1] and end_time > now:
            return self._truce
        return [0, 0]

    @truce.setter
    def truce(self, v):
        self._truce = v

    @property
    def truce_item_num_day(self):
        if is_today(self._truce_item[1]):
            return self._truce_item[0]
        return 0

    def do_truce(self, num):
        now = int(time.time())

        if is_today(self._truce_item[1]):
            self._truce_item[0] += num
        else:
            self._truce_item = [num, now]

        item_config_item = game_configs.item_config.get(130001)
        end_time = self._truce[1] + self._truce[0] * item_config_item.funcArg1 * 60
        if self._truce[1] and end_time > now:
            self._truce[0] += num
        else:
            self._truce = [num, now]
        return self._truce[0], self._truce[1], self._truce_item[0]

    def get_target_color_info(self, target_id):
        target_ids = self.owner.pvp.rob_treasure
        index = 1
        for id, ap in target_ids:
            if target_id == id:
                break
            index += 1
        index = len(target_ids) + 1 - index
        types = game_configs.base_config.get('indianaMatch')
        for _id in types:
            item1 = game_configs.arena_fight_config.get(_id)
            item = CommonItem(item1)
            if len(item.play_rank) == 2 and item.play_rank[0] <= index <= item.play_rank[1]:
                return item
            elif len(item.play_rank) == 1 and item.play_rank[0] == index:
                return item


def is_today(timeA):
    if time.localtime(timeA).tm_yday == time.localtime().tm_yday:
        return True
    return False

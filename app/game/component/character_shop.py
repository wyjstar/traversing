# -*- coding:utf-8 -*-
"""
created by server on 14-10-3下午3:43.
"""

from app.game.component.Component import Component
from app.game.redis_mode import tb_character_info
from shared.db_opear.configs_data import game_configs
from shared.utils.random_pick import random_multi_pick_without_repeat
from gfirefly.server.logobj import logger
from time import localtime
import time
from shared.utils.date_util import is_past_time
from app.game.core.drop_bag import BigBag


class CharacterShopComponent(Component):
    """武魂商店组件"""

    def __init__(self, owner):
        super(CharacterShopComponent, self).__init__(owner)
        self._shop_data = {}
        self._first_coin_draw = True  # 第一次免费抽取为某个特定武将
        self._first_gold_draw = True  # 第一次免费抽取为某个特定武将
        self._pseudo_times = {} #

    def init_data(self, character_info):
        self._shop_data = character_info.get('shop')
        self._first_coin_draw = character_info.get('first_coin_draw')
        self._first_gold_draw = character_info.get('first_gold_draw')
        self._pseudo_times = character_info.get('pseudo_times')
        self.check_time()

        # for k, v in self._shop_data.items():
        #     print k, v.items()

    def save_data(self):
        shop = tb_character_info.getObj(self.owner.base_info.id)
        if shop:
            shop.hset('shop', self._shop_data)
            shop.hset('first_coin_draw', self._first_coin_draw)
            shop.hset('first_gold_draw', self._first_gold_draw)
            shop.hset('pseudo_times', self._pseudo_times)

        else:
            logger.error('cant find shop:%s', self.owner.base_info.id)

    def new_data(self):
        for t, item in game_configs.shop_type_config.items():
            data = {}
            data['buyed_item_ids'] = []
            data['refresh_times'] = 0
            data['last_refresh_time'] = time.time()
            data['luck_num'] = 0.0
            data['luck_time'] = time.time()
            data['item_ids'] = self.get_shop_item_ids(t, 0)
            data['limit_items'] = {}
            # print t, data['item_ids']
            self._shop_data[t] = data
        # print data
        return {'shop': self._shop_data,
                'first_coin_draw': True,
                'first_gold_draw': True,
                'pseudo_times': self._pseudo_times}

    def check_time(self):
        current_date_time = time.time()
        current_day = localtime(current_date_time).tm_yday
        for k, v in self._shop_data.items():
            refresh_day = localtime(v['last_refresh_time']).tm_yday
            if current_day != refresh_day:
                v['refresh_times'] = 0
                v['limit_items'] = {}
                v['last_refresh_time'] = time.time()

            luck_day = localtime(v['luck_time']).tm_yday
            if current_day != luck_day:
                v['luck_time'] = time.time()
                v['luck_num'] = 0.0
                v['limit_items'] = {}

            if 'limit_items' not in v:
                v['limit_items'] = {}

        #自动刷新列表
        for shop_type, shop_type_info in game_configs.shop_type_config.items():
            freeRefreshTime = shop_type_info.freeRefreshTime
            if shop_type_info.freeRefreshTime == "-1":
                continue
            #if is_past_time(freeRefreshTime):
                #self.refresh_items(shop_type)

    def get_shop_data(self, t):
        if t not in self._shop_data:
            logger.error('err shop type:%s', t)
            return None

        self.check_time()
        return self._shop_data[t]

    def refresh_price(self, shop_type):
        shop_item = game_configs.shop_type_config.get(shop_type)
        if not shop_item:
            raise Exception('error shop type:%s' % shop_type)
        price = 0
        free_times = shop_item.get('freeRefreshTimes')

        __shop_data = self._shop_data[shop_type]
        if __shop_data['refresh_times'] >= free_times:
            refreshprice = shop_item.get('refreshPrice')
            if not refreshprice:
                logger.debug('no refresh price:shop type:%s', shop_type)
            else:
                ctype, price = refreshprice.items()[0]
            # print ctype, price
        def func():
            __shop_data['refresh_times'] += 1
            __shop_data['last_refresh_time'] = time.time()
            __shop_data['buyed_item_ids'] = []
            # data['last_refresh_time'] = time.time()
            if shop_item.itemNum > 0:
                # print shop_item, shop_type
                __shop_data['item_ids'] = self.get_shop_item_ids(shop_type,
                                                                self._shop_data[shop_type]['luck_num'])
            self.save_data()

        result = self._owner.pay.pay(price, func)
        return result

    def refresh_items(self, type_shop):
        if type_shop in self._shop_data:
            ids = self.get_shop_item_ids(type_shop, self._shop_data[type_shop].luck_num)
            self._shop_data[type_shop]['item_ids'] = ids
            logger.info('refresh_item_ids:%s', ids)
            self.save_data()
            return True
        else:
            logger.error('err type shop:%s', type_shop)
            return False

    def get_shop_item_ids(self, shop_type, luck_num):
        """随机筛选ids"""
        items = {}
        for item in game_configs.shop_config.get(shop_type):
            if item.weight == -1:
                continue
            elif item.weight == -2:
                weights = sorted(item.get('weightGroup'), reverse=True)
                for w in weights:
                    if luck_num >= w:
                        items[item.id] = item.get('weightGroup')[w]
                        break
                else:
                    logger.error('error luck_num:%s:%s', luck_num, item.get('weightGroup'))
            else:
                items[item.id] = item.weight

        shop_item = game_configs.shop_type_config.get(shop_type)
        if not shop_item:
            raise Exception('error shop type:%s' % shop_type)
        item_num = shop_item.get('itemNum')
        if item_num == -1:
            return items.keys()
        if not items:
            return []
        return random_multi_pick_without_repeat(items, item_num)
    @property
    def first_coin_draw(self):
        return self._first_coin_draw
    @first_coin_draw.setter
    def first_coin_draw(self, value):
        self._first_coin_draw = value

    @property
    def first_gold_draw(self):
        return self._first_gold_draw
    @first_gold_draw.setter
    def first_gold_draw(self, value):
        self._first_gold_draw = value

    def get_draw_drop_bag(self, pseudo_bag_id):
        """docstring for get_draw_drop_bag"""
        draw_times = self._pseudo_times.get(pseudo_bag_id, 0)
        pseudo_random_info = game_configs.pseudo_random_config.get(pseudo_bag_id)
        assert pseudo_random_info!=None, "can not find pseudo bag:%s" % pseudo_bag_id
        gain = pseudo_random_info.gain
        drop_items = []
        for k in sorted(gain.keys(), reverse=True):
            if draw_times >= k:
                bags = gain.get(k)
                for bag_id in bags:
                    logger.debug("drop_bag_id %s", bag_id)
                    big_bag = BigBag(bag_id)
                    drop_items.extend(big_bag.get_drop_items())
                break
        logger.debug("drop_items %s", drop_items)
        self._pseudo_times[pseudo_bag_id] = draw_times + 1
        self.save_data()
        return drop_items






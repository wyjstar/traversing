# -*- coding:utf-8 -*-
"""
created by server on 14-10-3下午3:43.
"""

from app.game.component.Component import Component
from app.game.redis_mode import tb_character_info
from shared.db_opear.configs_data.game_configs import shop_config
from shared.db_opear.configs_data.game_configs import shop_type_config
from shared.utils.random_pick import random_multi_pick_without_repeat
from gfirefly.server.logobj import logger
from time import localtime
import time


class CharacterShopComponent(Component):
    """武魂商店组件"""

    def __init__(self, owner):
        super(CharacterShopComponent, self).__init__(owner)
        self._shop_data = {}

    def init_data(self, character_info):
        if character_info.get('shop'):
            # print shop_data
            self._shop_data = character_info.get('shop')
            # print self._shop_data
            self.check_time()
        else:
            shop = tb_character_info.getObj(self.owner.base_info.id)
            for t, item in shop_type_config.items():
                data = {}
                data['buyed_item_ids'] = []
                data['refresh_times'] = 0
                data['last_refresh_time'] = time.time()
                data['luck_num'] = 0.0
                data['luck_time'] = time.time()
                data['item_ids'] = self.get_shop_item_ids(t, 0)
                print t, data['item_ids']
                self._shop_data[t] = data
            # print data
            shop.hset('shop', self._shop_data)

        # for k, v in self._shop_data.items():
        #     print k, v.items()

    def save_data(self):
        shop = tb_character_info.getObj(self.owner.base_info.id)
        if shop:
            shop.hset('shop', self._shop_data)
        else:
            logger.error('cant find shop:%s', self.owner.base_info.id)

    def check_time(self):
        current_date_time = time.time()
        current_day = localtime(current_date_time).tm_yday
        for k, v in self._shop_data.items():
            refresh_day = localtime(v['last_refresh_time']).tm_yday
            if current_day != refresh_day:
                v['refresh_times'] = 0

            luck_day = localtime(v['luck_time']).tm_yday
            if current_day != luck_day:
                v['luck_time'] = time.time()
                v['luck_num'] = 0.0

    def get_shop_data(self, t):
        if t not in self._shop_data:
            logger.error('err shop type:%s', t)
            return None

        self.check_time()
        return self._shop_data[t]

    def refresh_price(self, shop_type):
        shop_item = shop_type_config.get(shop_type)
        if not shop_item:
            raise Exception('error shop type:%s' % shop_type)
        price = 0
        free_times = shop_item.get('freeRefreshTimes')

        __shop_data = self._shop_data[shop_type]
        if __shop_data['refresh_times'] >= free_times:
            refreshprice = shop_item.get('refreshPrice')
            if not refreshprice:
                logger.error('no refresh price:shop type:%s', shop_type)
                return False
            ctype, price = refreshprice.items()[0]
            # print ctype, price

        result = self.owner.finance.consume_gold(price)
        self.owner.finance.save_data()
        __shop_data['refresh_times'] += 1
        __shop_data['last_refresh_time'] = time.time()
        __shop_data['buyed_item_ids'] = []
        # data['last_refresh_time'] = time.time()
        if shop_item.itemNum > 0:
            __shop_data['item_ids'] = self.get_shop_item_ids(shop_type, shop_item.itemNum)
        self.save_data()

        return result

    def refresh_items(self, type_shop):
        if type_shop in self._shop_data:
            ids = self.get_shop_item_ids(type_shop, type_shop.luck_num)
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
        for item in shop_config.get(shop_type):
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

        shop_item = shop_type_config.get(shop_type)
        if not shop_item:
            raise Exception('error shop type:%s' % shop_type)
        item_num = shop_item.get('itemNum')
        if item_num == -1:
            return items.keys()
        if not items:
            return []
        return random_multi_pick_without_repeat(items, item_num)

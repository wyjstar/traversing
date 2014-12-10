# -*- coding:utf-8 -*-
"""
created by server on 14-10-3下午3:43.
"""

from app.game.component.Component import Component
from app.game.redis_mode import tb_character_shop
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

    def init_data(self):
        shop_data = tb_character_shop.getObjData(self.owner.base_info.id)
        if shop_data:
            print shop_data
            self._shop_data = shop_data.get('shop')
            print self._shop_data

            # 初始化刷新次数
            for k, v in self._shop_data.items():
                current_date_time = int(time.time())
                if current_date_time >= v['last_refresh_time']:
                    v['refresh_times'] = 0
                current_day = localtime(current_date_time).tm_yday
                luck_day = localtime(v['luck_time']).tm_yday
                if current_day != luck_day:
                    v['luck_time'] = time.time()
                    v['luck_num'] = 0.0
        else:
            for t, item in shop_type_config.items():
                data = {}
                data['buyed_item_ids'] = []
                data['refresh_times'] = 0
                data['last_refresh_time'] = time.time()
                data['luck_num'] = 0.0
                data['luck_time'] = time.time()
                if item.itemNum > 0:
                    data['item_ids'] = self.get_shop_item_ids(t, 0)
                self._shop_data[t] = data
            data = dict(id=self.owner.base_info.id, shop=self._shop_data)
            print data
            tb_character_shop.new(data)

        for k, v in self._shop_data.items():
            print k, v.items()

    def save_data(self):
        shop = tb_character_shop.getObj(self.owner.base_info.id)
        if shop:
            props = dict(shop=self._shop_data)
            shop.update_multi(props)
        else:
            logger.error('cant find shop:%s', self.owner.base_info.id)

    def get_shop_data(self, t):
        if t not in self._shop_data:
            logger.error('err shop type:%s', t)
            return None

        v = self._shop_data[t]
        current_date_time = int(time.time())
        if current_date_time >= v['last_refresh_time']:
            v['refresh_times'] = 0
        current_day = localtime(current_date_time).tm_yday
        luck_day = localtime(v['luck_time']).tm_yday
        if current_day != luck_day:
            v['luck_time'] = time.time()
            v['luck_num'] = 0.0
        return v

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
            print ctype, price

        result = self.owner.finance.consume_gold(price)
        self.owner.finance.save_data()
        __shop_data['refresh_times'] += 1
        __shop_data['last_refresh_time'] = time.time()
        __shop_data['buyed_item_ids'] = []
        # data['last_refresh_time'] = time.time()
        if shop_item.itemNum > 0:
            __shop_data['item_ids'] = self.get_shop_item_ids(shop_type, 0)
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
                items[item.id] = item.get('weightGroup')[luck_num]
            else:
                items[item.id] = item.weight

        shop_item = shop_type_config.get(shop_type)
        if not shop_item:
            raise Exception('error shop type:%s' % shop_type)
        item_num = shop_item.get('itemNum')
        if not items:
            return []
        return random_multi_pick_without_repeat(items, item_num)

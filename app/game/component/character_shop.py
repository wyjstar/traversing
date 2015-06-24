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
from app.game.core.item_group_helper import do_get_draw_drop_bag


class CharacterShopComponent(Component):
    """武魂商店组件"""

    def __init__(self, owner):
        super(CharacterShopComponent, self).__init__(owner)
        self._shop_data = {}
        self._shop_extra_args = {}

    def init_data(self, character_info):
        self._shop_data = character_info.get('shop')
        self._shop_extra_args = character_info.get('shop_extra_args', self.get_new_shop_extra_args())
        self.check_time()
        self.refresh_shop_info()

    def save_data(self):
        shop = tb_character_info.getObj(self.owner.base_info.id)
        if shop:
            data = {'shop': self._shop_data, 'shop_extra_args': self._shop_extra_args}
            shop.hmset(data)
        else:
            logger.error('cant find shop:%s', self.owner.base_info.id)

    def new_data(self):
        for t, item in game_configs.shop_type_config.items():
            self._shop_data[t] = self.get_new_shop_info(t)
        self._shop_extra_args = self.get_new_shop_extra_args()
        return {'shop': self._shop_data,
                'shop_extra_args': self._shop_extra_args}

    def refresh_shop_info(self):
        for t, item in game_configs.shop_type_config.items():
            if not self._shop_data.get(t):
                self._shop_data[t] = self.get_new_shop_info(t)
        self.save_data()

    def get_new_shop_info(self, shop_type):
        data = {}
        data['buyed_item_ids'] = []
        data['refresh_times'] = 0
        data['last_refresh_time'] = time.time() # 手动刷新
        data['last_auto_refresh_time'] = time.time() # 自动刷新
        data['luck_num'] = 0.0
        data['luck_time'] = time.time()
        data['item_ids'] = self.get_shop_item_ids(shop_type, 0)
        data['limit_items'] = {}
        data['vip_limit_items'] = {}
        return data

    def get_new_shop_extra_args(self):
        data = {}
        data['first_coin_draw'] = True # 第一次免费抽取为某个特定武将
        data['first_gold_draw'] = True # 第一次免费抽取为某个特定武将
        data['single_coin_draw_times'] = 0 # 元宝单抽次数,十连抽必出紫
        data['single_gold_draw_times'] = 0 #银两单抽次数,十连抽必出
        data['pseudo_times'] = {}
        return data

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

            if 'vip_limit_items' not in v:
                v['vip_limit_items'] = {}

            #自动刷新列表
            shop_type_info = game_configs.shop_type_config.get(k)
            freeRefreshTime = shop_type_info.freeRefreshTime
            if shop_type_info.freeRefreshTime == "-1":
                continue
            logger.debug("%s %s" % (freeRefreshTime, v['last_auto_refresh_time']))
            if time.time() > is_past_time(freeRefreshTime, v['last_auto_refresh_time']):
                self.auto_refresh_items(k)

    def get_shop_data(self, t):
        if t not in self._shop_data:
            logger.error('err shop type:%s', t)
            return None

        self.check_time()
        return self._shop_data[t]

    def check_shop_refresh_times(self, shop_type):
        shop_data = self._shop_data[shop_type]
        max_shop_refresh_times = self.owner.base_info.shop_refresh_times
        return shop_data['refresh_times'] < max_shop_refresh_times

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
        if shop_type == 12:
            # 9活动
            act_confs = game_configs.activity_config.get(22, [])
            is_open = 0
            xs = 1
            for act_conf in act_confs:
                if self.owner.base_info.is_activiy_open(act_conf.id):
                    is_open = 1
                    xs = act_conf.parameterC[0]
                    break
            if is_open:
                price = int(price*xs)

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

    def auto_refresh_items(self, type_shop):
        logger.debug("auto_refresh_items=========")
        if type_shop in self._shop_data:
            ids = self.get_shop_item_ids(type_shop, self._shop_data[type_shop]['luck_num'])
            self._shop_data[type_shop]['item_ids'] = ids
            self._shop_data[type_shop]['last_auto_refresh_time'] = time.time()
            self._shop_data[type_shop]['buyed_item_ids'] = []
            logger.info('refresh_item_ids:%s', ids)
            self.save_data()
            return True
        else:
            logger.error('err type shop:%s', type_shop)
            return False

    def get_shop_item_ids(self, shop_type, luck_num):
        """随机筛选ids"""
        items = {}
        for item in game_configs.shop_config.get(shop_type, []):
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
        return self._shop_extra_args.get("first_coin_draw")
    @first_coin_draw.setter
    def first_coin_draw(self, value):
        self._shop_extra_args["first_coin_draw"] = value

    @property
    def first_gold_draw(self):
        return self._shop_extra_args.get("first_gold_draw")
    @first_gold_draw.setter
    def first_gold_draw(self, value):
        self._shop_extra_args["first_gold_draw"] = value

    @property
    def single_gold_draw_times(self):
        return self._shop_extra_args.get("single_gold_draw_times")

    @single_gold_draw_times.setter
    def single_gold_draw_times(self, value):
        self._shop_extra_args["single_gold_draw_times"] = value

    @property
    def single_coin_draw_times(self):
        return self._shop_extra_args.get("single_coin_draw_times")

    @single_coin_draw_times.setter
    def single_coin_draw_times(self, value):
        self._shop_extra_args["single_coin_draw_times"] = value

    @property
    def pseudo_times(self):
        return self._shop_extra_args.get("pseudo_times")

    def get_draw_drop_bag(self, pseudo_bag_id):
        """docstring for get_draw_drop_bag"""
        draw_times = self.pseudo_times.get(pseudo_bag_id, 0)
        drop =  do_get_draw_drop_bag(pseudo_bag_id, draw_times)
        self.pseudo_times[pseudo_bag_id] = draw_times + 1
        self.save_data()
        return drop

# -*- coding:utf-8 -*-
"""
created by server on 14-10-3下午3:43.
"""

from app.game.component.Component import Component
from app.game.redis_mode import tb_character_info
from shared.db_opear.configs_data import game_configs
from gfirefly.server.logobj import logger
import time
from app.game.core.item_group_helper import do_get_draw_drop_bag
from app.game.core.item_group_helper import is_afford, consume, \
    get_consume_gold_num, get_return
from shared.utils.const import const
from shared.common_logic.shop import guild_shops, get_new_shop_info, \
    check_time, refresh_shop_info, get_shop_item_ids, \
    do_auto_refresh_items


class CharacterShopComponent(Component):
    """武魂商店组件"""

    def __init__(self, owner):
        super(CharacterShopComponent, self).__init__(owner)
        self._shop_data = {}
        self._shop_extra_args = {}

    def init_data(self, character_info):
        self._shop_data = character_info.get('shop')
        self._shop_extra_args = character_info.get('shop_extra_args',
                                                   self.get_new_shop_extra_args())
        check_time(self._shop_data)
        refresh_shop_info(self._shop_data, 0)
        self.save_data()

    def save_data(self):
        shop = tb_character_info.getObj(self.owner.base_info.id)
        if shop:
            data = {'shop': self._shop_data, 'shop_extra_args': self._shop_extra_args}
            shop.hmset(data)
        else:
            logger.error('cant find shop:%s', self.owner.base_info.id)

    def new_data(self):
        for t, item in game_configs.shop_type_config.items():
            if t in guild_shops:
                continue
            self._shop_data[t] = get_new_shop_info(t)
        self._shop_extra_args = self.get_new_shop_extra_args()
        return {'shop': self._shop_data,
                'shop_extra_args': self._shop_extra_args}

    def get_new_shop_extra_args(self):
        data = {}
        data['first_coin_draw'] = True # 第一次免费抽取为某个特定武将
        data['first_gold_draw'] = True # 第一次免费抽取为某个特定武将
        data['single_coin_draw_times'] = 0 # 元宝单抽次数,十连抽必出紫
        data['single_gold_draw_times'] = 0 #银两单抽次数,十连抽必出
        data['pseudo_times'] = {}
        return data

    def get_shop_data(self, t):
        if t not in self._shop_data:
            logger.error('err shop type:%s', t)
            return None

        check_time(self._shop_data)
        return self._shop_data[t]

    def check_shop_refresh_times(self, shop_type):
        shop_data = self._shop_data[shop_type]
        max_shop_refresh_times = self.owner.base_info.shop_refresh_times
        if shop_type not in max_shop_refresh_times:
            logger.error('not found shop refresh times: %s--%s',
                         shop_type, max_shop_refresh_times)
            return False
        return shop_data['refresh_times'] < max_shop_refresh_times[shop_type]

    def refresh_price(self, shop_type, response):
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

            # 道具
            refresh_items = shop_item.get('refreshItem')
            has_refresh_item = is_afford(self._owner,
                                         refresh_items).get('result')
            if refresh_items and has_refresh_item:
                price = 0
                # 如果有刷新令，则消耗刷新令
                return_data = consume(self._owner,
                                      refresh_items,
                                      const.SHOP_REFRESH,
                                      shop=None,
                                      luck_config=None,
                                      multiple=1)
                get_return(self._owner, return_data, response.consume)
            elif not has_refresh_item or not refresh_items:
                price = get_consume_gold_num(refreshprice)

                xs = 1
                if (not has_refresh_item or not refresh_items) and shop_type == 12:
                    # 9活动
                    act_confs = game_configs.activity_config.get(22, [])
                    for act_conf in act_confs:
                        if self.owner.base_info.is_activiy_open(act_conf.id):
                            xs = act_conf.parameterC[0]
                            price = int(price*xs)
                            break
                return_data = consume(self._owner,
                                      refreshprice,
                                      const.SHOP_REFRESH,
                                      shop=None,
                                      luck_config=None,
                                      multiple=xs)
                get_return(self._owner, return_data, response.consume)

        def func():
            __shop_data['refresh_times'] += 1
            __shop_data['last_refresh_time'] = time.time()
            __shop_data['items'] = {}
            # data['last_refresh_time'] = time.time()
            if shop_item.itemNum > 0:
                __shop_data['item_ids'] = get_shop_item_ids(shop_type,
                                                                self._shop_data[shop_type]['luck_num'])
            self.save_data()

        result = self._owner.pay.pay(price, const.SHOP_REFRESH, func)
        return result

    def auto_refresh_items(self, shop_type):
        do_auto_refresh_items(shop_type, self._shop_data)

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
        drop = do_get_draw_drop_bag(pseudo_bag_id, draw_times)
        self.pseudo_times[pseudo_bag_id] = draw_times + 1
        self.save_data()
        return drop

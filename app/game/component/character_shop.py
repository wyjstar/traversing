# -*- coding:utf-8 -*-
"""
created by server on 14-10-3下午3:43.
"""

import time
from app.game.component.Component import Component
from app.game.redis_mode import tb_character_info
from shared.db_opear.configs_data import game_configs
from gfirefly.server.logobj import logger
from app.game.core.item_group_helper import do_get_draw_drop_bag
from app.game.core.item_group_helper import is_afford
from app.game.core.item_group_helper import consume
from app.game.core.item_group_helper import get_consume_gold_num
from app.game.core.item_group_helper import get_return
from shared.utils.const import const
from shared.common_logic.shop import guild_shops
from shared.common_logic.shop import get_new_shop_info
from shared.common_logic.shop import check_time
# from shared.common_logic.shop import refresh_shop_info
from shared.common_logic.shop import get_shop_item_ids
from shared.common_logic.shop import do_auto_refresh_items
from app.proto_file.shop_pb2 import GetShopItemsResponse


class CharacterShopComponent(Component):
    """武魂商店组件"""

    def __init__(self, owner):
        super(CharacterShopComponent, self).__init__(owner)
        self._shop_data = {}
        self._shop_extra_args = {}

    def init_data(self, character_info):
        self._shop_data = character_info.get('shop')
        self._shop_extra_args = character_info.get(
            'shop_extra_args', self.get_new_shop_extra_args())
        check_time(self._shop_data)
        # refresh_shop_info(self._shop_data, 0)
        self.save_data()

    def save_data(self):
        shop = tb_character_info.getObj(self.owner.base_info.id)
        if shop:
            data = {'shop': self._shop_data,
                    'shop_extra_args': self._shop_extra_args}
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
        data['first_coin_draw'] = True  # 第一次免费抽取为某个特定武将
        data['first_gold_draw'] = True  # 第一次免费抽取为某个特定武将
        data['single_coin_draw_times'] = 0  # 元宝单抽次数,十连抽必出紫
        data['single_gold_draw_times'] = 0  # 银两单抽次数,十连抽必出
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
            logger.error('not found shop refresh times: %s--%s', shop_type,
                         max_shop_refresh_times)
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
                if (not has_refresh_item or
                        not refresh_items) and shop_type == 12:
                    # 9活动
                    act_confs = game_configs.activity_config.get(22, [])
                    for act_conf in act_confs:
                        if self.owner.act.is_activiy_open(act_conf.id):
                            xs = act_conf.parameterC[0]
                            price = int(price * xs)
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
            if shop_item.itemNum > 0:
                __shop_data['item_ids'] = get_shop_item_ids(
                    shop_type, self._shop_data[shop_type]['luck_num'])
            self.save_data()

        result = self._owner.pay.pay(price, const.SHOP_REFRESH, func)
        return result

    def auto_refresh_items(self, shop_type):
        do_auto_refresh_items(shop_type, self._shop_data)

    def build_response_shop_items(self, shop_type):
        response = GetShopItemsResponse()

        # TODO 根据类型 从商店类型表里判断需不需要加入军团
        if shop_type in guild_shops and self.owner.guild.g_id == 0:
            response.res.result_no = 846
            response.res.result = False
            return response.SerializePartialToString()

        if shop_type in guild_shops:
            shopdata = self.owner.guild.get_shop_data(shop_type)
        else:
            shopdata = self.get_shop_data(shop_type)

        shop_is_open = self.owner.base_info.vip_shop_open
        _is_open = shop_is_open.get(shop_type, 0)
        if _is_open == 0:
            logger.error('shop is not open with vip:%s--%s', shop_type,
                         shop_is_open)
            response.res.result_no = 50801
            response.res.result = False
            return response.SerializePartialToString()

        if not shopdata:
            response.res.result = False
            return response.SerializePartialToString()

        for x in shopdata['item_ids']:
            response.id.append(x)
        for k, v in shopdata['items'].items():
            items = response.items.add()
            items.item_id = k
            items.item_num = v
        for k, v in shopdata['all_items'].items():
            all_items = response.all_items.add()
            all_items.item_id = k
            all_items.item_num = v
        for k, v in shopdata['guild_items'].items():
            guild_items = response.guild_items.add()
            guild_items.item_id = k
            guild_items.item_num = v

        # logger.debug("getshop items:%s:%s", shop_type, shopdata['item_ids'])
        response.luck_num = int(shopdata['luck_num'])
        response.res.result = True
        response.refresh_times = shopdata['refresh_times']
        # print response, shop_type, '====================shop item 508'
        return response.SerializePartialToString()

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

# -*- coding:utf-8 -*-
"""
created by server on 14-10-3下午3:43.
"""

from app.game.component.Component import Component
from app.game.redis_mode import tb_character_shop
from shared.db_opear.configs_data.game_configs import base_config
from gfirefly.server.logobj import logger
from datetime import datetime
from time import mktime


class ShopData(object):
    refresh_times = 0
    last_refresh_time = 0
    item_ids = []


class CharacterShopComponent(Component):
    """武魂商店组件"""

    def __init__(self, owner):
        super(CharacterShopComponent, self).__init__(owner)
        self._shop_data = {}

    def init_shop(self):
        shop_data = tb_character_shop.getObjData(self.owner.base_info.id)
        if shop_data:
            self._shop_data = shop_data.get('shop')

            # 初始化刷新次数
            for k, v in self._shop_data:
                current_date_time = int(mktime(datetime.now().date().timetuple()))
                if current_date_time >= v.last_refresh_time:
                    v.refresh_times = 0

    def save_data(self):
        props = dict(id=self.owner.base_info.id, shop=self._shop_data)
        shop = tb_character_shop.getObj(self.owner.base_info.id)
        shop.update_multi(props)

    @property
    def detail_data(self):
        """soul shop detail data"""
        return {
            'refresh_times': self._refresh_times,
            'last_refresh_time': self._last_refresh_time,
            'item_ids': self._item_ids
        }

    def get_shop_data(self, t):
        return self._shop_data[t]

    @property
    def price(self):
        price = base_config.get('soulShopRefreshPrice').get(2)[0]
        k = base_config.get('soulShopRefreshFactor')
        free_times = base_config.get('soulShopFreeRefreshTimes')

        if self._refresh_times < free_times:
            return 0
        else:
            return price * pow(k, self._refresh_times - free_times)

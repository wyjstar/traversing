# -*- coding:utf-8 -*-
"""
created by server on 14-10-3下午3:43.
"""

from app.game.component.Component import Component
from app.game.redis_mode import tb_character_info
from shared.db_opear.configs_data.game_configs import base_config
from gtwisted.utils import log
from datetime import datetime
from time import mktime



class CharacterSoulShopComponent(Component):
    """武魂商店组件"""

    def __init__(self, owner):
        super(CharacterSoulShopComponent, self).__init__(owner)
        self._refresh_times = 0  # 武魂商店刷新次数
        self._last_refresh_time = 0  # 上次刷新时间
        self._item_ids = []  # 当前武魂商店商品

    def init_soul_shop(self, soul_shop_data):
        log.DEBUG(str(soul_shop_data) + ", soul_shop_data+++++++++++++++++")
        if soul_shop_data:
            self._refresh_times = soul_shop_data.get('refresh_times')
            self._last_refresh_time = soul_shop_data.get('last_refresh_time')
            self._item_ids = soul_shop_data.get('item_ids')

            # 初始化刷新次数
            current_date_time = int(mktime(datetime.now().date().timetuple()))
            if current_date_time >= self._last_refresh_time:
                self._refresh_times = 0




    @property
    def detail_data(self):
        """soul shop detail data"""
        return {
            'refresh_times': self._refresh_times,
            'last_refresh_time': self._last_refresh_time,
            'item_ids': self._item_ids
        }

    @property
    def refresh_times(self):
        """刷新次数"""
        return self._refresh_times

    @refresh_times.setter
    def refresh_times(self, value):
        """体力"""
        self._refresh_times = value

    @property
    def last_refresh_time(self):
        """上次刷新时间"""
        return self._last_refresh_time

    @last_refresh_time.setter
    def last_refresh_time(self, value):
        """上次刷新时间"""
        self._last_refresh_time = value

    @property
    def item_ids(self):
        """商品id"""
        return self._item_ids

    @item_ids.setter
    def item_ids(self, value):
        """商品id"""
        self._item_ids = value

    @property
    def price(self):
        price = base_config.get('soulShopRefreshPrice').get('2')[0]
        k = base_config.get('soulShopRefreshFactor')
        free_times = base_config.get('soulShopFreeRefreshTimes')

        if self._refresh_times < free_times:
            return 0
        else:
            return price * pow(k, self._refresh_times - free_times)

    def save_data(self):
        props = dict(soul_shop=self.detail_data)
        info = tb_character_info.getObj(self.owner.base_info.id)
        info.update_multi(props)

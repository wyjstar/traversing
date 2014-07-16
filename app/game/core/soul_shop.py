# -*- coding:utf-8 -*-
"""
created by server on 14-7-16上午9:49.
武魂商店
"""
from shared.db_opear.configs_data.game_configs import soul_shop_config
from shared.db_opear.configs_data.game_configs import base_config
from shared.utils.random_pick import random_multi_pick_without_repeat


def get_all_shop_items():
    """从配置文件中读取所有商品"""
    data = {}
    for item_id, item in soul_shop_config.items():
        data[item_id] = item.weight
    return data


def get_shop_item_ids():
    """随机筛选ids"""
    items = get_all_shop_items()
    item_num = base_config.get('soul_shop_item_num')
    return random_multi_pick_without_repeat(items,item_num)
# -*- coding:utf-8 -*-
"""
@author: cui
"""
import time
from shared.db_opear.configs_data import game_configs
from gfirefly.server.logobj import logger
# import random
from shared.utils.random_pick import random_multi_pick_without_repeat
# from time import localtime
from shared.utils.date_util import is_past_time

guild_shops = [22]


def get_new_shop_info(shop_type):
    _now = time.time()
    data = {}
    data['refresh_times'] = 0
    data['last_refresh_time'] = _now  # 手动刷新
    data['last_auto_refresh_time'] = _now  # 自动刷新
    data['luck_num'] = 0.0
    data['luck_time'] = _now
    data['item_ids'] = get_shop_item_ids(shop_type, 0)
    data['items'] = {}  # 每日限制 每日刷新的
    data['all_items'] = {}  # 永久限制 一个号只能买一定个数
    data['guild_items'] = {}  # 军团限制军团公用个数 存军团里
    return data


def get_shop_item_ids(shop_type, luck_num):
    """随机筛选ids"""
    items = {}
    for item in game_configs.shop_config.get(shop_type, []):
        if item.weight == -1:
            items[item.id] = 1
            # continue
        elif item.weight == -2:
            weights = sorted(item.get('weightGroup'), reverse=True)
            for w in weights:
                if luck_num >= w:
                    items[item.id] = item.get('weightGroup')[w]
                    break
            else:
                logger.error('error luck_num:%s:%s', luck_num,
                             item.get('weightGroup'))
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


def do_auto_refresh_items(type_shop, shop_data):
    if type_shop not in shop_data:
        logger.error('err type shop:%s', type_shop)
        return False

    ids = get_shop_item_ids(type_shop, shop_data[type_shop]['luck_num'])
    shop_data[type_shop]['item_ids'] = ids
    shop_data[type_shop]['last_auto_refresh_time'] = time.time()
    shop_data[type_shop]['items'] = {}
    logger.info('refresh_item_ids:%s', ids)


def check_time(shop_data):
    # 1 个人 2 军团
    current_date_time = int(time.time())
    # current_day = localtime(current_date_time).tm_yday
    for k, v in shop_data.items():
        shop_type_info = game_configs.shop_type_config.get(k)
        freeRefreshTime = shop_type_info.freeRefreshTime
        if freeRefreshTime != '-1' and current_date_time > is_past_time(
                freeRefreshTime, v['last_refresh_time']):
            v['refresh_times'] = 0
            v['guild_items'] = {}
            v['items'] = {}
            v['last_refresh_time'] = current_date_time
            v['luck_time'] = current_date_time
            v['luck_num'] = 0.0

        # 自动刷新列表
        refresh = shop_type_info.refresh
        if refresh == -1:
            continue
        logger.debug("auto refresh %s %s" %
                     (refresh, v['last_auto_refresh_time']))
        tm_now = time.localtime(current_date_time)
        tm_refresh = time.localtime(v['last_auto_refresh_time'])
        if tm_now.tm_yday != tm_refresh.tm_yday or \
           tm_now.tm_hour / refresh * refresh > tm_refresh.tm_hour:
            do_auto_refresh_items(k, shop_data)


def refresh_shop_info(shop_data, is_guild_shop):
    for t, item in game_configs.shop_type_config.items():
        if (is_guild_shop and t in guild_shops) or (not is_guild_shop and
                                                    t not in guild_shops):
            shop_data[t] = get_new_shop_info(t)


def do_shop_buy(shop_id, item_count, shop, vip_level, build_level):

    shop_item = game_configs.shop_config.get(shop_id)
    shop_id_buyed_num = shop['items'].get(shop_id, 0)
    # shop_id_buyed_num_all = shop['all_items'].get(shop_id, 0)
    # guild_shop_id_buyed_num_day = shop['guild_items'].get(shop_id, 0)
    limit_type = ''

    if shop_item.limitVIP:
        limit_num = shop_item.limitVIP.get(vip_level, 0)
        limit_type = 'all_items'
        shop_id_buyed_num = shop['all_items'].get(shop_id, 0)

        if shop_id_buyed_num + item_count > limit_num:
            logger.error("vip limit shop item:%s:%s limit:%s:%s", shop_id,
                         item_count, shop_id_buyed_num, limit_num)
            return {'res': False, 'no': 502}
            # response.limit_item_current_num = shop_id_buyed_num_all
            # response.limit_item_max_num = limit_num

    elif shop_item.dutyFree:
        limit_num = shop_item.dutyFree.get(build_level, 0)
        limit_type = 'guild_items'
        shop_id_buyed_num = shop['guild_items'].get(shop_id, 0)

        if shop_id_buyed_num + item_count > limit_num:
            logger.error("limit shop item:%s:%s limit:%s:%s", shop_id,
                         item_count, shop_id_buyed_num, limit_num)
            return {'res': False, 'no': 502}
            # response.limit_item_current_num = shop_id_buyed_num_day
            # response.limit_item_max_num = limit_num

    elif shop_item.contribution:
        limit_num = shop_item.contribution.get(build_level, 0)
        limit_type = 'items'
        shop_id_buyed_num = shop['items'].get(shop_id, 0)

        if shop_id_buyed_num + item_count > limit_num:
            logger.error("limit shop item:%s:%s limit:%s:%s", shop_id,
                         item_count, shop_id_buyed_num, limit_num)
            return {'res': False, 'no': 502}
            # response.limit_item_current_num = shop_id_buyed_num_day
            # response.limit_item_max_num = limit_num

    elif shop_item.limitVIPeveryday:
        limit_num = shop_item.limitVIPeveryday.get(vip_level, 0)
        limit_type = 'items'
        shop_id_buyed_num = shop['items'].get(shop_id, 0)

        if shop_id_buyed_num + item_count > limit_num:
            logger.error("limit shop item:%s:%s limit:%s:%s", shop_id,
                         item_count, shop_id_buyed_num, limit_num)
            return {'res': False, 'no': 502}
            # response.limit_item_current_num = shop_id_buyed_num_day
            # response.limit_item_max_num = limit_num

    elif shop_item.batch != -1:
        limit_type = 'items'
        if shop_id_buyed_num + item_count > shop_item.batch:
            return {'res': False, 'no': 502}

    if limit_type:
        shop[limit_type][shop_id] = shop_id_buyed_num + item_count

    _lucky_attr = 0
    shop_item_attr = shop_item.get('attr')
    if shop_item_attr:
        lucky_keys = sorted(shop_item_attr.keys())
        for k in lucky_keys:
            if shop['luck_num'] >= k:
                _lucky_attr = shop_item_attr[k]
            else:
                break

    return {'res': True, 'lucky_attr': _lucky_attr, 'shop': shop}

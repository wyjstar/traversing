# -*- coding:utf-8 -*-
"""
created by server on 14-8-15下午5:30.
"""
from app.game.logic.common.check import have_player
from shared.db_opear.configs_data.game_configs import base_config
import time


@have_player
def eat_feast(dynamicid, **kwargs):
    """
    吃
    """

    # 得到 上次酒席时间
    # 比较 此次酒席时间
    # 得到 当前体力值
    # 添加 体力值
    # 保存 已经领取状态
    # 返回 成功

    player = kwargs.get('player')
    last_eat_time = player.feast.last_eat_time
    eat_time = base_config.get(u'manual_give_time')
    new = time.time()
    # if new
    add_manual_num = base_config.get(u'manual_give_value')
    return 123
    # [[u'12:00', u'14:00'], [u'18:00', u'20:00']]


@have_player
def get_time(dynamicid, **kwargs):
    """
    获取上次吃大餐时间
    """
    player = kwargs.get('player')
    return player.feast.last_eat_time



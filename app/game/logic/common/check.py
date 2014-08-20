# -*- coding:utf-8 -*-
"""
created by server on 14-7-9下午4:19.
"""
import functools
from app.game.core.PlayersManager import PlayersManager


def have_player(func):
    """根据动态ID 判断玩家是否存在
    """
    def wrapper(dynamic_id, *args, **kwargs):
        player = PlayersManager().get_player_by_dynamic_id(dynamic_id)
        # player = PlayersManager().get_player_by_dynamic_id(1)
        if not player or not player.check_dynamic_id:
            return {'result': False, 'result_no': 1, 'message': u''}
        ret = func(dynamic_id, *args, player=player)
        return ret
    return wrapper

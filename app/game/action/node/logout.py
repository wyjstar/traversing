# -*- coding:utf-8 -*-
"""
created by server on 14-7-8下午3:54.
"""
from app.game.core.PlayersManager import PlayersManager
from app.game.service.gatenoteservice import remote_service_handle


@remote_service_handle
def net_conn_lost_602(dynamic_id):
    """logout
    """
    player = PlayersManager().get_player_by_dynamic_id(dynamic_id)

    if not player:
        return True

    player.online_gift.offline_player()

    # TODO 是否需要保存数据
    PlayersManager().drop_player(player)
    return True

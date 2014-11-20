# -*- coding:utf-8 -*-
"""
created by server on 14-7-8下午3:54.
"""
from app.game.core.PlayersManager import PlayersManager
from gfirefly.server.globalobject import remoteserviceHandle


@remoteserviceHandle('gate')
def net_conn_lost_remote(player):
    """logout
    """
    player.online_gift.offline_player()

    # TODO 是否需要保存数据
    PlayersManager().drop_player(player)
    return True

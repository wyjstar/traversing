# -*- coding:utf-8 -*-
"""
created by sphinx on
"""

from gtwisted.core import reactor
from gfirefly.dbentrust import util
from app.transit.root.messagecache import message_cache
from gfirefly.server.globalobject import GlobalObject


groot = GlobalObject().root


tick_peroid = 6*60
PVP_TABLE_NAME = 'tb_pvp_rank'


def pvp_award_tick():
    reactor.callLater(tick_peroid, pvp_award_tick)

    records = util.GetSomeRecordInfo(PVP_TABLE_NAME, 'character_id>1000', ['character_id'])

    for k in records:
        childs = groot.childsmanager.childs
        for child in childs.values():
            if 'gate' in child.name:
                result = child.pull_message_remote('pvp_award_remote', k['character_id'], (2,))
                if type(result) is bool and result:
                    break
                else:
                    print 'pvp_award_tick result:', result
        else:
            message_cache.cache('pvp_award_remote', k['character_id'], 2)

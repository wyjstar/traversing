#coding:utf8
"""
Created on 2013-8-14
@author: lan (www.9miao.com)
"""
from gfirefly.dbentrust.dbpool import dbpool
from shared.utils.ranking import Ranking


def load_module():
    from action.root import netforwarding
    from action.local import login
    from action.local import login_server

    from action.local.chat import login
    from action.local.chat import chat
    from action.local import heart_beat

def init_guild_rank():
    fifo_configs = {
        'label': 'Fifo',
        'redis_server': '127.0.0.1',
        'redis_port': 6379,
        'redis_db': 0,
        'rank_len': 20,
        'eval_rank_func': 'testcase1_eval',
    }

    level_configs = {
        'label': 'Level',
        'redis_server': '127.0.0.1',
        'redis_port': 6379,
        'redis_db': 0,
        'rank_len': 20,
        'eval_rank_func': 'testcase1_eval2',
    }

    Ranking.init(fifo_configs)
    Ranking.init(level_configs)
    print 'guild rank init ok'

#coding:utf8
"""
Created on 2013-8-14
@author: lan (www.9miao.com)
"""
from gfirefly.dbentrust.dbpool import dbpool
from gfirefly.server.globalobject import GlobalObject
from shared.utils.ranking import Ranking


def load_module():
    from action.root import netforwarding
    from action.local import login
    from action.local import login_server

    from action.local.chat import login
    from action.local.chat import chat
#     from action.local import heart_beat


def init_guild_rank():
    try:
        level_configs = GlobalObject().json_config.get('Ranking_configs')
    except Exception:
        import traceback
        string = "\n" + traceback.format_exc()
        string += """\n
        Error:Couldn't import the json config 'config.json' in the directory containing %(file)r.
        """ % {'file': __file__}

    Ranking.init(level_configs)
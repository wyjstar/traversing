# coding:utf8
"""
"""
from gfirefly.server.globalobject import GlobalObject


def push_object(topic_id, msg, send_list):
    """ send msg to client in send_list
        send_list:
    """
    if 'gate' in GlobalObject().remote.keys():
        GlobalObject().remote['gate'].callRemote("push_object", topic_id, msg, send_list)


def get_guild_rank_from_gate():
    if 'gate' in GlobalObject().remote.keys():
        res = GlobalObject().remote['gate'].callRemoteForResult("get_guild_rank")
        return res


def add_guild_to_rank(g_id):
    if 'gate' in GlobalObject().remote.keys():
        GlobalObject().remote['gate'].callRemote("add_guild_to_rank", g_id)


def push_message(topic_id, character_id, *args, **kw):
    if 'gate' in GlobalObject().remote:
        print 'game call push message'
        GlobalObject().remote['gate'].callRemote("push_message", topic_id, character_id, args, kw)


def pull_message(character_id, *args, **kw):
    if 'gate' in GlobalObject().remote:
        print 'game call pull message'
        GlobalObject().remote['gate'].callRemote("pull_message", character_id, args, kw)

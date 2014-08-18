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


def send_mail(mail):
    """send mail through gate"""
    if 'gate' in GlobalObject().remote.keys():
        GlobalObject().remote['gate'].callRemote("send_mail", mail)


def get_guild_rank_from_gate():
    if 'gate' in GlobalObject().remote.keys():
        res = GlobalObject().remote['gate'].callRemoteForResult("get_guild_rank")
        print 'cuick,aaaaaaaaaaaaaaa,get_guild_rank_from_gate,aaaaaaa,res:', res
        return res


def add_guild_to_rank(g_id):
    if 'gate' in GlobalObject().remote.keys():
        print 'cuick,gid,test,bbbbbbbbbbbbbbbbbbbbbbbbbbgid:', g_id
        GlobalObject().remote['gate'].callRemote("add_guild_to_rank", g_id)

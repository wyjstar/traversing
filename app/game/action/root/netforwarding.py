# coding:utf8
from gfirefly.server.globalobject import GlobalObject
from app.game.core.PlayersManager import PlayersManager


def get_gate_remote():
    remote_gate = None
    if 'gate' in GlobalObject().remote:
        remote_gate = GlobalObject().remote['gate']
    return remote_gate


def push_object(topic_id, msg, send_list):
    """ send msg to client in send_list
        send_list:
    """
    if get_gate_remote():
        get_gate_remote().callRemote("push_object", topic_id, msg, send_list)


def send_mail(mail):
    """send mail through gate"""
    if get_gate_remote():
        get_gate_remote().callRemote("send_mail", mail)


def get_guild_rank_from_gate():
    if get_gate_remote():
        res = get_gate_remote().callRemoteForResult("get_guild_rank")
        return res


def add_guild_to_rank(g_id, dengji):
    if get_gate_remote():
        get_gate_remote().callRemote("add_guild_to_rank", g_id, dengji)


def login_chat(dynamic_id, character_id, guild_id, nickname):
    if get_gate_remote():
        get_gate_remote().callRemote("login_chat", dynamic_id, character_id, guild_id, nickname)


def push_message(topic_id, character_id, *args, **kw):
    if get_gate_remote():
        player = PlayersManager().get_player_by_id(character_id)
        if player:
            pargs = (player.dynamic_id, True) + args
            get_gate_remote()._reference.callTarget(*pargs, **kw)
        print 'game call push message'
        get_gate_remote().callRemote("push_message",
                                     topic_id,
                                     character_id,
                                     args,
                                     kw)

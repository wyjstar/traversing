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
        get_gate_remote().callRemote("push_object",
                                     topic_id,
                                     str(msg),
                                     send_list)


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
        get_gate_remote().callRemote("login_chat",
                                     dynamic_id,
                                     character_id,
                                     guild_id, nickname)


def login_guild_chat(dynamic_id, guild_id):
    if get_gate_remote():
        get_gate_remote().callRemote("login_guild_chat", dynamic_id, guild_id)


def logout_guild_chat(dynamic_id):
    if get_gate_remote():
        get_gate_remote().callRemote("logout_guild_chat", dynamic_id)


def del_guild_room(guild_id):
    if get_gate_remote():
        get_gate_remote().callRemote("del_guild_room", guild_id)


def push_message(key, character_id, *args, **kw):
    if get_gate_remote():
        player = PlayersManager().get_player_by_id(character_id)
        if player:
            pargs = (key, player.dynamic_id) + args
            kw['is_online'] = True
            return get_gate_remote()._reference._service.callTarget(*pargs,
                                                                    **kw)
        else:
            return get_gate_remote().callRemote("push_message",
                                                key,
                                                character_id,
                                                args,
                                                kw)

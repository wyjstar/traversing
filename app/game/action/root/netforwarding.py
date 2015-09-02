# coding:utf8
from gfirefly.server.globalobject import GlobalObject
from app.game.core.PlayersManager import PlayersManager


remote_gate = GlobalObject().remote.get('gate')
MAINTAIN_TIME_DEFAULT = 60*60*24*60


# def send_mail(mail):
#     """send mail through gate"""
#     if get_gate_remote():
#         get_gate_remote().callRemote("send_mail", mail)


def push_message(key, character_id, *args):
    player = PlayersManager().get_player_by_id(character_id)
    if player:
        kw = {}
        pargs = (key, player.dynamic_id) + args
        kw['is_online'] = True
        return remote_gate._reference._service.callTarget(*pargs, **kw)
    else:
        return remote_gate.push_message_remote(key, character_id, args)


def push_message_maintime(key, character_id,
                          maintain_time=MAINTAIN_TIME_DEFAULT, *args):
    player = PlayersManager().get_player_by_id(character_id)
    if player:
        kw = {}
        pargs = (key, player.dynamic_id) + args
        kw['is_online'] = True
        return remote_gate._reference._service.callTarget(*pargs, **kw)
    else:
        return remote_gate.push_message_maintime_remote(key, character_id,
                                                        maintain_time, args)


def get_activity_id():
    return remote_gate.get_act_id_from_world_remote()

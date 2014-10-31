# coding:utf8
from gfirefly.server.globalobject import GlobalObject


def get_gate_remote():
    remote_gate = None
    if 'gate' in GlobalObject().remote:
        remote_gate = GlobalObject().remote['gate']
    return remote_gate


def push_object(msg):
    if get_gate_remote():
        print 'bbbbbbbbbbbbbbbb', msg
        get_gate_remote().callRemote("from_admin", msg)


def get_guild_rank_from_gate():
    if get_gate_remote():
        res = get_gate_remote().callRemoteForResult("get_guild_rank")
        return res


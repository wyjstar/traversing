# coding:utf8
from gfirefly.server.globalobject import GlobalObject


def get_gate_remote():
    remote_gate = None
    if 'gate' in GlobalObject().remote:
        remote_gate = GlobalObject().remote['gate']
    return remote_gate


def push_object(msg):
    if get_gate_remote():
        get_gate_remote().callRemote("from_admin", msg)


def rpc_object(args):
    if get_gate_remote():
        res = get_gate_remote().callRemoteForResult("from_admin_rpc", args)
        return res


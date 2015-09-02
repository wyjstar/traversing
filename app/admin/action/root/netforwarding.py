# coding:utf8
from gfirefly.server.globalobject import GlobalObject


remote_gate = GlobalObject().remote['gate']


def push_message(key, character_id, *args):
    return remote_gate.push_message_remote(key, character_id, args)

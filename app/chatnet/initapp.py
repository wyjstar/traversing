#-*- coding:utf-8 -*-
"""
created by server on 14-5-17下午4:04.
"""
from gfirefly.server.globalobject import GlobalObject
from gfirefly.netconnect.datapack import DataPackProtoc


def conn_lost(conn):
    dynamic_id = conn.transport.sessionno
    GlobalObject().remote['chatgate'].callRemoteNotForResult("netconnlost", dynamic_id)


def conn_made(conn):
    GlobalObject().netfactory.pushObject(10001, "Distributed Login Test", [conn.transport.sessionno])


GlobalObject().netfactory.doConnectionLost = conn_lost
# GlobalObject().netfactory.doConnectionMade = conn_made
dataprotocl = DataPackProtoc(0, 0, 0, 0, 0, 0)
GlobalObject().netfactory.setDataProtocl(dataprotocl)


def load_module():
    import chatnetapp
    import chatgatenodeapp
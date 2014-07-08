#coding:utf8
"""
Created on 2013-8-14

@author: lan (www.9miao.com)
"""
from gfirefly.server.globalobject import GlobalObject
from gfirefly.netconnect.datapack import DataPackProtoc


def conn_lost(conn):
    dynamic_id = conn.transport.sessionno
    GlobalObject().remote['gate'].callRemoteNotForResult("net_conn_lost", dynamic_id)


GlobalObject().netfactory.doConnectionLost = conn_lost
dataprotocl = DataPackProtoc(0, 0, 0, 0, 0, 0)
GlobalObject().netfactory.setDataProtocl(dataprotocl)


def load_module():
    import netapp
    import gatenodeapp
#coding:utf8
"""
Created on 2013-8-13

@author: lan (www.9miao.com)
"""
from gate import initapp
from gtwisted.core import reactor
from gfirefly.server.globalobject import GlobalObject

initapp.load_module()
initapp.init_guild_rank()

front_ip = GlobalObject().json_config['front_ip']
front_port = GlobalObject().json_config['front_port']
name = GlobalObject().json_config['name']


def tick():
    GlobalObject().remote['login'].callRemote('server_sync',
                                              name, front_ip,
                                              front_port,
                                              'normal')

    reactor.callLater(60, tick)

reactor.callLater(3, tick)

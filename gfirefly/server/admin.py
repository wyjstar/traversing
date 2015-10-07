# coding:utf8
'''
Created on 2014-2-24

@author: lan (www.9miao.com)
'''
from gfirefly.server.globalobject import GlobalObject, masterserviceHandle
from gtwisted.core import reactor
from gfirefly.server.logobj import logger


reactor = reactor


@masterserviceHandle
def serverStop():
    """供master调用的接口：关闭服务器
    """
    logger.info('stop')
    if GlobalObject().stophandler:
        GlobalObject().stophandler()
    reactor.callLater(0.5, reactor.stop)
    return True


@masterserviceHandle
def sreload():
    """供master调用的接口：热更新模块
    """
    logger.info('reload')
    from shared.db_opear.configs_data import game_configs
    logger.debug("1==base_config.resource_for_InitUser %s" % game_configs.base_config.get("resource_for_InitUser"))
    if GlobalObject().reloadmodule:
        reload(GlobalObject().reloadmodule)
        from shared.utils.lua_runtime import lua
        reload_lua_func = lua.eval('''function() reload_lua_config(); end''')
        reload_lua_func()
    logger.debug("2==base_config.resource_for_InitUser %s" % game_configs.base_config.get("resource_for_InitUser"))


    return True


@masterserviceHandle
def remote_connect(rname, rhost):
    """供master调用的接口：进行远程的rpc连接
    """
    GlobalObject().remote_connect(rname, rhost)

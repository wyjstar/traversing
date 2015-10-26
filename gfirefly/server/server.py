# coding:utf8
"""
Created on 2013-8-2

@author: lan (www.9miao.com)
"""
import os
import affinity
from flask import Flask
from gfirefly.netconnect.protoc import LiberateFactory
from gfirefly.distributed.root import PBRoot, BilateralFactory
from gfirefly.distributed.node import RemoteObject
from gfirefly.dbentrust.dbpool import dbpool
from gfirefly.server.globalobject import GlobalObject
from gfirefly.server.logobj import log_init
from gfirefly.server.logobj import logger
from gtwisted.core import reactor
from gfirefly.utils import services
from gfirefly.dbentrust.redis_manager import redis_manager
from sdk.api.tencent.msdk import Msdk
from sdk.api.tencent.midas_api import MidasApi
from sdk.util import logger_sdk
import time

reactor = reactor


def serverStop():
    """停止服务进程"""
    logger.info('stop')
    if GlobalObject().stophandler:
        GlobalObject().stophandler()
    reactor.callLater(0.5, reactor.stop)
    return True


class FFServer:
    """抽象出的一个服务进程"""

    def __init__(self):
        """
        """
        self.netfactory = None  # net前端
        self.root = None  # 分布式root节点
        self.webroot = None  # http服务
        self.remote = {}  # remote节点
        self.master_remote = None
        self.db = None
        self.servername = None
        self.remoteportlist = []

    def config(self, config, servername=None, dbconfig=None,
               memconfig=None, redis_config=None, masterconf=None,
               model_default_config=None, model_config=None, msdk_config=None):
        """配置服务器"""
        GlobalObject().json_config = config
        GlobalObject().json_model_config = model_default_config
        GlobalObject().json_model_config = model_config
        netport = config.get('netport')  # 客户端连接
        webport = config.get('webport')  # http连接
        rootport = config.get('rootport')  # root节点配置
        self.remoteportlist = config.get('remoteport', [])  # remote节点配置列表
        if not servername:
            servername = config.get('name')  # 服务器名称
        logpath = config.get('log')  # 日志
        hasdb = config.get('db')  # 数据库连接
        # hasmem = config.get('mem')  # memcached连接
        hasredis = config.get('redis')  # redis连接
        app = config.get('app')  # 入口模块名称
        cpuid = config.get('cpu')  # 绑定cpu
        mreload = config.get('reload')  # 重新加载模块名称
        self.servername = servername
        #if servername == 'net':
            #time.sleep(6)
        #if servername == 'gate':
            #time.sleep(16)

        if logpath:
            log_init(logpath)  # 日志处理

        if netport:
            self.netfactory = LiberateFactory()
            netservice = services.CommandService("netservice")
            self.netfactory.addServiceChannel(netservice)
            reactor.listenTCP(netport, self.netfactory)

        if webport:
            self.webroot = Flask("master")
            GlobalObject().webroot = self.webroot
            self.webroot.debug = True
            # reactor.listenTCP(webport, self.webroot)
            reactor.listenWSGI(webport, self.webroot)

        if rootport:
            self.root = PBRoot()
            rootservice = services.Service("rootservice")
            self.root.addServiceChannel(rootservice)
            reactor.listenTCP(rootport, BilateralFactory(self.root))

        for cnf in self.remoteportlist:
            rname = cnf.get('rootname')
            self.remote[rname] = RemoteObject(self.servername)

        if hasdb and dbconfig:
            # logger.info(str(dbconfig))
            dbpool.initPool(**dbconfig)

        if hasredis and redis_config:
            connection_setting = redis_config.get('urls')
            redis_manager.connection_setup(connection_setting)

        if cpuid:
            affinity.set_process_affinity_mask(os.getpid(), cpuid)
        GlobalObject().config(netfactory=self.netfactory, root=self.root,
                              remote=self.remote)
        if app:
            __import__(app)
        if mreload:
            _path_list = mreload.split(".")
            GlobalObject().reloadmodule = __import__(mreload, fromlist=_path_list[:1])
        GlobalObject().remote_connect = self.remote_connect

        if masterconf:
            masterport = masterconf.get('rootport')
            masterhost = masterconf.get('roothost')
            self.master_remote = RemoteObject(servername)
            addr = ('localhost', masterport) if not masterhost else (masterhost, masterport)
            self.master_remote.connect(addr)
            GlobalObject().masterremote = self.master_remote

        if msdk_config:
            #zone_id = msdk_config.get("zone_id")
            host = msdk_config.get("host")
            #pay_host = msdk_config.get("pay_host")
            goods_host = msdk_config.get("buy_goods_host")
            valid_host = msdk_config.get("valid_host")
            qq_appid = msdk_config.get("qq_appid")
            qq_appkey = msdk_config.get("qq_appkey")
            wx_appid = msdk_config.get("wx_appid")
            wx_appkey = msdk_config.get("wx_appkey")
            log = logger_sdk.new_log('TxApi')
            GlobalObject().msdk = Msdk(host, qq_appid, qq_appkey, wx_appid, wx_appkey, log=log)
            GlobalObject().pay = MidasApi(host, goods_host, valid_host, log=log)
        import admin

    def remote_connect(self, rname, rhost):
        """进行rpc的连接"""
        for cnf in self.remoteportlist:
            _rname = cnf.get('rootname')
            if rname == _rname:
                rport = cnf.get('rootport')
                local_host = cnf.get('roothost')
                if local_host:
                    rhost = local_host
                if not rhost:
                    addr = ('localhost', rport)
                else:
                    addr = (rhost, rport)
                self.remote[rname].connect(addr)
                break

    def start(self):
        """启动服务器"""
        logger.info('%s start...', self.servername)
        logger.info('%s pid: %s' % (self.servername, os.getpid()))
        reactor.run()

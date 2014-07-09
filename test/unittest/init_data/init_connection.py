# -*- coding:utf-8 -*-
"""
created by server on 14-7-9上午11:23.

init db connection and redis connection
"""
from gfirefly.dbentrust.dbpool import dbpool
import json
from gfirefly.server.globalobject import GlobalObject
from test.unittest.settings import config_json_path
from shared.db_entrust.redis_client import RedisManager, redis_manager


def init():
    hostname = "127.0.0.1"  #  要连接的数据库主机名
    user = "test"  #  要连接的数据库用户名
    password = "test"  #  要连接的数据库密码
    port = 8066  #  3306 是MySQL服务使用的TCP端口号，一般默认是3306
    dbname = "db_traversing"  #  要使用的数据库库名
    charset = "utf8"  #  要使用的数据库的编码
    dbpool.initPool(host=hostname, user=user, passwd=password, port=port, db=dbname,
                    charset=charset)  ##firefly重新封装的连接数据库的方法，这一步就是初始化数据库连接池，这样你就可连接到你要使用的数据库了
init()  # init pool


config = json.load(open(config_json_path, 'r'))
GlobalObject().json_model_config = config.get("models")
redis_manager.connection_setup(config.get("memcached").get("urls"))
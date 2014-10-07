#-*- coding:utf-8 -*-
"""
created by server on 14-5-27下午1:51.
"""
import cPickle
from gfirefly.dbentrust.dbpool import dbpool
from gfirefly.dbentrust.madminanager import MAdminManager
from shared.db_entrust.redis_client import redis_manager
from shared.db_entrust.redis_mode import MAdmin
from shared.db_entrust.redis_object import RedisObject
from test.redis_my_test import tower_info  # @UnresolvedImport


class Account(RedisObject):

    def __init__(self, name, mc):
        pass


if __name__ == '__main__':
    hostname = "127.0.0.1"  #  要连接的数据库主机名
    user = "test"  #  要连接的数据库用户名
    password = "test"  #  要连接的数据库密码
    port = 8066  #  3306 是MySQL服务使用的TCP端口号，一般默认是3306
    dbname = "db_traversing"  #  要使用的数据库库名
    charset = "utf8"  #  要使用的数据库的编码
    dbpool.initPool(host=hostname, user=user, passwd=password, port=port, db=dbname,
                    charset=charset)  ##firefly重新封装的连接数据库的方法，这一步就是初始化数据库连接池，这样你就可连接到你要使用的数据库了

    connection_setting = ["127.0.0.1:6379"]

    redis_manager.connection_setup(connection_setting)

    # tower_info = MAdmin("tb_account_mapping", "account_token")
    # print '#1:', tower_info.__dict__
    # tower_info.insert()
    # # tower_info.load()
    # MAdminManager().registe(tower_info)


    data = {'id': 1029, 'account_token': 'e8054ceece61204cbef4b01d59d355e9'}
    n = tower_info.new(data)
    print 'n:',n.__dict__
    n.insert()
    m = tower_info.getObj('e8054ceece61204cbef4b01d59d355e8')
    data = m.get("data")
    print 'data:', cPickle.loads(data)

    # MAdminManager().checkAdmins()


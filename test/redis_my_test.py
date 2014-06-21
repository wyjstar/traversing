#-*- coding:utf-8 -*-
"""
created by wzp on 14-5-27下午1:51.
"""
import cPickle
from gfirefly.dbentrust.dbpool import dbpool
from gfirefly.dbentrust.madminanager import MAdminManager
from shared.db_entrust.redis_client import redis_manager
from shared.db_entrust.redis_mode import MAdmin
from shared.db_entrust.redis_object import RedisObject


class Account(RedisObject):

    def __init__(self, name, mc):
        pass


if __name__ == '__main__':


    hostname = "127.0.0.1"  #  要连接的数据库主机名
    user = "root"  #  要连接的数据库用户名
    password = "123456"  #  要连接的数据库密码
    port = 3306  #  3306 是MySQL服务使用的TCP端口号，一般默认是3306
    dbname = "test"  #  要使用的数据库库名
    charset = "utf8"  #  要使用的数据库的编码
    dbpool.initPool(host=hostname, user=user, passwd=password, port=port, db=dbname,
                    charset=charset)  ##firefly重新封装的连接数据库的方法，这一步就是初始化数据库连接池，这样你就可连接到你要使用的数据库了

    connection_setting = ["127.0.0.1:6379"]

    redis_manager.connection_setup(connection_setting)

    tower_info = MAdmin("tb_character", "id")
    #print '#1:', tower_info.__dict__
    tower_info.insert()
    # MAdminManager().registe(tower_info)

    tower_info.checkAll()
    mm = tower_info.getObj(123)

    print mm.get('nickname')

    data = {'id': 11111, 'nickname': 'zhizouxiao'}
    n = tower_info.new(data)
    print 'n:',n.__dict__
    n.insert()
    m = tower_info.getObj('11111')
    data = m.get("data")
    print data
    print 'data:', cPickle.loads(data)

    # MAdminManager().checkAdmins()


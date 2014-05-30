#-*- coding:utf-8 -*-
"""
created by server on 14-5-27下午1:51.
"""
from gfirefly.dbentrust.dbpool import dbpool
from gfirefly.dbentrust.madminanager import MAdminManager
from shared.db_entrust.redis_client import redis_manager
from shared.db_entrust.redis_mode import MAdmin
from shared.db_entrust.redis_object import RedisObject

if __name__ == '__main__':
    hostname = "localhost"  #  要连接的数据库主机名
    user = "root"  #  要连接的数据库用户名
    password = "123456"  #  要连接的数据库密码
    port = 3306  #  3306 是MySQL服务使用的TCP端口号，一般默认是3306
    dbname = "anheisg"  #  要使用的数据库库名
    charset = "utf8"  #  要使用的数据库的编码
    dbpool.initPool(host=hostname, user=user, passwd=password, port=port, db=dbname,
                    charset=charset)  ##firefly重新封装的连接数据库的方法，这一步就是初始化数据库连接池，这样你就可连接到你要使用的数据库了

    connection_setting = ["127.0.0.1:6379"]

    redis_manager.connection_setup(connection_setting)

    tower_info = MAdmin("tb_tower_info", "id")
    tower_info.insert()
    tower_info.load()

    MAdminManager().registe(tower_info)

    # print tower_info.madmininfo

    # m = tower_info.getObj(1)
    #
    # data = m.get("data")

    data = {'name': u'haha', 'monsterdesc': u'1213', 'level': 30L, 'expbound': 10000L, 'dropoutid': 4001L,
            'matrixid': 100001L, 'rule': u'[[4001,4001,4001,4001,4001],[1,3,5,7,9]]', 'boundinfo': u'sdfsadfas',
            'id': 2}

    n = tower_info.new(data)
    n.insert()

    m = tower_info.getObj(2)
    data = m.get("data")
    print m._time
    print data

    MAdminManager().checkAdmins()


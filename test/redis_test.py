#-*- coding:utf-8 -*-
"""
created by server on 14-5-27下午1:51.
"""
import cPickle
from gfirefly.dbentrust.redis_manager import redis_manager
from gfirefly.dbentrust.redis_mode import RedisObject



if __name__ == '__main__':
    hostname = "127.0.0.1"  #  要连接的数据库主机名
    port = 8066  #  3306 是MySQL服务使用的TCP端口号，一般默认是3306
    dbname = "db_traversing"  #  要使用的数据库库名
    charset = "utf8"  #  要使用的数据库的编码
    connection_setting = ["127.0.0.1:6379"]

    redis_manager.connection_setup(connection_setting)
    tb_base_info_db = RedisObject("tb_base_info")
    tb_base_info_db.set(1, dict(chater=1000, msg="hehe"))
    tb_base_info_db.rpush(2, dict(chater=1000, msg="hehe"))
    tb_base_info_db.rpush(2, dict(chater=1001, msg="hehe"))
    tb_base_info_db.rpush(2, dict(chater=1002, msg="hehe"))
    tb_base_info_db.lpop(2)
    tb_base_info_db.lrange(2, 0, -1)

    # tower_info = MAdmin("tb_account_mapping", "account_token")
    # print '#1:', tower_info.__dict__
    # tower_info.insert()
    # # tower_info.load()
    # MAdminManager().registe(tower_info)
    # MAdminManager().checkAdmins()


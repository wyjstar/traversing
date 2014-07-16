# -*- coding:utf-8 -*-
"""
created by server on 14-7-2下午8:00.
"""

from app.game.core.hero import Hero

from gfirefly.dbentrust.madminanager import MAdminManager
from shared.db_entrust import redis_mode
from shared.db_entrust.redis_client import RedisClient
from gfirefly.dbentrust.dbpool import dbpool
from shared.db_entrust.redis_client import RedisManager, redis_manager
from gfirefly.server.globalobject import GlobalObject
import json
import unittest


class HeroTest(unittest.TestCase):

    def setUp(self):
        config = json.load(open('../config.json', 'r'))

        def init():
            hostname = "127.0.0.1"  #  要连接的数据库主机名
            user = "root"  #  要连接的数据库用户名
            password = "root"  #  要连接的数据库密码
            port = 3306  #  3306 是MySQL服务使用的TCP端口号，一般默认是3306
            dbname = "traversing_1"  #  要使用的数据库库名
            charset = "utf8"  #  要使用的数据库的编码
            dbpool.initPool(host=hostname, user=user, passwd=password, port=port, db=dbname,
                            charset=charset)  ##firefly重新封装的连接数据库的方法，这一步就是初始化数据库连接池，这样你就可连接到你要使用的数据库了


        init()
        client = RedisClient()

        mmanager = MAdminManager()

        GlobalObject().json_model_config = config.get("models")
        redis_manager.connection_setup(config.get("memcached").get("urls"))

        m1 = redis_mode.MAdmin('tb_character_hero', 'id')

        m1.insert()

        data = {'hero_no': 10001,
                'character_id': 106, 'level': 9,
                'break_level': 10, 'exp': 11,
                'equipment_ids': ''}
        self.hero_mmode = m1.new(data)

        self.hero = Hero(1)
        self.hero.level = 12306

    def test_level(self):
        self.assertEqual(self.hero.level, 12306, 'level error!')
        self.assertEqual(self.hero_mmode.get('data').get('level'), 12306, 'mmode level error')

    def test_get_all_exp(self):
        # todo:
        pass

if __name__ == '__main__':
    unittest.main()


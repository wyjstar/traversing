# -*- coding:utf-8 -*-
"""
created by server on 14-8-20下午5:58.
"""
print "init connection"
import test.unittest.init_data.init_connection
import app.game.redis_mode
from gfirefly.dbentrust.dbpool import dbpool

dbpool.closePool()

def setUpModule():
    dbpool.closePool()

def tearDownModule():
    print "closePool....."
    dbpool.closePool()



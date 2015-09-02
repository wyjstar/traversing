#-*- coding:utf-8 -*-
"""
created by server on 14-5-24下午3:30.
"""

#coding:utf8

###########firefly、MySQL和Memcached共同使用###########
from flask import json

from gfirefly.dbentrust.dbpool import dbpool
from gfirefly.dbentrust.madminanager import MAdminManager
from gfirefly.dbentrust.memclient import mclient
from gfirefly.dbentrust.mmode import MAdmin
from gfirefly.server.globalobject import GlobalObject

hostname = "127.0.0.1"  #  要连接的数据库主机名
user = "test"  #  要连接的数据库用户名
password = "test"  #  要连接的数据库密码
port = 8066  #  3306 是MySQL服务使用的TCP端口号，一般默认是3306
dbname = "db_traversing"  #  要使用的数据库库名
charset = "utf8"  #  要使用的数据库的编码
dbpool.initPool(host=hostname, user=user, passwd=password, port=port, db=dbname, charset=charset)  ##firefly重新封装的连接数据库的方法，这一步就是初始化数据库连接池，这样你就可连接到你要使用的数据库了


def old_test():
    address = ["127.0.0.1:11211"]  #要连接的Memcached的主机地址端口号
    hostname = "localhost"  #要连接的Memcached的主机名
    mclient.connect(address, hostname)  #firefly重新封装的连接Memcached的方法，这样你就可连接到你要使用的Memcached

    tower_info = MAdmin("tb_tower_info", "id")  #实例化一个MAdmin管理器，用来管理player表中的数据，player是你要管理的表名，id是该表的主键
    #不清楚MAdmin是什么的童鞋请移步http://firefly.9miao.com/wiki/index.htm，wiki里面有个dbentrust使用文档，里面详细说明了firefly自定义的几个类与数据库之间的关联
    tower_info.insert()  #将管理器player注册到memcached中

    tower_info.load()  #一次性从数据库中将player表中所有数据读取到memcached中，如果不写本句，player只是一个空模型，没有数据，第一次取值时会到数据库中取出此次需要的数据并加载到memcached中，
    #如果第二次取值同第一次相同，则在memcached中取，否则需要再次同数据库建立连接进行取值

    m = tower_info.getObj(1)  #取出player表中主键（本例为id）为100001的这条数据对象（Mmode）
    data = m.get("data")  #获取数据对象m里面包含的信息
    print data  #打印信息

    data = {'name': u'haha', 'monsterdesc': u'1213', 'level': 30L, 'expbound': 10000L, 'dropoutid': 4001L, 'matrixid': 100001L, 'rule': u'[[4001,4001,4001,4001,4001],[1,3,5,7,9]]', 'boundinfo': u'sdfsadfas', 'id': 2}

    n = tower_info.new(data)
    n.insert()


    m = tower_info.getObj(2)
    data = m.get("data")
    print data

    MAdminManager().registe(tower_info)
    MAdminManager().checkAdmins()



mconfig = json.load(open('../models.json', 'r'))
model_config = mconfig.get('models', {})
GlobalObject().json_model_config = model_config
GlobalObject().json_model_default_config = {}



address = ["127.0.0.1:11211"]  #要连接的Memcached的主机地址端口号
hostname = "mem"  #要连接的Memcached的主机名
mclient.connect(address, hostname)  #firefly重新封装的连接Memcached的方法，这样你就可连接到你要使用的Memcached


# 用户信息表
tb_character_info = MAdmin('tb_character_info', 'id')
tb_character_info.insert()

# 英雄信息表
tb_character_hero = MAdmin('tb_character_hero', 'id', 1800, fk='character_id')
tb_character_hero.insert()

character = tb_character_info.getObj(1037)
print character

print tb_character_hero.getObj('1037_10001')
tb_character_hero.loadByFK(1037)
print tb_character_hero.getObj('1037_10002')



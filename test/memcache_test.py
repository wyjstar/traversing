#-*- coding:utf-8 -*-
"""
created by server on 14-5-24下午3:30.
"""

#coding:utf8

###########firefly、MySQL和Memcached共同使用###########

from gfirefly.dbentrust.dbpool import dbpool
from gfirefly.dbentrust.madminanager import MAdminManager
from gfirefly.dbentrust.memclient import mclient
from gfirefly.dbentrust.mmode import MAdmin


hostname = "localhost"  #  要连接的数据库主机名
user = "root"  #  要连接的数据库用户名
password = "123456"  #  要连接的数据库密码
port = 3306  #  3306 是MySQL服务使用的TCP端口号，一般默认是3306
dbname = "anheisg"  #  要使用的数据库库名
charset = "utf8"  #  要使用的数据库的编码
dbpool.initPool(host=hostname, user=user, passwd=password, port=port, db=dbname, charset=charset)  ##firefly重新封装的连接数据库的方法，这一步就是初始化数据库连接池，这样你就可连接到你要使用的数据库了

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
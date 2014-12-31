# coding:utf8
"""
Created on 2013-5-8

@author: lan (www.9miao.com)
"""
import gevent
import pymysql


def get_connection(func):
    def wrapper(*args, **kwargs):
        con = dbpool.get_connection()
        ret = func(*args, conn=con)
        dbpool.recollect_connection(con)
        return ret
    return wrapper


class DBPool(object):
    def __init__(self):
        self.config = {}
        self.idle_connections = []
        self.max_conection_num = 16

    def initPool(self, **kw):
        """根据连接配置初始化连接池配置信息.
        >>> aa = {'host':"localhost",'user':'root','passwd':'111',
                'db':'test','port':3306,'charset':'utf8'}
        >>> dbpool.initPool(**aa)
        """
        self.config = kw
        self.config['use_unicode'] = True
        self.config['charset'] = 'utf8'
        for i in range(self.max_conection_num):
            con = pymysql.Connect(**self.config)
            self.idle_connections.append(con)

    def get_connection(self):
        while len(self.idle_connections) <= 0:
            gevent.sleep(1)
        con = self.idle_connections.pop()
        try:
            con.ping()
        except:
            con = pymysql.Connect(**self.config)

        return con

    def recollect_connection(self, connection):
        connection.commit()
        self.idle_connections.append(connection)

    def closePool(self):
        for con in self.idle_connections:
            if con.socket:
                con.close()


# 数据库连接池对象
dbpool = DBPool()

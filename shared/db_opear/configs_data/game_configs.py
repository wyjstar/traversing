# -*- coding:utf-8 -*-
"""
created by server on 14-6-6上午11:05.
"""
from MySQLdb.cursors import DictCursor
import cPickle
from gfirefly.dbentrust.dbpool import dbpool
from shared.db_opear.configs_data.item_config import ItemsConfig


print id(dbpool)
from shared.db_opear.configs_data.hero_config import HeroConfig
from shared.db_opear.configs_data.hero_exp_config import HeroExpConfig
from shared.db_opear.configs_data.base_config import BaseConfig


def get_config_value(config_key):
    """获取所有翻译信息
    """
    sql = "SELECT * FROM configs where config_key='%s';" % config_key
    print 'sql:', sql
    conn = dbpool.connection()
    cursor = conn.cursor(cursorclass=DictCursor)
    cursor.execute(sql)
    result = cursor.fetchall()
    cursor.close()
    conn.close()
    if not result:
        return None
    data = {}
    for item in result:
        data[item['config_key']] = cPickle.loads(item['config_value'])
        print "data type", type(data)
    return data



base = {}
hero = {}
hero_exp = {}
item = {}



all_config_name = {
    'hero': HeroConfig(),
    'hero_exp': HeroExpConfig(),
     'item': ItemsConfig,
    #'bases_config': None,

}


class ConfigFactory(object):

    @classmethod
    def creat_config(cls, config_name, config_value):

        obj = None

        if config_name in all_config_name.keys():
            if config_name == 'bases_config':
                obj = all_config_name[config_name](dict((k, cls.type_value(v['config_type'], v['config_value'])) for k, v in config_value.items()))
                return obj

        return all_config_name[config_name].parser(config_value)

for config_name in all_config_name.keys():
        game_conf = get_config_value(config_name)

        print game_conf

        if not game_conf:
            continue
        objs = ConfigFactory.creat_config(config_name, game_conf[config_name])
        exec(config_name + '=objs')

        print hero
        print hero_exp

# def init():
#     hostname = "127.0.0.1"  #  要连接的数据库主机名
#     user = "test"  #  要连接的数据库用户名
#     password = "test"  #  要连接的数据库密码
#     port = 8066  #  3306 是MySQL服务使用的TCP端口号，一般默认是3306
#     dbname = "db_traversing"  #  要使用的数据库库名
#     charset = "utf8"  #  要使用的数据库的编码
#     dbpool.initPool(host=hostname, user=user, passwd=password, port=port, db=dbname,
#                     charset=charset)  ##firefly重新封装的连接数据库的方法，这一步就是初始化数据库连接池，这样你就可连接到你要使用的数据库了


if __name__ == '__main__':
    # init()
    pass







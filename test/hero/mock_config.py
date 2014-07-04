# -*- coding:utf-8 -*-
from gfirefly.dbentrust.dbpool import dbpool


def init():
    hostname = "127.0.0.1"  #  要连接的数据库主机名
    user = "test"  #  要连接的数据库用户名
    password = "test"  #  要连接的数据库密码
    port = 8066  #  3306 是MySQL服务使用的TCP端口号，一般默认是3306
    dbname = "db_traversing"  #  要使用的数据库库名
    charset = "utf8"  #  要使用的数据库的编码
    dbpool.initPool(host=hostname, user=user, passwd=password, port=port, db=dbname,
                    charset=charset)  ##firefly重新封装的连接数据库的方法，这一步就是初始化数据库连接池，这样你就可连接到你要使用的数据库了
init()  # init pool

from shared.db_opear.configs_data.game_configs import hero_config, hero_exp_config, base_config, item_config
from shared.db_opear.configs_data.common_item import CommonItem


#------------------------base----------------------------

base_config.clear()
base_config['exp_items'] = [1000101, 1000102, 1000103, 1000104]

#------------------------hero----------------------------

hero1 = {'id': 10001, 'name': 'hero10001', 'sacrifice_hero_soul': 100}
hero2 = {'id': 10002, 'name': 'hero10002', 'sacrifice_hero_soul': 200}
hero3 = {'id': 10003, 'name': 'hero10003', 'sacrifice_hero_soul': 300}

hero_config.clear()
hero_config[10001] = CommonItem(hero1)
hero_config[10002] = CommonItem(hero2)
hero_config[10003] = CommonItem(hero3)

#------------------------item----------------------------

item1 = {'id': 1000101, 'func_args': 100000}
item2 = {'id': 1000102, 'func_args': 50000}
item3 = {'id': 1000103, 'func_args': 10000}
item4 = {'id': 1000104, 'func_args': 5000}

item_config.clear()
item_config[1000101] = item1
item_config[1000102] = item2
item_config[1000103] = item3
item_config[1000104] = item4

#------------------------hero_exp----------------------------

hero_exp1 = {'level': 1, 'exp': 100}
hero_exp2 = {'level': 2, 'exp': 200}
hero_exp3 = {'level': 3, 'exp': 300}
hero_exp4 = {'level': 4, 'exp': 400}
hero_exp5 = {'level': 5, 'exp': 500}
hero_exp6 = {'level': 6, 'exp': 600}
hero_exp7 = {'level': 7, 'exp': 700}
hero_exp8 = {'level': 8, 'exp': 800}
hero_exp9 = {'level': 9, 'exp': 900}
hero_exp10 = {'level': 10, 'exp': 1000}
hero_exp11 = {'level': 11, 'exp': 1100}
hero_exp12 = {'level': 12, 'exp': 1200}
hero_exp13 = {'level': 13, 'exp': 1300}

hero_exp_config.clear()
hero_exp_config[1] = hero_exp1
hero_exp_config[2] = hero_exp2
hero_exp_config[3] = hero_exp3
hero_exp_config[4] = hero_exp4
hero_exp_config[5] = hero_exp5
hero_exp_config[6] = hero_exp6
hero_exp_config[7] = hero_exp7
hero_exp_config[8] = hero_exp8
hero_exp_config[9] = hero_exp9
hero_exp_config[10] = hero_exp10
hero_exp_config[11] = hero_exp11
hero_exp_config[12] = hero_exp12
hero_exp_config[13] = hero_exp13




# -*- coding:utf-8 -*-
"""
created by server on 14-6-6上午11:05.
"""
from MySQLdb.cursors import DictCursor
import cPickle
from gfirefly.dbentrust.dbpool import dbpool

print id(dbpool)
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
    return data


base_config = {}

all_config_name = {
    'hero':BaseConfig,
    # 'bases_config': BaseConfig,
}

for config_name in all_config_name.keys():
    game_conf = get_config_value(config_name)

    print game_conf

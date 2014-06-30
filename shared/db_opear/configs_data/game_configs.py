# -*- coding:utf-8 -*-
"""
created by server on 14-6-6上午11:05.
"""
from MySQLdb.cursors import DictCursor
import cPickle
from gfirefly.dbentrust.dbpool import dbpool

print id(dbpool)
from shared.db_opear.configs_data.base_config import BaseConfig
from shared.db_opear.configs_data.equipment_config import equipmentconfig

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
    'equipment': equipmentconfig,
}


class ConfigFactory(object):

    @classmethod
    def type_value(cls, stype, val):
        stype = stype.strip().lower()
        if stype == 'int':
            return int(val)
        elif stype == 'str':
            return str(val)
        elif stype == 'float':
            return float(val)
        elif stype == 'list':
            return eval(val)
        elif stype == 'dict':
            return eval(val)

    @classmethod
    def creat_config(cls, config_name, config_value):
        obj = None
        if config_name in all_config_name.keys():
             if config_name == 'bases_config':
                obj = all_config_name[config_name](dict((k, cls.type_value(v['config_type'], v['config_value'])) for k, v in config_value.items()))
                return obj
            #obj = all_config_name[config_name].parser(config_value)

        return config_value


for config_name in all_config_name.keys():
    game_conf = get_config_value(config_name)

    if not game_conf:
        continue

    objs = ConfigFactory.creat_config(config_name, game_conf)
    exec(config_name + '=objs')

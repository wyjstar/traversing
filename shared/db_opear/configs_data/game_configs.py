# -*- coding:utf-8 -*-
"""
created by server on 14-6-6上午11:05.
"""
from MySQLdb.cursors import DictCursor
from gfirefly.dbentrust.dbpool import dbpool


def get_all():
    """获取所有翻译信息
    """
    sql = "SELECT * FROM configs"
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
        data[item['config_key']] = item['config_value']
    return data
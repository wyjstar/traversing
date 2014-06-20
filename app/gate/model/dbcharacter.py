# -*- coding:utf-8 -*-
"""
created by server on 14-6-19下午5:07.
"""
from MySQLdb.cursors import DictCursor
from gfirefly.dbentrust.dbpool import dbpool


def get_character_by_userid(userid):
    """获取用户角色关系表所有信息
    @param userid: int 用户的id
    """
    return {'id': 'characterid'}
    sql = "select * from tb_character where id = %d" % userid
    conn = dbpool.connection()
    cursor = conn.cursor(cursorclass=DictCursor)
    cursor.execute(sql)
    result = cursor.fetchone()
    cursor.close()
    conn.close()
    return result
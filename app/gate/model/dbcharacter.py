# -*- coding:utf-8 -*-
"""
created by server on 14-6-19下午5:07.
"""
from MySQLdb.cursors import DictCursor
from gfirefly.dbentrust.dbpool import dbpool


def get_character_by_userid_area(userid, area):
    """获取用户角色关系表所有信息
    @param userid: int 用户的id
    """

    return {"id": 123}
    sql = "select * from tb_character where id = %d and area = '%s'" % (userid, area)
    conn = dbpool.connection()
    cursor = conn.cursor(cursorclass=DictCursor)
    cursor.execute(sql)
    result = cursor.fetchone()
    cursor.close()
    conn.close()
    return result
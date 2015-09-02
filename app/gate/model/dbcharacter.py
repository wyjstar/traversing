# -*- coding:utf-8 -*-
"""
created by server on 14-6-19下午5:07.
"""
import datetime
from gfirefly.dbentrust.dbpool import dbpool
from pymysql.cursors import DictCursor
from gfirefly.server.logobj import logger


def get_character_by_userid(userid):
    """获取用户角色关系表所有信息
    @param userid: int 用户的id
    """
    return False
    sql = "select * from tb_character where id = %d" % userid
    conn = dbpool.connection()
    cursor = conn.cursor(cursor=DictCursor)
    cursor.execute(sql)
    result = cursor.fetchone()
    cursor.close()
    conn.close()
    return result


def create_character(userid, nickname):
    """创建新的角色
    @param nickname: str 角色的昵称
    @param userid: int 角色ID
    """

    nowdatetime = str(datetime.datetime.today())
    sql = "insert into `tb_character`(id, nickName, createdate) \
    values('%d','%s','%s')" % (userid, nickname, nowdatetime)

    logger.info('sql', sql)
    conn = dbpool.connection()
    cursor = conn.cursor()
    count = cursor.execute(sql)
    conn.commit()

    cursor.close()
    conn.close()
    return 1
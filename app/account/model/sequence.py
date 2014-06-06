# -*- coding:utf-8 -*-
"""
created by server on 14-6-5下午9:17.
"""
from gfirefly.dbentrust.dbpool import dbpool


def get_id():
    """取得帐号唯一ID
    """
    sql1 = 'update account_sequence set id = last_insert_id(id+1)'
    conn = dbpool.connection()
    cursor = conn.cursor()
    try:
        cursor.execute(sql1)
        conn.commit()
        account_id = cursor.lastrowid
        return account_id
    finally:
        cursor.close()
        conn.close()

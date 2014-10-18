# -*- coding:utf-8 -*-
"""
created by server on 14-6-5下午12:05.
"""
from gfirefly.dbentrust.dbpool import dbpool



if __name__ == '__main__':
    hostname = "127.0.0.1"
    user = "test"
    password = "test"
    port = 8066
    dbname = "db_traversing"
    charset = "utf8"
    dbpool.initPool(host=hostname, user=user, passwd=password, port=port, db=dbname, charset=charset)


    sql1 = 'update account_sequence set id = last_insert_id(id+1)'
    conn = dbpool.connection()
    cursor = conn.cursor()
    cursor.execute(sql1)
    conn.commit()
    id = cursor.lastrowid
    cursor.close()
    conn.close()

    print id





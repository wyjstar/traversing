# coding:utf8
"""
Created on 2013-5-8

@author: lan (www.9miao.com)
"""
import MySQLdb

from dbpool import dbpool
from MySQLdb.cursors import DictCursor
from numbers import Number
from gfirefly.server.logobj import logger

import MySQLdb
escape_string = MySQLdb.escape_string


def force_str(text, encoding="utf-8", errors='strict'):
    t_type = type(text)
    if t_type == str:
        return text
    elif t_type == unicode:
        return text.encode(encoding, errors)
    return str(text)


def _smart(v):
    t = type(v)
    if t == str:
        return v
    elif t == unicode:
        return force_str(v)
    elif (t == int) or (t == long) or (t == float):
        return str(v)
    # elif t == datetime.datetime:
    #     return v.strftime("%Y-%m-%d %H:%M:%S")
    return str(v)


def _pairtext(k, v):
    if v is None:
        return "%s=null" % k
    return "%s=\"%s\"" % (k, escape_string(_smart(v)))


def _sqltext(data, delimiter=","):
    sql = delimiter.join([_pairtext(k[0], k[1]) for k in data.items()])
    return sql


def forEachPlusInsertProps(tablename, props):
    MySQLdb.escape_string
    assert type(props) == dict
    sqlstr = "INSERT INTO %s SET %s" % (tablename, _sqltext(props, ","))
    return sqlstr


def FormatCondition(props):
    """生成查询条件字符串
    """
    items = props.items()
    itemstrlist = []
    for _item in items:
        if isinstance(_item[1], Number):
            sqlstr = " %s=%s AND" % _item
        else:
            sqlstr = " %s='%s' AND" % (_item[0], escape_string(_smart(_item[1])))
        itemstrlist.append(sqlstr)
    sqlstr = ''.join(itemstrlist)
    return sqlstr[:-4]


def FormatUpdateStr(props):
    """生成更新语句
    """
    items = props.items()
    itemstrlist = []
    for _item in items:
        if isinstance(_item[1], Number):
            sqlstr = " `%s`=%s," % _item
        else:
            sqlstr = " `%s`='%s'," % (_item[0], escape_string(_smart(_item[1])))
        itemstrlist.append(sqlstr)
    sqlstr = ''.join(itemstrlist)
    return sqlstr[:-1]


def forEachUpdateProps(tablename, props, prere):
    """遍历所要修改的属性，以生成sql语句"""
    assert type(props) == dict
    pro = FormatUpdateStr(props)
    pre = FormatCondition(prere)
    sqlstr = """UPDATE %s SET %s WHERE %s;""" % (tablename, pro, pre)
    # print 'update:', sqlstr
    return sqlstr


def EachQueryProps(props):
    """遍历字段列表生成sql语句"""
    sqlstr = ""
    if props == '*':
        return '*'
    elif type(props) == type([0]):
        for prop in props:
            sqlstr = sqlstr + prop + ','
        sqlstr = sqlstr[:-1]
        return sqlstr
    else:
        raise Exception('props to query must be dict')
        return


def forEachQueryProps(sqlstr, props):
    """遍历所要查询属性，以生成sql语句"""
    if props == '*':
        sqlstr += ' *'
    elif type(props) == type([0]):
        i = 0
        for prop in props:
            if (i == 0):
                sqlstr += ' ' + prop
            else:
                sqlstr += ', ' + prop
            i += 1
    else:
        raise Exception('props to query must be list')
        return
    return sqlstr


def GetTableIncrValue(tablename):
    """
    """
    database = dbpool.config.get('db')
    sql = """SELECT AUTO_INCREMENT FROM information_schema.`TABLES` \
    WHERE TABLE_SCHEMA='%s' AND TABLE_NAME='%s';""" % (database, tablename)
    conn = dbpool.connection()
    cursor = conn.cursor()
    cursor.execute(sql)
    result = cursor.fetchone()
    cursor.close()
    conn.close()
    if result:
        return result[0]
    return result


def ReadDataFromDB(tablename):
    """
    """
    sql = """select * from %s""" % tablename
    conn = dbpool.connection()
    if dbpool._pymysql:
        from pymysql.cursors import DictCursor
        cursor = conn.cursor(cursor=DictCursor)
    else:
        from MySQLdb.cursors import DictCursor
        cursor = conn.cursor(cursorclass=DictCursor)
    cursor.execute(sql)
    result = cursor.fetchall()
    cursor.close()
    conn.close()
    return result


def DeleteFromDB(tablename, props):
    """从数据库中删除"""
    prers = FormatCondition(props)
    sql = """DELETE FROM %s WHERE %s ;""" % (tablename, prers)
    conn = dbpool.connection()
    cursor = conn.cursor()
    count = 0
    try:
        count = cursor.execute(sql)
        conn.commit()
    except Exception, e:
        logger.error(e)
        logger.error(sql)
    cursor.close()
    conn.close()
    return bool(count)


def InsertIntoDB(tablename, data):
    """写入数据库
    """
    sql = forEachPlusInsertProps(tablename, data)
    conn = dbpool.connection()
    cursor = conn.cursor()
    count = 0
    try:
        count = cursor.execute(sql)
        conn.commit()
    except Exception, e:
        logger.error(e)
        logger.error(sql)
    cursor.close()
    conn.close()
    return bool(count)


def UpdateWithDict(tablename, props, prere):
    """更新记录
    """
    sql = forEachUpdateProps(tablename, props, prere)
    conn = dbpool.connection()
    cursor = conn.cursor()
    count = 0
    try:
        count = cursor.execute(sql)
        conn.commit()
    except Exception, e:
        logger.error(e)
        logger.error(sql)
    cursor.close()
    conn.close()
    if (count >= 1):
        return True
    return False


def getAllPkByFkInDB(tablename, pkname, props):
    """根据所有的外键获取主键ID
    """
    props = FormatCondition(props)
    sql = """Select `%s` from `%s` where %s""" % (pkname, tablename, props)
    conn = dbpool.connection()
    cursor = conn.cursor()
    try:
        cursor.execute(sql)
    except Exception, e:
        logger.error(e)
        logger.error(sql)
    result = cursor.fetchall()
    cursor.close()
    conn.close()
    return [key[0] for key in result]


def GetOneRecordInfo(tablename, props):
    """获取单条数据的信息"""
    # print 'GetOneRecordInfo:', props
    props = FormatCondition(props)
    sql = """Select * from `%s` where %s""" % (tablename, props)
    conn = dbpool.connection()
    if dbpool._pymysql:
        from pymysql.cursors import DictCursor
        cursor = conn.cursor(cursor=DictCursor)
    else:
        from MySQLdb.cursors import DictCursor
        cursor = conn.cursor(cursorclass=DictCursor)
    try:
        cursor.execute(sql)
    except Exception, e:
        logger.error(e)
        logger.error(sql)
    result = cursor.fetchone()
    cursor.close()
    conn.close()
    return result


def GetRecordList(tablename, pkname, pklist):
    """
    """
    print pklist
    pkliststr = ""
    for pkid in pklist:
        pkliststr += "'%s'," % pkid
    pkliststr = "(%s)" % pkliststr[:-1]
    sql = """SELECT * FROM `%s` WHERE `%s` IN %s;""" % (tablename, pkname, pkliststr)
    conn = dbpool.connection()
    if dbpool._pymysql:
        from pymysql.cursors import DictCursor
        cursor = conn.cursor(cursor=DictCursor)
    else:
        from MySQLdb.cursors import DictCursor
        cursor = conn.cursor(cursorclass=DictCursor)
    cursor.execute(sql)
    result = cursor.fetchall()
    cursor.close()
    conn.close()
    return result


def DBTest():
    sql = """SELECT * FROM tb_item WHERE characterId=1000001;"""
    conn = dbpool.connection()
    if dbpool._pymysql:
        from pymysql.cursors import DictCursor
        cursor = conn.cursor(cursor=DictCursor)
    else:
        from MySQLdb.cursors import DictCursor
        cursor = conn.cursor(cursorclass=DictCursor)
    cursor.execute(sql)
    result = cursor.fetchall()
    cursor.close()
    conn.close()
    return result


def getallkeys(key, mem):
    itemsinfo = mem.get_stats('items')
    itemindex = []
    for items in itemsinfo:
        itemindex += [_key.split(':')[1] for _key in items[1].keys()]
    s = set(itemindex)
    itemss = [mem.get_stats('cachedump %s 0' % i) for i in s]
    allkeys = set([])
    for item in itemss:
        for _item in item:
            nowlist = set([])
            for _key in _item[1].keys():
                try:
                    keysplit = _key.split(':')
                    pk = keysplit[2]
                except:
                    continue
                if _key.startswith(key) and not pk.startswith('_'):
                    nowlist.add(pk)
            allkeys = allkeys.union(nowlist)
    return allkeys


def getAllPkByFkInMEM(key, fk, mem):
    pass


def getredisallkeys(key, mem):
    allkeys = set([])
    for client in mem.connections.values():
        itemss = client.redis().keys('%s*' % key)
        nowlist = set([])
        for item in itemss:
            keysplit = item.split(':')
            pk = keysplit[1]
            if pk.startswith('_'):
                continue
            nowlist.add(pk)
        allkeys = allkeys.union(nowlist)
    return allkeys


if __name__ == '__main__':
    import cPickle

    dbpool.initPool(**{
        "host": "127.0.0.1",
        "user": "test",
        "passwd": "test",
        "port": 8066,
        "db": "db_traversing",
        "charset": "utf8"
    })

    InsertIntoDB('tb_character_equipments', {'equipments': cPickle.dumps({123: 456}), 'id': 4})
    GetOneRecordInfo('tb_character_equipments', {'id': 4})

    UpdateWithDict('tb_character_equipments', {'equipments': cPickle.dumps({123: 567})}, {'id': 4})
    GetOneRecordInfo('tb_character_equipments', {'id': 4})

    DeleteFromDB('tb_character_equipments', {'id': 4})

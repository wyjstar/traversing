#coding:utf8
'''
Created on 2013-6-15

@author: lan (www.9miao.com)
'''
from MySQLdb.cursors import DictCursor
import MySQLdb

def getIncomeByDate(conn,onedate):
    """获取某天的缴费情况
    """
    sql = "SELECT SUM(rbm) AS goal,COUNT(uid) AS cnt\
    FROM tb_recharge WHERE DATE(rtime)=DATE('%s') GROUP BY uid;"%onedate
    cursor = conn.cursor(cursorclass=DictCursor)
    cursor.execute(sql)
    result = cursor.fetchall()
    cursor.close()
    conn.close()
    info = {}
    info['cnt'] = len(result)
    info['goal'] = sum([record['goal'] for record in result])
    return info


def getDayRecordList(conn,index,limit = 10):
    """获取每日的记录
    """
    sql ="SELECT * FROM tb_statistics ORDER BY recorddate DESC LIMIT %s,%s;"%(index-1,index*limit)
    cursor = conn.cursor(cursorclass=DictCursor)
    cursor.execute(sql)
    result = cursor.fetchall()
    cursor.close()
    conn.close()
    recordlist = []
    for daterecord in result:
        IncomeInfo = getIncomeByDate(daterecord['recorddate'])
        info = daterecord
        info['f_arpu'] = 0 if not IncomeInfo['cnt'] else IncomeInfo['goal']/IncomeInfo['cnt']
        info['z_arpu'] = 0 if not info['createrole'] else IncomeInfo['goal']/info['createrole']
        info['pay rate'] = 0 if not info['loginuser'] else IncomeInfo['cnt']*100/info['loginuser']
        info['r_rate'] = 0 if not info['createrole'] else info['loginuser']*100/info['createrole']
        info['recorddate'] = str(info['recorddate'])
        recordlist.append(info)
    return recordlist


#coding:utf8
"""
Created on 2013-8-14
@author: lan (www.9miao.com)
"""
from gfirefly.dbentrust.dbpool import dbpool


def load_module():
    from action.root import netforwarding
    from action.local import login
    from action.local import enterscene
    from action.local import createcharacter
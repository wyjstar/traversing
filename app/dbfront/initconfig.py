#coding:utf8


# def doWhenStop():
#     """服务器关闭前的处理
#     """
#     print "##############################"
#     print "##########checkAdmins#############"
#     print "##############################"
#     MAdminManager().checkAdmins()
#
# GlobalObject().stophandler = doWhenStop
from app.dbfront.dataloader import registe_madmin, check_mem_db


def load_module():
    registe_madmin()
    check_mem_db(10)
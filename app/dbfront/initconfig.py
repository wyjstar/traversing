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
from app.dbfront.dataloader import register_madmin, check_mem_db


def load_module():
    register_madmin()
    # check_mem_db(60)
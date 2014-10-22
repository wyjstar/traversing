#coding:utf8

from dataloader import register_madmin, check_mem_db


def load_module():
    register_madmin()
    check_mem_db(30)
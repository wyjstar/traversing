# -*- coding:utf-8 -*-
"""
created by server on 14-7-17下午4:36.
"""

from app.game.service.gatenoteservice import remote_service_handle

@remote_service_handle
def add_friend_request():
    """
    :return:
    """
    pass

@remote_service_handle
def add_friend_respond_accept():
    pass

@remote_service_handle
def add_friend_respond_refuse():
    pass

@remote_service_handle
def del_friend_request():
    pass

@remote_service_handle
def add_black_list():
    pass

@remote_service_handle
def del_black_list():
    pass


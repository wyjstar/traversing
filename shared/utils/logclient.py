# -*- coding:utf-8 -*-
"""
created by server on 14-9-19下午6:19.
"""
from gevent import socket
from gtwisted.utils import log
from shared.utils.const import const

class LogClient:
    """
    for tlog, UDP

    """
    sock=None
    def __init__(self):
        try:
            self.sock=socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        except IOError, arg:
            (_, err_msg) = arg
            log.err(str(err_msg))
    def send_msg(self, msg):
        if msg:
            try:
                self.sock.sendto(msg, const.TLOG_ADDR)
            except IOError, arg:
                (_, err_msg) = arg
                print "err_msg:%s",err_msg
                log.err(str(err_msg))
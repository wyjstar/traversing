# -*- coding:utf-8 -*-

from gfirefly.server.globalobject import GlobalObject
import socket
from gfirefly.server.logobj import logger
host = GlobalObject().allconfig['tlog']['host']
port = GlobalObject().allconfig['tlog']['port']
from gfirefly.server.logobj import logger


class LogClient:
    """
    for tlog, UDP
    """
    sock = None

    def __init__(self):
        try:
            self.sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        except socket.error, arg:
            (_, err_msg) = arg
            logger.info(str(err_msg))

    def send_msg(self, msg):
        if msg:
            try:
                self.sock.sendto(msg, (host, port))
                logger.debug('t logclient,send_msg:%s', msg)
            except socket.error, arg:
                (_, err_msg) = arg
                logger.info(str(err_msg))

udphandler = LogClient()


def gethandler():
    return udphandler

if "__main__" == __name__:
    gethandler().send_msg('hello world\n')

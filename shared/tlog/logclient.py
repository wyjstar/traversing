# -*- coding:utf-8 -*-

from gfirefly.server.globalobject import GlobalObject
import socket
from gfirefly.server.logobj import logger
print GlobalObject().json_config, 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
host = GlobalObject().json_config['tlog']['host']
port = GlobalObject().json_config['tlog']['port']
print host, port, 'cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc'
# host = "192.169.10.26"
# port = 30005


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
            print 'ddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd'

    def send_msg(self, msg):
        if msg:
            try:
                self.sock.sendto(msg, (host, port))
            except socket.error, arg:
                (_, err_msg) = arg
                logger.info(str(err_msg))
                print 'eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee'

udphandler = LogClient()


def gethandler():
    return udphandler

if "__main__" == __name__:
    gethandler().send_msg('hello world\n')

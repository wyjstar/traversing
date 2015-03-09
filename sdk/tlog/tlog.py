# coding: utf-8
# Created on 2014-12-29
# Author: jiang

""" tlog客户端
"""

import socket


class TLogClient(object):
    """
    tlog客户端，走UDP协议
    """
    sock = None

    def __init__(self, endpoint):
        """
        @param endpoint: 日志服务器地址, ("IP", PORT)
        """
        self._endpoint = endpoint
        self._sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

    @classmethod
    def _format(cls, fields):
        """
        拼接日志字段
        会把'\n'和'|'特殊字符替换为' '
        """
        strfields = map(str, fields)
        strfields = [w.replace('\n', ' ').replace('|', ' ') for w in strfields]
        return '|'.join(strfields) + '\n'

    def msg(self, fields):
        """
        发送日志到tlog服务器
        @param fields: 日志字段列表
        @return: 实际打印的整行日志
        """
        assert isinstance(fields, list), "msg must be list"
        if not fields:
            return
        line = self._format(fields)
        if not line:
            return
        self._send(line)
        return line
            
    def _send(self, line):
        self._sock.sendto(line, self._endpoint)


if "__main__" == __name__:
    tlog_addr = ("192.168.10.222", 6667)
    tlog = TLogClient(tlog_addr)
    text = tlog.msg(['hell|o', 'wor\nld'])
    print(text)

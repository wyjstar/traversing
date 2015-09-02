# coding: utf-8
# Created on 2014-12-29
# Author: jiang

""" log工具
"""

import traceback
import logging
from sdk.func.xtime import nowdatehours
from os.path import getsize, exists


def new_log(name, hdfile=None, hdsock=None, open_hdstream=True, level=logging.INFO):
    """
    创建日志打印实例
    @param name: 日志模块名
    @param hdfile: 文件地址
    @param hdsock: 网络地址, 'IP:PORT'
    @param open_hdstream: 是否把日志同时打印到控制台, 默认开启
    @param level: 日志打印级别
    """
    # 初始化日志配置
    log = logging.getLogger(name)
    log.setLevel(level)
    formatter = logging.Formatter("%(asctime)s [%(levelname).3s] %(message)s", "%Y-%m-%d %H:%M:%S")

    # 打印日志到文件
    if hdfile:
        hdfile = get_logfile_name(hdfile)
        file_handler = logging.FileHandler(hdfile)
        file_handler.setFormatter(formatter)
        log.addHandler(file_handler)

    # 打印日志到网络
    if hdsock:
        from logging.handlers import SocketHandler
        host, port = hdsock.split(":")
        socket_handler = SocketHandler(host, int(port))
        socket_handler.setFormatter(formatter)
        log.addHandler(socket_handler)

    # 打印日志到控制台
    if open_hdstream:
        formatter = logging.Formatter("%(asctime)s [%(levelname).3s] - [%(name).8s] %(message)s", "%Y-%m-%d %H:%M:%S")
        stream_handler = logging.StreamHandler()
        stream_handler.setFormatter(formatter)
        log.addHandler(stream_handler)

    def exception(mod=""):
        """
        记录详细代码异常日志

        Example:
            2014-12-29 18:56:35 [ERR] uid, ZeroDivisionError: integer division or modulo by zero,
                print 0/0,  File "/Users/chris/develop/masdk/utils/logger.py", line 46, in <module>
        """
        message = ','.join(traceback.format_exc().split('\n')[::-1][1:-1])
        if mod:
            message = "%s, %s" % (mod, message)
        log.error(message)

    # 支持缩写方式调用
    log.msg = log.info
    log.err = log.error
    log.war = log.warning
    log.cri = log.critical
    log.exception = exception
    log.exc = log.exception
    return log


def get_logfile_name(hdfile):
    datehour_str = nowdatehours()
    file_name = hdfile + '_' + datehour_str + '.log'
    while exists(file_name):
        file_size = getsize(file_name)
        if file_size > 10:
            if file_name[-1] == 'g':
                file_name += '.1'
            else:
                split_list = file_name.split('.')
                split_list[-1] = str(1+int(split_list[-1]))
                file_name = '.'.join(split_list)
    return file_name


if __name__ == "__main__":
    log1 = new_log('ACCOUNT', hdfile='test/error1')
    log2 = new_log('GAME', hdfile='test/error2')

    log1.msg("msg")
    log1.err("err")
    log1.cri("cri")
    log1.war("war")

    log2.err("test")

    print get_logfile_name('svr')

    try:
        print 0/0
    except:
        log1.exception()
        log2.exception()

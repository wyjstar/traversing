# coding:utf8
"""
Created on 2013-8-6
modify on 2014-10-8
"""
import sys
import logging
from logging.handlers import DatagramHandler
from shared.utils import const

logger_name = 's'


def log_init(log_path):
    _logger = logging.getLogger(logger_name)

    file_name = str(log_path).split('/')[-1].split('.')[0]
    datefmt = '%Y-%m-%d %I:%M:%S %p'
    fmt = '%(asctime)s-[%(levelname)s]-[' + file_name + ']: %(message)s'
    formatter = logging.Formatter(fmt, datefmt)

    _logger.setLevel(logging.DEBUG)
    fh = logging.FileHandler(log_path)
    fh.setLevel(logging.INFO)
    fh.setFormatter(formatter)
    _logger.addHandler(fh)

    ch = logging.StreamHandler(sys.stdout)
    ch.setLevel(logging.DEBUG)
    ch.setFormatter(formatter)
    _logger.addHandler(ch)

    uh = DatagramHandler(const.const.TLOG_ADDR[0], const.const.TLOG_ADDR[1])
    uh.setLevel(logging.CRITICAL)
    uh.setFormatter('%(message)s')
    # _logger.addHandler(uh)


def log_init_only_out():
    _logger = logging.getLogger(logger_name)

    datefmt = '%Y-%m-%d %I:%M:%S %p'
    fmt = '%(asctime)s-[%(levelname)s]: %(message)s'
    formatter = logging.Formatter(fmt, datefmt)

    ch = logging.StreamHandler(sys.stdout)
    ch.setLevel(logging.DEBUG)
    ch.setFormatter(formatter)
    _logger.addHandler(ch)


logger = logging.getLogger(logger_name)

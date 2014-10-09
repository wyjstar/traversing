# coding:utf8
"""
Created on 2013-8-6
modify on 2014-10-8
"""
import logging

logger_name = 's'


def log_init(log_path):
    _logger = logging.getLogger(logger_name)

    formatter = logging.Formatter('%(asctime)s-%(levelname)s-%(message)s')

    _logger.setLevel(logging.DEBUG)
    fh = logging.FileHandler(log_path)
    fh.setLevel(logging.DEBUG)
    fh.setFormatter(formatter)
    _logger.addHandler(fh)

    ch = logging.StreamHandler()
    ch.setLevel(logging.DEBUG)
    ch.setFormatter(formatter)
    _logger.addHandler(ch)


logger = logging.getLogger(logger_name)

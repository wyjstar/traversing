# coding:utf8
"""
Created on 2013-8-6
modify on 2014-10-8
"""
import sys
import logging
from logging import Formatter
from logging.handlers import DatagramHandler
from shared.utils import const


# 自定义log等级9,用于输出计算过程

DEBUG_CAL = 9
logging.addLevelName(DEBUG_CAL, "DEBUG_CAL")


def debug_cal(message, *args, **kws):
    if logger.isEnabledFor(DEBUG_CAL):
        logger._log(DEBUG_CAL, message, args, **kws)

logger_name = 's'

RED = '\033[31m'
GREEN = '\033[32m'
YELLOW = '\033[33m'
MAGENTA = '\033[35m'
OCEAN = '\033[36m'
RESET = '\033[0m'

color_map = {}
color_map[logging.DEBUG] = YELLOW
color_map[logging.ERROR] = RED
color_map[logging.INFO] = OCEAN
color_map[logging.CRITICAL] = MAGENTA


class MyFormatter(Formatter):
    def format(self, record):
        record.message = record.getMessage()
        if self.usesTime():
            record.asctime = self.formatTime(record, self.datefmt)
        s = self._fmt % record.__dict__
        if record.exc_info:
            # Cache the traceback text to avoid converting it multiple times
            # (it's constant anyway)
            if not record.exc_text:
                record.exc_text = self.formatException(record.exc_info)
        if record.exc_text:
            if s[-1:] != "\n":
                s = s + "\n"
            try:
                s = s + record.exc_text
            except UnicodeError:
                s = s + record.exc_text.decode(sys.getfilesystemencoding(),
                                               'replace')
        return color_map[record.levelno] + s


def log_init(log_path):
    _logger = logging.getLogger(logger_name)

    file_name = str(log_path).split('/')[-1].split('.')[0]
    datefmt = '%Y-%m-%d %I:%M:%S %p'
    fmt = '%(asctime)s-[%(levelname)s]-[' + file_name + ']: %(message)s'

    _logger.setLevel(logging.DEBUG)
    fh = logging.FileHandler(log_path)
    fh.setLevel(logging.ERROR)
    fh.setFormatter(Formatter(fmt, datefmt))
    _logger.addHandler(fh)

    ch = logging.StreamHandler(sys.stdout)
    ch.setLevel(logging.DEBUG)
    ch.setFormatter(MyFormatter(fmt, datefmt))
    _logger.addHandler(ch)

    uh = DatagramHandler(const.const.TLOG_ADDR[0], const.const.TLOG_ADDR[1])
    uh.setLevel(logging.CRITICAL)
    uh.setFormatter('%(message)s')
    # _logger.addHandler(uh)


def log_init_debug_cal():
    _logger = logging.getLogger(logger_name+"_cal")
    _logger.setLevel(logging.DEBUG)
    cah = logging.FileHandler("tool/battle/output", mode="w")
    cah.setLevel(logging.DEBUG)
    _logger.addHandler(cah)


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
logger_cal = logging.getLogger(logger_name+"_cal")
# logger_cal.setLevel(logging.DEBUG)
# log_init_debug_cal()

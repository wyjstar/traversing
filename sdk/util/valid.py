# coding: utf-8
# Created on 2014-12-29
# Author: jiang

""" 校验工具
"""

import re

email_regex = re.compile(r"^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$")
password_regex = re.compile(r"^[A-Za-z0-9~!@#$%^&*_+-=.?:,\(\)\{\}\[\]]+$")
chinese_regex = re.compile(ur"^[\u4E00-\u9FA5\w]+$")


def valid_len(s, _min, _max):
    if _min <= len(s) <= _max:
        return True
    return False


def valid_email(s):
    """ Validate email.
    """
    if not email_regex.match(s):
        return False
    if not valid_len(s, 5, 40):
        return False
    return True


def valid_password(s):
    """ Validate password.
    """
    if not password_regex.match(s):
        return False
    if not valid_len(s, 6, 16):
        return False
    return True


def valid_nickname(s, min_len=4, max_len=12):
    """ 校验昵称，中文或者英文
    单个汉字占两个位置，单个英文字母占一个位置
    """
    if not chinese_regex.match(unicode(s)):
        return False
    utf8_len = len(s)
    unicode_len = len(unicode(s))
    zh_char_len = (utf8_len - unicode_len) / 2
    en_char_len = unicode_len - zh_char_len
    char_len = zh_char_len * 2 + en_char_len
    return min_len <= char_len <= max_len


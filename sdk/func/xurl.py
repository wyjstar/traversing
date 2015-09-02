# coding: utf-8
# Created on 2014-12-29
# Author: jiang

""" url相关扩展方法
"""


def cuturi(url):
    """
    截取url的uri部分

    Example:
        geturi("http://localhost:8080/Payment?billno=123")
        >> Payment?billno=123
    """
    return url[url.rfind('/') + 1:]

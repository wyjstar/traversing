# -*- coding:utf-8 -*-
"""
created by server on 14-8-11下午5:42.
"""

import gevent
from gtwisted.core.base import Timer


def test(a, b):
    print a, b


# loop = gevent.get_hub().loop
# t = loop.timer(0.0, 5)  # timer注册回调函数后马上调用回调函数，然后反复每隔5秒调用回调函数
# t.start(test, 1, 2)
# print id(t)
#
# t1 = loop.timer(0.0, 3)
# t1.start(test, 3, 4)
# print id(t1)
#
# loop.run()  # 运行反应器loop


t2 = Timer(2, test, 5, 6)
t2._run()
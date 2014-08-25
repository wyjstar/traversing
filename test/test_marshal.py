# -*- coding:utf-8 -*-
"""
created by server on 14-8-25下午3:06.
"""

import marshal


test = marshal.dumps({'a':1234})
print test

print marshal.loads(test)
# -*- coding:utf-8 -*-
"""
created by server on 14-9-17下午3:16.
"""
f1 = open("/share/mgc.txt", 'r')
f2 = open("/share/mgc.config", 'w')
b = ''
for a in f1.read():
    if a == '[' or a == ']':
        continue
    if a == '|':
        f2.write('\n')
        continue
    f2.write(a)
f1.close()
f2.close()
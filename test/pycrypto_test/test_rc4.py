# -*- coding:utf-8 -*-
"""
created by server on 14-7-31下午6:45.
"""

# from test.pycrypto_test.pycrypto import PyCrypto_RC4
#
# a1 = PyCrypto_RC4('123456789123456789')
#
# str = a1.encrypt('fuck')
#
# a2 = PyCrypto_RC4('123456789123456789')
#
# print a2.decrypt(str)


from Crypto.Cipher import ARC4
a1 = ARC4.new('1234544523453245234')

str = a1.encrypt('fuck')

# a2 = ARC4.new('1234544523453245234')

print a1.decrypt(str)
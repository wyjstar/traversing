# -*- coding:utf-8 -*-
"""
created by server on 14-7-23下午5:25.
"""
from app.proto_file.account_pb2 import AccountLoginRequest, AccountResponse

request = AccountLoginRequest()
request.key.key = "fuckfuckfuck"
request.user_name = "mbmbmb"
request.password = "12345678"
import binascii
print binascii.b2a_hex(request.SerializeToString())


data = binascii.a2b_hex("00000000000000000000000026000000011a08313233343536373812066d626d626d620a0e0a0c6675636b6675636b6675636b")
print len(data)

test_response = AccountResponse()
test_response.result = True

data = binascii.b2a_hex(test_response.SerializeToString())
print data

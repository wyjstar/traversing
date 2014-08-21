# -*- coding:utf-8 -*-
"""
created by server on 14-7-23下午3:45.
"""
import time
from app.proto_file.common_pb2 import CommonResponse
if __name__ == '__main__':
    response = CommonResponse()
    data = response.SerializePartialToString()
    print response.result
    print response.result_no
    print response.message
    print type(response)

    response2 = CommonResponse()
    response2.ParseFromString(data)
    print response2.result_no
    print response2.message



# -*- coding:utf-8 -*-
"""
created by server on 15-2-11下午3:49.
"""
from gfirefly.server.globalobject import remoteserviceHandle
from sdk.api.google import google_check
from app.proto_file import google_pb2


@remoteserviceHandle('gate')
def test_1000000(data, player):
    request = google_pb2.RechargeTest()
    request.ParseFromString(data)
    player.recharge.charge(request.recharge_num)
    return ''


@remoteserviceHandle('gate')
def google_generate_id_10000(data, player):
    request = google_pb2.GoogleGenerateIDRequest()
    request.ParseFromString(data)

    response = google_pb2.GoogleGenerateIDResponse()
    response.uid = player.base_info.generate_google_id(request.channel)
    print response, ' GoogleGenerateIDRequest'
    return response.SerializeToString()


@remoteserviceHandle('gate')
def google_consume_10001(data, player):
    request = google_pb2.GoogleConsumeRequest()
    request.ParseFromString(data)
    print request, ' GoogleConsumeRequest'

    player.base_info.set_google_consume_data(request.data)

    response = google_pb2.GoogleConsumeResponse()
    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def google_consume_verify_10002(data, player):
    request = google_pb2.GoogleConsumeVerifyRequest()
    request.ParseFromString(data)
    print request, ' GoogleConsumeVerifyRequest'

    response = google_pb2.GoogleConsumeVerifyResponse()
    result = google_check('', request.data)
    if result:
        pass
    response.res.result = True
    return response.SerializeToString()

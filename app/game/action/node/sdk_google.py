# -*- coding:utf-8 -*-
"""
created by server on 15-2-11下午3:49.
"""
from gfirefly.server.globalobject import remoteserviceHandle
from sdk.api.google.google_check import verify_signature
from app.proto_file import google_pb2


VERIFY_KEY = 'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAz+WQFjaERwKgVIM7+zTmQwc/5i6o67K4YYluAQd7jlUWcJSNhUpiZ1Z4AxKWInffiVR+0ZQBNuDhi7/Mr0deffWaJ8rsa/xHVm9gGwZAHH31Wj+G3voIuejB84FgZmlh1asHgB+VMt+x3HO4/1LbSJvSxlscOl/vuov/+eIokvwsSiR+4Y8yKAnAqaoxcowNR6ER0p0n3VLNQ4UAvFlEisdXCsvW7JZf//ZBy4oKQQlYAkDFoebzpwkyAZEx2d9HEOmx4pZWoQi9JJi4WjrTvbLBXbh7dyqSxHvuVw/PkpJ9UHTNo6DgknWo2A7LDgaQdnTRlGY5mEBMnhCeQYlS3wIDAQAB'


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
    result = verify_signature(VERIFY_KEY, request.data)
    if result:
        pass
    response.res.result = True
    return response.SerializeToString()

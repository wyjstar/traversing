# -*- coding:utf-8 -*-
"""
created by sphinx on
"""
from gfirefly.server.globalobject import remoteserviceHandle
from gfirefly.server.globalobject import GlobalObject
from gfirefly.server.logobj import logger
from app.proto_file import cdkey_pb2
from geventhttpclient import HTTPClient
from geventhttpclient.url import URL


SERVER_NO = GlobalObject().allconfig.get('server_no')
CDKEY_URL = GlobalObject().allconfig.get('msdk').get('cdkey_url')
SERVER_TOKEN = '8284e374e15ae005b8300a0ebfdf803f'


@remoteserviceHandle('gate')
def get_cdkey_gift_1123(data, player):
    request = cdkey_pb2.CdkeyRequest()
    request.ParseFromString(data)

    response = cdkey_pb2.CdkeyResqonse()
    url = '%s/verify?area_id=%s&uid=%s&code=%s&token=%s' % \
          (CDKEY_URL, SERVER_NO, player.base_info.id,
           request.cdkey, SERVER_TOKEN)
    logger.debug('cdkey url:%s', url)

    url = URL(url)
    http = HTTPClient(url.host, port=url.port)
    url_response = eval(http.get(url.request_uri).read())
    http.close()

    logger.debug('cdkey url result:%s', url_response)

    # gain_data = tomorrow_gift['reward']
    # return_data = gain(player, gain_data, const.TOMORROW_GIFT)
    # get_return(player, return_data, response.gain)
    response.res.result = True
    response.res.result_no = url_response.get('success')
    response.res.message = str(url_response.get('message'))
    return response.SerializeToString()

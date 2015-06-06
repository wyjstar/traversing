# -*- coding:utf-8 -*-
"""
created by sphinx on
"""
import urllib
from gfirefly.server.globalobject import remoteserviceHandle
from gfirefly.server.globalobject import GlobalObject
from gfirefly.server.logobj import logger
from app.proto_file import cdkey_pb2

SERVER_NO = GlobalObject().allconfig.get('server_no', 0)
SERVER_TOKEN = '8284e374e15ae005b8300a0ebfdf803f'


@remoteserviceHandle('gate')
def get_cdkey_gift_1123(data, player):
    request = cdkey_pb2.CdkeyRequest()
    request.ParseFromString(data)

    response = cdkey_pb2.CdkeyResqonse()
    url = 'http://192.168.1.60:2600/cdkey/verify?area_id=%s&uid=%s&code=%s&token=%s' % (SERVER_NO, player.base_info.id, request.cdkey, SERVER_TOKEN)
    logger.debug('cdkey url:%s', url)

    url_response = urllib.urlopen(url)
    str_response = url_response.read()
    url_response = eval(str_response)
    logger.debug('cdkey url result:%s', url_response)

    # gain_data = tomorrow_gift['reward']
    # return_data = gain(player, gain_data, const.TOMORROW_GIFT)
    # get_return(player, return_data, response.gain)
    response.res.result = True
    response.res.result_no = url_response.get('success')
    response.res.message = str(url_response.get('message'))
    return response.SerializeToString()

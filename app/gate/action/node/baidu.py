# -*- coding:utf-8 -*-
"""
created by sphinx on 11/9/14.
"""
import urllib
import hashlib
import json
from flask import request
from gfirefly.server.logobj import logger

from gfirefly.server.globalobject import webserviceHandle
# from gfirefly.server.globalobject import GlobalObject
# from app.gate.core.virtual_character_manager import VCharacterManager

resultCode = "1"
resultMsg = "成功"
# 应用开发者appid
appid = "7595234"
# 应用开发者secretkey
secretkey = "pcSugeUWbdripDyzLSGGhZjuG2VX26BO"

orderSerial = ""
cooperatorOrderSerial = ""
content = ""
sign = ""


@webserviceHandle('/baidupay', methods=['post', 'get'])
def recharge_baidu_response():
    logger.debug('baidu recharge:%s', request.form)
    postData = None
    # print postData
    if postData:
        connectorParam = "&"
        spiltParam = "="
        import operator
        if operator.indexOf(postData, connectorParam) and operator.indexOf(
                postData, spiltParam):
            str_split = postData.split(connectorParam)
            for keyValue in str_split:
                kv = keyValue.split(spiltParam)
                if len(kv) > 1:
                    if kv[0] == "OrderSerial":
                        orderSerial = kv[1]
                    if kv[0] == "CooperatorOrderSerial":
                        cooperatorOrderSerial = kv[1]
                    if kv[0] == "Content":
                        # 读取POST流的方式需要进行UrlDecode解码操作
                        content = urllib.unquote(kv[1])
                        # print content
                    if kv[0] == "Sign":
                        sign = kv[1]

    # 验证签名
    if sign != hashlib.md5(appid + orderSerial + cooperatorOrderSerial +
                           content + secretkey).hexdigest():
        resultCode = "10001"
        resultMsg = "Sign无效"
    if resultCode == "1":
        # print content
        import base64
        # base64解码
        content = base64.b64decode(content)
        # json解析
        js = json.loads(content)
        print js
        # 根据获取的信息，执行业务处理

        # print js["UID"]
        # print js["MerchandiseName"]
        # print js["OrderMoney"]
        # print js["StartDateTime"]
        # print js["BankDateTime"]
        # print js["OrderStatus"]
        # print js["StatusMsg"]
        # print js["ExtInfo"]
        # print js["VoucherMoney"]
        # print resultMsg
    result = "{\"AppID\":" + appid + ",\"ResultCode\":" + resultCode + \
             ",\"ResultMsg\":\"" + resultMsg + "\",\"Sign\":\"" + \
             hashlib.md5(appid + resultCode + secretkey).hexdigest() + \
             "\",\"Content\":\"\"}"
    print result
    if result:
        return 'ok'

    return 'failed'

# 2.读取POST流方式获取请求参数

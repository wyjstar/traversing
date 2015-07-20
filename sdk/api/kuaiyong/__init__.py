# -*- coding:utf-8 -*-
"""
created by sphinx on
"""
import base64
from Crypto.PublicKey import RSA
from Crypto.Signature import PKCS1_v1_5
from hashlib import md5
from geventhttpclient import HTTPClient
from geventhttpclient.url import URL
from gfirefly.server.logobj import logger

# 测试用公钥，请替换为对应游戏的公钥，从快用平台上获取的是无格式的公钥，需要转换
PUBLIC_KEY = 'MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC3bYVta6I7Jkonvrv5UOO6KcmewJDY2qvLwp0lVr7g3ASNwx1S8/oTm1CFfbSfDaosZ58MmhVQ+BKepEy3yAN9NEV72cM8C+roI3yXsXzszwCBeCa22Qj6M+twzOfH/7YhAifsm5g1jXSLMWj+c8eNFwzdaAGbHzRvwiKUCUv9BwIDAQAB'

APP_KEY = '05826e2d277a5d2b1f21464ee6beb599'

VERIFY_KEY = RSA.importKey(base64.standard_b64decode(PUBLIC_KEY))

KUAIYONG_URL = 'http://f_signin.bppstore.com/loginCheck.php?'


def verify_login(token):
    sig = md5(APP_KEY + token).hexdigest
    url = '%stokenKey=%s&sign=%s' % (KUAIYONG_URL, token, sig)
    logger.debug('', url)
    url = URL(url)
    http = HTTPClient(url.host, port=url.port)
    response = eval(http.get(url.request_uri).read())
    http.close()
    return response


def recharge_verify(post_sign, post_notify_data, post_orderid, post_dealseq,
                    post_uid, post_subject, post_v):

    if post_sign == "":
        logger.debug(" Unable to get required value")
        return "failed"

    post_sign = base64.standard_b64decode(post_sign)

    # 对输入参数根据参数名排序，并拼接为key=value&key=value格式；
    parametersArray = {}

    parametersArray['notify_data'] = post_notify_data
    parametersArray['orderid'] = post_orderid
    parametersArray['dealseq'] = post_dealseq
    parametersArray['uid'] = post_uid
    parametersArray['subject'] = post_subject
    parametersArray['v'] = post_v

    # ksort($parametersArray)

    sourcestr = "?"
    for key, value in parametersArray:
        sourcestr += '&%s=%s' % (key, value)

    logger.debug('Raw sign is: %s', sourcestr)

    # 对数据进行验签，注意对公钥做格式转换
    verifier = PKCS1_v1_5.new(VERIFY_KEY)
    sig = base64.standard_b64decode(post_sign)
    verify = verifier.verify(sourcestr, sig)

    logger.debug('Verification result is %s', verify)

    if verify:
        logger.debug('Failed to verify data')
        return 'failed'

    # 对加密的notify_data进行解密
    post_notify_data_decode = base64.standard_b64decode(post_notify_data)

    decode_notify_data = VERIFY_KEY.decrypt(post_notify_data_decode)

    logger.debug('Notify data decoded as %s', decode_notify_data)

    parse_str(decode_notify_data)

    logger.debug('dealseq:%s fee:%s payresult:%s', dealseq, fee, payresult)

    # 比较解密出的数据中的dealseq和参数中的dealseq是否一致
    if dealseq == post_dealseq:
        logger.debug(" Success")
        # TODO：开发商根据dealseq将支付结果记录下来，并根据支付结果做相应处理
        return "success"
    else:
        logger.debug(" Dealseq values did not match")
        return "failed"

# -*- coding:utf-8 -*-
"""
created by sphinx on
"""
import base64
from hashlib import md5
from geventhttpclient import HTTPClient
from geventhttpclient.url import URL
try:
    from M2Crypto import RSA
except:
    pass
if __name__ != '__main__':
    from gfirefly.server.logobj import logger

try:
    pub = RSA.load_pub_key('kuaiyong_pub.pem')
except:
    pass

APP_KEY = '05826e2d277a5d2b1f21464ee6beb599'

KUAIYONG_URL = 'http://f_signin.bppstore.com/loginCheck.php?'


def verify_login(token):
    sig = md5(APP_KEY + token).hexdigest()
    url = '%stokenKey=%s&sign=%s' % (KUAIYONG_URL, token, sig)
    logger.debug('kuaiyong url:%s', url)
    url = URL(url)
    http = HTTPClient(url.host, port=url.port)
    response = eval(http.get(url.request_uri).read())
    http.close()
    return response


def parse_str(code):
    result = {}
    for _ in code.split('&'):
        kv = _.split('=')
        result[kv[0]] = kv[1]

    return result


def recharge_verify(post_sign, post_notify_data, post_orderid, post_dealseq,
                    post_uid, post_subject, post_v):

    if post_sign == "":
        logger.debug(" Unable to get required value")
        return False

    post_sign = base64.standard_b64decode(post_sign)

    # 对输入参数根据参数名排序，并拼接为key=value&key=value格式；
    # sourcestr = "?" + 'notify_data=' + post_notify_data
    # sourcestr += '&orderid=' +  post_orderid
    # sourcestr += '&dealseq=' +  post_dealseq
    # sourcestr += '&uid=' +  post_uid
    # sourcestr += '&subject=' +  post_subject
    # sourcestr += '&v=' +  post_v
    # logger.debug('Raw sign is: %s', sourcestr)

    # 对数据进行验签，注意对公钥做格式转换
    # verify = pub.verify(sourcestr, sig)
    # logger.debug('Verification result is %s', verify)
    # if verify:
    #     logger.debug('Failed to verify data')
    #     return False

    # 对加密的notify_data进行解密
    decode_data = base64.standard_b64decode(post_notify_data)
    decode_notify_data = pub.public_decrypt(decode_data, RSA.pkcs1_padding)

    logger.debug('Notify data decoded as %s', decode_notify_data)

    result = parse_str(decode_notify_data)
    dealseq = result['dealseq']
    fee = result['fee']
    payresult = result['payresult']

    logger.debug('dealseq:%s fee:%s payresult:%s', dealseq, fee, payresult)

    # 比较解密出的数据中的dealseq和参数中的dealseq是否一致
    if dealseq != post_dealseq:
        logger.debug(" Dealseq values did not match:%s-%s",
                     dealseq, post_dealseq)
        return False, 0

    if payresult != '0':
        logger.error("recharge fail payresult:%s", payresult)
        return False, 0

    logger.debug('kuaiyong verify success!')
    return True, fee


if __name__ == '__main__':
    class Logger:
        def debug(self, fmt, *arg):
            print fmt % arg
    logger = Logger()

    orderid = u'15072310073510103155877'
    uid = u's55af7268c55bb'
    v = u'1.0'
    dealseq = u'2'
    subject = u'60'
    notify_data = u'qT5Z0dXYGpsKTpjmopQnpEtoUsBlkNdNxThfaNCI+EPbq72IpfSoUgvWO7n+2tY8uMO8LVitMn7e0B/60zYTiHGE3U80G+LgYIc2SH1fyFxbT3PAUz60PIUWJ/Wp2LPjjU7NW9zhIukGgsUg+KGYrCe6LV6aKwi2G9LQzJwOfVs='
    sign = u'C0v1ftibEFJ45Dzh+21y4fboA3HirFFcNunuq/RgZ5C0F7cFysyeJp6nTqc4YgatxpADnbQZhm57p9B9jrI69dx8kzJZlpgYSt+xdg1ydXrPj/HUDhoN/ESZ0f/aNOomv+fvE/a7qpnwklsqy0S9Tf0EBCSVlwEhS11EboAJCOU='

    recharge_verify(sign, notify_data, orderid, dealseq,
                    uid, subject, v)

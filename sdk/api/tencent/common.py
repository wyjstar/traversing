# coding: utf-8
# Created on 2013-8-31
# Author: jiang

import binascii
import hashlib
import hmac
import urllib

def mk_soucrce(method, url_path, params):
    str_params = urllib.quote("&".join(k + "=" + str(params[k]) for k in sorted(params.keys())), '')
    source = '%s&%s&%s' % (
        method.upper(),
        urllib.quote(url_path, ''),
        str_params
    )
    return source

def hmac_sha1_sig(method, url_path, params, secret):
    source = mk_soucrce(method, url_path, params)
    print "secret====", secret
    print "source====", source
    hashed = hmac.new(secret, source, hashlib.sha1)
    return binascii.b2a_base64(hashed.digest())[:-1]

def create_cookie(platform, uri):
    if platform == 1:
        # WX
        params = {'session_id':'hy_gameid', 'session_type':'wc_actoken', 'org_loc':uri}
    else:
        # 手Q
        params = {'session_id':'openid', 'session_type':'kp_actoken', 'org_loc':uri}

    cookie = urllib.urlencode(params)
    return cookie.replace('&', '; ')

def encoding_params(method, uri, params, appkey):
    secret = '%s&' % appkey
    sig = hmac_sha1_sig(method, uri, params, secret)
    params['sig'] = sig
    en_params = urllib.urlencode(params)
    return en_params

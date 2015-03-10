# coding:utf-8
"""
Created on 2015-2-12

@author: hack
"""

import base64
from Crypto.PublicKey import RSA
from Crypto.Hash import SHA
from Crypto.Signature import PKCS1_v1_5
from conf.product import google_public_key
VERIFY_KEY = RSA.importKey(base64.standard_b64decode(google_public_key))


def verify_signature(sig, data):
    h = SHA.new()
    h.update(data)
    verifier = PKCS1_v1_5.new(VERIFY_KEY)
    sig = base64.standard_b64decode(sig)
    return verifier.verify(h, sig)

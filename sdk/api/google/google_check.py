# coding:utf-8
"""
Created on 2015-2-12

@author: hack
"""

import base64
from Crypto.PublicKey import RSA
from Crypto.Hash import SHA
from Crypto.Signature import PKCS1_v1_5

VERIFY_KEY = 'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAz+WQFjaERwKgVIM7+zTmQwc/5i6o67K4YYluAQd7jlUWcJSNhUpiZ1Z4AxKWInffiVR+0ZQBNuDhi7/Mr0deffWaJ8rsa/xHVm9gGwZAHH31Wj+G3voIuejB84FgZmlh1asHgB+VMt+x3HO4/1LbSJvSxlscOl/vuov/+eIokvwsSiR+4Y8yKAnAqaoxcowNR6ER0p0n3VLNQ4UAvFlEisdXCsvW7JZf//ZBy4oKQQlYAkDFoebzpwkyAZEx2d9HEOmx4pZWoQi9JJi4WjrTvbLBXbh7dyqSxHvuVw/PkpJ9UHTNo6DgknWo2A7LDgaQdnTRlGY5mEBMnhCeQYlS3wIDAQAB'

VERIFY_KEY = RSA.importKey(base64.standard_b64decode(VERIFY_KEY))


def verify_signature(sig, data):
    h = SHA.new()
    h.update(data)
    verifier = PKCS1_v1_5.new(VERIFY_KEY)
    sig = base64.standard_b64decode(sig)
    return verifier.verify(h, sig)

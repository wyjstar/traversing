# -*- coding:utf-8 -*-
"""
created by server on 14-6-4下午3:06.
"""

from Crypto.Cipher import AES

class MyCrypt(object):

    def __init__(self, key, mode):
        self.key = key
        self.mode = mode
        self.padding = '\0'

    def encrypt(self, text):
        cryptor = AES.new(self.key, self.mode)
        length = 16

        count = text.count('')
        if count < length:
            add = (length - count) + 1
            text += (self.padding * add)
        elif count > length:
            add = (length - (count % length)) + 1
            text += (self.padding * add)

        ciphertext = cryptor.encrypt(text)
        return ciphertext

    def decrypt(self, text):
        cryptor = AES.new(self.key, self.mode)
        plain_text = cryptor.decrypt(text)
        return plain_text.rstrip(self.padding)

key = '7486E0264E999881D4EF7BEEDF05A9F7'
mode = AES.MODE_ECB
ec = MyCrypt(key, mode)
encrypt = ec.encrypt
decrypt = ec.decrypt

if __name__ == '__main__':
    data = '{"a":"123中文"， sss}'
    encrpt_data = encrypt(data)
    decrpt_data = decrypt(encrpt_data)
    print encrpt_data
    print decrpt_data
    print decrpt_data==data

    import hashlib
    md5 = hashlib.md5()
    md5.update('12345678901234567890')
    print len(md5.hexdigest())

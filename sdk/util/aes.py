# coding: utf-8
# Created on 2014-12-29
# Author: jiang

""" AES算法工具类
"""


from Crypto.Cipher import AES
from func import xid
import base64


class AESUtil():
    def __init__(self, key, base64=False):
        self.key = key
        self.encryptor = AES.new(key, AES.MODE_ECB)
        self.padding_chr = '\0'
        self.base64 = base64

    def encrypt(self, text):
        """
        加密字串
        @param text: 明文字串
        @return: 加密结果
        """
        padding_len = 16 - len(text) % 16
        if padding_len == 16:
            padding_len = 0
        text += self.padding_chr * padding_len
        entext = self.encryptor.encrypt(text)
        if self.base64:
            entext = base64.b64encode(entext)
        return entext
    
    def decrypt(self, entext):
        """
        解密字串
        @param entext: 密文字串
        @return: 解密结果
        """
        if self.base64:
            entext = base64.b64decode(entext)
        text = self.encryptor.decrypt(entext)
        return text


if __name__ == "__main__":
    aes = AESUtil(xid.hexmd5('account_aes.201307021738'), base64=True)
    text = "hello"
    entext = aes.encrypt(text)
    print(entext)
    print(aes.decrypt(entext))

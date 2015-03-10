# coding: utf-8
# Created on 2014-12-29
# Author: jiang

""" 16位种子替换CHR加解密算法
"""


import random
import zlib


class CHREndec():
    """
    Class for encryption and decryption.
    """
    def __init__(self, en_key=False):
        self.en_box = [7, 6, 11, 1, 3, 15, 5, 9, 14, 0, 13, 4, 12, 8, 10, 2]
        if en_key:
            self.en_box = en_key
        # Encrypt Seed
        # Decrypt Seed(opposite with Encrypt Seed) 
        self.de_box = []
        # Encrypt & Decrypt Dictionary
        self.ende_dict = {}
        
        for i in range(16):
            self.de_box.append(self.en_box.index(i))
        for i in range(0, 16):
            for j in range(0, 16):
                key = chr(i * 16 + j)
                val = chr(self.en_box[j] * 16 + self.de_box[i])
                self.ende_dict[key] = val
    
    @classmethod
    def enkey(cls):
        """
        Create seek for encryption. 
        @return: seek list, seek string
        @rtype: list, str
        """
        key = []
        seek = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
        for _ in range(16):
            rand_index = random.randint(0, len(seek) - 1)
            rand_value = seek[rand_index]
            key.append(rand_value)
            del seek[rand_index]
        return key
    
    def encrypt(self, msg):
        return self.switch(msg)
     
    def decrypt(self, en_msg):
        return self.switch(en_msg)
        
    def switch(self, raw_str):
        """
        Encrypt or decrypt data with the method.
        """
        s = [self.ende_dict[char] for char in raw_str]
        return "".join(s)

    @classmethod
    def compress(cls, s):
        return zlib.compress(s)

    @classmethod
    def decompress(cls, s):
        return zlib.decompress(s)


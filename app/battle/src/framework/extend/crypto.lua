
--[[

Copyright (c) 2011-2014 chukong-inc.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

]]

--[[--

加解密、数据编码

]]
local crypto = {}

--[[--

使用 AES256 算法加密内容

提示：AES256 仅在 iOS 和 Mac 平台可用。加解密尽量选择跨平台的 XXTEA 接口。

@param string plaintext 明文字符串
@param string key 密钥字符串

@return string  加密后的字符串

]]
function crypto.encryptAES256(plaintext, key)
    plaintext = tostring(plaintext)
    key = tostring(key)
    return CCCrypto:encryptAES256(plaintext, string.len(plaintext), key, string.len(key))
end

--[[--

使用 AES256 算法解密内容

提示： AES256 仅在 iOS 和 Mac 平台可用。加解密尽量选择跨平台的 XXTEA 接口。

@param string ciphertext 加密后的字符串
@param string key 密钥字符串

@return string  明文字符串

]]
function crypto.decryptAES256(ciphertext, key)
    ciphertext = tostring(ciphertext)
    key = tostring(key)
    return CCCrypto:decryptAES256(ciphertext, string.len(ciphertext), key, string.len(key))
end

--[[--

使用 XXTEA 算法加密内容

@param string plaintext 明文字符串
@param string key 密钥字符串

@return string  加密后的字符串

]]
function crypto.encryptXXTEA(plaintext, key)
    plaintext = tostring(plaintext)
    key = tostring(key)
    return CCCrypto:encryptXXTEA(plaintext, string.len(plaintext), key, string.len(key))
end

--[[--

使用 XXTEA 算法解密内容

@param string ciphertext 加密后的字符串
@param string key 密钥字符串

@return string  明文字符串

]]
function crypto.decryptXXTEA(ciphertext, key)
    ciphertext = tostring(ciphertext)
    key = tostring(key)
    return CCCrypto:decryptXXTEA(ciphertext, string.len(ciphertext), key, string.len(key))
end

--[[--

使用 BASE64 算法编码内容

@param string plaintext 原文字符串

@return string  编码后的字符串

]]
function crypto.encodeBase64(plaintext)
    plaintext = tostring(plaintext)
    return CCCrypto:encodeBase64(plaintext, string.len(plaintext))
end

--[[--

使用 BASE64 算法解码内容

@param string ciphertext 编码后的字符串

@return string  原文字符串

]]
function crypto.decodeBase64(ciphertext)
    ciphertext = tostring(ciphertext)
    return CCCrypto:decodeBase64(ciphertext)
end

--[[--

计算内容的 MD5 码

@param string input 内容字符串
@param boolean isRawOutput 是否返回二进制 MD5 码

@return string MD5 字符串

]]
function crypto.md5(input, isRawOutput)
    input = tostring(input)
    if type(isRawOutput) ~= "boolean" then isRawOutput = false end
    return CCCrypto:MD5(input, isRawOutput)
end

--[[--

计算文件的 MD5 码

@param string path 文件路径

@return string MD5 字符串

]]
function crypto.md5file(path)
    if not path then
        printError("crypto.md5file() - invalid filename")
        return nil
    end
    path = tostring(path)
    if DEBUG > 1 then
        printInfo("crypto.md5file() - filename: %s", path)
    end
    return CCCrypto:MD5File(path)
end


-- module "crypto"

-- -- RC4
-- -- http://en.wikipedia.org/wiki/RC4

function KSA(key)
    local key_len = string.len(key)
    local S = {}
    local key_byte = {}

    for i = 0, 255 do
        S[i] = i
    end

    for i = 1, key_len do
        key_byte[i-1] = string.byte(key, i, i)
    end

    local j = 0
    for i = 0, 255 do
        j = (j + S[i] + key_byte[i % key_len]) % 256
        S[i], S[j] = S[j], S[i]
    end
    return S
end

function PRGA(S, text_len)
    local i = 0
    local j = 0
    local K = {}

    for n = 1, text_len do

        i = (i + 1) % 256
        j = (j + S[i]) % 256

        S[i], S[j] = S[j], S[i]
        K[n] = S[(S[i] + S[j]) % 256]
    end
    return K
end

function RC4(key, text)
    local text_len = string.len(text)

    local S = KSA(key)        
    local K = PRGA(S, text_len) 
    return output(K, text)
end

function output(S, text)
    local len = string.len(text)
    local c = nil
    local res = {}
    for i = 1, len do
        c = string.byte(text, i, i)
        res[i] = string.char(bxor(S[i], c))
    end
    return table.concat(res)
end


-------------------------------
-------------bit wise-----------
-------------------------------

local bit_op = {}
function bit_op.cond_and(r_a, r_b)
    return (r_a + r_b == 2) and 1 or 0
end

function bit_op.cond_xor(r_a, r_b)
    return (r_a + r_b == 1) and 1 or 0
end

function bit_op.cond_or(r_a, r_b)
    return (r_a + r_b > 0) and 1 or 0
end

function bit_op.base(op_cond, a, b)
    -- bit operation
    if a < b then
        a, b = b, a
    end
    local res = 0
    local shift = 1
    while a ~= 0 do
        r_a = a % 2
        r_b = b % 2
   
        res = shift * bit_op[op_cond](r_a, r_b) + res 
        shift = shift * 2

        a = math.modf(a / 2)
        b = math.modf(b / 2)
    end
    return res
end

function bxor(a, b)
    return bit_op.base('cond_xor', a, b)
end

function band(a, b)
    return bit_op.base('cond_and', a, b)
end

function bor(a, b)
    return bit_op.base('cond_or', a, b)
end

-- key = "a key"
-- text = "testkey"
-- K = RC4(key, text)
-- print (K)
-- text = RC4(key, K)
-- print (text)

-- key = "Wiki"
-- text = "pedia"
-- K = RC4(key, text)
-- print (K)

-- key = "Secret"
-- text = "Attack at dawn"
-- K = RC4(key, text)
-- print (K) 

return crypto
# -*- coding:utf-8 -*-
"""
created by server on 14-9-13下午2:19.
"""
from gfirefly.server.logobj import logger


class Check(object):
    def __init__(self):
        pass

    def add_word(self, text):
        pass

    def get_bad_word(self, text, offset=0):
        pass

    def replace_bad_word(self, text, offset=0, mark='*'):
        pass


import codecs
import sys


class TrieNode(Check):
    def __init__(self, value=None):
        self.__end = False
        self.__child = dict()
        self.__value = value

    def add(self, ch):
        if not self.__child.has_key(ch):
            node = TrieNode(ch)
            self.__child[ch] = node
            return node
        else:
            return self.__child.get(ch)

    def is__end(self, n):
        """根据下一个字符判断匹配是否结束"""
        if self.__child.has_key(n):
            return False
        if self.__child.has_key('#'):
            return True
        return False

    def set__end(self, end):
        self.add('#')

    def get__child(self, ch):
        if self.__child.has_key(ch):
            return self.__child.get(ch)
        else:
            return None

    def get__value(self):
        return self.__value


class TrieCheck(object):
    def __init__(self):
        self.__root = TrieNode('')

    def add_word(self, text):
        node = self.__root
        for i in text:
            node = node.add(i)
        node.set__end(True)

    def get_bad_word(self, text, offset=0):
        if not isinstance(text, str) or offset >= len(text):
            raise Exception("%s is not a string" % str(str))
        i = offset
        text = unicode(text[offset:], 'utf-8')
        for ch in text[offset:]:
            node = self.__root
            index = i
            node = node.get__child(ch)
            path = []

            while node is not None:
                n = text[index+1: index+2]
                path.append(text[index])
                if node.is__end(n):
                    return i, "".join(path)
                if len(text) == index + 1:
                    break
                index += 1
                node = node.get__child(text[index])
            i += 1
        return -1, None

    def replace_bad_word(self, text, offset=0, mark='*'):
        if isinstance(text, unicode):
            text = text.encode('utf-8')
        if not isinstance(text, str) or offset >= len(text):
            logger.error('error type %s, offset=%d', type(text), offset)
        i = offset
        text = unicode(text[offset:], 'utf-8')
        li = list(text)
        for ch in text[offset:]:
            node = self.__root
            index = i
            node = node.get__child(ch)

            while node is not None:
                n = text[index+1: index+2]
                if node.is__end(n):
                    for m in range(i, index+1):
                        li[m] = mark
                    break
                if len(text) == index + 1:
                    break
                index += 1
                node = node.get__child(text[index])
            i += 1
        return "".join(li)


def load(path, checker):
    with codecs.open(path, 'r', encoding='utf-8-sig') as f:
        for line in f.readlines():
            # print line.strip()
            line = line.strip()
            if line.startswith(u'#'):
                continue
            checker.add_word(line)

check = TrieCheck()
import os.path
root_dir = os.path.join(os.path.split(os.path.abspath(__file__))[0], os.pardir, os.pardir)
load(os.path.join(root_dir, 'mgc.config'), check)

# =========================================================================================


def test(argv):
    if len(argv) < 2:
        raise Exception("provide at least one parameter")
    check = TrieCheck()
    load(argv[1], check)
    print check.replace_bad_word('我喜欢毛泽东哈遺囑哈，邓明明，我草你大爷。你老味[|]吊佢佬未[|]吊妳好撚[|]吊妳老母[|]吊妳老味[|]吃屎[|]好撚廢[|]她娘的[|]她媽的[|]她媽的[|]死妓女[|]死婊[|]死雞巴[|]老母[|]老娼[|]老婊[|]自慰[|]作愛[|]你老母[|]你娘卡好[|]你娘的[|]你媽的[|]吹蕭[|]含撚[|]妓女[|]屁眼[|]我操你老母[|]肖查某[|]妳娘卡好[|]妳娘的[|]妳媽的[|]官方[|]性交[|]性虐待[|]性高潮[|]狗母養[|]狗娘[|]狗養的[|]狗雜碎[|]狗雜種[|]阻橪住曬[|]屄[|]俗啦[|]姦[|]客服[|]屌[|]屌你[|]哭腰[|]肉洞[|]肉捧[|]肉棒[|]肉棍[|]你娘78[|]流淫水[|]食撚[|]食撚妹[|]食撚屎啦[|]屌你[|]屌你老母含家[|]屌妳老母含家[|]唔燃同佢[|]臭妓女[|]臭表子[|]臭婊[|]臭婊子[|]臭機八[|]臭雞雞[|]耖你老幕[|]基掰[|]娼[|]婊[|]婊子[|]婊子養的兒子[|]強奸[|]強姦[|]強暴[|]您娘卡好[|]淫[|]淫[|]淫婦[|]淫蕩[|]淦[|]被狗幹[|]陰毛[|]陰門[|]陰莖[|]陰道[|]陰囊[|]援交[|]智障[|]陽具[|]陽物[|]陽莖[|]雲起[|]塞妮糧勒[|]睪丸[|]跡掰[|]鳩[|]嫩B[|]嫩b[|]榦[|]精液[|]睾丸[|]撚[|]賤[|]賤人[|]賤屄[|]賤胚[|]賤婊[|]賤貨[|]賣淫[|]靠ㄠ[|]靠么[|]靠妖[|]噁爛[|]閪[|]bitch[|]fuck[|]中共[|]甘霖老母[|]尻手槍[|]早洩[|]老共[|]卵子[|]妓[|]妓女[|]勃起[|]相幹[|]屌[|]射精[|]娼[|]婊 [|]婊子[|]強姦[|]強暴[|]陰莖粉嫩嫩[|]陰蒂[|]插爆[|]媽的[|]媽逼[|]幹[|]幹你娘[|]幹你媽[|]愛液[|]嫖娼[|]精子[|]精蟲[|]賤種[|]賣淫[|]靠背[|]靠腰[|]靠邀[|]操[|]操你媽[|]機八[|]機掰[|]激掰[|]積掰[|]龜頭[|]糙[|]糙你媽[|]糙妳媽[|]糙雞掰[|]')
    print "-"*50
    print check.get_bad_word('我喜欢毛泽东哈遺囑哈，邓明明，我草你大爷。')

if __name__ == "__main__":

    test([1, os.path.join(root_dir, 'mgc.config')])
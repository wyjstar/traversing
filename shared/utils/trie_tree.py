# -*- coding:utf-8 -*-
"""
created by server on 14-9-13下午2:19.
"""


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

    def is__end(self):
        return self.__end

    def set__end(self, end):
        self.__end = end

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
                path.append(text[index])
                if node.is__end():
                    return i, "".join(path)
                if len(text) == index + 1:
                    break
                index += 1
                node = node.get__child(text[index])
            i += 1
        return -1, None

    def replace_bad_word(self,text,offset=0,mark='*'):
        if not isinstance(text, str) or offset >= len(text):
            raise Exception("%s is not a string" % str(str))
        i = offset
        text = unicode(text[offset:], 'utf-8')
        li = list(text)
        for ch in text[offset:]:
            node = self.__root
            index = i
            node = node.get__child(ch)
            while node is not None:
                if node.is__end():
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

if len("/share/abc.config") < 1:
    raise Exception("provide at least one parameter")
check = TrieCheck()
load("/share/abc.config", check)


def main(argv):
    print "aaa", argv
    if len(argv) < 2:
        raise Exception("provide at least one parameter")
    check = TrieCheck()
    load(argv[1], check)
    # print check.replace_bad_word('我喜欢毛泽东哈遺囑哈，邓明明，我草你大爷。你老味[|]吊佢佬未[|]糙雞掰[|]')


if __name__ == "__main__":

    f1 = open("/share/mgc.txt", 'r')
    f2 = open("/share/abc.config", 'w')
    b = ''
    for a in f1.read():
        if a == '[' or a == ']':
            continue
        if a == '|':
            f2.write('\n')
            continue
        f2.write(a)
    f1.close()
    f2.close()
    main([1, "/share/abc.config"])
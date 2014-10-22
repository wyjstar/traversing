#-*- coding:utf-8 -*-
"""
Created on 2012-7-10
memcached 关系对象\n
通过key键的名称前缀来建立\n
各个key-value 直接的关系\n
@author: lan (www.9miao.com)
"""

import cPickle
from serializer import Serializer


class MemObject(Serializer):
    """memcached 关系对象,可以将一个对象的属性值记录到memcached中。
    
    >>> class Mcharacter(MemObject):
    >>>    def __init__(self,pid,name,mc):
    >>>        MemObject.__init__(self, name, mc)
    >>>        self.id = pid
    >>>        self.level = 0
    >>>        self.profession = 0
    >>>        self.nickname = u''
    >>>        self.guanqia = 1000
    >>> mcharacter = Mcharacter(1,'character:1',mclient)
    >>> mcharacter.name='lan'
    >>> mcharacter.insert()
    >>> mcharacter.get('nickname')
    lan
    """

    def __init__(self, name, mc):
        """
        @param name: str 对象的名称\n
        @param _lock: int 对象锁  为1时表示对象被锁定无法进行修改\n
        """
        self._client = mc
        self._name = name
        self._lock = 0

    def produceKey(self, keyname):
        """重新生成key
        """
        if isinstance(keyname, basestring):
            return ''.join([self._name, ':', keyname])
        else:
            raise "type error"

    def locked(self):
        """检测对象是否被锁定
        """
        key = self.produceKey('_lock')
        lock = self._client.get(key)
        if lock:
            lock = int(lock)
        return lock

    def lock(self):
        """锁定对象
        """
        key = self.produceKey('_lock')
        self._client.set(key, 1)

    def release(self):
        """释放锁
        """
        key = self.produceKey('_lock')
        self._client.set(key, 0)

    def get(self, key):
        """获取对象值
        """
        produce_key = self.produceKey(key)
        value = self._client.get(produce_key)

        if value and key == '_state':
            value = int(value)

        if value and key == 'data':
            value = self.loads(cPickle.loads(value))
        return value

    def get_multi(self, keys):
        """一次获取多个key的值
        @param keys: list(str) key的列表
        """
        keynamelist = [self.produceKey(keyname) for keyname in keys]
        olddict = self._client.get_multi(keynamelist)
        newdict = dict(zip([keyname.split(':')[-1] for keyname in olddict.keys()],
                           olddict.values()))

        if ('_state' in newdict) and newdict['_state']:
            newdict['_state'] = int(newdict['_state'])

        if ('data' in newdict) and newdict['data']:
            newdict['data'] = self.loads(cPickle.loads(newdict['data']))

        return newdict

    def update(self, key, values):
        """修改对象的值
        """
        if self.locked():
            return False
        produce_key = self.produceKey(key)
        if values and key == 'data':
            values = cPickle.dumps(self.dumps(values))

        return self._client.set(produce_key, values)

    def update_multi(self, mapping):
        """同时修改多个key值
        """
        if self.locked():
            return False

        if ('data' in mapping) and mapping['data']:
            mapping['data'] = cPickle.dumps(self.dumps(dict(mapping['data'])))

        newmapping = dict(zip([self.produceKey(keyname) for keyname in mapping.keys()],
                              mapping.values()))
        return self._client.set_multi(newmapping)

    def mdelete(self):
        """删除memcache中的数据
        """
        nowdict = dict(self.__dict__)
        del nowdict['_client']
        keys = nowdict.keys()
        keys = [self.produceKey(key) for key in keys]
        self._client.delete_multi(keys)

    def incr(self, key, delta):
        """自增
        """
        key = self.produceKey(key)
        return self._client.incr(key, delta)

    def insert(self):
        """插入对象记录
        """
        nowdict = dict(self.__dict__)
        del nowdict['_client']
        if ('data' in nowdict) and nowdict['data']:
            nowdict['data'] = cPickle.dumps(self.dumps(dict(nowdict['data'])))
        newmapping = dict(zip([self.produceKey(keyname) for keyname in nowdict.keys()],
                              nowdict.values()))
        self._client.set_multi(newmapping)

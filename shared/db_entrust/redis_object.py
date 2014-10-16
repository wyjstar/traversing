#-*- coding:utf-8 -*-
"""
created by server on 14-5-28下午12:14.
"""

import cPickle
from shared.db_entrust.serializer import Serializer


class RedisObject(Serializer):
    """redis 关系对象,可以将一个对象的属性值记录到redis中。

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

    def __init__(self, name, mc, lock=0):
        """
        @param  name: str 对象的名称\n
        @param  lock: int 对象锁  为1时表示对象被锁定无法进行修改\n
        """
        super(RedisObject, self).__init__()
        self._client = mc.get_connection(name)
        self._name = name
        self._lock = lock

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
        olddict = self._client.mget(keynamelist)
        newdict = dict(zip([keyname.split(':')[-1] for keyname in keynamelist], olddict))

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
        return self._client.mset(newmapping)

    def mdelete(self):
        """删除redis中的数据
        """
        nowdict = dict(self.__dict__)
        del nowdict['_client']
        keys = nowdict.keys()
        keys = [self.produceKey(key) for key in keys]
        for key in keys:
            self._client.delete(key)

    def incr(self, key, delta):
        """自增
        """
        key = self.produceKey(key)
        incr_value = self._client.incr(key, delta)
        return int(incr_value)

    def insert(self):
        """插入对象记录
        """
        nowdict = dict(self.__dict__)
        del nowdict['_client']
        if ('data' in nowdict) and nowdict['data']:
            nowdict['data'] = cPickle.dumps(self.dumps(dict(nowdict['data'])))
        newmapping = dict(zip([self.produceKey(keyname) for keyname in nowdict.keys()],
                              nowdict.values()))
        self._client.mset(newmapping)
# -*- coding:utf-8 -*-
"""
created by server on 14-5-28下午12:14.
"""

import cPickle


class RedisObject(object):
    """redis 关系对象,可以将一个对象的属性值记录到redis中"""

    def __init__(self, name, mc):
        super(RedisObject, self).__init__()
        self._client = mc.get_connection(name)
        self._name = name

    def produceKey(self, keyname):
        """重新生成key
        """
        if isinstance(keyname, basestring):
            return ''.join([self._name, ':', keyname])
        else:
            raise "type error"

    def get(self, key):
        """获取对象值
        """
        produce_key = self.produceKey(key)
        value = self._client.get(produce_key)

        if value:
            value = cPickle.loads(value)
        return value

    def get_multi(self, keys):
        """一次获取多个key的值
        @param keys: list(str) key的列表
        """
        keynamelist = [self.produceKey(keyname) for keyname in keys]
        olddict = self._client.mget(keynamelist)
        newdict = dict(zip([keyname.split(':')[-1] for keyname in keynamelist], olddict))
        result = {}
        for k, v in newdict.items():
            result[k] = cPickle.loads(v) if v else v
        print result, '9'*8
        print

        return result

    def update(self, key, values):
        """修改对象的值
        """
        produce_key = self.produceKey(key)

        return self._client.set(produce_key, cPickle.dumps(values))

    def update_multi(self, mapping):
        """同时修改多个key值
        """
        newmapping = dict(zip([self.produceKey(keyname) for keyname in mapping.keys()],
                              mapping.values()))
        for k, v in newmapping.items():
            self._client.set(k, cPickle.dumps(v))

        return True

    def mdelete(self):
        """删除redis中的数据 """
        nowdict = dict(self.__dict__)
        del nowdict['_client']
        keys = nowdict.keys()
        keys = [self.produceKey(key) for key in keys]
        for key in keys:
            self._client.delete(key)

    def insert(self):
        """插入对象记录 """
        nowdict = dict(name=self._name)
        if hasattr(self, 'data'):
            nowdict.update(self.data)
        newmapping = dict(zip([self.produceKey(keyname) for keyname in nowdict.keys()],
                              nowdict.values()))
        print newmapping
        for k, v in newmapping.items():
            self._client.set(k, cPickle.dumps(v))

    def sadd(self, key, member):
        self._client.sadd(key, member)

    def srem(self, key, member):
        self._client.srem(key, member)

    def scard(self, key):
        self._client.scard(key)

    def smem(self, key):
        self._client.smembers(key)

    def supdate(self, key, old_member, new_member):
        self.srem(key, old_member)
        self.sadd(key, new_member)

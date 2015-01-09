# -*- coding:utf-8 -*-
"""
created by server on 14-5-28下午4:41.
"""
from gfirefly.dbentrust.redis_manager import redis_manager
import cPickle


class RedisObject(object):
    def __init__(self, name):
        self._name = name
        self._client = redis_manager.get_connection(name)

    def getObj(self, pk):
        mm = RedisObject(self._name + ':%s' % pk)
        return mm

    def new(self, data):
        newdict = {}
        for k, v in data.items():
            newdict[k] = cPickle.dumps(v)
        self._client.hmset(self._name, newdict)

    def produceKey(self, keyname):
        if isinstance(keyname, basestring):
            return ''.join([self._name, ':', keyname])
        else:
            raise "type error"

    def exists(self):
        return self._client.exists(self._name) == 1

    def hgetall(self):
        newdict = self._client.hgetall(self._name)
        result = {}
        for k, v in newdict.items():
            result[k] = cPickle.loads(v)
        return result

    def get(self, field):
        value = self._client.hget(self._name, field)
        return cPickle.loads(value) if value else value

    def get_multi(self, fiedls):
        olddict = self._client.hmget(self._name, fiedls)
        newdict = dict(zip(fiedls, olddict))
        result = {}
        for k, v in newdict.items():
            result[k] = cPickle.loads(v) if v else v
        return result

    def update(self, field, values):
        return self._client.hset(self._name, field, cPickle.dumps(values))

    def update_multi(self, mapping):
        newdict = {}
        for k, v in mapping.items():
            newdict[k] = cPickle.dumps(v)
        self._client.hmset(self._name, newdict)
        return True

    def mdelete(self):
        return self._client.hdel(self._name)

    def sadd(self, key, member):
        produce_key = self.produceKey(key)
        member = cPickle.dumps(member)
        return self._client.sadd(produce_key, member) == 1

    def srem(self, key, member):
        produce_key = self.produceKey(key)
        member = cPickle.dumps(member)
        return self._client.srem(produce_key, member) == 1

    def scard(self, key):
        produce_key = self.produceKey(key)
        return self._client.scard(produce_key) == 1

    def smem(self, key):
        produce_key = self.produceKey(key)
        result = []
        datas = self._client.smembers(produce_key)
        for data in datas:
            result.append(cPickle.loads(data))
        return result

    def sismem(self, key, member):
        produce_key = self.produceKey(key)
        result = self._client.sismember(produce_key, cPickle.dumps(member))
        return result == 1

    def supdate(self, key, old_member, new_member):
        produce_key = self.produceKey(key)
        if self.srem(produce_key, old_member) != 1:
            return False
        if self.sadd(produce_key, new_member) != 1:
            return False
        return True

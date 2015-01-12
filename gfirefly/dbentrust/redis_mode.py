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
        print self._name
        return self._client.exists(self._name) == 1

    def hgetall(self):
        newdict = self._client.hgetall(self._name)
        result = {}
        for k, v in newdict.items():
            result[k] = cPickle.loads(v)
        return result

    def hget(self, field):
        value = self._client.hget(self._name, field)
        return cPickle.loads(value) if value else value

    def hmget(self, fiedls):
        olddict = self._client.hmget(self._name, fiedls)
        newdict = dict(zip(fiedls, olddict))
        result = {}
        for k, v in newdict.items():
            result[k] = cPickle.loads(v) if v else v
        return result

    def hset(self, field, values):
        return self._client.hset(self._name, field, cPickle.dumps(values))

    def hmset(self, mapping):
        newdict = {}
        for k, v in mapping.items():
            newdict[k] = cPickle.dumps(v)
        self._client.hmset(self._name, newdict)
        return True

    def hdel(self):
        return self._client.hdel(self._name)

    def hkeys(self):
        val = self._client.hkeys(self._name)
        return val

    def hexists(self, field):
        val = self._client.hexists(self._name, field)
        return val == 1

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

    def set(self, key, value):
        produce_key = self.produceKey(str(key))
        self._client.set(produce_key, cPickle.dumps(value))

    def get(self, key):
        produce_key = self.produceKey(key)
        ret = self._client.get(produce_key)
        return cPickle.loads(ret) if ret else ret

    def delete(self, key):
        produce_key = self.produceKey(key)
        self._client.delete(produce_key)

    def zscore(self, label, key):
        produce_key = self.produceKey(label)
        score = self._client.zscore(produce_key, key)
        return score

    def zadd(self, label, k, v):
        produce_key = self.produceKey(label)
        return self._client.zadd(produce_key, v, k)

    def zget(self, label, k):
        score = 0
        produce_key = self.produceKey(label)
        score = self._client.zscore(produce_key, k)
        return score

    def ztotal(self, label):
        produce_key = self.produceKey(label)
        total = self._client.zcard(produce_key)
        return total

    def zrem(self, label, k):
        produce_key = self.produceKey(label)
        rem = self._client.zrem(produce_key, k)
        return rem

    def zrank(self, label, k):
        produce_key = self.produceKey(label)
        rank = self._client.zrank(produce_key, k)
        return rank

    def zrevrank(self, label, k):
        produce_key = self.produceKey(label)
        rank = self._client.zrevrank(produce_key, k)
        return rank

    def zincrby(self, label, k, v):
        produce_key = self.produceKey(label)
        val = self._client.zincrby(produce_key, k, v)
        return val

    def znear(self, label, k, front, back):
        produce_key = self.produceKey(label)
        print 'znear1', label, k, type(label), type(k)
        index = self._client.zrevrank(produce_key, k)
        print 'znear3', index
        if index is not None:
            index = 20
        _min = index - front
        _max = index + back
        if index < front:
            _min = 0
            _max = front + back
        print 'znear2', label, _min, type(_min), _max, type(_max)
        _range = self._client.zrevrange(produce_key, _min, _max)
        return _range

    def zremrangebyrank(self, label, m, n):
        produce_key = self.produceKey(label)
        return self._client.zremrangebyrank(produce_key, m, n)

    def zcount(self, label, m, n):
        produce_key = self.produceKey(label)
        return self._client.zcount(produce_key, m, n)

    def zrevrange(self, label, start, end, withscores=False):
        produce_key = self.produceKey(label)
        return self._client.zrevrange(produce_key, start, end, withscores)

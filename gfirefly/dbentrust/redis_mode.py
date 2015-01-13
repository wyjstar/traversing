# -*- coding:utf-8 -*-
"""
created by server on 14-5-28下午4:41.
"""
from gfirefly.dbentrust.redis_manager import redis_manager
import cPickle


class RedisObject(object):
    def __init__(self, name):
        self._name = name

    def getObj(self, pk):
        mm = RedisObject(self._name + ':%s' % pk)
        return mm

    def new(self, data):
        newdict = {}
        for k, v in data.items():
            newdict[k] = cPickle.dumps(v)
        client = redis_manager.get_connection(self._name)
        client.hmset(self._name, newdict)

    def produceKey(self, keyname):
        if isinstance(keyname, basestring):
            return ''.join([self._name, ':', keyname])
        else:
            raise "type error"

    def exists(self):
        print self._name
        client = redis_manager.get_connection(self._name)
        return client.exists(self._name) == 1

    def hgetall(self):
        client = redis_manager.get_connection(self._name)
        newdict = client.hgetall(self._name)
        result = {}
        for k, v in newdict.items():
            result[k] = cPickle.loads(v)
        return result

    def hget(self, field):
        client = redis_manager.get_connection(self._name)
        value = client.hget(self._name, field)
        return cPickle.loads(value) if value else value

    def hmget(self, fiedls):
        client = redis_manager.get_connection(self._name)
        olddict = client.hmget(self._name, fiedls)
        newdict = dict(zip(fiedls, olddict))
        result = {}
        for k, v in newdict.items():
            result[k] = cPickle.loads(v) if v else v
        return result

    def hset(self, field, values):
        client = redis_manager.get_connection(self._name)
        return client.hset(self._name, field, cPickle.dumps(values)) == 1

    def hsetnx(self, field, values):
        client = redis_manager.get_connection(self._name)
        result = client.hsetnx(self._name, field, cPickle.dumps(values))
        return result == 1

    def hmset(self, mapping):
        newdict = {}
        for k, v in mapping.items():
            newdict[k] = cPickle.dumps(v)
        client = redis_manager.get_connection(self._name)
        return client.hmset(self._name, newdict) == 1

    def hdel(self):
        client = redis_manager.get_connection(self._name)
        return client.hdel(self._name) == 1

    def hkeys(self):
        client = redis_manager.get_connection(self._name)
        val = client.hkeys(self._name)
        return val == 1

    def hexists(self, field):
        client = redis_manager.get_connection(self._name)
        val = client.hexists(self._name, field)
        return val == 1

    def sadd(self, key, member):
        produce_key = self.produceKey(key)
        member = cPickle.dumps(member)
        client = redis_manager.get_connection(produce_key)
        return client.sadd(produce_key, member) == 1

    def srem(self, key, member):
        produce_key = self.produceKey(key)
        member = cPickle.dumps(member)
        client = redis_manager.get_connection(produce_key)
        return client.srem(produce_key, member) == 1

    def scard(self, key):
        produce_key = self.produceKey(key)
        client = redis_manager.get_connection(produce_key)
        return client.scard(produce_key) == 1

    def smem(self, key):
        produce_key = self.produceKey(key)
        result = []
        client = redis_manager.get_connection(produce_key)
        datas = client.smembers(produce_key)
        for data in datas:
            result.append(cPickle.loads(data))
        return result

    def sismem(self, key, member):
        produce_key = self.produceKey(key)
        client = redis_manager.get_connection(produce_key)
        result = client.sismember(produce_key, cPickle.dumps(member))
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
        client = redis_manager.get_connection(produce_key)
        client.set(produce_key, cPickle.dumps(value))

    def setnx(self, key, value):
        produce_key = self.produceKey(str(key))
        client = redis_manager.get_connection(produce_key)
        client.setnx(produce_key, cPickle.dumps(value))

    def get(self, key):
        produce_key = self.produceKey(key)
        client = redis_manager.get_connection(produce_key)
        ret = client.get(produce_key)
        return cPickle.loads(ret) if ret else ret

    def delete(self, key):
        produce_key = self.produceKey(key)
        client = redis_manager.get_connection(produce_key)
        return client.delete(produce_key) == 1

    def zscore(self, label, key):
        produce_key = self.produceKey(label)
        client = redis_manager.get_connection(produce_key)
        score = client.zscore(produce_key, key)
        return score

    def zadd(self, label, k, v):
        produce_key = self.produceKey(label)
        client = redis_manager.get_connection(produce_key)
        return client.zadd(produce_key, v, k) == 1

    def zget(self, label, k):
        score = 0
        produce_key = self.produceKey(label)
        client = redis_manager.get_connection(produce_key)
        score = client.zscore(produce_key, k)
        return score

    def ztotal(self, label):
        produce_key = self.produceKey(label)
        client = redis_manager.get_connection(produce_key)
        total = client.zcard(produce_key)
        return total

    def zrem(self, label, k):
        produce_key = self.produceKey(label)
        client = redis_manager.get_connection(produce_key)
        rem = client.zrem(produce_key, k)
        return rem == 1

    def zrank(self, label, k):
        produce_key = self.produceKey(label)
        client = redis_manager.get_connection(produce_key)
        rank = client.zrank(produce_key, k)
        return rank

    def zrevrank(self, label, k):
        produce_key = self.produceKey(label)
        client = redis_manager.get_connection(produce_key)
        rank = client.zrevrank(produce_key, k)
        return rank

    def zincrby(self, label, k, v):
        produce_key = self.produceKey(label)
        client = redis_manager.get_connection(produce_key)
        val = client.zincrby(produce_key, k, v)
        return val

    def znear(self, label, k, front, back):
        produce_key = self.produceKey(label)
        print 'znear1', label, k, type(label), type(k)
        client = redis_manager.get_connection(produce_key)
        index = client.zrevrank(produce_key, k)
        print 'znear3', index
        if index is not None:
            index = 20
        _min = index - front
        _max = index + back
        if index < front:
            _min = 0
            _max = front + back
        print 'znear2', label, _min, type(_min), _max, type(_max)
        client = redis_manager.get_connection(produce_key)
        _range = client.zrevrange(produce_key, _min, _max)
        return _range

    def zremrangebyrank(self, label, m, n):
        produce_key = self.produceKey(label)
        client = redis_manager.get_connection(produce_key)
        return client.zremrangebyrank(produce_key, m, n)

    def zcount(self, label, m, n):
        produce_key = self.produceKey(label)
        client = redis_manager.get_connection(produce_key)
        return client.zcount(produce_key, m, n)

    def zrevrange(self, label, start, end, withscores=False):
        produce_key = self.produceKey(label)
        client = redis_manager.get_connection(produce_key)
        return client.zrevrange(produce_key, start, end, withscores)

    def zremrangebyscore(self, m, n):
        client = redis_manager.get_connection(self._name)
        return client.zremrangebyscore(self._name, m, n)

    def zrange(self, m, n):
        client = redis_manager.get_connection(self._name)
        return client.zrange(self._name, m, n)

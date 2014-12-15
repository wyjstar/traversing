# -*- coding: utf-8 -*-
'''
Created on 2014-11-28

@author: hack
'''
from gfirefly.server.logobj import logger
from gfirefly.dbentrust.redis_client import redis_client

class Ranking(object):
    def __init__(self):
        self.redis = redis_client.conn
        
    @classmethod
    def instance(cls):
        return cls()
    
    def set(self, k, v):
        try:
            self.redis.set(k, v)
        except Exception, e:
            logger.error('redis set error : %s' % e)
            
    def get(self, k):
        try:
            ret = self.redis.get(k)
        except Exception, e:
            logger.error('redis get error : %s' % e)
        return ret
    
    def delete(self, k):
        try:
            self.redis.delete(k)
        except Exception, e:
            logger.error('redis delete error : %s' % e)
    
    def zscore(self, label, k):
        try:
            score = self.redis.zscore(label, k)
        except Exception, e:
            logger.error('redis score error : %s' % e)
        return score
    
    def zadd(self, label, k, v):
        try:
            self.redis.zadd(label, k, v)
        except Exception, e:
            logger.error('redis zadd error : %s' % e)

    def zget(self, label, k):
        try:
            score = self.redis.zscore(label, k)
        except Exception, e:
            logger.error('redis zget error : %s' % e)
        return score
    
    def ztotal(self, label):
        try:
            total = self.redis.zcard(label)
        except Exception, e:
            logger.error('redis zcard error : %s' % e)
        return total
    
    def zrem(self, label, k):
        try:
            rem = self.redis.zrem(label, k)
        except Exception, e:
            logger.error('redis zrem error : %s' % e)
        return rem
    
    def zrank(self, label, k):
        try:
            rank = self.redis.zrank(label, k)
        except Exception, e:
            logger.error('redis zrank error : %s' % e)
        return rank
    
    def zrevrank(self, label, k):
        try:
            rank = self.redis.zrevrank(label, k)
        except Exception, e:
            logger.error('redis zrevrank error : %s' % e)
        return rank
    
    def zincrby(self, label, k, v):
        try:
            val = self.redis.zincrby(label, k, v)
        except Exception, e:
            logger.error('redis zincrby error : %s' % e)
        return val
    
    def znear(self, label, k, front, back):
        
        try:
            index = self.redis.zrevrank(label, k)
            _min = index - front
            _max = index + back
            if index < front:
                _min = 0
                _max = front + back
            _range = self.redis.zrevrange(label, _min, _max)
        except Exception, e:
            logger.error('redis zrevrange error : %s' % e)
        return _range
    
    def hset(self, label, k, v):
        try:
            val = self.redis.hset(label, k, v)
            return val
        except Exception, e:
            logger.error('redis hset error : %s' % e)
            return None
        
    def hget(self, label, k):
        try:
            val = self.redis.hget(label, k)
            return val
        except Exception, e:
            logger.error('redis hget error : %s' % e)
            return None
        
    def hkeys(self, label):
        try:
            val = self.redis.hkeys(label)
            return val
        except Exception, e:
            logger.error('redis hkeys error : %s' % e)
            return None
        
    def hdel(self, label, *keys):
        try:
            val = self.redis.hdel(label, keys)
            return val
        except Exception, e:
            logger.error('redis hdel error : %s' % e)
            return None

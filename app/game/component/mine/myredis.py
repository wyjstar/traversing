# -*- coding: utf-8 -*-
'''
Created on 2014-11-28

@author: hack
'''
from gfirefly.server.logobj import logger
from gfirefly.dbentrust.redis_mode import RedisObject


tb_ranking = RedisObject('tb_character_info')


class Ranking(object):
    def __init__(self):
        pass

    @classmethod
    def instance(cls):
        return cls()

    def set(self, k, v):
        try:
            tb_ranking.set(k, v)
        except Exception, e:
            logger.error('redis set error : %s' % e)

    def get(self, k):
        try:
            ret = tb_ranking.get(k)
        except Exception, e:
            logger.error('redis get error : %s' % e)
        return ret

    def delete(self, k):
        try:
            tb_ranking.delete(k)
        except Exception, e:
            logger.error('redis delete error : %s' % e)

    def zscore(self, label, k):
        try:
            score = tb_ranking.zscore(label, k)
        except Exception, e:
            logger.error('redis score error : %s' % e)
        return score

    def zadd(self, label, k, v):
        try:
            tb_ranking.zadd(label, v, k)
        except Exception, e:
            logger.error('redis zadd error : %s' % e)

    def zget(self, label, k):
        score = 0
        try:
            score = tb_ranking.zscore(label, k)
        except Exception, e:
            logger.error('redis zget error : %s' % e)
        return score

    def ztotal(self, label):
        try:
            total = tb_ranking.zcard(label)
        except Exception, e:
            logger.error('redis zcard error : %s' % e)
        return total

    def zrem(self, label, k):
        try:
            rem = tb_ranking.zrem(label, k)
        except Exception, e:
            logger.error('redis zrem error : %s' % e)
        return rem

    def zrank(self, label, k):
        try:
            rank = tb_ranking.zrank(label, k)
        except Exception, e:
            logger.error('redis zrank error : %s' % e)
        return rank

    def zrevrank(self, label, k):
        try:
            rank = tb_ranking.zrevrank(label, k)
        except Exception, e:
            logger.error('redis zrevrank error : %s' % e)
        return rank

    def zincrby(self, label, k, v):
        try:
            val = tb_ranking.zincrby(label, k, v)
        except Exception, e:
            logger.error('redis zincrby error : %s' % e)
        return val

    def znear(self, label, k, front, back):

        try:
            print 'znear1', label, k, type(label), type(k)
            index = tb_ranking.zrevrank(label, k)
            print 'znear3', index
            if index is None:
                index = 20
            _min = index - front
            _max = index + back
            if index < front:
                _min = 0
                _max = front + back
            print 'znear2', label, _min, type(_min), _max, type(_max)
            _range = tb_ranking.zrevrange(label, _min, _max)
        except Exception, e:
            logger.error('redis zrevrange error : %s' % e)
        return _range

    def hset(self, label, k, v):
        try:
            val = tb_ranking.hset(label, k, v)
            return val
        except Exception, e:
            logger.error('redis hset error : %s' % e)
            return None

    def hget(self, label, k):
        try:
            val = tb_ranking.hget(label, k)
            return val
        except Exception, e:
            logger.error('redis hget error : %s' % e)
            return None

    def hkeys(self, label):
        try:
            val = tb_ranking.hkeys(label)
            return val
        except Exception, e:
            logger.error('redis hkeys error : %s' % e)
            return None

    def hdel(self, label, *keys):
        try:
            val = tb_ranking.hdel(label, keys)
            return val
        except Exception, e:
            logger.error('redis hdel error : %s' % e)
            return None

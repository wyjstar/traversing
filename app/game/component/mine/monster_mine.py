# -*- coding: utf-8 -*-
'''
Created on 2014-11-28

@author: hack
'''
import cPickle
from myredis import Ranking

class MineOpt(object):
    redis = Ranking.instance()
    def __init__(self):
        pass
    
    @classmethod
    def add_mine(cls, uid, mid, data):
        v = cPickle.dumps(data)
        label = 'mine.%s' % uid
        cls.redis.hset(label, mid, v)
        
    @classmethod
    def rem_mine(cls, uid, mid):
        label = 'mine.%s' % uid
        cls.redis.hdel(label, mid)
        
    @classmethod
    def get_mine(cls, uid, mid):
        label = 'mine.%s' % uid
        ret = cls.redis.hget(label, mid)
        return cPickle.loads(ret)
    
    @classmethod
    def lock(cls, uid):
        label = 'mine.lock'
        val = cls.redis.zincrby(label, uid, 1)
        return val
    
    @classmethod
    def unlock(cls, uid):
        label = 'mine.lock'
        cls.redis.zadd(label, uid, 0)
        
    @classmethod
    def update(cls, label, k, v):
        """
        label : "user_level","sword",玩家等级，团队战力
        """
        old_score = cls.redis.zget(label, k)
        if old_score:
            if old_score >= v:
                return
        cls.redis.zadd(label, k, v)

    @classmethod
    def rand_user(cls, label, k, front, back):
        """
        label : "user_level","sword",玩家等级，团队战力
        """
        ret = cls.redis.znear(label, k, front, back)
        return ret
    
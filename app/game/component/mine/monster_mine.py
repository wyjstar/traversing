# -*- coding: utf-8 -*-
'''
Created on 2014-11-28

@author: hack
'''
from gfirefly.dbentrust.redis_mode import RedisObject


class MineOpt(object):
    rank = RedisObject('mineopt')

    def __init__(self):
        pass

    @classmethod
    def add_mine(cls, uid, mid, data):
        label = 'mine.%s' % uid
        # print 'add_mine', label, mid
        rdobj = cls.rank.getObj(label)
        rdobj.hset(mid, 1)

        # print cls.rank.myhkeys(label)
        label = 'mine'
        rdobj = cls.rank.getObj(label)
        rdobj.hset(mid, data)

    @classmethod
    def rem_mine(cls, mid):
        label = 'mine'
        rdobj = cls.rank.getObj(label)
        result = rdobj.hdel(mid)
        if not result:
            print 'rem_mine error'

    @classmethod
    def get_mine(cls, mid):
        label = 'mine'
        rdobj = cls.rank.getObj(label)
        ret = rdobj.hget(mid)
        # print 'get_mine------', label, mid, cPickle.loads(ret)
        return ret

    @classmethod
    def get_user_mines(cls, uid):
        label = 'mine.%s' % uid
        # print 'get_user_mines', label
        rdobj = cls.rank.getObj(label)
        mids = rdobj.hkeys()
        return mids

    @classmethod
    def lock(cls, tid):
        label = 'mine.lock'
        val = cls.rank.zincrby(label, tid, 1)
        return val

    @classmethod
    def unlock(cls, tid):
        label = 'mine.lock'
        cls.rank.zadd(label, 0, tid)

    @classmethod
    def update(cls, label, k, v):
        """
        label : "sword",玩家等级，团队战力
        """
        old_score = cls.rank.zget(label, k)
        if old_score:
            if old_score >= v:
                return
        # print 'update', label, k, v
        cls.rank.zadd(label, k, v)

    @classmethod
    def updata_level(cls, label, uid, s, t):
        """
        label = 'user_level'
        """
        src = '%s.%s' % (label, s)
        dst = '%s.%s' % (label, t)
        # print 'updata_level', src, dst
        try:
            cls.rank.smove(src, dst, uid)
        except Exception, e:
            print 'update_level, error', e

    @classmethod
    def asadd(cls, label, uid, grade):
        key = '%s.%s' % (label, grade)
        # print 'asadd', key
        cls.rank.sadd(key, uid)

    @classmethod
    def rand_level(cls, label, front, back):
        """
        """
        users = []
        for level in range(front, back):
            mem = '%s.%s' % (label, level)
            # print 'rand_level', mem
            try:
                ret = cls.rank.smem(mem)
                # print 'rand_level', ret
                users.extend(ret)
            except Exception, e:
                print 'rank_level', e
        return users

#     @classmethod
#     def rand_user(cls, label, k, front, back):
#         """
#         label : sword",玩家等级，团队战力
#         """
#         ret = cls.rank.znear(label, k, front, back)
#         return ret

    @classmethod
    def get_user(cls, label, k):
        """
        label : "user_level","sword",玩家等级，团队战力
        """
        try:
            ret = cls.rank.zget(label, k)
        except Exception, e:
            print e
            return 1
        return ret

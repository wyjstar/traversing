# -*- coding: utf-8 -*-
"""
Created on 2014-11-28

@author: hack
"""
from gfirefly.dbentrust.redis_mode import RedisObject

tb_rank = RedisObject('mineopt')


class MineOpt(object):
    def __init__(self):
        pass

    @classmethod
    def add_mine(cls, uid, mid, data):
        label = 'mine.%s' % uid
        rdobj = tb_rank.getObj(label)
        rdobj.hset(mid, 1)

        label = 'mine'
        rdobj = tb_rank.getObj(label)
        rdobj.hset(mid, data)

    @classmethod
    def rem_mine(cls, mid):
        label = 'mine'
        rdobj = tb_rank.getObj(label)
        result = rdobj.hdel(mid)
        if not result:
            print 'rem_mine error'

    @classmethod
    def get_mine(cls, mid):
        label = 'mine'
        rdobj = tb_rank.getObj(label)
        ret = rdobj.hget(mid)
        return ret

    @classmethod
    def get_user_mines(cls, uid):
        label = 'mine.%s' % uid
        rdobj = tb_rank.getObj(label)
        mids = rdobj.hkeys()
        return mids

    @classmethod
    def lock(cls, tid):
        label = 'mine.lock'
        val = tb_rank.zincrby(label, tid, 1)
        return val

    @classmethod
    def unlock(cls, tid):
        label = 'mine.lock'
        tb_rank.zadd(label, 0, tid)

    @classmethod
    def update(cls, label, k, v):
        """ label : "sword",玩家等级，团队战力 """
        old_score = tb_rank.zget(label, k)
        if old_score:
            if old_score >= v:
                return
        tb_rank.zadd(label, k, v)

    @classmethod
    def updata_level(cls, label, uid, s, t):
        """ label = 'user_level' """
        src = '%s.%s' % (label, s)
        dst = '%s.%s' % (label, t)
        try:
            tb_rank.smove(src, dst, uid)
        except Exception, e:
            print 'update_level, error', e

    @classmethod
    def asadd(cls, label, uid, grade):
        key = '%s.%s' % (label, grade)
        tb_rank.sadd(key, uid)

    @classmethod
    def rand_level(cls, label, front, back):
        result = []
        for level in range(front, back):
            mem = '%s.%s' % (label, level)
            # print 'rand_level', mem
            try:
                ret = tb_rank.smem(mem)
                # print 'rand_level', ret
                result.extend(ret)
            except Exception, e:
                print 'rank_level', e
        return result

    @classmethod
    def get_user(cls, label, k):
        """ label : "user_level","sword",玩家等级，团队战力 """
        try:
            ret = tb_rank.zget(label, k)
        except Exception, e:
            print e
            return 1
        return ret

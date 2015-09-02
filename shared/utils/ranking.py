# -*- coding:utf-8 -*-
"""
created by server on 14-7-31下午3:04.
"""
from gfirefly.dbentrust.redis_mode import RedisObject

# 调试开关
_DEBUG = False

# 删除缓冲
BUF_SIZE = 128
tb_rank = RedisObject('tb_rank')


class Ranking:
    _instances = {}

    def __init__(self, label, rank_len):
        self.label = label
        self.rank_len = rank_len

    @classmethod
    def instance(cls, label):
        return cls._instances[label]

    @classmethod
    def init(cls, label, rank_len):
        instance = None
        if label in cls._instances:
            instance = cls._instances[label]

        if instance is None:
            instance = cls(label, rank_len)
            cls._instances[label] = instance

        return instance

    def add(self, id, value):
        tb = tb_rank.getObj(self.label)
        if _DEBUG:
            print "[DEBUG] Ranking.do_add: rank:", self.label, " id:", id, " value", value

        rank_len = self.rank_len
        tb.zadd(value, id)
        len = tb.zcount('-inf', '+inf')
        if (len - BUF_SIZE) > rank_len:
            tb.zremrangebyrank(0, (len - rank_len))
            if _DEBUG:
                len = tb.zcount('-inf', '+inf')
                print "[DEBUG] Ranking.do_add: do remove due to too long, now len =", len

    def get(self, start=1, end=1):
        """
        获取排名：start-end
        """
        tb = tb_rank.getObj(self.label)
        print start, end, tb.zcount('-inf', '+inf')
        return tb.zrevrange(start-1, end-1, withscores=True)

    def get_rank_no(self, key):
        """
        获取某个key的名次
        """
        tb = tb_rank.getObj(self.label)
        rank_no = tb.zrevrank(key)
        if not rank_no and rank_no != 0:
            return 0
        return rank_no + 1

    def get_value(self, key):
        """
        获取某个key的值
        """
        tb = tb_rank.getObj(self.label)
        value = tb.zscore(key)
        if not value:
            return 0
        return value

    def incr_value(self, key, value):
        """
        增加值，根据key
        """
        tb = tb_rank.getObj(self.label)
        return tb.zincrby(key, value)

    def clear_rank(self):
        print "clear_rank========"
        tb = tb_rank.getObj(self.label)
        tb.zremrangebyrank(0, -1)

    def remove(self, key):
        print "remove_rank========", key
        tb = tb_rank.getObj(self.label)
        tb.zrem(key)


def testcase1():
    # redis_client.connect("127.0.0.1", "6379", 0)

    Ranking.init("Level", 20)

    level_instance = Ranking.instance('Level')

    for i in xrange(2000):
        uid = "uid%d" % i
        level = i  # random.randint(1, 10000)

        level_instance.add(uid, level)  # 添加rank数据

    data = level_instance.get(1, 20)  # 获取等级最高的玩家列表(20条)
    print len(data)
    print "Level:", data


if __name__ == '__main__':
    testcase1()

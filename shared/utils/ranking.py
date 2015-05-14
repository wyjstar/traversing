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
        label = self.label
        if _DEBUG:
            print "[DEBUG] Ranking.do_add: rank:", label, " id:", id, " value", value

        rank_len = self.rank_len
        tb_rank.zadd(label, value, id)
        len = tb_rank.zcount(label, '-inf', '+inf')
        if (len - BUF_SIZE) > rank_len:
            tb_rank.zremrangebyrank(label, 0, (len - rank_len))
            if _DEBUG:
                len = tb_rank.zcount(label, '-inf', '+inf')
                print "[DEBUG] Ranking.do_add: do remove due to too long, now len =", len

    def get(self, start=1, end=1):
        """
        获取排名：start-end
        """
        print start, end, tb_rank.zcount(self.label, '-inf', '+inf')
        return tb_rank.zrevrange(self.label, start-1, end-1, withscores=True)

    def get_rank_no(self, key):
        """
        获取某个key的名次
        """
        rank_no = tb_rank.zrevrank(self.label, key)
        if not rank_no and rank_no != 0:
            return 0
        return rank_no + 1

    def get_value(self, key):
        """
        获取某个key的值
        """
        value = tb_rank.zscore(self.label, key)
        if not value:
            return 0
        return value

    def incr_value(self, key, value):
        """
        增加值，根据key
        """
        return tb_rank.zincrby(self.label, key, value)

    def clear_rank(self):
        print "clear_rank========"
        tb_rank.zremrangebyrank(self.label, 0, -1)

    def remove(self, key):
        print "remove_rank========", key
        tb_rank.zremrangebyrank(self.label, key, key)


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

# -*- coding:utf-8 -*-
"""
created by server on 14-7-31下午3:04.
"""

import redis
import random

# 调试开关
_DEBUG = False

# 删除缓冲
BUF_SIZE = 128


def _import_func(func_name):
    components = func_name.split('.')
    if len(components) == 1:
        return globals()[func_name]

    mod = __import__(components[0])
    for comp in components[1:]:
        mod = getattr(mod, comp)
    return mod


class Ranking:
    _instances = {}

    def __init__(self, id, redis_inst, conf, eval_rank_cb):
        self.label = id
        self.redis = redis_inst
        self.conf = conf
        self.eval_rank_cb = eval_rank_cb

    @classmethod
    def instance(cls, label):
        return cls._instances[label]

    @classmethod
    def init(cls, configs, callback=None):
        label = configs['label']
        instance = None
        if cls._instances.has_key(label):
            instance = cls._instances[label]

        if instance is None:
            conf = cls.parse_config(configs)
            if conf is not None:
                instance = cls(conf['label'], \
                               conf['redis'], \
                               conf, \
                               conf['eval_rank_cb'])
                cls._instances[label] = instance

        return instance

    def add(self, uid, **attrs):
        name, value = self.eval_rank_cb(**attrs)
        if name is not None:
            self.do_add(name, uid, value)
        else:
            pass

    def do_add(self, rank, id, value):

        if _DEBUG:
            print "[DEBUG] Ranking.do_add: rank:", rank, " id:", id, " value", value

        rank_len = self.conf['rank_len']
        rc = self.redis.zadd(rank, value, id)
        len = self.redis.zcount(rank, '-inf', '+inf')
        if (len - BUF_SIZE) > rank_len:
            self.redis.zremrangebyrank(rank, 0, (len - rank_len))
            if _DEBUG:
                len = self.redis.zcount(rank, '-inf', '+inf')
                print "[DEBUG] Ranking.do_add: do remove due to too long, now len =", len

    def get(self, rank, len, end=-1):
        start = end - len
        return self.redis.zrange(rank, start, end, withscores=True)

    @classmethod
    def parse_config(cls, configs):

        conf = {}

        conf['label'] = ''
        conf['redis_server'] = ''
        conf['redis_port'] = -1
        conf['redis_db'] = ''
        conf['rank_len'] = 1000

        if configs.has_key('redis_server'):
            conf['label'] = configs['label']

        if configs.has_key('redis_server'):
            conf['redis_server'] = configs['redis_server']

        if configs.has_key('redis_port'):
            conf['redis_port'] = int(configs['redis_port'])
        if configs.has_key('redis_db'):
            conf['redis_db'] = configs['redis_db']

        if configs.has_key('rank_size'):
            conf['rank_len'] = int(configs['rank_size'])

        if configs.has_key('eval_rank_func'):
            conf['eval_rank_cb'] = _import_func(configs['eval_rank_func'])

        try:
            conf['redis'] = redis.StrictRedis(host=conf['redis_server'], \
                                              port=conf['redis_port'], \
                                              db=conf['redis_db'], \
                                              socket_timeout=3)
        except Exception, e:
            print "Ranking.parse_config.Error:", e
            return None

        return conf


# 回调接口
# 返回值格式 (rank_name, score)

def testcase1_eval(**kwargs):
    # 为每个等级建立一个rank，rank的依据是当前时间
    # 实现：搜索指定顶级的玩家列表功能
    import time

    lv = kwargs['level']
    return ('Lv%03d' % lv, time.time())


def testcase1_eval2(**kwargs):
    # 建立等级的rank，玩家根据级别大小排列。
    lv = kwargs['level']
    return ('Level', lv)


def testcase1():
    fifo_configs = {
        'label': 'Fifo',
        'redis_server': '127.0.0.1',
        'redis_port': 6379,
        'redis_db': 0,
        'rank_len': 20,
        'eval_rank_func': 'testcase1_eval',
    }

    level_configs = {
        'label': 'Level',
        'redis_server': '127.0.0.1',
        'redis_port': 6379,
        'redis_db': 0,
        'rank_len': 20,
        'eval_rank_func': 'testcase1_eval2',
    }

    Ranking.init(fifo_configs)
    Ranking.init(level_configs)

    level_instance = Ranking.instance('Level')
    fifo_instance = Ranking.instance('Fifo')

    for i in xrange(10000):
        uid = "uid%d" % i
        level = random.randint(1, 40)

        fifo_instance.add(uid, level=level)  # 添加rank数据
        level_instance.add(uid, level=level)  # 添加rank数据

    data = level_instance.get("Level", 20)  # 获取等级最高的玩家列表(20条)
    print "Level:", data

    data = fifo_instance.get("Lv007", 20)  # 获取等级为7级的玩家列表(20条)
    print "Level:", data


if __name__ == '__main__':
    testcase1()
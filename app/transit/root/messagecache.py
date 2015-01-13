# coding:utf8
"""
created by sphinx on
"""
from gfirefly.dbentrust.redis_mode import RedisObject
import cPickle
import gevent
import uuid

# REDIS_HOST = '127.0.0.1'
# REDIS_POST = 6379
# DB = 1
STAY_TIME = 60 * 60 * 24

pvp_rank = RedisObject('pvp_rank')


class MessageCache:
    """
    """
    def __init__(self):
        pass

    def cache(self, key, character_id, *args, **kw):
        unique_id = uuid.uuid4()
        key_name = 'pvp_' + str(character_id)
        message = cPickle.dumps(dict(topic_id=key,
                                     character_id=character_id,
                                     args=args,
                                     kw=kw,
                                     uid=unique_id))
        score = time.time() + STAY_TIME
        result = pvp_rank.zadd(key_name, score, message)
        if not result:
            print 'cache key:', key, 'char id:', character_id, 'result', result
        # print result

    def get(self, character_id):
        request_key = 'pvp_' + str(character_id)
        pvp_rank.zremrangebyscore(request_key, 0, time.time())
        messages = pvp_rank.zrange(request_key, 0, 10000)

        for message in messages:
            data = cPickle.loads(message)
            yield message, data

    def delete(self, key, message):
        request_key = 'pvp_' + str(key)
        result = pvp_rank.zrem(request_key, message)
        if not result:
            print 'delete key:', key, 'message:', message, 'result', result
        # print result


message_cache = MessageCache()


import time
if __name__ == '__main__':
    message_cache.cache(444, 222, 'hihi', 'go')
    message_cache.cache(44, 222, 'hoho', 'g+')
    for request, key in message_cache.get(222):
        print request
        message_cache.delete(222, key)

    def get_message():
        print 'begin'
        for _ in range(10000):
            message = message_cache.get(222)
        print 'end'

    _time = time.time()
    threads = []
    for _ in range(100):
        threads.append(gevent.spawn(get_message))
    gevent.joinall(threads)
    print 'use time:', time.time() - _time

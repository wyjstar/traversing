# coding:utf8
"""
created by sphinx on
"""
from gfirefly.dbentrust.redis_mode import RedisObject
from gfirefly.server.logobj import logger
import cPickle
import uuid

# REDIS_HOST = '127.0.0.1'
# REDIS_POST = 6379
# DB = 1
MAINTAIN_TIME = 60 * 60 * 24 * 60

_messages = RedisObject('messages')


class MessageCache:
    """
    """
    def __init__(self):
        pass

    def cache(self, key, character_id, *args, **kw):
        unique_id = uuid.uuid4()
        message_obj = _messages.getObj(character_id)
        message = cPickle.dumps(dict(topic_id=key,
                                     character_id=character_id,
                                     args=args,
                                     kw=kw,
                                     uid=unique_id))
        score = time.time() + MAINTAIN_TIME
        result = message_obj.zadd(score, message)
        if not result:
            logger.error('cache key:%s, char id:%s, result%s',
                         key, character_id, result)
        # print result

    def cache_time(self, key, character_id, maintain_time, *args, **kw):

        unique_id = uuid.uuid4()
        message_obj = _messages.getObj(character_id)
        message = cPickle.dumps(dict(topic_id=key,
                                     character_id=character_id,
                                     args=args,
                                     kw=kw,
                                     uid=unique_id))
        score = time.time() + maintain_time
        result = message_obj.zadd(score, message)
        if not result:
            logger.error('cache key:%s, char id:%s, result%s',
                         key, character_id, result)
        # print result

    def get(self, character_id):
        message_obj = _messages.getObj(character_id)
        message_obj.zremrangebyscore(0, time.time())
        messages = message_obj.zrange(0, 10000)

        for message in messages:
            data = cPickle.loads(message)
            yield message, data

    def delete(self, key, message):
        message_obj = _messages.getObj(key)
        result = message_obj.zrem(message)
        if not result:
            logger.error('delete key:%s, message:%s, result%s',
                         key, message, result)
        # print result


message_cache = MessageCache()


import time
if __name__ == '__main__':
    message_cache.cache(444, 222, 'hihi', 'go')
    message_cache.cache(44, 222, 'hoho', 'g+')
    for request, key in message_cache.get(222):
        print request
        message_cache.delete(222, key)

    # def get_message():
    #     print 'begin'
    #     for _ in range(10000):
    #         message = message_cache.get(222)
    #     print 'end'

    # _time = time.time()
    # threads = []
    # for _ in range(100):
    #     threads.append(gevent.spawn(get_message))
    # gevent.joinall(threads)
    # print 'use time:', time.time() - _time

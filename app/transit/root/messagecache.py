# coding:utf8
"""
created by sphinx on
"""
import marshal
import redis
import uuid

REDIS_HOST = '127.0.0.1'
REDIS_POST = 6379
DB = 1


class MessageCache:
    """
    """
    def __init__(self):
        self._redis = redis.Redis()
        self._redis.pipeline()

    def cache(self, topic_id, character_id, *args, **kw):
        unique_id = uuid.uuid4()
        key = '%d_%d_%s' % (character_id, topic_id, unique_id)
        value = marshal.dumps({'topic_id': topic_id,
                               'character_id': character_id,
                               'args': args,
                               'kw': kw})
        self._redis[key] = value

    def get(self, character_id):
        request_key = '%d*' % character_id
        keys = self._redis.keys(request_key)

        if keys:
            for _ in keys:
                value = self._redis.get(_)
                request = marshal.loads(value)
                yield request

    def delete(self, topic_id, character_id):
        key = '%s_%s*' % (character_id, topic_id)
        if self._redis.exists(key):
            self._redis.delete(key)
        else:
            print 'cant find message by key:', key


message_cache = MessageCache()


if __name__ == '__main__':
    message_cache.cache(444, 222, 'hihi', 'go')
    for request in message_cache.get(222):
        print request.get('args'), request.get('character_id')

"""
created by sphinx on
"""
import marshal
import redis

REDIS_HOST = '127.0.0.1'
REDIS_POST = 6379
DB = 1


class MessageCache:
    """
    """
    def __init__(self):
        self._redis = redis.Redis(host=REDIS_HOST, port=REDIS_POST, db=DB)

    def cache(self, topic_id, character_id, *args, **kw):
        key = '%d_%d' % (character_id, topic_id)
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
        key = '%s_%s' % (character_id, topic_id)
        if self._redis.exists(key):
            self._redis.delete(key)
        else:
            print 'cant find message by key:', key


message_cache = MessageCache()

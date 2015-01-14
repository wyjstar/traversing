# -*- coding:utf-8 -*-
"""
created by server on 14-5-28下午4:47.
"""
import redis
from shared.utils.hash_ring import HashRing
from redis.connection import BlockingConnectionPool


def parse_setting(setting):
    """解析配置
    """
    host, port = setting.split(':')
    host = str(host)
    port = int(port)
    return dict(host=host, port=port, db=0)


class RedisClient(object):
    def __init__(self, **kwargs):
        self._pool = BlockingConnectionPool(**kwargs)

    def redis(self):
        return redis.StrictRedis(connection_pool=self._pool)

    def update(self, d):
        self.connection_settings.update(d)


class RedisManager(object):

    def __init__(self):
        self.connection_settings = None
        self.connections = {}
        self.hash_ring = None

    def connection_setup(self, connection_settings):
        self.hash_ring = HashRing(connection_settings)
        for setting in connection_settings:
            setting_dict = parse_setting(setting)
            client = RedisClient(**setting_dict)
            self.connections[setting] = client
        self.connection_settings = connection_settings

    def get_connection(self, key):
        node = self.hash_ring.get_node(key)
        if node and node in self.connections.keys():
            client = self.connections[node]
            return client.redis()
        return None

    def flushall(self, key):
        connection = self.get_connection(key)
        if connection:
            connection.flushall()


redis_manager = RedisManager()

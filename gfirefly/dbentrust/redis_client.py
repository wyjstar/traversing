#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
a simple redis client.
"""
import redis

class RedisClient(object):
    def __init__(self):
        self.conn = None

    def connect(self, host, port, db=0):
        settings = dict(host=host, port=port, db=db)
        self.conn = redis.StrictRedis(**settings)

    def get(self, key):
        return self.conn.get(key)

    def set(self, key, value):
        return self.conn.set(key, value)

redis_client = RedisClient()



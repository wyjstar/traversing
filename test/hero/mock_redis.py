# -*- coding:utf-8 -*-
"""
created by server on 14-7-4上午11:28.
"""

from shared.db_entrust.redis_client import RedisManager, redis_manager
import json

config = json.load(open('../../config.json', 'r'))
redis_manager.connection_setup(config.get("memcached").get("urls"))

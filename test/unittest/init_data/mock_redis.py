# -*- coding:utf-8 -*-
"""
created by server on 14-7-4上午11:28.
"""

from shared.db_entrust.redis_client import RedisManager, redis_manager
from shared.db_entrust.redis_mode import MAdmin
import json
from test.unittest.settings import config_json_path
from shared.db_entrust.redis_mode import MAdmin


def init_redis():
    config = json.load(open(config_json_path, 'r'))
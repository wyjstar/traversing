# -*- coding:utf-8 -*-
"""
created by server on 14-7-4上午11:28.
"""

from shared.db_entrust.redis_client import RedisManager, redis_manager
from shared.db_entrust.redis_mode import MAdmin
import json
from gfirefly.server.globalobject import GlobalObject

config = json.load(open('../../config.json', 'r'))
GlobalObject().json_model_config = config.get("models")
redis_manager.connection_setup(config.get("memcached").get("urls"))


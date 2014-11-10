# -*- coding:utf-8 -*-
"""
created by server on 14-8-26下午7:14.
"""
from gfirefly.server.logobj import logger
from shared.db_opear.configs_data import game_configs
from shared.utils.xreload import xreload


def reload():
    logger.info('test reload')

    print game_configs.base_config
    print '----------------------'
    xreload(game_configs)
    print '----------------------'

# -*- coding:utf-8 -*-
"""
created by server on 14-6-6上午11:12.
"""

from gfirefly.dbentrust.redis_mode import MAdmin

tb_account = MAdmin('tb_account', 'id')  # 帐号表
tb_account.insert()

tb_character_info = MAdmin('tb_character_info', 'id')
tb_character_info.insert()



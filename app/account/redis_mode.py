# -*- coding:utf-8 -*-
"""
created by server on 14-6-6上午11:12.
"""

from shared.db_entrust.redis_mode import MAdmin
from gfirefly.dbentrust.madminanager import MAdminManager

tb_account = MAdmin('tb_account', 'id')  # 帐号表
tb_account.insert()

tb_account_mapping = MAdmin('tb_account_mapping', 'account_token')  # 帐号匹配表
tb_account_mapping.insert()

tb_name_mapping = MAdmin('tb_name_mapping', 'account_name')  # 用户名匹配表
tb_name_mapping.insert()
# -*- coding:utf-8 -*-
"""
created by server on 15-11-11下午4:36.
"""

from gfirefly.server.logobj import logger
from gfirefly.server.globalobject import remoteserviceHandle
from gfirefly.server.globalobject import GlobalObject
from app.battle.battle_unit import BattleUnit
from app.game.redis_mode import tb_character_info
from app.game.action.root.netforwarding import push_message
from app.proto_file.common_pb2 import CommonResponse
from shared.db_opear.configs_data import game_configs, data_helper
from app.proto_file import friend_pb2
from app.proto_file.db_pb2 import Heads_DB
from app.proto_file.db_pb2 import Stamina_DB
from shared.utils.date_util import is_next_day
from app.game.core.item_group_helper import gain, get_return
from app.game.core.mail_helper import send_mail
from app.game.component.mine.monster_mine import MineOpt
from shared.utils.const import const
from app.game.core.task import hook_task, CONDITIONId
from app.game.redis_mode import tb_pvp_rank
import datetime
import random
import time
from app.game.action.node._fight_start_logic import assemble


remote_gate = GlobalObject().remote.get('gate')


@remoteserviceHandle('gate')
def add_friend_request_1100(data, player):

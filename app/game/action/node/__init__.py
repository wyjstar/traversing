# -*- coding:utf-8 -*-
"""
created by server on 14-6-19下午7:49.
"""
from gfirefly.server.globalobject import GlobalObject
from gfirefly.utils.services import CommandService

if 'gate' in GlobalObject().remote:
    GlobalObject().remote['gate']._reference.addService(CommandService("gateremote"))

import enter_scene
import logout
import item
import equipment
import equipment_chip
import line_up
import stage
import hero
import guild
import shop
import soul_shop
import hero_chip
import stage
import friend
import mail
import player
import online_gift
import level_gift
import feast
import sign_in
import login_gift
import pvp_rank
import arena_shop

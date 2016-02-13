# -*- coding:utf-8 -*-
"""
created by server on 14-6-19下午7:49.
"""
from gfirefly.server.globalobject import GlobalObject
from gfirefly.utils.services import CommandService
from gfirefly.server.logobj import logger
from app.game.core.PlayersManager import PlayersManager
import traceback
import time
from shared.utils.exception import AuthError

remote_gate = GlobalObject().remote.get('gate')


class GameCommandService(CommandService):
    def callTarget(self, targetKey, *args, **kw):
        target = self.getTarget(targetKey)
        if not target:
            print 'targetKey', targetKey
            logger.error('command %s not Found on service' % str(targetKey))
            return None
        # if targetKey not in self.unDisplay:
        #     logger.info("call method %s on service[%s]" %
        #                 (target.__name__, self._name))

        t = time.time()
        dynamic_id = args[0]
        _player = PlayersManager().get_player_by_dynamic_id(dynamic_id)
        try:
            #logger.debug('key and dynamic_id,%s,%s', dynamic_id, targetKey)

            if targetKey != 'enter_scene_remote':
                #_player = PlayersManager().get_player_by_dynamic_id(dynamic_id)
                # print 'find player:', _player
                if not _player:
                    logger.error('cantfind player dynamic id:%s', dynamic_id)
                    raise Exception("cantfind player dynamic id")
                    #return {'result': False, 'result_no': 1, 'message': u''}
                logger.info(
                    "call method begin %s on service[%s], player id %s",
                    target.__name__, self._name, _player.base_info.id)
                args = args[1:]
                kw['player'] = _player
                response = target(*args, **kw)
            else:
                response = target(*args, **kw)

        except AuthError, e:
            logger.exception(e)
            remote_gate.disconnect_remote(dynamic_id)
            remote_gate.push_object_remote(9999, "", _player.base_info.id)
            return None
        except Exception, e:
            logger.exception(e)
            return None
        except:
            logger.error(traceback.format_exc())
            remote_gate.push_object_remote(9999, "", _player.base_info.id)
            return None
        logger.info("call method %s on service[%s]:%f", target.__name__,
                    self._name, time.time() - t)
        return response


if 'gate' in GlobalObject().remote:
    reference = remote_gate._reference
    reference.addService(GameCommandService("gateremote"))

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
import hero_chip
import friend
import mail
import player
import online_gift
import level_gift
import feast
import sign_in
import login_gift
import pvp_rank
import brew
import world_boss
import travel
import mine
import runt
import inherit
import gm
import sdk_google
import sdk_apple
import sdk_tencent
import rank
import buy_coin_activity
import push
import rebate
import cdkey
import limit_hero
import task
import hjqy
import activity
import sdk_recharge
import start_target
import rob_treasure
import escort
import guild_boss
import guild_activity
import add_activity
# import sdk_xiaomi

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


class GameCommandService(CommandService):
    def callTarget(self, targetKey, *args, **kw):
        target = self.getTarget(targetKey)
        if not target:
            logger.error('command %s not Found on service' % str(targetKey))
            print self._targets
            return None
        # if targetKey not in self.unDisplay:
        #     logger.info("call method %s on service[%s]" %
        #                 (target.__name__, self._name))

        t = time.time()
        try:
            dynamic_id = args[0]
            # logger.debug('key and dynamic_id,%s,%s', dynamic_id, targetKey)
            if targetKey != 'enter_scene_remote':
                _player = PlayersManager().get_player_by_dynamic_id(dynamic_id)
                # print 'find player:', _player
                if not _player:
                    return {'result': False, 'result_no': 1, 'message': u''}
                args = args[1:]
                kw['player'] = _player
                response = target(*args, **kw)
            else:
                response = target(*args, **kw)

        except Exception, e:
            logger.exception(e)
            return None
        except:
            logger.error(traceback.format_exc())
        logger.info("call method %s on service[%s]:%f",
                    target.__name__, self._name, time.time() - t)
        return response


if 'gate' in GlobalObject().remote:
    reference = GlobalObject().remote['gate']._reference
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
import lively

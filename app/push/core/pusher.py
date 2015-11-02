# -*- coding:utf-8 -*-
"""
Created on 2015-5-2
@author: hack
"""

import time
from shared.utils import xtime
from gfirefly.server.logobj import logger
from shared.db_opear.configs_data import game_configs
from gfirefly.dbentrust.redis_mode import RedisObject
from gfirefly.server.globalobject import GlobalObject

PUSH_CHANNEL = GlobalObject().allconfig['push']['channel']
if PUSH_CHANNEL == 'xinge':
    logger.debug(' import xinge')
    from push_xinge import push_by_token
elif PUSH_CHANNEL == 'apns':
    logger.debug(' import apns')
    from push_apns import push_by_token

push_reg = RedisObject('pushobj.reg')
push_task = RedisObject('pushobj.push')
push_offline = RedisObject('pushobj.offline')
push_day = RedisObject('pushobj.day')


class PushMessage(object):
    def __init__(self):
        self.send_time = None
        self.message = None
        self.uid = None
        self.msg_type = None

    def can_send(self):
        now = int(time.time())
        if now > self.send_time:
            return True
        return False


class Character(object):
    def __init__(self):
        self.uid = None
        self.device_token = None
        self.switch = {}  # 消息开关
        self.status = 1
        self.status_time = 0

    def set_switch(self, mtype, switch):
        self.switch[mtype] = switch
        self.status = 1

    def set_status(self, status):
        self.status = status
        self.status_time = int(time.time())

    def can_push(self, mtype):
        return self.switch.get(mtype, 1) and self.status == 0

    def on_off(self):
        return self.status


class Pusher(object):
    def __init__(self):
        self.register = {}  # key:uid, value:Character
        self.to_push = {}
        self.offline = {}
        self.everyday = {}
        self.register = push_reg.hgetall()
        logger.info(self.register)
        self.to_push = push_task.hgetall()
        logger.info(self.to_push)
        self.offline = push_offline.hgetall()
        logger.info(self.offline)
        self.everyday = push_day.hgetall()
        logger.info(self.everyday)

    def regist(self, uid, device_token):
        logger.info('device_token:%s', device_token)
        if not device_token:
            return
        user = Character()
        user.uid = uid
        user.device_token = device_token
        self.register[user.uid] = user
        push_reg.hset(uid, user)

    def set_switch(self, uid, mtype, switch):
        if uid not in self.register:
            return

        self.register[uid].set_switch(mtype, switch)
        push_reg.hset(uid,  self.register[uid])

    def get_switch(self, uid):
        if uid in self.register:
            return self.register[uid].switch
        return {}

    def on_offf(self, uid, status):
        if uid in self.register:
            self.register[uid].set_status(status)
            push_reg.hset(uid,  self.register[uid])

        if status == 0:
            # 离线需要设置系统消息
            self.offline[uid] = int(time.time())
            push_offline.hset(uid, self.offline[uid])
        else:
            if uid in self.offline:
                del self.offline[uid]
                push_offline.hdel(uid)

    def add_message(self, uid, mtype, msg, send_time):
        logger.info('add_message:%s-%s-%s-%s', uid, mtype, msg, send_time)
        if uid in self.register:
            if self.register[uid].status == 1:
                return
        elif uid != -1:
            return
        message = PushMessage()
        message.uid = uid
        message.msg_type = mtype
        message.send_time = send_time
        message.message = msg
        mid = '%s.%s.%s' % (uid, mtype, time.time())
        self.to_push[mid] = message
        push_task.hset(mid, message)

    def process(self):
        # print 'process'
        # frame = Frame()
        # identifier = 1
        # expiry = int(time.time())
        # priority = 10
        now = int(time.time())
        count = 0
        for mid in self.to_push.keys():
            message = self.to_push[mid]
            uid = message.uid
            mtype = message.msg_type
            send_time = message.send_time
            if send_time > now:
                continue
            if uid == -1:
                self.send_all(mtype, message)
                del self.to_push[mid]
                push_task.hdel(mid)
                continue
            user = None
            if uid in self.register:
                user = self.register[uid]
            if user is None or not user.can_push(mtype):
                continue

            push_by_token(user.device_token, message.message)
            count += 1
            del self.to_push[mid]
            push_task.hdel(mid)

#         if count:
#             try:
#                 apns_handler.gateway_server.send_notification_multiple(frame)
#             except Exception, e:
#                 print e
#         payload = Payload(alert='message.message', sound='default', badge=1)
#             frame.add_item(user.device_token, payload, identifier, expiry, priority)
#         apns_handler.gateway_server.send_notification(device_token1, payload)

    def send_all(self, mtype, message):
        count = 0
        for user in self.register.values():
            logger.info('user.device_token:%s', user.device_token)
            if user.can_push(mtype):
                push_by_token(user.device_token, message.message)
                count += 1
        logger.debug('count:%s', count)
#         if count:
#             try:
#                 apns_handler.gateway_server.send_notification_multiple(frame)
#             except Exception,e:
#                 print e

    def gen_task(self):
        pass
        # push_config = game_configs.push_config
        # for push in push_config.values():
        #     if push.event == 2:
        #         self.gen_2(push.id)
        #     if push.event == 4:
        #         self.gen_4(push.id)
        #     if push.event == 6:
        #         self.gen_2(push.id)

    def gen_2(self, pid):
        push_config = game_configs.push_config[pid]
        tt = push_config.conditions
        for t in tt:
            h, m = map(int, t.split(':'))
            today_ts = xtime.today_ts()
            one = today_ts + h*60*60 + m*60
            if one in self.everyday:
                continue
            else:
                self.everyday[one] = 1
                push_day.hset(one, 1)
                txt = str(push_config.text)
                message = game_configs.language_config.get(txt).get('cn')
                logger.info('message:%s', message)
                self.add_message(-1, push_config.event, message, one)

    def gen_4(self, pid):
        push_config = game_configs.push_config[pid]
        days = push_config.conditions[0]
        now = time.time()
        for uid in self.offline.keys():
            if now - self.offline[uid] > days*24*60*60:
                txt = str(push_config.text)
                message = game_configs.language_config.get(txt).get('cn')
                self.add_message(uid, push_config.event,
                                 message, int(time.time()))
                del self.offline[uid]
                push_offline.hdel(uid)

pusher = Pusher()

# -*- coding:utf-8 -*-
'''
Created on 2015-5-2

@author: hack
'''
from gfirefly.utils.singleton import Singleton
import time
from app.push.core.apns import APNs, Payload, Frame
from shared.db_opear.configs_data import game_configs
from shared.utils import xtime

from gfirefly.dbentrust.redis_mode import RedisObject

push_reg = RedisObject('pushobj.reg')
push_task = RedisObject('pushobj.push')
push_offline = RedisObject('pushobj.offline')
push_day = RedisObject('pushobj.day')

apns_handler = APNs(use_sandbox=True, cert_file='push_dev.pem', enhanced=True)
device_token1 ='8690afe1f1f1067b3f45e0a26a3af4eef5391449e8d07073a83220462bf061be'


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
        self.switch = {} #消息开关
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
    __metaclass__ = Singleton

    def __init__(self):
        self.register = {} #key:uid, value:Character
        self.to_push = {}
        self.offline = {}
        self.everyday = {}
        print '__init__'
        self.register = push_reg.hgetall()
        print self.register
        self.to_push = push_task.hgetall()
        print self.to_push
        self.offline = push_offline.hgetall()
        print self.offline
        self.everyday = push_day.hgetall()
        print self.everyday

    def regist(self, uid, device_token):
        print 'device_token', device_token
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
            #离线需要设置系统消息
            self.offline[uid] = int(time.time())
            push_offline.hset(uid, self.offline[uid])
        else:
            if uid in self.offline:
                del self.offline[uid]
                push_offline.hdel(uid)

    def add_message(self, uid, mtype, msg, send_time):
        print(msg)
        print 'add_message', uid, mtype, msg, send_time
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
        mid = '%s.%s.%s' %(uid,mtype,time.time())
        self.to_push[mid] = message
        push_task.hset(mid, message)

    def process(self):
        print 'process'
#         frame = Frame()
#         identifier = 1
#         expiry = int(time.time())
#         priority = 10
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
            if user == None or not user.can_push(mtype):
                continue

            payload = Payload(alert=message.message, sound='default', badge=1)
#             frame.add_item(user.device_token, payload, identifier, expiry, priority)
            apns_handler.gateway_server.send_notification(user.device_token, payload)
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
#         frame = Frame()
#         identifier = 1
#         expiry = int(time.time())
#         priority = 10
        count = 0
        for user in self.register.values():
            print 'user.device_token', user.device_token
            if user.can_push(mtype):
                payload = Payload(alert=message.message, sound='default', badge=1)
#                 frame.add_item(user.device_token, payload, identifier, expiry, priority)
                apns_handler.gateway_server.send_notification(user.device_token, payload)
                count += 1
        print 'count', count
#         if count:
#             try:
#                 apns_handler.gateway_server.send_notification_multiple(frame)
#             except Exception,e:
#                 print e
        
    def gen_task(self):
        push_config = game_configs.push_config
        for push in push_config.values():
            if push.event == 2:
                self.gen_2(push.id)
            if push.event == 4:
                self.gen_4(push.id)
            if push.event == 6:
                self.gen_2(push.id)

    def gen_2(self, pid):
        push_config = game_configs.push_config[pid]
        tt = push_config.conditions
        for t in tt:
            h,m = map(int, t.split(':'))
            today_ts = xtime.today_ts()
            one = today_ts + h*60*60 + m*60
            if one in self.everyday:
                continue
            else:
                self.everyday[one] = 1
                push_day.hset(one, 1)
                message = game_configs.language_config.get(str(push_config.text)).get('cn')
                print 'message', message
                self.add_message(-1, push_config.event, message, one)

    def gen_4(self, pid):
        push_config = game_configs.push_config[pid]
        days = push_config.conditions[0]
        now = time.time()
        for uid in self.offline.keys():
            if now - self.offline[uid] > days*24*60*60:
                message = game_configs.language_config.get(str(push_config.text)).get('cn')
                self.add_message(uid, push_config.event, message, int(time.time()))
                del self.offline[uid]
                push_offline.hdel(uid)


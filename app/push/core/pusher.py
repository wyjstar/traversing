#coding: utf-8
'''
Created on 2015-5-2

@author: hack
'''
from gfirefly.utils.singleton import Singleton
import time
from app.push.core.apns import APNs, Payload, Frame

apns = APNs(use_sandbox=True, cert_file='push_dev.pem')

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
    
    def set_switch(self, mtype, switch):
        self.switch[mtype] = switch
        self.status = 1
        
    def set_status(self, status):
        self.status = status
        
    def can_push(self, mtype):
        return self.switch.get(mtype, 1) and self.status == 0
    
    def on_off(self):
        return self.status

class Pusher(object):
    __metaclass__ = Singleton
    
    def __init__(self):
        self.register = {} #key:uid, value:Character
        self.to_push = {}
        
    def add_task(self):
        pass
    
    def register(self, uid, device_token):
        user = Character()
        user.uid = uid
        user.device_token = device_token
        self.register[user.uid] = user
        
    def set_switch(self, uid, mtype, switch):
        if uid not in self.register:
            return
        
        self.register[uid].set_switch(mtype, switch)
        
    def on_offf(self, uid, status):
        if uid in self.register:
            self.register[uid].set_status(status)
            
        if status == 0:
            #离线需要设置系统消息
            pass
        else:
            del self.to_push[uid]
            
    def add_message(self, uid, mtype, message, send_time):
        if uid in self.register:
            if self.register[uid].status == 1:
                return
            message = PushMessage()
            message.uid = uid
            message.msg_type = mtype
            message.send_time = send_time
            message.message = message
            mid = '%s.%s.%s' %(uid,mtype,time.time())
            self.to_push[mid] = message
            
    def process(self):
        
        frame = Frame()
        identifier = 1
        expiry = int(time.time())
        priority = 10
        now = int(time.time())
        for mid in self.to_push.keys():
            message = self.to_push[mid]
            uid = message.uid
            mtype = message.msg_type
            send_time = message.send_time
            if send_time < now:
                continue
            if uid == -1:
                self.send_all(mtype, message)
                del self.to_push[mid]
                continue
            user = None
            if uid in self.register:
                user = self.register[uid]
            if user == None or not user.can_push(mtype):
                continue
                    
            payload = Payload(alert=message, sound='default', badge=1)
            frame.add_item(user.device_token, payload, identifier, expiry, priority)
            del self.to_push[mid]
        apns.gateway_server.send_notification_multiple(frame)
        
    def send_all(self, mtype, message):
        frame = Frame()
        identifier = 1
        expiry = int(time.time())
        priority = 10
        for user in self.register.values():
            if user.can_push(mtype):
                payload = Payload(alert=message, sound='default', badge=1)
                frame.add_item(user.device_token, payload, identifier, expiry, priority)
        apns.gateway_server.send_notification_multiple(frame)
#coding:utf-8
'''
Created on 2015-5-10

@author: hack
'''
from app.push.core.apns import APNs
from app.push.core import APNSWrapper
from app.push.core.apns import Payload
apns = APNs(use_sandbox=True, cert_file='push_dev.pem', enhanced=True)
device_token ='8690afe1f1f1067b3f45e0a26a3af4eef5391449e8d07073a83220462bf061be'

wrapper = APNSWrapper.APNSNotificationWrapper('push_dev.pem', True, debug_ssl=True)
message = APNSWrapper.APNSNotification()
message.token(device_token)
message.badge(1)
message.alert('hello, world')
wrapper.append(message)
wrapper.notify()

payload = Payload('hello', badge=1)

apns.gateway_server.send_notification(device_token, payload)
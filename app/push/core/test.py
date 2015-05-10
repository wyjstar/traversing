#coding:utf-8
'''
Created on 2015-5-10

@author: hack
'''
from app.push.core.apns import APNs, Frame
from app.push.core.apns import Payload
apns_handler = APNs(use_sandbox=True, cert_file='push_dev.pem', enhanced=True, ciphers='123456')
device_token ='8690afe1f1f1067b3f45e0a26a3af4eef5391449e8d07073a83220462bf061be'


payload = Payload('hello', badge=1)

apns_handler.gateway_server.send_notification(device_token, payload)

frame = Frame()
frame.add_item(device_token, payload, 1, 1, 1)
apns_handler.gateway_server.send_notification_multiple(frame)

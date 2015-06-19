#coding:utf-8
'''
Created on 2015-5-10

@author: hack
'''
from apns import APNs, Frame
from apns import Payload
apns_handler = APNs(use_sandbox=True, cert_file='push_dev2.pem', enhanced=True)
device_token ='8690afe1f1f1067b3f45e0a26a3af4eef5391449e8d07073a83220462bf061be'


payload = Payload('hello', badge=1)

apns_handler.gateway_server.send_notification(device_token, payload)

frame = Frame()
frame.add_item(device_token, payload, 1, 1, 1)
apns_handler.gateway_server.send_notification_multiple(frame)

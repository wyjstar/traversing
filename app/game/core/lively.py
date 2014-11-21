# -*- coding:utf-8 -*-
'''
Created on 2014-11-20

@author: hack
'''
from app.proto_file.lively_pb2 import TaskUpdate

def task_status(player):
    task_status = player.tasks.task_status()
    player.tasks.save_data()
    response = TaskUpdate()
    for status in task_status:
        ts = response.tasks.add()
        print 'query_status_1234', status
        ts.tid = status[0]
        ts.current = status[1]
        ts.target = status[2]
        ts.status = status[3]
    return response.SerializePartialToString()
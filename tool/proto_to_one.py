# -*- coding:utf-8 -*-
"""
created by server on 14-7-25下午5:52.
"""

root_path = "../app/proto_file/proto/"
import os
result_file = open("one.proto", "a")
for file_name in os.listdir(root_path):
    file_path = root_path + file_name
    temp = open(file_path, "r")
    data = temp.readlines()
    print data
    result_file.writelines(data)
result_file.close()
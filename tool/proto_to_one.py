# -*- coding:utf-8 -*-
"""
created by server on 14-7-25下午5:52.
"""

root_path = "../app/proto_file/proto/"
import os

result_file = open("traversing_one.proto", "w")
for file_name in os.listdir(root_path):
    if file_name.endswith('.proto'):
        file_path = root_path + file_name
        temp = open(file_path, "r")
        data = temp.readlines()
        for line in data:
            if not line.startswith("import") and not\
                    line.startswith("package"):
                result_file.write(line)

        result_file.write("\n")
result_file.close()

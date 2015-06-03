# -*- coding:utf-8 -*-
"""
created by server on 14-7-25下午5:52.
"""

root_path = "../app/proto_file/proto/"
import os
try:
    os.remove("traversing_one.proto")
    os.remove("traversing_one.pb")
except:
    pass

result_file = open("../proto/traversing_one.proto", "w")
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


#os.system("cd ../proto;git pull origin master:master;")
os.system("protoc -o ../proto/traversing_one.pb ../proto/traversing_one.proto --proto_path='../proto'")
os.system("cd ../app/proto_file/proto;protoc -I=. --python_out=.. ./*")
#os.system("cd ../proto;git commit -am 'update';git push origin master:master")
#os.system("protoc -I=. --python_out=.. ./*")

# -*- coding:utf-8 -*-
"""
created by server on 14-7-25下午5:52.
"""

import os
import sys
import getopt


def dumpInfoToFile(uid):
    pass


def loadInfoToRedis(uid):
    pass

if __name__ == '__main__':
    if len(sys.argv) != 4:
        print("please input args!")
        sys.exit()
    else:
        type_ = sys.argv[1]  # 1 从redis dump到文件 2:从文件load到redis
        uid = sys.argv[2]
        print "type:", type_, ", uid:", uid

    pass

    '''
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


    #os.system("cd ../proto;git checkout .;")
    os.system("cd ../proto;git checkout %s;git pull origin %s:%s;" % (branch_name, branch_name, branch_name))
    os.system("protoc -o ../proto/traversing_one.pb ../proto/traversing_one.proto --proto_path='../proto'")
    os.system("cd ../app/proto_file/proto;protoc -I=. --python_out=.. ./*")
    os.system("cd ../proto;git commit -am 'update';git push origin %s:%s" % (branch_name, branch_name))
    #os.system("protoc -I=. --python_out=.. ./*")
    '''

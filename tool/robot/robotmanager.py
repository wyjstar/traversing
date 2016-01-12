# -*- coding:utf-8 -*-
import urllib
import gevent
import json
import socket
import time


HOST = '127.0.0.1'
PORT = 31009


class RobotManager:
    def __init__(self):
        self._robot_count = 0
        self._robot_processing_num = 0
        self._robot_login_fail_num = 0
        self._robot_login_success_num = 0
        self._robots = []
        self._login_begin_time = 0

    @property
    def count(self):
        return self._robot_count

    def print_info(self):
        str_format = "processing:%d, login fail:%d, login success:%d"
        print str_format % (self._robot_processing_num,
                            self._robot_login_fail_num,
                            self._robot_login_success_num)

    def on_robot_command_error(self):
        self._robot_login_fail_num += 1
        self._robot_processing_num -= 1
        self.print_info()

    def on_robot_login_fail(self):
        self._robot_login_fail_num += 1
        self._robot_processing_num -= 1
        self.print_info()

    def on_robot_account_login_result(self, result):
        if not result:
            self._robot_login_fail_num += 1
            self._robot_processing_num -= 1
        self.print_info()

    def on_robot_character_login_result(self, result):
        if not result:
            self._robot_login_fail_num += 1
            self._robot_processing_num -= 1
        else:
            self._robot_login_success_num += 1
            self._robot_processing_num -= 1
        self.print_info()

    def register_robot(self, new_robot):
        new_robot.on_command_error = self.on_robot_command_error
        new_robot.on_connection_lost = self.on_robot_login_fail
        new_robot.on_account_login_result = self.on_robot_account_login_result
        new_robot.on_character_login_result = \
            self.on_robot_character_login_result

        self._robots.append(new_robot)

    def get_robot_command(self, index):
        robot = self._robots[int(index)]
        return robot.commands, robot.commands_args

    def do_command(self, robot_index, command, fun, *args):
        robot = self._robots[int(robot_index)]
        com = getattr(robot, command)
        setattr(robot, 'on_command_finish', fun)
        if com:
            com(*args)

    def is_robots_logined(self):
        result = self._robot_count == self._robot_login_success_num
        if result:
            peroid = time.time() - self._login_begin_time
            print 'login finished: FPS:%s use time:%s',\
                  self._robot_count/peroid, peroid
        return result

    def add_robot(self, robot_type, number):
        self._login_begin_time = time.time()
        for _ in range(int(number)):
            while self._robot_processing_num >= 200:
                gevent.sleep(1)
                self.print_info()

            robot_name = 'robot' + str(self._robot_count)
            pwd = '123456'
            robot_nickname = 'robot' + str(self._robot_count)
            self._robot_count += 1
            self._robot_processing_num += 1

            print 'add a client'
            gevent.spawn(add_robot_run, robot_type, self,
                         robot_name, pwd, robot_nickname)
            print 'add a client'


def add_robot_run(robot_type, manager, robot_name, pwd, robot_nickname):
    print("add_robot_run")
    register_url = 'http://localhost:30004/register?name=%s&pwd=%s' % \
                   (robot_name, pwd)
    register_response = json.loads((urllib.urlopen(register_url)).read())
    print 'register response:', register_response
    if register_response.get('result') is False and \
            register_response.get('message').find('exist') == -1:
        print 'register fail'
        return
    print 'register success'

    login_url = 'http://localhost:30004/login?name=%s&pwd=%s' % \
                (robot_name, pwd)
    login_response = json.loads((urllib.urlopen(login_url)).read())
    print 'login response:', login_response
    if login_response.get('result') is False:
        print 'login fail'
        return
    print 'login success'

    passport = login_response.get('passport')
    print passport
    login_game_url = 'http://localhost:30006/login?passport=' + passport
    login_game_response = (urllib.urlopen(login_game_url)).read()
    print 'login game response:', login_game_response
    login_game_response = json.loads(login_game_response)
    print 'login game response:', login_game_response
    net_ip = login_game_response.get('servers')[0].get('ip')
    net_port = login_game_response.get('servers')[0].get('port')
    if login_game_response.get('result') is False:
        print 'login game fail'
        return
    print 'login game success'
    game_passport = login_game_response.get('passport')

    skt = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    skt.connect((net_ip, net_port))
    print 'tcp connect game success'
    robot_type(skt, manager, game_passport, robot_nickname)

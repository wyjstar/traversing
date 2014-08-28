# -*- coding:utf-8 -*-

from twisted.internet import reactor
from twisted.internet.protocol import ClientCreator


HOST = '127.0.0.1'
PORT = 11009


class RobotManager:
    def __init__(self):
        self._robot_count = 0
        self._robot_processing_num = 0
        self._robot_login_fail_num = 0
        self._robot_login_success_num = 0
        self._robots = []

    @property
    def count(self):
        return self._robot_count

    def print_info(self):
        str_format = "processing:%d, login fail:%d, login success:%d"
        print str_format % (self._robot_processing_num,
                            self._robot_login_fail_num,
                            self._robot_login_success_num)

    def on_robot_command_error(self):
        self._robot_login_fail_num -= 1
        self._robot_processing_num -= 1
        self.print_info()

    def on_robot_login_fail(self):
        self._robot_login_fail_num -= 1
        self._robot_processing_num -= 1
        self.print_info()

    def on_robot_account_login_result(self, result):
        if not result:
            self._robot_login_fail_num -= 1
            self._robot_processing_num -= 1
        self.print_info()

    def on_robot_character_login_result(self, result):
        if not result:
            self._robot_login_fail_num -= 1
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
        return self._robot_count == self._robot_login_success_num

    def add_robot(self, robot_type, number):
        for _ in range(int(number)):
            robot_name = 'robot' + str(self._robot_count)
            pwd = '123456'
            robot_nickname = 'robot' + str(self._robot_count)
            self._robot_count += 1

            c = ClientCreator(reactor, robot_type, self,
                              robot_name, pwd, robot_nickname)
            c.connectTCP(HOST, PORT)
            print 'add a client'


robot_manager = RobotManager()

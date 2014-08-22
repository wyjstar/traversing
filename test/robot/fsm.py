# -*- coding:utf-8 -*-

from robot import Robot
from fsmmanager import fsm_manager
from robotmanager import robot_manager


class FsmCommand:
    def __init__(self):
        self.command_action = {}
        self.command_action['1'] = self.action_1
        self.command_action['2'] = self.action_2
        self.command_action['3'] = self.action_3

    def enter_state(self):
        print '='*48
        print '1.add robot'
        print '2.robot action'
        print '3.quit'

    def exit_state(self):
        pass

    def exec_state(self):
        select = raw_input()
        if not select.isdigit():
            self.enter_state()
            return
        if select not in self.command_action:
            self.enter_state()
            return
        action = self.command_action[select]
        action()

    def action_1(self):
        fsm_manager.change_state(FsmAddRobot)

    def action_2(self):
        fsm_manager.change_state(FsmRobotAction)

    def action_3(self):
        pass


class FsmAddRobot:
    def __init__(self):
        self._robot_type = 0
        self._robot_type = {}
        self._robot_type['1'] = Robot

    def enter_state(self):
        print '='*48
        for _i, _type in self._robot_type:
            print "%s:%s" % (_i, _type)

    def exit_state(self):
        pass

    def exec_state(self):
        print 'please input type id:'
        select = raw_input()
        while select not in self._robot_type:
            print 'please input:'
            select = raw_input()

        print 'please input number wanna robot create:'
        number = raw_input()
        while not number.isdigit():
            print 'please input number wanna robot create:'
            number = raw_input()

        robot_manager.add_robot(self._robot_type[select], number)
        fsm_manager.change_state(FsmCommand)


class FsmRobotAction:
    def enter_state(self):
        pass

    def exit_state(self):
        pass

    def exec_state(self):
        pass

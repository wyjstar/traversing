# -*- coding:utf-8 -*-

from robotmanager import robot_manager
from twisted.internet import reactor

from robot import Robot
from robot_friend import RobotFriend
from test.robot.robot_guild import RobotGuild


class FsmCommand:
    def __init__(self, fsm_manager):
        self.fsm_manager = fsm_manager
        self.command_action = {}
        self.command_action['1'] = self.action_1
        self.command_action['2'] = self.action_2
        self.command_action['3'] = self.action_3

    def enter_state(self):
        print '='*68
        print '1.add robot'
        print '2.robot action'
        print '3.quit'
        print 'please input command id:',

    def exit_state(self):
        pass

    def exec_state(self):
        select = raw_input()
        if select not in self.command_action:
            print 'error input!!!!!!'
            self.enter_state()
            return
        action = self.command_action[select]
        action()

    def action_1(self):
        self.fsm_manager.change_state(FsmAddRobot)

    def action_2(self):
        self.fsm_manager.change_state(FsmRobotAction)

    def action_3(self):
        reactor.stop()


class FsmAddRobot:
    def __init__(self, fsm_manager):
        self.fsm_manager = fsm_manager
        self._robot_type = {}
        self._robot_type['1'] = Robot
        self._robot_type['2'] = RobotFriend
        self._robot_type['3'] = RobotGuild

    def enter_state(self):
        print '='*68
        for _i, _type in self._robot_type.items():
            print "%s:%s" % (_i, _type)

        print 'please input type id:',
        select = raw_input()
        while select not in self._robot_type:
            print 'error! please input type id again:',
            select = raw_input()

        print 'please input number wanna robot create:',
        number = raw_input()
        while not number.isdigit():
            print 'error! please input number wanna robot create again:',
            number = raw_input()

        robot_manager.add_robot(self._robot_type[select], number)

    def exit_state(self):
        pass

    def exec_state(self):
        if robot_manager.is_robots_logined():
            self.fsm_manager.change_state(FsmCommand)


class FsmRobotAction:
    def __init__(self, fsm_manager):
        self.fsm_manager = fsm_manager
        self.finish = False

    def enter_state(self):
        print '='*68
        print "please input robot id[0-%d]:" % (robot_manager.count - 1),
        robot_id = raw_input()
        while not robot_id.isdigit() or int(robot_id) > robot_manager.count:
            print 'error! please input robot id again:',
            robot_id = raw_input()

        commands, command_args = robot_manager.get_robot_command(robot_id)
        for _ in range(len(commands)):
            print "%d.%s %s" % (_, commands[_], command_args[_])

        print 'please input command id:',
        command = raw_input()
        cid = command.split(' ')[0]
        args = command.split(' ')[1:]
        while not cid.isdigit() or int(cid) > len(commands):
            print 'error! please input command id again:',
            command = raw_input()
            cid = command.split(' ')[0]
            args = command.split(' ')[1:]

        robot_manager.do_command(robot_id,
                                 commands[int(cid)],
                                 self.on_command_finish, *args)

    def on_command_finish(self):
        print 'command finish'
        self.finish = True

    def exit_state(self):
        pass

    def exec_state(self):
        if self.finish:
            self.fsm_manager.change_state(FsmCommand)

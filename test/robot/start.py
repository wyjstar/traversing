# -*- coding:utf-8 -*-

from twisted.internet import reactor
from gevent import monkey
from robotmanager import RobotManager
from sfsm import Sfsm
from robot import Robot
from robot_friend import RobotFriend
from robot_guild import RobotGuild
import gevent

monkey.patch_os()


robot_type = {}
robot_type['1'] = Robot
robot_type['2'] = RobotFriend
robot_type['3'] = RobotGuild

robot_manager = RobotManager()


def enter_command(e):
    print '='*68
    print '1.add robot'
    print '2.robot action'
    print '3.quit'
    print 'please input command id:',

    select = raw_input()
    while select not in ['1', '2', '3']:
        print select
        print 'error input! please input command id:',
        select = raw_input()

    if select == '1':
        fsm.addrobot()
    elif select == '2':
        fsm.robotaction()
    elif select == '3':
        reactor.stop()


def enter_addrobot(e):
    print '='*68
    for _i, _type in robot_type.items():
        print "%s:%s" % (_i, _type)

    print 'please input type id:',
    select = raw_input()
    while select not in robot_type:
        print 'error! please input type id again:',
        select = raw_input()

    print 'please input number wanna robot create:',
    number = raw_input()
    while not number.isdigit():
        print 'error! please input number wanna robot create again:',
        number = raw_input()

    robot_manager.add_robot(robot_type[select], number)


def on_addrobot():
    if robot_manager.is_robots_logined():
        fsm.back()


def enter_robotaction(e):
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

    def on_command_finish():
        fsm.back()

    robot_manager.do_command(robot_id,
                             commands[int(cid)],
                             on_command_finish, *args)


fsm = Sfsm(events=[('start',  'none',  'command'),
                   ('addrobot', 'command', 'addrobot'),
                   ('robotaction', 'command', 'robotaction'),
                   ('back',  'addrobot',    'command'),
                   ('back', 'robotaction', 'command')],
           callbacks={'onentercommand': enter_command,
                      'onenteraddrobot': enter_addrobot,
                      'onenterrobotaction': enter_robotaction,
                      'onaddrobot': on_addrobot})


def tick():
    if fsm.current == 'none':
        fsm.start()
    else:
        fsm()
    reactor.callLater(0, tick)


if __name__ == '__main__':
    reactor.callLater(0, tick)
    reactor.run()

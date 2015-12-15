# -*- coding:utf-8 -*-

from gevent import monkey
monkey.patch_all()

import sys
import gevent
from robotmanager import RobotManager
from sfsm import Sfsm
from robot import Robot
from robot_friend import RobotFriend
from robot_guild import RobotGuild
from robot_online_gift import RobotOnlineGift
from robot_activity import RobotActivity
from robot_world_boss import RobotWorldBoss
from robot_stage import RobotStage
from robot_pvp import RobotPvp
from robot_mine import RobotMine
from robot_hero import RobotHero
from robot_zhangchao import RobotZhangChao
from robot_escort_task import RobotEscortTask
from robot_guild_boss import RobotGuildBoss


RED = '\033[31m'
GREEN = '\033[32m'
YELLOW = '\033[33m'
MAGENTA = '\033[35m'
OCEAN = '\033[36m'
RESET = '\033[0m'

robot_type = {}
robot_type['01'] = Robot
robot_type['02'] = RobotFriend
robot_type['03'] = RobotGuild
robot_type['04'] = RobotOnlineGift
robot_type['05'] = RobotActivity
robot_type['06'] = RobotWorldBoss
robot_type['07'] = RobotStage
robot_type['08'] = RobotPvp
robot_type['09'] = RobotMine
robot_type['10'] = RobotHero
robot_type['11'] = RobotZhangChao
robot_type['12'] = RobotEscortTask
robot_type['13'] = RobotGuildBoss
robot_manager = RobotManager()


def enter_command(e):
    print MAGENTA + '='*68
    print MAGENTA + '1.add robot'
    print MAGENTA + '2.robot action'
    print MAGENTA + '3.quit'
    print MAGENTA + 'please input command id:',

    select = raw_input()
    while select not in ['1', '2', '3']:
        print select
        print RED + 'error input! please input command id:',
        select = raw_input()

    if select == '1':
        fsm.addrobot()
    elif select == '2':
        fsm.robotaction()
    elif select == '3':
        sys.exit(0)


def enter_addrobot(e):
    print MAGENTA + '='*68
    keys = robot_type.keys()
    keys.sort()
    for k in keys:
        print YELLOW + "%s:%s" % (k, robot_type[k])

    print YELLOW + 'please input type id:',
    select = raw_input()
    while select not in robot_type:
        print RED + 'error! please input type id again:',
        select = raw_input()

    print YELLOW + 'please input number wanna robot create:',
    number = raw_input()
    while not number.isdigit():
        print RED + 'error! please input number wanna robot create again:',
        number = raw_input()

    robot_manager.add_robot(robot_type[select], number)


def on_addrobot():
    if robot_manager.is_robots_logined():
        fsm.back()


def enter_robotaction(e):
    print OCEAN + '='*68
    print YELLOW + "please input robot id[0-%d]:" % (robot_manager.count - 1),
    robot_id = raw_input()
    while not robot_id.isdigit() or int(robot_id) > robot_manager.count:
        print RED + 'error! please input robot id again:',
        robot_id = raw_input()

    commands, command_args = robot_manager.get_robot_command(robot_id)
    for _ in range(len(commands)):
        print YELLOW + "%d.%s %s" % (_, commands[_], command_args[_])

    print YELLOW + 'please input command id:',
    command = raw_input()
    cid = command.split(' ')[0]
    args = command.split(' ')[1:]
    while not cid.isdigit() or int(cid) > len(commands):
        print RED + 'error! please input command id again:',
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
    while True:
        if fsm.current == 'none':
            fsm.start()
        else:
            fsm()
        gevent.sleep(0)


if __name__ == '__main__':
    tick()

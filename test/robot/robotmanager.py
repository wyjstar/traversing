# -*- coding:utf-8 -*-


class RobotManager:
    def __init__(self):
        self._robot_count = 0
        self._robots = []

    def add_robot(self, robot_type, number):
        for _ in number:
            self._robots[self._robot_count] = robot_type()
            self._robot_count += 1

robot_manager = RobotManager()

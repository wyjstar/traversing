# -*- coding:utf-8 -*-
"""
created by wzp.
"""
from robot import Robot
from app.proto_file.shop_pb2 import ShopRequest

class RobotHero(Robot):

    def command_fight(self):
        print "command_fight============"
        request = ShopRequest()
        request.ids.append(50001)

        self.send_message(request, 501)

    def notice_2000(self, message):
        print "notice_2000==================="
        self.on_command_finish()

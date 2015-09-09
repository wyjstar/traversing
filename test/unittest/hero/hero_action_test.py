# -*- coding:utf-8 -*-
"""
created by server on 14-7-4上午10:16.
"""

import test.unittest.init_data.init_connection
import unittest
from app.proto_file.hero_response_pb2 import *
from app.proto_file.hero_request_pb2 import *
from test.unittest.test_tool import call
#from test.unittest.init_test_data import init


class HeroActionTest(unittest.TestCase):
    def setUp(self):

        from test.unittest.init_test_data import init
        self.player = init()

    def tst_get_hero_list_101(self):
        str_response = call(101, "")
        response = GetHerosResponse()
        response.ParseFromString(str_response)
        hero_list_len = len(response.heros)
        self.assertEqual(hero_list_len, 16, "return hero len error!%d" % hero_list_len)
        self.assertEqual(response.heros[0].hero_no, 10001, "first hero no error!")

    def test_one_key_hero_upgrade_119(self):
        request = HeroRequest()
        request.hero_no = 10001
        str_response = call(119, request.SerializeToString())
        print("test_one_key_hero_upgrade_119")


if __name__ == '__main__':
    unittest.main()


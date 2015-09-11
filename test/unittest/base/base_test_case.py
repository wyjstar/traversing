#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
base class
"""

import unittest

class BaseTestCase(unittest.TestCase):
    """docstring for BaseTestCase"""

    def setUp(self):
        from test.unittest.init_test_data import init
        self.player = init()

    def Equal(self, res, expected):
        self.assertEqual(res, expected, "error!%s_%s" % (res, expected))

    def NotEqual(self, res, expected):
        self.assertNotEqual(res, expected, "error!%s_%s" % (res, expected))

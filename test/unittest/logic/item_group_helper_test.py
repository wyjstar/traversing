# -*- coding:utf-8 -*-
"""
created by server on 14-7-10下午3:17.
"""
import test.unittest.init_data.init_connection
import unittest
from app.game.core.PlayersManager import PlayersManager
from app.game.logic.item_group_helper import *
from shared.db_opear.configs_data.data_helper import parse


class ItemGroupHelperTest(unittest.TestCase):

    def setUp(self):
        from test.unittest.init_test_data import init
        init()
        self.player = PlayersManager().get_player_by_id(1)

    def test_parse(self):
        data = {1: [1, 1, 1001], 2: [2, 2, 1002], 3: [3, 3, 1003]}
        item_group = parse(data)
        first = item_group[0]
        self.assertEqual(first.item_type, 1, "first item type id error!%d_%d" % (first.item_type, 1))
        self.assertEqual(first.num, 1, "first item type id error!%d_%d" % (first.num, 1))
        self.assertEqual(first.item_no, 1001, "first item type id error!%d_%d" % (first.item_no, 0011))

        last = item_group[len(item_group)-1]
        self.assertEqual(last.item_type, 3, "first item type id error!%d_%d" % (last.item_type, 3))
        self.assertEqual(last.num, 3, "first item type id error!%d_%d" % (last.num, 3))
        self.assertEqual(last.item_no, 1003, "first item type id error!%d_%d" % (last.item_no, 1003))

    def test_is_afford(self):
        consume_data = {1: [30000, 30000, 0],
                        2: [10000, 10000, 0],
                        3: [20000, 20000, 0],
                        4: [300, 300, 1000112],
                        5: [2, 2, 1000111]}

        result = is_afford(self.player, parse(consume_data))
        self.assertEqual(result.get('result'), True)

        import copy
        consume_data_copy = copy.deepcopy(consume_data)
        consume_data_copy[1][0] += 1
        consume_data_copy[1][1] += 1
        result = is_afford(self.player, parse(consume_data_copy))
        self.assertEqual(result.get('result'), False)
        consume_data_copy = copy.deepcopy(consume_data)
        consume_data_copy[2][0] += 1
        consume_data_copy[2][1] += 1
        result = is_afford(self.player, parse(consume_data_copy))
        self.assertEqual(result.get('result'), False)

        consume_data_copy = copy.deepcopy(consume_data)
        consume_data_copy[3][0] += 1
        consume_data_copy[3][1] += 1
        result = is_afford(self.player, parse(consume_data_copy))
        self.assertEqual(result.get('result'), False)

        consume_data_copy = copy.deepcopy(consume_data)
        consume_data_copy[4][0] += 1
        consume_data_copy[4][1] += 1
        result = is_afford(self.player, parse(consume_data_copy))
        self.assertEqual(result.get('result'), False)

        consume_data_copy = copy.deepcopy(consume_data)
        consume_data_copy[5][0] += 1
        consume_data_copy[5][1] += 1
        result = is_afford(self.player, parse(consume_data_copy))
        self.assertEqual(result.get('result'), False)

    def test_consume(self):
        consume_data = {1: [30000, 30000, 0],
                        2: [10000, 10000, 0],
                        3: [20000, 20000, 0],
                        4: [300, 300, 1000112],
                        5: [2, 2, 1000111]}

        consume(self.player, parse(consume_data))

        self.assertEqual(self.player.finance.coin, 0, 'coin %d_%d' % (self.player.finance.coin, 0))
        self.assertEqual(self.player.finance.hero_soul, 0, 'hero_soul %d_%d' % (self.player.finance.hero_soul, 0))
        self.assertEqual(self.player.finance.gold, 0, 'gold %d_%d' % (self.player.finance.gold, 0))
        hero_chip = self.player.hero_chip_component.get_chip(1000112)
        self.assertEqual(hero_chip.num, 0, 'chips_count %d_%d' % (hero_chip.num, 0))

        item = self.player.item_package.get_item(1000111)
        self.assertEqual(item.num, 0, 'item_count %d_%d' % (item.num, 0))

    def test_gain(self):
        gain_data = {COIN: [30000, 30000, 0],
                     GOLD: [10000, 10000, 0],
                     HERO_SOUL: [20000, 20000, 0],
                     HERO_CHIP: [300, 300, 1000112],
                     ITEM: [2, 2, 1000111]}

        gain(self.player, parse(gain_data))

        coin = self.player.finance.coin
        hero_soul = self.player.finance.hero_soul
        gold = self.player.finance.gold

        hero_chip = self.player.hero_chip_component.get_chip(1000112)
        item = self.player.item_package.get_item(1000111)

        self.assertEqual(coin, 60000, "%d_%d" % (coin, 60000))
        self.assertEqual(hero_soul, 40000, "%d_%d" % (hero_soul, 40000))
        self.assertEqual(gold, 20000, "%d_%d" % (gold, 20000))
        self.assertEqual(hero_chip.num, 600, "%d_%d" % (hero_chip.num, 600))
        self.assertEqual(item.num, 4, "%d_%d" % (item.num, 4))

        gain_data = {HERO: [1, 1, 10005]}
        gain(self.player, parse(gain_data))

        hero = self.player.hero_component.get_hero(10005)
        self.assertFalse(hero==None)
        self.assertEqual(hero.hero_no, 10005, "%d_%d" % (hero.hero_no, 10005))

        gain_data = {HERO: [1, 1, 10005]}
        gain(self.player, parse(gain_data))

        hero_chip = self.player.hero_chip_component.get_chip(1010005)
        self.assertEqual(hero_chip.num, 20, "%d_%d" % (hero_chip.num, 20))

        gain_data = {EQUIPMENT: [1, 1, 110005]}
        gain(self.player, parse(gain_data))
        lst = self.get_equipmnets_by_no(110005)
        self.assertEqual(len(lst), 1)

        gain(self.player, parse(gain_data))
        lst = lst = self.get_equipmnets_by_no(110005)
        self.assertEqual(len(lst), 2)

    def get_equipmnets_by_no(self, no):
        lst = []
        equipments = self.player.equipment_component.get_all()

        for equipment in equipments:
            if equipment.base_info.equipment_no == no:
                lst.append(equipment)
        return lst











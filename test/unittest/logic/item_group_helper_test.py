# -*- coding:utf-8 -*-
"""
created by server on 14-7-10下午3:17.
"""
import test.unittest.init_data.init_connection
import unittest
from app.game.core.PlayersManager import PlayersManager
from app.game.core.item_group_helper import *
from shared.db_opear.configs_data.data_helper import parse
from shared.utils.const import *
from app.proto_file.common_pb2 import GameResourcesResponse


class ItemGroupHelperTest(unittest.TestCase):
    def setUp(self):
        from test.unittest.init_test_data import init

        self.player = init()
        #self.player = PlayersManager().get_player_by_id(1)

    def tst_parse(self):
        data = {1: [1, 1, 1001], 2: [2, 2, 1002], 3: [3, 3, 1003]}
        item_group = parse(data)
        first = item_group[0]
        self.assertEqual(first.item_type, 1, "first item type id error!%d_%d" % (first.item_type, 1))
        self.assertEqual(first.num, 1, "first item type id error!%d_%d" % (first.num, 1))
        self.assertEqual(first.item_no, 1001, "first item type id error!%d_%d" % (first.item_no, 0011))

        last = item_group[len(item_group) - 1]
        self.assertEqual(last.item_type, 3, "first item type id error!%d_%d" % (last.item_type, 3))
        self.assertEqual(last.num, 3, "first item type id error!%d_%d" % (last.num, 3))
        self.assertEqual(last.item_no, 1003, "first item type id error!%d_%d" % (last.item_no, 1003))

    def tst_is_afford(self):
        consume_data = {const.COIN: [30000, 30000, 0],
                        const.GOLD: [10000, 10000, 0],
                        const.HERO_SOUL: [20000, 20000, 0],
                        const.HERO_CHIP: [300, 300, 1000112],
                        const.EQUIPMENT_CHIP: [300, 300, 1000112],
                        const.ITEM: [2, 2, 1000111]}

        result = is_afford(self.player, parse(consume_data))
        self.assertEqual(result.get('result'), True)

        import copy

        consume_data_copy = copy.deepcopy(consume_data)
        consume_data_copy[const.COIN][0] += 1
        consume_data_copy[const.COIN][1] += 1
        result = is_afford(self.player, parse(consume_data_copy))
        self.assertEqual(result.get('result'), False)
        consume_data_copy = copy.deepcopy(consume_data)
        consume_data_copy[const.GOLD][0] += 1
        consume_data_copy[const.GOLD][1] += 1
        result = is_afford(self.player, parse(consume_data_copy))
        self.assertEqual(result.get('result'), False)

        consume_data_copy = copy.deepcopy(consume_data)
        consume_data_copy[const.HERO_SOUL][0] += 1
        consume_data_copy[const.HERO_SOUL][1] += 1
        result = is_afford(self.player, parse(consume_data_copy))
        self.assertEqual(result.get('result'), False)

        consume_data_copy = copy.deepcopy(consume_data)
        consume_data_copy[const.HERO_CHIP][0] += 1
        consume_data_copy[const.HERO_CHIP][1] += 1
        result = is_afford(self.player, parse(consume_data_copy))
        self.assertEqual(result.get('result'), False)

        consume_data_copy = copy.deepcopy(consume_data)
        consume_data_copy[const.EQUIPMENT_CHIP][0] += 1
        consume_data_copy[const.EQUIPMENT_CHIP][1] += 1
        result = is_afford(self.player, parse(consume_data_copy))
        self.assertEqual(result.get('result'), False)

        consume_data_copy = copy.deepcopy(consume_data)
        consume_data_copy[const.ITEM][0] += 1
        consume_data_copy[const.ITEM][1] += 1
        result = is_afford(self.player, parse(consume_data_copy))
        self.assertEqual(result.get('result'), False)

    def tst_consume(self):
        consume_data = {const.COIN: [30000, 30000, 0],
                        const.GOLD: [10000, 10000, 0],
                        const.HERO_SOUL: [20000, 20000, 0],
                        const.HERO_CHIP: [300, 300, 1000112],
                        const.EQUIPMENT_CHIP: [300, 300, 1000112],
                        const.ITEM: [2, 2, 1000111]}

        consume(self.player, parse(consume_data))

        self.assertEqual(self.player.finance.coin, 0, 'coin %d_%d' % (self.player.finance.coin, 0))
        self.assertEqual(self.player.finance.hero_soul, 0, 'hero_soul %d_%d' % (self.player.finance.hero_soul, 0))
        self.assertEqual(self.player.finance.gold, 0, 'gold %d_%d' % (self.player.finance.gold, 0))
        hero_chip = self.player.hero_chip_component.get_chip(1000112)
        equipment_chip = self.player.equipment_chip_component.get_chip(1000112)
        self.assertEqual(hero_chip.num, 0, 'chips_count %d_%d' % (hero_chip.num, 0))
        self.assertEqual(equipment_chip.chip_num, 0, 'chips_count %d_%d' % (equipment_chip.chip_num, 0))

        item = self.player.item_package.get_item(1000111)
        self.assertEqual(item.num, 0, 'item_count %d_%d' % (item.num, 0))

    def tst_gain(self):
        gain_data = {const.COIN: [30000, 30000, 0],
                     const.GOLD: [10000, 10000, 0],
                     const.HERO_SOUL: [20000, 20000, 0],
                     const.HERO_CHIP: [300, 300, 1000112],
                     const.EQUIPMENT_CHIP: [300, 300, 1000112],
                     const.ITEM: [2, 2, 1000111]}

        gain(self.player, parse(gain_data))

        coin = self.player.finance.coin
        hero_soul = self.player.finance.hero_soul
        gold = self.player.finance.gold

        hero_chip = self.player.hero_chip_component.get_chip(1000112)
        equipment_chip = self.player.equipment_chip_component.get_chip(1000112)
        item = self.player.item_package.get_item(1000111)

        self.assertEqual(coin, 60000, "%d_%d" % (coin, 60000))
        self.assertEqual(hero_soul, 40000, "%d_%d" % (hero_soul, 40000))
        self.assertEqual(gold, 20000, "%d_%d" % (gold, 20000))
        self.assertEqual(hero_chip.num, 600, "%d_%d" % (hero_chip.num, 600))
        self.assertEqual(equipment_chip.chip_num, 600, "%d_%d" % (equipment_chip.chip_num, 600))
        self.assertEqual(item.num, 4, "%d_%d" % (item.num, 4))

        gain_data = {const.HERO: [1, 1, 10011]}
        gain(self.player, parse(gain_data))

        hero = self.player.hero_component.get_hero(10011)
        self.assertFalse(hero == None)
        self.assertEqual(hero.hero_no, 10011, "%d_%d" % (hero.hero_no, 10011))

        gain_data = {const.HERO: [1, 1, 10005]}
        gain(self.player, parse(gain_data))

        hero_chip = self.player.hero_chip_component.get_chip(1000113)
        self.assertEqual(hero_chip.num, 20, "%d_%d" % (hero_chip.num, 20))

        gain_data = {const.EQUIPMENT: [1, 1, 110005]}
        gain(self.player, parse(gain_data))
        lst = self.get_equipmnets_by_no(110005)
        self.assertEqual(len(lst), 2)

        gain(self.player, parse(gain_data))
        lst = lst = self.get_equipmnets_by_no(110005)
        self.assertEqual(len(lst), 3)

    def get_equipmnets_by_no(self, no):
        lst = []
        equipments = self.player.equipment_component.get_all()

        for equipment in equipments:
            if equipment.base_info.equipment_no == no:
                lst.append(equipment)
        return lst

    def tst_get_return(self):
        response = GameResourcesResponse()
        return_data = [[const.COIN, 30000, 0],
                       [const.GOLD, 10000, 0],
                       [const.HERO_SOUL, 20000, 0],
                       [const.HERO_CHIP, 300, 1000112],
                       [const.EQUIPMENT_CHIP, 300, 1000112],
                       [const.ITEM, 2, 1000111],
                       [const.HERO, 1, 10001]]
        get_return(self.player, return_data, response)

        self.assertEqual(response.finance.coin, 30000, "%d_%d" % (response.finance.coin, 30000))
        self.assertEqual(response.finance.gold, 10000, "%d_%d" % (response.finance.gold, 10000))
        self.assertEqual(response.finance.hero_soul, 20000, "%d_%d" % (response.finance.hero_soul, 20000))

        # hero
        hero = response.heros[0]
        self.assertFalse(hero == None, "hero")
        self.assertEqual(hero.hero_no, 10001, "%d_%d" % (hero.hero_no, 10001))
        self.assertEqual(hero.level, 11, "%d_%d" % (hero.level, 11))
        self.assertEqual(hero.exp, 1, "%d_%d" % (hero.exp, 1))
        self.assertEqual(hero.break_level, 1, "%d_%d" % (hero.break_level, 1))

        # equipment
        # 单独测试装备
        equipment = self.player.equipment_component.get_all()[0]
        return_data = [[const.EQUIPMENT, 1, equipment.base_info.id]]
        get_return(self.player, return_data, response)
        equipment_pb = response.equipments[0]
        self.assertFalse(equipment == None, "equipment")
        self.assertEqual(equipment_pb.no, equipment.base_info.equipment_no, "%d_%d" %
                         (equipment_pb.no, equipment.base_info.equipment_no))
        self.assertEqual(equipment_pb.strengthen_lv, equipment.attribute.strengthen_lv, "%d_%d" %
                         (equipment_pb.strengthen_lv, equipment.attribute.strengthen_lv))
        self.assertEqual(equipment_pb.awakening_lv, equipment.attribute.awakening_lv, "%d_%d" %
                         (equipment_pb.awakening_lv, equipment.attribute.awakening_lv))
        # todo: 添加详细信息测试
        self.assertEqual(equipment_pb.nobbing_effect, 0, "%d_%d" %
                         (equipment_pb.nobbing_effect, 0))
        self.assertEqual(equipment_pb.hero_no, 0, "%d_%d" %
                         (equipment_pb.hero_no, 0))

        # hero_chip
        hero_chip = response.hero_chips[0]
        self.assertFalse(hero_chip == None, "hero_chip")
        self.assertEqual(hero_chip.hero_chip_no, 1000112, "%d_%d" % (hero_chip.hero_chip_no, 1000112))
        self.assertEqual(hero_chip.hero_chip_num, 300, "%d_%d" % (hero_chip.hero_chip_num, 300))

        # equipment_chip
        equipment_chip = response.equipment_chips[0]
        self.assertFalse(equipment_chip == None, "equipment_chip")
        self.assertEqual(equipment_chip.equipment_chip_no, 1000112, "%d_%d" % (equipment_chip.equipment_chip_no, 1000112))
        self.assertEqual(equipment_chip.equipment_chip_num, 300, "%d_%d" % (equipment_chip.equipment_chip_num, 300))


    def test_gain(self):
        response = GameResourcesResponse()
        gain_data = {106:[1,1,1203]}
        #print(self.player)
        return_data = gain(self.player, parse(gain_data), 111)
        get_return(self.player, return_data, response)
        print response


if __name__ == '__main__':
    unittest.main()













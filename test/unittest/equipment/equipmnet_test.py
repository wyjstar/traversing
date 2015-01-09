# -*- coding:utf-8 -*-
"""
created by server on 14-7-10下午5:06.
"""
import test.unittest.init_data.init_connection
from app.game.core.PlayersManager import PlayersManager
import unittest
from app.game.redis_mode import tb_equipment_info


class EquipmentTest(unittest.TestCase):

    def setUp(self):
        from test.unittest.init_test_data import init
        init()
        self.player = PlayersManager().get_player_by_id(1)

    def test_add_equipment(self):
        equipment = self.player.equipment_component.add_equipment(100001)
        equipment.base_info.base_name = 'e3'
        equipment.attribute.strengthen_lv = 3
        equipment.attribute.awakening_lv = 4
        equipment.enhance_record.enhance_record.append((1,2,1000))
        equipment.save_data()


        data = tb_equipment_info.getObj(equipment.base_info.id)

        equipment = self.player.equipment_component.get_equipment(equipment.base_info.id)
        name = equipment.base_info.base_name
        slv = equipment.attribute.strengthen_lv
        alv = equipment.attribute.awakening_lv
        self.assertEqual(equipment.base_info.equipment_no, 110003, "%d_%d" % (equipment.base_info.equipment_no, 110003))
        self.assertEqual(name, 'e3', "%s_%s" % (name, 'e3'))

        self.assertEqual(slv, 3, "%d_%d" % (slv, 3))
        self.assertEqual(alv, 4, "%d_%d" % (alv, 4))

        data = tb_equipment_info.getObj(equipment.base_info.id).get('equipment_info')
        print 'equipment_no', data.get('equipment_no')
        self.assertEqual(data.get('equipment_no'), 110003, "%d_%d" % (data.get('equipment_no'), 110003))
        self.assertEqual(data.get('slv'), 3, "%d_%d" % (data.get('slv'), 3))
        self.assertEqual(data.get('alv'), 4, "%d_%d" % (data.get('alv'), 4))

    def test_delete_equipment(self):

        print '#2 -------------------------------'
        print self.player.equipment_component.get_all()

        equipment = self.player.equipment_component.get_all()[0]

        self.player.equipment_component.delete_equipment(equipment.base_info.id)
        first = self.player.equipment_component.get_equipment(equipment.base_info.id)
        self.assertTrue(first == None)

    def test_save_data(self):
        first = self.player.equipment_component.get_all()[0]

        first.base_info.base_name = 'e3'
        first.attribute.strengthen_lv = 3
        first.attribute.awakening_lv = 4
        first.save_data()

        equipment = self.player.equipment_component.get_equipment(first.base_info.id)
        name = equipment.base_info.base_name
        slv = equipment.attribute.strengthen_lv
        alv = equipment.attribute.awakening_lv
        self.assertEqual(equipment.base_info.equipment_no, first.base_info.equipment_no, "%d_%d" % (equipment.base_info.equipment_no, first.base_info.equipment_no))
        self.assertEqual(name, 'e3', "%s_%s" % (name, 'e3'))









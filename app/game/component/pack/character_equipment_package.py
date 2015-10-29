# -*- coding:utf-8 -*-
"""
created by server on 14-7-7上午11:39.
"""
from app.game.component.Component import Component
from app.game.core.equipment.equipment import Equipment
from app.game.redis_mode import tb_character_info
from shared.utils.pyuuid import get_uuid
from shared.db_opear.configs_data import game_configs
from app.game.core.task import hook_task, CONDITIONId


class CharacterEquipmentPackageComponent(Component):
    """角色的装备背包
    """

    def __init__(self, owner):
        super(CharacterEquipmentPackageComponent, self).__init__(owner)
        self._equipments_obj = {}  # {装备ID：装备obj}

    @property
    def equipments_obj(self):
        return self._equipments_obj

    def init_data(self, c):
        character_id = self.owner.base_info.id
        char_obj = tb_character_info.getObj(self.owner.base_info.id).getObj('equipments')
        equipments = char_obj.hgetall()

        for eid, equipment_data in equipments.items():
            equipment_info = equipment_data.get('equipment_info')
            equipment_id = equipment_data.get('id')

            equipment_no = equipment_info.get('equipment_no')  # 装备编号
            strengthen_lv = equipment_info.get('slv')  # 装备强化等级
            awakening_lv = equipment_info.get('alv')  # 装备觉醒等级
            main_attr = equipment_info.get('main_attr', {})
            minor_attr = equipment_info.get('minor_attr', {})
            is_guard = equipment_info.get('is_guard')  # guard
            exp = equipment_info.get('exp', 0)
            prefix = equipment_info.get('prefix')  # prefix
            attr_id = equipment_info.get('attr_id', 0)  # attr_id

            enhance_info = equipment_data.get('enhance_info')  # 装备强化花费记录
            nobbing_effect = equipment_data.get('nobbing_effect')  # 装备锤炼效果

            equipment_obj = Equipment(character_id, equipment_id, '',
                                      equipment_no, strengthen_lv,
                                      awakening_lv, enhance_info,
                                      nobbing_effect, is_guard,
                                      main_attr, minor_attr, prefix, attr_id,
                                      exp)
            self._equipments_obj[equipment_id] = equipment_obj

    def save_data(self):
        return

    def new_data(self):
        return {}

    def add_equipment(self, equipment_no, lucky_attr=0):
        """添加装备
        """
        character_id = self.owner.base_info.id
        equipment_id = get_uuid()
        equipment_obj = Equipment(character_id, equipment_id, '', equipment_no)
        self._equipments_obj[equipment_id] = equipment_obj

        equipment_obj.add_data(self.owner.base_info.id, lucky_attr)

        equ_conf = game_configs.equipment_config.get(equipment_no)

        cid = 0
        color = equ_conf.color
        color_num = 0
        star6_num = 0
        if equ_conf.color == 1:
            cid = CONDITIONId.GREEN_EQU
        elif equ_conf.color == 2:
            cid = CONDITIONId.BLUE_EQU
        for _, equ_obj in self._equipments_obj.items():
            e_conf = game_configs.equipment_config. \
                get(equ_obj.base_info.equipment_no)
            if e_conf.color == color and cid:
                color_num += 1
            if e_conf.quality == 6:
                star6_num += 1
        if color_num:
            hook_task(self.owner, cid, color_num)
        if star6_num:
            hook_task(self.owner, CONDITIONId.STAR6_EQU, star6_num)

        return equipment_obj

    def add_exist_equipment(self, equipment):
        self._equipments_obj[equipment.base_info.id] = equipment
        equipment.add_data(self.owner.base_info.id)

    def delete_equipment(self, equipment_id):
        equipment = self._equipments_obj[equipment_id]
        equipment.delete()
        del self._equipments_obj[equipment_id]

    def get_equipment(self, equipment_id):
        """根据装备ID 取得装备
        @param equipment_id: 装备ID
        @return: 装备对象
        """
        if equipment_id in self._equipments_obj:
            return self._equipments_obj[equipment_id]
        return None

    def get_by_type(self, equipment_type):
        """根据装备类型 取得装备
        @param equipment_type:
        @return:
        """
        return [equipment_obj.equipment_type for equipment_obj in self._equipments_obj.values() if
                equipment_obj.equipment_type and (equipment_obj.equipment_type == equipment_type)]

    def get_all(self):
        """返回全部装备
        """
        return self._equipments_obj.values()

    def is_guard(self, equipment_id):
        """
        是否在驻守中, 秘境相关
        """
        temp = self._equipments_obj.get(equipment_id)
        assert temp is not None, ("equipment %s not exists!" % equipment_id)
        return temp.is_guard

    def get_equipment(self, equipment_id):
        """根据装备ID 取得装备
        @param equipment_id: 装备ID
        @return: 装备对象
        """
        if equipment_id in self._equipments_obj:
            return self._equipments_obj[equipment_id]
        return None

    def get_equipment_num(self, equipment_no):
        num = 0
        for equipment_obj in self._equipments_obj.values():
            if equipment_obj.base_info.equipment_no == equipment_no:
                num += 1
        return num

    def get_quality_equip_count(self, quality):
        """
        :param quality: 指定品质类型
        :return:返回指定品质装备数量
        """
        count = 0
        for equip_id in self._equipments_obj:
            equip = game_configs.equipment_config[equip_id]
            if equip.quality >= quality:
                count += 1
        return count

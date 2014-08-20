# -*- coding:utf-8 -*-
"""
created by server on 14-8-13下午3:44.
"""
from app.game.component.baseInfo.slot_base_info import SlotBaseInfoComponent
from app.game.core.fight.skill import Skill
from app.game.core.fight.skill_helper import SkillHelper


class EquipmentSlotComponent(SlotBaseInfoComponent):
    """阵容装备格子
    """

    def __init__(self, owner, slot_no, activation=False, equipment_id=0, base_name=''):
        super(EquipmentSlotComponent, self).__init__(owner, slot_no, base_name, activation)

        self._equipment_id = equipment_id  # 装备

    @property
    def equipment_id(self):
        """装备ID
        """
        return self._equipment_id

    @equipment_id.setter
    def equipment_id(self, equipment_id):
        self._equipment_id = equipment_id

    @property
    def equipment_obj(self):
        """取得装备对象
        """
        # player_obj = self.owner.owner.owner  # -^_^- PlayerCharacter obj
        # equipment_obj = player_obj.equipment_component.equipments_obj.get(self._equipment_id, None)
        # return equipment_obj
        return self.owner.get_equipment_obj(self._equipment_id) if self._equipment_id else None

    @property
    def suit(self):
        """套装信息
        """
        equ_no_list = self.owner.equipment_nos  # 全部装备编号
        suit_conf = self.equipment_obj.suit_conf
        if not suit_conf:
            return {'num': 0, 'suit_no': 0}
        suit_intersection = list(set(equ_no_list).intersection(set(suit_conf.suitMapping)))  # 获取两个list 的交集
        return {'num': len(suit_intersection), 'suit_no': suit_conf.id}  # 激活数量，激活编号

    @property
    def suit_attr(self):
        """套装属性值
        """
        skills = []
        for skill_id in self.suit_skills:
            skill = Skill(skill_id)
            skill.init_attr()
            skills.append(skill)
        skill_helper = SkillHelper(skills)
        skill_helper.init_attr()
        attr = skill_helper.parse_buffs()
        return attr

    @property
    def suit_skills(self):
        """套装附加技能
        """
        suit = self.suit  # 套装数据
        suit_conf = self.equipment_obj.suit_conf  # 套装配置
        num = suit.get('num', 0)  # 套装激活数量
        skills = []
        for i in range(num):
            skill = getattr(suit_conf, 'attr%s' % (i+1))
            skills.append(skill)
        return skills














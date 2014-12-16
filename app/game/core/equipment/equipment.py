# -*- coding:utf-8 -*-
"""
created by server on 14-7-7下午5:26.
"""
from app.game.component.baseInfo.equipment_base_info import EquipmentBaseInfoComponent
from app.game.component.equipment.equipment_attribute import EquipmentAttributeComponent
from app.game.component.record.equipment_enhance import EquipmentEnhanceComponent
from app.game.redis_mode import tb_equipment_info
from shared.db_opear.configs_data import game_configs
from shared.db_opear.configs_data.common_item import CommonItem
from shared.utils.random_pick import random_pick_with_percent
from shared.db_opear.configs_data.game_configs import base_config
from shared.db_opear.configs_data.game_configs import formula_config
from gfirefly.server.logobj import logger
# from shared.utils.const import const
import random
import copy


EQUIP_ATTR_CONFIG = game_configs.equipment_attribute_config


def init_equipment_attr(equipment_no, is_special=False):
    mainAttr, minorAttr = {}, {}
    equipment_item = game_configs.equipment_config.get(equipment_no)
    if not equipment_item:
        logger.error('error equipment no:%s', equipment_no)
        return mainAttr, minorAttr

    equip_attr_id = equipment_item.specialAttr if is_special else equipment_item.attr
    equipment_attr_item = EQUIP_ATTR_CONFIG.get(int(equip_attr_id))
    if not equipment_attr_item:
        logger.error('error equipment attr no:%s:%s',
                     equip_attr_id, equipment_no)
        return mainAttr, minorAttr

    main_num = equipment_attr_item.get('mainAttrNum')
    minor_num_min, minor_num_min = equipment_attr_item.get('minorAttrNum')
    minor_num = random.randint(minor_num_min, minor_num_min)

    main_pool = copy.copy(equipment_attr_item.get('mainAttr'))
    minor_pool = copy.copy(equipment_attr_item.get('minorAttr'))

    for _ in range(main_num):
        at, avt, av, ai = rand_pick_attr(main_pool)
        mainAttr[at] = [avt, av, ai]
    for _ in range(minor_num):
        at, avt, av, ai = rand_pick_attr(minor_pool)
        minorAttr[at] = [avt, av, ai]

    assert main_num == len(mainAttr)
    assert minor_num == len(minorAttr)

    return mainAttr, minorAttr


def rand_pick_attr(attr):
    attrType, attrValueType, attrValue, attrIncrement = -1, -1, -1, 0
    rand_pool = {}
    for at, v in attr.items():
        rand_pool[at] = int(v[0] * 100)
    rand = random.randint(0, sum(rand_pool.values()))

    for k, v in rand_pool.items():
        if v >= rand:
            attrType = k
            if len(attr[k]) == 5:
                _, attrValueType, valueMin, valueMax, attrIncrement = attr[k]
            else:
                _, attrValueType, valueMin, valueMax = attr[k]
            attrValue = int(valueMin + random.random() * (valueMax - valueMin))
            del attr[k]
            break
        else:
            rand -= v
    return attrType, attrValueType, attrValue, attrIncrement


class Equipment(object):
    """装备 """

    def __init__(self, equipment_id, equipment_name, equipment_no,
                 strengthen_lv=1, awakening_lv=1, enhance_record=[],
                 nobbing_effect={}, main_attr={}, minor_attr={}):
        self._base_info = EquipmentBaseInfoComponent(self,
                                                     equipment_id,
                                                     equipment_name,
                                                     equipment_no)
        self._attribute = EquipmentAttributeComponent(self,
                                                      strengthen_lv,
                                                      awakening_lv,
                                                      nobbing_effect,
                                                      main_attr,
                                                      minor_attr)
        self._record = EquipmentEnhanceComponent(self, enhance_record)

    def add_data(self, character_id):
        no = self._base_info.equipment_no
        mainAttr, minorAttr = init_equipment_attr(no)
        self._attribute.main_attr = mainAttr
        self._attribute.minor_attr = minorAttr
        data = dict(id=self._base_info.id,
                    character_id=character_id,
                    equipment_info=dict(equipment_no=no,
                                        slv=self._attribute.strengthen_lv,
                                        alv=self._attribute.awakening_lv,
                                        main_attr=mainAttr,
                                        minor_attr=minorAttr),
                    enhance_info=self._record.enhance_record,
                    nobbing_effect=self._attribute.nobbing_effect)

        tb_equipment_info.new(data)

    def save_data(self):
        data = {
            'equipment_info': {'equipment_no': self._base_info.equipment_no,
                               'slv': self._attribute.strengthen_lv,
                               'alv': self._attribute.awakening_lv,
                               'main_attr': self._attribute.main_attr,
                               'minor_attr': self._attribute.minor_attr},
            'enhance_info': self._record.enhance_record,
            'nobbing_effect': self._attribute.nobbing_effect
        }

        items_data = tb_equipment_info.getObj(self._base_info.id)
        items_data.update_multi(data)

    def delete(self):
        items_data = tb_equipment_info.getObj(self._base_info.id)
        items_data.delete()

    @property
    def base_info(self):
        return self._base_info

    @property
    def attribute(self):
        return self._attribute

    def enhance(self, player):
        """强化
        """
        before_lv = self._attribute.strengthen_lv
        enhance_lv = 1
        extra_enhance = self.get_extra_enhance_times(player) * enhance_lv

        self._attribute.modify_single_attr('strengthen_lv', extra_enhance, add=True)
        after_lv = self._attribute.strengthen_lv

        return before_lv, after_lv

    def get_extra_enhance_times(self, player):
        """ 获取强化暴击倍数
        return: 暴击倍数
        """
        items = player.vip_component.equipment_strength_cli_times
        times = random_pick_with_percent(items)
        if times:
            return times
        return 1

    def nobbing(self):
        """锤炼
        """
        pass

    @property
    def melting_item(self):
        """熔炼获得的配置物品
        """
        equipment_no = self._base_info.equipment_no
        equ_config_obj = game_configs.equipment_config.get(equipment_no, None)
        return equ_config_obj.gain

    @property
    def awakening_item(self):
        """觉醒需要装备，数量"""
        equipment_no = self._base_info.equipment_no
        equ_config_obj = game_configs.equipment_config.get(equipment_no, None)
        return equ_config_obj.awakening_item

    @property
    def suit_conf(self):
        """套装信息
        """
        equipment_no = self._base_info.equipment_no
        # 装备配置
        equ_conf_obj = game_configs.equipment_config.get(equipment_no, None)
        if not equ_conf_obj:
            return None
        suit_no = equ_conf_obj.suitNo
        suit_conf_obj = game_configs.set_equipment_config.get(suit_no)
        return suit_conf_obj

    def update_pb(self, equipment_pb):
        equipment_pb.id = self.base_info.id
        equipment_pb.no = self.base_info.equipment_no
        equipment_pb.strengthen_lv = self.attribute.strengthen_lv
        equipment_pb.awakening_lv = self.attribute.awakening_lv
        equipment_pb.nobbing_effect = 0
        equipment_pb.hero_no = 0

        for (attr_type, [attr_value_type, attr_value, attr_increment]) in self.attribute.main_attr.items():
            main_attr_pb = equipment_pb.main_attr.add()
            main_attr_pb.attr_type = attr_type
            main_attr_pb.attr_value_type = attr_value_type
            main_attr_pb.attr_value = attr_value
            main_attr_pb. attr_increment = attr_increment

        for (attr_type, [attr_value_type, attr_value, attr_increment]) in self.attribute.minor_attr.items():
            minor_attr_pb = equipment_pb.minor_attr.add()
            minor_attr_pb.attr_type = attr_type
            minor_attr_pb.attr_value_type = attr_value_type
            minor_attr_pb.attr_value = attr_value
            minor_attr_pb.attr_increment = attr_increment

    def calculate_attr(self):
        """根据属性和强化等级计算装备属性"""
        # hpEqu             装备加生命值    中间值  1   baseHp+growHp*equLevel
        # atkEqu            装备加攻击力    中间值  1   baseAtk+growAtk*equLevel
        # physicalDefEqu    装备加物防  中间值  1   basePdef+growPdef*equLevel
        # magicDefEqu       装备加魔防  中间值  1   baseMdef+growMdef*equLevel
        # hitEqu            装备加命中  中间值  1   hit
        # dodgeEqu          装备加闪避  中间值  1   dodge
        # criEqu            装备加暴击  中间值  1   cri
        # criCoeffEqu       装备加暴伤  中间值  1   criCoeff
        # criDedCoeffEqu    装备加暴免  中间值  1   criDedCoeff
        # blockEqu          装备加格挡  中间值  1   block
        # ductilityEqu      装备加韧性  中间值  1   ductility

        # 1：加生命值上限
        # 2：加攻击力
        # 3：加物理防御
        # 4：加魔法防御
        # 5：加命中率
        # 6：加闪避率
        # 7：暴击率
        # 8：加暴击伤害
        # 9：加暴伤减免
        # 10：加格挡率
        # 11：加韧性

        result = {'hp_rate': 0,
                  'atk_rate': 0,
                  'physical_def_rate': 0,
                  'magic_def_rate': 0}
        varNames = {1: 'baseHp',
                    2: 'baseAtk',
                    3: 'basePdef',
                    4: 'baseMdef',
                    5: 'hit',
                    6: 'dodge',
                    7: 'cri',
                    8: 'criCoeff',
                    9: 'criDedCoeff',
                    10: 'block',
                    11: 'ductility'}
        varNames2 = {1: 'growHp',
                     2: 'growAtk',
                     3: 'growPdef',
                     4: 'growMdef'}
        varNames3 = {1: 'hp_rate',
                     2: 'atk_rate',
                     3: 'physical_def_rate',
                     4: 'magic_def_rate'}

        allVars = dict(baseHp=0,
                       baseAtk=0,
                       basePdef=0,
                       baseMdef=0,
                       hit=0,
                       dodge=0,
                       cri=0,
                       criCoeff=0,
                       criDedCoeff=0,
                       block=0,
                       ductility=0,
                       growHp=0,
                       growAtk=0,
                       growPdef=0,
                       growMdef=0,
                       equLevel=0)

        for k, v in self._attribute.main_attr.items():
            assert varNames[k] in allVars
            avt, av, ai = v
            if avt == 1:
                allVars[varNames[k]] += av
                if k in varNames2:
                    allVars[varNames2[k]] += ai
            elif avt == 2:
                if varNames3[k] in result:
                    result[varNames3[k]] += av
                else:
                    raise Exception('error %s:%s:%s' % avt, k, varNames3[k])
        for k, v in self._attribute.minor_attr.items():
            assert varNames[k] in allVars
            avt, av, ai = v
            if avt == 1:
                allVars[varNames[k]] += av
                if k in varNames2:
                    allVars[varNames2[k]] += ai
            elif avt == 2:
                if varNames3[k] in result:
                    result[varNames3[k]] += av
                else:
                    raise Exception('error %s:%s:%s' % avt, k, varNames3[k])

        formulas = dict(hp='hpEqu',
                        atk='atkEqu',
                        physical_def='physicalDefEqu',
                        magic_def='magicDefEqu',
                        hit='hitEqu',
                        dodge='dodgeEqu',
                        cri='criEqu',
                        cri_coeff='criCoeffEqu',
                        cri_ded_coeff='criDedCoeffEqu',
                        block='blockEqu',
                        ductility='ductilityEqu')

        for k, v in formulas.items():
            formula = formula_config.get(v)
            if not formula:
                raise Exception('cant find formula by name:%s' % k)
            result[k] = eval(formula.formula, allVars, allVars)

        # print 'result:'*4, self._base_info.equipment_no, result
        # print '-'*32
        # print 'allVars:', allVars
        # print '='*32

        return CommonItem(result)

    @property
    def strength_max(self):
        """获取装备上限为玩家等级+strength_max"""
        return base_config.get("max_equipment_strength", 3)

    @property
    def enhance_record(self):
        return self._record

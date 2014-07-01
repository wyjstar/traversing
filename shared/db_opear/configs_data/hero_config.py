# -*- coding:utf-8 -*-
"""
created by server on 14-6-26下午3:39.
"""

from shared.db_opear.configs_data.base_config import BaseConfig
import json


class HeroConfig(BaseConfig):
    """武将配置类"""
    def parser(self, config_value):
        """解析config到HeroConfig"""
        for hero_no, value in config_value.items():
            self[hero_no] = self.Item(value)

    class Item(object):
        """内部类：单个英雄配置文件"""
        def __init__(self, jsondata):
            self.no = jsondata['id']
            self.name = jsondata['name']    # 武将名称
            self.name_str = jsondata['nameStr']     # 英雄名称文字
            self.describe_str = jsondata['describeStr']    # 英雄描述文字
            self.quality = jsondata['quality']    # 英雄品质
            self.normal_skill = jsondata['normalSkill']    # 普通技能
            self.rage_skill = jsondata['rageSkill']    # 怒气技能
            self.hp = jsondata['hp']
            self.grow_hp = jsondata['growHp']
            self.atk = jsondata['atk']
            self.grow_atk = jsondata['growAtk']
            self.physical_def = jsondata['physicalDef']
            self.grow_physical_def = jsondata['growPhysicalDef']
            self.magic_def = jsondata['magicDef']
            self.grow_magic_def = jsondata['growMagicDef']
            self.hit = jsondata['hit']    # 命中率
            self.dodge = jsondata['dodge']    # 闪避率
            self.cri = jsondata['cri']    # 暴击率
            self.cri_coeff = jsondata['criCoeff']    # 暴击伤害系数
            self.cri_ded_coeff = jsondata['criDedCoeff']    # 暴伤减免系数
            self.block = jsondata['block']    # 格挡率
            self.res = jsondata['res']    # 美术资源ID
            self.audio = jsondata['audio']    # 声效ID
            self.sacrifice_currencysacrifice = jsondata['sacrificeCurrencysacrifice']    # 献祭可得货币类型
            self.sacrifice_currency_count = jsondata['sacrificeCurrencyCount']    # 献祭可得货币数量
            self.sell_currency = jsondata['sellCurrency']    # 出售可得货币类型
            self.sell_urrency_count = jsondata['sellCurrencyCount']    # 出售可得货币数量
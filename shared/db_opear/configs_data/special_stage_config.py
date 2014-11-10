# -*- coding:utf-8 -*-
"""
created by server on 14-9-24下午3:23.
"""

from shared.db_opear.configs_data.common_item import CommonItem


class SpecialStageConfig(object):
    """关卡配置信息
    """

    def __init__(self):
        self._elite_stages = {}  # 精英关卡  关卡ID：关卡信息
        self._act_stages = {}  # 活动关卡
        self._boss_stages = {}  # boss关卡
        self._first_stage_id = []  # 第一关
        self._condition_mapping = {}  # 开启条件 {'开启条件关卡编号'：['开启关卡编号']}

    def parser(self, config_value):
        for row in config_value:
            item = CommonItem(row)

            if item.type == 6:
                self._elite_stages[item.id] = item
                if item.condition != 0:  # 开启条件不是0
                    self._condition_mapping.setdefault(item.condition, []).append(item.id)
                else:
                    self._first_stage_id.append(item.id)
            elif item.type == 5:
                self._act_stages[item.id] = item
                if item.condition != 0:  # 开启条件不是0
                    self._condition_mapping.setdefault(item.condition, []).append(item.id)
                else:
                    self._first_stage_id.append(item.id)
            elif item.type == 7:
                self._boss_stages[item.id] = item

        return {'elite_stages': self._elite_stages, 'act_stages': self._act_stages, 'boss_stages': self._boss_stages,
                'first_stage_id': self._first_stage_id, 'condition_mapping': self._condition_mapping}
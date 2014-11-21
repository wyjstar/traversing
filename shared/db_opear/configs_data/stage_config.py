# -*- coding:utf-8 -*-
"""
created by server on 14-7-16下午5:48.
"""
from shared.db_opear.configs_data.common_item import CommonItem


class StageConfig(object):
    """关卡配置信息
    """

    def __init__(self):
        self._stages = {}  # 关卡ID：关卡信息
        self._first_stage_id = None  # 第一关
        self._chapter_ids = set()  # 章节编号
        self._condition_mapping = {}  # 开启条件 {'开启条件关卡编号'：['开启关卡编号']}
        self._activity_stages = {}  # 活动关卡
        self._travel_stages= []

    def parser(self, config_value):
        for row in config_value:
            item = CommonItem(row)

            if item.sort == 1:
                if item.type == 4:  # 活动
                    self._activity_stages[item.id] = item
                    continue

                self._chapter_ids.add(item.chapter)
                self._stages[item.id] = item

                if not item.chaptersTab:  # 不是章节标签
                    self._condition_mapping.setdefault(item.condition, []).append(item.id)

            if item.sort == 9:
                self._travel_stages.append(item.id)

        for stage_id, stage in self._stages.items():
            if stage.chapter == 1 and stage.section == 1 and stage.type == 1:  # 第一章第一节难度普通
                self._first_stage_id = stage_id

        return {'stages': self._stages, 'first_stage_id': self._first_stage_id, 'chapter_ids': list(self._chapter_ids),
                'condition_mapping': self._condition_mapping, 'activity_stages': self._activity_stages,
                'travel_stages': self._travel_stages}

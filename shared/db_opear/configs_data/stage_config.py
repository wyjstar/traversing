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

    def parser(self, config_value):
        for row in config_value:
            item = CommonItem(row)
            self._chapter_ids.add(item.chapter)
            self._stages[item.id] = item

        for stage_id, stage in self._stages.items():
            if stage.chapter == 1 and stage.section == 1 and stage.type == 1:  # 第一章第一节难度普通
                self._first_stage_id = stage_id

        return {'stages': self._stages, 'first_stage_id': self._first_stage_id, 'chapter_ids': list(self._chapter_ids)}
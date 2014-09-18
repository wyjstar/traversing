# -*- coding:utf-8 -*-
"""
created by server on 14-7-16下午5:48.
"""
from shared.db_opear.configs_data.common_item import CommonItem


class StageBreakConfig(object):
    """关卡配置信息
    """

    def __init__(self):
        self._open_break_stage = {}  # 开启中乱入关卡 {'关卡编号'：CommonItem obj}

    def parser(self, config_value):
        for row in config_value:
            item = CommonItem(row)
            if not item.is_open:  # 乱入开放
                continue
            self._open_break_stage[item.stage_id] = item
        return self._open_break_stage

# -*- coding:utf-8 -*-
"""
created by server on 14-7-16下午5:48.
"""
from shared.db_opear.configs_data.common_item import CommonItem
from shared.db_opear.configs_data.data_helper import convert_keystr2num
from shared.db_opear.configs_data.data_helper import parse


class StageConfig(object):
    """关卡配置信息
    """

    def __init__(self):
        self._stages = {}              # 关卡ID：关卡信息
        self._first_stage_id = None    # 第一关
        self._chapter_ids = set()      # 章节编号
        self._condition_mapping = {}   # 开启条件 {'开启条件关卡编号'：['开启关卡编号']}
        self._travel_stages = []       #
        self._travel_fight_stages = {} # 战斗事件关卡
        self._mine_stages = {}         # 秘境矿
        # self._gift_weight = {}         # ｛章节：权重｝
        # self._gift_info = {}           # {章节：［type，id，num］}
        self._hjqy_stages = {}         # {章节：［type，id，num］}
        self._chapter_hide_stage = {}  # {章节：隐藏关卡conf}

    def parser(self, config_value):
        for row in config_value:
            row["dragonGift"] = parse(row.get("dragonGift"))
            row["stageBox"] = parse(row.get("stageBox"))
            item = CommonItem(row)

            if item.sort == 1:
                if item.type == 14:  # 隐藏关卡
                    self._chapter_hide_stage[item.chapter] = item

                self._chapter_ids.add(item.chapter)
                self._stages[item.id] = item

                if item.chaptersTab:  # 是章节标签
                    pass
                    '''
                    for (id, info) in item.dragonGift.items():
                        if self._gift_weight.get(item.chapter):
                            self._gift_weight[item.chapter][id] = info[3]
                        else:
                            self._gift_weight[item.chapter] = {id: info[3]}
                        del info[-1]
                        if self._gift_info.get(item.chapter):
                            self._gift_info[item.chapter][id] = info
                        else:
                            self._gift_info[item.chapter] = {id: info}
                    '''
                else:
                    self._condition_mapping.setdefault(item.condition, []). \
                        append(item.id)

            if item.sort == 10:
                self._travel_fight_stages[item.id] = item

            if item.sort == 9:
                self._travel_stages.append(item.id)
                self._stages[item.id] = item

            if item.sort == 8:
                self._mine_stages[item.id] = item

            if item.sort == 12:
                self._hjqy_stages[item.id] = item

        for stage_id, stage in self._stages.items():
            if stage.chapter == 1 and stage.section == 1 and stage.type == 1:
                # 第一章第一节难度普通
                self._first_stage_id = stage_id

        return {'stages': self._stages,
                'first_stage_id': self._first_stage_id,
                'chapter_ids': list(self._chapter_ids),
                'condition_mapping': self._condition_mapping,
                'chapter_hide_stage': self._chapter_hide_stage,
                'travel_stages': self._travel_stages,
                'travel_fight_stages': self._travel_fight_stages,
                'mine_stages': self._mine_stages,
                'hjqy_stages': self._hjqy_stages}

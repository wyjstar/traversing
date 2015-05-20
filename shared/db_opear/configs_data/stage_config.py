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
        self._travel_stages = []
        self._travel_fight_stages = {}  # 战斗事件关卡
        self._mine_stages = {}  # 秘境矿
        self._gift_weight = {}  # ｛章节：权重｝
        self._gift_info = {}  # {章节：［type，id，num］}

    def parser(self, config_value):
        for row in config_value:
            convert_keystr2num(row.get("dragonGift"))
            item = CommonItem(row)

            if item.sort == 1:
                if item.type == 4:  # 活动
                    self._activity_stages[item.id] = item
                    continue

                self._chapter_ids.add(item.chapter)
                self._stages[item.id] = item

                if item.chaptersTab:  # 是章节标签
                    for (id, info) in item.dragonGift.items():
                        self._gift_weight[item.chapter] = {id: info[3]}
                        del info[-1]
                        self._gift_info[item.chapter] = {id: info}
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

        for stage_id, stage in self._stages.items():
            if stage.chapter == 1 and stage.section == 1 and stage.type == 1:
                # 第一章第一节难度普通
                self._first_stage_id = stage_id

        return {'stages': self._stages,
                'first_stage_id': self._first_stage_id,
                'chapter_ids': list(self._chapter_ids),
                'condition_mapping': self._condition_mapping,
                'activity_stages': self._activity_stages,
                'travel_stages': self._travel_stages,
                'travel_fight_stages': self._travel_fight_stages,
                'mine_stages': self._mine_stages,
                'gift_weight': self._gift_weight,
                'gift_info': self._gift_info}

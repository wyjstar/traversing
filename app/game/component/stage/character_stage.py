# -*- coding:utf-8 -*-
"""
created by server on 14-7-17上午11:07.
"""
from app.game.component.Component import Component
from app.game.core.stage.stage import Stage, StageAward
from app.game.redis_mode import tb_character_stages
from shared.db_opear.configs_data import game_configs
import time
from gtwisted.utils import log


class CharacterStageComponent(Component):
    """用户关卡信息组件
    """

    def __init__(self, owner):
        super(CharacterStageComponent, self).__init__(owner)

        self._stage_info = {}  # 关卡信息
        self._award_info = {}  # 按章节记录奖励信息

        # self._elite_stage_info = {}
        self._elite_stage_info = [0, 1]  # 精英关卡相关信息, {今日挑战次数，最后挑战日期}

        # self._act_stage = {}
        self._act_stage_info = [0, 1]  # 活动关卡相关信息, {今日挑战次数，最后挑战日期}

    def init_data(self):
        stage_data = tb_character_stages.getObjData(self.owner.base_info.id)
        if stage_data:
            stages = stage_data.get('stage_info')
            for stage_id, stage in stages.items():
                self._stage_info[stage_id] = Stage.loads(stage)

            stage_awards = stage_data.get('award_info')
            for chapter_id, stage_award in stage_awards.items():
                self._award_info[chapter_id] = StageAward.loads(stage_award)
            self._elite_stage_info = stage_data.get('elite_stage')
            self._act_stage_info = stage_data.get('act_stage')

        else:
            first_stage_id = game_configs.stage_config.get('first_stage_id')
            self._stage_info[first_stage_id] = Stage(first_stage_id)
            first_special_stage_ids = game_configs.special_stage_config.get('first_stage_id')
            for first_special_stage_id in first_special_stage_ids:
                self._stage_info[first_special_stage_id] = Stage(first_special_stage_id)
            tb_character_stages.new({'id': self.owner.base_info.id,
                                     'stage_info': dict([(stage_id, stage.dumps()) for stage_id, stage in
                                                         self._stage_info.iteritems()]),
                                     'award_info': dict(
                                         [(chapter_id, stage_award.dumps()) for chapter_id, stage_award in
                                          self._award_info.iteritems()]),
                                     'elite_stage': [0, int(time.time())],
                                     'act_stage': [0, int(time.time())]
                                     })

    def get_stage(self, stage_id):
        """取得关卡信息
        """
        stage_obj = self._stage_info.get(stage_id, None)
        if not stage_obj:
            stage_obj = Stage(stage_id, state=-2)
            self._stage_info[stage_id] = stage_obj
        return stage_obj

    def get_stage_by_condition(self, stage_id):
        """根据条件关卡编号取得开启关卡信息
        """
        condition_mapping = game_configs.stage_config.get('condition_mapping')
        stage_ids = condition_mapping.get(stage_id, [])

        return [self.get_stage(stage_id) for stage_id in stage_ids]

    def get_stages(self):
        """取得全部关卡信息
        """
        stages_config = game_configs.stage_config.get('stages')
        elite_stages = game_configs.special_stage_config.get('elite_stages')
        act_stages = game_configs.special_stage_config.get('act_stages')
        return [self.get_stage(stage_id) for stage_id, item in stages_config.items() if not item.chaptersTab] + \
               [self.get_stage(stage_id) for stage_id, item in elite_stages.items()] + \
               [self.get_stage(stage_id) for stage_id, item in act_stages.items()]

    def get_chapter(self, chapter_id):
        """取得章节奖励信息
        """
        chapter_obj = self._award_info.get(chapter_id, None)
        if not chapter_obj:
            chapter_obj = StageAward(chapter_id)
            self._award_info[chapter_id] = chapter_obj
        return chapter_obj

    def get_chapters(self):
        """取得全部章节奖励信息
        """
        chapter_ids = game_configs.stage_config.get('chapter_ids')

        return [self.get_chapter(chapter_id) for chapter_id in chapter_ids]

    def settlement(self, stage_id, result):
        """结算
        """
        stage = self.get_stage(stage_id)

        if stage.state == -2:  # 未开启
            return False

        stage.update(result)
        if result:  # win
            conf = game_configs.stage_config.get('stages')
            chapter_id = conf.get(stage_id).get('chapter')
            chapter = self.get_chapter(chapter_id)
            chapter.update(self.calculation_star(chapter_id))
            # 开启下一关卡
            stages = self.get_stage_by_condition(stage_id)
            for stage in stages:
                state = self.check_stage_state(stage.stage_id)
                if state == -2:
                    stage.state = -1  # 更新状态开启没打过
        return True

    def check_stage_state(self, stage_id):
        """校验当前关卡是否已经通关
        """

        if stage_id in self._stage_info.keys():
            stage = self.get_stage(stage_id)
            return stage.state
        return -2

    def calculation_star(self, chapter_id):
        """根据章节ID计算当前星数
        """
        stages_config = game_configs.stage_config.get('stages')
        chapter_stages_config = [self.get_stage(stage_id) for stage_id, item in stages_config.items() if
                                 not item.contents and item.chapter == chapter_id]

        num = 0
        for stage_config in chapter_stages_config:
            stage_id = stage_config.stage_id
            stage = self.get_stage(stage_id)
            if not stage.state == 1:
                continue
            num += 1
        return num

    def update(self):
        props = {'stage_info': dict([(stage_id, stage.dumps()) for stage_id, stage in self._stage_info.iteritems()]),
                 'award_info': dict(
                     [(chapter_id, stage_award.dumps()) for chapter_id, stage_award in self._award_info.iteritems()]),
                 'elite_stage': self._elite_stage_info,
                 'act_stage': self._act_stage_info
                 }
        stage_obj = tb_character_stages.getObj(self.owner.base_info.id)
        stage_obj.update_multi(props)

    @property
    def elite_stage_info(self):
        return self._elite_stage_info

    @elite_stage_info.setter
    def elite_stage_info(self, elite_stage_info):
        self._elite_stage_info = elite_stage_info

    @property
    def act_stage_info(self):
        return self._act_stage_info

    @act_stage_info.setter
    def act_stage_info(self, act_stage_info):
        self._act_stage_info = act_stage_info





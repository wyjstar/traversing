# -*- coding:utf-8 -*-
"""
created by server on 14-7-17上午11:07.
"""
from app.game.component.Component import Component
from app.game.core.stage.stage import Stage, StageAward
from app.game.redis_mode import tb_character_stages
from shared.db_opear.configs_data import game_configs


class CharacterStageComponent(Component):
    """用户关卡信息组件
    """

    def __init__(self, owner):
        super(CharacterStageComponent, self).__init__(owner)

        self._stage_info = {}  # 关卡信息
        self._award_info = {}  # 按章节记录奖励信息

    def init_data(self):
        stage_data = tb_character_stages.getObjData(self.owner.base_info.id)

        print 'stage_data #1111:', stage_data

        if stage_data:

            print 'stage_data:', stage_data

            stages = stage_data.get('stage_info')
            for stage_id, stage in stages.items():
                self._stage_info[stage_id] = Stage.loads(stage)

            stage_awards = stage_data.get('award_info')
            for chapter_id, stage_award in stage_awards.items():
                self._award_info[chapter_id] = StageAward.loads(stage_award)
        else:
            first_stage_id = game_configs.stage_config.get('first_stage_id')
            self._stage_info[first_stage_id] = Stage(first_stage_id)
            tb_character_stages.new({'id': self.owner.base_info.id,
                                     'stage_info': dict([(stage_id, stage.dumps()) for stage_id, stage in
                                                         self._stage_info.iteritems()]),
                                     'award_info': dict(
                                         [(chapter_id, stage_award.dumps()) for chapter_id, stage_award in
                                          self._award_info.iteritems()])})

    def get_stage(self, stage_id):
        """取得关卡信息
        """
        stage_obj = self._stage_info.get(stage_id, None)
        if not stage_obj:
            stage_obj = Stage(stage_id, state=-2)
            self._stage_info[stage_id] = stage_obj
        return stage_obj

    def get_stages(self):
        """取得全部关卡信息
        """
        stages_config = game_configs.stage_config.get('stages')
        return [self.get_stage(stage_id) for stage_id, item in stages_config.items() if not item.contents]

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
        stage.update(result)
        if result:  # win
            stages_conf = self.get_chapters()
            stage_conf = stages_conf.get(stage_id)
            chapter_id = stage_conf.chapter
            chapter = self.get_chapter(chapter_id)
            chapter.update(self.calculation_star(chapter_id))

    def calculation_star(self, chapter_id):
        """根据章节ID计算当前星数
        """

        stages_config = game_configs.stage_config.get('stages')
        chapter_stages_config = [self.get_stage(stage_id) for stage_id, item in stages_config.items() if
                                 not item.contents and item.chapter == chapter_id]

        num = 0
        for stage_config in chapter_stages_config:
            stage_id = stage_config.id
            stage = self.get_stage(stage_id)
            if not stage.state == 1:
                continue
            num += 1

        return num

    def update(self):
        pass




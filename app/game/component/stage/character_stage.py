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
        self._award_info = {}  # 按章节记录星星数量

    def init_data(self):
        stage_data = tb_character_stages.getObjData(self.owner.base_info.id)
        if stage_data:

            stages = stage_data.get('stage_info')
            for stage_id, stage in stages.items():
                self._stage_info[stage_id] = Stage.loads(stage)

            stage_awards = stage_data.get('award_info')
            for chapter_id, stage_award in stage_awards.items():
                self._award_info[chapter_id] = StageAward.loads(stage_award)
        else:
            first_stage_id = game_configs.stage_config.get('first_stage_id')
            self._stage_info[first_stage_id] = Stage(first_stage_id)
            tb_character_stages.new({'complete': self._complete, 'open': self._open})










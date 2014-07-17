# -*- coding:utf-8 -*-
"""
created by server on 14-7-17上午11:07.
"""
from app.game.component.Component import Component
from app.game.redis_mode import tb_character_stages
from shared.db_opear.configs_data import game_configs


class CharacterStageComponent(Component):
    """用户关卡信息组件
    """
    def __init__(self, owner):
        super(CharacterStageComponent, self).__init__(owner)

        self._complete = {}  # 完成信息 -1:开启没打过 0：输 1：赢
        self._open = {}  # 开启信息

    def init_data(self):
        stages_info = tb_character_stages.getObjData(self.owner.base_info.id)
        if stages_info:
            self._complete = stages_info.get('complete')
            self._open = stages_info.get('open')
        else:
            first_stage_id = game_configs.stage_config.get('first_stage_id')
            self._open = {first_stage_id: -1}
            tb_character_stages.new({'complete': self._complete, 'open': self._open})

    








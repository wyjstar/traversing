# -*- coding:utf-8 -*-
"""
created by server on 14-7-5下午3:07.
"""
from app.game.component.Component import Component
from app.game.core.line_up import LineUp
from app.game.redis_mode import tb_character_line_up


class CharacterLineUpComponent(Component):
    """用户英雄阵容组件
    """
    def __init__(self, owner):
        super(CharacterLineUpComponent, self).__init__(owner)
        self._line_up = LineUp()  # 第一阵容

    def init_data(self):

        line_up_data = tb_character_line_up.getObjData(self.owner.base_info.id)

        if line_up_data:
            self._line_up.loads(line_up_data.get('line_up'))
        else:
            tb_character_line_up.new({'id': self.owner.base_info.id, 'line_up': self._line_up.dumps()})



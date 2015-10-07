# -*- coding:utf-8 -*-
"""
created by server on 14-7-17上午11:07.
"""
from app.game.component.Component import Component
from app.game.core.stage.stage import Stage, StageAward
from app.game.redis_mode import tb_character_info
from shared.db_opear.configs_data import game_configs
import time
from gfirefly.server.logobj import logger


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
        self._stage_up_time = 1  # 关卡挑战次数 更新 时间
        self._plot_chapter = 1  # 剧情章节

        self._stage_progress = game_configs.stage_config.get('first_stage_id')
        self._rank_stage_progress = game_configs.stage_config.get('first_stage_id')
        self._star_num = [0]*40

    def init_data(self, character_info):
        stages = character_info.get('stage_info')
        for stage_id, stage in stages.items():
            self._stage_info[stage_id] = Stage.loads(stage)

        stage_awards = character_info.get('award_info')
        for chapter_id, stage_award in stage_awards.items():
            self._award_info[chapter_id] = StageAward.loads(stage_award)
        self._elite_stage_info = character_info.get('elite_stage')
        self._act_stage_info = character_info.get('act_stage')
        self._stage_up_time = character_info.get('stage_up_time')
        self._plot_chapter = character_info.get('plot_chapter', 1)

        first_stage_id = game_configs.stage_config.get('first_stage_id')
        self._stage_progress = character_info.get('stage_progress', first_stage_id)
        self._rank_stage_progress = character_info.get('rank_stage_progress', first_stage_id)
        self._star_num = character_info.get('star_num', [0]*40)

    def new_data(self):
        first_stage_id = game_configs.stage_config.get('first_stage_id')
        self._stage_info[first_stage_id] = Stage(first_stage_id)
        first_special_stage_ids = game_configs.special_stage_config.get('first_stage_id')
        for first_special_stage_id in first_special_stage_ids:
            self._stage_info[first_special_stage_id] = Stage(first_special_stage_id)

        data = {'stage_info': dict([(stage_id, stage.dumps()) for stage_id, stage in self._stage_info.iteritems()]),
                'award_info': dict(
                    [(chapter_id, stage_award.dumps()) for chapter_id, stage_award in
                     self._award_info.iteritems()]),
                'elite_stage': [0, int(time.time())],
                'plot_chapter': 1,
                'act_stage': [0, int(time.time())],
                'stage_progress': self._stage_progress,
                'rank_stage_progress': self._rank_stage_progress,
                'star_num': self._star_num,
                'stage_up_time': int(time.time())}
        return data

    def save_data(self):
        props = {'stage_info': dict([(stage_id, stage.dumps()) for stage_id, stage in self._stage_info.iteritems()]),
                 'award_info': dict(
                     [(chapter_id, stage_award.dumps()) for chapter_id, stage_award in self._award_info.iteritems()]),
                 'elite_stage': self._elite_stage_info,
                 'plot_chapter': self._plot_chapter,
                 'act_stage': self._act_stage_info,
                 'star_num': self._star_num,
                 'stage_progress': self._stage_progress,
                 'rank_stage_progress': self._rank_stage_progress,
                 'stage_up_time': self._stage_up_time
                 }

        char_obj = tb_character_info.getObj(self.owner.base_info.id)
        char_obj.hmset(props)

    def get_stage(self, stage_id):
        """取得关卡信息
        """
        stage_obj = self._stage_info.get(stage_id, None)
        if not stage_obj:
            stage_obj = Stage(stage_id, state=-2)
            self._stage_info[stage_id] = stage_obj
        return stage_obj

    def update_stage_times(self):
        self._stage_up_time = int(time.time())
        for stage_id, stage in self._stage_info.items():
            stage.attacks = 0

    # def get_stage_by_condition(self, stage_id):
    #     """根据条件关卡编号取得开启关卡信息
    #     """
    #     condition_mapping = game_configs.stage_config.get('condition_mapping')
    #     stage_ids = condition_mapping.get(stage_id, [])
    #
    #     return [self.get_stage(stage_id) for stage_id in stage_ids]

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
        open_stage_id = game_configs.base_config.get('warFogOpenStage')
        if stage.stage_id == open_stage_id and stage.state == 1:
            logger.debug('reset warfog')
            self.owner.mine.reset_data()

        if result:  # win
            conf = game_configs.stage_config.get('stages')
            chapter_id = None
            if game_configs.stage_config.get('stages').get(stage_id):  # 关卡
                chapter_id = conf.get(stage_id).get('chapter')
                chapter = self.get_chapter(chapter_id)
                chapter.update(self.calculation_star(chapter_id))
                next_stages = game_configs.stage_config.get('condition_mapping')
            # elif game_configs.special_stage_config.get('elite_stages').get(stage_id):  # 精英关卡
            else:
                next_stages = game_configs.special_stage_config.get('condition_mapping')
            # 开启下一关卡
            if next_stages.get(stage_id):
                for stage in [self.get_stage(temp_stage_id) for temp_stage_id in next_stages.get(stage_id)]:
                    state = self.check_stage_state(stage.stage_id)
                    logger.debug("next stage state===========atk_stage_id %s next_stage_id %s state %s chapter_id %s" %\
                            (stage_id, stage.stage_id, state, chapter_id))
                    if state == -2:
                        stage.state = -1  # 更新状态开启没打过
                        if chapter_id and conf.get(stage.stage_id).get('type') == 1:
                            logger.debug("next stage win=============")
                            self._stage_progress = stage_id
            # 计算星星
            chapter_star_num = self.calculation_star(chapter_id)
            self.star_num[chapter_id] = chapter_star_num

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
                                 not item.chaptersTab and item.chapter == chapter_id]

        num = 0
        for stage_config in chapter_stages_config:
            stage_id = stage_config.stage_id
            stage = self.get_stage(stage_id)
            if not stage.state == 1:
                continue
            num += 1
        return num

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

    @property
    def stage_up_time(self):
        return self._stage_up_time

    @stage_up_time.setter
    def stage_up_time(self, stage_up_time):
        self._stage_up_time = stage_up_time

    @property
    def plot_chapter(self):
        return self._plot_chapter

    @plot_chapter.setter
    def plot_chapter(self, values):
        self._plot_chapter = values

    @property
    def stage_progress(self):
        return self._stage_progress

    @stage_progress.setter
    def stage_progress(self, values):
        self._stage_progress = values

    @property
    def star_num(self):
        return self._star_num

    @star_num.setter
    def star_num(self, values):
        self._star_num = values

    @property
    def rank_stage_progress(self):
        return self._rank_stage_progress

    @rank_stage_progress.setter
    def rank_stage_progress(self, values):
        self._rank_stage_progress = values

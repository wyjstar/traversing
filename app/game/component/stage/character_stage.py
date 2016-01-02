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
from shared.utils.date_util import get_current_timestamp, is_next_day
from shared.common_logic.lucky_hero import update_lucky_hero


class CharacterStageComponent(Component):
    """用户关卡信息组件
    """

    def __init__(self, owner):
        super(CharacterStageComponent, self).__init__(owner)

        self._already_look_hide_stage = [] # 已经看过隐藏关卡提示的章节 [chapter_id]
        self._stage_info = {}             # 关卡信息
        self._award_info = {}             # 按章节记录奖励信息
                                          # self._elite_stage_info = {}
        self._elite_stage_info = [0, 0, 1]   # 精英关卡相关信息, {今日挑战次数，今日重置次数，最后挑战日期}
                                          # self._act_stage = {}
        self._act_stage_info = [0, 0, 1]  # 活动关卡相关信息, {今日挑战宝库次数，今日挑战校场次数,最后挑战日期}
        self._stage_up_time = 1           # 关卡挑战次数 更新 时间
        self._plot_chapter = 1            # 剧情章节
                                          # self._act_coin_lucky_heros = []                                                        # 宝库幸运武将
                                          # self._act_exp_lucky_heros = []                                                         # 校场幸运武将
                                          # self._act_coin_lucky_heros_time = [0, 0]                                               # 宝库幸运武将时间，[幸运武将开始时间，幸运武将结束时间]
                                          # self._act_exp_lucky_heros_time = [0, 0]                                                # 校场幸运武将时间，[幸运武将开始时间，幸运武将结束时间]
        self._act_lucky_heros = {}        # 活动幸运武将时间，关卡id，幸运武将列表，武将时间：[幸运武将开始时间，幸运武将结束时间]

        self._stage_progress = game_configs.stage_config.get('first_stage_id')
        self._rank_stage_progress = game_configs.stage_config.get('first_stage_id')
        self._star_num = [0]*100

    def init_data(self, character_info):
        stages = character_info.get('stage_info')
        for stage_id, stage in stages.items():
            self._stage_info[stage_id] = Stage.loads(stage)

        stage_awards = character_info.get('award_info')
        for chapter_id, stage_award in stage_awards.items():
            self._award_info[chapter_id] = StageAward.loads(stage_award)
        self._elite_stage_info = character_info.get('elite_stage')
        self._act_stage_info = character_info.get('act_stage')
        self._act_lucky_heros = character_info.get('act_lucky_heros', {})
        #self._act_coin_lucky_heros = character_info.get('act_coin_lucky_heros')
        #self._act_exp_lucky_heros = character_info.get('act_exp_lucky_heros')
        self._stage_up_time = character_info.get('stage_up_time')
        self._plot_chapter = character_info.get('plot_chapter', 1)

        first_stage_id = game_configs.stage_config.get('first_stage_id')
        self._stage_progress = character_info.get('stage_progress', first_stage_id)
        self._rank_stage_progress = character_info.get('rank_stage_progress', first_stage_id)
        self._star_num = character_info.get('star_num', [0]*100)
        self._already_look_hide_stage = character_info.get('already_look_hide_stage', [])

    def check_time(self):
        """
        时间改变，重置数据
        """
        current_time_stamp = get_current_timestamp()
        for k, v in self._act_lucky_heros.items():
            stage_info = game_configs.special_stage_config.get('act_stages').get(k)
            if v.get('time')[0] > current_time_stamp or v.get('time')[1] < current_time_stamp:
                v['heros'], v['time'][0], v['time'][1] = update_lucky_hero(stage_info.type, k%10)

        logger.debug("character_stage check time")
        logger.debug(self._act_stage_info)

        if is_next_day(current_time_stamp, self._elite_stage_info[2]):
            self._elite_stage_info[0] = 0
            self._elite_stage_info[1] = 0
            self._elite_stage_info[2] = current_time_stamp
        if is_next_day(current_time_stamp, self._act_stage_info[2]):
            self._act_stage_info[0] = 0
            self._act_stage_info[1] = 0
            self._act_stage_info[2] = current_time_stamp

        logger.debug("_act_lucky_heros %s" % self._act_lucky_heros)
        logger.debug(self._elite_stage_info)
        logger.debug(self._act_stage_info)
        self.save_data()

    def new_data(self):
        first_stage_id = game_configs.stage_config.get('first_stage_id')
        self._stage_info[first_stage_id] = Stage(first_stage_id)
        first_special_stage_ids = game_configs.special_stage_config.get('first_stage_id')
        for first_special_stage_id in first_special_stage_ids:
            self._stage_info[first_special_stage_id] = Stage(first_special_stage_id)

        act_stages = game_configs.special_stage_config.get('act_stages')
        act_lucky_heros = {}
        for k, v in act_stages.items():
            act_lucky_heros[k] = {'stage_id': k,
                    'time': [0, 0],
                    'heros': {}}

        data = {'stage_info': dict([(stage_id, stage.dumps()) for stage_id, stage in self._stage_info.iteritems()]),
                'award_info': dict(
                    [(chapter_id, stage_award.dumps()) for chapter_id, stage_award in
                     self._award_info.iteritems()]),
                'elite_stage': [0, 0, int(time.time())],
                'plot_chapter': 1,
                'act_stage': [0, 0, int(time.time())],
                'stage_progress': self._stage_progress,
                'rank_stage_progress': self._rank_stage_progress,
                'star_num': self._star_num,
                'already_look_hide_stage': self._already_look_hide_stage,
                'stage_up_time': int(time.time()),
                'act_lucky_heros': act_lucky_heros}
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
                 'stage_up_time': self._stage_up_time,
                 'already_look_hide_stage': self._already_look_hide_stage,
                 'act_lucky_heros': self._act_lucky_heros
                 }

        char_obj = tb_character_info.getObj(self.owner.base_info.id)
        char_obj.hmset(props)

    def get_stage(self, stage_id):
        """取得关卡信息
        """
        stage_obj = self._stage_info.get(stage_id, None)
        if not stage_obj:
            # stage_obj = Stage(stage_id, state=1, star_num=3)
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
        stage_open_max = game_configs.base_config.get('stage_open_max')
        stages_config = game_configs.stage_config.get('stages')
        elite_stages = game_configs.special_stage_config.get('elite_stages')
        act_stages = game_configs.special_stage_config.get('act_stages')
        # return [self.get_stage(stage_id) for stage_id, item in stages_config.items() if not item.chaptersTab] + \
        return [self.get_stage(stage_id) for stage_id, item in stages_config.items() if not item.chaptersTab and item.chapter <= stage_open_max] + \
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

    def settlement(self, stage_id, result, star_num):
        """结算
        """
        stage = self.get_stage(stage_id)

        if stage.state == -2:  # 未开启
            return False

        stage.update(result, star_num)
        # open_stage_id = game_configs.base_config.get('warFogOpenStage')
        # if stage.stage_id == open_stage_id and stage.state == 1:
        #     logger.debug('reset warfog')
        #     self.owner.mine.reset_data()

        if result:  # win
            stages_conf = game_configs.stage_config.get('stages')
            chapter_id = None
            if stages_conf.get(stage_id):  # 关卡
                chapter_id = stages_conf.get(stage_id).get('chapter')
                chapter = self.get_chapter(chapter_id)
                chapter_star_num = self.calculation_star(chapter_id)
                chapter.update(chapter_star_num)
                next_stages = game_configs.stage_config. \
                    get('condition_mapping')

                # if chapter_id != 1:
                # 计算星星  星星排行用
                self.star_num[chapter_id] = chapter_star_num

                # 根据星星数更新隐藏关卡开启状态
                chapter_conf = chapter.get_conf()
                hide_stage_conf = game_configs.stage_config. \
                    get('chapter_hide_stage').get(chapter_id)
                if hide_stage_conf:
                    print chapter_star_num, hide_stage_conf.condition2, chapter_id, '==========================111'
                    if chapter_star_num >= hide_stage_conf.condition2:
                        hide_stage_obj = self.get_stage(hide_stage_conf.id)
                        if hide_stage_obj.state == -2:
                            hide_stage_obj.state = -1
                # 获取那蛋疼的掉落

            else:
                next_stages = game_configs.special_stage_config. \
                    get('condition_mapping')
            # 开启下一关卡
            if next_stages.get(stage_id):
                for stage in [self.get_stage(temp_stage_id) for temp_stage_id in next_stages.get(stage_id)]:
                    state = self.check_stage_state(stage.stage_id)
                    if state == -2:
                        stage.state = -1  # 更新状态开启没打过
                        if chapter_id and stages_conf.get(stage.stage_id).get('type') == 1:
                            logger.debug("next stage win=============")
                            self._stage_progress = stage_id

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
        chapter_stages_config = [item for stage_id, item in stages_config.items() if
                                 not item.chaptersTab and item.chapter == chapter_id]

        num = 0
        for stage_config in chapter_stages_config:
            if stage_config.type not in [1, 2, 3]:
                continue
            stage_id = stage_config.id
            stage = self.get_stage(stage_id)
            if not stage.state == 1:
                continue
            num += stage.star_num
        return num

    @property
    def already_look_hide_stage(self):
        return self._already_look_hide_stage

    @already_look_hide_stage.setter
    def already_look_hide_stage(self, v):
        self._already_look_hide_stage = v

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

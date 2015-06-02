# -*- coding:utf-8 -*-

"""
created by server on 15-5-27下午2:00.
"""
__author__ = 'Server-ZhangChao'

from app.game.component.Component import Component
from app.game.redis_mode import tb_character_info
from shared.db_opear.configs_data.game_configs import achievement_config
from app.game.action.node.lively import add_items

class ShareComponent(Component):
    def __init__(self, owner):
        super(ShareComponent, self).__init__(owner)
        self.status = []

    def init_data(self, character_info):
        self.status = character_info.get('share_status')

    def save_data(self):
        share_obj = tb_character_info.getObj(self.owner.base_info.id)
        data = dict(share_status=self.status)
        share_obj.hmset(data)

    def new_data(self):
        data = dict(share_status=self.status)
        return data

    def get_reward(self, task_id, player, result):
        task = achievement_config.get(task_id)
        result.res.result = False
        if not task:
            result.res.message = u"任务不存在"
            return False
        for tid in self.status:                            #如果领取过则不可以再领
            if tid == task_id:
                result.res.message = u"已领取"
                return False
        limit = task['condition'].items()
        for k, v in limit:                                 # 可能存在多个条件，所以用循环
            if v[0] == 1:                                  # 1 是需要通过指定关卡
                stage = player.stage.get_stage(v[1])
                if stage.state < v[2]:
                    break
            if v[0] == 2:                                  # 2 是玩家达到指定等级
                if player.base_info.level < v[1]:
                    break
            if v[0] == 8:                                  # 8 是拥有指定数量的6星武将
                count = player.hero_component.get_quality_hero_count(6)
                if count < v[1]:
                    break
            if v[0] == 11:                                 # 11 是拥有指定数量的6星装备
                count = player.equipment.get_quality_equip_count(6)
                if count < v[1]:
                    break
            if v[0] == 25:                                 # 25 是擂台达到指定排名
                if player.base_info.pvp_high_rank < v[1]:
                    break
            result.res.result = True
        if result.res.result:
            self.status.append(task_id)
            result.tid = task_id
            add_items(player, task_id, result.gain)
            self.save_data()
        else:
            print("get eward fial")
            result.res.message = u"未达成领取条件"
            return False
        return True




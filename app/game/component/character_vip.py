# -*- coding:utf-8 -*-
"""
created by server on 14-9-11下午5:04.
"""

from app.game.component.Component import Component
from shared.db_opear.configs_data.game_configs import vip_config


class CharacterVIPComponent(Component):
    """VIP组件"""

    def __init__(self, owner):
        super(CharacterVIPComponent, self).__init__(owner)
        self._vip_level = 0  # VIP等级
        self._vip_content = None  # VIP 相关内容，从config中获得

    def init_vip(self, vip_level):
        self._vip_level = vip_level
        self.update_vip()

    @property
    def vip_level(self):
        return self._vip_level

    @vip_level.setter
    def vip_level(self, vip_level):
        self._vip_level = vip_level
        self.update_vip()

    @property
    def open_sweep(self):
        """解锁扫荡"""
        return self._vip_content.openSweep

    @property
    def open_sweep_ten(self):
        """解锁扫荡十次"""
        return self._vip_content.openSweepTen

    @property
    def free_sweep_times(self):
        """每日免费扫荡次数"""
        return self._vip_content.freeSweepTimes

    @property
    def reset_stage_times(self):
        """关卡重置次数"""
        return self._vip_content.resetStageTimes

    @property
    def reset_arena_cd(self):
        """重置竞技场CD"""
        return self._vip_content.resetArenaCD

    @property
    def buy_arena_times(self):
        """购买竞技场次数"""
        return self._vip_content.buyArenaTimes

    @property
    def buy_stamina_max(self):
        """每日购买体力上限"""
        return self._vip_content.buyStaminaMax

    @property
    def equipment_strength_one_key(self):
        """装备一键强化"""
        return self._vip_content.equipmentStrengthOneKey

    @property
    def shop_refresh_times(self):
        """每日商店刷新次数"""
        return self._vip_content.shopRefreshTimes

    @property
    def activity_copy_times(self):
        """每日活动副本次数"""
        return self._vip_content.activityCopyTimes

    @property
    def elite_copy_times(self):
        """每日精英副本次数"""
        return self._vip_content.eliteCopyTimes

    @property
    def equipment_strength_cli_times(self):
        """装备强化暴击次数"""
        return self._vip_content.equipmentStrengthCliTimes

    @property
    def gifts(self):
        """获得礼包"""
        #todo: send mail
        return self._vip_content.gifts

    @property
    def buy_gifts(self):
        """可购买的礼包"""
        #todo: 礼包ID
        return self._vip_content.buyGifts

    @property
    def guild_worship_times(self):
        """公会膜拜次数"""
        return self._vip_content.guildWorshipTimes


    def update_vip(self):
        """更新VIP组件"""
        self._vip_content = vip_config.get(self._vip_level)





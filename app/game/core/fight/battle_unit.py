# -*- coding:utf-8 -*-
"""
created by server on 14-7-19下午2:27.
"""
from app.game.component.Component import Component


class BattleUnit(Component):
    """战斗单位组件
    """
    def __init__(self, owner):

	required int32 no = 1;  //战斗单位ID
	optional int32 quality = 2;  //战斗单位品质
	optional int32 normal_skill = 3;  //战斗单位普通技能
	optional int32 rage_skill = 4;  //战斗单位怒气技能
	optional float hp = 5; // 战斗单位血量
	optional float atk = 6; //战斗单位攻击
	optional float physical_def = 7;//战斗单位物理防御
	optional float magic_dif = 8;  //战斗单位魔法防御
	optional float hit = 9; //战斗单位命中率
	optional float dodge = 10;  //战斗单位闪避率
	optional float cri = 11;  //战斗单位暴击率
	optional float cri_Coeff = 12; //战斗单位暴击伤害系数
	optional float cri_ded_coeff = 13;  //战斗单位暴伤减免系数
	optional float block = 14;  //战斗单位格挡率
	optional bool is_boss = 15; //是否是boss
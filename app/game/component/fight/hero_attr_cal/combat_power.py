# -*- coding:utf-8 -*-
"""
created by server on 14-12-29下午2:03.
"""
from shared.db_opear.configs_data.game_configs import formula_config, skill_buff_config

def hero_self_attr(player, hero):
    """
    武将自身属性＝基础＋成长＋突破＋突破系数＋炼体＋符文

    return:
    hpHero:武将自身生命值,
    atkHero:武将自身攻击力,
    physicalDefHero:武将自身物防,
    magicDefHero:武将自身魔防,
    hitHero:武将自身命中,
    dodgeHero:武将自身闪避,
    criHero:武将自身暴击,
    criCoeffHero:武将自身暴伤,
    criDedCoeffHero:武将自身暴免,
    blockHero:武将自身格挡,
    ductilityHero:武将自身韧性
    """

    assert hero!=None, "hero can not be None!"

    hero_info = hero.hero_info

    # 突破
    break_attr = skill_attr(hero, hero_info, hero.break_skill_ids)
    # 炼体
    refine_attr = hero.refine_attr()
    # 符文
    runt_attr = hero.runt_attr()

    all_vars = dict(
        hero_info=hero_info,
        heroLevel=hero.level,
        parameters=hero.break_param,

        hpB=break_attr.get("hp", 0),
        hpSeal=refine_attr.get("hp", 0),
        hpStone=runt_attr.get("hp", 0),

        atkB=break_attr.get("atk", 0),
        atkSeal=refine_attr.get("atk", 0),
        atkStone=runt_attr.get("atk", 0),

        pDefB=break_attr.get("physical_def", 0),
        pDefSeal=refine_attr.get("physical_def", 0),
        pDefStone=runt_attr.get("physical_def", 0),

        mDefB=break_attr.get("magic_def", 0),
        mDefSeal=refine_attr.get("magic_def", 0),
        mDefStone=runt_attr.get("magic_def", 0),

        hitB=break_attr.get("hit", 0),
        hitSeal=refine_attr.get("hit", 0),
        hitStone=runt_attr.get("hit", 0),

        dodgeB=break_attr.get("dodge", 0),
        dodgeSeal=refine_attr.get("dodge", 0),
        dodgeStone=runt_attr.get("dodge", 0),

        criB=break_attr.get("cri", 0),
        criSeal=refine_attr.get("cri", 0),
        criStone=runt_attr.get("cri", 0),

        criCoeffB=break_attr.get("cri_coeff", 0),
        criCoeffSeal=refine_attr.get("cri_coeff", 0),
        criCoeffStone=runt_attr.get("cri_coeff", 0),

        criDedCoeffB=break_attr.get("cri_ded_coeff", 0),
        criDedCoeffSeal=refine_attr.get("cri_ded_coeff", 0),
        criDedCoeffStone=runt_attr.get("cri_ded_coeff", 0),

        blockB=break_attr.get("block", 0),
        blockSeal=refine_attr.get("block", 0),
        blockStone=runt_attr.get("block", 0),

        ductilityB=break_attr.get("ductility", 0),
        ductilitySeal=refine_attr.get("ductility", 0),
        ductilityStone=runt_attr.get("ductility", 0),
    )
    # hpHero
    # hero_info.hp+hero_info.growHp*heroLevel+hpB+hero_info.hp*parameters+hpSeal+hpStone
    hpHero_formula = formula_config.get("hpHero")
    assert hpHero_formula!=None, "hpHero formula can not be None!"
    hpHero = eval(hpHero_formula, all_vars)

    # atkHero
    # hero_info.atk+hero_info.growAtk*heroLevel+atkB+hero_info.atk*parameters+atkSeal+atkStone
    atkHero_formula = formula_config.get("atkHero")
    atkHero = eval(atkHero_formula, all_vars)

    # pdefHero
    # hero_info.physicalDef+hero_info.growPhysicalDef*heroLevel+pDefB+hero_info.physicalDef*parameters+pDefSeal+pDefStone
    physicalDefHero_formula = formula_config.get("physicalDefHero")
    physicalDefHero = eval(physicalDefHero_formula, all_vars)

    # magicDefHero
    # hero_info.magicDef+hero_info.growMagicDef*heroLevel+mDefB+hero_info.magicDef*parameters+mDefSeal+mDefStone
    magicDefHero_formula = formula_config.get("magicDefHero")
    magicDefHero = eval(magicDefHero_formula, all_vars)
    # hitHero
    # hero_info.hit+hitB+hitSeal+hitStone
    hitHero_formula = formula_config.get("hitHero")
    hitHero = eval(hitHero_formula, all_vars)

    # dodgeHero
    # hero_info.dodge+dodgeB+dodgeSeal+dodgeStone
    dodgeHero_formula = formula_config.get("dodgeHero")
    dodgeHero = eval(dodgeHero_formula, all_vars)
    # criHero
    # hero_info.cri+criB+criSeal+criStone
    criHero_formula = formula_config.get("criHero")
    criHero = eval(criHero_formula, all_vars)

    # criCoeffHero
    # hero_info.criCoeff+criCoeffB+criCoeffSeal+criCoeffStone
    criCoeffHero_formula = formula_config.get("criCoeffHero")
    criCoeffHero = eval(criCoeffHero_formula, all_vars)
    # criDedCoeffHero
    # hero_info.criDedCoeff+criDedCoeffB+criDedCoeffSeal+criDedCoeffStone
    criDedCoeffHero_formula = formula_config.get("criDedCoeffHero")
    criDedCoeffHero = eval(criDedCoeffHero_formula, all_vars)
    # blockHero
    # hero_info.block+blockB+blockSeal+blockStone
    blockHero_formula = formula_config.get("blockHero")
    blockHero = eval(blockHero_formula, all_vars)
    # ductilityHero
    # hero_info.ductility+ductilityB+ductilitySeal+ductilityStone
    ductilityHero_formula = formula_config.get("ductilityHero")
    ductilityHero = eval(ductilityHero_formula, all_vars)

    return dict(hpHero=hpHero,
            atkHero=atkHero,
            physicalDefHero=physicalDefHero,
            magicDefHero=magicDefHero,
            hitHero=hitHero,
            dodgeHero=dodgeHero,
            criHero=criHero,
            criCoeffHero=criCoeffHero,
            criDedCoeffHero=criDedCoeffHero,
            blockHero=blockHero,
            ductilityHero=ductilityHero
            )

def hero_lineup_attr(player, hero, line_up_slot_no):
    """
    武将在阵容中的属性＝自身属性＋装备＋套装＋羁绊＋游历＋助威＋公会
    return:
    hpArray武将阵容生命值
    atkArray武将阵容攻击力
    physicalDefArray武将阵容物防
    magicDefArray武将阵容魔防
    hitArray武将阵容命中
    dodgeArray武将阵容闪避
    criArray武将阵容暴击
    criCoeffArray武将阵容暴伤
    criDedCoeffArray武将阵容暴免
    blockArray武将阵容格挡
    ductilityArray武将阵容韧性
    """
    assert hero!=None, "hero can not be None!"

    line_up_slot = player.line_up_component.line_up_slots.get(line_up_slot_no)

    hero_slot = line_up_slot.hero_slot

    hero_info = hero.hero_info
    # 自身属性
    self_attr = hero_self_attr(player, hero)
    # 装备
    equ_attr = line_up_slot.equ_attr()
    # 套装
    set_equ_attr = line_up_slot.set_equ_attr()
    # 羁绊
    link_attr = skill_attr(hero, hero_info, hero_slot.link_skill_ids)
    # 游历
    travel_attr = player.travel_component.get_travel_item_attr()
    # 助威
    cheer_attr = player.line_up_component.cheer_attr()
    # 公会
    guild_attr = player.guild_component.guild_attr()

    all_vars = dict(
            hpHero=self_attr.get("hp", 0),
            hpEqu=equ_attr.get("hp", 0),
            hpSetEqu=set_equ_attr.get("hp", 0),
            hplink=link_attr.get("hp", 0),
            hpGuild=guild_attr.get("hp", 0),
            hpCheer=cheer_attr.get("hp", 0),
            hpTravel=travel_attr.get("hp", 0),

            atkHero=self_attr.get("atk", 0),
            atkEqu=equ_attr.get("atk", 0),
            atkSetEqu=set_equ_attr.get("atk", 0),
            atklink=link_attr.get("atk", 0),
            atkGuild=guild_attr.get("atk", 0),
            atkCheer=cheer_attr.get("atk", 0),
            atkTravel=travel_attr.get("atk", 0),

            physicalDefHero=self_attr.get("physical_def", 0),
            physicalDefEqu=equ_attr.get("physical_def", 0),
            physicalDefSetEqu=set_equ_attr.get("physical_def", 0),
            physicalDeflink=link_attr.get("physical_def", 0),
            physicalDefGuild=guild_attr.get("physical_def", 0),
            physicalDefCheer=cheer_attr.get("physical_def", 0),
            physicalDefTravel=travel_attr.get("physical_def", 0),

            magicDefHero=self_attr.get("magic_def", 0),
            magicDefEqu=equ_attr.get("magic_def", 0),
            magicDefSetEqu=set_equ_attr.get("magic_def", 0),
            magicDeflink=link_attr.get("magic_def", 0),
            magicDefGuild=guild_attr.get("magic_def", 0),
            magicDefCheer=cheer_attr.get("magic_def", 0),
            magicDefTravel=travel_attr.get("magic_def", 0),

            hitHero=self_attr.get("hit", 0),
            hitEqu=equ_attr.get("hit", 0),
            hitSetEqu=set_equ_attr.get("hit", 0),
            hitlink=link_attr.get("hit", 0),
            hitGuild=guild_attr.get("hit", 0),
            hitCheer=cheer_attr.get("hit", 0),
            hitTravel=travel_attr.get("hit", 0),

            dodgeHero=self_attr.get("dodge", 0),
            dodgeEqu=equ_attr.get("dodge", 0),
            dodgeSetEqu=set_equ_attr.get("dodge", 0),
            dodgelink=link_attr.get("dodge", 0),
            dodgeGuild=guild_attr.get("dodge", 0),
            dodgeCheer=cheer_attr.get("dodge", 0),
            dodgeTravel=travel_attr.get("dodge", 0),

            criHero=self_attr.get("cri", 0),
            criEqu=equ_attr.get("cri", 0),
            criSetEqu=set_equ_attr.get("cri", 0),
            crilink=link_attr.get("cri", 0),
            criGuild=guild_attr.get("cri", 0),
            criCheer=cheer_attr.get("cri", 0),
            criTravel=travel_attr.get("cri", 0),

            criCoeffHero=self_attr.get("cri_coeff", 0),
            criCoeffEqu=equ_attr.get("cri_coeff", 0),
            criCoeffSetEqu=set_equ_attr.get("cri_coeff", 0),
            criCoefflink=link_attr.get("cri_coeff", 0),
            criCoeffGuild=guild_attr.get("cri_coeff", 0),
            criCoeffCheer=cheer_attr.get("cri_coeff", 0),
            criCoeffTravel=travel_attr.get("cri_coeff", 0),

            criDedCoeffHero=self_attr.get("cri_ded_coeff", 0),
            criDedCoeffEqu=equ_attr.get("cri_ded_coeff", 0),
            criDedCoeffSetEqu=set_equ_attr.get("cri_ded_coeff", 0),
            criDedCoefflink=link_attr.get("cri_ded_coeff", 0),
            criDedCoeffGuild=guild_attr.get("cri_ded_coeff", 0),
            criDedCoeffCheer=cheer_attr.get("cri_ded_coeff", 0),
            criDedCoeffTravel=travel_attr.get("cri_ded_coeff", 0),

            blockHero=self_attr.get("block", 0),
            blockEqu=equ_attr.get("block", 0),
            blockSetEqu=set_equ_attr.get("block", 0),
            blocklink=link_attr.get("block", 0),
            blockGuild=guild_attr.get("block", 0),
            blockCheer=cheer_attr.get("block", 0),
            blockTravel=travel_attr.get("block", 0),

            ductilityHero=self_attr.get("ductility", 0),
            ductilityEqu=equ_attr.get("ductility", 0),
            ductilitySetEqu=set_equ_attr.get("ductility", 0),
            ductilitylink=link_attr.get("ductility", 0),
            ductilityGuild=guild_attr.get("ductility", 0),
            ductilityCheer=cheer_attr.get("ductility", 0),
            ductilityTravel=travel_attr.get("ductility", 0),
            )


    # hpArray
    # hero_info.hp+hero_info.growHp*heroLevel+hpB+hero_info.hp*parameters+hpSeal+hpStone
    hpArray_formula = formula_config.get("hpArray")
    assert hpArray_formula!=None, "hpArray formula can not be None!"
    hpArray = eval(hpArray_formula, all_vars)

    # atkArray
    # hero_info.atk+hero_info.growAtk*heroLevel+atkB+hero_info.atk*parameters+atkSeal+atkStone
    atkArray_formula = formula_config.get("atkArray")
    atkArray = eval(atkArray_formula, all_vars)

    # pdefArray
    # hero_info.physicalDef+hero_info.growPhysicalDef*heroLevel+pDefB+hero_info.physicalDef*parameters+pDefSeal+pDefStone
    physicalDefArray_formula = formula_config.get("physicalDefArray")
    physicalDefArray = eval(physicalDefArray_formula, all_vars)

    # magicDefArray
    # hero_info.magicDef+hero_info.growMagicDef*heroLevel+mDefB+hero_info.magicDef*parameters+mDefSeal+mDefStone
    magicDefArray_formula = formula_config.get("magicDefArray")
    magicDefArray = eval(magicDefArray_formula, all_vars)

    # hitArray
    # hero_info.hit+hitB+hitSeal+hitStone
    hitArray_formula = formula_config.get("hitArray")
    hitArray = eval(hitArray_formula, all_vars)

    # dodgeArray
    # hero_info.dodge+dodgeB+dodgeSeal+dodgeStone
    dodgeArray_formula = formula_config.get("dodgeArray")
    dodgeArray = eval(dodgeArray_formula, all_vars)

    # criArray
    # hero_info.cri+criB+criSeal+criStone
    criArray_formula = formula_config.get("criArray")
    criArray = eval(criArray_formula, all_vars)

    # criCoeffArray
    # hero_info.criCoeff+criCoeffB+criCoeffSeal+criCoeffStone
    criCoeffArray_formula = formula_config.get("criCoeffArray")
    criCoeffArray = eval(criCoeffArray_formula, all_vars)

    # criDedCoeffArray
    # hero_info.criDedCoeff+criDedCoeffB+criDedCoeffSeal+criDedCoeffStone
    criDedCoeffArray_formula = formula_config.get("criDedCoeffArray")
    criDedCoeffArray = eval(criDedCoeffArray_formula, all_vars)

    # blockArray
    # hero_info.block+blockB+blockSeal+blockStone
    blockArray_formula = formula_config.get("blockArray")
    blockArray = eval(blockArray_formula, all_vars)

    # ductilityArray
    # hero_info.ductility+ductilityB+ductilitySeal+ductilityStone
    ductilityArray_formula = formula_config.get("ductilityArray")
    ductilityArray = eval(ductilityArray_formula, all_vars)

    return dict(hp=hpArray,
            atk=atkArray,
            physical_def=physicalDefArray,
            magic_def=magicDefArray,
            hit=hitArray,
            dodge=dodgeArray,
            cri=criArray,
            criCoeff=criCoeffArray,
            criDedCoeff=criDedCoeffArray,
            block=blockArray,
            ductility=ductilityArray
            )

def skill_attr(hero, hero_info, skill_ids):
    skill_attr = {}
    formulas = (("hpB_1", "hp"))
    for skill_id in skill_ids:
        skill_info = skill_buff_config.get(skill_id)
        assert skill_info!=None, "skill buff: %s not in skill_buff_config!" % skill_id
        cal_vars = dict(
            valueEffect=skill_info.valueEffect,
            levelEffectValue=skill_info.levelEffectValue,
            heroLevel=hero.level,
            hero_info=hero_info
            )
        pre_vars = dict(
            valueEffect=skill_info.valueEffect,
            levelEffectValue=skill_info.levelEffectValue,
            triggerType=skill_info.triggerType,
            effectPos=skill_info.effectPos
        )

        for formula_key, result_key in formulas:
            formula = formula_config.get(formula_key)
            pre_formula = formula.get("precondition")
            if eval(pre_formula, pre_vars):
                skill_attr[result_key] = eval(formula, cal_vars)

def cheer_attr(player):
    """docstring for cheer_attr"""
    all_vars = {}

    for slot_no, slot in player.line_up_component.sub_slots.items():
        hero_no = slot.hero_slot.hero_no
        hero = player.hero_component.get_hero(hero_no)
        if not hero: continue

        if slot_no == 1:
            self_attr = hero_self_attr(player, hero)
            all_vars["hpHero1"] = self_attr.get("hpHero", 0)
            all_vars["atkHero1"] = self_attr.get("atkHero", 0)
            all_vars["physicalDefHero1"] = self_attr.get("physicalDefHero", 0)
            all_vars["magicDefHero1"] = self_attr.get("magicDefHero", 0)
        if slot_no == 2:
            self_attr = hero_self_attr(player, hero_no)
            all_vars["hpHero2"] = self_attr.get("hpHero", 0)
            all_vars["atkHero2"] = self_attr.get("atkHero", 0)
            all_vars["physicalDefHero2"] = self_attr.get("physicalDefHero", 0)
            all_vars["magicDefHero2"] = self_attr.get("magicDefHero", 0)

        if slot_no == 3:
            self_attr = hero_self_attr(player, hero_no)
            all_vars["hpHero3"] = self_attr.get("hpHero", 0)
            all_vars["atkHero3"] = self_attr.get("atkHero", 0)
            all_vars["physicalDefHero3"] = self_attr.get("physicalDefHero", 0)
            all_vars["magicDefHero3"] = self_attr.get("magicDefHero", 0)

        if slot_no == 4:
            self_attr = hero_self_attr(player, hero_no)
            all_vars["hpHero4"] = self_attr.get("hpHero", 0)
            all_vars["atkHero4"] = self_attr.get("atkHero", 0)
            all_vars["physicalDefHero4"] = self_attr.get("physicalDefHero", 0)
            all_vars["magicDefHero4"] = self_attr.get("magicDefHero", 0)

        if slot_no == 5:
            self_attr = hero_self_attr(player, hero_no)
            all_vars["hpHero5"] = self_attr.get("hpHero", 0)
            all_vars["atkHero5"] = self_attr.get("atkHero", 0)
            all_vars["physicalDefHero5"] = self_attr.get("physicalDefHero", 0)
            all_vars["magicDefHero5"] = self_attr.get("magicDefHero", 0)

        if slot_no == 6:
            self_attr = hero_self_attr(player, hero_no)
            all_vars["hpHero6"] = self_attr.get("hpHero", 0)
            all_vars["atkHero6"] = self_attr.get("atkHero", 0)
            all_vars["physicalDefHero6"] = self_attr.get("physicalDefHero", 0)
            all_vars["magicDefHero6"] = self_attr.get("magicDefHero", 0)
    formula = formula_config.get("hpCheer")
    hpCheer = eval(formula, all_vars)

    formula = formula_config.get("atkCheer")
    atkCheer = eval(formula, all_vars)

    formula = formula_config.get("physicalDefCheer")
    physicalDefCheer = eval(formula, all_vars)

    formula = formula_config.get("magicDefCheer")
    magicDefCheer = eval(formula, all_vars)
    return dict(hp=hpCheer,
            atk=atkCheer,
            physical_def=physicalDefCheer,
            magic_def=magicDefCheer)

def combat_power_hero_self(player, hero_no):
    """
    武将自身的战斗力。
    (atkHero+(physicalDefHero+magicDefHero)/2)*hpHero**0.5*
    (hitHero+dodgeHero+criHero+criCoeffHero+criDedCoeffHero+blockHero+ductilityHero)/10000
    """

    self_attr = hero_self_attr(player, hero_no)
    formula = formula_config.get("fightValueHero")
    assert formula!=None, "formula can not be None"
    result = eval(formula, self_attr)
    return result

def combat_power_hero_lineup(player, hero_no, line_up_slot_no):
    """
    武将在阵容中的战斗力。
    (atkArray+(physicalDefArray+magicDefArray)/2)*hpArray**0.5*
    (hitArray+dodgeArray+criArray+criCoeffArray+criDedCoeffArray+blockArray+ductilityArray)/10000
    """
    line_up_attr = hero_self_attr(player, hero_no, line_up_slot_no)
    formula = formula_config.get("fightValueArray")
    assert formula!=None, "formula can not be None"
    result = eval(formula, line_up_attr)
    return result

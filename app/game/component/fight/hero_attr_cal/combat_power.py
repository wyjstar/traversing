# -*- coding:utf-8 -*-
"""
created by server on 14-12-29下午2:03.
"""
from shared.db_opear.configs_data import game_configs
from shared.utils import pprint

LOG_NAME = ""
LOG = False



def hero_self_attr(player, hero, stage=None):
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
    if hero is None:
        return {}

    assert hero!=None, "hero can not be None!"

    hero_info = hero.hero_info

    # 突破
    break_attr = skill_attr(hero, hero_info, hero.break_skill_ids)
    # 炼体
    refine_attr = hero.refine_attr()
    # 符文
    runt_attr = hero.runt_attr()
    # awake_percent
    # print("hero.awake_level %s" % hero.awake_level)
    #addition = game_configs.awake_config.get(hero.awake_level).get("addition")

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
        pDefSeal=refine_attr.get("physicalDef", 0),
        pDefStone=runt_attr.get("physical_def", 0),

        mDefB=break_attr.get("magic_def", 0),
        mDefSeal=refine_attr.get("magicDef", 0),
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
        criCoeffSeal=refine_attr.get("criCoeff", 0),
        criCoeffStone=runt_attr.get("cri_coeff", 0),

        criDedCoeffB=break_attr.get("cri_ded_coeff", 0),
        criDedCoeffSeal=refine_attr.get("criDedCoeff", 0),
        criDedCoeffStone=runt_attr.get("cri_ded_coeff", 0),

        blockB=break_attr.get("block", 0),
        blockSeal=refine_attr.get("block", 0),
        blockStone=runt_attr.get("block", 0),

        ductilityB=break_attr.get("ductility", 0),
        ductilitySeal=refine_attr.get("ductility", 0),
        ductilityStone=runt_attr.get("ductility", 0),
        #awake_percent=addition,
    )

    log(hero.hero_no, "计算武将自身属性所需的所有参数：", "", all_vars)

    log(hero.hero_no, "武将突破", hero.break_skill_ids, break_attr)
    log(hero.hero_no, "武将炼体", hero.refine, refine_attr)
    log(hero.hero_no, "武将符文", log_runt(hero), runt_attr)


    # hpHero
    # hero_info.hp+hero_info.growHp*heroLevel+hpB+hero_info.hp*parameters+hpSeal+hpStone
    hpHero_formula = game_configs.formula_config.get("hpHeroBase").get("formula")
    assert hpHero_formula!=None, "hpHero formula can not be None!"
    hpHeroBase = eval(hpHero_formula, all_vars)

    hpHero_formula = game_configs.formula_config.get("hpHeroSelf").get("formula")
    assert hpHero_formula!=None, "hpHero formula can not be None!"
    hpHero = eval(hpHero_formula, dict(hpHeroBase=hpHeroBase, AwakePercent=hero.awake_info.addition))

    # atkHero
    # hero_info.atk+hero_info.growAtk*heroLevel+atkB+hero_info.atk*parameters+atkSeal+atkStone
    atkHero_formula = game_configs.formula_config.get("atkHeroBase").get("formula")
    atkHeroBase = eval(atkHero_formula, all_vars)
    atkHero_formula = game_configs.formula_config.get("atkHeroSelf").get("formula")
    atkHero = eval(atkHero_formula, dict(atkHeroBase=atkHeroBase, AwakePercent=hero.awake_info.addition))
    #print("hero awake_percent: ",hpHeroBase, hpHero, hero.awake_info.addition)

    # pdefHero
    # hero_info.physicalDef+hero_info.growPhysicalDef*heroLevel+pDefB+hero_info.physicalDef*parameters+pDefSeal+pDefStone
    physicalDefHero_formula = game_configs.formula_config.get("physicalDefHeroBase").get("formula")
    physicalDefHeroBase = eval(physicalDefHero_formula, all_vars)
    physicalDefHero_formula = game_configs.formula_config.get("physicalDefHeroSelf").get("formula")
    physicalDefHero = eval(physicalDefHero_formula, dict(physicalDefHeroBase=physicalDefHeroBase, AwakePercent=hero.awake_info.addition))

    # magicDefHero
    # hero_info.magicDef+hero_info.growMagicDef*heroLevel+mDefB+hero_info.magicDef*parameters+mDefSeal+mDefStone
    magicDefHero_formula = game_configs.formula_config.get("magicDefHeroBase").get("formula")
    magicDefHeroBase = eval(magicDefHero_formula, all_vars)
    magicDefHero_formula = game_configs.formula_config.get("magicDefHeroSelf").get("formula")
    magicDefHero = eval(magicDefHero_formula, dict(magicDefHeroBase=magicDefHeroBase, AwakePercent=hero.awake_info.addition))
    # hitHero
    # hero_info.hit+hitB+hitSeal+hitStone
    hitHero_formula = game_configs.formula_config.get("hitHero").get("formula")
    hitHero = eval(hitHero_formula, all_vars)

    # dodgeHero
    # hero_info.dodge+dodgeB+dodgeSeal+dodgeStone
    dodgeHero_formula = game_configs.formula_config.get("dodgeHero").get("formula")
    dodgeHero = eval(dodgeHero_formula, all_vars)
    # criHero
    # hero_info.cri+criB+criSeal+criStone
    criHero_formula = game_configs.formula_config.get("criHero").get("formula")
    criHero = eval(criHero_formula, all_vars)

    # criCoeffHero
    # hero_info.criCoeff+criCoeffB+criCoeffSeal+criCoeffStone
    criCoeffHero_formula = game_configs.formula_config.get("criCoeffHero").get("formula")
    criCoeffHero = eval(criCoeffHero_formula, all_vars)
    # criDedCoeffHero
    # hero_info.criDedCoeff+criDedCoeffB+criDedCoeffSeal+criDedCoeffStone
    criDedCoeffHero_formula = game_configs.formula_config.get("criDedCoeffHero").get("formula")
    criDedCoeffHero = eval(criDedCoeffHero_formula, all_vars)
    # blockHero
    # hero_info.block+blockB+blockSeal+blockStone
    blockHero_formula = game_configs.formula_config.get("blockHero").get("formula")
    blockHero = eval(blockHero_formula, all_vars)
    # ductilityHero
    # hero_info.ductility+ductilityB+ductilitySeal+ductilityStone
    ductilityHero_formula = game_configs.formula_config.get("ductilityHero").get("formula")
    ductilityHero = eval(ductilityHero_formula, all_vars)

    self_attr = dict(hpHeroSelf=hpHero,
                hpHeroBase=hpHeroBase,
                atkHeroSelf=atkHero,
                atkHeroBase=atkHeroBase,
                physicalDefHeroSelf=physicalDefHero,
                physicalDefHeroBase=physicalDefHeroBase,
                magicDefHeroSelf=magicDefHero,
                magicDefHeroBase=magicDefHeroBase,
                hitHero=hitHero,
                dodgeHero=dodgeHero,
                criHero=criHero,
                criCoeffHero=criCoeffHero,
                criDedCoeffHero=criDedCoeffHero,
                blockHero=blockHero,
                ductilityHero=ductilityHero
                )
    if stage:
        stage.update_hero_self_attr(hero.hero_no, self_attr, player)

    return self_attr

def hero_lineup_attr(player, hero, line_up_slot_no, stage=None):
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
    self_attr = hero_self_attr(player, hero, stage)
    # 装备
    equ_attr = line_up_slot.equ_attr(self_attr)
    # 套装
    set_equ_attr = skill_attr(hero, hero_info, line_up_slot.set_equ_skill_ids)
    # 羁绊
    link_attr = skill_attr(hero, hero_info, hero_slot.link_skill_ids)
    # 游历
    travel_attr = player.travel_component.get_travel_item_attr()
    # 助威
    cheer_attr = _cheer_attr(player)
    # 公会
    guild_attr = player.line_up_component.guild_attr
    log(hero.hero_no, "武将自身", "", self_attr)
    log(hero.hero_no, "武将装备", log_equ(line_up_slot), equ_attr)
    log(hero.hero_no, "武将套装", "与装备一致", set_equ_attr)
    log(hero.hero_no, "武将羁绊", hero_slot.link_skill_ids, link_attr)
    log(hero.hero_no, "武将游历", log_travel(player), travel_attr)
    log(hero.hero_no, "武将助威", log_cheer(player), cheer_attr)
    log(hero.hero_no, "武将公会", 7, guild_attr)
    all_vars = dict(
            hpEqu=equ_attr.get("hp", 0),
            hpSetEqu=set_equ_attr.get("hp", 0),
            hplink=link_attr.get("hp", 0),
            hpGuild=guild_attr.get("hp", 0),
            hpCheer=cheer_attr.get("hp", 0),
            hpTravel=travel_attr.get("hp", 0),

            atkEqu=equ_attr.get("atk", 0),
            atkSetEqu=set_equ_attr.get("atk", 0),
            atklink=link_attr.get("atk", 0),
            atkGuild=guild_attr.get("atk", 0),
            atkCheer=cheer_attr.get("atk", 0),
            atkTravel=travel_attr.get("atk", 0),

            physicalDefEqu=equ_attr.get("physical_def", 0),
            physicalDefSetEqu=set_equ_attr.get("physical_def", 0),
            physicalDeflink=link_attr.get("physical_def", 0),
            physicalDefGuild=guild_attr.get("physical_def", 0),
            physicalDefCheer=cheer_attr.get("physical_def", 0),
            physicalDefTravel=travel_attr.get("physical_def", 0),

            magicDefEqu=equ_attr.get("magic_def", 0),
            magicDefSetEqu=set_equ_attr.get("magic_def", 0),
            magicDeflink=link_attr.get("magic_def", 0),
            magicDefGuild=guild_attr.get("magic_def", 0),
            magicDefCheer=cheer_attr.get("magic_def", 0),
            magicDefTravel=travel_attr.get("magic_def", 0),

            hitEqu=equ_attr.get("hit", 0),
            hitSetEqu=set_equ_attr.get("hit", 0),
            hitlink=link_attr.get("hit", 0),
            hitGuild=guild_attr.get("hit", 0),
            hitCheer=cheer_attr.get("hit", 0),
            hitTravel=travel_attr.get("hit", 0),

            dodgeEqu=equ_attr.get("dodge", 0),
            dodgeSetEqu=set_equ_attr.get("dodge", 0),
            dodgelink=link_attr.get("dodge", 0),
            dodgeGuild=guild_attr.get("dodge", 0),
            dodgeCheer=cheer_attr.get("dodge", 0),
            dodgeTravel=travel_attr.get("dodge", 0),

            criEqu=equ_attr.get("cri", 0),
            criSetEqu=set_equ_attr.get("cri", 0),
            crilink=link_attr.get("cri", 0),
            criGuild=guild_attr.get("cri", 0),
            criCheer=cheer_attr.get("cri", 0),
            criTravel=travel_attr.get("cri", 0),

            criCoeffEqu=equ_attr.get("cri_coeff", 0),
            criCoeffSetEqu=set_equ_attr.get("cri_coeff", 0),
            criCoefflink=link_attr.get("cri_coeff", 0),
            criCoeffGuild=guild_attr.get("cri_coeff", 0),
            criCoeffCheer=cheer_attr.get("cri_coeff", 0),
            criCoeffTravel=travel_attr.get("cri_coeff", 0),

            criDedCoeffEqu=equ_attr.get("cri_ded_coeff", 0),
            criDedCoeffSetEqu=set_equ_attr.get("cri_ded_coeff", 0),
            criDedCoefflink=link_attr.get("cri_ded_coeff", 0),
            criDedCoeffGuild=guild_attr.get("cri_ded_coeff", 0),
            criDedCoeffCheer=cheer_attr.get("cri_ded_coeff", 0),
            criDedCoeffTravel=travel_attr.get("cri_ded_coeff", 0),

            blockEqu=equ_attr.get("block", 0),
            blockSetEqu=set_equ_attr.get("block", 0),
            blocklink=link_attr.get("block", 0),
            blockGuild=guild_attr.get("block", 0),
            blockCheer=cheer_attr.get("block", 0),
            blockTravel=travel_attr.get("block", 0),

            ductilityEqu=equ_attr.get("ductility", 0),
            ductilitySetEqu=set_equ_attr.get("ductility", 0),
            ductilitylink=link_attr.get("ductility", 0),
            ductilityGuild=guild_attr.get("ductility", 0),
            ductilityCheer=cheer_attr.get("ductility", 0),
            ductilityTravel=travel_attr.get("ductility", 0),
            )

    all_vars.update(self_attr)

    log(hero.hero_no, "计算武将阵容属性所需的所有参数：", "", all_vars)
    #if hero.hero_no == 10045: logger_cal.debug("武将阵容属性中的输入:%s" % pprint.pformat(all_vars, indent=1))
    # hpArray
    # hero_info.hp+hero_info.growHp*heroLevel+hpB+hero_info.hp*parameters+hpSeal+hpStone
    hpArray_formula = game_configs.formula_config.get("hpHeroLineBase").get("formula")
    assert hpArray_formula!=None, "hpArray formula can not be None!"
    hpHeroLineBase = eval(hpArray_formula, dict(hpHeroBase=self_attr.get("hpHeroBase"), AwakePercent=hero.awake_info.addition, EquPercent=equ_attr.get("hpHeroPercent", 0)))
    all_vars.update(dict(hpHeroLineBase=hpHeroLineBase))
    hpArray_formula = game_configs.formula_config.get("hpHeroLine").get("formula")
    hpArray = eval(hpArray_formula, all_vars)

    # atkArray
    # hero_info.atk+hero_info.growAtk*heroLevel+atkB+hero_info.atk*parameters+atkSeal+atkStone
    atkArray_formula = game_configs.formula_config.get("atkHeroLineBase").get("formula")
    atkHeroLineBase = eval(atkArray_formula, dict(atkHeroBase=self_attr.get("atkHeroBase"), AwakePercent=hero.awake_info.addition, EquPercent=equ_attr.get("atkHeroPercent", 0)))
    all_vars.update(dict(atkHeroLineBase=atkHeroLineBase))
    atkArray_formula = game_configs.formula_config.get("atkHeroLine").get("formula")
    atkArray = eval(atkArray_formula, all_vars)

    # pdefArray
    # hero_info.physicalDef+hero_info.growPhysicalDef*heroLevel+pDefB+hero_info.physicalDef*parameters+pDefSeal+pDefStone
    physicalDefArray_formula = game_configs.formula_config.get("physicalDefHeroLineBase").get("formula")
    physicalDefHeroLineBase = eval(physicalDefArray_formula, dict(physicalDefHeroBase=self_attr.get("physicalDefHeroBase"), AwakePercent=hero.awake_info.addition, EquPercent=equ_attr.get("physicalDefHeroPercent", 0)))
    all_vars.update(dict(physicalDefHeroLineBase=physicalDefHeroLineBase))
    physicalDefArray_formula = game_configs.formula_config.get("physicalDefHeroLine").get("formula")
    physicalDefArray = eval(physicalDefArray_formula, all_vars)

    # magicDefArray
    # hero_info.magicDef+hero_info.growMagicDef*heroLevel+mDefB+hero_info.magicDef*parameters+mDefSeal+mDefStone
    magicDefArray_formula = game_configs.formula_config.get("magicDefHeroLineBase").get("formula")
    magicDefHeroLineBase = eval(magicDefArray_formula, dict(magicDefHeroBase=self_attr.get("magicDefHeroBase"), AwakePercent=hero.awake_info.addition, EquPercent=equ_attr.get("magicDefHeroPercent", 0)))
    all_vars.update(dict(magicDefHeroLineBase=magicDefHeroLineBase))
    magicDefArray_formula = game_configs.formula_config.get("magicDefHeroLine").get("formula")
    magicDefArray = eval(magicDefArray_formula, all_vars)

    # hitArray
    # hero_info.hit+hitB+hitSeal+hitStone
    hitArray_formula = game_configs.formula_config.get("hitArray").get("formula")
    hitArray = eval(hitArray_formula, all_vars)

    # dodgeArray
    # hero_info.dodge+dodgeB+dodgeSeal+dodgeStone
    dodgeArray_formula = game_configs.formula_config.get("dodgeArray").get("formula")
    dodgeArray = eval(dodgeArray_formula, all_vars)

    # criArray
    # hero_info.cri+criB+criSeal+criStone
    criArray_formula = game_configs.formula_config.get("criArray").get("formula")
    criArray = eval(criArray_formula, all_vars)

    # criCoeffArray
    # hero_info.criCoeff+criCoeffB+criCoeffSeal+criCoeffStone
    criCoeffArray_formula = game_configs.formula_config.get("criCoeffArray").get("formula")
    criCoeffArray = eval(criCoeffArray_formula, all_vars)

    # criDedCoeffArray
    # hero_info.criDedCoeff+criDedCoeffB+criDedCoeffSeal+criDedCoeffStone
    criDedCoeffArray_formula = game_configs.formula_config.get("criDedCoeffArray").get("formula")
    criDedCoeffArray = eval(criDedCoeffArray_formula, all_vars)

    # blockArray
    # hero_info.block+blockB+blockSeal+blockStone
    blockArray_formula = game_configs.formula_config.get("blockArray").get("formula")
    blockArray = eval(blockArray_formula, all_vars)

    # ductilityArray
    # hero_info.ductility+ductilityB+ductilitySeal+ductilityStone
    ductilityArray_formula = game_configs.formula_config.get("ductilityArray").get("formula")
    ductilityArray = eval(ductilityArray_formula, all_vars)

    return dict(hpHeroLine=hpArray,
            atkHeroLine=atkArray,
            physicalDefHeroLine=physicalDefArray,
            magicDefHeroLine=magicDefArray,
            hitArray=hitArray,
            dodgeArray=dodgeArray,
            criArray=criArray,
            criCoeffArray=criCoeffArray,
            criDedCoeffArray=criDedCoeffArray,
            blockArray=blockArray,
            ductilityArray=ductilityArray
            )

def skill_attr(hero, hero_info, skill_ids):
    # print("skill_attr:skill_ids %s" % skill_ids)
    attr = {}
    formulas = (
            ("hpB_1", "hp"),
            ("hpB_2", "hp"),
            ("atkB_1", "atk"),
            ("atkB_2", "atk"),
            ("pDefB_1", "physical_def"),
            ("pDefB_2", "physical_def"),
            ("mDefB_1", "magic_def"),
            ("mDefB_2", "magic_def"),
            ("hitB", "hit"),
            ("dodgeB", "dodge"),
            ("criB", "cri"),
            ("criCoeffB", "cri_coeff"),
            ("criDedCoeffB", "cri_ded_coeff"),
            ("blockB", "block"),
            ("ductilityB", "ductilityB")
            )
    for skill_id in skill_ids:
        if not skill_id: continue

        skill_buff_ids = game_configs.skill_config.get(skill_id).get("group")
        for skill_id in skill_buff_ids:
            skill_info = game_configs.skill_buff_config.get(skill_id)

            assert skill_info!=None, "skill buff: %s not in game_configs.skill_buff_config!" % skill_id
            cal_vars = dict(
                skill_buff=skill_info,
                heroLevel=hero.level,
                hero_info=hero_info
                )
            pre_vars = dict(skill_buff=skill_info)

            for formula_key, result_key in formulas:
                formula_info = game_configs.formula_config.get(formula_key)
                pre_formula = formula_info.get("precondition")
                formula = formula_info.get("formula")
                if eval(pre_formula, pre_vars):
                    val = attr.get(result_key, 0)
                    attr[result_key] = val + eval(formula, cal_vars)
    return attr

def _cheer_attr(player):
    """docstring for cheer_attr"""
    all_vars = {}
    line_up_slots_has_heros = player.line_up_component.line_up_slots_has_heros
    all_vars["person"] = len(line_up_slots_has_heros)


    for slot_no, slot in player.line_up_component.sub_slots.items():
        hero_no = slot.hero_slot.hero_no
        hero = player.hero_component.get_hero(hero_no)

        if slot_no == 1:
            self_attr = hero_self_attr(player, hero)
            all_vars["hpHeroSelf1"] = self_attr.get("hpHeroSelf", 0)
            all_vars["atkHeroSelf1"] = self_attr.get("atkHeroSelf", 0)
            all_vars["physicalDefHeroSelf1"] = self_attr.get("physicalDefHeroSelf", 0)
            all_vars["magicDefHeroSelf1"] = self_attr.get("magicDefHeroSelf", 0)
        if slot_no == 2:
            self_attr = hero_self_attr(player, hero)
            all_vars["hpHeroSelf2"] = self_attr.get("hpHeroSelf", 0)
            all_vars["atkHeroSelf2"] = self_attr.get("atkHeroSelf", 0)
            all_vars["physicalDefHeroSelf2"] = self_attr.get("physicalDefHeroSelf", 0)
            all_vars["magicDefHeroSelf2"] = self_attr.get("magicDefHeroSelf", 0)

        if slot_no == 3:
            self_attr = hero_self_attr(player, hero)
            all_vars["hpHeroSelf3"] = self_attr.get("hpHeroSelf", 0)
            all_vars["atkHeroSelf3"] = self_attr.get("atkHeroSelf", 0)
            all_vars["physicalDefHeroSelf3"] = self_attr.get("physicalDefHeroSelf", 0)
            all_vars["magicDefHeroSelf3"] = self_attr.get("magicDefHeroSelf", 0)

        if slot_no == 4:
            self_attr = hero_self_attr(player, hero)
            all_vars["hpHeroSelf4"] = self_attr.get("hpHeroSelf", 0)
            all_vars["atkHeroSelf4"] = self_attr.get("atkHeroSelf", 0)
            all_vars["physicalDefHeroSelf4"] = self_attr.get("physicalDefHeroSelf", 0)
            all_vars["magicDefHeroSelf4"] = self_attr.get("magicDefHeroSelf", 0)

        if slot_no == 5:
            self_attr = hero_self_attr(player, hero)
            all_vars["hpHeroSelf5"] = self_attr.get("hpHeroSelf", 0)
            all_vars["atkHeroSelf5"] = self_attr.get("atkHeroSelf", 0)
            all_vars["physicalDefHeroSelf5"] = self_attr.get("physicalDefHeroSelf", 0)
            all_vars["magicDefHeroSelf5"] = self_attr.get("magicDefHeroSelf", 0)

        if slot_no == 6:
            self_attr = hero_self_attr(player, hero)
            all_vars["hpHeroSelf6"] = self_attr.get("hpHeroSelf", 0)
            all_vars["atkHeroSelf6"] = self_attr.get("atkHeroSelf", 0)
            all_vars["physicalDefHeroSelf6"] = self_attr.get("physicalDefHeroSelf", 0)
            all_vars["magicDefHeroSelf6"] = self_attr.get("magicDefHeroSelf", 0)
    formula = game_configs.formula_config.get("hpCheerLine").get("formula")
    hpCheer = eval(formula, all_vars)

    formula = game_configs.formula_config.get("atkCheerLine").get("formula")
    atkCheer = eval(formula, all_vars)

    formula = game_configs.formula_config.get("physicalDefCheerLine").get("formula")
    physicalDefCheer = eval(formula, all_vars)

    formula = game_configs.formula_config.get("magicDefCheerLine").get("formula")
    magicDefCheer = eval(formula, all_vars)
    return dict(hp=hpCheer,
            atk=atkCheer,
            physical_def=physicalDefCheer,
            magic_def=magicDefCheer)

def combat_power_hero_self(player, hero):
    """
    武将自身的战斗力。
    (atkHero+(physicalDefHero+magicDefHero)/2)*hpHero**0.5*
    (hitHero+dodgeHero+criHero+criCoeffHero+criDedCoeffHero+blockHero+ductilityHero)/10000
    """
    self_attr = hero_self_attr(player, hero)
    self_attr["job"] = hero.hero_info.job
    formula = game_configs.formula_config.get("fightValueHeroSelf").get("formula")
    assert formula!=None, "formula can not be None"
    result = eval(formula, self_attr)

    log(hero.hero_no, "武将自身战力：", "", result)
    return result

def combat_power_hero_lineup(player, hero, line_up_slot_no, log_name=""):
    """
    武将在阵容中的战斗力。
    (atkArray+(physicalDefArray+magicDefArray)/2)*hpArray**0.5*
    (hitArray+dodgeArray+criArray+criCoeffArray+criDedCoeffArray+blockArray+ductilityArray)/10000
    """
    global LOG_NAME
    LOG_NAME = log_name
    create_log(hero.hero_no)
    line_up_attr = hero_lineup_attr(player, hero, line_up_slot_no)
    line_up_attr["job"] = hero.hero_info.job
    line_up_attr["hero_info"] = hero.hero_info
    log(hero.hero_no, "武将阵容", "", line_up_attr)
    formula = game_configs.formula_config.get("fightValueArrayLine").get("formula")
    assert formula!=None, "formula can not be None"
    result = eval(formula, line_up_attr)
    log(hero.hero_no, "武将阵容战力：", "", result)
    return result

def log_runt(hero):
    """docstring for pprint_runt"""
    s=[]
    for (runt_slot_type, item) in hero.runt.items():
        for (runt_po, runt_info) in item.items():
            [runt_id, runt_no, main_attr, minor_attr] = runt_info
            runt_type = game_configs.stone_config.get("stones").get(runt_no).get("type")
            s.append("符文编号%s, 符文槽类型%s, 符文类型%s, 符文是否镶嵌正确%s, 主要属性%s, 次要属性%s" % (runt_no, runt_slot_type, runt_type, runt_slot_type==runt_type, main_attr, minor_attr))
    return s

def log_equ(line_up_slot):
    s = []
    for no, slot in line_up_slot.equipment_slots.items():
        obj = slot.equipment_obj
        if not obj: continue
        equipment_no = obj.base_info.equipment_no
        strengthen_lv = obj.attribute.strengthen_lv
        s.append("装备编号%s, 装备等级%s, 主要属性%s, 次要属性%s" % (equipment_no, strengthen_lv, obj.attribute.main_attr, obj.attribute.minor_attr))
    return s

def log_travel(player):
    return player.travel_component.get_travel_item_groups()

def log_cheer(player):
    s = []
    for slot_no, slot in player.line_up_component.sub_slots.items():
        hero_no = slot.hero_slot.hero_no
        hero = player.hero_component.get_hero(hero_no)
        if not hero: continue
        s.append("助威阵容编号%s, 武将编号%s, 武将等级%s" % (slot_no, hero.hero_no, hero.level))
    return s


def create_log(hero_no):
    global LOG
    if not LOG:
        return
    f = open(str(hero_no)+"_hero_panel_"+LOG_NAME, "w")
    f.close()

def log(hero_no, title, str_input, str_output):
    global LOG
    if not LOG:
        return
    f = open(str(hero_no)+"_hero_panel_"+LOG_NAME, "a")
    f.write("%s \n 输入: %s \n 输出: %s \n\n" % (title, pprint.pformat(str_input), pprint.pformat(str_output)))
    f.close()

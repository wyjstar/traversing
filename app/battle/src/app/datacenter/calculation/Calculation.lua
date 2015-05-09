-- 武将自身属性计算= 基础属性+突破+炼体+符文
-- 武将阵容属性计算= 自身属性+装备+套装+羁绊+公会+助威+游历
Calculation = Calculation or class("Calculation")

function Calculation:ctor()
    self.c_SoldierData = getDataManager():getSoldierData()
    self.c_SoldierTemplate = getTemplateManager():getSoldierTemplate()
    self.c_EquipmentTemplate = getTemplateManager():getEquipTemplate()
    
    self.c_LineupData = getDataManager():getLineupData()
    self.c_TravelTemplate = getTemplateManager():getTravelTemplate()
    self.c_FormulaTemplate = getTemplateManager():getFormulaTemplate()
    self.formulas = {}
    self:preLoad() 
end

function Calculation:preLoad()
    -- 怪物战斗力
    local formula = self.c_FormulaTemplate:getFormulaByKey("fightValue").clientFormula
    local before = "function func(monster_info) "
    local after = " return result end"
    assert(loadstring(before..formula..after))()
    self.formulas["fightValue"] = func
    -- 装备战斗力
    local formula = self.c_FormulaTemplate:getFormulaByKey("equFightValue").clientFormula
    local before = "function func(equ_attr) "
    local after = " return result end"
    assert(loadstring(before..formula..after))()
    self.formulas["equFightValue"] = func
    -- 武将自身属性公式
    local before = "function func(hero_info, heroLevel, parameters, hpB, hpSeal, hpStone) "
    local after = " return result end"
    local formula = self.c_FormulaTemplate:getFormulaByKey("hpHero").clientFormula
    assert(loadstring(before..formula..after))()
    self.formulas["hpHero"] = func

    before = "function func(hero_info, heroLevel, parameters, atkB, atkSeal, atkStone) "
    after = " return result end"
    formula = self.c_FormulaTemplate:getFormulaByKey("atkHero").clientFormula
    assert(loadstring(before..formula..after))()
    self.formulas["atkHero"] = func

    before = "function func(hero_info, heroLevel, parameters, pDefB, pDefSeal, pDefStone) "
    after = " return result end"
    formula = self.c_FormulaTemplate:getFormulaByKey("physicalDefHero").clientFormula
    assert(loadstring(before..formula..after))()
    self.formulas["physicalDefHero"] = func

    before = "function func(hero_info, heroLevel, parameters, mDefB, mDefSeal, mDefStone) "
    after = " return result end"
    formula = self.c_FormulaTemplate:getFormulaByKey("magicDefHero").clientFormula
    assert(loadstring(before..formula..after))()
    self.formulas["magicDefHero"] = func

    before = "function func(hero_info, heroLevel, parameters, hitB, hitSeal, hitStone) "
    after = " return result end"
    formula = self.c_FormulaTemplate:getFormulaByKey("hitHero").clientFormula
    assert(loadstring(before..formula..after))()
    self.formulas["hitHero"] = func

    before = "function func(hero_info, heroLevel, parameters, dodgeB, dodgeSeal, dodgeStone) "
    after = " return result end"
    formula = self.c_FormulaTemplate:getFormulaByKey("dodgeHero").clientFormula
    assert(loadstring(before..formula..after))()
    self.formulas["dodgeHero"] = func

    before = "function func(hero_info, heroLevel, parameters, criB, criSeal, criStone) "
    after = " return result end"
    formula = self.c_FormulaTemplate:getFormulaByKey("criHero").clientFormula
    assert(loadstring(before..formula..after))()
    self.formulas["criHero"] = func

    before = "function func(hero_info, heroLevel, parameters, criCoeffB, criCoeffSeal, criCoeffStone) "
    after = " return result end"
    formula = self.c_FormulaTemplate:getFormulaByKey("criCoeffHero").clientFormula
    assert(loadstring(before..formula..after))()
    self.formulas["criCoeffHero"] = func

    before = "function func(hero_info, heroLevel, parameters, criDedCoeffB, criDedCoeffSeal, criDedCoeffStone) "
    after = " return result end"
    formula = self.c_FormulaTemplate:getFormulaByKey("criDedCoeffHero").clientFormula
    assert(loadstring(before..formula..after))()
    self.formulas["criDedCoeffHero"] = func

    before = "function func(hero_info, heroLevel, parameters, blockB, blockSeal, blockStone) "
    after = " return result end"
    formula = self.c_FormulaTemplate:getFormulaByKey("blockHero").clientFormula
    assert(loadstring(before..formula..after))()
    self.formulas["blockHero"] = func

    before = "function func(hero_info, heroLevel, parameters, ductilityB, ductilitySeal, ductilityStone) "
    after = " return result end"
    formula = self.c_FormulaTemplate:getFormulaByKey("ductilityHero").clientFormula
    assert(loadstring(before..formula..after))()
    self.formulas["ductilityHero"] = func

    local formula = self.c_FormulaTemplate:getFormulaByKey("fightValueHero").clientFormula
    local before = "function func(self_attr) "
    local after = " return result end"
    assert(loadstring(before..formula..after))()
    self.formulas["fightValueHero"] = func
    local formulas = {["hpB_1"] = "hp",
                ["hpB_2"] = "hp",
                ["atkB_1"] = "atk",
                ["atkB_2"] = "atk",
                ["pDefB_1"] = "physicalDef",
                ["pDefB_2"] = "physicalDef",
                ["mDefB_1"] = "magicDef",
                ["mDefB_2"] = "magicDef",
                ["hitB"] = "hit",
                ["dodgeB"] = "dodge",
                ["criB"] = "cri",
                ["criCoeffB"] = "criCoeff",
                ["criDedCoeffB"] = "criDedCoeff",
                ["blockB"] = "block",
                ["ductilityB"] = "ductility",
            }

    for key, res in pairs(formulas) do
        local formula_info = self.c_FormulaTemplate:getFormulaByKey(key)
        local pre_formula = formula_info["clientPrecondition"]
        pre_formula = " if "..pre_formula.." then local "
        local cal_formula = formula_info["clientFormula"]
        cal_formula = "function cal(skill_buff, heroLevel, hero_info) "..pre_formula..cal_formula.." return result end return 0 end"
        assert(loadstring(cal_formula))()
        self.formulas[key] = cal
    end
    -- 武将阵容属性公式
    local before = "function func(hpHero, hpEqu, hpSetEqu, hplink, hpGuild, hpCheer, hpTravel) "
    local after = " return result end"
    local formula = self.c_FormulaTemplate:getFormulaByKey("hpArray").clientFormula
    assert(loadstring(before..formula..after))()
    self.formulas["hpArray"] = func

    before = "function func(atkHero, atkEqu, atkSetEqu, atklink, atkGuild, atkCheer, atkTravel) "
    after = " return result end"
    formula = self.c_FormulaTemplate:getFormulaByKey("atkArray").clientFormula
    assert(loadstring(before..formula..after))()
    self.formulas["atkArray"] = func

    before = "function func(physicalDefHero, physicalDefEqu, physicalDefSetEqu, physicalDeflink, physicalDefGuild, physicalDefCheer, physicalDefTravel) "
    after = " return result end"
    formula = self.c_FormulaTemplate:getFormulaByKey("physicalDefArray").clientFormula
    assert(loadstring(before..formula..after))()
    self.formulas["physicalDefArray"] = func

    before = "function func(magicDefHero, magicDefEqu, magicDefSetEqu, magicDeflink, magicDefGuild, magicDefCheer, magicDefTravel) "
    after = " return result end"
    formula = self.c_FormulaTemplate:getFormulaByKey("magicDefArray").clientFormula
    assert(loadstring(before..formula..after))()
    self.formulas["magicDefArray"] = func

    before = "function func(hitHero, hitEqu, hitSetEqu, hitlink, hitGuild, hitCheer, hitTravel) "
    after = " return result end"
    formula = self.c_FormulaTemplate:getFormulaByKey("hitArray").clientFormula
    assert(loadstring(before..formula..after))()
    self.formulas["hitArray"] = func

    before = "function func(dodgeHero, dodgeEqu, dodgeSetEqu, dodgelink, dodgeGuild, dodgeCheer, dodgeTravel) "
    after = " return result end"
    formula = self.c_FormulaTemplate:getFormulaByKey("dodgeArray").clientFormula
    assert(loadstring(before..formula..after))()
    self.formulas["dodgeArray"] = func

    before = "function func(criHero, criEqu, criSetEqu, crilink, criGuild, criCheer, criTravel) "
    after = " return result end"
    formula = self.c_FormulaTemplate:getFormulaByKey("criArray").clientFormula
    assert(loadstring(before..formula..after))()
    self.formulas["criArray"] = func

    before = "function func(criCoeffHero, criCoeffEqu, criCoeffSetEqu, criCoefflink, criCoeffGuild, criCoeffCheer, criCoeffTravel) "
    after = " return result end"
    formula = self.c_FormulaTemplate:getFormulaByKey("criCoeffArray").clientFormula
    assert(loadstring(before..formula..after))()
    self.formulas["criCoeffArray"] = func

    before = "function func(criDedCoeffHero, criDedCoeffEqu, criDedCoeffSetEqu, criDedCoefflink, criDedCoeffGuild, criDedCoeffCheer, criDedCoeffTravel) "
    after = " return result end"
    formula = self.c_FormulaTemplate:getFormulaByKey("criDedCoeffArray").clientFormula
    assert(loadstring(before..formula..after))()
    self.formulas["criDedCoeffArray"] = func

    before = "function func(blockHero, blockEqu, blockSetEqu, blocklink, blockGuild, blockCheer, blockTravel) "
    after = " return result end"
    formula = self.c_FormulaTemplate:getFormulaByKey("blockArray").clientFormula
    assert(loadstring(before..formula..after))()
    self.formulas["blockArray"] = func

    before = "function func(ductilityHero, ductilityEqu, ductilitySetEqu, ductilitylink, ductilityGuild, ductilityCheer, ductilityTravel) "
    after = " return result end"
    formula = self.c_FormulaTemplate:getFormulaByKey("ductilityArray").clientFormula
    assert(loadstring(before..formula..after))()
    self.formulas["ductilityArray"] = func

    local formula = self.c_FormulaTemplate:getFormulaByKey("fightValueArray").clientFormula
    local before = "function func(lineup_attr) "
    local after = " return result end"
    assert(loadstring(before..formula..after))()
    self.formulas["fightValueArray"] = func
    -- 助威
    local before = "function func(hpHero1, hpHero2, hpHero3, hpHero4, hpHero5, hpHero6, person) "
    local after = " return result end"
    local formula = self.c_FormulaTemplate:getFormulaByKey("hpCheer").clientFormula
    assert(loadstring(before..formula..after))()
    self.formulas["hpCheer"] = func

    before = "function func(atkHero1, atkHero2, atkHero3, atkHero4, atkHero5, atkHero6, person) "
    after = " return result end"
    formula = self.c_FormulaTemplate:getFormulaByKey("atkCheer").clientFormula
    assert(loadstring(before..formula..after))()
    self.formulas["atkCheer"] = func

    before = "function func(physicalDefHero1, physicalDefHero2, physicalDefHero3, physicalDefHero4, physicalDefHero5, physicalDefHero6, person) "
    after = " return result end"
    formula = self.c_FormulaTemplate:getFormulaByKey("physicalDefCheer").clientFormula
    assert(loadstring(before..formula..after))()
    self.formulas["physicalDefCheer"] = func
    
    before = "function func(magicDefHero1, magicDefHero2, magicDefHero3, magicDefHero4, magicDefHero5, magicDefHero6, person) "
    after = " return result end"
    formula = self.c_FormulaTemplate:getFormulaByKey("magicDefCheer").clientFormula
    assert(loadstring(before..formula..after))()
    self.formulas["magicDefCheer"] = func

    local equFormulas = {
        ["hpEqu"]={"baseHp", "growHp"},
        ["atkEqu"]={"baseAtk", "growAtk"},
        ["physicalDefEqu"]={"basePdef", "growPdef"},
        ["magicDefEqu"]={"baseMdef", "growMdef"},
        ["hitEqu"]={"hit", "growHit"},
        ["dodgeEqu"]={"dodge", "growDodge"},
        ["criEqu"]={"cri", "growCri"},
        ["criCoeffEqu"]={"criCoeff", "growCriCoeff"},
        ["criDedCoeffEqu"]={"criDedCoeff", "growCriDedCoeff"},
        ["blockEqu"]={"block", "growBlock"},
        ["ductilityEqu"]={"ductility", "growDuctility"},
    }
    for formula_key, v in pairs(equFormulas) do
        local before = string.format("function func(%s, %s, equLevel) local ", v[1], v[2])
        local after = " return result end"
        local formula = self.c_FormulaTemplate:getFormulaByKey(formula_key).clientFormula
        --print(before..formula..after)
        assert(loadstring(before..formula..after))()
        self.formulas[formula_key] = func
    end
end

-- 突破
function Calculation:SoldierBreakAttr(hero, hero_info, break_skills)
    return self:SkillAttr(hero, hero_info, break_skills)
end

-- 炼体
-- SoldierTemplate.getAllAttribute

-- 符文
function Calculation:SoldierRuneAttr(hero)
    local attr = InitAttr()
    local temp = InitTemp()
    for _, runt_type in pairs(hero.runt_type) do
        local slot_type = runt_type.runt_type
        self:RuneAttrUtil(attr, temp, slot_type, runt_type.runt)
    end
    return attr
end

function Calculation:RuneAttrByType(hero, slot_type)
    local attr = InitAttr()
    local temp = InitTemp()
    local runes = self.c_LineupData:getRunesByType(hero, slot_type)
    if runes == nil then 
        return attr
    end

    self:RuneAttrUtil(attr, temp, slot_type, runes)
    return attr
end

function Calculation:RuneAttrUtil(attr, temp, slot_type, runes)
    local base_decay = getTemplateManager():getBaseTemplate():getRuneDecay()
    local decay = 1
    for _, runt in pairs(runes) do
        local runt_info = getTemplateManager():getStoneTemplate():getStoneItemById(runt.runt_id)
        
        if slot_type ~= runt_info.type then 
            decay = base_decay
        end

        for _, main_attr in pairs(runt.main_attr) do
            attr_key = temp[main_attr.attr_type]
            attr[attr_key] = attr[attr_key] + main_attr.attr_value*decay
        end
        for _, minor_attr in pairs(runt.minor_attr) do
            attr_key = temp[minor_attr.attr_type]
            attr[attr_key] = attr[attr_key] + minor_attr.attr_value*decay
        end
    end
end


function Calculation:SoldierBreakSkillIds(hero, hero_info)
    skill_ids = {}
    local break_level = hero.break_level
    for i = 1, break_level do 
        local break_str = "break" ..  i 
        local break_skill_id = hero_info[break_str]
        if break_skill_id ~= 0 then
            table.insert(skill_ids, break_skill_id)
        end
    end
    return skill_ids
end


-- 武将自身属性计算
function Calculation:SoldierSelfAttr(hero)
    local attr = InitHeroAttr()
    
    local hero_info = self.c_SoldierTemplate:getHeroTempLateById(hero.hero_no)
    attr["job"] = hero_info.job
    -- 突破
    local break_attr = self:SoldierBreakAttr(hero, hero_info, self:SoldierBreakSkillIds(hero, hero_info))
    -- 炼体
    local chain_attr = self.c_SoldierTemplate:getAllAttribute(hero.refine)
    -- 符文
    local rune_attr = self:SoldierRuneAttr(hero, hero_info)

    --appendFile(hero.hero_no, "突破", self:SoldierBreakSkillIds(hero, hero_info))
    --appendFile(hero.hero_no, "突破", break_attr)
    --appendFile(hero.hero_no, "练体", hero.refine)
    --appendFile(hero.hero_no, "练体", chain_attr)
    --appendFile(hero.hero_no, "符文", rune_attr)
    local parameters = 0
    if hero.break_level > 0 then
        parameters = hero_info["parameters"..hero.break_level]
    end

    attr["hpHero"] = self.formulas["hpHero"](hero_info, hero.level, parameters, break_attr.hp, chain_attr.hp, rune_attr.hp)
    
    attr["atkHero"] = self.formulas["atkHero"](hero_info, hero.level, parameters, break_attr.atk, chain_attr.atk, rune_attr.atk)

    attr["physicalDefHero"] = self.formulas["physicalDefHero"](hero_info, hero.level, parameters, break_attr.physicalDef, chain_attr.physicalDef, rune_attr.physicalDef)

    attr["magicDefHero"] = self.formulas["magicDefHero"](hero_info, hero.level, parameters, break_attr.magicDef, chain_attr.magicDef, rune_attr.magicDef)

    attr["hitHero"] = self.formulas["hitHero"](hero_info, hero.level, parameters, break_attr.hit, chain_attr.hit, rune_attr.hit)

    attr["dodgeHero"] = self.formulas["dodgeHero"](hero_info, hero.level, parameters, break_attr.dodge, chain_attr.dodge, rune_attr.dodge)

    attr["criHero"] = self.formulas["criHero"](hero_info, hero.level, parameters, break_attr.cri, chain_attr.cri, rune_attr.cri)

    attr["criCoeffHero"] = self.formulas["criCoeffHero"](hero_info, hero.level, parameters, break_attr.criCoeff, chain_attr.criCoeff, rune_attr.criCoeff)

    attr["criDedCoeffHero"] = self.formulas["criDedCoeffHero"](hero_info, hero.level, parameters, break_attr.criDedCoeff, chain_attr.criDedCoeff, rune_attr.criDedCoeff)

    attr["blockHero"] = self.formulas["blockHero"](hero_info, hero.level, parameters, break_attr.block, chain_attr.block, rune_attr.block)

    attr["ductilityHero"] = self.formulas["ductilityHero"](hero_info, hero.level, parameters, break_attr.ductility, chain_attr.ductility, rune_attr.ductility)
    return attr
end

-- 圣武将自身属性计算
function Calculation:AwakeSoldierSelfAttr(hero) 
    local hero_info = self.c_SoldierTemplate:getHeroTempLateById(hero.hero_no)
    awakeHero = clone(hero)
    awakeHero.hero_no = hero_info.awakeHeroID

    return self:SoldierSelfAttr(awakeHero)
end

-- 装备
function Calculation:EquAttr(line_up_slot, hero_self_attr)
    print("------Calculation:EquAttr---------")
    -- table.print(line_up_slot)
    local attr = InitAttr()
    if line_up_slot == nil or line_up_slot.equs == nil then return attr end
    for _, equ_slot in pairs(line_up_slot.equs) do
        local equ_id = equ_slot.equ.id
        if equ_id ~= nil and string.len(equ_id) ~= 0 then
            local equ = equ_slot.equ
            self:EquAttrUtil(attr, equ.main_attr, equ.strengthen_lv)
            self:EquAttrUtil(attr, equ.minor_attr, equ.strengthen_lv)
        end
    end
    -- 将百分比添加到
    local rate = {
        ["hpRate"] = "hp",
        ["atkRate"] = "atk",
        ["physicalDefRate"] = "physicalDef",
        ["magicDefRate"] = "magicDef",
        ["hitRate"] = "hit",
        ["dodgeRate"] = "dodge",
        ["criRate"] = "cri",
        ["criCoeffRate"] = "criCoeff",
        ["criDedCoeffRate"] = "criDedCoeff",
        ["blockRate"] = "block",
        ["ductilityRate"] = "ductility"
        }
    for k, v in pairs(rate) do
        if v ~= nil then
            attr[v] = attr[v] + attr[k]*hero_self_attr[v.."Hero"]
        end
    end
    return attr
end

-- 获取单个装备属性
function Calculation:getSingleEquAttr(equ)
    return self:EquAttrCalUtil(equ, equ.strengthen_lv)
end

-- 根据id获取装备原始属性
function Calculation:getSingleEquOriginAttr(equ)
    return self:EquAttrCalUtil(equ, 1)
end

function Calculation:EquAttrCalUtil(equ, strengthen_lv)
    local attr = InitAttr()
    local temp = InitTemp()
    self:EquAttrUtil(attr, equ.main_attr, strengthen_lv)
    self:EquAttrUtil(attr, equ.minor_attr, strengthen_lv)
    return attr
end

-- 单件装备战斗力
function Calculation:SingleEquCombatPower(equ)
    local equ_attr = self:getSingleEquAttr(equ)
    return self:EquCombatPowerUtil(equ_attr)
end

-- 单件装备原始战斗力
function Calculation:SingleOriginEquCombatPower(equ)
    local equ_attr = self:getSingleEquOriginAttr(equ)
    return self:EquCombatPowerUtil(equ_attr)
end

function Calculation:EquCombatPowerUtil(equ_attr)
    local result = self.formulas["equFightValue"](equ_attr)
    return result
end

function Calculation:SingleEquAttr(formula_key, str_base, str_grow, base, grow, level)
    return self.formulas[formula_key](base, grow, level)
end

function Calculation:SingleRateEquAttr(formula_key, str_value, str_rate_value, value, rate_value)
    local before = string.format("function func(%s, %s) local", str_value, str_rate_value)
    local after = " return result end"
    local formula = self.c_FormulaTemplate:getFormulaByKey(formula_key).clientFormula
    --print(formula)
    assert(loadstring(before..formula..after))()
    return func(value, rate_value)
end

function Calculation:EquAttrUtil(attr, temp_attrs, level)
    for _, temp_attr in pairs(temp_attrs) do
        if temp_attr.attr_type == 1 then
            if temp_attr.attr_value_type == 1 then
                attr.hp = attr.hp + self:SingleEquAttr("hpEqu", "baseHp", "growHp", temp_attr.attr_value, temp_attr.attr_increment, level)
            elseif temp_attr.attr_value_type == 2 then
                attr.hpRate = temp_attr.attr_value
            end
        elseif temp_attr.attr_type == 2 then
            if temp_attr.attr_value_type == 1 then
                attr.atk = attr.atk + self:SingleEquAttr("atkEqu", "baseAtk", "growAtk", temp_attr.attr_value, temp_attr.attr_increment, level)
            elseif temp_attr.attr_value_type == 2 then
                attr.atkRate = temp_attr.attr_value
            end
        elseif temp_attr.attr_type == 3 then
            if temp_attr.attr_value_type == 1 then
                attr.physicalDef = attr.physicalDef + self:SingleEquAttr("physicalDefEqu", "basePdef", "growPdef", temp_attr.attr_value, temp_attr.attr_increment, level)
            elseif temp_attr.attr_value_type == 2 then
                attr.physicalDefRate = temp_attr.attr_value
            end
        elseif temp_attr.attr_type == 4 then
            if temp_attr.attr_value_type == 1 then
                attr.magicDef = attr.magicDef + self:SingleEquAttr("magicDefEqu", "baseMdef", "growMdef", temp_attr.attr_value, temp_attr.attr_increment, level)
            elseif temp_attr.attr_value_type == 2 then
                attr.magicDefRate = temp_attr.attr_value
            end
        elseif temp_attr.attr_type == 5 then
            if temp_attr.attr_value_type == 1 then

                attr.hit = attr.hit + self:SingleEquAttr("hitEqu", "hit", "growHit", temp_attr.attr_value, temp_attr.attr_increment, level)
            elseif temp_attr.attr_value_type == 2 then
                attr.atkRate = temp_attr.attr_value
            end
        elseif temp_attr.attr_type == 6 then
            if temp_attr.attr_value_type == 1 then
                attr.dodge = attr.dodge + self:SingleEquAttr("dodgeEqu", "dodge", "growDodge", temp_attr.attr_value, temp_attr.attr_increment, level)
            elseif temp_attr.attr_value_type == 2 then
                attr.dodgeRate = temp_attr.attr_value
            end
        elseif temp_attr.attr_type == 7 then
            if temp_attr.attr_value_type == 1 then
                attr.cri = attr.cri + self:SingleEquAttr("criEqu", "cri", "growCri", temp_attr.attr_value, temp_attr.attr_increment, level)
            elseif temp_attr.attr_value_type == 2 then
                attr.criRate = temp_attr.attr_value
            end
        elseif temp_attr.attr_type == 8 then
            if temp_attr.attr_value_type == 1 then
                -- print("---------temp_attr.attr_increment----------",temp_attr.attr_increment)
                attr.criCoeff = attr.criCoeff + self:SingleEquAttr("criCoeffEqu", "criCoeff", "growCriCoeff", temp_attr.attr_value, temp_attr.attr_increment, level)
            elseif temp_attr.attr_value_type == 2 then
                attr.criCoeffRate = temp_attr.attr_value
            end
        elseif temp_attr.attr_type == 9 then
            if temp_attr.attr_value_type == 1 then
                attr.criDedCoeff = attr.criDedCoeff + self:SingleEquAttr("criDedCoeffEqu", "criDedCoeff", "growCriCoeff", temp_attr.attr_value, temp_attr.attr_increment, level)
            elseif temp_attr.attr_value_type == 2 then
                attr.criDedCoeffRate = temp_attr.attr_value
            end
        elseif temp_attr.attr_type == 10 then
            if temp_attr.attr_value_type == 1 then
                attr.block = attr.block + self:SingleEquAttr("blockEqu", "block", "growBlock", temp_attr.attr_value, temp_attr.attr_increment, level)
            elseif temp_attr.attr_value_type == 2 then
                attr.blockRate = temp_attr.attr_value
            end
        elseif temp_attr.attr_type == 11 then
            if temp_attr.attr_value_type == 1 then
                attr.ductility = attr.ductility + self:SingleEquAttr("ductilityEqu", "ductility", "growDuctility", temp_attr.attr_value, temp_attr.attr_increment, level)
            elseif temp_attr.attr_value_type == 2 then
                attr.ductilityRate = temp_attr.attr_value
            end
        end
    end
end

function Calculation:EquMainAttr(equ)
    local attr = InitAttr()
    local attrNameToNos = AttrNameToNos()
    self:EquAttrUtil(attr, equ.main_attr, equ.strengthen_lv)
    local equ_attr_info = self.c_EquipmentTemplate:getMainAttribute(equ.no)

    for k,v in pairs(attr) do
        if v > 0 then 
            local ends = ""
            if stringEndsWith(k, "Rate") then
                ends = "%"
            end
            return {["Key"] = k, ["Value"] = roundAttriNum(v)..ends, ["AttrName"] = self.c_EquipmentTemplate:getAttrName(k), ["Scope"]=self:EquAttrScope(k, equ_attr_info.mainAttr, attrNameToNos)}
        end
    end
    return {}
end


function Calculation:EquMinorAttr(equ)
    local attr = InitAttr()
    local noToAttrNames = InitTemp()
    local attrNameToNos = AttrNameToNos()
    local minor_attr = {}
    local equ_attr_info = self.c_EquipmentTemplate:getMainAttribute(equ.no)
    self:EquAttrUtil(attr, equ.minor_attr, equ.strengthen_lv)

    for i=1,11 do
        local k = noToAttrNames[i]
        local v = attr[k]
        if v > 0 then 
            local ends = ""
            if stringEndsWith(k, "Rate") then
                ends = "%"
            end
            table.insert(minor_attr, {["Key"] = k, ["Value"] = roundAttriNum(v)..ends, ["AttrName"] = self.c_EquipmentTemplate:getAttrName(k), ["Scope"]=self:EquAttrScope(k, equ_attr_info.minorAttr, attrNameToNos)})
        end
    end
    return minor_attr
end

function Calculation:EquAttrScope(attr_name, equ_info_attrs, attrNameToNos)
    local no = attrNameToNos[attr_name]
    if equ_info_attrs[tostring(no)] == nil  then
        return ""
    end
    local min = equ_info_attrs[tostring(no)][3]
    local max = equ_info_attrs[tostring(no)][4]
    return " ("..min.."-"..max..")"
end

-- 套装
function Calculation:SetEquSkillIds(line_up_slot)
    local skill_ids = {}
    local set_equipment_config = getTemplateManager():getSquipmentTemplate()
    local set_equ = {}

    for _, slot in pairs(line_up_slot.equs) do
        local equ_no = slot.equ.no
        if equ_no ~= 0 then
            local equ_info = self.c_EquipmentTemplate:getTemplateById(equ_no)
            local suit_no = equ_info.suitNo
            if suit_no ~= 0 then
                if set_equ[suit_no] == nil then
                    set_equ[suit_no] = 0
                end
                set_equ[suit_no] = set_equ[suit_no] + 1
            end
        end
    end
    for suit_no, equ_num in pairs(set_equ) do
        local set_equipment_info = set_equipment_config:getTemplateById(suit_no)
        for i=1,7 do
            attr_info = set_equipment_info["attr"..i]
            if attr_info ~= nil and attr_info[1] == equ_num then 
                table.insert(skill_ids, attr_info[2])
            end
        end
    end
    return skill_ids
end
function Calculation:SetEquAttr(hero, hero_info, skill_ids)
    return self:SkillAttr(hero, hero_info, skill_ids)
end

-- 羁绊
function Calculation:LinkSkillIds(line_up_slot)
    local skill_ids = {}
    local link_info = self.c_SoldierTemplate:getLinkTempLateById(line_up_slot.hero.hero_no)
    local hero_nos = self.c_LineupData:getHeroNos()
    local equ_nos = self.c_LineupData:getEquipNos(line_up_slot)
    for i=1,5 do
        skill_id = link_info["link"..i]
        trigger_list = link_info["trigger"..i]
        
        active = true 

        for _, no in pairs(trigger_list) do
            if string.len(no) == 5 then
                if not table.inv(hero_nos, no) then
                    active = false
                end
            end
            if string.len(no) == 6 then
                if not table.inv(equ_nos, no) then
                    active = false
                end
            end
        end
        if active == true and skill_id ~= 0 then
            table.insert(skill_ids, skill_id)
        end
    end
    return skill_ids
end
function Calculation:LinkAttr(hero, hero_info, skill_ids)
    return self:SkillAttr(hero, hero_info, skill_ids)
end

-- 游历
function Calculation:TravelAttr()
    local attr = InitAttr()
    local current_group_to_items = self.c_LineupData:getGroupToItems()
    self:TravelAttrUtil(attr, current_group_to_items)
    return attr
end
-- 根据关卡id获取游历属性
function Calculation:TravelAttrByStageID(stage_id)
    local attr = InitAttr()
    local current_group_to_items = self.c_LineupData:getGroupToItemsByStageID(stage_id)
    self:TravelAttrUtil(attr, current_group_to_items)
    return attr
end

function Calculation:TravelAttrUtil(attr, current_group_to_items)
    local travel_group_to_items = self.c_TravelTemplate:getGroupToItems()
    for group_no, group in pairs(current_group_to_items) do
        if table.nums(group) == table.nums(travel_group_to_items[group_no]) then
            local group_info = self.c_TravelTemplate:getTravelGroupsByNo(group_no)
            attr["hp"] = attr["hp"] + group_info["hp"]
            attr["atk"] = attr["atk"] + group_info["atk"]
            attr["physicalDef"] = attr["physicalDef"] + group_info["physicalDef"]
            attr["magicDef"] = attr["magicDef"] + group_info["magicDef"]
        end
    end
end

-- 助威
function Calculation:CheerAttr()
    local attr = InitAttr()
    local hpHero1 = 0
    local hpHero2 = 0
    local hpHero3 = 0
    local hpHero4 = 0
    local hpHero5 = 0
    local hpHero6 = 0

    local atkHero1 = 0
    local atkHero2 = 0
    local atkHero3 = 0
    local atkHero4 = 0
    local atkHero5 = 0
    local atkHero6 = 0

    local physicalDefHero1 = 0
    local physicalDefHero2 = 0
    local physicalDefHero3 = 0
    local physicalDefHero4 = 0
    local physicalDefHero5 = 0
    local physicalDefHero6 = 0

    local magicDefHero1 = 0
    local magicDefHero2 = 0
    local magicDefHero3 = 0
    local magicDefHero4 = 0
    local magicDefHero5 = 0
    local magicDefHero6 = 0

    
    local sub_slots = self.c_LineupData:getAllCheerLineUpSlotHasHeros()
    local person_num = table.nums(self.c_LineupData:getAllLineUpSlotHasHeros())
    for _, slot in pairs(sub_slots) do
        local hero = slot.hero
        self_attr = self:SoldierSelfAttr(hero)
        if slot.slot_no == 1 then
            hpHero1 = self_attr.hpHero
            atkHero1 = self_attr.atkHero
            physicalDefHero1 = self_attr.physicalDefHero
            magicDefHero1 = self_attr.magicDefHero
        end
        if slot.slot_no == 2 then
            hpHero2 = self_attr.hpHero
            atkHero2 = self_attr.atkHero
            physicalDefHero2 = self_attr.physicalDefHero
            magicDefHero2 = self_attr.magicDefHero
        end
        if slot.slot_no == 3 then
            hpHero3 = self_attr.hpHero
            atkHero3 = self_attr.atkHero
            physicalDefHero3 = self_attr.physicalDefHero
            magicDefHero3 = self_attr.magicDefHero
        end
        if slot.slot_no == 4 then
            hpHero4 = self_attr.hpHero
            atkHero4 = self_attr.atkHero
            physicalDefHero4 = self_attr.physicalDefHero
            magicDefHero4 = self_attr.magicDefHero
        end
        if slot.slot_no == 5 then
            hpHero5 = self_attr.hpHero
            atkHero5 = self_attr.atkHero
            physicalDefHero5 = self_attr.physicalDefHero
            magicDefHero5 = self_attr.magicDefHero
        end
        if slot.slot_no == 6 then
            hpHero6 = self_attr.hpHero
            atkHero6 = self_attr.atkHero
            physicalDefHero6 = self_attr.physicalDefHero
            magicDefHero6 = self_attr.magicDefHero
        end
    end
    attr["hp"] = self.formulas["hpCheer"](hpHero1, hpHero2, hpHero3, hpHero4, hpHero5, hpHero6, person_num)

    attr["atk"] = self.formulas["atkCheer"](atkHero1, atkHero2, atkHero3, atkHero4, atkHero5, atkHero6, person_num)

    attr["physicalDef"] = self.formulas["physicalDefCheer"](physicalDefHero1, physicalDefHero2, physicalDefHero3, physicalDefHero4, physicalDefHero5, physicalDefHero6, person_num)
    
    attr["magicDef"] = self.formulas["magicDefCheer"](magicDefHero1, magicDefHero2, magicDefHero3, magicDefHero4, magicDefHero5, magicDefHero6, person_num)
    return attr
end

-- 公会
function Calculation:LegionAttr(level)
    local attr = InitAttr()
    local guild_info = getTemplateManager():getLegionTemplate():getGuildTemplateByLevel(level)
    if guild_info == nil then return attr end
    attr["hp"] = guild_info.profit_hp 
    attr["atk"] = guild_info.profit_atk 
    attr["physicalDef"] = guild_info.profit_pdef 
    attr["magicDef"] = guild_info.profit_mdef
    return attr
end

-- 武将阵容属性计算
function Calculation:SoldierLineUpAttr(line_up_slot_no)
    local attr = InitLineUpAttr()
    
    local line_up_slot = self.c_LineupData:getSelectSoldierBySlotNo(line_up_slot_no)
    if line_up_slot == nil then
        return attr
    end
    local hero = line_up_slot.hero
    if hero == nil then
        return attr
    end
    -- print("--------hero------")
    -- table.print(hero)
    local hero_info = self.c_SoldierTemplate:getHeroTempLateById(line_up_slot.hero.hero_no)
    if hero_info == nil then
        return attr
    end
    attr["job"] = hero_info.job

    local self_attr = self:SoldierSelfAttr(hero)
    print("------self_attr------")
    -- table.print(self_attr)
    -- table.print(line_up_slot)
    local equ_attr = self:EquAttr(line_up_slot, self_attr)
    local set_equ_attr = self:SetEquAttr(hero, hero_info, self:SetEquSkillIds(line_up_slot))
    local link_attr = self:LinkAttr(hero, hero_info, self:LinkSkillIds(line_up_slot))
    local travel_attr = self:TravelAttr()
    local cheer_attr = self:CheerAttr()
    local legion_attr = self:LegionAttr(self.c_LineupData:getLegionLevel())
    --appendFile(hero.hero_no, "自身", self_attr)
    --appendFile(hero.hero_no, "装备", equ_attr)
    --appendFile(hero.hero_no, "套装", self:SetEquSkillIds(line_up_slot))
    --appendFile(hero.hero_no, "套装", set_equ_attr)
    --appendFile(hero.hero_no, "羁绊", self:LinkSkillIds(line_up_slot))
    --appendFile(hero.hero_no, "羁绊", link_attr)
    --appendFile(hero.hero_no, "游历", travel_attr)
    --appendFile(hero.hero_no, "助威", cheer_attr)
    --appendFile(hero.hero_no, "公会", legion_attr)

    attr["hpArray"] = self.formulas["hpArray"](self_attr.hpHero, equ_attr.hp, set_equ_attr.hp, link_attr.hp, travel_attr.hp, cheer_attr.hp, legion_attr.hp)

    attr["atkArray"] = self.formulas["atkArray"](self_attr.atkHero, equ_attr.atk, set_equ_attr.atk, link_attr.atk, travel_attr.atk, cheer_attr.atk, legion_attr.atk)

    attr["physicalDefArray"] = self.formulas["physicalDefArray"](self_attr.physicalDefHero, equ_attr.physicalDef, set_equ_attr.physicalDef, link_attr.physicalDef, travel_attr.physicalDef, cheer_attr.physicalDef, legion_attr.physicalDef)

    attr["magicDefArray"] = self.formulas["magicDefArray"](self_attr.magicDefHero, equ_attr.magicDef, set_equ_attr.magicDef, link_attr.magicDef, travel_attr.magicDef, cheer_attr.magicDef, legion_attr.magicDef)

    attr["hitArray"] = self.formulas["hitArray"](self_attr.hitHero, equ_attr.hit, set_equ_attr.hit, link_attr.hit, travel_attr.hit, cheer_attr.hit, legion_attr.hit)

    attr["dodgeArray"] = self.formulas["dodgeArray"](self_attr.dodgeHero, equ_attr.dodge, set_equ_attr.dodge, link_attr.dodge, travel_attr.dodge, cheer_attr.dodge, legion_attr.dodge)

    attr["criArray"] = self.formulas["criArray"](self_attr.criHero, equ_attr.cri, set_equ_attr.cri, link_attr.cri, travel_attr.cri, cheer_attr.cri, legion_attr.cri)

    attr["criCoeffArray"] = self.formulas["criCoeffArray"](self_attr.criCoeffHero, equ_attr.criCoeff, set_equ_attr.criCoeff, link_attr.criCoeff, travel_attr.criCoeff, cheer_attr.criCoeff, legion_attr.criCoeff)

    attr["criDedCoeffArray"] = self.formulas["criDedCoeffArray"](self_attr.criDedCoeffHero, equ_attr.criDedCoeff, set_equ_attr.criDedCoeff, link_attr.criDedCoeff, travel_attr.criDedCoeff, cheer_attr.criDedCoeff, legion_attr.criDedCoeff)

    attr["blockArray"] = self.formulas["blockArray"](self_attr.blockHero, equ_attr.block, set_equ_attr.block, link_attr.block, travel_attr.block, cheer_attr.block, legion_attr.block)

    attr["ductilityArray"] = self.formulas["ductilityArray"](self_attr.ductilityHero, equ_attr.ductility, set_equ_attr.ductility, link_attr.ductility, travel_attr.ductility, cheer_attr.ductility, legion_attr.ductility)
    --appendFile(hero.hero_no, "阵容", attr)
    return attr
end

-- 武将自身战力计算
function Calculation:CombatPowerSoldierSelf(hero)
    local self_attr = self:SoldierSelfAttr(hero)
    local result = self.formulas["fightValueHero"](self_attr)
    return result
end


-- 武将阵容战力计算
function Calculation:CombatPowerSoldierLineUp(line_up_slot_no)
    --createFile()
    local lineup_attr = self:SoldierLineUpAttr(line_up_slot_no)
    local result = self.formulas["fightValueArray"](lineup_attr)
    return result
end

-- 所有武将阵容战力
function Calculation:CombatPowerAllSoldierLineUp()
    local total = 0
    local line_up_slots = self.c_LineupData:getAllLineUpSlotHasHeros()
    for _, slot in pairs(line_up_slots) do
        total = total + self:CombatPowerSoldierLineUp(slot.slot_no)
    end
    return total
end

-- 怪物战斗力
function Calculation:CombatPowerMonster(monster_info)
    local result = self.formulas["fightValue"](monster_info)
    return result
end

function Calculation:SkillAttr(hero, hero_info, skill_ids)
    local attr = InitAttr()
    local formulas = {["hpB_1"] = "hp",
                ["hpB_2"] = "hp",
                ["atkB_1"] = "atk",
                ["atkB_2"] = "atk",
                ["pDefB_1"] = "physicalDef",
                ["pDefB_2"] = "physicalDef",
                ["mDefB_1"] = "magicDef",
                ["mDefB_2"] = "magicDef",
                ["hitB"] = "hit",
                ["dodgeB"] = "dodge",
                ["criB"] = "cri",
                ["criCoeffB"] = "criCoeff",
                ["criDedCoeffB"] = "criDedCoeff",
                ["blockB"] = "block",
                ["ductilityB"] = "ductility",
            }
    for _, skill_id in pairs(skill_ids) do
        local skill_buff_ids = self.c_SoldierTemplate:getSkillTempLateById(skill_id).group
        for _, skill_buff_id in pairs(skill_buff_ids) do
            local skill_buff = self.c_SoldierTemplate:getSkillBuffTempLateById(skill_buff_id)

            for key, res in pairs(formulas) do
                local result = self.formulas[key](skill_buff, hero.level, hero_info)
                attr[res] = attr[res] + result
            end
        end
    end
    return attr
end 

function InitAttr()
    return {
        ["hp"] = 0,
        ["atk"] = 0,
        ["physicalDef"] = 0,
        ["magicDef"] = 0,
        ["hit"] = 0,
        ["dodge"] = 0,
        ["cri"] = 0,
        ["criCoeff"] = 0,
        ["criDedCoeff"] = 0,
        ["block"] = 0,
        ["ductility"] = 0,
        ["hpRate"] = 0,
        ["atkRate"] = 0,
        ["physicalDefRate"] = 0,
        ["magicDefRate"] = 0,
        ["hitRate"] = 0,
        ["dodgeRate"] = 0,
        ["criRate"] = 0,
        ["criCoeffRate"] = 0,
        ["criDedCoeffRate"] = 0,
        ["blockRate"] = 0,
        ["ductilityRate"] = 0
    }

end

function InitLineUpAttr(...)
    return {
        ["hpArray"] = 0,
        ["atkArray"] = 0,
        ["physicalDefArray"] = 0,
        ["magicDefArray"] = 0,
        ["hitArray"] = 0,
        ["dodgeArray"] = 0,
        ["criArray"] = 0,
        ["criCoeffArray"] = 0,
        ["criDedCoeffArray"] = 0,
        ["blockArray"] = 0,
        ["ductilityArray"] = 0,
    }
end

function InitHeroAttr()
    return {
        ["hpHero"] = 0,
        ["atkHero"] = 0,
        ["physicalDefHero"] = 0,
        ["magicDefHero"] = 0,
        ["hitHero"] = 0,
        ["dodgeHero"] = 0,
        ["criHero"] = 0,
        ["criCoeffHero"] = 0,
        ["criDedCoeffHero"] = 0,
        ["blockHero"] = 0,
        ["ductilityHero"] = 0,
    }

end

function InitTemp()
    return {
        [1] = "hp",
        [2] = "atk",
        [3] = "physicalDef",
        [4] = "magicDef",
        [5] = "hit",
        [6] = "dodge",
        [7] = "cri",
        [8] = "criCoeff",
        [9] = "criDedCoeff",
        [10] = "block",
        [11] = "ductility"
    }
end

function AttrNameToNos()
    return {
        ["hp"] = 1,
        ["atk"] = 2,
        ["physicalDef"] = 3,
        ["magicDef"] = 4,
        ["hit"] = 5,
        ["dodge"] = 6,
        ["cri"] = 7,
        ["criCoeff"] = 8,
        ["criDedCoeff"] = 9,
        ["block"] = 10,
        ["ductility"] = 11
    }
end

function Calculation:setLineUpData(data)
    local lineUpData = clone(self.c_LineupData)
    lineUpData:setSelectSoldierData(data.slot)
    lineUpData:setCheerData(data.sub)
    lineUpData:setWSListData(data.unpars)
    lineUpData:setEmbattleOrder(data.order)
    lineUpData:setEmbattleUnpar(data.unpar_id)
    lineUpData:setTravelItemChapter(data.travel_item_chapter)
    lineUpData:setLegionLevel(data.guild_level)
    self.c_LineupData = lineUpData
end

function Calculation:resetLineUpData()
    self.c_LineupData = getDataManager():getLineupData()
end
return Calculation

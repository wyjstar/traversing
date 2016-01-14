local FormulaTemplate = class("FormulaTemplate")

import("..config.formula_config")

formulaArgs={
    ["isTrigger"] = {false, "(triggerRate, random)"},
    ["isHit"] = {false, "(hitArray1, dodgeArray2, random)"},
    ["isCri"] = {false, "(criArray1, ductilityArray2, random)"},
    ["isBlock"] = {false, "(blockArray, random)"},
    ["baseDamage"] = {false, "(atkHeroLine, def2, heroLevel)"},
    ["criDamage"] = {false, "(criCoeffArray1, criDedCoeffArray2)"},
    ["levelDamage"] = {false, "(heroLevel)"},
    ["floatDamage"] = {false, "(k1, k2, random)"},
    ["allDamage"] = {false, "(baseDamage, isHit, criDamage, isCri, isBlock, levelDamage, floatDamage)"},
    ["allHeal"] = {false, "(atkHeroLine, criCoeffArray, isCri)"}, 

    ["damage_1"] = {"(skill_buff)", "(allDamage, skill_buff, heroLevel)"}, 
    ["damage_2"] = {"(skill_buff)", "(allDamage, skill_buff, heroLevel)"}, 
    ["damage_3"] = {"(skill_buff)", "(skill_buff, heroLevel)"}, 
    ["damage_4"] = {"(skill_buff)", "(atkHeroLine, skill_buff, heroLevel)"}, 

    ["warriorsDamage"] = {false, "(warriors_atkArray, enemy_physicalDefArray, enemy_magicDefArray)"}, 
    ["warriorsLastDamage"] = {false, "(warriorsBaseDamage, skill_buff, playerLevel)"}, 
    ["monster_warriors_atkArray"] = {false, "(atk)"},
    ["heal_1"] = {"(skill_buff)", "(allHeal, skill_buff, heroLevel)"}, 
    ["heal_2"] = {"(skill_buff)", "(allHeal, skill_buff, heroLevel)"}, 
    ["skillbuffEffct_1"] = {"(skill_buff)", "(skill_buff, heroLevel)"},
    ["skillbuffEffct_2"] = {"(skill_buff)", "(skill_buff, attrHero)"},
    ["hjqyDamage"] = {false, "(heroBreak)"},
    ["peerlessDamage"] = {false, "(wslevel, skill_buff, job)"},
    ["peerlessAdd"] = {false, "(wslevel)"},
}

function FormulaTemplate:ctor(controller)
    self.formulas = {}
    self:preLoad()	
end

function FormulaTemplate:getFormulaByID(id)
    
    return formula_config[id]
end

function FormulaTemplate:preLoad()
    -- 预加载
    for k,v in pairs(formulaArgs) do
        print("=========", k)
        local formula = self:getFormulaByKey(k)
        -- 1. precondition
        if v[1] then
            local before = "function func"..v[1].." return "
            local after = " end"
            print("--------")
            print(before..formula["clientPrecondition"]..after)
            assert(loadstring(before..formula["clientPrecondition"]..after))()
            self.formulas[k.."Precondition"] = func
        end
        local before = "function func"..v[2]
        local after = " return result end"
        assert(loadstring(before..formula["clientFormula"]..after))()
        self.formulas[k] = func
    end
end

function FormulaTemplate:getFormulaByKey(key)
    for _, temp in pairs(formula_config) do
        if temp.key == key then
            return temp
        end
    end
    cclog("ERROR: can not find res by ==" .. key)
    return nil
end

function FormulaTemplate:getFunc(key)
    local func = self.formulas[key]
    if not func then
        cclog("can not find key = " .. key)
    end
    return func
end

function FormulaTemplate:randomName()
    local index = math.random(1,8)
    print(rand_name_config[math.random(1,496)].prefix_1 .. rand_name_config[math.random(1,96)].name_4 .. rand_name_config[math.random(1,96)].name_4)
    print("FormulaTemplate:randomName==>",index)
    if self.formulas["rand_name_"..index] == nil then
        local before = "function func() "
        local after = " return result end"
        print("--------")
        local formula = self:getFormulaByKey("rand_name_"..index).clientFormula
        print(before.. formula ..after)
        assert(loadstring(before..formula..after))()
        self.formulas["rand_name_" .. index] = func
    end

    return self.formulas["rand_name_" .. index]()

end

return FormulaTemplate

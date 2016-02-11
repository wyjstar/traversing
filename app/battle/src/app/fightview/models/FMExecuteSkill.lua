import(".FightUtil")

formulaTemplate = nil
process = nil

function getFormulaTemplate()
    if formulaTemplate == nil then
        formulaTemplate = getTemplateManager():getFormulaTemplate()
    end
    return formulaTemplate
end

function set_process(_process)
    process = _process
end


function check_trigger(buff_info)
    --if buff_info.id == 30024421 or buff_info.id == 301024711 or buff_info.id == 30054721 then
        --return true
    --end
    local random = get_random_int(1, 99)
    local triggerRate = buff_info.triggerRate
    isTrigger = getFormulaTemplate():getFunc("isTrigger")(triggerRate, random)
    if isTrigger == 0 then
        return false
    end
    return true
end

function check_hit(buff_info, attacker, target)
    if not table.inv({1, 2}, buff_info.effectId) then
        return true
    end
    local random = get_random_int(1, 99)
    local hitArray1 = attacker:get_hit()
    local dodgeArray2 = target:get_dodge()
    isHit = getFormulaTemplate():getFunc("isHit")(hitArray1, dodgeArray2, random)
     if isHit == 0 then
        isHit = false
    else
        isHit = true
    end
    appendFile2("判断命中：随机数:("..tostring(random)..
                ") 攻方命中率:("..tostring(hitArray1)..
                ") 受方闪避率:("..tostring(dodgeArray2)..
                ") 是否命中:"..tostring(isHit)..") \n", 0)
    return isHit
end

function check_block(attacker, target, buff_info)
    if not table.inv({1, 2}, buff_info.effectId) then
        return false
    end
    local random = get_random_int(1, 99)
    local blockArray = target:get_block()
    isBlock = getFormulaTemplate():getFunc("isBlock")(blockArray, random)
    if isBlock == 0 then
        return false
        --return true
    end
    return true
end

function check_cri(cri, ductility)
    local random = get_random_int(1, 99)
    local criArray1 = cri
    local ductilityArray2 = ductility
    isCri = getFormulaTemplate():getFunc("isCri")(criArray1, ductilityArray2, random)
    if isCri == 0 then
        return false
    end
    return true
end

function execute_demage(attacker, target, buff_info, is_block, is_cri, extra_msgs)
    -- 执行技能［1，2］
    local baseTemplate = getTemplateManager():getBaseTemplate()

    local k1 = attacker:get_atk() -- 攻方总实际攻击力
    local k2 = 0            -- 守方总物理或者魔法防御
    if buff_info.effectId == 1 then
        k2 = target:get_physical_def()
    elseif buff_info.effectId == 2 then
        k2 = target:get_magic_def()
    end

    print(buff_info.effectId, target:get_physical_def(), target:get_magic_def(), "==================execute_demage")

    -- 1. base_demage
    local base_demage_value = getFormulaTemplate():getFunc("baseDamage")(k1, k2, attacker.level)
    -- 2. cri_coeff
    local cri_coeff = getFormulaTemplate():getFunc("criDamage")(attacker:get_cri_coeff(), target:get_cri_ded_coeff())
    -- 3. levelDemage
    local level_coeff = getFormulaTemplate():getFunc("levelDamage")(attacker.level)
    -- 4. floatDemage
    local random = get_random_int(1, 99)
    local temp = baseTemplate:getBaseInfoById("a6")                           -- 伤害浮动调整参数
    local k1, k2 = temp[1], temp[2]                              --
    local float_coeff = getFormulaTemplate():getFunc("floatDamage")(k1, k2, random)
    -- 5. allDemage
    local is_hit = true
    local total_demage = getFormulaTemplate():getFunc("allDamage")(base_demage_value, is_hit, cri_coeff, is_cri, is_block, level_coeff, float_coeff)

    --["damage_1"] = {"(skill_buff)", "(allDamage, skill_buff, heroLevel)"}, 
    --["damage_2"] = {"(skill_buff)", "(allDamage, skill_buff, heroLevel)"}, 
    local actual_demage_1 = 0
    local actual_demage_2 = 0
    if getFormulaTemplate():getFunc("damage_1Precondition")(buff_info) then
        actual_demage_1 = getFormulaTemplate():getFunc("damage_1")(total_demage, buff_info, attacker.level)
    end
    if getFormulaTemplate():getFunc("damage_2Precondition")(buff_info) then
        actual_demage_2 = getFormulaTemplate():getFunc("damage_2")(total_demage, buff_info, attacker.level)
    end
    actual_demage = addDamageRate(attacker.side, actual_demage_1 + actual_demage_2)
    target:set_hp(target:get_hp() - actual_demage)

    local m1 = ""
    m1 = m1.."是否暴击:"..roundNumberIfNumber(is_cri)
    m1 = m1.."--是否格挡:"..roundNumberIfNumber(is_block)
    m1 = m1.."--基础伤害值:"..roundNumberIfNumber(base_demage_value).."("..roundNumberIfNumber(k1).."-"..roundNumberIfNumber(k2).."-"..roundNumberIfNumber(attacker.level)..")"
    m1 = m1.."--暴击系数:"..roundNumberIfNumber(cri_coeff).."("..roundNumberIfNumber(attacker:get_cri_coeff()).."-"..roundNumberIfNumber(attacker:get_cri_ded_coeff())..")"
    m1 = m1.."--等级系数:"..roundNumberIfNumber(level_coeff).."("..roundNumberIfNumber(attacker.level)..")"
    m1 = m1.."--浮动伤害系数:"..roundNumberIfNumber(float_coeff).."("..roundNumberIfNumber(k1).."-"..roundNumberIfNumber(k2).."-"..roundNumberIfNumber(random)..")"
    m1 = m1.."--总伤害:"..roundNumberIfNumber(total_demage)
    m1 = m1.."--实际伤害:"..roundNumberIfNumber(actual_demage)
    table.insert(extra_msgs, m1)

    return actual_demage
end

function execute_mp(target, buff_info, extra_msgs)
    --mp: 8,9
    if buff_info.effectId == 8 then
        target.skill:set_mp(target.skill:get_mp()+buff_info.valueEffect)
    elseif buff_info.effectId == 9 then
        target.skill:set_mp(target.skill:get_mp()-buff_info.valueEffect)
    end
    return buff_info.valueEffect
end

function execute_pure_demage(attacker, target, buff_info, extra_msgs)
    --纯伤害:3
    local actual_demage = 0
    
    local actual_demage_3 = 0
    local actual_demage_4 = 0
    if getFormulaTemplate():getFunc("damage_3Precondition")(buff_info) then
        actual_demage_3 = getFormulaTemplate():getFunc("damage_3")(buff_info, attacker.level)
    end
    if getFormulaTemplate():getFunc("damage_4Precondition")(buff_info) then
        actual_demage_4 = getFormulaTemplate():getFunc("damage_4")(attacker:get_atk(), buff_info, attacker.level)
    end
    actual_demage = addDamageRate(attacker.side, actual_demage_3 + actual_demage_4)
    target:set_hp(target:get_hp() - actual_demage)
    print("execute_pure_demage=========", actual_demage)
    return actual_demage
end

function execute_treat(attacker, target, buff_info, is_cri, extra_msgs)
    --治疗:26
    --["allHeal"] = {false, "(atkArray, criCoeffArray, isCri)"}, 
    --["heal_1"] = {"(skill_buff)", "(allHeal, skill_buff, heroLevel)"}, 
    --["heal_2"] = {"(skill_buff)", "(allHeal, skill_buff, heroLevel)"}, 
    local atkArray = attacker:get_atk()

    local total_heal = getFormulaTemplate():getFunc("allHeal")(attacker:get_atk(), attacker:get_cri_coeff(), is_cri)

    local actual_treat_1 = 0
    local actual_treat_2 = 0
    if getFormulaTemplate():getFunc("heal_1Precondition")(buff_info) then
        actual_treat_1 = getFormulaTemplate():getFunc("heal_1")(total_heal, buff_info, attacker.level)
    end
    if getFormulaTemplate():getFunc("heal_2Precondition")(buff_info) then
        actual_treat_2 = getFormulaTemplate():getFunc("heal_2")(total_heal, buff_info, attacker.level)
    end
    
    local actual_treat = actual_treat_1 + actual_treat_2
    target:set_hp(target:get_hp() + actual_treat)
    local m1 = ""
    m1 = m1.."是否暴击:"..roundNumberIfNumber(is_cri)
    m1 = m1.."攻击:"..roundNumberIfNumber(attacker:get_atk())
    m1 = m1.."暴击系数:"..roundNumberIfNumber(attacker:get_cri_coeff())
    m1 = m1.."--总治疗值:"..roundNumberIfNumber(total_heal)
    table.insert(extra_msgs, m1)
    return actual_treat
end

-- 无双值
function unpara(attacker, buff_info, target)
    local baseTemplate = getTemplateManager():getBaseTemplate()
    local job_value = baseTemplate:getBaseInfoById("ws_job")[tostring(attacker.unpar_job)]
    local warriorsDamage = getFormulaTemplate():getFunc("peerlessDamage")(attacker.unpar_level, buff_info, job_value)
    
    if target then
        target:set_hp(target:get_hp() - warriorsDamage)
    end
    return warriorsDamage
    --playerLevel = playerLevel or 1
    --local atkArray = process.redAtkArray
    --if attacker.side == "blue" then
        --atkArray = process.blueAtkArray
    --end
    --local atkArray = process.redAtkArray
    ----for _,v in pairs(attacker_side) do
        ----atkArray = atkArray + v.atk
    ----end
    --local warriorsDamage = getFormulaTemplate():getFunc("warriorsDamage")(atkArray, target:get_physical_def(), target:get_magic_def())
    --local warriorsLastDamage = getFormulaTemplate():getFunc("warriorsLastDamage")(warriorsDamage, buff_info, playerLevel)
    --warriorsLastDamage = addDamageRate(attacker.side, warriorsLastDamage)
    --print(warriorsLastDamage, "warriorsLastDamage==========")
    --local m1 = ""
    --m1 = m1.."总atk:"..roundNumberIfNumber(atkArray)
    --m1 = m1.."--基础伤害:"..roundNumberIfNumber(warriorsDamage)
    --m1 = m1.."--实际伤害:"..roundNumberIfNumber(warriorsLastDamage).."("..playerLevel..")"
    --table.insert(extra_msgs, m1)
end

-- 怪物无双值
function unpara_monster(atk, target, extra_msgs)
    local warriorsDamage = getFormulaTemplate():getFunc("monster_warriors_atkArray")(atk)
    print("unpara_monster", warriorsDamage, atk)
    warriorsDamage = addDamageRate("blue", warriorsDamage)
    target:set_hp(target:get_hp() - warriorsDamage)
    return warriorsDamage
end

function get_buff_value(value, buff)
    local skill_buff_1 = 0
    local skill_buff_2 = 0
    local buff_info = buff.skill_buff_info
    if buff.skill_buff_info.id == 11004622 then
        print("s_zz============", buff.continue_num)
    end

    if getFormulaTemplate():getFunc("skillbuffEffct_1Precondition")(buff_info) then
        skill_buff_1 = getFormulaTemplate():getFunc("skillbuffEffct_1")(buff_info, buff.process.attacker.level)
    end
    if getFormulaTemplate():getFunc("skillbuffEffct_2Precondition")(buff_info) then
        skill_buff_2 = getFormulaTemplate():getFunc("skillbuffEffct_2")(buff_info, value)
    end
    return skill_buff_1 + skill_buff_2
end

function addDamageRate(side, value)
    -- 添加伤害加成
    if side == "red" then
        damage_rate = process.damage_rate
        print("addDamageRate", damage_rate)
        return value * (1 + damage_rate)
    end
    return value
end
-- 数值处理小数点的数值, 返回string
function roundNumberIfNumber(value)
    print(value, "wzp======1", type(value))
    if type(value) ~= "number" then
        return tostring(value)
    end
    -- return math.round(number)        -- 四舍五入
    return tostring(math.floor(value))           -- 舍去小数点
end

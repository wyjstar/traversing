
local BattleUnit = import("..models.FMBattleUnit")
local UnParaSkill = import("..models.skills.FMUnParaSkill")
local HeroSkill = import("..models.skills.FMHeroSkill")
local MonsterSkill = import("..models.skills.FMMonsterSkill")
local BuddySkill = import("..models.skills.FMBuddySkill")
import("..models.FightUtil")


local baseTemplate = nil
local soldierTemplate = nil
local instanceTemplate = nil
local calculation = nil
local AEMY_ZORDER = 20
local ENEMY_ZORDER = 10
local process = nil
local fightData = nil
local formulaTemplate = nil

function initData(_process)
    -- 根据战斗类型初始化双方数据
    -- 战斗类型：
    -- TYPE_GUIDE 新手引导中演示关卡
    -- TYPE_STAGE_NORMAL 普通关卡
    -- TYPE_STAGE_ELITE 精英关卡
    -- TYPE_STAGE_ACTIVITY   活动关卡
    -- TYPE_TRAVEL          travel
    -- TYPE_PVP             pvp
    -- TYPE_WORLD_BOSS      世界boss
    -- TYPE_MINE_MONSTER     攻占也怪
    -- TYPE_MINE_OTHERUSER   攻占其他玩家
    baseTemplate = getTemplateManager():getBaseTemplate()
    soldierTemplate = getTemplateManager():getSoldierTemplate()
    instanceTemplate = getTemplateManager():getInstanceTemplate()
    formulaTemplate = getTemplateManager():getFormulaTemplate()
    fightData = getDataManager():getFightData() 
    calculation = getCalculationManager():getCalculation() 
    process = _process
    local data = fightData:getData() or {}
    --data["unpar_type_id"] = 8100001
    --data["unpar_other_id"] = 8100005
    set_seed(data.seed1, data.seed2)
    process.fight_type =  process.fight_type or TYPE_GUIDE
    print("process.fight_type======", process.fight_type)
    if process.fight_type==TYPE_GUIDE then
        return initGuideData()
    elseif process.fight_type==TYPE_WORLD_BOSS then
        return initWorldBossData(data)
    elseif process.fight_type==TYPE_STAGE_NORMAL 
        or process.fight_type==TYPE_STAGE_ELITE 
        or process.fight_type == TYPE_STAGE_ACTIVITY 
        or process.fight_type == TYPE_TRAVEL then
        return initStageData(data)
    elseif process.fight_type == TYPE_PVP or process.fight_type == TYPE_TREASURE then
        return initPvpData(data)
    elseif process.fight_type == TYPE_MINE_OTHERUSER
        or process.fight_type == TYPE_MINE_MONSTER then
        return initMineData(data)
    elseif process.fight_type == TYPE_HJQY_STAGE then
        return initHjqyData(data)
    elseif process.fight_type == TYPE_BEAST_BATTLE then
        return initBeastData(data)
    elseif process.fight_type == TYPE_ESCORT then
        return initGuildEscortPvpData(data)
    elseif process.fight_type == TYPE_TEST then
        return initTESTData()
    end

end

-- 新手引导中得演示关卡
--[[--
    战斗测试
]]
function initTESTData()
    -- return 我方数据，敌方数据，我方View，敌方View，我方无双，敌方无双
    -- 演示关卡中所有武将全部觉醒, 突破等级0
    -- local redUnits = {}
    local blueUnits = {}
    local redUnParaSkill = nil
    local blueUnParaSkill = nil
    --local redUnitViews = {}
    --local blueUnitViews = {}
    local demoHero = baseTemplate:getBaseInfoById("demoHero")
    local demoEnemy = baseTemplate:getBaseInfoById("demoEnemy")

    demoHero = {["5"] = {[1] = 10054,  [2] = 33,},
    ["6"] = {[1] = 10056,  [2] = 33,}}
    demoEnemy = {["5"] = {[1] = 10058,  [2] = 33,},
    ["6"] = {[1] = 10050,  [2] = 33,}}
    
    demoHero = {
        {
            ["2"] = {[1] = 10004,  [2] = 40,},
            ["1"] = {[1] = 10005,  [2] = 40,},
            ["3"] = {[1] = 10006,  [2] = 40,},
        },
        {
            ["2"] = {[1] = 10001,  [2] = 40,},
            ["1"] = {[1] = 10002,  [2] = 40,},
            ["3"] = {[1] = 10003,  [2] = 40,},
        },

        {
            ["2"] = {[1] = 10007,  [2] = 40,},
            ["1"] = {[1] = 10008,  [2] = 40,},
            ["3"] = {[1] = 10009,  [2] = 40,},
        }
    }

    demoEnemy = 
    {
        ["2"] = {[1] = 10004,  [2] = 50,},
        ["1"] = {[1] = 10005,  [2] = 50,},
        ["3"] = {[1] = 10006,  [2] = 50,},
        ["4"] = {[1] = 10007,  [2] = 30,},
        -- ["2"] = {[1] = 10002,  [2] = 60,},
        -- ["3"] = {[1] = 10003,  [2] = 60,},
        -- ["4"] = {[1] = 10004,  [2] = 60,},
        -- ["5"] = {[1] = 10005,  [2] = 60,},
        -- ["6"] = {[1] = 10006,  [2] = 60,},
    }
    --for pos, v in pairs(demoHero) do
    local chief = false
    local redGroup = {}
    for k = 1,3 do
        local redUnits = {}
        for i=1,6 do
            v = demoHero[k][tostring(i)]
            if v then
                local pos = i
                local unit_no = v[1]
                local unit_level = math.random(50,60)
                local data = soldierTemplate:getHeroTempLateById(unit_no)
                local isawake = false
                -- local break_level = 8 - i
                local break_level = 1
                print("=====================initGuideData1")
                local unit = constructBattleUnitWithTemplate(data, pos, unit_level, break_level, isawake, false)
                
                unit.hp_max = 1000
                unit.hp = 1000
                redUnits[pos] = unit
                updateRedUnitViewProperty(unit)
                --controller.addChild(UnitView.new(unit))
            end
        end
        redGroup[k] = redUnits
    end

    for pos, v in pairs(demoEnemy) do
        local pos = tonumber(pos)
        if v then
            local unit_no = v[1]
            local unit_level = math.random(50,60)
            local data = soldierTemplate:getHeroTempLateById(unit_no)
            local break_level = 0
            -- if pos == 1 then
            --     break_level = 7
            -- elseif pos == 2 then
            --     break_level = 3
            -- end
            break_level = 0
            local unit = constructBattleUnitWithTemplate(data, pos, unit_level, break_level, false, false)
            unit.hp_max = 1000
            unit.hp = 1000
            blueUnits[pos] = unit
            updateBlueUnitViewProperty(unit)
            --controller.addChild(UnitView.new(unit))
        end
    end
    local redUnParaSkill = constructUnparaSkill(0, 1, const.HOME_ARMY, "red", 7, 1, 1)
    local blueUnParaSkill = constructUnparaSkill(0, 1, const.HOME_ENEMY, "blue", 7+12, 1, 1)
    -- local buddySkill = constructBuddySkill(mockBattleUnit(0, 12, "red"))
    --print(buddySkill.unit.no, "buddySkill=================")
    --local redUnParaSkill = nil 
    --local blueUnParaSkill = nil 
    --local buddySkill = nil
    return redGroup, {blueUnits, clone(blueUnits), clone(blueUnits)}, redUnParaSkill, blueUnParaSkill, buddySkill
end

--[[--
    演示战斗
]]
function initGuideData()
    -- return 我方数据，敌方数据，我方View，敌方View，我方无双，敌方无双
    -- 演示关卡中所有武将全部觉醒, 突破等级0
    local redUnits = {}
    local blueUnits = {}
    local redUnParaSkill = nil
    local blueUnParaSkill = nil
    --local redUnitViews = {}
    --local blueUnitViews = {}
    local demoHero = baseTemplate:getBaseInfoById("demoHero")
    local demoEnemy = baseTemplate:getBaseInfoById("demoEnemy")

    -- demoHero = 
    -- {
    --     ["5"] = {[1] = 10044,  [2] = 190,[3] = 50,[4] = 175000},
    --     ["1"] = {[1] = 10045,  [2] = 195,[3] = 50,[4] = 150000},
    --     ["3"] = {[1] = 10046,  [2] = 160,[3] = 50,[4] = 200000},
    --     -- ["4"] = {[1] = 10044,  [2] = 60,},
    --     -- ["5"] = {[1] = 10045,  [2] = 60,},
    --     -- ["6"] = {[1] = 10046,  [2] = 60,},
    -- }
    -- demoEnemy = 
    -- {
    --     ["1"] = {[1] = 10049,  [2] = 200,[3] = 50,[4] = 140000},
    --     ["5"] = {[1] = 10048,  [2] = 190,[3] = 50,[4] = 50000},
    --     ["3"] = {[1] = 10061,  [2] = 160,[3] = 50,[4] = 240000},
    --     -- ["4"] = {[1] = 10055,  [2] = 60,},
    --     -- ["5"] = {[1] = 10050,  [2] = 60,},
    --     -- ["3"] = {[1] = 10002,  [2] = 60,},
    -- }

    local heroBaseInfo = {
        [1] = {
            ["hp"]=20000,
            ["atk"]=5000,
            ["physical_def"] = 0,
            ["magic_def"] =0,
            ["hit"] = 999999,
            ["dodge"] =0,
            ["ductility"]=999999,
            ["block"] = 0,
            ["mp"]=100,
            ["level"]=1
        },
        [3] ={
            ["hp"]=12000,
            ["atk"]=5000,
            ["physical_def"] = 0,
            ["magic_def"] =0,
            ["hit"] = 999999,
            ["dodge"] =0,
            ["ductility"]=999999,
            ["block"] = 0,
            ["mp"]=100,
            ["level"]=1
        },
        [5] ={
            ["hp"]=12000,
            ["atk"]=8000,
            ["physical_def"] = 0,
            ["magic_def"] =0,
            ["hit"] = 999999,
            ["dodge"] =0,
            ["ductility"]=999999,
            ["block"] = 0,
            ["mp"]=100,
            ["level"]=1
        }
    }


    local monseterBaseInfo = {
        [1] ={
            ["hp"]=18500,
            ["atk"]=5000,
            ["physical_def"] = 0,
            ["magic_def"] =0,
            ["hit"] = 999999,
            ["dodge"] =0,
            ["ductility"]=999999,
            ["block"] = 0,
            ["mp"]=100,
            ["level"]=1
        },
        [3] ={
            ["hp"]=18500,
            ["atk"]=5000,
            ["physical_def"] = 0,
            ["magic_def"] =0,
            ["hit"] = 999999,
            ["dodge"] =0,
            ["ductility"]=999999,
            ["block"] = 0,
            ["mp"]=100,
            ["level"]=1
        },
        [5] ={
            ["hp"]=10000,
            ["atk"]=5000,
            ["physical_def"] = 0,
            ["magic_def"] =0,
            ["hit"] = 999999,
            ["dodge"] =0,
            ["ductility"]=999999,
            ["block"] = 0,
            ["mp"]=100,
            ["level"]=1
        }
    }

    for i=1,6 do
        v = demoHero[tostring(i)]
        if v then
            local pos = i
            local baseInfo = heroBaseInfo[pos]

            local unit_no = v[1]
            local unit_level = baseInfo.level
            local data = soldierTemplate:getHeroTempLateById(unit_no)
            local isawake = true
            local break_level = 0
            local unit = constructBattleUnitWithTemplate(data, pos, unit_level, break_level, isawake, false)
            unit.skill.mp = baseInfo.mp

            for k,v in pairs(unit.skill.attack_normal_skill_buffs) do
                if v.effectId == 24 then
                    v.triggerRate = 0
                end
            end

            unit._skill.mp = baseInfo.mp
            unit.atk = baseInfo.atk
            unit.cri_coeff = 0
            unit.cri_ded_coeff = 0
            unit.block = 0                 -- 格挡率
            unit.ductility = baseInfo.ductility         -- 韧性
            unit.hp = baseInfo.hp
            unit.hp_max = baseInfo.hp
            unit.hit = baseInfo.hit                     -- 命中率
            unit.dodge = baseInfo.dodge                 -- 闪避率
            unit.physical_def = baseInfo.physical_def
            unit.magic_def = baseInfo.magic_def

            -- print(unit_no," info:")
            -- table.print(unit)

            redUnits[pos] = unit
            updateRedUnitViewProperty(unit)
        end
    end

    for pos, v in pairs(demoEnemy) do
        local pos = tonumber(pos)
        if v then
            local baseInfo = monseterBaseInfo[pos]
            local unit_no = v[1]
            local unit_level = baseInfo.level
            local data = soldierTemplate:getHeroTempLateById(unit_no)
            local break_level = 0
            local isawake = true
            local unit = constructBattleUnitWithTemplate(data, pos, unit_level, break_level, isawake, false)
            for k,v in pairs(unit.skill.attack_normal_skill_buffs) do
                if v.effectId == 24 then
                    v.triggerRate = 0
                end
            end
            blueUnits[pos] = unit
            unit.skill.mp = baseInfo.mp
            unit._skill.mp = baseInfo.mp
            unit.cri_coeff = 0
            unit.cri_ded_coeff = 0
            unit.atk = baseInfo.atk
            unit.ductility = baseInfo.ductility         -- 韧性
            unit.hp = baseInfo.hp
            unit.hp_max = baseInfo.hp
            unit.hit = baseInfo.hit                     -- 命中率
            unit.dodge = baseInfo.dodge                 -- 闪避率
            unit.physical_def = baseInfo.physical_def
            unit.magic_def = baseInfo.magic_def

            print(unit_no," info:")
            -- table.print(unit)

            updateBlueUnitViewProperty(unit)
        end
    end
    
    local unpar_type_id = 8100004 --demoUnpara[1] or 0
    local unpar_other_id = 8100009-- demoUnpara[2] or 0
    local unpar_level = 50 -- demoUnpara[3] or 0
    local unpar_job = 2--demoUnpara[4] or 0

    local redUnParaSkill = constructUnparaSkill(unpar_type_id, unpar_other_id, const.HOME_ARMY, "red", 7, unpar_level, unpar_job)
    redUnParaSkill.mp = 52
    -- local redUnParaSkill = constructUnparaSkill(10020, 1, const.HOME_ARMY, "red", 7, 1, 1)

    redUnParaSkill.mp_step = 8

    local blueUnParaSkill = constructUnparaSkill(0, 1, const.HOME_ENEMY, "blue", 7+12, 1, 1)
    -- local buddySkill = constructBuddySkill(mockBattleUnit(10001, 12, "red"))
    return {redUnits}, {blueUnits}, redUnParaSkill, blueUnParaSkill, buddySkill
end

function initMineData(data)
    local red_units = data.red
    local blue_units = data.blue
    local redUnits = {}
    local blueUnits = {}

    for i=1,6 do
        if red_units[i] then
            local unit = constructBattleUnit(red_units[i], "red")
            redUnits[unit.pos] = unit
            updateRedUnitViewProperty(unit)
        end
    end

    for i=1,6 do
        if blue_units[i] then
            local unit = constructBattleUnit(blue_units[i], "blue", true)
            blueUnits[unit.pos] = unit
            updateBlueUnitViewProperty(unit)
        end
    end
    --optional int32 red_best_skill_id = 4;       // 无双
        --optional int32 red_best_skill_level = 5; // 无双
            --optional int32 blue_best_skill_id = 6;       // 无双
                --optional int32 blue_best_skill_level = 7; // 无双

    local redUnParaSkill = constructUnparaSkill(data.unpar_type_id, data.unpar_other_id, const.HOME_ARMY, "red", 7, data.unpar_level, data.unpar_job)
    local blueUnParaSkill = constructUnparaSkill(0, 0, const.HOME_ENEMY, "blue", 7+12, 1, 1)
    --local buddySkill = constructBuddySkill(data.replace)
    --print(buddySkill.unit.no, "buddySkill=================")
    return {redUnits}, {blueUnits}, redUnParaSkill, blueUnParaSkill, buddySkill
end

-- 世界boss
function initWorldBossData()
    local data = fightData:getData()
    local red_units = data.red
    local blue_units = data.blue
    local debuff_skill_no = data.debuff_skill_no
    local damage_rate = data.damage_rate
    process.damage_rate = damage_rate
    local redUnits = {}
    local blueUnits = {}

    for i=1,6 do
        if red_units[i] then
            local unit = constructBattleUnit(red_units[i], "red")
            redUnits[unit.pos] = unit
            updateRedUnitViewProperty(unit)
        end
    end

    for i=1,6 do
        if blue_units[i] then
            local unit = constructBattleUnit(blue_units[i], "blue")
            blueUnits[unit.pos] = unit
            print("initWorldBossData ======", unit, debuff_skill_no)
            updateBossUnitViewProperty(unit)
            unit.skill:set_break_skill_ids({debuff_skill_no})
        end
    end

    local redUnParaSkill = constructUnparaSkill(data.unpar_type_id, data.unpar_other_id, const.HOME_ARMY, "red", 7, data.unpar_level, data.unpar_job)
    local blueUnParaSkill = constructUnparaSkill(0, 0, const.HOME_ENEMY, "blue", 7+12, 1, 1)
    --local buddySkill = constructBuddySkillWithTemplate(10001, 30)
    --local buddySkill = constructBattleUnit(data.replace, "blue")
    return {redUnits}, {blueUnits}, redUnParaSkill, blueUnParaSkill, buddySkill
end

function initStageData(data)
    local red_units = data.red
    local blue_group = data.blue
    local redUnits = {}
    local blueGroup = {}

    for i=1,6 do
        if red_units[i] then
            local unit = constructBattleUnit(red_units[i], "red")
            redUnits[unit.pos] = unit
            updateRedUnitViewProperty(unit)
        end
    end

    for k,blue_units in pairs(blue_group) do
        local blueUnits = {}
        print("blue_units==========="..table.nums(blue_units.group))
        for i=1,6 do
            if blue_units.group[i] then
                local unit = constructBattleUnit(blue_units.group[i], "blue", k==table.nums(blue_group))
                blueUnits[unit.pos] = unit
                updateBlueUnitViewProperty(unit)
            end
        end
        table.insert(blueGroup, blueUnits)
    end

    local redUnParaSkill = constructUnparaSkill(data.unpar_type_id, data.unpar_other_id, const.HOME_ARMY, "red", 7, data.unpar_level, data.unpar_job )
    --local redUnParaSkill = constructUnparaSkill(0, 0, const.HOME_ARMY, "red", 7 )
    local blueUnParaSkill = constructUnparaSkill(data.monster_unpar, 0, const.HOME_ENEMY, "blue", 7+12, 1, 1)
    --local buddySkill = constructBuddySkillWithTemplate(10001, 30)
    local buddySkill = constructBuddySkill(data.friend)
    --print(buddySkill.unit.no, "buddySkill=================")
    return {redUnits}, blueGroup, redUnParaSkill, blueUnParaSkill, buddySkill
end

function initPvpData(data)
    local red_units = data.red
    local blue_units = data.blue
    local redUnits = {}
    local blueUnits = {}

    for i=1,6 do
        if red_units[i] then
            local unit = constructBattleUnit(red_units[i], "red")
            redUnits[unit.pos] = unit
            updateRedUnitViewProperty(unit)
        end
    end

    for i=1,6 do
        if blue_units[i] then
            local unit = constructBattleUnit(blue_units[i], "blue")
            blueUnits[unit.pos] = unit
            updateBlueUnitViewProperty(unit)
        end
    end

    --local redUnParaSkill = constructUnparaSkill(data.red_skill, data.red_skill_level, const.HOME_ARMY, "red", 7)
    --local blueUnParaSkill = constructUnparaSkill(data.blue_skill, data.blue_skill_level, const.HOME_ENEMY, "blue", 7+12)
    local redUnParaSkill = constructUnparaSkill(0, 0, const.HOME_ARMY, "red", 7, data.unpar_level, data.unpar_job)
    local blueUnParaSkill = constructUnparaSkill(0, 0, const.HOME_ENEMY, "blue", 7+12, 1, 1)
    --local buddySkill = constructBuddySkill(data.replace)
    --print(buddySkill.unit.no, "buddySkill=================")
    return {redUnits}, {blueUnits}, redUnParaSkill, blueUnParaSkill, buddySkill
end

-- 军团押运
function initGuildEscortPvpData(data)
    local red_groups = data.red
    local blue_groups = data.blue
    local redGroup = {}
    local blueGroup = {}

    for k,red_units in pairs(red_groups) do
        local redUnits = {}
        print("red_units==========="..table.nums(red_units.group))
        for i=1,6 do
            if red_units.group[i] then
                local unit = constructBattleUnit(red_units.group[i], "red", k==table.nums(red_group))
                redUnits[unit.pos] = unit
                updateRedUnitViewProperty(unit)
            end
        end
        table.insert(redGroup, redUnits)
    end  
    for k,blue_units in pairs(blue_groups) do
        local blueUnits = {}
        print("blue_units==========="..table.nums(blue_units.group))
        for i=1,6 do
            if blue_units.group[i] then
                local unit = constructBattleUnit(blue_units.group[i], "blue", k==table.nums(blue_group))
                blueUnits[unit.pos] = unit
                updateBlueUnitViewProperty(unit)
            end
        end
        table.insert(blueGroup, blueUnits)
    end

    --local redUnParaSkill = constructUnparaSkill(data.red_skill, data.red_skill_level, const.HOME_ARMY, "red", 7)
    --local blueUnParaSkill = constructUnparaSkill(data.blue_skill, data.blue_skill_level, const.HOME_ENEMY, "blue", 7+12)
    local redUnParaSkill = constructUnparaSkill(0, 1, const.HOME_ARMY, "red", 7, data.unpar_level, data.unpar_job)
    local blueUnParaSkill = constructUnparaSkill(0, 1, const.HOME_ENEMY, "blue", 7+12, 1, 1)
    --local buddySkill = constructBuddySkill(data.replace)
    --print(buddySkill.unit.no, "buddySkill=================")
    return redGroup, blueGroup, redUnParaSkill, blueUnParaSkill, buddySkill
end

function initHjqyData(data)
    local red_units = data.red
    local blue_units = data.blue
    local attack_type = data.attack_type
    local redUnits = {}
    local blueUnits = {}
    local heroBreak = 0

    for i=1,6 do
        if red_units[i] then
            local unit = constructBattleUnit(red_units[i], "red")
            redUnits[unit.pos] = unit
            updateRedUnitViewProperty(unit)
        end
    end

    for i=1,6 do
        if blue_units[i] then
            local unit = constructBattleUnit(blue_units[i], "blue", true)
            blueUnits[unit.pos] = unit
            updateBlueUnitViewProperty(unit)
        end
    end
    -- 全力一击增加伤害
    if attack_type == 2 then
        process.damage_rate = formulaTemplate:getFunc("hjqyDamage")(heroBreak)
    else
        process.damage_rate = 0
    end
    local redUnParaSkill = constructUnparaSkill(data.unpar_type_id, data.unpar_other_id, const.HOME_ARMY, "red", 7, data.unpar_level, data.unpar_job)
    local blueUnParaSkill = constructUnparaSkill(0, 0, const.HOME_ENEMY, "blue", 7+12, 1, 1)
    --local redUnParaSkill = constructUnparaSkill(0, 1, const.HOME_ARMY, "red", 7)
    --local blueUnParaSkill = constructUnparaSkill(0, 1, const.HOME_ENEMY, "blue", 7+12)
    --local buddySkill = constructBuddySkill(data.replace)
    --print(buddySkill.unit.no, "buddySkill=================")
    return {redUnits}, {blueUnits}, redUnParaSkill, blueUnParaSkill, buddySkill
end

function initBeastData(data)
    local red_units = data.red
    local blue_units = data.blue
    local redUnits = {}
    local blueUnits = {}
    local heroBreak = 0

    for i=1,6 do
        if red_units[i] then
            local unit = constructBattleUnit(red_units[i], "red")
            redUnits[unit.pos] = unit
            updateRedUnitViewProperty(unit)
        end
    end

    for i=1,6 do
        if blue_units[i] then
            local unit = constructBattleUnit(blue_units[i], "blue", true)
            blueUnits[unit.pos] = unit
            updateBlueUnitViewProperty(unit)
        end
    end

    local redUnParaSkill = constructUnparaSkill(data.unpar_type_id, data.unpar_other_id, const.HOME_ARMY, "red", 7, data.unpar_level, data.unpar_job)
    local blueUnParaSkill = constructUnparaSkill(0, 0, const.HOME_ENEMY, "blue", 7+12, 1, 1)

    return {redUnits}, {blueUnits}, redUnParaSkill, blueUnParaSkill, buddySkill
end

-- 根据hero模板构造battle unit
function constructBattleUnitWithTemplate(data, pos, level, break_level, is_awake, is_break)
    print("data...."..data.id)
    local hero = {["refine"] = 0, ["hero_no"] = data.id, ["break_level"] = break_level, ["awake_level"] = 1,["level"] = level, ["runt_type"] = {}}
    local self_attr = calculation:SoldierSelfAttr(hero)
    local unit = BattleUnit.new()
    unit.origin_no = data.id
    unit.no = data.id
    if is_awake then
        unit.no = data.awakeHeroID
        hero.hero_no = unit.no
        self_attr = calculation:SoldierSelfAttr(hero)
        unit.is_awake = is_awake
        unit.is_break = is_break
        data = soldierTemplate:getHeroTempLateById(unit.no)
    end
    if is_break then
        print(unit.no, "unit no======")
        unit.no = 30063--data.awakeHeroID
        hero.hero_no = unit.no
        self_attr = calculation:SoldierSelfAttr(hero)
        unit.is_awake = is_awake
        unit.is_break = is_break
        data = soldierTemplate:getHeroTempLateById(unit.no)
        print(unit.no, "unit no======")
    end
    unit.hp = self_attr.hpHero
    unit.hp_max = self_attr.hpHero
    unit.atk = self_attr.atkHero
    unit.physical_def = self_attr.physicalDefHero
    unit.magic_def = self_attr.magicDefHero
    unit.hit = self_attr.hitHero                     -- 命中率
    unit.dodge = self_attr.dodgeHero                 -- 闪避率
    unit.cri = self_attr.criHero                     -- 暴击率
    unit.cri_coeff = self_attr.criCoeffHero          -- 暴击伤害系数
    unit.cri_ded_coeff = self_attr.criDedCoeffHero   -- 暴击减免系数
    unit.block = self_attr.blockHero                 -- 格挡率
    unit.ductility = self_attr.ductilityHero         -- 韧性
    unit.pos = pos                              -- 位置
    unit.level = level                          -- 等级
    unit.break_level = break_level              -- 突破等级
                                                -- unit.quality = data.quality -- 武将品质
    unit.unit_info = data                       -- 配置信息
    print(unit.no)
    print("g=============".. unit.pos)
    if not SERVER_CODE then
        local pictureName, res = soldierTemplate:getHeroImageName(unit.no)
        unit.pictureName = pictureName

        if unit.is_break or unit.is_awake then --乱入前武将图片
            local originPictureName,orires = soldierTemplate:getHeroImageName(unit.origin_no)
            unit.originPictureName = originPictureName
        end

        unit.resFrame = res
    end

    boss_mp_info = nil
--TYPE_STAGE_NORMAL   = 1          -- 普通关卡（剧情）， stage_config
--TYPE_STAGE_ELITE    = 2          -- 精英关卡， special_stage_config
--TYPE_STAGE_ACTIVITY = 3          -- 活动关卡， special_stage_config
--TYPE_TRAVEL         = 4          -- travel
--TYPE_PVP            = 6          -- pvp
--TYPE_WORLD_BOSS     = 7          -- 世界boss
--TYPE_MINE_MONSTER   = 8          -- 攻占也怪
--TYPE_MINE_OTHERUSER = 9          -- 攻占其他玩家
--TYPE_HJQY_STAGE     = 10         -- 黄巾起义

    unit.skill = HeroSkill.new(unit, boss_mp_info)
    unit._skill = HeroSkill.new(unit, boss_mp_info)

    return unit
end

-- 根据战斗返回构造battle unit
function constructBattleUnit(data, side, is_last_round)
    if not data or data.no == 0 then return nil end
    local unit = BattleUnit.new()
    unit.unit_name = ""
    unit.no = data.no
    unit.hp = data.hp
    --unit.hp_max = data.hp_max
    unit.hp_max = data.hp_max
    unit.atk = data.atk
    unit.physical_def = data.physical_def
    unit.magic_def = data.magic_def
    unit.hit = data.hit                     -- 命中率
    unit.dodge = data.dodge                 -- 闪避率
    unit.cri = data.cri                     -- 暴击率
    unit.cri_coeff = data.cri_coeff         -- 暴击伤害系数
    unit.cri_ded_coeff = data.cri_ded_coeff -- 暴击减免系数
    unit.block = data.block                 -- 格挡率
    unit.ductility = data.ductility         -- 韧性
    unit.pos = data.position                          -- 位置
    unit.level = data.level                 -- 等级
    unit.break_level = data.break_level     -- 突破等级
    unit.quality = data.quality             -- 武将品质
    unit.is_boss = data.is_boss             -- 是否为boss
    unit.is_break = data.is_break                 -- 是否为乱入
    unit.is_awake = data.is_awake                 -- 是否觉醒

    unit.origin_no = data.origin_no         -- 乱入或者觉醒武将的原始no

    unit.chief = false
    print("side:",side,"constructBattleUnit===========", data.no," origin_no:", data.origin_no,"break_level:",unit.break_level)
    local boss_mp_info = nil
    if (process.fight_type == TYPE_STAGE_NORMAL 
        or process.fight_type == TYPE_STAGE_ELITE 
        or process.fight_type == TYPE_STAGE_ACTIVITY 
        or process.fight_type == TYPE_TRAVEL
        or process.fight_type == TYPE_MINE_MONSTER
        or process.fight_type == TYPE_WORLD_BOSS
        or process.fight_type == TYPE_BEAST_BATTLE
        or process.fight_type == TYPE_HJQY_STAGE)
        and side == "blue"
        then
        print("==========?", data.no)
        local unit_info = soldierTemplate:getMonsterTempLateById(unit.no)
        print("==========?", unit_info.id)
        unit.unit_info = unit_info                       -- 配置信息
        unit.unit_type = UNIT_TYPE_MONSTER
        if not SERVER_CODE then
            local pictureName = soldierTemplate:getMonsterImageName(unit.no)
            print("BLUE:",pictureName,unit.no)
            unit.pictureName = pictureName
        end
        local bossOpeningRage = baseTemplate:getBaseInfoById("BOSSOpeningRage")
        if process.fight_type == TYPE_STAGE_NORMAL then
            boss_mp_info = bossOpeningRage[tostring(1)]
        elseif process.fight_type == TYPE_STAGE_ACTIVITY then
            boss_mp_info = bossOpeningRage[tostring(2)]
        elseif process.fight_type == TYPE_STAGE_ELITE then
            boss_mp_info = bossOpeningRage[tostring(3)]
        elseif process.fight_type == TYPE_HJQY_STAGE then
            boss_mp_info = bossOpeningRage[tostring(4)]
        elseif process.fight_type == TYPE_MINE_MONSTER then
            boss_mp_info = bossOpeningRage[tostring(5)]
        end
        if not is_last_round then
            boss_mp_info = nil
        end
        --unit.resFrame = res
    else
        print("boss_mp_info========", boss_mp_info)
        local unit_info = soldierTemplate:getHeroTempLateById(unit.no)
        print("==========?", unit_info.id)
        unit.unit_info = unit_info                       -- 配置信息
        unit.unit_type = UNIT_TYPE_HERO
        if not SERVER_CODE then
            local pictureName, res = soldierTemplate:getHeroImageName(unit.no,unit.break_level,false,true)
            if unit.is_break or unit.is_awake then --乱入前武将图片
                local originPictureName,orires = soldierTemplate:getHeroImageName(unit.origin_no,unit.break_level,false,true)
                unit.originPictureName = originPictureName
            end

            unit.pictureName = pictureName
            
            unit.resFrame = res
        end
    end


    unit.skill = HeroSkill.new(unit, boss_mp_info)        -- 武将技能
    unit._skill = HeroSkill.new(unit, boss_mp_info)
    return unit
end

-- 更新我方显示相关属性
function updateRedUnitViewProperty(unit)
    unit.HOME = clone(const.HOME_ARMY[unit.pos])
    unit.zorder = AEMY_ZORDER + 6 - unit.pos
    unit.viewPos = unit.pos
    unit.prelude = true
    unit.side = "red"
end

-- 更新敌方显示相关属性
function updateBlueUnitViewProperty(unit)
    unit.HOME = clone(const.HOME_ENEMY[unit.pos])
    unit.zorder = ENEMY_ZORDER + 6 - unit.pos
    unit.viewPos = unit.pos + 12
    unit.prelude = false
    unit.side = "blue"
end

-- 更新boss显示相关属性
function updateBossUnitViewProperty(unit)
    unit.HOME = const.BOSS_HOME
    unit.zorder = ENEMY_ZORDER + 6 - unit.pos
    unit.viewPos = unit.pos + 12
    unit.prelude = false
    unit.side = "blue"
end

-- 构造无双技能
function constructUnparaSkill(unpar_type_id, unpar_other_id, HOMES, side, viewPos, unpar_level, unpar_job)
    if unpar_type_id == 0 then
        unpar_type_id = nil
    end
    print("constructUnparaSkill=============", unpar_type_id, unpar_other_id, unpar_level, unpar_job)
    local base_info = baseTemplate:getBaseInfoById("wushang_value_config")
    local unpara_skill = UnParaSkill.new(unpar_type_id, unpar_other_id, base_info, process)

    unpara_skill.HOME = HOMES[7]
    unpara_skill.side = side
    unpara_skill.viewPos = viewPos
    unpara_skill.level = unpar_level
    unpara_skill.job = unpar_job
    return unpara_skill
end

-- 小伙伴技能
function constructBuddySkill(data)
    --local unit_no = unit_no
    --local unit_level = level
    --local data = soldierTemplate:getHeroTempLateById(unit_no)
    --local pos = 12
    --local unit = constructBattleUnitWithTemplate(data, pos, unit_level, 0, false, false)
    print("constructBuddySkill:=====")
    -- table.print(data)
    local unit = constructBattleUnit(data, "red")
    if not unit then
        return nil
    end 
    unit.pos = 12
    updateRedUnitViewProperty(unit)
    return BuddySkill.new(unit)
end

function mockBattleUnit(no, pos, side)
    local hero_type = 0
    print("mockBattleUnit============", no,  process.fight_type, side)
    if (process.fight_type == TYPE_STAGE_NORMAL 
        or process.fight_type == TYPE_STAGE_ELITE 
        or process.fight_type == TYPE_STAGE_ACTIVITY 
        or process.fight_type == TYPE_TRAVEL
        or process.fight_type == TYPE_MINE_MONSTER
        or process.fight_type == TYPE_WORLD_BOSS)
        and side == "blue"
        then
        local data = soldierTemplate:getMonsterTempLateById(no)
    else
        data = soldierTemplate:getHeroTempLateById(no)
    end
    --local data = soldierTemplate:getHeroTempLateById(no)
    --if not data then
        --data = soldierTemplate:getMonsterTempLateById(no)
        --print("mockBattleUnit============", no, data.id)
    --end
    local unit = clone(data)
    unit.no = no
    unit.hp_max = data.hp
    unit.hp = data.hp
    unit.atk = data.atk
    unit.physical_def = data.physicalDef
    unit.magic_def = data.magicDef
    unit.hit = data.hit                     -- 命中率
    unit.dodge = data.dodge                 -- 闪避率
    unit.cri = data.cri                     -- 暴击率
    unit.cri_coeff = data.criCoeff         -- 暴击伤害系数
    unit.cri_ded_coeff = data.criDedCoeff -- 暴击减免系数
    unit.block = data.block                 -- 格挡率
    unit.ductility = data.ductility         -- 韧性
    unit.position = pos                          -- 位置
    unit.level = 30                 -- 等级
    unit.break_level = 0     -- 突破等级
    unit.mp_base = 0             -- 武将基础mp
    unit.quality = data.quality             -- 武将品质
    if pos == 5 then
        unit.is_boss = true             -- 是否为boss
    end
    --unit.skill = HeroSkill.new(unit)        -- 武将技能
    unit.is_break = false                 -- 是否为乱入
    unit.is_awake = false                 -- 是否觉醒
    unit.origin_no = no        -- 乱入或者觉醒武将的原始no
    return unit
end


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
    fightData = getDataManager():getFightData() 
    calculation = getCalculationManager():getCalculation() 
    process = _process
    local data = fightData:getData()
    --process.fight_type = TYPE_GUIDE
    print("process.fight_type======", process.fight_type)
    if process.fight_type==TYPE_GUIDE then
        return initGuideData()
    elseif process.fight_type==TYPE_WORLD_BOSS then
        return initWorldBossData(data)
    elseif process.fight_type==TYPE_STAGE_NORMAL 
        or process.fight_type==TYPE_STAGE_ELITE 
        or process.fight_type == TYPE_STAGE_ACTIVITY 
        or process.fight_type == TYPE_TRAVEL
        or process.fight_type == TYPE_MINE_MONSTER then
        return initStageData(data)
    elseif process.fight_type==TYPE_MINE_OTHERUSER
        or process.fight_type == TYPE_PVP then
        return initPvpData(data)
    end
end

-- 新手引导中得演示关卡
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

    demoHero = {["5"] = {[1] = 10054,  [2] = 33,},
    ["6"] = {[1] = 10056,  [2] = 33,}}
    demoEnemy = {["5"] = {[1] = 10058,  [2] = 33,},
    ["6"] = {[1] = 10050,  [2] = 33,}}
    demoEnemy = 
    {
        ["1"] = {[1] = 10056,  [2] = 33,},
        ["2"] = {[1] = 10046,  [2] = 33,},
        ["3"] = {[1] = 10061,  [2] = 33,},
        ["4"] = {[1] = 10058,  [2] = 33,},
        ["5"] = {[1] = 10053,  [2] = 33,},
        ["6"] = {[1] = 10045,  [2] = 33,},
}
    demoHero = 
    {
        ["1"] = {[1] = 10050,  [2] = 33,},
        ["2"] = {[1] = 10056,  [2] = 33,},
        ["3"] = {[1] = 10047,  [2] = 33,},
        ["4"] = {[1] = 10028,  [2] = 33,},
        ["5"] = {[1] = 10054,  [2] = 33,},
        ["6"] = {[1] = 10025,  [2] = 33,},
}
    demoEnemy = 
    {
        --["1"] = {[1] = 10050,  [2] = 33,},
        ["2"] = {[1] = 10046,  [2] = 1,},
        --["3"] = {[1] = 30063,  [2] = 33,},
}
    demoHero = 
    {
        ["1"] = {[1] = 10050,  [2] = 1,},
        --["2"] = {[1] = 10046,  [2] = 33,},
        ["3"] = {[1] = 30063,  [2] = 1,},
}
    demoEnemy = 
    {
        ["1"] = {[1] = 10020,  [2] = 1,},
        ["2"] = {[1] = 10046,  [2] = 1,},
        --["3"] = {[1] = 10061,  [2] = 1,},
        --["4"] = {[1] = 30057,  [2] = 1,},
        --["5"] = {[1] = 30060,  [2] = 1,},
        --["6"] = {[1] = 10045,  [2] = 1,},
}
    demoHero = 
    {
        ["1"] = {[1] = 10044,  [2] = 1,},
        ["2"] = {[1] = 10062,  [2] = 1,},
        --["2"] = {[1] = 10056,  [2] = 1,},
        --["3"] = {[1] = 10047,  [2] = 1,},
        --["4"] = {[1] = 10028,  [2] = 1,},
        --["5"] = {[1] = 10054,  [2] = 1,},
        --["6"] = {[1] = 10025,  [2] = 1,},
}
    demoEnemy = 
    {
        --["1"] = {[1] = 10041,  [2] = 80,},
        ["5"] = {[1] = 10013,  [2] = 60,},
        -- ["2"] = {[1] = 10042,  [2] = 60,},
        -- ["2"] = {[1] = 10045,  [2] = 60,},
        -- ["3"] = {[1] = 10045,  [2] = 60,},
        -- ["4"] = {[1] = 10045,  [2] = 60,},
        -- ["5"] = {[1] = 10045,  [2] = 60,},
        -- ["6"] = {[1] = 10045,  [2] = 60,},
        -- ["3"] = {[1] = 10061,  [2] = 1,},
        --["4"] = {[1] = 30057,  [2] = 1,},
        --["5"] = {[1] = 30060,  [2] = 1,},
        --["6"] = {[1] = 10045,  [2] = 1,},
}
    demoHero = 
    {
        -- ["1"] = {[1] = 10047,  [2] = 60,},
        ["5"] = {[1] = 10041,  [2] = 60,},
        -- ["2"] = {[1] = 10056,  [2] = 60,},
        -- ["3"] = {[1] = 10056,  [2] = 60,},
        -- ["4"] = {[1] = 10056,  [2] = 60,},
        -- ["5"] = {[1] = 10056,  [2] = 60,},
        -- ["6"] = {[1] = 10056,  [2] = 60,},
        --["2"] = {[1] = 10045,  [2] = 30,},
        --["2"] = {[1] = 10056,  [2] = 1,},
        --["3"] = {[1] = 10047,  [2] = 1,},
        --["4"] = {[1] = 10028,  [2] = 1,},
        --["5"] = {[1] = 10054,  [2] = 1,},
        --["6"] = {[1] = 10025,  [2] = 1,},
}
    demoHero = 
    {
        ["1"] = {[1] = 10042,  [2] = 60,},
        ["2"] = {[1] = 10046,  [2] = 60,},
        -- ["3"] = {[1] = 10044,  [2] = 60,},
        -- ["4"] = {[1] = 10044,  [2] = 60,},
        -- ["5"] = {[1] = 10044,  [2] = 60,},
        -- ["6"] = {[1] = 10044,  [2] = 60,},
}
    demoEnemy = 
    {
        -- ["6"] = {[1] = 10061,  [2] = 60,},
        -- ["2"] = {[1] = 30057,  [2] = 60,},
        -- ["3"] = {[1] = 30059,  [2] = 60,},
        -- ["4"] = {[1] = 10055,  [2] = 60,},
        -- ["5"] = {[1] = 10050,  [2] = 60,},
        ["3"] = {[1] = 10002,  [2] = 60,},
}
    --for pos, v in pairs(demoHero) do
    local chief = false
    for i=1,6 do
        v = demoHero[tostring(i)]
        if v then
            local pos = i
            local unit_no = v[1]
            local unit_level = v[2]
            local data = soldierTemplate:getHeroTempLateById(unit_no)
            local isawake = false
            if i == 2 then
                isawake = false
            end
            local break_level = 0
            if i == 1 then
                break_level = 7
            elseif i == 2 then
                break_level = 7
            end
            break_level = i - 1
            local unit = constructBattleUnitWithTemplate(data, pos, unit_level, break_level, isawake, false)
            print("=====================initGuideData1")
            if not chief then
                --unit = constructBattleUnitWithTemplate(data, pos, unit_level, break_level, false, false)
                unit.chief = true
                chief = true
            end
            unit.hp_max = 100000000
            unit.hp = 100000000
            redUnits[pos] = unit
            updateRedUnitViewProperty(unit)
            --controller.addChild(UnitView.new(unit))
        end
    end

    for pos, v in pairs(demoEnemy) do
        local pos = tonumber(pos)
        if v then
            local unit_no = v[1]
            local unit_level = v[2]
            local data = soldierTemplate:getHeroTempLateById(unit_no)
            local break_level = 0
            if pos == 1 then
                break_level = 7
            elseif pos == 2 then
                break_level = 3
            end
            break_level = 0
            local unit = constructBattleUnitWithTemplate(data, pos, unit_level, break_level, false, false)
            unit.hp_max = 100000000
            unit.hp = 100000000
            blueUnits[pos] = unit
            updateBlueUnitViewProperty(unit)
            --controller.addChild(UnitView.new(unit))
        end
    end
    local redUnParaSkill = constructUnparaSkill(0, 1, const.HOME_ARMY, "red", 7)
    local blueUnParaSkill = constructUnparaSkill(0, 1, const.HOME_ENEMY, "blue", 7+12)
    --local buddySkill = constructBuddySkillWithTemplate(10001, 1)
    --print(buddySkill.unit.no, "buddySkill=================")
    --local redUnParaSkill = nil 
    --local blueUnParaSkill = nil 
    --local buddySkill = nil
    return redUnits, {blueUnits, clone(blueUnits), clone(blueUnits)}, redUnParaSkill, blueUnParaSkill, buddySkill
end


-- 世界boss
function initWorldBossData()
    local red_units = fightData:getData().red
    local blue_units = fightData:getData().blue
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
            print("initWorldBossData ======", unit)
            updateBossUnitViewProperty(unit)
        end
    end

    local redUnParaSkill = constructUnparaSkill(data.red_best_skill, data.red_best_skill_level, const.HOME_ARMY, "red", 7)
    local blueUnParaSkill = constructUnparaSkill(0, 0, const.HOME_ENEMY, "blue", 7+12)
    --local buddySkill = constructBuddySkillWithTemplate(10001, 30)
    --local buddySkill = constructBattleUnit(data.replace, "blue")
    return redUnits, {blueUnits}, redUnParaSkill, blueUnParaSkill, buddySkill
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

    local blue
    for _,blue_units in pairs(blue_group) do
        local blueUnits = {}
        print("blue_units==========="..table.nums(blue_units.group))
        for i=1,6 do
            if blue_units.group[i] then
                local unit = constructBattleUnit(blue_units.group[i], "blue")
                blueUnits[unit.pos] = unit
                updateBlueUnitViewProperty(unit)
            end
        end
        table.insert(blueGroup, blueUnits)
    end

    local redUnParaSkill = constructUnparaSkill(data.hero_unpar, data.hero_unpar_level, const.HOME_ARMY, "red", 7)
    local blueUnParaSkill = constructUnparaSkill(data.hero_unpar, data.hero_unpar_level, const.HOME_ENEMY, "blue", 7+12)
    --local buddySkill = constructBuddySkillWithTemplate(10001, 30)
    local buddySkill = constructBuddySkill(data.friend)
    --print(buddySkill.unit.no, "buddySkill=================")
    return redUnits, blueGroup, redUnParaSkill, blueUnParaSkill, buddySkill
end

function initPvpData(data)
    local red_units = data.red
    local blue_units = data.blue
    local redUnits = {}
    local blueUnits = {}

    print(red_units)
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

    local redUnParaSkill = constructUnparaSkill(data.red_skill, data.red_skill_level, const.HOME_ARMY, "red", 7)
    local blueUnParaSkill = constructUnparaSkill(data.blue_skill, data.blue_skill_level, const.HOME_ENEMY, "blue", 7+12)
    --local buddySkill = constructBuddySkill(data.replace)
    --print(buddySkill.unit.no, "buddySkill=================")
    return redUnits, {blueUnits}, redUnParaSkill, blueUnParaSkill, buddySkill
end

-- 根据hero模板构造battle unit
function constructBattleUnitWithTemplate(data, pos, level, break_level, is_awake, is_break)
    print("data...."..data.id)
    local hero = {["refine"] = 0, ["hero_no"] = data.id, ["break_level"] = break_level, ["level"] = level, ["runt_type"] = {}}
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
    local pictureName, res = soldierTemplate:getHeroImageName(unit.no)
    unit.pictureName = pictureName
    unit.resFrame = res

    unit.skill = HeroSkill.new(unit)
    unit._skill = HeroSkill.new(unit)

    return unit
end

-- 根据战斗返回构造battle unit
function constructBattleUnit(data, side)
    print("constructBattleUnit======")
    table.print(data)
    print(data.no)
    if not data or data.no == 0 then return nil end
    local unit = BattleUnit.new()
    unit.unit_name = ""
    unit.no = data.no
    unit.hp = data.hp
    unit.hp_begin = data.hp
    --unit.hp_max = data.hp_max
    unit.hp_max = data.hp
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
    unit.origin_no = data.no         -- 乱入或者觉醒武将的原始no
    unit.chief = false
    print("constructBattleUnit===========", unit.no, data.origin_no)
    if (process.fight_type == TYPE_STAGE_NORMAL 
        or process.fight_type == TYPE_STAGE_ELITE 
        or process.fight_type == TYPE_STAGE_ACTIVITY 
        or process.fight_type == TYPE_TRAVEL
        or process.fight_type == TYPE_MINE_MONSTER
        or process.fight_type == TYPE_WORLD_BOSS)
        and side == "blue"
        then
        print("==========?", data.no)
        local unit_info = soldierTemplate:getMonsterTempLateById(data.no)
        print("==========?", unit_info.id)
        unit.unit_info = unit_info                       -- 配置信息
        unit.unit_type = UNIT_TYPE_MONSTER
        --local pictureName = soldierTemplate:getMonsterImageName(unit.no)
        --unit.pictureName = pictureName
        --unit.resFrame = res
    else
        local unit_info = soldierTemplate:getHeroTempLateById(data.no)
        print("==========?", unit_info.id)
        unit.unit_info = unit_info                       -- 配置信息
        unit.unit_type = UNIT_TYPE_HERO
        --local pictureName, res = soldierTemplate:getHeroImageName(unit.no)
        --unit.pictureName = pictureName
        --unit.resFrame = res
    end
    unit.skill = HeroSkill.new(unit)        -- 武将技能
    unit._skill = HeroSkill.new(unit)
    return unit
end

-- 更新我方显示相关属性
function updateRedUnitViewProperty(unit)
    unit.HOME = const.HOME_ARMY[unit.pos]
    unit.zorder = AEMY_ZORDER + 6 - unit.pos
    unit.viewPos = unit.pos
    unit.prelude = true
    unit.side = "red"
end

-- 更新敌方显示相关属性
function updateBlueUnitViewProperty(unit)
    unit.HOME = const.HOME_ENEMY[unit.pos]
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
function constructUnparaSkill(uparaId, level, HOMES, side, viewPos)
    local uparaInfo = instanceTemplate:getWSInfoById(uparaId)
    print("constructUnparaSkill=============", uparaId)
    table.print(uparaInfo)
    --print(level)
    --print("p+++")
    local base_info = baseTemplate:getBaseInfoById("wushang_value_config")
    print("constructSkill===============", process)
    local unpara_skill = UnParaSkill.new(uparaInfo, base_info, level, process)

    unpara_skill.HOME = HOMES[7]
    unpara_skill.side = side
    unpara_skill.viewPos = viewPos
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
    print(data)
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

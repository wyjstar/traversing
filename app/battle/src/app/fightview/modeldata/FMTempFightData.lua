--战斗流程

local FMTempFightData = class("FMTempFightData")
local FMCard = import(".FMCard")
local GuideId = GuideId

function FMTempFightData:ctor(id)
    self.director = cc.Director:getInstance()
    self.fightData = getDataManager():getFightData()
    self.soldierTemplate = getTemplateManager():getSoldierTemplate()
    self.resourceData = getDataManager():getResourceData()
    self.c_BaseTemplate = getTemplateManager():getBaseTemplate()
    self.actionUtil = getActionUtil()

    self.soldierTemplate = getTemplateManager():getSoldierTemplate()
    self.unparaConfig = self.c_BaseTemplate:getBaseInfoById("wushang_value_config")
    self.boddyConfig = self.c_BaseTemplate:getBaseInfoById("huoban_value_config")
    self.max_times_fight = self.c_BaseTemplate:getBaseInfoById("max_times_fight")
    self.data = nil
    self.timeline = {} 
    self.rounds = {}
    self.roundMax = 0 
    self.currentRound = 0 
    self.totleSRound = 1
    self.armys = {}
    self.ws_armys = {}
    self.totleEnemys = {}
    self.pvpEnemys = {}
    self.bossEnemys = {}

    self.tempSkillIdTable = {}
    self.tempBreakBuffs = {}
    self.tempAniActTable = {}
    self.friendHero = nil
    self.drop_num = nil
    self.dropInfoTable = {}
    self.fightRounds = {}
    self.friend = nil
    self.seadX1 = 1
    self.seadX2 = 2

    self.unparaValue = 0
    self.monsterUnparaValue = 0

    self.boddyValue = 0

    self.isAuto = false
    self.tempDropValue = 0
    self.unparaItem = nil
    self.monsterUnparaItem = nil

    self.armysCheckTable = {}
    self.enemysCheckTable = {}
    --self.breakSkill = {30042321, 30043321, 30044321}
    --self.breakSkillB = {30044421, 30054711, 30014721, 30032321, 30054721, 30014631}
    self.replaceHero = nil
    self.mapRes = nil
    -- self:initGuideFight()
    self.red = {}
    self.blue = {}
end

--初始化 --演示战斗，刚开始的进入游戏的时候初始化假数据
function FMTempFightData:initGuideFight()
    local demoHero = self.c_BaseTemplate:getBaseInfoById("demoHero")

    self.red = {}
    for k, v in pairs(demoHero) do
        local heroId = v[1]
        local level = v[2]
        local breakLevel = 1
        if heroId ~= 0 then
            local item = self:createRedHero(tonumber(k), heroId, level, breakLevel, true)
            self.red[#self.red + 1] = item
        end
    end

    local demoEnemy = self.c_BaseTemplate:getBaseInfoById("demoEnemy")
    self.blue = {}
    for k, v in pairs(demoEnemy) do
        
        local heroId = v[1]
        local level = v[2]
        local breakLevel = 1
        if heroId ~= 0 then
            local item = self:createRedHero(tonumber(k), heroId, level, breakLevel, true)
            self.blue[#self.blue + 1] = item
        end

    end
    
    
    -- self.fightType = TYPE_GUIDE
    self.unparaId = 10020
    self.unparaLv = 1

end

--
function FMTempFightData:initNewHandHero()

    local newhandHero = self.c_BaseTemplate:getBaseInfoById("newhandHero")
    self:unpackHero()
    for k, v in pairs(newhandHero) do
        local heroId = v[1]
        local level = v[2]
        local battleUnit = self:createRedHero(tonumber(k), heroId, level, 1)

        self.red[#self.red + 1] = battleUnit
    end
end

--获得数据
function FMTempFightData:unpackHero()
    local tempTable = {}
    for k, v in pairs(self.red) do
        local battleUnit = {}

        battleUnit.no = v.no
        battleUnit.quality = v.quality
        battleUnit.hp = v.hp
        battleUnit.atk = v.atk
        battleUnit.physical_def = v.physical_def
        battleUnit.magic_def = v.magic_def
        battleUnit.hit = v.hit
        battleUnit.dodge = v.dodge
        battleUnit.cri = v.cri
        battleUnit.cri_coeff = v.cri_coeff
        battleUnit.cri_ded_coeff = v.cri_ded_coeff
        battleUnit.block = v.block
        battleUnit.ductility = v.ductility
        battleUnit.level = v.level
        battleUnit.break_level = v.break_level
        battleUnit.is_boss = v.is_boss
        battleUnit.break_skills = v.break_skills
        battleUnit.position = v.position
        battleUnit.is_break = v.is_break
        battleUnit.is_awake = v.is_awake
        battleUnit.origin_no = v.origin_no
        tempTable[#tempTable + 1] = battleUnit
    end
    self.red = tempTable
end

--创建友方
function FMTempFightData:createRedHero(position, heroId, level, breakLevel, is_awake)
    local heroItem = self.soldierTemplate:getHeroTempLateById(heroId)

    local battleUnit = {}
    if is_awake then
        battleUnit.no = heroItem.awakeHeroID
        battleUnit.is_awake = true
        battleUnit.origin_no = heroId
    else
        battleUnit.no = heroId
        battleUnit.is_awake = false
        battleUnit.origin_no = 0
    end
    -- battleUnit.no = heroId
    battleUnit.quality = heroItem.quality
    battleUnit.hp = heroItem.hp + level * heroItem.growHp
    battleUnit.atk = heroItem.atk + level * heroItem.growAtk
    battleUnit.physical_def = heroItem.physicalDef + level * heroItem.growPhysicalDef
    battleUnit.magic_def = heroItem.magicDef + level * heroItem.growMagicDef
    battleUnit.hit = heroItem.hit
    battleUnit.dodge = heroItem.dodge
    battleUnit.cri = heroItem.cri
    battleUnit.cri_coeff = heroItem.criCoeff
    battleUnit.cri_ded_coeff = heroItem.criDedCoeff
    battleUnit.block = heroItem.block
    battleUnit.ductility = heroItem.ductility
    battleUnit.level = level
    battleUnit.break_level = breakLevel
    battleUnit.is_boss = false
    battleUnit.break_skills = {}
    battleUnit.position = position
    battleUnit.is_break = false
    
    return battleUnit
end

function FMTempFightData:createBlueHero(position, heroId, level, breakLevel)
    local heroItem = self.soldierTemplate:getMonsterTempLateById(heroId)

    local battleUnit = {}
    battleUnit.no = heroId
    battleUnit.quality = heroItem.quality
    battleUnit.hp = heroItem.hp 
    battleUnit.atk = heroItem.atk 
    battleUnit.physical_def = heroItem.physicalDef 
    battleUnit.magic_def = heroItem.magicDef 
    battleUnit.hit = heroItem.hit
    battleUnit.dodge = heroItem.dodge
    battleUnit.cri = heroItem.cri
    battleUnit.cri_coeff = heroItem.criCoeff
    battleUnit.cri_ded_coeff = heroItem.criDedCoeff
    battleUnit.block = heroItem.block
    battleUnit.ductility = heroItem.ductility
    battleUnit.level = level
    battleUnit.break_level = breakLevel
    battleUnit.is_boss = false
    battleUnit.break_skills = {}
    battleUnit.position = position
    battleUnit.is_break = false
    battleUnit.is_awake = false
    battleUnit.origin_no = 0
    return battleUnit
end

function FMTempFightData:init()
    self.gId = getNewGManager():getCurrentGid()
    print("self.gId=====", self.gId)
    --没有13这个引导
    if self.gId == 13 and ISSHOW_GUIDE then
        self.isNewHand = true
    else
        self.isNewHand = false
    end

    self:initFrame()

    if EFFECT_TEST then
        self.fightType = TYPE_TEST
    elseif self.gId == GuideId.G_SRART_GUIDE_ANI and ISSHOW_GUIDE then
        self.fightType = TYPE_GUIDE
    else
        self.data = self.fightData:getData()
        self.fightType = self.fightData:getFightType()
        self.red = self.data.red
        if self.isNewHand then
            self:initNewHandHero()
        end
        self.blue =  self.data.blue
    end

    -- self.redLineup = self.fightData:getLineup()

    if self.fightType == TYPE_PVP then
        self.unparaId = self.data.red_skill
        self.unparaLv = self.data.red_skill_level

        self.monsterUnparaId = self.data.blue_skill
        self.monsterUnparaLv = self.data.blue_skill_level

        self.isAuto = true

        self.roundMax = 1
        self:initPvpEnemys()

    elseif self.fightType == TYPE_WORLD_BOSS then

        self.isAuto = true
        self.unparaId = self.data.red_best_skill
        self.unparaLv = self.data.red_best_skill_level
        self.roundMax = 1
        self:initBossEnemys()

    elseif self.fightType == TYPE_MINE_MONSTER then
        self.isAuto = false
        self.unparaId = self.data.red_best_skill_id
        self.unparaLv = self.data.red_best_skill_level

        self.monsterUnparaId = self.data.blue_best_skill_id
        self.monsterUnparaLv = self.data.blue_best_skill_level

        self.blue = {}
        self.blue[1] = {}
        self.blue[1].group = self.data.blue

        self:initEnemys()

    elseif self.fightType == TYPE_MINE_OTHERUSER then

        self.unparaId = self.data.red_best_skill_id
        self.unparaLv = self.data.red_best_skill_level

        self.monsterUnparaId = self.data.blue_best_skill_id
        self.monsterUnparaLv = self.data.blue_best_skill_level

        self.isAuto = true

        self.roundMax = 1
        self:initPvpEnemys()
        print("-------self.fightType == TYPE_MINE_OTHERUSER ---------")
    elseif self.fightType == TYPE_GUIDE then  --演示战斗
        self:initGuideFight()
        self:initPvpEnemys()
        self.isAuto = true
        self.roundMax = 1
    elseif self.fightType == TYPE_TEST then
        self:initTestEnemys()
        self:initPvpEnemys()
        self.isAuto = false
        self.roundMax = 1
        self.isAwake = false
    else
        self.isAuto = false
        -- self.awake = self.data.awake 
        self.friend =  self.data.friend
        print("-----self.friend-------")
        print(#self.friend)


        -- self.replace =  self.data.replace
        -- self.replace_no = self.data.replace_no
        self.dropNum =  self.data.drop_num

        self.unparaId = self.data.hero_unpar --无双id
        self.unparaLv = self.data.hero_unpar_level --无双等级

        self.monsterUnparaId = self.data.monster_unpar --敌方无双id

        self:initEnemys()
    end

    self:initDrop()  --初始化掉落
    self:initArmy()  --初始化友方数据
    
    self:initAwake() --初始化觉醒
    self:initReplace()  --初始化武将乱入，被替换
    self:initBoddy()  --初始化小伙伴
    self:initUnpara()  --初始化无双
end

function FMTempFightData:setFightRounds(step, round)
    -- table.insert(self.fightRounds, round)
    self.fightRounds[#self.fightRounds + 1] = round
end

function FMTempFightData:initArmy()
    print("initArmy=====self.red=======")
    
    print(#self.red)

    if not ISSHOW_GUIDE then  --如果是新手引导的时候
        for k, v in pairs(self.red) do
            print("v.no====" .. v.no)
            print("v.origin_no====" .. v.origin_no)
            local heroId = nil
            local is_awake = v.is_awake
            local is_break = v.is_break
            if is_awake or is_break then
                heroId = v.origin_no
            else
                heroId = v.no
            end
            print("---00000--")
            local position = self.fightData:getSeat(heroId)
            v.position = position
        end
    elseif self.gId ~= GuideId.G_SRART_GUIDE_ANI and self.gId ~= 0 then
        for k, v in pairs(self.red) do
            print("v.no====" .. v.no)
            print("v.origin_no====" .. v.origin_no)
            local heroId = nil
            local is_awake = v.is_awake
            local is_break = v.is_break
            if is_awake or is_break then
                heroId = v.origin_no
            else
                heroId = v.no
            end
            local position = self.fightData:getSeat(heroId)
            v.position = position
        end
    end

    -- 第一章，第一个小关卡，
    local _stageId = self.fightData:getFightingStageId()
    if _stageId == STAGE_100101 then
    
    local _ispass = self:isPassByStage(_stageId)
        if _ispass  then
            local demoHero = self.c_BaseTemplate:getBaseInfoById("newhandHero")

            for k, v in pairs(demoHero) do
                local heroId = v[1]
                local level = v[2]
                local breakLevel = 1

                if heroId ~= 0 then
                    local item = self:createRedHero(tonumber(k), heroId, level, breakLevel, false)
                    self.red[tonumber(k)] = item
                end
            end
        end
    end

    --根据位置进行排序，按照123456 的次序
    local function mySort(item1, item2)
        return item1.position < item2.position
    end

    table.sort(self.red, mySort)
    local flag = true

    for k, v in pairs(self.red) do
 
        local position = v.position
        

        -- if TEST then
            -- if k == 2 then
            --     v.is_break =  true
            --     v.origin_no = 10055
            --     v.no = 20055
            -- end
        -- end
        
        local is_awake = v.is_awake
        local is_break = v.is_break
        local heroId = nil

        if is_awake or is_break then
            heroId = v.origin_no
        else
            heroId = v.no
        end
        print("---v.origin_no-----")
        print(v.origin_no)
        print(v.no)
        cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA4444)
        local pictureName, res = self.soldierTemplate:getHeroImageName(heroId)
        cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA8888)
        v.pictureName = pictureName
         print("-----pictureName---FMTempFightData:initArmy---"..pictureName)
         print(heroId)
        -- local len = string.len(pictureName)
        -- local startPos = len - 4
        -- local tempName = pictureName
        -- local res = string.sub(tempName, 1, startPos)

        v.owner = "army"
        v.resFrame = res
        v.tmp_heroId = heroId
        v.break_heroId = v.no
        v.break_aweak = false
        v.is_boss = false
        v.heroType = TYPE_HERO_NORMAL
        if flag then
            v.chief = true
            flag = false
        else
            v.chief = false
        end
        if is_awake == false and is_break == false then
            local army = FMCard.new(v, true)
            self.armys[position] = army
            
            table.insert(self.tempSkillIdTable, army.normal_skill)
            table.insert(self.tempSkillIdTable, army.rage_skill)
            table.insert(self.tempBreakBuffs, army.break_skills)
            
            local baseData = army:getBaseData()
            table.insert(self.armysCheckTable, baseData)
        end
        if EFFECT_TEST then
            local army = FMCard.new(v)
            self.armys[position] = army           
            local baseData = army:getBaseData()
            table.insert(self.armysCheckTable, baseData)
        end
        self.timeline[2 * position - 1] = {camp = "army", seat = position}
    end
    -- print("-----clone(self.armys)------")
   --  print(table.nums(self.armys))
   -- self.ws_armys = clone(self.armys)
   -- print("-----clone(self.armys)---22---")
   -- print(table.nums(self.ws_armys))
end

--初始化测试敌方，给龙宇用，就是假人
function FMTempFightData:initTestEnemys()
    local demoHero = self.c_BaseTemplate:getBaseInfoById("demoHero")
    print("1111")
    table.print(demoHero)
    print("1111")
    self.red = {}
    local size = #demoHero
    local heroItem = demoHero["2"]
    local redNum = 1
    local blueNum = 6
    self.red = {}
    for i = 1, redNum do
        local heroId = heroItem[1]
        local level = heroItem[2]
        local breakLevel = 1
        if heroId ~= 0 then
            local item = self:createRedHero(i, heroId, level, breakLevel, true)
            self.red[#self.red + 1] = item
        end
    end
    self.blue = {}
    for i = 1, blueNum do
        local heroId = heroItem[1]
        local level = heroItem[2]
        local breakLevel = 1
        if heroId ~= 0 then
            local item = self:createRedHero(i, heroId, level, breakLevel, true)
            self.blue[#self.blue + 1] = item
        end
    end
    
    -- self.fightType = TYPE_GUIDE
    self.unparaId = 10020
    self.unparaLv = 1

end

--普通情况下初始化敌方数据
function FMTempFightData:initEnemys()
    print("=======000000=====")
    local function mySort(item1, item2)
        print(item1)
        return item1.position < item2.position
    end
    local roundIndex = 0
   
    for m, n in pairs(self.blue) do
        roundIndex = roundIndex + 1
        
        -- table.print(n.group)

        table.sort(n.group, mySort)
        local enemys = {}

        -- if EFFECT_TEST then
        --     for i = 1, 6 do
        --         local isHas = false
        --         for k, v in pairs(n.group) do
        --             local position = v.position 
        --             if i == position then
        --                 isHas = true
        --             end
        --         end
        --         if isHas == false then
        --             local item = n.group[1]
        --             local cloneItem = clone(item)
        --             cloneItem.position = i
        --             n.group[i] = cloneItem
        --         end
        --     end
        -- end

        for k, v in pairs(n.group) do
            local position = v.position
            
            local pictureName = self.soldierTemplate:getMonsterImageName(v.no)
            print("--FMTempFightData:initEnemys-----"..pictureName)
            print(v.no)
            -- self.resourceData:loadHeroImageDataById(pictureName)
            v.pictureName = pictureName
            v.owner = "enemy"
            v.break_aweak = 3 
            v.tmp_heroId = 0
            v.resFrame = pictureName
            v.chief = false
            v.heroType = TYPE_HERO_NORMAL
            local enmey = FMCard.new(v)
            enemys[position] = enmey
            v.is_boss = false
            table.insert(self.tempSkillIdTable, enmey.normal_skill)
            table.insert(self.tempSkillIdTable, enmey.rage_skill)
            table.insert(self.tempBreakBuffs, enmey.break_skills)
            local baseData = enemys[position]:getBaseData()
  
            table.insert(self.enemysCheckTable, baseData)
        end

        self.totleEnemys[roundIndex] = enemys
    end
    self.roundMax = roundIndex
end

--初始化pvp 敌方
function FMTempFightData:initPvpEnemys()
    print("-----FMTempFightData:initPvpEnemys")
    local function mySort(item1, item2)
        return item1.position < item2.position
    end
    table.sort(self.blue, mySort)

    for k, v in pairs(self.blue) do
        local position = v.position
        local is_awake = v.is_awake
        local is_break = v.is_break
        local heroId = nil
        if is_awake or is_break then
            heroId = v.origin_no
        else
            heroId = v.no
        end

        -- local pictureName = self.soldierTemplate:getHeroImageName(heroId)
        cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA4444)
        local pictureName, frameImg = self.soldierTemplate:getHeroImageName(heroId)
        cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA8888)
        v.pictureName = pictureName
        -- local len = string.len(pictureName)
        -- local startPos = len - 4
        -- local tempName = pictureName
        -- local res = string.sub(tempName, 1, startPos)
        -- self.resourceData:loadHeroImageDataById(res)
        v.break_aweak = false
        v.tmp_heroId = heroId
        v.owner = "enemy"
        v.resFrame = frameImg
        v.chief = false
        
        v.is_boss = false

        v.heroType = TYPE_HERO_NORMAL
        -- if is_awake == false and is_break == false then
        local enemy = FMCard.new(v)
        self.pvpEnemys[position] = enemy
        
        -- table.insert(self.tempBreakBuffs, enmey.break_skills)
        local baseData = enemy:getBaseData()
        table.insert(self.enemysCheckTable, baseData) --将base数据放到table中，以便结束战斗后，将数据导出
        
        self.timeline[2 * position] = {camp = "enemy", seat = position}
    end
end

--初始化世界boss敌方
function FMTempFightData:initBossEnemys()
    for k, v in pairs(self.blue) do
        local position = 5
        local pictureName = self.soldierTemplate:getMonsterImageName(v.no)
        v.pictureName = pictureName
        local len = string.len(pictureName)
        local startPos = len - 4
        local tempName = pictureName

       cclog("initBossEnemys=======pictureName=========" .. pictureName)

       print(v.hp)
        print(v.atk)
        -- self.resourceData:loadHeroImageDataById(pictureName)
        v.break_aweak = 3
        v.tmp_heroId = 0
        v.owner = "enemy"
        v.resFrame = pictureName
        v.chief = false
        v.position = position
        v.is_boss = true

        v.heroType = TYPE_HERO_WORLD_BOSS

        local enemy = FMCard.new(v)

        self.bossEnemys[position] = enemy

        table.insert(self.tempSkillIdTable, enemy.normal_skill)
        table.insert(self.tempSkillIdTable, enemy.rage_skill)
        -- table.insert(self.tempBreakBuffs, enmey.break_skills)
        local baseData = enemy:getBaseData()
        table.insert(self.enemysCheckTable, baseData)
        self.timeline[2 * position] = {camp = "enemy", seat = position}
    end
end

--初始化武将乱入
function FMTempFightData:initReplace()
    self.replace = nil
    local red = clone(self.red)
    for k, v in pairs(red) do
        local is_break = v.is_break
        if is_break then
            self.replace = v
        end
    end
    if self.replace == nil then
        return
    end
    
    local pictureName, frameImg = self.soldierTemplate:getHeroImageName(self.replace.no)
    print("------initReplace-------", pictureName )
    print(frameImg)

    self.replace.pictureName = pictureName
    --  local len = string.len(pictureName)
    -- local startPos = len - 4
    -- local tempName = pictureName
    -- local res = string.sub(tempName, 1, startPos)
    self.replaceResFrame = frameImg
    -- self.resourceData:loadHeroImageDataById(res)
    self.replace.owner = "army"
    self.replace.chief = false
    self.replace.resFrame = frameImg

    self.replace.heroType = TYPE_HERO_REPLACE
    self.replaceHero = FMCard.new(self.replace)
    table.insert(self.tempSkillIdTable, self.replaceHero.normal_skill)
    table.insert(self.tempSkillIdTable, self.replaceHero.rage_skill)
    table.insert(self.tempBreakBuffs, self.replaceHero.break_skills)
    local baseData = self.replaceHero:getBaseData()
    table.insert(self.armysCheckTable, baseData)
end

--改变数据，有可能是被乱入，有可能是觉醒
function FMTempFightData:changeArmyData(prop)
    self.armys[prop.position] = self.replaceHero
end

--初始化觉醒
function FMTempFightData:initAwake()
    if EFFECT_TEST then
        return
    end
   cclog("FMTempFightData:initAwake")
    self.redAwake = {}
    local red = clone(self.red)
    for k, v in pairs(red) do
        local is_awake = v.is_awake
        if is_awake then
            table.insert(self.redAwake, v)
        end
    end

    self.blueAwake = {}
    if self.fightType == TYPE_PVP or self.fightType == TYPE_GUIDE then
        local blue = clone(self.blue)
         for k, v in pairs(self.blue) do
            local is_awake = v.is_awake
            if is_awake then
                table.insert(self.blueAwake, v)
            end
        end
    end

    local maxSize = #self.redAwake + #self.blueAwake
    if maxSize > 0 then
        self.isAwake = true
    else
        self.isAwake = false
    end
    
    self.redAwakeHeros = {}
    for m, n in pairs(self.redAwake) do
        local heroId = n.no
        cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA4444)
        local pictureName, frameImg = self.soldierTemplate:getHeroImageName(heroId)
        cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA8888)

        print("---self.redAwakeHeros-------")
        print(pictureName)

        local len = string.len(pictureName)
        local startPos = len - 4
        local tempName = pictureName
        local res = string.sub(tempName, 1, startPos)
        n.chief = false
        n.break_aweak = false
        n.tmp_heroId = heroId
        -- self.resourceData:loadHeroImageDataById(res)
        n.owner = "army"
        n.resFrame = frameImg
        -- n.originPictureName = pictureName
        local position = n.position
        n.pictureName = pictureName

        n.heroType = TYPE_HERO_AWAKE
        cclog("n.heroType==========" .. n.heroType)
        local awake = FMCard.new(n)
        self.redAwakeHeros[position] = awake
        table.insert(self.tempSkillIdTable, awake.normal_skill)
        table.insert(self.tempSkillIdTable, awake.rage_skill)
        table.insert(self.tempBreakBuffs, awake.break_skills)
        local baseData = awake:getBaseData()
        table.insert(self.armysCheckTable, baseData)
    end
    self.blueAwakeHeros = {}
    for m, n in pairs(self.blueAwake) do
        local heroId = n.no
        local pictureName = self.soldierTemplate:getHeroImageName(heroId)

        local len = string.len(pictureName)
        local startPos = len - 4
        local tempName = pictureName
        local res = string.sub(tempName, 1, startPos)
        n.chief = false
        -- self.resourceData:loadHeroImageDataById(res)
        n.owner = "army"
        n.resFrame = res
        n.heroType = TYPE_HERO_AWAKE
        local position = n.position
        n.pictureName = pictureName
        local awake = FMCard.new(n)
        self.blueAwakeHeros[position] = awake
        table.insert(self.tempSkillIdTable, awake.normal_skill)
        table.insert(self.tempSkillIdTable, awake.rage_skill)
        table.insert(self.tempBreakBuffs, awake.break_skills)
        local baseData = awake:getBaseData()
        table.insert(self.enemysCheckTable, baseData)
    end
end

-- 判断是否是死亡的最后一个紫武将
function FMTempFightData:isLastHeroDead(heroId)
    -- local _tmpHeroInfo = self.soldierTemplate:getHeroTempLateById(heroId)
    -- local _quality = _tmpHeroInfo.quality
    -- print("===_quality===="..heroId)
    -- print(_quality)
    -- if _quality ~= 5 and _quality ~= 6 then return false end

    -- print("--FMTempFightData:isLastHeroDead------")
    -- print(#self.armys)

    -- for k,v in pairs(self.armys) do
    --     print(v.tmp_heroId)
    --     if v.tmp_heroId ~= heroId then 
    --         _quality = self.soldierTemplate:getHeroTempLateById(v.tmp_heroId).quality
    --         if _quality == 5 or _quality == 6 then
    --          return false
    --         end
    --      end
    -- end
    -- local _quality = _tmpHeroInfo.quality
    -- print("===_quality===="..heroId)
    -- print(_quality)
    -- if _quality ~= 5 and _quality ~= 6 then return false end

    print("--FMTempFightData:isLastHeroDead------")
    print(#self.armys)
    local tmp = {}
    for k, v in pairs(self.armys) do
        if v then
            tmp[#tmp+1] = v
        end
    end
    
    if #tmp > 1 then return false end

    if tmp[1].tmp_heroId ~= heroId then
        return false
    end    

    return true
end

-- 判断是否是死亡的最后一个紫武将
function FMTempFightData:isLastHeroDeadInEnemys(heroId)
    print("---isLastHeroDeadInEnemys-----")
    print(heroId)
    local _tmpHeroInfo = self.soldierTemplate:getHeroTempLateById(heroId)
    if _tmpHeroInfo == nil then return false end

    local _quality = _tmpHeroInfo.quality
    print("===_quality===="..heroId)
    print(_quality)
    if _quality ~= 5 and _quality ~= 6 then return false, _quality end

    print("--FMTempFightData:isLastHeroDeadInEnemys------")

    local _enemys = self:getCurrentEnemys()
    print(#_enemys)

    for k,v in pairs(_enemys) do
        print(v.no)
        print(v.tmp_heroId)
        if v.tmp_heroId ~= heroId then 
            _quality = self.soldierTemplate:getHeroTempLateById(v.tmp_heroId).quality
            if _quality == 5 or _quality == 6 then
             return false, 6
            end
         end
    end

    return true, 6
end


-- 判断是否是死亡的最后一个怪物
function FMTempFightData:isLastMonsterDeadInEnemys()
    print("---isLastMonsterDeadInEnemys-----")
    
    local _enemys = self:getCurrentEnemys()

    local _count = table.nums(_enemys)

    local i = 0
    for k,v in pairs(_enemys) do

        if v.isDead  then 
           i = i +1
         end
    end

    if i >= _count then 
        return true
    end

    return false
end

-- 判断该关卡是否打过
function FMTempFightData:isPassByStage(stageId)
    local _stageData = getDataManager():getStageData()

    return _stageData:getStageState(stageId) == -1
end

--改变觉醒的数据
function FMTempFightData:changeAwakeData()
    for k, v in pairs(self.redAwakeHeros) do
        self.armys[k] = v
    end

    for k, v in pairs(self.blueAwakeHeros) do
        self.pvpEnemys[k] = v
    end
end

--初始化小伙伴
function FMTempFightData:initBoddy() 
    
    print("----FMTempFightData:initBoddy----")

    if self.friend == nil or self.friend.no == 0 then
        return 
    end

    local no = self.friend.no

   cclog("self.friend.no=========" .. self.friend.no)
    local position = self.friend.position

    -- local pictureName = self.soldierTemplate:getHeroImageName(self.friend.no)
    local pictureName, res = self.soldierTemplate:getHeroImageName(self.friend.no)
    self.friend.position = BUDDY_SEAT
    -- local len = string.len(pictureName)
    -- local startPos = len - 4
    -- local tempName = pictureName
    -- local res = string.sub(tempName, 1, startPos)
    self.friend.resFrame = res
    self.friend.tmp_heroId = self.friend.no
    self.friend.break_aweak = 3
    -- self.resourceData:loadHeroImageDataById(res)

    self.friend.pictureName = pictureName
    self.friend.owner = "boddy"
    self.friend.chief = false

    self.friend.heroType = TYPE_HERO_NORMAL

    self.friendHero = FMCard.new(self.friend)
    table.insert(self.tempSkillIdTable, self.friendHero.rage_skill)
    table.insert(self.tempBreakBuffs, self.friendHero.break_skills)
end

--初始化无双数据
function FMTempFightData:initUnpara()
    cclog("self.unparaId========" .. self.unparaId)
    local instanceTemplate = getTemplateManager():getInstanceTemplate()
    if self.unparaId ~= 0 and self.unparaId ~= nil then   
        self.unparaItem = instanceTemplate:getWSInfoById(self.unparaId)

        table.insert(self.tempSkillIdTable, self.unparaItem["triggle1"])

        if self.unparaLv > 1 then
            table.insert(self.tempSkillIdTable, self.unparaItem["triggle2"])
        end

        if self.unparaLv > 2 then
            table.insert(self.tempSkillIdTable, self.unparaItem["triggle3"])
        end
    end

    if self.monsterUnparaId ~= 0 and self.monsterUnparaId ~= nil then
        print("FMTempFightData:initUnpara-------")
        print(self.monsterUnparaId)

        self.monsterUnparaItem = instanceTemplate:getWSInfoById(self.monsterUnparaId)
        table.insert(self.tempSkillIdTable, self.monsterUnparaItem["triggle1"])
        table.insert(self.tempSkillIdTable, self.monsterUnparaItem["triggle2"])
        table.insert(self.tempSkillIdTable, self.monsterUnparaItem["triggle3"])
    end
end

--初始化掉落
function FMTempFightData:initDrop()
    if self.dropNum == nil or self.dropNum == 0 then
        return
    end

    local maxGroup = #self.blue
    local grounInfoTable = {}
    for i = 1, maxGroup do
        grounInfoTable[i] = 0
    end
    for i = 1, self.dropNum do
        local tempData = math.random(1, maxGroup)
        grounInfoTable[tempData] = grounInfoTable[tempData] + 1
    end
    for i = 1, maxGroup do
        self.dropInfoTable[i] = {}
        local group = self.blue[i].group
        local groupNum = #group
        local item = grounInfoTable[i]
        for j = 1, item do
            local tempData = math.random(1, groupNum)
            local enemy = group[tempData]
            local seat = enemy.position
            self.dropInfoTable[i][tempData] = {}
            local temp = self.dropInfoTable[i][tempData]
            if temp.dropNum == nil then
                temp.dropNum = 1
                temp.seat = seat
            else
                self.dropInfoTable[i][tempData] = self.dropInfoTable[i][tempData] + 1
            end
        end
    end

end

--根据seat获得掉落的数量
function FMTempFightData:getDropNum(seat)
    local item = self.dropInfoTable[self.currentRound]
    if item then
        for k, v in pairs(item) do
            local tempSeat = v.seat
            local dropNum = v.dropNum
            if tempSeat == seat then
                return dropNum
            end
        end
    end
    return 0
    -- return 1
end

--清理12的step line 的数据
function FMTempFightData:clearTimeLineOfSeat(seat)
    self.timeline[seat] = nil
end

--清理死亡的hero
function FMTempFightData:clearDeadHero()
    
    print("=-------FMTempFightData:clearDeadHero-----")

    local cloneArmys = clone(self.armys)

    for k, v in pairs(cloneArmys) do
        if v.isDead then
            self.armys[k] = nil
        end
    end 

    local enemys = self:getCurrentEnemys()

    local cloneEnemys = clone(enemys)
    for k, v in pairs(cloneEnemys) do
        if v.isDead then
            enemys[k] = nil
        end
    end 
end

function FMTempFightData:setFightPause()
    print("setFightPause-------------")
     --self.pausedTargets = self.director:getActionManager():pauseAllRunningActions()
     self.pausedFight = true
end

function FMTempFightData:resumeFightPause() 
    print("resumeFightPause-------------")
    --self.director:getActionManager():resumeTargets(self.pausedTargets)
end

--获得当前回合内的敌方，可能根据战况不同，获得的数据不同
function FMTempFightData:getCurrentEnemys()
    if self.fightType == TYPE_PVP or self.fightType == TYPE_MINE_OTHERUSER or self.fightType == TYPE_GUIDE or self.fightType == TYPE_TEST then
        return self.pvpEnemys
        --self.bossEnemys
    elseif self.fightType == TYPE_WORLD_BOSS then
        return self.bossEnemys
    else
        --cclog("self.currentRound========" .. self.currentRound)
        -- table.printKey(self.totleEnemys)
        --cclog("self.currentRound========" .. self.currentRound)
        return self.totleEnemys[self.currentRound]
    end
end

--获得友方数据，不过我一般直接点出来了
function FMTempFightData:getCurrentArmys()
    return self.armys
end

--增加小伙伴值
function FMTempFightData:addBoddyValue()
    self.boddyValue = self.boddyValue + self.boddyConfig[2]
    -- self.boddyValue = self.boddyValue + 300
    if self.boddyValue > self.boddyConfig[3] then
        self.boddyValue = self.boddyConfig[3]
    end
end

function FMTempFightData:isFullBodyValue()
    
    return self.boddyValue >= self.boddyConfig[3]
end

function FMTempFightData:setBoddyValue(boddyValue)
    self.boddyValue = boddyValue
end

function FMTempFightData:getBoddyValue()
    return self.boddyValue
end

--设置当前的round，从1开始
function FMTempFightData:setCurrentRound(round)
    self.currentRound = round

    if self.fightType ~= TYPE_PVP and self.fightType ~= TYPE_WORLD_BOSS and self.fightType ~= TYPE_MINE_OTHERUSER and self.fightType ~= TYPE_GUIDE and self.fightType ~= TYPE_TEST then
        local enemys = self.totleEnemys[round]

        for k, v in pairs(enemys) do

            local position = v.position
            --这样的话就是初始化，1-12，这样就是一个大循环，敌方是2的倍数，我方是2*i- 1
            self.timeline[2 * position] = {camp = "enemy",seat = position}
        end
    end
end

function FMTempFightData:setUnparaValue(unparaValue)
    self.unparaValue = unparaValue
end

--增加我方无双值
function FMTempFightData:addUnparaValue()
    if self.unparaId == 0 or self.unparaId == nil then
        return
    end
    self.unparaValue = self.unparaValue + self.unparaConfig[2]
    print("--TODO:无双的数值临时调整")
    self.unparaValue = self.unparaValue + 600
    if self.unparaValue > self.unparaConfig[self.unparaLv + 2] then
        self.unparaValue = self.unparaConfig[self.unparaLv + 2]
        -- self.gId = getNewGManager():getCurrentGid()
        -- self:setFightPause()
    end
end

--检测是否达到引导的无双
function FMTempFightData:checkUnparaGuide()
    if self.unparaId == 0 or self.unparaId == nil then
        return false
    end

    if self.unparaValue == self.unparaConfig[self.unparaLv + 2] then
        local gId = getNewGManager():getCurrentGid()
        print("gId=====" .. gId)
        if gId == GuideId.G_GUIDE_20023 then
            groupCallBack(GuideGroupKey.BTN_FIGHT_RAGE)

            return true
        end

        
    end
    return false
end

function FMTempFightData:getUnparaValue()
    return self.unparaValue
end

function FMTempFightData:setMonsterUnparaValue(monsterUnparaValue)
    self.monsterUnparaValue = monsterUnparaValue
end

--增加敌方无双
function FMTempFightData:addMonsterUnparaValue()
    
    if self.fightType ~= TYPE_PVP or self.fightType ~= TYPE_MINE_OTHERUSER then return  end

    self.monsterUnparaValue = self.monsterUnparaValue + self.unparaConfig[2]

    -- self.monsterUnparaValue = self.monsterUnparaValue + 100
    if self.monsterUnparaValue > self.unparaConfig[self.monsterUnparaLv+2] then
        self.monsterUnparaValue = self.unparaConfig[self.monsterUnparaLv+2]
    end
end

--self.totleRound = 0
function FMTempFightData:getTotleRound()
    return self.totleSRound
end

function FMTempFightData:addTotleSRound()
    self.totleSRound = self.totleSRound + 1
end
--获取是否30回合满了
function FMTempFightData:getIsFullRound()
    -- if self.fightType == TYPE_WORLD_BOSS then
    --     self.max_times_fight = 5
    -- end
    
    if self.totleSRound > self.max_times_fight then
        return true
    end
    return false
end

function FMTempFightData:setTotleSRound(totleSRound)
    self.totleSRound = totleSRound
end

function FMTempFightData:getMonsterUnparaValue()
    return self.monsterUnparaValue
end 

--获得无双是否满了
function FMTempFightData:getIsUnparaFull()
    local unparaType = TYPE_AUTO_UNPARA_NORMAL
    --如果满了，看是我方满了还是敌方满了
    if self.unparaId ~= nil and self.unparaId ~= 0 then
        if self.unparaValue  == self.unparaConfig[self.unparaLv + 2] then
            self.unparaValue = 0
            unparaType = TYPE_AUTO_UNPARA_RED --我方
            return unparaType
        end
    end

    if self.monsterUnparaId ~= nil and self.monsterUnparaId ~= 0 then
        if self.monsterUnparaValue  == self.unparaConfig[self.monsterUnparaLv+2] then
            self.monsterUnparaValue = 0
            unparaType = TYPE_AUTO_UNPARA_BLUE --敌方
            return unparaType
        end
    end
    return nil
end

function FMTempFightData:setTempDropValue(tempDropValue)
    self.tempDropValue = tempDropValue
end

function FMTempFightData:getRandom(x1, x2)
    self.seadX1, self.seadX2, result = rnd(self.seadX1, self.seadX2)
    if x1 ~= nil and x2 ~= nil then
        result = x1 + (x2 - x1 ) * result
    end                                                                                                                                                                                                                  
    local randomTable = {}
    randomTable.seadX1 = self.seadX1
    randomTable.seadX2 = self.seadX2
    randomTable.randomValue = result
    return randomTable
end

function FMTempFightData:initAnimationFrame()
    -- print("initAnimationFrame-------")
    -- table.print(self.tempSkillIdTable)
    -- print("initAnimationFrame-------")

    for k, v in pairs(self.tempSkillIdTable) do

        local item = self.soldierTemplate:getSkillTempLateById(v)
        local group = item.group
        for m, n in pairs(group) do
            local buffItem = self.soldierTemplate:getSkillBuffTempLateById(n)
            local actEffect = buffItem.actEffect
            if actEffect ~= 0 then

                local item = self.actionUtil.buffdata[string.format(actEffect)]
                local actionActions = item.actions
                for p, q in pairs(actionActions) do
                    local attack = q.attack
                    local hit = q.hit
                    local attackAction = self.actionUtil.data[attack]
                    local hitAction = self.actionUtil.data[hit]

                    self:preferAction(attackAction)
                    self:preferAction(hitAction)
                end
            end
        end
    end
    --
    for k, v in pairs(self.tempBreakBuffs) do
        for m, n in pairs(v) do
            local buffItem = self.soldierTemplate:getSkillBuffTempLateById(n)
            local actEffect = buffItem.actEffect
            if actEffect ~= 0 then
                local item = self.actionUtil.buffdata[string.format(actEffect)]
                local actionActions = item.actions
                for p, q in pairs(actionActions) do
                    local attack = q.attack
                    local hit = q.hit
                    local attackAction = self.actionUtil.data[attack]
                    local hitAction = self.actionUtil.data[hit]

                    self:preferAction(attackAction)
                    self:preferAction(hitAction)
                end
            end
        end
    end
end

function FMTempFightData:preferAction(action)
    if action == nil then return end

    for _, v2 in pairs(action) do
        for _, v3 in pairs(v2) do
            if v3 and v3.animate then
                local name = string.sub(v3.animate.file, 1, -3)
                self.tempAniActTable[#self.tempAniActTable + 1] = name
            end
            if v3 and v3.animateS then
                local name = string.sub(v3.animateS.file, 1, -3)
                self.tempAniActTable[#self.tempAniActTable + 1] = name
            end
        end
    end
end

function FMTempFightData:preLoadAnimation()
    getActionUtil():init()
    self:initAnimationFrame()
end

function FMTempFightData:loadAnimation()
    cclog("loadAnimation--------index===")
    table.print(self.tempAniActTable)
    cclog("loadAnimation--------index===")
    -- game.addSpriteFramesWithFile("res/ui/fight_hit.plist")
    -- game.addSpriteFramesWithFile("res/ccb/resource/kill_effect.plist")

    -- local _info = cc.Director:getInstance():getTextureCache():getCachedTextureInfo()
    --cclog("222222222222222")
    --cclog(_info)
    --cclog("222222222222222")
    self.callBackIndex = 1
    local timeCallBack = function ()
        if self.callBackIndex > #self.tempAniActTable then
            timer.unscheduleGlobal(self.timeScheduler)
            
            game.getRunningScene().sceneRoot:removeChildByTag(9999)

            getFEControl():startFight()
        else
            cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA4444)
            local v = self.tempAniActTable[self.callBackIndex]
            if v then
                game.addSpriteFramesWithFile("res/animate/" .. v .. ".plist")
            end
            
            local v = self.tempAniActTable[self.callBackIndex + 1]
            if v then
                game.addSpriteFramesWithFile("res/animate/" .. v .. ".plist")
            end

            local v = self.tempAniActTable[self.callBackIndex + 2]
            if v then
                game.addSpriteFramesWithFile("res/animate/" .. v .. ".plist")
            end

            local v = self.tempAniActTable[self.callBackIndex + 3]
            if v then
                game.addSpriteFramesWithFile("res/animate/" .. v .. ".plist")
            end

            local v = self.tempAniActTable[self.callBackIndex + 4]
            if v then
                game.addSpriteFramesWithFile("res/animate/" .. v .. ".plist")
            end
            cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA8888)
        end
        self.callBackIndex = self.callBackIndex + 5
    end
    self.timeScheduler = timer.scheduleGlobal(timeCallBack, 0.01)

end

function FMTempFightData:initFrame()
    cclog("FMTempFightData:initFrame===")

    cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA4444)
    game.addSpriteFramesWithFile("res/ui/fight_hit.plist")
    game.addSpriteFramesWithFile("res/ccb/resource/kill_effect.plist")

    game.addSpriteFramesWithFile("res/card/state_all.plist")
    game.addSpriteFramesWithFile("res/ccb/resource/ui_fight.plist")
    game.addSpriteFramesWithFile("res/ccb/resource/round_effect.plist")
    game.addSpriteFramesWithFile("res/card/dead_all.plist")
    game.addSpriteFramesWithFile("res/card/board_all.plist")
    cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA8888)

    
    -- local _info = cc.Director:getInstance():getTextureCache():getCachedTextureInfo()
    --  print(_info)
    
    
    -- if EFFECT_TEST then
    --     for file, _ in pairs(self.actionUtil:getUsedFiles()) do

    --         game.addSpriteFramesWithFile("res/animate/" .. file .. ".plist")
    --     end
    -- end
end

function FMTempFightData:getHeroLevel(camp, heroId)
    local heros = nil
    if camp == "army" then
        heros = self.armys
    else
        --heros = self:getCurrentEnemys()
        heros = self.armys
    end
    for k, v in pairs(heros) do
        local heroNo = v.no
       cclog("heroNo====" .. heroNo)
        if heroNo == heroId then
            return v.level
        end
    end
    return 0
end

function FMTempFightData:getResultRound()
    local totleCheckRounds = {}

    for k, v in pairs(self.fightRounds) do
        local tempRounds = {}
        tempRounds.step = v.step
        tempRounds.subSkillType = v.subSkillType
        tempRounds.camp = v.camp
        tempRounds.beginAction = v.beginAction
        tempRounds.skillType = v.skillType
        tempRounds.src = v.src
        tempRounds.buffGroup = v.buffGroup
        tempRounds.name = v.name
        tempRounds.keyInfoTable = v.keyInfoTable
        
        local tempBuffs = v.buffs
        local buffs = {}
        for m, n in pairs(tempBuffs) do
            local tempbuff = {}
            tempbuff.startCamp = n.startCamp
            tempbuff.dst_army = n.dst_army
            tempbuff.dst_enemy = n.dst_enemy
            tempbuff.buffno = n.buffno
            tempbuff.startSeat = n.startSeat
            tempbuff.actEffect = n.actEffect
            tempbuff.startCampBaseData = n.startCampBaseData
            tempbuff.actionActions = n.actionActions
            tempbuff.tiggerTable = n.tiggerTable
            
            table.insert(buffs, tempbuff)
        end
        tempRounds.buffs = buffs
        -- table.insert(totleCheckRounds, tempRounds)
        totleCheckRounds[k] = tempRounds
    end
    return totleCheckRounds
end

-- 根据heroId获取战力
function FMTempFightData:getHeroAtk(heroId)
    print("---FMTempFightData:getHeroAtk----")
    -- table.print(self.ws_armys)

    for k,v in pairs(self.red) do

        if v.no == heroId or v.origin_no == heroId then
            return v.atk
        end
    end

    return 1
end

-- 根据heroId获取战力
function FMTempFightData:getEnemyHeroAtk(heroId)
    -- local _enemys = self:getCurrentEnemys()
    
    for k,v in pairs(self.blue) do

        if  v and (v.no == heroId or v.origin_no == heroId) then
            return v.atk
        end
    end

    return 1
end

-- 获取自己的物防
function FMTempFightData:getArmyphysicalDef(heroId)
    local _value = 1

    for k,v in pairs(self.red) do

        if  v and (v.no == heroId or v.origin_no == heroId) then
            return v.physical_def
        end
    end

    return _value
end

-- 获取自己的魔防
function FMTempFightData:getArmyMagicDef(heroId)
    local _value = 0

    for k,v in pairs(self.red) do

        if v and (v.no == heroId or v.origin_no == heroId) then
            return v.magic_def
        end
    end

    return _value
end

-- 获取敌人的物防
function FMTempFightData:getEnemyphysicalDef(heroId)
    local _enemys = self:getCurrentEnemys()
    local _value = 0

    for k,v in pairs(_enemys) do

        if  v and (v.no == heroId or v.origin_no == heroId) then
            return v.physical_def
        end
    end

    return _value
end

-- 获取敌人的魔防
function FMTempFightData:getEnemyMagicDef(heroId)
    local _enemys = self:getCurrentEnemys()
    local _value = 0

    for k,v in pairs(_enemys) do

        if  v and (v.no == heroId or v.origin_no == heroId) then
            return v.magic_def
        end
    end

    return _value
end

function FMTempFightData:saveData()
    if device.platform == "ios" and string.find(device.writablePath, "Simulator") then
        local preUrl = string.sub(device.writablePath, string.find(device.writablePath, "^/Users/.-/"))
        local armyDataFile = preUrl .. "GameData/checkdata/army_data.json"
        local enemyDataFile = preUrl .. "GameData/checkdata/enemy_data.json"
        local fightDataFile = preUrl .. "GameData/checkdata/fight_data.json"
        local f = io.open(armyDataFile, "w")

        if f then
            local jsonData = json.encode(self.armysCheckTable)
            f:write(jsonData)
            f:close()
        else
           cclog("ERROR: no armyDataFile==" .. armyDataFile) 
        end

        local f = io.open(enemyDataFile, "w")
        if f then
            f:write(json.encode(self.enemysCheckTable))
            f:close()
        else
           cclog("ERROR: no enemyDataFile==" .. enemyDataFile)
        end

        local f = io.open(fightDataFile, "w")
        if f then
            
            f:write(json.encode(self:getResultRound()))
            f:close()
        else
           cclog("ERROR: no enemyDataFile==" .. enemyDataFile) 
        end
    end
end

function FMTempFightData:clearData()
    for k, v in pairs(self.red) do
        local plist = v.pictureName
        self.resourceData:removeHeroImageDataById(plist)
    end
    self.red = {}
    -- if self.blue ~= nil then
    --     if self.fightType == TYPE_PVP or self.fightType == TYPE_WORLD_BOSS or self.fightType == TYPE_MINE_OTHERUSER or self.fightType == TYPE_GUIDE then
    --         for m, n in pairs(self.blue) do
    --             local plist = n.pictureName
    --             self.resourceData:removeHeroImageDataById(plist)
    --         end
    --     else
    --         for m, n in pairs(self.blue) do
    --             for k, v in pairs(n.group) do
    --                 local resFrame = v.pictureName
    --                 if resFrame then
    --                     self.resourceData:removeHeroImageDataById(resFrame)
    --                 end
    --             end
    --         end
    --     end
    -- end

    self.blue = {}

    if self.replace ~= nil and self.replace.pictureName ~= nil then
        self.resourceData:removeHeroImageDataById(self.replace.pictureName)
        self.replace.pictureName = nil
    end

    if self.friend ~= nil and self.friend.no ~= 0 then
  
        self.resourceData:removeHeroImageDataById(self.friend.pictureName)
        self.friend = nil
    end

    for file, _ in pairs(self.tempAniActTable) do
        game.removeSpriteFramesWithFile("res/animate/" .. file .. ".plist")
    end

    self.armys = nil
    self.ws_armys = nil
    self.armys = {}
    self.totleEnemys = nil
    self.totleEnemys = {}

    ----
    self.bossEnemys = nil
    self.bossEnemys = {}

    --
    self.pvpEnemys = nil
    self.pvpEnemys = {}

    self.currentRound = 1
    self.timeline = nil
    self.timeline = {} 
    self.rounds = {}
    self.unparaValue = 0
    self.tempDropValue = 0
    self.totleSRound = 1
    self.unparaItem = nil
    self.dropNum = 0

    self.armysCheckTable = {}
    self.enemysCheckTable = {}
    self.fightRounds = {}

    self.tempSkillIdTable = {}
    self.tempBreakBuffs = {}
    self.tempAniActTable = {}
    
    self.replace =  nil
    self.replace_no = nil
    self.redAwakeHeros = nil

    self.unparaId = nil
    self.monsterUnparaId = nil
    self.unparaLv = 0
    self.monsterUnparaLv = 0

    self.unparaValue = 0
    self.monsterUnparaValue = 0

    self.boddyValue = 0

    self.isAuto = false
    game.removeSpriteFramesWithFile("res/card/board_all.plist")
    game.removeSpriteFramesWithFile("res/card/state_all.plist")

    game.removeSpriteFramesWithFile("res/card/dead_all.plist")
    game.removeSpriteFramesWithFile("res/ui/fight_hit.plist")
    game.removeSpriteFramesWithFile("res/ccb/resource/kill_effect.plist")

    game.removeSpriteFramesWithFile("res/ccb/resource/ui_fight.plist")
    game.removeSpriteFramesWithFile("res/ccb/resource/round_effect.plist")

    game.removeSpriteFramesWithFile("res/ccb/resource/meng_effect.plist")
    
    game.removeSpriteFramesWithFile("res/ccb/resource/luanru_effect.plist")
    game.removeSpriteFramesWithFile("res/ccb/resource/round_effect.plist")

end

return FMTempFightData







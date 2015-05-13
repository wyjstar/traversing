
local SoldierTemplate = SoldierTemplate or class("SoldierTemplate")
import("..config.hero_config")
import("..config.skill_config")
import("..config.skill_buff_config")
import("..config.hero_breakup_config")
import("..config.hero_breakup_attr_config")
import("..config.chip_config")
import("..config.link_config")
import("..config.hero_exp_config")
import("..config.monster_config")
import("..config.seal_config")
import("..config.monster_group_config")
import("..config.lucky_hero_config")

function SoldierTemplate:ctor(controller)
   self.c_ResourceTemplate = getTemplateManager():getResourceTemplate()
end

function SoldierTemplate:getHeroAudio(heroId)
    print("----------- getHeroAudio --------------"..heroId)
    local id = hero_config[heroId]["audio"]
    print(id)
    if id == 0 then return 0 end
    local res = resource_config[id]["pathWithName"]
    return "res/sound/effect/hero/"..res
end

function SoldierTemplate:getHeroDeadAudio(heroId)
    print("-----SoldierTemplate:getHeroDeadAudio-----")
    if heroId == nil then return nil end

    if hero_config[heroId] == nil then return nil end

    local id = hero_config[heroId]["deadAudio"]
    if id == 0 then return nil end

    local res = resource_config[id]["pathWithName"]
    return "res/sound/effect/hero/"..res
end

function SoldierTemplate:getMonsterDeadAudio(no)
    if no == nil then return nil end

    local id = monster_config[no]["deadAudio"]

    if id == 0 then return nil end

    local res = resource_config[id]["pathWithName"]
    return "res/sound/effect/hero/"..res
end

--根据武将id获得羁绊信息
function SoldierTemplate:getLinkDataById(id)

    local linkItem = self:getLinkTempLateById(id)
    if linkItem == nil then
        return nil
    end
    local linkTable = {}
    for i = 1, 5 do
        local triggerStr = "trigger" .. i       --出发条件

        local trigger = linkItem[triggerStr]
        local isTrigger = self:getIsTrigger(trigger)
        if isTrigger == true then
            local linkItemTable = {}
            local nameStr = "linkname" .. i
            local name = linkItem[nameStr]

            local textStr = "linktext" .. i
            local text = linkItem[textStr]

            local linkStr = "link" .. i
            local link = linkItem[linkStr]

            local strType = "type"..tostring(i)
            local typeId = linkItem[strType]

            linkItemTable.name = name
            linkItemTable.text = text
            linkItemTable.link = link
            linkItemTable.trigger = trigger
            linkItemTable.typeId = typeId
            table.insert(linkTable, linkItemTable)
        end
    end
    return linkTable
end

--根据英雄资源名字获取人物图片node
function SoldierTemplate:getBigImageByResName(pictureName, heroId)
    print("SoldierTemplate:getBigImageByResName==========>pictureName=" .. pictureName)

    getDataManager():getResourceData():loadHeroImageDataById(pictureName)

    local tempName = pictureName
    local heroType  = string.sub(tempName, 1, 4)

    if heroType == "hero" then
        tempName = pictureName
        -- local tempId = string.sub(tempName,6,10)

        if heroId ~= 0 and heroId ~= nil then

            return self:getHeroBigImageById(heroId)
        else
            local tempId = string.sub(tempName,6,10)

            heroType  = string.sub(tempName, 1, 5)
            if heroType == "hero1" or heroType == "hero2" or heroType == "hero3" then
                tempId = string.sub(tempName,7,11)
            else
                heroType = "hero"
            end

            print("tempId===22===".. tempId)

           return self:getHeroBigImageById2(tempId, heroType)
        end
    end
    tempName = pictureName
    local stageType = string.sub(tempName,1,5)
    if stageType == "stage" then
        local len = string.len(pictureName)
        local startPos = len - 4
        tempName = pictureName

        local res = string.sub(tempName, 1, startPos)

        return self:getMonsterBigImage(res)
    end
    --worldboss_1_all
    local stageType = string.sub(tempName,1,9)
    if stageType == "worldboss" then
        --worldboss_1_1
        local len = string.len(pictureName)
        local startPos = len - 4
        tempName = pictureName

        local res = string.sub(tempName, 1, startPos)
        return self:getMonsterBigImage(res)
    end
end

function SoldierTemplate:changeUnparaImage(heroSprite, heroId)
    local finalUrlA = "#hero_" .. heroId .. "_1.png"
    local finalUrl = "#hero_" .. heroId .. "_2.png"
    local finalUrlB = "#hero_" .. heroId .. "_3.png"

    game.setSpriteFrame(heroSprite, finalUrl)
    local effectA = game.newSprite(finalUrlA)
    local effectB = game.newSprite(finalUrlB)

    if effectA ~= nil then
        effectA:setPosition(CONFIG_CARD_EFFECTA_X, CONFIG_CARD_EFFECTA_Y)
        heroSprite:addChild(effectA, 1)
        effectA:setTag(1)
    end

    if effectB ~= nil then
        effectB:setPosition(CONFIG_CARD_EFFECTB_X, CONFIG_CARD_EFFECTB_Y)
        heroSprite:addChild(effectB, -1)
        effectA:setTag(2)
    end
end

-- --获得hero大图
-- 不需要突破等级
function SoldierTemplate:getHeroBigImageById2(heroId, heroType)
    local finalUrlA = "#"..heroType.."_" .. heroId .. "_1.png"
    local finalUrl = "#"..heroType.."_" .. heroId .. "_2.png"
    local finalUrlB = "#"..heroType.."_" .. heroId .. "_3.png"

    -- local resFrame = "hero_" .. heroId .. "_all"
    -- getDataManager():getResourceData():loadHeroImageDataById(resFrame)
    print("----SoldierTemplate:getHeroBigImageById2-----")
    print(finalUrlA)
    print(finalUrl)
    print(finalUrlB)

    local hero = game.newSprite(finalUrl)
    if hero == nil then

        cclog("ERROR: can not find res by ==" .. finalUrl)
    end

    local effectA = game.newSprite(finalUrlA)
    local effectB = game.newSprite(finalUrlB)
    -- getDataManager():getResourceData():removeHeroImageDataById(resFrame)
    if effectA ~= nil then
        effectA:setPosition(CONFIG_CARD_EFFECTA_X, CONFIG_CARD_EFFECTA_Y)
        hero:addChild(effectA, 1)
        effectA:setTag(1)
    end

    if effectB ~= nil then
        effectB:setPosition(CONFIG_CARD_EFFECTB_X, CONFIG_CARD_EFFECTB_Y)
        hero:addChild(effectB, -1)
        effectA:setTag(2)
    end

    if hero then
        hero:setScale(1.2)
    end

    return hero
end


--根据突破等级获得武将大图
function SoldierTemplate:getHeroBigImageById(id, break_level)
    print("--------------------------------")
    local soldierTemplateItem = self:getHeroTempLateById(id)
    if soldierTemplateItem == nil then
        return
    end
    local _breakLevel = getDataManager():getSoldierData():getSoldierBreakLV(id)

    if break_level ~= nil then
       _breakLevel = break_level
        print("突破等级：".._breakLevel)
    end

    local resPicture = nil
    if _breakLevel < 3 or _breakLevel == nil  then
        resPicture = soldierTemplateItem.resPicture  -- 0 1 2
    elseif _breakLevel < 5 then
        resPicture = soldierTemplateItem.resPicture2 -- 3 4
    elseif _breakLevel < 7 then
        resPicture = soldierTemplateItem.resPicture3 -- 5 6
    else
        resPicture = soldierTemplateItem.resPicture4 -- 7
    end

    local resStr = self.c_ResourceTemplate:getPathNameById(resPicture)
    print("resStr"..resStr)
    getDataManager():getResourceData():loadHeroImageDataById(resStr)
    print("resStr"..resStr)

    local __resPath2 = string.gsub(resStr, "_all", "_2.png")
    local __resPath1 = string.gsub(resStr, "_all", "_1.png")
    local __resPath3 = string.gsub(resStr, "_all", "_3.png")

    -- local finalUrlA = "#hero_" .. heroId .. "_1.png"
    -- local finalUrl = "#hero_" .. heroId .. "_2.png"
    -- local finalUrlB = "#hero_" .. heroId .. "_3.png"

    local finalUrlA = "#"..__resPath1
    local finalUrl = "#"..__resPath2
    local finalUrlB = "#"..__resPath3


    local hero = game.newSprite(finalUrl)
    if hero == nil then

        cclog("ERROR: can not find res by ==" .. finalUrl)
    end

    local effectA = game.newSprite(finalUrlA)
    local effectB = game.newSprite(finalUrlB)
    -- getDataManager():getResourceData():removeHeroImageDataById(resFrame)
    if effectA ~= nil then
        effectA:setPosition(CONFIG_CARD_EFFECTA_X, CONFIG_CARD_EFFECTA_Y)
        hero:addChild(effectA, 1)
        effectA:setTag(1)
    end

    if effectB ~= nil then
        effectB:setPosition(CONFIG_CARD_EFFECTB_X, CONFIG_CARD_EFFECTB_Y)
        hero:addChild(effectB, -1)
        effectB:setTag(2)
    end

    if hero then
        hero:setScale(1.2)
    end
    print("--------------------------------")

    return hero
end


--获取世界boss大图
function SoldierTemplate:getWorldBossImage(monster_id)
    local resIcon = monster_config[monster_id].res
    local resStr = self.c_ResourceTemplate:getResourceById(resIcon)
    local resStr2 = string.gsub(resStr, "png", "plist")
    game.addSpriteFramesWithFile("res/card/" .. resStr2)
    local __resPath2 = string.gsub(resStr, "_all", "_2")
    local hero = game.newSprite("#" .. __resPath2)
    return hero
end

--获得monster大图
function SoldierTemplate:getMonsterBigImage(res)
    print("怪物大图 =============== ", res)

    local finalUrlA = "#" .. res .. "_1.png"
    local finalUrl = "#" .. res .. "_2.png"
    local finalUrlB = "#" .. res .. "_3.png"

    local hero = game.newSprite(finalUrl)
    if hero == nil then
        cclog("ERROR: can not find res by ==" .. finalUrl)
    end

    -- local effectA = game.newSprite(finalUrlA)
    -- local effectB = game.newSprite(finalUrlB)

    -- if effectA ~= nil then
    --     print("aaaaaaaaaaa")
    --     effectA:setPosition(CONFIG_CARD_EFFECTA_X, CONFIG_CARD_EFFECTA_Y)
    --     hero:addChild(effectA, 1)
    -- end

    -- if effectB ~= nil then
    --     print("bbbbbbbbbbb")
    --     effectB:setPosition(CONFIG_CARD_EFFECTB_X, CONFIG_CARD_EFFECTB_Y)
    --     hero:addChild(effectB, -1)
    -- end

    -- local frame = game.newSpriteFrame(string.sub(filename, 2))
--             if frame then
--                 sprite = cc.Sprite:createWithSpriteFrame(frame)
--             else
--                 sprite = cc.Sprite:create()
--             end
    local frameA = game.newSpriteFrame(res .. "_1.png")
    if frameA then
        local effectA = cc.Sprite:createWithSpriteFrame(frameA)
        local effectSize = effectA:getContentSize()
        effectA:setPosition(effectSize.width / 2, effectSize.height / 2)
        hero:addChild(effectA, 1)
        effectA:setTag(1)
    end

    local frameB = game.newSpriteFrame(res .. "_3.png")
    if frameB then
        local effectB = cc.Sprite:createWithSpriteFrame(frameB)
        local effectSize = effectB:getContentSize()
        effectB:setPosition(effectSize.width / 2, effectSize.height / 2)
        hero:addChild(effectB, -1)
        effectB:setTag(2)
    end
    return hero
end

--获得武将icon名称
function SoldierTemplate:getSoldierIcon(id)
    cclog("getSoldierIcon===="..id)
    local resStr = nil
    if id == 0 then
        local resIcon = 1100011
        resStr = self.c_ResourceTemplate:getResourceById(resIcon)
    else
        print("id====", id)
        local soldierTemplateItem = self:getHeroTempLateById(id)
        local resIcon = soldierTemplateItem.resIcon
        resStr = self.c_ResourceTemplate:getResourceById(resIcon)
        -- local fianlRes = "#" .. resStr
    end
    return resStr
end
--获得武将头像
function SoldierTemplate:getSoldierHead(id)
    cclog("getSoldierHead===="..id)
    local resStr = nil
    if id == 0 then
        local playerIcon = 1100341
        resStr = self.c_ResourceTemplate:getResourceById(playerIcon)
    else
        print("id====", id)
        local soldierTemplateItem = self:getHeroTempLateById(id)
        local playerIcon = soldierTemplateItem.playerIcon
        resStr = self.c_ResourceTemplate:getResourceById(playerIcon)
        -- local fianlRes = "#" .. resStr
    end
    return resStr
end

--获得武将icon名称
function SoldierTemplate:getMonsterIcon(monster_id)
    cclog("monster===="..monster_id)
    local resIcon = monster_config[monster_id].icon
    local resStr = self.c_ResourceTemplate:getResourceById(resIcon)
    -- local fianlRes = "#" .. resStr
    return resStr, monster_config[monster_id].quality
end

--获得武将大图名称
function SoldierTemplate:getSoldierImageName(id)
    -- local soldierTemplateItem = self:getHeroTempLateById(id)
    -- local resPicture = soldierTemplateItem.resPicture
    -- local resStr = self.c_ResourceTemplate:getResourceById(resPicture)
    -- -- local fianlRes = "#" .. resStr
    -- return resStr
    local soldierTemplateItem = self:getHeroTempLateById(id)
    local level = getDataManager():getSoldierData():getSoldierBreakLV(id)
    print("突破等级："..level)
    local resPicture = nil
    if level < 3 or level == nil then
        resPicture = soldierTemplateItem.resPicture  -- 0 1 2
    elseif level < 5 then
        resPicture = soldierTemplateItem.resPicture2 -- 3 4
    elseif level < 7 then
        resPicture = soldierTemplateItem.resPicture3 -- 5 6
    else
        resPicture = soldierTemplateItem.resPicture4 -- 7
    end
    local resStr = self.c_ResourceTemplate:getPathNameById(resPicture)

    getDataManager():getResourceData():loadHeroImageDataById(resStr)

    local frameImg = string.gsub(resStr, "all", "2.png", 1)

    return resStr, frameImg
end

--获得大图名称
function SoldierTemplate:getHeroImageName(id)

    local soldierTemplateItem = self:getHeroTempLateById(id)
    local level = getDataManager():getSoldierData():getSoldierBreakLV(id)
    print("突破等级："..level)
    local resPicture = nil
    if level < 3 or level == nil then
        resPicture = soldierTemplateItem.resPicture  -- 0 1 2
    elseif level < 5 then
        resPicture = soldierTemplateItem.resPicture2 -- 3 4
    elseif level < 7 then
        resPicture = soldierTemplateItem.resPicture3 -- 5 6
    else
        resPicture = soldierTemplateItem.resPicture4 -- 7
    end
    local resStr = self.c_ResourceTemplate:getPathNameById(resPicture)
    getDataManager():getResourceData():loadHeroImageDataById(resStr)

     local frameImg = string.gsub(resStr, "all", "2.png", 1)

    return resStr, frameImg
end

--获得是否有羁绊
function SoldierTemplate:getIsTrigger(trigger)
    local size = table.getn(trigger)
    if size == 0 then
        return false
    end
    for k, v in pairs(trigger) do
        if v == 0 then
            return false
        end
    end
    return true
end

--获得怪物大图名称
function SoldierTemplate:getMonsterImageName(id)
    local item = self:getMonsterTempLateById(id)
    local res = item.res
    local resStr = self.c_ResourceTemplate:getPathNameById(res)
    --local fianlRes = "#" .. resStr
    return resStr
end

--获取是否存在羁绊by index（1-5）
function SoldierTemplate:getIsTriggerByIndex(linkId, index)
    local linkItem = self:getLinkTempLateById(linkId)
    if linkItem ~= nil then
        local triggerStr = "trigger" .. index       --出发条件

        local trigger = linkItem[triggerStr]
        local isTrigger = self:getIsTrigger(trigger)
        return isTrigger,trigger
    else
        return nil
    end
end

--获得英雄最大可突破等级
function SoldierTemplate:getMaxBreakLv(soldierId)
    local item = self:getBreakupTempLateById(soldierId)
    print("SoldierTemplate:getMaxBreakLv")
    -- table.print(item)
    print("SoldierTemplate:getMaxBreakLv")
    local tempIndex = 0
    for k = 1, 7 do
        local breakStr = "break" .. k
        if item[breakStr] == 0 then
            return tempIndex
        end
        tempIndex = tempIndex + 1
    end
    return tempIndex
end

--根据等级获取武将经验
function SoldierTemplate:getHeroExpByLevel(level)
    local _level = level
    if _level <=0 then
        return 0
    end

    return hero_exp_config[level].exp
end

--根据经验返回能到达的等级
function SoldierTemplate:getLevelByExpAll(expAll)
    local countExp = 0
    local level = 0
    for i=1, 200 do
        local v = hero_exp_config[i]
        expAll = expAll - v.exp
        if expAll < 0 then --
            level = v.level
            return level, (expAll+v.exp)
        elseif expAll == 0 then
            level = v.level + 1
            return level, 0
        end
    end
end


--获得武将的总经验
function SoldierTemplate:getHeroAllExpByLevel(level)
    local _level = level
    if _level <=0 then
        return 0
    end

    local hero_exp = 0
    for i=1, _level do
        hero_exp = hero_exp + hero_exp_config[i].exp
    end

    return hero_exp
end

function SoldierTemplate:getMonsterTempLateById(monsterId)
     local item = monster_config[monsterId]
    if item == nil then
        cclog("ERROR:can not find MonsterTempLate by id=" .. monsterId)
    end
    return item
end

--获得英雄基本数据
function SoldierTemplate:getHeroTempLateById(soldierId)
    local item = hero_config[soldierId]
    if item == nil then
        cclog("ERROR:can not find HeroTempLate by id=" .. soldierId)
    end
    return item
end

--获得武将职业typeId
function SoldierTemplate:getHeroTypeId(soldierId)
    local item = hero_config[soldierId]
    if item == nil then
        cclog("ERROR:can not find HeroTempLate by id=" .. soldierId)
    end
    return item.job
end

-- 获取武将名称
function SoldierTemplate:getHeroName(hero_no)

    local  _hero = hero_config[hero_no]
    if nil == _hero then
        print("ERROR:cannot find SoldierTemplate by hero_no===" .. hero_no)
        return string.format( Localize.query("soldierTemp.1") )
    end
    local heroName = getTemplateManager():getLanguageTemplate():getLanguageById(_hero.nameStr)
    if nil == heroName then
        print("ERROR:cannot find getLanguageById by _hero.nameStr===" .. _hero.nameStr)
        return string.format( Localize.query("soldierTemp.1") )
    end

    return heroName
end

function SoldierTemplate:getDescribe(hero_no)
    local  _hero = hero_config[hero_no].describeStr
    return getTemplateManager():getLanguageTemplate():getLanguageById(_hero)
end

-- 获取武将兑换的武魂数量
function SoldierTemplate:getSoulNum(hero_no)
     local  heroItem = self:getHeroTempLateById(hero_no)
    if nil == heroItem then
        return 0
    end

    local soulNum = 0
    for k,v in pairs(heroItem.sacrificeGain["3"]) do
        soulNum = v
        return soulNum
    end

    return 0
end

function SoldierTemplate:getChipSoulNum(hero_chip_no)
    local chipItem = chip_config[hero_chip_no]
    local soulNum = chipItem.sacrificeGain["3"][1]
    return soulNum
end

-- 获取将领对应的resIcon编号
function SoldierTemplate:getResIconNo(hero_no)
    local  _hero = hero_config[hero_no]
    if nil == _hero then
        return 0
    end

    return _hero.resIcon
end

-- 获得将领头像Icon
function SoldierTemplate:getHeroHeadIcon(hero_no)
    local resIconNo = self:getResIconNo(hero_no)

     local headIcon = getTemplateManager():getResourceTemplate():getResourceById(resIconNo)

    return headIcon
end

-- 获取武将品质
function SoldierTemplate:getHeroQuality(hero_no)
    --10070126
    --10026
    local _hero
    if hero_no > 99999 then    --怪物
        _hero = monster_config[hero_no]
    else
        _hero = hero_config[hero_no]
    end

    if nil == _hero then
        return 0
    end

    return _hero.quality
end

-- 获取武将卡牌颜色
function SoldierTemplate:getHeroHeadIconColor(hero_no)
    local quality = self:getHeroQuality(hero_no)

    return self:getHeroHeadIconColorByQ(quality)
end
--根据资源id获取英雄的品质
function SoldierTemplate:getHeroQualityByResId(resid)
    for k,v in pairs(hero_config) do
        if v.resPicture == resid then
            cclog("---------v.quality------"..v.quality)
            return v.quality
        end
    end
    cclog("----没有找到改资源英雄id--------")
    return 0
end
-- 根据品质获取卡牌颜色
function SoldierTemplate:getHeroHeadIconColorByQ(quality)
    -- 绿、蓝3星、蓝4星、紫5星、紫6星
    if 2 == quality then
        return "ui_common_frameg.png"
    elseif 3 == quality and 4 == quality then
        return "ui_common_framebu.png"
    elseif 5 == quality and 6 == quality then
        return "ui_common_framep.png"
    end

    return "ui_common_kuang.png"
end

--获得技能基本数据
function SoldierTemplate:getSkillTempLateById(skillId)

    local data = skill_config[skillId]
    if data == nil then
        cclog("ERROR:can not find SkillTempLate by id=" .. skillId)
    end
    return data
end

--获得技能buff基本数据
function SoldierTemplate:getSkillBuffTempLateById(buffId)
    local data = skill_buff_config[buffId]
    if data == nil then
        cclog("ERROR:can not find SkillBuffTempLate by id=" .. buffId)
    end

    return data
end

--获得技能buff简单描述
function SoldierTemplate:getSkillBuffInfo(skillBuffId)
    local info = ""
    local item = self:getSkillBuffTempLateById(skillBuffId)
    local effectName = self:getSkillBuffEffectName(item.effectId)
    local value = item.valueEffect
    info = effectName .. " + " .. value
    return info
end

function SoldierTemplate:getSkillBuffEffectName(effectId)
    local key = "skillbuff."..tostring(effectId)
    return Localize.query(key)
end

--获得武将突破列表
function SoldierTemplate:getBreakupTempLateById(heroId)
    local data = hero_config[heroId]
    if data == nil then
        cclog("ERROR:can not find BreakupTempLate by id=" .. heroId)
    end
    return data
end

--获得武将突破系数
function SoldierTemplate:getBreakupAttrTemplateById(heroId)
    local data = hero_breakup_attr_config[heroId]
    if data == nil then
        cclog("ERROR:can not find BreakupAttrTempLate by id=" .. heroId)
    end
    return data
end

--获得武将碎片
function SoldierTemplate:getChipTempLateById(chipId)
    local data = chip_config[chipId]
    if data == nil then
        cclog("ERROR:can not find ChipTempLate by id=" .. chipId)
    end
    return data
end

--根据武将id获得羁绊数据
function SoldierTemplate:getLinkTempLateById(soldierId)

    -- local data = getDataBaseHelper():queryTable("link_config", "id="..soldierId)
    -- table.print(data)
     data = link_config[soldierId]
    if data == nil then
        cclog("ERROR:can not find LinkTempLate by id=" .. soldierId)
    end
    return data
end

--根据羁绊id获得羁绊数据
function SoldierTemplate:getLinkById(link_id)

    -- local data = getDataBaseHelper():queryTable("link_config", "id="..soldierId)
    -- table.print(data)
     data = link_config[link_id]
    if data == nil then
        cclog("ERROR:can not find LinkTempLate by id=" .. link_id)
    end
    return data
end

--board
--获得英雄底板(战斗)
function SoldierTemplate:getHeroBoardById(hero_no)
    local quality = self:getHeroQuality(hero_no)
    local bgSprite = cc.Sprite:create()

    if quality == 1 or quality == 2 then
        game.setSpriteFrame(bgSprite, "#c_board1.png")
    elseif quality == 3 or quality == 4 then
        game.setSpriteFrame(bgSprite, "#c_board2.png")
    elseif quality == 5 or quality == 6 then
        game.setSpriteFrame(bgSprite, "#c_board3.png")
    end
    return bgSprite
end

--获得英雄职业(战斗)
function SoldierTemplate:getHeroKindById(hero_no)
    local heroItem = nil
    if hero_no > 99999 then    --怪物
        heroItem = monster_config[hero_no]
    else
        heroItem =  self:getHeroTempLateById(hero_no)
    end

    local bgSprite = cc.Sprite:create()

    if heroItem.job == 1 then
        game.setSpriteFrame(bgSprite, "#c_kind1.png")
    elseif heroItem.job == 2 then
        game.setSpriteFrame(bgSprite, "#c_kind3.png")
    elseif heroItem.job == 3 then
        game.setSpriteFrame(bgSprite, "#c_kind2.png")
    elseif heroItem.job == 4 then
        game.setSpriteFrame(bgSprite, "#c_kind4.png")
    else
        game.setSpriteFrame(bgSprite, "#c_kind5.png")
    end
    return bgSprite
end

--=============== 武将觉醒相关 ===============--

--武将觉醒相关  获取武将变身的id
function SoldierTemplate:getSoldierChangeInfo(heroId)
    local awakeHeroId = hero_config[heroId].awakeHeroID
    if awakeHeroId ~= nil and awakeHeroId ~= 0 then
        return awakeHeroId
    end
end


--武将觉醒相关  获取武将变身需要的战斗力
function SoldierTemplate:getChangeNeedPower(heroId, curPower)
    local nextPower = 0
    local ratio = 0
    local awakeDict = hero_config[heroId].awake
    local keys = table.keys(awakeDict)

    local function mySort(item1, item2)
        return tonumber(item1) < tonumber(item2)
    end

    table.sort(keys, mySort)

    for k, v in pairs(keys) do
        if curPower <= tonumber(v) then
            nextPower = tonumber(v)
            break
        else
            nextPower = tonumber(v)
        end
    end

    if awakeDict ~= nil then
        for k,v in pairs(awakeDict) do
            if nextPower == tonumber(k) then
                ratio = v
            end
        end
    end
    return nextPower, ratio
end

--根据穴道ID返回模板的具体数据
function SoldierTemplate:getSealTemplateById(id)
    return seal_config[id]
end

--
function SoldierTemplate:getFirstSealId()
    return 1001001
end

function SoldierTemplate:getNextSealId(id)
    return seal_config[id].next
end

--得到当前穴位的显示位置
function SoldierTemplate:getSealPos(id)
    return cc.p(seal_config[id]["coordinate"][1], seal_config[id]["coordinate"][2])
end

--得到当前穴位的显示比例
function SoldierTemplate:getSealScale(id)
    return seal_config[id]["ratio"]
end

--脉数
function SoldierTemplate:getPulse(id)
    if id == 0 then return 0 end
    return seal_config[id].pulse
end
--穴位序列
function SoldierTemplate:getAcupoint(id)
    if id == 0 then return 0 end
    return seal_config[id].acupoint
end

--得到穴位列表
function SoldierTemplate:getSealConfigTable()
    return seal_config
end

function SoldierTemplate:getAllMai(id)

    local all = self:getAllInt(id)         --总排序
    local acu = self:getAcupoint(id)       --穴位排序
    local pulase = self:getPulse(id)       --脉数
    local step = self:getStep(id)
    local p1,p2 = self:getPulaseTwo(step)
    local m1 = self:getMaiNum(p1)
    local m2 = self:getMaiNum(p2)
    local n1 = self:getMaiName(p1)
    local n2 = self:getMaiName(p2)

    local isA1 = false
    local isA2 = false

    local isNum1 = 0
    local isNum2 = 0


    if step == 1 then
        if all == acu then
            if acu == self:getMaiNum(p1) then
                isA1 = true
                isNum1 = acu
            else
                isA1 = false
                isNum1 = acu
            end
        else
            isA1 = true
            isNum1 = self:getMaiNum(p1)

            if acu == self:getMaiNum(p1) + self:getMaiNum(p2) then
                isA2 = true
                isNum2 = self:getMaiNum(p2)
            else
                isA2 = false
                isNum2 = acu
            end
        end
    end
    if step == 2 or step == 3 or step == 4 then

        -- print("===========================")
        -- print(acu)
        -- print(all)

        -- print(self:getMaiNum(1) + self:getMaiNum(2) + self:getMaiNum(p1))
        local a = 0
        local b = 0
        if step == 2 then
            a = self:getMaiNum(1) + self:getMaiNum(2) + self:getMaiNum(p1)
            b = self:getMaiNum(1) + self:getMaiNum(2) + self:getMaiNum(p1) + self:getMaiNum(p2)
        end
        if step == 3 then
            a = self:getMaiNum(1) + self:getMaiNum(2) + self:getMaiNum(3) + self:getMaiNum(4) + self:getMaiNum(p1)
            b = self:getMaiNum(1) + self:getMaiNum(2) + self:getMaiNum(3) + self:getMaiNum(4) + self:getMaiNum(p1) + self:getMaiNum(p2)
        end
        if step == 4 then
            a = self:getMaiNum(1) + self:getMaiNum(2) + self:getMaiNum(3) + self:getMaiNum(4) + self:getMaiNum(5) + self:getMaiNum(6) + self:getMaiNum(p1)
            b = self:getMaiNum(1) + self:getMaiNum(2) + self:getMaiNum(3) + self:getMaiNum(4) + self:getMaiNum(5) + self:getMaiNum(6) + self:getMaiNum(p1) + self:getMaiNum(p2)
        end

        if all >= a then
            isA1 = true
            isNum1 = self:getMaiNum(p1)   --self:getMaiNum(p2)
            if all == b then
                isA2 = true
                isNum2 = self:getMaiNum(p2)
            else
                isA2 = false
                isNum2 = acu
            end
        else
            isA1 = false
            isNum1 = acu
            -- print("===========================")
            -- print(acu)
            -- print(self:getMaiNum(1))
            -- print(self:getMaiNum(2))
            -- print(isNum1)
            isA2 = false
            isNum2 = 0
        end

    end



    return n1,n2,isA1,isA2,isNum1,isNum2   --脉1名字，脉2名字   ，脉1是否全部突破，脉2是否全部突破，  脉1突破数量， 脉2突破数量
end

function SoldierTemplate:getPulaseTwo(step)

    if step == 1 then return 1,2 end
    if step == 2 then return 3,4 end
    if step == 3 then return 5,6 end
    if step == 4 then return 7,8 end
end

-- 脉有多少个穴位
function SoldierTemplate:getMaiNum(pulase)
    local id = 1001001
    local num = 0
    while id ~= 0 do
        if self:getPulse(id) == pulase then
            num = num +1
        end
        id = self:getNextSealId(id)
    end
    return num
end

function SoldierTemplate:getMaiName(pulase)
    local str = ""
    if pulase == 1 then
        str = string.format("%s", Localize.query("soldierChain.1"))
    elseif pulase == 2 then
        str = string.format("%s",Localize.query("soldierChain.2"))
    elseif pulase == 3 then
        str = string.format("%s",Localize.query("soldierChain.3"))
    elseif pulase == 4 then
        str = string.format("%s",Localize.query("soldierChain.4"))
    elseif pulase == 5 then
        str = string.format("%s",Localize.query("soldierChain.5"))
    elseif pulase == 6 then
        str = string.format("%s",Localize.query("soldierChain.6"))
    elseif pulase == 7 then
        str = string.format("%s",Localize.query("soldierChain.7"))
    elseif pulase == 8 then
        str = string.format("%s",Localize.query("soldierChain.8") )
    end
    return str
end

-- 炼体属性
function SoldierTemplate:getAllAttribute(id)
    local refAttTable = {}
    refAttTable["hp"] = 0
    refAttTable["atk"] = 0
    refAttTable["physicalDef"] = 0
    refAttTable["magicDef"] = 0
    refAttTable["hit"] = 0
    refAttTable["dodge"] = 0
    refAttTable["cri"] = 0
    refAttTable["criCoeff"] = 0
    refAttTable["criDedCoeff"] = 0
    refAttTable["block"] = 0
    refAttTable["ductility"] = 0
    for k,v in pairs(seal_config) do
        if v.id <= id then
            if v.hp ~= 0 then refAttTable.hp = refAttTable.hp + v.hp
            elseif v.atk ~= 0 then refAttTable.atk = refAttTable.atk + v.atk
            elseif v.physicalDef ~= 0 then refAttTable.physicalDef = refAttTable.physicalDef + v.physicalDef
            elseif v.magicDef ~= 0 then refAttTable.magicDef = refAttTable.magicDef + v.magicDef
            elseif v.hit ~= 0 then refAttTable.hit = refAttTable.hit + v.hit
            elseif v.dodge ~= 0 then refAttTable.dodge = refAttTable.dodge + v.dodge
            elseif v.cri ~= 0 then refAttTable.cri = refAttTable.cri + v.cri
            elseif v.criCoeff ~= 0 then refAttTable.criCoeff = refAttTable.criCoeff + v.criCoeff
            elseif v.criDedCoeff ~= 0 then refAttTable.criDedCoeff = refAttTable.criDedCoeff + v.criDedCoeff
            elseif v.block ~= 0 then refAttTable.block = refAttTable.block + v.block
            elseif v.ductility ~= 0 then refAttTable.ductility = refAttTable.ductility + v.ductility
            end
        end
    end
    return refAttTable
end

function SoldierTemplate:getCurrSealAtt( id )
    local v = seal_config[id]
    if v.hp ~= 0 then return 1, v.hp
    elseif v.atk ~= 0 then return 2, v.atk
    elseif v.physicalDef ~= 0 then return 3, v.physicalDef
    elseif v.magicDef ~= 0 then return 4, v.magicDef
    elseif v.hit ~= 0 then return 5, v.hit
    elseif v.dodge ~= 0 then return 6, v.dodge
    elseif v.cri ~= 0 then return 7, v.cri
    elseif v.ductility ~= 0 then return 8, v.ductility
    elseif v.criCoeff ~= 0 then return 9, v.criCoeff
    elseif v.criDedCoeff ~= 0 then return 10, v.criDedCoeff
    elseif v.block ~= 0 then return 11, v.block
    end
end


function SoldierTemplate:getLastSealId(id)
    if id == 1001001 then return 0
    else
        for k,v in pairs(seal_config) do
            if v.next == id then return v.id end
        end
    end
    return "@@@@@@"
end

-- self.heroTemp:getStep(id)
-- 返回穴位等级
function SoldierTemplate:getStep(id)

    for k,v in pairs(seal_config) do
        if v.id == id then return v.step end
    end
    return 0
end
-- 返回穴位总次序
function SoldierTemplate:getAllInt(id)

    for k,v in pairs(seal_config) do
        if v.id == id then return v.allInt end
    end
    return 0
end

function SoldierTemplate:getFirstIdByPluse(pluse)--得到某个穴位的起始ID
    for k,v in pairs(seal_config) do
        if v.pulse == pluse and v.acupoint == 1 then
            return v.id
        end
    end
    return 0
end

--============= 怪物组配置表相关 =============--

--怪物组数据获取
function SoldierTemplate:getMonsterGroup(monsterGroupId)
    return monster_group_config[monsterGroupId]
end

--获取boss怪物的id
function SoldierTemplate:getMonsIdFromGroup(monsterGroupId)
    return monster_group_config[monsterGroupId].pos5
end

--根据幸运id获取武将相关信息
function SoldierTemplate:getLuckyInfoById(id)
    return lucky_hero_config[id]
end

return SoldierTemplate

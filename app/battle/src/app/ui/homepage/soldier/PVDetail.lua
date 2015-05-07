--英雄属性滑动页面
local PVDetail = class("PVDetail", function()
    return game.newLayer()
end)

function PVDetail:ctor(id)
    --self.UISoldierAttributeScroll = {}
    self.detailTable = {}
    local proxy = cc.CCBProxy:create()
    local node = CCBReaderLoad("soldier/ui_soldier_attribute_scroll.ccbi", proxy, self.detailTable)
    self:addChild(node)
    self:initView()
    self.c_SoldierTemplate = getTemplateManager():getSoldierTemplate()
    self.c_LanguageTemplate = getTemplateManager():getLanguageTemplate()
end

--初始化变量
function PVDetail:initView()
    self.sizeLayer = self.detailTable["UISoldierAttributeScroll"]["sizeLayer"]
    self.skillLabelA = self.detailTable["UISoldierAttributeScroll"]["skillLabelA"]
    self.skillLabelB = self.detailTable["UISoldierAttributeScroll"]["skillLabelB"]
    self.skillLabelDescA = self.detailTable["UISoldierAttributeScroll"]["skillLabelDescA"]
    self.skillLabelDescB = self.detailTable["UISoldierAttributeScroll"]["skillLabelDescB"]

    self.linkLabelA = self.detailTable["UISoldierAttributeScroll"]["linkLabelA"]
    self.linkLabelB = self.detailTable["UISoldierAttributeScroll"]["linkLabelB"]
    self.linkLabelC = self.detailTable["UISoldierAttributeScroll"]["linkLabelC"]
    self.linkLabelD = self.detailTable["UISoldierAttributeScroll"]["linkLabelD"]
    self.linkLabelE = self.detailTable["UISoldierAttributeScroll"]["linkLabelE"]

    self.linkLabelDescA = self.detailTable["UISoldierAttributeScroll"]["linkLabelDescA"]
    self.linkLabelDescB = self.detailTable["UISoldierAttributeScroll"]["linkLabelDescB"]
    self.linkLabelDescC = self.detailTable["UISoldierAttributeScroll"]["linkLabelDescC"]
    self.linkLabelDescD = self.detailTable["UISoldierAttributeScroll"]["linkLabelDescD"]
    self.linkLabelDescE = self.detailTable["UISoldierAttributeScroll"]["linkLabelDescE"]

    self.breakLabelA = self.detailTable["UISoldierAttributeScroll"]["breakLabelA"]
    self.breakLabelB = self.detailTable["UISoldierAttributeScroll"]["breakLabelB"]
    self.breakLabelC = self.detailTable["UISoldierAttributeScroll"]["breakLabelC"]
    self.breakLabelD = self.detailTable["UISoldierAttributeScroll"]["breakLabelD"]
    self.breakLabelE = self.detailTable["UISoldierAttributeScroll"]["breakLabelE"]
    self.breakLabelF = self.detailTable["UISoldierAttributeScroll"]["breakLabelF"]
    self.breakLabelG = self.detailTable["UISoldierAttributeScroll"]["breakLabelG"]

    self.breakLabelDescA = self.detailTable["UISoldierAttributeScroll"]["breakLabelDescA"]
    self.breakLabelDescB = self.detailTable["UISoldierAttributeScroll"]["breakLabelDescB"]
    self.breakLabelDescC = self.detailTable["UISoldierAttributeScroll"]["breakLabelDescC"]
    self.breakLabelDescD = self.detailTable["UISoldierAttributeScroll"]["breakLabelDescD"]
    self.breakLabelDescE = self.detailTable["UISoldierAttributeScroll"]["breakLabelDescE"]
    self.breakLabelDescF = self.detailTable["UISoldierAttributeScroll"]["breakLabelDescF"]
    self.breakLabelDescG = self.detailTable["UISoldierAttributeScroll"]["breakLabelDescG"]

    self.soldierDescLabel = self.detailTable["UISoldierAttributeScroll"]["soldierDescLabel"]
    self.descSizeLayer = self.detailTable["UISoldierAttributeScroll"]["descSizeLayer"]
    local skillDescSizeLayer = self.detailTable["UISoldierAttributeScroll"]["skillDescSizeLayer"]

    self.soldierDescLabel:setDimensions(self.descSizeLayer:getContentSize().width, self.descSizeLayer:getContentSize().height)

    self.skillLabelDescA:setDimensions(skillDescSizeLayer:getContentSize().width, skillDescSizeLayer:getContentSize().height)
    self.skillLabelDescB:setDimensions(skillDescSizeLayer:getContentSize().width, skillDescSizeLayer:getContentSize().height)
end

function PVDetail:updateView(soldierDataItem)
    local soldierId = soldierDataItem.hero_no
     --更新技能
     print("soldierId======" .. soldierId)

    local soliderItem = self.c_SoldierTemplate:getHeroTempLateById(soldierId)
    local normalSkill = soliderItem.normalSkill --普通技能
    local rageSkill = soliderItem.rageSkill  --怒气技能

    --普通技能
    local normalSkillItem = self.c_SoldierTemplate:getSkillTempLateById(normalSkill)
    local normalName = normalSkillItem.name
    local normalDescribe = normalSkillItem.describe

    print("normalName======" .. normalName)
    print("normalDescribe=====" .. normalDescribe)
    local nameLanguage = self.c_LanguageTemplate:getLanguageById(normalName)
    local describeLanguage = self.c_LanguageTemplate:getLanguageById(normalDescribe)
    self.skillLabelA:setString(nameLanguage)
    self.skillLabelDescA:setString(describeLanguage)

    --怒气技能
    local rageSkillItem = self.c_SoldierTemplate:getSkillTempLateById(rageSkill)
    local rageName = rageSkillItem.name
    local rageDescribe = rageSkillItem.describe


    nameLanguage = self.c_LanguageTemplate:getLanguageById(rageName)
    describeLanguage = self.c_LanguageTemplate:getLanguageById(rageDescribe)
    self.skillLabelB:setString(nameLanguage)
    self.skillLabelDescB:setString(describeLanguage)

    --更新羁绊
    self:updateLinkView(soldierId)
    --更新技能突破
    
    self:updateBreakView(soldierId)

    --更新简介
    local heroItem = self.c_SoldierTemplate:getHeroTempLateById(soldierId)
    local describeStr = heroItem.describeStr
    local describeLanguage = self.c_LanguageTemplate:getLanguageById(describeStr)
    self.soldierDescLabel:setString(describeLanguage)
end

--更新突破技能
function PVDetail:updateBreakView(soldierId)
    local breakItem = self.c_SoldierTemplate:getBreakupTempLateById(soldierId)
    --break1
    local breakId = breakItem["break1"]
    if breakId ~= 0 then
        local skillItem = self.c_SoldierTemplate:getSkillTempLateById(breakId) --突破技能item
        local name = skillItem.name
        local describe = skillItem.describe

        local nameLanguage = self.c_LanguageTemplate:getLanguageById(name)
        local describeLanguage = self.c_LanguageTemplate:getLanguageById(describe)
        self.breakLabelDescA:setString(describeLanguage)

        self.breakLabelDescA:setVisible(true)
        self.breakLabelA:setVisible(true)
    else
        self.breakLabelA:setVisible(false)
        self.breakLabelDescA:setVisible(false)
    end

    --break1
    breakId = breakItem["break2"]
    if breakId ~= 0 then
        local skillItem = self.c_SoldierTemplate:getSkillTempLateById(breakId) --突破技能item
        local name = skillItem.name
        local describe = skillItem.describe

        local nameLanguage = self.c_LanguageTemplate:getLanguageById(name)
        local describeLanguage = self.c_LanguageTemplate:getLanguageById(describe)
        self.breakLabelDescB:setString(describeLanguage)

        self.breakLabelDescB:setVisible(true)
        self.breakLabelB:setVisible(true)
    else
        self.breakLabelB:setVisible(false)
        self.breakLabelDescB:setVisible(false)
    end

    --break1
    local breakId = breakItem["break3"]
    if breakId ~= 0 then
        local skillItem = self.c_SoldierTemplate:getSkillTempLateById(breakId) --突破技能item
        local name = skillItem.name
        local describe = skillItem.describe

        local nameLanguage = self.c_LanguageTemplate:getLanguageById(name)
        local describeLanguage = self.c_LanguageTemplate:getLanguageById(describe)
        self.breakLabelDescC:setString(describeLanguage)
        
        self.breakLabelDescC:setVisible(true)
        self.breakLabelC:setVisible(true)
    else
        self.breakLabelC:setVisible(false)
        self.breakLabelDescC:setVisible(false)
    end

    --break1
    local breakId = breakItem["break4"]
    if breakId ~= 0 then
        local skillItem = self.c_SoldierTemplate:getSkillTempLateById(breakId) --突破技能item
        local name = skillItem.name
        local describe = skillItem.describe

        local nameLanguage = self.c_LanguageTemplate:getLanguageById(name)
        local describeLanguage = self.c_LanguageTemplate:getLanguageById(describe)
        self.breakLabelDescD:setString(describeLanguage)
       
        self.breakLabelDescD:setVisible(true)
        self.breakLabelD:setVisible(true)
    else
        self.breakLabelD:setVisible(false)
        self.breakLabelDescD:setVisible(false)
    end

    --break1
    local breakId = breakItem["break5"]
    if breakId ~= 0 then
        local skillItem = self.c_SoldierTemplate:getSkillTempLateById(breakId) --突破技能item
        local name = skillItem.name
        local describe = skillItem.describe

        local nameLanguage = self.c_LanguageTemplate:getLanguageById(name)
        local describeLanguage = self.c_LanguageTemplate:getLanguageById(describe)
        self.breakLabelDescE:setString(describeLanguage)
       
        self.breakLabelDescE:setVisible(true)
        self.breakLabelE:setVisible(true)
    else
        self.breakLabelE:setVisible(false)
        self.breakLabelDescE:setVisible(false)
    end

    --break1
    local breakId = breakItem["break6"]
    if breakId ~= 0 then
        local skillItem = self.c_SoldierTemplate:getSkillTempLateById(breakId) --突破技能item
        local name = skillItem.name
        local describe = skillItem.describe

        local nameLanguage = self.c_LanguageTemplate:getLanguageById(name)
        local describeLanguage = self.c_LanguageTemplate:getLanguageById(describe)
        self.breakLabelDescF:setString(describeLanguage)
       
        self.breakLabelDescF:setVisible(true)
        self.breakLabelF:setVisible(true)
    else
        self.breakLabelF:setVisible(false)
        self.breakLabelDescF:setVisible(false)
    end

    --break1
    local breakId = breakItem["break7"]
    if breakId ~= 0 then
        local skillItem = self.c_SoldierTemplate:getSkillTempLateById(breakId) --突破技能item
        local name = skillItem.name
        local describe = skillItem.describe

        local nameLanguage = self.c_LanguageTemplate:getLanguageById(name)
        local describeLanguage = self.c_LanguageTemplate:getLanguageById(describe)
        self.breakLabelDescG:setString(describeLanguage)
        
        self.breakLabelDescG:setVisible(true)
        self.breakLabelG:setVisible(true)
    else
        self.breakLabelG:setVisible(false)
        self.breakLabelDescG:setVisible(false)
    end

end

--更新羁绊界面
function PVDetail:updateLinkView(soldierId)
    local linkItem = self.c_SoldierTemplate:getLinkTempLateById(soldierId)

    if self.c_SoldierTemplate:getIsTriggerByIndex(soldierId, 1) then --说明存在羁绊1
        local name1 = linkItem["name1"]
        local text1 = linkItem["text1"]
        local nameLanguage1 = self.c_LanguageTemplate:getLanguageById(name1)
        local textLanguage1 = self.c_LanguageTemplate:getLanguageById(text1)

        self.linkLabelA:setVisible(true)
        self.linkLabelDescA:setVisible(true)
        self.linkLabelA:setString(nameLanguage1)
        self.linkLabelDescA:setString(textLanguage1)
    else
        self.linkLabelA:setVisible(false)
        self.linkLabelDescA:setVisible(false)
    end

    if self.c_SoldierTemplate:getIsTriggerByIndex(soldierId, 2) then --说明存在羁绊2
        local name2 = linkItem["name2"]
        local text2 = linkItem["text2"]
        local nameLanguage2 = self.c_LanguageTemplate:getLanguageById(name2)
        local textLanguage2 = self.c_LanguageTemplate:getLanguageById(text2)
        self.linkLabelB:setString(nameLanguage2)
        self.linkLabelDescB:setString(textLanguage2)

        self.linkLabelB:setVisible(true)
        self.linkLabelDescB:setVisible(true)
    else
        self.linkLabelB:setVisible(false)
        self.linkLabelDescB:setVisible(false)
    end

    if self.c_SoldierTemplate:getIsTriggerByIndex(soldierId, 3) then --说明存在羁绊3
        local name3 = linkItem["name3"]
        local text3 = linkItem["text3"]

        local nameLanguage3 = self.c_LanguageTemplate:getLanguageById(name3)
        local textLanguage3 = self.c_LanguageTemplate:getLanguageById(text3)
        self.linkLabelC:setString(nameLanguage3)
        self.linkLabelDescC:setString(textLanguage3)
        self.linkLabelC:setVisible(true)
        self.linkLabelDescC:setVisible(true)
    else
        self.linkLabelC:setVisible(false)
        self.linkLabelDescC:setVisible(false)
    end

    if self.c_SoldierTemplate:getIsTriggerByIndex(soldierId, 4) then --说明存在羁绊4
        local name4 = linkItem["name4"]
        local text4 = linkItem["text4"]
        local nameLanguage4 = self.c_LanguageTemplate:getLanguageById(name4)
        local textLanguage4 = self.c_LanguageTemplate:getLanguageById(text4)
        self.linkLabelD:setString(nameLanguage4)
        self.linkLabelDescD:setString(textLanguage4)
        self.linkLabelD:setVisible(true)
        self.linkLabelDescD:setVisible(true)
    else
        self.linkLabelD:setVisible(false)
        self.linkLabelDescD:setVisible(false)
    end

    if self.c_SoldierTemplate:getIsTriggerByIndex(soldierId, 5) then --说明存在羁绊5
        local name5 = linkItem["name5"]
        local text5 = linkItem["text5"]
        local nameLanguage5 = self.c_LanguageTemplate:getLanguageById(name5)
        local textLanguage5 = self.c_LanguageTemplate:getLanguageById(text5)
        self.linkLabelE:setString(nameLanguage5)
        self.linkLabelDescE:setString(textLanguage5)
        self.linkLabelE:setVisible(true)
        self.linkLabelDescE:setVisible(true)
    else
        self.linkLabelE:setVisible(false)
        self.linkLabelDescE:setVisible(false)
    end

end

function PVDetail:getLayerSize()
    return self.sizeLayer:getContentSize()
end

return PVDetail

--武将升级详细页面
local PVSoldierBreakSuccessDetail = class("PVSoldierBreakSuccessDetail", BaseUIView)

function PVSoldierBreakSuccessDetail:ctor(id)
    PVSoldierBreakSuccessDetail.super.ctor(self, id)
end
function PVSoldierBreakSuccessDetail:onMVCEnter()
    self.UISoldierBreakSuccessDetail = {}
    self:initTouchListener()
    self:loadCCBI("soldier/ui_soldier_break_Success_detail.ccbi", self.UISoldierBreakSuccessDetail)
    self.c_SodierData = getDataManager():getSoldierData()
    self.c_SoldierTemplate = getTemplateManager():getSoldierTemplate()
    self.c_Calculation = getCalculationManager():getCalculation()

    self.c_LanguageTemplate = getTemplateManager():getLanguageTemplate()
    self.c_ResourceTemplate = getTemplateManager():getResourceTemplate()
    self.c_CommonData = getDataManager():getCommonData()
    self.stageData = getDataManager():getStageData()

    self:initView()
    self:updateData()

end



function PVSoldierBreakSuccessDetail:initTouchListener()
    local function backMenuClick()
        getAudioManager():playEffectButton2()
        self:onHideView()
    end

    self.UISoldierBreakSuccessDetail["UISoldierBreakSuccessDetail"] = {}
    self.UISoldierBreakSuccessDetail["UISoldierBreakSuccessDetail"]["backMenuClick"] = backMenuClick

end

function PVSoldierBreakSuccessDetail:initView()
    self.heroNode = self.UISoldierBreakSuccessDetail["UISoldierBreakSuccessDetail"]["heroNode"]
    self.breakType = self.UISoldierBreakSuccessDetail["UISoldierBreakSuccessDetail"]["breakType"]
    self.detailLabel = self.UISoldierBreakSuccessDetail["UISoldierBreakSuccessDetail"]["detailLabel"]
    self.heroName1 = self.UISoldierBreakSuccessDetail["UISoldierBreakSuccessDetail"]["heroName1"]
    self.heroName2 = self.UISoldierBreakSuccessDetail["UISoldierBreakSuccessDetail"]["heroName2"]
    self.breakLvBg1 = self.UISoldierBreakSuccessDetail["UISoldierBreakSuccessDetail"]["breakLvBg1"]
    self.breakLvBg2 = self.UISoldierBreakSuccessDetail["UISoldierBreakSuccessDetail"]["breakLvBg2"]

    self.atkLabel1 = self.UISoldierBreakSuccessDetail["UISoldierBreakSuccessDetail"]["atkLabel1"]
    self.pdefLabel1 = self.UISoldierBreakSuccessDetail["UISoldierBreakSuccessDetail"]["physicalDefLabel1"]
    self.hpLabel1 = self.UISoldierBreakSuccessDetail["UISoldierBreakSuccessDetail"]["hpLabel1"]
    self.mdefLabel1 = self.UISoldierBreakSuccessDetail["UISoldierBreakSuccessDetail"]["magicDefLabel1"]

    self.atkLabel2 = self.UISoldierBreakSuccessDetail["UISoldierBreakSuccessDetail"]["atkLabel2"]
    self.pdefLabel2 = self.UISoldierBreakSuccessDetail["UISoldierBreakSuccessDetail"]["physicalDefLabel2"]
    self.hpLabel2 = self.UISoldierBreakSuccessDetail["UISoldierBreakSuccessDetail"]["hpLabel2"]
    self.mdefLabel2 = self.UISoldierBreakSuccessDetail["UISoldierBreakSuccessDetail"]["magicDefLabel2"]

    self.addAtkLabel = self.UISoldierBreakSuccessDetail["UISoldierBreakSuccessDetail"]["addAtkLabel"]
    self.addPdefLabel = self.UISoldierBreakSuccessDetail["UISoldierBreakSuccessDetail"]["addPdefLabel"]
    self.addHpLabel = self.UISoldierBreakSuccessDetail["UISoldierBreakSuccessDetail"]["addHpLabel"]
    self.addMdefLabel = self.UISoldierBreakSuccessDetail["UISoldierBreakSuccessDetail"]["addMdefLabel"]
    
end

function PVSoldierBreakSuccessDetail:updateSoldierImage()
    local soldierId = self.soldierDataItem.hero_no
    addHeroHDSpriteFrame(soldierId)
    --更新英雄大图
    self.heroNode:removeAllChildren()
    local heroImageNode = self.c_SoldierTemplate:getHeroBigImageById(soldierId)
    heroImageNode:setScale(1.5)
    self.heroNode:addChild(heroImageNode)
end

function PVSoldierBreakSuccessDetail:updateData()
    soldierId = self:getTransferData()[1]
    print("soldierId", soldierId)
    if soldierId ~= nil then
        self.soldierDataItem = self.c_SodierData:getSoldierDataById(soldierId)

        self.soldierId = self.soldierDataItem.hero_no
        -- 武将名
        local _name = self.c_SoldierTemplate:getHeroName(self.soldierId)
        self.heroName1:setString(_name)
        self.heroName2:setString(_name)
        local soldierTemplateItem = self.c_SoldierTemplate:getHeroTempLateById(self.soldierId)
        local quality = soldierTemplateItem.quality
        local color = ui.COLOR_GREEN
        if quality == 1 or quality == 2 then
            color = ui.COLOR_GREEN
        elseif quality == 3 or quality == 4 then
            color = ui.COLOR_BLUE
        elseif quality == 5 or quality == 6 then
            color = ui.COLOR_PURPLE
        end
        self.heroName1:setColor(color)
        self.heroName2:setColor(color)
        -- 突破等级
        local break_level = self.soldierDataItem.break_level
        print("--------break_level--------",break_level)
        if break_level <= 1 then 
            self.breakLvBg1:setVisible(false)
            local strImg = "ui_lineup_number"..tostring(break_level)..".png"
            self.breakLvBg2:setSpriteFrame(strImg)
            self.breakLvBg2:setVisible(true)
        else
            local strImg1 = "ui_lineup_number"..tostring(break_level - 1)..".png"
            local strImg2 = "ui_lineup_number"..tostring(break_level)..".png"
            self.breakLvBg1:setSpriteFrame(strImg1)
            self.breakLvBg2:setSpriteFrame(strImg2)
            self.breakLvBg1:setVisible(true)
            self.breakLvBg2:setVisible(true)
        end

        local item = self.c_SoldierTemplate:getBreakupTempLateById(soldierId)
        local breakStr = "break" .. break_level
        local breakId = item[breakStr]

        local skillItem = self.c_SoldierTemplate:getSkillTempLateById(breakId)
        -- print("--------skillItem-------")
        -- table.print(skillItem)
        -- local skillTitle = skillItem.describe
        local skillDesc = skillItem.describe
        local describeLanguage = self.c_LanguageTemplate:getLanguageById(skillDesc)
        self.detailLabel:setString(describeLanguage)

        self:updateSoldierImage()
        self:updateAttributeView()
    end    
end



--更新属性
function PVSoldierBreakSuccessDetail:updateAttributeView()
    local soldierTemplateItem = self.c_SoldierTemplate:getHeroTempLateById(self.soldierId)

    self.soldierDataItem.break_level = self.soldierDataItem.break_level - 1
    local attr = self.c_Calculation:SoldierSelfAttr(self.soldierDataItem)
    self.soldierDataItem.break_level = self.soldierDataItem.break_level + 1
    self.atkLabel1:setString(string.format(roundAttriNum(attr.atkHero)))
    self.pdefLabel1:setString(string.format(roundAttriNum(attr.physicalDefHero)))
    self.hpLabel1:setString(string.format(roundAttriNum(attr.hpHero)))
    self.mdefLabel1:setString(string.format(roundAttriNum(attr.magicDefHero)))
   
    local attr_next = self.c_Calculation:SoldierSelfAttr(self.soldierDataItem)
    self.atkLabel2:setString(string.format(roundAttriNum(attr_next.atkHero)))
    self.pdefLabel2:setString(string.format(roundAttriNum(attr_next.physicalDefHero)))
    self.hpLabel2:setString(string.format(roundAttriNum(attr_next.hpHero)))
    self.mdefLabel2:setString(string.format(roundAttriNum(attr_next.magicDefHero)))

    self.addAtkLabel:setString("+ " .. string.format(roundAttriNum(attr_next.atkHero - attr.atkHero)))
    self.addPdefLabel:setString("+ " .. string.format(roundAttriNum(attr_next.physicalDefHero - attr.physicalDefHero)))
    self.addHpLabel:setString("+ " .. string.format(roundAttriNum(attr_next.hpHero - attr.hpHero)))
    self.addMdefLabel:setString("+ " .. string.format(roundAttriNum(attr_next.magicDefHero - attr.magicDefHero)))

end



return PVSoldierBreakSuccessDetail

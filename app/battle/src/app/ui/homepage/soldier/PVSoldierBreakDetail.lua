--英雄突破详细页面
local PVSoldierBreakDetail = class("PVSoldierBreakDetail", BaseUIView)

function PVSoldierBreakDetail:ctor(id)
    PVSoldierBreakDetail.super.ctor(self, id)

    SOLDIER_BREAK_POINT_X = 200
    SOLDIER_BREAK_POINT_Y = 622.4  -- 200 517
    SOLDIER_BREAK_POINT_X_2 = 230
    SOLDIER_BREAK_POINT_Y_2 = 360

    self.c_SoldierNet = getNetManager():getSoldierNet()
    self.c_Calculation = getCalculationManager():getCalculation()
    self.c_SoldierData = getDataManager():getSoldierData()
    self.c_SoldierTemplate = getTemplateManager():getSoldierTemplate()
    self.c_CommonData = getDataManager():getCommonData()

    self.c_BagTemplate = getTemplateManager():getBagTemplate()
    self.chipTemp = getTemplateManager():getChipTemplate()
    self.bagData = getDataManager():getBagData()
    self.c_LanguageTemplate = getTemplateManager():getLanguageTemplate()
    self.c_CommonData = getDataManager():getCommonData()
end

function PVSoldierBreakDetail:onMVCEnter()
    self.isCanBeBreak = true  --是否可以突破
    --self.isAnimation = false
    self.break_type = 1 -- 只需要碎片突破
    self.UISoldierBreakDetail = {}
    self.starTable  = {}
    self:initTouchListener()
    self:regeisterNetCallBack()
    self.MAX_BREAK_LEVEL = nil --最大突破等级
    self:loadCCBI("soldier/ui_soldier_break.ccbi", self.UISoldierBreakDetail)

    self.soldierId = self:getTransferData()[1]
    self:initView()

    self:updateData()
end

--注册网络回调
function PVSoldierBreakDetail:regeisterNetCallBack()

-- required CommonResponse res = 1;
--     optional GameResourcesResponse consume = 2;
--     optional int32 break_level = 3;
    local function callBack()
        -- self.breakMenu:setEnabled(true)
        self:updateOtherView()
        self:updateNeedItem()
        
        self:showBreakSuccessAni()
        self:updateHeroView()

        self:updatePowerView()
        --战力提升
        self.c_CommonData.updateCombatPower()
        -- getOtherModule():showAlertDialog(nil, Localize.query("soldier.11"))
        --
        local function setTouchedInAni()
            --self.isAnimation = false
            print("remove ShieldLayer")
            self:removeTopShieldLayer()
        end
        if (getNewGManager():getCurrentGid() == GuideId.G_GUIDE_40007) then
            local seq = cc.Sequence:create(cc.DelayTime:create(0.1), cc.CallFunc:create(setTouchedInAni))
            self:runAction(seq)
        end

        groupCallBack(GuideGroupKey.BTN_CLICK_TUPO)   -- 点击突破
        getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSoldierBreakSuccessDetail", self.soldierDataItem.hero_no)
    end

    local function onBreakCallBack(id, data)
        local res = data.res
        local result = res.result

        if result == true then
            -- print("response wujiang tu po")
            -- print(data.break_level)
            local soldierId = self.soldierDataItem.hero_no
            self.break_level = data.break_level
            self.c_SoldierData:changeSoldierBreakLV(soldierId, self.break_level)
            getDataManager():getLineupData():changeSoldierBreakLV(soldierId, self.break_level)
            getDataManager():getLineupData():changeCheerSoldierBreakLV(soldierId, self.break_level)


            if self.leftEffect then
                local node = nil
                if self.break_type == 1 then
                    node = UI_Wujiangtupojiaqiangzhongjian()
                else
                    node = UI_Wujiangtupojiaqiangzuomian()
                end
                self.animationNode:addChild(node)
            end
            if self.rightEffect then
                local node = UI_Wujiangtupojiaqiangyoumian()
                self.animationNode:addChild(node)
            end

            
            local node2 = UI_Wujiangtupojiaqianghoubanbufen(callBack)
            -- local node2 = UI_Wujiangtupojiaqiangxin(callBack)
            self.animationNode:addChild(node2)

            self.breakMenu:setEnabled(false)

            --self.isAnimation = true
            print("getCurrentGid ",getNewGManager():getCurrentGid())
            
            if (getNewGManager():getCurrentGid() == GuideId.G_GUIDE_40007) then
                print("addChild ShieldLayer")
                self:createTopShieldLayer()
            end
        else
            getOtherModule():showAlertDialog(nil, Localize.query("soldier.12"))

            groupCallBack(GuideGroupKey.BTN_CLICK_TUPO)   -- 点击突破
        end

    end

    self:registerMsg(NET_ID_HERO_BREAK, onBreakCallBack)
end

--突破成功特效
function PVSoldierBreakDetail:showBreakSuccessAni()
    local function callBack()
        print("showBreakSuccessAni______callBack")
    end
    -- local node = UI_Wujiangtupo(callBack)
    -- self:addChild(node)
end

function PVSoldierBreakDetail:initTouchListener()
    local function backMenuClick()
        getAudioManager():playEffectButton2()

        -- stepCallBack(G_GUIDE_40104)   -- 点击guanbi
        groupCallBack(GuideGroupKey.BTN_CLOSE_TUPO)  --点击关闭

        self:onHideView()
    end

    local function onBreakClick()
        getAudioManager():playEffectButton2()
        local soldierId = self.soldierDataItem.hero_no

        -- stepCallBack(G_GUIDE_40103)   -- 点击突破
        
        if self.isCanBeBreak == false then
            print("---------------error,item not enougth")
            -- self:toastShow(self.tips)
            getOtherModule():showAlertDialog(nil, self.tips)
            groupCallBack(GuideGroupKey.BTN_CLICK_TUPO)   -- 点击突破
            return
        end

        -- self.c_SoldierData:getPatchNumById(itemId)
        self.c_SoldierNet:sendBreakSoldierMsg(soldierId)
    end

    --突破使用道具查看
    local function itemMenuClicikA()
        if self.itemId ~= nil then
            getOtherModule():showOtherView("PVCommonDetail", 1, self.itemId, 2)
        end
    end
    --突破使用武将碎片查看
    local function itemMenuClicikB()
        if self.chipId ~= nil then
            local nowPatchNum = self.c_SoldierData:getPatchNumById(self.chipId)
            getOtherModule():showOtherView("PVCommonChipDetail", 1, self.chipId, nowPatchNum)
        end
    end

    self.UISoldierBreakDetail["UISoldierBreakDetail"] = {}
    self.UISoldierBreakDetail["UISoldierBreakDetail"]["backMenuClick"] = backMenuClick
    self.UISoldierBreakDetail["UISoldierBreakDetail"]["onBreakClick"] = onBreakClick
    self.UISoldierBreakDetail["UISoldierBreakDetail"]["itemMenuClicikA"] = itemMenuClicikA
    self.UISoldierBreakDetail["UISoldierBreakDetail"]["itemMenuClicikB"] = itemMenuClicikB
end

--检测是否能突破
function PVSoldierBreakDetail:checkIsCanBeBreak()
end

function PVSoldierBreakDetail:updateData()
    --突破所使用的物品
    self.itemId = nil
    self.chipId = nil
    -- local index = self:getTransferData()[1]
    if self.soldierId ~= nil then
        self.soldierDataItem = self.c_SoldierData:getSoldierDataById(self.soldierId)
        -- print("---------self.soldierDataItem--------")
        -- table.print(self.soldierDataItem)
        local quality = self.c_SoldierTemplate:getHeroQuality(self.soldierId)
        local level = self.soldierDataItem.level
        updateStarLV(self.starTable, quality) --更新星级
        local levelNode = getLevelNode(level)
        self.levelNumLabel:addChild(levelNode)

        -- self.soldierDataItem = self.c_SoldierData:getSoldierItemByIndex(index)
        self.break_level = self.soldierDataItem.break_level
        local soldierId = self.soldierDataItem.hero_no
        -- 武将职业
        local jobId = self.c_SoldierTemplate:getHeroTypeId(soldierId)
        local _spriteJob = nil
        print("----jobId-----",jobId)
        if jobId == 1 then
            _spriteJob = "ui_comNew_kind_001.png"
        elseif jobId == 2 then
            _spriteJob = "ui_comNew_kind_002.png"
        elseif jobId == 3 then
            _spriteJob = "ui_comNew_kind_003.png"
        elseif jobId == 4 then
            _spriteJob = "ui_comNew_kind_004.png"
        elseif jobId == 5 then
            _spriteJob = "ui_comNew_kind_005.png"
        end
        self.typeSprite:setSpriteFrame(_spriteJob)
        -- 突破等级
        local break_level = self.soldierDataItem.break_level
        print("----------break_level--------",break_level)
        if break_level == 0 then 
            self.img_leftNum:setVisible(false)
        else
            local strImg = "ui_lineup_number"..tostring(break_level)..".png"
            self.img_leftNum:setSpriteFrame(strImg)
            self.img_leftNum:setVisible(true)
        end

        self.MAX_BREAK_LEVEL = self.c_SoldierTemplate:getMaxBreakLv(soldierId)

        self:updateHeroView()
        self:updateOtherView()
        self:updateNeedItem()
        self:updatePowerView()
    end
end

function PVSoldierBreakDetail:updateHeroView()
    local soldierId = self.soldierDataItem.hero_no
    local soldierTemplateItem = self.c_SoldierTemplate:getHeroTempLateById(soldierId)

    local nameStr = soldierTemplateItem.nameStr

    local level = self.soldierDataItem.level
    local break_level = self.soldierDataItem.break_level
    local quality = soldierTemplateItem.quality

    --self.levelBMLabel:setString(string.format(level))      --更新等级
    --更新一部分ui
    --更新image
    -- addHeroHDSpriteFrame(soldierId)
    self.playerSpriteA:removeAllChildren()
    self.playerSpriteB:removeAllChildren()

    print("--getHeroBigImageById---")
    print(soldierId)
    print(level)

    nodeA = self.c_SoldierTemplate:getHeroBigImageById(soldierId, break_level)
    nodeB = self.c_SoldierTemplate:getHeroBigImageById(soldierId, break_level+1)
    self.playerSpriteA:addChild(nodeA, 100)
    nodeA:setPosition(self.playerSpriteA:getContentSize().width / 2, self.playerSpriteA:getContentSize().height / 2)
    nodeA:setScale(1)
    self.playerSpriteB:addChild(nodeB, 101)
    nodeB:setPosition(self.playerSpriteB:getContentSize().width / 2, self.playerSpriteB:getContentSize().height / 2)
    nodeB:setScale(1)
end

function PVSoldierBreakDetail:updateOtherView()
    local soldierId = self.soldierDataItem.hero_no
    local item = self.c_SoldierTemplate:getBreakupTempLateById(soldierId)
    -- print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!", self.break_level, self.MAX_BREAK_LEVEL)
    if self.break_level and self.break_level + 1 > self.MAX_BREAK_LEVEL then     --达到最高突破
        self.tipLabel:setString( Localize.query("soldier.1") )
        return
    end
    local breakStr = "break" .. ( self.break_level + 1 )
    local nextBreakId = item[breakStr]

    local skillItem = self.c_SoldierTemplate:getSkillTempLateById(nextBreakId)
    local skillDesc = skillItem.describe
    local describeLanguage = self.c_LanguageTemplate:getLanguageById(skillDesc)

    local finalSkillDesc = Localize.query("soldier.2") .. describeLanguage
    self.tipLabel:setString(finalSkillDesc)

end

--更新需要的物品
function PVSoldierBreakDetail:updateNeedItem()
    local soldierId = self.soldierDataItem.hero_no
    local item = self.c_SoldierTemplate:getBreakupTempLateById(soldierId)
    --突破消耗
    local resumeStr = "consume" .. (self.break_level + 1)

    local resume = item[resumeStr]
    self.needMoneyBMLabel:setString(string.format(0))
    self.itemId = nil
    self.chipId = nil
    self.needSpriteA:setVisible(false)
    self.needSpriteB:setVisible(false)
    self.needItemNum:setVisible(false)
    self.needChipNum:setVisible(false)
    self.haveItemNum:setVisible(false)
    self.haveChipNum:setVisible(false)

    if self.break_level >= self.MAX_BREAK_LEVEL then return end

    --更新需要的物品
    local menuFlag = true
    self.leftEffect = false
    self.rightEffect = false
    print("--------resume------------",table.nums(resume))
    table.print(resume)
    local _num = table.nums(resume)
    for k,v in pairs(resume) do
        --itemIndex = itemIndex + 1
        local minNum = v[1]
        local maxNum = v[2]
        local itemId = v[3]
        if k == "1" then

            local nowCoin = self.c_CommonData:getCoin()
            if nowCoin < minNum then  --金币不足
                self.isCanBeBreak = false
                self.tips = Localize.query("shop.10")
            end
            self.needMoneyBMLabel:setString(string.format(minNum))
        elseif k == "105" then  --突破丹
            self.rightEffect = true
            
            self.itemMenuA:setVisible(true)
            self.needSpriteA:setVisible(true)
            self.needItemNum:setVisible(true)
            self.haveItemNum:setVisible(true)
            local nowItemNum = self.bagData:getItemNumById(itemId)
            if nowItemNum == nil then
                nowItemNum = 0
            end
            if nowItemNum < minNum then  --突破丹不足
                self.isCanBeBreak = false
                self.haveItemNum:setColor(ui.COLOR_RED)
                self.tips = Localize.query("soldier.6")
            else
                self.haveItemNum:setColor(ui.COLOR_GREEN)
            end
            self.haveItemNum:setString(tostring(nowItemNum))
            self.needItemNum:setString(string.format("/%d", minNum))
            if nowItemNum < minNum then menuFlag = false--self.breakMenu:setEnabled(false)
            --else --[[self.breakMenu:setEnabled(true) ]]
            end
            local bagTempItem = self.c_BagTemplate:getItemById(itemId)
            local quality = bagTempItem.quality
            local resIcon = self.c_BagTemplate:getItemResIcon(itemId)
            self.itemId = itemId
            -- setCardWithFrame(self.needSpriteA, resIcon, quality)
            setItemImage3(self.needSpriteA, resIcon, quality)

        elseif k == "103" then   --武将碎片,左面
            self.leftEffect = true
            self.needSpriteB:setVisible(true)
            self.needChipNum:setVisible(true)
            self.haveChipNum:setVisible(true)
            if _num <= 2 then
                self.itemMenuB:setPosition(cc.p(self.itemMenuB_posx+100,self.itemMenuB_posy-20))
                self.needSpriteB:setPosition(cc.p(self.needSpriteB_posx+100,self.needSpriteB_posy-20))
                self.needChipNum:setPosition(cc.p(self.needChipNum_posx+100,self.needChipNum_posy-20))
                self.haveChipNum:setPosition(cc.p(self.haveChipNum_posx+100,self.haveChipNum_posy-20))
                self.itemMenuA:setVisible(false)
                self.needSpriteA:setVisible(false)
                self.needItemNum:setVisible(false)
                self.haveItemNum:setVisible(false)
                self.break_type = 1
            else
                self.itemMenuB:setPosition(cc.p(self.itemMenuB_posx,self.itemMenuB_posy))
                self.needSpriteB:setPosition(cc.p(self.needSpriteB_posx,self.needSpriteB_posy))
                self.needChipNum:setPosition(cc.p(self.needChipNum_posx,self.needChipNum_posy))
                self.haveChipNum:setPosition(cc.p(self.haveChipNum_posx,self.haveChipNum_posy))
                self.itemMenuA:setVisible(true)
                self.needSpriteA:setVisible(true)
                self.needItemNum:setVisible(true)
                self.haveItemNum:setVisible(true)
                self.break_type = 2 
            end
            local nowPatchNum = self.c_SoldierData:getPatchNumById(itemId)
            if nowPatchNum < minNum then  --当前武将碎片数量不足
                self.isCanBeBreak = false
                self.haveChipNum:setColor(ui.COLOR_RED)
                self.tips = Localize.query("soldier.7")
            else
                self.haveChipNum:setColor(ui.COLOR_GREEN)
            end
            self.haveChipNum:setString(tostring(nowPatchNum))
            self.needChipNum:setString(string.format("/%d", minNum))
            print(nowPatchNum.."======"..minNum)
            if nowPatchNum < minNum then
                menuFlag = false --self.breakMenu:setEnabled(false)
            end
            local patchTempLate = self.c_SoldierTemplate:getChipTempLateById(itemId)
            local combineResult = patchTempLate.combineResult
            local soldierTemplateItem = self.c_SoldierTemplate:getHeroTempLateById(combineResult)
            local quality = soldierTemplateItem.quality
            local resIcon = self.chipTemp:getChipIconById(itemId)
            self.chipId = itemId
            -- changeNewIconImage(self.needSpriteB, resIcon, quality)
            changeHeroChipIcon(self.needSpriteB, resIcon, quality)
        end
        if menuFlag == true then self.breakMenu:setEnabled(true)
        else self.breakMenu:setEnabled(false)
        end
    end
end

--更新攻击力
function PVSoldierBreakDetail:updatePowerView()
    print("--更新攻击力--")

    local soldierId = self.soldierDataItem.hero_no

    --更新突破值
    local level = self.soldierDataItem.level

    local attr = self.c_Calculation:SoldierSelfAttr(self.soldierDataItem)
    self.atkLabelA:setString(string.format(roundAttriNum(attr.atkHero)))
    self.pdefLabelA:setString(string.format(roundAttriNum(attr.physicalDefHero)))
    self.hpLabelA:setString(string.format(roundAttriNum(attr.hpHero)))
    self.mdefLabelA:setString(string.format(roundAttriNum(attr.magicDefHero)))

    local function updateBreakLevelImg(img, level)
        if level == 0 then img:setVisible(false)
        else
            -- print("break level img", level)
            local strImg = "ui_lineup_number"..tostring(level)..".png"
            img:setSpriteFrame(strImg)
            img:setVisible(true)
        end
    end

    if self.break_level >= self.MAX_BREAK_LEVEL then   --如果达到最高等级
        print("--如果达到最高等级--")
        self.nextBreakLayer:setVisible(false)
        self.playerSpriteB:setVisible(false)
        self.breakMenu:setEnabled(false)

        self.playerSpriteA:setPosition(cc.p(SOLDIER_BREAK_POINT_X,SOLDIER_BREAK_POINT_Y))   
        -- self.leftBreakLayer:setPosition(cc.p(SOLDIER_BREAK_POINT_X_2,SOLDIER_BREAK_POINT_Y_2))  -- 200 382

        self.jiantouSp:setVisible(false)
        self.jlNode:setVisible(false)
        self.mjyc_Node:setVisible(false)
        self.atkLabelB:setVisible(false)
        self.pdefLabelB:setVisible(false)
        self.hpLabelB:setVisible(false)
        self.mdefLabelB:setVisible(false)

        -- 显示突破满级属性
        self.breakItem = self.c_SoldierTemplate:getBreakupTempLateById(soldierId)
        self:creatrBreakAttrList()
        -- local finalSkillDesc = Localize.query("soldier.2") .. describeLanguage


        -- self.node1:setPosition(cc.p(self.x1-120,self.y1-20))
        -- self.node2:setPosition(cc.p(self.x2-120,self.y2-20))
        -- self.node3:setPosition(cc.p(self.x3+140,self.y1+54))
        -- self.node4:setPosition(cc.p(self.x4+140,self.y2+54))
    else
        self.nextBreakLayer:setVisible(true)
        self.playerSpriteB:setVisible(true)
        self.breakMenu:setEnabled(true)

        updateBreakLevelImg( self.breakImgNumB, self.break_level+1 )

        self.soldierDataItem.break_level = self.soldierDataItem.break_level + 1
        local attr = self.c_Calculation:SoldierSelfAttr(self.soldierDataItem)
        self.soldierDataItem.break_level = self.soldierDataItem.break_level - 1
        local _attr = self.c_Calculation:SoldierSelfAttr(self.soldierDataItem)
        self.atkLabelB:setString("+" .. string.format(roundAttriNum(attr.atkHero - _attr.atkHero)))
        self.pdefLabelB:setString("+" .. string.format(roundAttriNum(attr.physicalDefHero - _attr.physicalDefHero)))
        self.hpLabelB:setString("+" .. string.format(roundAttriNum(attr.hpHero - _attr.hpHero)))
        self.mdefLabelB:setString("+" .. string.format(roundAttriNum(attr.magicDefHero - _attr.magicDefHero)))
    end

    updateBreakLevelImg( self.breakImgNumA, self.break_level )
     print("--更新攻击力--")

end

function PVSoldierBreakDetail:initView()
    self.animationManager = self.UISoldierBreakDetail["UISoldierBreakDetail"]["mAnimationManager"]

    self.playerSpriteA = self.UISoldierBreakDetail["UISoldierBreakDetail"]["playerSpriteA"]
    self.playerSpriteB = self.UISoldierBreakDetail["UISoldierBreakDetail"]["playerSpriteB"]
    -- self.preNameLayerA = self.UISoldierBreakDetail["UISoldierBreakDetail"]["preNameLayerA"]
    -- self.preNameLayerB = self.UISoldierBreakDetail["UISoldierBreakDetail"]["preNameLayerB"]

    self.atkLabelA = self.UISoldierBreakDetail["UISoldierBreakDetail"]["atkLabelA"]
    self.hpLabelA = self.UISoldierBreakDetail["UISoldierBreakDetail"]["hpLabelA"]
    self.pdefLabelA = self.UISoldierBreakDetail["UISoldierBreakDetail"]["pdefLabelA"]
    self.mdefLabelA = self.UISoldierBreakDetail["UISoldierBreakDetail"]["mdefLabelA"]

    self.atkLabelB = self.UISoldierBreakDetail["UISoldierBreakDetail"]["atkLabelB"]
    self.hpLabelB = self.UISoldierBreakDetail["UISoldierBreakDetail"]["hpLabelB"]
    self.pdefLabelB = self.UISoldierBreakDetail["UISoldierBreakDetail"]["pdefLabelB"]
    self.mdefLabelB = self.UISoldierBreakDetail["UISoldierBreakDetail"]["mdefLabelB"]

    self.tipLayer = self.UISoldierBreakDetail["UISoldierBreakDetail"]["tipLayer"]
    self.tipLabel = self.UISoldierBreakDetail["UISoldierBreakDetail"]["tipLabel"]       --激活天赋
    self.needMoneyBMLabel = self.UISoldierBreakDetail["UISoldierBreakDetail"]["needMoneyBMLabel"]

    --
    self.itemMenuA = self.UISoldierBreakDetail["UISoldierBreakDetail"]["itemMenuA"]
    self.itemMenuB = self.UISoldierBreakDetail["UISoldierBreakDetail"]["itemMenuB"]
    self.needSpriteA = self.UISoldierBreakDetail["UISoldierBreakDetail"]["needSpriteA"]
    self.needSpriteB = self.UISoldierBreakDetail["UISoldierBreakDetail"]["needSpriteB"]

    self.breakLvBgA = self.UISoldierBreakDetail["UISoldierBreakDetail"]["breakLvBgA"]  --突破
    self.breakLvBgB = self.UISoldierBreakDetail["UISoldierBreakDetail"]["breakLvBgB"]
    self.breakImgNumA = self.UISoldierBreakDetail["UISoldierBreakDetail"]["img_leftNum"]
    self.breakImgNumB = self.UISoldierBreakDetail["UISoldierBreakDetail"]["img_rightNum"]

    --
    self.nextBreakLayer = self.UISoldierBreakDetail["UISoldierBreakDetail"]["nextBreakLayer"]
    self.breakMenu = self.UISoldierBreakDetail["UISoldierBreakDetail"]["breakMenu"]

    self.needChipNum = self.UISoldierBreakDetail["UISoldierBreakDetail"]["label_needB"] -- chip
    self.needItemNum = self.UISoldierBreakDetail["UISoldierBreakDetail"]["label_needA"] -- item
    self.haveChipNum = self.UISoldierBreakDetail["UISoldierBreakDetail"]["label_haveB"]
    self.haveItemNum = self.UISoldierBreakDetail["UISoldierBreakDetail"]["label_haveA"]

    self.animationNode = self.UISoldierBreakDetail["UISoldierBreakDetail"]["animationNode"]

    self.leftBreakLayer = self.UISoldierBreakDetail["UISoldierBreakDetail"]["leftBreakLayer"]
    self.jiantouSp = self.UISoldierBreakDetail["UISoldierBreakDetail"]["jiantouSp"]
    self.jlNode = self.UISoldierBreakDetail["UISoldierBreakDetail"]["jlNode"]
    self.levelNumLabel = self.UISoldierBreakDetail["UISoldierBreakDetail"]["levelNumLabel"]
    self.typeSprite = self.UISoldierBreakDetail["UISoldierBreakDetail"]["typeSprite"]
    self.heroNameLabel = self.UISoldierBreakDetail["UISoldierBreakDetail"]["heroNameLabel"]
    self.img_leftNum = self.UISoldierBreakDetail["UISoldierBreakDetail"]["img_leftNum"]
    self.mjyc_Node = self.UISoldierBreakDetail["UISoldierBreakDetail"]["mjyc_Node"]
    self.contentLayer = self.UISoldierBreakDetail["UISoldierBreakDetail"]["contentLayer"]

    local starSelect1 = self.UISoldierBreakDetail["UISoldierBreakDetail"]["starSelect1"]
    local starSelect2 = self.UISoldierBreakDetail["UISoldierBreakDetail"]["starSelect2"]
    local starSelect3 = self.UISoldierBreakDetail["UISoldierBreakDetail"]["starSelect3"]
    local starSelect4 = self.UISoldierBreakDetail["UISoldierBreakDetail"]["starSelect4"]
    local starSelect5 = self.UISoldierBreakDetail["UISoldierBreakDetail"]["starSelect5"]
    local starSelect6 = self.UISoldierBreakDetail["UISoldierBreakDetail"]["starSelect6"]
    table.insert(self.starTable, starSelect1)
    table.insert(self.starTable, starSelect2)
    table.insert(self.starTable, starSelect3)
    table.insert(self.starTable, starSelect4)
    table.insert(self.starTable, starSelect5)
    table.insert(self.starTable, starSelect6)

    self.node1 = self.UISoldierBreakDetail["UISoldierBreakDetail"]["node1"]
    self.node2 = self.UISoldierBreakDetail["UISoldierBreakDetail"]["node2"]
    self.node3 = self.UISoldierBreakDetail["UISoldierBreakDetail"]["node3"]
    self.node4 = self.UISoldierBreakDetail["UISoldierBreakDetail"]["node4"]
    self.x1 = self.node1:getPositionX()
    self.y1 = self.node1:getPositionY()
    self.x2 = self.node2:getPositionX()
    self.y2 = self.node2:getPositionY()
    self.x3 = self.node3:getPositionX()
    self.y3 = self.node3:getPositionY()
    self.x4 = self.node4:getPositionX()
    self.y4 = self.node4:getPositionY()

    self.needSpriteB_posx, self.needSpriteB_posy = self.needSpriteB:getPosition()
    self.itemMenuB_posx, self.itemMenuB_posy = self.itemMenuB:getPosition()
    self.needChipNum_posx, self.needChipNum_posy = self.needChipNum:getPosition()
    self.haveChipNum_posx, self.haveChipNum_posy = self.haveChipNum:getPosition()


    self.itemMenuA:setAllowScale(false)
    self.itemMenuB:setAllowScale(false)
 
    self.tipLabel:setDimensions(self.tipLayer:getContentSize().width, 0)
    local _name = self.c_SoldierTemplate:getHeroName(self.soldierId)
    self.heroNameLabel:setString(_name)

    local soldierTemplateItem = self.c_SoldierTemplate:getHeroTempLateById(self.soldierId)
    -- self.levelNumLabel:setString(tostring(soldierTemplateItem.level))
    local quality = soldierTemplateItem.quality

    local color = ui.COLOR_GREEN
    if quality == 1 or quality == 2 then
        color = ui.COLOR_GREEN
    elseif quality == 3 or quality == 4 then
        color = ui.COLOR_BLUE
    elseif quality == 5 or quality == 6 then
        color = ui.COLOR_PURPLE
    end
    self.heroNameLabel:setColor(color)

end

function PVSoldierBreakDetail:creatrBreakAttrList()
    local function tableCellTouched(tbl, cell)
        print("PVSoldierBreakDetail cell touched at index: " .. cell:getIdx())
    end
    local function numberOfCellsInTableView(tab)
       return tonumber(self.break_level)
    end
    local function cellSizeForTable(tbl, idx)
        -- print("--------self.itemSize.height-------",self.itemSize.height)
        return self.itemSize.height,self.itemSize.width
        -- return 30,600
    end
    local function tableCellAtIndex(tbl, idx)
        local breakStr = "break" .. ( idx + 1 )
        local breakId = self.breakItem[breakStr]
        local skillItem = self.c_SoldierTemplate:getSkillTempLateById(breakId)
        local skillDesc = skillItem.describe
        local describeLanguage = self.c_LanguageTemplate:getLanguageById(skillDesc)
        local _strLen,t = stringLen(describeLanguage)
        local strLen = table.nums(t)
        -- print("---------describeLanguage---------",describeLanguage)
        -- print("---------_strLen---------",table.nums(t))
        local cell = nil
        if nil == cell then
            cell = cc.TableViewCell:new()
            cell.cardinfo = {}
            local proxy = cc.CCBProxy:create()
            cell.cardinfo["UIBreakAttriItem"] = {}
            local node = nil
            if strLen > 25 then
                node = CCBReaderLoad("soldier/ui_soldier_break_Attr2_item.ccbi", proxy, cell.cardinfo)
            else
                node = CCBReaderLoad("soldier/ui_soldier_break_Attr_item.ccbi", proxy, cell.cardinfo)
            end
            cell.itemNode = cell.cardinfo["UIBreakAttriItem"]["itemNode"]
            cell.soldierName = cell.cardinfo["UIBreakAttriItem"]["soldierName"]
            cell.detailLabel = cell.cardinfo["UIBreakAttriItem"]["detailLabel"]
            self.itemSize = cell.itemNode:getContentSize()
            cell:addChild(node)
        end
        local breakDetail = "BreakDetail." .. ( idx + 1 )
        cell.soldierName:setString(Localize.query(breakDetail))
        cell.detailLabel:setString(describeLanguage)
        return cell
    end
    local layerSize = self.contentLayer:getContentSize()
    local tempTable = {}
    local proxy = cc.CCBProxy:create()
    tempTable["UIBreakAttriItem"] = {}
    local item = CCBReaderLoad("soldier/ui_soldier_break_Attr_item.ccbi", proxy, tempTable)
    local itemNode = tempTable["UIBreakAttriItem"]["itemNode"]
    self.itemSize = itemNode:getContentSize()
    self.tableView = cc.TableView:create(layerSize)
    self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.tableView:setDelegate()
    self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.contentLayer:addChild(self.tableView)
    self.tableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.tableView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
    self.tableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)

    local scrBar = PVScrollBar:new()
    scrBar:init(self.tableView,1)
    scrBar:setPosition(cc.p(layerSize.width+13,layerSize.height/2))
    self.contentLayer:addChild(scrBar,2)

    self.tableView:reloadData()
end


return PVSoldierBreakDetail

local PVRunePanel = class("PVRunePanel", BaseUIView)

function PVRunePanel:ctor(id)
    self.super.ctor(self, id)
end

function PVRunePanel:onMVCEnter()
    --加载相关plist文件
    print("onMVCEnter ============= ")
    game.addSpriteFramesWithFile("res/ccb/resource/ui_rune.plist")

    self.c_runeData = getDataManager():getRuneData()
    self.commonData = getDataManager():getCommonData()
    self.c_SoldierData = getDataManager():getSoldierData()
    self.c_LineupData = getDataManager():getLineupData()

    self.c_StoneTemplate = getTemplateManager():getStoneTemplate()
    self.c_ResourceTemplate = getTemplateManager():getResourceTemplate()

    self.c_runeNet = getNetManager():getRuneNet()
    self.c_Calculation = getCalculationManager():getCalculation()

    self:registerDataBack()

    self:initData()
    self:initView()
    self:nodeRegisterTouchEvent()
end

-- 镶嵌后显示属性增加的消息
function PVRunePanel:showMessageAfterAdd()
    local attriStr = ""
    local curSoldierId = self.c_runeData:getCurSoliderId()
    local hero = self.c_SoldierData:getSoldierDataById(curSoldierId)
    print(curSoldierId)
    print(hero)
    print("x++++")
    local attr = self.c_Calculation:RuneAttrByType(hero, self.curRuneType)
    for k,v in pairs(attr) do
        if v > 0 then
            local typeStr = self.c_StoneTemplate:getAttrName(k)
            attriStr = attriStr.. typeStr .. "+" .. round1(v)
        end
    end
    -- getOtherModule():showToastView(attriStr)
    getOtherModule():showAlertDialog(nil, attriStr,10)

end

--网络返回
function PVRunePanel:registerDataBack()
    --符文镶嵌
    local function addRuneCallBack(id, data)
        if data.res.result then
            local runeItem = self.c_runeData:getCurRuneItem()
            runeItem.runt_po = self.curIndex
            self.c_runeData:updateNumById(2, runeItem)
            self:onBackUpdateView("add", runeItem)
            self.c_runeData:setCurRuneItem(nil)
            self:showMessageAfterAdd()

            self.commonData.updateCombatPower()
        end

    end

    self:registerMsg(RUNE_ADD, addRuneCallBack)

    --符文摘除
    local function deleRuneCallBack(id, data)
        local haveCoin = self.commonData:getCoin()
        local changeItem = self.c_runeData:getChangeRune()
        if changeItem ~= nil then
            self.deleteType = changeItem.deleteType
        end
        print("符文摘除 =============== 符文摘除", self.deleteType)
        if data.res.result then
            if self.deleteType ~= nil and self.deleteType == 2 then
                for k,v in pairs(self.curRuneList) do
                    self.c_runeData:updateNumById(1, v)
                end
                self.commonData:setCoin(self.haveCoin - self.totalCostDelete)
                self:onBackUpdateView("delete_all")
                self:initAddRuneMenu()
                --特效删除
                self.effectLayer:removeAllChildren()
                self.effectList = {}
            elseif self.deleteType == 3 then
                local deleteRuneItem = {}
                deleteRuneItem = self:getCurItem(self.curRuneType, self.deleteNo)
                self.c_runeData:updateNumById(1, deleteRuneItem)
                self:onBackUpdateView("delete", deleteRuneItem)
                self.c_runeData:setCurRuneItem(changeItem)
                -- 摘除消耗
                local pickPrice = self.c_StoneTemplate:getPickPriceById(deleteRuneItem.runt_id)
                self.commonData:setCoin(self.haveCoin - pickPrice)
                local curSoldierId = self.c_runeData:getCurSoliderId()
                self.c_runeNet:sendAddRune(curSoldierId, self.curRuneType, changeItem.runePos, changeItem.runt_no)
            else
                local deleteRuneItem = {}

                deleteRuneItem = self:getCurItem(self.curRuneType, self.deleteNo)
                self.c_runeData:updateNumById(1, deleteRuneItem)
                self:onBackUpdateView("delete", deleteRuneItem)
                --摘除消耗
                local pickPrice = self.c_StoneTemplate:getPickPriceById(deleteRuneItem.runt_id)
                self.commonData:setCoin(self.haveCoin - pickPrice)
            end
            self.commonData.updateCombatPower()
        end
    end
    self:registerMsg(RUNE_DELETE, deleRuneCallBack)
end
--根据runt_no获取符文对象
function PVRunePanel:getCurItem(runeType, runtNo)
    for k, v in pairs(self.soldierRunes[runeType]) do
        if v.runt_no == runtNo then
            return v
        end
    end
end


--相关数据初始化
function PVRunePanel:initData()
    self.curIndex = 1
    self.curRuneType = 1
    --当前英雄的id
    self.hero_no = self.funcTable[1]

    self.soldierRunes = self.c_runeData:getSoldierRunes()

    self.soldierRunes = {}
    self.soldierRunes[1] = self.c_runeData:getRunesByType(1)                --生命符文

    self.soldierRunes[2] = self.c_runeData:getRunesByType(2)                --攻击符文

    self.soldierRunes[3] = self.c_runeData:getRunesByType(3)                --物防符文

    self.soldierRunes[4] = self.c_runeData:getRunesByType(4)                --法防符文

    self.curRuneList = self.soldierRunes[1]                                --初始化默认是生命符文

    self.effectList = {}

    self.haveCoin = self.commonData:getCoin()
    --self.mainAttributeList = {}
    --self.mainAttributeList[1] = {}
    --self.mainAttributeList[2] = {}
    --self.mainAttributeList[3] = {}
    --self.mainAttributeList[4] = {}

    --for k, v in pairs(self.soldierRunes) do
        --if self.soldierRunes[k] ~= nil then
            --for m, n in pairs(self.soldierRunes[k]) do
                --self:updateAttribute(1, k, n)
            --end
        --end
    --end

    --self.curAttributeList = self.mainAttributeList[1]


end

--初始化符文特效
function PVRunePanel:initEffectList(runeList)
    local effectList = {}
    if runeList ~= nil then
        for k, v in pairs(runeList) do
            local runePos = v.runt_po                                                   --符文镶嵌位置
            local runeItem = self.c_StoneTemplate:getStoneItemById(v.runt_id)

            if runeItem.quality >= 6 then
                local effecItem = {}
                effecItem.runeNo = v.runt_no
                effecItem.typeValue = runeItem.type
                effecItem.positionX = self.runeSprite[runePos]:getPositionX()
                effecItem.positionY = self.runeSprite[runePos]:getPositionY()
                table.insert(effectList, effecItem)
            end
        end
    end
    return effectList
end

--界面加载以及初始化
function PVRunePanel:initView()
    self.UIRunePanel = {}

    self:initTouchListener()
    self:loadCCBI("rune/ui_rune_panel.ccbi", self.UIRunePanel)

    self.contentLayer = self.UIRunePanel["UIRunePanel"]["contentLayer"]
    self.animationLayer = self.UIRunePanel["UIRunePanel"]["animationLayer"]
    self.effectLayer = self.UIRunePanel["UIRunePanel"]["effectLayer"]
    self.contentScrollView = self.UIRunePanel["UIRunePanel"]["contentScrollView"]

    self.tabNormalImage = {}
    self.tabSelectImage = {}

    self.tabSelectImage[1] = self.UIRunePanel["UIRunePanel"]["lifeSelect"]
    self.tabNormalImage[1] = self.UIRunePanel["UIRunePanel"]["lifeNor"]

    self.tabSelectImage[2] = self.UIRunePanel["UIRunePanel"]["attackSelect"]
    self.tabNormalImage[2] = self.UIRunePanel["UIRunePanel"]["attackNor"]

    self.tabSelectImage[3] = self.UIRunePanel["UIRunePanel"]["phySelect"]
    self.tabNormalImage[3] = self.UIRunePanel["UIRunePanel"]["phyNor"]

    self.tabSelectImage[4] = self.UIRunePanel["UIRunePanel"]["magicSelect"]
    self.tabNormalImage[4] = self.UIRunePanel["UIRunePanel"]["magicNor"]

    self.tabMenu = {}                      --tab标签按钮

    self.menuLife = self.UIRunePanel["UIRunePanel"]["menuLife"]
    self.menuAttack = self.UIRunePanel["UIRunePanel"]["menuAttack"]
    self.menuPhy = self.UIRunePanel["UIRunePanel"]["menuPhy"]
    self.menuMagic = self.UIRunePanel["UIRunePanel"]["menuMagic"]

    table.insert(self.tabMenu, self.menuLife)
    table.insert(self.tabMenu, self.menuAttack)
    table.insert(self.tabMenu, self.menuPhy)
    table.insert(self.tabMenu, self.menuMagic)
    --menu标签页没有缩放效果
    for k,v in pairs(self.tabMenu) do
        v:setAllowScale(false)
    end

    self.runeSprite = {}

    self.runeSprite[1] = self.UIRunePanel["UIRunePanel"]["runeSprite1"]
    self.runeSprite[2] = self.UIRunePanel["UIRunePanel"]["runeSprite2"]
    self.runeSprite[3] = self.UIRunePanel["UIRunePanel"]["runeSprite3"]
    self.runeSprite[4] = self.UIRunePanel["UIRunePanel"]["runeSprite4"]
    self.runeSprite[5] = self.UIRunePanel["UIRunePanel"]["runeSprite5"]
    self.runeSprite[6] = self.UIRunePanel["UIRunePanel"]["runeSprite6"]
    self.runeSprite[7] = self.UIRunePanel["UIRunePanel"]["runeSprite7"]
    self.runeSprite[8] = self.UIRunePanel["UIRunePanel"]["runeSprite8"]
    self.runeSprite[9] = self.UIRunePanel["UIRunePanel"]["runeSprite9"]
    self.runeSprite[10] = self.UIRunePanel["UIRunePanel"]["runeSprite10"]

    self.runeline = {}

    self.runeline[2] = self.UIRunePanel["UIRunePanel"]["runeline2"]
    self.runeline[3] = self.UIRunePanel["UIRunePanel"]["runeline3"]
    self.runeline[4] = self.UIRunePanel["UIRunePanel"]["runeline4"]
    self.runeline[5] = self.UIRunePanel["UIRunePanel"]["runeline5"]
    self.runeline[6] = self.UIRunePanel["UIRunePanel"]["runeline6"]
    self.runeline[7] = self.UIRunePanel["UIRunePanel"]["runeline7"]
    self.runeline[8] = self.UIRunePanel["UIRunePanel"]["runeline8"]
    self.runeline[9] = self.UIRunePanel["UIRunePanel"]["runeline9"]
    self.runeline[10] = self.UIRunePanel["UIRunePanel"]["runeline10"]

    self.runeAdd = {}

    self.runeAdd[1] = self.UIRunePanel["UIRunePanel"]["runeAdd1"]
    self.runeAdd[2] = self.UIRunePanel["UIRunePanel"]["runeAdd2"]
    self.runeAdd[3] = self.UIRunePanel["UIRunePanel"]["runeAdd3"]
    self.runeAdd[4] = self.UIRunePanel["UIRunePanel"]["runeAdd4"]
    self.runeAdd[5] = self.UIRunePanel["UIRunePanel"]["runeAdd5"]
    self.runeAdd[6] = self.UIRunePanel["UIRunePanel"]["runeAdd6"]
    self.runeAdd[7] = self.UIRunePanel["UIRunePanel"]["runeAdd7"]
    self.runeAdd[8] = self.UIRunePanel["UIRunePanel"]["runeAdd8"]
    self.runeAdd[9] = self.UIRunePanel["UIRunePanel"]["runeAdd9"]
    self.runeAdd[10] = self.UIRunePanel["UIRunePanel"]["runeAdd10"]

    self.runeAddMenu = {}

    self.runeAddMenu[1] = self.UIRunePanel["UIRunePanel"]["runeAddMenu1"]
    self.runeAddMenu[2] = self.UIRunePanel["UIRunePanel"]["runeAddMenu2"]
    self.runeAddMenu[3] = self.UIRunePanel["UIRunePanel"]["runeAddMenu3"]
    self.runeAddMenu[4] = self.UIRunePanel["UIRunePanel"]["runeAddMenu4"]
    self.runeAddMenu[5] = self.UIRunePanel["UIRunePanel"]["runeAddMenu5"]
    self.runeAddMenu[6] = self.UIRunePanel["UIRunePanel"]["runeAddMenu6"]
    self.runeAddMenu[7] = self.UIRunePanel["UIRunePanel"]["runeAddMenu7"]
    self.runeAddMenu[8] = self.UIRunePanel["UIRunePanel"]["runeAddMenu8"]
    self.runeAddMenu[9] = self.UIRunePanel["UIRunePanel"]["runeAddMenu9"]
    self.runeAddMenu[10] = self.UIRunePanel["UIRunePanel"]["runeAddMenu10"]

    self.runeBigSprite = self.UIRunePanel["UIRunePanel"]["runeBigSprite"]

    self.attriDesLayer = self.UIRunePanel["UIRunePanel"]["attriDesLayer"]
    self.attributeNode = self.UIRunePanel["UIRunePanel"]["attributeNode"]

    self.deleteAll = self.UIRunePanel["UIRunePanel"]["deleteAll"]

    self.sliverValue = self.UIRunePanel["UIRunePanel"]["sliverValue"]           --全部摘除消耗

    self.headQulityA = self.UIRunePanel["UIRunePanel"]["headQulityA"]           --当前武将头像
    self.soliderName = self.UIRunePanel["UIRunePanel"]["soliderName"]           --当前武将名称

    self.sliverValue:setString(self.totalCostDelete)
    -- self.deleteAll:setEnabled(false)
    self:initAddRuneMenu()

    self.effectList = self:initEffectList(self.curRuneList)
    --默认设置生命标签
    self:updateMenuByIndex(1)
    self:updateTabContent(1)

    self.effectLayer:removeAllChildren()
    -- local node = UI_Fuwentexiao(self.effectList)
    -- node:setPosition(cc.p(0,0))
    -- self.effectLayer:addChild(node)
    for k,v in pairs(self.effectList) do
        local node = UI_Fuwentexiao(self.effectList)
        node:setPosition(cc.p(v.positionX, v.positionY))
        self.effectLayer:addChild(node)
    end

    self.contentScrollView:setTouchEnabled(false)

    local name = getTemplateManager():getSoldierTemplate():getHeroName(self.hero_no)
    local icon = getTemplateManager():getSoldierTemplate():getSoldierIcon(self.hero_no)
    local quality = getTemplateManager():getSoldierTemplate():getHeroQuality(self.hero_no)
    self.soliderName:setString(name)
    changeNewIconImage(self.headQulityA, icon, quality)
end

--标签页点击 更新标签状态
function PVRunePanel:updateMenuByIndex(index)
    local menuCount = table.getn(self.tabNormalImage)
    for  i = 1, menuCount do
        if i == index then
            self.tabNormalImage[i]:setVisible(false)
            self.tabSelectImage[i]:setVisible(true)
            self.tabMenu[i]:setEnabled(false)
        else
            self.tabNormalImage[i]:setVisible(true)
            self.tabSelectImage[i]:setVisible(false)
            self.tabMenu[i]:setEnabled(true)
        end
    end
end

--各个tab标签下内容的更新
function PVRunePanel:updateTabContent(index)
    self.curRuneType = index
    local res = "ui_rune_type" .. index .. ".png"
    self.runeBigSprite:setSpriteFrame(res)
    self.effectLayer:removeAllChildren()
    self.totalCostDelete = 0
    print("self.curRuneList ===== ", self.curRuneList)
    table.print(self.curRuneList)
    if self.curRuneList ~= nil then
        for k, v in pairs(self.curRuneList) do
            local runePos = v.runt_po                                                   --符文镶嵌位置
            local runeItem = self.c_StoneTemplate:getStoneItemById(v.runt_id)
            local res = self.c_ResourceTemplate:getResourceById(runeItem.res)
            print("runePos ======== runePos ======== ", runePos)
            self.runeSprite[runePos]:setTexture("res/icon/rune/" .. res)
            self.runeAdd[runePos]:setVisible(false)
            local runeLine = self.runeline[runePos + 1]
            if runeLine ~= nil then
                runeLine:setVisible(true)
            end
            self.runeAddMenu[runePos].isHave = true
            self.runeAddMenu[runePos].runeId = v.runt_id
            self.runeAddMenu[runePos].curType = runeItem.type
            self.runeAddMenu[runePos].runt_no = v.runt_no
            local pickPrice = self.c_StoneTemplate:getPickPriceById(v.runt_id)
            self.totalCostDelete = self.totalCostDelete + pickPrice
        end

        -- local node = UI_Fuwentexiao(self.effectList)
        -- node:setPosition(cc.p(0,0))
        -- self.effectLayer:addChild(node)
        for k,v in pairs(self.effectList) do
            local node = UI_Fuwentexiao(self.effectList)
            node:setPosition(cc.p(v.positionX, v.positionY))
            self.effectLayer:addChild(node)
        end

        self:updateBigRuneSprite(self.curRuneType, self.curRuneList)
    else
        -- self.attributeNode:setVisible(false)
        self.animationLayer:removeAllChildren()
        self:initAddRuneMenu()
    end
    self.sliverValue:setString(self.totalCostDelete)
    self.attriDesLayer:removeAllChildren()
    self:showAttr()
end

--初始化镶嵌按钮
function PVRunePanel:initAddRuneMenu()
    for k, v in pairs(self.runeAddMenu) do
        v.isHave = false
        v.curType = 0
        v.runeId = nil
        v.runt_no = nil
        self.runeSprite[k]:setSpriteFrame("ui_rune_bottom.png")
        self.runeAdd[k]:setVisible(true)
        local runeLine = self.runeline[k + 1]
        if runeLine ~= nil then
            runeLine:setVisible(false)
        end
    end
end

--界面监听事件
function PVRunePanel:initTouchListener()
    --生命
    local function menuLifeClick()
        getAudioManager():playEffectButton2()
        -- self.curRuneList = nil
        self:initAddRuneMenu()
        self.curRuneList = self.soldierRunes[1]
        self.effectList = self:initEffectList(self.curRuneList)
        --self.curAttributeList = self.mainAttributeList[1]
        self:updateMenuByIndex(1)
        self:updateTabContent(1)
    end

    --攻击
    local function menuAttackClick()
        getAudioManager():playEffectButton2()
        -- self.curRuneList = nil
        self:initAddRuneMenu()
        self.curRuneList = self.soldierRunes[2]
        self.effectList = self:initEffectList(self.curRuneList)
        --self.curAttributeList = self.mainAttributeList[2]
        self:updateMenuByIndex(2)
        self:updateTabContent(2)
    end

    --物防
    local function menuPhyClick()
        getAudioManager():playEffectButton2()
        -- self.curRuneList = nil
        self:initAddRuneMenu()
        self.curRuneList = self.soldierRunes[3]
        self.effectList = self:initEffectList(self.curRuneList)
        --self.curAttributeList = self.mainAttributeList[3]
        self:updateMenuByIndex(3)
        self:updateTabContent(3)
    end

    --法防
    local function menuMagicClick()
        getAudioManager():playEffectButton2()
        -- self.curRuneList = nil
        self:initAddRuneMenu()
        self.curRuneList = self.soldierRunes[4]
        self.effectList = self:initEffectList(self.curRuneList)
        --self.curAttributeList = self.mainAttributeList[4]
        self:updateMenuByIndex(4)
        self:updateTabContent(4)
    end

    --炼化
    local function onRecieveHightRune()
        getAudioManager():playEffectButton2()
        -- getModule(MODULE_NAME_HOMEPAGE):showUIView("PVSmeltPanel")
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVSmeltView", 3)
    end

    --符文背包
    local function onRuneBagClick()
        getAudioManager():playEffectButton2()
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVRuneBagCheck")
    end

    --打造符文
    local function onBuildRuneClick()
        getAudioManager():playEffectButton2()
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVRuneBuildPanel")
    end

    --全部摘除
    local function onAllDeleteClick()
        local haveCoin = self.commonData:getCoin()
        print("全部删除查看 ================= ", haveCoin,  self.totalCostDelete)
        self.deleteType = 2
        getAudioManager():playEffectButton2()
        local curSoldierId = self.c_runeData:getCurSoliderId()
        if self.curRuneList ~= nil and table.nums(self.curRuneList) > 0 then
            if haveCoin >= self.totalCostDelete then
                self.c_runeNet:sendDeleRune(curSoldierId, self.curRuneType, nil)
            else
                getOtherModule():showAlertDialog(nil, Localize.query(101))
            end
        end
    end

    --关闭
    local function onCloseClick()
        getAudioManager():playEffectButton2()

        -- stepCallBack(G_GUIDE_50127)
        groupCallBack(GuideGroupKey.BTN_RUNE_CLOSE)

        self:onHideView()
    end

    --镶嵌符文按钮
    local function runeMenuClick1()
        getAudioManager():playEffectButton2()
        self:onAddRuneClick(1)

        --stepCallBack(G_GUIDE_50111)   --点击符文槽位
        groupCallBack(GuideGroupKey.BTN_CLICK_FUWEN_SLOT)
    end

    local function runeMenuClick2()
        getAudioManager():playEffectButton2()
        self:onAddRuneClick(2)

        --stepCallBack(G_GUIDE_50115)
        groupCallBack(GuideGroupKey.BTN_CLICK_FUWEN_SLOT)
    end

    local function runeMenuClick3()
        getAudioManager():playEffectButton2()

        local runeInfo = self.runeAddMenu[3]
        print("是否镶嵌 ",runeInfo.isHave)
        if runeInfo.isHave then
            if(getNewGManager():getCurrentGid()==GuideId.G_GUIDE_50027) then
                getNewGManager():setCurrentGID(GuideId.G_GUIDE_50029)
                groupCallBack(GuideGroupKey.BTN_FUWEN_CONFIRM_IN_TIP)
                return
            end
        end

        self:onAddRuneClick(3)

        groupCallBack(GuideGroupKey.BTN_CLICK_FUWEN_SLOT)
        -- stepCallBack(G_GUIDE_50119)
    end

    local function runeMenuClick4()
        getAudioManager():playEffectButton2()
        self:onAddRuneClick(4)
    end

    local function runeMenuClick5()
        getAudioManager():playEffectButton2()
        self:onAddRuneClick(5)
    end

    local function runeMenuClick6()
        getAudioManager():playEffectButton2()
        self:onAddRuneClick(6)
    end

    local function runeMenuClick7()
        getAudioManager():playEffectButton2()
        self:onAddRuneClick(7)
    end

    local function runeMenuClick8()
        getAudioManager():playEffectButton2()
        self:onAddRuneClick(8)
    end

    local function runeMenuClick9()
        getAudioManager():playEffectButton2()
        self:onAddRuneClick(9)
    end

    local function runeMenuClick10()
        getAudioManager():playEffectButton2()
        self:onAddRuneClick(10)
    end

    local function onChangeSoliderClick()
        print("onChangeSoliderClick =========== ")
        getAudioManager():playEffectButton2()
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVRuneChangeSoldier")
    end


    self.UIRunePanel["UIRunePanel"] = {}

    self.UIRunePanel["UIRunePanel"]["menuLifeClick"] = menuLifeClick                        --生命
    self.UIRunePanel["UIRunePanel"]["menuAttackClick"] = menuAttackClick                    --攻击
    self.UIRunePanel["UIRunePanel"]["menuPhyClick"] = menuPhyClick                          --物防
    self.UIRunePanel["UIRunePanel"]["menuMagicClick"] = menuMagicClick                      --法防

    self.UIRunePanel["UIRunePanel"]["onRecieveHightRune"] = onRecieveHightRune              --炼化
    self.UIRunePanel["UIRunePanel"]["onBuildRuneClick"] = onBuildRuneClick                  --符文打造
    self.UIRunePanel["UIRunePanel"]["onRuneBagClick"] = onRuneBagClick                      --符文背包
    self.UIRunePanel["UIRunePanel"]["onAllDeleteClick"] = onAllDeleteClick                  --全部摘除

    self.UIRunePanel["UIRunePanel"]["runeMenuClick1"] = runeMenuClick1
    self.UIRunePanel["UIRunePanel"]["runeMenuClick2"] = runeMenuClick2
    self.UIRunePanel["UIRunePanel"]["runeMenuClick3"] = runeMenuClick3
    self.UIRunePanel["UIRunePanel"]["runeMenuClick4"] = runeMenuClick4
    self.UIRunePanel["UIRunePanel"]["runeMenuClick5"] = runeMenuClick5
    self.UIRunePanel["UIRunePanel"]["runeMenuClick6"] = runeMenuClick6
    self.UIRunePanel["UIRunePanel"]["runeMenuClick7"] = runeMenuClick7
    self.UIRunePanel["UIRunePanel"]["runeMenuClick8"] = runeMenuClick8
    self.UIRunePanel["UIRunePanel"]["runeMenuClick9"] = runeMenuClick9
    self.UIRunePanel["UIRunePanel"]["runeMenuClick10"] = runeMenuClick10

    self.UIRunePanel["UIRunePanel"]["onCloseClick"] = onCloseClick                        --关闭

    self.UIRunePanel["UIRunePanel"]["onChangeSoliderClick"] = onChangeSoliderClick        --更换查看武将
end

--添加符文事件
function PVRunePanel:onAddRuneClick(index)
    self.c_runeData:setChangeRune(nil)
    self.curIndex = index
    print("---index---", index)
    for k,v in pairs(self.runeAddMenu) do
        if k == index then
            if v.isHave then
                self.deleteNo = v.runt_no                                           --当前要摘除的符文id
                local runeItem = self:getCurItem(self.curRuneType, v.runt_no)
                if runeItem ~= nil then
                    self.deleteType = 1
                    runeItem.runePos = self.curIndex
                    runeItem.runeType = self.curRuneType
                    getOtherModule():showOtherView("PVRuneCheck", self.posX + 10, self.posY - 10, runeItem, 1)
                end
            else
                getModule(MODULE_NAME_HOMEPAGE):showUIView("PVRuneBagPanel", 1, {runePos=self.curIndex,runeType=self.curRuneType})
            end
            break
        end
    end
    print("添加符文事件 ============ ", self.deleteType,    self.deleteNo)
end

--获取当前触摸点的坐标
function PVRunePanel:nodeRegisterTouchEvent()
    local function onTouchEvent(eventType, x, y)
        self.posX = x
        self.posY = y
    end
    self.contentLayer:registerScriptTouchHandler(onTouchEvent)
    self.contentLayer:setTouchMode(cc.TOUCHES_ONE_BY_ONE)
    self.contentLayer:setTouchEnabled(true)
end

--镶嵌成功之后返回更新
function PVRunePanel:onBackUpdateView(doType, curRuneItem)
    if doType == "add" then
        local curRuneId = curRuneItem.runt_id
        if curRuneId ~= nil then
            --史诗符文特效添加
            local quality = self.c_StoneTemplate:getStoneItemById(curRuneId).quality
            if quality >= 6 then
                local runeType = self.c_StoneTemplate:getStoneItemById(curRuneId).type
                local effectItem = {}
                effectItem.runeNo = curRuneItem.runt_no
                effectItem.typeValue = runeType
                effectItem.positionX = self.runeSprite[self.curIndex]:getPositionX()
                effectItem.positionY = self.runeSprite[self.curIndex]:getPositionY()
                table.insert(self.effectList, effectItem)
                self.effectLayer:removeAllChildren()
                for k,v in pairs(self.effectList) do
                    local node = UI_Fuwentexiao(self.effectList)
                    node:setPosition(cc.p(v.positionX, v.positionY))
                    self.effectLayer:addChild(node)
                end
                -- local node = UI_Fuwentexiao(self.effectList)
                -- node:setPosition(cc.p(0, 0))
                -- self.effectLayer:addChild(node)
            end
            table.insert(self.curRuneList, curRuneItem)

            local resId = self.c_StoneTemplate:getStoneItemById(curRuneId).res
            local res = self.c_ResourceTemplate:getResourceById(resId)
            self.runeSprite[self.curIndex]:setTexture("res/icon/rune/" .. res)
            self.runeAdd[self.curIndex]:setVisible(false)
            local runeLine = self.runeline[self.curIndex + 1]
            if runeLine ~= nil then
                runeLine:setVisible(true)
            end
            self.runeAddMenu[self.curIndex].isHave = true
            self.runeAddMenu[self.curIndex].runeId = curRuneId
            self.runeAddMenu[self.curIndex].runt_no = curRuneItem.runt_no
        end
    elseif doType == "delete" then
        local curRuneNo = curRuneItem.runt_no
        local curRuneId = curRuneItem.runt_id
        if self.curRuneList ~= nil then
            for k,v in pairs(self.curRuneList) do
                if v.runt_no == curRuneNo then
                    table.remove(self.curRuneList, k)
                    self.runeAddMenu[self.curIndex].isHave = false
                    self.runeAddMenu[self.curIndex].runeId = nil
                    self.runeAddMenu[self.curIndex].runt_no = nil
                    self.runeSprite[self.curIndex]:setSpriteFrame("ui_rune_bottom.png")
                    self.runeAdd[self.curIndex]:setVisible(true)
                    local runeLine = self.runeline[self.curIndex + 1]
                    if runeLine ~= nil then
                        runeLine:setVisible(false)
                    end
                    break
                end
            end
        end

        --符文特效删除
        for k,v in pairs(self.effectList) do
            if v.runeNo == curRuneNo then
                table.remove(self.effectList, k)
                self.effectLayer:removeAllChildren()
                -- local node = UI_Fuwentexiao(self.effectList)
                -- node:setPosition(cc.p(0,0))
                -- self.effectLayer:addChild(node)
                for k,v in pairs(self.effectList) do
                    local node = UI_Fuwentexiao(self.effectList)
                    node:setPosition(cc.p(v.positionX, v.positionY))
                    self.effectLayer:addChild(node)
                end
                break
            end
        end
    elseif doType == "delete_all" then
        self.soldierRunes[self.curRuneType] = {}
        self.curRuneList = {}
    end
    -- save
    local curSoldierId = self.c_runeData:getCurSoliderId()
    local hero = self.c_SoldierData:getSoldierDataById(curSoldierId)
    self.c_SoldierData:setRuneData(hero, self.curRuneType, self.curRuneList)
    self.c_LineupData:setRuneData(hero)
    self:updateBigRuneSprite(self.curRuneType, self.curRuneList)

    self:updateTotalDelete()
    self:showAttr()
end
--切换标签更新中心符文镶嵌特效显示
function PVRunePanel:updateBigRuneSprite(curRuneType, curRuneList)
    -- if curRuneList ~= nil then
    --     local node = nil
    --     if curRuneType ==  1 then
    --         self.animationLayer:removeAllChildren()
    --         node = UI_fuwenjiemian001(curRuneList)
    --         -- node:setPosition(cc.p(-60, -207))
    --         node:setPosition(cc.p(-215, -310))
    --         self.animationLayer:addChild(node)
    --     elseif curRuneType == 2 then
    --         self.animationLayer:removeAllChildren()
    --         node = UI_fuwenjiemian002(curRuneList)
    --         node:setPosition(cc.p(-210, -310))
    --         self.animationLayer:addChild(node)
    --     elseif curRuneType == 3 then
    --         self.animationLayer:removeAllChildren()
    --         node = UI_fuwenjiemian003(curRuneList)
    --         node:setPosition(cc.p(-210, -310))
    --         self.animationLayer:addChild(node)
    --     elseif curRuneType == 4 then
    --         self.animationLayer:removeAllChildren()
    --         node = UI_fuwenjiemian004(curRuneList)
    --         node:setPosition(cc.p(-207, -305))
    --         self.animationLayer:addChild(node)
    --     end
    -- end
end

function PVRunePanel:showAttr()
    self.attriDesLayer:removeAllChildren()
    local curSoldierId = self.c_runeData:getCurSoliderId()
    local hero = self.c_SoldierData:getSoldierDataById(curSoldierId)
    local attr = self.c_Calculation:RuneAttrByType(hero, self.curRuneType)
    local i = 1
    for k,v in pairs(attr) do
        if v > 0 then
            local label = cc.LabelTTF:create("", MINI_BLACK_FONT_NAME, 20)
            label:setAnchorPoint(cc.p(0, 0.5))
            label:setColor(ui.COLOR_GREEN)
            local typeStr = self.c_StoneTemplate:getAttrName(k)
            local attriStr = typeStr .. "+" .. round1(v)

            local x, y = 0
            if i <= 4 then
                y = 80
                x = (i - 1) * 120 + 10
            elseif i <= 8 then
                y = 50
                x = (i - 5) * 120 + 10
            else
                x = (i - 9) * 120 + 10
                y = 20
            end
            label:setPosition(cc.p(x, y))
            label:setString(attriStr)
            self.attriDesLayer:addChild(label)
            i = i + 1
        end
    end
end

function PVRunePanel:updateTotalDelete()
    self.totalCostDelete = 0
    if self.curRuneList ~= nil then
        for k, v in pairs(self.curRuneList) do
            local pickPrice = self.c_StoneTemplate:getPickPriceById(v.runt_id)
            self.totalCostDelete = self.totalCostDelete + pickPrice
        end
    end
    self.sliverValue:setString(self.totalCostDelete)
end

function PVRunePanel:onReloadView()
    print("=====================>PVRunePanel:onReloadView", self.funcTable[1])
    local tag = self.funcTable[1]
    if tag == 1 then
        self:onHideView()
    end
end

function PVRunePanel:clearResource()
    -- game.removeSpriteFramesWithFile("res/ccb/resource/ui_rune.plist")
end

return PVRunePanel

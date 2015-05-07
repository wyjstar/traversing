local PVRuneBuildPanel = class("PVRuneBuildPanel", BaseUIView)

function PVRuneBuildPanel:ctor(id)
    self.super.ctor(self, id)
end

function PVRuneBuildPanel:onMVCEnter()
    self.c_runeData = getDataManager():getRuneData()
    self.c_commonData = getDataManager():getCommonData()

    self.c_StoneTemplate = getTemplateManager():getStoneTemplate()
    self.c_LanguageTemplate = getTemplateManager():getLanguageTemplate()
    self.c_ResourceTemplate = getTemplateManager():getResourceTemplate()
    self.c_BaseTemplate = getTemplateManager():getBaseTemplate()

    self.c_runeNet = getNetManager():getRuneNet()

    self:registerDataBack()

    self:initData()
    self:initView()

end

--网络返回
function PVRuneBuildPanel:registerDataBack()
    --符文刷新返回
    local function refreshCallBack(id, data)
        if data.res.result then
            self.refreshItem = data.refresh_runt
            if self.refreshFreeTimes >= 1 then
                self.refreshFreeTimes = self.refreshFreeTimes - 1
            else
                if self.haveGold ~= nil then
                    self.c_commonData:setGold(self.haveGold - self.refreshCost)
                end
            end
            if self.refreshItem ~= nil then
                self.refreshId = self.refreshItem.runt_id
                self.buildCost = self.c_StoneTemplate:getBuildCostById(self.refreshId)          --打造符文消耗
            end
            self.showDesLayer5:removeAllChildren()
            print("符文刷新返回 =========== ", self.refreshFreeTimes, self.refreshId)
            self.c_runeData:setRefreshFreeTimes(2 - self.refreshFreeTimes)
            self:updateViewShow()
        end
    end

    self:registerMsg(RUNE_BUILD_REFRESH, refreshCallBack)

    --打造符文返回
    local function buildRuneCallBack(id ,data)
        print("打造符文返回 ========= ", data.res.result)
        if data.res.result then
            self.refreshItem = data.refresh_runt
            self.receiveItem = self.c_runeData:getRefreshRuneItem()
            getOtherModule():showOtherView("PVReceiveDialog", self.receiveItem.runt_id)
            self.c_runeData:setRefreshRuneItem(self.refreshItem)
            self.c_commonData:setCoin(self.haveCoin -  self.buildCost[3])

            self.stone1 = self.c_runeData:updateStone1Num(2, self.buildCost[1])
            self.stone2 = self.c_runeData:updateStone2Num(2, self.buildCost[2])

            local runeItem = {}
            runeItem.runeId = data.refresh_runt.runt_id
            self.c_runeData:updateNumById(2, runeItem)
            self.refreshId = data.refresh_runt.runt_id

            self.haveCoin = self.c_commonData:getCoin()
            self.haveGold = self.c_commonData:getGold()

            if self.refreshId ~= 0 then
                self.buildCost = self.c_StoneTemplate:getBuildCostById(self.refreshId)          --打造符文消耗
            end
            self.showDesLayer5:removeAllChildren()
            self:updateViewShow()
        end
    end

    self:registerMsg(RUNE_BUILD, buildRuneCallBack)
end

--相关数据初始化
function PVRuneBuildPanel:initData()
    self.refreshItem = self.c_runeData:getRefreshRuneItem()
    print("打造符文界面数据初始化 ================ ")

    if self.refreshItem ~= nil and table.getn(self.refreshItem) > 0 then
        self.refreshId = self.refreshItem.runt_id
        if self.refreshId ~= nil then                                                       --刷新出的符文id
            self.buildCost = self.c_StoneTemplate:getBuildCostById(self.refreshId)          --打造符文消耗
        end
    end
    self.refreshCost = self.c_BaseTemplate:getRefreshCost()                             --刷新符文消耗元宝数

    self.refreshFreeTimes = self.c_runeData:getRefreshFreeTimes()                       --获取免费刷新的次数

    self.stone1 = self.c_runeData:getStone1()
    self.stone2 = self.c_runeData:getStone2()

    self.haveCoin = self.c_commonData:getCoin()
    self.haveGold = self.c_commonData:getGold()

    self.isCost1 = false
    self.isCost2 = false
    self.isCost3 = false
end

--界面加载以及初始化

function PVRuneBuildPanel:initView()
    self.UIRuneBuildPanel = {}

    self:initTouchListener()
    self:loadCCBI("rune/ui_rune_build.ccbi", self.UIRuneBuildPanel)

    self.contentLayer = self.UIRuneBuildPanel["UIRuneBuildPanel"]["contentLayer"]

    self.runeItemIcon5 = self.UIRuneBuildPanel["UIRuneBuildPanel"]["runeItemIcon5"]             --中心符文

    --玩家当前拥有的原石和晶石
    self.yuanValue = self.UIRuneBuildPanel["UIRuneBuildPanel"]["yuanValue"]
    self.sparValue = self.UIRuneBuildPanel["UIRuneBuildPanel"]["sparValue"]

    --免费次数相关
    self.freeTimes = self.UIRuneBuildPanel["UIRuneBuildPanel"]["freeTimes"]
    self.freeTimeLayer = self.UIRuneBuildPanel["UIRuneBuildPanel"]["freeTimeLayer"]

    --刷新符文消耗元宝相关
    self.costCoinLayer = self.UIRuneBuildPanel["UIRuneBuildPanel"]["costCoinLayer"]
    self.goldValue1 = self.UIRuneBuildPanel["UIRuneBuildPanel"]["goldValue1"]

    --打造消耗
    self.goldValue2 = self.UIRuneBuildPanel["UIRuneBuildPanel"]["goldValue2"]
    self.yuanValue2 = self.UIRuneBuildPanel["UIRuneBuildPanel"]["yuanValue2"]
    self.sparValue2 = self.UIRuneBuildPanel["UIRuneBuildPanel"]["sparValue2"]

    self.showDesLayer5 = self.UIRuneBuildPanel["UIRuneBuildPanel"]["showDesLayer5"]

    self.runeName = self.UIRuneBuildPanel["UIRuneBuildPanel"]["runeName"]

    self.mainAtrribute = self.UIRuneBuildPanel["UIRuneBuildPanel"]["mainAtrribute"]

    self.yinding = self.UIRuneBuildPanel["UIRuneBuildPanel"]["yinding"]
    self.yuanbao = self.UIRuneBuildPanel["UIRuneBuildPanel"]["yuanbao"]

    self.contentScrollView = self.UIRuneBuildPanel["UIRuneBuildPanel"]["contentScrollView"]
    self.contentScrollView:setTouchEnabled(false)
    self:updateViewShow()
end

function PVRuneBuildPanel:updateViewShow()
    --刷新符文icon的展示
    self.refreshId = self.refreshItem.runt_id
    --金币
    self.yinding:setString(getDataManager():getCommonData():getCoin())
    self.yuanbao:setString(getDataManager():getCommonData():getGold())

    --当前拥有的原石和晶石的数量
    self.yuanValue:setString(self.stone1)
    self.sparValue:setString(self.stone2)
    print("self.refreshId PVRuneBuildPanel ================ ", self.refreshId,       self.refreshItem)
    if self.refreshId ~= 0 then
        --当前符文的名称
        local nameId = self.c_StoneTemplate:getStoneItemById(self.refreshId).name
        local nameStr = self.c_LanguageTemplate:getLanguageById(nameId)
        local quality = self.c_StoneTemplate:getStoneItemById(self.refreshId).quality
        local color = self.c_StoneTemplate:getColorByQuality(quality)
        self.runeName:setColor(color)
        self.runeName:setString(nameStr)

        self.buildCost = self.c_StoneTemplate:getBuildCostById(self.refreshId)
        local resId = self.c_StoneTemplate:getStoneItemById(self.refreshId).res
        local resIcon = self.c_ResourceTemplate:getResourceById(resId)

        local quality = self.c_StoneTemplate:getStoneItemById(self.refreshId).quality

        self.c_runeData:setItemImage(self.runeItemIcon5, "res/icon/rune/" .. resIcon, quality)

        self:updateBuildCost()
    else
        self.runeItemIcon5:removeAllChildren()
        self.runeItemIcon5:setSpriteFrame("ui_rune_build1.png")
         --金币消耗
        local goldValueStr = 0
        self.goldValue2:setString(goldValueStr)
        --原石消耗
        local yuanValueStr = 0
        self.yuanValue2:setString(yuanValueStr)
        --晶石消耗
        local sparValueStr = 0
        self.sparValue2:setString(sparValueStr)
    end
    --免费刷新
    print("免费刷新 self.refreshFreeTimes ============ ", self.refreshFreeTimes)
    if self.refreshFreeTimes > 0 then
        self.freeTimeLayer:setVisible(true)
        self.freeTimes:setString(self.refreshFreeTimes)
        self.costCoinLayer:setVisible(false)
    elseif self.refreshItem == nil then
        self.refreshFreeTimes = self.c_BaseTemplate:getFreeRefreshTimes()
        self.freeTimeLayer:setVisible(true)
        self.freeTimes:setString(self.refreshFreeTimes)
    else
        self.freeTimeLayer:setVisible(false)
        self.costCoinLayer:setVisible(true)
        self.goldValue1:setString(self.refreshCost)
    end
    --属性展示
    if self.refreshItem ~= nil then
        local mainAttribute = self.refreshItem.main_attr
        local minorAttribute = self.refreshItem.minor_attr

        for k, v in pairs(mainAttribute) do
            local attr_type = v.attr_type
            local attr_value = v.attr_value
            attr_value = math.floor(attr_value * 10) / 10
            local typeStr = self.c_StoneTemplate:getAttriStrByType(attr_type)
            local mainAttriStr = typeStr .. "+" .. attr_value

            -- local mainLabel = cc.LabelTTF:create("", MINI_BLACK_FONT_NAME, 19)

            -- mainLabel:setColor(ui.COLOR_WHITE)
            -- mainLabel:setString(mainAttriStr)

            self.mainAtrribute:setString(mainAttriStr)

            if table.getn(minorAttribute) == 0 then
                -- mainLabel:setPosition(cc.p(82, 56))
            else
                -- mainLabel:setPosition(cc.p(82, 100))
            end

            -- self.mainAtrribute:addChild(mainLabel)
        end

        for k,v in pairs(minorAttribute) do
            local label = cc.LabelTTF:create("", MINI_BLACK_FONT_NAME, 22)
            local quality = self.c_StoneTemplate:getStoneItemById(self.refreshItem.runt_id).quality
            local color = self.c_StoneTemplate:getColorByQuality(quality)
            label:setColor(color)
            label:setAnchorPoint(cc.p(0, 0.5))
            local typeStr = self.c_StoneTemplate:getAttriStrByType(v.attr_type)
            v.attr_value = math.floor(v.attr_value * 10) / 10
            local attriStr = typeStr .. "+" .. v.attr_value
            label:setPosition(cc.p(8, 105 - (k - 1) * 30))
            label:setString(attriStr)
            self.showDesLayer5:addChild(label)
        end
    end
end

function PVRuneBuildPanel:updateBuildCost()
    self.buildCost = self.c_StoneTemplate:getBuildCostById(self.refreshId)
    print("打造符文 PVRuneBuildPanel ============= ", self.refreshId,     self.buildCost)

    --打造消耗的原石、晶石、金币的显示
    if self.buildCost ~= nil and table.getn(self.buildCost) > 0 then
        table.print(self.buildCost)
        --金币消耗(即银两)
        if self.buildCost[3] <= self.haveCoin then
            self.goldValue2:setColor(ui.COLOR_GREEN)
            self.isCost1 = true
        else
            self.goldValue2:setColor(ui.COLOR_RED)
            self.isCost1 = false
        end

        local goldValueStr = self.buildCost[3]
        self.goldValue2:setString(goldValueStr)
        --原石消耗
        if self.buildCost[1] <= self.stone1 then
            self.yuanValue2:setColor(ui.COLOR_GREEN)
            self.isCost2 = true
        else
            self.yuanValue2:setColor(ui.COLOR_RED)
            self.isCost2 = false
        end

        local yuanValueStr = self.buildCost[1]
        self.yuanValue2:setString(yuanValueStr)
        --晶石消耗
        if self.buildCost[2] <= self.stone2 then
            self.sparValue2:setColor(ui.COLOR_GREEN)
            self.isCost3 = true
        else
            self.sparValue2:setColor(ui.COLOR_RED)
            self.isCost3 = false
        end

        local sparValueStr = self.buildCost[2]
        -- .. " / " .. self.stone2
        self.sparValue2:setString(sparValueStr)
    else
        --金币消耗
        local goldValueStr = 0
        self.goldValue2:setString(goldValueStr)
        --原石消耗
        local yuanValueStr = 0
        self.yuanValue2:setString(yuanValueStr)
        --晶石消耗
        local sparValueStr = 0
        self.sparValue2:setString(sparValueStr)

        self.isCost1 = true
        self.isCost2 = true
        self.isCost3 = true
    end
end

--界面监听事件
function PVRuneBuildPanel:initTouchListener()
    --刷新符文
    local function onRefreshRuneClick()
        getAudioManager():playEffectButton2()
        self.haveGold = self.c_commonData:getGold()
        if self.refreshCost <= self.haveGold then
            self.c_runeNet:sendRefreshRunes()
        else
            -- getOtherModule():showToastView(Localize.query(102))
            getOtherModule():showAlertDialog(nil, Localize.query(102))

        end
    end

    --打造符文
    local function onBuildRuneClick()
        getAudioManager():playEffectButton2()
        if self.refreshId == 0 then
            -- getOtherModule():showToastView(Localize.query(828))
            getOtherModule():showAlertDialog(nil, Localize.query(828))
        elseif self.isCost1 and self.isCost2 and self.isCost3 then
            self.c_runeNet:sendBuildRune()
        else
            -- getOtherModule():showToastView(Localize.query(826))
            getOtherModule():showAlertDialog(nil, Localize.query(826))
        end
    end

    --关闭
    local function onCloseClick()
        getAudioManager():playEffectButton2()
        self.showDesLayer5:removeAllChildren()
        self:onHideView()
    end

    local function onAddSliver()
        getModule(MODULE_NAME_SHOP):showUIViewAndInTop("PVShopPage", 3)
    end
    local function onAddGold()
        getModule(MODULE_NAME_SHOP):showUIViewAndInTop("PVshopRecharge")
    end

    self.UIRuneBuildPanel["UIRuneBuildPanel"] = {}

    self.UIRuneBuildPanel["UIRuneBuildPanel"]["onRefreshRuneClick"] = onRefreshRuneClick                --刷新符文
    self.UIRuneBuildPanel["UIRuneBuildPanel"]["onBuildRuneClick"] = onBuildRuneClick                    --打造符文
    self.UIRuneBuildPanel["UIRuneBuildPanel"]["onAddSliver"] = onAddSliver                    --增加银两
    self.UIRuneBuildPanel["UIRuneBuildPanel"]["onAddGold"] = onAddGold                    --增加元宝

    self.UIRuneBuildPanel["UIRuneBuildPanel"]["onCloseClick"] = onCloseClick                            --关闭
end

function PVRuneBuildPanel:onReloadView()
end

function PVRuneBuildPanel:clearResource()
end

return PVRuneBuildPanel

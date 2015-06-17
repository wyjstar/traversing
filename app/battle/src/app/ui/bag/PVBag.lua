local processor = import("...netcenter.DataProcessor")
local CursorInputLayer = import("..input.CursorInputLayer")
local CustomScrollView = import("...util.CustomScrollView")
local PVBagItem = import(".PVBagItem")

local PVBag = class("PVBag", BaseUIView)

local COLUMN_NUM = 4
local COLUMN_SPACE = 0

function PVBag:ctor(id)
    PVBag.super.ctor(self, id)
end

function PVBag:onMVCEnter()
    game.addSpriteFramesWithFile("res/ccb/resource/ui_bag.plist")

    self:registerDataBack()

    self.bagNet = getNetManager():getBagNet()
    self.c_LanguageTemplate = getTemplateManager():getLanguageTemplate()
    self.c_ResourceTemplate = getTemplateManager():getResourceTemplate()
    self.c_BaseTemplate = getTemplateManager():getBaseTemplate()

    self:initView()         --背包界面初始化
    self:updateData()
end


function PVBag:registerDataBack()
    local function getBagData()
        self:updateData()
    end
    local function getUseResult()
        local resultData = processor:getCommonResponse()
        if resultData.result then
            self:freshData()
            if self.curUseNo ~= nil then
                local dropBigId = getTemplateManager():getBagTemplate():getItemById(self.curUseNo).dropId
                local smallBags = getTemplateManager():getDropTemplate():getSmallBagIds(dropBigId)
                getOtherModule():showOtherView("PVCongratulationsGainDialog", 5, smallBags)
            end
        elseif resultData.result_no == 107 then
            getOtherModule():showAlertDialog(nil, Localize.query("bag.1"))
        end
    end

    self:registerMsg(PROP_USE, getUseResult)

    self:registerMsg(BAG_GET_DATA, getBagData)
end

--背包道具数据初始化
function PVBag:updateData()
     --背包容量上限
    self.maxBagNum = self.c_BaseTemplate:getMaxBag()

    self.c_bag_data = getDataManager():getBagData()
    self.bagData = self.c_bag_data:getData()
    self:loadData()
    self.itemCount = table.nums(self.bagData)
    self.itemTotalNum = 0
    for k,v in pairs(self.bagData) do
        self.itemTotalNum = self.itemTotalNum + v.itemNum
    end

    local function mySort(item1, item2)
        if item1.item.canUse ~= item2.item.canUse then
            return item1.item.canUse > item2.item.canUse
        else
            if item1.item.quality == item2.item.quality then
                return item1.item.star > item2.item.star
            else
                return item1.item.quality > item2.item.quality
            end
        end
    end

    table.sort(self.bagData, mySort)

    -- self.curData = self.bagData[1]
    self:onClickScrollViewCell(nil,self.curData)
    --初始化装备列表
    self:initViewList(self.itemCount)
end

function PVBag:initViewList(itemCount)
    if self.scrollView then self.scrollView:clear()  end
    self.scrollView = nil
    local layerSize = self.bagContentLayer:getContentSize()
    local x, y = self.bagContentLayer:getPosition()
    print("PVArenaShop ===== x, y ======= ",layerSize.width,    layerSize.height)
    local otherCondition = {}
    otherCondition.columns = COLUMN_NUM
    if self.itemCount % COLUMN_NUM ~= 0 then
        otherCondition.rows = self.itemCount / COLUMN_NUM + 1
    else
        otherCondition.rows = self.itemCount / COLUMN_NUM
    end
    otherCondition.columnspace = COLUMN_SPACE

    self.scrollView = CustomScrollView.new(self.bagContentLayer, otherCondition)
    self.scrollView:setDelegate(self)

    self.cells_ = {}
    if self.scrollView ~= nil then
        for i = 1 , tonumber(itemCount) do
            local item = PVBagItem.new(self.bagData[i])
            self.scrollView:addCell(item)
            self.cells_[#self.cells_ + 1] = item
        end
        self:addChild(self.scrollView)
    end
end

function PVBag:onClickScrollViewCell(cell, curData)
    local data = nil
    if cell ~= nil then
        data = cell:getData()
    end
    if data ~= nil or curData ~= nil then
        if data ~= nil then
            self.curData = data
        else
            self.curData = curData
        end

        local name_chinese = getTemplateManager():getLanguageTemplate():getLanguageById(self.curData.item.name)
        local descibe_chinese = getTemplateManager():getLanguageTemplate():getLanguageById(self.curData.item.describe)

        self.itemName:setString(name_chinese)
        self.itemDetail:setString(descibe_chinese)
    end
    if self.cells_ ~= nil then
        for i = 1, #self.cells_ do
            if self.cells_[i]:getData().item.id ~= cell:getData().item.id then
                self.cells_[i]:setSelected(false)
            else
                self.cells_[i]:setSelected(true)
            end
        end
    end
end

--重新排序
function PVBag:loadData()
    local index = 1
    for k, v in pairs(self.bagData) do
        v.index = index
        index = index + 1
    end
end

--界面初始化
function PVBag:initView()
    self.UIBagView = {}
    self:initTouchListener()
    self:loadCCBI("bag/ui_bag_view.ccbi", self.UIBagView)

    self.bagContentLayer = self.UIBagView["UIBagView"]["bagContentLayer"]
    self.animationManager = self.UIBagView["UIBagView"]["mAnimationManager"]
    self.totalNumber = self.UIBagView["UIBagView"]["totalNumber"]
    self.itemName = self.UIBagView["UIBagView"]["itemName"]
    self.itemDetail = self.UIBagView["UIBagView"]["itemDetail"]
end

function PVBag:freshData()
    self:loadData()
    self.itemCount = table.nums(self.bagData)
     self:initViewList(self.itemCount)
    local end_num = self.c_bag_data:getItemNum()
    if end_num ~= nil and self.number_label then
        self.number_label:setString(end_num)
    end

    getHomeBasicAttrView():updateCoin()
    getHomeBasicAttrView():updateGold()
end

function PVBag:onReloadView()
    for k,v in pairs(self.bagData) do
        if v.itemNum == 0 then
            table.remove(self.bagData, k)
            v = nil
        end
    end
    self.itemCount = table.getn(self.bagData)
    self:initViewList(self.itemCount)
end

function PVBag:initTouchListener()
    --关闭
    local function onCloseClick()
        getAudioManager():playEffectButton2()
        showModuleView(MODULE_NAME_HOMEPAGE)
    end
    --使用
    local function onUseClick()
        getAudioManager():playEffectButton2()
        if self.curData ~= nil then
            local item_no = self.curData.item.id
            self.curItemNo = item_no
            local item_num = self.curData.itemNum
            local canBatchUse = self.curData.item.canBatchUse
            local canUse = self.curData.item.canUse
            self.curUseNo = item_no
            if canBatchUse == 1 then
                if item_num > 1 then
                    getOtherModule():showOtherView("PVUseItemTips", item_num, item_no)
                else
                    self.c_bag_data:setUseNum(1)
                    self.bagNet:sendUseProp(item_no, 1)        --发送道具使用协议
                end
            end
            if canUse == 2 then
                getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSoldierMain", 4)
            elseif canUse == 3 then
                getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSoldierMain", 3)
            elseif canUse == 4 then
                getModule(MODULE_NAME_HOMEPAGE):removeLastView()
                getModule(MODULE_NAME_HOMEPAGE):showUIView("PVActivityPage", 5)
            end
        end
    end
    --获取
    local function onGetClick()
        print("onGetClick ============ ")
        if self.curData ~= nil then
            local item_no = self.curData.item.id
            local itemToGetId = getTemplateManager():getBagTemplate():getToGetById(item_no)
            local _data =  getTemplateManager():getChipTemplate():getDropListById(itemToGetId)
            if (type(_data.stage) == "table" and table.nums(_data.stage) == 0) and _data.coinHero == 0
                and _data.moneyHero == 0 and _data.coinEqu == 0 and _data.moneyEqu == 0 and _data.soulShop == 0
                and _data.arenaShop == 0 and _data.stageBreak == 0 and _data.isStage == 0 and (type(_data.isEliteStage) == "table" and table.nums(_data.isEliteStage) == 0)
                and _data.isActiveStage then
                    local tipText = getTemplateManager():getLanguageTemplate():getLanguageById(3300010001)
                    getOtherModule():showAlertDialog(nil, tipText)

            else
                g__data = _data
                -- self:onHideView()
                getOtherModule():showOtherView("PVChipGetDetail", g__data, item_no)
                g__data = nil
            end
        end
    end
    self.UIBagView["UIBagView"] = {}
    self.UIBagView["UIBagView"]["onCloseClick"] = onCloseClick
    self.UIBagView["UIBagView"]["onUseClick"] = onUseClick
    self.UIBagView["UIBagView"]["onGetClick"] = onGetClick

end

function PVBag:clearResource()
end

return PVBag

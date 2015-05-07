
local CustomScrollView = import("....util.CustomScrollView")
local PVArenaShopItem = import(".PVArenaShopItem")

local PVArenaShop = class("PVArenaShop", BaseUIView)

local TYPE_SHOP_PVP = 10
local COLUMN_NUM = 3
local COLUMN_SPACE = 30

function PVArenaShop:ctor(id)
    self.super.ctor(self, id)

    self.arenaShopTemplate = getTemplateManager():getArenaShopTemplate()  --商品基本数据

    self.shopTemp = getTemplateManager():getShopTemplate()
    self.languageTemp = getTemplateManager():getLanguageTemplate()
    self.shopData = getDataManager():getShopData()
    self.commonData = getDataManager():getCommonData()
    self.baseTemp = getTemplateManager():getBaseTemplate()
    self.dropTemp = getTemplateManager():getDropTemplate()
    self.bagTemp = getTemplateManager():getBagTemplate()
    self.resourceTemp = getTemplateManager():getResourceTemplate()
    self.soldierTemp = getTemplateManager():getSoldierTemplate()
    self.equipTemp = getTemplateManager():getEquipTemplate()
    self.chipTemp = getTemplateManager():getChipTemplate()

    getNetManager():getShopNet():sendGetShopList(TYPE_SHOP_PVP)      --竞技场中兑换商店

    self:registerDataBack()
end

function PVArenaShop:onMVCEnter()
    --加载相关plist文件
    game.addSpriteFramesWithFile("res/ccb/resource/ui_arena.plist")

    self:initData()

    self:initView()
end


--网络返回
function PVArenaShop:registerDataBack()
    --兑换商店相关
    function onGetShopListCallBack(id, data)
        print("兑换商店相关 -=============- ")
        table.print(data)
        if data.res.result ~= true then
        else
            self.shopData:setPvpList(data.id)
            self.shopData:setPvpGotList(data.buyed_id)
            self:updateData()
        end
    end

    --刷新返回
    local function onRefreshCallback(id, data) -- flash
        if data.res.result ~= true then
            cclog("!!! 数据返回错误")
        else
            cclog("!!! onRefreshCallback")
            table.print(data)
            self.shopData:setPvpList(data.id)
            self.shopData:setPvpGotList(data.buyed_id)
            self.commonData:subGold(self.flashMoney)  -- 应该根据类型扣*，self.flashType
            self:updateData()
        end
    end
    --兑换返回
    local function getGoodsCallback(id, data)
        print("兑换返回 ========== ")
        table.print(data)
        if data.res.result ~= true then
            cclog("!!! 数据返回错误")
        else
            if self.useMoney ~= nil then
                self.curPvpStore = self.commonData:subPvpStore(self.useMoney)
                self.curPvpStore = self.commonData:getPvpStore()
                self.scoreLabel:setString(self.curPvpStore)
                self:updateData()
                getModule(MODULE_NAME_HOMEPAGE):showUITopShowLastView("PVExchangeDialog", self.buyGoodsId)
            end
        end
    end


    self:registerMsg(SHOP_GET_ITEM_CODE, onGetShopListCallBack)
    self:registerMsg(SHOP_REFRESH_CODE, onRefreshCallback)
    self:registerMsg(SHOP_BUY_GOODS_CODE, getGoodsCallback)

end

--相关数据初始化
function PVArenaShop:initData()
    self.curPvpStore = self.commonData:getPvpStore()
    self.haveGold = self.commonData:getGold()                                   --目前拥有的元宝数量
    self.refreshTimes = self.shopTemp:getRefreshTimes(TYPE_SHOP_PVP)            --获取免费刷新的次数
    local vipLevel = self.commonData:getVip()
    self.costRefreshTimes = self.baseTemp:getShopRefreshTimes(vipLevel)         --可刷新次数

    local _flashMoney, _flashType = self.shopTemp:getFlashMoney(TYPE_SHOP_PVP)
    self.flashMoney = _flashMoney
end

--更新网络协议返回数据
function PVArenaShop:updateData()
    --兑换列表初始化
    local _idsList = self.shopData:getPvpList()
    local _idsGotList = self.shopData:getPvpGotList()

    self.scoreLabel:setString( self.curPvpStore)

    -- 获取商城装备数据
    self.exchangeList = {}
    for k,v in pairs(_idsList) do
        local value = self.shopTemp:getTemplateById(v)
        value.got = false
        table.insert(self.exchangeList, value)
    end
    for k,v in pairs(_idsGotList) do
        local value = self.shopTemp:getTemplateById(v)
        value.got = true
        table.insert(self.exchangeList, value)
    end

    table.sort( self.exchangeList, function (a,b) return a.id < b.id end )

    print("@@@@@@@@@@@@@@@@@")
    table.print(self.exchangeList)
    print("@@@@@@@@@@@@@@@@@")

    self.itemCount = table.nums(self.exchangeList)
    --初始化默认显示第一个装备的详细信息
    self.curData = self.exchangeList[1]
    self:onClickScrollViewCell(nil,self.curData)
    --初始化装备列表
    self:initViewList(self.itemCount)
end

--界面加载以及初始化
function PVArenaShop:initView()
    self.UIArenaShop = {}
    self:initTouchListener()
    self:loadCCBI("arena/ui_arena_shop.ccbi", self.UIArenaShop)

    self.contentLayer = self.UIArenaShop["UIArenaShop"]["contentLayer"]
    self.scoreLabel = self.UIArenaShop["UIArenaShop"]["scoreLabel"]                        --军功值
    self.itemIcon = self.UIArenaShop["UIArenaShop"]["itemIcon"]                             --装备icon
    self.itemName = self.UIArenaShop["UIArenaShop"]["itemName"]                             --装备名称
    self.itemDetail = self.UIArenaShop["UIArenaShop"]["itemDetail"]                         --装备详情
    self.refreshTime = self.UIArenaShop["UIArenaShop"]["refreshTime"]                       --刷新时间

    self.goldLayer = self.UIArenaShop["UIArenaShop"]["goldLayer"]                           --消耗元宝刷新层
    self.gold_value = self.UIArenaShop["UIArenaShop"]["gold_value"]                         --刷新消耗元宝
    self.refreshLeaveTimes = self.UIArenaShop["UIArenaShop"]["refreshLeaveTimes"]           --刷新剩余次数

    self.freeLayer = self.UIArenaShop["UIArenaShop"]["freeLayer"]                           --免费刷新的层
    self.freeTimes = self.UIArenaShop["UIArenaShop"]["freeTimes"]                           --免费刷新次数

    self.changeMenu = self.UIArenaShop["UIArenaShop"]["changeMenu"]                         --兑换按钮

    if self.refreshTimes > 0 then
        self.goldLayer:setVisible(false)
        self.freeLayer:setVisible(true)
        self.freeTimes:setString(self.refreshTimes)
    else
        self.goldLayer:setVisible(true)
        self.freeLayer:setVisible(false)
        self.gold_value:setString(self.flashMoney)
        self.refreshLeaveTimes:setString(self.costRefreshTimes)
    end
end

function PVArenaShop:initViewList(itemCount)
    if self.scrollView then self.scrollView:clear()  end
    self.scrollView = nil
    local layerSize = self.contentLayer:getContentSize()
    local x, y = self.contentLayer:getPosition()
    local otherCondition = {}
    otherCondition.columns = COLUMN_NUM
    if self.itemCount % COLUMN_NUM ~= 0 then
        otherCondition.rows = self.itemCount / COLUMN_NUM + 1
    else
        otherCondition.rows = self.itemCount / COLUMN_NUM
    end
    otherCondition.columnspace = COLUMN_SPACE
    -- self.scrollView = CustomScrollView.new(cc.rect(x, y, layerSize.width, layerSize.height), otherCondition)
    self.scrollView = CustomScrollView.new(self.contentLayer, otherCondition)
    self.scrollView:setDelegate(self)

    self.cells_ = {}
    if self.scrollView ~= nil then
        for i = 1 , tonumber(itemCount) do
            local item = PVArenaShopItem.new(self.exchangeList[i])
            self.scrollView:addCell(item)
            self.cells_[#self.cells_ + 1] = item
        end

        self:addChild(self.scrollView)
    end
end

function PVArenaShop:onClickScrollViewCell(cell, curData)
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
        local gainData = self.curData.gain
        local gainKey = tonumber(table.getKeyByIndex(gainData, 1))
        local gainValue = table.getValueByIndex(gainData, 1)
        if self.curData.got then
            self.changeMenu:setEnabled(false)
        else
            self.changeMenu:setEnabled(true)
        end
        setCommonDrop(gainKey, gainValue[3], self.itemIcon, self.itemName, self.itemDetail)

        if self.cells_ ~= nil then
            for i = 1, #self.cells_ do
                local gainData = self.cells_[i]:getData().gain
                local gainValueId = table.getValueByIndex(gainData, 1)
                if gainValueId[3] ~= gainValue[3] then
                    self.cells_[i]:setSelected(false)
                else
                    self.cells_[i]:setSelected(true)
                end
            end
        end
    end
end

--界面监听事件
function PVArenaShop:initTouchListener()
    --关闭
    local function onCloseClick()
        getAudioManager():playEffectButton2()
        self:onHideView()
    end

    --兑换
    local function onChangeClick()
        getAudioManager():playEffectPage()
        local consumeData = self.curData.consume
        self.buyGoodsId = self.curData.id
        self.useMoney = table.getValueByIndex(consumeData, 1)[1]
        if self.curPvpStore >= self.useMoney then
            getNetManager():getShopNet():sendBuyGoods(self.buyGoodsId)
        else
            getOtherModule():showAlertDialog(nil, Localize.query("shop.15"))
        end
        groupCallBack(GuideGroupKey.BIN_EXCHANGE_IN_LEITAI)
    end
    --刷新
    local function onRefreshClick()
        getAudioManager():playEffectButton2()
        cclog("onRefreshClick")
        if self.commonData:getGold() < self.flashMoney then
            getOtherModule():showAlertDialog(nil, Localize.query("shop.8"))
        else
            getNetManager():getShopNet():sendRefreshShopList(TYPE_SHOP_PVP)
        end
    end

    --查看
    local function onCheckClick()
        local gainData = self.curData.gain
        local gainKey = tonumber(table.getKeyByIndex(gainData, 1))
        local gainValue = table.getValueByIndex(gainData, 1)
        checkCommonDetail(gainKey, gainValue[3])
    end

    self.UIArenaShop["UIArenaShop"] = {}

    self.UIArenaShop["UIArenaShop"]["onCloseClick"] = onCloseClick                          --关闭
    self.UIArenaShop["UIArenaShop"]["onChangeClick"] = onChangeClick                    --兑换
    self.UIArenaShop["UIArenaShop"]["onCheckClick"] = onCheckClick                          --查看
    self.UIArenaShop["UIArenaShop"]["onRefreshClick"] = onRefreshClick                      --刷新
end

function PVArenaShop:onReloadView()
    getNetManager():getShopNet():sendGetShopList(TYPE_SHOP_PVP)
end

return PVArenaShop

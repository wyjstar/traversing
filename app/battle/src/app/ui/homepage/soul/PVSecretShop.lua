
-- 武魂商店
local TYPE_SHOP_SOUL = 9
local COLUMN_NUM = 3
local COLUMN_SPACE = 30
local CustomScrollView = import("....util.CustomScrollView")
local PVExchangeShopItem = import("src.app.ui.homepage.soul.PVExchangeShopItem")
local PVSecretShop = class("PVSecretShop", BaseUIView)

function PVSecretShop:ctor(id)
    PVSecretShop.super.ctor(self, id)

    self:initRegisterNetCallBack()

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

--    self.GameLoginResponse = getDataManager():getCommonData():getData()
    self.SoulShopTemplate = getTemplateManager():getSoulShopTemplate()
end

function PVSecretShop:onMVCEnter()

    self.UISecretShopView = {}

    self:initTouchListener()
    -- self:loadCCBI("equip/ui_equip_shop.ccbi", self.UISecretShopView)
    self:loadCCBI("equip/ui_equip_shop_new.ccbi", self.UISecretShopView)
    self.buySwitch = true
    self:initView()
    -- self:initTableView()

    -- 获取武魂商店列表
    getNetManager():getShopNet():sendGetShopList(TYPE_SHOP_SOUL)

end

function PVSecretShop:initView()
    -- self.contentLayer = self.UISecretShopView["UISmeltShop"]["listLayer"]
    -- self.totalSoulNumLabel = self.UISecretShopView["UISmeltShop"]["equipsoul_value"]
    -- -- self.totalSoulNumLabel = self.UISecretShopView["UISmeltShop"]["totalSoulNumLabel"]
    -- -- self.nodeSoul = self.UISecretShopView["UISmeltShop"]["nodeSoul"]
    -- self.refreshBtn = self.UISecretShopView["UISmeltShop"]["refreshBtn"]
    -- self.refreshMoney = self.UISecretShopView["UISmeltShop"]["refresh_money"]
    -- self.refreshTimes = self.UISecretShopView["UISmeltShop"]["refreshTimes"]

    -- -- self.nodeSoul:setVisible(true)

    -- self.freeTimesLablel = self.UISecretShopView["UISmeltShop"]["label_free_refresh"]
    -- self.nodeRefreshMoney = self.UISecretShopView["UISmeltShop"]["node_refresh_money"]
    -- self.nodeRefreshFree = self.UISecretShopView["UISmeltShop"]["node_free"]


    self.contentLayer = self.UISecretShopView["UISmeltShop"]["listLayer"]
    -- self.totalSoulNumLabel = self.UISecretShopView["UISmeltShop"]["equipsoul_value"]
    -- self.refreshBtn = self.UISecretShopView["UISmeltShop"]["refreshBtn"]
    -- self.refreshMoney = self.UISecretShopView["UISmeltShop"]["refresh_money"]
    -- self.refreshTimes = self.UISecretShopView["UISmeltShop"]["refreshTimes"]

    -- self.nodeSoul:setVisible(true)

    self.freeTimesLablel = self.UISecretShopView["UISmeltShop"]["label_free_refresh"]
    self.nodeRefreshMoney = self.UISecretShopView["UISmeltShop"]["node_refresh_money"]
    self.nodeRefreshFree = self.UISecretShopView["UISmeltShop"]["node_free"]
    self.totalSoulNumLabel = self.UISecretShopView["UISmeltShop"]["equipsoul_value"]
    self.refreshTimes = self.UISecretShopView["UISmeltShop"]["refreshTimes"]
    self.refreshBtn = self.UISecretShopView["UISmeltShop"]["refreshBtn"]

    -- self.scoreLabel = self.UISecretShopView["UISmeltShop"]["scoreLabel"]
    self.itemIcon = self.UISecretShopView["UISmeltShop"]["itemIcon"]
    self.itemName = self.UISecretShopView["UISmeltShop"]["itemName"]
    self.itemDetail = self.UISecretShopView["UISmeltShop"]["itemDetail"] 
    self.refreshMoney = self.UISecretShopView["UISmeltShop"]["refresh_money"]
    self.changeMenu = self.UISecretShopView["UISmeltShop"]["changeMenu"]


end

function PVSecretShop:initRegisterNetCallBack()
    function onGetShopListCallBack(id, data)
        print("get secretshop list ...")
        if data.res.result ~= true then
            print("!!! 数据返回错误")
        else
            table.print(data)
            self.shopData:setSoulList(data.id)
            self.shopData:setSoulGotList(data.buyed_id)

            if self.speSign then
                self.shopTemp:addSpecialSoulGoodsBuyed(self.buyGoodsId)
            end

            self:updateData()
        end
    end
    local function onRefreshCallback(id, data) -- flash
        if data.res.result ~= true then
            print("!!! 数据返回错误")
        else
            print("!!! onRefreshCallback")
            self.shopData:setSoulList(data.id)
            self.shopData:setSoulGotList(data.buyed_id)
            self.shopData:addRefreshTimes(1)
            self:updateData()
            if self.shopData:getRefreshTimes() > self.shopTemp:getRefreshTimesInSoulShop() then
                self.commonData:subGold(self.flashMoney)
            end
            -- --初始化属性
        end
    end

    local function getGoods(data)
        print("getGoods data")
        table.print(data)
        self.commonData:reductionHero_soul( self.useMoney )
        if self.gainType == 102 then  -- 装备类型的
            getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVEquipmentAttribute", data.gain.equipments[1]) --合成了装备，采用跳转到装备详情界面
        elseif self.gainType == 101 then -- 武将
            getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSoldierShowCard", self.gainValue)
        else
            getOtherModule():showOtherView("PVExchangeDialog", self.buyGoodsId)
        end

    end

    local function getGoodsCallback(id, data)
        self.buySwitch = true
        if data.res.result ~= true then
            print("!!! 数据返回错误")
        else
            print("!!! getGoodlsCallback")
            getGoods(data)
        end
    end

    local function getGoodsByGuidCallback(id, data)
        print("PVSecretShop:getGoodsByGuidCallback")
        table.print(data)
        if getNewGManager():getCurrentGid() == GuideId.G_GUIDE_30035 then
            self.buySwitch = true
            getGoods(data)
            getNewGManager():startGuide(GuideId.G_GUIDE_30035)
            return
        end

        if getNewGManager():getCurrentGid() == GuideId.G_GUIDE_30033 then
            self.buySwitch = true
            getGoods(data)
            getNewGManager():startGuide(GuideId.G_GUIDE_30033)
        end
        
    end

    self:registerMsg(SHOP_GET_ITEM_CODE, onGetShopListCallBack)
    self:registerMsg(SHOP_REFRESH_CODE, onRefreshCallback)
    self:registerMsg(SHOP_BUY_GOODS_CODE, getGoodsCallback)
    self:registerMsg(NewbeeGuideStep, getGoodsByGuidCallback)
end


function PVSecretShop:updateData()
    local _idsList = self.shopData:getSoulList()
    local _idsGotList = self.shopData:getSoulGotList()
    local _flashMoney, _flashType = self.shopTemp:getFlashMoney(TYPE_SHOP_SOUL)

    -- 获取商城装备数据
    self.soulList = {}

    if ISSHOW_GUIDE and (getNewGManager():getCurrentGid() == GuideId.G_GUIDE_30023 or getNewGManager():getCurrentGid() == GuideId.G_GUIDE_30034) then       --新手引导中特殊处理，服务器没有推送任何东西的情况下

        cclog("-----tschuli-------")
        self.speSign = true
        self.soulList = {}
        _idsList =  self.shopTemp:getSpecialSoulGoods()
        _idsGotList = self.shopTemp:getSpecialSoulGoodsBuyed()
        for k,v in pairs(_idsList) do 
            table.insert(self.soulList,v)
        end
        if _idsGotList then
            for k,v in pairs(_idsGotList) do
                table.insert(self.soulList,v)
            end
        end
    else
        for k,v in pairs(_idsList) do
            local value = self.shopTemp:getTemplateById(v)
            value.got = false
            table.insert(self.soulList, value)
        end
        for k,v in pairs(_idsGotList) do
            local value = self.shopTemp:getTemplateById(v)
            value.got = true
            table.insert(self.soulList, value)
        end
    end


    table.sort( self.soulList, function (a,b) return a.id < b.id end )


-- print("@@@@@@@@@@@@@@@@@")
-- table.print(self.soulList)
-- print("@@@@@@@@@@@@@@@@@")
    self.itemCount = table.nums(self.soulList)
    --初始化默认显示第一个装备的详细信息
    self.curData = self.soulList[1]
    self:initCheckView(self.curData)
    --初始化装备列表
    self:initViewList(self.itemCount)



    -- self.soulTableView:reloadData()
    -- self:tableViewItemAction(self.soulTableView)

    assert(_flashType == "2", "武魂商店的刷新消耗钱币类型应为充值币")
    self.flashMoney = _flashMoney
    self.refreshMoney:setString(tostring( self.flashMoney ))

    self.totalSoulNumLabel:setString(tostring( self.commonData:getHeroSoul() ))--self.GameLoginResponse.hero_soul ))
    
    local totalFreshTimes = self.baseTemp:getShopRefreshTimes(self.commonData:getVip())
    local usedFreshTimes = self.shopData:getRefreshTimes()
    if totalFreshTimes > usedFreshTimes then
        self.refreshTimes:setString(tostring(totalFreshTimes - usedFreshTimes).."/"..totalFreshTimes)
        self.refreshBtn:setEnabled(true)
    else
        self.refreshTimes:setString("0".."/"..totalFreshTimes)
        self.refreshBtn:setEnabled(false)
    end

    -- if self.shopData:getRefreshTimes() >= self.shopTemp:getRefreshTimesInSoulShop() then
    --     self.nodeRefreshFree:setVisible(false)
    --     self.nodeRefreshMoney:setVisible(true)
    -- else
    --     self.freeTimesLablel:setString(self.shopTemp:getRefreshTimesInSoulShop() - self.shopData:getRefreshTimes().."次")
    --     self.nodeRefreshFree:setVisible(true)
    --     self.nodeRefreshMoney:setVisible(false)
    -- end
end

-- 上层dialog关闭之后会调用这个
function PVSecretShop:updateView()
    cclog('--PVSecretShop-updateView-----')

    getNetManager():getShopNet():sendGetShopList(TYPE_SHOP_SOUL)   -- 更新
end

function PVSecretShop:initTouchListener()
    --兑换
    local function onExchangeClick()
        cclog("onExchangeClick")
        getAudioManager():playEffectPage()
        if self.buySwitch then
            self.buySwitch = false
            -- local id = self.soulList[cell:getIdx()+1].id
            -- print("1GGGGGG buy", id)
            -- self.buyGoodsId = id
            -- self.useMoney = tonumber(cell.labelMoney:getString())
            self.buyGoodsId = self.curData.id
            local gainData = self.curData.gain
            self.gainType = tonumber(table.getKeyByIndex(gainData, 1))
            local gainValue = table.getValueByIndex(gainData, 1)
            self.gainValue = gainValue[3]
            self.gainNum = gainValue[1]
            local consumeData = self.curData.consume
            self.useMoney = table.getValueByIndex(consumeData, 1)[1]
            if self.commonData:getHeroSoul() >= self.useMoney then
                -- self.gainType = cell.gainType
                -- self.gainValue = cell.gainValue
                -- self.gainNum = cell.gainNum
                if getNewGManager():getCurrentGid() == GuideId.G_GUIDE_30023 or getNewGManager():getCurrentGid() == GuideId.G_GUIDE_30034 then
                    local guidInfo = getNewGManager():getCurrentInfo()
                    getNewGManager():setGidWithProtocol(true, guidInfo["skip_to"])
                else
                    getNetManager():getShopNet():sendBuyGoods(self.buyGoodsId)
                end
            else
                -- self:toastShow(Localize.query("shop.9"))
                if getNewGManager():getCurrentGid() == GuideId.G_GUIDE_30023 or getNewGManager():getCurrentGid() == GuideId.G_GUIDE_30034 then
                    getNewGManager():setCurrentGID(GuideId.G_GUIDE_30035)
                    groupCallBack(GuideGroupKey.BTN_CLOSE_WUHUN_SHOP)
                end
                getOtherModule():showAlertDialog(nil, Localize.query("shop.9"))
                self.buySwitch = true
            end
        end
    end

    --查看
    local function onCheckClick()
        local gainData = self.curData.gain
        local gainKey = tonumber(table.getKeyByIndex(gainData, 1))
        local gainValue = table.getValueByIndex(gainData, 1)
        checkCommonDetail(gainKey, gainValue[3])
    end

    -- 

    local function onRefreshClick()
        cclog("onRefreshClick")
        getAudioManager():playEffectButton2()
        local refreshTimes = self.baseTemp:getShopRefreshTimes(self.commonData:getVip()) + self.shopTemp:getRefreshTimesInSoulShop() - self.shopData:getRefreshTimes()
        if refreshTimes > 0 then
            if self.shopData:getRefreshTimes() >= self.shopTemp:getRefreshTimesInSoulShop() then
                if self.commonData:getGold() < self.flashMoney then
                    getOtherModule():showAlertDialog(nil, Localize.query("shop.8"))
                else
                    getNetManager():getShopNet():sendRefreshShopList(TYPE_SHOP_SOUL)
                end
            else
                getNetManager():getShopNet():sendRefreshShopList(TYPE_SHOP_SOUL)
            end
        else
            if self.commonData:getVip() < 15 then
                getOtherModule():showAlertDialog(nil, Localize.query("shop.19"))
            else
                getOtherModule():showAlertDialog(nil, Localize.query("shop.20"))
            end
        end

    end

    local function onCloseClick()
        cclog("onCloseClick")
        getAudioManager():playEffectButton2()
        groupCallBack(GuideGroupKey.BTN_WUHUN_BACK)
        self:onHideView()

        -- stepCallBack(G_GUIDE_30119)                 -- 30024 点击返回

    end
    local function onSacrificeClick()
        cclog("onSacrificeClick")
        getAudioManager():playEffectButton2()
        self:onHideView()
    end

    self.UISecretShopView["UISmeltShop"] = {}
    self.UISecretShopView["UISmeltShop"]["backMenuClick"] = onCloseClick
    self.UISecretShopView["UISmeltShop"]["onRefresh"] = onRefreshClick
    self.UISecretShopView["UISmeltShop"]["onChangeClick"] = onExchangeClick
    self.UISecretShopView["UISmeltShop"]["onCheckClick"] = onCheckClick
end

function PVSecretShop:initViewList(itemCount)
    if self.scrollView then 
        -- self.scrollView:removeFromParent(true) 
        self:removeChildByTag(1001)
        self.scrollView = nil 
    end

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
    self.scrollView = CustomScrollView.new(self.contentLayer, otherCondition)
    self.scrollView:setDelegate(self)
    -- self.scrollView:setPositionY(self.scrollView:getPositionY()+60)

    if self.scrollView ~= nil then
        for i = 1 , tonumber(itemCount) do
            local item = PVExchangeShopItem.new(self.soulList[i], 1)
            self.scrollView:addCell(item)
        end

        -- self:addChild(self.scrollView)
        self:addChild(self.scrollView,0,1001)
    end
end

function PVSecretShop:onClickScrollViewCell(cell)
    cclog("------------updateViewCallBack--------")
    local data= cell:getData()
    table.print(data)
    if data ~= nil or self.curData ~= nil then
        self.curData = data
        if data.got then 
            self.changeMenu:setEnabled(false)
            SpriteGrayUtil:drawSpriteTextureGray(self.changeMenu:getNormalImage()) 
        else 
            self.changeMenu:setEnabled(true) 
            SpriteGrayUtil:drawSpriteTextureColor(self.changeMenu:getNormalImage())
        end

        local gainData = data.gain
        local gainKey = tonumber(table.getKeyByIndex(gainData, 1))
        local gainValue = table.getValueByIndex(gainData, 1)
        setCommonDrop(gainKey, gainValue[3], self.itemIcon, self.itemName, self.itemDetail)
        local consumeData = data.consume
        local useMoney = table.getValueByIndex(consumeData, 1)[1]
        -- self.scoreLabel:setString(useMoney)
        table.print(data)
    end
end


function PVSecretShop:initCheckView(data)
    if data ~= nil or self.curData ~= nil then
        self.curData = data
        if data.got then 
            self.changeMenu:setEnabled(false)
            SpriteGrayUtil:drawSpriteTextureGray(self.changeMenu:getNormalImage()) 
        else 
            self.changeMenu:setEnabled(true) 
            SpriteGrayUtil:drawSpriteTextureColor(self.changeMenu:getNormalImage())
        end

        local gainData = data.gain
        local gainKey = tonumber(table.getKeyByIndex(gainData, 1))
        local gainValue = table.getValueByIndex(gainData, 1)
        setCommonDrop(gainKey, gainValue[3], self.itemIcon, self.itemName, self.itemDetail)
        local consumeData = data.consume
        local useMoney = table.getValueByIndex(consumeData, 1)[1]
        -- self.scoreLabel:setString(useMoney)
        -- table.print(data)
    end
end

-- function PVSecretShop:initTableView()
--     local function tableCellTouched(tbl, cell)
--         print("soul list touched at index: " .. cell:getIdx())
--     end
--     local function numberOfCellsInTableView(tab)
--        return table.nums(self.soulList)
--     end
--     local function cellSizeForTable(tbl, idx)
--         return 148, 555
--     end
--     local function tableCellAtIndex(tbl, idx)
--         local cell = tbl:dequeueCell()
--         if nil == cell then
--             cell = cc.TableViewCell:new()

--             local function onBuyMenuClick()
--                 if self.buySwitch then
--                     self.buySwitch = false
--                     local id = self.soulList[cell:getIdx()+1].id
--                     print("1GGGGGG buy", id)
--                     self.buyGoodsId = id
--                     self.useMoney = tonumber(cell.labelMoney:getString())
--                     if self.commonData:getHeroSoul() >= self.useMoney then
--                         self.gainType = cell.gainType
--                         self.gainValue = cell.gainValue
--                         self.gainNum = cell.gainNum
--                         if getNewGManager():getCurrentGid() == GuideId.G_GUIDE_30023 or getNewGManager():getCurrentGid() == GuideId.G_GUIDE_30034 then
--                             local guidInfo = getNewGManager():getCurrentInfo()
--                             getNewGManager():setGidWithProtocol(true, guidInfo["skip_to"])
--                         else
--                             getNetManager():getShopNet():sendBuyGoods(id)
--                         end
--                     else
--                         -- self:toastShow(Localize.query("shop.9"))
--                         if getNewGManager():getCurrentGid() == GuideId.G_GUIDE_30023 or getNewGManager():getCurrentGid() == GuideId.G_GUIDE_30034 then
--                             getNewGManager():setCurrentGID(GuideId.G_GUIDE_30035)
--                             groupCallBack(GuideGroupKey.BTN_CLOSE_WUHUN_SHOP)
--                         end
--                         getOtherModule():showAlertDialog(nil, Localize.query("shop.9"))
--                         self.buySwitch = true
--                     end
--                 end
--             end

--             local function onItemClick()
--                 local equipData = self.soulList[cell:getIdx()+1]
--                 local k = table.getKeyByIndex(equipData.gain, 1)
--                 local vId = equipData.gain[tostring(k)][3]
--                 if k == "103" then
--                     local nowPatchNum = getDataManager():getSoldierData():getPatchNumById(vId)
--                     getOtherModule():showOtherView("PVCommonChipDetail", 1, vId, nowPatchNum, 1)
--                 elseif k == "105" then
--                      getOtherModule():showOtherView("PVCommonDetail", 1, vId, 1)
--                 elseif k == "107" then
--                     getOtherModule():showOtherView("PVCommonDetail", 2, vId, 1)
--                 end
--             end

--             cell.cardinfo = {}
--             local proxy = cc.CCBProxy:create()
--             cell.cardinfo["UISecretShopItem"] = {}
--             cell.cardinfo["UISecretShopItem"]["onChangeClick"] = onBuyMenuClick
--             cell.cardinfo["UISecretShopItem"]["onItemClick"] = onItemClick
--             local node = CCBReaderLoad("soul/ui_shop_item.ccbi", proxy, cell.cardinfo)

--             -- 获取Item上的控件
--             cell.icon = cell.cardinfo["UISecretShopItem"]["headIcon"]
--             cell.equipName = cell.cardinfo["UISecretShopItem"]["equipName"]
--             cell.imgHalf = cell.cardinfo["UISecretShopItem"]["img_half"]
--             cell.labelMoney = cell.cardinfo["UISecretShopItem"]["money_value"]
--             cell.menuBuy = cell.cardinfo["UISecretShopItem"]["menu_buy"]
--             cell.labelNum = cell.cardinfo["UISecretShopItem"]["label_num"]

--             cell:addChild(node)
--         end
--         cell.index = idx
--         -- 获取数据中的值
--         local soulData = self.soulList[idx+1]

--         local gainData = soulData.gain
--         local gainKey = tonumber(table.getKeyByIndex(gainData, 1))
--         local gainValue = table.getValueByIndex(gainData, 1)

--         cell.gainType = gainKey
--         cell.gainValue = gainValue[3]
--         cell.gainNum = gainValue[1]

--         -- 分类处理,更改名字，图标
--         if gainKey == 101 then -- hero
--             local _temp = self.soldierTemp:getSoldierIcon(gainValue[3])
--             local quality = self.soldierTemp:getHeroQuality(gainValue[3])
--             changeNewIconImage(cell.icon, _temp, quality)
--             cell.equipName:setString(self.soldierTemp:getHeroName(gainValue[3]))
--         elseif gainKey == 102 then -- equipment
--             local _temp = self.equipTemp:getEquipResIcon(gainValue[3])
--             local quality = self.equipTemp:getQuality(gainValue[3])
--             changeEquipIconImageBottom(cell.icon, _temp, quality)
--             cell.equipName:setString(self.equipTemp:getEquipName(gainValue[3]))
--         elseif gainKey == 103 then -- hero chip;
--             local _temp = self.chipTemp:getTemplateById(gainValue[3]).resId
--             local _icon = self.resourceTemp:getResourceById(_temp)
--             local _quality = self.chipTemp:getTemplateById(gainValue[3]).quality
--             setChipWithFrame(cell.icon,"res/icon/hero/".._icon, _quality)
--             cell.equipName:setString(self.chipTemp:getChipName(gainValue[3]))
--         elseif gainKey == 104 then -- equipment chip
--             local _temp = self.chipTemp:getTemplateById(gainValue[3]).resId
--             local _icon = self.resourceTemp:getResourceById(_temp)
--             local _quality = self.chipTemp:getTemplateById(gainValue[3]).quality
--             setChipWithFrame(cell.icon,"res/icon/equipment/".._icon, _quality)
--             cell.equipName:setString(self.chipTemp:getChipName(gainValue[3]))
--         elseif gainKey == 105 then -- item
--             local _temp = self.bagTemp:getItemResIcon(gainValue[3])
--             local quality = self.bagTemp:getItemQualityById(gainValue[3])
--             setCardWithFrame(cell.icon, "res/icon/item/".._temp, quality)
--             cell.equipName:setString(self.bagTemp:getItemName(gainValue[3]))
--         elseif gainKey == 106 then -- big_bag
--             -- to do 不用大包吧
--         elseif gainKey == 107 then  -- resource   元气
--             local _res = self.resourceTemp:getResourceById(gainValue[3])
--             setItemImage(cell.icon, "res/icon/resource/".._res, 1)

--             local nameStr = self.resourceTemp:getResourceName(gainValue[3])
--             cell.equipName:setString(nameStr)
--         else
--             local _res = self.resourceTemp:getResourceById(gainValue[3])
--             setItemImage(cell.icon, "#".._res, 1)
--             local nameStr = self.resourceTemp:getResourceName(gainValue[3])
--             cell.equipName:setString(nameStr)
--         end


--         local consumeData = soulData.consume
--         local useMoney = table.getValueByIndex(consumeData, 1)[1]
--         local discout = soulData.discountPrice
--         if table.nums(discout) ~= 0 then cell.imgHalf:setVisible(true); useMoney = useMoney / 2
--         else cell.imgHalf:setVisible(false)
--         end

--         cell.labelMoney:setString(useMoney)
--         cell.labelNum:setString(tostring("x "..gainValue[1]))

--         if soulData.got then
--             cell.menuBuy:setEnabled(false)
--             cell.menuBuy:setSelectedImage(game.newSprite("#ui_shop_s_gotit.png"))
--         else
--             cell.menuBuy:setEnabled(true)
--             cell.menuBuy:setSelectedImage(game.newSprite("#ui_soul_s_dh.png"))
--         end

--         return cell
--     end

--     local layerSize = self.contentLayer:getContentSize()
--     self.soulTableView = cc.TableView:create(layerSize)
--     self.soulTableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
--     self.soulTableView:setDelegate()
--     self.soulTableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
--     self.contentLayer:addChild(self.soulTableView)

--     self.soulTableView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
--     self.soulTableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
--     self.soulTableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
--     self.soulTableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)

--     local scrBar = PVScrollBar:new()
--     scrBar:init(self.soulTableView,1)
--     scrBar:setPosition(cc.p(layerSize.width,layerSize.height/2))
--     self.contentLayer:addChild(scrBar,2)
-- end


return PVSecretShop


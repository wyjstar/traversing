-- 装备熔炼商店

local TYPE_SHOP_SMELT = 11
local COLUMN_NUM = 3
local COLUMN_SPACE = 30
local CustomScrollView = import("....util.CustomScrollView")
local PVExchangeShopItem = import("src.app.ui.homepage.soul.PVExchangeShopItem")

local PVEquipShop = class("PVEquipShop", BaseUIView)

function PVEquipShop:ctor(id)
    PVEquipShop.super.ctor(self, id)

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

    self.SoulShopTemplate = getTemplateManager():getSoulShopTemplate()
end

function PVEquipShop:onMVCEnter()
    game.addSpriteFramesWithFile("res/ccb/resource/ui_smelt.plist")
    self.UISmeltShop = {}

    self:initTouchListener()
    -- self:loadCCBI("equip/ui_equip_shop.ccbi", self.UISmeltShop)
    self:loadCCBI("equip/ui_equip_shop_new.ccbi", self.UISmeltShop)

    self:initView()
    -- self:initTableView()
    -- 获取武魂商店列表
    getNetManager():getShopNet():sendGetShopList(TYPE_SHOP_SMELT)   
end

function PVEquipShop:initView()
    -- self.contentLayer = self.UISmeltShop["UISmeltShop"]["listLayer"]
    -- self.totalEquipSoulNum = self.UISmeltShop["UISmeltShop"]["equipsoul_value"]  --装备精华
    -- self.freeTimesLablel = self.UISmeltShop["UISmeltShop"]["label_free_refresh"]
    -- self.refreshBtn = self.UISmeltShop["UISmeltShop"]["refreshBtn"]
    -- self.refreshMoney = self.UISmeltShop["UISmeltShop"]["refresh_money"]
    -- -- self.nodeEquip = self.UISmeltShop["UISmeltShop"]["nodeEquip"]
    -- self.refreshTimes = self.UISmeltShop["UISmeltShop"]["refreshTimes"]
    -- -- self.nodeEquip:setVisible(true)
    -- self.nodeRefreshMoney = self.UISmeltShop["UISmeltShop"]["node_refresh_money"]
    -- self.nodeRefreshFree = self.UISmeltShop["UISmeltShop"]["node_free"]
    -- self.nodeRefreshFree:setVisible(false)

    self.contentLayer = self.UISmeltShop["UISmeltShop"]["listLayer"]

    self.freeTimesLablel = self.UISmeltShop["UISmeltShop"]["label_free_refresh"]
    self.nodeRefreshMoney = self.UISmeltShop["UISmeltShop"]["node_refresh_money"]
    self.nodeRefreshFree = self.UISmeltShop["UISmeltShop"]["node_free"]
    self.totalEquipSoulNum = self.UISmeltShop["UISmeltShop"]["equipsoul_value"]
    self.refreshTimes = self.UISmeltShop["UISmeltShop"]["refreshTimes"]
    self.refreshBtn = self.UISmeltShop["UISmeltShop"]["refreshBtn"]
    self.shopTitle = self.UISmeltShop["UISmeltShop"]["shop_title"]
    self.oweConsume = self.UISmeltShop["UISmeltShop"]["owe_consume"]

    self.itemIcon = self.UISmeltShop["UISmeltShop"]["itemIcon"]
    self.itemName = self.UISmeltShop["UISmeltShop"]["itemName"]
    self.itemDetail = self.UISmeltShop["UISmeltShop"]["itemDetail"] 
    self.refreshMoney = self.UISmeltShop["UISmeltShop"]["refresh_money"]
    self.changeMenu = self.UISmeltShop["UISmeltShop"]["changeMenu"]

    game.setSpriteFrame(self.shopTitle, "#ui_smelt_s_jhsd.png")
    game.setSpriteFrame(self.oweConsume, "#ui_rongLian.png")
end

function PVEquipShop:initRegisterNetCallBack()
    function onGetShopListCallBack(id, data)
        print("get secretshop list ...")
        if data.res.result ~= true then
            print("!!! 数据返回错误")
        else
            self.shopData:setSmeltList(data.id)
            self.shopData:setSmeltGotList(data.buyed_id)

            if self.speSign then
                self.shopTemp:addSpecialGoodsBuyed(self.buyGoodsId)
            end

            self:updateData()
        end
    end
    local function onRefreshCallback(id, data) -- flash
        if data.res.result ~= true then
            print("!!! 数据返回错误")
        else
            print("!!! onRefreshCallback")
            self.shopData:setSmeltList(data.id)
            self.shopData:setSmeltGotList(data.buyed_id)
            self.shopData:addRefreshTimes(1)

            self:updateData()
            if self.shopData:getRefreshTimes() > self.shopTemp:getRefreshTimesInEquipShop() then
                self.commonData:subGold(self.flashMoney)
            end

            if self.baseTemp:getShopRefreshTimes(self.commonData:getVip()) <= self.shopData:getRefreshTimes() then
                self.refreshBtn:setEnabled(false)
            end
            -- --初始化属性
        end
    end

    local function getGoods(data)
        self.commonData:subEquipSoul( self.useMoney )
        if self.gainType == 102 then  -- 装备类型的
            -- local data = {}
            -- data.no = self.gainValue
            -- getModule(MODULE_NAME_pvexHOMEPAGE):showUIViewAndInTop("PVEquipShowCard", {data})  -- 要满足格式
            getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVEquipmentAttribute", data.gain.equipments[1]) --购买了装备，采用跳转到装备详情界面

        else  -- 其他类型的
            getModule(MODULE_NAME_HOMEPAGE):showUITopShowLastView("PVExchangeDialog", self.buyGoodsId)
        end
    end

    local function getGoodsCallback(id, data)
        -- getModule(MODULE_NAME_HOMEPAGE):showUITopShowLastView("PVExchangeDialog", self.buyGoodsId)
        if data.res.result ~= true then
            print("!!! 数据返回错误")
        else
            print("!!! getGoodlsCallback")
            getGoods(data)
        end
    end

    local function getGoodsByGuidCallback(id, data)
        print("PVEquipShop:getGoodsByGuidCallback ")
        table.print(data)
        if getNewGManager():getCurrentGid() == GuideId.G_GUIDE_40075 then
            getGoods(data)
            getNewGManager():startGuide(GuideId.G_GUIDE_40075)
            return
        end

        if getNewGManager():getCurrentGid() == GuideId.G_GUIDE_40074 then
            getGoods(data)
            getNewGManager():startGuide(GuideId.G_GUIDE_40074)
        end
        
    end

    self:registerMsg(SHOP_GET_ITEM_CODE, onGetShopListCallBack)
    self:registerMsg(SHOP_REFRESH_CODE, onRefreshCallback)
    self:registerMsg(SHOP_BUY_GOODS_CODE, getGoodsCallback)
    self:registerMsg(NewbeeGuideStep, getGoodsByGuidCallback)
end


function PVEquipShop:updateData()
    local _idsList = self.shopData:getSmeltList()
    local _idsGotList = self.shopData:getSmeltGotList()
    local _flashMoney, _flashType = self.shopTemp:getFlashMoney(TYPE_SHOP_SMELT)

    -- 获取商城装备数据
    self.goodsList = {}
    print("PVEquipShop:updateData====================>", getNewGManager():getCurrentGid())

    if ISSHOW_GUIDE and (getNewGManager():getCurrentGid() == GuideId.G_GUIDE_40042 or getNewGManager():getCurrentGid() == GuideId.G_GUIDE_40043) then       --新手引导中特殊处理，服务器没有推送任何东西的情况下

        cclog("-----tschuli-------")
        self.speSign = true
        self.goodsList = {}
        _idsList =  self.shopTemp:getSpecialGoods()
        _idsGotList = self.shopTemp:getSpecialGoodsBuyed()
        for k,v in pairs(_idsList) do 
            table.insert(self.goodsList,v)
        end
        if _idsGotList then
            for k,v in pairs(_idsGotList) do
                table.insert(self.goodsList,v)
            end
        end
    else
        for k,v in pairs(_idsList) do
            local value = self.shopTemp:getTemplateById(v)
            value.got = false
            table.insert(self.goodsList, value)
        end
        for k,v in pairs(_idsGotList) do
            local value = self.shopTemp:getTemplateById(v)
            value.got = true
            table.insert(self.goodsList, value)
        end
    end

 table.sort( self.goodsList, function (a,b) return a.id < b.id end )
-- print("@@@@@@@@@@@@@@@@@")
-- table.print(self.goodsList)
-- print("@@@@@@@@@@@@@@@@@")
    self.itemCount = table.nums(self.goodsList)
    --初始化默认显示第一个装备的详细信息
    self.curData = self.goodsList[1]
    self:initCheckView(self.curData)
    --初始化装备列表
    self:initViewList(self.itemCount)


    -- self.soulTableView:reloadData()
    -- self:tableViewItemAction(self.soulTableView)

    self.flashMoney = _flashMoney
    self.refreshMoney:setString(tostring( self.flashMoney ))

    self.totalEquipSoulNum:setString(tostring( self.commonData:getEquipSoul() ))

    -- if self.baseTemp:getShopRefreshTimes(self.commonData:getVip()) > self.shopData:getRefreshTimes() then
    --     self.refreshTimes:setString(tostring(self.baseTemp:getShopRefreshTimes(self.commonData:getVip()) - self.shopData:getRefreshTimes()))
    --     self.refreshBtn:setEnabled(true)
    -- else 
    --     self.refreshTimes:setString(0)
    --     self.refreshBtn:setEnabled(false)
    -- end

    local totalFreshTimes = self.baseTemp:getShopRefreshTimes(self.commonData:getVip())
    local usedFreshTimes = self.shopData:getRefreshTimes()
    if totalFreshTimes > usedFreshTimes then
        self.refreshTimes:setString(tostring(totalFreshTimes - usedFreshTimes).."/"..totalFreshTimes)
        self.refreshBtn:setEnabled(true)
    else
        self.refreshTimes:setString("0".."/"..totalFreshTimes)
        self.refreshBtn:setEnabled(false)
    end
    -- self.shopTemp:getRefreshTimesInEquipShop()

    -- if self.shopData:getRefreshTimes() >= self.shopTemp:getRefreshTimesInEquipShop() then
    --     self.nodeRefreshFree:setVisible(false)
    --     self.nodeRefreshMoney:setVisible(true)
    -- else
    --     self.freeTimesLablel:setString(self.shopTemp:getRefreshTimesInEquipShop() - self.shopData:getRefreshTimes().."次")
    --     self.nodeRefreshFree:setVisible(true)
    --     self.nodeRefreshMoney:setVisible(false)
    -- end
end

function PVEquipShop:initTouchListener()
    --兑换
    local function onExchangeClick()
        cclog("onExchangeClick")
        getAudioManager():playEffectPage()
      
        if self.commonData:getEquipSoul() >= self.useMoney then

            if getNewGManager():getCurrentGid() == GuideId.G_GUIDE_40043 or getNewGManager():getCurrentGid() == GuideId.G_GUIDE_40042 then
                local guidInfo = getNewGManager():getCurrentInfo()
                getNewGManager():setGidWithProtocol(true, guidInfo["skip_to"])
            else
                getNetManager():getShopNet():sendBuyGoods(self.buyGoodsId)
            end
        else
            -- self:toastShow(Localize.query("shop.18"))
            if getNewGManager():getCurrentGid() == GuideId.G_GUIDE_40043 or getNewGManager():getCurrentGid() == GuideId.G_GUIDE_40042 then
                getNewGManager():setCurrentGID(GuideId.G_GUIDE_40075)
                groupCallBack(GuideGroupKey.BTN_EQUIPATTR_IN_EXCHANGE)
            end
            getOtherModule():showAlertDialog(nil, Localize.query("shop.18"))
        end
    end

    --查看
    local function onCheckClick()
        local gainData = self.curData.gain
        local gainKey = tonumber(table.getKeyByIndex(gainData, 1))
        local gainValue = table.getValueByIndex(gainData, 1)
        checkCommonDetail(gainKey, gainValue[3])
    end

    local function onRefreshClick()
        cclog("onRefreshClick")
        getAudioManager():playEffectButton2()
        local refreshTimes = self.baseTemp:getShopRefreshTimes(self.commonData:getVip()) + self.shopTemp:getRefreshTimesInEquipShop() - self.shopData:getRefreshTimes()
        if refreshTimes > 0 then
            if self.shopData:getRefreshTimes() >= self.shopTemp:getRefreshTimesInEquipShop() then
                if self.commonData:getGold() < self.flashMoney then
                    getOtherModule():showAlertDialog(nil, Localize.query("shop.8"))
                else
                    getNetManager():getShopNet():sendRefreshShopList(TYPE_SHOP_SMELT)
                end
            else
                getNetManager():getShopNet():sendRefreshShopList(TYPE_SHOP_SMELT)
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
        self:onHideView()

        -- stepCallBack(G_GUIDE_40129)    --点击返回 
        -- stepCallBack(G_GUIDE_40130)
        groupCallBack(GuideGroupKey.BTN_CLOSE_EXCHANGE)
    end

    self.UISmeltShop["UISmeltShop"] = {}
    self.UISmeltShop["UISmeltShop"]["onRefresh"] = onRefreshClick
    self.UISmeltShop["UISmeltShop"]["backMenuClick"] = onCloseClick
    self.UISmeltShop["UISmeltShop"]["onChangeClick"] = onExchangeClick
    self.UISmeltShop["UISmeltShop"]["onCheckClick"] = onCheckClick
end

function PVEquipShop:initViewList(itemCount)
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
    if self.scrollView ~= nil then
        for i = 1 , tonumber(itemCount) do
            local item = PVExchangeShopItem.new(self.goodsList[i], 2)
            self.scrollView:addCell(item)
        end

        self:addChild(self.scrollView,0,1001)
    end
end


function PVEquipShop:initCheckView(data)
    if data ~= nil or self.curData ~= nil then
        self.curData = data
        
        self.buyGoodsId = data.id
        local gainData = data.gain
        self.gainType = tonumber(table.getKeyByIndex(gainData, 1))
        local gainValue = table.getValueByIndex(gainData, 1)
        self.gainValue = gainValue[3]
        self.gainNum = gainValue[1]
        local consumeData = data.consume
        self.useMoney = table.getValueByIndex(consumeData, 1)[1]
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

function PVEquipShop:onClickScrollViewCell(cell)
    local data = cell:getData()
    if data ~= nil or self.curData ~= nil then
        self.curData = data
        
        self.buyGoodsId = data.id
        local gainData = data.gain
        self.gainType = tonumber(table.getKeyByIndex(gainData, 1))
        local gainValue = table.getValueByIndex(gainData, 1)
        self.gainValue = gainValue[3]
        self.gainNum = gainValue[1]
        local consumeData = data.consume
        self.useMoney = table.getValueByIndex(consumeData, 1)[1]
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

-- function PVEquipShop:initTableView()
--     local function tableCellTouched(tbl, cell)
--         print("soul list touched at index: " .. cell:getIdx())
--     end
--     local function numberOfCellsInTableView(tab)
--        return table.nums(self.goodsList)
--     end
--     local function cellSizeForTable(tbl, idx)
--         return 148, 555
--     end
--     local function tableCellAtIndex(tbl, idx)
--         local cell = tbl:dequeueCell()
--         if nil == cell then
--             cell = cc.TableViewCell:new()

--             local function onBuyMenuClick()
--                 local id = self.goodsList[cell:getIdx()+1].id
--                 -- print("GGGGGG buy", id)
--                 self.buyGoodsId = id
--                 self.useMoney = tonumber(cell.labelMoney:getString())
--                 -- cclog("---onBuyMenuClick--"..self.commonData:getEquipSoul().."--- self.useMoney---".. self.useMoney)

--                 if self.commonData:getEquipSoul() >= self.useMoney then
--                     self.gainType = cell.gainType
--                     self.gainValue = cell.gainValue
--                     if getNewGManager():getCurrentGid() == GuideId.G_GUIDE_40043 or getNewGManager():getCurrentGid() == GuideId.G_GUIDE_40042 then
--                         local guidInfo = getNewGManager():getCurrentInfo()
--                         getNewGManager():setGidWithProtocol(true, guidInfo["skip_to"])
--                     else
--                         getNetManager():getShopNet():sendBuyGoods(id)
--                     end
--                 else
--                     -- self:toastShow(Localize.query("shop.18"))
--                     if getNewGManager():getCurrentGid() == GuideId.G_GUIDE_40043 or getNewGManager():getCurrentGid() == GuideId.G_GUIDE_40042 then
--                         getNewGManager():setCurrentGID(GuideId.G_GUIDE_40075)
--                         groupCallBack(GuideGroupKey.BTN_EQUIPATTR_IN_EXCHANGE)
--                     end
--                     getOtherModule():showAlertDialog(nil, Localize.query("shop.18"))
--                 end
--             end

--             local function onItemClick()
--                 getAudioManager():playEffectButton2()

--                 local soulData = self.goodsList[cell:getIdx()+1]
--                 -- print("onItemClick ================= "..idx)
--                 -- table.print(soulData)
--                 -- local gainData = soulData.gain

--                 local k = table.getKeyByIndex(soulData.gain, 1)
--                 local vId = soulData.gain[tostring(k)][3] 

--                 if k == "102" then
--                     local equipment = getTemplateManager():getEquipTemplate():getTemplateById(vId)
--                     getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVOtherEquipAttribute", equipment, 2)
--                 elseif k == "104" then
--                     local nowPatchNum = getDataManager():getEquipmentData():getPatchNumById(vId)
--                     getOtherModule():showOtherView("PVCommonChipDetail", 2, vId, nowPatchNum, 1)
--                 end
--             end

--             cell.cardinfo = {}
--             local proxy = cc.CCBProxy:create()
--             cell.cardinfo["UISecretShopItem"] = {}
--             cell.cardinfo["UISecretShopItem"]["onChangeClick"] = onBuyMenuClick

--             cell.cardinfo["UISecretShopItem"]["onItemClick"] = onItemClick

--             local node = CCBReaderLoad("equip/ui_equip_shop_item.ccbi", proxy, cell.cardinfo)

--             -- 获取Item上的控件
--             cell.icon = cell.cardinfo["UISecretShopItem"]["headIcon"]
--             cell.equipName = cell.cardinfo["UISecretShopItem"]["equipName"]
--             cell.imgHalf = cell.cardinfo["UISecretShopItem"]["img_half"]
--             cell.labelMoney = cell.cardinfo["UISecretShopItem"]["money_value"]
--             cell.menuBuy = cell.cardinfo["UISecretShopItem"]["menu_buy"]
--             cell.labelNum = cell.cardinfo["UISecretShopItem"]["label_num"]
--             cell.itemMenuItem = cell.cardinfo["UISecretShopItem"]["itemMenuItem"]

--             cell.itemMenuItem:setAllowScale(false)

--             cell:addChild(node)
--         end
--         cell.index = idx
--         -- 获取数据中的值
--         local soulData = self.goodsList[idx+1]

--         local gainData = soulData.gain
--         local gainKey = tonumber(table.getKeyByIndex(gainData, 1))
--         local gainValue = table.getValueByIndex(gainData, 1)

--         cell.gainType = gainKey
--         cell.gainValue = gainValue[3]

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
--         else -- resource
--             local _res = self.resourceTemp:getResourceById(gainValue[3])
--             setItemImage(cell.icon, "#".._res, 1)
--             local nameStr = self.resourceTemp:getResourceName(gainValue[3])
--             cell.equipName:setString(nameStr)
--         end

--         local consumeData = soulData.consume
--         local useMoney = table.getValueByIndex(consumeData, 1)[1]
--         local discout = soulData.discountPrice
--         if table.nums(discout) ~= 0 then
--             cell.imgHalf:setVisible(true)
--             useMoney = useMoney / 2
--         else
--             cell.imgHalf:setVisible(false)
--         end

--         if useMoney > self.commonData:getEquipSoul() then
--             cell.labelMoney:setColor(ui.COLOR_RED)
--         else
--             cell.labelMoney:setColor(ui.COLOR_WHITE)
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

-- 上层dialog关闭之后会调用这个
function PVEquipShop:onReloadView()
    cclog("onReloadView")
    getNetManager():getShopNet():sendGetShopList(TYPE_SHOP_SMELT)   -- 更新
end


return PVEquipShop

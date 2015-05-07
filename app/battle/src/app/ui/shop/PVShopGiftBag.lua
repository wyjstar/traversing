
-- 商城的礼品窗口ui
--[[
   展示一个道具列表, 使用方法：
   @ 先调用setViewSize(size)
   @ 在调用initTableView()
]]

local PVShopGiftBag = class("PVShopGiftBag",function ()
    return cc.Node:create()
end)


function PVShopGiftBag:ctor() 
    --初始化属性
    self:init()
end

--初始化属性
function PVShopGiftBag:init()

    cclog("进入来商城礼包111111111111")
    self.commonData = getDataManager():getCommonData()
    self.bagTemplate = getTemplateManager():getBagTemplate()
    self.shopTemp = getTemplateManager():getShopTemplate()
    self.shopData = getDataManager():getShopData()
    self.dropTemp = getTemplateManager():getDropTemplate()

    
    self.num = 0
    self.tableView = nil
    self.tableViewSize = nil  -- tableView 的大小尺寸

    self.goodData = {}

    self:initData()

    self.tabFlag = true
    
end

--初始化礼品 应该是读表 目前是假数据 随便写点
function PVShopGiftBag:initData()
    self.goodData = {
    }

    --获取itemSize大小
    local tempTab = {}
    local proxy = cc.CCBProxy:create()
    CCBReaderLoad("shop/ui_shop_pp.ccbi", proxy, tempTab)
    local node = tempTab["UIShopProp"]["cellBg"]
    self.itemSize = node:getContentSize()
end


 function PVShopGiftBag:initTableView()

    assert(self.tableViewSize ~= nil, "tableView size can not be nil .." )

    self.tableView = cc.TableView:create(self.tableViewSize)
    --self.tableView:ignoreAnchorPointForPosition(false)
    --self.tableView:setAnchorPoint(0.5,0)
    self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    --self.tableView:setPosition(0, -10)
    self.tableView:setDelegate()

    self:addChild(self.tableView)

    self.tableView:registerScriptHandler(function(table) return self:numberOfCellsInTableView(table) end, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.tableView:registerScriptHandler(function(table, idx) return self:cellSizeForTable(table, idx) end, cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView:registerScriptHandler(function(table, idx) return self:tableCellAtIndex(table, idx) end, cc.TABLECELL_SIZE_AT_INDEX)
    self.tableView:registerScriptHandler(function(table, idx) return self:tableCellTouched(table, idx) end, cc.TABLECELL_TOUCHED)

    self.tableView:reloadData()
end


function PVShopGiftBag:setViewSize(size)
    self.tableViewSize = size
end

function PVShopGiftBag:tableCellTouched(tbl, cell)
    print("商城礼包 ======= buy equipment cell touched at index: " .. cell:getIdx())
end

function PVShopGiftBag:cellSizeForTable(table, idx)
    return self.itemSize.height, self.itemSize.width
end

function PVShopGiftBag:numberOfCellsInTableView(table)
    -- print("numberOfCellsInTableView ==",#self.goodData)
   return #self.goodData
end

-- function PVShopGiftBag:tableCellAtIndex(table, idx)
    
--     local tempGoodData = self.goodData[idx+1]
--     local cell = table:dequeueCell()
--     if nil == cell then
--         cell = cc.TableViewCell:new()
--     end

--     local RGItem = {}
--     --购买按钮
--     local function menuClickBuy() --购买按钮回调事件
--         print("I buy it ......", tempGoodData.id)
--     end
--     RGItem["UIShopProp"] = {}
--     RGItem["UIShopProp"]["menuClickBuy"] = menuClickBuy

--     local proxy = cc.CCBProxy:create()
--     local cellItem = CCBReaderLoad("shop/ui_shop_pp.ccbi", proxy, RGItem)
--     cell:addChild(cellItem)

--     local labelTime = RGItem["UIShopProp"]["labelTime"]
--     local labelName = RGItem["UIShopProp"]["labelName"]
--     local labelMoney = RGItem["UIShopProp"]["labelPrice"]
--     local labelCount = RGItem["UIShopProp"]["labelCount"]
--     local labelLimit = RGItem["UIShopProp"]["labelLimit"]
--     local imgGoods = RGItem["UIShopProp"]["goodImg"]
   
--     labelName:setString(tempGoodData.name)
--     labelTime:setString(tempGoodData.time)
--     labelMoney:setString(tempGoodData.price)
--     labelCount:setString(tempGoodData.count)
--     --img:setSpriteFrameName("...")

--     return cell
-- end

function PVShopGiftBag:tableCellAtIndex(tbl, idx)
    local cell = tbl:dequeueCell()
    if nil == cell then
        cell = cc.TableViewCell:new()

        local function onBuyMenuClick()
            local id = self.giftBagTable[cell:getIdx() + 1].id
            print("2GGGGGG buy", id)
            cclog("cell:getIdx()"..cell:getIdx())
            -- self.useMoney = tonumber(cell.labelCoin:getString())
            self.useMoney = cell.useMoney
            self.moneyType = cell.moneyType
            local coinValue = self.commonData:getCoin()
            local goldValue = self.commonData:getGold()
            self.shopData:setProBuyTypeAndMoney(self.moneyType,self.useMoney)
            if self.moneyType == 1 then
                if coinValue >= self.useMoney then 
                    cclog("购买请求发送")
                    getNetManager():getShopNet():sendBuyGoods(id)
                else 
                    -- self:toastShow(Localize.query("shop.10")) 
                    getOtherModule():showAlertDialog(nil, Localize.query("shop.10"))
                end
            elseif self.moneyType == 2 then
                if goldValue >= self.useMoney then 
                     cclog("购买请求发送")
                    getNetManager():getShopNet():sendBuyGoods(id)
                else
                    -- self:toastShow(Localize.query("shop.8"))
                    getOtherModule():showAlertDialog(nil, Localize.query("shop.8"))
                end
            end
            -- getOtherModule():showOtherView("DialogGetCard",cell.gain)
        end

        local function onItemClick()
            local giftBagData = self.giftBagTable[cell:getIdx() + 1]
            local item_no = giftBagData.gain["105"][3]
            getOtherModule():showOtherView("PVCommonDetail", 1, item_no, 1)
        end

        cell.cardinfo = {}
        local proxy = cc.CCBProxy:create()
        cell.cardinfo["UIShopEquip"] = {}
        cell.cardinfo["UIShopEquip"]["menuClickBuy"] = onBuyMenuClick
        cell.cardinfo["UIShopEquip"]["onItemClick"] = onItemClick
        local node = CCBReaderLoad("shop/ui_shop_equipitem.ccbi", proxy, cell.cardinfo)

        -- 获取Item上的控件
        cell.icon = cell.cardinfo["UIShopEquip"]["headIcon"]
        cell.equipName = cell.cardinfo["UIShopEquip"]["equipName"]
        cell.imgHalf = cell.cardinfo["UIShopEquip"]["img_half"]
        cell.goldNode = cell.cardinfo["UIShopEquip"]["node_gold"]
        cell.coinNode = cell.cardinfo["UIShopEquip"]["node_coin"]
        cell.labelCoin = cell.cardinfo["UIShopEquip"]["coin_value"]
        cell.labelGold = cell.cardinfo["UIShopEquip"]["gold_value"]
        cell.menuBuy = cell.cardinfo["UIShopEquip"]["menu_buy"]
        cell.itemMenuItem = cell.cardinfo["UIShopEquip"]["itemMenuItem"]

        cell.itemMenuItem:setAllowScale(false)

        cell:addChild(node)
    end
    cell.index = idx
    -- 获取数据中的值
    local giftBagData = self.giftBagTable[idx+1]
    cell.gain = giftBagData.gain
    table.print(cell.gain)
    local giftId = giftBagData.gain["106"][3]
    local list = self.dropTemp:getAllItemByBigbagId(giftId)

    local consumeData = giftBagData.consume
    local useMoneyType = tonumber(table.getKeyByIndex(consumeData, 1))
    local useMoney = table.getValueByIndex(consumeData, 1)[1]
    if useMoneyType == 107 then useMoneyType = tonumber(table.getValueByIndex(consumeData, 1)[3]) end

    local discout = giftBagData.discountPrice


    local _icon = self.bagTemplate:getItemResIcon(list[1].detailId)
    cclog("道具的icon".._icon)
    local _quality = self.bagTemplate:getItemQualityById(list[1].detailId)
    local _name = self.bagTemplate:getItemName(list[1].detailId)
    _icon = "res/icon/item/".._icon
    setItemImage(cell.icon, _icon, _quality)
    cell.equipName:setString(_name)

    if table.nums(discout) ~= 0 then
        cell.imgHalf:setVisible(true); useMoney = useMoney / 2
    else
        cell.imgHalf:setVisible(false)
    end

    if useMoneyType == 1 then
        cell.coinNode:setVisible(true)
        cell.goldNode:setVisible(false)
        cell.labelCoin:setString(useMoney)
        cell.moneyType = 1
    elseif useMoneyType == 2 then
        cell.coinNode:setVisible(false)
        cell.goldNode:setVisible(true)
        cell.labelGold:setString(useMoney)
        cell.moneyType = 2
    end

    if giftBagData.got then
        cell.menuBuy:setEnabled(false)
        cell.menuBuy:setSelectedImage(game.newSprite("#ui_shop_s_gotit.png"))
    else
        cell.menuBuy:setEnabled(true)
        cell.menuBuy:setSelectedImage(game.newSprite("#ui_shop_s_buy.png"))
    end

    cell.useMoney = useMoney
    return cell
end


--初始化属性
function PVShopGiftBag:updateData()

    local _idsList = self.shopData:getShopGiftBagList()
    local _idsGotList = self.shopData:getShopGiftBagGotList()

    -- 获取商城装备数据
    cclog("这里是商城获取商场数据")
    self.giftBagTable = {}

    for k,v in pairs(_idsList) do
        print(v)
        local value = self.shopTemp:getTemplateById(v)
        value.got = false
        table.insert(self.giftBagTable, value)
    end
    cclog("这里是商城获取商场数据")
    for k,v in pairs(_idsGotList) do
        print(v)
        local value = self.shopTemp:getTemplateById(v)
        value.got = true
        table.insert(self.giftBagTable, value)
    end

    local function cmp(a,b)
        return a.id < b.id
    end

    table.sort( self.giftBagTable, cmp )
    cclog("这里是商城获取商场数据11111")

    if self.tabFlag then
        self:initTableView() 
        self.tabFlag = false
    else
        self.tableView:reloadData()
    end

end

return PVShopGiftBag

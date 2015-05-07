
-- 商城的道具窗口ui
--[[
   展示一个道具列表, 使用方法：
   @ 先调用setViewSize(size)
   @ 在调用initTableView()
]]

local PVShopProp = class("PVShopProp",function ()
    return cc.Node:create()
end)


function PVShopProp:ctor()

    --初始化属性
    cclog("进入来道具商城")
    self:init()
    --self.shopTemp = getTemplateManager():getShopTemplate()

end



--初始化属性
function PVShopProp:init()
    cclog("进入来道具商城111111111111")
    self.commonData = getDataManager():getCommonData()
    self.bagTemplate = getTemplateManager():getBagTemplate()
    self.shopTemp = getTemplateManager():getShopTemplate()
    self.shopData = getDataManager():getShopData()
    self.shopProps = self.shopTemp:getPorps()
    if self.shopProps ~=nil then
        table.print(self.shopProps)
    else
        cclog("nononononononononnnononno")
    end

    self.num = 0
    self.tableView = nil
    self.tableViewSize = nil  -- tableView 的大小尺寸

    self:initData()

    self.tabFlag = true
    cclog("进入来道具商城111111111111")


end

--初始化商品数据 应该是读表 目前是假数据 随便写点
function PVShopProp:initData()
    self.goodData = {
    }

    --获取itemSize大小
    local tempTab = {}
    local proxy = cc.CCBProxy:create()
    CCBReaderLoad("shop/ui_shop_pp.ccbi", proxy, tempTab)
    local node = tempTab["UIShopProp"]["cellBg"]
    self.itemSize = node:getContentSize()
    -- cclog("发送协议333333")
    -- -- getNetManager():getShopNet():sendGetShopList(3)
    -- -- self.shopData:setShopType(3)
    -- cclog("发送协议333333")
    --self:updateData()
end


 function PVShopProp:initTableView()

    assert(self.tableViewSize ~= nil, "tableView size can not be nil .." )
    cclog("---------PVShopProp:initTableView------------")

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
    -- self:tableViewItemAction(self.tableView)
end


function PVShopProp:setViewSize(size)
    self.tableViewSize = size

end


function PVShopProp:tableCellTouched(tbl, cell)
    print("商城道具 ======= buy equipment cell touched at index: " .. cell:getIdx())
end

function PVShopProp:cellSizeForTable(tbl, idx)
    --return self.itemSize.height, self.itemSize.width
    return 148, 555
end

function PVShopProp:numberOfCellsInTableView(tbl)
    -- print("numberOfCellsInTableView ==",#self.goodData)
   --return #self.goodData
   print("self.proTable ============= ", self.proTable)
   --return table.getn(self.shopProps)
   return table.getn(self.proTable)
end


function PVShopProp:tableCellAtIndex(tbl, idx)
    local cell = tbl:dequeueCell()
    if nil == cell then
        cell = cc.TableViewCell:new()

        local function onBuyMenuClick()
            local id = self.proTable[cell:getIdx() + 1].id
            print("4GGGGGG buy", id)
            cclog("cell:getIdx()"..cell:getIdx())
            -- self.useMoney = tonumber(cell.labelCoin:getString())
            self.useMoney = cell.useMoney
            self.moneyType = cell.moneyType
            local coinValue = self.commonData:getCoin()
            local goldValue = self.commonData:getGold()
            -- self.shopData:setProBuyTypeAndMoney(self.moneyType,self.useMoney)
            --在这里做不进入选取数量的判断
            local vipLimte = self.shopTemp:getBuyVIPLimitNumById(id,getDataManager():getCommonData():getVip())
            if vipLimte ~= 0 and vipLimte <= self.shopData:getProLimitOneDayById(id) then
                if id == 30003 then
                    getOtherModule():showAlertDialog(nil, Localize.query("basic.4"))
                elseif id == 30002 then
                    getOtherModule():showAlertDialog(nil, Localize.query("basic.5"))
                end
                return
            end

            if self.moneyType == 1 then
                if coinValue >= self.useMoney then 
                    cclog("购买请求发送")
                    getOtherModule():showOtherView("PVShopBuyByNum",id)
                    -- getNetManager():getShopNet():sendBuyGoods(id)
                else 
                    -- self:toastShow(Localize.query("shop.10")) 
                    getOtherModule():showAlertDialog(nil, Localize.query("shop.10"))
                end
            elseif self.moneyType == 2 then
                if goldValue >= self.useMoney then 
                     cclog("购买请求发送")
                     getOtherModule():showOtherView("PVShopBuyByNum",id)
                    -- getNetManager():getShopNet():sendBuyGoods(id)
                else
                    -- self:toastShow(Localize.query("shop.8"))
                    getOtherModule():showAlertDialog(nil, Localize.query("shop.8"))
                end
            end
            -- getOtherModule():showOtherView("DialogGetCard",cell.gain)
        end

        local function onItemClick()
            local propData = self.proTable[cell:getIdx() + 1]
            local item_no = propData.gain["105"][3]
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
    local propData = self.proTable[idx+1]
    cell.gain = propData.gain
    table.print(cell.gain)
    local propId = propData.gain["105"][3]

    local consumeData = propData.consume
    local useMoneyType = tonumber(table.getKeyByIndex(consumeData, 1))
    local useMoney = table.getValueByIndex(consumeData, 1)[1]
    if useMoneyType == 107 then useMoneyType = tonumber(table.getValueByIndex(consumeData, 1)[3]) end

    local discout = propData.discountPrice


    local _icon = self.bagTemplate:getItemResIcon(propId)
    cclog("道具的icon".._icon)
    local _quality = self.bagTemplate:getItemQualityById(propId)
    local _name = self.bagTemplate:getItemName(propId)
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

    if propData.got then
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
function PVShopProp:updateData()

    local _idsList = self.shopData:getShopPropList()
    local _idsGotList = self.shopData:getShopPropGotList()

    -- 获取商城装备数据
    cclog("这里是商城获取商场数据")
    self.proTable = {}

    for k,v in pairs(_idsList) do
        print(v)
        local value = self.shopTemp:getTemplateById(v)
        value.got = false
        table.insert(self.proTable, value)
    end
    cclog("这里是商城获取商场数据")
    for k,v in pairs(_idsGotList) do
        print(v)
        local value = self.shopTemp:getTemplateById(v)
        value.got = true
        table.insert(self.proTable, value)
    end

    local function cmp(a,b)
        return a.id < b.id
    end

    table.sort( self.proTable, cmp )
    cclog("这里是商城获取商场数据11111")

    if self.tabFlag then
        self:initTableView() 
        self.tabFlag = false
    else
        self.tableView:reloadData()
    end

    -- print("@@@@@@@@@@@@@@@@@")
    -- table.print(self.equipmentTable)
    -- print("@@@@@@@@@@@@@@@@@")

    -- if self.equipTableView then
    --     self.equipTableView:reloadData()
    --     self:tableViewItemAction(self.equipTableView)
    -- end

    -- self.equipLucky:setString(tostring(_luckNum))
    -- local pos = self.equipLucky:getPositionX() + self.equipLucky:getContentSize().width
    -- self.equip_tips:setPositionX(pos)

    -- assert(_flashType == "2", "装备的刷新消耗钱币类型应为充值币")
    -- self.equipGoldValue:setString(tostring(_flashMoney))
    -- self.flashMoney = _flashMoney


    -- self:updateCommonData()
end

return PVShopProp

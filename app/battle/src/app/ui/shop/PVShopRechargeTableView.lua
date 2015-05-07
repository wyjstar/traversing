-- 充值的tableview
--[[
   @ 必须先调用setViewSize(size)
   @ 后调用initTableView()
]]


local PVShopRechargeTableView = class("PVShopRechargeTableView",function ()
    return cc.Node:create()
end)


function PVShopRechargeTableView:ctor()
    self.c_BaseTemplate = getTemplateManager():getBaseTemplate()
    self.c_ShopTemplate = getTemplateManager():getShopTemplate()
    self:init()
   -- self:initTableView()

end


function PVShopRechargeTableView:init(size)

    self.coinData = {}

    self.tableViewSize = nil

    self:initData()

end


--初始化属性
function PVShopRechargeTableView:initData()
    self.coinData = self.c_ShopTemplate:getRechargeListByPlatform(device.platform)
    
    cclog("--------rechargr list-----------")
    table.print(self.coinData)
   
end

--创建TableView
function PVShopRechargeTableView:initTableView()

    assert(self.tableViewSize ~= nil, "tableView size can not be nil ")
    self.tableView = cc.TableView:create(self.tableViewSize)
    self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.tableView:setDelegate()

    self:addChild(self.tableView)

    self.tableView:registerScriptHandler(function(table) return self:numberOfCellsInTableView(table) end, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  --Table数量
    self.tableView:registerScriptHandler(function(table, idx) return self:cellSizeForTable(table, idx) end, cc.TABLECELL_SIZE_FOR_INDEX)  --Index处Cell大小
    self.tableView:registerScriptHandler(function(table, idx) return self:tableCellAtIndex(table, idx) end, cc.TABLECELL_SIZE_AT_INDEX)   --Index处Cell

    self.tableView:setBounceable(false)

    local scrBar = PVScrollBar:new()
    scrBar:init(self.tableView,1)
    scrBar:setPosition(cc.p(self.tableViewSize.width,self.tableViewSize.height/2))
    self:addChild(scrBar,2)

    self.tableView:reloadData()
end


function PVShopRechargeTableView:setViewSize(size)

    self.tableViewSize = size
end


--列表单元个数
function PVShopRechargeTableView:numberOfCellsInTableView(table_)

    return #self.coinData
end

--单元大小
function PVShopRechargeTableView:cellSizeForTable(table_, idx)

    -- return self.itemSize.height, self.width
    return 180, 550
end

--返回单元
function PVShopRechargeTableView:tableCellAtIndex(table_, idx)

    local tempGoodData = self.coinData[idx+1]
    print("coindata======")
    table.print(tempGoodData)
    local cell = table_:dequeueCell()
    if nil == cell then
        cell = cc.TableViewCell:new()
    end

    local RGItem = {}
    --购买按钮
    local function menuClickBuy()--购买按钮回调事件
        getAudioManager():playEffectButton2()
        print("I buy it ......", tempGoodData.id)
        -- getNetManager():getActivityNet():sendGetRechargeTest(100)  --模拟充值
    end
    RGItem["UIShopRechargeItem"] = {}
    RGItem["UIShopRechargeItem"]["menuClickBuy"] = menuClickBuy

    local proxy = cc.CCBProxy:create()
    local cellItem = CCBReaderLoad("shop/ui_rg_item.ccbi", proxy, RGItem)
    cell:addChild(cellItem)

    local labelCoin = RGItem["UIShopRechargeItem"]["labelCoin"]
    local coinImg = RGItem["UIShopRechargeItem"]["coinImg"]
    local buyItem = RGItem["UIShopRechargeItem"]["itemBuy"]
    local coinDesc = RGItem["UIShopRechargeItem"]["spriteDesc"]
    local spriteDonate = RGItem["UIShopRechargeItem"]["spriteDonate"]
    local labelGift = RGItem["UIShopRechargeItem"]["labelgift"]

    local x =  #self.coinData - idx
    if x > 3 then
        x = 4 
    end
    game.setSpriteFrame(coinImg, tostring("#ui_shop_rg_s"..x..".png"))

    if tempGoodData.setting["107"][1] >= 10000 then
        coinDesc:setPositionX(coinDesc:getPositionX()+100)
    elseif tempGoodData.setting["107"][1] >= 1000 then
        coinDesc:setPositionX(coinDesc:getPositionX()+65)
    elseif tempGoodData.setting["107"][1] >= 100 then
        coinDesc:setPositionX(coinDesc:getPositionX()+25)
    end

    if tempGoodData.fristGift["107"][1] >= 10000 then
        spriteDonate:setPositionX(spriteDonate:getPositionX()+50)
    elseif tempGoodData.fristGift["107"][1] >= 1000 then
        spriteDonate:setPositionX(spriteDonate:getPositionX()+30)
    elseif tempGoodData.fristGift["107"][1] >= 100 then
        spriteDonate:setPositionX(spriteDonate:getPositionX()+10)
    end
   
    labelCoin:setString(string.format(Localize.query("recharge.1"),tempGoodData.currence,tempGoodData.setting["107"][1]))
    labelGift:setString(string.format(Localize.query("recharge.2"),tempGoodData.fristGift["107"][1]))

    return cell
end




return PVShopRechargeTableView

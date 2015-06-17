-- 商城的充值页面

-- local RgTableView = import(".PVShopRechargeTableView")
local RgVipView = import(".PVShopRechargeVip")
local CustomScrollView = import("...util.CustomScrollView")
local PVShopRgItem = import(".PVShopRgItem")

local TAG_VIPVIEW = 90
local TAG_BUYVIEW = 91
local REFRESH_RECHARGE_SHOP_NOTICE = "REFRESH_RECHARGE_SHOP_NOTICE"

--CustomScrollView 参数设置
local COLUMN_NUM = 2
local COLUMN_SPACE = 0


local PVShopRecharge = class("PVshopRecharge",BaseUIView)

function PVShopRecharge:ctor(id)
    self.super.ctor(self,id)
    print("PVShopRecharge:ctor end")
end


function PVShopRecharge:onMVCEnter()
    game.addSpriteFramesWithFile("res/ccb/resource/ui_shopVip.plist")
    --初始化属性
    self:init()
    --绑定事件
    self:initTouchListener()
    --加载本界面的ccbi ui_shop.ccbi
    self:loadCCBI("shop/ui_shop_recharge.ccbi", self.ccbiNode)
    -- self:initBaseUI()
    self:initView()
    --添加可购买的列表TableView
    -- self:addTableView()

    --购买成功刷新ui
    self.listener = cc.EventListenerCustom:create(REFRESH_RECHARGE_SHOP_NOTICE, function()
        self:reloadViewFunc()
    end)
    self:getEventDispatcher():addEventListenerWithFixedPriority(self.listener, 1)
end

function PVShopRecharge:reloadViewFunc()
    local currRecharge = getDataManager():getCommonData():getRechargeNum()
    local vipNo = getDataManager():getCommonData():getVip()
    local rechargeAmount = 0
    if vipNo < 15 then
        rechargeAmount = getTemplateManager():getBaseTemplate():getRechargeAmount(vipNo + 1)
    else
        rechargeAmount = getTemplateManager():getBaseTemplate():getRechargeAmount(vipNo)
    end
    local percentage = currRecharge / rechargeAmount
    self.vipPrgress:setPercentage(percentage * 100)
    self.labelYuanBao:setString(currRecharge.."/"..rechargeAmount)
    self.labelVip:setString(string.format(Localize.query("shop.22"),rechargeAmount,vipNo + 1))
end

function PVShopRecharge:initView()
    self.ccbiRootNode = self.ccbiNode["UIShopRecharge"]
    self.labelVip = self.ccbiRootNode["labelVip"]
    self.labelYuanBao = self.ccbiRootNode["labelYuanBao"]
    self.imgVipNol = self.ccbiRootNode["vipNol_sprite"]
    self.imgVipNor = self.ccbiRootNode["vipNor_sprite"]
    self.imgVipSlider = self.ccbiRootNode["imgVipSlider"]
    self.contentLayer = self.ccbiRootNode["contentLayer"]


    local vipNo = getDataManager():getCommonData():getVip()
    self.vipNo = vipNo
    self:setVipNo(vipNo,self.imgVipNol,self.imgVipNor)
    --显示到达下一vip所需累计充值金额
    local rechargeAmount = 0
    local nextVipNo = vipNo
    if  vipNo < 15 then
        nextVipNo = vipNo + 1
        rechargeAmount = getTemplateManager():getBaseTemplate():getRechargeAmount(nextVipNo)
    else
        rechargeAmount = getTemplateManager():getBaseTemplate():getRechargeAmount(vipNo)
    end
    self.labelVip:setString(string.format(Localize.query("shop.22"),rechargeAmount,nextVipNo))
    self.labelVip:setScaleX(0.9)
    local currRecharge = getDataManager():getCommonData():getRechargeNum()
    -- self.labelYuanBao:setString(currRecharge.."/"..rechargeAmount)
 
    print("vip-charge:",currRecharge,"----",rechargeAmount)
    self.labelYuanBao:setString(currRecharge.."/"..rechargeAmount)

    self.imgVipSlider:setVisible(false)
    self.vipPrgress = cc.ProgressTimer:create(self.imgVipSlider)
    self.vipPrgress:setAnchorPoint(cc.p(0,0.5))
    self.vipPrgress:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.vipPrgress:setBarChangeRate(cc.p(1, 0))
    self.vipPrgress:setMidpoint(cc.p(0, 0))
    self.vipPrgress:setLocalZOrder(0)
    self.vipPrgress:setPosition(cc.p(self.imgVipSlider:getPositionX(),self.imgVipSlider:getPositionY()))
    self.imgVipSlider:getParent():addChild(self.vipPrgress)
    self:updataProgress()

    --初始化物品列表
    self:initItemList()
end

--初始化物品列表
function PVShopRecharge:initItemList()
    self.itemNodeTable = {}
    for k,v in pairs(self.rechargeItemList) do
        print("rechargeItem========",k)
        table.print(v)
        local node = PVShopRgItem.new(v)
        table.insert(self.itemNodeTable,node)
    end

    --初始化CustomScrollView

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
        for i = 1 , tonumber(self.itemCount) do
            local item = self.itemNodeTable[i]
            self.scrollView:addCell(item)
        end

        self:addChild(self.scrollView)
    end


end

function PVShopRecharge:onClickScrollViewCell(cell, curData)
    local item = cell:getData()
    print("onClickScrollViewCell item:")
    table.print(item)
end

function PVShopRecharge:setVipNo(num,sprlef,sprrig)
    local decade = roundNumber(num / 10)
    local unit = num % 10
    local function setNum(temNum,sprite)
        local str = string.format("#ui_vip_%d.png",temNum)
        game.setSpriteFrame(sprite,str)
    end
    
    if decade == 0 then
        sprrig:setVisible(false)
        setNum(unit,sprlef)
    else
        setNum(decade,sprlef)
        setNum(unit,sprrig)
    end
end


function PVShopRecharge:updataProgress()
    local vipNo = getDataManager():getCommonData():getVip()
    local rechargeAmount = 0
    if vipNo < 15 then
        rechargeAmount = getTemplateManager():getBaseTemplate():getRechargeAmount(vipNo + 1)
    else
        rechargeAmount = getTemplateManager():getBaseTemplate():getRechargeAmount(vipNo)
    end
    local percentage = getDataManager():getCommonData():getRechargeNum() / rechargeAmount  --模拟充值
    self.vipPrgress:setPercentage(percentage * 100)

end

--初始化属性
function PVShopRecharge:init()
    self.ccbiNode = {}
    self.ccbiRootNode = {}

    self.c_ShopTemplate = getTemplateManager():getShopTemplate()
    self.c_ResourceTemplate = getTemplateManager():getResourceTemplate()
    self.c_LanguageTemplate = getTemplateManager():getLanguageTemplate()

    self.rechargeItemList = self.c_ShopTemplate:getRechargeListByPlatform(device.platform)
    self.itemCount = #self.rechargeItemList
    local function comp(a,b)
        if tonumber(a["type"]) > tonumber(b["type"]) then
            return true 
        else
            if tonumber(a["id"])>tonumber(b["id"]) then return true end
        end
    end
    table.sort(self.rechargeItemList,comp)

end

--绑定事件
function PVShopRecharge:initTouchListener()
    cclog("充值绑定事件")

    local function menuClickBack()  --充值回调事件
        print("充值退出")
        getAudioManager():playEffectButton2()
        -- print("menuClick Back")
        self:onHideView()
    end

    local function menuClickVip()   --VIP特权
        getAudioManager():playEffectButton2()
        print("menuClick Vip")
        getModule(MODULE_NAME_SHOP):showUIView("PVShopRechargeVip")
    end

    self.ccbiNode["UIShopRecharge"] = {}
    self.ccbiNode["UIShopRecharge"]["menuClickBack"] = menuClickBack
    self.ccbiNode["UIShopRecharge"]["menuClickvip"] = menuClickVip

end

function PVShopRecharge:onReloadView()
    self:updataProgress()
end

--@return
return PVShopRecharge

local CustomLabelMenu = import("...util.CustomLabelMenu")
local CustomLabelItem = import("...util.CustomLabelItem")
local CustomScrollView = import("...util.CustomScrollView")
local PVEquipItem = import(".PVEquipItem")
local PVGiftItem = import(".PVGiftItem")
-- 商城界面展示
local PVShopPage = class("PVShopPage", BaseUIView)
local ItemType = {
    EQUIPMENT = 1,
    PROP = 2,
    GIFT = 3
}
function PVShopPage:ctor(id)
    PVShopPage.super.ctor(self, id)
    --注册网络回调
    self:registerNetCallback()
    self.pageIndex = 1
    self.shopTemp = getTemplateManager():getShopTemplate()
    self.languageTemp = getTemplateManager():getLanguageTemplate()
    self.resTemp = getTemplateManager():getResourceTemplate()
    self.equipTemp = getTemplateManager():getEquipTemplate()
    self.bagTemplate = getTemplateManager():getBagTemplate()
    self.dropTemplate =  getTemplateManager():getDropTemplate()
    self.baseTemp = getTemplateManager():getBaseTemplate()
    self.stageData = getDataManager():getStageData()
    self.shopData = getDataManager():getShopData()
    self.commonData = getDataManager():getCommonData()
end
--注册网络回调方法
function PVShopPage:registerNetCallback()
    local function equipListCallback(comid, data)
        local shopType = self.shopData:getShopType()
        if data.res.result ~= true then
            error("get equip list data error=================>")
        else
            if shopType == 12 then--商城装备列表返回
                self.shopData:setShopEquipList(data.id)
                self.shopData:setShopEquipGotList(data.buyed_id)
                self.shopData:setLuckNum(data.luck_num)                
            elseif shopType == 3 then--商城道具列表返回
                self.shopData:setShopPropList(data.id)
                self.shopData:setShopPropGotList(data.buyed_id)                
            elseif shopType == 4 then--商城礼包列表返回
                self.shopData:setShopGiftBagList(data.id)
                self.shopData:setShopGiftBagGotList(data.buyed_id)                
            end
            self:initScrollView()
        end
    end

    local function buyGoodCallback(id, data)
        print("－－－－－－getGoodsCallback－－－－－－－")
        if data.res.result ~= true then
            print("!!! 数据返回错误")
            table.print(data)
        else
            print("!!! 物品列表返回")
            print("get Goods Callback", self.moneyType, self.useMoney)
            table.print(data)

            if table.nums(data.gain.equipments) > 1 then
                -- print("--- 全部购买---")
                getModule(MODULE_NAME_SHOP):showUITopShowLastView("PVShopEquBuySuccess", data.gain.equipments) --PVShopEquBuySuccess
            else
                local reward = data.gain
                local flag = table.getKeyByIndex(reward, 1)
                if flag == "equipments" then 
                    getModule(MODULE_NAME_SHOP):showUITopShowLastView("PVShopEquBuySuccess", reward.equipments)
                elseif flag == "items" then
                    local item = reward.items
                    local reward = {["105"] = {[1] = item[1]["item_num"],[2] = item[1]["item_num"],[3] = item[1]["item_no"]}}
                    getOtherModule():showOtherView("DialogGetCard",reward)
                end
                --更新金额
                if self.selectedItem then
                    local needMoney = self.selectedItem.disMoney or self.selectedItem.useMoney
                    if self.selectedItem.useMoneyType == 1 then
                        self.commonData:subCoin(needMoney)                      
                    elseif self.selectedItem.useMoneyType == 2 then
                        self.commonData:subGold(needMoney)
                    end
                end
            end
            self:resetView()          
        end   
    end

    local function refreshCallback(id, data) -- flash
        if data.res.result ~= true then
            print("!!! 数据返回错误")
        else
            print("!!! 刷新列表返回，－－－－－元宝")
            table.print(data)
            local usedRefreshTimes = self.shopData:getRefreshTimes()
            self.shopData:setRefreshTimes(usedRefreshTimes+1)

            self.shopData:setShopEquipList(data.id)
            self.shopData:setShopEquipGotList(data.buyed_id)
            self.shopData:setLuckNum(data.luck_num)
            --
            local flashGold = tonumber(self.UIShop["UIShopOther"]["equip_fresh_yuanbao"]:getString())
            self.commonData:subGold(flashGold) -- 扣钱
            --更新页面
            self:resetView()
        end
    end        
    self:registerMsg(SHOP_GET_ITEM_CODE, equipListCallback)
    self:registerMsg(SHOP_REFRESH_CODE, refreshCallback)
    self:registerMsg(SHOP_BUY_GOODS_CODE, buyGoodCallback)    
end

function PVShopPage:onExit()
    cclog("-------onExit----")
    if self.globalSchedule then
        timer.unscheduleGlobal(self.globalSchedule)
        self.globalSchedule = nil
    end
    getDataManager():getResourceData():clearResourcePlistTexture()
end

function PVShopPage:onMVCEnter()
    self.UIShop = {}       -- ccbi加载后返回的node       
    self:initTouch()
    self:initView()
    self:updateMoneyInfo()
    --定时器
    self.globalSchedule = timer.scheduleGlobal(function()
        self:updateHeroTime(1)--更新招募倒计时
        self:updateEquipTime(1)--更新装备刷新倒计时
    end, 1.0)    
end

function PVShopPage:updateHeroTime(d)
    self.diffTime1 = self.diffTime1 + d
    if self.diffTime1 > self.heroFreePeriod then
        --免费
        self.UIShop["UIShopHero"]["liang_label"]:setString(Localize.query("shop.5"))
    else
        --倒计时
        local _leftTime = self.heroFreePeriod - self.diffTime1
        self.UIShop["UIShopHero"]["liang_label"]:setString(self:getFormatTime(_leftTime))            
    end
    self.diffTime2 = self.diffTime2 + d
    if self.diffTime2 > self.godHeroFreePeriod then
        self.UIShop["UIShopHero"]["shen_label"]:setString(Localize.query("shop.5"))        
    else
        local _leftTime = self.heroFreePeriod - self.diffTime1
        self.UIShop["UIShopHero"]["shen_label"]:setString(self:getFormatTime(_leftTime))        
    end
end

function PVShopPage:initHeroTime()
    local preHeroTime = self.commonData:getFineHero()
    local preGodHeroTime = self.commonData:getExcellentHero()
    self.heroFreePeriod = self.shopTemp:getHeroFreePeriod() * 3600
    self.godHeroFreePeriod = self.shopTemp:getGodHeroFreePeriod() * 3600
    local currTime = self.commonData:getTime()
    self.diffTime1 = os.difftime(currTime, self.preHeroTime)
    self.diffTime2 = os.difftime(currTime, self.preGodHeroTime)
    self:updateHeroTime(1)         
end

function PVShopPage:getFormatTime(t)
    return string.format("%02d:%02d:%02d",math.floor(t/3600),math.floor(t%3600/60),t%60)
end

function PVShopPage:updateEquipTime()
    -- body
end
--初始化响应事件
function PVShopPage:initTouch()
    self.UIShop["UIShop"] = {}
    local function onClickClose()
        getAudioManager():playEffectButton2()
        self:onHideView()
    end

    local function onClickCharge()
        getAudioManager():playEffectButton2()
        getModule(MODULE_NAME_SHOP):showUIViewAndInTop("PVshopRecharge")
    end

    local function onClickAddYuanbao()
        getAudioManager():playEffectButton2()
        getModule(MODULE_NAME_SHOP):showUIViewAndInTop("PVshopRecharge")
    end    

    local function onClickAddYinding()
        print("onClickAddYinding================>")
    end
    self.UIShop["UIShop"]["onClickClose"] = onClickClose
    self.UIShop["UIShop"]["onClickCharge"] = onClickCharge
    self.UIShop["UIShop"]["onClickAddYuanbao"] = onClickAddYuanbao                    
    self.UIShop["UIShop"]["onClickAddYinding"] = onClickAddYinding                    
end
--初始化显示层
function PVShopPage:initView()
    self.rootNode = self:loadCCBI("shop/ui_shop2.ccbi", self.UIShop)
    --招募界面
    self:initHeroPage()
    --其他界面
    self:initOtherPage() 
    --头部标签
    self.labelMenu = CustomLabelMenu.new(self.UIShop["UIShop"]["menu_node"])
    --招募
    self.labelMenu:addMenuItem(CustomLabelItem.new(self.UIShop["UIShop"]["btn_hero"], function()
        self:showPage(1)
    end))
    --装备
    self.labelMenu:addMenuItem(CustomLabelItem.new(self.UIShop["UIShop"]["btn_equip"], function()
        self:showPage(2)
    end))
    --道具
    self.labelMenu:addMenuItem(CustomLabelItem.new(self.UIShop["UIShop"]["btn_item"], function()
        self:showPage(3)
    end))
    --礼包
    self.labelMenu:addMenuItem(CustomLabelItem.new(self.UIShop["UIShop"]["btn_gift"], function()
        self:showPage(4)
    end))

    self.labelMenu:changeLabel(self.pageIndex)
end

--显示页面
function PVShopPage:showPage(pageIndex)
    self.pageIndex = pageIndex
    if pageIndex == 1 then
        self:changePage(self.ui_shop_hero, self.ui_shop_other)
    else
        self:showOtherPage(pageIndex)
        self:changePage(self.ui_shop_other, self.ui_shop_hero)        
    end
end
--切换页面
function PVShopPage:changePage(show, hide)
    if hide:getParent() then
        hide:retain()        
        hide:removeFromParent(false)          
    end

    if show:getParent() then
        show:setVisible(true)
    else
        self.rootNode:addChild(show, -1)
        show:release()            
    end 
end
--显示其他页面
function PVShopPage:showOtherPage(pageIndex)
    --详细页面
    self.UIShop["UIShopOther"]["detail_info"]:setVisible(false)
    --礼包滑动页面初始化
    self:initGiftView()
    self.selectedItem = nil --选择的商品    
    if pageIndex == 2 then--装备
        self.UIShop["UIShopOther"]["equip_page"]:setVisible(true)
        self.UIShop["UIShopOther"]["item_page"]:setVisible(false)
        self.UIShop["UIShopOther"]["gift_page"]:setVisible(false)
        getNetManager():getShopNet():sendGetShopList(12)
        self.shopData:setShopType(12)
    elseif pageIndex == 3 then--道具
        self.UIShop["UIShopOther"]["equip_page"]:setVisible(false)
        self.UIShop["UIShopOther"]["item_page"]:setVisible(true)
        self.UIShop["UIShopOther"]["gift_page"]:setVisible(false)
        getNetManager():getShopNet():sendGetShopList(3)
        self.shopData:setShopType(3) 
    elseif pageIndex == 4 then--礼包
        self.UIShop["UIShopOther"]["equip_page"]:setVisible(false)
        self.UIShop["UIShopOther"]["item_page"]:setVisible(false)
        self.UIShop["UIShopOther"]["gift_page"]:setVisible(true)
        getNetManager():getShopNet():sendGetShopList(4)
        self.shopData:setShopType(4) 
    else
        error("pageIndex error:"..pageIndex)
        return   
    end
end
--获取要显示的装备
function PVShopPage:getEquipItem()
    local allItems = self.shopData:getShopEquipList()
    local gotItems = self.shopData:getShopEquipGotList() or {}
    if not allItems then return nil end
    local equipItems = {}
    for _, v in pairs(allItems) do
        local value = self.shopTemp:getTemplateById(v)
        local equipId = value.gain["102"][3]
        local item = {
            id=equipId,
            sid=v,
            quality=self.equipTemp:getQuality(equipId),
            name=self.equipTemp:getEquipName(equipId),
            icon=CONFIG_RES_EQUIPMENT_PAHT..self.equipTemp:getEquipResIcon(equipId),
            got = table.inv(gotItems, v),
            consume = value.consume,
            discout = value.discountPrice,
            description=self.equipTemp:getDescribe(equipId),            
            item_type=ItemType.EQUIPMENT
        }
        table.insert(equipItems, item)
    end
    return equipItems
end
--获取要显示的道具
function PVShopPage:getShopItem( ... )
    local allItems = self.shopData:getShopPropList()
    local gotItems = self.shopData:getShopPropGotList()
    if not allItems then return nil end
    local propItems = {}
    for _, v in pairs(allItems) do
        local value = self.shopTemp:getTemplateById(v)
        local propId = value.gain["105"][3]
        local item={
            id=propId,
            sid=v,            
            quality=self.bagTemplate:getItemQualityById(propId),
            name=self.bagTemplate:getItemName(propId),
            icon=CONFIG_RES_ICON_ITEM_PAHT..self.bagTemplate:getItemResIcon(propId),
            got=table.inv(gotItems,v),
            consume=value.consume,
            discout=value.discountPrice,
            description=self.bagTemplate:getDescribe(propId),
            item_type=ItemType.PROP        
        }
        table.insert(propItems, item)
    end
    return propItems    
end
--获取要显示的礼包
function PVShopPage:getGiftItem()
    local allItems = self.shopData:getShopGiftBagList()
    local gotItems = self.shopData:getShopGiftBagGotList()
    if not allItems then return nil end
    local giftItems = {}

    for _, v in pairs(allItems) do
        local value = self.shopTemp:getTemplateById(v)
        local item = {sid=v}
        --106是包，105是物品
        if value.gain["106"] then
            item.id = value.gain["106"][3]
            item.icon = CONFIG_RES_ICON_ITEM_PAHT..self.resTemp:getResourceById(value.res)
            item.name = self.languageTemp:getLanguageById(value.languageId)
            item.quality = value.quality
        elseif value.gain["105"] then
            item.id = value.gain["105"][3]
            item.icon = CONFIG_RES_ICON_ITEM_PAHT..self.bagTemplate:getItemResIcon(item.id)
            item.name=self.bagTemplate:getItemName(item.id)
            item.quality=self.bagTemplate:getItemQualityById(item.id)                 
        end
        item.consume=value.consume
        item.discout=value.discountPrice
        item.got=table.inv(gotItems,v)
        item.item_type=ItemType.GIFT
        table.insert(giftItems, item)
    end
    return giftItems
end
--初始化招募界面
function PVShopPage:initHeroPage()
    self.UIShop["UIShopHero"]={}
    local function onClickShen()
        getModule(MODULE_NAME_SHOP):showUIViewAndInTop("PVShopRecruitBuyGod",0)
    end
    local function onClickLiang() 
        getModule(MODULE_NAME_SHOP):showUIViewAndInTop("PVShopRecruitBuy",0)     
    end
    self.UIShop["UIShopHero"]["onClickShen"] = onClickShen
    self.UIShop["UIShopHero"]["onClickLiang"] = onClickLiang

    self.ui_shop_hero = game.newCCBNode("shop/ui_shop_hero.ccbi", self.UIShop)
    self.rootNode:addChild(self.ui_shop_hero, -1)
    --初始化招募倒计时
    self:initHeroTime()
end
--初始化其他界面
function PVShopPage:initOtherPage()
    self.UIShop["UIShopOther"]={}
    --装备和道具通用查看回调
    local function onClickLook()
        if self.selectedItem then
            --查看详情
            if self.selectedItem.item_type == ItemType.EQUIPMENT then
                local equipment = self.equipTemp:getTemplateById(self.selectedItem.id)
                getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVOtherEquipAttribute", equipment, 2, nil)                
            elseif self.selectedItem.item_type == ItemType.PROP then
                getOtherModule():showOtherView("PVCommonDetail", 1, self.selectedItem.id, 1)                
            end            
        end
    end
    self.UIShop["UIShopOther"]["onClickLook"] = onClickLook   
    self:initEquipTouch()
    self:initItemTouch()
    self:initGiftTouch()   
    self.ui_shop_other = game.newCCBNode("shop/ui_shop_equip.ccbi", self.UIShop)
    self.UIShop["UIShopOther"]["detail_info"]:setVisible(false)
    self:initEquipView()
    self:initItemView()
    self:initGiftView()
    self.rootNode:addChild(self.ui_shop_other, -1)  
end

function PVShopPage:updateMoneyInfo()
    --更新元宝，银锭数量
    self.UIShop["UIShop"]["yuanbao_num"]:setString(self.commonData:getGold())
    self.UIShop["UIShop"]["yinding_num"]:setString(self.commonData:getCoin())
end

function PVShopPage:initScrollView()
    local items = nil
    if self.pageIndex == 2 then--装备
        items = self:getEquipItem()
    elseif self.pageIndex == 3 then--道具
        items = self:getShopItem()
    elseif self.pageIndex == 4 then
        items = self:getGiftItem()
    else
        return
    end
   
    --初始化cell
    if self.scrollView then
        self.scrollView:clear()
    elseif items and #items > 0 then
        self.scrollView = CustomScrollView.new(self.UIShop["UIShopOther"]["scrollRect"],{columnspace=10})
        self.scrollView:setDelegate(self)
    end    

    if items then
        for i =1 , #items do
            local data = items[i]
            data.useMoney = table.getValueByIndex(data.consume, 1)[1]
            data.useMoneyType = tonumber(table.getKeyByIndex(data.consume, 1))
            if data.useMoneyType == 107 then
                data.useMoneyType = tonumber(table.getValueByIndex(data.consume, 1)[3])
            end
            if table.nums(data.discout) > 0 then
                data.disMoney = table.getValueByIndex(data.discout, 1)[1]                
            end
            local item = PVEquipItem.new(data)
            self.scrollView:addCell(item)
        end        
    end
end
--点击cell
function PVShopPage:onClickScrollViewCell(cell)
    local data = cell:getData()
    self.scrollView:singalSelectedCell(cell)
    ----------------------------------------------------------
    self.UIShop["UIShopOther"]["detail_info"]:setVisible(false)
    ----------------------------------------------------------
    self:initGiftView()
    if self.pageIndex == 1 then
    elseif self.pageIndex == 2 or self.pageIndex == 3 then
        self:showItemInfo(data)     
    elseif self.pageIndex == 4 then
        self:showGiftInfo(data)
    end
end
--显示装备，道具信息
function PVShopPage:showItemInfo(data)
    self.UIShop["UIShopOther"]["detail_info"]:setVisible(true)
    if data.item_type == ItemType.EQUIPMENT then
        self.UIShop["UIShopOther"]["item_icon"]:setScale(0.8)
    else
        self.UIShop["UIShopOther"]["item_icon"]:setScale(1)            
    end
    self.UIShop["UIShopOther"]["item_icon"]:setTexture(data.icon)
    self.UIShop["UIShopOther"]["item_name"]:setString(data.name)
    self.UIShop["UIShopOther"]["item_description"]:setString(data.description)
    self.selectedItem = data             
end
--显示礼包内物品
function PVShopPage:showGiftInfo(data)
    self.UIShop["UIShopOther"]["gift_info"]:setVisible(true)
    self.UIShop["UIShopOther"]["vip_name"]:setString(data.name)
    local items = self.dropTemplate:getAllItemById(data.id)
    if self.giftScrollView then
        self.giftScrollView:clear()
        self.giftScrollView:setEnabled(true)
    elseif items and #items > 0 then
        --只能滑动，不可点击        
        self.giftScrollView = CustomScrollView.new(self.UIShop["UIShopOther"]["giftScollRect"],{columnspace=10,direction=CustomScrollView.DIRECTION_HORIZONTAL})
    end    

    if items then
        for i =1 , #items do
            local item = items[i]          
            item.icon = getIconByType(item.item_id, item.item_type)
            item.quality = getQualityByType(item.item_id, item.item_type)
            local cell = PVGiftItem.new(item)
            self.giftScrollView:addCell(cell)
        end
        if self.giftScrollView:getContentSize().width > self.giftScrollView:getViewSize().width then
            self.UIShop["UIShopOther"]["right_arrow"]:setVisible(true)
            self.UIShop["UIShopOther"]["left_arrow"]:setVisible(true)
        else
            self.UIShop["UIShopOther"]["right_arrow"]:setVisible(false)
            self.UIShop["UIShopOther"]["left_arrow"]:setVisible(false)            
        end              
    end
    self.selectedItem = data            
end

--初始化装备点击事件
function PVShopPage:initEquipTouch()
    local function onClickEquipFresh()
        getAudioManager():playEffectButton2()
        local usedRefreshTimes = self.shopData:getRefreshTimes()
        --超出最大值
        if usedRefreshTimes > self.refreshTotalTimes then
            getOtherModule():showAlertDialog(nil, Localize.query("shop.19"))
            return
        end
        --判断元宝是否足够
        local flashGold = tonumber(self.UIShop["UIShopOther"]["equip_fresh_yuanbao"]:getString())
        if self.commonData:getGold() < flashGold then
            getOtherModule():showAlertDialog(nil, Localize.query("shop.8"))
        else
            getNetManager():getShopNet():sendRefreshShopList(12)
        end
    end
    local function onClickEquipBuy()
        getAudioManager():playEffectButton2()        
        if self.selectedItem then
            getOtherModule():showConfirmDialog(function()--confirm
                local needMoney = self.selectedItem.disMoney or self.selectedItem.useMoney
                if self.selectedItem.useMoneyType == 1 and needMoney > self.commonData:getCoin() then
                    getOtherModule():showAlertDialog(nil, Localize.query("shop.10"))
                    return 
                elseif self.selectedItem.useMoneyType == 2 and needMoney > self.commonData:getGold() then
                    getOtherModule():showAlertDialog(nil, Localize.query("shop.8"))
                    return                   
                end
                getNetManager():getShopNet():sendBuyGoods(self.selectedItem.sid)
            end,function()--cancel
            end, Localize.query("shop.21")) 
        end
    end
    self.UIShop["UIShopOther"]["onClickEquipFresh"] = onClickEquipFresh
    self.UIShop["UIShopOther"]["onClickEquipBuy"] = onClickEquipBuy        
end
--初始化装备
function PVShopPage:initEquipView()
    --幸运度
    local _luckNum = self.shopData:getLuckNum()
    self.UIShop["UIShopOther"]["equip_xingyudu"]:setString(_luckNum)
    --刷新元宝
    local needYuanbao,_ = self.shopTemp:getFlashMoney(12)
    self.UIShop["UIShopOther"]["equip_fresh_yuanbao"]:setString(needYuanbao)
    --刷新次数
    local vipNo = self.commonData:getVip()
    local usedTimes = self.shopData:getRefreshTimes() or 0
    local totalTimes = self.baseTemp:getShopRefreshTimes(vipNo)   
    self.UIShop["UIShopOther"]["equip_fresh_times"]:setString("（"..usedTimes.."/"..totalTimes.."）")
    --获取当前vipno下所有用的刷新次数
    self.refreshTotalTimes = self.baseTemp:getShopRefreshTimes(vipNo)    
end
--初始化道具点击事件
function PVShopPage:initItemTouch()
    local function onClickBuyItem()
        getAudioManager():playEffectButton2()        
        if self.selectedItem then
            local vipLimte = self.shopTemp:getBuyVIPLimitNumById(self.selectedItem.sid, self.commonData:getVip())
            if vipLimte ~= 0 and vipLimte <= self.shopData:getProLimitOneDayById(self.selectedItem.sid) then
                if self.selectedItem.sid == 30003 then
                    getOtherModule():showAlertDialog(nil, Localize.query("basic.4"))
                elseif self.selectedItem.sid == 30002 then
                    getOtherModule():showAlertDialog(nil, Localize.query("basic.5"))
                end
                return                
            end
            local needMoney = self.selectedItem.disMoney or self.selectedItem.useMoney
            if self.selectedItem.useMoneyType == 1 and needMoney > self.commonData:getCoin() then
                getOtherModule():showAlertDialog(nil, Localize.query("shop.10"))
                return 
            elseif self.selectedItem.useMoneyType == 2 and needMoney > self.commonData:getGold() then
                getOtherModule():showAlertDialog(nil, Localize.query("shop.8"))
                return                   
            end
            getOtherModule():showOtherView("PVShopBuyByNum",self.selectedItem.sid)           
        end
    end
    self.UIShop["UIShopOther"]["onClickBuyItem"] = onClickBuyItem    
end
--初始化道具
function PVShopPage:initItemView()
    -- body
end
--初始化礼包
function PVShopPage:initGiftTouch()
    local function onClickBuyGift()
        getAudioManager():playEffectButton2()        
        if self.selectedItem then
            local needMoney = self.selectedItem.disMoney or self.selectedItem.useMoney
            if self.selectedItem.useMoneyType == 1 and needMoney > self.commonData:getCoin() then
                getOtherModule():showAlertDialog(nil, Localize.query("shop.10"))
                return 
            elseif self.selectedItem.useMoneyType == 2 and needMoney > self.commonData:getGold() then
                getOtherModule():showAlertDialog(nil, Localize.query("shop.8"))
                return                   
            end
            getNetManager():getShopNet():sendBuyGoods(self.selectedItem.sid)          
        end
    end
    self.UIShop["UIShopOther"]["onClickBuyGift"] = onClickBuyGift
end
--初始化礼包
function PVShopPage:initGiftView()
    self.UIShop["UIShopOther"]["gift_info"]:setVisible(false)
    if self.giftScrollView then self.giftScrollView:setEnabled(false) end        
end

function PVShopPage:resetView()
    self:updateMoneyInfo()
    self:initScrollView()
end

--@return
return PVShopPage

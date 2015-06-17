-- 商城界面展示
local PVScrollBar = import("..homepage.scrollbar.PVScrollBar")
local RecruitView = import(".PVShopRecruit")  --招募
local PpView = import(".PVShopProp")          --道具
-- local CsView = import(".PVShopChest")         --宝箱
local GbView = import(".PVShopGiftBag")       --礼包

-- 标记子View的类型
local RECRIUT = "recruitview"  --招募
local PROP    = "PropView"     --道具
local CHEST   = "Chest"        --抽取宝箱
local GIFTBAG = "GiftBag"      --礼包

-- 标记updateView时，是否关闭当前页面
SHOP_PAST_PAGE_HIDEVIEW = false
-- 标记是抽取的哪种
-- 1:良将1，2:良将10，3:神将1，4:神将10，11:良装 12:神装，0:无
SHOP_EQUIP_TYPE = 0

SHOP_EQUIP_IS_FREE = false


local PVShopPage = class("PVShopPage", BaseUIView)

function PVShopPage:ctor(id)
    PVShopPage.super.ctor(self, id)

    -- 注册网络回调
    self:registerNetCallback()

    self.shopTemp = getTemplateManager():getShopTemplate()
    self.languageTemp = getTemplateManager():getLanguageTemplate()
    self.equipTemp = getTemplateManager():getEquipTemplate()
    self.bagTemplate = getTemplateManager():getBagTemplate()
    self.baseTemp = getTemplateManager():getBaseTemplate()
    self.stageData = getDataManager():getStageData()
    self.shopData = getDataManager():getShopData()
    self.commonData = getDataManager():getCommonData()
end

function PVShopPage:onExit()
    cclog("-------onExit----")
    -- self:unregisterScriptHandler()
    getDataManager():getResourceData():clearResourcePlistTexture()

end

function PVShopPage:registerNetCallback()

    local function equipListCallback(id, data)
        local shopType = self.shopData:getShopType()
        cclog("---equipListCallback-----"..shopType)
        if data.res.result ~= true then
            print("!!! 数据返回错误")
        else
            if shopType == 12 then
                -- print("!!! 商城装备列表返回,－－－－－")
                -- table.print(data)
                -- print("!!! 商城装备列表返回")
                self.shopData:setShopEquipList(data.id)
                self.shopData:setShopEquipGotList(data.buyed_id)
                self.shopData:setLuckNum(data.luck_num)

                if self.speSign then
                    self.shopTemp:addSpecialEquipGoodsBuyed(self.buyGoodsId)
                end
                --初始化属性
                self:updateData()
            elseif shopType == 3 then
                -- print("!!! 商城道具列表返回,－－－－－")
                -- table.print(data)
                -- print("!!! 商城道具列表返回")
                self.shopData:setShopPropList(data.id)
                self.shopData:setShopPropGotList(data.buyed_id)
                --初始化属性
                self.viewTable[PROP]:updateData()
                -- self:tableViewItemAction(self.viewTable[PROP].tableView)
            elseif shopType == 4 then
                -- print("!!! 商城礼包列表返回,－－－－－")
                -- table.print(data)
                -- print("!!! 商城礼包列表返回")
                self.shopData:setShopGiftBagList(data.id)
                self.shopData:setShopGiftBagGotList(data.buyed_id)
                --初始化属性
                self.viewTable[GIFTBAG]:updateData()
                self:tableViewItemAction(self.viewTable[GIFTBAG].tableView)
            end
        end
    end
    local function equipListCallback2(id, data) -- flash
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
            self.commonData:subGold(self.flashMoney) -- 扣钱
            --初始化属性
            self:updateData()
        end
    end

    local  function getGoods(data)
        cclog("------buy back-------")
        table.print(data)
        if table.nums(data.gain.equipments) > 1 then
            -- print("--- 全部购买 现实列表---")
            getModule(MODULE_NAME_SHOP):showUITopShowLastView("PVShopEquBuySuccess", data.gain.equipments) --PVShopEquBuySuccess
        else
            -- print("--- 购买了一件装备---")
            local reward = data.gain
            -- table.print(reward)
            local flag = table.getKeyByIndex(reward, 1)
            -- print(flag)
            
            -- if reward.equipments ~= nil then 
            if flag == "equipments" then 
                --getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVEquipmentAttribute", data.gain.equipments[1]) --购买了装备，采用跳转到装备详情界面
                getModule(MODULE_NAME_SHOP):showUITopShowLastView("PVShopEquBuySuccess", reward.equipments)
            elseif flag == "items" then
                cclog("-----doumaidaoju-------")
                print(table.getKeyByIndex(reward, 1))
                local item = reward.items
                local reward = {["105"] = {[1] = item[1]["item_num"],[2] = item[1]["item_num"],[3] = item[1]["item_no"]}}
                getOtherModule():showOtherView("DialogGetCard",reward)
                local unit = self.shopData:getProBuyTypeAndMoney()
                self.moneyType = unit["moneyType"]
                self.useMoney = unit["useMoney"]
            end 
        end
        if self.moneyType == 1 then self.commonData:subCoin(self.useMoney)
        elseif self.moneyType == 2 then self.commonData:subGold(self.useMoney)
        elseif self.moneyType == 0 then
            self.commonData:subCoin(self.useMoney.coins)
            self.commonData:subGold(self.useMoney.golds)
        end
    end

    local function getGoodsCallback(id, data)
        print("－－－－－－getGoodsCallback－－－－－－－")
        if data.res.result ~= true then
            print("!!! 数据返回错误")
            table.print(data)
        else
            print("!!! 物品列表返回")
            print("get Goods Callback", self.moneyType, self.useMoney)
            table.print(data)
            
            getGoods(data)
        end   
    end

    local function getGoodsByGuidCallback(id, data)
        print(" getGoodsByGuidCallback ")
        table.print(data)
        if getNewGManager():getCurrentGid() == GuideId.G_GUIDE_40064 then
            getGoods(data)
        end
    end

    self:registerMsg(SHOP_GET_ITEM_CODE, equipListCallback)
    self:registerMsg(SHOP_REFRESH_CODE, equipListCallback2)
    self:registerMsg(SHOP_BUY_GOODS_CODE, getGoodsCallback)
    self:registerMsg(NewbeeGuideStep, getGoodsByGuidCallback)
end

function PVShopPage:onMVCEnter()
    self.ccbiNode = {}       -- ccbi加载后返回的node
    self.ccbiRootNode = {}   -- ccb界面上的根节点
    self.viewTable = {}         --存放4个视图的表

    self:initTouchListener()

    self:loadCCBI("shop/ui_shop.ccbi", self.ccbiNode)

    self:initView()

    -- 添加招募视图内容
    self:initAllTabPage()
    --self:createEquipTableView()
    --商城道具列表
     -- self.shopProps = self.shopTemp:getPorps()
     -- self:createPropTableView()

    -- 发送请求初始化
    -- getNetManager():getShopNet():sendGetShopList(12)
    -- self.shopData:setShopType(12)


end

function PVShopPage:initAllTabPage()

    self:onRecruitCallback()     --用的时候在加载
    -- self:onChestCallback()
    -- self:onPropCallback()
    -- self:onGiftBagCallback()

    local data = self.funcTable[1]
    print("************", data)
    if data == nil then data = 1 end
    self:updateMenuByIndex(data)
end

--初始化属性
function PVShopPage:updateData()

    local _idsList = self.shopData:getShopEquipList()
    local _idsGotList = self.shopData:getShopEquipGotList()
    local _luckNum = self.shopData:getLuckNum()
    local _flashMoney, _flashType = self.shopTemp:getFlashMoney(12)

    -- print("——flash——", _flashMoney, _flashType)

    -- 获取商城装备数据
    self.equipmentTable = {}
    --添加是否开启引导判断
    -- if ISSHOW_GUIDE and getNewGManager():getCurrentGid() ~= GuideId.G_GUIDE_40045 then
    if getNewGManager():getCurrentGid() ~= GuideId.G_GUIDE_40045 then
        for k,v in pairs(_idsList) do
            print(v)
            local value = self.shopTemp:getTemplateById(v)
            value.got = false
            table.insert(self.equipmentTable, value)
        end
        for k,v in pairs(_idsGotList) do
            print(v)
            local value = self.shopTemp:getTemplateById(v)
            value.got = true
            table.insert(self.equipmentTable, value)
        end
    end 
    if ISSHOW_GUIDE and getNewGManager():getCurrentGid() == GuideId.G_GUIDE_40054 then       --新手引导中特殊处理，服务器没有推送任何东西的情况下

        cclog("-----tschuli-------")
        self.speSign = true
        self.equipmentTable = {}
        _idsList =  self.shopTemp:getSpecialEquipGoods()
        _idsGotList = self.shopTemp:getSpecialEquipGoodsBuyed()
        for k,v in pairs(_idsList) do 
            table.insert(self.equipmentTable,v)
        end
        if _idsGotList then
            for k,v in pairs(_idsGotList) do
                table.insert(self.equipmentTable,v)
            end
        end
    end
    

    local function cmp(a,b)
        return a.id < b.id
    end

    table.sort( self.equipmentTable, cmp )

    print("@@@@@@@@@@@@@@@@@")
    table.print(self.equipmentTable)
    print("@@@@@@@@@@@@@@@@@")

    if self.equipTableView then
        self.equipTableView:reloadData()
        self:tableViewItemAction(self.equipTableView)
    end

    self.equipLucky:setString(tostring(_luckNum))
    local pos = self.equipLucky:getPositionX() + self.equipLucky:getContentSize().width
    self.equip_tips:setPositionX(pos)

    assert(_flashType == "2", "装备的刷新消耗钱币类型应为充值币")
    self.equipGoldValue:setString(tostring(_flashMoney))
    self.flashMoney = _flashMoney


    self:updateCommonData()
end

--初始化属性:从CCB中获取变量
function PVShopPage:initView()

    self.ccbiRootNode = self.ccbiNode["UIShop"]
    self.labelTips = self.ccbiRootNode["labelTips"]
    self.imgVipNo = self.ccbiRootNode["vip_sprite"]
    self.imgVipNol = self.ccbiRootNode["vipNol_sprite"]
    self.imgVipNor = self.ccbiRootNode["vipNor_sprite"]
    self.labelCharge = self.ccbiRootNode["labelYuanBao"]  -- 1200/3999
    self.labelMoney = self.ccbiRootNode["silverNum"]
    self.labelSuperMoney = self.ccbiRootNode["goldNum"]
    self.imgVipSlider = self.ccbiRootNode["slider_sprite"]
    self.labelTipsBottom = self.ccbiRootNode["lable_tips_bom"]

    -- to do 从DataCenter中取玩家数据 -> vip充值信息，money,

    self.viewLayer = self.ccbiRootNode["laycolor_bg"]  -- tableView的父控件
    self.rcNode = self.ccbiRootNode["recuit_node"]

    self.menu = {}
    table.insert(self.menu, self.ccbiRootNode["menuA"])
    table.insert(self.menu, self.ccbiRootNode["menuB"])
    table.insert(self.menu, self.ccbiRootNode["menuC"])
    table.insert(self.menu, self.ccbiRootNode["menuD"])
    for k,v in pairs(self.menu) do
        v:setAllowScale(false)
    end

    self.menuFont = {}   -- 菜单文字
    table.insert(self.menuFont, self.ccbiRootNode["menu1"])
    table.insert(self.menuFont, self.ccbiRootNode["menu2"])
    table.insert(self.menuFont, self.ccbiRootNode["menu3"])
    table.insert(self.menuFont, self.ccbiRootNode["menu4"])
    self.menuFont2 = {}
    table.insert(self.menuFont2, self.ccbiRootNode["menu12"])
    table.insert(self.menuFont2, self.ccbiRootNode["menu22"])
    table.insert(self.menuFont2, self.ccbiRootNode["menu32"])
    table.insert(self.menuFont2, self.ccbiRootNode["menu42"])

    --宝箱
    self.equipNode = self.ccbiRootNode["equip_node"]
    self.equipGoldValue = self.ccbiRootNode["gold_value"]
    self.equipFlash = self.ccbiRootNode["menu_flash"]
    self.equipLucky = self.ccbiRootNode["label_lucky"]
    self.equip_tips = self.ccbiRootNode["equip_tips"]
    self.equipListLayer = self.ccbiRootNode["contentLayer"]
    
    local vipNo = self.commonData:getVip()
    self.vipNo = vipNo
    self:setVipNo(vipNo,self.imgVipNol,self.imgVipNor)
    --显示到达下一vip所需累计充值金额
    local rechargeAmount = 0
    local nextVipNo = vipNo
    if  vipNo < 15 then
        nextVipNo = vipNo + 1
        rechargeAmount = self.baseTemp:getRechargeAmount(nextVipNo)
    else
        rechargeAmount = self.baseTemp:getRechargeAmount(nextVipNo)
    end
    self.nextVipNo = nextVipNo
    self.labelTips:setString(string.format(Localize.query("shop.22"),rechargeAmount,nextVipNo))
    self.labelTips:setScaleX(0.9)
    local currRecharge = self.baseTemp:getRechargeAmount(vipNo)
    self.labelCharge:setString(currRecharge.."/"..rechargeAmount)
    --获取当前vipno下所有用的刷新次数
    self.refreshTimes = self.baseTemp:getShopRefreshTimes(vipNo)
    --充值按钮
    self.menuCharge = self.ccbiRootNode["menuCharge"]
    -- self.menuCharge = self.ccbiRootNode["menuCharge"]
    -- SpriteGrayUtil:drawSpriteTextureGray(self.menuCharge:getNormalImage())
    -- self.menuCharge:setEnabled(false)
    -- 赋值
    self:updateCommonData()


    --进度条
    self.imgVipSlider:setVisible(false)
    self.vipPrgress = cc.ProgressTimer:create(self.imgVipSlider)
    self.vipPrgress:setAnchorPoint(cc.p(0,0.5))
    self.vipPrgress:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.vipPrgress:setBarChangeRate(cc.p(1, 0))
    self.vipPrgress:setMidpoint(cc.p(0, 0))
    self.vipPrgress:setLocalZOrder(0)
    self.vipPrgress:setPosition(cc.p(5,3))
    self.imgVipSlider:getParent():addChild(self.vipPrgress)
    self:updataProgress()
end

function PVShopPage:setVipNo(num,sprlef,sprrig)
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

function PVShopPage:updataProgress()
    local rechargeAmount = self.baseTemp:getRechargeAmount(self.nextVipNo)
    local percentage = self.commonData:getRechargeAcc() / rechargeAmount
    self.vipPrgress:setPercentage(percentage * 100)
end

function PVShopPage:updateCommonData()
    self.labelMoney:setString(self.commonData:getCoin())
    self.labelSuperMoney:setString(self.commonData:getGold())
end

--绑定事件
function PVShopPage:initTouchListener()

    local function menuBackClick()
        getAudioManager():playEffectButton2()
        print("back ....")
        -- self:onHideView()
        if isEntry then
            print("-------self:onHideView()-------")
            self:onHideView()
            isEntry = false
        else
            showModuleView(MODULE_NAME_HOMEPAGE)
        end
        groupCallBack(GuideGroupKey.HOME)

        -- stepCallBack(G_GUIDE_20121)

        -- local currentGID = getNewGManager():getCurrentGid()
        -- if currentGID == G_SELECT_LINEUP_2  then
        --     local homePage = getPlayerScene().homeModuleView.moduleView
        --     homePage:scrollToSPage()
        -- end
    end
    local function menuClickCharge()  --充值回调事件
        getAudioManager():playEffectButton2()
        print("menuclick back 。。。")
        getModule(MODULE_NAME_SHOP):showUIViewAndInTop("PVshopRecharge")
 
    end
    local function menuClickA() --招募事件
        getAudioManager():playEffectButton2()
        print("menuClickA")
        self:updateMenuByIndex(1)
    end
    local function menuClickB() --宝箱事件
        getAudioManager():playEffectButton2()
        -- print("menuClickB")
        
        local _stageId = self.baseTemp:getEquMallOpenStage()
        local _isOpen = self.stageData:getIsOpenByStageId(_stageId)
        if _isOpen then
            self:updateMenuByIndex(2)
            groupCallBack(GuideGroupKey.BTN_EQUIP_IN_MALL)
            -- stepCallBack(G_GUIDE_40132)   -- 40053 点击装备页签
        else
            getStageTips(_stageId)
            return
        end
    end
    local function menuClickC() --道具事件
        getAudioManager():playEffectButton2()
        -- print("menuClickC")
        self:updateMenuByIndex(3)
    end
    local function menuClickD() --礼包事件
        getAudioManager():playEffectButton2()
        -- print("menuClickD")
        self:updateMenuByIndex(4)
    end
    local function menuRefresh()
        getAudioManager():playEffectButton2()
        -- print("刷新")
        local usedRefreshTimes = self.shopData:getRefreshTimes()
        -- cclog("VIP等级为 "..self.vipNo.."刷新次数  "..self.refreshTimes.."已用次数"..usedRefreshTimes)
        if self.refreshTimes <= usedRefreshTimes then
            getOtherModule():showAlertDialog(nil, Localize.query("shop.19"))
            return
        end
        if self.commonData:getGold() < self.flashMoney then
            -- self:toastShow(Localize.query("shop.8"))
            getOtherModule():showAlertDialog(nil, Localize.query("shop.8"))
        else
            getNetManager():getShopNet():sendRefreshShopList(12)
        end
    end
    local function menuBuyAll()
        print("menuBuyAll购买全部")
        getAudioManager():playEffectButton2()

        if table.nums(self.shopData:getShopEquipList()) == 0 then
            -- self:toastShow( Localize.query("shop.14") )
            getOtherModule():showAlertDialog(nil, Localize.query("shop.14"))
            return
        end

        -- 统计所有消耗，提示出消息SystemTips
        local _coins = 0
        local _golds = 0     
         for k,v in pairs(self.equipmentTable) do
            if v.got == false then
                local consumeData = v.consume
                local discout = v.discountPrice
                local useMoney = 0
                if table.nums(discout) ~= 0 then
                    useMoney = table.getValueByIndex(discout, 1)[1]
                else
                    useMoney = table.getValueByIndex(consumeData, 1)[1]
                end
                local useMoneyType = tonumber(table.getKeyByIndex(consumeData, 1))
                if useMoneyType == 107 then useMoneyType = tonumber(table.getValueByIndex(consumeData, 1)[3]) end
                if useMoneyType == 1 then _coins = _coins + useMoney
                elseif useMoneyType == 2 then _golds = _golds + useMoney
                end
                
            end
        end

        local coinValue = self.commonData:getCoin()
        local goldValue = self.commonData:getGold()

        if goldValue <  _golds then
            getOtherModule():showAlertDialog(nil, Localize.query("shop.8"))
            return      
        elseif coinValue < _coins then
            getOtherModule():showAlertDialog(nil, Localize.query("shop.10"))
            return 
        end
        
        local tips = ""
        if _coins ~= 0 and _golds ~= 0 then
            tips = string.format(Localize.query("shop.11"), _coins, _golds)
        elseif _coins == 0 and _golds ~= 0 then
            tips = string.format(Localize.query("shop.12"), _golds)
        elseif _coins ~= 0 and _golds == 0 then
            tips = string.format(Localize.query("shop.13"), _coins)
        end
        print("tips" .. tips)
        getOtherModule():showOtherView("SystemTips", tips)
        self.moneyType = 0
        self.useMoney = {coins=_coins,golds=_golds}
    end

    self.ccbiNode["UIShop"] = {}
    self.ccbiNode["UIShop"]["backMenuClick"] = menuBackClick
    self.ccbiNode["UIShop"]["menuClickCharge"] = menuClickCharge
    self.ccbiNode["UIShop"]["menuClickA"] = menuClickA
    self.ccbiNode["UIShop"]["menuClickB"] = menuClickB
    self.ccbiNode["UIShop"]["menuClickC"] = menuClickC
    self.ccbiNode["UIShop"]["menuClickD"] = menuClickD
    self.ccbiNode["UIShop"]["onBuyAll"] = menuBuyAll
    self.ccbiNode["UIShop"]["onFlash"] = menuRefresh
end

function PVShopPage:updateMenuByIndex(idx)
    cclog("--------PVShopPage:updateMenuByIndex----"..idx)
    table.print(self.viewTable)
    --将disabled的menu设置为enabled
    for i,var in ipairs(self.menu) do
        if var:isEnabled() == false then
            var:setEnabled(true)
            self.menuFont[i]:setVisible(true)  --将灰色的显示出来
            self.menuFont2[i]:setVisible(false) --将高亮的隐藏
        end
    end
    -- -- 将当前显示的子页面全设为隐藏
    for k,var in pairs(self.viewTable) do
        if var:isVisible() == true then
            var:setVisible(false)
            if var.letEnabled then var:letEnabled(false) end
        end
        if k == GIFTBAG then var.tableView:setTouchEnabled(false) end
        if k == PROP then var.tableView:setTouchEnabled(false) end
    end
    -- 为菜单设置高亮
    self.menu[idx]:setEnabled(false)
    self.menuFont[idx]:setVisible(false)  --将灰色的隐藏
    self.menuFont2[idx]:setVisible(true)  --将高亮的显示出来
    -- 调用具体页面
    if idx == 1 then self:onRecruitCallback()
    elseif idx == 2 then self:onChestCallback()
    elseif idx == 3 then self:onPropCallback()
    else self:onGiftBagCallback()
    end

     -- 将当前显示的子页面全设为隐藏
    -- for k,var in pairs(self.viewTable) do
    --     if var:isVisible() == true then
    --         var:setVisible(false)
    --         if var.letEnabled then var:letEnabled(false) end
    --     end
    --     if k == GIFTBAG then var.tableView:setTouchEnabled(false) end
    --     if k == PROP then var.tableView:setTouchEnabled(false) end
    -- end
end

--招募按钮回调事件
function PVShopPage:onRecruitCallback()
    print("招募---")
    self.equipNode:setVisible(false)
    if self.viewTable[RECRIUT] == nil then
        local recruitView = RecruitView.new()
        self.viewTable[RECRIUT] = recruitView
        self.rcNode:addChild(self.viewTable[RECRIUT])
    end
    if self.viewTable[RECRIUT]:isVisible() == false then
        self.viewTable[RECRIUT]:setVisible(true)
        self.viewTable[RECRIUT]:letEnabled(true)
    end
    self.labelTipsBottom:setVisible(true)
    self.labelTipsBottom:setString(Localize.query("shop.1"))
end

--宝箱按钮回调事件
function PVShopPage:onChestCallback()

    if self.viewTable[CHEST] == nil then
        self:createEquipTableView()
        getNetManager():getShopNet():sendGetShopList(12)
        self.shopData:setShopType(12)
        
        self.equipTableView:reloadData()
        self:tableViewItemAction(self.equipTableView)
        self.viewTable[CHEST] = self.equipNode
    end
    if self.viewTable[CHEST]:isVisible() == false then
        self.viewTable[CHEST]:setVisible(true)
        self.equipTableView:reloadData()

        self:tableViewItemAction(self.equipTableView)
        if self.viewTable[CHEST].letEnabled then
            self.viewTable[CHEST]:letEnabled(true)
        end
    end
    self.labelTipsBottom:setVisible(true)
    self.labelTipsBottom:setString(Localize.query("shop.2"))
end

--道具按钮回调事件
function PVShopPage:onPropCallback()
    self.equipNode:setVisible(false)
    if self.viewTable[PROP] == nil then
        cclog("道具回调－－－－－－－－－－－－－－")
        local ppView = PpView.new()
        self.viewTable[PROP] = ppView
        getNetManager():getShopNet():sendGetShopList(3)
        self.shopData:setShopType(3)

        ppView:setViewSize(self.viewLayer:getContentSize())
        --ppView:initTableView() 
        self.viewLayer:addChild(self.viewTable[PROP])
    end
    if self.viewTable[PROP]:isVisible() == false then
        self:tableViewItemAction(self.viewTable[PROP].tableView)
        self.viewTable[PROP]:setVisible(true)
    end
    self.labelTipsBottom:setVisible(false)
end

--礼包按钮回调事件
function PVShopPage:onGiftBagCallback(tag,sender)
    self.equipNode:setVisible(false)
    getOtherModule():showAlertDialog(nil, Localize.query("PVShopPage.1"))
    if true then
        return                                      --此版本未完成，提示
    end
    if self.viewTable[GIFTBAG] == nil then
        local gbView = GbView.new()
        self.viewTable[GIFTBAG] = gbView

        getNetManager():getShopNet():sendGetShopList(4)
        self.shopData:setShopType(4)
        gbView:setViewSize(self.viewLayer:getContentSize())
        -- gbView:initTableView()
        self.viewLayer:addChild(self.viewTable[GIFTBAG])
    end
    if self.viewTable[GIFTBAG]:isVisible() == false then
        self.viewTable[GIFTBAG]:setVisible(true)
        self.viewTable[GIFTBAG].tableView:setTouchEnabled(true)
    end
    self.labelTipsBottom:setVisible(false)
end


--创建装备商店列表
function PVShopPage:createEquipTableView()
    self.equipListLayer:removeAllChildren()
    local function tableCellTouched(tbl, cell)
        print("buy equipment cell touched at index: " .. cell:getIdx())
    end
    local function numberOfCellsInTableView(tab)
       return table.nums(self.equipmentTable)
    end
    local function cellSizeForTable(tbl, idx)
        return 148, 555
    end
    local function tableCellAtIndex(tbl, idx)
        local cell = tbl:dequeueCell()
        if nil == cell then
            cell = cc.TableViewCell:new()

            local function onBuyMenuClick()
                self.moneyType = cell.moneyType
                self.useMoney = cell.useMoney
                --确认按钮
                local function onSureBuyEquip( )
                    local id = self.equipmentTable[cell:getIdx()+1].id
                    local coinValue = self.commonData:getCoin()
                    local goldValue = self.commonData:getGold()
                    if cell.moneyType == 1 then
                        if coinValue >= cell.useMoney then 
                            getNetManager():getShopNet():sendBuyGoods(id)
                        else
                            getOtherModule():showAlertDialog(nil, Localize.query("shop.10"))
                        end
                    elseif cell.moneyType == 2 then
                        if goldValue >= cell.useMoney then 
                            getNetManager():getShopNet():sendBuyGoods(id)
                        else
                            getOtherModule():showAlertDialog(nil, Localize.query("shop.8"))
                        end
                    end
                end
                --取消按钮
                local function onCancelByEquip()
                    
                end
                --触发点击确定引导，在引导中不弹确认框
                if ISSHOW_GUIDE and getNewGManager():getCurrentGid() == GuideId.G_GUIDE_40054 then
                    --此处不应该没有钱，如没钱就是数值错了
                    if cell.moneyType == 2 and self.commonData:getGold() >= cell.useMoney then
                        groupCallBack(GuideGroupKey.BTN_CLICK_SHOP_BUY)
                    else--此处应该是数值表中配置skipEnd=-1，不需要程序结束
                        cclog("onBuyMenuClick data error: gold not enough============================>")
                        getNewGManager():guideOver()
                    end
                else
                    getOtherModule():showConfirmDialog(onSureBuyEquip,onCancelByEquip, Localize.query("shop.21"))                    
                end  
            end

            local function onItemClick()
                local equipData = self.equipmentTable[cell:getIdx()+1]
                local equipId = equipData.gain["102"][3]
                local equipment = getTemplateManager():getEquipTemplate():getTemplateById(equipId)
                getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVOtherEquipAttribute", equipment, 2, nil)
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
            cell.nodeHalf = cell.cardinfo["UIShopEquip"]["node_half"]
            cell.imgHalf = cell.cardinfo["UIShopEquip"]["img_half"]
            cell.goldNode = cell.cardinfo["UIShopEquip"]["node_gold"]
            cell.coinNode = cell.cardinfo["UIShopEquip"]["node_coin"]
            cell.labelCoin = cell.cardinfo["UIShopEquip"]["coin_value"]
            cell.labelGold = cell.cardinfo["UIShopEquip"]["gold_value"]
            cell.menuBuy = cell.cardinfo["UIShopEquip"]["menu_buy"]
            cell.itemMenuItem = cell.cardinfo["UIShopEquip"]["itemMenuItem"]

            cell.disGoldNode = cell.cardinfo["UIShopEquip"]["node_gold_discount"]
            cell.disCoinNode = cell.cardinfo["UIShopEquip"]["node_coin_discount"]
            cell.disLabelCoin = cell.cardinfo["UIShopEquip"]["coin_value_discount"]
            cell.disLabelGold = cell.cardinfo["UIShopEquip"]["gold_value_discount"]
            cell.deltLine = cell.cardinfo["UIShopEquip"]["deleteline"]

            cell.itemMenuItem:setAllowScale(false)

            cell:addChild(node)
        end
        cell.index = idx
        -- 获取数据中的值
        local equipData = self.equipmentTable[idx+1]

        local equipId = equipData.gain["102"][3]

        local consumeData = equipData.consume
        local useMoneyType = tonumber(table.getKeyByIndex(consumeData, 1))
        local useMoney = table.getValueByIndex(consumeData, 1)[1]
        if useMoneyType == 107 then 
            --cclog("装备107－－－－")
            useMoneyType = tonumber(table.getValueByIndex(consumeData, 1)[3]) 
        end

        local discout = equipData.discountPrice
        
        local _icon = self.equipTemp:getEquipResIcon(equipId)
        local _quality = self.equipTemp:getQuality(equipId)
        local _name = self.equipTemp:getEquipName(equipId)
        
        changeEquipIconImageBottom(cell.icon, _icon, _quality)  -- 设置卡的图片
        cell.equipName:setString(_name)
        local discoutNum = 1
        if useMoneyType == 1 then
            cell.coinNode:setVisible(true)
            cell.goldNode:setVisible(false)
            cell.disGoldNode:setVisible(false)
            if table.nums(discout) ~= 0 then
                local disMoney = table.getValueByIndex(discout, 1)[1]
                cell.nodeHalf:setVisible(true)
                cell.deltLine:setVisible(true)
                cell.labelCoin:setString(useMoney)
                cell.disCoinNode:setVisible(true)
                cell.disLabelCoin:setString(disMoney)
                discoutNum = disMoney/useMoney
                self:setDiscoutImg(cell.imgHalf,discoutNum)
            else
                cell.nodeHalf:setVisible(false)
                cell.deltLine:setVisible(false)
                cell.labelCoin:setString(useMoney)
                cell.disCoinNode:setVisible(false)
            end
            cell.moneyType = 1
        elseif useMoneyType == 2 then
            cell.coinNode:setVisible(false)
            cell.goldNode:setVisible(true)
            cell.disCoinNode:setVisible(false)
            if table.nums(discout) ~= 0 then
                local disMoney = table.getValueByIndex(discout, 1)[1]
                cell.nodeHalf:setVisible(true)
                cell.deltLine:setVisible(true)
                cell.labelGold:setString(useMoney)
                cell.disGoldNode:setVisible(true)
                cell.disLabelGold:setString(disMoney)
                discoutNum = disMoney/useMoney
                self:setDiscoutImg(cell.imgHalf,discoutNum)
            else
                cell.nodeHalf:setVisible(false)
                cell.deltLine:setVisible(false)
                cell.labelGold:setString(useMoney)
                cell.disGoldNode:setVisible(false)
            end
            --cell.labelGold:setString(useMoney)
            cell.moneyType = 2
        end

        if equipData.got then
            cell.menuBuy:setEnabled(false)
            cell.menuBuy:setSelectedImage(game.newSprite("#ui_shop_s_gotit.png"))
        else
            cell.menuBuy:setEnabled(true)
            cell.menuBuy:setSelectedImage(game.newSprite("#ui_shop_s_buy.png"))
        end

        cell.useMoney = useMoney * discoutNum

        return cell
    end

    local layerSize = self.equipListLayer:getContentSize()

    self.equipTableView = cc.TableView:create(layerSize)
    self.equipTableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.equipTableView:setDelegate()
    self.equipTableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.equipListLayer:addChild(self.equipTableView)

    self.equipTableView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
    self.equipTableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.equipTableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.equipTableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)

    local scrBar = PVScrollBar:new()
    scrBar:init(self.equipTableView,1)
    scrBar:setPosition(cc.p(layerSize.width,layerSize.height/2))
    self.equipListLayer:addChild(scrBar,2)
end
function PVShopPage:setDiscoutImg(spr,disc)
    disc = disc * 10
    local imgName = string.format("#discout%d.png",disc)
    game.setSpriteFrame(spr,imgName)
end

-- 更新界面
function PVShopPage:onReloadView()

    if COMMON_TIPS_BOOL_RETURN == true then
        print("~~~~~~~~~~~ buy all goods .........")
        getNetManager():getShopNet():sendBuyGoods(self.shopData:getShopEquipList())
        COMMON_TIPS_BOOL_RETURN = nil
    elseif COMMON_TIPS_BOOL_RETURN == false then
        COMMON_TIPS_BOOL_RETURN = nil
        return
    end

    print("~~~~~~~~~~~~~~~~~~~onReloadView")
    if self.viewTable[RECRIUT] ~= nil then
        if self.viewTable[RECRIUT]:isVisible() == true then
            self.viewTable[RECRIUT]:updateData()
        end
        self:updateCommonData()
    end
    if self.viewTable[CHEST] ~= nil then
        if self.viewTable[CHEST]:isVisible() == true then
            --self:updateData()
            getNetManager():getShopNet():sendGetShopList(12)   -- 更新
            self.shopData:setShopType(12)
        end
    end

     if self.viewTable[PROP] ~= nil then
        if self.viewTable[PROP]:isVisible() == true then
            --self:updateData()
            getNetManager():getShopNet():sendGetShopList(3)   -- 更新
            self.shopData:setShopType(3)
        end
    end

    if self.viewTable[GIFTBAG] ~= nil then
        if self.viewTable[GIFTBAG]:isVisible() == true then
            --self:updateData()
            getNetManager():getShopNet():sendGetShopList(4)   -- 更新
            self.shopData:setShopType(4)
        end
    end
end


--@return
return PVShopPage

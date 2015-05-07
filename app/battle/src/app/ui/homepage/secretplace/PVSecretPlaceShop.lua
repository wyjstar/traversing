-- 秘境商人

local PVSecretPlaceShop = class("PVSecretPlaceShop", BaseUIView)

 local TYPE_SHOP_SECRETPLACE = 7

function PVSecretPlaceShop:ctor(id)
    PVSecretPlaceShop.super.ctor(self, id)

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

    self.activityNet = getNetManager():getActivityNet()

    self.GameLoginResponse = getDataManager():getCommonData():getData()
    -- self.SoulShopTemplate = getTemplateManager():getSoulShopTemplate()
    self.curCellId = 0
    self.itemList = {}
end

function PVSecretPlaceShop:onMVCEnter()

    self.UISecretPlaceShopView = {}
    self.generalItems = {}
    self.itemCount = 0

    self:initTouchListener()
    self:loadCCBI("secretTerritory/ui_secretshop_panel.ccbi", self.UISecretPlaceShopView)
    
    self:initView()
    -- self:initTableView()

    -- 获取商店列表
    getNetManager():getShopNet():sendGetShopList(TYPE_SHOP_SECRETPLACE)

end

function PVSecretPlaceShop:initView()
    self.contentLayer = self.UISecretPlaceShopView["UISecretPlaceShopView"]["contentLayer"]
    self.blackCL = self.UISecretPlaceShopView["UISecretPlaceShopView"]["blackCL"]
    -- self.totalSoulNumLabel = self.UISecretPlaceShopView["UISecretPlaceShopView"]["totalSoulNumLabel"]
    -- self.timeLablel = self.UISecretPlaceShopView["UISecretPlaceShopView"]["timeLablel"]
    -- self.refreshBtn = self.UISecretPlaceShopView["UISecretPlaceShopView"]["refreshBtn"]
    -- self.refreshMoney = self.UISecretPlaceShopView["UISecretPlaceShopView"]["flash_value"]
end

function PVSecretPlaceShop:initRegisterNetCallBack()
    function onGetShopListCallBack(id, data)
        print("get secretshop list ...")
        if not self:handelCommonResResult(data.res) then
            return
        else
            print("----------------initRegisterNetCallBack----------")
            table.print(data)

            self.shopData:setSecretPlaceList(data.id)
            self.shopData:setSecretPlaceGotList(data.buyed_id)
            self:updateData()
        end
    end

    local function getGoodsCallback(id, data)
        if data.res.result ~= true then
            print("!!! 数据返回错误")
        else
            print("!!! getGoodlsCallback")
            table.print(data)
            self.commonData:subGold( self.useMoney )


            self.itemList[self.curCellId+1].got = true
            -- table.insert(self.itemList, )

            -- table.remove(self.itemList, self.curCellId+1)
            -- getModule(MODULE_NAME_SHOP):showUITopShowLastView("PVShopEquBuySuccess", data.gain.equipment)
            -- getOtherModule():showOtherView("DialogGetCard", self.gain)
            local reward = data.gain
            table.print(reward)
            local flag = table.getKeyByIndex(reward, 1)
 
            if flag == "equipments" then 
                getModule(MODULE_NAME_SHOP):showUITopShowLastView("PVShopEquBuySuccess", reward.equipments)
            else 
                getOtherModule():showOtherView("DialogGetCard",self.gain)
               
            end
            
            local pos = self.soulTableView:getContentOffset()

            self.soulTableView:reloadData()
            self.soulTableView:setContentOffset(cc.p(pos.x, pos.y))
            self:resetTabviewContentOffset(self.soulTableView)
        end
    end

    self:registerMsg(SHOP_GET_ITEM_CODE, onGetShopListCallBack)
    self:registerMsg(SHOP_BUY_GOODS_CODE, getGoodsCallback)
end


function PVSecretPlaceShop:updateData()
    local _idsList = self.shopData:getSecretPlaceList()
    local _idsGotList = self.shopData:getSecretPlaceGotList()
--     local _flashMoney, _flashType = self.shopTemp:getFlashMoney(9)
    
    -- print("——flash——", _flashMoney, _flashType)
    print("--------updateData--------------")
    -- getDataManager():getMineData():setShopCanBuy(true)
    -- if _idsList == nil or table.nums(_idsList) == 0 then
    --     getDataManager():getMineData():setShopCanBuy(false)
    -- end
--     -- 获取商城装备数据
    self.itemList = {}
    for k,v in pairs(_idsList) do
        local value = self.shopTemp:getTemplateById(v)
        value.got = false
        table.insert(self.itemList, value)
    end
    for k,v in pairs(_idsGotList) do
        local value = self.shopTemp:getTemplateById(v)
        value.got = true
        table.insert(self.itemList, value)
    end
    
    local function cmp(a,b)
        return a.id < b.id
    end

    table.sort( self.itemList, cmp )
    table.print(self.itemList)

    if self.soulTableView == nil then
        cclog("create a tabele")
        self:initTableView()
    end

    self.soulTableView:reloadData()
    self:tableViewItemAction(self.soulTableView)

end


function PVSecretPlaceShop:initTouchListener()

    local function onCloseClick()
        cclog("onCloseClick")
        getAudioManager():playEffectButton2()
        SECRET_SHOP_BACK = true             --供返回到主界面刷新使用
        self:onHideView()
    end

    local function onMakeSure()
        cclog("onSacrificeClick")
        getAudioManager():playEffectButton2()
        SECRET_SHOP_BACK = true
        self:onHideView()
    end

    self.UISecretPlaceShopView["UISecretPlaceShopView"] = {}
    self.UISecretPlaceShopView["UISecretPlaceShopView"]["onCloseClick"] = onCloseClick
    self.UISecretPlaceShopView["UISecretPlaceShopView"]["onMakeSure"] = onMakeSure
end

function PVSecretPlaceShop:initTableView()

    local function tableCellTouched(tbl, cell)
        print("soul list touched at index: " .. cell:getIdx())
    end

    local function numberOfCellsInTableView(tab)

       return  table.nums(self.itemList)
    end

    local function cellSizeForTable(tbl, idx)
        return 148, 417.5
    end

    local function tableCellAtIndex(tbl, idx)
        local cell = tbl:dequeueCell()
        if nil == cell then
            cell = cc.TableViewCell:new()

            local function menuClickBuy()
                local id = self.itemList[cell:getIdx()+1].id    
                
                print(id)
                self.gain = cell.gain
                local _Data = self.itemList[cell:getIdx()+1]
                local consumeKey = table.getKeyByIndex(_Data.consume,1)
                self.useMoney = _Data.consume[consumeKey][1]
                -- self.useMoney = _Data.consume["2"][1]
                self.curCellId  = cell:getIdx()
                if self.commonData:getGold() >= self.useMoney then
                    self.blackCL:setVisible(true)
                    getNetManager():getShopNet():sendBuyGoods(id)
                else
                    -- self:toastShow(Localize.query("shop.8"))
                    getOtherModule():showAlertDialog(nil, Localize.query("shop.8"))
                end
            end

            cell.cardinfo = {}
            local proxy = cc.CCBProxy:create()
            cell.cardinfo["UIShopEquip"] = {}
            cell.cardinfo["UIShopEquip"]["menuClickBuy"] = menuClickBuy
            local node = CCBReaderLoad("secretTerritory/ui_secretshop_item.ccbi", proxy, cell.cardinfo)

            -- 获取Item上的控件
            cell.icon = cell.cardinfo["UIShopEquip"]["headIcon"]
            cell.node_coin = cell.cardinfo["UIShopEquip"]["node_coin"]
            cell.node_gold = cell.cardinfo["UIShopEquip"]["node_gold"]

            cell.equipName = cell.cardinfo["UIShopEquip"]["equipName"]
            cell.labelNum = cell.cardinfo["UIShopEquip"]["labelNum"]
            cell.labelMoney = cell.cardinfo["UIShopEquip"]["coin_value"]
            cell.goldValue = cell.cardinfo["UIShopEquip"]["gold_value"]

            cell.menuBuy = cell.cardinfo["UIShopEquip"]["menu_buy"]
            

            cell:addChild(node)
        end
        cell.index = idx
        -- 获取数据中的值
        local _Data = self.itemList[idx+1]
        -- table.print(_Data)
        local gainData = _Data.gain
        cell.gain = gainData
        local gainKey = tonumber(table.getKeyByIndex(gainData, 1))
        local gainValue = table.getValueByIndex(gainData, 1)

        -- -- -- print("~~~~~~~~~~~", gainKey, gainValue)
        

        -- -- -- 分类处理,更改名字，图标
        if gainKey == 101 then -- hero
            local _temp = self.soldierTemp:getSoldierIcon(gainValue[3])
            local quality = self.soldierTemp:getHeroQuality(gainValue[3])
            changeNewIconImage(cell.icon, _temp, quality)
            cell.equipName:setString(self.soldierTemp:getHeroName(gainValue[3]))
        elseif gainKey == 102 then -- equipment
            local _temp = self.equipTemp:getEquipResIcon(gainValue[3])
            local quality = self.equipTemp:getQuality(gainValue[3])
            changeEquipIconImageBottom(cell.icon, _temp, quality)
            cell.equipName:setString(self.equipTemp:getEquipName(gainValue[3]))
        elseif gainKey == 103 then -- hero chip;
            local _temp = self.chipTemp:getTemplateById(gainValue[3]).resId
            local _icon = self.resourceTemp:getResourceById(_temp)
            local _quality = self.chipTemp:getTemplateById(gainValue[3]).quality
            setChipWithFrame(cell.icon,"res/icon/hero/".._icon, _quality)
            cell.equipName:setString(self.chipTemp:getChipName(gainValue[3]))
        elseif gainKey == 104 then -- equipment chip
            local _temp = self.chipTemp:getTemplateById(gainValue[3]).resId
            local _icon = self.resourceTemp:getResourceById(_temp)
            local _quality = self.chipTemp:getTemplateById(gainValue[3]).quality
            setChipWithFrame(cell.icon,"res/icon/equipment/".._icon, _quality)
            cell.equipName:setString(self.chipTemp:getChipName(gainValue[3]))
        elseif gainKey == 105 then -- item
            local _temp = self.bagTemp:getItemResIcon(gainValue[3])
            local quality = self.bagTemp:getItemQualityById(gainValue[3])
            setCardWithFrame(cell.icon, "res/icon/item/".._temp, quality)
            cell.equipName:setString(self.bagTemp:getItemName(gainValue[3]))
        elseif gainKey == 106 then -- big_bag
            -- to do 不用大包吧
        else -- resource
            local _res = self.resourceTemp:getResourceById(gainValue[3])
            setItemImage(cell.icon, "#".._res, 1)
            local nameStr = self.resourceTemp:getResourceName(gainValue[3])
            cell.equipName:setString(nameStr)
        end
        cell.labelNum:setString("X "..gainValue[1])
        
        local consumeKey = table.getKeyByIndex(_Data.consume,1)
        local useMoney = _Data.consume[consumeKey][1]
        local _useMoneyType = _Data.consume[consumeKey][3]

        cell.goldValue:setString(tostring("x "..useMoney))

        if _Data.got then 
            cell.menuBuy:setEnabled(false)
            SpriteGrayUtil:drawSpriteTextureGray(cell.menuBuy:getNormalImage())
        else 
            cell.menuBuy:setEnabled(true)
            SpriteGrayUtil:drawSpriteTextureColor(cell.menuBuy:getNormalImage())
        end

        return cell
    end

    local layerSize = self.contentLayer:getContentSize()
    self.soulTableView = cc.TableView:create(layerSize)
    self.soulTableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.soulTableView:setDelegate()
    self.soulTableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.contentLayer:addChild(self.soulTableView)

    self.soulTableView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
    self.soulTableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.soulTableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.soulTableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)

    local scrBar = PVScrollBar:new()
    scrBar:init(self.soulTableView,1)
    scrBar:setPosition(cc.p(layerSize.width,layerSize.height/2))
    self.contentLayer:addChild(scrBar,2)
    
    self.soulTableView:reloadData()

end

function PVSecretPlaceShop:onReloadView()
    self.blackCL:setVisible(false)
end

return PVSecretPlaceShop

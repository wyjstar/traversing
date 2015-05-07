local PVExchangeDialog = class("PVExchangeDialog", BaseUIView)

function PVExchangeDialog:ctor(id)
    PVExchangeDialog.super.ctor(self, id)

    self.shopTemp = getTemplateManager():getShopTemplate()
    self.languageTemp = getTemplateManager():getLanguageTemplate()
    self.equipTemp = getTemplateManager():getEquipTemplate()
    self.shopData = getDataManager():getShopData()
    self.dropTemp = getTemplateManager():getDropTemplate()
    self.bagTemp = getTemplateManager():getBagTemplate()
    self.resourceTemp = getTemplateManager():getResourceTemplate()
    self.soldierTemp = getTemplateManager():getSoldierTemplate()
    self.chipTemp = getTemplateManager():getChipTemplate()
end

function PVExchangeDialog:onMVCEnter()
    self.UIDialogView = {}
    self:initTouchListener()

    self:loadCCBI("soul/ui_dialog.ccbi", self.UIDialogView)

    self:initView()

    self:initData()
end

function PVExchangeDialog:initTouchListener()

    local function onItemClick()
        cclog("onItemClick")
    end
    local function onCloseClick()
        self:hideDialogView()
    end
    local function onSureClick()
        self:hideDialogView()
        groupCallBack(GuideGroupKey.BTN_EQUIPATTR_IN_EXCHANGE)
        groupCallBack(GuideGroupKey.BTN_CLICK_WUHUN_SHOP)
        groupCallBack(GuideGroupKey.BTN_CLOSE_WUHUN_SHOP)
    end

    self.UIDialogView["UIDialogView"] = {}
    self.UIDialogView["UIDialogView"]["onItemClick"] = onItemClick
    self.UIDialogView["UIDialogView"]["onCloseClick"] = onCloseClick
    self.UIDialogView["UIDialogView"]["onSureClick"] = onSureClick
end

function PVExchangeDialog:initView()
    self.itemNumber = self.UIDialogView["UIDialogView"]["itemNumber"]
    self.itemName = self.UIDialogView["UIDialogView"]["itemName"]
    self.itemDetail = self.UIDialogView["UIDialogView"]["itemDetail"]
    self.itemCoin = self.UIDialogView["UIDialogView"]["icon"]
    self.itemNum = self.UIDialogView["UIDialogView"]["item_num"]
end

function PVExchangeDialog:initData()
    self.shopItemId = self.funcTable[1]

    print("~~~~~~~~~~~~~~~", self.shopItemId)

    -- 获取数据中的值
    local soulData = getTemplateManager():getShopTemplate():getTemplateById(self.shopItemId)

    local gainData = soulData.gain
    local gainKey = tonumber(table.getKeyByIndex(gainData, 1))
    local gainValue = table.getValueByIndex(gainData, 1)
    setCommonDrop(gainKey, gainValue[3], self.itemCoin, nil)
    -- 分类处理,更改名字，图标
    -- if gainKey == 101 then -- hero
    --     local _temp = self.soldierTemp:getSoldierIcon(gainValue[3])
    --     local quality = self.soldierTemp:getHeroQuality(gainValue[3])
    --     changeNewIconImage(self.itemCoin, _temp, quality)
    --     self.itemName:setString(self.soldierTemp:getHeroName(gainValue[3]))
    --     self.itemDetail:setString(self.soldierTemp:getDescribe(gainValue[3]))
    -- elseif gainKey == 102 then -- equipment
    --     local _temp = self.equipTemp:getEquipResIcon(gainValue[3])
    --     local quality = self.equipTemp:getQuality(gainValue[3])
    --     changeEquipIconImageBottom(self.itemCoin, _temp, quality)
    --     self.itemName:setString(self.equipTemp:getEquipName(gainValue[3]))
    --     self.itemDetail:setString(self.equipTemp:getDescribe(gainValue[3]))
    -- elseif gainKey == 103 then -- hero chip;
    --     local _temp = self.chipTemp:getTemplateById(gainValue[3]).resId
    --     local _icon = self.resourceTemp:getResourceById(_temp)
    --     local _quality = self.chipTemp:getTemplateById(gainValue[3]).quality
    --     setChipWithFrame(self.itemCoin,"res/icon/hero/".._icon, _quality)
    --     self.itemName:setString(self.chipTemp:getChipName(gainValue[3]))
    --     self.itemDetail:setString("")
    -- elseif gainKey == 104 then -- equipment chip
    --     local _temp = self.chipTemp:getTemplateById(gainValue[3]).resId
    --     local _icon = self.resourceTemp:getResourceById(_temp)
    --     local _quality = self.chipTemp:getTemplateById(gainValue[3]).quality
    --     setChipWithFrame(self.itemCoin,"res/icon/equipment/".._icon, _quality)
    --     self.itemName:setString(self.chipTemp:getChipName(gainValue[3]))
    --     self.itemDetail:setString("")
    -- elseif gainKey == 105 then -- item
    --     local _temp = self.bagTemp:getItemResIcon(gainValue[3])
    --     local quality = self.bagTemp:getItemQualityById(gainValue[3])
    --     setCardWithFrame(self.itemCoin, "res/icon/item/".._temp, quality)
    --     self.itemName:setString(self.bagTemp:getItemName(gainValue[3]))
    --     self.itemDetail:setString(self.bagTemp:getDescribe(gainValue[3]))
    -- elseif gainKey == 106 then -- big_bag
    --     -- to do 不用大包吧
    -- elseif gainKey == 107 then  -- resource   元气
    --     local _res = self.resourceTemp:getResourceById(gainValue[3])
    --     setItemImage(self.itemCoin, "res/icon/resource/".._res, 1)

    --     local nameStr = self.resourceTemp:getResourceName(gainValue[3])
    --     self.itemName:setString(nameStr)
    --     self.itemDetail:setString(self.resourceTemp:getDescribe(gainValue[3]))
    -- else -- resource
    --     local _res = self.resourceTemp:getResourceById(gainValue[3])
    --     setItemImage(self.itemCoin, "#".._res, 1)
    --     local nameStr = self.resourceTemp:getResourceName(gainValue[3])
    --     self.itemName:setString(nameStr)
    --     self.itemDetail:setString("")
    -- end

    self.itemNum:setString(tostring("x "..gainValue[1]))


end

function PVExchangeDialog:showDialogView(id)
    cclog('--PVExchangeDialog:showDialogView--')
    self.itemNumber:setString(string.format(id))
    self:setVisible(true)
    self.curId = id
end

function PVExchangeDialog:hideDialogView()
    self:onHideView(9)
end

return PVExchangeDialog

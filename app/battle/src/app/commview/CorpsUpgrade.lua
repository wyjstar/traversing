
CorpsUpgrade = CorpsUpgrade or class("CorpsUpgrade")

function CorpsUpgrade:ctor(controller)
    self._resourceTemp = getTemplateManager():getResourceTemplate()
    self.chipTemp = getTemplateManager():getChipTemplate()
end

function CorpsUpgrade:startView()
    self:initData()
    self:initView()
    self:startTime()
end

function CorpsUpgrade:initData()
    self.upgtadeData = getDataManager():getStageData():getGropUpgradeData()

    -- required int32 level = 1;
    --  required GameResourcesResponse drops = 2;
    self.itemLists = {}
    for k, v in pairs(self.upgtadeData) do
        local level = v.level
        local drops = v.drops
        local itemList = self:createTableData(drops)
        self.itemLists[#self.itemLists + 1] = itemList
    end
    self.listIndex = 1
end

function CorpsUpgrade:initView()
    -- game.addSpriteFramesWithFile("res/ccb/resource/ui_newHandLead.plist")
    
    local sharedDirector = cc.Director:getInstance()
    local glsize = sharedDirector:getWinSize()
    self.adapterLayer = cc.Layer:create()

    local shieldlayer = game.createShieldLayer()
    self.adapterLayer:addChild(shieldlayer)
    shieldlayer:setTouchEnabled(true)

    self.adapterLayer:setContentSize(cc.size(CONFIG_SCREEN_SIZE_WIDTH, CONFIG_SCREEN_SIZE_HEIGHT))
    self.adapterLayer:setPosition(cc.p(glsize.width / 2 - CONFIG_SCREEN_SIZE_WIDTH / 2, glsize.height / 2 - CONFIG_SCREEN_SIZE_HEIGHT / 2))
    
    self.upgradeNode = game.newNode()
    self.adapterLayer:addChild(self.upgradeNode)
    local runningScene = game.getRunningScene()
    runningScene:addChild(self.adapterLayer, 10000)

    self.UIGoUpView = {}
    -- self:initTouchListener()
    local proxy = cc.CCBProxy:create()
    local node = CCBReaderLoad("instance/ui_goup_view.ccbi", proxy, self.UIGoUpView)
    self.upgradeNode:addChild(node)

    self.goupSp = self.UIGoUpView["UIGoUpView"]["goupSp"]   
    self.soldierGoupSp = self.UIGoUpView["UIGoUpView"]["soldierGoupSp"]   
    self.equipGoupSp = self.UIGoUpView["UIGoUpView"]["equipGoupSp"]   

    self.light_bg = self.UIGoUpView["UIGoUpView"]["light_bg"] 
    self.texiaoNode = self.UIGoUpView["UIGoUpView"]["texiaoNode"] 

    self.light_bg:setVisible(false)

end

function CorpsUpgrade:startShowAward()
    print("------升级奖励-------")
    self.UICommonGetCard = {}
    self:initTouchListener()
    local proxy = cc.CCBProxy:create()
    local node = CCBReaderLoad("common/ui_common_getcard.ccbi", proxy, self.UICommonGetCard)

    self.upgradeNode:addChild(node)

    self.contentLayer = self.UICommonGetCard["UICommonGetCard"]["contentLayer"]  
    self:createTableView()
end

function CorpsUpgrade:startTime()
    local delayAction = cc.DelayTime:create(1)
    local function callBack()
        -- self.upgradeNode:removeAllChildren()
        -- local colorLayer = cc.LayerColor:create(cc.c4b(0, 0, 0, 125), 640, 960)
        -- self.upgradeNode:addChild(colorLayer)
        -- self:startShowAward()
        self:startRunAction()
    end

    local sequenceAction = cc.Sequence:create(delayAction, cc.CallFunc:create(callBack))
    self.upgradeNode:runAction(sequenceAction)
end

function CorpsUpgrade:startRunAction()
    self.light_bg:setVisible(true)
    local node = UI_Zhanduishengji()
    self.texiaoNode:addChild(node)

    local delayAction = cc.DelayTime:create(1)
    local function callBack()
        

        local _level_info = getDataManager():getStageData():getGropUpgradeData()
        if _level_info then
            local size = table.nums(_level_info)
            -- print("size====level_info=====", size)
            if size > 0 then
                self.upgradeNode:removeAllChildren()

               local colorLayer = cc.LayerColor:create(cc.c4b(0, 0, 0, 125), 640, 960)
                self.upgradeNode:addChild(colorLayer)
                self:startShowAward()
            else
                self.adapterLayer:removeFromParent(true)
            end
        else
            self.adapterLayer:removeFromParent(true)
        end
        
    end

    local sequenceAction = cc.Sequence:create(delayAction, cc.CallFunc:create(callBack))
    self.upgradeNode:runAction(sequenceAction)
end

function CorpsUpgrade:initTouchListener()
  
    local function onCloseClick()
       -- self:onHideView()
       self:checkNextData()
    end

    local function onSureClick()
       -- self:onHideView()
       self:checkNextData()
        if self.isLast then
            -- print("================================onSureClick")
            --groupCallBack(GuideGroupKey.BTN_WIN_OK)
            print("CorpsUpgrade:initTouchListener=====================>",game.getRunningScene().scenename)
            --getNewGManager():checkLevelUp()
        end
    end

    self.UICommonGetCard["UICommonGetCard"] = {}

    self.UICommonGetCard["UICommonGetCard"]["onCloseClick"] = onCloseClick
    self.UICommonGetCard["UICommonGetCard"]["onSureClick"] = onSureClick

end

function CorpsUpgrade:checkNextData()
    self.listIndex = self.listIndex + 1
    local item = self.itemLists[self.listIndex]
    self.isLast = true
    if item then
        self.isLast = false
        self:startShowAward()
    else
        print("CorpsUpgrade exit")
        --TODO: 不在此检查是否有引导
        -- getFightScene().fvLayerUI:addStageGuide()
        self.adapterLayer:removeFromParent(true)
    end

end

function CorpsUpgrade:createTableData(dropItem)
    local heros = dropItem.heros                --武将
    local equips = dropItem.equipments          --装备
    local items = dropItem.items                --道具
    local h_chips = dropItem.hero_chips         --英雄灵魂石
    local e_chips = dropItem.equipment_chips    --装备碎片
    local finance = dropItem.finance            --finance
    -- local stamina = dropItem.stamina
    -- print("stamina====", stamina)
    -- stamina = 60
    local _itemList = {}  -- 将创建物件需要的数据暂存到_itemList中
    local _index = 1
    if heros ~= nil then
        for k,var in pairs(heros) do
            _itemList[_index] = {type = 101, detailId = var.hero_no, nums = 1}
            _index = _index + 1
        end
    end
    if equips ~= nil then
        for k,var in pairs(equips) do
            _itemList[_index] = {type = 102, detailId = var.no, nums = 1}
            _index = _index + 1
        end
    end
    if h_chips ~= nil then
        for k,var in pairs(h_chips) do
            _itemList[_index] = {type = 103, detailId = var.hero_chip_no, nums = var.hero_chip_num}
            _index = _index + 1
        end
    end
    if e_chips ~= nil then
        for k,var in pairs(e_chips) do
            _itemList[_index] = {type = 104, detailId = var.equipment_chip_no, nums = var.equipment_chip_num}
            _index = _index + 1
        end
    end
    if items ~= nil then
        for k,var in pairs(items) do
            _itemList[_index] = {type = 105, detailId = var.item_no, nums = var.item_num}
            _index = _index + 1
        end   
    end

    if finance ~= nil then
        local gold = finance.gold

        if gold and gold ~= 0 then

            _itemList[_index] = {type = 107, detailId = 2, nums = tonumber(gold)}
            _index = _index + 1
        end

        local coin = finance.coin

        if coin and coin ~= 0 then

            _itemList[_index] = {type = 107, detailId = 1, nums = tonumber(coin)}
            _index = _index + 1
        end

        finance_changes = finance.finance_changes

        if finance_changes ~= nil then
            for k, v in pairs(finance_changes) do
                print("CorpsUpgrade finance: ",v.item_type, v.item_no, v.item_num)
                local item_type = v.item_type
                local item_num = v.item_num
                local item_no = v.item_no
                
                _itemList[_index] = {type = item_type, detailId = item_no, nums = tonumber(item_num)}
                _index = _index + 1
            end
        end

    end

    -- if stamina and stamina > 0 then
    --     _itemList[_index] = {type = 7, detailId = 0, nums = tonumber(stamina)}
    --     _index = _index + 1
    -- end

    return _itemList
end

function CorpsUpgrade:createTableView()
    self.itemListSize = #self.itemLists[self.listIndex]
    local function tableCellTouched( tbl, cell )
        print("drop cell touched ..", cell:getIdx())
        local item = self.itemLists[self.listIndex]
        self.curDrop = item[cell:getIdx() + 1]
        getDataManager():getStageData():setCloseTips(true)
        if self.curDrop.type < 100 then
            getOtherModule():showOtherViewInRunningScene("PVCommonDetail", 2, self.curDrop.detailId, 1)   
        elseif self.curDrop.type == 105 then -- item
            getOtherModule():showOtherViewInRunningScene("PVCommonDetail", 1, self.curDrop.detailId, 1)
        elseif self.curDrop.type == 101 then --hero
            getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInRunningScence("PVSoldierOtherDetail", self.curDrop.detailId, 101)
        elseif self.curDrop.type == 102 then --equipment
            local _equipment = self.c_EquipmentData:getEquipById(self.curDrop.id)
            getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInRunningScence("PVEquipmentAttribute", _equipment, 101)
        elseif self.curDrop.type == 103 then --heroChip  
            getOtherModule():showOtherViewInRunningScene("PVCommonChipDetail", 1, self.curDrop.detailId, self.curDrop.nums, 1) --1 herochip
        elseif  self.curDrop.type == 104 then --equipmentChip
            getOtherModule():showOtherViewInRunningScene("PVCommonChipDetail", 2, self.curDrop.detailId, self.curDrop.nums, 1) --2 equipmentchip 
        elseif  self.curDrop.type == 107 then 
            getOtherModule():showOtherViewInRunningScene("PVCommonDetail", 2, self.curDrop.detailId, 1)
       end
    end
    local function numberOfCellsInTableView(tab)
       return self.itemListSize
    end
    local function cellSizeForTable(tbl, idx)
        return 110,110
    end

    local function tableCellAtIndex(tbl, idx)
        local cell = tbl:dequeueCell()
        if nil == cell then
            cell = cc.TableViewCell:new()
            local cardinfo = {}
            local proxy = cc.CCBProxy:create()
            local node = CCBReaderLoad("common/ui_card_withnumber.ccbi", proxy, cardinfo)
            cell:addChild(node)  
            cell.card = cardinfo["UICommonGetCard"]["img_card"] 
            cell.card:setVisible(false)
            cell.number = cardinfo["UICommonGetCard"]["label_number"]
            cell.number:setLocalZOrder(10)
        end
        local item = self.itemLists[self.listIndex]
        local v = item[idx + 1]
        print("tableCellAtIndex")
        -- table.print(v)
        print("tableCellAtIndex")
        local str = "X "..tostring(v.nums)

        print("str====" .. str)
        cell.number:setString(str)
        
        local sprite = game.newSprite()
        if v.type < 100 then  -- 可直接读的资源图
            _temp = v.type
            local _icon = self._resourceTemp:getResourceById(_temp)
            setItemImage(sprite,"res/icon/resource/".._icon, 1)
        else  -- 需要继续查表
            if v.type == 101 then -- 武将
                _temp = getTemplateManager():getSoldierTemplate():getSoldierIcon(v.detailId)
                local quality = getTemplateManager():getSoldierTemplate():getHeroQuality(v.detailId)
                changeNewIconImage(sprite,_temp,quality)
            elseif v.type == 102 then -- equpment
                _temp = getTemplateManager():getEquipTemplate():getEquipResIcon(v.detailId)
                local quality = getTemplateManager():getEquipTemplate():getQuality(v.detailId)
                changeEquipIconImageBottom(sprite, _temp, quality)
            elseif v.type == 103 then -- hero chips
                _temp = self.chipTemp:getTemplateById(v.detailId).resId
                local _icon = self._resourceTemp:getResourceById(_temp)
                local _quality = self.chipTemp:getTemplateById(v.detailId).quality
                setChipWithFrame(sprite,"res/icon/hero/".._icon, _quality)
            elseif v.type == 104 then -- equipment chips
                _temp = self.chipTemp:getTemplateById(v.detailId).resId
                local _icon = self._resourceTemp:getResourceById(_temp)
                local _quality = self.chipTemp:getTemplateById(v.detailId).quality
                setChipWithFrame(sprite,"res/icon/equipment/".._icon, _quality)
            elseif v.type == 105 then  -- item
                _temp = getTemplateManager():getBagTemplate():getItemResIcon(v.detailId)
                local quality = getTemplateManager():getBagTemplate():getItemQualityById(v.detailId)
                setCardWithFrame(sprite,"res/icon/item/".._temp,quality)
            elseif v.type == 107 then  -- 资源-元气...
                local _icon = self._resourceTemp:getResourceById(v.detailId)
                setItemImage(sprite,"res/icon/resource/".._icon,1)
            end
        end
        cell.card:getParent():addChild(sprite)
        sprite:setPosition(55, 55)
        return cell
    end

    local layerSize = self.contentLayer:getContentSize()
    self.contentLayer:removeAllChildren()

    self.dropTableView = cc.TableView:create(layerSize)    -- 剧情列表
    self.dropTableView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    self.dropTableView:setDelegate()
    self.dropTableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.contentLayer:addChild(self.dropTableView)

    self.dropTableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.dropTableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.dropTableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.dropTableView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)

    local scrBar = PVScrollBar:new()
    scrBar:init(self.dropTableView,1)
    scrBar:setPosition(cc.p(layerSize.width,layerSize.height/2))
    self.contentLayer:addChild(scrBar,2)
    
    self.dropTableView:reloadData()
end

return CorpsUpgrade














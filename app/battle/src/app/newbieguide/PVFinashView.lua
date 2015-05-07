local PVFinashView = class("PVFinashView")

function PVFinashView:ctor(id)
    -- PVFinashView.super.ctor(self, id)
    game.addSpriteFramesWithFile("res/resource/resource_icon1.plist")
    self.instanceTemp = getTemplateManager():getInstanceTemplate()
    self.c_LanguageTemplate = getTemplateManager():getLanguageTemplate()
    self._resourceTemp = getTemplateManager():getResourceTemplate()
    self.soldierTemplate = getTemplateManager():getSoldierTemplate()
    self.chipTemp = getTemplateManager():getChipTemplate()
    self.lineUpData = getDataManager():getLineupData()
    self.c_EquipTemp = getTemplateManager():getEquipTemplate()
    self.squipTemp = getTemplateManager():getSquipmentTemplate()

    self.stageData = getDataManager():getStageData()
    self.soldierData = getDataManager():getSoldierData()
    self.lineUpData = getDataManager():getLineupData()

    self.stageTemp = getTemplateManager():getInstanceTemplate()
    self.commonData = getDataManager():getCommonData()
    self.dropTemp = getTemplateManager():getDropTemplate()
end

function PVFinashView:onMVCEnter()
    -- self:showAttributeView()

end

function PVFinashView:startView()
    self:initData()
    self:checkGuideNode()
    self:initView()
    self:createTableView()
end

function PVFinashView:checkGuideNode()
    if self.adapterLayer == nil then
        local sharedDirector = cc.Director:getInstance()
        local glsize = sharedDirector:getWinSize()
        self.adapterLayer = cc.Layer:create()

        self.adapterLayer:setContentSize(cc.size(CONFIG_SCREEN_SIZE_WIDTH, CONFIG_SCREEN_SIZE_HEIGHT))
        self.adapterLayer:setPosition(cc.p(glsize.width / 2 - CONFIG_SCREEN_SIZE_WIDTH / 2, glsize.height / 2 - CONFIG_SCREEN_SIZE_HEIGHT / 2))

        self.guideNode = game.newNode()
        self.adapterLayer:addChild(self.guideNode)
        local runningScene = game.getRunningScene()
        runningScene:addChild(self.adapterLayer, 10099)
    end
end

function PVFinashView:initView()
    self.UICommonGetCard = {}
    self.UICommonGetCard["UICommonGetCard"] = {}
    local proxy = cc.CCBProxy:create()
    self:initTouchListener()
    local shieldLayer = game.createShieldLayer()
    shieldLayer:setTouchEnabled(true)
    local node = CCBReaderLoad("common/ui_common_getcard.ccbi", proxy, self.UICommonGetCard)
    self.adapterLayer:addChild(shieldLayer)
    self.contentLayer = self.UICommonGetCard["UICommonGetCard"]["contentLayer"]
    self.adapterLayer:addChild(node)
end

function PVFinashView:initTouchListener()

    local function onCloseClick()
       self.adapterLayer:removeFromParent(true)
       self:stepCallBack()
    end

    local function onSureClick()
       self.adapterLayer:removeFromParent(true)
       self:stepCallBack()
    end

    self.UICommonGetCard["UICommonGetCard"] = {}

    self.UICommonGetCard["UICommonGetCard"]["onCloseClick"] = onCloseClick
    self.UICommonGetCard["UICommonGetCard"]["onSureClick"] = onSureClick

end

function PVFinashView:stepCallBack()
    local gId = getNewGManager():getCurrentGid()
    print("gId===== PVFinashView", gId)
end

function PVFinashView:registerDataBack()

end

function PVFinashView:initData()
    local bagBagItem = self.dropTemp:getBigBagById(1)
    local smallBagIdList = bagBagItem.smallPacketId
    self.itemList = {}
    for k, smallDropId in pairs(smallBagIdList) do

        local smallBagItemList = self.dropTemp:getAllItemsByDropId(smallDropId)
        for m, n in pairs(smallBagItemList) do
            self.itemList[#self.itemList + 1] = n
        end
    end
    self.itemListSize = #self.itemList
    print("tableCellAtIndex=======")
    table.print(self.itemList)
    print("tableCellAtIndex=======")

end

function PVFinashView:createTableView()
    local function tableCellTouched( tbl, cell )
        print("drop cell touched ..", cell:getIdx())
    end
    local function numberOfCellsInTableView(tab)
       return self.itemListSize
    end
    local function cellSizeForTable(tbl, idx)
        return 125,110
    end

    local function tableCellAtIndex(tbl, idx)
        local cell = tbl:dequeueCell()
        if nil == cell then
            cell = cc.TableViewCell:new()
            local cardinfo = {}
            local proxy = cc.CCBProxy:create()
            local node = CCBReaderLoad("common/ui_card_withnumber2.ccbi", proxy, cardinfo)
            cell:addChild(node)
            cell.card = cardinfo["UICommonGetCard"]["img_card"]
            -- cell.card:setVisible(false)
            cell.number = cardinfo["UICommonGetCard"]["label_number"]
            cell.number:setLocalZOrder(10)
        end

        local v = self.itemList[idx + 1]
        cell.number:setString("X "..tostring(v.count))
        print("v.countv.countv.count ======= ", v.count)
        -- local sprite = game.newSprite()
        if v.type < 100 then  -- 可直接读的资源图
            _temp = v.type
            local _icon = self._resourceTemp:getResourceById(_temp)
            setItemImage(cell.card, "res/icon/resource/".._icon, 1)
        else  -- 需要继续查表
            if v.type == 101 then -- 武将
                _temp = getTemplateManager():getSoldierTemplate():getSoldierIcon(v.detailId)
                local quality = getTemplateManager():getSoldierTemplate():getHeroQuality(v.detailId)
                changeNewIconImage(cell.card,_temp,quality)
            elseif v.type == 102 then -- equpment
                _temp = getTemplateManager():getEquipTemplate():getEquipResIcon(v.detailId)
                local quality = getTemplateManager():getEquipTemplate():getQuality(v.detailId)
                changeEquipIconImageBottom(cell.card, _temp, quality)
            elseif v.type == 103 then -- hero chips
                _temp = self._chipTemp:getTemplateById(v.detailId).resId
                local _icon = self._resourceTemp:getResourceById(_temp)
                local _quality = self._chipTemp:getTemplateById(v.detailId).quality
                setChipWithFrame(cell.card,"res/icon/hero/".._icon, _quality)
            elseif v.type == 104 then -- equipment chips
                _temp = self._chipTemp:getTemplateById(v.detailId).resId
                local _icon = self._resourceTemp:getResourceById(_temp)
                local _quality = self._chipTemp:getTemplateById(v.detailId).quality
                setChipWithFrame(cell.card,"res/icon/equipment/".._icon, _quality)
            elseif v.type == 105 then  -- item
                _temp = getTemplateManager():getBagTemplate():getItemResIcon(v.detailId)
                local quality = getTemplateManager():getBagTemplate():getItemQualityById(v.detailId)
                setCardWithFrame(cell.card,"res/icon/item/".._temp,quality)
            elseif v.type == 107 then  -- item
                local _icon = self._resourceTemp:getResourceById(v.detailId)
                setItemImage(cell.card,"res/icon/resource/".._icon,1)
            end
        end
        -- sprite:setLocalZOrder(1)
        -- cell:addChild(sprite)
        -- sprite:setPosition(55, 55)
        return cell
    end

    local layerSize = self.contentLayer:getContentSize()
    self.contentLayer:removeAllChildren()

    self.dropTableView = cc.TableView:create(layerSize)    -- 剧情列表
    self.dropTableView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    self.dropTableView:setDelegate()
    self.dropTableView:setPosition(cc.p(0, 0))
    -- self.dropTableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.contentLayer:addChild(self.dropTableView)

    self.dropTableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.dropTableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.dropTableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)

    local scrBar = PVScrollBar:new()
    scrBar:init(self.dropTableView,1)
    scrBar:setPosition(cc.p(layerSize.width,layerSize.height/2))
    self.contentLayer:addChild(scrBar,2)
    
    self.dropTableView:reloadData()
end


return PVFinashView


















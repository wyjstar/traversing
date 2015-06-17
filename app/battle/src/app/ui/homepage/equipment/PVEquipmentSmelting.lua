--装备熔炼

local PVEquipmentSmelting = class("PVEquipmentSmelting", BaseUIView)

function PVEquipmentSmelting:ctor(id)
    PVEquipmentSmelting.super.ctor(self, id)
    
    self.ccbiNode = {}
    self.itemsA = {}
    self.gains = {}
end

function PVEquipmentSmelting:onMVCEnter()

    self:initTouchListener()
    self:loadCCBI("equip/ui_equipment_smelting.ccbi", self.ccbiNode)
    self:initView()

    self:createListViewA()
    self:createListViewB()
end 

function PVEquipmentSmelting:initView()

    -- 获取控件
    self.ccbiRootNode = self.ccbiNode["UIEquipmentSmelting"]
    self.listLayerA = self.ccbiRootNode["listLayerA"]
    self.listLayerB = self.ccbiRootNode["listLayerB"]

    --获取list item的大小
    local tempTabA = {}
    local proxyA = cc.CCBProxy:create()
    CCBReaderLoad("equip/ui_equipment_smelt_itemA.ccbi", proxyA, tempTabA)
    local nodeA = tempTabA["UIEquipmentSmeltItemA"]["laycolor_bg"]
    self.itemSizeA = nodeA:getContentSize()

    local tempTabB = {}
    local proxyB = cc.CCBProxy:create()
    CCBReaderLoad("equip/ui_equipment_smelt_itemB.ccbi", proxyB, tempTabB)
    local nodeB = tempTabB["UIEquipmentSmeltItemB"]["laycolor_bg"]
    self.itemSizeB = nodeB:getContentSize()

    assert(self.funcTable, "PVEquipmentAttribute's funcTable must not be nil !")
    self.equipList = self.funcTable[1]  -- 被熔炼的装备  -- id list
    self.gainList = self.funcTable[2]   -- 熔炼后产生的物品
    
    -- print("++++++++++++++++++++++++++++++++++")
    -- print("列出 将要 被溶解项目")
    -- table.print(self.equipList)
    -- print("列出 产生物品")
    -- table.print(self.gainList)

    --计算各种卡的数目
    local greenSum = 0
    local blueSum = 0
    local purperSum = 0

    local equipTemp = getTemplateManager():getEquipTemplate()
    for i,v in ipairs(self.equipList) do
        local _itemData = getDataManager():getEquipmentData():getEquipById(v)
        
        table.print(_itemData)

        if _itemData == nil then
            break
        end
        
        local _equipTemplateData = equipTemp:getTemplateById(_itemData.no)
        local _quality = _equipTemplateData.quality  -- 品阶
        --统计卡牌类型
        if _quality == 1 or _quality == 2 then greenSum = greenSum+ 1
        elseif _quality == 3 or _quality == 4 then blueSum = blueSum + 1 
        elseif _quality == 5 or _quality == 6 then purperSum = purperSum + 1
        end
    end
    --统计产物种类加入
    if greenSum ~= 0 then table.insert(self.itemsA, {2, greenSum}) end
    if blueSum ~= 0 then table.insert(self.itemsA, {3, blueSum}) end
    if purperSum ~= 0 then table.insert(self.itemsA, {4, purperSum}) end

    local finances = self.gainList.finance.finance_changes
    self.gains["coin"] = self.gainList.finance.coin
    self.gains["gold"] = self.gainList.finance.gold
    self.gains["equip_soul"] = finances[1].item_num
    -- self.gains["hero_soul"] = self.gainList.finance.hero_soul
    -- self.gains["junior_stone"] = self.gainList.finance.junior_stone
    -- self.gains["middle_stone"] = self.gainList.finance.middle_stone
    -- self.gains["high_stone"] = self.gainList.finance.high_stone
    print("@@")
    table.print(self.gains)
    print("@@")
    for k,v in pairs(self.gains) do
        print(k, v)
        if v == 0 then self.gains[k]=nil end
    end

end

--控件事件绑定
function PVEquipmentSmelting:initTouchListener()
    local function onMenuClickOk()
        getAudioManager():playEffectButton2()
        print("------ click OK")
        self:onHideView()
        
        groupCallBack(GuideGroupKey.BTN_WUHUN)
    end
    self.ccbiNode["UIEquipmentSmelting"] = {}
    self.ccbiNode["UIEquipmentSmelting"]["MenuClickOk"] = onMenuClickOk
end

--创建熔炼列表
function PVEquipmentSmelting:createListViewA()

    local function numberOfCellsInTableView(tab)
        return #self.itemsA
    end

    local function cellSizeForTable(tbl, idx)
        return self.itemSizeA.height, self.itemSizeA.width
    end

    local function tableCellAtIndex(tbl, idx)
        local cell = tbl:dequeueCell()
        if nil == cell then
            cell = cc.TableViewCell:new()
        end    

        local cardinfo = {}
        local proxy = cc.CCBProxy:create()
        local node = CCBReaderLoad("equip/ui_equipment_smelt_itemA.ccbi", proxy, cardinfo)
        cell:addChild(node)

        --获取ccbi上的控件
        local labelCardColor = cardinfo["UIEquipmentSmeltItemA"]["colorLabel"]
        local labelCardNum = cardinfo["UIEquipmentSmeltItemA"]["outNum"]

        local _itemData = self.itemsA[idx+1]
        labelCardColor:setString( getTemplateManager():getBaseTemplate():getColorByNo(_itemData[1]) )  -- 品质
        labelCardNum:setString(string.format(_itemData[2]))           -- 个数

        return cell
    end

    local layerSize = self.listLayerA:getContentSize()
    self.tableViewA = cc.TableView:create(layerSize)
    self.tableViewA:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.tableViewA:setDelegate()
    self.tableViewA:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.listLayerA:addChild(self.tableViewA)

    self.tableViewA:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.tableViewA:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableViewA:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)

    local scrBar = PVScrollBar:new()
    scrBar:init(self.tableViewA,1)
    scrBar:setPosition(cc.p(layerSize.width,layerSize.height/2))
    self.listLayerA:addChild(scrBar,2)

    self.tableViewA:reloadData()

end

--创建获得物品列表
function PVEquipmentSmelting:createListViewB()  

    local function numberOfCellsInTableView(tab)
       return table.nums(self.gains)
    end

    local function cellSizeForTable(tbl, idx)
        return self.itemSizeB.height, self.itemSizeB.width
    end

    local function tableCellAtIndex(tbl, idx)
        local cell = tbl:dequeueCell()
        if nil == cell then
            cell = cc.TableViewCell:new()
        end    
        local cardinfo = {}
        local proxy = cc.CCBProxy:create()
        local node = CCBReaderLoad("equip/ui_equipment_smelt_itemB.ccbi", proxy, cardinfo)
        cell:addChild(node)

        --获取ccbi上的控件
        local iconType = cardinfo["UIEquipmentSmeltItemB"]["outStoneType"]
        local labelNum = cardinfo["UIEquipmentSmeltItemB"]["outNum"]

        local _itemKey = table.getKeyByIndex(self.gains, idx+1)
        local _itemValue = table.getValueByIndex(self.gains, idx+1)
        --iconType:set.. -- to do 根据类型改变图片
        if _itemKey == "coin" then iconType:setSpriteFrame("ui_common_ings.png")
        elseif _itemKey == "gold" then iconType:setSpriteFrame("ui_common_ingg.png")
        elseif _itemKey == "equip_soul" then iconType:setSpriteFrame("ui_rongLian.png")
        -- elseif _itemKey == "junior_stone" then iconType:setSpriteFrame("ui_common_shitou_b.png") -- 百炼石
        -- elseif _itemKey == "middle_stone" then iconType:setSpriteFrame("ui_common_shitou.png") -- 精炼石
        -- elseif _itemKey == "high_stone" then iconType:setSpriteFrame("ui_common_shitou_g.png")  -- 千炼石
        end
        labelNum:setString(string.format(_itemValue))

        return cell
    end
    local layerSize = self.listLayerA:getContentSize()
    self.tableViewB = cc.TableView:create(layerSize)
    self.tableViewB:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.tableViewB:setDelegate()
    self.tableViewB:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.listLayerB:addChild(self.tableViewB)

    self.tableViewB:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.tableViewB:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableViewB:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)

    local scrBar = PVScrollBar:new()
    scrBar:init(self.tableViewB,1)
    scrBar:setPosition(cc.p(layerSize.width,layerSize.height/2))
    self.listLayerB:addChild(scrBar,2)
    
    self.tableViewB:reloadData()

end


--@return 
return PVEquipmentSmelting

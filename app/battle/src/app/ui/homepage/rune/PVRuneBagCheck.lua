local CustomScrollView = import("....util.CustomScrollView")
local PVRuneItem = import(".PVRuneItem")
local PVRuneBagCheck = class("PVRuneBagCheck", BaseUIView)

function PVRuneBagCheck:ctor(id)
    self.super.ctor(self, id)
end

function PVRuneBagCheck:onMVCEnter()
    self.c_runeData = getDataManager():getRuneData()

    self.c_StoneTemplate = getTemplateManager():getStoneTemplate()
    self.c_LanguageTemplate = getTemplateManager():getLanguageTemplate()
    self.c_ResourceTemplate = getTemplateManager():getResourceTemplate()

    self.c_runeNet = getNetManager():getRuneNet()

    self:initData()
    self:initView()
end

function PVRuneBagCheck:initData()
    --符文背包上限
    self.bagMaxCount = getTemplateManager():getBaseTemplate():getRuneBagMaxCount()

    self.runeList = self.c_runeData:getBagRunes()

    self.soldierRunes = {}
    --1 生命 2 攻击 3 物防  4 法防
    self.soldierRunes[1] = {}
    self.soldierRunes[2] = {}
    self.soldierRunes[3] = {}
    self.soldierRunes[4] = {}

    for k, v in pairs(self.runeList) do
        local runeData = self.c_StoneTemplate:getStoneItemById(v.runt_id)
        local runeItem = {}
        local runeType = runeData.type
        local runeQuality = runeData.quality
        local runeIcon = self.c_ResourceTemplate:getResourceById(runeData.res)
        local runeName = self.c_LanguageTemplate:getLanguageById(runeData.name)
        runeItem.runt_no = v.runt_no
        runeItem.runt_id = v.runt_id
        runeItem.runeType = runeType
        runeItem.quality = runeQuality
        runeItem.isSelect = false
        runeItem.main_attr = v.main_attr
        runeItem.minor_attr = v.minor_attr
        runeItem.enabled = false
        runeItem.rune_icon = runeIcon
        runeItem.rune_name = runeName

        table.insert(self.soldierRunes[runeType], runeItem)
    end

    self.curRuneList = self.soldierRunes[1]

end

function PVRuneBagCheck:initIsSelect(runeId)
    for k, v in pairs(self.soldierRunes) do
        for m, n in pairs(v) do
            if n.runt_id == runeId then
                n.isSelect = true
            end
        end
    end
end

function PVRuneBagCheck:initView()
    self.UIRuneBagCheckPanel = {}
    self:initTouchListener()
    self:loadCCBI("rune/ui_rune_bagcheck.ccbi", self.UIRuneBagCheckPanel)
    self.UIRuneBagCheckPanel["UIRuneBagCheckPanel"]["rune_attr"]:setVisible(false)

    self.contentLayer = self.UIRuneBagCheckPanel["UIRuneBagCheckPanel"]["contentLayer"]
    self.runeNum = self.UIRuneBagCheckPanel["UIRuneBagCheckPanel"]["runeNum"]
    self.bagNum = self.UIRuneBagCheckPanel["UIRuneBagCheckPanel"]["bagNum"]

    self.tabNormalImage = {}
    self.tabSelectImage = {}

    self.tabSelectImage[1] = self.UIRuneBagCheckPanel["UIRuneBagCheckPanel"]["lifeSelect"]
    self.tabNormalImage[1] = self.UIRuneBagCheckPanel["UIRuneBagCheckPanel"]["lifeNor"]

    self.tabSelectImage[2] = self.UIRuneBagCheckPanel["UIRuneBagCheckPanel"]["attackSelect"]
    self.tabNormalImage[2] = self.UIRuneBagCheckPanel["UIRuneBagCheckPanel"]["attackNor"]

    self.tabSelectImage[3] = self.UIRuneBagCheckPanel["UIRuneBagCheckPanel"]["phySelect"]
    self.tabNormalImage[3] = self.UIRuneBagCheckPanel["UIRuneBagCheckPanel"]["phyNor"]

    self.tabSelectImage[4] = self.UIRuneBagCheckPanel["UIRuneBagCheckPanel"]["magicSelect"]
    self.tabNormalImage[4] = self.UIRuneBagCheckPanel["UIRuneBagCheckPanel"]["magicNor"]

    self.tabMenu = {}                                       --tab标签按钮

    self.menuLife = self.UIRuneBagCheckPanel["UIRuneBagCheckPanel"]["menuLife"]
    self.menuAttack = self.UIRuneBagCheckPanel["UIRuneBagCheckPanel"]["menuAttack"]
    self.menuPhy = self.UIRuneBagCheckPanel["UIRuneBagCheckPanel"]["menuPhy"]
    self.menuMagic = self.UIRuneBagCheckPanel["UIRuneBagCheckPanel"]["menuMagic"]

    table.insert(self.tabMenu, self.menuLife)
    table.insert(self.tabMenu, self.menuAttack)
    table.insert(self.tabMenu, self.menuPhy)
    table.insert(self.tabMenu, self.menuMagic)
    --menu标签页没有缩放效果
    for k,v in pairs(self.tabMenu) do
        v:setAllowScale(false)
    end

    self.runeNum:setString(table.getn(self.runeList))
    self.bagNum:setString(self.bagMaxCount)

    --默认设置生命标签
    if self.tabIndex ~= nil then
        self:updateMenuByIndex(self.tabIndex)
        self:updateContent(self.tabIndex)
    else
        self:updateMenuByIndex(1)
        self:updateContent(1)
    end


    -- self:initTableView()
end

function PVRuneBagCheck:updateContent(index)
    if #self.curRuneList == 0 then return end

    local function mySort(item1, item2)
        return item1.quality > item2.quality
    end

    table.sort(self.curRuneList, mySort)

    -- if self.tableView ~= nil then
    --     self.tableView:reloadData()
    --     self:tableViewItemAction(self.tableView)
    -- end
    --初始化符文
    if self.scrollView then
        self.scrollView:clear()
    else 
        self.scrollView = CustomScrollView.new(self.UIRuneBagCheckPanel["UIRuneBagCheckPanel"]["contentLayer"], {columnspace=20})
        self.scrollView:setDelegate(self)
    end

    self.cells_ = {}
    for i =1 , #self.curRuneList do
        local item = PVRuneItem.new(self.curRuneList[i])
        self.scrollView:addCell(item)
        self.cells_[#self.cells_ + 1] = item
    end    
end

function PVRuneBagCheck:onClickScrollViewCell(cell)

    local data = cell:getData()

    self.scrollView:singalSelectedCell(cell)    

    self.UIRuneBagCheckPanel["UIRuneBagCheckPanel"]["rune_attr"]:setVisible(true)    
    self.UIRuneBagCheckPanel["UIRuneBagCheckPanel"]["minattr_layer"]:setVisible(false)
    local runeName = "["..data.rune_name.."]"    
    self.UIRuneBagCheckPanel["UIRuneBagCheckPanel"]["rune_name"]:setString(runeName)
    local mainAttr = data.main_attr[1]
    local attr_value = math.floor(mainAttr.attr_value * 10)/10
    local typeStr = self.c_StoneTemplate:getAttriStrByType(mainAttr.attr_type)
    local min, max = self.c_StoneTemplate:getMainValue(data.runt_id, mainAttr.attr_type)
    local mainAttriStr = typeStr.."+"..tostring(attr_value).." (" .. min .. "~" .. max .. ")"
    self.UIRuneBagCheckPanel["UIRuneBagCheckPanel"]["mainattr"]:setString(mainAttriStr)

    local minorAttribute = data.minor_attr
    if #minorAttribute > 0 then
        self.UIRuneBagCheckPanel["UIRuneBagCheckPanel"]["minattr_layer"]:setVisible(true)      
        for i = 1, 4 do
            self.UIRuneBagCheckPanel["UIRuneBagCheckPanel"]["minattr_v"..i]:setVisible(false)
            if i <= #minorAttribute then
                local attr = minorAttribute[i]
                local attr_value = math.floor(attr.attr_value * 10)/10
                local typeStr = self.c_StoneTemplate:getAttriStrByType(attr.attr_type)
                local min, max = self.c_StoneTemplate:getMintorValue(data.runt_id, attr.attr_type)
                local _attriStr = typeStr .. "+"..tostring(attr_value)
                if min ~= nil and max ~= nil then
                    _attriStr = _attriStr.." (" .. min .. "~" .. max .. ")"                    
                end
                local color = self.c_StoneTemplate:getColorByQuality(data.quality)
                self.UIRuneBagCheckPanel["UIRuneBagCheckPanel"]["minattr_v"..i]:setColor(color)
                self.UIRuneBagCheckPanel["UIRuneBagCheckPanel"]["minattr_v"..i]:setString(_attriStr)
                self.UIRuneBagCheckPanel["UIRuneBagCheckPanel"]["minattr_v"..i]:setVisible(true)                 
            end           
        end         
    end
end

function PVRuneBagCheck:updateMenuByIndex(index)
    local menuCount = table.getn(self.tabNormalImage)
    for  i = 1, menuCount do
        if i == index then
            self.tabNormalImage[i]:setVisible(false)
            self.tabSelectImage[i]:setVisible(true)
            self.tabMenu[i]:setEnabled(false)
        else
            self.tabNormalImage[i]:setVisible(true)
            self.tabSelectImage[i]:setVisible(false)
            self.tabMenu[i]:setEnabled(true)
        end
    end
end

function PVRuneBagCheck:initTouchListener()
    --关闭
    local function onCloseClick()
        getAudioManager():playEffectButton2()
        typeIndex = nil
        curRuneId = nil
        self:onHideView()
    end

    --生命
    local function menuLifeClick()
        getAudioManager():playEffectButton2()
        self.curRuneList = self.soldierRunes[1]
        self:updateMenuByIndex(1)
        self:updateContent(1)
    end

    --攻击
    local function menuAttackClick()
        getAudioManager():playEffectButton2()
        self.curRuneList = self.soldierRunes[2]
        self:updateMenuByIndex(2)
        self:updateContent(2)
    end

    --物防
    local function menuPhyClick()
        getAudioManager():playEffectButton2()
        self.curRuneList = self.soldierRunes[3]
        self:updateMenuByIndex(3)
        self:updateContent(3)
    end

    --法防
    local function menuMagicClick()
        getAudioManager():playEffectButton2()
        self.curRuneList = self.soldierRunes[4]
        self:updateMenuByIndex(4)
        self:updateContent(4)
    end

    --获取符文
    local function onReceiveClick()
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVSecretPlacePanel")
    end

    --符文炼化
    local function onSmeltRuneClick()
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVSmeltView", 3)
        -- getModule(MODULE_NAME_HOMEPAGE):showUIView("PVSmeltPanel")
    end

    self.UIRuneBagCheckPanel["UIRuneBagCheckPanel"] = {}

    self.UIRuneBagCheckPanel["UIRuneBagCheckPanel"]["onCloseClick"] = onCloseClick
    self.UIRuneBagCheckPanel["UIRuneBagCheckPanel"]["menuLifeClick"] = menuLifeClick
    self.UIRuneBagCheckPanel["UIRuneBagCheckPanel"]["menuAttackClick"] = menuAttackClick
    self.UIRuneBagCheckPanel["UIRuneBagCheckPanel"]["menuPhyClick"] = menuPhyClick
    self.UIRuneBagCheckPanel["UIRuneBagCheckPanel"]["menuMagicClick"] = menuMagicClick

    self.UIRuneBagCheckPanel["UIRuneBagCheckPanel"]["onReceiveClick"] = onReceiveClick
    self.UIRuneBagCheckPanel["UIRuneBagCheckPanel"]["onSmeltRuneClick"] = onSmeltRuneClick
end

function PVRuneBagCheck:initTableView()
    local layerSize = self.contentLayer:getContentSize()
    self.tableView = cc.TableView:create(cc.size(layerSize.width, layerSize.height))

    self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.tableView:setPosition(cc.p(0, 0))
    self.tableView:setDelegate()
    self.contentLayer:addChild(self.tableView)

    self.tableView:registerScriptHandler(function(table) return self:numberOfCellsInTableView(table) end, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.tableView:registerScriptHandler(function(table, cell) self:tableCellTouched(table, cell) end, cc.TABLECELL_TOUCHED)
    self.tableView:registerScriptHandler(function(table, idx) return self:cellSizeForTable(table, idx) end, cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView:registerScriptHandler(function(table, idx) return self:tableCellAtIndex(table, idx) end, cc.TABLECELL_SIZE_AT_INDEX)

    local scrBar = PVScrollBar:new()
    scrBar:init(self.tableView,1)
    scrBar:setPosition(cc.p(layerSize.width,layerSize.height/2))
    self.contentLayer:addChild(scrBar,2)
    
    self.tableView:reloadData()
    self:tableViewItemAction(self.tableView)

end

function PVRuneBagCheck:tableCellTouched(table, cell)
end

function PVRuneBagCheck:cellSizeForTable(table, idx)
    return 140, 550
end

function PVRuneBagCheck:tableCellAtIndex(tbl, idx)
    local cell = tbl:cellAtIndex(idx)

        if nil == cell then
            cell = cc.TableViewCell:new()

            local function onSelectClick()
                getAudioManager():playEffectButton2()
                cell.itemSelect:setVisible(false)
                local index = cell:getIdx()
                local curSelectItem = self.curRuneList[index + 1]

                local str = Localize.query("rune.1")
                if self.selectItemCount >= self.maxCount and cell.chooseSprite:isVisible() == false then
                    -- getOtherModule():showToastView(string.format(str, self.maxCount))
                    getOtherModule():showAlertDialog(nil, string.format(str, self.maxCount))

                else
                    if not (cell.chooseSprite:isVisible()) then
                        cell.chooseSprite:setVisible(true)
                        self.selectItemCount = self.selectItemCount + 1
                        if self.addRunePos == nil then
                            self.curRuneList[index + 1].isSelect = true
                            table.insert(self.selectRunes, self.curRuneList[idx + 1])
                        else
                            self.curRuneList[index + 1].isSelect = true
                            -- self.addRuneId = self.curRuneList[index + 1].id
                            -- self.addRuneNo = self.curRuneList[index + 1].no
                            self.curRuneItem = self.curRuneList[index + 1]
                        end
                    else
                        cell.chooseSprite:setVisible(false)
                        self.selectItemCount = self.selectItemCount - 1
                        if self.addRunePos == nil then
                            self.curRuneList[index + 1].isSelect = false

                            local id = self.curRuneList[index + 1].runt_id
                            for k,v in pairs(self.selectRunes) do
                                if v.runt_id == id then
                                    table.remove(self.selectRunes, k)
                                end
                            end
                        else
                            -- self.addRuneId = nil
                            -- self.addRuneNo = nil
                            self.curRuneItem = nil
                        end
                    end
                end
            end

            local function onItemClick()
                print("onItemClick .........PVRuneBagCheck ")
                local curRuneItem = self.curRuneList[cell:getIdx() + 1]
                getOtherModule():showOtherView("PVRuneLook", curRuneItem, 3)
            end

            cell.UIRuneBagItem = {}
            cell.UIRuneBagItem["UIRuneBagItem"] = {}

            cell.UIRuneBagItem["UIRuneBagItem"]["onSelectClick"] = onSelectClick
            cell.UIRuneBagItem["UIRuneBagItem"]["onItemClick"] = onItemClick

            local runeBagItemProxy = cc.CCBProxy:create()
            local runeBagItem = CCBReaderLoad("rune/ui_rune_bagItem.ccbi", runeBagItemProxy, cell.UIRuneBagItem)

            cell.runeNum = cell.UIRuneBagItem["UIRuneBagItem"]["runeNum"]
            cell.runeName = cell.UIRuneBagItem["UIRuneBagItem"]["runeName"]
            cell.desLabel = cell.UIRuneBagItem["UIRuneBagItem"]["desLabel"]
            cell.desLayer = cell.UIRuneBagItem["UIRuneBagItem"]["desLayer"]
            cell.headIcon = cell.UIRuneBagItem["UIRuneBagItem"]["headIcon"]
            cell.chooseSprite = cell.UIRuneBagItem["UIRuneBagItem"]["chooseSprite"]
            cell.selectMenuItem = cell.UIRuneBagItem["UIRuneBagItem"]["selectMenuItem"]
            cell.itemSelect = cell.UIRuneBagItem["UIRuneBagItem"]["itemSelect"]
            cell.chooseLayer = cell.UIRuneBagItem["UIRuneBagItem"]["chooseLayer"]

            cell.chooseLayer:setVisible(false)

            cell:addChild(runeBagItem)

            if table.nums(self.curRuneList) > 0 then
                -- cell.runeNum:setString(self.curRuneList[idx + 1].num)
                --符文名称
                local nameId = self.c_StoneTemplate:getStoneItemById(self.curRuneList[idx + 1].runt_id).name
                local nameStr = self.c_LanguageTemplate:getLanguageById(nameId)
                cell.runeName:setString(nameStr)
                --符文icon
                local resId = self.c_StoneTemplate:getStoneItemById(self.curRuneList[idx + 1].runt_id).res
                local resIcon = self.c_ResourceTemplate:getResourceById(resId)
                local quality = self.c_StoneTemplate:getStoneItemById(self.curRuneList[idx + 1].runt_id).quality
                local icon = "res/icon/rune/" .. resIcon
                self.c_runeData:setItemImage(cell.headIcon, icon, quality)
                --符文属性
                local mainAttribute = self.curRuneList[idx + 1].main_attr
                local minorAttribute = self.curRuneList[idx + 1].minor_attr

                for k, v in pairs(mainAttribute) do
                    local attr_type = v.attr_type
                    local attr_value = v.attr_value
                    attr_value = math.floor(attr_value * 10) / 10
                    local typeStr = self.c_StoneTemplate:getAttriStrByType(attr_type)
                    local mainAttriStr = typeStr .. "+" .. attr_value

                    local mainLabel = cc.LabelTTF:create("", MINI_BLACK_FONT_NAME, 19)
                    mainLabel:setAnchorPoint(cc.p(0, 0.5))

                    mainLabel:setColor(ui.COLOR_WHITE)
                    mainLabel:setString(mainAttriStr)

                    if table.getn(minorAttribute) == 0 then
                        mainLabel:setPosition(cc.p(5, 40))
                    else
                        mainLabel:setPosition(cc.p(5, 65))
                    end

                    cell.desLayer:addChild(mainLabel)
                end

                for k,v in pairs(minorAttribute) do
                    local label = cc.LabelTTF:create("", MINI_BLACK_FONT_NAME, 19)
                    label:setAnchorPoint(cc.p(0, 0.5))
                    local color = self.c_StoneTemplate:getColorByQuality(quality)
                    label:setColor(color)
                    local typeStr = self.c_StoneTemplate:getAttriStrByType(v.attr_type)
                    v.attr_value = math.floor(v.attr_value * 10) / 10
                    local attriStr = typeStr .. "+" .. v.attr_value
                    if k == 1 then
                        label:setPosition(cc.p(5, 40))
                    end
                    if k == 2 then
                        label:setPosition(cc.p(135, 40))
                    end
                    if k == 3 then
                        label:setPosition(cc.p(5, 16))
                    end
                    if k == 4 then
                        label:setPosition(cc.p(135, 16))
                    end

                    label:setString(attriStr)
                    cell.desLayer:addChild(label)
                end

                if self.curRuneList[idx + 1].isSelect then
                    cell.chooseSprite:setVisible(true)
                else
                    cell.chooseSprite:setVisible(false)
                end

                if self.curRuneId ~= nil and self.curRuneId == self.curRuneList[idx + 1].runt_id then
                    cell.itemSelect:setVisible(true)
                else
                    cell.itemSelect:setVisible(false)
                end
            end
        end

        return cell
end

function PVRuneBagCheck:numberOfCellsInTableView(tab)
   return table.getn(self.curRuneList)
end


return PVRuneBagCheck

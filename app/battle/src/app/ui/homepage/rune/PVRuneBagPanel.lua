
local PVRuneBagPanel = class("PVRuneBagPanel", BaseUIView)

function PVRuneBagPanel:ctor(id)
    self.super.ctor(self, id)
end

function PVRuneBagPanel:onMVCEnter()
    self.c_runeData = getDataManager():getRuneData()
    self.commonData = getDataManager():getCommonData()

    self.c_StoneTemplate = getTemplateManager():getStoneTemplate()
    self.c_LanguageTemplate = getTemplateManager():getLanguageTemplate()
    self.c_ResourceTemplate = getTemplateManager():getResourceTemplate()

    self.c_runeNet = getNetManager():getRuneNet()

    self:registerDataBack()

    self.typeIndex = self.funcTable[1]                             --typeIndex 1:从符文镶嵌界面跳转  2:从符文炼化界面跳转  3:查看界面 更换符文
    self.curRuneId = self.funcTable[2]                             --从符文炼化界面跳转 传递的id
    self.addRuneItem = clone(self.funcTable[3])                    --从符文镶嵌界面跳转 传递的镶嵌的位置
    self.curRuneNo = self.funcTable[4]
    self.addPreRuneItem = self.c_runeData:getPreRuneItem()
    if self.addRuneItem ~= nil then
        self.tabIndex = self.addRuneItem.runeType
    elseif self.curRuneId ~= nil and self.curRuneNo ~= nils then
        local curType = self.c_StoneTemplate:getStoneItemById(self.curRuneId).type
        self.tabIndex = curType
    end
    self:initData()
    self:initView()
end

function PVRuneBagPanel:registerDataBack()
    -- body
end

function PVRuneBagPanel:initData()
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
        local runeItem = {}
        -- print("PVRuneBagPanel  v.main_attr ================ ", v.main_attr)
        -- table.print(v.main_attr)
        -- print("PVRuneBagPanel  v.minor_attr ================ ", v.minor_attr)
        -- table.print(v.minor_attr)

        local runeType = self.c_StoneTemplate:getStoneItemById(v.runt_id).type
        local runeQuality = self.c_StoneTemplate:getStoneItemById(v.runt_id).quality

        runeItem.runt_no = v.runt_no
        runeItem.runt_id = v.runt_id
        runeItem.type = runeType
        runeItem.quality = runeQuality
        runeItem.isSelect = false
        runeItem.main_attr = v.main_attr
        runeItem.minor_attr = v.minor_attr
        -- runeItem.num = v.num

        table.insert(self.soldierRunes[runeType], runeItem)
    end

    if self.addRuneItem ~= nil then
        self.addRunePos = self.addRuneItem.runePos
    end

    --背包一次性选择最大数值初始化
    if self.typeIndex == 1 or self.typeIndex == 3 then
        self.maxCount = 1
    elseif self.typeIndex == 2 then
        self.maxCount = 8
    end

    self.lastRuneList = self.c_runeData:getSelectRunes()
    self.selectRunes = clone(self.lastRuneList)

    if self.selectRunes ~= nil then
        self.selectItemCount = table.getn(self.selectRunes)
        if table.getn(self.selectRunes) > 0 then
            for k,v in pairs(self.selectRunes) do
                self:initIsSelect(v.runt_no)
            end
        end
    end
    if self.tabIndex ~= nil then
        self.curRuneList = self.soldierRunes[self.tabIndex]
    else
        self.curRuneList = self.soldierRunes[1]
    end

    print("符文背包列表 ================== ")
    table.print(self.curRuneList)
end

function PVRuneBagPanel:initIsSelect(runeNo)
    for k, v in pairs(self.soldierRunes) do
        for m, n in pairs(v) do
            if n.runt_no == runeNo then
                n.isSelect = true
            end
        end
    end
end

function PVRuneBagPanel:initView()
    self.UIRuneBagPanel = {}
    self:initTouchListener()
    self:loadCCBI("rune/ui_rune_bag.ccbi", self.UIRuneBagPanel)

    self.contentLayer = self.UIRuneBagPanel["UIRuneBagPanel"]["contentLayer"]
    self.runeNum = self.UIRuneBagPanel["UIRuneBagPanel"]["runeNum"]
    self.bagNum = self.UIRuneBagPanel["UIRuneBagPanel"]["bagNum"]

    self.titleNameLianhua = self.UIRuneBagPanel["UIRuneBagPanel"]["titleNameLianhua"]
    self.titleNameLianhua2 = self.UIRuneBagPanel["UIRuneBagPanel"]["titleNameLianhua2"]
    if self.typeIndex == 2 then
        self.titleNameLianhua:setVisible(true)
        self.titleNameLianhua2:setVisible(false)
    else
        self.titleNameLianhua:setVisible(false)
        self.titleNameLianhua2:setVisible(true)
    end

    self.tabNormalImage = {}
    self.tabSelectImage = {}

    self.tabSelectImage[1] = self.UIRuneBagPanel["UIRuneBagPanel"]["lifeSelect"]
    self.tabNormalImage[1] = self.UIRuneBagPanel["UIRuneBagPanel"]["lifeNor"]

    self.tabSelectImage[2] = self.UIRuneBagPanel["UIRuneBagPanel"]["attackSelect"]
    self.tabNormalImage[2] = self.UIRuneBagPanel["UIRuneBagPanel"]["attackNor"]

    self.tabSelectImage[3] = self.UIRuneBagPanel["UIRuneBagPanel"]["phySelect"]
    self.tabNormalImage[3] = self.UIRuneBagPanel["UIRuneBagPanel"]["phyNor"]

    self.tabSelectImage[4] = self.UIRuneBagPanel["UIRuneBagPanel"]["magicSelect"]
    self.tabNormalImage[4] = self.UIRuneBagPanel["UIRuneBagPanel"]["magicNor"]

    self.tabMenu = {}                                       --tab标签按钮

    self.menuLife = self.UIRuneBagPanel["UIRuneBagPanel"]["menuLife"]
    self.menuAttack = self.UIRuneBagPanel["UIRuneBagPanel"]["menuAttack"]
    self.menuPhy = self.UIRuneBagPanel["UIRuneBagPanel"]["menuPhy"]
    self.menuMagic = self.UIRuneBagPanel["UIRuneBagPanel"]["menuMagic"]

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
    self:initTableView()
end

function PVRuneBagPanel:updateContent(index)
    local function mySort(item1, item2)
        return item1.quality > item2.quality
    end

    table.sort(self.curRuneList, mySort)

    if self.tableView ~= nil then
        self.tableView:reloadData()
        self:tableViewItemAction(self.tableView)
    end
end

function PVRuneBagPanel:updateMenuByIndex(index)
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

function PVRuneBagPanel:initTouchListener()
    --关闭
    local function onCloseClick()
        getAudioManager():playEffectButton2()
        typeIndex = nil
        curRuneId = nil
        if self.typeIndex ~= 2 then
            self.c_runeData:setSelectRunes(nil)
        end
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

    --确定
    local function onSureClick()
        getAudioManager():playEffectButton2()
        if self.addRunePos ~= nil then
            self.c_runeData:setCurRuneItem(self.curRuneItem)
            table.print(self.curRuneItem)
            local curRuneType = self.addRuneItem.runeType
            local curSoldierId = self.c_runeData:getCurSoliderId()
            if self.curRuneItem ~= nil then
                print("123123123123")
                self.c_runeNet:sendAddRune(curSoldierId, curRuneType, self.addRunePos, self.curRuneItem.runt_no)
            end

            if self.typeIndex == 3 then

                local haveCoin = getDataManager():getCommonData():getCoin()
                local pickPrice = self.c_StoneTemplate:getPickPriceById(self.addPreRuneItem.runtId)
                local curSoldierId = self.c_runeData:getCurSoliderId()

                if haveCoin > pickPrice then
                    self.c_runeNet:sendDeleRune(curSoldierId, self.addPreRuneItem.runeType, self.addPreRuneItem.runePos)
                end
                local changeItem = {}
                changeItem.deleteType = 3
                changeItem.curRuneType = self.addPreRuneItem.runeType
                changeItem.runt_no = self.curRuneItem.runt_no
                changeItem.addRunePos = self.addRunePos
                table.print(changeItem)
                self.c_runeData:setChangeRune(changeItem)
            end

        else
            print("炼化使用 ============= ", table.getn(self.selectRunes))
            table.print(self.selectRunes)
            -- print("最终的列表 ============ ", table.getn(self.lastRuneList))
            -- table.print(self.lastRuneList)
            --炼化使用
            self.c_runeData:setSelectRunes(self.selectRunes)
        end

        typeIndex = nil
        curRuneId = nil

        -- stepCallBack(G_GUIDE_50113)
        -- stepCallBack(G_GUIDE_50117)
        -- stepCallBack(G_GUIDE_50121)
        if self.curRuneItem ~= nil then
            groupCallBack(GuideGroupKey.BTN_FUWEN_CONFIRM, curSoldierId, self.curRuneItem.runt_no)
        end

        self:onHideView()
    end

    self.UIRuneBagPanel["UIRuneBagPanel"] = {}

    self.UIRuneBagPanel["UIRuneBagPanel"]["onCloseClick"] = onCloseClick
    self.UIRuneBagPanel["UIRuneBagPanel"]["menuLifeClick"] = menuLifeClick
    self.UIRuneBagPanel["UIRuneBagPanel"]["menuAttackClick"] = menuAttackClick
    self.UIRuneBagPanel["UIRuneBagPanel"]["menuPhyClick"] = menuPhyClick
    self.UIRuneBagPanel["UIRuneBagPanel"]["menuMagicClick"] = menuMagicClick
    self.UIRuneBagPanel["UIRuneBagPanel"]["onSureClick"] = onSureClick
end

function PVRuneBagPanel:initTableView()
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


    if self.curRuneId ~= nil and self.curRuneNo ~= nil then
        local showIndex = 0
        local totalCount = table.getn(self.curRuneList)
        print("totalCount =========== totalCount ===== ", totalCount)
        if totalCount > 3 then
            local _offSet = self.tableView:getContentOffset()
            for k,v in pairs(self.curRuneList) do
                if self.curRuneNo == v.runt_no then
                    showIndex = k
                end
            end
            print("showIndex -=============- ", showIndex)
            local tag = showIndex - totalCount + 2
            print("tag ============= ", tag)
            if tag <= 0 and showIndex ~= 1 then
                _offSet.y = (showIndex - totalCount + 2) * 140
            elseif tag == 1 then
                _offSet.y = 0
            end

            if showIndex == totalCount then
                _offSet.y = 0
            end

            self.tableView:setContentOffset(cc.p(_offSet.x, (_offSet.y)))
        end
    end
end

function PVRuneBagPanel:tableCellTouched(table, cell)
end

function PVRuneBagPanel:cellSizeForTable(table, idx)
    return 140, 550
end

function PVRuneBagPanel:tableCellAtIndex(tbl, idx)
    local cell = tbl:cellAtIndex(idx)

        if nil == cell then
            cell = cc.TableViewCell:new()

            local function onSelectClick()
                getAudioManager():playEffectButton2()


                -- stepCallBack(G_GUIDE_50112)                --50028  点击勾选框
                -- stepCallBack(G_GUIDE_50116)
                -- stepCallBack(G_GUIDE_50120)

                groupCallBack(GuideGroupKey.BTN_FUWEN_CHECKBOX)

                cell.itemSelect:setVisible(false)
                local index = cell:getIdx()
                local curSelectItem = self.curRuneList[index + 1]

                local str = Localize.query("rune.1")
                if self.selectItemCount >= self.maxCount and cell.chooseSprite:isVisible() == false then
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
                            self.curRuneItem = self.curRuneList[index + 1]
                        end
                    else
                        cell.chooseSprite:setVisible(false)
                        self.selectItemCount = self.selectItemCount - 1
                        if self.addRunePos == nil then
                            self.curRuneList[index + 1].isSelect = false
                            local no = self.curRuneList[index + 1].runt_no
                            for k,v in pairs(self.selectRunes) do
                                if v.runt_no == no then
                                    table.remove(self.selectRunes, k)
                                end
                            end
                        else
                            self.curRuneItem = nil
                        end
                    end
                end
            end

            local function onItemClick()
                print("onItemClick .........")
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
            if self.typeIndex == 2 then
                cell.chooseSprite = cell.UIRuneBagItem["UIRuneBagItem"]["chooseSprite2"]
            end
            cell.selectMenuItem = cell.UIRuneBagItem["UIRuneBagItem"]["selectMenuItem"]
            cell.itemSelect = cell.UIRuneBagItem["UIRuneBagItem"]["itemSelect"]
            cell.yunLabel = cell.UIRuneBagItem["UIRuneBagItem"]["coin_value"]
            cell.jinLabel = cell.UIRuneBagItem["UIRuneBagItem"]["equip_value"]

            cell.lianhuaNode = cell.UIRuneBagItem["UIRuneBagItem"]["lianhuaNode"]
            cell.runNode = cell.UIRuneBagItem["UIRuneBagItem"]["runNode"]

            if self.typeIndex == 2 then
                cell.lianhuaNode:setVisible(true)
                cell.runNode:setVisible(false)
            else
                cell.lianhuaNode:setVisible(false)
                cell.runNode:setVisible(true)
            end
            cell:addChild(runeBagItem)

            if table.nums(self.curRuneList) > 0 then
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
                --熔炼获得原石数量
                local ston1Num = self.c_StoneTemplate:getStone1ById(self.curRuneList[idx + 1].runt_id)
                --熔炼获得晶石数量
                local ston2Num = self.c_StoneTemplate:getStone2ById(self.curRuneList[idx + 1].runt_id)

                cell.yunLabel:setString(ston1Num)
                cell.jinLabel:setString(ston2Num)

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

                if self.curRuneNo ~= nil and self.curRuneNo == self.curRuneList[idx + 1].runt_no then
                    cell.itemSelect:setVisible(true)
                else
                    cell.itemSelect:setVisible(false)
                end

                if self.curRuneList[idx + 1].isSelect then
                    cell.chooseSprite:setVisible(true)
                else
                    cell.chooseSprite:setVisible(false)
                end
            end
        end

        return cell
end

function PVRuneBagPanel:numberOfCellsInTableView(tab)
   return table.getn(self.curRuneList)
end

function PVRuneBagPanel:clearResource()
end
return PVRuneBagPanel

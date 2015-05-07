local PVScrollBar = import("..scrollbar.PVScrollBar")
local PVGeneralList = class("PVGeneralList", BaseUIView)

function PVGeneralList:ctor(id)
    PVGeneralList.super.ctor(self, id)
end

function PVGeneralList:onMVCEnter()
    self:showAttributeView()
    -- self.soldierData = getDataManager():getSoldierData():getSoldierData()
    self.soldierData = getDataManager():getLineupData():getChangeCheerSoldier()
    self.SoldierTemplate = getTemplateManager():getSoldierTemplate()
    self.c_SoldierData = getDataManager():getSoldierData()
    self.languageTemplate = getTemplateManager():getLanguageTemplate()
    self.chipTemp = getTemplateManager():getChipTemplate()
    self.c_Calculation = getCalculationManager():getCalculation()
    self.chipListDate = self.c_SoldierData:getPatchData()


    self.UIGeneralListView = {}
    self:initTouchListener()

    -- self:loadCCBI("soul/ui_generals_list.ccbi", self.UIGeneralListView)
    self:loadCCBI("soul/ui_generals_list_new.ccbi", self.UIGeneralListView)

    self:initView()
    -- self:initTableView()

    -- self:createChipListView()

    -- self:createChipListView()

    self:initData(self.funcTable[1], self.funcTable[2], self.funcTable[3], self.funcTable[4])

end

-- 降序
function compair_quality(item1, item2)

    if item1.hero.level == item2.hero.level then
        local quality1 = getTemplateManager():getSoldierTemplate():getHeroQuality(item1.hero.hero_no)
        local quality2 = getTemplateManager():getSoldierTemplate():getHeroQuality(item2.hero.hero_no)
        if quality1 == quality2 then
            return item1.power < item2.power
        end
        return quality1 < quality2
    end

    return item1.hero.level < item2.hero.level
end



function chip_compair_quality(item1, item2)

    local quality1 = getTemplateManager():getSoldierTemplate():getChipTempLateById(item1.hero.hero_chip_no).quality
    local quality2 = getTemplateManager():getSoldierTemplate():getChipTempLateById(item2.hero.hero_chip_no).quality
    return quality1 < quality2
end


function PVGeneralList:initView()

    self.soldierNormal = self.UIGeneralListView["UIGeneralView"]["soldierNormal"]
    self.soldierSelect = self.UIGeneralListView["UIGeneralView"]["soldierSelect"]
    self.spNormal = self.UIGeneralListView["UIGeneralView"]["spNormal"]
    self.spSelect = self.UIGeneralListView["UIGeneralView"]["spSelect"]
    self.oweSoul = self.UIGeneralListView["UIGeneralView"]["owe_soul"]
    self.oweSoul:setString(getDataManager():getCommonData():getFinance(3))

    self.contentLayer = self.UIGeneralListView["UIGeneralView"]["contentLayer"]
    self.totalSelectNums = 5
    self.totalSelect = {}
    self.generalItems = {}
    self.chipItems = {}

    -- for k, v in pairs(self.soldierData) do
    --     self.generalItems[k] = {}
    --     self.generalItems[k].hero = v
    --     self.generalItems[k].isSelect = false
    --     self.generalItems[k].id = k
    -- end

    for k, v in pairs(self.soldierData) do
        self.generalItems[k] = {}
        self.generalItems[k].hero = v
        self.generalItems[k].isSelect = false
        self.generalItems[k].id = k
        self.generalItems[k].type = 1
        local _power = self.c_Calculation:CombatPowerSoldierSelf(v)
        self.generalItems[k].power = _power
    end

    for k, v in pairs(self.chipListDate) do
        self.chipItems[k] = {}
        local tabTemp = {["hero_chip_no"] = tonumber(v.hero_chip_no),["hero_chip_num"] = tonumber(v.hero_chip_num)}
        self.chipItems[k].hero = tabTemp
        self.chipItems[k].isSelect = false
        self.chipItems[k].id = k
        self.chipItems[k].type = 2
    end

    -- print("－－－－－－－炼化选择－－self.generalItems－－－－－")
    -- table.print(self.generalItems)
    -- print("－－－－－－－炼化选择－－self.chipItems－－－－－")
    -- table.print(self.chipItems)
    self.itemCount = table.nums(self.generalItems)

    -- 武将列表排列顺序为等级>品质。
    -- 武将列表优先按照等级进行排序，当等级相同时按照品质进行排序
    table.sort(self.generalItems, compair_quality)
    table.sort(self.chipItems, chip_compair_quality)
    -- print("－－－－－－－炼化选择排序后－－self.chipItems－－－－－")
    -- table.print(self.chipItems)

    self.totalSelect = {}


    -- cclog("----hero's chip ===========")
    -- table.print(self.chipListDate)
    -- cclog("----hero's chip ===========")
end

function PVGeneralList:totalSelReloadData()

    local index = 1
    self.totalSelect = {}

    -- for k,v in pairs(self.generalItems) do
    --     if v.isSelect then
    --         self.totalSelect[index] = self.generalItems[k].hero
    --         index = index + 1
    --     end
    -- end

     for k,v in pairs(self.generalItems) do     --这里应该区分一下类型吧
        if v.isSelect then
            cclog("++++++++++++存入英雄列表被选中的元素++++++++++")
            table.print(self.generalItems[k])
            -- self.totalSelect[index]["hero"] = self.generalItems[k].hero
            -- self.totalSelect[index]["type"] = self.generalItems[k].type
            self.totalSelect[index] = {["hero"] = self.generalItems[k].hero,["type"] = self.generalItems[k].type}
            index = index + 1
        end
    end
    --存入碎片列表被选中的元素
    for k,v in pairs(self.chipItems) do
        if v.isSelect then
            cclog("++++++++++++存入碎片列表被选中的元素++++++++++")
            table.print(self.chipItems[k])
            -- self.totalSelect[index].hero = self.chipItems[k].hero
            -- self.totalSelect[index].type = self.chipItems[k].type
            self.totalSelect[index] = {["hero"] = self.chipItems[k].hero,["type"] = self.chipItems[k].type}
            index = index + 1
        end
    end

    -- cclog("===============总列表＝＝＝＝＝＝＝＝＝")
    -- table.print(self.totalSelect)
    -- cclog("===============总列表＝＝＝＝＝＝＝＝＝")

end

function PVGeneralList:_isExistsHero(item)
    for k, v in pairs(self.generalHead) do
        if v.hero ~= nil and v.type == 1 and item.type == 1 then
            if v.hero.hero_no == item.hero.hero_no then
                return true
            end
        elseif v.hero ~= nil and v.type == 2 and item.type == 2 then
            if v.hero.hero_chip_no == item.hero.hero_chip_no then
                return true
            end
        end

    end

    return false
end

function PVGeneralList:_saveHero(item)
    -- cclog("增加到列表里的")
    -- table.print(item)
    -- cclog("增加到列表里的")
    if self.generalHead[self.headNum] and not self.generalHead[self.headNum].isSelect then
        self.generalHead[self.headNum].isSelect = true
        self.generalHead[self.headNum].hero = item.hero
        self.generalHead[self.headNum].type = item.type
        return
    end

    for k, v in pairs(self.generalHead) do
        if self.generalHead[k] and not self.generalHead[k].isSelect then
            self.generalHead[k].isSelect = true
            self.generalHead[k].hero = item.hero
            self.generalHead[k].type = item.type
            return
        end

    end
end

function PVGeneralList:existsInTotalSelect(item)
    if item.hero == nil then return false end
    -- cclog("--------------existsInTotalSelect--------")
    -- table.print(item)
    -- cclog("--------------existsInTotalSelect--------")


    for k, v in pairs(self.totalSelect) do
        if item.type == 1 and v.type == 1 then
            if v.hero.hero_no == item.hero.hero_no then
                return true
            end
        elseif item.type == 2 and v.type == 2 then
            if v.hero.hero_chip_no == item.hero.hero_chip_no then
                return true
            end
        end
    end
    return false
end

function PVGeneralList:initTouchListener()
    local function onBackClick()
        getAudioManager():playEffectButton2()
        self:onHideGeneralList()
    end

    local function onSureClick()
        getAudioManager():playEffectButton2()

        self:totalSelReloadData()

        -- if table.nums(self.totalSelect) <=0 then

        --      getOtherModule():showOtherView("Toast", "至少选择一个献祭英雄")

        --     return
        -- end

        -- table.print(self.totalSelect)

        if  table.nums(self.totalSelect) <= 0 then
            for k, v in pairs(self.generalHead) do
                self.generalHead[k].isSelect = false
                self.generalHead[k].hero = nil
                self.generalHead[k].type = nil
            end
        else
            -- for k, v in pairs(self.totalSelect) do
            --     local ret = self:_isExistsHero(v)
            --     print(ret)
            --     if not ret then
            --         self:_saveHero(v)
            --     end
            -- end

             for k, v in pairs(self.generalHead) do
                --local ret = self:existsInTotalSelect(v.hero)
                local ret = self:existsInTotalSelect(v)
                if not ret then
                    self.generalHead[k].isSelect = false
                    self.generalHead[k].hero = nil
                    self.generalHead[k].type = nil
                end

            end

            for k, v in pairs(self.totalSelect) do
                local ret = self:_isExistsHero(v)
                -- cclog("hahahahahhahaahhaha")
                -- print(ret)
                -- cclog("hahahahahhahaahhaha")
                if not ret then
                    self:_saveHero(v)
                end
            end

        end

            -- cclog("点击确定按钮。。。。。。。")
            -- table.print(self.generalHead)
            -- cclog("点击确定按钮。。。。。。。")
            table.print(self.totalSelect)
            self:onHideGeneralList()
        -- else
        --     self:onHideGeneralList()
        --     --show dialog
        --     cclog("dialog  +++")
        -- end
    end

    local function onSoldierMenuClick()
        if self.tableView == nil then
            self:initTableView()
            -- self.tableView:reloadData()
            self:tableViewItemAction(self.tableView)
        else
            self.tableView:reloadData()
            self:tableViewItemAction(self.tableView)
        end
        if table.nums(self.soldierData) <=0 then
        -- getOtherModule():showToastView("没有英雄数据")
            getOtherModule():showAlertDialog(nil, Localize.query("PVGeneralList.1"))
        end
        self.soldierNormal:setVisible(false)
        self.soldierSelect:setVisible(true)
        self.spNormal:setVisible(true)
        self.spSelect:setVisible(false)
        self.tableView:setVisible(true)
        if self.tableViewChip ~= nil then
            self.tableViewChip:setVisible(false)
        end
    end

    local function onSpMenuClick()
        if self.tableViewChip == nil then
            self:createChipListView()
            -- self.tableViewChip:reloadData()
            self:tableViewItemAction(self.tableViewChip)
        else
            self.tableViewChip:reloadData()
            self:tableViewItemAction(self.tableViewChip)
        end
        if table.nums(self.chipListDate) <=0 then
        -- getOtherModule():showToastView("没有英雄碎片数据")
            getOtherModule():showAlertDialog(nil, Localize.query("PVGeneralList.2"))
        end
        self.soldierNormal:setVisible(true)
        self.soldierSelect:setVisible(false)
        self.spNormal:setVisible(false)
        self.spSelect:setVisible(true) 
        self.tableViewChip:setVisible(true)
        if self.tableView then
            self.tableView:setVisible(false)
        end
    end
    self.UIGeneralListView["UIGeneralView"] = {}

    self.UIGeneralListView["UIGeneralView"]["onBackClick"] = onBackClick
    self.UIGeneralListView["UIGeneralView"]["onSureClick"] = onSureClick
    self.UIGeneralListView["UIGeneralView"]["soldierMenuClick"] = onSoldierMenuClick
    self.UIGeneralListView["UIGeneralView"]["spMenuClick"] = onSpMenuClick
end

function PVGeneralList:initTableView()
    local layerSize = self.contentLayer:getContentSize()
    self.tableView = cc.TableView:create(cc.size(layerSize.width, layerSize.height))

    self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.tableView:setPosition(cc.p(0, 0))
    self.tableView:setDelegate()
    self.contentLayer:addChild(self.tableView)

    self.tableView:registerScriptHandler(function(table) return self:numberOfCellsInTableView(table) end, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.tableView:registerScriptHandler(self.scrollViewDidScroll, cc.SCROLLVIEW_SCRIPT_SCROLL)
    self.tableView:registerScriptHandler(self.scrollViewDidZoom, cc.SCROLLVIEW_SCRIPT_ZOOM)
    self.tableView:registerScriptHandler(function(table, cell) self:tableCellTouched(table, cell) end, cc.TABLECELL_TOUCHED)
    self.tableView:registerScriptHandler(function(table, idx) return self:cellSizeForTable(table, idx) end, cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView:registerScriptHandler(function(table, idx) return self:tableCellAtIndex(table, idx) end, cc.TABLECELL_SIZE_AT_INDEX)

    self.contentLayer:removeChildByTag(10001)
    local scrBar = PVScrollBar:new()
    scrBar:setTag(10001)
    scrBar:init(self.tableView,1)
    scrBar:setPosition(cc.p(layerSize.width,layerSize.height/2))
    self.contentLayer:addChild(scrBar,2)
    
    self.tableView:reloadData()
end

function PVGeneralList:scrollViewDidScroll(view)
end

function PVGeneralList:scrollViewDidZoom(view)
end

function PVGeneralList:tableCellTouched(table, cell)

end

function PVGeneralList:cellSizeForTable(table, idx)
    return CONFIG_GENERAL_CELL_HEIGHT, CONFIG_GENERAL_CELL_WIDTH
end

function PVGeneralList:tableCellAtIndex(tbl, idx)

    local cell = nil
    -- tbl:dequeueCell()

    if nil == cell then
        cell = cc.TableViewCell:new()

        local function onItemClick()
            cclog("onItemClick")
            local soldierItem = self.generalItems[cell:getIdx() + 1]
            -- table.print(soldierItem)
            getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSoldierMyLookDetail", soldierItem.hero.hero_no)
        end

        local function onSelectClick()
            getAudioManager():playEffectButton2()
            if 8 <= self.totalSelectNums and false == cell.star:isVisible() then

                -- getOtherModule():showToastView("每次最多选择5个")
                getOtherModule():showAlertDialog(nil, "每次最多选择8个")
                getOtherModule():showAlertDialog(nil, Localize.query("PVGeneralList.3"))

                return
            end

            local index = cell:getIdx()
            if (cell.star:isVisible()) then
                -- cclog("取消选择的是。。。。。。")
                -- table.print(self.generalItems[index + 1])
                -- cclog("取消选择的是。。。。。。")
                cell.star:setVisible(false)
                self.generalItems[index + 1].isSelect = false

                self.totalSelectNums = self.totalSelectNums - 1
            else
                -- cclog("选择的是。。。。。。")
                -- table.print(self.generalItems[index + 1])
                -- cclog("选择的是。。。。。。")
                cell.star:setVisible(true)
                self.generalItems[index + 1].isSelect = true
                self.totalSelectNums = self.totalSelectNums + 1
            end
        end


        cell.UIGeneralItem = {}
        cell.UIGeneralItem["UIGeneralItem2"] = {}

        cell.UIGeneralItem["UIGeneralItem2"]["onItemClick"] = onItemClick
        cell.UIGeneralItem["UIGeneralItem2"]["onSelectClick"] = onSelectClick

        local generaProxy = cc.CCBProxy:create()
        local generalItem = CCBReaderLoad("soul/ui_general_item_new2.ccbi", generaProxy, cell.UIGeneralItem)

        cell:addChild(generalItem)

        if table.nums(self.generalItems) > 0 then

            local strValue = string.format("%d", self.generalItems[idx + 1].hero.level)

            local starLayer = cell.UIGeneralItem["UIGeneralItem2"]["starLayer"]
            local headMenuItem = cell.UIGeneralItem["UIGeneralItem2"]["headMenuItem"]
            local generalMenu = cell.UIGeneralItem["UIGeneralItem2"]["generalMenu"]
            local selectMenuItem = cell.UIGeneralItem["UIGeneralItem2"]["selectMenuItem"]
            local generalName = cell.UIGeneralItem["UIGeneralItem2"]["generalName"]
            local generalLevel = cell.UIGeneralItem["UIGeneralItem2"]["lvBMLabel2"]
            local fightNum = cell.UIGeneralItem["UIGeneralItem2"]["fightNum"]
            local levelNum = cell.UIGeneralItem["UIGeneralItem2"]["levelNum"]
            local resNumLabel = cell.UIGeneralItem["UIGeneralItem2"]["equip_value"]

            local headIcon = cell.UIGeneralItem["UIGeneralItem2"]["headIcon"]
            local itemBg = cell.UIGeneralItem["UIGeneralItem2"]["itemBg"]

            cell.star = cell.UIGeneralItem["UIGeneralItem2"]["starSprite"]
            cell.selectMenu = cell.UIGeneralItem["UIGeneralItem2"]["selectMenu"]
            cell.itemMenuItem = cell.UIGeneralItem["UIGeneralItem2"]["itemMenuItem"]
            cell.itemMenuItem:setAllowScale(false)

            generalLevel:setString("等级" .. string.format(strValue))
            local atkValue = getCalculationManager():getCalculation():CombatPowerSoldierSelf(self.generalItems[idx + 1].hero) --战斗力
            fightNum:setString(roundAttriNum(atkValue))
            local break_level = self.generalItems[idx + 1].hero.break_level
            levelNum:setSpriteFrame(self:updateBreakLv(break_level))
            if break_level == 0 or break_level == nil then
                levelNum:setVisible(false)
            end

            local heroName = self.SoldierTemplate:getHeroName(self.generalItems[idx + 1].hero.hero_no)
            generalName:setString(heroName)

            -- 炼化得到的武魂的数量
            local resNum = self.SoldierTemplate:getSoulNum(self.generalItems[idx + 1].hero.hero_no)
            resNumLabel:setString(resNum)

            local quality = self.SoldierTemplate:getHeroQuality(self.generalItems[idx + 1].hero.hero_no)

            for i=1,quality do
                local star = string.format("starSelect%d", i)
                local starQuality = cell.UIGeneralItem["UIGeneralItem2"][star]
                starQuality:setVisible(true)
            end

            -- local resIcon = self.SoldierTemplate:getSoldierIcon(self.generalItems[idx + 1].hero.hero_no)
            -- changeNewIconImage(headIcon, resIcon, quality) --更新icon
            local resIcon = self.SoldierTemplate:getSoldierIcon(self.generalItems[idx + 1].hero.hero_no)
            changeNewSoldierIconImage(headIcon, resIcon, quality, itemBg)

            if self.generalItems[idx + 1].isSelect ==true then
                cell.star:setVisible(true)

            else
                cell.star:setVisible(false)
            end

        end
    end

    return cell
end

-- 突破级别
function PVGeneralList:updateBreakLv(level)
    local _img = "ui_lineup_number1.png"
    if level == 1 then
        _img = "ui_lineup_number1.png"
    elseif level == 2 then
        _img = "ui_lineup_number2.png"
    elseif level == 3 then
        _img = "ui_lineup_number3.png"
    elseif level == 4 then
        _img = "ui_lineup_number4.png"
    elseif level == 5 then
        _img = "ui_lineup_number5.png"
    elseif level == 6 then
        _img = "ui_lineup_number6.png"
    elseif level == 7 then
        _img = "ui_lineup_number7.png"
    elseif level == 8 then
        _img = "ui_lineup_number8.png"
    elseif level == 9 then
        _img = "ui_lineup_number9.png"
    end

    return _img
end

function PVGeneralList:numberOfCellsInTableView(table)
   return self.itemCount
end

function PVGeneralList:initData(index1, index2, index3)
    -- self.shieldlayer:setTouchEnabled(true)
    self.totalSelectNums = 0
    self.generalHead = index1
    self.totalSelect = {}
    cclog("-----------self.generalItems---------")
    table.print(self.generalItems)
    cclog("-----------self.generalItems---------")

    cclog("+++++++++++self.generalItems++++++++++")
    table.print(self.generalHead)
    cclog("+++++++++++self.generalItems++++++++++")

    self.headNum = index3
    local itemSelectedType = self.generalHead[self.headNum].type
    -- local temItem = {}
    -- for k,v in pairs(self.generalHead[self.headNum]) do
    --     temItem[k] = v
    -- end
    -- cclog("-----当前备份信息++++++++++++++++++++")
    -- table.print(temItem)

    -- self.generalHead[self.headNum].isSelect = false         --卸下当前座位的英雄
    -- self.generalHead[self.headNum].hero = nil
    -- self.generalHead[self.headNum].type = nil

    for k, v in pairs(self.generalItems) do
        for k1,v1 in pairs(self.generalHead) do
            if v1.hero ~=nil and v1.type ~= nil and v1.type == 1 and (v.hero.hero_no == v1.hero.hero_no) then
                v.isSelect = true
                self.totalSelectNums = self.totalSelectNums+1
            end
        end
    end

     for k, v in pairs(self.chipItems) do
        for k1,v1 in pairs(self.generalHead) do
            if v1.hero ~=nil and v1.type ~= nil and v1.type == 2 and (v.hero.hero_chip_no == v1.hero.hero_chip_no) then
                v.isSelect = true
                self.totalSelectNums = self.totalSelectNums+1
            end
        end
    end


     if itemSelectedType == 2 then
        self:createChipListView()
        self.tableViewChip:reloadData()
        self:tableViewItemAction(self.tableViewChip)

        --self.tableView:setVisible(true)
        self.soldierNormal:setVisible(true)
        self.soldierSelect:setVisible(false)
        self.spNormal:setVisible(false)
        self.spSelect:setVisible(true)

        if table.nums(self.chipListDate) <=0 then
        -- getOtherModule():showToastView("没有英雄碎片数据")
            getOtherModule():showAlertDialog(nil, Localize.query("PVGeneralList.2"))
        end
    else
        self:initTableView()
        self.tableView:reloadData()
        self:tableViewItemAction(self.tableView)

        --self.tableViewChip:setVisible(false)
        self.soldierNormal:setVisible(false)
        self.soldierSelect:setVisible(true)
        self.spNormal:setVisible(true)
        self.spSelect:setVisible(false)

        if table.nums(self.soldierData) <=0 then
        -- getOtherModule():showToastView("没有英雄数据")
            getOtherModule():showAlertDialog(nil, Localize.query("PVGeneralList.1"))
        end
    end
    

end

function PVGeneralList:onHideGeneralList()
    self:onHideView()
    -- self.shieldlayer:setTouchEnabled(false)
    -- self:setVisible(false)
end
--创建herochip视图列表
function PVGeneralList:createChipListView()

    local function tableCellTouched(tbl, cell)
        print("PVSoldierChip cell touched at index: " .. cell:getIdx())
    end

    local function cellSizeForTable(table, idx)
        return CONFIG_GENERAL_CELL_HEIGHT, CONFIG_GENERAL_CELL_WIDTH
    end

    local function numberOfCellsInTableView(tab)
       --return table.nums(self.patchListData)
        return #self.chipItems

    end

    local function tableCellAtIndex(tbl, idx)
        local cell = nil
    -- tbl:dequeueCell()
        if nil == cell then
            cell = cc.TableViewCell:new()

            local function onItemClick()
                cclog("onItemClick")

                local chipItem = self.chipItems[cell:getIdx() + 1]

                -- table.print(soldierItem)
                getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSoldierMyLookDetail", chipItem.hero_chip_no)
            end

            local function onSelectClick()
                getAudioManager():playEffectButton2()
                if 8 <= self.totalSelectNums and false == cell.star:isVisible() then


                    -- getOtherModule():showToastView("每次最多选择5个")
                    getOtherModule():showAlertDialog(nil, "每次最多选择8个")
                    getOtherModule():showAlertDialog(nil, Localize.query("PVGeneralList.3"))


                    return
                end

                local index = cell:getIdx()
                if (cell.star:isVisible()) then
                    cell.star:setVisible(false)

                    self.chipItems[index + 1].isSelect = false


                    self.totalSelectNums = self.totalSelectNums - 1
                else
                    cell.star:setVisible(true)

                    self.chipItems[index + 1].isSelect = true
                    self.totalSelectNums = self.totalSelectNums + 1
                end
                --stepCallBack(G_GUIDE_30005)

            end


            cell.UIGeneralItem = {}
            cell.UIGeneralItem["UIGeneralItem"] = {}

            cell.UIGeneralItem["UIGeneralItem"]["onItemClick"] = onItemClick
            cell.UIGeneralItem["UIGeneralItem"]["onSelectClick"] = onSelectClick

            local generaProxy = cc.CCBProxy:create()
            local generalItem = CCBReaderLoad("soul/ui_general_item_new.ccbi", generaProxy, cell.UIGeneralItem)

            cell:addChild(generalItem)


            if table.nums(self.chipItems) > 0 then

                --local strValue = string.format("%d", self.chipListDate[idx + 1].hero_chip_num)
                local strValue = string.format("%d", self.chipItems[idx + 1].hero.hero_chip_num)


                local starLayer = cell.UIGeneralItem["UIGeneralItem"]["starLayer"]
                local headMenuItem = cell.UIGeneralItem["UIGeneralItem"]["headMenuItem"]
                local generalMenu = cell.UIGeneralItem["UIGeneralItem"]["generalMenu"]
                local selectMenuItem = cell.UIGeneralItem["UIGeneralItem"]["selectMenuItem"]
                local generalName = cell.UIGeneralItem["UIGeneralItem"]["generalName"]
                -- local generalLevel = cell.UIGeneralItem["UIGeneralItem"]["generalLevel"]
                local itemBg = cell.UIGeneralItem["UIGeneralItem"]["itemBg"]
                local headIcon = cell.UIGeneralItem["UIGeneralItem"]["headIcon"]

                -- local levelNum = cell.UIGeneralItem["UIGeneralItem"]["levelNum"]
                -- local chipCapacity = cell.UIGeneralItem["UIGeneralItem"]["fightCapacity"]
                local chipNum = cell.UIGeneralItem["UIGeneralItem"]["fightNum"]
                local resNumLabel = cell.UIGeneralItem["UIGeneralItem"]["equip_value"]
                -- levelNum:setVisible(false)


                cell.star = cell.UIGeneralItem["UIGeneralItem"]["starSprite"]
                cell.selectMenu = cell.UIGeneralItem["UIGeneralItem"]["selectMenu"]
                -- cell.itemMenuItem = cell.UIGeneralItem["UIGeneralItem"]["itemMenuItem"]

                -- cell.itemMenuItem:setAllowScale(false)

                cell.starTable = {}
                local starSelect1 = cell.UIGeneralItem["UIGeneralItem"]["starSelect1"]
                local starSelect2 = cell.UIGeneralItem["UIGeneralItem"]["starSelect2"]
                local starSelect3 = cell.UIGeneralItem["UIGeneralItem"]["starSelect3"]
                local starSelect4 = cell.UIGeneralItem["UIGeneralItem"]["starSelect4"]
                local starSelect5 = cell.UIGeneralItem["UIGeneralItem"]["starSelect5"]
                local starSelect6 = cell.UIGeneralItem["UIGeneralItem"]["starSelect6"]
                table.insert(cell.starTable, starSelect1)
                table.insert(cell.starTable, starSelect2)
                table.insert(cell.starTable, starSelect3)
                table.insert(cell.starTable, starSelect4)
                table.insert(cell.starTable, starSelect5)
                table.insert(cell.starTable, starSelect6)


                --generalLevel:setString(strValue)

                -- generalLevel:setVisible(false)
                -- chipCapacity:setString("数量:")
                -- generalLevel:setVisible(false)
                -- chipCapacity:setString(Localize.query("PVGeneralList.4"))
                --chipNum:setString(strValue)

                -- local heroName = self.SoldierTemplate:getHeroName(self.generalItems[idx + 1].hero.hero_no)
                -- generalName:setString(heroName)

                -- local quality = self.SoldierTemplate:getHeroQuality(self.generalItems[idx + 1].hero.hero_no)

                -- for i=1,quality do
                --     local star = string.format("starSelect%d", i)
                --     local starQuality = cell.UIGeneralItem["UIGeneralItem"][star]
                --     starQuality:setVisible(true)
                -- end

                -- local resIcon = self.SoldierTemplate:getSoldierIcon(self.generalItems[idx + 1].hero.hero_no)
                -- changeNewIconImage(headIcon, resIcon, quality) --更新icon

                cell.index = idx

                --local patchItem = self.chipListDate[cell.index + 1]
                local patchItem = self.chipItems[cell.index + 1].hero
                local patchNum = patchItem.hero_chip_num
                local patchNo = patchItem.hero_chip_no
                --cell.patchNo = patchNo
                local soulNum = self.SoldierTemplate:getChipSoulNum(patchNo)
                resNumLabel:setString(soulNum)

                local patchTempLate = self.SoldierTemplate:getChipTempLateById(patchNo)
                local nameStr = patchTempLate.language
                local combineResult = patchTempLate.combineResult

                local name = self.languageTemplate:getLanguageById(nameStr)
                generalName:setString(name)

                local quality = patchTempLate.quality
                updateStarLV(cell.starTable, quality)

                -- local resIcon = self.chipTemp:getChipIconById(patchNo)
                -- setChipWithFrame(headIcon, resIcon, quality) --更新icon
                local resIcon = self.SoldierTemplate:getSoldierIcon(combineResult) --新版icon
                setNewChipWithFrame(headIcon, resIcon, quality, itemBg) --更新icon  新版




                -- if self.generalItems[idx + 1].isSelect ==true then
                --     cell.star:setVisible(true)

                -- else
                --     cell.star:setVisible(false)
                -- end

                local needNum = patchTempLate.needNum
                chipNum:setString(string.format(patchNum) .. "/" .. string.format(needNum))



                if self.chipItems[idx + 1].isSelect ==true then
                    cell.star:setVisible(true)
                else
                    cell.star:setVisible(false)
                end


            end
        end

        return cell
    end

    local layerSize = self.contentLayer:getContentSize()
    self.tableViewChip = cc.TableView:create(cc.size(layerSize.width, layerSize.height))

    self.tableViewChip:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.tableViewChip:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.tableViewChip:setPosition(cc.p(0, 0))
    self.tableViewChip:setDelegate()
    self.contentLayer:addChild(self.tableViewChip)

    self.tableViewChip:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
    self.tableViewChip:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableViewChip:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.tableViewChip:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)

    self.contentLayer:removeChildByTag(10001)
    local scrBar = PVScrollBar:new()
    scrBar:setTag(10001)
    scrBar:init(self.tableViewChip,1)
    scrBar:setPosition(cc.p(layerSize.width,layerSize.height/2))
    self.contentLayer:addChild(scrBar,2)

    self.tableViewChip:reloadData()

end


return PVGeneralList


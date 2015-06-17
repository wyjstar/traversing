-- 传承

-- 无双界面

local PVInheritWSList = class("PVInheritWSList", BaseUIView)

function PVInheritWSList:ctor(id)
    self.super.ctor(self, id)

    self.lineupData = getDataManager():getLineupData()
    self.c_SoldierTemplate = getTemplateManager():getSoldierTemplate()
    self.c_LanguageTemplate = getTemplateManager():getLanguageTemplate()
    self.c_ResourceTemplate = getTemplateManager():getResourceTemplate()
    self.c_InstanceTemplate = getTemplateManager():getInstanceTemplate()
end

function PVInheritWSList:onMVCEnter()

    game.addSpriteFramesWithFile("res/ccb/resource/ui_lineup.plist")

    self.level = self:getTransferData()[1]    --等级， 0 代表选择材料卡牌，等级大于1     ；其他代表小于该等级
    print("level:"..self.level)

    self.UIInheritLineUpView = {}
    self:initTouchListener()
    self:loadCCBI("inherit/ui_inherit_ws.ccbi", self.UIInheritLineUpView)

    self:initView()    
end

function PVInheritWSList:onExit()
    cclog("-------onExit----")
    -- self:unregisterScriptHandler()
    -- game.removeSpriteFramesWithFile("res/ccb/resource/ui_lineup.plist")

    self.lineupData = nil
    self.c_SoldierTemplate = nil
    self.c_LanguageTemplate = nil
    self.c_ResourceTemplate = nil
end

function PVInheritWSList:initView()
    self:showAttributeView()

    ----------
    self.secretNoNode = self.UIInheritLineUpView["UIInheritLineUpView"]["secretNoNode"]
    self.secretNoNode:setVisible(false)

    self.inheritLabel = self.UIInheritLineUpView["UIInheritLineUpView"]["inheritLabel"]
    self.inheritLabel:setVisible(true)

    self.titile = self.UIInheritLineUpView["UIInheritLineUpView"]["titile"]
    game.setSpriteFrame(self.titile , "#ui_inherit_lb_wsjn.png")


    -- self.soldierNode = self.UIInheritLineUpView["UIInheritLineUpView"]["soldierNode"]
    -- self.soldierNode:setVisible(false)
    -- self.cheerNode =  self.UIInheritLineUpView["UIInheritLineUpView"]["cheerNode"]
    -- self.cheerNode:setVisible(false)

    -- self.SeatNode = self.UIInheritLineUpView["UIInheritLineUpView"]["hero_node"]
    -- self.SeatNode:setVisible(false)

    --无双
    self.nodeWS = self.UIInheritLineUpView["UIInheritLineUpView"]["wu_node"]
    self.nodeWS:setVisible(true)
    -- self.nodeWS:setPosition(0, 65)
    self.wslayer = self.UIInheritLineUpView["UIInheritLineUpView"]["ws_layer"]

    -- ws
    self:updateWSListData()
    self:createWSList()
end


--更新无双列表的数据
function PVInheritWSList:updateWSListData()
    self.wsListAll = self.c_InstanceTemplate:getWSList()  -- 无双列表
    self.wsList = {}
    local index = 1
    print("等级"..self.level)
    for k,v in pairs(self.wsListAll) do
    	if self.level == 0 then 
    		if self.lineupData:getWSLevel(v.id) > 1 and self:getIsWSLive(v) then 
    			table.insert(self.wsList, v)
        	    index = index+1
            end
        else
        	if self.lineupData:getWSLevel(v.id) < self.level and self:getIsWSLive(v) then 
                print("激活，等级符合")
        		table.insert(self.wsList, v)
        	    index = index+1
            end
        end
    end
    print(">>>>>>>>>"..index)

    print("---------- updateWSListData -------------")
    table.print(self.wsList)

    local function getIsActive(wsId)
        local condition = {}
        local v = self.c_InstanceTemplate:getWSInfoById(wsId)
        if v.condition1 ~= 0 then table.insert(condition, v.condition1) end
        if v.condition2 ~= 0 then table.insert(condition, v.condition2) end
        if v.condition3 ~= 0 then table.insert(condition, v.condition3) end
        if v.condition4 ~= 0 then table.insert(condition, v.condition4) end
        if v.condition5 ~= 0 then table.insert(condition, v.condition5) end
        if v.condition6 ~= 0 then table.insert(condition, v.condition6) end
        if v.condition7 ~= 0 then table.insert(condition, v.condition7) end

        for k,v in pairs(condition) do
            if self:getSoldierIsActivity(v) == false then -- v is soldierId
                return false
            end
        end

        return true
    end

    for k,v in pairs(self.wsList) do
        if getIsActive(v.id) then v.isActive = true end
    end

    -- sort 
    local function compare(a, b)
        local cmpA = 0
        local cmpB = 0
        if a.isActive then cmpA = 1 end
        if b.isActive then cmpB = 1 end
        if cmpA > cmpB then return true
        elseif cmpA == cmpB then
            if a.id < b.id then return true
            else return false
            end
        end
    end
    table.sort( self.wsList, compare )

    if self.wsTableView then
        self.wsTableView:reloadData()
        self:tableViewItemAction(self.wsTableView)
    end
end


function PVInheritWSList:getSoldierIsActivity(soldierId)
    local selectSoldier = self.lineupData:getSelectSoldier()

    for k, v in pairs(selectSoldier) do
        if v.hero.hero_no == soldierId then
            return true
        end
    end
    return false
end
--无双是否激活
function PVInheritWSList:getIsWSLive(ws)
    local condition = {}
    if ws.condition1 ~= 0 then table.insert(condition, ws.condition1) end
    if ws.condition2 ~= 0 then table.insert(condition, ws.condition2) end
    if ws.condition3 ~= 0 then table.insert(condition, ws.condition3) end
    if ws.condition4 ~= 0 then table.insert(condition, ws.condition4) end
    if ws.condition5 ~= 0 then table.insert(condition, ws.condition5) end
    if ws.condition6 ~= 0 then table.insert(condition, ws.condition6) end
    if ws.condition7 ~= 0 then table.insert(condition, ws.condition7) end

    local isActive = true

    for k,v in pairs(condition) do

        if self:getSoldierIsActivity(v) == false then
            isActive = false
            return
        end
    end
    return isActive
end
--
function PVInheritWSList:initTouchListener()

    local function backMenuClick()
        getAudioManager():playEffectButton2()
        self:onHideView()
        -- showModuleView(MODULE_NAME_HOMEPAGE)
    end
    self.UIInheritLineUpView["UIInheritLineUpView"] = {}
    self.UIInheritLineUpView["UIInheritLineUpView"]["backMenuClick"] = backMenuClick
end



function PVInheritWSList:createWSList()
	print("---------- createWSList -------------")

    local function tableCellTouched(tab, cell)
        print("cell touched at index: " .. cell:getIdx())
    end
    local function numberOfCellsInTableView(tab)
        return table.nums(self.wsList)
    end
    local function cellSizeForTable(tab, idx)
        return 142, 555
    end
    local function tableCellAtIndex(tab, idx)
        local cell = nil --tab:dequeueCell()
        if nil == cell then
            cell = cc.TableViewCell:new()
         
            ------------------
            local function inheritMenuClick()
            	local ws = table.getValueByIndex(self.wsList, cell:getIdx()+1)
            	print("----- ws ------")
                table.print(ws)

                -- getDataManager():getInheritData():setws1(ws)

                if self.level == 0 then
                    print("")
                    getDataManager():getInheritData():setws1(ws)
                   
                else
                    getDataManager():getInheritData():setws2(ws)
                    -- self:onHideView()
                end

                local event = cc.EventCustom:new(UPDATE_VIEW)
                self:getEventDispatcher():dispatchEvent(event)

                self:onHideView()

            end
            ------------------

            cell.cardinfo = {}
            local proxy = cc.CCBProxy:create()
            cell.cardinfo["UIInheritSelectWSItem"] = {}
            cell.cardinfo["UIInheritSelectWSItem"]["inheritMenuClick"] = inheritMenuClick
            local node = CCBReaderLoad("inherit/ui_inherit_ws_item.ccbi", proxy, cell.cardinfo)
            cell:addChild(node)

            cell.imgUpgred = cell.cardinfo["UIInheritSelectWSItem"]["img_shengji"]
            cell.imgLook = cell.cardinfo["UIInheritSelectWSItem"]["img_look"]
            cell.menu = cell.cardinfo["UIInheritSelectWSItem"]["menu"]
            -----------
            cell.menuInherit = cell.cardinfo["UIInheritSelectWSItem"]["menuInherit"]
            -----------
            cell.labelDes = cell.cardinfo["UIInheritSelectWSItem"]["desc"]
            cell.nodeState = cell.cardinfo["UIInheritSelectWSItem"]["node_state"]
            cell.iconImg = cell.cardinfo["UIInheritSelectWSItem"]["img_ws"]

            cell.levelLabel = cell.cardinfo["UIInheritSelectWSItem"]["lvLabel"]

            cell.richText = self:getAllPremiseName(self.wsList[idx+1].id)
            cell.nodeState:addChild(cell.richText)
        end
  
        cell.menu:setVisible(false)
        cell.menuInherit:setVisible(true)


        local wsItem = self.wsList[idx+1]
        local _icon = self.c_ResourceTemplate:getResourceById(wsItem.icon)
        local _description = self.c_LanguageTemplate:getLanguageById(wsItem.discription)

        local _wsLevel = self.lineupData:getWSLevel(wsItem.id)
        cell.levelLabel:setString("Lv"..tostring(_wsLevel))

        cell.labelDes:setString(_description)
        game.setSpriteFrame(cell.iconImg, "res/icon/ws/".._icon)
        if wsItem.isActive then
            cell.imgUpgred:removeFromParent(false)
            cell.menu:setSelectedImage(cell.imgUpgred)
            cell.imgLook:setVisible(false)
            cell.imgUpgred:setVisible(true)
        else
            cell.imgLook:removeFromParent(false)
            cell.menu:setSelectedImage(cell.imgLook)
            cell.imgLook:setVisible(true)
            cell.imgUpgred:setVisible(false)
        end

        return cell
    end

    self.wsTableView = cc.TableView:create(self.wslayer:getContentSize())
    self.wsTableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.wsTableView:setDelegate()
    self.wsTableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.wslayer:addChild(self.wsTableView)

    self.wsTableView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
    self.wsTableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.wsTableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.wsTableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)

    local scrBar = PVScrollBar:new()
    scrBar:init(self.wsTableView,1)
    
    local layerSize = self.wslayer:getContentSize()
    scrBar:setPosition(cc.p(layerSize.width,layerSize.height/2))
    self.wslayer:addChild(scrBar,2)

    self.wsTableView:reloadData()
    self:tableViewItemAction(self.wsTableView)
end

--无双是否激活
function PVInheritWSList:getSoldierIsActivity(soldierId)
    local selectSoldier = self.lineupData:getSelectSoldier()

    for k, v in pairs(selectSoldier) do
        if v.hero.hero_no == soldierId then
            return true
        end
    end
    return false
end

--获取激活条件
function PVInheritWSList:getAllPremiseName(wsId)

    local richtext = ccui.RichText:create()
    richtext:setAnchorPoint(cc.p(0,0.5))

    local nameId = self.c_InstanceTemplate:getWSInfoById(wsId).name
    local wsName = self.c_LanguageTemplate:getLanguageById(nameId)

    local re0 = ccui.RichElementText:create(1, ui.COLOR_YELLOW, 255, wsName, "res/ccb/resource/miniblack.ttf", 22)
    richtext:pushBackElement(re0)

    local re1 = ccui.RichElementText:create(1, ui.COLOR_GREY, 255, Localize.query("wushuang.1"), "res/ccb/resource/miniblack.ttf", 22)
    richtext:pushBackElement(re1)

    local condition = {}
    local v = self.c_InstanceTemplate:getWSInfoById(wsId)
    if v.condition1 ~= 0 then table.insert(condition, v.condition1) end
    if v.condition2 ~= 0 then table.insert(condition, v.condition2) end
    if v.condition3 ~= 0 then table.insert(condition, v.condition3) end
    if v.condition4 ~= 0 then table.insert(condition, v.condition4) end
    if v.condition5 ~= 0 then table.insert(condition, v.condition5) end
    if v.condition6 ~= 0 then table.insert(condition, v.condition6) end
    if v.condition7 ~= 0 then table.insert(condition, v.condition7) end

    local count = table.nums(condition)

    for k,v in pairs(condition) do
        local _nameId = self.c_SoldierTemplate:getHeroTempLateById(v).nameStr
        local _nameStr = self.c_LanguageTemplate:getLanguageById(_nameId)
        local color = ui.COLOR_GREY
        if self:getSoldierIsActivity(v) then -- v is soldierId
            color = ui.COLOR_GREEN
        end
        local re1 = ccui.RichElementText:create(1, color, 255, _nameStr, "res/ccb/resource/miniblack.ttf", 22)
        richtext:pushBackElement(re1)

        if k ~= count then
            local re2 = ccui.RichElementText:create(1, ui.COLOR_GREY, 255, Localize.query("wushuang.2"), "res/ccb/resource/miniblack.ttf", 22)
            richtext:pushBackElement(re2)
        end
    end
    local rend = ccui.RichElementText:create(1, ui.COLOR_GREY, 255, Localize.query("wushuang.3"), "res/ccb/resource/miniblack.ttf", 22)
    richtext:pushBackElement(rend)

    return richtext
end


function PVInheritWSList:clearResource()
    cclog("--------clearResource-----")
    -- self.sodierData:clearHeroImagePlist()

    -- game.removeSpriteFramesWithFile("res/ccb/resource/ui_lineup.plist")
end

return PVInheritWSList










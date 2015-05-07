--选择无双界面

local PVSelectWS = class("PVSelectWS", BaseUIView)

function PVSelectWS:ctor(id)

    PVSelectWS.super.ctor(self, id)

    self.heroTemp = getTemplateManager():getSoldierTemplate()
    self.instanceTemp = getTemplateManager():getInstanceTemplate()
    self.languageTemp = getTemplateManager():getLanguageTemplate()
    self.lineupData = getDataManager():getLineupData()
    self.resourceTemp = getTemplateManager():getResourceTemplate()
end

function PVSelectWS:onMVCEnter()

    self.UISelectWS = {}
    
    self:initTouchListener()

    self:loadCCBI("instance/ui_select_ws.ccbi", self.UISelectWS)

    self:initView()
    self:updateWSListData()
    self:createListView()
end 

function PVSelectWS:initTouchListener()

    local function backMenuClick()
       -- self.selectIndex = -1
       self:onHideView()
       groupCallBack(GuideGroupKey.BTN_CLOSE_WS)
    end

    self.UISelectWS["UISelectWS"] = {}
    self.UISelectWS["UISelectWS"]["backMenuClick"] = backMenuClick
end

function PVSelectWS:initView()
    self.wslayer = self.UISelectWS["UISelectWS"]["listLayer"]
end

function PVSelectWS:updateWSListData()
    local list = self.instanceTemp:getWSList()  -- 无双列表

    local function getIsActive(wsId)
        local condition = {}
        local v = self.instanceTemp:getWSInfoById(wsId)
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

    self.wsList = {}
    for k,v in pairs(list) do
        if getIsActive(v.id) then
            v.isActive = true 
            table.insert(self.wsList, v)
        end
    end

    table.print(self.wsList)

    -- sort 
    -- local function compare(a, b)
    --     local cmpA = 0
    --     local cmpB = 0
    --     if a.isActive then cmpA = 1 end
    --     if b.isActive then cmpB = 1 end
    --     if cmpA > cmpB then return true
    --     elseif cmpA == cmpB then
    --         if a.id < b.id then return true
    --         else return false
    --         end
    --     end
    -- end
    -- table.sort( self.wsList, compare )

    if self.wsTableView then
        self.wsTableView:reloadData()
        self:tableViewItemAction(self.wsTableView)
    end

    if table.nums(self.wsList) == 0 then
        -- getOtherModule():showToastView(Localize.query("wushuang.6"))
    end
end

function PVSelectWS:createListView()

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
            local function selectMenuClick()
                getAudioManager():playEffectButton2()
                print("selectMenuClick")

                -- stepCallBack(G_GUIDE_20043)
                groupCallBack(GuideGroupKey.BTN_CLICK_SELECT)
                local id = self.wsList[idx+1].id
                getDataManager():getStageData():setCurrUnpara(id)
                self:onHideView()
            end
            cell.cardinfo = {}
            local proxy = cc.CCBProxy:create()
            cell.cardinfo["UISelectWSItem"] = {}
            cell.cardinfo["UISelectWSItem"]["selectMenuClick"] = selectMenuClick
            local node = CCBReaderLoad("instance/ui_select_ws_item.ccbi", proxy, cell.cardinfo)
            cell:addChild(node)

            cell.menu = cell.cardinfo["UISelectWSItem"]["menu"]
            cell.labelDes = cell.cardinfo["UISelectWSItem"]["desc"]
            cell.nodeState = cell.cardinfo["UISelectWSItem"]["node_state"]
            cell.iconImg = cell.cardinfo["UISelectWSItem"]["img_ws"]
            cell.wsLevelNumLabelNode = cell.cardinfo["UISelectWSItem"]["wsLevelNumLabelNode"]

            cell.richText = self:getAllPremiseName(self.wsList[idx+1].id)
            cell.nodeState:addChild(cell.richText)
        end
        local wsItem = self.wsList[idx+1]
        local _icon = self.resourceTemp:getResourceById(wsItem.icon)
        local _description = self.languageTemp:getLanguageById(wsItem.discription)
        local _wsLevel = getDataManager():getLineupData():getWSLevel(wsItem.id)
       
        local levelNode = getLevelNode(_wsLevel)
        cell.wsLevelNumLabelNode:removeAllChildren()
        cell.wsLevelNumLabelNode:addChild(levelNode)

        cell.labelDes:setString(_description)
        game.setSpriteFrame(cell.iconImg, "res/icon/ws/".._icon)

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
    scrBar:setPosition(cc.p(self.wslayer:getContentSize().width,self.wslayer:getContentSize().height/2))
    self.wslayer:addChild(scrBar,2)

    self.wsTableView:reloadData()
    self:tableViewItemAction(self.wsTableView)
end

--无双是否激活
function PVSelectWS:getSoldierIsActivity(soldierId)
    -- local selectSoldier = self.lineupData:getSelectSoldier()

    -- for k, v in pairs(selectSoldier) do
    --     if v.hero.hero_no == soldierId then
    --         return true
    --     end
    -- end
    -- return false

    local selectSoldier = self.lineupData:getEmbattleArray()

    for k,v in pairs(selectSoldier) do     --现在对无双的检测是用布阵的武将，不是阵容的武将列表
        if v.hero_id == soldierId then
            return true
        end
    end
    return false
end

--获取激活条件
function PVSelectWS:getAllPremiseName(wsId)

    local richtext = ccui.RichText:create()
    richtext:setAnchorPoint(cc.p(0,0.5))

    local nameId = self.instanceTemp:getWSInfoById(wsId).name
    local wsName = self.languageTemp:getLanguageById(nameId)

    local re0 = ccui.RichElementText:create(1, ui.COLOR_YELLOW, 255, wsName, "res/ccb/resource/miniblack.ttf", 22)
    richtext:pushBackElement(re0)

    local re1 = ccui.RichElementText:create(1, ui.COLOR_GREY, 255, Localize.query("wushuang.1"), "res/ccb/resource/miniblack.ttf", 22)
    richtext:pushBackElement(re1)
    
    local condition = {}
    local v = self.instanceTemp:getWSInfoById(wsId)
    if v.condition1 ~= 0 then table.insert(condition, v.condition1) end
    if v.condition2 ~= 0 then table.insert(condition, v.condition2) end
    if v.condition3 ~= 0 then table.insert(condition, v.condition3) end
    if v.condition4 ~= 0 then table.insert(condition, v.condition4) end
    if v.condition5 ~= 0 then table.insert(condition, v.condition5) end
    if v.condition6 ~= 0 then table.insert(condition, v.condition6) end
    if v.condition7 ~= 0 then table.insert(condition, v.condition7) end

    local count = table.nums(condition)

    for k,v in pairs(condition) do
        local _nameId = self.heroTemp:getHeroTempLateById(v).nameStr
        local _nameStr = self.languageTemp:getLanguageById(_nameId)
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


--@return 
return PVSelectWS
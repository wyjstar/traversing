
--游历
--风物志
local PVTravelFengwuzhi = class("PVTravelFengwuzhi", BaseUIView)

function PVTravelFengwuzhi:ctor(id)

    self.c_TravelTemplate = getTemplateManager():getTravelTemplate()
    self.c_TravelData = getDataManager():getTravelData()


    self.super.ctor(self, id)
end

function PVTravelFengwuzhi:onMVCEnter()
    game.addSpriteFramesWithFile("res/ccb/resource/ui_travel.plist")
    
    self.UITravelFengwuzhiView = {}
    self:initTouchListener()
    --加载本界面的ccbi
    self:loadCCBI("travel/ui_travel_fengwuzhi.ccbi", self.UITravelFengwuzhiView)

    self.touchEvent = false
    self.c_Calculation = getCalculationManager():getCalculation()

    self.doTableViewAction = true

    self:initView()  

    self:initData()

    self:initRedPoints()

    self:updateAddPower()
end


function PVTravelFengwuzhi:initView()
    self.listLayer = self.UITravelFengwuzhiView["UITravelFengwuzhiView"]["travelContentLayer"]
    self.layerSize = self.listLayer:getContentSize()


    self.peopleSprite = self.UITravelFengwuzhiView["UITravelFengwuzhiView"]["peopleSprite"]
    self.peopleSprite2 = self.UITravelFengwuzhiView["UITravelFengwuzhiView"]["peopleSprite2"]
    self.shenglingSprite = self.UITravelFengwuzhiView["UITravelFengwuzhiView"]["shenglingSprite"]
    self.shenglingSprite2 = self.UITravelFengwuzhiView["UITravelFengwuzhiView"]["shenglingSprite2"]
    self.fengjingSprite = self.UITravelFengwuzhiView["UITravelFengwuzhiView"]["fengjingSprite"]
    self.fengjingSprite2 = self.UITravelFengwuzhiView["UITravelFengwuzhiView"]["fengjingSprite2"]
    self.qiwuSprite = self.UITravelFengwuzhiView["UITravelFengwuzhiView"]["qiwuSprite"]
    self.qiwuSprite2 = self.UITravelFengwuzhiView["UITravelFengwuzhiView"]["qiwuSprite2"]

    self.lifeAddNum = self.UITravelFengwuzhiView["UITravelFengwuzhiView"]["lifeAddNum"]       -- 生命
    self.attackAddNum = self.UITravelFengwuzhiView["UITravelFengwuzhiView"]["attackAddNum"]   -- 攻击
    self.physicAddNum = self.UITravelFengwuzhiView["UITravelFengwuzhiView"]["physicAddNum"]   -- 物防
    self.magicAddNum = self.UITravelFengwuzhiView["UITravelFengwuzhiView"]["magicAddNum"]     -- 魔防

    self.item_notice4 = self.UITravelFengwuzhiView["UITravelFengwuzhiView"]["item_notice4"] 
    self.item_notice3 = self.UITravelFengwuzhiView["UITravelFengwuzhiView"]["item_notice3"]
    self.item_notice2 = self.UITravelFengwuzhiView["UITravelFengwuzhiView"]["item_notice2"]
    self.item_notice1 = self.UITravelFengwuzhiView["UITravelFengwuzhiView"]["item_notice1"]

    self.peopleTitleLabel = self.UITravelFengwuzhiView["UITravelFengwuzhiView"]["peopleTitleLabel"]
    self.zhiDesLabel = self.UITravelFengwuzhiView["UITravelFengwuzhiView"]["zhiDesLabel"]
    self.icon = self.UITravelFengwuzhiView["UITravelFengwuzhiView"]["zhiSprite"]
    self.travelHuaJuan = self.UITravelFengwuzhiView["UITravelFengwuzhiView"]["travelHuaJuan"]
    

    self.tabelItemList = {}

    self.menuTable = {} --4个按钮
    self.menuA = self.UITravelFengwuzhiView["UITravelFengwuzhiView"]["menuItem1"]
    self.menuB = self.UITravelFengwuzhiView["UITravelFengwuzhiView"]["menuItem2"]
    self.menuC = self.UITravelFengwuzhiView["UITravelFengwuzhiView"]["menuItem3"]
    self.menuD = self.UITravelFengwuzhiView["UITravelFengwuzhiView"]["menuItem4"]
    table.insert(self.menuTable, self.menuA)
    table.insert(self.menuTable, self.menuB)
    table.insert(self.menuTable, self.menuC)
    table.insert(self.menuTable, self.menuD)

    for k,v in pairs(self.menuTable) do
        v:setAllowScale(false)
    end
    self:onMenuChange(1)

    self.tableViewPeopleList = {}

    self.curTab = 1 
    self:initTableview()
    self.curTab = 2 
    self:initTableview()
    self.curTab = 3 
    self:initTableview()
    self.curTab = 4 
    self:initTableview()

    self.curTab = 1 
    
end

function PVTravelFengwuzhi:initRedPoints( ... )
    
    if self.c_TravelData:isHaveRedPointFeng(self.stage_id, 2) then 
        self.item_notice1:setVisible(true)
    else
        self.item_notice1:setVisible(false)
    end
    if self.c_TravelData:isHaveRedPointFeng(self.stage_id, 3) then
        self.item_notice2:setVisible(true)
    else
        self.item_notice2:setVisible(false)
    end
    if self.c_TravelData:isHaveRedPointFeng(self.stage_id, 4) then
        self.item_notice3:setVisible(true)
    else
        self.item_notice3:setVisible(false)
    end
    if self.c_TravelData:isHaveRedPointFeng(self.stage_id, 1) then
        self.item_notice4:setVisible(true)
    else
        self.item_notice4:setVisible(false)
    end

end


function PVTravelFengwuzhi:initData()

    self.life = 0
    self.fight = 0
    self.physic = 0
    self.magic = 0

    self.peopleZhiList = {}     --盛放人物志
    self.peopleZhiNumber = 0
    self.lifeZhiList = {}       --盛放生灵志
    self.lifeZhiNumber = 0
    self.fengZhiList = {}       --盛放风景志
    self.fengZhiNumber = 0
    self.qiZhiList = {}         --盛放奇物志
    self.qiZhiNumber = 0

    self.chaNum = self.funcTable[2]   --获取本章节的章节号
    self.stage_id = self.funcTable[1]
    self.curTab = 1

    local i = self.chaNum * 10000+1

    local _travelItem = self.c_TravelTemplate:getItemByDetailID(i)
    while _travelItem ~= nil do
    
        if _travelItem.type == 2 then
            self.peopleZhiList[self.peopleZhiNumber] = i 
            self.peopleZhiNumber = self.peopleZhiNumber + 1
        end
        if _travelItem.type == 3 then
            self.lifeZhiList[self.lifeZhiNumber] = i 
            self.lifeZhiNumber = self.lifeZhiNumber + 1
        end
        if _travelItem.type == 4 then
            self.fengZhiList[self.fengZhiNumber] = i 
            self.fengZhiNumber = self.fengZhiNumber + 1
        end
        if _travelItem.type == 1 then
            self.qiZhiList[self.qiZhiNumber] = i 
            self.qiZhiNumber = self.qiZhiNumber + 1
        end

        i = i + 1
        _travelItem = self.c_TravelTemplate:getItemByDetailID(i)
    end


    table.print(self.peopleZhiList)


    self.peopleZhiGroup = {}     --盛放人物志 组号
    self.peopleZhiGroupNumber = 0 --人物志有多少组
    self.lifeZhiGroup = {}       --盛放生灵志 组号
    self.lifeZhiGroupNumber = 0
    self.fengZhiGroup = {}       --盛放风景志 组号
    self.fengZhiGroupNumber = 0
    self.qiZhiGroup = {}         --盛放奇物志 组号
    self.qiZhiGroupNumber = 0

    --在peopleZhiGroup中存放人物志的所有组号
    local id = self.peopleZhiList[0]
    self.peopleZhiGroup[1] = self.c_TravelTemplate:getItemGroupByDetailID(id) -- 把第一个人物志的组号给人物志组
    self.peopleZhiGroupNumber = self.peopleZhiGroupNumber+1
    for i=2, self.peopleZhiNumber do
        local id2 = self.peopleZhiList[i-1]
        local x = self.peopleZhiGroupNumber
        local y = 0
        for j=1,x do
            if self.c_TravelTemplate:getItemGroupByDetailID(id2) ~= self.peopleZhiGroup[j] then
                y = y+1 
            end
        end
        --print(y)
        if x == y then
            self.peopleZhiGroupNumber = self.peopleZhiGroupNumber+1
            self.peopleZhiGroup[self.peopleZhiGroupNumber] = self.c_TravelTemplate:getItemGroupByDetailID(id2)
        end
    end
    print("peopleZhiGroupNumber:"..self.peopleZhiGroupNumber)


    table.print(self.peopleZhiGroup)


    --在lifeZhiGroup中存放生灵志的所有组号
    local id = self.lifeZhiList[0]
    self.lifeZhiGroup[1] = self.c_TravelTemplate:getItemGroupByDetailID(id)
    self.lifeZhiGroupNumber = self.lifeZhiGroupNumber+1
    for i=2,self.lifeZhiNumber do
        local id2 = self.lifeZhiList[i-1]
        local x = self.lifeZhiGroupNumber
        local y = 0
        for j=1,x do
            if self.c_TravelTemplate:getItemGroupByDetailID(id2) ~= self.lifeZhiGroup[j] then
                y = y+1
            end
        end
        --print(y)
        if x == y then
            self.lifeZhiGroupNumber = self.lifeZhiGroupNumber+1
            self.lifeZhiGroup[self.lifeZhiGroupNumber] = self.c_TravelTemplate:getItemGroupByDetailID(id2)
        end
    end
    print("lifeZhiGroupNumber:"..self.lifeZhiGroupNumber)

    --在fengZhiGroup中存放风景志的所有组号
    local id = self.fengZhiList[0]
    self.fengZhiGroup[1] = self.c_TravelTemplate:getItemGroupByDetailID(id)
    self.fengZhiGroupNumber = self.fengZhiGroupNumber+1
    for i=2,self.fengZhiNumber do
        local id2 = self.fengZhiList[i-1]
        local x = self.fengZhiGroupNumber
        local y = 0
        for j=1,x do
            if self.c_TravelTemplate:getItemGroupByDetailID(id2) ~= self.fengZhiGroup[j] then
                y = y+1   
            end
        end
        --print(y)
        if x == y then
            self.fengZhiGroupNumber = self.fengZhiGroupNumber+1
            self.fengZhiGroup[self.fengZhiGroupNumber] = self.c_TravelTemplate:getItemGroupByDetailID(id2)
        end
    end
    print("fengZhiGroupNumber:"..self.fengZhiGroupNumber)

    --在qiZhiGroup中存放奇物志的所有组号
    local id = self.qiZhiList[0]
    self.qiZhiGroup[1] = self.c_TravelTemplate:getItemGroupByDetailID(id)
    self.qiZhiGroupNumber = self.qiZhiGroupNumber+1
    for i=2,self.qiZhiNumber do
        local id2 = self.qiZhiList[i-1]
        local x = self.qiZhiGroupNumber
        local y = 0
        for j=1,x do
            if self.c_TravelTemplate:getItemGroupByDetailID(id2) ~= self.qiZhiGroup[j] then
                y = y+1   
            end
        end
        --print(y)
        if x == y then
            self.qiZhiGroupNumber = self.qiZhiGroupNumber+1
            self.qiZhiGroup[self.qiZhiGroupNumber] = self.c_TravelTemplate:getItemGroupByDetailID(id2)
        end
    end
    print("qiZhiGroupNumber:"..self.qiZhiGroupNumber)

    local tempTable = {}
    local proxy = cc.CCBProxy:create()
    local node = CCBReaderLoad("travel/ui_travel_fengwuzhi_item.ccbi", proxy, tempTable)
    local sizeLayer = tempTable["UITravelFengwuzhiItem"]["sizeLayer"]

    self.itemSize = sizeLayer:getContentSize()
 
    self.tableViewTable = {}  --4个tabelView
    -- self:createPeopleZhiListView()
    -- self:createLifeZhiListView()
    -- self:createFengZhiListView()
    -- self:createQiZhiListView()

    self.menuA:setEnabled(false)
    
    self.tableViewPeople:reloadData()
    self.tableViewPeople:setVisible(true)
    self:tableViewItemAction(self.tableViewPeople)


    local itemId = self.peopleZhiList[0]
    local itemGroupId = self.c_TravelTemplate:getItemGroupByDetailID(id)
    self:updateZhiShow(itemId, 1)
end

function PVTravelFengwuzhi:updateAddPower()
    -- print("---------------- 人物志 ---------------")
    for k,v in pairs(self.peopleZhiGroup) do
        -- print(">>>>>>>>>  "..k)
        local tableNum = 0
        local isHaveNum = 0
        for k1,v1 in pairs(self.peopleZhiList) do
            if self.c_TravelTemplate:getItemGroupByDetailID(v1) == v then
                tableNum = tableNum + 1
                if self.c_TravelData:setIsHaveFengWuZhi(v1) == true then
                    isHaveNum = isHaveNum + 1
                end
            end
        end
        -- print("---"..isHaveNum.."---"..tableNum)
        if isHaveNum == tableNum then
            -- str = self.c_TravelTemplate:getAddByeventID(
            local hp, atk, physicalDef, magicDef = self.c_TravelTemplate:getAddByGroupId(v)
            -- print("---"..hp.."---"..atk.."---"..physicalDef.."---"..magicDef)
            self.life = self.life + hp
            self.fight = self.fight + atk
            self.physic = self.physic + physicalDef
            self.magic = self.magic + magicDef
        end
        -- print("--"..self.life.."--"..self.fight.."--"..self.physic.."--"..self.magic)
    end
    -- print("---------------- 生灵志 ---------------")
    for k,v in pairs(self.lifeZhiGroup) do
        local tableNum = 0
        local isHaveNum = 0
        for k1,v1 in pairs(self.lifeZhiList) do
            if self.c_TravelTemplate:getItemGroupByDetailID(v1) == v then
                tableNum = tableNum + 1
                if self.c_TravelData:setIsHaveFengWuZhi(v1) == true then
                    isHaveNum = isHaveNum + 1
                end
            end     
        end
        -- print("---"..isHaveNum.."---"..tableNum)
        if isHaveNum == tableNum then
            -- str = self.c_TravelTemplate:getAddByeventID(
            local hp, atk, physicalDef, magicDef = self.c_TravelTemplate:getAddByGroupId(v)
            -- print("---"..hp.."---"..atk.."---"..physicalDef.."---"..magicDef)
            self.life = self.life + hp
            self.fight = self.fight + atk
            self.physic = self.physic + physicalDef
            self.magic = self.magic + magicDef
        end
        -- print("--"..self.life.."--"..self.fight.."--"..self.physic.."--"..self.magic)

    end
    -- print("---------------- 风物质 ---------------")
    for k,v in pairs(self.fengZhiGroup) do
        local tableNum = 0
        local isHaveNum = 0
        for k1,v1 in pairs(self.fengZhiList) do
            if self.c_TravelTemplate:getItemGroupByDetailID(v1) == v then
                tableNum = tableNum + 1
                if self.c_TravelData:setIsHaveFengWuZhi(v1) == true then
                    isHaveNum = isHaveNum + 1
                end
            end
        end
        -- print("---"..isHaveNum.."---"..tableNum)
        if isHaveNum == tableNum then
            -- str = self.c_TravelTemplate:getAddByeventID(
            local hp, atk, physicalDef, magicDef = self.c_TravelTemplate:getAddByGroupId(v)
            -- print("---"..hp.."---"..atk.."---"..physicalDef.."---"..magicDef)
            self.life = self.life + hp
            self.fight = self.fight + atk
            self.physic = self.physic + physicalDef
            self.magic = self.magic + magicDef
        end
        
        -- print("--"..self.life.."--"..self.fight.."--"..self.physic.."--"..self.magic)

    end
     -- print("---------------- 奇物质 ---------------")
    for k,v in pairs(self.qiZhiGroup) do
        local tableNum = 0
        local isHaveNum = 0
        for k1,v1 in pairs(self.qiZhiList) do
            if self.c_TravelTemplate:getItemGroupByDetailID(v1) == v then
                tableNum = tableNum + 1
                if self.c_TravelData:setIsHaveFengWuZhi(v1) == true then
                    isHaveNum = isHaveNum + 1
                end
            end
        end
        -- print("---"..isHaveNum.."---"..tableNum)
        if isHaveNum == tableNum then
            -- str = self.c_TravelTemplate:getAddByeventID(
            local hp, atk, physicalDef, magicDef = self.c_TravelTemplate:getAddByGroupId(v)
            -- print("---"..hp.."---"..atk.."---"..physicalDef.."---"..magicDef)
            self.life = self.life + hp
            self.fight = self.fight + atk
            self.physic = self.physic + physicalDef
            self.magic = self.magic + magicDef
        end
        -- print("--"..self.life.."--"..self.fight.."--"..self.physic.."--"..self.magic)

    end

    local color1 = ui.COLOR_GREEN
    local color2 = ui.COLOR_GREEN
    local color3 = ui.COLOR_GREEN
    local color4 = ui.COLOR_GREEN
    if self.life == 0 then
        color1 = ui.COLOR_GREY
    end
    if self.fight == 0 then
        color2 = ui.COLOR_GREY
    end
    if self.physic == 0 then
        color3 = ui.COLOR_GREY
    end
    if self.magic == 0 then
        color4 = ui.COLOR_GREY
    end
    local attr = self.c_Calculation:TravelAttrByStageID(self.stage_id)
    self.lifeAddNum:setColor(color1)
    self.lifeAddNum:setString("生命＋"..roundAttriNum(attr.hp))
    self.attackAddNum:setColor(color2)
    self.attackAddNum:setString("攻击＋"..roundAttriNum(attr.atk))
    self.physicAddNum:setColor(color3)
    self.physicAddNum:setString("物防＋"..roundAttriNum(attr.physicalDef))
    self.magicAddNum:setColor(color4)
    self.magicAddNum:setString("魔防＋"..roundAttriNum(attr.magicDef))
    
end

function PVTravelFengwuzhi:updateZhiShow(selectIndex, selectIndex2)

    if selectIndex2 == 1 then self.travelHuaJuan:setVisible(false) end
    if selectIndex2 ~= 1 then self.travelHuaJuan:setVisible(true) end
     
    
    local languageId = self.c_TravelTemplate:getTravelItemByDetailID(selectIndex)
    self.peopleTitleLabel:setString(languageId)
    local languagedescription = self.c_TravelTemplate:getDiscriptionByDetailID(selectIndex)
    local a = string.gsub( tostring(languagedescription) ,"\\n","\n")
    self.zhiDesLabel:setString(a)
 
    self.c_TravelData:setBigFengPng(self.icon, selectIndex)

end

function PVTravelFengwuzhi:initTouchListener()
    --退出
    local function onCloseClick()
        getAudioManager():playEffectButton2()
        self:onHideView()
    end
    local function menuClickA()
        getAudioManager():playEffectButton2()
        self:updateMenuIndex(1)
    end

    local function menuClickB()
        getAudioManager():playEffectButton2()
        self:updateMenuIndex(2)
    end

    local function menuClickC()
        getAudioManager():playEffectButton2()
        self:updateMenuIndex(3)
    end

    local function menuClickD()
        getAudioManager():playEffectButton2()
        self:updateMenuIndex(4)
    end
    self.UITravelFengwuzhiView["UITravelFengwuzhiView"] = {}
    self.UITravelFengwuzhiView["UITravelFengwuzhiView"]["onCloseClick"] = onCloseClick
    self.UITravelFengwuzhiView["UITravelFengwuzhiView"]["menuClickA"] = menuClickA
    self.UITravelFengwuzhiView["UITravelFengwuzhiView"]["menuClickB"] = menuClickB
    self.UITravelFengwuzhiView["UITravelFengwuzhiView"]["menuClickC"] = menuClickC
    self.UITravelFengwuzhiView["UITravelFengwuzhiView"]["menuClickD"] = menuClickD
end

function PVTravelFengwuzhi:updateMenuIndex( index )
    -- for i=1,4 do
    --     if i == index then
    --         self.imgSelect[i]:setVisible(true)
    --         self.imgNormal[i]:setVisible(false)
    --     else
    --         self.imgSelect[i]:setVisible(false)
    --         self.imgNormal[i]:setVisible(true)
    --     end
    -- end
    self:onSlidingMenuChange(index)
end
--tab点击
function PVTravelFengwuzhi:onSlidingMenuChange(state)
    self:onMenuChange(state)

    self.current_type = state
    for k,v in pairs(self.menuTable) do
        if k == state then
            v:setEnabled(false)
        else
            v:setEnabled(true)
        end
    end

    self.curTab = state

    -- self.tableViewPeople:setContentOffset(self.tableViewPeople:minContainerOffset())
    -- self.tableViewPeople:reloadData()
    -- self.tableViewPeople:setVisible(true)
    -- self:tableViewItemAction(self.tableViewPeople)

    self.listLayer:removeAllChildren()
    self:initTableview()
    local nowTableView = self.tableViewPeopleList[self.curTab]
    
    self.listLayer:removeChildByTag(999)
    local scrBar = PVScrollBar:new()
    scrBar:setTag(999)
    scrBar:init(nowTableView,1)
    scrBar:setPosition(cc.p(self.layerSize.width,self.layerSize.height/2))
    self.listLayer:addChild(scrBar,2)

    nowTableView:reloadData()
    if self.doTableViewAction then
        self:tableViewItemAction(nowTableView)
    else
        self:resetTabviewContentOffset(nowTableView)
        self.doTableViewAction = true
    end
end

--tab点击
function PVTravelFengwuzhi:onMenuChange(state)
    if state == 1 then 
        self.peopleSprite:setVisible(false)
        self.peopleSprite2:setVisible(true)
        self.shenglingSprite:setVisible(true)
        self.shenglingSprite2:setVisible(false)
        self.fengjingSprite:setVisible(true)
        self.fengjingSprite2:setVisible(false)
        self.qiwuSprite:setVisible(true)
        self.qiwuSprite2:setVisible(false)
    elseif state == 2 then
        self.peopleSprite:setVisible(true)
        self.peopleSprite2:setVisible(false)
        self.shenglingSprite:setVisible(false)
        self.shenglingSprite2:setVisible(true)
        self.fengjingSprite:setVisible(true)
        self.fengjingSprite2:setVisible(false)
        self.qiwuSprite:setVisible(true)
        self.qiwuSprite2:setVisible(false)
    elseif state == 3 then
        self.peopleSprite:setVisible(true)
        self.peopleSprite2:setVisible(false)
        self.shenglingSprite:setVisible(true)
        self.shenglingSprite2:setVisible(false)
        self.fengjingSprite:setVisible(false)
        self.fengjingSprite2:setVisible(true)
        self.qiwuSprite:setVisible(true)
        self.qiwuSprite2:setVisible(false)
    elseif state == 4 then
        self.peopleSprite:setVisible(true)
        self.peopleSprite2:setVisible(false)
        self.shenglingSprite:setVisible(true)
        self.shenglingSprite2:setVisible(false)
        self.fengjingSprite:setVisible(true)
        self.fengjingSprite2:setVisible(false)
        self.qiwuSprite:setVisible(false)
        self.qiwuSprite2:setVisible(true)

    end
end

--风物志 组
function PVTravelFengwuzhi:initMemberCellData(id,groupid,fengwuzhiContentLayer)
    --id属于哪组风物志  groupid组号
    -- self.tabelItemList[] = fen
    local zhiList = self.peopleZhiList
    local zhiNumber = self.peopleZhiNumber
    if id == 1 then zhiList = self.peopleZhiList zhiNumber = self.peopleZhiNumber end
    if id == 2 then zhiList = self.lifeZhiList zhiNumber = self.lifeZhiNumber end
    if id == 3 then zhiList = self.fengZhiList zhiNumber = self.fengZhiNumber end
    if id == 4 then zhiList = self.qiZhiList zhiNumber = self.qiZhiNumber end
    local tableThis = {}
    local tableNum = 0
    for i=1, zhiNumber do
        local a = zhiList[i-1]
        if self.c_TravelTemplate:getItemGroupByDetailID(a) == groupid then
            tableNum = tableNum + 1
            tableThis[tableNum] = zhiList[i-1]
        end
    end

    function tableCellTouched(table, cell)
        self.clickIndex = tableThis[cell:getIdx()+1]
        self.curId = id
        self.touchEvent = true
        print("--self.touchEvent------")
        -- getAudioManager():playEffectButton2()
        -- getOtherModule():showOtherView("PVTravelFengwuzhiShow",tableThis[cell:getIdx()+1],id)

    end

    function cellSizeForTable(table, idx)

        return 98, 130
    end


    function tableCellAtIndex(tabl, idx)
        cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA4444)
        local curCell = tabl:dequeueCell()
        --if nil == curCell then
            curCell = cc.TableViewCell:new()
            local proxy = cc.CCBProxy:create()
            curCell.cardinfo = {}
            curCell.cardinfo["UITravelZhiItem"] = {}
            local node = CCBReaderLoad("travel/ui_travel_fengwuzhi_zhi.ccbi", proxy, curCell.cardinfo)
            curCell:addChild(node)

        --end
        local nameLabel = curCell.cardinfo["UITravelZhiItem"]["zhiNameLabel"]
        local heroSprite = curCell.cardinfo["UITravelZhiItem"]["heroSprite"]
        -- local peopleVisible = curCell.cardinfo["UITravelZhiItem"]["peopleVisible"]

        local newSp = curCell.cardinfo["UITravelZhiItem"]["newSp"]

        
        print("-----------------------"..idx)
        if self.c_TravelData:isHaveRedPointZhi(tableThis[idx+1]) == true then
            newSp:setVisible(true)
            self.c_TravelData:removeFromNewFengWuZhi(tableThis[idx+1])
            self:initRedPoints()
        else
            newSp:setVisible(false)
        end
        
        -- if id == 1 then peopleVisible:setVisible(true) end
        -- if id ~= 1 then peopleVisible:setVisible(false) end

        local languageName = self.c_TravelTemplate:getTravelItemByDetailID(tableThis[idx+1])
        local pathImg = self.c_TravelTemplate:getResIconByeventID(tableThis[idx+1])
        -- print("pathImg.........",pathImg)
        -- game:setSpriteFrame( heroSprite, pathImg)
        nameLabel:setString( languageName )

        local dropItem = self.c_TravelTemplate:getItemByDetailID(tableThis[idx+1])
        local _type = dropItem.type
        local quality = dropItem.quality

        local color = ui.COLOR_GREEN
        if quality == 1 then
            color = ui.COLOR_WHITE
        elseif quality == 2 then
            color = ui.COLOR_GREEN
        elseif quality == 3 or quality == 4 then
            color = ui.COLOR_BLUE
        elseif quality == 5 or quality == 6 then
            color = ui.COLOR_PURPLE
        end

        nameLabel:setColor(color)


        -- print("=====tableThis======")
        -- table.print(tableThis)
        -- 更改风物志图标
        local _type = self.c_TravelData:changeFengIconImage(heroSprite, tableThis[idx+1], true, true)
        
        cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA8888)
        return curCell
    end

    function numberOfCellsInTableView(tabl)
        self.touchEvent = false
        return tableNum
    end


    local itemLayer = fengwuzhiContentLayer

    local layerSize2 = itemLayer:getContentSize()
    
    -- if self.memberTableView ~= nil then
    --     self.memberTableView:removeFromParent()
    -- end

    self.memberTableView = cc.TableView:create(cc.size(layerSize2.width, layerSize2.height))
    self.memberTableView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    self.memberTableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.memberTableView:setPosition(cc.p(0, 0))
    self.memberTableView:setDelegate()
    itemLayer:addChild(self.memberTableView)

    self.memberTableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.memberTableView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
    self.memberTableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.memberTableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.memberTableView:reloadData()
end

--创建人物志列表
function PVTravelFengwuzhi:initTableview()

    local function tableCellTouchedPeople(tbl, cell)
        if self.touchEvent and self.clickIndex ~= nil then
            -- getAudioManager():playEffectButton2()
            -- getOtherModule():showOtherView("PVTravelFengwuzhiShow",self.clickIndex,self.curId)
            print(" 人物志  : " .. cell:getIdx())
            self:updateZhiShow(self.clickIndex,self.curId)
        end
    end

    local function numberOfCellsInTableViewPeople(tab)
        self.touchEvent = false
        if self.curTab == 1 then
            return self.peopleZhiGroupNumber

        elseif self.curTab == 2 then

            return self.lifeZhiGroupNumber
        elseif self.curTab == 3 then

            return self.fengZhiGroupNumber
        elseif self.curTab == 4 then

            return self.qiZhiGroupNumber
        end
    end

    local function cellSizeForTablePeople(tbl, idx)

        return self.itemSize.height,self.itemSize.width
    end

    local function tableCellAtIndexPeople(tbl, idx)
        local cell = tbl:dequeueCell()
        if nil == cell then
            cell = cc.TableViewCell:new()
            cell.cardinfo = {}
            local proxy = cc.CCBProxy:create()
            cell.cardinfo["UITravelFengwuzhiItem"] = {}
            local node = CCBReaderLoad("travel/ui_travel_fengwuzhi_item.ccbi", proxy, cell.cardinfo)
            cell.fengwuzhiContentLayer = cell.cardinfo["UITravelFengwuzhiItem"]["fengwuzhiContentLayer"]
            cell.desLabel = cell.cardinfo["UITravelFengwuzhiItem"]["desLabel"]
            cell:addChild(node)
        end

        if nil ~= cell.fengwuzhiContentLayer then
            cell.fengwuzhiContentLayer:removeAllChildren()
        end

        local str = ""

        if self.curTab == 1 then
            self:initMemberCellData(1, self.peopleZhiGroup[idx+1], cell.fengwuzhiContentLayer)
            str = self.c_TravelTemplate:getAddByeventID(self.peopleZhiGroup[idx+1])
        elseif self.curTab == 2 then
            self:initMemberCellData(2,self.lifeZhiGroup[idx+1],cell.fengwuzhiContentLayer)
            str = self.c_TravelTemplate:getAddByeventID(self.lifeZhiGroup[idx+1])
        elseif self.curTab == 3 then
            self:initMemberCellData(3,self.fengZhiGroup[idx+1],cell.fengwuzhiContentLayer)
            str = self.c_TravelTemplate:getAddByeventID(self.fengZhiGroup[idx+1])
        elseif self.curTab == 4 then
            self:initMemberCellData(4,self.qiZhiGroup[idx+1],cell.fengwuzhiContentLayer)
            str = self.c_TravelTemplate:getAddByeventID(self.qiZhiGroup[idx+1])
        end

        cell.desLabel:setString(str)

        cell.index = idx

        return cell
    end

    self.tableViewPeople = cc.TableView:create(self.layerSize)

    self.tableViewPeople:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.tableViewPeople:setDelegate()
    self.tableViewPeople:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.listLayer:addChild(self.tableViewPeople)
    self.tableViewPeople:registerScriptHandler(function(table) return numberOfCellsInTableViewPeople(table) end , cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.tableViewPeople:registerScriptHandler(function(table, cell) tableCellTouchedPeople(table, cell) end , cc.TABLECELL_TOUCHED)
    self.tableViewPeople:registerScriptHandler(function(table, idx) return cellSizeForTablePeople(table, idx) end , cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableViewPeople:registerScriptHandler(function(table, idx) return tableCellAtIndexPeople(table, idx) end , cc.TABLECELL_SIZE_AT_INDEX)
    self.tableViewPeopleList[self.curTab] = self.tableViewPeople
end

function PVTravelFengwuzhi:onReloadView()
end

function PVTravelFengwuzhi:onExit()
    --self:unregisterScriptHandler()
    --game.removeSpriteFramesWithFile("res/ccb/resource/ui_travel.plist")
end

return PVTravelFengwuzhi

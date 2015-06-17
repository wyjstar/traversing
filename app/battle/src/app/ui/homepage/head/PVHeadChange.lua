-- 
-- UPDATE_ON_ID = "UPDATE_ON_ID"

local PVHeadHead = import(".PVHeadHead")


local PVHeadChange = class("PVHeadChange", BaseUIView)

function PVHeadChange:ctor(id)
    PVHeadChange.super.ctor(self, id)
end

function PVHeadChange:onMVCEnter()
    print("++++++++++++++++++++++++++++++++++++++++")
    
    self.head_id = nil
   
 	self.ccbiNode = {}
  
	self:initTouchListener()

    self:loadCCBI("head/ui_head_change.ccbi", self.ccbiNode)
    
    self:initData()
    self:initView()
    self:initScrollViewContent()

    self:initRegisterNetCallBack()
    self:initScrollViewTouchEvent()
end


function PVHeadChange:initData()

    local soldierDataAll = getDataManager():getCommonData():getHeadList()
    -- print("=================== self.soldierDataAll ===================")
    -- table.print(soldierDataAll)
    self.soldierData = {}
    for k,v in pairs(soldierDataAll) do
        -- local heropb = getDataManager():getLineupData():getSlotItemBySeat(1)
        local heroNo = getDataManager():getCommonData():getHead()
        if heroNo ~= nil then
            -- local heroNo = heropb.hero.hero_no
            if v ~= heroNo then
                local quality = getTemplateManager():getSoldierTemplate():getHeroQuality(v)
                if  quality == 5 or quality == 6 then
                    -- self.soldierData[table.nums(self.soldierData)+1] = v
                    table.insert(self.soldierData, v) 
                end
            end
        end
    end
end

function PVHeadChange:initView()

    self.conLayer = self.ccbiNode["UIHeadChange"]["conLayer"]

    self.scrollView = cc.ScrollView:create()
    local screenSize = self.conLayer:getContentSize()
    if nil ~= self.scrollView then
        self.scrollView:setViewSize(cc.size(screenSize.width, screenSize.height))
        self.scrollView:ignoreAnchorPointForPosition(true)
        self.scrollView:setDirection(1)
        self.scrollView:setClippingToBounds(true)
        self.scrollView:setBounceable(true)
        self.scrollView:setDelegate()
    end
    self.conLayer:addChild(self.scrollView)

end

function PVHeadChange:initScrollViewContent()

    local _itemCount = table.nums(self.soldierData) +1 
    local cell_width = 130
    local cell_height = 130
    local m_cloum = 4

    local _containerSize = 0

    if _itemCount%4 >0 then
        _containerSize = (math.floor(_itemCount/4)+1) * cell_height
    else
        _containerSize = (math.floor(_itemCount/4)) * cell_height
    end

    self.scrollView:setContentSize(self.scrollView:getViewSize().width, _containerSize)
    self.scrollView:setContentOffset(cc.p(0, self.scrollView:minContainerOffset().y))

    for i=1, _itemCount do
        local cell = PVHeadHead.new()
        if i == 1 then 
            -- local heropb = getDataManager():getLineupData():getSlotItemBySeat(1)
            local heroNo = getDataManager():getCommonData():getHead()
            cell.id = heroNo
            if heroNo ~= nil then
                -- local heroNo = heropb.hero.hero_no
                cell:initData(heroNo, self)
            end
        else
            cell:initData(self.soldierData[i-1], self)
        end

        
        cell:setAnchorPoint(cc.p(0, 0))
        cell:setContentSize(cell_width, cell_height)
        local _x = i-1
 
        local rowIndex = _x%m_cloum;
        local indexPath = math.floor(_x/m_cloum)

        local _posx = rowIndex * cell_width
        local _posy = _containerSize - (indexPath+1)*cell_height

        cell:setPosition(_posx, _posy)
        self.scrollView:getContainer():addChild(cell)
    end

end

function PVHeadChange:initScrollViewTouchEvent()
    -- print("-------------initScrollViewTouchEvent-----------------")

    -- local rectArea = self.conLayer:getBoundingBox() 
    local rectArea = cc.rect(0, 0, self.conLayer:getContentSize().width, self.conLayer:getContentSize().height)
    local _isMoving =  false
    local _startPos = cc.p(0, 0)

    local function onTouchEvent(eventType, x, y)
        if eventType == "began" then
            _startPos = cc.p(x,y)
            local _point = self.conLayer:convertToNodeSpace(_startPos)
            local isInRect = cc.rectContainsPoint(rectArea, _point)
            if isInRect then
                self.curCellItem = self:inTouchSide(cc.p(x, y))
                if self.curCellItem then
                    return true
                else
                    return false
                end
            else
                -- print("=onTouchEvent==false")
                return false
            end

        elseif  eventType == "moved" then
            local _pox = _startPos.x - x
            local _poy = _startPos.y - y

            if math.abs(_pox)>5.0 or math.abs(_poy)>5.0 then
                _isMoving = true
            end
        elseif  eventType == "ended" then
            if not _isMoving and self.curCellItem ~= nil then
                -- self:touchEventFunc()

                self:setHeadId(self.curCellItem.id)
                getNetManager():getHeadNet():sendChangeHead(self.curCellItem.id)
            end
            _isMoving = false
        end
    end

    self.conLayer:registerScriptTouchHandler(onTouchEvent)
    self.conLayer:setTouchMode(cc.TOUCHES_ONE_BY_ONE)
    self.conLayer:setTouchEnabled(true)
end

function PVHeadChange:inTouchSide(point)
    local _children = self.scrollView:getContainer():getChildren()

    for k,v in pairs(_children) do
        
        local _point = v:convertToNodeSpace(point)

        local posx, posy = v:getPosition()
        local rectArea = cc.rect(0, 0, v:getContentSize().width, v:getContentSize().height)

        local isInRect = cc.rectContainsPoint(rectArea, _point)
        
        if isInRect then
            return v
        end
    end

    return nil
end

function PVHeadChange:setHeadId(id)
    self.head_id = id
end

function PVHeadChange:update_headImg(data)
    if not self:handelCommonResResult(data.res) then
        -- self:toastShow("更换头像失败")
        getOtherModule():showAlertDialog(nil, Localize.query("PVHeadChange.1"))
        return
    end

    print("更换头像成功")

    getDataManager():getCommonData():setHead(self.head_id)

    local event = cc.EventCustom:new(UPDATE_HEAD)
    self:getEventDispatcher():dispatchEvent(event)
    

    local _children = self.scrollView:getContainer():getChildren()
    for k,v in pairs(_children) do
        v:updateUI()
    end
end

function PVHeadChange:initTouchListener()

    local function onCloseClick()
        getAudioManager():playEffectButton2()
        self:onHideView()
    end
 
    self.ccbiNode["UIHeadChange"] = {}
    self.ccbiNode["UIHeadChange"]["onCloseClick"] = onCloseClick
end

--网络返回
function PVHeadChange:initRegisterNetCallBack()
    local function onReciveMsgCallBack(_id, data)
        if _id == NET_ID_HEAD_CHANGE then  self:update_headImg(data)   end 
    end

    self:registerMsg(NET_ID_HEAD_CHANGE, onReciveMsgCallBack)
end


return PVHeadChange

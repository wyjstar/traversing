--旋转菜单

local CustomRotateMenu = class("CustomRotateMenu")

local animationDuration = 0.3
local PI = math.pi
local sharedScheduler = cc.Director:getInstance():getScheduler()

--[[--
构造方法
@param Layer contentLayer 控件所在的layer
@param table params 控制参数
    - xRatio x半轴长度与contentLayer宽度的比值 默认 0.33
    - yRatio y半轴长度与contentLayer高度度比值 默认 0.01
]]
function CustomRotateMenu:ctor(contentLayer, params)
  	self.contentLayer = contentLayer
    assert(self.contentLayer, "ERROR: you must be set contentLayer when create CustomRotateMenu")
  	self.angle = 0
    self.unitAngle = 0
    self.touchEnabled = true 
    self.itemsTable = {}
    self.selectedItem = nil
    self.delegate = nil

    params = params or {}
    local xRatio = params.xRatio or 0.33
    local yRatio = params.yRatio or 0.01
    local menuSize = self.contentLayer:getContentSize()
    self.disX = menuSize.width * xRatio
    self.disY = menuSize.height * yRatio
    print("CustomRotateMenu:ctor", self.disX, self.disY)

    self:init()
  	self:addLayerTouchEvent()
end

function CustomRotateMenu:setDelegate(delegate_)
    self.delegate = delegate_
end

function CustomRotateMenu:setTouchEnabled(enabled)
    self.touchEnabled = enabled
end

function CustomRotateMenu:addMenuItem(menuItem)
    self.itemsTable[#self.itemsTable+1] = menuItem
end

function CustomRotateMenu:reloadData()
    if #self.itemsTable > 0 then
        self.unitAngle = 2*PI / table.nums(self.itemsTable)
        for k,v in pairs(self.itemsTable) do
            v:setPosition(cc.p(self.contentLayer:getContentSize().width / 2,self.contentLayer:getContentSize().height / 2))
            self.contentLayer:addChild(v)
            self:reset()
            self:updatePosition()
        end
    end
end

function CustomRotateMenu:updatePosition()
  	local menuSize = self.contentLayer:getContentSize()
  	for k,v in pairs(self.itemsTable) do
    		local x = menuSize.width / 2 + self.disX * math.sin((k) * self.unitAngle + self.angle)
    		local y = menuSize.height / 2 - self.disY * math.cos((k) * self.unitAngle + self.angle)
    		v:setPosition(x,y)
    		v:setLocalZOrder(-y)
    		v:setOpacity(192 + 63 * math.cos(k*self.unitAngle + self.angle))
    		v:setScale(0.75 + 0.25 * math.cos(k*self.unitAngle + self.angle))
        if #v:getChildren() > 0 then
            for k_,v_ in pairs(v:getChildren()) do
                v_:setOpacity(192 + 63 * math.cos(k*self.unitAngle + self.angle))
            end
        end
  	end
end

function CustomRotateMenu:updatePositionWithAnimation()
    for k,v in pairs(self.itemsTable) do
        v:stopAllActions()
    end
    local menuSize = self.contentLayer:getContentSize()
    for k,v in pairs(self.itemsTable) do
        local x = menuSize.width / 2 + self.disX*math.sin((k)*self.unitAngle + self.angle)
        local y = menuSize.height / 2 - self.disY*math.cos((k)*self.unitAngle + self.angle)
        local moveTo = cc.MoveTo:create(animationDuration, cc.p(x, y))
        v:runAction(moveTo)
        local fadeTo = cc.FadeTo:create(animationDuration, (192 + 63 * math.cos(k*self.unitAngle + self.angle)))
        v:runAction(fadeTo)

        if #v:getChildren() > 0 then
            for k_,v_ in pairs(v:getChildren()) do
                v_:runAction(fadeTo:clone())
            end
        end

        local scaleTo = cc.ScaleTo:create(animationDuration, 0.75 + 0.25*math.cos(k*self.unitAngle + self.angle))
        v:runAction(scaleTo)
        v:setLocalZOrder(-y)
    end

    self.delayTimer = timer.delayGlobal(function()
        self:rotateDidEnd()
    end,animationDuration)

end

function CustomRotateMenu:clear()
    print("unscheduleGlobal delayTimer")
    if self.delayTimer then
        timer.unscheduleGlobal(self.delayTimer)
    end
end

function CustomRotateMenu:rectify(forward)
    -- body
     local angle = self.angle
      while (angle<0)
      do
        angle = angle + PI * 2
      end

      while (angle>PI * 2)
      do
          angle = angle - PI * 2
      end
      if forward then
        angle = (math.floor((angle + self.unitAngle / 3*2) / self.unitAngle)*self.unitAngle)
      else
        angle = (math.floor((angle + self.unitAngle / 3 ) / self.unitAngle)*self.unitAngle)
      end
      self.angle = angle

end

function CustomRotateMenu:init()

end

function CustomRotateMenu:reset()
    self.angle = 0
end

function CustomRotateMenu:setAngle(angle)
    self.angle = angle
    self:rectify(true)
    self:updatePosition()
end

function CustomRotateMenu:setCurrentIndex(idx)
    self:setAngle((idx-1)*self.unitAngle)
end

function CustomRotateMenu:addLayerTouchEvent()
    local function onTouchBegan(touch, event)
        if self.touchEnabled == false then return false end
        for k,v in pairs(self.itemsTable) do
            v:stopAllActions()
        end
     
        local target = event:getCurrentTarget() 
        local locationInNode = target:convertToNodeSpace(touch:getLocation())
        local s = target:getContentSize()
        local rect = cc.rect(0, 0, s.width, s.height) 
        if cc.rectContainsPoint(rect, locationInNode) then
            return true
        end
        return false
    end

    local function onTouchMoved(touch, event)
        local angle = self:disToAngle(touch:getDelta().x)
        if getNewGManager():getCurrentGid() == GuideId.G_GUIDE_50059 then
            if touch:getDelta().x <= 0 then return end
        end
        self.angle = self.angle + angle
        self:updatePosition()
        if self.delegate.rotateTouchMovedEvent then
            self.delegate:rotateTouchMovedEvent()
        end
    end
    local function onTouchEnded(touch, event)
        local xDelta = touch:getLocation().x - touch:getStartLocation().x
        if getNewGManager():getCurrentGid() == GuideId.G_GUIDE_50059 then
            if xDelta<=0 then return end
        end
        self:rectify(xDelta>0)
        self:updatePositionWithAnimation()
    end
     
    local listener = cc.EventListenerTouchOneByOne:create() 
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(onTouchMoved, cc.Handler.EVENT_TOUCH_MOVED)
    listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)
     
    local eventDispatcher = self.contentLayer:getEventDispatcher() 
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self.contentLayer) 
end

function CustomRotateMenu:disToAngle(dis)
    local width = self.contentLayer:getContentSize().width / 2;
    return dis / width*self.unitAngle
end
  
function CustomRotateMenu:getCurrentIndex()
    if (#self.itemsTable == 0) then
        return nil
    end
    -- local index = math.floor((2 * PI - self.angle) / self.unitAngle+0.1*self.unitAngle)
    local index = math.floor(self.angle / self.unitAngle+0.1*self.unitAngle)
    
    index = index % #self.itemsTable -- 取得以0开头的真实序号(可能出现值为数组长度的index)

    return #self.itemsTable - index -- 取得与self.itemsTable中一致的编号(从1开头)     注:self.itemsTable中编号较小的item,index值更大
end

function CustomRotateMenu:getCurrentItem()
    return self.itemsTable[self:getCurrentIndex()]
end

function CustomRotateMenu:getAllItems()
    return self.itemsTable
end

function CustomRotateMenu:rotateDidEnd()
    if self.delegate then
      self.delegate:rotateDidEnd()
    end
end

return CustomRotateMenu

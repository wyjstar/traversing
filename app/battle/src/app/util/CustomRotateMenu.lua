--旋转菜单

local CustomRotateMenu = class("CustomRotateMenu")

local animationDuration = 0.3
local PI = math.pi
local sharedScheduler = cc.Director:getInstance():getScheduler()

function CustomRotateMenu:ctor(contentLayer)
  	self.contentLayer = contentLayer
  	self.angle = 0
    self.unitAngle = 0
    self.touchEnabled = true 
    self.itemsTable = {}
    self.selectedItem = nil
    self.delegate = nil
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
	  table.insert(self.itemsTable,menuItem)
end

function CustomRotateMenu:reloadData()
    if #self.itemsTable > 0 then
        self.unitAngle = 2*PI / table.getn(self.itemsTable)
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
  	local disY = menuSize.height / 8
  	local disX = menuSize.width / 3
  	for k,v in pairs(self.itemsTable) do
    		local x = menuSize.width / 2 + disX * math.sin((k) * self.unitAngle + self.angle)
    		local y = menuSize.height / 2 - disY * math.cos((k) * self.unitAngle + self.angle)
    		v:setPosition(x,y)
    		v:setLocalZOrder(-y)
    		v:setOpacity(192 + 63 * math.cos(k*self.unitAngle + self.angle))
    		v:setScale(0.85 + 0.15 * math.cos(k*self.unitAngle + self.angle))
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
    local disY = menuSize.height / 8
    local disX = menuSize.width / 3
    for k,v in pairs(self.itemsTable) do
        local x = menuSize.width / 2 + disX*math.sin((k)*self.unitAngle + self.angle)
        local y = menuSize.height / 2 - disY*math.cos((k)*self.unitAngle + self.angle)
        local moveTo = cc.MoveTo:create(animationDuration, cc.p(x, y))
        v:runAction(moveTo)
        local fadeTo = cc.FadeTo:create(animationDuration, (192 + 63 * math.cos(k*self.unitAngle + self.angle)))
        v:runAction(fadeTo)

        if #v:getChildren() > 0 then
            for k_,v_ in pairs(v:getChildren()) do
                v_:runAction(fadeTo:clone())
            end
        end

        local scaleTo = cc.ScaleTo:create(animationDuration, 0.85 + 0.15*math.cos(k*self.unitAngle + self.angle))
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
    local index = math.floor((2 * PI - self.angle) / self.unitAngle+0.1*self.unitAngle)
    return index % #self.itemsTable + 1
end

function CustomRotateMenu:rotateDidEnd()
    if self.delegate then
      self.delegate:rotateDidEnd()
    end
end

return CustomRotateMenu

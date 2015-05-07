local NewbieGuide = class("NewbieGuide", BaseUIView)

function NewbieGuide:ctor(id)
    self.super.ctor(self, id)
end

function NewbieGuide:onMVCEnter()

    local sharedDirector = cc.Director:getInstance()
    local glsize = sharedDirector:getWinSize()
    self.clipNode = cc.ClippingNode:create()
    self:addChild(self.clipNode, 1)

    self.colorLayer = game.newColorLayer(cc.c4b(0, 0, 0, 180))
    self.clipNode:addChild(self.colorLayer)

    -- self.stencil = game.newSprite(self.funcTable[1])
    -- self.stencil:setPosition(cc.p(glsize.width / 2, glsize.height /  2))
    -- self.clipNode:setStencil(self.stencil)

    -- self.touchLayer = game.newLayer()
    -- self.touchLayer:setContentSize(self.stencil:getContentSize())
    -- self.touchLayer:setPosition(cc.p(glsize.width / 2, glsize.height /  2))
    -- self.clipNode:addChild(self.touchLayer)

    self.nodef = game.newLayer()
    self.touchSprite = game.newSprite(self.funcTable[1])
    self.nodef:addChild(self.touchSprite)
    self.nodef:setPosition(cc.p(glsize.width / 2, glsize.height /  2))
    self.clipNode:setStencil(self.nodef)

    self.clipNode:setInverted(true)

    self.shieldlayer:setTouchEnabled(true)
    self:registerTouchEvent()
end

function NewbieGuide:registerTouchEvent()
    -- local posX, posY = self.touchLayer:getPosition()
    -- local size = self.touchLayer:getContentSize()
    -- local touchArea = cc.rect(posX - (size.width / 2), posY - (size.height / 2), size.width, size.height)
    -- local function onTouchEvent(eventType, x, y)
    --     local isInRect = cc.rectContainsPoint(touchArea, cc.p(x, y))
    --     if  eventType == "began" then
    --         if isInRect then
    --             self:onHideView()
    --             return false
    --         end
    --         return true
    --     elseif  eventType == "ended" then
    --     end
    -- end
    -- self.touchLayer:registerScriptTouchHandler(onTouchEvent)
    -- self.touchLayer:setTouchMode(cc.TOUCHES_ONE_BY_ONE)
    -- self.touchLayer:setTouchEnabled(true)
end

return NewbieGuide

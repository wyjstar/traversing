
local PVBackground = class("PVBackground", mvc.ViewBase)

function PVBackground:ctor(id)
    PVBackground.super.ctor(self, id)
end

function PVBackground:onMVCEnter()
    self.bg = mvc.ViewLayer()

    local function onEnter()
        self.bg:setAccelerometerEnabled(true)

        local function accelerometerListener(event, x, y, z, timestamp)
            local target  = event:getCurrentTarget()
            local ballSize = target:getContentSize()
            local ptNowX,ptNowY    = target:getPosition()
            ptNowX = ptNowX + x * 9.81
            ptNowY = ptNowY + y * 9.81

            target:setPosition(cc.p(ptNowX , ptNowY))
        end

        local listerner  = cc.EventListenerAcceleration:create(accelerometerListener)
        self.bg:getEventDispatcher():addEventListenerWithSceneGraphPriority(listerner, self.bg)
    end

    local function onExit()
        self.bg:setAccelerometerEnabled(false)
    end

    local function onNodeEvent(event)
        if "enter" == event then
            onEnter()
        elseif "exit" == event then
            onExit()
        end
    end

    self.bg:registerScriptHandler(onNodeEvent)

    self:addChild(self.bg)
end

return PVBackground

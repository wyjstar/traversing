
local PVNetLoading = class("PVNetLoading", BaseUIView)

function PVNetLoading:ctor(id)
    self.super.ctor(self, id)
--    self.loading ＝ nil
end

function PVNetLoading:onMVCEnter()
    
    self.shieldlayer:setTouchEnabled(true)
    self.adapterLayer:setTouchEnabled(true)

    self:showLoading()

end

function PVNetLoading:showLoading()

    self.loading = cc.Sprite:createWithSpriteFrameName("refresh01.png")
    self.loading:setPosition(self.adapterLayer:getContentSize().width/2, self.adapterLayer:getContentSize().height/2)
    self:addToUIChild(self.loading)

    local animation = cc.Animation:create()
    local number, name
    for i = 1, 25 do
        
        name = string.format("#refresh%02d.png", i)
        animation:addSpriteFrameWithFile(name)
    end

    animation:setDelayPerUnit(1/12.0)

    local action = cc.Animate:create(animation)
    self.loading:runAction(cc.RepeatForever:create(action))
end

function PVNetLoading:removeLoading()

    self:removeFromParent()
end

return PVNetLoading

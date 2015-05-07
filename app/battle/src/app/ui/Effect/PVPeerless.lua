
local PVPeerless = class("PVPeerless", BaseUIView)

function PVPeerless:ctor(id)
    PVPeerless.super.ctor(self, id)

end

function PVPeerless:onMVCEnter()
    self:initView()
end

function PVPeerless:initView()
    self.UIAniView = {}

    -- self:loadCCBI("effect/ui_wushuang.ccbi", self.UIAniView)

    -- self.rightGuangBG = self.UIAniView["UIAniView"]["rightGuangBG"]
    -- self.rightMask1 = self.UIAniView["UIAniView"]["rightMask1"]
    -- self.rightHero1 = self.UIAniView["UIAniView"]["rightHero1"]
    -- self.rightHero1:setVisible(false)

    -- self.rightMask1:setVisible(false)
    -- self



    local size = self.adapterLayer:getContentSize()

    local bg = game.newSprite("#ui_ws_b_left.png")
    bg:setPosition( cc.p(size.width / 2, size.height / 2) )

    self.adapterLayer:addChild(bg)


    

    local stencil = game.newSprite("#ui_ws_b_left1.png")

    -- local stencil = game.newSprite("res/ccb/resource/ui_ws_b_left1.png")

    local clipper = cc.ClippingNode:create()
    clipper:setContentSize(stencil:getContentSize())
    clipper:setAnchorPoint(cc.p(0.5, 0.5))
    clipper:setScale(2.0)
    clipper:setPosition( cc.p(size.width / 2, size.height / 2) )
    clipper:setAlphaThreshold(0)
    
    stencil:setPosition( cc.p(clipper:getContentSize().width / 2, clipper:getContentSize().height / 2) )

    clipper:setStencil(stencil)

    clipper:addChild(stencil)

    self.adapterLayer:addChild(clipper)

    local hero = game.newSprite("res/ccb/resource/hero_10001_2.png")
    hero:setScale(2)
    hero:setPosition( cc.p(clipper:getContentSize().width / 2, clipper:getContentSize().height / 2) );

    clipper:addChild(hero);



    -- local frames = game.newFrames("guang_0%d.png", 1, 8)
    -- self.animation = game.newAnimation(frames, 0.15)
    -- self.light = mvc.ViewSprite()
    -- self.light:setPosition(0,0)

    -- self.light:runAction(cc.Animate:create(self.animation))
    -- self.light:setScaleX(2.2)
    -- self.light:setScaleY(0.95)
    -- self.effectNode:addChild(self.light)

    -- local frames2 = game.newFrames("guang_0%d.png", 1, 8)
    -- self.animation2 = game.newAnimation(frames2, 0.15)
    -- self.light2 = mvc.ViewSprite()
    -- self.light2:setPosition(0,0)

    -- self.light2:runAction(cc.Animate:create(self.animation2))
    -- self.light2:setScaleX(-2.2)
    -- self.light2:setScaleY(0.95)
    -- self.effectNode2:addChild(self.light2)




    -- self.dispareAction = cc.Sequence:create({
    --     cc.DelayTime:create(1.5),cc.CallFunc:create(function () self:onHideView() end
    --     ), nil})
    -- self:runAction(self.dispareAction)






    -- self.removeAction = cc.Sequence:create({
    --     cc.DelayTime:create(2.5),
    --     cc.CallFunc:create(function () self:onHideView() end
    --     ), nil})
    -- self:runAction(self.removeAction)
end


return PVPeerless

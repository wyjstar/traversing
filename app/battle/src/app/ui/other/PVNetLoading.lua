
local PVNetLoading = class("PVNetLoading", BaseUIView)

function PVNetLoading:ctor(id)
    print("id  =========== ", id)
    self.super.ctor(self, id)
    self.UIAniView = {}
    self._callFunc = nil

    self:initBaseUI()
end

function PVNetLoading:onMVCEnter()

    -- self.shieldlayer:setTouchEnabled(true)
    -- self.adapterLayer:setTouchEnabled(true)

    self:showLoading()

    self.netTips = getTemplateManager():getLanguageTemplate():getNetRandTips()

    local keys = {}
    for k,v in pairs(self.netTips) do
        table.insert(keys, k)
    end

    -- local randomKey = table.randomKey(keys)
    -- self.randomStr = self.netTips[randomKey].cn
    -- print("等于false  ----------- ", self.randomStr)
    -- self.tipLabel:setString(self.randomStr)

    print("updateTips ====== updateTips ========= ", isEnterGame)
    if not isEnterGame then
        local randomKey = table.randomKey(keys)
        self.randomStr = self.netTips[randomKey].cn
        print("等于false  ----------- ", self.randomStr)
        self.tipLabel:setString(self.randomStr)
    else
        local tipStr = getDataManager():getCommonData():getNetTip()
        print("设置文字 ========== isEnterGame ======== ", isEnterGame,     tipStr)
        self.tipLabel:setString(tipStr)

    end

end

function PVNetLoading:showLoading()
    print("enter showNetLoading -==========-  ")
    local s = cc.Director:getInstance():getWinSize()

    local bg_color = cc.LayerColor:create(cc.c4b(0,0,0,150))

    bg_color:setContentSize(cc.size(s.width, s.height))
    bg_color:ignoreAnchorPointForPosition(true)
    self:addChild(bg_color, -1)

    cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA4444)

    self.UIAniView["UIAniView"] = {}
    self:loadCCBI("effect/ui_load_effect.ccbi", self.UIAniView)
    self.animationManager = self.UIAniView["UIAniView"]["mAnimationManager"]
    self.animationManager:runAnimationsForSequenceNamed("showAnimation")

    self.tipLabel = self.UIAniView["UIAniView"]["tipLabel"]



    cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA8888)

    -- local function showAnimation()
    --     self.animationManager:runAnimationsForSequenceNamed("showAnimation")
    -- end

    -- local action = cc.Sequence:create(cc.DelayTime:create(2), cc.CallFunc:create(showAnimation))
    -- self:runAction(cc.RepeatForever:create(action))


    -- self.loading = cc.Sprite:createWithSpriteFrameName("refresh01.png")
    -- self.loading:setPosition(self.adapterLayer:getContentSize().width/2, self.adapterLayer:getContentSize().height/2)
    -- self:addToUIChild(self.loading)

    -- local animation = cc.Animation:create()
    -- local frame, name
    -- for i = 1, 25 do

    --     name = string.format("refresh%02d.png", i)
    --     frame = game.newSpriteFrame(name)
    --     animation:addSpriteFrame(frame)
    -- end

    -- animation:setDelayPerUnit(1/12.0)

    -- local action = cc.Animate:create(animation)
    -- self.loading:runAction(cc.RepeatForever:create(action))

    -- local function updateTips()
        -- self.netTips = getTemplateManager():getLanguageTemplate():getNetRandTips()

        -- local keys = {}
        -- for k,v in pairs(self.netTips) do
        --     table.insert(keys, k)
        -- end
        -- local randomKey = table.randomKey(keys)
        -- self.randomStr = self.netTips[randomKey].cn
        -- print("updateTips ====== updateTips ========= ", self.randomStr)
        -- self.tipLabel:setString(self.randomStr)
    -- end
    -- print("updateTips ====== updateTips ========= ", self.randomStr)

    -- local action = cc.Sequence:create(cc.DelayTime:create(0.2), cc.CallFunc:create(updateTips))
    -- self:runAction(cc.RepeatForever:create(action))
end

function PVNetLoading:removeLoading(_callFunc)
    print("PVNetLoading:removeLoading  ======= ")
    _callFunc()
    self:removeFromParent()
end

return PVNetLoading


local FVUnpara = class("FVUnpara", function()
    return game.newNode()
end)

function FVUnpara:ctor(id)
    self.target = nil
    self.soldierTemplate = getTemplateManager():getSoldierTemplate()
    self.process = getFCProcess()
end

function FVUnpara:initData()
    local red_unpara = self.process.red_unpara_skill
    local blue_unpara = self.process.blue_unpara_skill

    if red_unpara then
        self.unparaItem = red_unpara.unpara_info
        self.maxUnparaHeroNum = red_unpara:get_hero_num()
    end
    if blue_unpara then
        self.monsterUnparaItem = blue_unpara.unpara_info
        self.maxMUnparaHeroNum = blue_unpara:get_hero_num()
    end
end

function FVUnpara:setTarget(target)
    self.target = target
end

function FVUnpara:startUnparaView(attacker)

    local colorLayer = cc.LayerColor:create(cc.c4b(0, 0, 0, 0), 2000, 2000)
    local delayTimeAction = cc.DelayTime:create(0.1) 
    local fadeToAction = cc.FadeTo:create(0.08, 125)
    local fadeOutAction = cc.FadeOut:create(0.02)

    local delayTimeAction1 = cc.DelayTime:create(0.1)
    local delayTimeAction2 = cc.DelayTime:create(1.29)

    local function removeCallBack(sender)
        sender:removeFromParent(true)
    end

    local function loadWSCallBack()
        self:loadWSCCBI(attacker)
        local loadWsAction = cc.Sequence:create({
        cc.DelayTime:create(0.05),
        cc.CallFunc:create(function () 
            getFightScene():runSceneAction()
        end
        ), nil})
        self:runAction(loadWsAction)
    end
    local sequenceAction = cc.Sequence:create(delayTimeAction, fadeToAction, delayTimeAction2, fadeOutAction, cc.CallFunc:create(removeCallBack))
    colorLayer:runAction(sequenceAction)
    self:addChild(colorLayer)
    colorLayer:setPosition(-680, -520)
    loadWSCallBack()

    local delayAction3 = cc.DelayTime:create(0.35)
    local function shakeCallBack1()
        getFightScene():runSceneShake(2)
    end
    sequenceAction = cc.Sequence:create(delayAction3, cc.CallFunc:create(shakeCallBack1))
    self:runAction(sequenceAction)

    ---------
    local delayAction4 = cc.DelayTime:create(0.62)

    local function shakeCallBack2()
        getFightScene():runSceneShake(3)
    end

    sequenceAction = cc.Sequence:create(delayAction4, cc.CallFunc:create(shakeCallBack2))
    self:runAction(sequenceAction)

end

function FVUnpara:loadWSCCBI(attacker)
    self.UIAniView = {}
    local proxy = cc.CCBProxy:create()
    self.unparaView = CCBReaderLoad("effect/ui_wushuang.ccbi", proxy, self.UIAniView)
    self.rightNode1 = self.UIAniView["UIAniView"]["rightMask1"]

    self.leftNode1 = self.UIAniView["UIAniView"]["leftMask1"]

    self.rightNode2 = self.UIAniView["UIAniView"]["rightMask2"]

    self.rightHero1 = self.UIAniView["UIAniView"]["rightHero1"]
    self.leftHero2 = self.UIAniView["UIAniView"]["leftHero2"]
    self.rightHero2 = self.UIAniView["UIAniView"]["rightHero2"]
    
    self.nowNode3 = self.UIAniView["UIAniView"]["nowNode3"]
    local unparaItem = nil
    local heroNum = 0

    if attacker.side == "blue" then
        unparaItem = self.monsterUnparaItem
        heroNum = self.maxMUnparaHeroNum
    else
        unparaItem = self.unparaItem
        heroNum = self.maxUnparaHeroNum
    end

    local curClipper1 = self:getClipperNode(unparaItem["condition1"])
    curClipper1:setPosition(cc.p(110, 68))
    self.rightNode1:addChild(curClipper1)


    local curClipper2 = self:getClipperNode(unparaItem["condition2"])
    curClipper2:setPosition(cc.p(110, 68))
    self.leftNode1:addChild(curClipper2)

    if heroNum >= 3 then
        self.nowNode3:setVisible(true)
        self.rightNode2:setVisible(true)
        local curClipper3 = self:getClipperNode(unparaItem["condition3"])
        curClipper3:setPosition(cc.p(110, 68))
        self.rightNode2:addChild(curClipper3)
    else
        self.nowNode3:setVisible(false)
    end
    
    self.shieldlayer = game.createShieldLayer()
    self.unparaView:addChild(self.shieldlayer)
    self.shieldlayer:setTouchEnabled(true)
    self:addChild(self.unparaView)

    local hideAction = cc.Sequence:create({

    cc.DelayTime:create(1.68),
    cc.CallFunc:create(function () 
        self.shieldlayer:setTouchEnabled(false)  
        self.unparaView:removeFromParent()
        self.target:onUnparaAniOver()
    end
    ), nil})

    self:runAction(hideAction)
end

--无双添加遮罩
function FVUnpara:getClipperNode(heroId)
    local stencil = game.newSprite("#ui_ws_b_left1.png")        --遮罩层
    local clipper = cc.ClippingNode:create()

    clipper:setAnchorPoint(cc.p(0.5, 0.5))
    clipper:setScale(2)
    clipper:setAlphaThreshold(0)
    clipper:setStencil(stencil)
    clipper:addChild(stencil)


    local node = self.soldierTemplate:getHeroBigImageById(heroId)
    node:setScale(0.58)
    node:setPosition(0, -25)
    clipper:addChild(node)
    return clipper
end

return FVUnpara







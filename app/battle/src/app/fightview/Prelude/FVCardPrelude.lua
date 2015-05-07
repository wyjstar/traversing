-- 入场卡牌
local FVCardPrelude = class("FVCardPrelude", function()
    return mvc.ViewNode()
end)

function FVCardPrelude:ctor(prop)
    self.fvParticleManager = getFVParticleManager()
    local soldierTemplate = getTemplateManager():getSoldierTemplate()

    --local board = mvc.ViewSprite(string.format("#c_board%d.png", math.random(1,4)))

    self.board = soldierTemplate:getHeroBoardById(prop.no)
    -- hero
    
    self.hero = soldierTemplate:getBigImageByResName(prop.pictureName, prop.no)

    --state
    self.state = mvc.ViewBatchNode("res/card/state_all.pvr.ccz", 4)
    
    self.state.trough = mvc.ViewSprite("#c_trough.png")
    self.state.hp = mvc.ViewSprite(string.format("#c_hp%d.png", CONFIG_HP_MIN))
    self.state.mp = mvc.ViewSprite(string.format("#c_mp%d.png", CONFIG_MP_MIN))
    self.state.mp:setVisible(false)
    self.kind = soldierTemplate:getHeroKindById(prop.no)
    
    self.state.hp:setAnchorPoint(cc.p(0, 0))
    self.state.mp:setAnchorPoint(cc.p(0, 0))
    self.state.hp:setPosition(CONFIG_CARD_HP_X, CONFIG_CARD_HP_Y)
    self.state.mp:setPosition(CONFIG_CARD_MP_X, CONFIG_CARD_MP_Y)
    self.kind:setPosition(CONFIG_CARD_KIND_X, CONFIG_CARD_KIND_Y)
    self.state.trough:addChild(self.state.hp)
    self.state.trough:addChild(self.state.mp)
    self.state.trough:addChild(self.kind)
    self.kind:setVisible(false)
    self.state.trough:setPosition(CONFIG_CARD_STATE_X, CONFIG_CARD_STATE_Y)
    self.state:addChild(self.state.trough)

    --
    self:addChild(self.board)
    self:addChild(self.hero)
    self:addChild(self.state)
end

function FVCardPrelude:setCardHome(home)
    self.home = home

    self:setPosition(self.home.point)
    self:setScale(self.home.scale)
end

function FVCardPrelude:doActionPrelude()
    self:setPosition(320, 480)
    self:setScale(1)

    self.board:setPositionX(self.board:getPositionX() - 600)
    self.hero:setPositionX(self.hero:getPositionX() + 600)
    self.state:setPositionX(self.state:getPositionX() - 600)

    local frames = game.newFrames("c_hp%d.png", CONFIG_HP_MIN, CONFIG_HP_MAX, false)

    self.board:runAction(cc.Sequence:create({
        cc.EaseBackOut:create(
            cc.MoveBy:create(0.3, cc.p(600, 0))
            ),
        }))
    self.hero:runAction(cc.Sequence:create({
        cc.DelayTime:create(0.1),
        cc.EaseBackOut:create(
            cc.MoveBy:create(0.3, cc.p(-600, 0))
            ),
        }))
    self.state:runAction(cc.Sequence:create({
        cc.DelayTime:create(0.2),
        cc.EaseBackOut:create(
            cc.MoveBy:create(0.3, cc.p(600, 0))
            ),
        cc.CallFunc:create(function(state)
            local part = getFVParticleManager():make("fgblue1", 0.2, false)
            --part:setPosition(-100, -125)
            part:setPosition(-59, -115)
            self:addChild(part, 100)
        end),
        cc.DelayTime:create(0.2),
        cc.CallFunc:create(function(state) 
            self.kind:setVisible(true)
            end)
        }))

    self.state.hp:runAction(cc.Sequence:create({
        cc.DelayTime:create(0.7),
        cc.Animate:create(game.newAnimation(frames, 0.006)),
        }))

    local time = 0.2

    local spawnAction = cc.Spawn:create(

            cc.MoveTo:create(0.16, self.home.point),
            --cc.ScaleTo:create(0.1, 1.2)
            cc.Sequence:create(
                
                cc.EaseSineOut:create(cc.ScaleTo:create(0.16, 1.5)),
                cc.EaseSineInOut:create(cc.ScaleTo:create(0.04, self.home.scale))
                
                )
            
            )

    self:runAction(
        cc.Sequence:create(
            cc.DelayTime:create(0.81),
            
            cc.EaseIn:create(cc.EaseBackOut:create(spawnAction), 8)
        )
    )
end

return FVCardPrelude

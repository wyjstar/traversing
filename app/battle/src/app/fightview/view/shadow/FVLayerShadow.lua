
local FVLayerShadow = class("FVLayerShadow", mvc.ViewBase)

function FVLayerShadow:ctor(id)
    FVLayerShadow.super.ctor(self, id)

end

function FVLayerShadow:onMVCEnter()
    cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA4444)
    self.shadows = mvc.ViewBatchNode("res/card/shadow.png", 12)

    self.shadow_army = {
        [1] = mvc.ViewSprite("res/card/shadow.png"),
        [2] = mvc.ViewSprite("res/card/shadow.png"),
        [3] = mvc.ViewSprite("res/card/shadow.png"),
        [4] = mvc.ViewSprite("res/card/shadow.png"),
        [5] = mvc.ViewSprite("res/card/shadow.png"),
        [6] = mvc.ViewSprite("res/card/shadow.png"),
        [12] = mvc.ViewSprite("res/card/shadow.png"),
    }
    self.shadow_enemy = {
        [1] = mvc.ViewSprite("res/card/shadow.png"),
        [2] = mvc.ViewSprite("res/card/shadow.png"),
        [3] = mvc.ViewSprite("res/card/shadow.png"),
        [4] = mvc.ViewSprite("res/card/shadow.png"),
        [5] = mvc.ViewSprite("res/card/shadow.png"),
        [6] = mvc.ViewSprite("res/card/shadow.png"),
    }

    self.shadows:addChild(self.shadow_army[1])
    self.shadows:addChild(self.shadow_army[2])
    self.shadows:addChild(self.shadow_army[3])
    self.shadows:addChild(self.shadow_army[4])
    self.shadows:addChild(self.shadow_army[5])
    self.shadows:addChild(self.shadow_army[6])
    self.shadows:addChild(self.shadow_army[12])
    self.shadows:addChild(self.shadow_enemy[1])
    self.shadows:addChild(self.shadow_enemy[2])
    self.shadows:addChild(self.shadow_enemy[3])
    self.shadows:addChild(self.shadow_enemy[4])
    self.shadows:addChild(self.shadow_enemy[5])
    self.shadows:addChild(self.shadow_enemy[6])

    self:onShadowClean()

    self:addChild(self.shadows)

    cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA8888)

    self:listenEvent(const.EVENT_SHADOW_CLEAN, self.onShadowClean, nil)
    self:listenEvent(const.EVENT_SHADOW_SHOW, self.onShadowShow, nil)
end

function FVLayerShadow:onShadowClean()
    self.shadow_army[1]:setVisible(false)
    self.shadow_army[2]:setVisible(false)
    self.shadow_army[3]:setVisible(false)
    self.shadow_army[4]:setVisible(false)
    self.shadow_army[5]:setVisible(false)
    self.shadow_army[6]:setVisible(false)
    self.shadow_army[12]:setVisible(false)
    self.shadow_enemy[1]:setVisible(false)
    self.shadow_enemy[2]:setVisible(false)
    self.shadow_enemy[3]:setVisible(false)
    self.shadow_enemy[4]:setVisible(false)
    self.shadow_enemy[5]:setVisible(false)
    self.shadow_enemy[6]:setVisible(false)
end

function FVLayerShadow:onShadowShow(cards_army, cards_enemy)
    for seat, card in pairs(cards_army) do
        local visible = card.isVisible

        local shadow = self.shadow_army[seat]

        if visible then

            local scale = (card.scaleX + card.scaleY) / (0.45 * 2)

            shadow:setVisible(true)
            shadow:setPosition(card.x + 30 - (scale - 1) * 150, card.y + 10 - (scale - 1) * 100)
            local armyScale = 0.45 * (1 - ((scale - 1) * 0.2))
            --cclog("armyScale========" .. armyScale)
            shadow:setScale(armyScale)
            shadow:setRotation(card.rotate)
            shadow:setOpacity(128)
        else
            shadow:setVisible(false)
        end

    end

    for seat, card in pairs(cards_enemy) do
        local visible = card.isVisible
        local is_boss = card.is_boss
        local shadow = self.shadow_enemy[seat]
        if visible then
            local scale = nil
            local point = nil
            local finalScale = nil

            -- if is_boss then
            --     --BIG_SCALE = 0.58
            --     --BOSS_SCALE = 1
            --     scale = (card.scaleX + card.scaleY) / (0.45 * 2) * BOSS_SCALE / BIG_SCALE
            --     point = cc.p(card.x + 30 - (scale - 1) * 15, card.y + 10 - (scale - 1) * 10)

            --     finalScale = 0.45 * (1 - ((scale - 1) * 0.15)) * BOSS_SCALE / BIG_SCALE * 2
            -- else
            --     scale = (card.scaleX + card.scaleY) / (0.45 * 2)
            --     point = cc.p(card.x + 30 - (scale - 1) * 150, card.y + 10 - (scale - 1) * 100)
            --     finalScale = 0.45 * (1 - ((scale - 1) * 0.2))
            -- end
            --cclog("finalScale=======" .. finalScale)
            --cclog("point--------x==" .. point.x)
            --cclog("point--------y==" .. point.y)
            
            scale = (card.scaleX + card.scaleY) / (0.45 * 2)
            point = cc.p(card.x + 30 - (scale - 1) * 150, card.y + 10 - (scale - 1) * 100)
            finalScale = 0.45 * (1 - ((scale - 1) * 0.2))

            shadow:setScale(finalScale)
            shadow:setPosition(point)
            shadow:setVisible(true)
            shadow:setRotation(card.rotate)
            shadow:setOpacity(128)
        else
            shadow:setVisible(false)
        end

    end
end

return FVLayerShadow

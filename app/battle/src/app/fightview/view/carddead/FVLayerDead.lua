
local FVCardDead = import(".FVCardDead")

local FVLayerDead = class("FVLayerDead", mvc.ViewBase)

function FVLayerDead:ctor(id)
    FVLayerDead.super.ctor(self, id)

    self.deadItems = {}

    self.deads = mvc.ViewBatchNode("res/card/dead_all.pvr.ccz", 60)

    self:addChild(self.deads)
end

function FVLayerDead:onMVCEnter()
    self:listenEvent(const.EVENT_MAKE_CARD_ITEM, self.addDeadItem, nil)
    self:listenEvent(const.EVENT_REST_CARD_ITEM, self.restDeadItem, nil)
    self:listenEvent(const.EVENT_ANEW_CARD_ITEM, self.anewDeadItem, nil)
    self:listenEvent(const.EVENT_ATTACK_ITEM_SHAKE, self.playActionItem_shake, nil)
    self:listenEvent(const.EVENT_DEAD_ITEM, self.playDeadItem, nil)

    self:listenEvent(const.EVENT_FIGHT_VICTORY, self.fightVictory, nil)
end

function FVLayerDead:fightVictory()
    for k, v in pairs(self.deadItems) do
        v:removeFromParent(true)
    end
end

function FVLayerDead:addDeadItem(unit)
    local dead = FVCardDead.new(unit)

    self.deadItems[unit.viewPos] =  dead

    dead:setCardHome(unit.HOME)
    dead:setVisible(false)

    self.deads:addChild(dead)
end

function FVLayerDead:restDeadItem(seat)
    self.deadItems[seat]:setVisible(false)
end

function FVLayerDead:anewDeadItem(seat, unit)
    self.deadsItems[seat]:setVisible(false)
end

function FVLayerDead:anewDeadEnemy(seat, unit)
    local dead = self.deads_enemy[seat]
    if dead then
        dead:removeFromParent(true)
    end

    dead = FVCardDead.new(unit)

    self.deads_enemy[seat] =  dead

    dead:setCardHome(unit.HOME)
    dead:setVisible(false)

    self.deads:addChild(dead)
    --table.printKey(self.deads_enemy)
end

function FVLayerDead:playDeadItem(seat)
    if self.deadItems[seat] == nil then
        return
    end
    self.deadItems[seat]:setVisible(true)
    self.deadItems[seat]:playAction_dead()

    local function removeCallBack(card)
        self.deadItems[seat]:removeFromParent()
        self.deadItems[seat] = nil
    end

    local delayAction = cc.DelayTime:create(0.2)
    local sequenceAction = cc.Sequence:create(delayAction, cc.CallFunc:create(removeCallBack))

    self.deadItems[seat]:runAction(sequenceAction)
end

function FVLayerDead:playActionItem_shake(target_pos, frequency, aspect)
    for _, army in pairs(self.deadItems) do
        army:playAction_shake(target_pos, aspect)
    end
end

return FVLayerDead

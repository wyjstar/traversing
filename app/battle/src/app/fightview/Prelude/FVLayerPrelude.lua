--入场动画层
local FVCardPrelude = import(".FVCardPrelude")

local FVLayerPrelude = class("FVLayerPrelude", mvc.ViewBase)

function FVLayerPrelude:ctor(id)
    FVLayerPrelude.super.ctor(self, id)

    self.chief = nil
    self.armys = {}
    self.preludes_army = {}
    self.preludes_enemy = {}
    self.position = nil
    self.fvParticleManager = getFVParticleManager()
end
--监听创建卡牌消息和入场动画开始消息
function FVLayerPrelude:onMVCEnter()
    self:listenEvent(const.EVENT_MAKE_CARD_ITEM, self.addPreludeItem, nil)
    self:listenEvent(const.EVENT_PRELUDE_BEGIN, self.onPreludeBegin, nil)
    
end
--如果是主卡则创建主卡动画，其他则加入卡牌队列中
function FVLayerPrelude:addPreludeItem(unit)
    print("FVLayerPrelude:addPreludeItem")
    if unit.chief then
        if self.chief == nil then
            self.chief = FVCardPrelude.new(unit)
            self.chief:setVisible(false)
            self.chief:setCardHome(unit.HOME)
            self:addChild(self.chief)          
        end
    else
        self.preludes_army[#self.preludes_army + 1] = unit.HOME
    end
end
--接收入场动画开始消息
function FVLayerPrelude:onPreludeBegin()
    cclog("FVLayerPrelude:onPreludeBegin=============>")
    local function callBack1()
        self:startPrelude()
    end
    local function callBack2()
        self:dispatchEvent(const.EVENT_ATTACK_ARMY_SHAKE, nil, 2)
    end
    local delayTime1 = cc.DelayTime:create(0.1)
    local delayTime2 = cc.DelayTime:create(1.06)
    local sequenceAction = cc.Sequence:create(delayTime1, cc.CallFunc:create(callBack1), delayTime2, cc.CallFunc:create(callBack2))
    self:runAction(sequenceAction)
end
--开始入场动画
function FVLayerPrelude:startPrelude()

    self:dispatchEvent(const.EVENT_SHOW_SHADOW, "red", true)
    self:dispatchEvent(const.EVENT_DO_ACTION_PRELUDE)
    
    local function callBack()
        self:startOtherIn()
    end
    local delayTime = cc.DelayTime:create(0.1)
    local sequenceAction = cc.Sequence:create(delayTime, cc.CallFunc:create(callBack))
    self:runAction(sequenceAction)

    local function callBack1()
        if not self.chief then return end        
        self.chief:removeFromParent(true)
        self.chief = nil
    end

    local delayTime2 = cc.DelayTime:create(1.5)
    local sequenceAction = cc.Sequence:create(delayTime2, cc.CallFunc:create(callBack1))
    self:runAction(sequenceAction)
end
--其他卡牌入场
function FVLayerPrelude:startOtherIn()
    self:runAction(cc.Sequence:create({
    cc.DelayTime:create(0.9),
    cc.CallFunc:create(function(card)
        for _, home in pairs(self.preludes_army) do
            local part1 = getFVParticleManager():make("cx03", 0.25, false)
            local part2 = getFVParticleManager():make("cx06", 0.25, false)
            local newPoint = cc.p(home.point.x, home.point.y)
            part1:setPosition(newPoint)
            part2:setPosition(newPoint)
            part1:setScale(home.scale * 2.5)
            part2:setScale(home.scale * 4.5)
            self:addChild(part1)
            self:addChild(part2)
        end
    end),
    cc.DelayTime:create(0.25),
    cc.CallFunc:create(function(card)
        for _, home in pairs(self.preludes_army) do
            local part1 = getFVParticleManager():make("cx04", 0.3, false)
            local part2 = getFVParticleManager():make("cx05", 0.2, false)
            local newPoint = cc.p(home.point.x, home.point.y)
            part1:setPosition(newPoint)
            part2:setPosition(newPoint)
            part1:setScale(home.scale * 2.5)
            part2:setScale(home.scale * 2.5)
            self:addChild(part1)
            self:addChild(part2)
        end
    end),
    cc.DelayTime:create(0.2),
    cc.CallFunc:create(function(card)
        --发送入场动画结束消息
        self:dispatchEvent(const.EVENT_PRELUDE_END)
        self:perludeEnd()
    end),
    cc.DelayTime:create(0.37),
    cc.CallFunc:create(function(card)
        self:dispatchEvent(const.EVENT_SHOW_SHADOW, "red", true)
        self:dispatchEvent(const.EVENT_ATTACK_ARMY_SHAKE, nil, 2)        
    end),
    }))
end

function FVLayerPrelude:perludeEnd()

end

return FVLayerPrelude








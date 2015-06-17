
local ImproveAbility = class("ImproveAbility", BaseUIView)

local ScrollLabel = import(".ScrollLabel")

function ImproveAbility:ctor(id)
    ImproveAbility.super.ctor(self, id)

    -- self.oldNum = self.funcTable[1]
    -- self.newNum = self.funcTable[2]
    -- self.diff_num = self.newNum - self.oldNum

    -- self.UIFIghtPowerUp = {}
    -- --加载本界面的ccbi ui_shop.ccbi
    -- self:loadCCBI("common/ui_fightPower_up.ccbi", self.UIFIghtPowerUp)

    -- --添加可购买的列表TableView
    -- self:initView()
end

function ImproveAbility:onMVCEnter()
    self.oldNum = self.funcTable[1]
    self.newNum = self.funcTable[2]
    self.diff_num = self.newNum - self.oldNum

    self.UIFIghtPowerUp = {}
    --加载本界面的ccbi ui_shop.ccbi
    self:loadCCBI("common/ui_fightPower_up.ccbi", self.UIFIghtPowerUp)

    --添加可购买的列表TableView
    self:initView()

    -- print(self.diff_num)
    -- print("x----")
    -- self:createView()
    -- self:createUpLabel(self.diff_num)
    -- self:changeShieldLayerState(false)
end

function ImproveAbility:initView()
    self.ui_common_elevate_up = self.UIFIghtPowerUp["UIFIghtPowerUp"]["ui_common_elevate_up"]
    self.ui_common_elevate_down = self.UIFIghtPowerUp["UIFIghtPowerUp"]["ui_common_elevate_down"]

    self.ui_diff_num_label = self.UIFIghtPowerUp["UIFIghtPowerUp"]["ui_diff_num_label"]
    self.scrollLabel = self.UIFIghtPowerUp["UIFIghtPowerUp"]["scrollLabel"]
    self.bgSp = self.UIFIghtPowerUp["UIFIghtPowerUp"]["bgSp"]

    if self.diff_num >= 0 then
        self.ui_diff_num_label:setColor(ui.COLOR_GREEN)
        self.ui_common_elevate_up:setVisible(true)
        self.ui_common_elevate_down:setVisible(false)
    else
        self.ui_diff_num_label:setColor(ui.COLOR_RED)
        self.ui_common_elevate_up:setVisible(false)
        self.ui_common_elevate_down:setVisible(true)
    end

    -- self.scrollLabel:setString(self.newNum)  -- = ScrollLabel.new(self.newNum)
    self.ui_diff_num_label:setString(self.diff_num)

    self.num = 0
    -- self.ui_diff_num_label:setString(self.num)
    --
    self.scrollLabel:setString(self.oldNum)

    local function callBack()
        
        self:startTimer()
        local node = UI_Zhandoulishangsheng()
        self.bgSp:addChild(node)
    end
    local function callBack2()
        
        if self._scheduerOutputTime ~= nil then
            timer.unscheduleGlobal(self._scheduerOutputTime)
            self._scheduerOutputTime = nil
        end
    end
    
    local delayTimeAction = cc.DelayTime:create(0.25)
    local delayTimeAction2 = cc.DelayTime:create(2)
    local sequenceAction = cc.Sequence:create(delayTimeAction,cc.CallFunc:create(callBack), delayTimeAction2, cc.CallFunc:create(callBack2), cc.RemoveSelf:create(true))
    self:runAction(sequenceAction)

    -- local node = UI_Zhandoulishangsheng()
    -- self:addChild(node)

end
function ImproveAbility:startTimer()
    -- print("-------------startTimer---------------")
    
    
    local function updateTimer(dt)
        -- print("----- updateTimer -----")
        -- print(self.num)
        -- print(self.diff_num)

        if self.diff_num == nil then
            print("---------self.diff_num->nil--------")
            if self._scheduerOutputTime ~= nil then
                timer.unscheduleGlobal(self._scheduerOutputTime)
                self._scheduerOutputTime = nil
            end
        end

        local add = math.modf(self.diff_num/8)
        if self.diff_num < 8 and self.diff_num > 1 then
            add = 1
        elseif self.diff_num <= 1 and self.diff_num > 0 then
            add = 0.5
        elseif self.diff_num > -8 and self.diff_num < -1 then
            add = -1
        elseif self.diff_num >= -1 and self.diff_num < 0 then
            add = -0.5
        end

        if math.abs(self.num) < math.abs(self.diff_num) then
            self.num = self.num+add
        end
        -- self.ui_diff_num_label:setString(self.num)
        self.scrollLabel:setString(self.oldNum+self.num)
       
        if math.abs(self.num) >= math.abs(self.diff_num) then
            self.num = self.diff_num
            -- self.ui_diff_num_label:setString(self.num)
            self.scrollLabel:setString(self.newNum)
            print("达到最大值")
            if self._scheduerOutputTime ~= nil then
                timer.unscheduleGlobal(self._scheduerOutputTime)
                self._scheduerOutputTime = nil
            end
        end
    end

    self._scheduerOutputTime = timer.scheduleGlobal(updateTimer, 0.002)

end

function ImproveAbility:createView()
    -- local baseNode = game.newNode()
    -- self:addChild(baseNode)
    -- baseNode:setPosition(320, 960)
    -- local spriteBg = game.newSprite("#ui_common_elevate_bg.png")
    -- local spritelabel = game.newSprite("#ui_common_elevate_label.png")
    -- local ui_common_elevate_up = game.newSprite("#ui_common_elevate_up.png")
    -- local ui_common_elevate_down = game.newSprite("#ui_common_elevate_down.png")
    -- local ui_diff_num_label = cc.LabelTTF:create(math.abs(self.diff_num), MINI_BLACK_FONT_NAME, 24)

    -- baseNode:addChild(spriteBg)
    -- baseNode:addChild(spritelabel)
    -- baseNode:addChild(ui_common_elevate_up)
    -- baseNode:addChild(ui_common_elevate_down)
    -- baseNode:addChild(ui_diff_num_label)

    -- spritelabel:setPosition(0, 40)
    -- ui_common_elevate_up:setPosition(-40, -40)    
    -- ui_common_elevate_down:setPosition(-40, -40)

    -- if self.diff_num > 0 then
    --     ui_diff_num_label:setColor(ui.COLOR_GREEN)
    --     ui_common_elevate_up:setVisible(true)
    --     ui_common_elevate_down:setVisible(false)
    -- else
    --     ui_diff_num_label:setColor(ui.COLOR_RED)
    --     ui_common_elevate_up:setVisible(false)
    --     ui_common_elevate_down:setVisible(true)
    -- end

    -- spriteBg:stopAllActions()
    -- spriteBg:setVisible(false)

    -- local scaleTo1 = cc.ScaleTo:create(0.01, 1.5, 1)
    -- -- spriteBg:runAction(scaleTo1)
    -- local showAction = cc.Show:create()
    -- local delayTimeAction1 = cc.DelayTime:create(1)
    -- local scaleTo2 = cc.ScaleTo:create(0.5, 1, 1)
    -- local sequenceAction1 = cc.Sequence:create(delayTimeAction1, scaleTo1, showAction, scaleTo2)
    -- spriteBg:runAction(sequenceAction1)
    -- ---------
    -- spritelabel:setVisible(false)
    -- local scaleTo3 = cc.ScaleTo:create(0.01, 2)
    -- local scaleTo4 = cc.ScaleTo:create(0.2, 1)
    -- local sequenceAction2 = cc.Sequence:create(delayTimeAction1:clone(), scaleTo3, showAction:clone(), scaleTo4)
    -- spritelabel:runAction(sequenceAction2)

    ----------------
    -- self.scrollLabel = ScrollLabel.new(self.newNum)
    -- self.scrollLabel:setPosition(0, -30)
    -- baseNode:addChild(self.scrollLabel)
    -- self.scrollLabel:setNum(self.newNum)
    -------------------

    -- local delayTimeAction2 = cc.DelayTime:create(2)

    -- local function callBack()

    -- end

    -- --local sequenceAction2 = cc.Sequence:create(delayTimeAction2, cc.CallFunc:create(callBack))
    -- local sequenceAction2 = cc.Sequence:create(delayTimeAction2, cc.RemoveSelf:create(true))
    -- self:runAction(sequenceAction2)
end

-- function ImproveAbility:createUpLabel(upValue)
--     local node = game.newNode()
--     local spriteUp = game.newSprite("#ui_common_elevate_up.png")
--     local labelUp = game.newText(tostring(upValue),"miniblack.ttf", 20)
--     node:addChild(spriteUp)
--     labelUp:setPosition(0, -450)
--     node:addChild(labelUp)
--     node:setPosition(0, -50)

--     local moveByAction = cc.MoveBy:create(0.5, cc.p(0, 50))
--     local fadeTo = cc.FadeTo:create(0.5, 0)
--     local spawn = cc.Spawn:create(moveByAction, fadeTo)
--     local sequenceAction = cc.Sequence:create(spawn, cc.RemoveSelf:create(true))
--     node:runAction(sequenceAction)
--     self:addChild(node)
-- end


return ImproveAbility

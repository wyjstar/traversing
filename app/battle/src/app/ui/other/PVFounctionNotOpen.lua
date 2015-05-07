
local PVFounctionNotOpen = class("PVFounctionNotOpen", BaseUIView)

function PVFounctionNotOpen:ctor(id)
    PVFounctionNotOpen.super.ctor(self, id)
end

function PVFounctionNotOpen:onMVCEnter()
    self.UIFunctionNotOpen = {}

    self:loadCCBI("common/ui_function_not_open.ccbi", self.UIFunctionNotOpen)

    self:initView()
end

function PVFounctionNotOpen:initView()
    self.detailLayer = self.UIFunctionNotOpen["UIFunctionNotOpen"]["detailLayer"]
    self.levelLabel = self.UIFunctionNotOpen["UIFunctionNotOpen"]["levelLabel"]

    self.levelLabel:setString(self.funcTable[1])

    self.moveAction = cc.Sequence:create({
                cc.DelayTime:create(1),
                cc.CallFunc:create(function () self:onHideUI() end
                )})
    self:runAction(self.moveAction)
end

function PVFounctionNotOpen:onHideUI()
    self:removeFromParent(true)
end

return PVFounctionNotOpen

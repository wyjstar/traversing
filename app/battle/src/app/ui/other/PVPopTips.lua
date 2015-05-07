--获取英雄界面
local PVPopTips = class("PVPopTips", BaseUIView)

function PVPopTips:ctor(id)
    PVPopTips.super.ctor(self, id)

end
function PVPopTips:onMVCEnter()
    self.UIPopTips = {}

    self:loadCCBI("ui_pop_tips.ccbi", self.UIPopTips)

    self:initView()

    self:onPopViewShow()
    --self:changeShieldLayerState(false)
end

function PVPopTips:initView()
    self.animationManager = self.UIPopTips["UIPopTips"]["mAnimationManager"]
    self.showMsgLabel = self.UIPopTips["UIPopTips"]["showMsgLabel"]
end

function PVPopTips:onPopViewShow()
    self.showMsgLabel:setString(self.funcTable[1])

    local function actionCallback()
        self:onHideView()
    end

    local actionIn = cc.FadeIn:create(0.5)
    self:runAction(cc.Sequence:create( cc.DelayTime:create(0.5), actionIn, cc.CallFunc:create(actionCallback)))

end

return PVPopTips

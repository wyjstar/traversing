local  PVFriendPop = class("PVFriendPop", BaseUIView)

function PVFriendPop:ctor(id)
    PVFriendPop.super.ctor(self, id)
end

function PVFriendPop:onMVCEnter()

    self.id = self.funcTable[1]

    self.UIFriendPop = {}
    self.UIFriendPop["UIFriendPop"] = {}

    self:initTouchListener()

    self:loadCCBI("friend/ui_friend_pop.ccbi", self.UIFriendPop)

    self:initView()

end

function PVFriendPop:initTouchListener()
    -- 按键响应函数

    -- 按键绑定
end

function PVFriendPop:initView()
    -- 初始化元素
    self.popRoot = self.UIFriendPop["UIFriendPop"]["friend_pop_root"]   --根节点
    self.zscg = self.UIFriendPop["UIFriendPop"]["zscg"]         --赠送成功
    self.yjj = self.UIFriendPop["UIFriendPop"]["yjj"]           --已拒绝
    self.tjcg = self.UIFriendPop["UIFriendPop"]["tjcg"]         --添加成功
    self.ysc = self.UIFriendPop["UIFriendPop"]["ysc"]           --已删除

    if self.id == FRIEND_PRESENTVIGOR_REQUES then --赠送成功
        self.zscg:setVisible(true)
    elseif self.id == FRIEND_REFUSE_APPLY_REQUEST then --已拒绝
        self.yjj:setVisible(true)
    elseif self.id == FRIEND_ACCEPT_APPLY_REQUEST then --添加成功
        self.tjcg:setVisible(true)
    elseif self.id == FRIEND_DELETE_REQUEST then --已删除
        self.ysc:setVisible(true)
    end

    local function removeMyself()
        self:onHideView()
    end

    --向上移动动作
    local moveUp = cc.MoveBy:create(0.5, cc.p(0, 200))
    local move_up= cc.EaseSineOut:create(moveUp)
    --向下移动动作
    local moveDown = cc.MoveBy:create(0.6, cc.p(0, -200))
    local move_down= cc.EaseSineOut:create(moveDown)
    --消失动作
    local fade = cc.FadeTo:create(0.5, 0)
    --释放self动作
    local rel = cc.CallFunc:create(removeMyself)

    local spawn = cc.Spawn:create(moveDown, fade)

    -- local sequence = cc.Sequence:create(moveUp, spawn, rel)
    local sequence = cc.Sequence:create(move_up, cc.DelayTime:create(0.2), moveDown, rel)
    -- local move = cc.MoveBy:create(0.5, cc.p(0, 150))
    -- local fade = cc.FadeOut:create(0.5)
    -- local spawnAction = cc.Spawn:create(move, fade)
    -- local sequenceAction = cc.Sequence:create(cc.DelayTime:create(1.0), spawnAction)
    -- self.UIPopRoot:runAction(sequenceAction)
    self:runAction(sequence)
end

return PVFriendPop
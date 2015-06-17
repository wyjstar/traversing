
-- local CursorInputLayer = import("...input.CursorInputLayer")
-- local LabelCommon = import("....ui.other.LabelCommon")

local PVChatCheck = class("PVChatCheck", BaseUIView)

function PVChatCheck:ctor(id)
    PVChatCheck.super.ctor(self, id)
end

function PVChatCheck:onMVCEnter()
    self.chatData = getDataManager():getChatData()
    self.chatNet = getNetManager():getChatNet()
    self.commonData = getDataManager():getCommonData()
    self:registerDataBack()


    self:initView()
    self:initData()
end

function PVChatCheck:registerDataBack()
    local function getCheckInfoCallBack(id, data)
        self:onHideView()
        -- getModule(MODULE_NAME_HOMEPAGE):showUIView("PVArenaCheckInfo", nil)
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVArenaCheckInfo", self.name)
    end

    self:registerMsg(CHECK_INFO, getCheckInfoCallBack)

    local function onReciveMsgCallBack(id, data)
        if id == FRIEND_APPLY_REQUEST then
            if data.result then
                getOtherModule():showAlertDialog(nil, Localize.query("friend.7"))
            end
        end
    end
    self:registerMsg(FRIEND_APPLY_REQUEST, onReciveMsgCallBack)

    local function onInviteCallBack(id, data)
        print("邀请加入返回 ------------ ", id)
        table.print(data)
        local sure = function()
            self:onHideView(1)
        end
        if data.result then
            getOtherModule():showAlertDialog(sure, Localize.query("legion.13"))
        else
            getOtherModule():showAlertDialog(sure, data.message)
        end
    end
    self:registerMsg(INVITE_JOIN_LEGION, onInviteCallBack)
end

function PVChatCheck:initData()
    -- local index = self.funcTable[1]
    -- self.name = self.funcTable[2]
    self.curId = self.funcTable[1]
    local height = self.funcTable[2]
    self.curPosY = self.funcTable[3]
    self.name = self.funcTable[4]
    self.isCheck = self.funcTable[5]--是否允许查看信息
    self.isAdd   = self.funcTable[6]--是否允许添加好友
    self.checkMenuItem:setEnabled((self.isCheck ~= nil) and self.isCheck)
    self.addMenuItem:setEnabled((self.isAdd ~= nil) and self.isAdd)
    -- self.playerName:setString(self.name)
    -- if index >= 4 then
    --     self.mainNode:setPosition(cc.p(210, 640 - 3 * height))
    -- else
    --     self.mainNode:setPosition(cc.p(210, 640 - index * height))
    -- end
    print("self.curPosY  ======= ", self.curPosY )
    print("height")
    self:setPosition(cc.p(320, self.curPosY - height / 2))
    -- self:setPosition(cc.p(320, self.curPosY - self.mainNode:getContentSize().height))
end

function PVChatCheck:initView()
    self.UICheckView = {}
    self:initTouchListener()
    self:loadCCBI("chat/ui_chat_check.ccbi", self.UICheckView)

    -- self.playerName = self.UICheckView["UICheckView"]["playerName"]
    self.mainNode = self.UICheckView["UICheckView"]["mainNode"]
    self.mainLayer = self.UICheckView["UICheckView"]["mainLayer"]

    self.checkMenuItem = self.UICheckView["UICheckView"]["checkMenuItem"]
    self.addMenuItem = self.UICheckView["UICheckView"]["addMenuItem"]
    self.legionMenuItem = self.UICheckView["UICheckView"]["legionMenuItem"]

    self:nodeRegisterTouchEvent()

    self.legionData = getDataManager():getLegionData()
    local legionPos = self.legionData:getLegionPosition()
    if legionPos == 1 then
        print("发出邀请加入军团消息 ================")
        self.legionMenuItem:setEnabled(true)
    else
        print("can not invite ================== ")
        SpriteGrayUtil:drawSpriteTextureGray(self.legionMenuItem:getNormalImage())
        self.legionMenuItem:setEnabled(false)
    end

    -- self.labelCommon = LabelCommon:new()
    -- self:addChild(self.labelCommon)
end

function PVChatCheck:initTouchListener()
    --查看信息
    local function onCheckClick()
        print("chatCheck ================ ", self.curId)
        self.chatNet:sendCheckInfo(self.curId)
    end

    --添加好友
    local function onAddFriendClick()
        print("onAddFriendClick ============= ", self.curId)

        local isExist = getDataManager():getFriendData():isExistsInFriend(self.curId)
        if isExist then
            getOtherModule():showAlertDialog(nil, Localize.query("friend.8"))
            return
        end

        self.friendNet = getNetManager():getFriendNet()
        local  data = { target_ids={self.curId} }
        self.friendNet:sendFriendApply(data)
    end

    --邀请加入军团
    local function onJoinLegionClick()
        print("onJoinLegionClick =============== ")
        print("邀请的玩家的id =============== ", self.curId)
        getNetManager():getLegionNet():sendInviteJoin(self.curId)
    end

    self.UICheckView["UICheckView"] = {}

    self.UICheckView["UICheckView"]["onCheckClick"] = onCheckClick
    self.UICheckView["UICheckView"]["onAddFriendClick"] = onAddFriendClick
    self.UICheckView["UICheckView"]["onJoinLegionClick"] = onJoinLegionClick
end

function PVChatCheck:nodeRegisterTouchEvent()

    local posX, posY = self.mainLayer:getPosition()

    local size = self.mainLayer:getContentSize()
    local rectArea = cc.rect(posX, posY, size.width, size.height)


    local function onTouchEvent(eventType, x, y)
        print("current point x y ============= ", x , y)
        pos = self.mainLayer:convertToNodeSpace(cc.p(x,y))
        local isInRect = cc.rectContainsPoint(rectArea, cc.p(pos.x,pos.y))
         if  eventType == "began" then
            if isInRect then
                return false
            end
            return true
        elseif  eventType == "ended" then
            self:onHideView(1)
        end
    end
    self.mainLayer:registerScriptTouchHandler(onTouchEvent)
    self.mainLayer:setTouchMode(cc.TOUCHES_ONE_BY_ONE)
    self.mainLayer:setTouchEnabled(true)
end

return PVChatCheck

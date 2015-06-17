local  PVFriendSecondMenu = class("PVFriendSecondMenu", BaseUIView)

function PVFriendSecondMenu:ctor(id)
    PVFriendSecondMenu.super.ctor(self, id)

end

function PVFriendSecondMenu:onMVCEnter()
    self.UICheckView = {}
    self.menuLayer = {}
    self.parentObject = self.funcTable[1]
    self.friendInfoData = self.funcTable[2]
    self.posx = self.funcTable[3]
    self.posy = self.funcTable[4]
    self.isCheck = self.funcTable[5]--是否能够查看信息
    self.isInvi  = self.funcTable[6]--是否能够邀请入团
    self.isAdd   = self.funcTable[7]--是否能够添加好友
    self:initTouchListener()

    -- self:loadCCBI("friend/ui_friend_check_new.ccbi", self.UICheckView)
    local proxy = cc.CCBProxy:create()
    self.secondView = CCBReaderLoad("friend/ui_friend_check_new.ccbi", proxy, self.UICheckView)
    print("_LZD:" .. self.posx .. "|" .. self.posy)
    self.secondView:setPositionX(self.posx)
    self.secondView:setPositionY(self.posy)
    self:addToUIChild(self.secondView)

    self:initView()
end


function PVFriendSecondMenu:initTouchListener()

    -- 事件函数：查看玩家信息
    function onCheckClick()
        cclog("-onCheckClick-")
        local uid = self.friendInfoData.data.id
        self.parentObject.friendNet:sendCheckInfo(uid)
        self:onHideView()
    end
    
    -- 事件函数：邀请入团
    function onInviClick()
        cclog("-onInviClick-")
        -- getDataManager():getFriendData():setTempFriendInfoData(self.friendInfoData)
        self:onHideView()
        -- getOtherModule():showOtherView("PVFriendPrivateChat")
    end
    -- 事件函数：加为好友
    function onAddClick()
        cclog("-onAddClick-")
        self:onHideView()
        local  data  = { target_ids={friendInfoData.data.id}}
        elf.parentObject.friendNet:sendAcceptFriendApply(data)
    end

    self.UICheckView["UICheckView"] = {}
    self.UICheckView["UICheckView"]["onCheckClick"] = onCheckClick
    self.UICheckView["UICheckView"]["onInviClick"] = onInviClick
    self.UICheckView["UICheckView"]["onAddClick"] = onAddClick

end

function PVFriendSecondMenu:initView()
    self.menuLayer = self.UICheckView["UICheckView"]["menuLayer"]
    self.checkBtn = self.UICheckView["UICheckView"]["checkBtn"]
    self.inviBtn = self.UICheckView["UICheckView"]["inviBtn"]
    self.addBtn = self.UICheckView["UICheckView"]["addBtn"]

    self.checkBtn:setEnabled(self.isCheck)
    self.inviBtn:setEnabled(self.isInvi)
    self.addBtn:setEnabled(self.isAdd)

    self:menuLayerRegisterTouchEvent()
end

function PVFriendSecondMenu:menuLayerRegisterTouchEvent()

    local posX, posY = self.menuLayer:getPosition()

    local size = self.menuLayer:getContentSize()
    local rectArea = cc.rect(posX, posY, size.width, size.height)

    local function onTouchEvent(eventType, x, y)
        print("_LZD:背景层响应")
        pos = self.menuLayer:convertToNodeSpace(cc.p(x,y))
        local isInRect = cc.rectContainsPoint(rectArea, cc.p(pos.x,pos.y))
        print("_LZD:eventType = " .. eventType)
        if  eventType == "began" then
            if isInRect then
                print("_LZD:return false")
                return false
            end
            return true
        elseif  eventType == "ended" then
            self:onHideView()
        end
    end
    
    self.menuLayer:registerScriptTouchHandler(onTouchEvent)
    self.menuLayer:setTouchMode(cc.TOUCHES_ONE_BY_ONE)
    self.menuLayer:setTouchEnabled(true)
end

return PVFriendSecondMenu
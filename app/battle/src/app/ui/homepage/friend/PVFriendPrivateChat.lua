-- 私聊

local  PVFriendPrivateChat = class("PVFriendPrivateChat", BaseUIView)

function PVFriendPrivateChat:ctor(id)
    self.super.ctor(self, id)
end

function PVFriendPrivateChat:onMVCEnter()
    self.UISendView = {}
    self.bglayer = {}
    self.friendInfoData = getDataManager():getFriendData():getTempFriendInfoData()
    
    self:initTouchListener()

    self:loadCCBI("friend/ui_friend_send.ccbi", self.UISendView)

    self:initView()
    self.friendNet = getNetManager():getFriendNet()
    self:registerCallBack()
end

function PVFriendPrivateChat:registerCallBack()
    function responseFriendPrivateChat(id, data)
        if data.result then
            self.inputEditbox:setText("")
            -- self:toastShow(Localize.query("friend.1"))
            getOtherModule():showAlertDialog(nil, Localize.query("friend.1"))
            self:onHideView()
        else
            -- self:toastShow(Localize.query(9998))
            getOtherModule():showAlertDialog(nil, Localize.query(9998))
        end
    end
    self:registerMsg(FRIEND_PRIVATECHAT_REQUEST, responseFriendPrivateChat)
end

function PVFriendPrivateChat:initTouchListener()
    
    function onSendClick()
        cclog("-onSendClick-")
        local content = self.inputEditbox:getStringValue()
        content = string.trim(content)
        if string.len(content) == 0 then
            -- self:toastShow(Localize.query("friend.2"))
            getOtherModule():showAlertDialog(nil, Localize.query("friend.2"))
            return
        end
        local data = { target_uid = self.friendInfoData.data.id, content=content }
        self.friendNet:sendPrivateChat(data)
    end

    function onCloseClick()
         cclog("-onCloseClick-")
         getDataManager():getFriendData():clearTempFriendInfoData()
         self:onHideView()

    end

    self.UISendView["UISendView"] = {}
    self.UISendView["UISendView"]["onSendClick"] = onSendClick
    self.UISendView["UISendView"]["onCloseClick"] = onCloseClick

end

function PVFriendPrivateChat:initView()
    self.bglayer = self.UISendView["UISendView"]["bglayer"]
    self.textAreaIcon = self.UISendView["UISendView"]["friendIcon"]
    self:initTextArea()

    self:bgLayerRegisterTouchEvent()
end

function PVFriendPrivateChat:initTextArea()
    if self.inputEditbox ~= nil then
        self.inputEditbox:removeFromParent(true)
    end

    -- self.inputEditbox = ui.newEditBox({
    --     image = cc.Scale9Sprite:create(),
    --     size = cc.size(self.textAreaIcon:getContentSize().width, self.textAreaIcon:getContentSize().height-10),
    --     x = self.textAreaIcon:getPositionX()+5,
    --     y = self.textAreaIcon:getPositionY(),
    --     listener = function(strEventName,pSender)
    --         print(strEventName)
    --         -- self:editBoxTextEventHandle(strEventName,pSender)
    --     end
    --     })

    self.inputEditbox = ui.newTextField({
            fontName = const.FONT_NAME,
            maxLength = 25,
            size = cc.size(self.textAreaIcon:getContentSize().width, self.textAreaIcon:getContentSize().height-10),
            fontSize = 28,
            placeHoder=Localize.query("friend.3"),
            verticalAlignment = 1,-- 0 CENTER
            x = self.textAreaIcon:getPositionX()+5,
            y = self.textAreaIcon:getPositionY(),
        })

    -- self.inputEditbox:setPosition(self.textAreaIcon:getPositionX()+5, self.textAreaIcon:getPositionY())
    -- self.editboxUser:setFontColor(cc.c3b(255,0,0))
    -- self.inputEditbox:setFont(MINI_BLACK_FONT_NAME, 28)
    -- self.inputEditbox:setPlaceHolder(Localize.query("friend.3"))
    -- self.inputEditbox:setPlaceholderFontColor(cc.c3b(255,255,255))
    -- self.inputEditbox:setMaxLength(25)
    -- self.inputEditbox:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE )
    -- self.inputEditbox:setInputFlag(cc.EDITBOX_INPUT_FLAG_INITIAL_CAPS_ALL_CHARACTERS)
    -- -- self.inputEditbox:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
    -- self.inputEditbox:setAnchorPoint(0.5,0.5)
    self.textAreaIcon:getParent():addChild(self.inputEditbox)
end

function PVFriendPrivateChat:bgLayerRegisterTouchEvent()

    local posX, posY = self.bglayer:getPosition()

    local size = self.bglayer:getContentSize()
    local rectArea = cc.rect(posX, posY, size.width, size.height)
    -- local rectArea = cc.rect(0, 0, size.width, size.height)


    local function onTouchEvent(eventType, x, y)

        -- local isInRect = cc.rectContainsPoint(self.menuLayer:getBoundingBox(),cc.p(x, y))
        pos = self.bglayer:convertToNodeSpace(cc.p(x,y))
        local isInRect = cc.rectContainsPoint(rectArea, cc.p(pos.x,pos.y))
         if  eventType == "began" then
            if isInRect then
                return false
            end
            return true
        elseif  eventType == "ended" then
            self:onHideView()
               -- self:removeFromParent(true)
        end
    end
    self.bglayer:registerScriptTouchHandler(onTouchEvent)
    self.bglayer:setTouchMode(cc.TOUCHES_ONE_BY_ONE)
    self.bglayer:setTouchEnabled(true)
end

return PVFriendPrivateChat
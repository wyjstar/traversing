
local PVBoundTourist = class("PVBoundTourist", BaseUIView)

function PVBoundTourist:ctor(id)
    self.super.ctor(self, id)


end

function PVBoundTourist:onMVCEnter()
    self.UILoginTravel = {}

    self.username = ""
    self.pwd = ""

    self:initTouchListener()

    self:initView()

    self.loginNet = getNetManager():getLoginNet()
end

function PVBoundTourist:initTouchListener()

    --取消
    local function cancelOnClick()
        self:onHideView()
    end

    --绑定
    local function blinkOnClick()
        -- print(self.editboxUser)
        self.username = self.editboxUser:getText()

        -- 用户名验证
        if not self:usernameValidate(self.username) then
            return
        end

        self.pwd = self.editboxPwd:getText()
        -- print("blinkOnClick onSureRegister ====== self.pwd ===== ", self.pwd)
        if not self:pwdValidate(self.pwd) then
            return
        end

        local surePwd = self.editboxSurePwd:getText()
        if surePwd ~= self.pwd then
            getOtherModule():showAlertDialog(nil, Localize.query("login.6"))
            return
        end

        local touristId = cc.UserDefault:getInstance():getStringForKey("tourist_id")
        print("blinkOnClick onSureRegister ====== self.pwd ===== ", self.pwd)
        print("blinkOnClick onSureRegister ===== self.username ====== touristId ===== ", self.username,  touristId)
        -- 回调
        local boundCallFunc = function(status, response)
        print("回调 ======== 回调 =========== ")
            self:boundResponse(status, response)
        end

        g_NetManager:getHttpCenter():sendBoundTourist(boundCallFunc, self.username, self.pwd, touristId)
    end

    self.UILoginTravel["UILoginTravel"] = {}

    self.UILoginTravel["UILoginTravel"]["blinkOnClick"] = blinkOnClick
    self.UILoginTravel["UILoginTravel"]["cancelOnClick"] = cancelOnClick
end

function PVBoundTourist:boundResponse(status, response)
    local data = {}
    if status == 200 then  -- 成功
           data = parseJson(response)
    else
        getOtherModule():showAlertDialog(nil, Localize.query("login.1"))
        return
    end
    print("绑定结果返回 =============== ", self.username,    self.pwd)
    table.print(data)
    if data.result == true then
        cc.UserDefault:getInstance():setStringForKey("user_name", self.username)
        cc.UserDefault:getInstance():setStringForKey("password", self.pwd)
        cc.UserDefault:getInstance():setBoolForKey("isBound", true)
        self:onHideView()
    end
end

-- 检验用户名
function PVBoundTourist:usernameValidate(username)

    if string.len(username)<=0 then
        getOtherModule():showAlertDialog(nil, Localize.query("login.7"))
        return false
    elseif string.len(username) < 6 or string.len(username) > 20 then
        getOtherModule():showAlertDialog(nil, Localize.query("login.8"))
        return false
    elseif not self:strMatchDigitOrChar(username) then
        getOtherModule():showAlertDialog(nil, Localize.query("login.8"))
        return false
    end

    return true
end

-- 字符串是否是(0~9 or a~z or A~Z)
function PVBoundTourist:strMatchDigitOrChar(str)
    if not str and string.len(str)<=0 then
        return false
    end

    local x = string.match(str, "[%w]+", 1)

    return x == str
end

-- 检验密码
function PVBoundTourist:pwdValidate(pwd)
    print(pwd)
    if string.len(pwd)<=0 then
        getOtherModule():showAlertDialog(nil, Localize.query("login.9"))
        return false
    elseif string.len(pwd) < 6 or string.len(pwd) > 20 then
        getOtherModule():showAlertDialog(nil, Localize.query("login.10"))
        return false
    elseif not self:strMatchDigitOrChar(pwd) then
        getOtherModule():showAlertDialog(nil, Localize.query("login.10"))
        return false
    end

    return true
end


function PVBoundTourist:initView()
    game.addSpriteFramesWithFile("res/ccb/resource/ui_login.plist")

    local sharedDirector = cc.Director:getInstance()
    local glsize = sharedDirector:getWinSize()
    self.adapterLayer = cc.Layer:create()
    self.adapterLayer:setContentSize(cc.size(CONFIG_SCREEN_SIZE_WIDTH, CONFIG_SCREEN_SIZE_HEIGHT))
    self.adapterLayer:setPosition(cc.p(glsize.width / 2 - CONFIG_SCREEN_SIZE_WIDTH / 2, glsize.height / 2 - CONFIG_SCREEN_SIZE_HEIGHT / 2))

    self:addChild(self.adapterLayer)

    local proxy = cc.CCBProxy:create()
    local updateView = CCBReaderLoad("login/ui_login_travel.ccbi", proxy, self.UILoginTravel)
    self.adapterLayer:addChild(updateView)

    self.userNameSprite = self.UILoginTravel["UILoginTravel"]["userNameSprite"]
    self.pwdSprite = self.UILoginTravel["UILoginTravel"]["pwdSprite"]
    self.surePwdSprite = self.UILoginTravel["UILoginTravel"]["surePwdSprite"]

    if self.editboxUser ~= nil then
        self.editboxUser:removeFromParent(true)
    end
    if self.editboxPwd ~= nil then
        self.editboxPwd:removeFromParent(true)
    end

    self.editboxUser = ui.newEditBox({
        image = cc.Scale9Sprite:create(),
        size = cc.size(self.userNameSprite:getContentSize().width, self.userNameSprite:getContentSize().height-20),
        x = self.userNameSprite:getPositionX()+5,
        y = self.userNameSprite:getPositionY()+2,
        listener = function(strEventName,pSender)
            -- self:editBoxTextEventHandle(strEventName,pSender)
        end
        })

    self.editboxUser:setFont(MINI_BLACK_FONT_NAME, 28)
    self.editboxUser:setPlaceHolder(Localize.query("login.11"))
    self.editboxUser:setPlaceholderFontColor(cc.c3b(255,255,255))
    self.editboxUser:setMaxLength(20)
    self.editboxUser:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE )
    self.editboxUser:setInputFlag(cc.EDITBOX_INPUT_FLAG_INITIAL_CAPS_ALL_CHARACTERS)
    self.editboxUser:setInputMode(cc.EDITBOX_INPUT_MODE_EMAILADDR)

    self.userNameSprite:getParent():addChild(self.editboxUser)

    self.editboxPwd = ui.newEditBox({
        image = cc.Scale9Sprite:create(),
        size = cc.size(self.pwdSprite:getContentSize().width, self.pwdSprite:getContentSize().height-20),
        x = self.pwdSprite:getPositionX()+5,
        y = self.pwdSprite:getPositionY()+2,
        listener = function(strEventName,pSender)
            -- self:editBoxTextEventHandle(strEventName,pSender)
        end
        })

    -- self.editboxPwd:setFontColor(cc.c3b(255,0,0))
    self.editboxPwd:setPlaceHolder(Localize.query("login.11"))
    self.editboxPwd:setFont(MINI_BLACK_FONT_NAME, 28)
    self.editboxPwd:setPlaceholderFontColor(cc.c3b(255,255,255))
    self.editboxPwd:setMaxLength(20)
    if device.platform ~= "mac" then
        self.editboxPwd:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
    end
    self.editboxPwd:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE )
    self.editboxPwd:setInputMode(cc.EDITBOX_INPUT_MODE_EMAILADDR)

    self.pwdSprite:getParent():addChild(self.editboxPwd)
    -- 确认密码
    self.editboxSurePwd = ui.newEditBox({
        image = cc.Scale9Sprite:create(),
        size = cc.size(self.surePwdSprite:getContentSize().width, self.surePwdSprite:getContentSize().height-20),
        x = self.surePwdSprite:getPositionX()+5,
        y = self.surePwdSprite:getPositionY()+2,
        listener = function(strEventName,pSender)
            -- self:editBoxTextEventHandle(strEventName,pSender)
        end
        })

    -- self.editboxPwd:setFontColor(cc.c3b(255,0,0))
    self.editboxSurePwd:setPlaceHolder(Localize.query("login.11"))
    self.editboxSurePwd:setFont(MINI_BLACK_FONT_NAME, 28)
    self.editboxSurePwd:setPlaceholderFontColor(cc.c3b(255,255,255))
    self.editboxSurePwd:setMaxLength(20)
    if device.platform ~= "mac" then
        self.editboxSurePwd:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
    end
    self.editboxSurePwd:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE )
    self.editboxSurePwd:setInputMode(cc.EDITBOX_INPUT_MODE_EMAILADDR)

    self.surePwdSprite:getParent():addChild(self.editboxSurePwd)
end

return PVBoundTourist

--PlatformOfficial

-- require("src.app.controller.GameController")

local PlatformOfficial = class("PlatformOfficial", BaseUIView)

function PlatformOfficial:ctor(id)
    self.super.ctor(self, id)

    self.LoginView = {}
    self.editboxUser = nil
    self.editboxPwd = nil
    self.curBox = nil
    self.username = ""
    self.pwd = ""
    self.passport = ""
    self.isTourist = false

    -- 登陆注册切换 1，登录  2，注册
    self.tab = 1

    self:initTouchListener()

    self:initView()
    self:initData()

    -- 网络请求注册回掉
    -- self:initRegisterNetCallBack()

    self.loginNet = getNetManager():getLoginNet()

    self.username = cc.UserDefault:getInstance():getStringForKey("user_name")
    self.pwd = cc.UserDefault:getInstance():getStringForKey("password")
    self.account_key = cc.UserDefault:getInstance():getStringForKey("account_key")

    -- 如果用户名已经存在直接登陆
    if string.len(self.username) > 1 and string.len(self.pwd) > 1 then

    -- elseif string.len(self.account_key) > 1 then
    --     self:sendLoginByVisitor(self.account_key)

        local function showAnimation()
            self:sendLoginByExistsUserAndPwd()
        end

        local action = cc.Sequence:create(cc.DelayTime:create(0.5), cc.CallFunc:create(showAnimation))
        self:runAction(action)
    end

    local layer = createBlockLayer()
    if layer then
        self:addChild(layer)
    end

    -- if DEBUG == 1 then
    --     local _info = cc.Director:getInstance():getTextureCache():getCachedTextureInfo()
    --     print(_info)
    -- end

    -- local sharedDirector = cc.Director:getInstance()
    -- local glsize = sharedDirector:getWinSize()

    -- local _htmlLabel = cc.CCHTMLLabel:createWithString("<img src='res/close.png'/>中国<font face='font1' color='#ff0000'>你好</font><font face='font3' color='#ffff00'>html测试</font><a id='2000' name='reload' href='reload' bgcolor='#000080' >Touch Reload!</a>",
    --     cc.size(glsize.width*0.8, glsize.height), "default")
    -- -- htmllabelsetAnchorPoint(Vec2(0.5f,0.5f));
    -- _htmlLabel:setPosition(glsize.width*0.5, glsize.height*0.5)



    -- -- _htmlLabel:registerListener(this, &HTMLTest::onHTMLClicked, &HTMLTest::onHTMLMoved );

    -- self:addChild(_htmlLabel)


    -- game.addSpriteFramesWithFile("res/animate/hero_10055_all.plist")

    -- local _sprte = game.newSprite("#hero_10055_2.png")
    -- local sharedDirector = cc.Director:getInstance()
    -- local glsize = sharedDirector:getWinSize()
    -- _sprte:setPosition(glsize.width/2, glsize.height/2)
    -- self:addChild(_sprte)
end

function PlatformOfficial:onBegin( ... )
    -- body
end

-- 用户注册 响应回调
function PlatformOfficial:registerResponse(status, response)
    local data = {}
    if status == 200 then  -- 成功
           data = parseJson(response)
    else
        -- getOtherModule():showToastView(Localize.query("login.1"))
        getOtherModule():showAlertDialog(nil, Localize.query("login.1"))
        return
    end
    -- print("注册返回结果 =============== ", self.isTourist)
    -- table.print(data)
    if data.result == true then
        if self.isTourist then
            self.username = data.account_name
            self.pwd = data.account_password
            cc.UserDefault:getInstance():setStringForKey("isTourist", true)
            cc.UserDefault:getInstance():setStringForKey("tourist_id", data.account_name)
        end
        -- getOtherModule():showToastView(Localize.query("login.3"))
        -- getOtherModule():showAlertDialog(nil, Localize.query("login.3"))
        cc.UserDefault:getInstance():setBoolForKey("first_login", false)
        cc.UserDefault:getInstance():setStringForKey("user_name", self.username)
        cc.UserDefault:getInstance():setStringForKey("password", self.pwd)
        -- cc.UserDefault:getInstance():setStringForKey("server", "");
        cc.UserDefault:getInstance():flush()
        self:sendLogin()  -- 发送登录协议
    elseif data.result_no == 1 then
        -- getOtherModule():showToastView(Localize.query("login.2"))
        getOtherModule():showAlertDialog(nil, Localize.query("login.2"))
    else
        -- getOtherModule():showToastView(Localize.query("login.4"))
        getOtherModule():showAlertDialog(nil, Localize.query("login.4"))
    end
end

-- 用户登录
function PlatformOfficial:loginResponse(status, response)
    local data = {}
    if status == 200 then  -- 成功
        data = parseJson(response)
    else
        -- getOtherModule():showToastView(Localize.query("login.5"))
        print("------------33333333333333------------------")
        getOtherModule():showAlertDialog(nil, Localize.query("login.5"))
        return
    end
    print("登录返回 ============= ")
    table.print(data)
    if data.result == true then
        cc.UserDefault:getInstance():setStringForKey("user_name", self.username)
        cc.UserDefault:getInstance():setStringForKey("password", self.pwd)
        cc.UserDefault:getInstance():flush()

        -- 回调
        local _roleLoginResponse = function(status, response)
            self:roleLoginResponse(status, response)
        end

        g_NetManager:getHttpCenter():sendLoginByPassport(_roleLoginResponse, data.passport)
        -- self.loginNet:sendRoleLogin(data.passport)
    else
        -- getOtherModule():showToastView(Localize.query("login.5"))
        print("------------44444444444444------------------")
        local _mesId = data.result_no
        -- local _mes = getTemplateManager():getLanguageTemplate():getLanguageById(_mesId)
        local _mes = Localize.query("login.5")
        getOtherModule():showAlertDialog(nil, _mes)
    end

end

-- 正式登录成功
function PlatformOfficial:roleLoginResponse(status, response)
    local data = {}
    print(response)
     if status == 200 then  -- 成功
           data = parseJson(response)
    else
        -- getOtherModule():showToastView(Localize.query("login.5"))
        getOtherModule():showAlertDialog(nil, Localize.query("login.5"))
        return
    end

    self.loginNet:setHttpLoginSuccessResponse(data)

    if data.result == true then
        -- getOtherModule():showToastView("登录成功")
        self.loginNet:setServerList(data.servers)
        self:enterServerPanel()
    else
        -- getOtherModule():showToastView(Localize.query("login.5"))
        getOtherModule():showAlertDialog(nil, Localize.query("login.5"))
    end
end

-- 进入服务器列表界面
function PlatformOfficial:enterServerPanel()
    game.getRunningScene():removeAllChildren()

    local ServerList = require("src.app.platform.PVServerList")
    local serverList = ServerList.new("PVServerList")


     game.getRunningScene():addChild(serverList)

end

function PlatformOfficial:initTouchListener()

    -- 取消注册进入登陆界面
    local function onCancleRegister()
        self.tab = 1
        self:switchTab()
    end
    -- 进入注册界面
    local function onRegisterClick()
        self.tab = 2
        self:switchTab()
        -- getPlatformLuaManager():sendQQLogin("QQLogin")
    end

    local function onLogionClick()
        self.username = self.editboxUser:getText()

         -- 用户名验证
        if not self:usernameValidate(self.username) then

            -- self:shake(self.editboxUser, 2, 8)
            return
        end

        self.pwd = self.editboxPwd:getText()
        if not self:pwdValidate(self.pwd) then -- 密码验证
            -- self:shake(self.editboxPwd, 2, 8)
            return
        end
        -- self.username = "zzz333333"
        -- self.pwd = "111111"

        -- self.pwd = crypto.md5(self.pwd, false)

        -- 发送登录协议
        self:sendLogin()

    end

    -- 游客登录
    local function onVisitorLogin()
        -----游客登录相关----------
        local tourist = "True"
        local udid = ""
        if device.platform == "ios" then
            udid = getPlatformLuaManager():accessDiffPlatform("getDeviceUDID")
        elseif device.platform == "android" then
            print("uidid ========android====== ")
            -- local deviceId = getPlatformLuaManager():accessDiffPlatform("getDeviceId")
            udid = getPlatformLuaManager():accessDiffPlatform("getDeviceId")
        end
        print("uidid ============== ", udid)
        local account_key = cc.UserDefault:getInstance():getStringForKey("account_key")
        -- print("account_key =============== ", account_key)
        local server = cc.UserDefault:getInstance():getStringForKey("server")
        -- print("server ============== ", server)
        if string.len(account_key) > 5 and  server == SOCKET_URL then  -- 如果选择的是另外一台服务器则需要跳过这个
            self:sendLoginByVisitor(account_key)
            return
        end

        self.isTourist = true
        cc.UserDefault:getInstance():setBoolForKey("isTourist", true)
        getDataManager():getCommonData():setIsTourist(true)
        print("getDataManager():getCommonData():setIsTourist(true) ", getDataManager():getCommonData():getIsTourist())
        local touristCallFunc = function(status, response)
            local data = {}
            if status == 200 then  -- 成功
                   data = parseJson(response)
            else
                getOtherModule():showAlertDialog(nil, Localize.query("login.1"))
                return
            end
            print("游客登录查询 ============= ")
            table.print(data)
            if not data.result then
                cc.UserDefault:getInstance():setBoolForKey("isBound", false)
                local registerCallFunc = function(status, response)
                    self:registerResponse(status, response)
                end
                print("不存在的就进行注册 =========== ")
                g_NetManager:getHttpCenter():sendThirdRigister(registerCallFunc, "tourist", "", tourist, udid)
            else
                self.username = data.account_name
                self.pwd = data.account_password

                -- getOtherModule():showToastView(Localize.query("login.3"))
                -- getOtherModule():showAlertDialog(nil, Localize.query("login.3"))
                cc.UserDefault:getInstance():setBoolForKey("first_login", false)
                cc.UserDefault:getInstance():setStringForKey("user_name", data.account_name)
                cc.UserDefault:getInstance():setStringForKey("password", data.account_password)
                cc.UserDefault:getInstance():setBoolForKey("isTourist", true)
                cc.UserDefault:getInstance():setStringForKey("tourist_id", data.account_name)
                cc.UserDefault:getInstance():setStringForKey("isBound", true)

                -- cc.UserDefault:getInstance():setStringForKey("server", "");
                cc.UserDefault:getInstance():flush()

                self:sendLogin()  -- 发送登录协议
            end
        end

        g_NetManager:getHttpCenter():sendTouristLogin(touristCallFunc, udid)

        -----游客登录相关----------

        -- self.isTourist = true
        -- local data = {type=1}
        -- self.loginNet:sendRegisterUser(data)

        -- local registerCallFunc = function(status, response)
        --     self:registerResponse(status, response)
        -- end

        -- g_NetManager:getHttpCenter():sendThirdRigister(registerCallFunc, "tourist", "", tourist)


        ----qq登录相关-------
        -- getPlatformLuaManager():sendQQLogin("QQLogin")
        -- getPlatformLuaManager():sendWXLogin("WXLogin")

    end

    --qq登录
    local function sendQQLoginClick()
        getPlatformLuaManager():sendQQLogin("QQLogin")
    end

    --微信登录
    local function sendWXLoginClick()
        getPlatformLuaManager():sendWXLogin("WXLogin")
    end

    -- 确认注册
    local function onSureRegister()
        self.username = self.editboxUser:getText()
        print("onSureRegister ===== self.username ====== ", self.username)
        -- 用户名验证
        if not self:usernameValidate(self.username) then
             -- self:shake(self.editboxUser, 2, 8)
            return
        end

        self.pwd = self.editboxPwd:getText()
        print("onSureRegister ====== self.pwd ===== ", self.pwd)
        if not self:pwdValidate(self.pwd) then
             -- self:shake(self.editboxPwd, 2, 8)
            return
        end

        local surePwd = self.editboxSurePwd:getText()
        if surePwd ~= self.pwd then
            -- self:shake(self.editboxSurePwd, 2, 8)
            -- getOtherModule():showToastView(Localize.query("login.6"))
            getOtherModule():showAlertDialog(nil, Localize.query("login.6"))
            return
        end

        -- self.pwd = crypto.md5(self.pwd, false)
        -- local data = {type=2, user_name=self.username, password=self.pwd}
        -- self.loginNet:sendRegisterUser(data)
        -- 回调
        local registerCallFunc = function(status, response)
            self:registerResponse(status, response)
        end

        g_NetManager:getHttpCenter():sendThirdRigister(registerCallFunc, self.username, self.pwd, "false", "")
    end

    self.LoginView["LoginView"] = {}
    self.LoginView["LoginView"]["onLogionClick"] = onLogionClick
    self.LoginView["LoginView"]["onRegisterClick"] = onRegisterClick
    self.LoginView["LoginView"]["onVisitorLogin"] = onVisitorLogin

    self.LoginView["LoginView"]["onSureRegister"] = onSureRegister
    self.LoginView["LoginView"]["onCancleRegister"] = onCancleRegister
end

-- 检验用户名
function PlatformOfficial:usernameValidate(username)

    if string.len(username)<=0 then
        -- getOtherModule():showToastView(Localize.query("login.7"))
        getOtherModule():showAlertDialog(nil, Localize.query("login.7"))
        return false
    elseif string.len(username) < 6 or string.len(username) > 20 then
        -- getOtherModule():showToastView(Localize.query("login.8"))
        getOtherModule():showAlertDialog(nil, Localize.query("login.8"))
        return false
    elseif not self:strMatchDigitOrChar(username) then
        -- getOtherModule():showToastView(Localize.query("login.8"))
        getOtherModule():showAlertDialog(nil, Localize.query("login.8"))
        return false
    end

    return true
end

-- 字符串是否是(0~9 or a~z or A~Z)
function PlatformOfficial:strMatchDigitOrChar(str)
    if not str and string.len(str)<=0 then
        return false
    end

    local x = string.match(str, "[%w]+", 1)

    return x == str
end

-- 检验密码
function PlatformOfficial:pwdValidate(pwd)
    print(pwd)
    if string.len(pwd)<=0 then
        -- getOtherModule():showToastView(Localize.query("login.9"))
        getOtherModule():showAlertDialog(nil, Localize.query("login.9"))
        return false
    elseif string.len(pwd) < 6 or string.len(pwd) > 20 then
        -- getOtherModule():showToastView(Localize.query("login.10"))
        getOtherModule():showAlertDialog(nil, Localize.query("login.10"))
        return false
    elseif not self:strMatchDigitOrChar(pwd) then
        -- getOtherModule():showToastView(Localize.query("login.10"))
        getOtherModule():showAlertDialog(nil, Localize.query("login.10"))
        return false
    end

    return true
end

-- 用户登录第三方
function PlatformOfficial:sendLogin()
    -- local data = {
    --         key = { key = "" },
    --         user_name = self.username,
    --         password = self.pwd
    --         }

    local _httpResponse = function(status, response)
        self:loginResponse(status, response)
    end
    print("self.username, self.pwd ============ ", self.username,   self.pwd)
    local isBound = cc.UserDefault:getInstance():getBoolForKey("isBound", false)
    if isBound then
        print("self.username, self.pwd ============ isBound ==", self.username,   self.pwd)
        -- self.username = cc.UserDefault:getInstance():getStringForKey("user_name")
        -- self.pwd = cc.UserDefault:getInstance():getStringForKey("password")
        -- print("self.username, self.pwd ============ isBound", self.username,   self.pwd)
    end
   -- cc.UserDefault:getInstance():getStringForKey("user_name")
   --  self.pwd = cc.UserDefault:getInstance():getStringForKey("password")
    g_NetManager:getHttpCenter():sendThirdLogin(_httpResponse, self.username, self.pwd)
    -- self.loginNet:sendUserLogin(data)
end

-- 游客登录
function PlatformOfficial:sendLoginByVisitor(account_key)

    local data = {
            key = { key = account_key }
            }
    table.print(data)
    -- self.loginNet:sendUserLogin(data)
end

-- 如果已经存在用户名和密码，可以直接登录
function PlatformOfficial:sendLoginByExistsUserAndPwd()

    -- local __sendTimeTick = function ()
        -- 发送登录协议
        self:sendLogin()

    -- end

    -- timer.delayGlobal(__sendTimeTick, 1)

end

function PlatformOfficial:initView()

    game.addSpriteFramesWithFile("res/ccb/resource/ui_login.plist")

    local sharedDirector = cc.Director:getInstance()
    local glsize = sharedDirector:getWinSize()
    self.adapterLayer = cc.Layer:create()
    self.adapterLayer:setContentSize(cc.size(CONFIG_SCREEN_SIZE_WIDTH, CONFIG_SCREEN_SIZE_HEIGHT))
    self.adapterLayer:setPosition(cc.p(glsize.width / 2 - CONFIG_SCREEN_SIZE_WIDTH / 2, glsize.height / 2 - CONFIG_SCREEN_SIZE_HEIGHT / 2))

    self:addChild(self.adapterLayer)

    local proxy = cc.CCBProxy:create()
    local updateView = CCBReaderLoad("login/ui_login_main.ccbi", proxy, self.LoginView)
    self.adapterLayer:addChild(updateView)

    self.loginMenuItem = self.LoginView["LoginView"]["loginMenuItem"]
    self.registerMenuItem = self.LoginView["LoginView"]["registerMenuItem"]
    self.progressNumber = self.LoginView["LoginView"]["progressNumber"]
    self.downloadNumber = self.LoginView["LoginView"]["downloadNumber"]

    self.userNameSprite = self.LoginView["LoginView"]["userNameSprite"]
    self.pwdSprite = self.LoginView["LoginView"]["pwdSprite"]
    self.surePwdSprite = self.LoginView["LoginView"]["surePwdSprite"]
    self.VisitorItem = self.LoginView["LoginView"]["VisitorItem"]

    self.loginNode = self.LoginView["LoginView"]["loginNode"]
    self.registerNode = self.LoginView["LoginView"]["registerNode"]

    if device.platform == "ios" then
        local isBound = cc.UserDefault:getInstance():getBoolForKey("isBound", false)
        -- print("是否进行了绑定 ========= ", isBound)
        if isBound then
            SpriteGrayUtil:drawSpriteTextureGray(self.VisitorItem:getNormalImage())
            self.VisitorItem:setEnabled(false)
        end
    else
        SpriteGrayUtil:drawSpriteTextureGray(self.VisitorItem:getNormalImage())
        self.VisitorItem:setEnabled(false)
    end

    local username = cc.UserDefault:getInstance():getStringForKey("user_name")
    -- 是否需要显示游客登录
    -- if string.len(username) > 1 then

        -- SpriteGrayUtil:drawSpriteTextureGray(self.VisitorItem:getNormalImage())
        -- self.VisitorItem:setEnabled(false)
    -- end

    -- editbox1
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

    -- self.editboxUser:setFontColor(cc.c3b(255,0,0))
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

    self.tab = 1
    self:switchTab()
end

function PlatformOfficial:shake(sender,shakeCount, degree)

    if self.curBox and self.curBox ~= sender then
        stopAction()
    else
        self.curBox = sender
    end

    local posX, posY = sender:getPosition()
    local currentDegree = degree
    local age = 0

    function listener()
        age = age + 0.25;
        if age < shakeCount then
            currentDegree = -currentDegree*0.95;
            self.curBox:setPosition(cc.p(posX, posY-currentDegree))
        else
            stopAction()
        end

    end

    function stopAction()

        timer.unscheduleGlobal(self._shakeTimer)
        self.curBox:setPosition(cc.p(posX, posY))

    end

    self._shakeTimer = timer.scheduleGlobal(listener, 0.035)
end

function PlatformOfficial:switchTab()
    if self.editboxPwd ~= nil then
        self.editboxPwd:setText("")
    end
    if self.editboxSurePwd ~= nil then
        self.editboxSurePwd:setText("")
    end
    if self.editboxUser  ~= nil then
        self.editboxUser:setText("")
    end

    if self.tab == 1 then -- 登陆
        self.loginNode:setVisible(true)
        self.registerNode:setVisible(false)
        self.editboxSurePwd:setVisible(false)

    else --注册
        self.loginNode:setVisible(false)
        self.registerNode:setVisible(true)
        self.editboxSurePwd:setVisible(true)
    end
end

function PlatformOfficial:initData()
   local username = cc.UserDefault:getInstance():getStringForKey("user_name");
   local pwd = cc.UserDefault:getInstance():getStringForKey("password");
   local a = string.len(username)
   print("a a a ================= ", a)
   if string.len(username) > 20 then
        self.editboxUser:setText("")
    else
        self.editboxUser:setText(username)
    end
   -- self.editboxPwd:setText(pwd)
end


return PlatformOfficial

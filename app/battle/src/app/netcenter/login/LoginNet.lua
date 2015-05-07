--
local processor = import("..DataProcessor")
LoginNet = class("LoginNet", BaseNetWork)

USER_NAME = "chuanyue000"
PASSWORD = "123456"

LOGIN_REGISTER_REQUEST     = 1     -- 注册
LOGIN_LOGIN_REQUEST        = 2     -- 登陆
LOGIN_ROLELOGIN_REQUEST    = 4     -- 角色登陆
LOGIN_CREATE_PLAYER_REQUEST    = 5     -- 修改角色名称
LOGIN_KICK = 11


g_netResponselist = {}

function LoginNet:ctor()
    self.super.ctor(self, self.__cname)
    self:init()
    self:initRegisterNet();
    self.serverList = {}
    self.selectServer = {}
    self.httpLoginSuccessResponse = {}
end

function LoginNet:setHttpLoginSuccessResponse(data)

    self.httpLoginSuccessResponse = data
end

function LoginNet:getHttpLoginSuccessResponse()

    return self.httpLoginSuccessResponse
end

function LoginNet:setServerList(serverList)

    self.serverList = serverList
end

function LoginNet:getServerList()

    return self.serverList
end

function LoginNet:setSelectServer(selectServer)

    self.selectServer = selectServer
end

function LoginNet:getSelectServer()

    return self.selectServer
end

function LoginNet:init()

    self.commonData = getDataManager():getCommonData()

end

-- 注册
function LoginNet:sendRegisterUser(data)
    -- local data = {
    --                 type = 2,
    --                 user_name = USER_NAME,
    --                 password = PASSWORD
    --                 }


    self:sendMsg(LOGIN_REGISTER_REQUEST, "AccountInfo", data, true)
end

-- 登录
function LoginNet:sendUserLogin(data)

    local data = {
                    passport = self.httpLoginSuccessResponse.passport
                }

    self:sendMsg(LOGIN_LOGIN_REQUEST, "AccountLoginRequest", data, true)
end

-- 角色登录
function LoginNet:sendRoleLogin(data)
    -- local  _data = { token = "" }
    local _data = {}
    _data["token"] = ""
    _data["plat_id"] = 0
    _data["client_version"] = ""
    _data["system_software"] = ""
    _data["system_hardware"] = ""
    _data["telecom_oper"] = ""
    _data["network"] = ""
    _data["screen_width"] = 0
    _data["screen_hight"] = 0
    _data["density"] = 0
    _data["login_channel"] = 0
    _data["mac"] = ""
    _data["cpu_hardware"] = ""
    _data["memory"] = 0
    _data["gl_render"] = ""
    _data["gl_version"] = ""
    _data["device_id"] = ""

    cclog("---------------发送登陆信息--------------")
    local plat_id = 0
    if device.platform == "ios" then
        plat_id = 0
    elseif device.platform == "android" then
        plat_id = 1
    end

    local system_software = getPlatformLuaManager():accessDiffPlatform("getSystemVersion")
    local system_hardware = getPlatformLuaManager():accessDiffPlatform("getDeviceVersion")
    local cpu_hardware = getPlatformLuaManager():accessDiffPlatform("getCPUInfo")
    local memory = getPlatformLuaManager():accessDiffPlatform("getDevcieMemory")
    local screen_width = getPlatformLuaManager():accessDiffPlatform("getScreenWidth")
    local screen_hight = getPlatformLuaManager():accessDiffPlatform("getScreenHeight")
    local telecom_oper = getPlatformLuaManager():accessDiffPlatform("getISP")
    local network = getPlatformLuaManager():accessDiffPlatform("getNetworkType")
    local gl_render = getPlatformLuaManager():accessDiffPlatform("getGLRenderer")
    local gl_version = getPlatformLuaManager():accessDiffPlatform("getGLVersion")
    local mac = getPlatformLuaManager():accessDiffPlatform("getMacAddress")
    local device_id = getPlatformLuaManager():accessDiffPlatform("getDeviceUDID")
    local density = getPlatformLuaManager():accessDiffPlatform("getScreenDensity")
    -- local client_version = getPlatformLuaManager():accessDiffPlatform("getAppVersionName")


    local client_versionclient_version = nil
    local _versionPath = cc.FileUtils:getInstance():getWritablePath() .. "version"
    local _isExists = cc.FileUtils:getInstance():isFileExist(_versionPath)
    if _isExists then
        local f = io.open(_versionPath,"r")
        client_version = f:read("*all")
        f:close()
    else
        client_version = "1.0.10"

    end
    _data["token"] = ""
    _data["plat_id"] = plat_id
    _data["client_version"] = client_version
    _data["system_software"] = system_software
    _data["system_hardware"] = system_hardware
    _data["telecom_oper"] = telecom_oper
    _data["network"] = network
    _data["screen_width"] = tonumber(screen_width)
    _data["screen_hight"] = tonumber(screen_hight)
    _data["density"] = tonumber(density)
    -- _data["login_channel"] = 0
    _data["mac"] = mac
    _data["cpu_hardware"] = cpu_hardware
    _data["memory"] = tonumber(memory)
    _data["gl_render"] = gl_render
    _data["gl_version"] = gl_version
    _data["device_id"] = device_id
    cclog("-----------------123---------------")
    table.print(_data)

    self:sendMsg(LOGIN_ROLELOGIN_REQUEST, "GameLoginRequest", _data, true)
end

-- 修改角色名字   临时使用
function LoginNet:sendCreatePlayerNickName(cur_name)
    self.name = cur_name
    local  data = { nickname = cur_name }
    self:sendMsg(LOGIN_CREATE_PLAYER_REQUEST, "CreatePlayerRequest", data, true)

end

--注册接受网络协议
function LoginNet:initRegisterNet()

    local function registerCallBack(data)
        self.commonData:setUserName("")
        local data = {}
        data.result = false
        getDataProcessor():setCreateResult(data)
        -- getDataManager():getCommonData():setAccountResponse(data)
        self.commonData:setAccountResponse(data)
        -- table.print(data)
        -- self:sendUserLogin(data)    --发送登录
    end

    local function loginCallBack(data)
         print("<<< -- Response Login CallBack  -- >>>")
        table.print(data)
        --getDataManager():getCommonData():setAccountResponse(data)
        self.commonData:setAccountResponse(data)
        if data.result then
            self:sendRoleLogin(data)    --发送角色登录
        end

    end

    local  function roleLoginCallBack(data)
        print("<<< -- Response releLogin CallBack  -- >>>")
        table.print(data)

        -- getDataManager():getCommonData():setData(data)
        self.commonData:setData(data)

        if g_isReconnect == false then
            getNetManager():sendPreLoadNet()
        else
            getHomeBasicAttrView():updateData()
        end
    end

    local  function createPlayerCallBack(data)
        processor:setCreateResult(data)
        -- processor:setCommonResponse(data)
        if data.result then
            self.commonData:setUserName(self.name)
            if ISSHOW_GUIDE then
                --fix bug(补丁)
            end
        else
            -- getOtherModule():showToastView("该名字已被占用")
            getOtherModule():showAlertDialog(nil, Localize.query("LoginNet.1"))
        end
    end

    local function loginKickCallBack(data)
        g_isLoginOut = true --当前用户被踢出之后需要断开
        print("被踢出 ============ ")
        table.print(data)
        local  sure = function()
            enterMenuScene()
        end
        getOtherModule():showAlertDialog(sure, Localize.query("LoginNet.2"))
    end

    self:registerNetMsg(LOGIN_CREATE_PLAYER_REQUEST, "CommonResponse", createPlayerCallBack)
    self:registerNetMsg(LOGIN_REGISTER_REQUEST, "AccountResponse", registerCallBack)
    self:registerNetMsg(LOGIN_ROLELOGIN_REQUEST, "GameLoginResponse", roleLoginCallBack)
    self:registerNetMsg(LOGIN_LOGIN_REQUEST, "AccountResponse", loginCallBack)
    self:registerNetMsg(LOGIN_KICK, "AccountKick", loginKickCallBack)

end

return LoginNet

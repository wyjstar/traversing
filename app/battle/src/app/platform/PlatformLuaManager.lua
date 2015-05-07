
-- 不同渠道登陆管理


require("src.app.controller.GameController")
local PlatformLuaManager = class("PlatformLuaManager")

local APPSTORE = "appstore"
local PP = "pp"
local TENCENT = "tencent"
local MOBARTSGAME = "mobartsgame"

function PlatformLuaManager:ctor()
    print("-----CHANNEL_ID-----",CHANNEL_ID)
    self.channelID =  CHANNEL_ID

    -- 背景音乐
    getAudioManager():playBgMusic()

    self:loginPlatformByChannel()

end

-- 不同渠道登录
function PlatformLuaManager:loginPlatformByChannel()
    print("-----self.channelID-----",self.channelID)
    if self.channelID == APPSTORE then
        self:appstoreLogin()
    elseif self.channelID == TENCENT then
        self:tencentLogin()
    elseif self.channelID == MOBARTSGAME then
        self:mobartsgameLogin()
    elseif self.channelID == PP then
        self:ppLogin()
    end
end

-- 官网登陆
function PlatformLuaManager:appstoreLogin()

    cc.Director:getInstance():getRunningScene():removeAllChildren()

    local Login = require("src.app.platform.PlatformOfficial")
    local login = Login.new("PlatformOfficial")

    game.getRunningScene():addChild(login)

end

-- 腾讯登陆
function PlatformLuaManager:tencentLogin()

    cc.Director:getInstance():getRunningScene():removeAllChildren()

    local Login = require("src.app.platform.PlatformOfficial")
    local login = Login.new("PlatformOfficial")

    game.getRunningScene():addChild(login)

end

-- 艺动登陆
function PlatformLuaManager:mobartsgameLogin()

    cc.Director:getInstance():getRunningScene():removeAllChildren()

    local Login = require("src.app.platform.PlatformOfficial")
    local login = Login.new("PlatformOfficial")

    game.getRunningScene():addChild(login)

end


function PlatformLuaManager:ppLogin()

end

-- luaoc  and luajava

if "ios" == string.lower(device.platform) then
    PLATFORM_BRIDGE_CLASSNAME = "LuaObjectCBridge"
else
    PLATFORM_BRIDGE_CLASSNAME = "LuaJavaBridge"
end


function PlatformLuaManager:accessDiffPlatform(callMethod, args)
    local ok = false
    local ret = ""
    if "ios" == string.lower(device.platform) then
        ok, ret = platformLuaoc.callStaticMethod(PLATFORM_BRIDGE_CLASSNAME, callMethod, args)
    elseif "android" == string.lower(device.platform) then
        local luaj = require "src.framework.extend.platformLuajava"
        local className = "com/transfer/lua/AppActivity"
        local sigs = "()Ljava/lang/String;"
        ok, ret  = luaj.callStaticMethod(className, callMethod, args, sigs)
    end

    cclog("ret:"..ret)

    return ret

end

--qq登录
function PlatformLuaManager:sendQQLogin(callMethod, args)
    print("PlatformLuaManager:sendQQLogin ========== ")
    local ok = false
    local ret = ""
    if "android" == string.lower(device.platform) then
        local luaj = require "src.framework.extend.platformLuajava"
        local className = "com/transfer/lua/AppActivity"
        local sigs = "()V"
        ok, ret  = luaj.callStaticMethod(className, callMethod, args, sigs)

        local loginCallFunc = function(status, response)
            print("sendQQLogin ==== loginCallFunc ==== ")
            self:thirdLoginResponse(status, response)
        end

        local function getThirdLoginInfo(param)
            print("sendQQLogin ========== ", param,  string.len(param))
            if string.len(param) > 0 then
                local infoList = string.split(param, ".")
                for k, v in pairs(infoList) do
                    print("第三方登录信息返回 sendQQLogin -------------- ", v)
                end

            g_NetManager:getHttpCenter():sendThirdLoginCheck(loginCallFunc, infoList[1], infoList[2], 2)

            end
        end
        args = { getThirdLoginInfo }
        sigs = "(I)V"
        ok = luaj.callStaticMethod(className,"getThirdLoginInfo",args,sigs)
        if not ok then
            cclog("call callback error")
        end
    elseif "ios" == string.lower(device.platform) then
        cclog("ios =========== ")
    end
end

--微信登录
function PlatformLuaManager:sendWXLogin(callMethod, args)
    print("PlatformLuaManager:sendWXLogin ========== ")
    local ok = false
    local ret = ""
    if "android" == string.lower(device.platform) then
        local luaj = require "src.framework.extend.platformLuajava"
        local className = "com/transfer/lua/AppActivity"
        local sigs = "()V"
        ok, ret  = luaj.callStaticMethod(className, callMethod, args, sigs)

        local function getThirdLoginInfo(param)
            print("sendWXLogin ========== ", param,  string.len(param))
            if string.len(param) > 0 then
                local infoList = string.split(param, ".")
                for k, v in pairs(infoList) do
                    print("第三方登录信息返回 -------------- ", v)
                end
                local loginCallFunc = function(status, response)
                    print("sendWXLogin ==== loginCallFunc ==== ")
                    self:thirdLoginResponse(status, response)
                end

                g_NetManager:getHttpCenter():sendThirdLoginCheck(loginCallFunc, infoList[1], infoList[2], 1)

            end
        end

        args = { getThirdLoginInfo }
        sigs = "(I)V"
        ok = luaj.callStaticMethod(className,"getThirdLoginInfo",args,sigs)
        if not ok then
            print("call callback error")
        end
    else
    end

    return ret
end

-- 获取第三方登录信息
function PlatformLuaManager:thirdLoginResponse(status, response)
    local data = {}
    if status == 200 then  -- 成功
           data = parseJson(response)
    else
        getOtherModule():showAlertDialog(nil, Localize.query("login.1"))
        return
    end
    print("thirdLoginResponse =============== ")
    table.print(data)
    if data.result == true then
        print("第三方登录校验成功 =========== ")
        getNetManager():getLoginNet():setServerList(data.servers)

        game.getRunningScene():removeAllChildren()

        local ServerList = require("src.app.platform.PVServerList")
        local serverList = ServerList.new("PVServerList")


        game.getRunningScene():addChild(serverList)
    else
        getOtherModule():showAlertDialog(nil, Localize.query("login.5"))
    end
end

function PlatformLuaManager:androidLogin()
    print("----------platformLuajava-----------")
    local args = { 2 , 3}
    local sigs = "(II)I"
    local luaj = require "src.framework.extend.platformLuajava"
    local className = "com/transfer/lua/LuaJavaBridge"
    local ok,ret  = luaj.callStaticMethod(className,"addTwoNumbers",args,sigs)
    if not ok then
        print("luaj error:", ret)
    else
        print("The ret is:", ret)
    end

    local function callbackLua(param)
        if "success" == param then
            print("java call back success")
        end
    end
    args = { "callbacklua", callbackLua }
    sigs = "(I)V"
    ok = luaj.callStaticMethod(className,"callbackLua",args,sigs)
    if not ok then
        print("call callback error")
    end
end

function PlatformLuaManager:iosLogin()
    local args = { num1 = 2 , num2 = 3 }
    local luaoc = require "src.framework.extend.platformLuaoc"
    local className = "LuaObjectCBridge"
    local ok,ret  = luaoc.callStaticMethod(className,"addTwoNumbers",args)
    if not ok then
        print("luaoc error:", ret)
    else
        print("The ret is:", ret)
    end

    local function callback(param)
        if "success" == param then
            print("object c call back success")
        end
    end
    luaoc.callStaticMethod(className,"registerScriptHandler", {scriptHandler = callback } )
    luaoc.callStaticMethod(className,"callbackScriptHandler")

end

return PlatformLuaManager


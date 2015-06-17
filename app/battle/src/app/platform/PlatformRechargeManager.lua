
-- 不同渠道支付管理
local PlatformRechargeManager = class("PlatformRechargeManager")

function PlatformRechargeManager:ctor()
    if device.platform == "ios" then
        PLATFORM_BRIDGE_CLASSNAME = "LuaObjectCBridge"
    elseif device.platform == "android" then
        PLATFORM_BRIDGE_CLASSNAME = "LuaJavaBridge"
    end
end

function PlatformRechargeManager:payDiffPlatform(args)
    -- print(callMethod)
    local ok = false
    local ret = ""
    if "ios" == string.lower(device.platform) then
        -- ok, ret = platformLuaoc.callStaticMethod(PLATFORM_BRIDGE_CLASSNAME, callMethod, args)
    elseif "android" == string.lower(device.platform) then
        -- paystart
        local function callbackPurchasedLua(param)
            print("buy product success", param) 
            getOtherModule():showAlertDialog(nil, Localize.query("PlatformRechargeManager.1"))    --Localize.query("toast.1")
        end
        local _args = { callbackPurchasedLua }
        local sigs = "(I)V"
        local luaj = require "src.framework.extend.platformLuajava"
        local className = "org/PayPlugin/GooglePlayIABPlugin"
        ok  = luaj.callStaticMethod(className,"setLuaFuncId", _args, sigs)
        if not ok then
            print("luaj error: setLuaFuncId failed")
        else
            print("setLuaFuncId successed")
        end

        local sigs = "(Ljava/lang/String;)V"
        ok  = luaj.callStaticMethod(className, "PayStart", args, sigs)
        if not ok then
            print("luaj error: PayStart failed")
        else
            print("PayStart successed")
        end  
    end
end

function PlatformRechargeManager:useAndroid()
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
    sigs = "(Ljava/lang/String;I)V"
    ok = luaj.callStaticMethod(className,"callbackLua",args,sigs)
    if not ok then
        print("call callback error")
    end
end

function PlatformRechargeManager:useIos()
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

return PlatformRechargeManager


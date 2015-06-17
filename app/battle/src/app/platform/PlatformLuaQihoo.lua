
local PlatformLuaQihoo = class("PlatformLuaQihoo")

function PlatformLuaQihoo:ctor()
    self.className = "org/cocos2dx/lua/PlatformComm"

end

function PlatformLuaQihoo:login()
    local args = { 2 , 3}
    local sigs = "(II)I"
    
    local ok,ret  = platformLuaj.callStaticMethod(className,"addTwoNumbers",args,sigs)
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
    ok = platformLuaj.callStaticMethod(className,"callbackLua",args,sigs)
    if not ok then
        print("call callback error")
    end
end

--登录
function PlatformLuaQihoo:doLogin()
    print("doLogin")
    local args = {}
    local sigs = "(V)V"
    
    local ok,ret  = platformLuaj.callStaticMethod(className,"doSdkLogin",args,sigs)
    if not ok then
        print("luaj error:", ret)
    else
        print("The ret is:", ret)
    end
end


return PlatformLuaQihoo


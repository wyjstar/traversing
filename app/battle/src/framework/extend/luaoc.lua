
local platformLuaoc = platformLuaoc or {}

local callStaticMethod = LuaObjcBridge.callStaticMethod

function platformLuaoc.callStaticMethod(className, methodName, args)
    local ok, ret = callStaticMethod(className, methodName, args)
    if not ok then
        local msg = string.format("platformLuaoc.callStaticMethod(\"%s\", \"%s\", \"%s\") - error: [%s] ",
                className, methodName, tostring(args), tostring(ret))
        if ret == -1 then
            print(msg .. "INVALID PARAMETERS")
        elseif ret == -2 then
            print(msg .. "CLASS NOT FOUND")
        elseif ret == -3 then
            print(msg .. "METHOD NOT FOUND")
        elseif ret == -4 then
            print(msg .. "EXCEPTION OCCURRED")
        elseif ret == -5 then
            print(msg .. "INVALID METHOD SIGNATURE")
        else
            print(msg .. "UNKNOWN")
        end
    end
    return ok, ret
end

return platformLuaoc


-- collectgarbage("setpause", 100)
-- collectgarbage("setstepmul", 5000)


require("src.updateConfig")
require("src.framework.init")
require("socket")


math.randomseed(socket.gettime())
logStr = ""
cclog = function(...)
    if DEBUG then
        print(string.format("%s", socket.gettime()), string.format(...))
        
        -- print("path==========" .. path)
        -- if ISSHOWLOG then
        --     logStr = logStr .. string.format(...) .. "\n"
        --     local path = cc.FileUtils:getInstance():getWritablePath()
        --     local f = io.open(path .. "/log.lua", "w")
        --     if not f then return end
            
        --     local s = f:write(logStr)
        --     f:close()

        -- end
    end
end

function __G__TRACKBACK__(msg)
    cclog("----------------------------------------")
    cclog("LUA ERROR: " .. tostring(msg) .. "\n")
    
    cclog(debug.traceback())
    local finalStr = tostring(msg) .. "\n" .. debug.traceback()
    createErrorLayer(finalStr)
    cclog("----------------------------------------")
end

local function main()
    collectgarbage("collect")
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)

     --local MenuScene = require("src.app.scenes.MenuScene")
     --local MenuScene = require("src.app.scenes.MenuScene")
     --game.runWithScene(MenuScene.new())
     --MenuScene = nil
------------------调试战斗-----------------------------
     require("src.app.appinit")
     require("src.app.fightview.init")
     game.runWithScene(getFightScene())
     require("src.app.fightview.init_after")
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    error(msg)
end

-- local MenuScene = require("src.app.scenes.MenuScene")
-- game.runWithScene(MenuScene.new())

 
require("socket.core")
require("src.config")
require("src.framework.init")
require("src.app.controller.GameController")

cclog = function(...)
    print(string.format("%s", socket.gettime()),string.format(...))
end

function __G__TRACKBACK__(msg)
    cclog("----------------------------------------")
    cclog("LUA ERROR: " .. tostring(msg) .. "\n")
    --cclog(debug.traceback())
    cclog("----------------------------------------")
end

collectgarbage("setpause", 100)
collectgarbage("setstepmul", 5000)


local host = 'localhost' -- please change localhost to your PC's IP for on-device debugging
----
local ASSETSDOWNLOADER_CREATE_FILE = 0
local ASSETSDOWNLOADER_NETWORK = 1
local ASSETSDOWNLOADER_UNCOMPRESS = 2
local ASSETSDOWNLOADER_PROTOCOL_PROGRESS = 0
local ASSETSDOWNLOADER_PROTOCOL_SUCCESS = 1
local ASSETSDOWNLOADER_PROTOCOL_ERROR = 2

----
local update = {}

function update.updateGame()
    local function onError(errorCode)
        if errorCode == ASSETSDOWNLOADER_CREATE_FILE then
            cclog("create file error")
        elseif errorCode == ASSETSDOWNLOADER_NETWORK then
            cclog("network error")
        elseif errorCode == ASSETSDOWNLOADER_UNCOMPRESS then
            cclog("upcompress error")
        end
    end

    local function onProgress(percent)
        cclog("downloading %d%%", percent)
    end

    local function onSuccess()
        cclog("downloading ok")
        update.runApp()
    end

    local assets = cc.AssetsDownloader:new("http://192.168.1.200/bianweifeng/gameupdate/src.zip", cc.FileUtils:getInstance():getWritablePath() .. "update/")
    assets:retain()
    assets:setDelegate(onError, ASSETSDOWNLOADER_PROTOCOL_ERROR)
    assets:setDelegate(onProgress, ASSETSDOWNLOADER_PROTOCOL_PROGRESS)
    assets:setDelegate(onSuccess, ASSETSDOWNLOADER_PROTOCOL_SUCCESS)
    assets:setConnectionTimeout(3)
    assets:update()
end

function update.needUpdate()
    return false
end

function update.runApp()
    initialize()
end

function update.main()
    if update.needUpdate() then
        update.updateGame()
    else
        update.runApp()
    end
end
return update
--update.main()

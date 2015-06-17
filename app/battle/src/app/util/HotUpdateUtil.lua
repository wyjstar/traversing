-- HotUpdateUtil.lua
-- @create by QGW
-- @create Date 2015.04.02
-- @descript 主要用于热更新之前就要使用的Util,与Util.lua同时使用

function createBlockLayer()
    local viewHeight = scr.contentScaleFactor * CONFIG_SCREEN_SIZE_HEIGHT
    local viewWidth = scr.contentScaleFactor * CONFIG_SCREEN_SIZE_WIDTH
    local winSize = cc.Director:getInstance():getWinSize()

    if viewHeight < scr.heightInPixels then
        local height = (winSize.height - CONFIG_SCREEN_SIZE_HEIGHT) / 2 + 22
        local width = winSize.width
        local size = cc.size(width, height)
        --local layerUp = cc.LayerColor:create(cc.c4b(255, 0, 0, 255), width, height)
        local layerUp = cc.Scale9Sprite:create("res/ui/ui_size_up.png")
        layerUp:setContentSize(size)
        layerUp:setAnchorPoint(cc.p(0,1))
        layerUp:setPosition(0, scr.top)
        --local layerBottom = cc.LayerColor:create(cc.c4b(255, 0, 0, 255), width, height)
        local layerBottom = cc.Scale9Sprite:create("res/ui/ui_size_down.png")
        size = cc.size(width, height)
        layerBottom:setContentSize(size)
        layerBottom:setAnchorPoint(cc.p(0,0))
        layerBottom:setPosition(0, 0)
        local node = game.newLayer()
        node:addChild(layerUp)
        node:addChild(layerBottom)
        return node
    elseif viewWidth < scr.widthInPixels then
        local width = (winSize.width - CONFIG_SCREEN_SIZE_WIDTH) / 2 + 21
        local height = winSize.height
        local size = cc.size(width + 2, height)
        local size1 = cc.size(width + 4, height)
        --local layerLeft = cc.LayerColor:create(cc.c4b(0, 0, 0, 255), width, height)
        local layerLeft = cc.Scale9Sprite:create("res/ui/ui_size_ce.png")
        layerLeft:setContentSize(size1)
        layerLeft:setAnchorPoint(cc.p(0, 0))
        layerLeft:setPosition(cc.p(0, 0))
        --local layerRight = cc.LayerColor:create(cc.c4b(0, 0, 0, 255), width, height)
        local layerRight = cc.Scale9Sprite:create("res/ui/ui_size_ce_right.png")
        layerRight:setContentSize(size)
        layerRight:setAnchorPoint(cc.p(1, 0))
        layerRight:setPosition(cc.p(scr.right, 0))
        local node = game.newNode()
        node:setAnchorPoint(cc.p(0.5,0.5))
        node:addChild(layerLeft)
        node:addChild(layerRight)
        return node
    end
    return nil
end

if "ios" == string.lower(device.platform) then
    PLATFORM_BRIDGE_CLASSNAME = "LuaObjectCBridge"
else
    PLATFORM_BRIDGE_CLASSNAME = "LuaJavaBridge"
end


function accessDiffPlatform(callMethod, args)
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
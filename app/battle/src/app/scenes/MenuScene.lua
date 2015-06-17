

local MenuScene = class("MenuScene", function()
    return game.newScene("MenuScene")
end)

local Logo = import("..ui.logo.Logo")

function MenuScene:ctor()
    self._languageTable = {}
    self:init()
end

function MenuScene:init()

    -- 获取渠道ID
    if device.platform == "ios" or device.platform == "mac" then
        CHANNEL_ID = PlatformManager:getPlatform()
    else
        local luaj = require("src.framework.extend.platformLuajava")
        local className = "com/transfer/lua/AppActivity"
        local sigs = "()Ljava/lang/String;"
        local callMethod = "getChannelID"
        local ok, ret  = luaj.callStaticMethod(className, callMethod, args, sigs)

        CHANNEL_ID = ret
    end

end

function MenuScene:onSceneEnter()
    local logo = self:getChildByTag(10001)
    if logo == nil then
        local _Logo = Logo.new("Logo")
        _Logo:setTag(10001)
        self:addChild(_Logo)
        
    end
end

function MenuScene:playCartoon()
     game.getRunningScene():removeAllChildren()

    local PVCartoon = require("src.app.platform.PVCartoon")
    local _pvCartoon = PVCartoon.new("PVCartoon")
    game.getRunningScene():addChild(_pvCartoon)

end

--通知ui更新
function MenuScene:onNetMsgUpdateUI(_id, _data)
    print("MenuScene:onNetMsgUpdateUI========", _id)
    if _id == FRIEND_LIST_REQUEST then

        getOtherModule():removeNetLoading()
        --local first_login = cc.UserDefault:getInstance():getBoolForKey("first_login", false)
        -- 如果是新手引导出现中断情况下做的标记
        g_isInterrupt = false
        --if not first_login and ISSHOW_GUIDE then
        if ISSHOW_GUIDE then
            local index = getDataManager():getCommonData().newbee_guide_id
            if index ~= 0 and index ~= -1 then
                local backId = getNewGManager():getBackId(index)
                if backId ~= -1 then
                    index=backId
                    g_isInterrupt = true
                end
            end

            -- print("--index---", index)
             --index = 

            getNewGManager():setCurrentGID(index)

            if index ==nil or index ==0 or index == GuideId.G_START_GUIDE_FIGHT then
                self:playCartoon()
            else
                game.getRunningScene():removeAllChildren()
                enterPlayerScene()                
            end
        else
            game.getRunningScene():removeAllChildren()

            enterPlayerScene()
            return
        end
    else
        if _id == NewbeeGuideStep then
            return      
        end
        getOtherModule():showNetLoading()
    end

    local children = self:getChildren()

    for k, v in pairs(children) do
        if v~= nil and v.receiveMsg then
            v:receiveMsg(_id, _data)
        end
    end
end


return MenuScene

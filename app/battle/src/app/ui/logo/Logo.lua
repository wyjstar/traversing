--Logo

local Logo = class("Logo", function ()
    return cc.Node:create()
end)


function Logo:ctor(id)

    self:initView()
end

function Logo:initView()
    local s = cc.Director:getInstance():getWinSize()
    local  bg_layer = cc.LayerGradient:create(cc.c4b(254,255,255,255), cc.c4b(169,169,169,255))
    bg_layer:setContentSize(cc.size(s.width, s.height))
    bg_layer:ignoreAnchorPointForPosition(true)
    self:addChild(bg_layer, -1)

    game.addSpriteFramesWithFile("res/ccb/resource/ui_logo.plist")

    self.shieldlayer = game.createShieldLayer()
    self:addChild(self.shieldlayer)
    self.shieldlayer:setTouchEnabled(true)

    local sharedDirector = cc.Director:getInstance()
    local glsize = sharedDirector:getWinSize()
    self.adapterLayer = cc.Layer:create()

    self.adapterLayer:setContentSize(cc.size(CONFIG_SCREEN_SIZE_WIDTH, CONFIG_SCREEN_SIZE_HEIGHT))

    self.adapterLayer:setPosition(cc.p(glsize.width / 2 - CONFIG_SCREEN_SIZE_WIDTH / 2, glsize.height / 2 - CONFIG_SCREEN_SIZE_HEIGHT / 2))

    self:addChild(self.adapterLayer)
    -- self.UILogo = {}
    -- local proxy = cc.CCBProxy:create()
    -- local node = CCBReaderLoad("logo/ui_logo.ccbi", proxy, self.UILogo)
    -- if node == nil then
    --     cclog("Error: in loadCCBI _name==" .. _name)
    --     return
    -- end

    -- self.adapterLayer:addChild(node)
    self:logoShow()
    self:delayCallFunc()
end
function Logo:logoShow()
    local logoTC = game.newSprite("#logoTC.png")
    logoTC:setAnchorPoint(cc.p(0.5,0.5))
    -- local s = cc.Director:getInstance():getWinSize()
    -- -- logoTC:setPosition(cc.p(s.width/2,s.height/2))
    logoTC:setPosition(cc.p(320,500))
    self.adapterLayer:addChild(logoTC)
    logoTC:setTag(1000)
    local function onConvertLogo()
        self.adapterLayer:removeChildByTag(1000)
        self.UILogo = {}
        local proxy = cc.CCBProxy:create()
        local node = CCBReaderLoad("logo/ui_logo.ccbi", proxy, self.UILogo)
        if node == nil then
            cclog("Error: in loadCCBI _name==" .. _name)
            return
        end

        self.adapterLayer:addChild(node)
    end
    self:runAction(cc.Sequence:create(cc.DelayTime:create(2),cc.CallFunc:create(onConvertLogo)))
end
function Logo:delayCallFunc()

    local onConvertPanel = function()
        if g_isLoadResource == nil then
            local PVVersionUpdatePanel = require("src.app.ui.versionupdate.PVVersionUpdatePanel")
            local _PVVersionUpdatePanel = PVVersionUpdatePanel.new("PVVersionUpdatePanel")

            cc.Director:getInstance():getRunningScene():removeAllChildren()

            game.getRunningScene():addChild(_PVVersionUpdatePanel)
        else
            g_PlatformLuaManager = require("src.app.platform.PlatformLuaManager")
            g_PlatformLuaManager.new("PlatformLuaManager")
        end

    end

    -- self:runAction(cc.Sequence:create(cc.DelayTime:create(2),cc.CallFunc:create(onConvertPanel)))
    self:runAction(cc.Sequence:create(cc.DelayTime:create(4),cc.CallFunc:create(onConvertPanel)))

end

-- function Logo:playVideo()

--     function videoPlayCallBack()
--         print("--videoPlayCallBack---call back")
--     end

--     local _PvNotice = PvNotice.new("PvNotice")
--     _PvNotice:openWebView(NOTICE_URL)
--     self:addChild(_PvNotice)


--     -- local videoManager = VideoManager:getInstance()
--     -- VideoManager:playVideo("res/video/cg.mp4", cc.CallFunc:create(videoPlayCallBack))
--     -- WebViewManager:openWebView("http://mobartsgame.com", cc.CallFunc:create(openWebviewCallBack))
--     --cc.Video:play("res/video/cg.mp4", rect)
--     -- 09-02 17:59:28.705: D/wpa_supplicant(1276): nl80211: survey data missing!

-- end

return Logo

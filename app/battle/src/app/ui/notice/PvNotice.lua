
local PvNotice = class("PvNotice", BaseUIView)

function PvNotice:ctor(id)
    self.super.ctor(self, id)
    self.UINoticeView = {}
    
    self:onMVCEnter()

    self.target = nil
    self.callfunc = nil

end

function PvNotice:onMVCEnter()
    --game.addSpriteFramesWithFile("res/ccb/resource/ui_common.plist")
    game.addSpriteFramesWithFile("res/ccb/resource/ui_notice.plist")
    --添加屏蔽层
    self:initBaseUI()

    self:initTouchListener()

    self:loadCCBI("common/ui_common_notice.ccbi", self.UINoticeView)

    self:initView()
   
end

function PvNotice:initView()

    local function callfunc()
        print("-webview-callfunc--")
    end

    self.contentLayer = self.UINoticeView["UICommonNotice"]["contentLayer"]  -- webview 显示区域
   
end

function PvNotice:openWebView(url)
    -- self.target = target
    -- self.callfunc = callfunc
    local function callfunc( ... )
        -- body
    end 
    WebViewManager:openWebView(url, CONFIG_SCREEN_AUTOSCALE, self.contentLayer, cc.CallFunc:create(callfunc))
end

function PvNotice:initTouchListener()
    
    function onCloseClick()
        print("=---onCloseClick--")
        WebViewManager:removeWebView()
        self:removeFromParent()
        if self.callfunc then
            self.target:callfunc()
        end

        -- game.removeSpriteFramesWithFile("res/ccb/resource/ui_notice.plist")
    end

    self.UINoticeView["UICommonNotice"] = {}
    self.UINoticeView["UICommonNotice"]["onCloseClick"] = onCloseClick

end


return PvNotice

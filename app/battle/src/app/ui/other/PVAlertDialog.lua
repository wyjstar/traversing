-- 公共 alert dialog
-- 需要三个参数，1， 确定（回调函数） 2，取消（回调函数） 3，文字内容

local PVAlertDialog = class("PVAlertDialog", BaseUIView)

COMMON_TIPS_BOOL_RETURN = nil

function PVAlertDialog:ctor(id)
    PVAlertDialog.super.ctor(self, id)
    -- print("PVAlertDialog, ctor ...")
end

function PVAlertDialog:onMVCEnter()
     self:initBaseUI()
     
    local s = cc.Director:getInstance():getWinSize()
    local bg_color = cc.LayerColor:create(cc.c4b(0,0,0,150))

    bg_color:setContentSize(cc.size(s.width, s.height))
    bg_color:ignoreAnchorPointForPosition(true)
    self:addChild(bg_color, -1)

	self.ccbiNode = {}
	self:initTouchListener()
    self:loadCCBI("common/ui_common_tips.ccbi", self.ccbiNode)
    self:initView()
    self:initData()
end

function PVAlertDialog:initParams(sureCallfunc, text, callfunc)
    self.sureCallfunc = sureCallfunc
    self.text = text
    self.callfunc = callfunc
end

function PVAlertDialog:initData()
	
	self.tipsText = self.text
    self.labelTips:setString(self.tipsText)
end

function PVAlertDialog:initTouchListener()

    local function onMenuClickOk()
        if self.sureCallfunc ~= nil then
            self.sureCallfunc()
            self.callfunc()
        end

        self:removeFromParent()
    end

    local function onMenuClickCancle()
        if self.cancelCallfunc ~= nil then
            self.cancelCallfunc()
            self.callfunc()
        end
        
        self:removeFromParent()
    end

    local function onMenuClickOk_1()
        self.callfunc()
        if self.sureCallfunc ~= nil then
            self.sureCallfunc()
        end
        self:removeFromParent()
    end

    self.ccbiNode["UICommonTipsView"] = {}
    self.ccbiNode["UICommonTipsView"]["onSureClick"] = onMenuClickOk
    self.ccbiNode["UICommonTipsView"]["onCancleClick"] = onMenuClickCancle
    self.ccbiNode["UICommonTipsView"]["menuClickOk"] = onMenuClickOk_1
    self.ccbiNode["UICommonTipsView"]["onCloseClick"] = onMenuClickCancle

    local function onRelease( code,event )
        print("PVAlertDialog,onRelease:",code)
        if code == 6 then --Click Back Key
            if not getNewGManager():checkStageGuide() then --非新手引导过程中
                onMenuClickOk_1()
            end
        end
    end

    local function onKeyPressed( code,event )
    end

    local key_listener = cc.EventListenerKeyboard:create()
    key_listener:retain()
    key_listener:registerScriptHandler(onRelease,cc.Handler.EVENT_KEYBOARD_RELEASED)
    key_listener:registerScriptHandler(onKeyPressed,cc.Handler.EVENT_KEYBOARD_PRESSED)
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(key_listener,self)
end

function PVAlertDialog:initView()
	self.labelTips = self.ccbiNode["UICommonTipsView"]["detailLabel1"]

    self.menuCloseBtn = self.ccbiNode["UICommonTipsView"]["menu_close"]  -- close btn
	self.layerOneButton = self.ccbiNode["UICommonTipsView"]["oneBtnLayer"]
	self.layerTwoButton = self.ccbiNode["UICommonTipsView"]["twoBtnLayer"]

    self.layerOneButton:setVisible(true)
    self.layerTwoButton:setVisible(false)
    self.menuCloseBtn:setVisible(false)

end


return PVAlertDialog

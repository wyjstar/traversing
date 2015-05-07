-- 公共UI
-- 使用：getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("SystemTips", "your tips text" [, 1 ]): type:1,一个按钮模式,默认就是2
-- 在弹出此界面的UI类中添加更新函数onReloadView：根据COMMON_TIPS_BOOL_RETURN判断返回值.

local SystemTips = class("SystemTips", BaseUIView)

COMMON_TIPS_BOOL_RETURN = nil

function SystemTips:ctor(id)
    SystemTips.super.ctor(self, id)
end

function SystemTips:onMVCEnter()
    self.c_BaseTemplate = getTemplateManager():getBaseTemplate()

    self:initData()
	self.ccbiNode = {}
	self:initTouchListener()
    self:loadCCBI("common/ui_common_tips.ccbi", self.ccbiNode)
    self:initView()
end

function SystemTips:initData()
	assert(self.funcTable ~= nil, "if you used SystemTips UI, you must to give a text in !")

    -- for k,v in pairs(self.funcTable) do
    --     if type(v) == "string" then self.tipsText = v end
    --     if type(v) == "number" then self.type = v end
    -- end

    self.tipsText = self.funcTable[1]
    self.type = self.funcTable[2]
    print("self.tipsText ============ ", self.tipsText)
    print("self.type ============ ", self.type)
    self.typeIndex = self.funcTable[3]
    print("initData ============== ", self.typeIndex)
    -- print("^^^^^^", self.tipsText, self.type)
    -- table.print(self.funcTable)
end

function SystemTips:setOneButtonModel()
	self.layerOneButton:setVisible(true)
	self.layerTwoButton:setVisible(false)
    self.menuCloseBtn:setVisible(false)
end

function SystemTips:setTwoButtonModel()
    self.layerOneButton:setVisible(false)
    self.layerTwoButton:setVisible(true)
    self.menuCloseBtn:setVisible(true)
end

function SystemTips:initTouchListener()

    local function onMenuClickOk()
        getAudioManager():playEffectButton2()
        cclog("------ click OK")
        COMMON_TIPS_BOOL_RETURN = true
        self:onHideView()
    end
    local function onMenuClickCancle()
        getAudioManager():playEffectButton2()
    	cclog("---- click cancle")
    	COMMON_TIPS_BOOL_RETURN = false
        self:onHideView()
    end
    local function onMenuClickOk_1()
        getAudioManager():playEffectButton2()
    	cclog("one model ---- click ok !")
    	self:onHideView()
    end

    self.ccbiNode["UICommonTipsView"] = {}
    self.ccbiNode["UICommonTipsView"]["onSureClick"] = onMenuClickOk
    self.ccbiNode["UICommonTipsView"]["onCancleClick"] = onMenuClickCancle
    self.ccbiNode["UICommonTipsView"]["onMenuOk"] = onMenuClickOk_1
    self.ccbiNode["UICommonTipsView"]["onCloseClick"] = onMenuClickCancle
    self.ccbiNode["UICommonTipsView"]["menuClickOk"] = onMenuClickOk_1

end

function SystemTips:initView()
	self.labelTips = self.ccbiNode["UICommonTipsView"]["detailLabel1"]

    self.contentLayer = self.ccbiNode["UICommonTipsView"]["contentLayer"]

    self.contentLayer1 = self.ccbiNode["UICommonTipsView"]["contentLayer1"]
    self.label_money = self.ccbiNode["UICommonTipsView"]["label_money"]
    self.detailLabel2 = self.ccbiNode["UICommonTipsView"]["detailLabel2"]
    self.detailLabel3 = self.ccbiNode["UICommonTipsView"]["detailLabel3"]

    self.menuCloseBtn = self.ccbiNode["UICommonTipsView"]["menu_close"]  -- close btn
	self.layerOneButton = self.ccbiNode["UICommonTipsView"]["oneBtnLayer"]
	self.layerTwoButton = self.ccbiNode["UICommonTipsView"]["twoBtnLayer"]

    -- 赋值
    self.labelTips:setString(self.tipsText)
    -- print("!!!!!!!!!!!!!!!", self.type)
    if self.type == 1 then
        self:setOneButtonModel()
    else
        self:setTwoButtonModel()
    end

    if self.typeIndex ~= nil and self.typeIndex == 1 then
        print("隐藏显示")
        self.contentLayer:setVisible(false)
        self.contentLayer1:setVisible(true)
        local costPrice = self.c_BaseTemplate:getArenaTimePrice()
        self.label_money:setString(costPrice)
        self.detailLabel2:setString(Localize.query("arena.1"))
    end
end


return SystemTips

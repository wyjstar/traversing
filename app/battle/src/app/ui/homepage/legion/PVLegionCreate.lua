--军团创建
import("....datacenter.template.wordcheck.trie_tree")
local CursorInputLayer = import("...input.CursorInputLayer")
--local LabelCommon = import("....ui.other.LabelCommon")

local PVLegionCreate = class("PVLegionCreate", BaseUIView)

function PVLegionCreate:ctor(id)
    PVLegionCreate.super.ctor(self, id)
end

function PVLegionCreate:onMVCEnter()
    self.legionNet = getNetManager():getLegionNet()
    self.legionData = getDataManager():getLegionData()
    self.commonData = getDataManager():getCommonData()
    self.c_BaseTemplate = getTemplateManager():getBaseTemplate()

    self:initView()
    self:registerDataBack()
end

function PVLegionCreate:initView()
    self.UILegionCreateView = {}
    self:initTouchListener()

    self:loadCCBI("legion/ui_legion_create.ccbi", self.UILegionCreateView)
    self.costSuperMoney = self.UILegionCreateView["UILegionCreateView"]["costSuperMoney"]
    self.inputName = self.UILegionCreateView["UILegionCreateView"]["inputName"]
    self.nameLable = self.UILegionCreateView["UILegionCreateView"]["nameLable"]
    self.moneyBMFont = self.UILegionCreateView["UILegionCreateView"]["moneyBMFont"]
    self.nameLable:setVisible(false)

    local needMoney = self.c_BaseTemplate:getBaseInfoById("create_money")
    self.moneyBMFont:setString(needMoney)

    --输入框
    local layerSize = self.inputName:getContentSize()
    self.cursorInputLayer = CursorInputLayer.new()

    local sharedDirector = cc.Director:getInstance()
    local glsize = sharedDirector:getWinSize()

    self.cursorInputLayer:setContentSize(cc.size(CONFIG_SCREEN_SIZE_WIDTH, CONFIG_SCREEN_SIZE_HEIGHT))
    self.cursorInputLayer:setPosition(cc.p(glsize.width / 2 - CONFIG_SCREEN_SIZE_WIDTH / 2, glsize.height / 2 - CONFIG_SCREEN_SIZE_HEIGHT / 2))
    self.cursorInputLayer:initEditBox(layerSize, "请输入要创建的军团的名称", 20)
    self.cursorInputLayer.editName:setPosition(self.nameLable:getPosition())

    self:addChild(self.cursorInputLayer)

end

function PVLegionCreate:initTouchListener()
    --关闭界面
    local function onCloseClick()
        getAudioManager():playEffectButton2()
        self:onHideView()
    end

    --创建公会
    local function onCreateLegionClick()
        self.legionNet:sendGetLegionInfo()
        getAudioManager():playEffectButton2()
        local curLevel = self.commonData:getLevel()
        self.curGold = self.commonData:getGold()

        local needLevel = self.c_BaseTemplate:getBaseInfoById("create_level")
        self.needMoney = self.c_BaseTemplate:getBaseInfoById("create_money")

        --level >= 20级 金币 >= 1000
        if curLevel >= needLevel and self.curGold >= self.needMoney then
            local legionName = self.cursorInputLayer:getInputText()
            print("legionName ======= legionName ======= ", legionName)
            if legionName ~= nil then
                legionName = string.trim(legionName)
                if string.len(legionName) <=0 then
                     -- getOtherModule():showToastView(Localize.query("legion.6"))
                     getOtherModule():showAlertDialog(nil, Localize.query("legion.6"))
                     return
                end
            end

            if legionName ~= nil then
                local checkResult = checkWord.get_bad_word(legionName)
                if checkResult ~= -1 then
                    getOtherModule():showAlertDialog(nil, Localize.query("legion.7"))
                elseif not IsContainPunctu(legionName) then
                    getOtherModule():showAlertDialog(nil, Localize.query("createteam.3"))
                    return
                else
                    local legionInfo = self.legionData:getLegionInfo()
                    if legionInfo == nil then
                        self.legionNet:sendCreateLegion(legionName)
                    else
                        getOtherModule():showAlertDialog(nil, Localize.query("legion.12"))
                    end
                end
            else
                getOtherModule():showAlertDialog(nil, Localize.query("legion.8"))
            end
        elseif curLevel < needLevel then
            getOtherModule():showAlertDialog(nil, Localize.query("legion.9"))
        elseif self.curGold < self.needMoney then
            local str = Localize.query("common.1")
            getOtherModule():showOtherView("PVCommonDialog", str)   --元宝不足提示页
        end
    end

    self.UILegionCreateView["UILegionCreateView"] = {}
    self.UILegionCreateView["UILegionCreateView"]["onCreateLegionClick"] = onCreateLegionClick
    self.UILegionCreateView["UILegionCreateView"]["onCloseClick"] = onCloseClick
end

--网络协议接口注册
function PVLegionCreate:registerDataBack()
    local function cretaCallBack()
        local responsData = self.legionData:getLegionResultData()
        isSucceed = responsData.result
        self.message = responsData.message
        if isSucceed then
            --self.commonData.updateCombatPower()
            self.commonData:setGold(self.curGold - self.needMoney)
            self.legionNet:sendGetLegionInfo()
            self:onHideView()
            getModule(MODULE_NAME_HOMEPAGE):showUINodeView("PVLegionPanel")

        else

            getOtherModule():showAlertDialog(nil, self.message)
        end

    end
    self:registerMsg(CREATE_LEGION, cretaCallBack)
end

return PVLegionCreate

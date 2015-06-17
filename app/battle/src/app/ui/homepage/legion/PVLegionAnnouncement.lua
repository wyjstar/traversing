import("....datacenter.template.wordcheck.trie_tree")
local CursorInputLayer = import("...input.CursorInputLayer")

local PVLegionAnnouncement = class("PVLegionAnnouncement", BaseUIView)

function PVLegionAnnouncement:ctor(id)
    PVLegionAnnouncement.super.ctor(self, id)
end

function PVLegionAnnouncement:onMVCEnter()
    self.legionData = getDataManager():getLegionData()
    self.legionNet = getNetManager():getLegionNet()
    self:initView()
    self:registerCallBack()
end

function PVLegionAnnouncement:registerCallBack()
    local function getCallBack()
        local responsData = self.legionData:getLegionResultData()
        local result = responsData.result
        local message = responsData.message
        if result then
            print("PVLegionAnnouncement ================  bacak")
            self.legionData:setAnouncement(self.editContent)
            self:onHideView()
        end
    end
    self:registerMsg(EDIT_ANNOUNCEMENT, getCallBack)
end

function PVLegionAnnouncement:initView()
    self.UILegionAnnounceView = {}
    self:initTouchListener()
    self:loadCCBI("legion/ui_legion_edit_announce.ccbi", self.UILegionAnnounceView)

    self.contentLayer = self.UILegionAnnounceView["UILegionAnnounceView"]["contentLayer"]
    self.nameLable = self.UILegionAnnounceView["UILegionAnnounceView"]["nameLable"]

    local layerSize = self.contentLayer:getContentSize()
    layerSize = cc.size(layerSize.width-20,layerSize.height)
    -- self.cursorInputLayer = CursorInputLayer.new()

    --self.cursorInputLayer:setAnchorPoint(0.5, 0.5)
    --self.cursorInputLayer:setContentSize(640, 960)
   -- self.cursorInputLayer:setPosition(cc.p(320, 510))

    local sharedDirector = cc.Director:getInstance()
    local glsize = sharedDirector:getWinSize()

    self.editBox = ui.newTextField({
            fontName = const.FONT_NAME,
            maxLength = 50,
            size = layerSize,
            fontSize = 28,
            placeHoder="可输入50个字符",
            verticalAlignment = 1,-- 0 CENTER
            x = self.nameLable:getPositionX()+5,
            y = self.nameLable:getPositionY()+10,
    })

    -- self.cursorInputLayer:setContentSize(cc.size(CONFIG_SCREEN_SIZE_WIDTH, CONFIG_SCREEN_SIZE_HEIGHT))
    -- self.cursorInputLayer:setPosition(cc.p(glsize.width / 2 - CONFIG_SCREEN_SIZE_WIDTH / 2, glsize.height / 2 - CONFIG_SCREEN_SIZE_HEIGHT / 2))
    -- self.cursorInputLayer:initEditBox(layerSize, "", 50)
    -- self.cursorInputLayer.editName:setPosition(self.nameLable:getPosition())

    self.nameLable:getParent():addChild(self.editBox)

end

function PVLegionAnnouncement:initTouchListener()
    --公告编辑成功
    local function onSureClick()
        -- getAudioManager():playEffectButton2()
        self.editContent = self.editBox:getStringValue()
        local checkResult = checkWord.get_bad_word(self.editContent)
        if checkResult ~= -1 then
            getOtherModule():showAlertDialog(nil, Localize.query("legion.1"))
        else
            self.legionNet:sendEditAnounce(self.editContent)
        end

    end

    local function onCloseClick()
        getAudioManager():playEffectButton2()
        self:onHideView()
    end

    self.UILegionAnnounceView["UILegionAnnounceView"] = {}
    self.UILegionAnnounceView["UILegionAnnounceView"]["onSureClick"] = onSureClick
    self.UILegionAnnounceView["UILegionAnnounceView"]["onCloseClick"] = onCloseClick
end

return PVLegionAnnouncement

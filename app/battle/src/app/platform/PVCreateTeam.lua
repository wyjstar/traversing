local CursorInputLayer = import("..ui.input.CursorInputLayer")
local PVCreateTeam = class("PVCreateTeam", BaseUIView)
import("..datacenter.template.wordcheck.trie_tree")

function PVCreateTeam:ctor(id)
    self.super.ctor(self, id)

    self:initView()

    self:initData()

    -- self:initRegisterNetCallBack()
end

function PVCreateTeam:onMVCEnter()

end

-- 注册网络回调
-- function PVCreateTeam:initRegisterNetCallBack()
--     print("PVCreateTeam ==================== 界面 ============= ")
--     local function getCallBack()
--         print("PVCreateTeam ==================== 界面")
--         local resultData = processor:getCommonResponse()
--         if resultData.result then
--             self.createTeam:removeFromParent(true)
--         end
--     end
--     self:registerMsg(LOGIN_CREATE_PLAYER_REQUEST, getCallBack)
-- end

function PVCreateTeam:getRandomTarget(rNum, tempNums)
    local dstTable = {}
    local tempTable = tempNums
    for i = 1, rNum do
        local key = table.randomKey(tempTable)
        table.insert(dstTable, key)
        --tempTable[key] = nil  --如果随机一个删除一个，只可以随机26次
        local size = table.getn(tempTable)
        if size == 0 then
            return dstTable
        end
    end

    return dstTable
end

function PVCreateTeam:initTouchListener()
    --取消
    local function onCancleClick()
        self:onHideView()
    end
    --创建
    local function onCreateClick()
        local randName = self.cursorInputLayer.editName:getText()
        randName = string.trim(randName)
        if string.len(randName) <= 0 then
            getOtherModule():showAlertDialog(nil, Localize.query("createteam.1"))

        else
            local checkResult = checkWord.get_bad_word(randName)
            if checkResult ~= -1 then
                getOtherModule():showAlertDialog(nil, Localize.query("createteam.2"))

                return
            end

            if not IsContainPunctu(randName) then
                getOtherModule():showAlertDialog(nil, Localize.query("createteam.3"))

                return
                -- self.loginNet:sendCreatePlayerNickName(randName)
            else
                self.loginNet:sendCreatePlayerNickName(randName)
            end
        end
    end

    --随机名称
    local function onRandomName()
        local chooseNum1 = self:getRandomTarget(1, self.randNums1)
        local chooseNum2 = self:getRandomTarget(1, self.randNums2)
        local chooseNum3 = self:getRandomTarget(1, self.randNums3)
        local randomTempalte = getTemplateManager():getRandomTemplate()
        local randName3 = randomTempalte:getOfficeById(chooseNum3[1])
        local randName2 = randomTempalte:getPrefix_2ById(chooseNum2[1])
        local randName1 = randomTempalte:getPrefix_1ById(chooseNum1[1])
        self.randName = randName1 .. randName2 .. randName3
        self.cursorInputLayer.editName:setText(self.randName)
    end

    --关闭界面
    local function onCloseClick()
        self:onHideView()
    end

    self.UICreateTeam["UICreateTeam"] = {}
    self.UICreateTeam["UICreateTeam"]["onCancleClick"] = onCancleClick
    self.UICreateTeam["UICreateTeam"]["onCreateClick"] = onCreateClick
    self.UICreateTeam["UICreateTeam"]["onRandomName"] = onRandomName
    self.UICreateTeam["UICreateTeam"]["onCloseClick"] = onCloseClick
end

function PVCreateTeam:onExit()
    cclog("-------onExit----")
    -- self:unregisterScriptHandler()
    getDataManager():getResourceData():clearResourcePlistTexture()
end

function PVCreateTeam:initView()

    self.shieldlayer = game.createShieldLayer()
    self:addChild(self.shieldlayer)
    self.shieldlayer:setLocalZOrder(-200)
    self.shieldlayer:setTouchEnabled(true)

    self.UICreateTeam = {}
    self:initTouchListener()
    self:loadCCBI("login/ui_login_create_team.ccbi", self.UICreateTeam)
    self.nameLable = self.UICreateTeam["UICreateTeam"]["nameLable"]

    --输入框
    local layerSize = self.nameLable:getContentSize()
    self.cursorInputLayer = CursorInputLayer.new()

    local sharedDirector = cc.Director:getInstance()
    local glsize = sharedDirector:getWinSize()
    
    self.cursorInputLayer:setContentSize(cc.size(CONFIG_SCREEN_SIZE_WIDTH, CONFIG_SCREEN_SIZE_HEIGHT))
    self.cursorInputLayer:setPosition(cc.p(glsize.width / 2 - CONFIG_SCREEN_SIZE_WIDTH / 2, glsize.height / 2 - CONFIG_SCREEN_SIZE_HEIGHT / 2))
    self.cursorInputLayer:initEditBox(layerSize, "12个字符或6个汉字", 20)
    self.cursorInputLayer.editName:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
    self.cursorInputLayer.editName:setPosition(self.nameLable:getPosition())

    self:addChild(self.cursorInputLayer)

end

function PVCreateTeam:initData()
    self.randNums1 = {}
    for i = 1, 28 do
        table.insert(self.randNums1, i)
    end

    self.randNums2 = {}
    for i = 1, 37 do
        table.insert(self.randNums2, i)
    end

    self.randNums3 = {}
    for i = 1, 26 do
        table.insert(self.randNums3, i)
    end

    self.loginNet = getNetManager():getLoginNet()
end

return PVCreateTeam

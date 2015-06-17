

local PVLegionPanel = class("PVLegionPanel", BaseUIView)

function PVLegionPanel:ctor(id)
    PVLegionPanel.super.ctor(self, id)
end

function PVLegionPanel:onMVCEnter()
    self:showAttributeView()
    self.legionNet = getNetManager():getLegionNet()
    self.legionData = getDataManager():getLegionData()
    self.legionTempalte = getTemplateManager():getLegionTemplate()
    self.c_Calculation = getCalculationManager():getCalculation()
    self.commonData = getDataManager():getCommonData()
    self:registerDataBack()

    self.legionInfoData = {}


end

--网络协议返回接口
function PVLegionPanel:registerDataBack()
    local function getInfoBack()
        local legionInfo = self.legionData:getLegionInfo()
        if legionInfo ~= nil then
            table.print(legionInfo)
        end
        if legionInfo == nil then
            self.legionNet:sendGetRankList()
            self:onHideView()
            getModule(MODULE_NAME_HOMEPAGE):showUIView("PVLegionApply")
        else
            self:initView()
            self:initData()
        end
    end
    self:registerMsg(PLAYER_GET_LEGION_INFO, getInfoBack)
    -- 原来
    -- local function getInfoBack()
    --     self:initData()
    -- end
    -- self:registerMsg(PLAYER_GET_LEGION_INFO, getInfoBack)

    local function getKillInfoBack()
        showModuleView(MODULE_NAME_HOMEPAGE)
    end
    self:registerMsg(GET_KILL_OUT_TIP, getKillInfoBack)
end

--界面相关内容初始化
function PVLegionPanel:initView()
    game.addSpriteFramesWithFile("res/ccb/resource/ui_legion.plist")

    self.UILegionPanelView = {}
    self:initTouchListener()
    self:loadCCBI("legion/ui_legion_panel.ccbi", self.UILegionPanelView)

    self.legionSprite = self.UILegionPanelView["UILegionPanelView"]["legionSprite"]     --公会图标
    self.legionName = self.UILegionPanelView["UILegionPanelView"]["legionName"]         --公会名称
    self.levelBMFnt = self.UILegionPanelView["UILegionPanelView"]["levelBMFnt"]         --公会等级
    self.legionNumber = self.UILegionPanelView["UILegionPanelView"]["legionNumber"]     --公会成员数
    self.legionScore = self.UILegionPanelView["UILegionPanelView"]["legionScore"]       --公会战绩
    self.legionMoney = self.UILegionPanelView["UILegionPanelView"]["legionMoney"]       --公会资金
    self.legionLevel = self.UILegionPanelView["UILegionPanelView"]["legionLevel"]       --公会等级
    self.legionExp = self.UILegionPanelView["UILegionPanelView"]["legionExp"]           --守护经验
    self.lifeValue = self.UILegionPanelView["UILegionPanelView"]["lifeValue"]           --生命值
    self.attackLabel = self.UILegionPanelView["UILegionPanelView"]["attackLabel"]       --攻击力
    self.phyLabel = self.UILegionPanelView["UILegionPanelView"]["phyLabel"]             --物防
    self.powerValue = self.UILegionPanelView["UILegionPanelView"]["powerValue"]         --法防

    self.applyListSprite = self.UILegionPanelView["UILegionPanelView"]["applyListSprite"]           --申请列表按钮上的图片
    self.applyListMenuItem = self.UILegionPanelView["UILegionPanelView"]["applyListMenuItem"]       --申请列表按钮
    self.editMenuItem = self.UILegionPanelView["UILegionPanelView"]["editMenuItem"]                 --编辑公告按钮

    self.progressSprite = self.UILegionPanelView["UILegionPanelView"]["progress_sprite"]            --守护经验进度条

    self.announceLabel = self.UILegionPanelView["UILegionPanelView"]["announceLabel"]               --公告

    self.legionInstance = self.UILegionPanelView["UILegionPanelView"]["legionInstance"]             --军团副本
    self.leginInstanceItem = self.UILegionPanelView["UILegionPanelView"]["leginInstanceItem"]       --军团副本按钮

    self.legionJudian = self.UILegionPanelView["UILegionPanelView"]["legionJudian"]                 --军团据点
    self.legionJdItem = self.UILegionPanelView["UILegionPanelView"]["legionJdItem"]                 --军团据点按钮

    self.legionShop = self.UILegionPanelView["UILegionPanelView"]["legionShop"]                     --军团商店
    self.legionShopItem = self.UILegionPanelView["UILegionPanelView"]["legionShopItem"]             --军团商店按钮

    self.haveApply = self.UILegionPanelView["UILegionPanelView"]["haveApply"]             --军团申请红点

    -- self.scrollView = self.UILegionPanelView["UILegionPanelView"]["scrollView"]             --军团商店按钮
    -- self.announceLabel:removeFromParent()
    -- self.announceLabel:setPosition(cc.p(0,0))
    -- self.scrollView:setContainer(self.announceLabel)
    --部分功能尚未开启
    self.legionInstance:setColor(cc.c3b(88,87,86))
    self.leginInstanceItem:setEnabled(false)
    self.legionJudian:setColor(cc.c3b(88,87,86))
    self.legionJdItem:setEnabled(false)
    self.legionShop:setColor(cc.c3b(88,87,86))
    self.legionShopItem:setEnabled(false)

    -- self:initData()
    self:updateLeginNotice()
end
--红点更新
function PVLegionPanel:updateLeginNotice()
    local leginApplyList = getDataManager():getLegionData():getApplyList()
    local position = getDataManager():getLegionData():getLegionPosition()
    if position ~= nil then
        if table.getn(leginApplyList) > 0 and position <= 3 then
            self.haveApply:setVisible(true)
        else
            self.haveApply:setVisible(false)
        end
    end
end

--数据初始化
function PVLegionPanel:initData()
    self.commonData.updateCombatPower()
    self.legionInfoData = self.legionData:getLegionInfo()
    print("self.legionInfoData ======================== ",self.legionInfoData)
    if self.legionInfoData ~= nil then
        print("编辑之后更新 ==================== ")
        self:dataSet(self.legionInfoData)
    end
end

--公会信息数据设置
function PVLegionPanel:dataSet(data)
    self.g_id = data.g_id
    --军团名称
    self.name = data.name
    self.legionName:setString(self.name)

    --军团等级
    self.level = data.level
    self.levelBMFnt:setString(self.level)
    self.otherDetail = self.legionTempalte:getGuildTemplateByLevel(self.level)

    --守护经验
    self.exp = data.exp
    local addExp = self.legionData.legionExp
    if addExp ~= nil then
        local nowExp = self.exp + addExp
        if nowExp - self.otherDetail.exp < 0 then
            self.exp = self.exp + addExp
            data.exp = self.exp
        else
            self.exp = (self.exp + addExp) - self.otherDetail.exp
            data.exp = self.exp
            self.level = self.level + 1
            data.level = self.level
            --上面读取了，这为什么还要读取
            -- self.otherDetail = self.legionTempalte:getGuildTemplateByLevel(self.level)
        end
        self.legionData.legionExp = 0
    end
    self.legionExp:setString(self.exp .. " / " .. self.otherDetail.exp)
    local rate = self.exp/(self.otherDetail.exp)
    self.progressSprite:setScaleX(rate)

    --军团成员数量显示
    print("获取军团成员数量 ================ ", data.p_num)
    self.p_num = data.p_num
    self.legionNumber:setString(self.p_num .. " / " .. self.otherDetail.p_max)

    --守护效果赋值
    local attr = self.c_Calculation:LegionAttr(self.level)
    self.lifeValue:setString(roundAttriNum(attr.hp))            --生命
    self.attackLabel:setString(roundAttriNum(attr.atk))         --攻击
    self.phyLabel:setString(roundAttriNum(attr.physicalDef))           --物防
    self.powerValue:setString(roundAttriNum(attr.magicDef))         --法防

    --军团资金
    self.fund = data.fund
    local addMoney = self.legionData.legionMoney
    if addMoney ~= nil then
        self.fund = self.fund + addMoney
        data.fund = self.fund
        self.legionData.legionMoney = 0
    end
    self.legionMoney:setString(self.fund)

    self.call = data.call
    print("输出公告 ================ ", self.call)
    local content = self.legionData:getAnouncement()
    print("再输出公告 ================ ", content)
    if content ~= nil then
        data.call = content
        self.legionData:setAnouncement(nil)
    end

    self.announceLabel:setString(data.call)

    self.record = data.record
    self.legionScore:setString(self.record)
    print("data my_position ================== ", data.my_position)
    -- self.my_position = self.legionData:getPositionById()
    self.my_position = self.legionData:getLegionPosition()
    -- print("self.legionData:getPositionById() =================== ", self.legionData:getPositionById())
    if self.my_position == nil then
        self.my_position = data.my_position
    end
    --编辑公告按钮设置
    if self.my_position ~= nil then
        if self.my_position <= 2 then
            self.editMenuItem:setEnabled(true)
        else
            self.editMenuItem:setEnabled(false)
        end
         --申请列表权限
        if self.my_position <= 3 then
            self.applyListMenuItem:setEnabled(true)
            self.applyListSprite:setColor(cc.c3b(255,255,255))
        else
            self.applyListMenuItem:setEnabled(false)
            self.applyListSprite:setColor(cc.c3b(88,87,86))
        end
    end
end

--界面返回更新回调
function PVLegionPanel:onReloadView()
    print("worship back update ================ ")
    local memberNum = self.funcTable[1]
    self:updateLegionPanel()
    self:updateLeginNotice()
    -- local legionInfo = self.legionData:getLegionInfo()
    -- if legionInfo == nil then
    --     self:onHideView()
    -- end
end

--更新界面
function PVLegionPanel:updateLegionPanel()
    --self:dataSet(self.legionInfoData)
    self:initData()
end

--公会界面相关事件
function PVLegionPanel:initTouchListener()
    --膜拜
    local function onWorshipClick()
        cclog("onWorshipClick")
        getAudioManager():playEffectButton2()
        -- getModule(MODULE_NAME_HOMEPAGE):showUIView("PVLegionWorship")
        getOtherModule():showOtherView("PVLegionWorship")
    end

    --编辑公告
    local function onEditAnnounceClick()
        cclog("onEditAnnounceClick")
        getAudioManager():playEffectButton2()

        getOtherModule():showOtherView("PVLegionAnnouncement")

        -- getModule(MODULE_NAME_HOMEPAGE):showUIView("PVLegionAnnouncement")
        --local modoule = getModule(MODULE_NAME_HOMEPAGE)
    end

    --军团排行
    local function onRankClick()
        cclog("onRankClick")
        getAudioManager():playEffectButton2()
        self.legionNet:sendGetRankList()
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVLegionRank")
    end

    --申请列表
    local function onApplyListClick()
        cclog("onApplyListClick")
        getAudioManager():playEffectButton2()
        self.legionNet:sendGetApplyList()
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVLegionApplyList")
    end

    --成员列表
    local function onMemberListClick()
        cclog("onMemberListClick")
        getAudioManager():playEffectButton2()
        self.legionNet:sendGetMemberList()
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVLegionMemberList")
    end

    --军团副本
    local function onCopyClick()
        cclog("onCopyClick")
    end

    --据点争夺
    local function onFightForClick()
        cclog("onFightForClick")
    end

    --军团商店
    local function onShopClick()
        cclog("onShopClick")
    end

    --返回
    local function onBackClick()
        cclog("onBackClick")
        --self:onHideView()
        getAudioManager():playEffectButton2()
        showModuleView(MODULE_NAME_HOMEPAGE)
    end

    self.UILegionPanelView["UILegionPanelView"] = {}
    self.UILegionPanelView["UILegionPanelView"]["onWorshipClick"] = onWorshipClick
    self.UILegionPanelView["UILegionPanelView"]["onEditAnnounceClick"] = onEditAnnounceClick
    self.UILegionPanelView["UILegionPanelView"]["onRankClick"] = onRankClick
    self.UILegionPanelView["UILegionPanelView"]["onApplyListClick"] = onApplyListClick
    self.UILegionPanelView["UILegionPanelView"]["onMemberListClick"] = onMemberListClick
    self.UILegionPanelView["UILegionPanelView"]["onCopyClick"] = onCopyClick
    self.UILegionPanelView["UILegionPanelView"]["onFightForClick"] = onFightForClick
    self.UILegionPanelView["UILegionPanelView"]["onShopClick"] = onShopClick
    self.UILegionPanelView["UILegionPanelView"]["onBackClick"] = onBackClick
end

function PVLegionPanel:clearResource()
    -- game.removeSpriteFramesWithFile("res/ccb/resource/ui_legion.plist")
end

return PVLegionPanel

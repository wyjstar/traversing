--武将页面  提升战力
local PVPromoteForce = class("PVPromoteForce", BaseUIView)


function PVPromoteForce:ctor(id)
    PVPromoteForce.super.ctor(self, id)
end

function PVPromoteForce:onMVCEnter()
    self.c_runeNet = getNetManager():getRuneNet()
    self.c_SoldierData = getDataManager():getSoldierData()
    self.c_runeData = getDataManager():getRuneData()

    game.addSpriteFramesWithFile("res/ccb/resource/ui_soldier.plist")

    self.UIPromoteForce = {}

    self:initTouchListener()

    self:loadCCBI("soldier/ui_soldier_addPowerStyle.ccbi", self.UIPromoteForce)

    self:initView()
    self:initData()
    self:regeisterNetCallBack()
end
--进入页面后判断是否直接点击了按钮
function PVPromoteForce:enterTransitionFinish()
    if self.clickBtn and self.clickBtn == 4 then
        self.UIPromoteForce["UIPromoteForce"]["onPhysicalTrainingClick"]()
    end
end

function PVPromoteForce:initData()
    self.selectID = self:getTransferData()[1]
    self.clickBtn = self:getTransferData()[2]
    print("self.selectID", self.selectID)
end

function PVPromoteForce:initView()
end

--注册网络回调
function PVPromoteForce:regeisterNetCallBack()
end

function PVPromoteForce:initTouchListener()
    local function onCloseClick()
        getAudioManager():playEffectButton2()
        -- stepCallBack(G_GUIDE_30111)     --点击提升战力弹框的关闭按钮
        -- stepCallBack(G_GUIDE_40105)     --点击提升战力弹框的关闭按钮
        -- groupCallBack(GuideGroupKey.BTN_CLOSE_LINEUP)


        -- -- if currentGID == G_GUIDE_30112 then
        -- --     local homePage = getPlayerScene().homeModuleView.moduleView
        -- --     homePage:scrollToTPage()
        -- -- end

        groupCallBack(GuideGroupKey.BTN_CLOSE_LINEUP)
        self:onHideView()
    end

    --武将升级
    local function onSoldierUpgradeClick()
        getAudioManager():playEffectButton2()

        -- stepCallBack(G_GUIDE_30108)        -- 点击武将升级

        g_selectID = self.selectID
        --getModule(MODULE_NAME_LINEUP):removeLastView()
        getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSoldierUpgradeDetail", g_selectID)
    end

    --武将突破
    local function onSoldierBreakClick()
        getAudioManager():playEffectButton2()

        -- stepCallBack(G_GUIDE_40102)        -- 40005 点击武将突破
        g_selectID = self.selectID
        -- getModule(MODULE_NAME_HOMEPAGE):removeLastView()
        ---------------ljr
        self.playerLevel = getDataManager():getCommonData():getLevel()
        self.breakupOpenLeve = getTemplateManager():getBaseTemplate():getBreakupOpenLeve()

        local _stageId = getTemplateManager():getBaseTemplate():getBreakupOpenStage()
        local isOpen = getDataManager():getStageData():getIsOpenByStageId(_stageId)
        if isOpen then        --self.playerLevel >= self.breakupOpenLeve
            getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSoldierBreakDetail", g_selectID)

            groupCallBack(GuideGroupKey.BTN_WUJIANG_TUPO)
        else
            --支援
            --功能等级开放提示
            -- self:removeChildByTag(1000)
            -- self:addChild(getLevelTips(self.breakupOpenLeve), 0, 1000)
            getStageTips(_stageId)
        end
        ----------------
    end

    --符文镶嵌
    local function onSymbolInlayClick()
        getAudioManager():playEffectButton2()
        -- self:toastShow("功能未开启，敬请期待！")
        g_selectID = self.selectID
        local heroPb = self.c_SoldierData:getSoldierDataById(g_selectID)
        self.c_runeData:setCurSoliderId(self.selectID)
        print(self.selectID)
        print("y+++++")
        self.c_runeData:setSoldierRune(heroPb.runt_type)

        ---------------ljr
        self.playerLevel = getDataManager():getCommonData():getLevel()
        self.runeOpenLeve = getTemplateManager():getBaseTemplate():getRuneOpenLeve()

        local _stageId = getTemplateManager():getBaseTemplate():getTotemOpenStage()
        local isOpen = getDataManager():getStageData():getIsOpenByStageId(_stageId)
        if isOpen then    --self.playerLevel >= self.runeOpenLeve
            self:onHideView()
            getNetManager():getRuneNet():sendBagRunes()
            getModule(MODULE_NAME_HOMEPAGE):showUIView("PVRunePanel",g_selectID)
        else
            --支援
            --功能等级开放提示
            -- self:removeChildByTag(1000)
            -- self:addChild(getLevelTips(self.runeOpenLeve), 0, 1000)
            getStageTips(_stageId)
        end
        ---------------

        -- self:onHideView()
        -- getModule(MODULE_NAME_LINEUP):removeLastView()
        -- getModule(MODULE_NAME_HOMEPAGE):showUIView("PVRunePanel",g_selectID)
        --getModule(MODULE_NAME_LINEUP):showUIView("PVLineUp")
        --stepCallBack(G_GUIDE_120009)
        groupCallBack(GuideGroupKey.BTN_CLICK_FUWEN)
    end

    --炼体
    local function onPhysicalTrainingClick()
        getAudioManager():playEffectButton2()
        g_selectID = self.selectID

        ---------------ljr
        self.playerLevel = getDataManager():getCommonData():getLevel()
        self.sealOpenLeve = getTemplateManager():getBaseTemplate():getSealOpenLeve()

        local _stageId = getTemplateManager():getBaseTemplate():getSealOpenStage()
        local isOpen = getDataManager():getStageData():getIsOpenByStageId(_stageId)
        if isOpen then   --self.playerLevel >= self.sealOpenLeve
            getModule(MODULE_NAME_LINEUP):showUIView("PVSoldierChain",g_selectID)
            local temp = getDataManager():getCommonData():getFinance(DROP_BREW)
            if temp > 0 then
                groupCallBack(GuideGroupKey.BTN_LIANTI)
            else
                if getNewGManager():getCurrentGid() == GuideId.G_GUIDE_60014 then
                    getNewGManager():setCurrentGID(GuideId.G_GUIDE_60016)
                    groupCallBack(GuideGroupKey.BTN_LIANTI)
                end
            end
        else
            --功能等级开放提示
            -- self:removeChildByTag(1000)
            -- self:addChild(getLevelTips(self.sealOpenLeve), 0, 1000)
            getStageTips(_stageId)
        end
        ---------------
    end

    self.UIPromoteForce["UIPromoteForce"] = {}
    self.UIPromoteForce["UIPromoteForce"]["onCloseClick"] = onCloseClick
    self.UIPromoteForce["UIPromoteForce"]["onSoldierUpgradeClick"] = onSoldierUpgradeClick
    self.UIPromoteForce["UIPromoteForce"]["onSoldierBreakClick"] = onSoldierBreakClick
    self.UIPromoteForce["UIPromoteForce"]["onSymbolInlayClick"] = onSymbolInlayClick
    self.UIPromoteForce["UIPromoteForce"]["onPhysicalTrainingClick"] = onPhysicalTrainingClick

end

--返回更新
function PVPromoteForce:onReloadView()
end

function PVPromoteForce:clearResource()
    --game.removeSpriteFramesWithFile("res/ccb/resource/ui_soldier.plist")
end

return PVPromoteForce

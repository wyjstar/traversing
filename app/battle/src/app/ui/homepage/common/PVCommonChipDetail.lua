
local PVCommonChipDetail = class("PVCommonChipDetail", BaseUIView)

function PVCommonChipDetail:ctor(id)
    PVCommonChipDetail.super.ctor(self, id)
end

function PVCommonChipDetail:onMVCEnter()
    self:initBaseUI()
    self.commonData = getDataManager():getCommonData()
    self.equipTemplate = getTemplateManager():getEquipTemplate()                    --装备
    self.resourceTemplate = getTemplateManager():getResourceTemplate()
    self.c_LanguageTemplate = getTemplateManager():getLanguageTemplate()
    self.c_SoldierTemplate = getTemplateManager():getSoldierTemplate()
    self.chipTemplate = getTemplateManager():getChipTemplate()

    self:initData()
    self:initView()
end

function PVCommonChipDetail:initData()
    self.itemType = self.funcTable[1]
    self.itemId = self.funcTable[2]                   --当前物品的id
    self.itemNum = self.funcTable[3]                  --数量
    self.buttonType = self.funcTable[4]
end

function PVCommonChipDetail:initView()
    self.UIChipDetail = {}
    self:initTouchListener()
    self:loadCCBI("common/ui_common_chip_detail.ccbi", self.UIChipDetail)

    self.titleSprite = self.UIChipDetail["UIChipDetail"]["titleSprite"]                             --标题名称
    self.itemName = self.UIChipDetail["UIChipDetail"]["itemName"]                                   --物品名称
    self.detailLabel2 = self.UIChipDetail["UIChipDetail"]["detailLabel2"]                           --物品描述
    self.headSprite = self.UIChipDetail["UIChipDetail"]["headSprite"]                               --物品icon

    self.oneMenu = self.UIChipDetail["UIChipDetail"]["oneMenu"]                                     --确定
    self.twoMenu = self.UIChipDetail["UIChipDetail"]["twoMenu"]                                     --确定、获得途径
    self.signMenu = self.UIChipDetail["UIChipDetail"]["signMenu"]                                   --确定、签到
    self.signMenu2 = self.UIChipDetail["UIChipDetail"]["signMenu2"]                                 --确定、补签

    if self.buttonType == 1 then
        self.oneMenu:setVisible(true)
        self.twoMenu:setVisible(false)
    elseif self.buttonType == nil then
        self.oneMenu:setVisible(false)
        self.twoMenu:setVisible(true)
    elseif self.buttonType == 3 then
        self.oneMenu:setVisible(false)
        self.twoMenu:setVisible(false)
        self.signMenu:setVisible(true)
        self.signMenu2:setVisible(false)
    elseif self.buttonType == 4 then
        self.oneMenu:setVisible(false)
        self.twoMenu:setVisible(false)
        self.signMenu:setVisible(false)
        self.signMenu2:setVisible(true)
    end


    self:updateDetailView()
end

function PVCommonChipDetail:updateDetailView()
    if self.itemType == 1 then
        local patchTempLate = self.c_SoldierTemplate:getChipTempLateById(self.itemId)
        local nameStr = patchTempLate.language                              --碎片名称
        local combineResult = patchTempLate.combineResult                   --合成结果
        local soldierTemplateItem = self.c_SoldierTemplate:getHeroTempLateById(combineResult)
        self.quality = patchTempLate.quality
        local resultName =  self.c_LanguageTemplate:getLanguageById(soldierTemplateItem.nameStr)        --合成武将名称
        local needNum = patchTempLate.needNum                               --需要的碎片数量

        self.descibe_chinese = needNum .. "个碎片可合成武将" .. resultName .. "\n" .. "已拥有：" .. self.itemNum
        self.name = self.c_LanguageTemplate:getLanguageById(nameStr)
        self.resIcon = self.chipTemplate:getChipIconById(self.itemId)
        changeHeroChipIcon(self.headSprite, self.resIcon, self.quality)
    elseif self.itemType == 2 then
        local chipTemplateItem = self.chipTemplate:getTemplateById(self.itemId)                 --装备碎片模板数据
        local _languageId = chipTemplateItem.language                                           --碎片名称
        local combineResult = chipTemplateItem.combineResult
        local equipmentItem = self.equipTemplate:getTemplateById(combineResult)
        local resultName =  self.c_LanguageTemplate:getLanguageById(equipmentItem.name)        --合成装备名称
        local needNum = chipTemplateItem.needNum

        self.descibe_chinese = needNum .. "个碎片可合成装备" .. resultName .. "\n" .. "已拥有：" .. self.itemNum
        self.name = self.c_LanguageTemplate:getLanguageById(_languageId)
        self.resIcon = self.resourceTemplate:getResourceById(chipTemplateItem.resId) -- 资源名
        self.quality = chipTemplateItem.quality
        changeEquipChipIconImageBottom(self.headSprite, self.resIcon, self.quality)
    end
    -- setChipWithFrameNew(self.headSprite, self.resIcon, self.quality)
    self.itemName:setString(self.name)
    self.detailLabel2:setString(self.descibe_chinese)
end

function PVCommonChipDetail:initTouchListener()
    --确定关闭
    local function onClickOK()
        print("确定 ============== ")
        getAudioManager():playEffectButton2()
        self:onHideView()
    end
    --获取途径
    local function onReceiveClik()
        if self.itemType == 1 then
            _data = getTemplateManager():getChipTemplate():getAllDropPlace(self.itemId)
        elseif self.itemType == 2 then
            _data = getTemplateManager():getChipTemplate():getAllDropPlace(self.itemId)
        end


        if (type(_data.stage) == "table" and table.nums(_data.stage) == 0) and _data.coinHero == 0
            and _data.moneyHero == 0 and _data.coinEqu == 0 and _data.moneyEqu == 0 and _data.soulShop == 0
            and _data.arenaShop == 0 and _data.stageBreak == 0  then
            local tipText = self.c_LanguageTemplate:getLanguageById(3300010001)
            -- getOtherModule():showToastView(tipText)
            getOtherModule():showAlertDialog(nil, tipText)

        else
            -- self:onHideView()
            if self.itemType == 1 then
                getModule(MODULE_NAME_HOMEPAGE):showUITopShowLastView("PVChipGetDetail", _data, self.itemId, 2)
            elseif self.itemType == 2 then
                getModule(MODULE_NAME_HOMEPAGE):showUITopShowLastView("PVChipGetDetail", _data, self.itemId, 4)
            end
        end
    end

    --签到
    local function onSignClik()
        print("签到 =================  ")
        self:onHideView()
        getNetManager():getActivityNet():sendGetSignMsg()
    end

    --补签
    local function onSignClik2()
        print("补签 ================ ")
        local _times = getDataManager():getCommonData():getRepaireTimes()
        local money = getTemplateManager():getBaseTemplate():getRepaireSignMoney(_times+1)
        self:onHideView()
        getOtherModule():showOtherView("SystemTips", string.format(Localize.query("activity.1"), money))
    end

    self.UIChipDetail["UIChipDetail"] = {}

    self.UIChipDetail["UIChipDetail"]["onClickOK"] = onClickOK
    self.UIChipDetail["UIChipDetail"]["onReceiveClik"] = onReceiveClik
    self.UIChipDetail["UIChipDetail"]["onSignClik"] = onSignClik
    self.UIChipDetail["UIChipDetail"]["onSignClik2"] = onSignClik2
end

return PVCommonChipDetail

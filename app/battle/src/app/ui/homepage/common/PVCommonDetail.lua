
local PVCommonDetail = class("PVCommonDetail", BaseUIView)

function PVCommonDetail:ctor(id)
    PVCommonDetail.super.ctor(self, id)
end

function PVCommonDetail:onMVCEnter()
    self:initBaseUI()
    self.commonData = getDataManager():getCommonData()
    self.bagTemplate = getTemplateManager():getBagTemplate()                        --背包
    self.equipTemplate = getTemplateManager():getEquipTemplate()                    --装备
    self.resourceTemplate = getTemplateManager():getResourceTemplate()
    self.c_LanguageTemplate = getTemplateManager():getLanguageTemplate()
    self.c_ChipTemplate = getTemplateManager():getChipTemplate()
    self.baseTemp = getTemplateManager():getBaseTemplate()
    self.stageData = getDataManager():getStageData()

    self:initData()
    self:initView()
end

function PVCommonDetail:initData()
    self.itemType = self.funcTable[1]                   --当前物品的类型 1、道具 2、战队经验、银两、元宝 3、装备
    self.itemId = self.funcTable[2]                     --当前物品的id
    self.buttonType = self.funcTable[3]                 --显示的button的数量
end

function PVCommonDetail:initView()
    self.UIItemDetail = {}
    self:initTouchListener()
    self:loadCCBI("common/ui_common_item_detail.ccbi", self.UIItemDetail)

    self.titleSprite = self.UIItemDetail["UIItemDetail"]["titleSprite"]                             --标题名称
    self.itemName = self.UIItemDetail["UIItemDetail"]["itemName"]                                   --物品名称
    self.detailLabel2 = self.UIItemDetail["UIItemDetail"]["detailLabel2"]                           --物品描述
    self.headSprite = self.UIItemDetail["UIItemDetail"]["headSprite"]                               --物品icon

    self.oneMenu = self.UIItemDetail["UIItemDetail"]["oneMenu"]                                     --确定
    self.twoMenu = self.UIItemDetail["UIItemDetail"]["twoMenu"]                                     --确定、获得途径
    self.signMenu = self.UIItemDetail["UIItemDetail"]["signMenu"]                                   --确定、签到
    self.signMenu2 = self.UIItemDetail["UIItemDetail"]["signMenu2"]                                 --确定、补签

    --self.buttonType  1、确定 2、获得途径、确定 3、签到、确定 4、补签、确定
    if self.buttonType == 1 then
        self.oneMenu:setVisible(true)
        self.twoMenu:setVisible(false)
        self.signMenu:setVisible(false)
        self.signMenu2:setVisible(false)
    elseif self.buttonType == 2 then
        self.oneMenu:setVisible(false)
        self.twoMenu:setVisible(true)
        self.signMenu:setVisible(false)
        self.signMenu2:setVisible(false)
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

function PVCommonDetail:updateDetailView()
    if self.itemType == 1 then
        local item = self.bagTemplate:getItemById(self.itemId)
        self.resIcon = self.bagTemplate:getItemResIcon(self.itemId)
        self.quality = self.bagTemplate:getItemQualityById(self.itemId)
        self.descibe_chinese = self.c_LanguageTemplate:getLanguageById(item.describe)
        self.name = self.c_LanguageTemplate:getLanguageById(item.name)
    elseif self.itemType == 2 then
        local resName = self.resourceTemplate:getResourceById(self.itemId)
        self.resIcon = "res/icon/resource/" .. resName
        local desId = self.resourceTemplate:getDesIdById(self.itemId)
        self.descibe_chinese = self.c_LanguageTemplate:getLanguageById(desId)
        self.name = self.resourceTemplate:getResourceName(self.itemId)
    elseif self.itemType == 3 then

    end

    setItemImage3(self.headSprite, self.resIcon, self.quality)
    self.itemName:setString(self.name)
    self.detailLabel2:setString(self.descibe_chinese)
end

function PVCommonDetail:initTouchListener()
    --确定关闭
    local function onClickOK()
        getAudioManager():playEffectButton2()
        self:onHideView()
    end

    --获取途径
    local function onReceiveClik()
        getAudioManager():playEffectButton2()
        if self.itemId == 2 then
            -- getModule(MODULE_NAME_HOMEPAGE):removeLastView()
            getModule(MODULE_NAME_HOMEPAGE):removeLastView()
            -- getModule(MODULE_NAME_SHOP):showUINodeView("PVshopRecharge")
            getModule(MODULE_NAME_SHOP):showUIViewAndInTop("PVshopRecharge")
        elseif self.itemId == 3 then
            local _stageId = self.baseTemp:getHeroSacrificeOpenStage()
            local _isOpen = self.stageData:getIsOpenByStageId(_stageId)
            if _isOpen then
                getModule(MODULE_NAME_HOMEPAGE):removeLastView()
                getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSmeltView")
            else
                getStageTips(_stageId)
                return
            end
        elseif self.itemId == 13 then
            getModule(MODULE_NAME_HOMEPAGE):removeLastView()                                               --煮酒
            getModule(MODULE_NAME_HOMEPAGE):showUIView("PVActivityPage", 5)
        else
            local itemToGetId = self.bagTemplate:getToGetById(self.itemId)
            local _data =  self.c_ChipTemplate:getDropListById(itemToGetId)
            if (type(_data.stage) == "table" and table.nums(_data.stage) == 0) and _data.coinHero == 0
                and _data.moneyHero == 0 and _data.coinEqu == 0 and _data.moneyEqu == 0 and _data.soulShop == 0
                and _data.arenaShop == 0 and _data.stageBreak == 0 and _data.isStage == 0 and (type(_data.isEliteStage) == "table" and table.nums(_data.isEliteStage) == 0)
                and _data.isActiveStage then
                    print("false ----------------------- ")
                    local tipText = getTemplateManager():getLanguageTemplate():getLanguageById(3300010001)
                    -- getOtherModule():showToastView(tipText)
                    getOtherModule():showAlertDialog(nil, tipText)

            else
                g__data = _data
                -- self:onHideView()
                getOtherModule():showOtherView("PVChipGetDetail", g__data,self.itemId)
                g__data = nil
            end
        end
    end

    --签到
    local function onSignClik()
        self:onHideView()
        if EXTRA_SIGN_GIFT then
            getNetManager():getActivityNet():sendRepaireSignBoxMsg(ACTIVITY_REPAIRE_DAY)
            EXTRA_SIGN_GIFT = false
        else
            getNetManager():getActivityNet():sendGetSignMsg()
        end
    end

    --补签
    local function onSignClik2()
        local _times = getDataManager():getCommonData():getRepaireTimes()
        local money = getTemplateManager():getBaseTemplate():getRepaireSignMoney(_times+1)
        self:onHideView()
        getOtherModule():showOtherView("SystemTips", string.format(Localize.query("activity.1"), money))
    end

    self.UIItemDetail["UIItemDetail"] = {}

    self.UIItemDetail["UIItemDetail"]["onClickOK"] = onClickOK
    self.UIItemDetail["UIItemDetail"]["onReceiveClik"] = onReceiveClik
    self.UIItemDetail["UIItemDetail"]["onSignClik"] = onSignClik
    self.UIItemDetail["UIItemDetail"]["onSignClik2"] = onSignClik2
end

return PVCommonDetail

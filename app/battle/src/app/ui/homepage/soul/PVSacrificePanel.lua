
local PVSacrificePanel = class("PVSacrificePanel", BaseUIView)

function PVSacrificePanel:ctor(id)
    self.super.ctor(self, id)
end

function PVSacrificePanel:onMVCEnter()
    game.addSpriteFramesWithFile("res/ccb/resource/ui_sacrifice.plist")
    self:showAttributeView()
    self.UISacrificeView = {}
    self.herosData = {}
    self.soldierData = getDataManager():getLineupData():getChangeCheerSoldier()
    self.SoldierTemplate = getTemplateManager():getSoldierTemplate()
    self.c_Calculation = getCalculationManager():getCalculation()
    -- self.GameLoginResponse = getDataManager():getCommonData():getData()
    self.commonData = getDataManager():getCommonData()
    self.HeroSacrificeResponse = {}
    self.generalHead = {}
    self.totalSelect = {}
    self.addOneKey = false

    self:initTouchListener()

    self:loadCCBI("soul/ui_sacrifice_panel.ccbi", self.UISacrificeView)

    self:initView()
    -- self:viewRunActionFadeIn()

    self:initData()

    -- self.soliderData = getDataManager():getSoldierData():getSoldierData()

    -- table.print(self.soliderData)

    self:initRegisterNetCallBack()

    -- 获取一次将领数据
    -- if table.nums(self.soldierData) <= 0 then
    --     getNetManager():getSoldierNet():sendGetSoldierMsg()
    -- else
        self:updateUIData()
    -- end


    -- local function onNodeEvent(event)
    --     if "exit" == event then
    --         self:onExit()
    --     end
    -- end

    -- self:registerScriptHandler(onNodeEvent)

    -- local event = cc.EventCustom:new(UPDATE_HEAD_ICON)
    -- self:getEventDispatcher():dispatchEvent(event)

end

function PVSacrificePanel:onExit()
    cclog("-------onExit----")
    -- self:unregisterScriptHandler()
    -- game.removeSpriteFramesWithFile("res/ccb/resource/ui_sacrifice.plist")
end

function PVSacrificePanel:initView()
    self.soulNumber = self.UISacrificeView["UISacrificeView"]["soulNumber"]

    for i=1,5 do
        self.generalHead[i] = {}
        local  strName = string.format("headImg%d", i)
        self.generalHead[i].headImg = self.UISacrificeView["UISacrificeView"][strName]

        strName = string.format("headImg%d_q", i)
        self.generalHead[i].headImgq = self.UISacrificeView["UISacrificeView"][strName]
        self.generalHead[i].isSelect = false
        self.generalHead[i].hero = {}
    end

    self.gainSoulNumLabel = self.UISacrificeView["UISacrificeView"]["gainSoulNumLabel"]
    self.expProNum = self.UISacrificeView["UISacrificeView"]["expProNum"]
    self.totalSoulNumLabel = self.UISacrificeView["UISacrificeView"]["totalSoulNumLabel"]

    self.gain_exp = self.UISacrificeView["UISacrificeView"]["gain_exp"]
    self.gain_soul = self.UISacrificeView["UISacrificeView"]["gain_soul"]

    self.item1 = self.UISacrificeView["UISacrificeView"]["item1"]
    self.item2 = self.UISacrificeView["UISacrificeView"]["item2"]

    self.item1:setAllowScale(false)
    self.item2:setAllowScale(false)

    self.sacrificeMenuItem = self.UISacrificeView["UISacrificeView"]["sacrificeMenuItem"]
    self.oneAddKey = self.UISacrificeView["UISacrificeView"]["oneAddKey"]
     -- SpriteGrayUtil:drawSpriteTextureGray(self.sacrificeMenuItem:getNormalImage())
    self.animationNode = self.UISacrificeView["UISacrificeView"]["animationNode"]

end

-- 初始化数据
function PVSacrificePanel:initData()
    self.gainSoulNumLabel:setString("")
    self.expProNum:setString("")
    self.totalSoulNumLabel:setString(self.commonData:getHeroSoul())--self.GameLoginResponse.hero_soul);

end

function PVSacrificePanel:initRegisterNetCallBack()
    function onReciveMsgCallBack(_id)
        if _id == NET_ID_HERO_REQUEST then -- 获取武将列表
            self:updateUIData(_id)
        elseif _id == HERO_SACRIFICE_REQUEST then -- 献祭
            self:onUpdateSacrificeUI()
        end
    end

    self:registerMsg(HERO_SACRIFICE_REQUEST, onReciveMsgCallBack)
    self:registerMsg(NET_ID_HERO_REQUEST, onReciveMsgCallBack)
end

-- 删除献祭后的将领
function PVSacrificePanel:removeHeroByID(hero_no)
    local data = getDataManager():getSoldierData():getSoldierData()
    for k,v in pairs(data) do
        if v.hero_no == hero_no then
            table.remove(data, k)
        end
    end

end

-- 根据献祭之后返回数据更新UI
function PVSacrificePanel:onUpdateSacrificeUI()
    self.addOneKey = false

   self.HeroSacrificeResponse = getDataManager():getSacrificeData():getHeroSacrificeResponseData()
   if self.HeroSacrificeResponse.res.result then
        -- getOtherModule():showToastView(Localize.query("SacrificePanel.1"))
        -- getOtherModule():showAlertDialog(nil, Localize.query("SacrificePanel.1"))

        table.print(self.HeroSacrificeResponse.gain.items)
        print(table.nums(self.HeroSacrificeResponse.gain.items))

        if table.nums(self.HeroSacrificeResponse.gain.items) >0 then
            getDataManager():getBagData():setItemByOtherWay(self.HeroSacrificeResponse.gain.items)               -- 经验药水添加到背包里
        end
        -- print("添加的数量 ============= ", self.HeroSacrificeResponse.gain.items[1].item_num)
        getDataManager():getCommonData():addHero_soul(self.HeroSacrificeResponse.gain.finance.hero_soul)     -- 增加武魂总值


        local ret = false
        for k, v in pairs(self.generalHead) do
            if v.isSelect and v.hero then
                -- add card 献祭特效
                local actionEnd = function()
                    self.gain_exp:setOpacity(255)
                    self.gain_soul:setOpacity(255)

                    SpriteGrayUtil:drawSpriteTextureColor(self.sacrificeMenuItem:getNormalImage())
                    SpriteGrayUtil:drawSpriteTextureColor(self.oneAddKey:getNormalImage())
                    self.sacrificeMenuItem:setEnabled(true)
                    self.oneAddKey:setEnabled(true)
                    if k == table.getn(self.totalSelect) then
                        -- 献祭成功后，获得物品提示
                        print("------献祭成功------")
                        table.print(self.HeroSacrificeResponse)
                        self.HeroSacrificeResponse.gain.items[1].icon = self.icon
                        getOtherModule():showOtherView("PVCongratulationsGainDialog",2,self.HeroSacrificeResponse.gain)
                    end
                end
                local posx, posy = v.headImg:getPosition()
                cclog("posx, posy", posx, posy)

                if self.gain_exp:isVisible() then
                    ret = true
                end
                local node = UI_Xianji(posx, posy, actionEnd, ret)
                self.animationNode:addChild(node)

                self:removeHeroByID(v.hero.hero_no)

            end
        end
        self:updateUIData()
    else
        -- getOtherModule():showToastView(Localize.query("SacrificePanel.2"))
        getOtherModule():showAlertDialog(nil, Localize.query("SacrificePanel.2"))
    end

    for k, v in pairs(self.generalHead) do
        self.generalHead[k].headImg:setVisible(false)
        self.generalHead[k].headImgq:setVisible(false)
        self.generalHead[k].isSelect = false
        self.generalHead[k].hero = nil
    end

    -- 献祭成功后更新数据
    -- self.gain_exp:setVisible(false)
    -- self.gain_soul:setVisible(false)
    -- self.gainSoulNumLabel:setString("")
    -- self.expProNum:setString("")
    self.totalSoulNumLabel:setString(self.commonData:getHeroSoul())--self.GameLoginResponse.hero_soul)

end

-- function sortByHeroQuality(heroA, heroB)

--     return heroA.quality < heroB.quality
-- end



-- 获取武将列表
function PVSacrificePanel:updateUIData()
    self.soldierData = getDataManager():getLineupData():getChangeCheerSoldier()

    -- table.print(self.soldierData)

    self.herosData = {}
    -- local len = table.nums(self.soldierData)
    for k,v in pairs(self.soldierData) do
        self.herosData[k] = {}
        self.herosData[k].HeroPB = v
        local _quality = self.SoldierTemplate:getHeroQuality(v.hero_no)
        self.herosData[k].quality = _quality
        local _power = self.c_Calculation:CombatPowerSoldierSelf(v)
        self.herosData[k].power = _power
        -- len = len - 1

    end

    local function sortByHeroQuality(item1, item2)
        if item1.query == item2.quality then
           return item1.power < item2.power
        end
        return item1.quality < item2.quality
    end

    table.sort(self.herosData, sortByHeroQuality)

    -- table.print(self.herosData)

end

function PVSacrificePanel:initTouchListener()
    local function onCloseClick()
        getAudioManager():playEffectButton2()
        -- cc.Director:getInstance():purgeCachedData()
        self:onHideView()

    end

    local function onShopClick()
        cclog("onShopClick")
        getAudioManager():playEffectButton2()
        getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSecretShop")
    end

    local function onHead1Click()
        cclog("onHead1Click")
        getAudioManager():playEffectButton2()
        --self:dispatchEvent(const.EVENT_PV_GENERALLIST_SHOW, self.generalHead, self.curSoulNum, self.cancleLayer, 1)
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVGeneralList", self.generalHead, self.curSoulNum, 1)
    end

    local function onHead2Click()
        cclog("onHead2Click")
        getAudioManager():playEffectButton2()
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVGeneralList", self.generalHead, self.curSoulNum, 2)
    end

    local function onHead3Click()
        cclog("onHead3Click")
        getAudioManager():playEffectButton2()
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVGeneralList", self.generalHead, self.curSoulNum, 3)
    end

    local function onHead4Click()
        cclog("onHead4Click")
        getAudioManager():playEffectButton2()
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVGeneralList", self.generalHead, self.curSoulNum, 4)
    end

    local function onHead5Click()
        cclog("onHead5Click")
        getAudioManager():playEffectButton2()
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVGeneralList", self.generalHead, self.curSoulNum, 5)
    end

    local function onCancleClick()
        cclog("onCancleClick")
        getAudioManager():playEffectButton2()
        self:imageChange(self.generalHead[1])
        --self.cancleLayer[1]:setVisible(false)
    end

    local function onCancle2Click()
        cclog("onCancle2Click")
        getAudioManager():playEffectButton2()
        self:imageChange(self.generalHead[2])
        --self.cancleLayer[2]:setVisible(false)
    end

    local function onCancle3Click()
        cclog("onCancle3Click")
        getAudioManager():playEffectButton2()
        self:imageChange(self.generalHead[3])
        --self.cancleLayer[3]:setVisible(false)
    end

    local function onCancle4Click()
        cclog("onCancle4Click")
        getAudioManager():playEffectButton2()
        self:imageChange(self.generalHead[4])
        --self.cancleLayer[4]:setVisible(false)
    end

    local function onCancle5Click()
        cclog("onCancle5Click")
        getAudioManager():playEffectButton2()
        self:imageChange(self.generalHead[5])
        --self.cancleLayer[5]:setVisible(false)
    end

    local function onSacrificeClick()
        -- getPlatformLuaManager():accessDiffPlatform("handShake")
        -- SpriteGrayUtil:drawSpriteTextureColor(self.sacrificeMenuItem:getNormalImage())
        cclog("onSacrificeClick")
        getAudioManager():playEffectButton2()
        self:totalSelectHead()
        if table.nums(self.totalSelect) <=0 then

            -- self:toastShow(Localize.query("SacrificePanel.3"))
            getOtherModule():showAlertDialog(nil, Localize.query("SacrificePanel.3"))
             -- getOtherModule():showOtherView("Toast", "请先添加所要献祭的武将")

            return
        end


        local  data = { hero_nos=self.totalSelect}
        -- 添加紫色英雄献祭的二次确认提示
        local _isContainsPurpleSoldier = false
        for k,v in pairs(self.totalSelect) do
            local _quality = self.SoldierTemplate:getHeroQuality(v)
            if _quality >= 5 then
                _isContainsPurpleSoldier = true
                local _soldierName = self.SoldierTemplate:getHeroName(v)
                print("－－－－－包含紫色武将－－－－－－")
                print(_soldierName)
                local  sure = function()
                    -- 确定
                    getNetManager():getSacrificeNet():sendHeroSacrificeRequest("HeroSacrificeRequest", data)
                end
                local cancel = function()
                    -- 取消
                    getOtherModule():clear()
                end
                getOtherModule():showConfirmDialog(sure, cancel, Localize.query("PVSacrificePanel.1"))
                break
            end
        end
        if _isContainsPurpleSoldier == false then
            self.sacrificeMenuItem:setEnabled(false)
            self.oneAddKey:setEnabled(false)
            SpriteGrayUtil:drawSpriteTextureGray(self.sacrificeMenuItem:getNormalImage())
            SpriteGrayUtil:drawSpriteTextureGray(self.oneAddKey:getNormalImage())
            getNetManager():getSacrificeNet():sendHeroSacrificeRequest("HeroSacrificeRequest", data)
        end
    end

     local function isExistsIngeneralHead(HeroPB)
        for i=1,5 do
            if self.generalHead[i].headImg:isVisible() and self.generalHead[i].hero.hero_no == HeroPB.hero_no then
               return true
            end
        end

        return false
    end

    local  function onAddAllClick()
        cclog("onAddAllClick")
        getAudioManager():playEffectButton2()
        -- 用户点击一键添加，无需打开献祭武将列表，按照武将品质（绿、蓝3星、蓝4星、紫5星、紫6星）自动添加武将至置放武将位置。
        if table.nums(self.herosData) <=0 then
            -- getOtherModule():showToastView(Localize.query("SacrificePanel.4"))
            getOtherModule():showAlertDialog(nil, Localize.query("SacrificePanel.4"))
            return
        elseif self.addOneKey and table.nums(self.herosData)<5 then
             -- getOtherModule():showToastView(Localize.query("SacrificePanel.4"))
             getOtherModule():showAlertDialog(nil, Localize.query("SacrificePanel.4"))
            return
        elseif self.addOneKey  then
            -- getOtherModule():showToastView(Localize.query("SacrificePanel.5"))
            getOtherModule():showAlertDialog(nil, Localize.query("SacrificePanel.5"))
            return
        end

        for k, v in pairs(self.herosData) do
            -- if k>5 then
            --     break
            -- end

            local _isExist = isExistsIngeneralHead(v.HeroPB)

            if not _isExist then
                for i=1,5 do
                    if not self.generalHead[i].headImg:isVisible() then
                        self.generalHead[i].headImg:setVisible(true)
                        self.generalHead[i].isSelect = true
                        self.generalHead[i].hero = v.HeroPB
                        game:setSpriteFrame(self.generalHead[k], "#ui_common_pro.png")
                        break
                    end
                end

            end
        end

        self.addOneKey = true

        self:updateSoulIconAndNum()
    end

    self.UISacrificeView["UISacrificeView"] = {}

    self.UISacrificeView["UISacrificeView"]["onBackClick"] = onCloseClick
    self.UISacrificeView["UISacrificeView"]["onShopClick"] = onShopClick
    self.UISacrificeView["UISacrificeView"]["onHead1Click"] = onHead1Click
    self.UISacrificeView["UISacrificeView"]["onHead2Click"] = onHead2Click
    self.UISacrificeView["UISacrificeView"]["onHead3Click"] = onHead3Click
    self.UISacrificeView["UISacrificeView"]["onHead4Click"] = onHead4Click
    self.UISacrificeView["UISacrificeView"]["onHead5Click"] = onHead5Click
    self.UISacrificeView["UISacrificeView"]["onCancleClick"] = onCancleClick
    self.UISacrificeView["UISacrificeView"]["onCancle2Click"] = onCancle2Click
    self.UISacrificeView["UISacrificeView"]["onCancle3Click"] = onCancle3Click
    self.UISacrificeView["UISacrificeView"]["onCancle4Click"] = onCancle4Click
    self.UISacrificeView["UISacrificeView"]["onCancle5Click"] = onCancle5Click
    self.UISacrificeView["UISacrificeView"]["onSacrificeClick"] = onSacrificeClick
    self.UISacrificeView["UISacrificeView"]["onAddAllClick"] = onAddAllClick

end

function PVSacrificePanel:totalSelectHead()
    self.totalSelect = {}
    for k,v in pairs(self.generalHead) do
        if v.isSelect == true then
           table.insert(self.totalSelect, v.hero.hero_no)
        end
    end
end

-- 更新献祭的武魂数量和图标
function PVSacrificePanel:updateSoulIconAndNum()
    -- 武魂
    local  totalSoulNum = self:getTotalSoulNum()
    if totalSoulNum > 0 then
        -- self.gainSoulNumLabel:setString(string.format("%d%s",totalSoulNum, Localize.query("SacrificePanel.6")))
        getOtherModule():showAlertDialog(nil, string.format("%d%s",totalSoulNum, Localize.query("SacrificePanel.6")))
    else
        self.gainSoulNumLabel:setString(string.format(""))
    end

    if totalSoulNum > 0 then
        self.gain_soul:setSpriteFrame("resource_3.png")
        self.gain_soul:setVisible(true)
        self.gain_soul:setOpacity(150)
    else
        self.gain_soul:setVisible(false)
    end

    -- 经验
    local status, totalExp = self:getTotalHeroExp()
    -- print(status..'---'..totalExp)
    -- local num, icon = getTemplateManager():getBagTemplate():getExpIconAndNum(totalExp)
    -- if num >0 then
    --     self.expProNum:setString(string.format("%d经验丹",num))
    -- else
    --     self.expProNum:setString(string.format(""))
    -- end

    if totalExp > 0 then
        -- self.gain_exp:setSpriteFrame(icon)
        self.gain_exp:setVisible(true)
        self.gain_exp:setOpacity(150)

        local num, icon = getTemplateManager():getBagTemplate():getExpIconAndNum(totalExp)
        self.icon = "res/icon/item/"..icon    --存储icon为恭喜获得使用
        if num >0 then
            self.expProNum:setString(string.format("%d%s",num, Localize.query("SacrificePanel.7")))
        else
            self.expProNum:setString(string.format(""))
        end

        self.gain_exp:setTexture("res/icon/item/"..icon)
        self.expProNum:setVisible(true)
    else
        self.gain_exp:setVisible(false)
        self.expProNum:setVisible(false)
    end

    -- 显示和隐藏头像
    for k,v in pairs(self.generalHead) do
        if v.isSelect == true then
            v.headImg:setVisible(true)
            v.headImgq:setVisible(false)

            local quality = self.SoldierTemplate:getHeroQuality(v.hero.hero_no)
            local resIcon = self.SoldierTemplate:getSoldierIcon(v.hero.hero_no)
            changeNewIconImage(v.headImg, resIcon, quality) --更新icon

            -- local headicon = self.SoldierTemplate:getHeroHeadIcon(v.hero.hero_no)
            -- v.headImg:setSpriteFrame(headicon)

            -- local headiconColor = self.SoldierTemplate:getHeroHeadIconColor(v.hero.hero_no)
            -- v.headImgq:setSpriteFrame(headiconColor)
        else
            v.headImg:setVisible(false)
            v.headImgq:setVisible(false)
        end
    end

end

-- 获得献祭武将总共兑换的经验值
function PVSacrificePanel:getTotalHeroExp()
    local totalExp = 0
    for k,v in pairs(self.generalHead) do
        if v.isSelect == true and v.hero.level > 1 then
            totalExp = totalExp + self.SoldierTemplate:getHeroAllExpByLevel(v.hero.level)
        end
    end

    local status = 4
    if math.modf(totalExp/10^5) > 0 then
        status = 1
    elseif math.modf(totalExp/10^4) > 0 then
        status = 2
    elseif math.modf(totalExp/10^3) > 0 then
        status = 3
    end

    return  status, totalExp
end

function PVSacrificePanel:getTotalSoulNum()
    local totalSoulNum = 0
    for k,v in pairs(self.generalHead) do
        if v.isSelect == true then
            totalSoulNum = totalSoulNum + self.SoldierTemplate:getSoulNum(v.hero.hero_no)
        end
    end

    return totalSoulNum
end

function PVSacrificePanel:onReloadView()
    self.addOneKey = false
    self.totalSoulNumLabel:setString(self.commonData:getHeroSoul())  --self.GameLoginResponse.hero_soul)
    self:updateSoulIconAndNum()
end

function PVSacrificePanel:clearResource()

    cclog("--PVSacrificePanel:clearResource--")
    game.removeSpriteFramesWithFile("res/ccb/resource/ui_sacrifice.plist")
end

function PVSacrificePanel:onShowSacrificeView()
    -- self.shieldlayer:setTouchEnabled(true)
    self:setVisible(true)
end

return PVSacrificePanel

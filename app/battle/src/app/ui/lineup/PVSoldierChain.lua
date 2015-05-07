--练体界面

local PVSoldierChain = class("PVSoldierChain", BaseUIView)

function PVSoldierChain:ctor(id)
    self.super.ctor(self, id)
    self.heroTemp = getTemplateManager():getSoldierTemplate()
    self.c_CommonData = getDataManager():getCommonData()

    self:registerNetCallBack()
end

--注册网络回调
function PVSoldierChain:registerNetCallBack()
    local function onCallback(id, data)
        if data.result == true then
            getDataManager():getSoldierData():setSealById(self.heroId, self.curSeal)
            getDataManager():getLineupData():changeSoldierById(self.heroId)
            local num = self.c_CommonData:getFinance(DROP_BREW)
            -- getDataManager():getCommonData():setNectarNum(num-self.useJiu)
            self.c_CommonData:subFinance(DROP_BREW,self.useJiu)
            local function callback()
                self.c_CommonData.updateCombatPower()
                --self:toastShow(self.str)
                self.menuCongXue:setEnabled(true)
                self:updataProgress()
                self:updateData()
                
                groupCallBack(GuideGroupKey.BTN_CHONGXUE, self.heroId)
            end
            --self:updataProgress()
            local node = UI_liantichongci(callback)
            self.nodeShow:addChild(node)
        else
            -- self:toastShow(Localize.query("soldierChain.9"))
            groupCallBack(GuideGroupKey.BTN_CHONGXUE, self.heroId)
            getOtherModule():showAlertDialog(nil, Localize.query("soldierChain.9"))
        end

        
    end
    self:registerMsg(NET_ID_SEAL, onCallback)  -- 冲穴返回
end

function PVSoldierChain:onMVCEnter()
    self.ccbiNode = {}
    self:initTouchListener()
    self:loadCCBI("lineup/ui_solder_lianti.ccbi", self.ccbiNode)
    self:initView()
end

function PVSoldierChain:initView()
    self.ccbiRootNode = self.ccbiNode["UILianTiPage"]
    self.adpterNode = self.ccbiRootNode["adpter_node"]
    self.nodeShow = self.ccbiRootNode["node_show"]
    self.nodeBg = self.ccbiRootNode["node_bg"]
    self.imgBg = self.ccbiRootNode["img_bg"]
    self.nodeHero = self.ccbiRootNode["node_hero"]
    self.labeHero = self.ccbiRootNode["label_heroname"]
    self.labelJie = self.ccbiRootNode["label_jienum"]
    self.bfJiuNum = self.ccbiRootNode["bmfont_all"]
    self.labelMaiName = self.ccbiRootNode["label_xdname"]
    self.labelXuedao1 = self.ccbiRootNode["label_xue1"]
    self.labelXuedao2 = self.ccbiRootNode["label_xue2"]
    self.labelXuedao3 = self.ccbiRootNode["label_xue3"]
    self.menuCongXue = self.ccbiRootNode["menu_cx"]
    self.labelType = self.ccbiRootNode["label_type_num"]
    self.labelAttNum = self.ccbiRootNode["label_bg_num"]
    self.bfUseJiuNum = self.ccbiRootNode["bmfont_use"]
    self.progressSprite = self.ccbiRootNode["progress_fg"]
    self.progressTTF = self.ccbiRootNode["proTTF"]
    self.nodePromote = self.ccbiRootNode["nodePromote"]
    self.nodeConsume = self.ccbiRootNode["nodeConsume"]
    self.nodeProgress = self.ccbiRootNode["nodeProgress"]
    self.labelJinDu = self.ccbiRootNode["jinDu"]
    self.AttNumTable = {}
    for i=1,11 do
        local strName = "label_attr_" .. tostring(i)
        table.insert(self.AttNumTable, self.ccbiRootNode[strName])
    end
    self.animationNode = self.ccbiRootNode["animationNode"]

    self.clipNode = cc.ClippingNode:create()
    self.clipNode:setContentSize(cc.size(549, 566))
    self.clipNode:setAnchorPoint(cc.p(0, 0))
    self.clipNode:setPosition(self.adpterNode:getPosition())
    self.adpterNode:addChild(self.clipNode)

    local stencil = cc.LayerColor:create(cc.c4b(100, 100, 0, 255))
    local imgsize = self.imgBg:getContentSize()
    local imgposx, imgposy = self.imgBg:getPosition()
    stencil:setContentSize(imgsize)
    stencil:setPosition(cc.p(imgposx - imgsize.width/2, imgposy - imgsize.height/2))
    self.clipNode:setStencil(stencil)

    self.nodeBg:removeFromParent(false)
    self.clipNode:addChild(self.nodeBg, 1, 1)
    self.nodeHero:removeFromParent(false)
    self.clipNode:addChild(self.nodeHero, 2, 2)
    self.nodeShow:removeFromParent(false)
    self.nodeShow:setPosition(cc.p(0, 0))
    self.clipNode:addChild(self.nodeShow, 3, 3)
    self.clipNode:setInverted(false)
    self.animationNode:removeFromParent(false)
    self.clipNode:addChild(self.animationNode, 1, 1)

    -- get data from 上一个界面
    self.heroId = self.funcTable[1]
   
    print("&&&&&&&&&& 武将的ID", self.heroId)

    -- update attribute data
    self:updateAttribute()

    -- animationNode
    local node = UI_liantichixu()
    self.animationNode:addChild(node)
--初始化进度条
    self.seal = getDataManager():getSoldierData():getSealById(self.heroId)
    --print("############### seal", seal)

    if self.seal == 0 then seal = self.heroTemp:getFirstSealId()
    else self.seal = self.heroTemp:getNextSealId(self.seal)
    end

    self.progressSprite:setVisible(false)
    self.pulPrgress = cc.ProgressTimer:create(self.progressSprite)
    self.pulPrgress:setAnchorPoint(cc.p(0.5,0.5))
    self.pulPrgress:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.pulPrgress:setBarChangeRate(cc.p(1, 0))
    self.pulPrgress:setMidpoint(cc.p(0, 0))
    self.pulPrgress:setLocalZOrder(0)
    self.progressSprite:getParent():addChild(self.pulPrgress)
    self:updataProgress()
end

function PVSoldierChain:initTouchListener()
    local function backMenuClick()
        cclog("back ..")
        getAudioManager():playEffectButton2()
        self:onHideView()
    end
    local function goSealClick()
        cclog("冲穴")
        getAudioManager():playEffectButton2()
        local number = self.c_CommonData:getFinance(DROP_BREW)
        cclog("琼浆玉液的数目："..number.."需要的雨夜树木："..self.useJiu.."英雄ID"..self.heroId.."当前穴道"..self.curSeal)
        if number >= self.useJiu then
            getNetManager():getLineUpNet():sendSealMsg(self.heroId, self.curSeal)
            self.menuCongXue:setEnabled(false)
            --self:toastShow(self.str)
    
        else
            -- self:toastShow(Localize.query("soldierChain.9"))
            groupCallBack(GuideGroupKey.BTN_CHONGXUE, self.heroId)
            getOtherModule():showAlertDialog(nil, Localize.query("soldierChain.9"))
        end
    end
    local function goZhujiuClick()
        cclog("煮酒")
        getAudioManager():playEffectButton2()
        getModule(MODULE_NAME_HOMEPAGE):removeLastView()
        getModule(MODULE_NAME_HOMEPAGE):removeLastView()
        getModule(MODULE_NAME_HOMEPAGE):removeLastView()
        getModule(MODULE_NAME_HOMEPAGE):removeLastView()
        getModule(MODULE_NAME_HOMEPAGE):removeLastView()
        -- getModule(MODULE_NAME_HOMEPAGE):showUINodeView("PVActivityPage", 5)
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVActivityPage", 5)
        --getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVActivityPage", 4)
        groupCallBack(GuideGroupKey.BTN_ZHUJIU)
    end
    local function goLineupClick()
        cclog("阵容")
        getAudioManager():playEffectButton2()
        getModule(MODULE_NAME_LINEUP):showUIView("PVLineUp")
    end
    self.ccbiNode["UILianTiPage"] = {}
    self.ccbiNode["UILianTiPage"]["backMenuClick"] = backMenuClick
    self.ccbiNode["UILianTiPage"]["onMenuClickGo"] = goSealClick
    self.ccbiNode["UILianTiPage"]["onMenuZhuJiu"] = goZhujiuClick
    self.ccbiNode["UILianTiPage"]["onMenuClickLineup"] = goLineupClick
end

function PVSoldierChain:updateAttribute()

    -- 武将相关
    local heroImage = self.heroTemp:getHeroBigImageById(self.heroId)
    local heroName = self.heroTemp:getHeroName(self.heroId)
    heroImage:setColor(cc.c3b(45,45,45))
    local children = heroImage:getChildren()
    for k,v in pairs(children) do
        v:setColor(cc.c3b(45,45,45))
    end
    self.nodeHero:addChild(heroImage)
    self.labeHero:setString(heroName)

    self:updateData()
end
-- function PVSoldierChain:updataProgress()
--     local seal = getDataManager():getSoldierData():getSealById(self.heroId)
--     if seal == 0 then 
--         seal = self.heroTemp:getFirstSealId()
--     else 
--         seal = self.heroTemp:getNextSealId(seal)
--     end
--     local schDone = self.heroTemp:getSealTemplateById(seal).acupoint - 1
--     local pul = self.heroTemp:getSealTemplateById(seal).pulse
--     local schTotle = self.heroTemp:getMaiNum(pul)
--     if schDone == schTotle then
--         seal = self.heroTemp:getNextSealId(seal)
--         schDone = 0
--         pul = self.heroTemp:getSealTemplateById(seal).pulse
--         schTotle = self.heroTemp:getMaiNum(pul)
--     end
--     --print("这里是进度条思密达")
--     --cclog("完成："..schDone.."总的："..schTotle.."脉数："..pul)
--     local percentage = schDone / schTotle
--     self.pulPrgress:setPercentage(percentage * 100)
--     self.progressTTF:setString(schDone.."/"..schTotle)
-- end


function PVSoldierChain:updataProgress()
    local seal = getDataManager():getSoldierData():getSealById(self.heroId)
    local nextSeal = seal
    if seal == 0 then 
        nextSeal = self.heroTemp:getFirstSealId()
    else 
        nextSeal = self.heroTemp:getNextSealId(seal)
    end
    if nextSeal == 0 then
        self.nodeProgress:setVisible(false)
        self.labelJinDu:setString("满  穴")
        -- self.labelJinDu:setFontSize(30)
        -- self.labelJinDu:setColor(ui.COLOR_RED)
        self.labelJinDu:setPositionX(self.labelJinDu:getPositionX() + 83)
    else

        local schDone = self.heroTemp:getSealTemplateById(nextSeal).acupoint - 1
        local pul = self.heroTemp:getSealTemplateById(nextSeal).pulse
        local schTotle = self.heroTemp:getMaiNum(pul)
        if schDone == schTotle then
            seal = self.heroTemp:getNextSealId(nextSeal)
            schDone = 0
            pul = self.heroTemp:getSealTemplateById(nextSeal).pulse
            schTotle = self.heroTemp:getMaiNum(pul)
        end
        --print("这里是进度条思密达")
        --cclog("完成："..schDone.."总的："..schTotle.."脉数："..pul)
        local percentage = schDone / schTotle
        self.pulPrgress:setPercentage(percentage * 100)
        self.progressTTF:setString(schDone.."/"..schTotle)
    end
end


-- function PVSoldierChain:updateData()

--     --练体相关
--     local seal = getDataManager():getSoldierData():getSealById(self.heroId)
--     print("############### seal", seal)

--     if seal == 0 then seal = self.heroTemp:getFirstSealId()
--     else seal = self.heroTemp:getNextSealId(seal)
--     end

--     self.curSeal = seal

--     local jiuNum = getDataManager():getCommonData():getNectarNum()
--     local sealItemData = self.heroTemp:getSealTemplateById(seal)
--     self.useJiu = sealItemData.expend
--     local step = sealItemData.step
--     local sealName = getTemplateManager():getLanguageTemplate():getLanguageById(sealItemData.name)
--     local stepName = nil
--     local curAttType ,curAtt = self.heroTemp:getCurrSealAtt(seal)

--     if step == 1 then stepName = "一阶"
--     elseif step == 2 then stepName = "二阶"
--     elseif step == 3 then stepName = "三阶"
--     elseif step == 4 then stepName = "四阶"
--     end
--     local pulse = sealItemData.pulse

--     local nextId = sealItemData.next
--     if nextId ~= 0 then
--         local nextNameId = self.heroTemp:getSealTemplateById(nextId).name
--         local nextName = getTemplateManager():getLanguageTemplate():getLanguageById(nextNameId)
--         self.labelXuedao3:setString(nextName)
--         self.labelXuedao3:setVisible(true)
--     else
--         self.labelXuedao3:setVisible(false)
--     end
--     local lastId = self.heroTemp:getLastSealId(seal)
--     if lastId ~= 0 then
--         local lastNameId = self.heroTemp:getSealTemplateById(lastId).name
--         local lastName = getTemplateManager():getLanguageTemplate():getLanguageById(lastNameId)
--         self.labelXuedao1:setString(lastName)
--         self.labelXuedao1:setVisible(true)
--     else
--         self.labelXuedao1:setVisible(false)
--     end

--     local allAttributes = self.heroTemp:getAllAttribute(seal) -- seal之前的所有属性和

--     self.labelJie:setString(stepName)
--     self.bfJiuNum:setString(jiuNum)
--     self.labelMaiName:setString(Localize.query("soldierChain."..tostring(pulse)))
--     self.labelXuedao2:setString(sealName)
--     -- self.menuCongXue

--     self.labelType:setString(Localize.query("soldierAtt."..curAttType) )
--     if curAttType <= 4 and curAttType >= 1 then
--         curAtt = roundNumber(curAtt)
--     end
--     self.labelAttNum:setString("+"..curAtt)
--     self.bfUseJiuNum:setString(self.useJiu)
--     --显示数字提醒
--     local strTemp = Localize.query("soldierAtt."..curAttType)
--     local strNum = "+"..curAtt
--     self.str = strTemp..strNum



--     self.AttNumTable[1]:setString("+"..roundNumber(allAttributes["hp"]))
--     self.AttNumTable[2]:setString("+"..roundNumber(allAttributes["atk"]))
--     self.AttNumTable[3]:setString("+"..roundNumber(allAttributes["physicalDef"]))
--     self.AttNumTable[4]:setString("+"..roundNumber(allAttributes["magicDef"]))
--     self.AttNumTable[5]:setString("+"..allAttributes["hit"])
--     self.AttNumTable[6]:setString("+"..allAttributes["dodge"])
--     self.AttNumTable[7]:setString("+"..allAttributes["cri"])
--     self.AttNumTable[8]:setString("+"..allAttributes["ductility"])
--     self.AttNumTable[9]:setString("+"..allAttributes["criCoeff"])
--     self.AttNumTable[10]:setString("+"..allAttributes["criDedCoeff"])
--     self.AttNumTable[11]:setString("+"..allAttributes["block"])
-- end


function PVSoldierChain:updateData()

    --练体相关
    local seal = getDataManager():getSoldierData():getSealById(self.heroId)
    print("############### seal", seal)

    -- if seal == 0 then seal = self.heroTemp:getFirstSealId()
    -- else seal = self.heroTemp:getNextSealId(seal)
    -- end
    local nextSeal = seal
    if seal == 0 then 
        nextSeal = self.heroTemp:getFirstSealId()
    else 
        nextSeal = self.heroTemp:getNextSealId(seal)
    end
    self.curSeal = nextSeal     --下一个要冲的穴道

    if self.curSeal == 0 then
        self.nodePromote:setVisible(false)
        self.nodeConsume:setVisible(false)
        self.menuCongXue:setEnabled(false)
    end

    if nextSeal == nil or nextSeal == 0 then 
        nextSeal = seal
    end

    -- local jiuNum = getDataManager():getCommonData():getNectarNum()
    local jiuNum = self.c_CommonData:getFinance(DROP_BREW)
    local sealItemData = self.heroTemp:getSealTemplateById(nextSeal)
    self.useJiu = sealItemData.expend["107"][1]
    local step = sealItemData.step
    local sealName = getTemplateManager():getLanguageTemplate():getLanguageById(sealItemData.name)
    local stepName = nil
    local curAttType ,curAtt = self.heroTemp:getCurrSealAtt(nextSeal)

    if step == 1 then stepName = "一阶"
    elseif step == 2 then stepName = "二阶"
    elseif step == 3 then stepName = "三阶"
    elseif step == 4 then stepName = "四阶"
    end
    local pulse = sealItemData.pulse

    local nextId = sealItemData.next
    if nextId ~= 0 then
        local nextNameId = self.heroTemp:getSealTemplateById(nextId).name
        local nextName = getTemplateManager():getLanguageTemplate():getLanguageById(nextNameId)
        self.labelXuedao3:setString(nextName)
        self.labelXuedao3:setVisible(true)
    else
        self.labelXuedao3:setVisible(false)
    end
    local lastId = self.heroTemp:getLastSealId(nextSeal)
    if lastId ~= 0 then
        local lastNameId = self.heroTemp:getSealTemplateById(lastId).name
        local lastName = getTemplateManager():getLanguageTemplate():getLanguageById(lastNameId)
        self.labelXuedao1:setString(lastName)
        self.labelXuedao1:setVisible(true)
    else
        self.labelXuedao1:setVisible(false)
    end

    local allAttributes = self.heroTemp:getAllAttribute(seal) -- seal之前的所有属性和

    self.labelJie:setString(stepName)
    self.bfJiuNum:setString(jiuNum)
    self.labelMaiName:setString(Localize.query("soldierChain."..tostring(pulse)))
    self.labelXuedao2:setString(sealName)
    -- self.menuCongXue

    self.labelType:setString(Localize.query("soldierAtt."..curAttType) )
    -- if curAttType <= 4 and curAttType >= 1 then
    --     curAtt = roundNumber(curAtt)
    -- end
    self.labelAttNum:setString("+"..curAtt)
    self.bfUseJiuNum:setString(self.useJiu)
    --显示数字提醒
    local strTemp = Localize.query("soldierAtt."..curAttType)
    local strNum = "+"..curAtt
    self.str = strTemp..strNum



    self.AttNumTable[1]:setString("+"..allAttributes["hp"])
    self.AttNumTable[2]:setString("+"..allAttributes["atk"])
    self.AttNumTable[3]:setString("+"..allAttributes["physicalDef"])
    self.AttNumTable[4]:setString("+"..allAttributes["magicDef"])
    self.AttNumTable[5]:setString("+"..allAttributes["hit"])
    self.AttNumTable[6]:setString("+"..allAttributes["dodge"])
    self.AttNumTable[7]:setString("+"..allAttributes["cri"])
    self.AttNumTable[8]:setString("+"..allAttributes["ductility"])
    self.AttNumTable[9]:setString("+"..allAttributes["criCoeff"])
    self.AttNumTable[10]:setString("+"..allAttributes["criDedCoeff"])
    self.AttNumTable[11]:setString("+"..allAttributes["block"])
end

function PVSoldierChain:onReloadView()
    self:updateData()
end


--@return
return PVSoldierChain

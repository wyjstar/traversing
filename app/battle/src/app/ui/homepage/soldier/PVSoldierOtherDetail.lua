--查看武将
local PVSoldierOtherDetail = class("PVSoldierOtherDetail",BaseUIView)

function PVSoldierOtherDetail:ctor(id)
    PVSoldierOtherDetail.super.ctor(self, id)
end

function PVSoldierOtherDetail:onMVCEnter()
    self.UISoldierMyDetail = {}
    self.starTable = {}
    self.soldierId = nil --英雄id
    self.c_ChipTemplate = getTemplateManager():getChipTemplate()
    self.c_SoldierData = getDataManager():getSoldierData()
    self.c_SoldierTemplate = getTemplateManager():getSoldierTemplate()
    self.c_SoldierCalculation = getCalculationManager():getSoldierCalculation()
    self.c_LanguageTemplate = getTemplateManager():getLanguageTemplate()

    self:initTouchListener()

    self:loadCCBI("soldier/ui_soldier_attribute.ccbi", self.UISoldierMyDetail)

    self:initView()
    self:initData()
    self:createTableView()

    self:updateData()

    --武将觉醒相关
    self.TYPE_MOVE_NONE = 0
    self.TYPE_MOVE_LEFT = 1
    self.TYPE_MOVE_RIGHT = 2
end

function PVSoldierOtherDetail:initData()
    local soldierId = nil
    self.data = {}  -- {tag, title, content} : tag: 1 技能 2 羁绊 3 突破 4 简介
    self.selectIndex = self:getTransferData()[1]
    soldierId = self.selectIndex
    self.soldierDataItem = self.c_SoldierTemplate:getHeroTempLateById(self.selectIndex)
    self.curType = self:getTransferData()[2]
    self.curLevel = self:getTransferData()[3]
    self.isInstance = self:getTransferData()[4]
    self.breakLevel = self:getTransferData()[5]

    --武将音效的添加
    if self.selectIndex > 0 then
        local res = self.c_SoldierTemplate:getHeroAudio(self.selectIndex)
        if res == 0 then
            print("没有音效")
            self.effectOnBtn:setVisible(false)
            self.labadiSp:setVisible(false)
        else
            print("播放音效")
            self.effectOnBtn:setVisible(true)
            self.labadiSp:setVisible(true)
            self.isMusic = true
            self.musicEffect = res
            getAudioManager():playHeroEffect(res)
        end

        print("删除武将新列表"..self.selectIndex)
        -- self.c_SoldierData:removeSoldierIsNewList(self.selectIndex)
    end

    -- self.c_SoldierData:removeSoldierIsNewList(self.selectIndex)

    -- if self.curType == nil then
    --     local curQuality = self.c_SoldierTemplate:getHeroQuality(soldierId)                             --觉醒相关
    --     if curQuality == 5 or curQuality == 6 then
    --         self.curSoldierId = soldierId
    --         -- self.needPowerChange = self.c_SoldierTemplate:getChangeNeedPower(self.curSoldierId)         --变身所需要的战斗力(百分百变身)
    --         self.changeId = self.c_SoldierTemplate:getSoldierChangeInfo(self.curSoldierId)
    --         --当前战队战斗力数值
    --         if self.changeId ~= nil then
    --             local power = getDataManager():getCommonData():getCombatPower()
    --             self:changePowerShow(power)

    --             self.soldierAddPowerLayer:setVisible(true)
    --             self:initHeroLayerTouch()
    --         else
    --             self.soldierAddPowerLayer:setVisible(false)
    --         end
    --     else
    --         self.soldierAddPowerLayer:setVisible(false)
    --     end
    --     self.buttonLayer:setVisible(true)
    -- end

    -- self.soldierDataItem = self.c_SoldierData:getSoldierDataById(soldierId)
    local jobId = self.c_SoldierTemplate:getHeroTypeId(soldierId)
    local _spriteJob = nil
    print("----jobId-----",jobId)
    if jobId == 1 then
        _spriteJob = "ui_comNew_kind_001.png"
    elseif jobId == 2 then
        _spriteJob = "ui_comNew_kind_002.png"
    elseif jobId == 3 then
        _spriteJob = "ui_comNew_kind_003.png"
    elseif jobId == 4 then
        _spriteJob = "ui_comNew_kind_004.png"
    elseif jobId == 5 then
        _spriteJob = "ui_comNew_kind_005.png"
    end
    self.typeSprite:setSpriteFrame(_spriteJob)

    self.buttonLayer:setVisible(false)
    self.soldierAddPowerLayer:setVisible(false)
    self.btnSoldierAddPower:setVisible(false)
    self.btnSoldierAddPower1:setVisible(false)
    local _posx,_posy = self.getButton:getPosition()
    self.getButton:setPosition(_posx+200,_posy)

    self.c_SoldierData:loadHeroImage(soldierId)
    if self.changeId ~= nil then
        self.c_SoldierData:loadHeroImage(self.changeId)
    end

    -- --是否从关卡界面跳转
    -- if self.isInstance == nil then
    --     self.getButton:setVisible(false)
    -- else
    --     self.getButton:setVisible(true)
    -- end
    --skill
    self:initSkillData(soldierId)
    --更新羁绊
    self:initLinkData(soldierId)
    --更新技能突破
    self:initBreakData(soldierId)
    --更新简介
    self:initSummary(soldierId)
end

function PVSoldierOtherDetail:initSkillData(soldierId)
    local function setSkillAttri(str)
        local _describeLanguage = str
        for findStr in string.gmatch(str, "%$%d+:%w+%$") do  -- 模式匹配“$id:字段$”
            local repStr = nil
            for _var in string.gmatch(findStr, "%d+:%w+") do
                local _pos, _end = string.find(_var, ":")
                local buffId = string.sub(_var, 1, _pos-1)
                local key = string.sub(_var, _end+1)
                print("^^^^^^^^^^^", buffId)
                local buffItem = self.c_SoldierTemplate:getSkillBuffTempLateById(tonumber(buffId))
                -- table.print(buffItem)
                local value = buffItem[key]
                repStr = value
            end
            _describeLanguage = string.gsub(_describeLanguage, "%$%d+:%w+%$", repStr, 1)
        end
        return _describeLanguage
    end

    local soliderItem = self.c_SoldierTemplate:getHeroTempLateById(soldierId)
    local normalSkill = soliderItem.normalSkill --普通技能
    local rageSkill = soliderItem.rageSkill  --怒气技能

    --普通技能
    local normalSkillItem = self.c_SoldierTemplate:getSkillTempLateById(normalSkill)
    local normalName = normalSkillItem.name
    local normalDescribe = normalSkillItem.describe
    local nameLanguage = self.c_LanguageTemplate:getLanguageById(normalName)
    local describeLanguage = self.c_LanguageTemplate:getLanguageById(normalDescribe)
    describeLanguage = setSkillAttri(describeLanguage)

    self:createOneDataItem(1, nameLanguage, describeLanguage)

    --怒气技能
    local rageSkillItem = self.c_SoldierTemplate:getSkillTempLateById(rageSkill)
    local rageName = rageSkillItem.name
    local rageDescribe = rageSkillItem.describe
    nameLanguage = self.c_LanguageTemplate:getLanguageById(rageName)
    describeLanguage = self.c_LanguageTemplate:getLanguageById(rageDescribe)
    describeLanguage = setSkillAttri(describeLanguage)

    self:createOneDataItem(1, nameLanguage, describeLanguage)
end

function PVSoldierOtherDetail:initLinkData(soldierId)
    local function getBuffInfo(buff)
        local strEffect = ""
        for i,v in ipairs(buff) do
            local buffInfo = self.c_SoldierTemplate:getSkillBuffTempLateById(buff[i])
            local buffEffectId = buffInfo.effectId
            local buffType = buffInfo.valueType
            local buffValue = buffInfo.valueEffect
            local strValue = nil
            if buffType == 1 then strValue = tostring(buffValue)
            elseif buffType == 2 then strValue = tostring(buffValue) .. "%"
            end
            strEffect = strEffect .. self.c_SoldierTemplate:getSkillBuffEffectName(buffEffectId) .. strValue
        end
        return strEffect
    end

    local linkItem = self.c_SoldierTemplate:getLinkTempLateById(soldierId)
    for i=1, 5 do
        if self.c_SoldierTemplate:getIsTriggerByIndex(soldierId, i) then
            local strName = "linkname"..tostring(i)
            local strText = "linktext"..tostring(i)
            local strSkill = "link"..tostring(i)
            local name = linkItem[strName]
            local text = linkItem[strText]
            local skillId = linkItem[strSkill]
            local nameLanguage = self.c_LanguageTemplate:getLanguageById(name)
            local textLanguage = self.c_LanguageTemplate:getLanguageById(text)
            local skillInfo = self.c_SoldierTemplate:getSkillTempLateById(skillId)
            local buff = skillInfo.group
            textLanguage = string.gsub(textLanguage, "s%%", "")
            textLanguage = textLanguage .. getBuffInfo(buff)

            self:createOneDataItem(2, nameLanguage, textLanguage)
        end
    end
end

function PVSoldierOtherDetail:initBreakData(soldierId)

    local breakItem = self.c_SoldierTemplate:getBreakupTempLateById(soldierId)
    for i=1, 7 do
        local strBreak = "break"..tostring(i)
        local breakId = breakItem[strBreak]
        if breakId ~= 0 then
            local skillItem = self.c_SoldierTemplate:getSkillTempLateById(breakId) --突破技能item
            local name = skillItem.name
            local describe = skillItem.describe
            -- local breakDetail = "BreakDetail." .. tostring(i)
            -- local nameLanguage = Localize.query(breakDetail) -- 突破无名
            local nameLanguage = i -- 突破无名
            local describeLanguage = self.c_LanguageTemplate:getLanguageById(describe)

            self:createOneDataItem(3, nameLanguage, describeLanguage)
        end
    end
end

function PVSoldierOtherDetail:initSummary(soldierId)

    local heroItem = self.c_SoldierTemplate:getHeroTempLateById(soldierId)
    local describeId = heroItem.describeStr ---- 简介无名
    local describeLanguage = self.c_LanguageTemplate:getLanguageById(describeId)
    self:createOneDataItem(4, "", describeLanguage)
end

function PVSoldierOtherDetail:initTouchListener()
    --返回
    local function onBackClick()
        getAudioManager():playEffectButton2()
        self:onHideView()
    end
    --获得途径
    local function onGetSoldierClick()
        getAudioManager():playEffectButton2()

        local soldierId = self.selectIndex
        local soldierToGetId = self.c_SoldierTemplate:getHeroTempLateById(soldierId).toGet
        local _data =  self.c_ChipTemplate:getDropListById(soldierToGetId)
        if (type(_data.stage) == "table" and table.nums(_data.stage) == 0) and _data.coinHero == 0
            and _data.moneyHero == 0 and _data.coinEqu == 0 and _data.moneyEqu == 0 and _data.soulShop == 0
            and _data.arenaShop == 0 and _data.stageBreak == 0  then
            local tipText = getTemplateManager():getLanguageTemplate():getLanguageById(3300010001)
            -- getOtherModule():showToastView(tipText)
            getOtherModule():showAlertDialog(nil, tipText)

        else
            getOtherModule():showOtherView("PVChipGetDetail", _data, soldierId, 1)
        end
    end

    local function effectOnClick()
        self:stopMusicHero()
        if self.selectIndex > 0 then
            local res = self.c_SoldierTemplate:getHeroAudio(self.selectIndex)
            if res == 0 then
                print("没有音效")
            else
                print("播放音效")
                self.isMusic = true
                self.musicEffect = res
                getAudioManager():playHeroEffect(res)
            end
        end
    end


    self.UISoldierMyDetail["UISoldierMyDetail"] = {}
    self.UISoldierMyDetail["UISoldierMyDetail"]["onBackClick"] = onBackClick
    -- self.UISoldierMyDetail["UISoldierMyDetail"]["ltMenuChange"] = ltMenuChange
    self.UISoldierMyDetail["UISoldierMyDetail"]["onGetSoldierClick"] = onGetSoldierClick
    self.UISoldierMyDetail["UISoldierMyDetail"]["effectOnClick"] = effectOnClick

end

function PVSoldierOtherDetail:initView()
    self.animationManager = self.UISoldierMyDetail["UISoldierMyDetail"]["mAnimationManager"]
    self.heroNameLabel = self.UISoldierMyDetail["UISoldierMyDetail"]["heroNameLabel"]
    self.heroLevelLabel = self.UISoldierMyDetail["UISoldierMyDetail"]["heroLevelLabel"]

    self.attributeLabelA = self.UISoldierMyDetail["UISoldierMyDetail"]["attributeLabelA"]
    self.attributeLabelB = self.UISoldierMyDetail["UISoldierMyDetail"]["attributeLabelB"]
    self.attributeLabelC = self.UISoldierMyDetail["UISoldierMyDetail"]["attributeLabelC"]
    self.attributeLabelD = self.UISoldierMyDetail["UISoldierMyDetail"]["attributeLabelD"]
    self.attributeLabelE = self.UISoldierMyDetail["UISoldierMyDetail"]["attributeLabelE"]
    self.attributeLabelF = self.UISoldierMyDetail["UISoldierMyDetail"]["attributeLabelF"]
    self.attributeLabelG = self.UISoldierMyDetail["UISoldierMyDetail"]["attributeLabelG"]
    self.attributeLabelH = self.UISoldierMyDetail["UISoldierMyDetail"]["attributeLabelH"]

    self.heroName = self.UISoldierMyDetail["UISoldierMyDetail"]["label_heroname"]
    self.heroBreakNumImg = self.UISoldierMyDetail["UISoldierMyDetail"]["img_rightNum"]

    self.heroCardImg = self.UISoldierMyDetail["UISoldierMyDetail"]["heroImageSprite"]
    self.skillListLayer = self.UISoldierMyDetail["UISoldierMyDetail"]["skillListLayer"]
    self.otherSkillListLayer = self.UISoldierMyDetail["UISoldierMyDetail"]["otherSkillListLayer"]

    self.playerSprite = self.UISoldierMyDetail["UISoldierMyDetail"]["playerSprite"]     --英雄image
    self.typeSprite = self.UISoldierMyDetail["UISoldierMyDetail"]["typeSprite"]         --类型图片
    self.heroTypeBMLabel = self.UISoldierMyDetail["UISoldierMyDetail"]["heroTypeBMLabel"]

    self.playerChangeSprite = self.UISoldierMyDetail["UISoldierMyDetail"]["playerChangeSprite"]

    self.powerBMLabel = self.UISoldierMyDetail["UISoldierMyDetail"]["powerBMLabel"]     --攻击力
    self.physicalDefenseLabel = self.UISoldierMyDetail["UISoldierMyDetail"]["physicalDefenseLabel"]
    self.hpBMLabel = self.UISoldierMyDetail["UISoldierMyDetail"]["hpBMLabel"]
    self.magicDefenseLabel = self.UISoldierMyDetail["UISoldierMyDetail"]["magicDefenseLabel"]

    self.levelBMLabel = self.UISoldierMyDetail["UISoldierMyDetail"]["levelBMLabel"]

    self.contentLayer = self.UISoldierMyDetail["UISoldierMyDetail"]["contentLayer"]
    self.btnSoldierAddPower1 = self.UISoldierMyDetail["UISoldierMyDetail"]["btnSoldierAddPower1"]
    self.btnSoldierAddPower = self.UISoldierMyDetail["UISoldierMyDetail"]["btnSoldierAddPower"]
    self.btGetSoldier = self.UISoldierMyDetail["UISoldierMyDetail"]["btGetSoldier"]

    local starSelect1 = self.UISoldierMyDetail["UISoldierMyDetail"]["starSelect1"]
    local starSelect2 = self.UISoldierMyDetail["UISoldierMyDetail"]["starSelect2"]
    local starSelect3 = self.UISoldierMyDetail["UISoldierMyDetail"]["starSelect3"]
    local starSelect4 = self.UISoldierMyDetail["UISoldierMyDetail"]["starSelect4"]
    local starSelect5 = self.UISoldierMyDetail["UISoldierMyDetail"]["starSelect5"]
    local starSelect6 = self.UISoldierMyDetail["UISoldierMyDetail"]["starSelect6"]

    self.buttonLayer = self.UISoldierMyDetail["UISoldierMyDetail"]["buttonLayer"]

    self.inheritLayer = self.UISoldierMyDetail["UISoldierMyDetail"]["inheritLayer"]

    self.getButton = self.UISoldierMyDetail["UISoldierMyDetail"]["getButton"]
    self.lvBMLabel = self.UISoldierMyDetail["UISoldierMyDetail"]["levelBMLabel"]

    --武将觉醒相关
    self.powerDes = self.UISoldierMyDetail["UISoldierMyDetail"]["powerDes"]
    self.powerNum = self.UISoldierMyDetail["UISoldierMyDetail"]["powerNum"]
    self.soldierAddPowerLayer = self.UISoldierMyDetail["UISoldierMyDetail"]["soldierAddPowerLayer"]
    self.heroLayer = self.UISoldierMyDetail["UISoldierMyDetail"]["heroLayer"]
    self.animationNode = self.UISoldierMyDetail["UISoldierMyDetail"]["animationNode"]
    --音效的按钮
    self.effectOnBtn = self.UISoldierMyDetail["UISoldierMyDetail"]["effectOnBtn"]

    self.labadiSp = self.UISoldierMyDetail["UISoldierMyDetail"]["labadiSp"]

    table.insert(self.starTable, starSelect1)
    table.insert(self.starTable, starSelect2)
    table.insert(self.starTable, starSelect3)
    table.insert(self.starTable, starSelect4)
    table.insert(self.starTable, starSelect5)
    table.insert(self.starTable, starSelect6)

    -- self.nodeLevel:setVisible(false)
end

function PVSoldierOtherDetail:createTableView()

    local function tableCellTouched(tbl, cell)
        print("tableView cell touched at index: " .. cell:getIdx())
    end
    local function numberOfCellsInTableView(tab)
       return table.nums(self.data)
    end
    local function cellSizeForTable(tbl, idx)
        return self.itemSize.height, self.itemSize.width
    end
    local function tableCellAtIndex(tbl, idx)
        local cell = tbl:dequeueCell()
        if nil == cell then
            cell = cc.TableViewCell:new()

            cell.cardinfo = {}
            local proxy = cc.CCBProxy:create()
            local node = CCBReaderLoad("soldier/ui_soldier_attri_item.ccbi", proxy, cell.cardinfo)

            cell.tagImg = cell.cardinfo["UIAttriItem"]["tagSprite"]
            cell.title = cell.cardinfo["UIAttriItem"]["soldierName"]
            cell.detail = cell.cardinfo["UIAttriItem"]["detailLabel"]
            cell.pos = cell.cardinfo["UIAttriItem"]["pos_node"]
            cell.item = cell.cardinfo["UIAttriItem"]["itemNode"]

            cell:addChild(node)
        end

        -- 设置数据
        local itemData = self.data[idx+1]
        local tag = itemData.tag
        local title = itemData.title
        local content = itemData.content
        if tag == 1 then
            cell.title:setVisible(true)
            cell.item:removeChildByTag(10)
            cell.tagImg:setSpriteFrame("ui_soldier_jineng.png")
        elseif tag == 2 then
            cell.title:setVisible(true)
            cell.item:removeChildByTag(10)
            cell.tagImg:setSpriteFrame("ui_soldier_jiban.png")
        elseif tag == 3 then
            local rect = cc.rect(title*30, 0, 30, 46)
            local sprite = cc.Sprite:createWithTexture(self.texture, rect)
            local posx, posy = cell.pos:getPosition()
            sprite:setPosition(posx,posy)
            sprite:setTag(10)
            cell.item:removeChildByTag(10)
            cell.item:addChild(sprite)
            cell.tagImg:setSpriteFrame("ui_soldier_tupo.png")
            cell.title:setVisible(false)
        elseif tag == 4 then
            cell.title:setVisible(true)
            cell.item:removeChildByTag(10)
            cell.tagImg:setSpriteFrame("ui_soldier_jianjie.png")
        end
        cell.title:setString(title)
        cell.detail:setString(content)

        return cell
    end

    self.texture = cc.Director:getInstance():getTextureCache():addImage("res/ui/ui_tuponumber.png")

    local tempTable = {}
    local proxy = cc.CCBProxy:create()
    local node = CCBReaderLoad("soldier/ui_soldier_attri_item.ccbi", proxy, tempTable)
    self.itemSize = tempTable["UIAttriItem"]["itemNode"]:getContentSize()
    self.layerSize = self.contentLayer:getContentSize()

    self.tableView = cc.TableView:create(self.layerSize)
    self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.tableView:setDelegate()
    self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.contentLayer:addChild(self.tableView)
    self.tableView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
    self.tableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.tableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)

    local scrBar = PVScrollBar:new()
    scrBar:init(self.tableView,1)
    scrBar:setPosition(cc.p(self.layerSize.width,self.layerSize.height/2))
    self.contentLayer:addChild(scrBar,2)

    self.tableView:reloadData()
end

function PVSoldierOtherDetail:updateData()

    local soldierId = self.soldierDataItem.id
    local break_level = self.breakLevel

    local soldierTemplateItem = self.c_SoldierTemplate:getHeroTempLateById(soldierId)
    local level = self.curLevel
    if level == nil then
        level = "1"
    end
    local quality = soldierTemplateItem.quality
    updateStarLV(self.starTable, quality)    --更新星级
    local levelNode = getLevelNode(level)    --更新等级
    self.lvBMLabel:removeAllChildren()
    self.lvBMLabel:addChild(levelNode)
    if self.curLevel ~= nil then
        local hpValue = self.c_SoldierCalculation:getSoldierHP(soldierId, level, break_level)
        local atkValue = self.c_SoldierCalculation:getSoldierATK(soldierId, level, break_level)
        local pdefValue = self.c_SoldierCalculation:getSoldierPDEF(soldierId, level, break_level)
        local mdefValue = self.c_SoldierCalculation:getSoldierMDEF(soldierId, level, break_level)
        self.powerBMLabel:setString(string.format(atkValue))
        self.hpBMLabel:setString(string.format(hpValue))
        self.physicalDefenseLabel:setString(string.format(pdefValue))
        self.magicDefenseLabel:setString(string.format(mdefValue))
    else
        self.powerBMLabel:setString(string.format(roundAttriNum(soldierTemplateItem.atk)))
        self.hpBMLabel:setString(string.format(roundAttriNum(soldierTemplateItem.hp)))
        self.physicalDefenseLabel:setString(string.format(roundAttriNum(soldierTemplateItem.physicalDef)))
        self.magicDefenseLabel:setString(string.format(roundAttriNum(soldierTemplateItem.magicDef)))
    end
    self:initHeroImage(soldierId)

    local _name = self.c_SoldierTemplate:getHeroName(soldierId)
    self.heroName:setString(_name)

    if break_level == 0 or break_level == nil then self.heroBreakNumImg:setVisible(false)
    else
        -- print("break break_level img", break_level)
        local strImg = "ui_lineup_number"..tostring(break_level)..".png"
        self.heroBreakNumImg:setSpriteFrame(strImg)
        self.heroBreakNumImg:setVisible(true)
    end
    local color = getTemplateManager():getStoneTemplate():getColorByQuality(quality)
    self.heroName:setColor(color)

    local quality = soldierTemplateItem.quality
    local resIcon = self.c_SoldierTemplate:getSoldierIcon(soldierId)
    changeNewIconImage(self.heroCardImg, resIcon, quality)
end

--更新人物图像
function PVSoldierOtherDetail:initHeroImage(heroId)
    --武将觉醒相关
    self.curTypeIndex = 1
    --更新英雄大图
    addHeroHDSpriteFrame(heroId)
    print("---------------------- ", heroId)
    self.playerSprite:removeAllChildren()
    local heroImageNode = self.c_SoldierTemplate:getHeroBigImageById(heroId)
    self.playerSprite:addChild(heroImageNode)
    self.playerChangeSprite:setVisible(false)
    heroImageNode:setPosition(self.playerSprite:getContentSize().width / 2, self.playerSprite:getContentSize().height / 2)
end

function PVSoldierOtherDetail:createOneDataItem(tag, title, content)
    local _data = {}
    _data.tag = tag
    _data.title = title
    _data.content = content
    table.insert(self.data, _data)
end

--武将觉醒 更改英雄大图
function PVSoldierOtherDetail:changeHeroImage(heroId1, heroId2)

    print("changeHeroImage : ", heroId1, heroId2)

    addHeroHDSpriteFrame(heroId1)
    addHeroHDSpriteFrame(heroId2)

    self.playerSprite:removeAllChildren()
    local heroImageNode1 = self.c_SoldierTemplate:getHeroBigImageById(heroId1)
    self.playerSprite:addChild(heroImageNode1)
    heroImageNode1:setPosition(self.playerSprite:getContentSize().width / 2, self.playerSprite:getContentSize().height / 2)
    -- self.playerSprite:setVisible(false)
    self.playerChangeSprite:removeAllChildren()
    local heroImageNode2 = self.c_SoldierTemplate:getHeroBigImageById(heroId2)
    self.playerChangeSprite:addChild(heroImageNode2)
    heroImageNode2:setPosition(self.playerChangeSprite:getContentSize().width / 2, self.playerChangeSprite:getContentSize().height / 2)

    local function callBack()
        local fadeInAction = cc.FadeIn:create(1)
        local fadeOutAction = cc.FadeOut:create(1)
        local action2 = cc.Sequence:create(fadeInAction, fadeOutAction)
        heroImageNode2:runAction(action2)
    end

    local fadeInAction = cc.FadeIn:create(1)
    local fadeOutAction = cc.FadeOut:create(1)
    local action = cc.Sequence:create(fadeOutAction, fadeInAction, cc.CallFunc:create(callBack))

    -- heroImageNode1:runAction(action)

    if self.curTypeIndex == 2 then
        local effect = UI_Wujiangzhuanhuanzise()
        self.animationNode:addChild(effect)
    end
end

--武将觉醒 滑动查看武将信息
function PVSoldierOtherDetail:initHeroLayerTouch()
    local posX,posY = self.heroLayer:getPosition()
    local size = self.heroLayer:getContentSize()

    local rectArea = cc.rect(posX, posY, size.width, size.height)

    local moveType = self.TYPE_MOVE_NONE
    local MAGIN = 40
    local function onTouchEvent(eventType, x, y)
        if eventType == "began" then
            local isInRect = cc.rectContainsPoint(rectArea, cc.p(x,y))
            moveType = self.TYPE_MOVE_NONE
            if isInRect then
                self.touchBeginX = x
                return true
            else
                return false
            end

        elseif  eventType == "moved" then
            local length = self.touchBeginX - x
            if math.abs(length) > MAGIN then
                if length > 0 then
                    moveType = self.TYPE_MOVE_LEFT
                else
                    moveType = self.TYPE_MOVE_RIGHT
                end
            else
                moveType = self.TYPE_MOVE_NONE
            end
        elseif  eventType == "ended" then
            self:onLayerTouchCallBack(moveType)
        end
    end
    self.heroLayer:registerScriptTouchHandler(onTouchEvent)
    self.heroLayer:setTouchMode(cc.TOUCHES_ONE_BY_ONE)
    self.heroLayer:setTouchEnabled(true)
end

function PVSoldierOtherDetail:onLayerTouchCallBack(moveType)
    if moveType == self.TYPE_MOVE_RIGHT then
        self:OnTouchMoveRight()
    elseif moveType == self.TYPE_MOVE_LEFT then
        self:OnTouchMoveLeft()
    end
end

--往左滑动
function PVSoldierOtherDetail:OnTouchMoveLeft()
    if self.curTypeIndex == 1 and self.changeId ~= nil then
        print("向左 ====================== ")
        -- self.playerSprite:setVisible(false)
        -- self.playerChangeSprite:setVisible(false)
        self.curTypeIndex = 2
        self:changeHeroImage(self.changeId, self.curSoldierId)                            --变身之后的图片
    end
end

--往右滑动
function PVSoldierOtherDetail:OnTouchMoveRight()
    if self.curTypeIndex == 2 then
        print("向右 ================== ")
        -- self.playerChangeSprite:setVisible(false)
        -- self.playerSprite:setVisible(false)
        self.curTypeIndex = 1                               --原图
        self:changeHeroImage(self.curSoldierId, self.changeId)
    end
end

--武将觉醒 战斗力显示更新
function PVSoldierOtherDetail:changePowerShow(power)
    if self.needPowerChange == nil then return end

    local needPower = tonumber(self.needPowerChange)
    if power > needPower then
        self.powerDes:setString(Localize.query("soldier.4"))
        self.powerNum:setString(needPower)
        self.powerDes:setColor(ui.COLOR_WHITE)
        self.powerNum:setColor(ui.COLOR_WHITE)
    else
        self.powerDes:setString(Localize.query("soldier.5"))
        self.powerNum:setString(needPower)
        self.powerDes:setColor(ui.COLOR_RED)
        self.powerNum:setColor(ui.COLOR_RED)
    end
end

function PVSoldierOtherDetail:onReloadView()
    local power = getDataManager():getCommonData():getCombatPower()                 --获取战斗数值
    self:changePowerShow(power)

    self:updateData()
end

function PVSoldierOtherDetail:stopMusicHero()
    if self.isMusic then
        print("关闭音效")
        -- cc.SimpleAudioEngine:getInstance():stopMusic(true)
        -- cc.SimpleAudioEngine:getInstance():stopEffect(self.musicEffect)
        cc.SimpleAudioEngine:getInstance():stopAllEffects()
        self.isMusic = false
    else
    end
end

return PVSoldierOtherDetail

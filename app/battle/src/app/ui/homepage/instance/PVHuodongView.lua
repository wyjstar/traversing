-- 讨伐中的活动界面
--[[
  @ 使用需 setChapterInstance(inst) : 用来关闭页面后显示出活动列表
  @ 调用createHuodongView(huodongType) : 将创建对应的活动页面
]]

local Huodong_Type_Gold = 1
local Huodong_Type_Exp = 2

local PVHuodongView = class("PVHuodongView",function ()
    return cc.Node:create()
end)


function PVHuodongView:ctor()
    self.ccbiNode = {}
    self.chapterInst = nil  --章节类实例
    self:init()

    self._languageTemp = getTemplateManager():getLanguageTemplate()
    self._stageTemp = getTemplateManager():getInstanceTemplate()
    self._stageData = getDataManager():getStageData()
    self._resourceTemp = getTemplateManager():getResourceTemplate()
    self._dropTemp = getTemplateManager():getDropTemplate()
    self._chipTemp = getTemplateManager():getChipTemplate()
    self._commonData = getDataManager():getCommonData()
    self._baseTemp = getTemplateManager():getBaseTemplate()
    self.c_SoldierData = getDataManager():getSoldierData()
    self.c_EquipmentData = getDataManager():getEquipmentData()
end

function PVHuodongView:setChapterInstance(inst)
    self.chapterInst = inst
end

function PVHuodongView:init(size)

    game.addSpriteFramesWithFile("res/stage/stage_map.plist")
    -- 添加CCB界面
    self:initTouchListener()
    local proxy = cc.CCBProxy:create()
    local node = CCBReaderLoad("instance/ui_huodong_view.ccbi", proxy, self.ccbiNode)
    self:addChild(node)

end

--绑定事件
function PVHuodongView:initTouchListener()

    local function backMenuClick()  -- 返回到章节列表
        assert(self.chapterInst, "you must to call function \"PVChapterMap:setChapterInstance(inst)\" ")
        getAudioManager():playEffectButton2()
        for k,v in pairs(self.chapterInst.menu) do
            v:setEnabled(true)
        end

        local currTime = getDataManager():getCommonData():getTime()
        local weekDay = os.date("%w", currTime) + 1
        if weekDay == 1 or weekDay % 2 == 0 then
            --周一、周三、周五、周日开放
            self.chapterInst.goldHuodongBtn:setEnabled(true)
            self.chapterInst.expHuodongBtn:setEnabled(false)
        else
            --周二、周四、周六、周日开放
            self.chapterInst.goldHuodongBtn:setEnabled(false)
            self.chapterInst.expHuodongBtn:setEnabled(true)
        end
        
        self:removeFromParent()
    end

    local function instanceClick1()
        getAudioManager():playEffectButton2()
        self.curStageIdx = 1
        self:updateView()
    end
    local function instanceClick2()
        getAudioManager():playEffectButton2()
        self.curStageIdx = 2
        self:updateView()
    end
    local function instanceClick3()
        getAudioManager():playEffectButton2()
        self.curStageIdx = 3
        self:updateView()
    end

    local function onClickGoFightHDBtn()
        print("进入活动关卡。。。", self.stageList[self.curStageIdx].id)
        if self.actStageTimes > 0 then
            self._stageData:setCurrStageId(self.stageList[self.curStageIdx].id)
            getModule(MODULE_NAME_HOMEPAGE):showUIView("PVEmbattle", self.stageList[self.curStageIdx].id,"activity")
        else
            getOtherModule():showAlertDialog(nil, Localize.query("instance.1"))
        end
    end

    self.ccbiNode["UIHuodongView"] = {}
    self.ccbiNode["UIHuodongView"]["backMenuClick"] = backMenuClick
    self.ccbiNode["UIHuodongView"]["instanceClick1"] = instanceClick1
    self.ccbiNode["UIHuodongView"]["instanceClick2"] = instanceClick2
    self.ccbiNode["UIHuodongView"]["instanceClick3"] = instanceClick3
    self.ccbiNode["UIHuodongView"]["onClickGoFightHDBtn"] = onClickGoFightHDBtn
end

--获取控件
function PVHuodongView:initView()
    --当前活动索引，默认1 （难度1，难度2，难度3的3个关卡）
    self.curStageIdx = 1

    self.ccbiRootNode = self.ccbiNode["UIHuodongView"]
    self.hdDropLayer = self.ccbiRootNode["dropsLayer"]
    self.hdImgArrowLeft = self.ccbiRootNode["hd_arrow_left"]
    self.hdImgArrowRight = self.ccbiRootNode["hd_arrow_right"]
    self.timesLabel = self.ccbiRootNode["timesLabel"]
    self.instanceMenu1 = self.ccbiRootNode["instanceMenu1"]
    self.instanceMenu2 = self.ccbiRootNode["instanceMenu2"]
    self.instanceMenu3 = self.ccbiRootNode["instanceMenu3"]
    self.activityTitle = self.ccbiRootNode["activity_title"]
    self.sprite1 = self.ccbiRootNode["sprite1"]
    self.sprite2 = self.ccbiRootNode["sprite2"]
    self.sprite3 = self.ccbiRootNode["sprite3"]
    self.wordMenu1 = self.ccbiRootNode["wordMenu1"]
    self.wordMenu2 = self.ccbiRootNode["wordMenu2"]
    self.wordMenu3 = self.ccbiRootNode["wordMenu3"]

    --活动等级限制，难度1不做限制
    self.playerLevel = self._commonData:getLevel()
    if self.playerLevel >= self.stageList[2].levelLimit then
        self.instanceMenu2:setEnabled(true)
        self.wordMenu2:setEnabled(true)
    else
        self.instanceMenu2:setEnabled(false)
        self.wordMenu2:setEnabled(false)
    end
    if self.playerLevel >= self.stageList[3].levelLimit then
        self.instanceMenu3:setEnabled(true)
        self.wordMenu3:setEnabled(true)
    else
        self.instanceMenu3:setEnabled(false)
        self.wordMenu3:setEnabled(false)
    end

    if self.huodongType == Huodong_Type_Gold then
        game.setSpriteFrame(self.activityTitle,"#ui_instance_lb_jybk.png")
        game.setSpriteFrame(self.sprite1,"#ui_instance_gold_001.png")
        game.setSpriteFrame(self.sprite2,"#ui_instance_gold_002.png")
        game.setSpriteFrame(self.sprite3,"#ui_instance_gold_003.png")
        self.wordMenu1:setNormalSpriteFrame(game.newSpriteFrame("ui_instance_lb_nor1.png"))
        self.wordMenu2:setNormalSpriteFrame(game.newSpriteFrame("ui_instance_lb_nor2.png"))
        self.wordMenu3:setNormalSpriteFrame(game.newSpriteFrame("ui_instance_lb_nor3.png"))
    else
        game.setSpriteFrame(self.activityTitle,"#ui_instance_lb_jcsl.png")
        game.setSpriteFrame(self.sprite1,"#ui_instance_tu_001.png")
        game.setSpriteFrame(self.sprite2,"#ui_instance_tu_002.png")
        game.setSpriteFrame(self.sprite3,"#ui_instance_tu_003.png")
        self.wordMenu1:setNormalSpriteFrame(game.newSpriteFrame("ui_instance_lb_yj.png"))
        self.wordMenu2:setNormalSpriteFrame(game.newSpriteFrame("ui_instance_lb_mj.png"))
        self.wordMenu3:setNormalSpriteFrame(game.newSpriteFrame("ui_instance_lb_sj.png"))
    end

    self:updateView()
end

function PVHuodongView:updateView()
    --创建活动掉落列表
    self:createHDDropList(self.stageList[self.curStageIdx].id)
    
    --更新剩余次数
    local curHdTimes = self._stageData:getActStageTimes()
    local vip = getDataManager():getCommonData():getVip()
    -- local fbMaxTimes = getTemplateManager():getBaseTemplate():getNumEliteTimes(vip)
    local hdMaxTimes = getTemplateManager():getBaseTemplate():getNumActTimes(vip)
    -- self.eliteStageTimes = fbMaxTimes - curFbTimes
    self.actStageTimes = hdMaxTimes - curHdTimes
    self.timesLabel:setString(string.format(self.timesLabel:getString(),self.actStageTimes,hdMaxTimes))
    
    --更新难度选中状态
    if self.curStageIdx == 1 then
        self.instanceMenu1:setNormalSpriteFrame(game.newSpriteFrame("ui_instance_bg2.png"))
        self.instanceMenu2:setNormalSpriteFrame(game.newSpriteFrame("ui_instance_bg.png"))
        self.instanceMenu3:setNormalSpriteFrame(game.newSpriteFrame("ui_instance_bg.png"))
    elseif self.curStageIdx == 2 then
        self.instanceMenu1:setNormalSpriteFrame(game.newSpriteFrame("ui_instance_bg.png"))
        self.instanceMenu2:setNormalSpriteFrame(game.newSpriteFrame("ui_instance_bg2.png"))
        self.instanceMenu3:setNormalSpriteFrame(game.newSpriteFrame("ui_instance_bg.png"))
    else
        self.instanceMenu1:setNormalSpriteFrame(game.newSpriteFrame("ui_instance_bg.png"))
        self.instanceMenu2:setNormalSpriteFrame(game.newSpriteFrame("ui_instance_bg.png"))
        self.instanceMenu3:setNormalSpriteFrame(game.newSpriteFrame("ui_instance_bg2.png"))
    end

end

-- 为活动关卡创建掉落物品list
function PVHuodongView:createHDDropList(stageId)
    print("掉落更新 -------===========---------- ", stageId)
    -- 查stage_config的boss掉落, 小怪掉落
    local _bossDropId = self._stageTemp:getSpecialStageById(stageId).eliteDrop
    local _monsterDropId = self._stageTemp:getSpecialStageById(stageId).commonDrop
    local _smallDropId = self._dropTemp:getBigBagById(_bossDropId).smallPacketId[1]
    local _itemList = self._dropTemp:getAllItemsByDropId(_smallDropId)
    local _smallDropId2 = self._dropTemp:getBigBagById(_monsterDropId).smallPacketId[1]
    local _itemList2 = self._dropTemp:getAllItemsByDropId(_smallDropId2)
    for k,v in pairs(_itemList2) do
        local _find = true
        for _k,_v in pairs(_itemList) do
            if _v.detailId == v.detailId then
                _find = false
                break
            end
        end
        if _find == true then table.insert(_itemList, v) end
    end

    print("++活动droplist++++++++++++++++++++")
    table.print(_itemList)
    print("++droplist++++++++++++++++++++")

    local function tableCellTouched( tbl, cell )
        print("drop cell touched ..", cell:getIdx())
        local v = _itemList[cell:getIdx()+1]
        table.print(v)
        if v.type == 101 then -- 武将
            getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSoldierOtherDetail", v.detailId, 2, nil, 1)
        elseif v.type == 102 then -- 装备
            local equipment = getTemplateManager():getEquipTemplate():getTypeById(v.detailId)
            getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVEquipmentAttribute", equipment, 2)
        elseif v.type == 103 then -- 武将碎片
            local nowPatchNum = self.c_SoldierData:getPatchNumById(v.detailId)
            getOtherModule():showOtherView("PVCommonChipDetail", 1, v.detailId, nowPatchNum)
        elseif v.type == 104 then -- 装备碎片
            local nowPatchNum = self.c_EquipmentData:getPatchNumById(v.detailId)
            getOtherModule():showOtherView("PVCommonChipDetail", 2, v.detailId, nowPatchNum)
        elseif v.type == 105 then  -- 道具
            getOtherModule():showOtherView("PVCommonDetail", 1, v.detailId, 1)
        end
    end
    local function numberOfCellsInTableView(tab)
       return table.nums(_itemList)
    end
    local function cellSizeForTable(tbl, idx)
        return 110,130
    end
    local function tableCellAtIndex(tbl, idx)
        local cell = tbl:dequeueCell()
        if nil == cell then
            cell = cc.TableViewCell:new()
        end

        cell:removeAllChildren()

        local v = _itemList[idx+1]

        local sprite = game.newSprite()
        if v.type < 100 then  -- 可直接读的资源图
            _temp = v.type
            local _icon = self._resourceTemp:getResourceById(_temp)
            setItemImage(sprite,"#".._icon,1)
        else  -- 需要继续查表
            if v.type == 101 then -- 武将
                _temp = getTemplateManager():getSoldierTemplate():getSoldierIcon(v.detailId)
                local quality = getTemplateManager():getSoldierTemplate():getHeroQuality(v.detailId)
                changeNewIconImage(sprite,_temp,quality)
            elseif v.type == 102 then -- equpment
                _temp = getTemplateManager():getEquipTemplate():getEquipResIcon(v.detailId)
                local quality = getTemplateManager():getEquipTemplate():getQuality(v.detailId)
                changeEquipIconImageBottom(sprite, _temp, quality)
            elseif v.type == 103 then -- hero chips
                _temp = self._chipTemp:getTemplateById(v.detailId).resId
                local _icon = self._resourceTemp:getResourceById(_temp)
                local _quality = self._chipTemp:getTemplateById(v.detailId).quality
                changeHeroChipIcon(sprite,_icon, _quality)
            elseif v.type == 104 then -- equipment chips
                _temp = self._chipTemp:getTemplateById(v.detailId).resId
                local _icon = self._resourceTemp:getResourceById(_temp)
                local _quality = self._chipTemp:getTemplateById(v.detailId).quality
                changeEquipChipIconImageBottom(sprite,_icon, _quality)
            elseif v.type == 105 then  -- item
                _temp = getTemplateManager():getBagTemplate():getItemResIcon(v.detailId)
                local quality = getTemplateManager():getBagTemplate():getItemQualityById(v.detailId)
                setItemImage3(sprite,_temp,quality)
            end
        end
        cell:addChild(sprite)
        sprite:setPosition(55, 55)

        if self._hdflag_showArrow == true then
            if self.hdDropTableView:getContentOffset().x >= self.hdDropTableView:maxContainerOffset().x then
                self.hdImgArrowLeft:setVisible(false)
                self.hdImgArrowRight:setVisible(true)
            elseif self.hdDropTableView:getContentOffset().x <= self.hdDropTableView:minContainerOffset().x then
                self.hdImgArrowRight:setVisible(false)
                self.hdImgArrowLeft:setVisible(true)
            end
        end

        return cell
    end

    local layerSize = self.hdDropLayer:getContentSize()
    self.hdDropLayer:removeAllChildren()

    self.hdDropTableView = cc.TableView:create(layerSize)    -- 剧情列表
    self.hdDropTableView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    self.hdDropTableView:setDelegate()
    self.hdDropLayer:addChild(self.hdDropTableView)

    self.hdDropTableView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
    self.hdDropTableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.hdDropTableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.hdDropTableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.hdDropTableView:reloadData()

    if table.nums(_itemList) >= 4 then
        self._hdflag_showArrow = true
        self.hdImgArrowLeft:setVisible(false)
        self.hdImgArrowRight:setVisible(true)
    else
        self._hdflag_showArrow = false
        self.hdImgArrowLeft:setVisible(false)
        self.hdImgArrowRight:setVisible(false)
    end
end

function PVHuodongView:createHuodongView(huodongType)
    self.hdGoldStageList, self.hdExpStageList = self._stageTemp:getHDList()
    self.huodongType = huodongType
    if self.huodongType == Huodong_Type_Gold then
        self.stageList = self.hdGoldStageList
    elseif self.huodongType == Huodong_Type_Exp then
        self.stageList = self.hdExpStageList
    else
        print("错误的活动类型！")
    end
    self:initView()
end



--@return
return PVHuodongView


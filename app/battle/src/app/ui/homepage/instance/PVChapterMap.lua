-- 具体章节的地图
--[[
  @ 使用需 setChapterInstance(inst) : 用来关闭Map后显示出章节列表
  @ 使用需要调用 setData(data) : 关卡数据, simple stage list
  @ 最后调用createStage() : 将创建出关卡
]]

local ChapterNode = import(".PVChapterNode")


local PVChapterMap = class("PVChapterMap",function ()
    return cc.Node:create()
end)


function PVChapterMap:ctor()

    self.ccbiNode = {}
    self.chapterInst = nil  --章节类实例

    self:init()
    self:initView()

    self._stageTemp = getTemplateManager():getInstanceTemplate()
    self._languageTemp = getTemplateManager():getLanguageTemplate()
    self._stageData = getDataManager():getStageData()
    self._resourceTemp = getTemplateManager():getResourceTemplate()

end

function PVChapterMap:setChapterInstance(inst)
    self.chapterInst = inst
end

function PVChapterMap:init(size)

    game.addSpriteFramesWithFile("res/stage/stage_map.plist")
    -- 添加CCB界面
    self:initTouchListener()
    local proxy = cc.CCBProxy:create()
    local node = CCBReaderLoad("instance/ui_chapters_map.ccbi", proxy, self.ccbiNode)
    self:addChild(node)

end

function PVChapterMap:setData( stageList )

    print("----PVChapterMap:setData------")

    assert(stageList ~= nil, "PVChapterMap:setData(list): list must not be nil !")
    self.data = stageList

    -- 判断是否要创建星级抽奖
    local chapterIdx = self._stageTemp:getIndexofStage(self.data[1])
    self.chapterIdx = chapterIdx
    if chapterIdx == 1 then
        print("-----self.isShowStar = false--")
        self.prizeNode:setVisible(false)
        self.isShowStar = false
    else
        self.getstar = self._stageData:getStarNum(chapterIdx)
        if chapterIdx == 2 then self:createStarPrize(2)
        else self:createStarPrize(3) end
        self.isShowStar = true
        print("-----self.isShowStar = true--")
    end

    -- 创建地图
    local chapterItem = self._stageTemp:getChapterItemByChapterNo(chapterIdx)
    self.chapterItem = chapterItem
    local _map = self._resourceTemp:getResourceById(chapterItem.resMap)
    -- print("map:::::::::", _map)
    local _path = self._resourceTemp:getResourceById(chapterItem.stage_line)
    print("----".._path)
    -- self.spritePath:setSpriteFrame(_path)
    cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGB565)
    self.spriteMap:setTexture("stage/".._map)
    print("chapterIdx====" .. chapterIdx)
    cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA8888)
    -- 奖励
    -- local stageAward = self._stageData:getAwardInfoByNo(chapterIdx)
    -- if stageAward then
    --     self.box1open = stageAward.award[1]
    --     self.box2open = stageAward.award[2]
    --     self.box3open = stageAward.award[3]

    --     -- 处理领取
    --     if self.box1open == 1 then self.box1:setEnabled(false) end
    --     if self.box2open == 1 then self.box2:setEnabled(false) end
    --     if self.box3open == 1 then self.box3:setEnabled(false) end
    -- else
    --     self.box1:setVisible(false)
    --     self.box2:setVisible(false)
    --     self.box3:setVisible(false)
    -- end
    self:updateBoxView()
end

function PVChapterMap:updateBoxView()
    local stageAward = self._stageData:getAwardInfoByNo(self.chapterIdx)
    if stageAward then
        local box1open = stageAward.award[1]
        local box2open = stageAward.award[2]
        local box3open = stageAward.award[3]

        -- 处理领取
        if box1open == 1 then
            self.box1:setEnabled(false)
        else
            self.box1:setEnabled(true)
        end
        if box2open == 1 then
            self.box2:setEnabled(false)
        else
            self.box2:setEnabled(true)
        end

        if box3open == 1 then
            self.box3:setEnabled(false)
        else
            self.box3:setEnabled(true)
        end
        print("self.getstar=======", self.getstar)
        if self.getstar >= 7 then
            --添加有可领取的奖励时的发光特效
            if box1open ~= 1 then
                self:addEffectReward(self.box1, 101, 1)
            end

            SpriteGrayUtil:drawSpriteTextureColor(self.box1)
        else
            SpriteGrayUtil:drawSpriteTextureGray(self.box1)
        end
        if self.getstar >= 14 then
            if box2open ~= 1 then
                self:addEffectReward(self.box2, 102, 2)
            end
            SpriteGrayUtil:drawSpriteTextureColor(self.box2)
        else
            SpriteGrayUtil:drawSpriteTextureGray(self.box2)
        end

        if self.getstar >= 21 then
            if box3open ~= 1 then
                self:addEffectReward(self.box3, 103, 3)
            end
            SpriteGrayUtil:drawSpriteTextureColor(self.box3)
        else
            SpriteGrayUtil:drawSpriteTextureGray(self.box3)
        end
    else
        self.box1:setVisible(false)
        self.box2:setVisible(false)
        self.box3:setVisible(false)
    end
end

--可领取奖励发光特效
function PVChapterMap:addEffectReward(curNode, effctTag, actionTag)
    local function callBack()
        if self.box3:getChildByTag(effctTag) then
            self.box3:removeChildByTag(effctTag)
        end
        local node = UI_Guankakaibaoxiang()
        node:setPosition(35, 55)
        node:setTag(effctTag)
        curNode:addChild(node)
    end

    local sequence = cc.Sequence:create(cc.CallFunc:create(callBack), cc.DelayTime:create(2))
    repeatAction2 = cc.RepeatForever:create(sequence)
    repeatAction2:setTag(actionTag)
    curNode:runAction(repeatAction2)
end

--绑定事件
function PVChapterMap:initTouchListener()

    local function backMenuClick()  -- 返回到章节列表
        assert(self.chapterInst, "you must to call function \"PVChapterMap:setChapterInstance(inst)\" ")
        -- 重置当前关卡id
        self._stageData:setCurrStageId(nil)
        getAudioManager():playEffectButton2()
        self.chapterInst:showChaptersList(true)
        for k,v in pairs(self.chapterInst.menu) do
            v:setEnabled(true)
        end
        self:removeFromParent()
    end
    local function menuCallback()
        getAudioManager():playEffectButton2()
        local isFullStar = self.getstar == self.maximumValue
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVStarAwardView", self.chapterIdx, isFullStar)
        -- stepCallBack(G_GUIDE_40114)    -- 40021 点击星级抽奖

        groupCallBack(GuideGroupKey.BTN_CLOSE_CHOUJIANG)
    end
    self.ccbiNode["UIChaptersMap"] = {}
    self.ccbiNode["UIChaptersMap"]["backMenuClick"] = backMenuClick
    self.ccbiNode["UIChaptersMap"]["MenuClick"] = menuCallback
end

--获取控件
function PVChapterMap:initView()

    self.ccbiRootNode = self.ccbiNode["UIChaptersMap"]
    self.sliderNode = self.ccbiRootNode["node_slider"]
    -- self.spritePath = self.ccbiRootNode["sprite_path"]
    self.spriteMap = self.ccbiRootNode["sprite_map_bg"]
    self.stageNode = self.ccbiRootNode["node_1"]
    self.prizeNode = self.ccbiRootNode["node2"]

    self.nodeStep1 = self.ccbiRootNode["node_step1"]
    self.nodeStep2 = self.ccbiRootNode["node_step2"]
    self.nodeStep3 = self.ccbiRootNode["node_step3"]
    self.box1 = self.ccbiRootNode["menuBox1"]
    self.box2 = self.ccbiRootNode["menuBox2"]
    self.box3 = self.ccbiRootNode["menuBox3"]
    self.labelStar1 = self.ccbiRootNode["labelStar1"]
    self.labelStar2 = self.ccbiRootNode["labelStar2"]
    self.labelStar3 = self.ccbiRootNode["labelStar3"]

    self.animationNode = self.ccbiRootNode["animationNode"]

    self.stageNameImg = self.ccbiRootNode["itemNameSp"]

    self.box1:getSelectedImage():setVisible(false)
    self.box1:setAllowScale(false)
    self.box2:getSelectedImage():setVisible(false)
    self.box2:setAllowScale(false)
    self.box3:getSelectedImage():setVisible(false)
    self.box3:setAllowScale(false)

    -- local node1 = UI_Guankaweikaibaoxiang() --关卡未开宝箱
    -- local node2 = UI_Guankaweikaibaoxiang()
    -- local node3 = UI_Guankaweikaibaoxiang()
    -- node1:setPosition(35, 35)
    -- node2:setPosition(35, 35)
    -- node3:setPosition(35, 35)
    -- self.box1:addChild(node1)
    -- self.box2:addChild(node2)
    -- self.box3:addChild(node3)

    -- self.spritePath:setVisible(false)
end

--创建星级抽将
-- @param model: 2, 3个宝箱模式
function PVChapterMap:createStarPrize(model)
    --添加星星进度条
    local sprite1 = game.newSprite("#ui_stage_bg_blacktiao.png")
    local sprite2 = game.newSprite("#ui_stage_bg_bluetiao.png")
    local sprite3 = game.newSprite()
    self.slider = cc.ControlSlider:create(sprite1, sprite2, sprite3)
    self.slider:setEnabled(false)
    self.slider:setMinimumValue(0)
    self.slider:setAnchorPoint(cc.p(0,0.5))
    self.sliderNode:addChild(self.slider)
    self.maximumValue = 0
    if model == 2 then
        self.slider:setMaximumValue(14)
        self.maximumValue = 14
    elseif model == 3 then
        self.slider:setMaximumValue(21)
        self.maximumValue = 21
    end

    --------------------
    --将本章节数据载入
    self.slider:setValue(self.getstar)
    --设置宝箱的状态
    local function onBox1callback()
        print("%%%%%%%%%%%%%%%%%%%%", self.getstar)
        if self.getstar >= 7 then
            self.box1:removeChildByTag(103)
            self.box1:stopActionByTag(1)
            self.box1:setEnabled(false)
            -- self.box1:removeAllChildren()
            local node = UI_Guankakaibaoxiang()
            node:setPosition(35, 35)
            -- self.box1:addChild(node)
            self._stageData:setTempBoxIndex(1)
            getNetManager():getInstanceNet():sendStarRaffles(self.chapterIdx, 0)
            -- getNetManager():getInstanceNet():sendGetChapterPrizeMsg(id)
        else
            -- getModule(MODULE_NAME_HOMEPAGE):showUITopShowLastView("PVStarAwardShow", self.chapterIdx, 1)
            getOtherModule():showOtherView("PVStarAwardShow", self.chapterIdx, 1)
            -- stepCallBack(G_GUIDE_40112)    -- 40021 点击星级抽奖
            groupCallBack(GuideGroupKey.BTN_CLICK_BAOXIANG)
            -- self._stageData:setTempBoxIndex(1)
            -- getNetManager():getInstanceNet():sendStarRaffles(self.chapterIdx, 0)
            -- getNetManager():getInstanceNet():sendStarRaffles(self.chapterIdx, 0)

        end
    end

    local function onBox2callback()
        if self.getstar >= 14 then
            self.box2:removeChildByTag(102)
            self.box2:stopActionByTag(2)
            self.box2:setEnabled(false)
            -- self.box1:removeAllChildren()
            local node = UI_Guankakaibaoxiang()
            node:setPosition(35, 35)
            -- self.box2:addChild(node)
            self._stageData:setTempBoxIndex(2)
            getNetManager():getInstanceNet():sendStarRaffles(self.chapterIdx, 1)
        else
            -- self._stageData:setTempBoxIndex(2)
            -- getNetManager():getInstanceNet():sendStarRaffles(self.chapterIdx, 1)
            -- getModule(MODULE_NAME_HOMEPAGE):showUITopShowLastView("PVStarAwardShow", self.chapterIdx, 2)
            getOtherModule():showOtherView("PVStarAwardShow", self.chapterIdx, 2)
        end
    end

    local function onBox3callback()
        if self.getstar == 21 then
            self.box3:removeChildByTag(103)
            self.box3:stopActionByTag(3)
            self.box3:setEnabled(false)
            -- self.box1:removeAllChildren()
            local node = UI_Guankakaibaoxiang()
            node:setPosition(35, 35)
            -- self.box3:addChild(node)
            self._stageData:setTempBoxIndex(3)
            getNetManager():getInstanceNet():sendStarRaffles(self.chapterIdx, 2)
        else
            -- getModule(MODULE_NAME_HOMEPAGE):showUITopShowLastView("PVStarAwardShow", self.chapterIdx, 3)
            getOtherModule():showOtherView("PVStarAwardShow", self.chapterIdx, 3)
        end
    end
    self.box1:registerScriptTapHandler(onBox1callback)
    self.box2:registerScriptTapHandler(onBox2callback)
    self.box3:registerScriptTapHandler(onBox3callback)

    if model == 2 then
        self.box3:setVisible(false)
        self.nodeStep3:setVisible(false)
        local pos3X = self.nodeStep3:getPositionX()
        local pos2X = self.nodeStep2:getPositionX()
        local pos1X = self.nodeStep1:getPositionX()
        self.nodeStep2:setPositionX(pos3X)
        self.box2:setPositionX(pos3X)
        self.nodeStep1:setPositionX(pos2X-30)
        self.box1:setPositionX(pos2X-30)
    end
end

function PVChapterMap:createStage()

    print("--------PVChapterMap:createStage------")
    --将地图中关卡载入
    for k,v in pairs(self.data) do  -- k: index, v: stage id
        local _stageData = self._stageTemp:getTemplateById(v)
        local node = ChapterNode.new()
        if self.isShowStar == false then node:setStarHide() end
        if self._stageData:getStageIsLock(v) == true then
            node:setLocked(true)
            node:setVisible(false)
        else
            local _stageState, _firstOpen = self._stageData:getStageStateAndFirstOpen(v)  --获取下一关的状态-1:开启没打过,是否第一次开启
            if _stageState == -1 and _firstOpen == true then
               node:setLocked(true)
            else
               node:setLocked(false)
            end
            node:setVisible(true)
        end

        -- local vpos = self.stagepos_list[k]  -- position
        local posx = _stageData.coordinate[1]
        local posy = _stageData.coordinate[2]
        local _posx,_posy = node:getPosition()
        node:setPosition(posx-_posx, posy-_posy)

        node:setData(v)
        --关卡标题
        local nameImgStr = string.format("#ui_newHand_00%d.png",self.chapterIdx)
        game.setSpriteFrame(self.stageNameImg,nameImgStr)
        self.stageNode:addChild(node)
    end
end



--@return
return PVChapterMap


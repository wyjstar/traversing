--章节选择界面
-- local PVScrollBar = import("..scrollbar.PVScrollBar")
local ChapterMap = import(".PVChapterMap")
local HuodongView = import(".PVHuodongView")
local PVChapters = class("PVChapters", BaseUIView)

local Tag_Map = 210
local Huodong_Type_Gold = 1
local Huodong_Type_Exp = 2

function PVChapters:ctor(id)
    PVChapters.super.ctor(self, id)
    self:registerNetCallback()

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
    self.c_SoldierTemplate = getTemplateManager():getSoldierTemplate()

    cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA4444)
end

function PVChapters:onExit()
    cclog("-------onExit----")
    -- self:unregisterScriptHandler()
    cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA8888)
    getDataManager():getResourceData():clearResourcePlistTexture()

end


-- 注册网络response回调
function PVChapters:registerNetCallback()
    local function prizeCallback(id, data)
        print("#######################", id, data)
        -- table.print(data)
    end

    local function callBack(id, data)
        print("PVChapters:registerNetCallback=====", data.res.result)
        if data.res.result then
            local mapNode = self.mapNode:getChildByTag(Tag_Map)
            local aaa = self._stageData:getAwardInfo()

            local chapterIdx = self._stageTemp:getIndexofStage(self.mapStageList[1])

            local awardInfo = self._stageData:getAwardInfoByNo(chapterIdx)

            local tempBoxIndex = self._stageData:getTempBoxIndex()
            --local box1open = awardInfo.award[tempBoxIndex]
            awardInfo.award[tempBoxIndex] = 1
            mapNode:updateBoxView()
            getModule(MODULE_NAME_HOMEPAGE):showUITopShowLastView("PVStarAwardResult", data.drops)
        end
    end

    self:registerMsg(INST_CHAPTER_PRIZE_CODE, prizeCallback)  -- 章节奖励
    self:registerMsg(INST_STAR_RAFFLES, callBack)
end


function PVChapters:onMVCEnter()
    self:showAttributeView()
    game.addSpriteFramesWithFile("res/ccb/resource/ui_instance.plist")
    -- game.addSpriteFramesWithFile("res/stage/stage_map.plist")

    self.ccbiNode = {}       -- ccbi加载后返回的node
    self.ccbiRootNode = {}   -- ccb界面上的根节点

    self:initData()
    self:initTouchListener()
    self:loadCCBI("instance/ui_chapters.ccbi", self.ccbiNode)
    self:initView()
    self:createJQList()  -- 创建剧情list
    self:createFBList()  -- 创建副本list
    -- self:createDiffModel()

    self:updateViewData()

    --根据传入的值，跳入对应的章节地图
    if self.goStageId ~= nil and self.pageIdx == 1 then
        self:updateMenu(1)
        self:goChaptersMap()
    elseif self.goStageId ~= nil and self.pageIdx == 2 then
        self:updateMenu(2)
        self:toPageViewIdx()
    elseif self.goStageId == nil and self.pageIdx ~= nil then
        self:updateMenu(self.pageIdx)
    else
        self:updateMenu(1)
    end
    -- 重置当前关卡id
    self._stageData:setCurrStageId(nil)
    -- --- 第一次进入讨伐 第一章节故事介绍
    -- local _stageId = 100101
    -- local _stageState, _firstOpen = self._stageData:getStageStateAndFirstOpen(_stageId)
    -- if _stageState == -1 then
    --     getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInRunningScence("PVChapterIntroduce",_stageId)
    -- end

end
function PVChapters:toPageViewIdx()
    -- print("----------toPageViewIdx-------------")

    local x = 1
    for k,v in pairs(self.fbStageList) do
    -- for k,v in pairs(self.fbStageList) do
        print(k, v.id)

        if v.id == self.goStageId then
            x = k
            break
        end
    end
    -- print("----------", x, self.goStageId)
    self.pageViewCopy:scrollToPage(x-1)--:scrollToPage(x)
end

function PVChapters:initData()
    self.clickIndex2 = 1                                     --第一页
    self.clickIndex1 = 1
    self.playerLevel = self._commonData:getLevel()
    self.fbLevelLimit = self._baseTemp:getFBStageStartLv()
    self.hdLevelLimit = self._baseTemp:getHDStageStartLv()

    self:updataCurrStageList()  -- 更新当前开启关卡章节列表

    self.tvLists = {} -- 存放剧情，副本，活动 三个tableview

    -- 获取跳转关卡id
    self.goStageId = self.funcTable[1]
    self.pageIdx = self.funcTable[2]

    self.fbStageList = self._stageTemp:getFBList()

    -- self._stageTemp:getHDList()
    self.hdStageList = {}
    self.hdStageOtherList = {}
    self.hdStageList, self.hdStageOtherList = self._stageTemp:getHDList()

    self.allFbDropTableViews = {}
    -- self.hdStageList = self._stageTemp.hdStageList
    print("----self.hdStageList-----",self.pageIdx )
    -- self.hdStageOtherList = self._stageTemp.hdStageOtherList
    self.curPage = self.pageIdx
end

-- 通过传值直接跳转到地图界面
function PVChapters:goChaptersMap()
    local chapterIdx, stageIdx = self._stageTemp:getIndexofStage(self.goStageId)
    self.chapterIdx = chapterIdx
    print("self.chapterIdx=====", self.chapterIdx)
    self._stageList = self._stageTemp:getSimpleStageList(chapterIdx)
    self:createMap(self._stageList)

    local simpleStageId = self._stageTemp:getSimpleStage(chapterIdx, stageIdx)
    local _stageData = self._stageTemp:getTemplateById(simpleStageId)
    local posx = _stageData.coordinate[1]
    local posy = _stageData.coordinate[2]
    print("$$$")
    game.addSpriteFramesWithFile("res/ccb/resource/ui_newHandLead.plist")
    local img = game.newSprite("#ui_newHand_hand.png")
    img:setAnchorPoint(cc.p(0,1))
    local mapNode = self.mapNode:getChildByTag(Tag_Map)
    local _posx,_posy = img:getPosition()
    img:setPosition(posx-_posx, posy-_posy)
    mapNode:addChild(img)
end

function PVChapters:onEnterFight()
    local type = nil
    if self.currIndex == 1 then type = "normal"
    elseif self.currIndex == 2 then type = "elite"
    elseif self.currIndex == 3 then type = "activity"
    end
    local _id = self._stageData:getCurrStageId()
    getModule(MODULE_NAME_HOMEPAGE):showUIView("PVEmbattle", _id, type)
end

function PVChapters:initTouchListener()

    local function backMenuClick()
        print("-------关闭讨伐---------")
        getAudioManager():playEffectButton2()
        if self.eliteStageTimes > 0 or self.actStageTimes > 0 then
            touchNotice(INSTANCE_NOTICE, true)
        else
            touchNotice(INSTANCE_NOTICE, false)
        end

        -- groupCallBack(GuideGroupKey.BTN_CHAPTER_CLOSE)

        -- groupCallBack(GuideGroupKey.HOME)

        -- groupCallBack(GuideGroupKey.HOME)
        -- groupCallBack(GuideGroupKey.HOME)   ----添加home
        -- stepCallBack(G_GUIDE_20116)
        -- stepCallBack(G_GUIDE_20119)
        -- stepCallBack(G_GUIDE_40134)
        -- stepCallBack(G_GUIDE_40135)
        -- stepCallBack(G_GUIDE_50100)
        -- stepCallBack(G_GUIDE_50129)
        -- stepCallBack(G_GUIDE_60004)
        -- stepCallBack(G_GUIDE_60107)
        -- stepCallBack(G_GUIDE_60102)
        -- stepCallBack(G_GUIDE_60108)
        -- stepCallBack(G_GUIDE_30124)
        -- stepCallBack(G_GUIDE_30116)
        -- stepCallBack(G_GUIDE_40134)

        -- stepCallBack(G_GUIDE_50100)
        -- stepCallBack(G_GUIDE_20060_2)
        -- stepCallBack(G_GUIDE_50108)

        -- stepCallBack(G_GUIDE_50129)

        -- local currentGID = getNewGManager():getCurrentGid()
        -- if currentGID == G_GUIDE_20093 or currentGID == G_GUIDE_30117 or currentGID == G_GUIDE_80003 then
        --     local homePage = getPlayerScene().homeModuleView.moduleView
        --     homePage:scrollToFPage()
        -- elseif currentGID == G_GUIDE_20123 or currentGID == G_GUIDE_110003 then
        --     local homePage = getPlayerScene().homeModuleView.moduleView
        --     homePage:scrollToSPage()
        --     stepCallBack(G_GUIDE_20123)
        -- end
        self:onHideView()

    end
    local function selectPlotClick()
        print("剧情。。。")
        getAudioManager():playEffectButton2()
        self:updateMenu(1)
        self._stageData:setCurrStageId(nil)
        self.tvLists[2]:setTouchEnabled(false)
        self.tvLists[2]:setPosition(cc.Director:getInstance():getWinSize().width,0)
        self.tvLists[1]:setTouchEnabled(true)
        
        groupCallBack(GuideGroupKey.BTN_JUQING_FUBEN)
    end
    local function selectInstanceClick()
        print("副本。。。")
        local currentGid = getNewGManager():getCurrentGid()
        if currentGid == G_GUIDE_90002 or currentGid == G_GUIDE_90003 then
            self.fbStageList = self._stageTemp:getFBList()
            -- self:createDiffModel()
            -- self:createFBList()
        end
        table.print(self.fbStageList)
        getAudioManager():playEffectButton2()
        self:updateMenu(2) --暂时禁用副本，活动
        self.curPage = 0
        -- self.menuLeft:setVisible(false)
        -- self.menuRight:setVisible(true)
        self._stageData:setCurrStageId(nil)
        self.tvLists[2]:setTouchEnabled(true)
        self.tvLists[1]:setTouchEnabled(false)
        
        self.tvLists[2]:setPosition(-30,0)
        groupCallBack(GuideGroupKey.BTN_JINGYING_FUBEN)
        -- stepCallBack(G_GUIDE_90003)
    end
    local function selectActivityClick()
        print("selectActivityClick------------活动。。。")
        getAudioManager():playEffectButton2()
        self:updateMenu(3)
        local currTime = getDataManager():getCommonData():getTime()
        local weekDay = os.date("%w", currTime) + 1
        print("selectActivityClick weekDay ============ weekDay ============ ", weekDay)
        if weekDay == 1 or weekDay % 2 == 0 then
            self.introduction:setString("周一、周三、周五、周日开放")
            -- self.pageView:scrollToPage(0)
        else
            self.introduction:setString("周二、周四、周六、周日开放")
            -- self.pageView:scrollToPage(1)
        end
        self._stageData:setCurrStageId(nil)
        self.tvLists[2]:setTouchEnabled(false)
        self.tvLists[1]:setTouchEnabled(false)
        self.tvLists[2]:setPosition(cc.Director:getInstance():getWinSize().width,0)
        groupCallBack(GuideGroupKey.BTN_HUODONG_FUBEN)

        --stepCallBack(G_GUIDE_70003)
        -- stepCallBack(G_GUIDE_70004)
        -- stepCallBack(G_GUIDE_50104)
        -- getNewGManager():setCurrentGID(G_GUIDE_70004)
    end
    local function goFightFB()
        print("进入精英关卡。。。", self.fbStageId)
        if self.eliteStageTimes > 0 then
            self._stageData:setCurrStageId(self.fbStageId)
            -- getNetManager():getInstanceNet():sendGetUnparalleledMsg()
            self:onEnterFight()
        else
            -- self:toastShow( Localize.query("instance.1") )
            getOtherModule():showAlertDialog(nil, Localize.query("instance.1"))
        end

        groupCallBack(GuideGroupKey.BTN_JINGYING_FUBEN)
    end
    local function goFightHD()
        print("进入活动关卡。。。", self.hdStageId)
        if self.actStageTimes > 0 then
            self._stageData:setCurrStageId(self.hdStageId)
            -- getNetManager():getInstanceNet():sendGetUnparalleledMsg()
            self:onEnterFight()
        else
            -- self:toastShow( Localize.query("instance.1") )
            getOtherModule():showAlertDialog(nil, Localize.query("instance.1"))
        end
    end

    -- local function onRightMove()
    --     print("向右移动 ============ ", self.curPage)
    --     if self.currIndex == 2 then
    --         self.pageViewCopy:scrollToPage(self.curPage + 1)
    --     elseif self.currIndex == 3 then
    --         self.pageView:scrollToPage(self.curPage + 1)
    --     end
    -- end

    -- local function onLeftMove()
    --     print("向左移动 ============ ", self.curPage)
    --     if self.currIndex == 2 then
    --         self.pageViewCopy:scrollToPage(self.curPage - 1)
    --     elseif self.currIndex == 3 then
    --         self.pageView:scrollToPage(self.curPage - 1)
    --     end
    -- end

    --点击金库试炼
    local function onClickGoldHuodongBtn()
        print("创建金库试炼试图，添加到self.huodongViewNode")
        self:createHuodongView(Huodong_Type_Gold)
    end

    --点击校场试炼
    local function onClickExpHuodongBtn()
        print("创建校场试炼试图，添加到self.huodongViewNode")
        self:createHuodongView(Huodong_Type_Exp)
    end

    self.ccbiNode["UIChapters"] = {}
    self.ccbiNode["UIChapters"]["backMenuClick"] = backMenuClick
    self.ccbiNode["UIChapters"]["onPlotClick"] = selectPlotClick
    self.ccbiNode["UIChapters"]["onInstanceClick"] = selectInstanceClick
    self.ccbiNode["UIChapters"]["onActivityClick"] = selectActivityClick
    self.ccbiNode["UIChapters"]["menuClickFightFB"] = goFightFB
    self.ccbiNode["UIChapters"]["menuClickFightHD"] = goFightHD
    -- self.ccbiNode["UIChapters"]["onLeftMove"] = onLeftMove
    -- self.ccbiNode["UIChapters"]["onRightMove"] = onRightMove
    self.ccbiNode["UIChapters"]["onClickGoldHuodongBtn"] = onClickGoldHuodongBtn
    self.ccbiNode["UIChapters"]["onClickExpHuodongBtn"] = onClickExpHuodongBtn
end

--创建活动页面
function PVChapters:createHuodongView(huodongType)
    print("-----PVChapters:createHuodongView-------")
    
    local huodongView = HuodongView.new()
    huodongView:setChapterInstance(self)
    huodongView:createHuodongView(huodongType)
    -- map:setTag(Tag_Map)
    if self.huodongViewNode ~= nil then
        self.huodongViewNode:addChild(huodongView)
        self.goldHuodongBtn:setEnabled(false)
        self.expHuodongBtn:setEnabled(false)
        for k,v in pairs(self.menu) do
            v:setEnabled(false)
        end
    end
end

function PVChapters:initView()

    self.ccbiRootNode = self.ccbiNode["UIChapters"]
    self.JQNode = self.ccbiRootNode["jq_node"]
    self.FBNode = self.ccbiRootNode["fb_node"]
    self.HDNode = self.ccbiRootNode["hd_node"]
    self.listLayer = self.ccbiRootNode["contentLayer"]
    self.mapNode = self.ccbiRootNode["node_map"]
    self.fbLayer = self.ccbiRootNode["fb_layer"]
    self.fbDropLayer = self.ccbiRootNode["drop_layer"]
    -- self:setShieldLayer(self.jqshieldlayer)

    -- self.fbshieldlayer = self:createShieldLayer()
    -- self.fbshieldlayer:setTouchEnabled(true)
    -- self.FBNode:addChild(self.fbshieldlayer)

    -- self.hdshieldlayer = self:createShieldLayer()
    -- self.hdshieldlayer:setTouchEnabled(true)
    -- self.HDNode:addChild(self.hdshieldlayer)

    -- self.menuFBFight = self.ccbiRootNode["menu_gofight"]
    -- self.menuFBFight:setEnabled(false)
    -- self.labelFBLeftNum = self.ccbiRootNode["label_fb_number"]  -- 剩余次数
    -- self.imgArrowLeft = self.ccbiRootNode["arrow_left"]
    -- self.imgArrowRight = self.ccbiRootNode["arrow_right"]
    -- self.imgArrowLeft:setVisible(false)
    -- self.imgArrowRight:setVisible(false)
    self.hdListLayer = self.ccbiRootNode["hd_layer"]
    self.hdDropLayer = self.ccbiRootNode["hd_drop_layer"]
    self.menuHDFight = self.ccbiRootNode["hd_menu_gofight"]
    self.menuHDFight:setEnabled(false)
    self.labelHDLeftNum = self.ccbiRootNode["label_hd_number"]  -- 剩余次数
    self.hdImgArrowLeft = self.ccbiRootNode["hd_arrow_left"]
    self.hdImgArrowRight = self.ccbiRootNode["hd_arrow_right"]
    self.hdImgArrowLeft:setVisible(false)
    self.hdImgArrowRight:setVisible(false)

    --活动viewnode
    self.huodongViewNode = self.ccbiRootNode["huodongViewNode"]

    --2种活动的按钮
    self.goldHuodongBtn = self.ccbiRootNode["goldHuodongBtn"]
    self.expHuodongBtn = self.ccbiRootNode["expHuodongBtn"]
    local currTime = getDataManager():getCommonData():getTime()
    local weekDay = os.date("%w", currTime) + 1
    if weekDay == 1 or weekDay % 2 == 0 then
        --周一、周三、周五、周日开放
        self.goldHuodongBtn:setEnabled(true)
        self.expHuodongBtn:setEnabled(false)
    else
        --周二、周四、周六、周日开放
        self.goldHuodongBtn:setEnabled(false)
        self.expHuodongBtn:setEnabled(true)
    end

    --分页按钮
    self.menu = {}
    table.insert(self.menu, self.ccbiRootNode["plotMenu"])
    table.insert(self.menu, self.ccbiRootNode["copyMenu"])
    table.insert(self.menu, self.ccbiRootNode["activityMenu"])
    for i,v in ipairs(self.menu) do
        -- v:getSelectedImage():setVisible(false)
        v:setAllowScale(false)
    end
    --分页按钮上的文字
    self.menuTextSelect = {}
    table.insert(self.menuTextSelect, self.ccbiRootNode["plotSelect"])
    table.insert(self.menuTextSelect, self.ccbiRootNode["instanceSelect"])
    table.insert(self.menuTextSelect, self.ccbiRootNode["activitySelect"])
    self.menuTextNor = {}
    table.insert(self.menuTextNor, self.ccbiRootNode["plotNor"])
    table.insert(self.menuTextNor, self.ccbiRootNode["instanceNor"])
    table.insert(self.menuTextNor, self.ccbiRootNode["activityNor"])

    --获取大小尺寸
    local tempTab = {}
    local proxy = cc.CCBProxy:create()
    CCBReaderLoad("instance/ui_chapters_item.ccbi", proxy, tempTab)
    local node = tempTab["UIChaptersItem"]["itemBg"]
    self.itemSize = node:getContentSize()

    -- self.touchLayer = self.ccbiRootNode["touchLayer"]

    --向左向右按钮
    -- self.moveMenu = self.ccbiRootNode["moveMenu"]
    -- self.menuLeft = self.ccbiRootNode["menuLeft"]
    -- self.menuRight = self.ccbiRootNode["menuRight"]

    --活动关卡开启说明
    self.introduction = self.ccbiRootNode["introduction"]

    --剧情副本红点
    self.instance_jq_notice = self.ccbiRootNode["instance_jq_notice"]
    --精英副本红点
    self.instance_fb_notice = self.ccbiRootNode["instance_fb_notice"]
    --活动红点
    self.instance_hd_notice = self.ccbiRootNode["instance_hd_notice"]


end

--切换菜单的高亮
function PVChapters:updateMenu(idx)
    print("切换标签 ============== ", idx)

    local lv = self._commonData:getLevel()

    -- 判断等级，看是否开启了活动关卡
    if idx == 3 then
        local _stageId = getTemplateManager():getBaseTemplate():getActivityStageOpenStage()
        local _isOpen = getDataManager():getStageData():getIsOpenByStageId(_stageId)
        -- local starLv = self._baseTemp:getHDStageStartLv()
        if not _isOpen then  --lv < self.hdLevelLimit
            -- local str = Localize.query("instance.11")
            -- str = string.format(str, starLv)
            -- getOtherModule():showAlertDialog(nil, str)

            -- self:removeChildByTag(1000)
            -- self:addChild(getLevelTips(self.hdLevelLimit), 0, 1000)
            getStageTips(_stageId)
            return
        end
    end

    if idx == 2 then
        local _stageId = getTemplateManager():getBaseTemplate():getSpecialStageOpenStage()
        local _isOpen = getDataManager():getStageData():getIsOpenByStageId(_stageId)
        --TODO: 调试用，临时注销
        if not _isOpen then
            getStageTips(_stageId)
            return
        end
    end

    -- 控制菜单的高亮
    for i,v in ipairs(self.menu) do
        if idx == i then v:setEnabled(false)
        else v:setEnabled(true)
        end
    end
    for i,v in ipairs(self.menuTextNor) do
        if idx == i then v:setVisible(false)
        else v:setVisible(true)
        end
    end
    for i,v in ipairs(self.menuTextSelect) do
        if idx == i then v:setVisible(true)
        else v:setVisible(false)
        end
    end
    --切换tableView控件
    for i,v in ipairs(self.tvLists) do
        if i == idx then
            v:setVisible(true)
            v:setTouchEnabled(true)
            if v.reloadData then
                v:reloadData()
                local curPos = v:getContentOffset()
                local max = v:maxContainerOffset()
                -- v:setContentOffset(cc.p(curPos.x, max.y))
                self:tableViewItemAction(v)
            end
        else
            v:setVisible(false)
            v:setTouchEnabled(false)
        end
    end
    self.currIndex = idx

    -- 切换界面
    if idx == 1 then
        self.JQNode:setVisible(true)
        self.FBNode:setVisible(false)
        self.HDNode:setVisible(false)
        -- if self.allFbDropTableViews ~= nil then
        --     for k,v in pairs(self.allFbDropTableViews) do
        --         if v ~= nil then
        --             v:setTouchEnabled(false)
        --         end
        --     end
        -- end
        -- self.moveMenu:setVisible(false)
    elseif idx == 2 then
        self.JQNode:setVisible(false)
        self.FBNode:setVisible(true)
        self.HDNode:setVisible(false)
        -- if self.allFbDropTableViews ~= nil then
        --     for k,v in pairs(self.allFbDropTableViews) do
        --         if v ~= nil then
        --             v:setTouchEnabled(true)
        --         end
        --     end
        -- end
        if self.hdDropTableView ~= nil then
            self.hdDropTableView:setTouchEnabled(false)
        end
        -- self.moveMenu:setVisible(true)
    elseif idx == 3 then
        self.JQNode:setVisible(false)
        self.FBNode:setVisible(false)
        self.HDNode:setVisible(true)
        -- if self.allFbDropTableViews ~= nil then
        --     for k,v in pairs(self.allFbDropTableViews) do
        --         if v ~= nil then
        --             v:setTouchEnabled(false)
        --         end
        --     end
        -- end
        if self.hdDropTableView ~= nil then
            self.hdDropTableView:setTouchEnabled(true)
        end
        -- self.moveMenu:setVisible(true)
    end
end

function PVChapters:setShieldLayer(layer)
    
    local function onTouchEvent(eventType, x, y)
        if eventType == "began" then
            return true
        end
    end

    layer:registerScriptTouchHandler(onTouchEvent)
    layer:setTouchMode(cc.TOUCHES_ONE_BY_ONE)
    layer:setTouchEnabled(true)
end

--创建剧情关卡列表
function PVChapters:createJQList()
    local function tableCellTouched(tbl, cell)  --点击跳入对应的关卡地图界面
        print("PVChapters cell touched at index: " .. cell:getIdx())

        if cell._isLock == false then
            getAudioManager():playEffectButton2()
            local _data = self.currStageList[cell:getIdx()+1]
            -- local _stageList = self._stageTemp:getSimpleStageList(cell:getIdx()+1)
            self._stageList = self._stageTemp:getSimpleStageList(_data.chapter)
            self:createMap(self._stageList)

            groupCallBack(GuideGroupKey.BTN_CHAPTER)

            -- stepCallBack(G_GUIDE_00101)
            -- stepCallBack(G_SELECT_FIRST_COPY)
            -- --stepCallBack(G_GUIDE_20052)
            -- stepCallBack(G_GUIDE_20073)

            -- stepCallBack(G_GUIDE_30100)         -- 30003 点击章节
            -- stepCallBack(G_GUIDE_30113)
            -- stepCallBack(G_GUIDE_30121)
            -- stepCallBack(G_GUIDE_40111)
            -- stepCallBack(G_GUIDE_40123)

            -- stepCallBack(G_SECTION_4_START)     -- 40001 第三章描述

        end
    end
    local function numberOfCellsInTableView(tab)
       return table.nums(self.currStageList)
    end
    local function cellSizeForTable(tbl, idx)
        return 150, 640
    end
    local function tableCellAtIndex(tbl, idx)

        local cell = tbl:dequeueCell()
        if nil == cell then
            cell = cc.TableViewCell:new()

            local function onHeadIconClick()  --不知道要不要。。。头像的点击事件
                print("详情")
            end
            local cardinfo = {}
            cardinfo["UIChaptersItem"] = {}
            cardinfo["UIChaptersItem"]["onItemClick"] = onHeadIconClick
            local proxy = cc.CCBProxy:create()
            local node = CCBReaderLoad("instance/ui_chapters_item.ccbi", proxy, cardinfo)
            cell._isLock = self._stageData:getChapterIsLock(idx+1)
            cell:addChild(node)
            --获取Item的控件
            cell.iconMenu = cardinfo["UIChaptersItem"]["itemMenuItem"]     --头像的menu
            cell.iconMenu:setAllowScale(false)  -- 暂时去掉了点击事件
            cell.iconMenu:setEnabled(false)
            cell.stageLabel = cardinfo["UIChaptersItem"]["itemName"]       --关卡名
            cell.stageNameImg = cardinfo["UIChaptersItem"]["itemNameSp"]   --关卡名图片
            cell.stageBgImg = cardinfo["UIChaptersItem"]["itemBg"]         --关卡小背景
            cell.detailLabel = cardinfo["UIChaptersItem"]["detailLabel"]   --简单介绍
            cell.stateImg = cardinfo["UIChaptersItem"]["stateSprite"]      --是否通关的状态图片
            cell.perfectImg = cardinfo["UIChaptersItem"]["perfect_img"]    --完美
            cell.starLabel = cardinfo["UIChaptersItem"]["star_num"]        --显示星级
            cell.maskLayerColor = cardinfo["UIChaptersItem"]["lock_layercolor"]  --用于遮罩的layer
            cell.imgUnlock = cardinfo["UIChaptersItem"]["img_unlocked"]
            cell.imgLocked = cardinfo["UIChaptersItem"]["img_locked"]
            cell.starImg = cardinfo["UIChaptersItem"]["star_img"]          --星星图标
            cell.boxImg = cardinfo["UIChaptersItem"]["goldSp"]             --宝箱图标

        end

        print("----idx----")
        print(idx)

        if cell~=nil and idx ~= nil then
            --设置属性
            -- local _data = self.stageList[idx+1]
            local _data = self.currStageList[idx+1]
            local _name = self._languageTemp:getLanguageById(_data.name)
            local _info = self._languageTemp:getLanguageById(_data.info)
            _info = string.gsub( tostring(_info) ,"\\n","\n")
            local _chapterNo =  _data.chapter --self._stageTemp:getIndexofStage(_data.id)

            local _endStageId = nil
            if _chapterNo == 1 then _endStageId = self._stageTemp:getSimpleStage(1,3)
            else _endStageId = self._stageTemp:getSimpleStage(_chapterNo,7)
            end

            -- local _icon = self._resourceTemp:getResourceById(self._stageTemp:getTemplateById(_endStageId).iconHero)

            -- cell._isClear = self._stageData:getChapterIsClear(idx+1)
            cell._isClear = self._stageData:getChapterIsClear(_chapterNo)
            -- 寻找本章最后一一个关的头像
            -- local _currStar, _totalStar = self._stageData:getStarNum(idx+1)
            local _currStar, _totalStar = self._stageData:getStarNum(_chapterNo)
            local _strStarNum = string.format("%d/%d", _currStar, _totalStar)
            local _isPerfect = nil
            if _currStar == _totalStar then _isPerfect = true end
            cell.starLabel:setString(_strStarNum)

            cell.stageLabel:setString(_name)
            cell.detailLabel:setString(_info)
            local nameImgStr = string.format("#ui_newHand_00%d.png",_chapterNo)
            game.setSpriteFrame(cell.stageNameImg,nameImgStr)

            --9张背景图循环用
            local bgImgStr = nil
            bgImgStr = string.format("#ui_instanceBg_0%d.png",_chapterNo%9 + 1)
            game.setSpriteFrame(cell.stageBgImg,bgImgStr)

            --有可领取的奖励显示宝箱，否则隐藏
            local stageAward = self._stageData:getAwardInfoByNo(_chapterNo)
        
            table.print(stageAward)
            if stageAward then
    
                if _currStar < 7 then 
                    cell.boxImg:setVisible(false)
                elseif _currStar < 14 then
                    if stageAward.award[1] == 1 then cell.boxImg:setVisible(false)
                    else
                        cell.boxImg:setVisible(true)
                    end
                    
                elseif _currStar < 21 then
                    if stageAward.award[2] == 1 and stageAward.award[1] == 1 then cell.boxImg:setVisible(false)
                    else
                        cell.boxImg:setVisible(true)
                    end
                    
                else
                    if stageAward.award[3] == 1 and stageAward.award[2] == 1 and stageAward.award[1] == 1 then cell.boxImg:setVisible(false)
                    else
                        cell.boxImg:setVisible(true)
                    end
                    
                end

            else
                cell.boxImg:setVisible(false)
            end

            -- local _img = game.newSprite(_icon)
            -- cell.iconMenu:setNormalImage(_img)
            if cell._isClear == false then
                cell.stateImg:setVisible(false)
                cell.perfectImg:setVisible(false)
            else
                if _isPerfect == true then
                    cell.stateImg:setVisible(false)
                    cell.perfectImg:setVisible(true)
                    --完美后隐藏星星和星星数量
                    cell.starImg:setVisible(false)
                    cell.starLabel:setVisible(false)
                else
                    cell.stateImg:setVisible(true)
                    cell.perfectImg:setVisible(false)
                    cell.starImg:setVisible(true)
                    cell.starLabel:setVisible(true)
                end
            end
        end
        -- cell._isLock = self._stageData:getChapterIsLock(idx+1)
        local _data = self.currStageList[idx+1]
        cell._isLock = self._stageData:getChapterIsLock(_data.chapter)
        if cell._isLock == true then
            cell.maskLayerColor:setVisible(true)
            cell.imgLocked:setVisible(true)
            cell.imgUnlock:setVisible(false)
        else
            cell.maskLayerColor:setVisible(false)
            cell.imgLocked:setVisible(false)
            cell.imgUnlock:setVisible(false)
        end
        return cell
    end

    local layerSize = self.listLayer:getContentSize()

    self.JQList = cc.TableView:create(layerSize)    -- 剧情列表
    self.JQList:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.JQList:setDelegate()
    self.JQList:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.listLayer:addChild(self.JQList)

    self.JQList:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
    self.JQList:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.JQList:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.JQList:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)

    local scrBar = PVScrollBar:new()
    scrBar:init(self.JQList,1)
    scrBar:setPosition(cc.p(layerSize.width,layerSize.height/2))
    self.listLayer:addChild(scrBar,2)

    self.tvLists[1] = self.JQList

end

--创建副本关卡列表
function PVChapters:createFBList()

    local function tableCellTouched(tbl, cell)  --点击跳入对应的关卡地图界面
        print("PVChapters cell touched at index: " .. cell:getIdx(), self.curCellIdx)

        if self.curCellIdx then
            local theCell = self.FBList:cellAtIndex(self.curCellIdx)
            -- if theCell then theCell.imgLight:setVisible(false) end
        end
        -- self.FBList:cellAtIndex(cell:getIdx()).imgLight:setVisible(true)

        self.curCellIdx = cell:getIdx()
        self.fbStageId = cell.stageId
        -- self:createFBDropList(self.fbStageId)

        if cell.isOpen then 
            print("进入精英关卡。。。", self.fbStageId)
            if self.eliteStageTimes > 0 then
                self._stageData:setCurrStageId(self.fbStageId)
                self:onEnterFight()
            else
            getOtherModule():showAlertDialog(nil, Localize.query("instance.1"))
            end
        end
    end
    local function numberOfCellsInTableView(tab)
       return table.nums(self.fbStageList)
    end
    local function cellSizeForTable(tbl, idx)
        return 220, 640
    end
    local function tableCellAtIndex(tbl, idx)

        local cell = tbl:dequeueCell()
        if nil == cell then
            cell = cc.TableViewCell:new()

            local tempTab = {}
            local proxy = cc.CCBProxy:create()
            local node = CCBReaderLoad("instance/ui_chapters_insitem.ccbi", proxy, tempTab)
            cell:addChild(node)
            cell.clipperLayer = tempTab["UIFBStageItem"]["clipperLayer"]
            cell.wujiangBgNode = tempTab["UIFBStageItem"]["wujiangBgNode"]
            cell.wujiangBgImg = tempTab["UIFBStageItem"]["wujiangBgImg"]
            cell.stageNameImg = tempTab["UIFBStageItem"]["stageNameImg"]
            cell.imgBg = tempTab["UIFBStageItem"]["itemBg"]
            cell.labelName = tempTab["UIFBStageItem"]["instanceName"]
            -- cell.imgLight = tempTab["UIFBStageItem"]["img_light"]
            cell.maskLayer = tempTab["UIFBStageItem"]["mask_layer"]
            cell.dropListLayer = tempTab["UIFBStageItem"]["dropListLayer"]
        end

        local _item = self.fbStageList[idx+1]
        local nameImgRes = self._resourceTemp:getResourceById(_item.resIcon)
        local name = self._languageTemp:getLanguageById(_item.name)
        print("name =============== ", name," nameImgRes =",nameImgRes ,"wujiangImgRes =",wujiangImgRes,"heroId =",_item.resHero)
        cell.stageId = _item.id
        
        --设置关卡名字和关卡人物图
        game.setSpriteFrame(cell.stageNameImg,"#"..nameImgRes)
        local stageBgName = string.format("#ui_instanceBg_00%d.png",idx+1)
        print(stageBgName)
        game.setSpriteFrame(cell.wujiangBgImg,stageBgName)

        
        if self._stageData:getFBStageIsOpen(_item.id) then
            cell.maskLayer:setVisible(false)
            cell.isOpen = true
        else
            cell.maskLayer:setVisible(true)
            cell.isOpen = false
            cell.labelName:setString(self._languageTemp:getLanguageById(self.fbStageList[idx].name))
        end
        if self.curCellIdx == idx then
            -- cell.imgLight:setVisible(true)
        else
            -- cell.imgLight:setVisible(false)
        end

        self:createFBDropList(cell.stageId,cell.dropListLayer)

        return cell
    end

    local layerSize = self.fbLayer:getContentSize()

    self.FBList = cc.TableView:create(layerSize)
    self.FBList:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.FBList:setDelegate()
    self.FBList:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.fbLayer:addChild(self.FBList)

    self.FBList:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
    self.FBList:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.FBList:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.FBList:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)

    local scrBar = PVScrollBar:new()
    scrBar:init(self.FBList,1)
    scrBar:setPosition(cc.p(layerSize.width,layerSize.height/2))
    self.fbLayer:addChild(scrBar,2)

    self.tvLists[2] = self.FBList
end


--创建活动关卡列表
function PVChapters:createHDList()

    local function tableCellTouched(tbl, cell)  --点击跳入对应的关卡地图界面
        print("PVChapters cell touched at index: " .. cell:getIdx(), self.curHDCellIdx)

        if self.curHDCellIdx then
            local theCell = self.HDList:cellAtIndex(self.curHDCellIdx)
            if theCell then theCell.imgLight:setOpacity(120) end
        end
        self.HDList:cellAtIndex(cell:getIdx()).imgLight:setOpacity(255)

        self.curHDCellIdx = cell:getIdx()
        self.hdStageId = cell.stageId
        self:createHDDropList(self.hdStageId)

        if self.curHDCellIdx then self.menuHDFight:setEnabled(true) end
    end
    local function numberOfCellsInTableView(tab)
        return table.nums(self.hdStageList)
    end
    local function cellSizeForTable(tbl, idx)
        return 120, 543
    end
    local function tableCellAtIndex(tbl, idx)

        local cell = tbl:dequeueCell()
        if nil == cell then
            cell = cc.TableViewCell:new()

            local tempTab = {}
            local proxy = cc.CCBProxy:create()
            local node = CCBReaderLoad("instance/ui_chapters_actitem.ccbi", proxy, tempTab)
            cell:addChild(node)

            cell.imgBg = tempTab["UIHDStageItem"]["img_bg"]
            cell.labelName = tempTab["UIHDStageItem"]["itemName"]
            cell.imgLight = tempTab["UIHDStageItem"]["img_light"]
            cell.maskLayer = tempTab["UIHDStageItem"]["mask_layer"]
            cell.maskLayer:setVisible(false)
        end

        local _item = self.hdStageList[idx+1]
        local res = self._resourceTemp:getResourceById(_item.resIcon)
        local name = self._languageTemp:getLanguageById(_item.name)
        cell.stageId = _item.id
        cell.imgBg:setTexture("res/stage/"..res)
        cell.imgLight:setTexture("res/stage/"..string.gsub(res, "bg", "frame"))
        cell.imgLight:setOpacity(120)
        cell.labelName:setString(name)
        if self.curHDCellIdx == idx then
            cell.imgLight:setOpacity(225)
        else
            cell.imgLight:setOpacity(120)
        end

        return cell
    end

    local layerSize = self.hdListLayer:getContentSize()

    self.HDList = cc.TableView:create(layerSize)
    self.HDList:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.HDList:setDelegate()
    self.HDList:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.hdListLayer:addChild(self.HDList)

    self.HDList:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
    self.HDList:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.HDList:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.HDList:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)

    local scrBar = PVScrollBar:new()
    scrBar:init(self.HDList,1)
    scrBar:setPosition(cc.p(layerSize.width,layerSize.height/2))
    self.hdListLayer:addChild(scrBar,2)

    self.tvLists[3] = self.HDList
end

--创建地图
function PVChapters:createMap(stageList)
    print("-----PVChapters:createMap-------")
    self:showChaptersList(false)

    local map = ChapterMap.new()
    -- print("TTTTTTTTTTTTTTTTTTTTTTT")
    -- table.print(stageList)
    -- print("TTTTTTTTTTTTTTTTTTTTTTT")
    self.mapStageList = stageList
    map:setData(stageList)
    map:createStage()
    map:setChapterInstance(self)
    map:setTag(Tag_Map)
    if self.mapNode ~= nil then
        self.mapNode:addChild(map)
        for k,v in pairs(self.menu) do
            v:setEnabled(false)
        end
    end
end

function PVChapters:showChaptersList(isShow)
    print("------------showChaptersList---------",isShow)
    self.listLayer:setVisible(isShow)
    for i,v in ipairs(self.tvLists) do
        if i == self.currIndex then
            v:setVisible(isShow)
            v:setTouchEnabled(isShow)
        end
    end
end

-- 为精英关卡创建掉落物品list
function PVChapters:createFBDropList(stageId,dropLayer)

    -- 查stage_config的boss掉落, 小怪掉落
    local _bossDropId = self._stageTemp:getSpecialStageById(stageId).eliteDrop
    local _monsterDropId = self._stageTemp:getSpecialStageById(stageId).commonDrop
    local _smallDropId = self._dropTemp:getBigBagById(_bossDropId).smallPacketId[1]
    print("_smallDropId", _smallDropId)
    local _itemList = self._dropTemp:getAllItemsByDropId(_smallDropId)
    local _smallDropId2 = self._dropTemp:getBigBagById(_monsterDropId).smallPacketId[1]
    print("_smallDropId2", _smallDropId2)
    local _itemList2 = self._dropTemp:getAllItemsByDropId(_smallDropId2)
    for k,v in pairs(_itemList2) do
        table.insert(_itemList, v)
    end

    -- print("++副本droplist++++++++++++++++++++")
    -- table.print(_itemList)
    -- print("++droplist++++++++++++++++++++")

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
            print("nowPatchNum ======== nowPatchNum ========== ", nowPatchNum)
            getOtherModule():showOtherView("PVCommonChipDetail", 2, v.detailId, nowPatchNum)
        elseif v.type == 105 then  -- 道具
            getOtherModule():showOtherView("PVCommonDetail", 1, v.detailId, 1)
        end
        self.tvLists[2]:setTouchEnabled(false)
        self.tvLists[2]:setTouchEnabled(true)
    end
    local function numberOfCellsInTableView(tab)
       return table.nums(_itemList)
    end
    local function cellSizeForTable(tbl, idx)
        return 110,70
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
        sprite:setScale(0.5)
        sprite:setPosition(55, 40)

        -- if self._flag_showArrow == true then
        --     if self.fbDropTableView:getContentOffset().x >= self.fbDropTableView:maxContainerOffset().x then
        --         -- self.imgArrowLeft:setVisible(false)
        --         -- self.imgArrowRight:setVisible(true)
        --     elseif self.fbDropTableView:getContentOffset().x <= self.fbDropTableView:minContainerOffset().x then
        --         self.imgArrowLeft:setVisible(true)
        --         self.imgArrowRight:setVisible(false)
        --     end
        -- en

        return cell
    end

    local layerSize = dropLayer:getContentSize()
    dropLayer:removeAllChildren()


    local fbDropTableView = cc.TableView:create(layerSize)    -- 剧情列表
    fbDropTableView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    fbDropTableView:setDelegate()
    dropLayer:addChild(fbDropTableView)

    fbDropTableView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
    fbDropTableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    fbDropTableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    fbDropTableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    fbDropTableView:reloadData()
    table.insert(self.allFbDropTableViews,fbDropTableView)
    -- if table.nums(_itemList) >= 4 then
    --     self._flag_showArrow = true
    --     self.imgArrowLeft:setVisible(false)
    --     self.imgArrowRight:setVisible(true)
    -- else
    --     self._flag_showArrow = false
    --     self.imgArrowLeft:setVisible(false)
    --     self.imgArrowRight:setVisible(false)
    -- end
end

-- 为活动关卡创建掉落物品list
function PVChapters:createHDDropList(stageId)
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
        return 110,110
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
                setChipWithFrame(sprite,"res/icon/hero/".._icon, _quality)
            elseif v.type == 104 then -- equipment chips
                _temp = self._chipTemp:getTemplateById(v.detailId).resId
                local _icon = self._resourceTemp:getResourceById(_temp)
                local _quality = self._chipTemp:getTemplateById(v.detailId).quality
                setChipWithFrame(sprite,"res/icon/equipment/".._icon, _quality)
            elseif v.type == 105 then  -- item
                _temp = getTemplateManager():getBagTemplate():getItemResIcon(v.detailId)
                local quality = getTemplateManager():getBagTemplate():getItemQualityById(v.detailId)
                setCardWithFrame(sprite,"res/icon/item/".._temp,quality)
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

function PVChapters:updateViewData()
    print("updateViewData")
    local curFbTimes = self._stageData:getEliteStageTimes()
    local curHdTimes = self._stageData:getActStageTimes()
    local vip = getDataManager():getCommonData():getVip()
    local fbMaxTimes = getTemplateManager():getBaseTemplate():getNumEliteTimes(vip)
    local hdMaxTimes = getTemplateManager():getBaseTemplate():getNumActTimes(vip)
    print("fbMaxTimes====", fbMaxTimes)
    print("curFbTimes====", curFbTimes)
    self.eliteStageTimes = fbMaxTimes - curFbTimes
    self.actStageTimes = hdMaxTimes - curHdTimes

    -- self.labelFBLeftNum:setString(tostring(self.eliteStageTimes))
    self.labelHDLeftNum:setString(tostring(self.actStageTimes))

    --剧情红点
    --if  self._stageData:getChapterIsClear() then
    --    self.instance_jq_notice:setVisible(false)
    --else
    --    self.instance_jq_notice:setVisible(true)
    --end

    --副本红点
    local _stageId = getTemplateManager():getBaseTemplate():getActivityStageOpenStage()
    local _isOpen = getDataManager():getStageData():getIsOpenByStageId(_stageId)
    if _isOpen and self.eliteStageTimes > 0 then
        self.instance_fb_notice:setVisible(true)
    else
        self.instance_fb_notice:setVisible(false)
    end

    --活动副本红点
    _stageId = getTemplateManager():getBaseTemplate():getSpecialStageOpenStage()
    _isOpen = getDataManager():getStageData():getIsOpenByStageId(_stageId)
    if _isOpen and self.actStageTimes > 0 then
        self.instance_hd_notice:setVisible(true)
    else
        self.instance_hd_notice:setVisible(false)
    end

    -- if self.currIndex == 2 then
    --     -- self:createDiffModel()
    --     self:createFBList()
    -- end

end

--更新当前开启关卡章节列表
function PVChapters:updataCurrStageList()
    -- 获取章节列表
    self.stageList = self._stageTemp:getChapterList()
    self.currStageList = {}
    for k,v in pairs(self.stageList) do
        if  self._stageData:getChapterIsLock(k) ~= true then
            print(self._stageData:getChapterIsLock(k))
            table.insert(self.currStageList,v)
        end
    end
    print("-----------章节排序------------")
    -- table.print(self.currStageList)
    local function comp(a,b)
        if tonumber(a.chapter) > tonumber(b.chapter) then return true end
    end
    table.sort(self.currStageList,comp)
end

function PVChapters:onReloadView()
    local data = self.funcTable[1]
    print("************", data)

    if data == 1 or data == 10 then -- 为1不更新
        return
    end

    if self.currIndex == 1 then
        -- 更新地图
        local _currentStageId = self._stageData:getCurrStageId()
        if _currentStageId ~= nil then
            self:updataCurrStageList()
            self.JQList:reloadData()
            self:updateMenu(self.currIndex)
            print("--self.currIndex--",self.currIndex)
            local _no,_id = self._stageTemp:getIndexofStage(_currentStageId)
            local _simpleStageId = self._stageTemp:getSimpleStage(_no, _id)
            if _simpleStageId ~= _currentStageId then    
                self.mapNode:removeAllChildren()
                self:createMap(self._stageList)
                return 
            end

            self._stageList = self._stageTemp:getSimpleStageList(_no)
            local _stageId = self._stageTemp:getSimpleStage(_no, #self._stageList)
            local _state = self._stageData:getStageState(_stageId)
            if _state == 1 then
                local _chapterList = self._stageTemp:getChapterList()
                local nextStageId = self._stageTemp:getNextStage(_stageId)

                if nextStageId ~= -1 then
                    local _nextStageState, _firstOpen = self._stageData:getStageStateAndFirstOpen(nextStageId)
                    print("_nextStageState ",_nextStageState)
                    print("_firstOpen ",_firstOpen)

                    if _firstOpen and _nextStageState == -1  then
                        -- 回到章节列表
                        self._stageData:setStageNoFirstOpen(nextStageId)

                        local item = self._stageTemp:getTemplateById(_currentStageId)
                        if item.open[1] == nil then
                            self:showChaptersList(true)
                            self.mapNode:removeChildByTag(Tag_Map)
                            cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA8888)
                            getModule(MODULE_NAME_HOMEPAGE):showUIViewLastShow("PVChapterIntroduce",nextStageId)
                        else
                            print("------通关关卡开启新功能-------",_currentStageId)
                            getStagePassOpen():startShowViewByStageId(_currentStageId,true)
                        end
                        g_firstOpen = true
                        return
                    elseif _firstOpen == false and _nextStageState == -1 then
                        local nextStageId = self._stageTemp:getNextStage(_currentStageId)        --获取下一关id
                        if nextStageId ~= -1 then
                            local _nextStageState, _firstOpen = self._stageData:getStageStateAndFirstOpen(nextStageId)
                            if _nextStageState == -1  and g_firstOpen then
                                print("--------刷新到章节列表---------")
                                self:showChaptersList(true)
                                self.mapNode:removeChildByTag(Tag_Map)
                                g_firstOpen = false
                            else
                                stepCallBack(GuideId.G_GUIDE_20044)
                            end
                        end
                        return
                    end
                end
            end
            --判断是否显示章节介绍，如果不显示则检查是否能触发掉落包，以防后续操作物品不足

            -- print("============检查掉落包引导====================")
            -- stepCallBack(GuideId.G_GUIDE_20044)
            -- stepCallBack(GuideId.G_GUIDE_60003)
            -- print("============检查掉落包引导====================")
            print("---------self._stageList--------")
            table.print(self._stageList)
            self.mapNode:removeAllChildren()
            self:createMap(self._stageList)
        end
    elseif self.currIndex == 2 then
        -- self:createDiffModel()
        -- self:createFBList()
    end
    if not g_stagePassOpenTag then
        self:updateViewData()
        g_stagePassOpenTag = false
    end
end

function PVChapters:clearResource()
    cclog("-----PVChapters-clearResource-------")

    -- game.removeSpriteFramesWithFile("res/ccb/resource/stage_map.plist")
end


--@return
return PVChapters



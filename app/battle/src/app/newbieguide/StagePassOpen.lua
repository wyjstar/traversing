
local StagePassOpen = class("StagePassOpen") -- BaseUIView

function StagePassOpen:ctor(controller)
    game.addSpriteFramesWithFile("res/ccb/resource/ui_navi.plist")
    self.languageTemplate = getTemplateManager():getLanguageTemplate()
    self.soldierTemplate = getTemplateManager():getSoldierTemplate()
    self.resourceData = getDataManager():getResourceData()
    self.resourceTemplate = getTemplateManager():getResourceTemplate()
    self._stageTemp = getTemplateManager():getInstanceTemplate()
    self.isShow_ = false
end

function StagePassOpen:isShow()
    return self.isShow_
end

function StagePassOpen:startShowView(stageNo) -- 显示本章节要开启的功能

    if stageNo == nil then return end
    local _stageList = self._stageTemp:getSimpleStageList(stageNo)
    self.open = nil
    self.open = {}
    for k,v in pairs(_stageList) do
        local item = self._stageTemp:getTemplateById(v)
        if item.open[1] ~= nil then
            for _k,_v in pairs(item.open) do
                local _openData = {}
                local _chapterNo, _stageNo = self._stageTemp:getIndexofStage(v)
                _openData.chapterNo = _chapterNo
                _openData.stageNo = _stageNo
                _openData.openId = _v
                table.insert(self.open,_openData)
            end
        end  
    end
    local _stageList = self._stageTemp:getNormalStageList(stageNo)
    for k,v in pairs(_stageList) do
        local item = self._stageTemp:getTemplateById(v)
        if item.open[1] ~= nil then
            for _k,_v in pairs(item.open) do
                local _openData = {}
                local _chapterNo, _stageNo = self._stageTemp:getIndexofStage(v)
                _openData.chapterNo = _chapterNo
                _openData.stageNo = _stageNo
                _openData.openId = _v
                table.insert(self.open,_openData)
            end
        end  
    end
    local _data = self.open[1]
    if _data == nil then 
        return
    end 
    self.comeFromStageNo = true
    self:checkGuideNode()
    self:initView()
    self:initStageGuideLayerTouch()
    self:startStageGuide()
    

    -- self.isShow_ = true

end

function StagePassOpen:startShowViewByStageId(stageId,showIntroduce)  -- 显示通过该关卡将开启的功能
    if stageId == nil then return end
    local  _chapterNo, _stageNo = self._stageTemp:getIndexofStage(stageId)
    local item = self._stageTemp:getTemplateById(stageId)
    self.open = {}
    if item.open[1] ~= nil then
        for _k,_v in pairs(item.open) do
            local _openData = {}
            _openData.chapterNo = _chapterNo
            _openData.stageNo = _stageNo
            _openData.openId = _v
            table.insert(self.open,_openData)
        end
    else
        return
    end 
    
    self.stageId = stageId
    self.comeFromStageNo = false
    self:checkGuideNode()
    self:initView()
    self:initStageGuideLayerTouch()
    self:startStageGuideOpened()
    self.showIntroduce = showIntroduce
    self.isShow_ = true
    g_stagePassOpenTag = true
    getModule(MODULE_NAME_HOMEPAGE):removeLastView()
end

function StagePassOpen:initView()
    -- game.addSpriteFramesWithFile("res/ccb/resource/ui_navi.plist")
    self.UINewHandOpenView = {}
    self.UINewHandOpenView["UINewHandOpenView"] = {}
    local proxy = cc.CCBProxy:create()
    self.openStagePass = CCBReaderLoad("newHandLead/ui_newHand_open.ccbi", proxy, self.UINewHandOpenView)
    self.conLayer = self.UINewHandOpenView["UINewHandOpenView"]["conLayer"]
    self.touchLayer = self.UINewHandOpenView["UINewHandOpenView"]["touchLayer"]
    self.UINewHandOpenNode = self.UINewHandOpenView["UINewHandOpenView"]["UINewHandOpenNode"]
    self.openedSp = self.UINewHandOpenView["UINewHandOpenView"]["openedSp"]
    self.UINewHandOpenNode:setVisible(self.comeFromStageNo)

    if self.openStagePass == nil then
        return
    end
    if self.comeFromStageNo then
        local _node = UI_xinshouyindaoF1()
        self.adapterLayer:addChild(_node,1000)
        self.openedSp:setVisible(false)
    else
        self.openedSp:setVisible(true)
    end
    self.adapterLayer:addChild(self.openStagePass,99999)
end

function StagePassOpen:checkGuideNode()
    -- self:clearView()
    if self.adapterLayer == nil then
        local sharedDirector = cc.Director:getInstance()
        local glsize = sharedDirector:getWinSize()
        self.adapterLayer = cc.Layer:create()
        self.adapterLayer:setContentSize(cc.size(CONFIG_SCREEN_SIZE_WIDTH, CONFIG_SCREEN_SIZE_HEIGHT))
        self.adapterLayer:setPosition(cc.p(glsize.width / 2 - CONFIG_SCREEN_SIZE_WIDTH / 2, glsize.height / 2 - CONFIG_SCREEN_SIZE_HEIGHT / 2))
        self.upViewNode = game.createShieldLayer()
        self.adapterLayer:addChild(self.upViewNode,888)
        local layer = cc.LayerColor:create(cc.c4b(0, 0, 0, 0), CONFIG_SCREEN_SIZE_WIDTH, CONFIG_SCREEN_SIZE_HEIGHT)
        layer:setOpacity(200)
        self.adapterLayer:addChild(layer,444)
        local runningScene = game.getRunningScene()
        runningScene:addChild(self.adapterLayer, 10001)
    end
end

function StagePassOpen:startStageGuide()
    local function tableCellTouched(tbl, cell)  
        print("cell touched at index: " .. cell:getIdx())
    end
    local function numberOfCellsInTableView(tab)
        -- print("-----self.open------",table.nums(self.open))
        return table.nums(self.open)
    end
    local function cellSizeForTable(tbl, idx)
        return 125, 640
    end
    local function tableCellAtIndex(tbl, idx)

        local cell = tbl:dequeueCell()
        if nil == cell then
            cell = cc.TableViewCell:new()
            local tempTab = {}
            local proxy = cc.CCBProxy:create()
            local node = CCBReaderLoad("newHandLead/ui_newHand_open_item.ccbi", proxy, tempTab)
            cell:addChild(node)
            cell.tubiaoSp = tempTab["UINewHandOpenItem"]["tubiaoSp"]
            cell.biaotiName = tempTab["UINewHandOpenItem"]["biaotiName"]
            cell.biaotiDes = tempTab["UINewHandOpenItem"]["biaotiDes"]
        end
        
        local _data = self.open[idx+1]
        local resId1 = _data.openId
        local imageName = self.resourceTemplate:getPathNameById(resId1)
        local name = self.resourceTemplate:getResourceName(resId1)
        local url = "#" .. imageName .. ".png"
        local _strDes = nil
        game.setSpriteFrame(cell.tubiaoSp, url)
        cell.biaotiName:setString(name)
        if self.comeFromStageNo then
            _strDes = "通关" .. _data.chapterNo .. "-" .. _data.stageNo .. "关卡开启"
        else
            _strDes = "已开启"
        end
        cell.biaotiDes:setString(_strDes)
        return cell
    end

    local layerSize = self.conLayer:getContentSize()

    self.stageGuideList = cc.TableView:create(layerSize)
    self.stageGuideList:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.stageGuideList:setDelegate()
    self.stageGuideList:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.conLayer:addChild(self.stageGuideList)

    self.stageGuideList:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
    self.stageGuideList:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.stageGuideList:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.stageGuideList:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.stageGuideList:reloadData()
end

function StagePassOpen:initStageGuideLayerTouch()
    local function onTouchEvent(eventType, x, y)
        if eventType == "began" then
            return true
        elseif eventType == "ended" then 
            if self.comeFromStageNo == false and self.showIntroduce == false then
                -- print("------PVChapterIntroduce------")
                -- local nextStageId = self._stageTemp:getNextStage(self.stageId)
                -- getModule(MODULE_NAME_HOMEPAGE):showUIViewLastShow("PVChapterIntroduce",nextStageId)
                local homePage = getPlayerScene().homeModuleView.moduleView
                homePage:showHomeGuide()
            else
                --[[local gId = getNewGManager():getCurrentGid() 
                if gId == GuideId.G_GUIDE_20084 then 
                    groupCallBack(GuideGroupKey.BTN_TAOFA)
                else
                    groupCallBack(GuideGroupKey.BTN_NEW_CHAPTER_CLOSE)
                end]]--
                --local gId = getNewGManager():getCurrentGid()

                --local stageData = getDataManager():getStageData()
                --local _isShowPlotChapter, _stageId = stageData:getPlotChapterIsShow()
                --print("---- _isShowPlotChapter ", _isShowPlotChapter)
                --if _isShowPlotChapter == true or gId == GuideId.G_GUIDE_20084 then
                groupCallBack(GuideGroupKey.BTN_TAOFA)
                --end

            end
            g_stagePassOpenTag = false
            self:clearView()
        end
    end
    -- self.upViewNode:setTouchMode(cc.TOUCHES_ONE_BY_ONE)
    self.upViewNode:setSwallowsTouches(true)
    self.upViewNode:setTouchEnabled(true)   
    self.upViewNode:registerScriptTouchHandler(onTouchEvent)
end


function StagePassOpen:clearView()
    if self.adapterLayer then
        self.adapterLayer:removeFromParent(true)
        self.adapterLayer = nil
    end
    self.isShow_ = false
    self.showIntroduce = false
    self._chapterNo, self._stageNo = nil ,nil
end

function StagePassOpen:startStageGuideOpened()
    local sharedDirector = cc.Director:getInstance()
    local glsize = sharedDirector:getWinSize()
    local _openedNum = table.nums(self.open)
    local _w = nil
    if _openedNum == 1 then 
       local _node = self:getOpenNode(1)
       _node:setPosition(cc.p(CONFIG_SCREEN_SIZE_WIDTH / 3,CONFIG_SCREEN_SIZE_HEIGHT / 3))
       self.openStagePass:addChild(_node)
    elseif _openedNum == 2 then
        for i=1,_openedNum do
            if i == 1 then
                _w = 0.1
            else
                _w = 0.5
            end
           local _node = self:getOpenNode(i)
           _node:setPosition(cc.p(CONFIG_SCREEN_SIZE_WIDTH * _w,CONFIG_SCREEN_SIZE_HEIGHT / 3))
           self.openStagePass:addChild(_node)
        end
    elseif _openedNum == 3 then
        for i=1,_openedNum do
            if i == 1 then
                _w = 0.1
            elseif i == 2 then
                _w = 0.5
            else 
                _w = 1/3
            end
           local _node = self:getOpenNode(i)
           if i == 3 then
                _node:setPosition(cc.p(CONFIG_SCREEN_SIZE_WIDTH * _w,CONFIG_SCREEN_SIZE_HEIGHT / 5))
           else
                _node:setPosition(cc.p(CONFIG_SCREEN_SIZE_WIDTH * _w,CONFIG_SCREEN_SIZE_HEIGHT*3 / 5))
           end
           self.openStagePass:addChild(_node)
        end
    elseif _openedNum == 4 then
        for i=1,_openedNum do
             if i == 1 or i == 3 then
                _w = 0.1
            elseif i == 2 or i == 4 then
                _w = 0.5
            end
           local _node = self:getOpenNode(i)
           if i > 2  then
                _node:setPosition(cc.p(CONFIG_SCREEN_SIZE_WIDTH * _w,CONFIG_SCREEN_SIZE_HEIGHT / 5))
           else
                _node:setPosition(cc.p(CONFIG_SCREEN_SIZE_WIDTH * _w,CONFIG_SCREEN_SIZE_HEIGHT*3 / 5))
           end
           self.openStagePass:addChild(_node)
        end
    end
    
end

function StagePassOpen:getOpenNode(id)
    local opeItemNode = {}
    local proxy = cc.CCBProxy:create()
    local node = CCBReaderLoad("newHandLead/ui_newHand_open_item2.ccbi", proxy, opeItemNode)
    _biaotiName = opeItemNode["UINewHandOpenItem2"]["biaotiName"]
    local _data = self.open[id]
    local resId1 = _data.openId
    local name = self.resourceTemplate:getResourceName(resId1)
    local _nameLen, t = stringLen(name)
    print("-------_nameLen---------",_nameLen)
    if #t == 4 then
        name = t[1] .. t[2] .. "\n" .. t[3] .. t[4]
    elseif #t == 5 then
        name = t[1] .. t[2] .. "\n" .. t[3] .. t[4] .. t[5]
    elseif #t == 6 then
        name = t[1] .. t[2] .. t[3] .. "\n" .. t[4] .. t[5] .. t[6]
    end
    _biaotiName:setString(name)
    return node
end

return StagePassOpen














--章节介绍
local PVChapterIntroduce = class("PVChapterIntroduce", BaseUIView)

function PVChapterIntroduce:ctor(id)
    PVChapterIntroduce.super.ctor(self, id)

    self._languageTemp = getTemplateManager():getLanguageTemplate()
    self._stageTemp = getTemplateManager():getInstanceTemplate()

    -- cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA4444)
end

function PVChapterIntroduce:onMVCEnter()
	self.ccbiNode = {}       -- ccbi加载后返回的node
    self.ccbiRootNode = {}  -- ccb界面上的根节点
    self.stageId = self.funcTable[1]
    self.chapterId = self._stageTemp:getChapterByStageId(self.stageId)
    self.chapterIdx = self._stageTemp:getIndexofStage(self.stageId)
    cclog("---------self.stageId------"..self.stageId.."---------self.chapterId------"..self.chapterId.."------"..self.chapterIdx)
    self:loadCCBI("newHandLead/ui_newhand_fight_zhan.ccbi", self.ccbiNode)

	self:initView()
	self:initTouchLayer()
end

function PVChapterIntroduce:initView()
	self.ccbiRootNode = self.ccbiNode["UINewHandFightZhanView"]
	self.zhanDesLabel = self.ccbiRootNode["zhanDesLabel"]
	self.touchLayer = self.ccbiRootNode["touchLayer"]
	self.nameSp = self.ccbiRootNode["nameSp"]

	local str = self._languageTemp:getLanguageById(self._stageTemp:getStageIntroByID(self.chapterId))
	self.zhanDesLabel:setString(str)
	local nameStr = string.format("#ui_newHand_00%d.png",self.chapterIdx)
	game.setSpriteFrame(self.nameSp,nameStr)
end

function PVChapterIntroduce:initTouchLayer()
	
    local size = self.touchLayer:getContentSize()
    local rectArea = cc.rect(0, 0, size.width, size.height)
    local function onTouchEvent(eventType, x, y)
        local _pos = self.touchLayer:convertToNodeSpace(cc.p(x,y))
        local isInRect = cc.rectContainsPoint(rectArea, _pos)
        if eventType == "began" then
            return true
        elseif eventType == "ended" then
            --self.imgTokenLeft:setScale(1)
            if isInRect then
                getAudioManager():playEffectButton2()
                getNetManager():getInstanceNet():sendPlotChapter(self.chapterIdx+1)
                --本章节将要开启功能
                getStagePassOpen():startShowView(self.chapterIdx)
                
                self:onHideView()
                
                


                -- groupCallBack(GuideGroupKey.BTN_TAOFA)
                --TODO:此处调用违背新手引导的设计思路，先暂时注销掉
                -- print("---执行是否有新手引导检查---")
                -- groupCallBack(GuideGroupKey.BTN_NEW_CHAPTER_CLOSE)
                --  g_guideItem = getNewGManager():getCurrentInfo()

                -- if g_guideItem ~= nil then 
                --     if g_guideItem.trigger == 4 then
                --         if getNewGManager():getCurrentGid() == G_GUIDE_20115 then
                --             getNewGManager():setCurrentGID(G_GUIDE_20115)
                --             getNewGManager():createOtherRewards()
                --         end
                --         getNewGManager():startGuide()

                --     end

                --     g_guideItem = nil
                -- end
                
                -- print("----getNewGManager():getCurrentGid()------")

                -- print(getNewGManager():getCurrentGid())

                -- if getNewGManager():getCurrentGid() == GuideId.G_GUIDE_20043 then
                --     groupCallBack(GuideGroupKey.BTN_CHAPTER_CLOSE)
                    
                --     getNewGManager():setCurrentGID(GuideId.G_GUIDE_20044)
                --     getNewGManager():createOtherRewards()
                    
                -- end

            end
        end
    end
    self.touchLayer:setSwallowsTouches(true)
    self.touchLayer:setVisible(true)
    self.touchLayer:setTouchEnabled(true)
    self.touchLayer:setTouchMode(cc.TOUCHES_ONE_BY_ONE)
    self.touchLayer:registerScriptTouchHandler(onTouchEvent)

end

return PVChapterIntroduce
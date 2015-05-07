--游历
--
local PVTravelFengwuzhiShow = class("PVTravelFengwuzhiShow", BaseUIView)

function PVTravelFengwuzhiShow:ctor(id)
    self.super.ctor(self, id)
end

function PVTravelFengwuzhiShow:onMVCEnter()
    game.addSpriteFramesWithFile("res/ccb/resource/ui_travel.plist")

    self.UITravelZhiShow = {}
    self:initTouchListener()

    --加载本界面的ccbi
    self:loadCCBI("travel/ui_travel_fengwuzhi_show.ccbi", self.UITravelZhiShow)
    print("***************")
    self:initView()   
end

function PVTravelFengwuzhiShow:onExit()
    --self:unregisterScriptHandler()
    --game.removeSpriteFramesWithFile("res/ccb/resource/ui_travel.plist")
end

function PVTravelFengwuzhiShow:initView()
    local s = cc.Director:getInstance():getWinSize()

    local bg_color = cc.LayerColor:create(cc.c4b(0,0,0,150))

    bg_color:setContentSize(cc.size(s.width, s.height))
    bg_color:ignoreAnchorPointForPosition(true)
    self:addChild(bg_color, -1)
    
    
    self.selectIndex = self:getTransferData()[1]
    self.selectIndex2 = self:getTransferData()[2]
    print(">>>>>>"..self.selectIndex)


    self.peopleTitleLabel = self.UITravelZhiShow["UITravelZhiShow"]["peopleTitleLabel"]
    self.zhiDesLabel = self.UITravelZhiShow["UITravelZhiShow"]["zhiDesLabel"]
    self.icon = self.UITravelZhiShow["UITravelZhiShow"]["zhiSprite"]
    self.travelHuaJuan = self.UITravelZhiShow["UITravelZhiShow"]["travelHuaJuan"]
    if self.selectIndex2 == 1 then self.travelHuaJuan:setVisible(false) end
    if self.selectIndex2 ~= 1 then self.travelHuaJuan:setVisible(true) end
     
    
    local languageId = getTemplateManager():getTravelTemplate():getTravelItemByDetailID(self.selectIndex)
    self.peopleTitleLabel:setString(languageId)
    local languagedescription = getTemplateManager():getTravelTemplate():getDiscriptionByDetailID(self.selectIndex)
    local a = string.gsub( tostring(languagedescription) ,"\\n","\n")
    self.zhiDesLabel:setString(a)
 
    getDataManager():getTravelData():setBigFengPng(self.icon, self.selectIndex)

end

function PVTravelFengwuzhiShow:initTouchListener()
    --退出
    local function onCloseClick()
        getAudioManager():playEffectButton2()
        self:onHideView()
    end
    self.UITravelZhiShow["UITravelZhiShow"] = {}
    self.UITravelZhiShow["UITravelZhiShow"]["onCloseClick"] = onCloseClick
    --self.UITravelPropItem["UITravelPropItem"]["onItemClick"] = onItemClick
end

function PVTravelFengwuzhiShow:onReloadView()
   
end

return PVTravelFengwuzhiShow


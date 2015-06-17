-- fromtype  1, 游历  2，秘境
-- param[1]  类型
-- param[2] ID

--游历
--物品（鞋子）介绍
local PVTravelPropItem = class("PVTravelPropItem", BaseUIView)

function PVTravelPropItem:ctor(id)

    self.c_BaseTemplate = getTemplateManager():getBaseTemplate()
    self.c_StoneTemplate = getTemplateManager():getStoneTemplate()
    self.super.ctor(self, id)
end

function PVTravelPropItem:onMVCEnter()
    game.addSpriteFramesWithFile("res/ccb/resource/ui_travel.plist")

    self.UITravelPropItem = {}
    self:initTouchListener()

    --加载本界面的ccbi
    self:loadCCBI("travel/ui_travel_prop_item.ccbi", self.UITravelPropItem)
    print("***************")
    self:initView()   
    self:initData()
end

function PVTravelPropItem:onExit()
    --self:unregisterScriptHandler()
    --game.removeSpriteFramesWithFile("res/ccb/resource/ui_travel.plist")

end

function PVTravelPropItem:initView()
    self.itemIconImg = self.UITravelPropItem["UITravelPropItem"]["itemIcon"]
    self.itemName = self.UITravelPropItem["UITravelPropItem"]["itemName"]
    self.itemTimes = self.UITravelPropItem["UITravelPropItem"]["itemTimes"]
    self.proKuang = self.UITravelPropItem["UITravelPropItem"]["proKuang"]

    self.attributeLabel = self.UITravelPropItem["UITravelPropItem"]["attributeLabel"]
end

function PVTravelPropItem:initData()
    self.fromtype = self:getTransferData()[1]
    self.selectIndex = self:getTransferData()[2]
    print(">>>>>>"..self.selectIndex)

    if self.fromtype == 1 then -- 游历
        
        self:travelTips()

    elseif self.fromtype == 2 then -- 秘境
        self:mineTips()
    end
   
end

function PVTravelPropItem:mineTips()
    local _respng, _quality =  self.c_StoneTemplate:getStoneIconByID(self.selectIndex)
    self.itemIconImg:setOpacity(0)
    self.attributeLabel:setVisible(false)
    self.itemTimes:setVisible(false)
    setItemImage(self.proKuang, _respng, _quality)
end

function PVTravelPropItem:travelTips()
    local _list = self.c_BaseTemplate:getCaoXieDeg("travelShoe"..self.selectIndex)
    self.itemTimes:setString(_list)
    local res, name = self.c_BaseTemplate:getCaoXieResName(self.selectIndex)
    self.itemName:setString(name)
    self.itemIconImg:setOpacity(0)
    res = res..".webp"
    res = "res/icon/resource/"..res
    local pin = self.c_BaseTemplate:getCaoXiePin(self.selectIndex)
    setItemImage3(self.proKuang, res, pin)

    

    -- game.setSpriteFrame(self.itemIconImg, res)


    -- local pin = self.c_BaseTemplate:getCaoXiePin(self.selectIndex)
    -- local resPin = ""
    -- -- 绿、蓝3星、蓝4星、紫5星、紫6星
    -- if quality == 1 or quality == 2 then 
    --     resPin = resPin.."#ui_common2_bg2_lv.png"
    -- elseif quality == 3 or quality == 4 then
    --     resPin = resPin.."#ui_common2_bg2_lan.png"
    -- elseif quality == 5 or quality == 6 then
    --     resPin = resPin.."#ui_common2_bg2_zi.png"
    -- end
    -- game.setSpriteFrame(self.proKuang, resPin) 
end

function PVTravelPropItem:initTouchListener()
    --退出
    local function onCloseClick()
        getAudioManager():playEffectButton2()
        self:onHideView()
    end
    self.UITravelPropItem["UITravelPropItem"] = {}
    self.UITravelPropItem["UITravelPropItem"]["onCloseClick"] = onCloseClick
    --self.UITravelPropItem["UITravelPropItem"]["onItemClick"] = onItemClick
end

function PVTravelPropItem:onReloadView()
   
end

return PVTravelPropItem


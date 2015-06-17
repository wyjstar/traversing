

local PVLineUpCheck = class("PVLineUpCheck", BaseUIView)

function PVLineUpCheck:ctor(id)
    PVLineUpCheck.super.ctor(self, id)
end

function PVLineUpCheck:onMVCEnter()
    self.chatData = getDataManager():getChatData()
    self.chatNet = getNetManager():getChatNet()
    self.commonData = getDataManager():getCommonData()
    self.c_lineUpData = getDataManager():getLineupData()
    self:registerDataBack()
    self:initView()
    self:initData()
end

function PVLineUpCheck:registerDataBack()
end

function PVLineUpCheck:initData()
    g_data = self.funcTable[1]
    g_type_select_hero = self.funcTable[2]
    g_fromType = self.funcTable[3]
    self.type_select = self.funcTable[4]   -- 1. hero   2. equip
    if self.type_select == 1 then 
        self.downMenuItem:setVisible(true)
        self.downMenuItem1:setVisible(false)
        self:setPosition(cc.p(400, 480))
    elseif self.type_select == 2 then
        self.downMenuItem:setVisible(false)
        self.downMenuItem1:setVisible(true)
        self:setPosition(cc.p(270, 200))
    end
end

function PVLineUpCheck:initView()
    self.UICheckView = {}
    self:initTouchListener()
    self:loadCCBI("lineup/ui_lineup_check.ccbi", self.UICheckView)
    self.mainNode = self.UICheckView["UICheckView"]["mainNode"]
    self.mainLayer = self.UICheckView["UICheckView"]["mainLayer"]

    self.changeMenuItem = self.UICheckView["UICheckView"]["changeMenuItem"]
    self.downMenuItem = self.UICheckView["UICheckView"]["downMenuItem"]       --武将
    self.downMenuItem1 = self.UICheckView["UICheckView"]["downMenuItem1"]     --装备
    self.lookMenuItem = self.UICheckView["UICheckView"]["lookMenuItem"]

    self:nodeRegisterTouchEvent()

end

function PVLineUpCheck:initTouchListener()
    --更换
    local function onChangeClick()
        if self.type_select == 1 then 
            self:onHideView()
            getModule(MODULE_NAME_LINEUP):showUIViewAndInTop("PVSelectSoldier", g_type_select_hero, g_fromType)
        elseif self.type_select == 2 then 
            self:onHideView()
            getModule(MODULE_NAME_LINEUP):showUIView("PVSelectEquipment", g_type_select_hero, -1, g_data)
        end
        g_data = nil
        g_type_select_hero = nil
        g_fromType = nil
    end

    --下阵
    local function onDownClick()
        if self.type_select == 1 then 
            if g_fromType == FROM_TYPE_MINE or g_fromType == FROM_TYPE_MINE_CHANGE_LINEUP then
                self:onHideView(0)
            else
                local _onLineUpList = self.c_lineUpData:getOnLineUpList()
                if g_type_select_hero == 1 then
                    if table.nums(_onLineUpList) > 1 then
                        self:onHideView(0)
                    else
                        getOtherModule():showAlertDialog(nil, Localize.query("lineup.8"))
                    end
                else
                    self:onHideView(0)
                end
            end
        elseif self.type_select == 2 then 
            self:onHideView(0)
        end
        g_data = nil
        g_type_select_hero = nil
        g_fromType = nil
    end

    --查看
    local function onLookClick()
        if self.type_select == 1 then 
            self:onHideView()
            getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSoldierMyLookDetail", g_data, 1, g_type_select_hero, g_fromType) 
        elseif self.type_select == 2 then 
            self:onHideView()
            getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVEquipmentAttribute", g_data, 1, g_type_select_hero)
        end
        g_data = nil
        g_type_select_hero = nil
        g_fromType = nil
    end

    self.UICheckView["UICheckView"] = {}

    self.UICheckView["UICheckView"]["onChangeClick"] = onChangeClick
    self.UICheckView["UICheckView"]["onDownClick"] = onDownClick
    self.UICheckView["UICheckView"]["onLookClick"] = onLookClick
end

function PVLineUpCheck:nodeRegisterTouchEvent()

    local posX, posY = self.mainLayer:getPosition()

    local size = self.mainLayer:getContentSize()
    local rectArea = cc.rect(posX, posY, size.width, size.height)


    local function onTouchEvent(eventType, x, y)
        print("current point x y ============= ", x , y)
        pos = self.mainLayer:convertToNodeSpace(cc.p(x,y))
        local isInRect = cc.rectContainsPoint(rectArea, cc.p(pos.x,pos.y))
         if  eventType == "began" then
            if isInRect then
                return false
            end
            return true
        elseif  eventType == "ended" then
            self:onHideView()
            g_data = nil
            g_type_select_hero = nil
            g_fromType = nil
        end
    end
    self.mainLayer:registerScriptTouchHandler(onTouchEvent)
    self.mainLayer:setTouchMode(cc.TOUCHES_ONE_BY_ONE)
    self.mainLayer:setTouchEnabled(true)
end

return PVLineUpCheck

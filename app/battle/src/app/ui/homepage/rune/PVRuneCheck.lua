--符文镶嵌页面，点击符文子菜单
local PVRuneCheck = class("PVRuneCheck", BaseUIView)

function PVRuneCheck:ctor(id)
    self.super.ctor(self, id)
end

function PVRuneCheck:onMVCEnter()
    self.c_runeData = getDataManager():getRuneData()
    self.commonData = getDataManager():getCommonData()
    self.c_runeNet = getNetManager():getRuneNet()
    self.c_StoneTemplate = getTemplateManager():getStoneTemplate()
    self:registerDataBack()
    self:initData()
    self:initView()
    self:nodeRegisterTouchEvent()
end

--网络返回
function PVRuneCheck:registerDataBack()
end

--相关数据初始化
function PVRuneCheck:initData()
    self.posX = self.funcTable[1]
    self.posY = self.funcTable[2]
    self.curRuneItem = self.funcTable[3]
    -- self.typeIndex = self.funcTable[4]

    -- self.curRuneId = self.curRuneItem.runeId
    -- self.curRuneType = self.curRuneItem.runeType
    -- self.curRunePos = self.curRuneItem.runePos

    -- self.curRuneId = self.curRuneItem.runt_id
    -- self.curRuneType = self.curRuneItem.runeType
    -- self.curRunePos = self.curRuneItem.runePos
    -- self.curRuneNo = self.curRuneItem.runt_no
    -- local addRuneItem = {}
    -- addRuneItem.runePos = self.curRunePos
    -- addRuneItem.runeType = self.curRuneType
    -- addRuneItem.curRuneId = self.curRuneId
    -- self.c_runeData:setPreRuneItem(self.curRuneItem)
end

--界面加载以及初始化
function PVRuneCheck:initView()
    self.UIRuneCheckView = {}

    self:initTouchListener()
    self:loadCCBI("rune/ui_rune_check.ccbi", self.UIRuneCheckView)

    self.mainNode = self.UIRuneCheckView["UIRuneCheckView"]["mainNode"]
    self.mainLayer = self.UIRuneCheckView["UIRuneCheckView"]["mainLayer"]

    self.mainNode:setPosition(cc.p(self.posX, self.posY))
end

--界面监听事件
function PVRuneCheck:initTouchListener()
    --查看
    local function onCheckClick()
        getAudioManager():playEffectButton2()
        if self.curRuneItem ~= nil then
            getOtherModule():showOtherView("PVRuneLook", self.curRuneItem, 1)
        end
    end

    --摘除
    local function onDeleteRuneClick()
        getAudioManager():playEffectButton2()
        local curSoldierId = self.c_runeData:getCurSoliderId()
        -- typeIndex = self.typeIndex
        -- curRuneId = self.curRuneId
        -- curRuneNo = self.curRuneNo
        -- if self.typeIndex == 1 then
            local haveCoin = self.commonData:getCoin()
            local pickPrice = self.c_StoneTemplate:getPickPriceById(self.curRuneItem.runt_id)
            if haveCoin >= pickPrice then
                self.c_runeNet:sendDeleRune(curSoldierId, self.curRuneItem.runeType, self.curRuneItem.runePos)
                self:onHideView()
            else
                getOtherModule():showAlertDialog(nil, Localize.query(101))
            end
        -- elseif self.typeIndex == 2 then
        --     self:onHideView()
        --     getModule(MODULE_NAME_HOMEPAGE):showUIView("PVRuneBagPanel", typeIndex, {rune_no=curRuneNo})
        -- end
    end

    --更换
    local function onChangeRuneClick()
        print("onChangeRuneClick ============ ")
        getAudioManager():playEffectButton2()
        if self.curRuneItem ~= nil then
            cclog("符文背包 ========= ")
            local haveCoin = self.commonData:getCoin()
            local pickPrice = self.c_StoneTemplate:getPickPriceById(self.curRuneItem.runt_id)
            if haveCoin >= pickPrice then
                self.c_runeData:setPreRuneItem(self.curRuneItem)
                self:onHideView()            
                getModule(MODULE_NAME_HOMEPAGE):showUIView("PVRuneBagPanel", 3)  
            else
                getOtherModule():showAlertDialog(nil, Localize.query(101))
            end     
        end
    end

    self.UIRuneCheckView["UIRuneCheckView"] = {}
    self.UIRuneCheckView["UIRuneCheckView"]["onCheckClick"] = onCheckClick                    --查看
    self.UIRuneCheckView["UIRuneCheckView"]["onDeleteRuneClick"] = onDeleteRuneClick          --摘除
    self.UIRuneCheckView["UIRuneCheckView"]["onChangeRuneClick"] = onChangeRuneClick          --更换

end

function PVRuneCheck:nodeRegisterTouchEvent()

    local posX, posY = self.mainLayer:getPosition()

    local size = self.mainLayer:getContentSize()
    local rectArea = cc.rect(posX, posY, size.width, size.height)


    local function onTouchEvent(eventType, x, y)
        pos = self.mainLayer:convertToNodeSpace(cc.p(x,y))
        local isInRect = cc.rectContainsPoint(rectArea, cc.p(pos.x,pos.y))
         if  eventType == "began" then
            if isInRect then
                return false
            end
            return true
        elseif  eventType == "ended" then
            self:onHideView()
        end
    end
    self.mainLayer:registerScriptTouchHandler(onTouchEvent)
    self.mainLayer:setTouchMode(cc.TOUCHES_ONE_BY_ONE)
    self.mainLayer:setTouchEnabled(true)
end

function PVRuneCheck:onReloadView()
end

function PVRuneCheck:clearResource()
end

return PVRuneCheck

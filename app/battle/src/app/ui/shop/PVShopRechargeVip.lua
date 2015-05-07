-- 商城的vip页面

local vipMax = 15            --vip最大等级
local duration = 0.5         --滑动动画时间

local PVShopRechargeVip = class("PVShopRechargeVip", BaseUIView)

function PVShopRechargeVip:ctor(id)
    
    self.super.ctor(self, id)
    
    print("PVShopRechargeVip:ctor end")


    self.TYPE_MOVE_NONE = 0  --滑动类型为无
    self.TYPE_MOVE_LEFT = 1  --滑动类型为向左
    self.TYPE_MOVE_RIGHT = 2  --滑动类型为向右

end


function PVShopRechargeVip:onMVCEnter()
    
    --初始化属性
    self:init()
    
    --绑定事件
    self:initTouchListener()
    
    --加载本界面的ccbi ui_shop.ccbi
    self:loadCCBI("shop/ui_shop_rg_vip.ccbi", self.ccbiNode)

    self:initView()

    self.vipNum = 1
    self:updataVipDes(self.vipNum)

    self:initTouchLayerTouch()

end

function PVShopRechargeVip:init()

    self.ccbiNode = {}
    self.ccbiRootNode = {}

    self.labelTips = nil
end


--初始化界面
function PVShopRechargeVip:initView( ... )
    self.ccbiRootNode = self.ccbiNode["UIShopRgVip"]
    self.labelTips = self.ccbiRootNode["labelVip"]
    self.labelYuanBao = self.ccbiRootNode["labelYuanBao"]
    self.imgVipNol = self.ccbiRootNode["vipNol_sprite"]
    self.imgVipNor = self.ccbiRootNode["vipNor_sprite"]
    self.imgVipSlider = self.ccbiRootNode["imgVipSlider"]
    self.listLayer = self.ccbiRootNode["contentLayer"]
    self.vipLv = self.ccbiRootNode["vipLv"]
    self.onClickLeftBtn = self.ccbiRootNode["onClickLeftBtn"]
    self.onClickRightBtn = self.ccbiRootNode["onClickRightBtn"]
    self.vipLevelLabelNodeLeft = self.ccbiRootNode["vipLevelLabelNodeLeft"]
    self.vipLevelLabelNodeMid = self.ccbiRootNode["vipLevelLabelNodeMid"]
    self.vipLevelLabelNodeRight = self.ccbiRootNode["vipLevelLabelNodeRight"]

    local vipNo = getDataManager():getCommonData():getVip()
    self.vipNo = vipNo
    self:setVipNo(vipNo)
    --显示到达下一vip所需累计充值金额
    local rechargeAmount = 0
    local nextVipNo = vipNo
    if  vipNo < 15 then
        nextVipNo = vipNo + 1
        rechargeAmount = getTemplateManager():getBaseTemplate():getRechargeAmount(nextVipNo)
    else
        rechargeAmount = getTemplateManager():getBaseTemplate():getRechargeAmount(vipNo)
    end
    self.labelTips:setString(string.format(Localize.query("shop.22"),rechargeAmount,nextVipNo))
    self.labelTips:setScaleX(0.9)
    local currRecharge = getTemplateManager():getBaseTemplate():getRechargeAmount(vipNo)
    self.labelYuanBao:setString(currRecharge.."/"..rechargeAmount)

    self.touchLayer = self.ccbiRootNode["touchLayer"]      -- 滑动 layer
    self.vipDesLabel = self.ccbiRootNode["vipDesLabel"]    -- vip 描述
    -- self.onVipLeftTo = self.ccbiRootNode["onVipLeftTo"]    -- 向左
    -- self.onVipRightTo = self.ccbiRootNode["onVipRightTo"]  -- 向左
    
    self.imgVipSlider:setVisible(false)
    self.vipPrgress = cc.ProgressTimer:create(self.imgVipSlider)
    self.vipPrgress:setAnchorPoint(cc.p(0,0.5))
    self.vipPrgress:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.vipPrgress:setBarChangeRate(cc.p(1, 0))
    self.vipPrgress:setMidpoint(cc.p(0, 0))
    self.vipPrgress:setLocalZOrder(0)
    self.vipPrgress:setPosition(cc.p(self.imgVipSlider:getPositionX(),self.imgVipSlider:getPositionY()))
    self.imgVipSlider:getParent():addChild(self.vipPrgress)
    self:updataProgress()

    --底部vip滑动图标
    self.bottomVipContentNode = game.newNode()
    self.vipL1 = game.newSprite("#ui_shopvip_vip_bg.png")
    self.vipL2 = game.newSprite("#ui_shopvip_vip_bg.png")
    self.vipR1 = game.newSprite("#ui_shopvip_vip_bg.png")
    self.vipR2 = game.newSprite("#ui_shopvip_vip_bg.png")
    self.vipMid = game.newSprite("#ui_shopvip_vip_bg.png")
    self.vipMid:setPosition(320,80)
    self.vipL1:setPosition(120,80)
    self.vipL2:setPosition(-100,80)
    self.vipR1:setPosition(520,80)
    self.vipR2:setPosition(740,80)
    self.bottomVipContentNode:addChild(self.vipL1)
    self.bottomVipContentNode:addChild(self.vipL2)
    self.bottomVipContentNode:addChild(self.vipR1)
    self.bottomVipContentNode:addChild(self.vipR2)
    self.bottomVipContentNode:addChild(self.vipMid)
    self.vipL1:setScale(0.5)
    self.vipL2:setScale(0.5)
    self.vipR1:setScale(0.5)
    self.vipR2:setScale(0.5)

    self.bottonVipSpriteTable = {}  -- 保存顺序
    table.insert(self.bottonVipSpriteTable,self.vipL2)
    table.insert(self.bottonVipSpriteTable,self.vipL1)
    table.insert(self.bottonVipSpriteTable,self.vipMid)
    table.insert(self.bottonVipSpriteTable,self.vipR1)
    table.insert(self.bottonVipSpriteTable,self.vipR2)

    local stencil = game.newColorLayer(ui.COLOR_RED_NEW)
    stencil:setContentSize(cc.size(530,300))
    stencil:setAnchorPoint(cc.p(0.5,0.5))
    stencil:setPosition(55,0)
    self.bottomVipNode = game.newClippingNode()
    self.bottomVipNode:setStencil(stencil)
    self.bottomVipNode:addChild(self.bottomVipContentNode)
    self.bottomVipNode:setPosition(0,100)
    self.bottomVipNode:setAlphaThreshold(1)
    self.adapterLayer:addChild(self.bottomVipNode)

    self.vipValue = {} --vip数值
    self.vipValue[1] = vipMax-1
    self.vipValue[2] = vipMax
    self.vipValue[3] = 1
    self.vipValue[4] = 2
    self.vipValue[5] = 3

    self.vipLabelTable = {}

    for k,v in pairs(self.bottonVipSpriteTable) do
        self.vipLabelTable[k] = getVipLevelLabel(self.vipValue[k])
        self.vipLabelTable[k]:setPosition(150,80)
        v:addChild(self.vipLabelTable[k])
        local vipword = game.newSprite("#ui_shopvip_word_vip_new.png")
        v:addChild(vipword)
        vipword:setPosition(110,80)
    end
    


end

--底部vip 向左滑动
function PVShopRechargeVip:bottomVipSwipeLeft()
    local duration = 0.5
    local rightX,rightY = self.bottonVipSpriteTable[5]:getPosition()

    local tempTable = {}
    tempTable[1] = self.bottonVipSpriteTable[1]
    tempTable[2] = self.bottonVipSpriteTable[2]
    tempTable[3] = self.bottonVipSpriteTable[3]
    tempTable[4] = self.bottonVipSpriteTable[4]
    tempTable[5] = self.bottonVipSpriteTable[5]

    local tempLabelTable = {}
    tempLabelTable[1] = self.vipLabelTable[1]
    tempLabelTable[2] = self.vipLabelTable[2]
    tempLabelTable[3] = self.vipLabelTable[3]
    tempLabelTable[4] = self.vipLabelTable[4]
    tempLabelTable[5] = self.vipLabelTable[5]

    self.bottonVipSpriteTable[5]:runAction(cc.MoveTo:create(duration,cc.p(self.bottonVipSpriteTable[4]:getPosition())))
    self.bottonVipSpriteTable[5]:runAction(cc.ScaleTo:create(duration,0.5))

    self.bottonVipSpriteTable[4]:runAction(cc.MoveTo:create(duration,cc.p(self.bottonVipSpriteTable[3]:getPosition())))
    self.bottonVipSpriteTable[4]:runAction(cc.ScaleTo:create(duration,1))

    self.bottonVipSpriteTable[3]:runAction(cc.MoveTo:create(duration,cc.p(self.bottonVipSpriteTable[2]:getPosition())))
    self.bottonVipSpriteTable[3]:runAction(cc.ScaleTo:create(duration,0.5))

    self.bottonVipSpriteTable[2]:runAction(cc.MoveTo:create(duration,cc.p(self.bottonVipSpriteTable[1]:getPosition())))
    self.bottonVipSpriteTable[2]:runAction(cc.ScaleTo:create(duration,0.5))

    self.bottonVipSpriteTable[1]:setPosition(rightX,rightY)
    self.bottonVipSpriteTable[1]:setScale(0.5)

    --更新顺序
    local function callBack1( ... )
        self.touchLayer:setTouchEnabled(false)
    end
    local function callBack2( ... )
        self.bottonVipSpriteTable[5] = tempTable[1]
        self.bottonVipSpriteTable[4] = tempTable[5]
        self.bottonVipSpriteTable[3] = tempTable[4]
        self.bottonVipSpriteTable[2] = tempTable[3]
        self.bottonVipSpriteTable[1] = tempTable[2]

        self.vipLabelTable[5] = tempLabelTable[1]
        self.vipLabelTable[4] = tempLabelTable[5]
        self.vipLabelTable[3] = tempLabelTable[4]
        self.vipLabelTable[2] = tempLabelTable[3]
        self.vipLabelTable[1] = tempLabelTable[2]

        self.touchLayer:setTouchEnabled(true)
        --更新vip数值
        if self.vipValue[1] == vipMax then
            self.vipValue[1] = 1
        else
            self.vipValue[1] = self.vipValue[1]+1
        end

        if self.vipValue[2] == vipMax then
            self.vipValue[2] = 1
        else
            self.vipValue[2] = self.vipValue[2]+1
        end

        if self.vipValue[3] == vipMax then
            self.vipValue[3] = 1
        else
            self.vipValue[3] = self.vipValue[3]+1
        end

        if self.vipValue[4] == vipMax then
            self.vipValue[4] = 1
        else
            self.vipValue[4] = self.vipValue[4]+1
        end

        if self.vipValue[5] == vipMax then
            self.vipValue[5] = 1
        else
            self.vipValue[5] = self.vipValue[5]+1
        end
        table.print(self.vipValue)
        for k,v in pairs(self.vipLabelTable) do
            v:setString(tostring(self.vipValue[k]))
        end
    end
    local sequnce = cc.Sequence:create({cc.CallFunc:create(callBack1),cc.DelayTime:create(duration),cc.CallFunc:create(callBack2)})
    self:runAction(sequnce)

end

--底部vip 向右滑动
function PVShopRechargeVip:bottomVipSwipeRight()
    
    local leftX,leftY = self.bottonVipSpriteTable[1]:getPosition()

    local tempTable = {}
    tempTable[1] = self.bottonVipSpriteTable[1]
    tempTable[2] = self.bottonVipSpriteTable[2]
    tempTable[3] = self.bottonVipSpriteTable[3]
    tempTable[4] = self.bottonVipSpriteTable[4]
    tempTable[5] = self.bottonVipSpriteTable[5]

    local tempLabelTable = {}
    tempLabelTable[1] = self.vipLabelTable[1]
    tempLabelTable[2] = self.vipLabelTable[2]
    tempLabelTable[3] = self.vipLabelTable[3]
    tempLabelTable[4] = self.vipLabelTable[4]
    tempLabelTable[5] = self.vipLabelTable[5]

    self.bottonVipSpriteTable[1]:runAction(cc.MoveTo:create(duration,cc.p(self.bottonVipSpriteTable[2]:getPosition())))
    self.bottonVipSpriteTable[1]:runAction(cc.ScaleTo:create(duration,0.5))

    self.bottonVipSpriteTable[2]:runAction(cc.MoveTo:create(duration,cc.p(self.bottonVipSpriteTable[3]:getPosition())))
    self.bottonVipSpriteTable[2]:runAction(cc.ScaleTo:create(duration,1))

    self.bottonVipSpriteTable[3]:runAction(cc.MoveTo:create(duration,cc.p(self.bottonVipSpriteTable[4]:getPosition())))
    self.bottonVipSpriteTable[3]:runAction(cc.ScaleTo:create(duration,0.5))

    self.bottonVipSpriteTable[4]:runAction(cc.MoveTo:create(duration,cc.p(self.bottonVipSpriteTable[5]:getPosition())))
    self.bottonVipSpriteTable[4]:runAction(cc.ScaleTo:create(duration,0.5))

    self.bottonVipSpriteTable[5]:setPosition(leftX,leftY)
    self.bottonVipSpriteTable[5]:setScale(0.5)

    --更新顺序
    local function callBack1( ... )
        self.touchLayer:setTouchEnabled(false)
    end
    local function callBack2( ... )
        self.bottonVipSpriteTable[5] = tempTable[4]
        self.bottonVipSpriteTable[4] = tempTable[3]
        self.bottonVipSpriteTable[3] = tempTable[2]
        self.bottonVipSpriteTable[2] = tempTable[1]
        self.bottonVipSpriteTable[1] = tempTable[5]

        self.vipLabelTable[5] = tempLabelTable[4]
        self.vipLabelTable[4] = tempLabelTable[3]
        self.vipLabelTable[3] = tempLabelTable[2]
        self.vipLabelTable[2] = tempLabelTable[1]
        self.vipLabelTable[1] = tempLabelTable[5]

        self.touchLayer:setTouchEnabled(true)
        --更新vip数值
        if self.vipValue[1] == 1 then
            self.vipValue[1] = vipMax
        else
            self.vipValue[1] = self.vipValue[1]-1
        end

        if self.vipValue[2] == 1 then
            self.vipValue[2] = vipMax
        else
            self.vipValue[2] = self.vipValue[2]-1
        end

        if self.vipValue[3] == 1 then
            self.vipValue[3] = vipMax
        else
            self.vipValue[3] = self.vipValue[3]-1
        end

        if self.vipValue[4] == 1 then
            self.vipValue[4] = vipMax
        else
            self.vipValue[4] = self.vipValue[4]-1
        end

        if self.vipValue[5] == 1 then
            self.vipValue[5] = vipMax
        else
            self.vipValue[5] = self.vipValue[5]-1
        end
        table.print(self.vipValue)
        for k,v in pairs(self.vipLabelTable) do
            v:setString(tostring(self.vipValue[k]))
        end
    end
    local sequnce = cc.Sequence:create({cc.CallFunc:create(callBack1),cc.DelayTime:create(duration),cc.CallFunc:create(callBack2)})
    self:runAction(sequnce)
 
end

--更新进度条
function PVShopRechargeVip:updataProgress()
    local vipNo = getDataManager():getCommonData():getVip()
    local rechargeAmount = 0
    if vipNo < 15 then
        rechargeAmount = getTemplateManager():getBaseTemplate():getRechargeAmount(vipNo + 1)
    else
        rechargeAmount = getTemplateManager():getBaseTemplate():getRechargeAmount(vipNo)
    end
    local percentage = getDataManager():getCommonData():getRechargeAcc() / rechargeAmount    
    self.vipPrgress:setPercentage(percentage * 100)
end

--绑定事件
function PVShopRechargeVip:initTouchListener()
    
    local function menuClickBack()
        print("menuclickBack ...")
        self:onHideView()
    end

    local function menuClickCharge()
        getAudioManager():playEffectButton2()
        print("menuclickCharge 。。。")
        self:onHideView()
        getModule(MODULE_NAME_HOMEPAGE):removeLastView()
        getModule(MODULE_NAME_SHOP):showUIViewAndInTop("PVshopRecharge")
    end

    local function onClickLeft( ... )
        self:OnTouchMoveLeft()
        self:unableMenuDuration()
    end

    local function onClickRight( ... )
        self:OnTouchMoveRight()
        self:unableMenuDuration()
    end

    self.ccbiNode["UIShopRgVip"] = {}
    self.ccbiNode["UIShopRgVip"]["menuClickBack"] = menuClickBack
    self.ccbiNode["UIShopRgVip"]["menuClickCharge"] = menuClickCharge
    self.ccbiNode["UIShopRgVip"]["onClickLeft"] = onClickLeft
    self.ccbiNode["UIShopRgVip"]["onClickRight"] = onClickRight


end

--暂时禁用按钮，然后再恢复
function PVShopRechargeVip:unableMenuDuration( ... )

    local function callBack1( ... )
        -- body
        self.onClickLeftBtn:setEnabled(false)
        self.onClickRightBtn:setEnabled(false)
    end
    local function callBack2( ... )
        -- body
        self.onClickLeftBtn:setEnabled(true)
        self.onClickRightBtn:setEnabled(true)
    end

    local seq = cc.Sequence:create({cc.CallFunc:create(callBack1),cc.DelayTime:create(duration),cc.CallFunc:create(callBack2)})

    self:runAction(seq)
end

--更新vip等级
function PVShopRechargeVip:setVipNo(num)
    self.vipLevelLabelNodeLeft:removeAllChildren()
    self.vipLevelLabelNodeLeft:addChild(getVipLevelLabel(num))

    self.vipLevelLabelNodeRight:removeAllChildren()
    if num+1 > vipMax then
        self.vipLevelLabelNodeRight:addChild(getVipLevelLabel(vipMax))
    else
        self.vipLevelLabelNodeRight:addChild(getVipLevelLabel(num+1))
    end
end

--vip特权描述
function PVShopRechargeVip:updataVipDes( vipNum )
    -- print("--------------updataVipDes( vipNum )---------------"..vipNum)
    -- self.vipLv:removeAllChildren()
    -- if vipNum < 10 then 
    --     game.setSpriteFrame(self.vipLv, tostring("#ui_shop_s_vip"..vipNum..".png"))
    -- else
    --     local shiWei = roundNumber(vipNum/10)
    --     local geWei = (vipNum%10)
    --     game.setSpriteFrame(self.vipLv, tostring("#ui_shop_s_vip"..shiWei..".png"))
        

    --     local bgSprite = cc.Sprite:create()
    --     game.setSpriteFrame(bgSprite, tostring("#ui_shop_s_vip"..geWei..".png"))
        
    --     self.vipLv:addChild(bgSprite, 1)
    --     bgSprite:setPosition(38, 22)
    -- end
    self.vipLevelLabelNodeMid:removeAllChildren()
    self.vipLevelLabelNodeMid:addChild(getVipLevelLabel(vipNum))

    local desId = getTemplateManager():getBaseTemplate():getVipDescription(vipNum)
    local des = getTemplateManager():getLanguageTemplate():getLanguageById(desId)
    des = string.gsub( tostring(des) ,"\\n","\n")
    self.vipDesLabel:setString(des)


end



-- function PVShopRechargeVip:updataVipNumList()
--     -- print("--------------updataVipNumList( vipNum )---------------"..vipNum)

--     for k,v in pairs(self.vipNumList) do
--         -- print(k,v)
--         if v < 10 then 
--             game.setSpriteFrame(self.vipNum1[k], tostring("#ui_vip_"..v..".png"))
--             self.vipNum2[k]:setVisible(false)
--         else
--             local shiWei = roundNumber(v/10)
--             local geWei = (v%10)
--             self.vipNum2[k]:setVisible(true)
--             game.setSpriteFrame(self.vipNum1[k], tostring("#ui_vip_"..shiWei..".png"))
--             game.setSpriteFrame(self.vipNum2[k], tostring("#ui_vip_"..geWei..".png"))
--         end
--     end
-- end

--初始化触摸事件
function PVShopRechargeVip:initTouchLayerTouch()
    -- print("-------------initTouchLayerTouch---------------")
    local posX,posY = self.touchLayer:getPosition()
    local size = self.touchLayer:getContentSize()
    self.touchLayer:setTouchMode(cc.TOUCHES_ONE_BY_ONE)

    local rectArea = cc.rect(0, 0, size.width, size.height)

    local moveType = self.TYPE_MOVE_NONE
    local MAGIN = 50

    local function onTouchEvent(eventType, x, y)
        -- print("-------------onTouchEvent(eventType, x, y)---------------")
        if eventType == "began" then
            local _point = self.touchLayer:convertToNodeSpace(cc.p(x,y))
            local isInRect = cc.rectContainsPoint(rectArea, _point)
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

    self.touchLayer:registerScriptTouchHandler(onTouchEvent)
    self.touchLayer:setTouchMode(cc.TOUCHES_ONE_BY_ONE)
    self.touchLayer:setTouchEnabled(true)
end

--触摸事件回调
function PVShopRechargeVip:onLayerTouchCallBack(moveType)
    -- print("-------------onLayerTouchCallBack---------------")
    if moveType == self.TYPE_MOVE_NONE then
        -- self:showSelectHeroView()
    elseif moveType == self.TYPE_MOVE_LEFT then
        self:OnTouchMoveLeft()
    elseif moveType == self.TYPE_MOVE_RIGHT then
        self:OnTouchMoveRight()
    end
end

--往左滑动
function PVShopRechargeVip:OnTouchMoveRight()
    if self.vipNum == 1 then
        self.vipNum = vipMax
    else
        self.vipNum = self.vipNum - 1
    end
    self:updataVipDes(self.vipNum)
    self:bottomVipSwipeRight()
end

--往右滑动
function PVShopRechargeVip:OnTouchMoveLeft()

    if self.vipNum == vipMax then
        self.vipNum = 1
    else
        self.vipNum = self.vipNum + 1
    end
    self:updataVipDes(self.vipNum)
    self:bottomVipSwipeLeft()
end

--@return
return PVShopRechargeVip

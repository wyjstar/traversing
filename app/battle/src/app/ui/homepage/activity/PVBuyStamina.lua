-- 购买体力

local PVBuyStamina = class("PVBuyStamina", BaseUIView)

function PVBuyStamina:ctor(id)
    PVBuyStamina.super.ctor(self, id)
end

function PVBuyStamina:onMVCEnter()
    game.addSpriteFramesWithFile("res/ccb/resource/ui_friend.plist")
    self.c_BaseTemplate = getTemplateManager():getBaseTemplate()

    self.fileName = self.funcTable[1]
    self.detailValue = self.funcTable[2]
    print("self.fileName ================= ", self.fileName)
    print("self.detailValue ==================== ", self.detailValue)
	self:init()
    self:registerNetCallback()
end

function PVBuyStamina:init()
	self.ccbiNode = {}

    self:initTouchListener()
    self:loadCCBI("common/ui_common_buy_stamina.ccbi", self.ccbiNode)

    self:initView()
end

function PVBuyStamina:registerNetCallback()
    local function buyStaminaCallback(id, data)
        print(" --------- ui response buyStamina --------", data)
        table.print(data)
        if data.result then
            local number = getTemplateManager():getBaseTemplate():buyStaminaNumber()
            getDataManager():getCommonData():addStamina(number)
            getHomeBasicAttrView():updateStamina()
            getDataManager():getCommonData():addBuyStaminaTimes()
            local event = cc.EventCustom:new(UPDATE_TL)
            self:getEventDispatcher():dispatchEvent(event)
        else
            getOtherModule():showAlertDialog(nil, Localize.query(data.result_no))
        end

        self:onHideView(10)
    end
    self:registerMsg(ACTIVITY_BUY_STAMINA, buyStaminaCallback)
end

function PVBuyStamina:initTouchListener()
    function onMenuCancle()
        cclog('onMenuCancle')
        -- do nothing
        self:onHideView(10)
    end
    local function onClickOK()
        cclog("buy stamina ...")
        if self.fileName == nil then
            local type, money = getTemplateManager():getBaseTemplate():getBuyStaminaMoney()
            if money > getDataManager():getCommonData():getGold() then
                getOtherModule():showAlertDialog(nil, Localize.query("activity.5"))
                return
            else
                getDataManager():getCommonData():subGold(tonumber(money))
            end
            getNetManager():getActivityNet():sendBuyStamina()
        elseif self.fileName == "pvArenaPanel" then
            cclog("购买挑战次数 ============= ")
        end
    end
    self.ccbiNode["UIBuyTLNode"] = {}
    self.ccbiNode["UIBuyTLNode"]["onMenuCancle"] = onMenuCancle
    self.ccbiNode["UIBuyTLNode"]["onClickOK"] = onClickOK
    self.ccbiNode["UIBuyTLNode"]["onCloseClick"] = onMenuCancle

end

function PVBuyStamina:initView()
	self.labelMoney = self.ccbiNode["UIBuyTLNode"]["label_money"]
	self.imgMoney = self.ccbiNode["UIBuyTLNode"]["img_money_type"]
    self.titleSprite = self.ccbiNode["UIBuyTLNode"]["titleSprite"]
    self.detailLabel2 = self.ccbiNode["UIBuyTLNode"]["detailLabel2"]

    if self.fileName ~= nil then
        self.titleSprite:setSpriteFrame("ui_friends_s_sysm.png")
    else
        self.titleSprite:setSpriteFrame("ui_player_buytl.png")
    end

    if self.detailValue ~= nil then
        self.detailLabel2:setString(self.detailValue)
    else
        self.detailLabel2:setString("购买120点体力，是否继续？")
    end

    if self.fileName == nil then
        local type, money = getTemplateManager():getBaseTemplate():getBuyStaminaMoney()
        print("type_money", type, money)
        if type == 1 then
            self.imgMoney:setSpriteFrame("ui_common_ings.png")
        elseif type == 2 then
            self.imgMoney:setSpriteFrame("ui_common_ingg.png")
        end

        self.labelMoney:setString(string.format("%d", money))
    elseif self.fileName == "pvArenaPanel" then
        local price = self.c_BaseTemplate:getArenaTimePrice()
        self.labelMoney:setString(string.format("%d", price))
    end
end

function PVBuyStamina:clearResource()
    game.removeSpriteFramesWithFile("res/ccb/resource/ui_friend.plist")
end

return PVBuyStamina

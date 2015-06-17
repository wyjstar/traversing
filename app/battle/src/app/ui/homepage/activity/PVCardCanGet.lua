-- 可获取的卡片node
-- setState(state) : 1 未获得， 2 已获得

local PVCardCanGet = class("PVCardCanGet", function ()
	return cc.Node:create()
end)

function PVCardCanGet:ctor(img, day,reward)
	self.img = img
	self.day = day
	self.reward = reward
	self:init()
	self:initView()
end

function PVCardCanGet:init()
	self.ccbiNode = {}
    self:initTouchListener()
    local proxy = cc.CCBProxy:create()
    local node = CCBReaderLoad("common/ui_card_canget.ccbi", proxy, self.ccbiNode)
    self:addChild(node)
end

function PVCardCanGet:initTouchListener()
	local function onMenuCallback()
        print("详情 .....")
   		-- 发送协议
   		local _continTotalSignDay = getDataManager():getCommonData():getContinuousSignDays()
   		if _continTotalSignDay >= self.day then
   			cclog("-------_continTotalSignDay--".._continTotalSignDay.."----self.day ---"..self.day )
   			ACTIVITY_CONTINUOUS_DAY = self.day
   			getDataManager():getCommonData():setCurContinuousSigned(self.reward)
   			getNetManager():getActivityNet():sendContinuousSignMsg(self.day)
   		else
   			-- getOtherModule():showToastView(Localize.query("cardcanget.1"))
   			getOtherModule():showAlertDialog(nil, Localize.query("cardcanget.1"))
   		end
    end
    self.ccbiNode["UICardCanGet"] = {}
    self.ccbiNode["UICardCanGet"]["menuClick"] = onMenuCallback
end

function PVCardCanGet:initView()
	--获取控件
	self.ccbiRootNode = self.ccbiNode["UICardCanGet"]
	self.menuCard = self.ccbiRootNode["menu_img"]
	self.imgGot = self.ccbiRootNode["img_got"]
	self.layColorMask = self.ccbiRootNode["laycolor_mask"]
	self.cumulaDays = self.ccbiRootNode["cumulaDays"]
	self.node_vip = self.ccbiRootNode["node_vip"]

	-- self.node_vip:setVisible(false)
	self:setScale(0.8)
	self:setMenuEnabled(false)
	self.menuCard:setNormalImage(self.img)
	self.cumulaDays:setString(self.day.."\n".."天")
	-- self.menuCard:setAllowScale(false)
end

-- @ param state : 1 未获得， 2 已获得 3 可以获得
function PVCardCanGet:setState(state)
	if state == 1 then 
		self.imgGot:setVisible(false)
		self.layColorMask:setVisible(false)
		self:setMenuEnabled(true)
	elseif state == 2 then
		self:removeChildByTag(100)

		self.imgGot:setVisible(true)
		self.layColorMask:setVisible(true)
		self:setMenuEnabled(false)
	elseif state == 3 then 
		local timeEff = self:getChildByTag(100)
		if timeEff == nil then
			timeEff = UI_Meiriqiandao()
			timeEff:setScale(1.3)
			timeEff:setPosition(cc.p(56,43))
			timeEff:setTag(100)
			print("timeEff ============ timeEff ========== timeEff ========= ")
			self:addChild(timeEff,1003)
		end

		self.imgGot:setVisible(false)
		self.layColorMask:setVisible(false)
		self:setMenuEnabled(true)
	end
end

-- 
function PVCardCanGet:setMenuEnabled(flag)
	self.menuCard:setEnabled(flag)
end

return PVCardCanGet


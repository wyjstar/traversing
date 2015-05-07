--精彩活动 vip礼包
local GiftList = import("src.app.ui.homepage.common.GiftListShowNode")
local PVActivityVipGift = class("PVActivityVipGift",BaseUIView)

function PVActivityVipGift:ctor(id)
	self.super.ctor(self,id)
	self.shopTemplate = getTemplateManager():getShopTemplate()
	
	--self:initBaseUI()
   -- self:initFunc( {...} )
    self:onMVCEnter()
    
    
	-- body
end
function PVActivityVipGift:receiveVipBuy(data)
	if data.res.result == true  then
		cclog("－－－－－－－购买成功－－－－－－")
       getOtherModule():showAlertDialog(nil, "VIP特权礼包购买成功")
       self.m_buyBtn:setEnabled(false)
       getDataManager():getShopData():setCanBuyCurVip(self.itemId["id"])
	end
	
	-- body
end
function PVActivityVipGift:receiveVipData(id,buyed_id)
		
    	local m_vipGift = {}
    	self.rewardList = {}
	    local num = table.getn(id)
	     --for i=1,num do
		m_vipGift["id"] = id
		m_vipGift["buyed_id"] = buyed_id--limitNum[1]
		self.itemId = getDataManager():getShopData():getVipGiftData()
		table.print(self.itemId)
		cclog("购买商品id"..self.itemId["id"])
		self.rewardList = self.shopTemplate:getTemplateById(self.itemId["id"])
        if self.itemId["BuyEnable"] == 0 then
        	self.m_buyBtn:setEnabled(false)
        end
        --设置当前价格
        for k,v in pairs(self.rewardList["consume"]) do
		    self.perPrice = v[1]
		    self.m_labelPrizebefore:setString(string.format("%d",self.perPrice))
	    end
	    for k,v in pairs(self.rewardList["discountPrice"]) do
		    self.nowPrice = v[1]
		    self.m_labelPrizeZhexian:setVisible(true)
	    end
	    if self.nowPrice ==nil then
	    	self.nowPrice =self.perPrice
	    end
	    
	    self.m_labelPrizenow:setString(string.format("%d",self.nowPrice))



		--table.print(self.rewardList)
	     --end
	     -- table.print(self.rewardList["gain"])
	     self.m_giftCell = GiftList.new("GiftListShowNode")
	     local layerSize = self.m_giftListLayer:getContentSize()
	     self.m_giftCell:onMVCEnter(self.rewardList["gain"],false)
	     self.m_giftListLayer:addChild(self.m_giftCell)
	     
	-- body
end
function PVActivityVipGift:onMVCEnter()
    cclog("－－－－－－－PVActivityVipGiftonMVCEnter－－－－－－")    
	self.ccbiNode = {}
	self.ccbiNode["UIActivityGift"] = {}
	self:initTouchListener()
	local proxy = cc.CCBProxy:create()
	local node = CCBReaderLoad("home/ui_activity_vipgift.ccbi", proxy, self.ccbiNode)
	self:addChild(node)
	self:initView()
	getNetManager():getShopNet():sendGetShopList(24)

	


	
	-- body
end
function PVActivityVipGift:init()
    cclog("－－－－－－－PVActivityVipGiftoninit－－－－－－")
	-- body
end

function PVActivityVipGift:initTouchListener()
	
	function ccGotoVip()
		getAudioManager():playEffectButton2()
		cclog("－－－－－－－ccGotoVip－－－－－－")
		getModule(MODULE_NAME_SHOP):showUIViewAndInTop("PVShopRechargeVip")
		-- body
	end
	function ccGotoTopUp()
		getAudioManager():playEffectButton2()
		cclog("－－－－－－－ccGotoTopUp－－－－－－")
		getModule(MODULE_NAME_SHOP):showUIViewAndInTop("PVshopRecharge")
		-- body
	end
	function ccGotoBuy()
		getAudioManager():playEffectButton2()
		local userGold  = getDataManager():getCommonData():getGold()
		cclog("－－－－－－－userGold－－－－－－"..userGold.."      "..self.nowPrice)
		if self.nowPrice > userGold then
		      cclog("－－－－－－－元宝不足－－－－－－")
		      getOtherModule():showConfirmDialog(
              function()--
                getModule(MODULE_NAME_SHOP):showUIViewAndInTop("PVshopRecharge")
               end
              , nil, "所需元宝不足，请先进行充值")
		  else
		  	getNetManager():getShopNet():sendBuyGoods(self.itemId["id"])
	    end
		
		-- body
	end
	self.ccbiNode["UIActivityGift"] = {}
	self.ccbiNode["UIActivityGift"]["ccGotoVip"] = ccGotoVip
	self.ccbiNode["UIActivityGift"]["ccGotoTopUp"] = ccGotoTopUp
	self.ccbiNode["UIActivityGift"]["ccGotoBuy"] =ccGotoBuy
	-- body
end
function PVActivityVipGift:initView()
	cclog("－－－－－－－PVActivityVipGiftinitView－－－－－－")
	self.m_labelVipdes = self.ccbiNode["UIActivityGift"]["ui_activity_vipdes"]
	self.m_labelPrizebefore = self.ccbiNode["UIActivityGift"]["ui_activity_vipgift_prizeBefore"]
	self.m_labelPrizeZhexian = self.ccbiNode["UIActivityGift"]["ui_activity_gift_zhexians"]
	self.m_labelPrizenow = self.ccbiNode["UIActivityGift"]["ui_activity_vipgift_prizeNow"]

	self.m_giftListLayer = self.ccbiNode["UIActivityGift"]["ui_activity_vipgift_giftlayer"]
	self.m_buyBtn = self.ccbiNode["UIActivityGift"]["activity_gift_btnbuy"]
	self.m_vipLevel = self.ccbiNode["UIActivityGift"]["ui_activity_gift_viplevel"]
     local vipLevel = getDataManager():getCommonData():getVip()
     cclog("=========="..string.format("%d", vipLevel)) 
	self.viplevelLabel = cc.LabelAtlas:_create(string.format("%d", vipLevel), "res/ui/ui_common_num.png", 20, 70, string.byte("0"))
     self.viplevelLabel:setAnchorPoint(0.5,0.5)
     self.viplevelLabel:setPosition(0,-20)
     self.m_vipLevel:addChild(self.viplevelLabel)
	-- body
end
return PVActivityVipGift











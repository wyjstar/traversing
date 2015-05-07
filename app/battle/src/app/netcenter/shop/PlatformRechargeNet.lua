--平台支付网络通信


local PlatformRechargeNet = class("PlatformRechargeNet", BaseNetWork)

--googleplay 支付
PAY_GOOGLEPLAY_GET_GENERATEID_CODE = 10000      --请求订单ID
PAY_GOOGLEPLAY_CONSUME_CODE = 10001      	    --消费成功通知服务器
PAY_GOOGLEPLAY_CONSUMEVERIFY_CODE = 10002       --验证消费商品，加元宝


function PlatformRechargeNet:ctor()
	self.super.ctor(self, "PlatformRechargeNet")
	self:initRegisterNet()
end


-- googleplay 请求订单
function PlatformRechargeNet:sendGoogleGenerateID(channel)
	print("-----GoogleGenerateIDRequest----",channel)
	local data = {channel = channel}
	self:sendMsg( PAY_GOOGLEPLAY_GET_GENERATEID_CODE, "GoogleGenerateIDRequest", data )
end

-- googleplay 验证商品
function PlatformRechargeNet:sendGoogleConsumeVerify(data)
	print("-----GoogleConsumeVerifyRequest----",data)
	self:sendMsg( PAY_GOOGLEPLAY_CONSUMEVERIFY_CODE, "GoogleConsumeVerifyRequest", data )
end

-- googleplay 消费成功，添加元宝
function PlatformRechargeNet:sendGoogleConsume(data)
	print("-----GoogleConsumeRequest----",data)
	local data = {data = data}
	self:sendMsg( PAY_GOOGLEPLAY_CONSUME_CODE, "GoogleConsumeRequest", data )
end


--注册接受网络协议
function PlatformRechargeNet:initRegisterNet()
	--- google 支付
	local function getGoogleGenerateIDCallback( data )  -- 获取订单
		print("------getGoogleGenerateIDCallback-------")
		getPlatformRechargeManager():googlePlay_payStart(data.uid)
	end

	local function getGoogleConsumeVerifyCallback( data )  -- 验证商品
		print("------getGoogleConsumeVerifyCallback-------")
        table.print(data.gain)
        if data.res.result == true then 
        	--添加元宝
        	getDataProcessor():gainGameResourcesResponse(data.gain)
        	getHomeBasicAttrView():updateGold()
        	getOtherModule():showAlertDialog(nil, Localize.query("recharge.1"))    --Localize.query("recharge.2")	
        else
        	getOtherModule():showAlertDialog(nil, Localize.query("recharge.2"))    --Localize.query("recharge.2")
        end
	end

	local function getGoogleConsumeCallback( data )  -- 消耗
		print("------getGoogleConsumeVerifyCallback-------")
        table.print(data)
        if data.res.result == true then 
        	getPlatformRechargeManager():googlePlay_payEnd()
        else
        	print("----------消耗失败------------")
        	-- getPlatformRechargeManager():googlePlay_payEnd()
        end
	end

	self:registerNetMsg(PAY_GOOGLEPLAY_GET_GENERATEID_CODE, "GoogleGenerateIDResponse", getGoogleGenerateIDCallback) -- 获取订单
	self:registerNetMsg(PAY_GOOGLEPLAY_CONSUMEVERIFY_CODE, "GoogleConsumeVerifyResponse", getGoogleConsumeVerifyCallback) -- 验证商品
	self:registerNetMsg(PAY_GOOGLEPLAY_CONSUME_CODE, "GoogleConsumeResponse", getGoogleConsumeCallback) -- 消耗
end


--@return 
return PlatformRechargeNet


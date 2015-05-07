--装备网络

local EquipNet = class("EquipNet", BaseNetWork)


EQU_REQUEST_CODE = 401  -- 请求装备列表
EQU_ENHANCE_CODE = 402  -- 装备强化
EQU_COMPOSE_CODE = 403  -- 装备合成
-- EQU_NOBBING_CODE = 404  -- 装备锤炼
EQU_MELTING_CODE = 405  -- 装备熔炼

EQU_CHIPS_CODE = 407    -- 装备碎片


function EquipNet:ctor()

	self.super.ctor(self, self.__cname)
	self:init()

	self:initRegisterNet()
end

function EquipNet:init()

end

--请求装备列表
function EquipNet:sendGetEquipMsg()	
	local data = {type = 0}
	print("send to Get Equipment List")
	self:sendMsg( EQU_REQUEST_CODE, "GetEquipmentsRequest", data )
end

--请求装备碎片列表
function EquipNet:sendGetChipsMsg()
	print("send to Get Equipment Chips List")
	self:sendMsg(EQU_CHIPS_CODE)
end

--请求装备强化
--@param ID: equipment id
--@param Type: 1,强化；2，自动强化
--@param Times: 类型1使用，强化次数
function EquipNet:sendEnHanceMsg(ID, Type) 	
	print("send EnHance MSG", ID, Type)
	local data = {id = ID}
	if Type ~= nil then data.type= Type end
	-- if Times ~= nil then data.num = Times end
	self:sendMsg(EQU_ENHANCE_CODE, "EnhanceEquipmentRequest", data)
end

--请求装备合成
--@param strNo: 装备碎片No
function EquipNet:sendComposeMsg(strNo)
	local data = {no = strNo}
	self:sendMsg( EQU_COMPOSE_CODE, "ComposeEquipmentRequest", data )
end
--[[
--请求装备锤炼
function EquipNet:sendNobbingMsg(ID)
	
	local data = {id = ID}

	self:sendMsg( EQU_NOBBING_CODE, "NobbingEquipmentRequest", data )
end
]]
--装备熔炼
-- @ param IDs : 装备id表
function EquipNet:sendMeltingMsg(IDs)
	print("send melting request ....")
	-- table.print(IDs)
	local data = {id=IDs}
	-- for k,v in pairs(IDs) do
	-- 	table.insert(data, {id=v})
	-- end
	self:sendMsg( EQU_MELTING_CODE, "MeltingEquipmentRequest", data )
end


--注册接受网络协议
function EquipNet:initRegisterNet()

	local function getEquipCallback( data )  --接收全部装备列表
		-- print("equpment callback ...")
		-- for k,v in pairs(data.equipment) do
		-- 	table.print(v.main_attr)
		-- end

		table.remove(g_netResponselist)
		
		if data.res.result ~= true then   -- to do
			print("!!! 数据返回错误")
		else 
			print("<<<== 从服务器获取到Equipment列表 ==>>>")

		    local equips = data.equipment
		    if equips then 
		        for k,var in pairs(equips) do
		            getDataManager():getEquipmentData():addEquip(var)
		        end

		    end
		end
	end

	local function getChipsCallback( data ) --接收获取装备碎片列表
		print("<<<== 从服务器获取到Chips列表 ==>>>")
		-- table.print(data)
		table.remove(g_netResponselist)
		
		local chips = data.equipment_chips
		if chips then 
	        -- for k,var in pairs(chips) do
	        --     -- print("process ... chips data ", k, var, var.equipment_chip_no)
	        --     getDataManager():getEquipmentData():addChip(var)
	        -- end
	        getDataManager():getEquipmentData():setEquipChipData(chips)
		end
	end

	local function getEnhanceCallback( data )  --接收装备强化结果
		-- -- table.print(data)
		-- -- print(data.res.result)
		-- if data.res.result ~= true then
		-- 	print("!!! 数据返回错误")
		-- else
		-- 	print("<<<== 强化装备处理返回的数据 ==>>>")

		-- 	-- local enhanceData = data.data[1]
		-- 	-- if enhanceData then
		-- 	--     getDataManager():getCommonData():subCoin(enhanceData.cost_coin)
		-- 	--     getDataManager():getEquipmentData():setStrengLv(enhanceData.after_lv)
		-- 	-- end
		-- end
	end

	local function getComposeCallback( data )  --接收合成结果
		-- table.print(data)
		if data.res.result ~= true then
			print("!!! 数据返回错误")
		else -- 返回正确
			print("<<<== 合成装备处理返回的数据 ==>>>")

			local composeData = data.equ
			if composeData then
				-- 消耗的碎片在UI上处理
		        getDataManager():getEquipmentData():addEquip(composeData)
			end
		end
	end

	local function getMeltingCallback( data )  --接收熔炼结果
		print("-------------smelting response")
	    table.print(data)
	    if data.res.result ~= true then
	    	print("!!! 数据返回错误")
	    else
	    	print("<<<== 熔炼装备处理返回的数据 ==>>>")
	    	-- 装备的Datacter中的移除在UI处理
		    getDataProcessor():gainGameResourcesResponse(data.cgr)  -- 获得物品
	    end 
	end

	self:registerNetMsg(EQU_REQUEST_CODE, "GetEquipmentResponse", getEquipCallback)         -- 401
	self:registerNetMsg(EQU_CHIPS_CODE, "GetEquipmentChipsResponse", getChipsCallback)

	self:registerNetMsg(EQU_ENHANCE_CODE, "EnhanceEquipmentResponse", getEnhanceCallback)
	self:registerNetMsg(EQU_COMPOSE_CODE, "ComposeEquipmentResponse", getComposeCallback)   -- 403
--	self:registerNetMsg(EQU_NOBBING_CODE, "NobbingEquipmentResponse", getNobbingCallback)
	self:registerNetMsg(EQU_MELTING_CODE, "MeltingEquipmentResponse", getMeltingCallback)

end


--@return 
return EquipNet


-- --装备
--[[
-- Socket.EQU_REQUEST_RESPONSE = 401
-- Socket.EQU_ENHANCE_RESPONSE = 402
-- Socket.EQU_COMPOSE_RESPONSE = 403
-- Socket.EQU_NOBBING_RESPONSE = 404
-- Socket.EQU_MELTING_RESPONSE = 405
请求装备列表	401	 equipment.proto / GetEquipmentsRequest	 equipment.proto / GetEquipmentResponse
 装备强化	 	402	 equipment.proto / EnhanceEquipmentRequest	 equipment.proto / EnhanceEquipmentResponse
 装备合成	 	403	 equipment.proto / ComposeEquipmentRequest	 equipment.proto / ComposeEquipmentResponse
 装备锤炼	 	404	 equipment.proto / NobbingEquipmentRequest	 equipment.proto / NobbingEquipmentResponse
 装备熔炼 	405	 equipment.proto / MeltingEquipmentRequest	 equipment.proto / MeltingEquipmentResponse
 ]]
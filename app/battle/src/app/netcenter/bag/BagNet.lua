--背包
local processor = import("..DataProcessor")

BagNet = class("BagNet", BaseNetWork)

function BagNet:ctor()
    self.super.ctor(self, "BagNet")
    self:init()
end

function BagNet:init()
    self.bagData = getDataManager():getBagData()
    --self.commonData = getDataManager():getCommonData()
    self:registerBagNet()
end

--发送获取道具列表的协议
function BagNet:sendGetPropList()
    self:sendMsg(BAG_GET_DATA)
end

--发送道具使用协议
function BagNet:sendUseProp(cur_item_no, cur_item_num)
    self.cur_item_no = cur_item_no
    self.cur_item_num = cur_item_num
    local data = {
                    item_no = cur_item_no,
                    item_num = cur_item_num
                }

    -- table.print(data)

    self:sendMsg(PROP_USE, "ItemPB", data)
end

--注册协议返回回调函数
function BagNet:registerBagNet()
    --道具数据获取
    local function getPropList(data)
        self.bagData.propItems = {}
        self.bagData:setData(data)
        table.remove(g_netResponselist)
    end

    self:registerNetMsg(BAG_GET_DATA, "GetItemsResponse", getPropList)

    --道具使用回调
    local function getUseProp(data)
        -- table.print(data.gain)
        -- print(self.cur_item_num.."=self.cur_item_no="..self.cur_item_no)
        -- local _no = tonumber(self.cur_item_no)
        -- print(_no)
        -- if _no == 40001 then    -- 小金币袋
        --     getDataManager():getCommonData():addCoin(self.cur_item_num*100)
        -- elseif _no == 40002 then -- 金币袋
        --      getDataManager():getCommonData():addCoin(self.cur_item_num*1000)
        -- elseif _no == 40003 then
        --      getDataManager():getCommonData():addCoin(self.cur_item_num*10000)
        -- elseif _no == 40004 then
        --      getDataManager():getCommonData():addCoin(self.cur_item_num*50)
        -- elseif _no == 40005 then
        --      getDataManager():getCommonData():addCoin(self.cur_item_num*500)
        -- elseif _no == 40006 then
        --      getDataManager():getCommonData():addCoin(self.cur_item_num*5000)
        -- elseif _no == 40007 then
        --      getDataManager():getCommonData():addCoin(self.cur_item_num*1000)
        -- elseif _no == 40008 then
        --      getDataManager():getCommonData():addCoin(self.cur_item_num*1000)
        -- end

        processor:setCommonResponse(data.res)
        if data.res.result then
            self.bagData:updatePropItem(self.cur_item_no, self.cur_item_num)
            processor:gainGameResourcesResponse(data.gain)
        end


        --self.commonData:setResourcesResponseGainData(data.gain)
    end
    self:registerNetMsg(PROP_USE, "ItemUseResponse", getUseProp)
end

return BagNet

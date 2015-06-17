-- 头像item

local PVHeadHead = class("PVHeadHead", function()
    return cc.TableViewCell:new() 
    end)

function PVHeadHead:ctor()
    
end

function PVHeadHead:initData(id, delegate)

    print("------------------- "..id.." ----------------------")

    self.id = id
    self.delegate = delegate
    self:initView()
    self:updateUI()

end

function PVHeadHead:initView()

    cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA4444)

    self.UIHeadHead = {}
    self.UIHeadHead["UIHeadHead"] = {}

    local _ccbProxy = cc.CCBProxy:create()
    local cellItem = nil

    self:initTouchListener()
    
    cellItem = CCBReaderLoad("head/ui_head_head.ccbi", _ccbProxy, self.UIHeadHead)
    self:addChild(cellItem)

    self.isShanSp = self.UIHeadHead["UIHeadHead"]["isShanSp"]
    self.isUsingSp = self.UIHeadHead["UIHeadHead"]["isUsingSp"]
    self.spKuang = self.UIHeadHead["UIHeadHead"]["spKuang"]

    self.menu_img = self.UIHeadHead["UIHeadHead"]["menu_img"]


    -- local resIcon = getTemplateManager():getSoldierTemplate():getSoldierIcon(self.id)
    -- print(resIcon)
    local quality = getTemplateManager():getSoldierTemplate():getHeroQuality(self.id)
    -- if resIcon == 0 then
    -- end

    -- self.menu_img:setTexture("res/icon/hero/"..resIcon)

    local resIcon = getTemplateManager():getSoldierTemplate():getSoldierHead(self.id)
    self.menu_img:removeAllChildren()
    self.menu_img:setTexture("res/icon/hero_head/"..resIcon)
    self.menu_img:setScale(0.8)    
    self.spKuang:setVisible(false)

   
    -- if quality == 1 or quality == 2 then
    --     game.setSpriteFrame(self.spKuang, "#ui_common_frameg.png")
    -- elseif quality == 3 or quality == 4 then
    --     game.setSpriteFrame(self.spKuang, "#ui_common_framebu.png")
    -- elseif quality == 5 or quality == 6 then
    --     game.setSpriteFrame(self.spKuang, "#ui_common_framep.png")
    -- end

    -- local function onNodeEvent(event)
    --     if "exit" == event then
    --         self:onExit()
    --     end
    -- end
    -- self:registerScriptHandler(onNodeEvent)

    cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA8888)

end

function PVHeadHead:initTouchListener()

    -- local function menuClick()
    --     print("点击")
    --     self.delegate:setHeadId(self.id)
    --     getNetManager():getHeadNet():sendChangeHead(self.id)
    -- end

    self.UIHeadHead["UIHeadHead"] = {}
    -- self.UIHeadHead["UIHeadHead"]["menuClick"] = menuClick
end

function PVHeadHead:onExit()
    -- self:unregisterScriptHandler()
end

-- 根据传过来的数据更新UI
function PVHeadHead:updateUI()
    
    -- local heropb = getDataManager():getLineupData():getSlotItemBySeat(1)
    local heroNo = getDataManager():getCommonData():getHead()
    if heroNo ~= nil then
        -- local heroNo = heropb.hero.hero_no
        if self.id == heroNo then
            -- print("正在使用")
            self.isUsingSp:setVisible(true)
            self.isShanSp:setVisible(true)
        else
            -- print("没有使用")
            self.isUsingSp:setVisible(false)
            self.isShanSp:setVisible(false)
        end
    end

end


-- --网络返回
-- function PVHeadHead:initRegisterNetCallBack()
--     -- local function onReciveMsgCallBack(_id)
--     --     if _id == NET_ID_HEAD_CHANGE then  self:changeHeadCallBack()   end 
--     -- end

--     -- self:registerMsg(NET_ID_HEAD_CHANGE, onReciveMsgCallBack)
-- end

-- function PVHeadHead:changeHeadCallBack()
--     print("===================  changeHeadCallBack  ================================")

--     local changeHeadResponse = getDataManager():getTravelData():getBuyShoesResponse()
--     if changeHeadResponse.res.result == false then
--         self:toastShow("更换头像失败")
--         return
--     end
--     self:toastShow("更换头像成功")

--     getDataManager():getCommonData():setHead(self.id)

-- end

return PVHeadHead

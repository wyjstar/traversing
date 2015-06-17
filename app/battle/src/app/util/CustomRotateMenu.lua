--还未完成
--旋转菜单

local CustomRotateMenu = class("CustomRotateMenu",Layer)
--动画运行时间
local animationDuration = 0.3

function CustomRotateMenu:ctor()
	--角度 弧度
	self.angle = 0
	--单位角度 弧度
    self.unitAngle = 0
    --菜单项集合,_children顺序会变化，新建数组保存顺序
    self.itemsTable = {}
    --当前被选择的item
    self.selectedItem = nil

    self:init()

	self:addLayerTouchEvent()

	

  
end

--添加菜单项
function CustomRotateMenu:addMenuItem(menuItem)
	menuItem:setPosition(self:getContentSize() / 2)
	self:addChild(menuItem)
	table.insert(self.itemsTable,menuItem)
	self.unitAngle = 2*PI / table.getn(self.itemsTable)
	self:reset()
	self:updatePositionWithAnimation()
end

--更新位置
function CustomRotateMenu:updatePosition()
  	local menuSize = self:getContentSize()
  	local disY = menuSize.height / 8
  	local disX = menuSize.width / 3
  	for k,v in pairs(self.itemsTable) do
  		local x = menuSize.width / 2 + disX * math.sin(k * self.unitAngle + self.angle)
  		local y = menuSize.height / 2 - disY * math.cos(k * self.unitAngle + self.angle)
  		v:setPosition(x,y)
  		v:setZOrder(-y)
  		v:setOpacity(192 + 63 * math.cos(k*self.unitAngle + self.angle))
  		v:setScale(0.75 + 0.25 * math.cos(k*self.unitAngle + self.angle))
  	end
end

--更新位置，有动画
function CustomRotateMenu:updatePositionWithAnimation()
-- body
end

--位置矫正  修改角度 forward为移动方向  当超过1/3，进1
--true 为正向  false 负
function CustomRotateMenu:rectify(forward)
-- body
end

function CustomRotateMenu:init()

    self:ignoreAnchorPointForPosition(false)
    local s = cc.Director:getInstance():getWinSize()
    self:setContentSize(s/3*2)
    self:setAnchorPoint(cc.p(0.5,0.5))

end

--重置  操作有旋转角度设为0
function CustomRotateMenu:reset()
-- body
end

function CustomRotateMenu:addLayerTouchEvent()
    local function onTouchEvent(eventType, x, y)
        if eventType == "began" then 
            
            return true
        elseif eventType == "moved" then 
            
        elseif eventType == "ended" then 
            
        end
    end
    self:setTouchEnabled(true)
    self:registerScriptTouchHandler(onTouchEvent)
end


--滑动距离转换角度,转换策略为  移动半个Menu.width等于_unitAngle
--float disToAngle(float dis);
function disToAngle(dis)
	-- body
end
  
--返回被选中的item
--cocos2d::MenuItem * getCurrentItem();
function getCurrentItem()
	-- body
end

--动画完结调用函数
--actionEndCallBack(float dx);
function actionEndCallBack(dx)
	-- body
end

return CustomRotateMenu

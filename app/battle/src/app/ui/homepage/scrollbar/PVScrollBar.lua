--列表中的进度条
local PVScrollBar = class("PVScrollBar", function ()
	return cc.Layer:create()
end)


DIR_NODIR = 0
DIR_VERTICAL = 1
DIR_HORIZENTAL = 2


function PVScrollBar:ctor()
	 local function onNodeEvent(event)
        if "exit" == event then
            self:onExit()
        end
    end
    self:registerScriptHandler(onNodeEvent)
end

function PVScrollBar:onExit()
    cclog("----------PVScrollBar:onExit--------")
    if self.scheduleSlider ~= nil then
        timer.unscheduleGlobal(self.scheduleSlider)
        self.scheduleSlider = nil
    end
end
--传入一个tableview对象，滚动条背景的九妹图和滚动块的九妹图，和滚动条的方向
-- function PVScrollBar:init(tabView,ScroBg,ScroSlider,dire)
-- 	self.pTarget = tabView    								--tableview列表
-- 	self.pBg = ScroBg 		 								--滚动条背景图
-- 	self.pSlider = ScroSlider								--滚动条slider
-- 	self.direction = dire									--滚动条方向
-- 	self.preContentSize = self.pTarget:getContainer():getContentSize()
-- 	self.viewSize = self.pTarget:getViewSize()
-- 	self.sliderTouched = false

-- 	if self.direction == DIR_VERTICAL then
-- 		self.pBg:setContentSize(cc.size(self.pBg:getContentSize().width,self.viewSize.height))
-- 		self.pBg:setPosition(cc.p(self.pBg:getContentSize().width / 2,0))
-- 		self.pSlider:setPositionX(self.pBg:getContentSize().width / 2)
-- 	elseif self.direction == DIR_HORIZENTAL then
-- 		self.pBg:setContentSize(cc.size(self.viewSize.width,self.pBg:getContentSize().height));
-- 		self.pBg:setPosition(cc.p(0,-self.pBg:getContentSize().height / 2));
-- 		self.pSlider:setPositionY(-self.pBg:getContentSize().height / 2);
-- 	end

-- 	self:addChild(self.pBg,0)
	
-- 	self:addChild(self.pSlider,1)
-- 	self:updateSlider()

-- 	self:initSchedule()
-- 	self:initOntouchEvent()

-- end

function PVScrollBar:init(tabView,dire)
	-- print("-------tabView-----",tabView)
	self.pTarget = tabView  
	-- print("-------self.pTarget-----11111",self.pTarget) --tableview列表
					
	self.direction = dire									--滚动条方向
	self.preContentSize = self.pTarget:getContainer():getContentSize()
	self.viewSize = self.pTarget:getViewSize()
	self.sliderTouched = false

	if self.direction == DIR_VERTICAL then
		self.pBg = cc.Scale9Sprite:create("res/ui/vr_slider_bg.png") 		 								--滚动条背景图
		self.pSlider = cc.Scale9Sprite:create("res/ui/vr_slider.png")	
		self.pBg:setContentSize(cc.size(self.pBg:getContentSize().width,self.viewSize.height))
		self.pBg:setPosition(cc.p(self.pBg:getContentSize().width / 2,0))
		self.pSlider:setPositionX(self.pBg:getContentSize().width / 2)
	elseif self.direction == DIR_HORIZENTAL then
		self.pBg = cc.Scale9Sprite:create("res/ui/vr_slider_bg2.png") 		 								--滚动条背景图
		self.pSlider = cc.Scale9Sprite:create("res/ui/vr_slider2.png")	
		self.pBg:setContentSize(cc.size(self.viewSize.width,self.pBg:getContentSize().height));
		self.pBg:setPosition(cc.p(0,-self.pBg:getContentSize().height / 2));
		self.pSlider:setPositionY(-self.pBg:getContentSize().height / 2);
	end

	self:addChild(self.pBg,0)
	
	self:addChild(self.pSlider,1)
	self:updateSlider()

	self:initSchedule()
	self:initOntouchEvent()

end

function PVScrollBar:updateSlider()
	local ratio = 0
	if self.direction == DIR_VERTICAL then
		 ratio = self.viewSize.height / self.preContentSize.height
		 if (self.viewSize.height * ratio) < 30 then
		 	self.pSlider:setContentSize(cc.size(self.pSlider:getContentSize().width,30))
		 else
		 	self.pSlider:setContentSize(cc.size(self.pSlider:getContentSize().width,self.viewSize.height * ratio)) 
		 end
	elseif self.direction == DIR_HORIZENTAL then
		ratio = self.viewSize.width / self.preContentSize.width
		self.pSlider:setContentSize(cc.size(self.viewSize.width * ratio,self.pSlider:getContentSize().height))
	end
	self:setVisible( not(ratio >= 1) )
end

function PVScrollBar:initSchedule()

	local function updateTimer()
		if self.pTarget == nil then return end
		local curContentSize = self.pTarget:getContainer():getContentSize()
		if ( not(math.abs(curContentSize.height - self.preContentSize.height) <= 0.00001) or (not(math.abs(curContentSize.width - self.preContentSize.width) <= 0.00001))) then
			self.preContentSize = curContentSize
			self:updateSlider()
		end

		if self.direction == DIR_VERTICAL then
			local curOffsetX = self.pTarget:getContentOffset().x + (self.preContentSize.width - self.viewSize.width) / 2
			local curOffsetY = self.pTarget:getContentOffset().y + (self.preContentSize.height - self.viewSize.height) / 2

			local sliderOffset = curOffsetY / (self.viewSize.height - curContentSize.height) * 
				(self.viewSize.height - self.pSlider:getContentSize().height);
			
			if (math.abs(sliderOffset) > (self.viewSize.height - self.pSlider:getContentSize().height) / 2) then
				return
			end
		
			self.pSlider:setPositionY(sliderOffset)
		
		elseif self.direction == DIR_HORIZENTAL then
			local curOffsetX = self.pTarget:getContentOffset().x + (self.preContentSize.width - self.viewSize.width) / 2
			local curOffsetY = self.pTarget:getContentOffset().y + (self.preContentSize.height - self.viewSize.height) / 2

			local sliderOffset = -curOffsetX / (self.viewSize.width - curContentSize.width) * 
				(self.viewSize.width - self.pSlider:getContentSize().width);
			if (math.abs(sliderOffset) > (self.viewSize.width - self.pSlider:getContentSize().width) / 2) then
				return 
			end
			
			self.pSlider:setPositionX(-sliderOffset)
		end
	end
	
	if self.scheduleSlider == nil then self.scheduleSlider = timer.scheduleGlobal(updateTimer, 1/60) end
end

function PVScrollBar:initOntouchEvent()
	local function onTouchEvent(eventType, x, y)
    	if eventType == "began" then
            -- cclog("-----PVScrollBar began-----")
            self.sliderCurPosX,self.sliderCurPosY = self.pSlider:getPosition();
			self.targetCurPos = self.pTarget:getContentOffset()
			self.firTouPointX = x
			self.firTouPointY = y
			local touchPoint = self:convertToNodeSpace(cc.p(x,y))
			local rectArea1 = self.pBg:getBoundingBox()
			local rectArea2 = self.pSlider:getBoundingBox()

			if (not cc.rectContainsPoint(rectArea1, touchPoint))then
				-- cclog("---------------false-------")
				return false
			end
			
			if cc.rectContainsPoint(rectArea2, touchPoint) then
				self.sliderTouched = true
			else
				if self.direction == DIR_VERTICAL then
					local offset = touchPoint.y - self.sliderCurPosY
					if touchPoint.y <= 0 then
						offset = offset + self.pSlider:getContentSize().height/2
					else
						offset = offset - self.pSlider:getContentSize().height/2
					end
					local newoff = self.targetCurPos.y + offset / (self.pSlider:getContentSize().height - self.viewSize.height) *(self.preContentSize.height - self.viewSize.height)
					local posx = self.pTarget:getPositionX()
					self.pTarget:setContentOffset(cc.p(-posx,newoff))

				elseif self.direction == DIR_HORIZENTAL then

					local offset = touchPoint.x - self.sliderCurPosY
					if touchPoint.x <= 0 then
						offset = offset + self.pSlider:getContentSize().width/2
					else
						offset = offset - self.pSlider:getContentSize().width/2
					end
					local newoff = self.targetCurPos.x + offset / (self.viewSize.width - self.pSlider:getContentSize().width)*(self.preContentSize.width -self.viewSize.width)
					self.pTarget:setContentOffset(cc.p(newoff,0))
				end
			end
			return true
        elseif  eventType == "moved" then
            -- cclog("-----PVScrollBar moved-----")
            if self.sliderTouched then
		        local offposX = x - self.firTouPointX
		        local offposY = y - self.firTouPointY
		        if self.direction == DIR_VERTICAL then
		        	local newoff = self.sliderCurPosY + offposY
		        	 if math.abs(newoff) > (self.viewSize.height - self.pSlider:getContentSize().height)/2 then
		        	 	if newoff < 0 then
		        	 		newoff = (self.pSlider:getContentSize().height - self.viewSize.height)/2
		        	 	else
		        	 		newoff = (self.viewSize.height - self.pSlider:getContentSize().height)/2
		        	 	end
		        	 end
		        	 newoff = newoff - self.sliderCurPosY
		        	 local posoff = self.targetCurPos.y + newoff / (self.pSlider:getContentSize().height - self.viewSize.height)*(self.preContentSize.height - self.viewSize.height)
		        	 local posx = self.pTarget:getPositionX()
		        	 self.pTarget:setContentOffset(cc.p(-posx,posoff))
		        	 
		        elseif self.direction == DIR_HORIZENTAL then
		        	local newoff = self.sliderCurPosX + offposY
					if (math.abs(newoff) > (self.viewSize.width - self.pSlider:getContentSize().width) / 2) then
						if newoff < 0 then
							newoff = (self.pSlider:getContentSize().width - self.viewSize.width) / 2
						else
							newoff = (self.viewSize.width - self.pSlider:getContentSize().width) / 2
						end
					end
					newoff = newoff - self.sliderCurPosX
					local posoff = self.targetCurPos.x + newoff / (self.viewSize.width - self.pSlider:getContentSize().width) * (self.preContentSize.width - self.viewSize.width)
					self.pTarget:setContentOffset(cc.p(posoff,0))
		        end
		    end

        elseif  eventType == "ended" then
            -- cclog("-----PVScrollBar ended-----")
            self.sliderTouched = false
        end
    end
    self:setTouchEnabled(true)
    self:setTouchMode(cc.TOUCHES_ONE_BY_ONE)
    self:registerScriptTouchHandler(onTouchEvent)
end


return PVScrollBar
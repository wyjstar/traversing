
local PVCommonTipsLevel = class("PVCommonTipsLevel", BaseUIView)

function PVCommonTipsLevel:ctor(id)
	print("----------- PVCommonTipsLevel:ctor(id) ---------------")
    PVCommonTipsLevel.super.ctor(self, id)

    self.UICommonTipsLevel = {}
    --加载本界面的ccbi ui_shop.ccbi
    self:loadCCBI("common/ui_common_tips_level.ccbi", self.UICommonTipsLevel)

    --添加可购买的列表TableView
    self:initView()

end

function PVCommonTipsLevel:initDate(level)
	-- self:initView()
	if level > 9 then
		print("-------- level >9 ----------")
		self.levelSp1:setVisible(true)
		game.setSpriteFrame(self.levelSp1, "#ui_common_num_"..roundNumber(level/10)..".png")
		game.setSpriteFrame(self.levelSp2, "#ui_common_num_"..(level%10)..".png")
	else
		self.levelSp1:setVisible(false)
		game.setSpriteFrame(self.levelSp2, "#ui_common_num_"..level..".png")
    end
end

-- 根据关卡开启
function PVCommonTipsLevel:initDateByStage(stageId)
	
end

function PVCommonTipsLevel:initView()
	print("------------ PVCommonTipsLevel:initView ---------------")
    self.levelSp1 = self.UICommonTipsLevel["UICommonTipsLevel"]["levelSp1"]
    self.levelSp2 = self.UICommonTipsLevel["UICommonTipsLevel"]["levelSp2"]

end

function PVCommonTipsLevel:initTouchListener()
end

return PVCommonTipsLevel

--装备唤醒

local PVEquipmentAwaken = class("PVEquipmentAwaken", BaseUIView)

function PVEquipmentAwaken:ctor(id)
    PVEquipmentAwaken.super.ctor(self, id)

end

function PVEquipmentAwaken:onMVCEnter()
 

    self.UIEquipmentAwaken = {}
    
    self:initTouchListener()

    self:loadCCBI("equip/ui_equipment_awaken.ccbi", self.UIEquipmentAwaken)

    self:initView()
end 

function PVEquipmentAwaken:initView()
    self.animationManager = self.UIEquipmentAwaken["UIEquipmentAwaken"]["mAnimationManager"]
    
end

function PVEquipmentAwaken:initData()

end

function PVEquipmentAwaken:registerNetCallback()

    local function getAwakenResponse()
        print("response equipment awaken---------------------------------")
    end

    --self:registerMsg(, getAwakenResponse)  -- to do
end


function PVEquipmentAwaken:initTouchListener()
    local function backMenuClick()
       self:onHideView()
    end

    local function awakenMenuClick()
       -- local msg = "觉醒成功"
       getModule(MODULE_NAME_OTHER):showUIView("PVPopTips", msg)
    end

    self.UIEquipmentAwaken["UIEquipmentAwaken"] = {}
    self.UIEquipmentAwaken["UIEquipmentAwaken"]["backMenuClick"] = backMenuClick
    self.UIEquipmentAwaken["UIEquipmentAwaken"]["awakenMenuClick"] = awakenMenuClick
end

return PVEquipmentAwaken

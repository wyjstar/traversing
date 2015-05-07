
-- 邮箱详情查看界面

local PVEmailDetail = class("PVEmailDetail", BaseUIView)

function PVEmailDetail:ctor(id)
    self.super.ctor(self, id)

end

function PVEmailDetail:onMVCEnter()
    self.UIMaildetail = {}

    self:initData()

    self:initTouchListener()

    self:loadCCBI("email/ui_mail_m_detail.ccbi", self.UIMaildetail)

    self:initView()

end

function PVEmailDetail:initData()
    assert(self.funcTable, "PVEmailDetail must not be nil !")
    self.parentObject = self.funcTable[1]
    self.mail = self.funcTable[2]
end

function PVEmailDetail:initTouchListener()
    function onCloseClick()
        --查看后直接删除邮件
        local data = {}
        data.mail_ids = {}
        data.mail_type = 4
        table.insert(data.mail_ids, self.mail.mail_id)
        self.parentObject.emailNet:sendReadEmail(data)
        self.parentObject.reciveEmailList = data
        --关闭弹窗
        self:onHideView()
    end

    self.UIMaildetail["UIMaildetail"] = {}
    self.UIMaildetail["UIMaildetail"]["onCloseClick"] = onCloseClick
end

function PVEmailDetail:initView()
    self.itemDetailLabel = self.UIMaildetail["UIMaildetail"]["itemDetail"]
    self.itemDetailLabel:setString(self.mail.content)
end

return PVEmailDetail

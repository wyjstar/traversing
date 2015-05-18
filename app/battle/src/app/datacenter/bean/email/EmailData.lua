
local EmailData = class("EmailData")

function EmailData:ctor()

	self.emaillist = {}				-- 邮件列表
    self.target = 30                 -- 每日可领取好友赠送活动上限
    self.current = 0                -- 当日已领取好友赠送活力次数

end

--[[
//邮件基本信息
message Mail_PB
{
    required string mail_id = 1; // ID
    optional int32 sender_id = 2; //发件人ID
    optional string sender_name = 3; //发件人
    optional int32 receive_id = 4; //收件人ID
    optional string receive_name = 5; //收件人
    optional string title = 6; //标题
    optional string content = 7; //邮件内容
    required int32 mail_type = 8; //邮件类型
    optional int32 send_time = 9; //发件时间
    optional bool is_readed = 10; //是否已读
    optional string prize = 11; //奖品
    optional int32 config_id   //
}
]]

-- 新增一个邮件
function EmailData:addEmail(email)
	self.emaillist[email.mail_id] = email
end

-- 获取某封邮件数据
function EmailData:getEmailById(id)
	return self.emaillist[id]
end

-- 获取更个邮件列表
function EmailData:getEmailList()
    return self.emaillist
end

-- 从已拉取的邮件中移除掉邮件
function EmailData:removeEmail(emailId)
    self.emaillist[emailId] = nil
end

-- 标记邮件为已读
function EmailData:readEmail(emailId)
    self.emaillist[emailId].is_readed = true
end

function EmailData:clearData()
	self.emaillist = {}
end

function EmailData:setRate(data)
    if data.target ~= 0 then
        self.target = data.target
        self.current = data.current
    end
end


return EmailData


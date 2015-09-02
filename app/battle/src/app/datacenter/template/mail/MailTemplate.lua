--[1] = {
--    ["content"] = "3100000001",  ["icon"] = 0,  ["id"] = 1,  ["type"] = 1,  ["rewards"] = {
--        ["7"] = {
--        [1] = 2,  [2] = 2,  [3] = 0,}
--        ,}
--    ,  ["nameId"] = 0,  ["title"] = "0",}

local MailTemplate = MailTemplate or class("MailTemplate")
import("..config.mail_config")

function MailTemplate:ctor(controller)
    self.c_ResourceTemplate = getTemplateManager():getResourceTemplate()
    self.c_LanguageTemplate = getTemplateManager():getLanguageTemplate()
end

--获取邮件信息
function MailTemplate:getMailTypeById(mail_id)
    return mail_config[mail_id].type
end

--获取发信人姓名
function MailTemplate:getSendNameById(mail_id)
    return self.c_LanguageTemplate:getLanguageById(mail_config[mail_id].nameId)
end

--获取标题
function MailTemplate:getTitleById(mail_id)
    print("mail_id ====== ", mail_id)
    return self.c_LanguageTemplate:getLanguageById(mail_config[mail_id].title)
end

--获取标题
function MailTemplate:getIconById(mail_id)
    return mail_config[mail_id].icon
end

--获取邮件内容
function MailTemplate:getEmailContent(mail_id)
    return self.c_LanguageTemplate:getLanguageById(mail_config[mail_id].content)
end

--获取掉落
function MailTemplate:getMailGainById(mail_id)
    return mail_config[mail_id].rewards
end

--@return
return MailTemplate

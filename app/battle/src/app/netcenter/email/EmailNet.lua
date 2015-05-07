--信箱网络
EmailNet = EmailNet or class("EmailNet", BaseNetWork)

EMAIL_LIST_REQUEST               = 1301      --信箱列表
EMAIL_READ_REQUEST               = 1302      --读取邮件、领取奖励
EMAIL_DELETE_REQUEST             = 1303      --删除邮件
EMAIL_SEND_REQUEST               = 1304      --发送邮件
EMAIL_RECEIVE_REQUEST             = 1305      --接收邮件 （服务器主动推送过来的暂时放这）

function EmailNet:ctor()
    self.super.ctor(self, self.__cname)
    self:init()
    self:initRegisterNetCallback()
end

function EmailNet:init()

end

--获取信箱列表
function EmailNet:sendGetEmailListMsg()
    print(" start send get email list ...")
    self:sendMsg(EMAIL_LIST_REQUEST)
end

--读取邮件
function EmailNet:sendReadEmail(data)
    print(" send read request ...")
    self:sendMsg(EMAIL_READ_REQUEST, "ReadMailRequest", data)
end

--删除邮件
function EmailNet:sendDeleteEmail(data)
    self:sendMsg(EMAIL_DELETE_REQUEST, "DeleteMailRequest", data)
end

--发送邮件
function EmailNet:sendSendEmail(data)
    self:sendMsg(EMAIL_SEND_REQUEST, "SendMailRequest", data)
end

--删除好友
function EmailNet:sendDeleteFriend(data)
    self:sendMsg(FRIEND_DELETE_REQUEST, "FriendCommon", data)
end

--注册接受网络协议
function EmailNet:initRegisterNetCallback()

    local function getEmailListMsgCallBack(data)
        cclog("response get邮件列表")
        table.print(data)
        table.remove(g_netResponselist)

        local _emailData = getDataManager():getEmailData()
        for k,v in pairs(data.mails) do
            _emailData:addEmail(v)
        end
        _emailData:setRate(data)
        -- print(data.target)
        -- print(data.current)
        -- table.print(_emailData:getEmailList())
    end

    local function readEmailCallBack(data)
        cclog("============ response read email ") -- 将获取存入DataCenter
        table.print(data)  -- to do 处理接收物品到DataCenter中
        -- print(data.mail_type)
        -- print(data.res.result)
        -- print(data.gain.stamina)
        if data.res.result == true then
            if data.mail_type == 1 then
                local _emailData = getDataManager():getEmailData()
                _emailData:setRate(data)
            end

            -- local _commData = getDataManager():getCommonData()
            -- -- _commData:addStamina(data.gain.stamina)
            -- for k,v in pairs(data.gain.finance.finance_changes) do
            --     -- _commData:addFinance(v.item_no, v.item_num)
            -- end
        end

    end

    local function DeleteEmailCallBack(data)

    end

    local function receiveMailCallBack(data)
        local newMail = data.mail
        local _emailData = getDataManager():getEmailData()
        _emailData:addEmail(newMail)
    end

    self:registerNetMsg(EMAIL_LIST_REQUEST, "GetMailInfos", getEmailListMsgCallBack)         --获取信箱列表
    self:registerNetMsg(EMAIL_READ_REQUEST, "ReadMailResponse", readEmailCallBack)           --读取邮件
    self:registerNetMsg(EMAIL_RECEIVE_REQUEST, "ReceiveMailResponse", receiveMailCallBack)   --接收到新邮件
end

return EmailNet

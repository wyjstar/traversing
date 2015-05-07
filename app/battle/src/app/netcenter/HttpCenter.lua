--lua http 请求管理管理类


-- 第三方登录URL
THIRD_HTTP_SERVER_URL = THIRD_LOGIN_REGISTER_SERVER..":"..THIRD_LOGIN_REGISTER_PORT.."/"
-- 正式登录
LOGIN_SERVER_SERVER_URL = LOGIN_SERVER..":"..LOGIN_SERVER_PORT.."/"

local HttpCenter = HttpCenter or class("HttpCenter")

function HttpCenter:ctor(controller)

    self.response = {}
    self.delegate = nil
    self.assetsManager = nil

end

function HttpCenter:setDelegate(delegate)
    self.delegate = delegate
end

-- 发送中心
function HttpCenter:sendCenter(params, isShowLoading)

    if self.delegate ~= nil and isShowLoading then
        self.delegate:onNetLoading()
    end
    self.httpRequest = cc.XMLHttpRequest:new()
    self.httpRequest.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON

    self.httpRequest:open(SEND_TYPE, params[2])

    local function onHttpResponse()
        print("Http Status Code:"..self.httpRequest.statusText)

        -- 回调函数
        -- callfunc(self.httpRequest.status, self.httpRequest.response)
        if self.delegate ~= nil and isShowLoading then
            self.delegate:onRemoveNetLoading()
        end

         params[1](self.httpRequest.status, self.httpRequest.response)
    end

    self.httpRequest:registerScriptHandler(onHttpResponse)
    self.httpRequest:send()
end


-- 检查网络
function HttpCenter:checkNetwork()

    local isAvailable = cc.CCNetwork:isLocalWiFiAvailable() or cc.CCNetwork:isInternetConnectionAvailable()

    return isAvailable
end

-- 游客登录查询(是否使用过游客登录账号)
-- @param callfunc  回调函数
-- @param name 用户名
-- @param pwd  密码
function HttpCenter:sendTouristLogin(callfunc, deviceid)
    print("游客登录查询 ================== ",  deviceid)
    -- if not self:checkNetwork() then
    --     getOtherModule():showAlertDialog(nil, Localize.query("toast.1"))
    --     return
    -- end

   local server_url = THIRD_HTTP_SERVER_URL.."query_touristid?deviceid="..deviceid

    self:sendCenter({callfunc, server_url}, true)
end

-- 游客登录绑定账号
-- @param callfunc  回调函数
-- @param name 用户名
-- @param pwd  密码
function HttpCenter:sendBoundTourist(callfunc, name, pwd, tid)
    -- if not self:checkNetwork() then
    --     getOtherModule():showAlertDialog(nil, Localize.query("toast.1"))
    --     return
    -- end
    local server_url = THIRD_HTTP_SERVER_URL.."bind?name="..name.."&pwd="..pwd .. "&tid=" .. tid
    self:sendCenter({callfunc, server_url}, true)
end

-- 第三方注册
-- @param callfunc  回调函数
-- @param name 用户名
-- @param pwd  密码
function HttpCenter:sendThirdRigister(callfunc, name, pwd, isTourist, deviceid)
    -- if not self:checkNetwork() then

    --     -- getOtherModule():showToastView(Localize.query("toast.1"))
    --     getOtherModule():showAlertDialog(nil, Localize.query("toast.1"))
    --     return
    -- end
    local server_url = ""
    if isTourist == "True" then
        server_url = THIRD_HTTP_SERVER_URL.."register?name="..name.."&pwd="..pwd .. "&tourist=" .. isTourist .. "&deviceid=" .. deviceid
    else
        server_url = THIRD_HTTP_SERVER_URL.."register?name="..name.."&pwd="..pwd
    end
    print("server_url ================= ", server_url)
    self:sendCenter({callfunc, server_url}, true)
end

-- 第三方登录
-- @param callfunc  回调函数
-- @param name 用户名
-- @param pwd  密码
function HttpCenter:sendThirdLogin(callfunc, name, pwd)
    print("第三方登录 sendThirdLogin =============> ", name, pwd)
    -- if not self:checkNetwork() then

    --     -- getOtherModule():showToastView(Localize.query("toast.1"))
    --     getOtherModule():showAlertDialog(nil, Localize.query("toast.1"))
    --     return
    -- end

    local server_url = THIRD_HTTP_SERVER_URL.."login?name="..name.."&pwd="..pwd
    print("sendThirdLogin==============>"..server_url)
    self:sendCenter({callfunc, server_url}, true)
end

-- 正式登录
-- @param callfunc  回调函数
-- @param passport
function HttpCenter:sendLoginByPassport(callfunc, passport)

    local server_url = LOGIN_SERVER_SERVER_URL.."login?passport="..passport
    self:sendCenter({callfunc, server_url}, true)
end

--游客身份绑定
-- @param callfunc  回调函数
-- @param passport
function HttpCenter:sendBindTourist(callfunc, name, pwd, tid)
    -- print("游客身份绑定 sendBindTourist ============= ", name, pwd)
    -- if not self:checkNetwork() then
    --     getOtherModule():showAlertDialog(nil, Localize.query("toast.1"))
    --     return
    -- end

    local server_url = THIRD_HTTP_SERVER_URL.."bind?name="..name.."&pwd="..pwd .. "&tid=" .. tid
    self:sendCenter({callfunc, server_url}, true)
end

--qq微信登录
function HttpCenter:sendThirdLoginCheck(callfunc, opneId, token, platformId)
    print("第三方登录 校验 sendThirdLogin ============= ", opneId, token, platformId)
    -- if not self:checkNetwork() then
    --     getOtherModule():showAlertDialog(nil, Localize.query("toast.1"))
    --     return
    -- end

    local server_url = LOGIN_SERVER_SERVER_URL.."login?open_id=" .. opneId .."&access_token=".. token .. "&platform=" .. platformId
    self:sendCenter({callfunc, server_url}, true)
end

--@return
return HttpCenter

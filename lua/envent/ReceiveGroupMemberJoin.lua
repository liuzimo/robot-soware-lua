--[[
处理收到的群成员增加事件

提前收到的声明数据为：
fromqq      被操作qq号码    number类型
fromgroup   消息的群号码    number类型
operateqq   操作者qq号码    number类型  如果为自己进群，此值为nil

注意：拦截消息后请将变量handled置true，表示消息已被拦截，如：
handled = true

下面的代码为我当前接待喵逻辑使用的代码，可以重写也可以按自己需求进行更改
详细请参考readme
]]


-- local h1 = apiXmlGet(tostring(fromgroup),"newreplay","第一次欢迎")~="" or "欢迎欢迎"

-- local private1 = apiXmlGet(tostring(fromgroup),"newreplay","第一次私聊")~="" or "欢迎加入"
if operateqq+0~=fromqq then
    cqSendGroupMessage(fromgroup,cqCode_At(operateqq).."邀请" ..fromqq.."进群")
    local count = apiXmlGet(tostring(fromgroup),"invite",tostring(operateqq))
    if count == "" then
        count=0
    end
    apiXmlSet(tostring(fromgroup),"invite",tostring(operateqq),tostring(tonumber(count)+1))
    cqSendGroupMessage(fromgroup,cqCode_At(operateqq).."你总共邀请"..tostring(tonumber(count)+1).."人进群，".."此次赠送积分100 \n可通过'积分查询'查看积分，后续更新积分游戏功能")
    local integral = apiXmlGet(tostring(fromgroup), "integral",tostring(operateqq))
    if integral == "" then
        integral = 500
    end
    apiXmlSet(tostring(fromgroup),"integral",tostring(operateqq),tostring(tonumber(integral)+100))
    return true
end


-- cqSendGroupMessage(fromgroup,cqCode_At(fromqq)..h1)
-- cqSendPrivateMessage(fromqq,private1..fromgroup)

-- if fromgroup ==418106020 then

--     local h2 = apiXmlGet(tostring(fromgroup),"newreplay","第二次欢迎")~="" or "热烈欢迎"

--     local private2 = apiXmlGet(tostring(fromgroup),"newreplay","第二次私聊")~="" or "欢迎加入"
    
--     local time = tonumber(apiXmlGet(tostring(fromgroup),"newreplay","时间毫秒")~="" or "5000")
    
--     cqSendDelyMessage(fromgroup,fromqq,cqCode_At(fromqq)..h2,private2..fromgroup,time)

-- end


local inteinitial = require("app.integral.initial")
if inteinitial(fromgroup,fromqq) then
    handled = true
end
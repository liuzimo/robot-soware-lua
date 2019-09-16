--统一的消息处理函数
local msg, qq, group, id = nil, nil, nil, nil
local handled = false

--发送消息
function sendMessage(s)
    cqSendPrivateMessage(qq, s)
end

--去除字符串开头的空格
function kickSpace(s)
    if type(s) ~= "string" then return end
    while s:sub(1, 1) == " " do
        s = s:sub(2)
    end
    return s
end


--对外提供的函数接口
return function(inmsg, inqq, ingroup, inid)
    msg, qq, group, id = inmsg, inqq, ingroup, inid
    local getapp = require("app.menu.privatefeatures")
    local apps = getapp(qq,msg)
    local getadminapp = require("app.menu.privatemanage")
    local adminapps = getadminapp(qq,msg)

    --匹配是否需要获取帮助
    if msg:lower():find("help") == 1 then
        local allApp = {}
        for i = 1, #apps do
            local appExplain = apps[i].explain and apps[i].explain()
            if appExplain then
                table.insert(allApp, appExplain)
            end
        end
        sendMessage("功能列表\n" ..
        table.concat(allApp, "\n") .. "\n")
        return true
    end
    --匹配是否需要获取管理
    if msg:lower():find("manage") == 1 then
        local allApp = {}
        for i = 1, #adminapps do
            local appExplain = adminapps[i].explain and adminapps[i].explain()
            if appExplain then
                table.insert(allApp, appExplain)
            end
        end
        sendMessage("管理功能(以下操作为全局设置)\n" ..
        table.concat(allApp, "\n") .. "\n")
        return true
    end
    --遍历所有功能
    for i = 1, #adminapps do
        if adminapps[i].check and adminapps[i].check() then
            if adminapps[i].run() then
                return true
            end
        end
    end
    for i = 1, #apps do
        if apps[i].check and apps[i].check() then
            if apps[i].run() then
                return true
            end
        end
    end
    return handled
end
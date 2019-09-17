--统一的消息处理函数
local msg, qq, group, id = nil, nil, nil, nil
local handled = false

--发送消息
function sendMessage(s)
    if cqSendGroupMessage(group, s) == -34 then
        --在群内被禁言了，打上标记
        apiXmlSet("", "ban", tostring(group), tostring(os.time()))
    end
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
    local getapp = require("app.menu.groupfeatures")
    local apps = getapp(group,qq,msg)
    local getadminapp = require("app.menu.groupmanage")
    local adminapps = getadminapp(group,qq,msg)

    --匹配是否需要获取帮助
    if msg:lower():find("help") == 1 then
        local allApp = {}
        for i = 1, #apps do
            local appExplain = apps[i].explain and apps[i].explain()
            if appExplain then
                table.insert(allApp, appExplain)
            end
        end
        sendMessage("命令帮助\n" ..
        table.concat(allApp, "\n") .. "\n")
        return true
    end

    --匹配是否需要获取管理
    if msg:lower():find("manage") == 1 then
        if (apiXmlGet(tostring(group), "adminList", tostring(qq)) == "admin" or apiXmlGet("", "adminList", tostring(qq)) == "admin") or qq == admin then
            local allApp = {}
            for i = 1, #adminapps do
                local appExplain = adminapps[i].explain and adminapps[i].explain()
                if appExplain then
                    table.insert(allApp, appExplain)
                end
            end
            sendMessage("管理功能\n" ..
            table.concat(allApp, "\n") .. "\n")
            return true
        end
        sendMessage("权限不足！")
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
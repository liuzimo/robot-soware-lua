--统一的消息处理函数
local msg, qq, group, id = nil, nil, nil, nil
local handled = false

--发送消息
function sendMessage(s)
    cqSendPrivateMessage(qq, s)
end

--去除字符串开头的空格
local function kickSpace(s)
    if type(s) ~= "string" then return end
    while s:sub(1, 1) == " " do
        s = s:sub(2)
    end
    return s
end

--管理操作
local adminapps = {
    {--!add
    check = function()--检查函数，拦截则返回true
        return msg:find("add ") == 1
    end,
    run = function()--匹配后进行运行的函数
        if (apiXmlGet("", "adminList", tostring(qq)) == "admin") or qq == admin then
            msg = msg:gsub("add ","")
            local keyWord, answer = msg:match("(.+):(.+)")
            keyWord = kickSpace(keyWord)
            answer = kickSpace(answer)
            if not keyWord or not answer or keyWord:len() == 0 or answer:len() == 0 then
                sendMessage("格式 add 123:123") return true
            end
            apiXmlInsert("", "common", keyWord, answer)
            sendMessage("添加完成！\n" ..
            "词条：" .. keyWord .. "\n" ..
            "回答：" .. answer)
        else
            sendMessage("权限不足！")
        end
        return true
    end,
    explain = function()--功能解释，返回为字符串，若无需显示解释，返回nil即可
        return "add    关键词:回答 --全局词库 (超管功能)"
    end
},
{--!delall
    check = function()
        return msg:find("delall ") == 1
    end,
    run = function()
        if (apiXmlGet("", "adminList", tostring(qq)) == "admin") or qq == admin then
            keyWord = msg:gsub("delall ","")
            keyWord = kickSpace(keyWord)
            apiXmlDelete("","common", keyWord)
            sendMessage("删除完成！\n" ..
            "词条：" .. keyWord)
        else
            sendMessage("权限不足！")
        end
        return true
    end,
    explain = function()
        return "delall 关键词 (超管功能)"
    end
},
{--!del
    check = function()
        return msg:find("del ") == 1
    end,
    run = function()
        if (apiXmlGet("", "adminList", tostring(qq)) == "admin") or qq == admin then
            msg = msg:gsub("del ","")
            local keyWord, answer = msg:match("(.+):(.+)")
            keyWord = kickSpace(keyWord)
            answer = kickSpace(answer)
            if not keyWord or not answer or keyWord:len() == 0 or answer:len() == 0 then
                sendMessage("格式 del 123:123") return true
            end
            apiXmlRemove("", "common", keyWord, answer)
            sendMessage("删除完成！\n" ..
            "词条：" .. keyWord .. "\n" ..
            "回答：" .. answer)
        else
            sendMessage("权限不足！")
        end
        return true
    end,
    explain = function()
        return "del     关键词:回答(超管功能)"
    end
},
{--!list
    check = function()
        return msg:find("list ") == 1
    end,
    run = function()
        keyWord = msg:gsub("list ","")
        keyWord = kickSpace(keyWord)
        sendMessage("全局词库内容：\n" .. apiXmlListGet("", "common", keyWord))
        return true
    end,
    explain = function()
        return "list     关键词(超管功能)"
    end
},
{--!addgroupadmin
    check = function()
        return msg:find("addgroupadmin ") == 1
    end,
    run = function()
        if (apiXmlGet("", "adminList", tostring(qq)) == "admin") or qq == admin then
            msg = msg:gsub("addgroupadmin ","")
            local ingroup, inqq = msg:match("(.+):(.+)")
            ingroup = kickSpace(ingroup)
            inqq = kickSpace(inqq)
            if ingroup:len() == 0 and inqq:len() == 0 and tonumber(ingroup) == nil and tonumber(inqq) == nil then
                sendMessage("格式 addgroupadmin 群号:qq") return true
            end
            local dlist = apiDirectoryList("")
            local num = dlist[0]
            local list = dlist[1]
            for i=0,num do
                if ingroup == list[i] then
                    apiXmlSet(ingroup, "adminList", inqq, "admin")
                    sendMessage("群:" .. ingroup .. "\n添加管理员:" .. inqq)
                    cqSendGroupMessage(tonumber(ingroup), "添加本群机器管理员:"..inqq)
                    return true
                end
            end
            sendMessage("Q群不存在")
            return true

        else
            sendMessage("权限不足！")
        end
        
        return true
    end,
    explain = function()
        return "addgroupadmin 群号:添加管理qq(超管功能)"
    end
},
{--!delgroupadmin
    check = function()
        return msg:find("delgroupadmin ") == 1
    end,
    run = function()
        if (apiXmlGet("", "adminList", tostring(qq)) == "admin") or qq == admin then
            msg = msg:gsub("delgroupadmin ","")
            local ingroup, inqq = msg:match("(.+):(.+)")
            ingroup = kickSpace(ingroup)
            inqq = kickSpace(inqq)
            if ingroup:len() == 0 and inqq:len() == 0 and tonumber(ingroup) == nil and tonumber(inqq) == nil then
                sendMessage("格式 delgroupadmin 群号:qq") return true
            end
            local dlist = apiDirectoryList("")
            local num = dlist[0]
            local list = dlist[1]
            for i=0,num do
                if ingroup == list[i] then
                    apiXmlDelete(ingroup, "adminList", inqq)
                    sendMessage("群:" .. ingroup .. "\n删除管理员:" .. inqq) 
                    cqSendGroupMessage(tonumber(ingroup), "删除本群机器管理员:"..inqq)
                    return true
                end
            end
            sendMessage("Q群不存在")
            return true
        else
        sendMessage("权限不足！")
         end
    
        return true
    end,
    explain = function()
        return "delgroupadmin  群号:删除管理qq (超管功能)"
    end
},
{--!addadmin
    check = function()
        return msg:find("addadmin ") == 1 and
        qq == admin
    end,
    run = function()
        local keyWord = msg:match("(%d+)")
        apiXmlSet("", "adminList", keyWord, "admin")
        sendMessage("已添加狗管理" .. keyWord)
        return true
    end,
    explain = function()
        return "addadmin qq (所有者功能)"
    end
},
{--!deladmin
    check = function()
        return msg:find("deladmin ") == 1 and
        qq == admin
    end,
    run = function()
        local keyWord = msg:match("(%d+)")
        apiXmlDelete("", "adminList", keyWord)
        sendMessage("已宰掉狗管理" .. keyWord)
        return true
    end,
    explain = function()
        return "deladmin qq (所有者功能)"
    end
},
{--初始化群列表
    check = function()
        return msg:find("初始化群列表") == 1 and 
        qq == admin 
    end,
    run = function()
       
        --初始化群列表
        local grouplist = cqGetGroupList()
        local n = grouplist[0]
        local list = grouplist[1]

        for i=0,n do
            apiXmlSet("", "grouplist", tostring(list[i]["Id"]),"")
        end
        sendMessage("初始化群列表完成,数量:"..tostring(n+1))
        return true
    end,
    explain = function()
        return "初始化群列表 (所有者功能)"
    end
},
{--获取群列表
    check = function()
        return msg:find("群列表") == 1 and  
        qq == admin
    end,
    run = function()
        local dlist = apiXmlIdListGet("","grouplist")
        local num = dlist[0]
        local list = dlist[1]
        local n = ""
        for i=0,num do
            n = n..list[i].."\n"
        end
        sendMessage(n)
        return true
    end,
    explain = function()
        return "群列表  --打印群列表 (所有者功能)"
    end
},
{--初始化群成员
    check = function()
        return msg:find("初始化群 ") == 1 and 
        qq == admin 
    end,
    run = function()
       
        local key = msg:match("(%d+)")
        local t = cqGetMemberList(tonumber(key))
        local nums = t[0]
        local lists = t[1]
        for s=0,nums do
            local ls = lists[s]
            apiXmlSet(key, "memberlist", tostring(ls["QQ"]),"")
        end

        sendMessage("群成员初始化完成,人数:"..tostring(nums+1))
        return true
        

    end,
    explain = function()
        return "初始化群 群号 (所有者功能)"
    end
},
{--群发
check = function()
    return msg:find("群发 ") == 1 and
    qq == admin
end,
run = function()
    keyWord = msg:gsub("群发 ","")
    local t = apiXmlIdListGet("","grouplist")
    local nums = t[0]
    local lists = t[1]
    for i=0,nums do
        if cqSendGroupMessage(tonumber(lists[i]),keyWord) == -34 then
            --在群内被禁言了，打上标记
            cqSetGroupExit(tonumber(lists[i]))
        end
    end
    sendMessage("群发完成,数量:"..tostring(nums+1))
    return true
end,
explain = function()
    return "群发 内容(所有者功能)"
end
},
{--测试
    check = function()
        return msg:find("test") == 1
    end,
    run = function()
        

    end,
},
}
--所有需要运行的app
local apps = {
    {--今日运势
        check = function()
            return msg == "今日运势" or msg == "明日运势" or msg == "昨日运势"
        end,
        run = function()
            local getAlmanac = require("app.almanac")
            sendMessage(getAlmanac(qq))
            return true
        end,
        explain = function()
            return "昨日/今日/明日运势"
        end
    },
    {--查快递
        check = function()
            return msg:find("查快递") == 1
        end,
        run = function()
            local express = require("app.express")
            sendMessage(express(qq, msg))
            return true
        end,
        explain = function()
            return "查快递 加 单号"
        end
    },
    {--空气质量
        check = function()
            return msg:find("空气质量") == 1
        end,
        run = function()
            local air = require("app.air")
            sendMessage(air(msg))
            return true
        end,
        explain = function()
            return "空气质量"
        end
    },
    {--点歌
        check = function()
            return msg:find("点歌") == 1
        end,
        run = function()
            local qqmusic = require("app.qqmusic")
            sendMessage(qqmusic(msg))
            return true
        end,
        explain = function()
            return "点歌 加 qq音乐id或歌名"
        end
    },
    {--查动画
        check = function()
            return msg:find("查动画") or msg:find("搜动画") or msg:find("查番") or msg:find("搜番")
        end,
        run = function()
            local animeSearch = require("app.animeSearch")
            sendMessage(animeSearch(msg))
            return true
        end,
        explain = function()
            return "查动画 加 没裁剪过的视频截图"
        end
    },
    {--b站av号解析
        check = function()
            return msg:find("av%d+")
        end,
        run = function()
            local av = require("app.av")
            sendMessage(av(msg))
            return true
        end,
        explain = function()
            return "b站av号解析"
        end
    },
    {--一言
        check = function()
            return msg == "一言"
        end,
        run = function()
            local hitokoto = require("app.hitokoto")
            sendMessage(hitokoto())
            return true
        end,
        explain = function()
            return "一言"
        end
    },
    {--必应美图
        check = function()
            return msg:find("必应") == 1 and (message:find("美图") or message:find("壁纸"))
        end,
        run = function()
            local bing = require("app.bing")
            sendMessage(bing())
            return true
        end,
        explain = function()
            return "必应壁纸"
        end
    },
    {--通用回复
    check = function()
        return true
    end,
    run = function()
        -- local replyCommon = apiXmlReplayGet("", "common", msg)
        -- sendMessage(replyCommon)
        sendMessage("你可以通过 'help' 来获取一般功能帮助\n"..
                    "或者通过 'manage'来管理我 私聊和群聊有不同效果哦\n"..
                    "机器人交流群 插件定制群 418106020\n"..
                    "主人QQ 919825501\n"..
                    "可以把我拉到其他群里一起玩哦~ 后续功能继续开发中。。。")
        return true
    end
    },
}

--对外提供的函数接口
return function(inmsg, inqq, ingroup, inid)
    msg, qq, group, id = inmsg, inqq, ingroup, inid
    --匹配是否需要获取帮助
    if msg:lower():find("help") == 1 or msg:find("帮助") == 1 or msg:find("菜单") == 1 or msg:find("命令") == 1 then
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
        sendMessage("管理功能\n" ..
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
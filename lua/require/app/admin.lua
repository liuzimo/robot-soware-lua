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

--所有需要运行的app
local apps = {
    {--!add
        check = function()--检查函数，拦截则返回true
            return (msg:find("！ *add *.+：.+") == 1 or msg:find("! *add *.+:.+") == 1)
            and not (msg:find("！ *addadmin *.+") == 1 or msg:find("! *addadmin *.+") == 1)
        end,
        run = function()--匹配后进行运行的函数
            if (apiXmlGet("", "adminList", tostring(qq)) ~= "admin" or not group) and qq ~= admin then
                sendMessage(cqCode_At(qq) .. "你不是狗管理，想成为狗管理请找我的主人呢")
                return true
            end
            local keyWord, answer = msg:match("！ *add *(.+)：(.+)")
            if not keyWord then keyWord, answer = msg:match("! *add *(.-):(.+)") end
            keyWord = kickSpace(keyWord)
            answer = kickSpace(answer)
            if not keyWord or not answer or keyWord:len() == 0 or answer:len() == 0 then
                sendMessage(cqCode_At(qq) .. "格式错误，请检查") return true
            end
            apiXmlInsert("", tostring(group or "common"), keyWord, answer)
            sendMessage(cqCode_At(qq) .. "\r\n添加完成！\r\n" ..
            "词条：" .. keyWord .. "\r\n" ..
            "回答：" .. answer)
            return true
        end,
        explain = function()--功能解释，返回为字符串，若无需显示解释，返回nil即可
            return "!add关键词:回答"
        end
    },
    {--!delall
        check = function()
            return msg:find("！ *delall *.+") == 1 or msg:find("! *delall *.+") == 1
        end,
        run = function()
            if (apiXmlGet("", "adminList", tostring(qq)) ~= "admin" or not group) and qq ~= admin then
                sendMessage(cqCode_At(qq) .. "你不是狗管理，想成为狗管理请找我的主人呢")
                return true
            end
            local keyWord = msg:match("！ *delall *(.+)")
            if not keyWord then keyWord = msg:match("! *delall *(.+)") end
            keyWord = kickSpace(keyWord)
            apiXmlDelete("", tostring(group or "common"), keyWord)
            sendMessage(cqCode_At(qq) .. "\r\n删除完成！\r\n" ..
            "词条：" .. keyWord)
            return true
        end,
        explain = function()
            return "!delall关键词"
        end
    },
    {--!del
        check = function()
            return (msg:find("！ *del *.+：.+") == 1 or msg:find("! *del *.+:.+") == 1)
            and not (msg:find("！ *deladmin *.+") == 1 or msg:find("! *deladmin *.+") == 1)
        end,
        run = function()
            if (apiXmlGet("", "adminList", tostring(qq)) ~= "admin" or not group) and qq ~= admin then
                sendMessage(cqCode_At(qq) .. "你不是狗管理，想成为狗管理请找我的主人呢")
                return true
            end
            local keyWord, answer = msg:match("！ *del *(.+)：(.+)")
            if not keyWord then keyWord, answer = msg:match("! *del *(.-):(.+)") end
            keyWord = kickSpace(keyWord)
            answer = kickSpace(answer)
            if not keyWord or not answer or keyWord:len() == 0 or answer:len() == 0 then
                sendMessage(cqCode_At(qq) .. "格式错误，请检查") return true
            end
            apiXmlRemove("", tostring(group or "common"), keyWord, answer)
            sendMessage(cqCode_At(qq) .. "\r\n删除完成！\r\n" ..
            "词条：" .. keyWord .. "\r\n" ..
            "回答：" .. answer)
            return true
        end,
        explain = function()
            return "!del关键词:回答"
        end
    },
    {--!list
        check = function()
            return msg:find("！ *list *.+") == 1 or msg:find("! *list *.+") == 1
        end,
        run = function()
            local keyWord = msg:match("！ *list *(.+)")
            if not keyWord then keyWord = msg:match("! *list *(.+)") end
            keyWord = kickSpace(keyWord)
            sendMessage(cqCode_At(qq) .. "\r\n当前词条回复如下：\r\n" ..
            apiXmlListGet("", tostring(group), keyWord) .. "\r\n" ..
            "全局词库内容：\r\n" .. apiXmlListGet("", "common", keyWord))
            return true
        end,
        explain = function()
            return "!list关键词"
        end
    },
    {--今日运势
        check = function()
            return msg == "今日运势" or msg == "明日运势" or msg == "昨日运势"
        end,
        run = function()
            local getAlmanac = require("app.almanac")
            sendMessage(cqCode_At(qq) .. getAlmanac(qq))
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
            sendMessage(cqCode_At(qq) .. "\r\n" .. air(msg))
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
            sendMessage(cqCode_At(qq) .. "\r\n" .. animeSearch(msg))
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
    {--测试代码
        check = function()
            return msg:find("#lua") == 1
        end,
        run = function()
            if qq == admin then
                local result, info = pcall(function()
                    print = function(s)
                        sendMessage(tostring(s))
                    end
                    load(cqCqCode_UnTrope(msg:sub(5)))()
                end)
                if result then
                    sendMessage(cqCode_At(qq) .. "成功运行")
                else
                    sendMessage(cqCode_At(qq) .. "运行失败\r\n" .. tostring(info))
                end
            else
                sendMessage(cqCode_At(qq) .. "\r\n" .. apiSandBox(cqCqCode_UnTrope(msg:sub(5))))
            end
            return true
        end,
        explain = function()
            return "#lua运行lua代码"
        end
    },
    {--!addadmin
        check = function()
            return (msg:find("！ *addadmin *.+") == 1 or msg:find("! *addadmin *.+") == 1) and
            qq == admin
        end,
        run = function()
            local keyWord = msg:match("(%d+)")
            if keyWord and apiXmlGet("", "adminList", keyWord) == "admin" then
                sendMessage(cqCode_At(qq) .. "\r\n" .. keyWord .. "已经是狗管理了")
            else
                apiXmlSet("", "adminList", keyWord, "admin")
                sendMessage(cqCode_At(qq) .. "\r\n已添加狗管理" .. keyWord)
            end
            return true
        end,
    },
    {--!deladmin
        check = function()
            return (msg:find("！ *deladmin *.+") == 1 or msg:find("! *deladmin *.+") == 1) and
            qq == admin
        end,
        run = function()
            local keyWord = msg:match("(%d+)")
            if keyWord and apiXmlGet("", "adminList", keyWord) == "" then
                sendMessage(cqCode_At(qq) .. "\r\n狗管理" .. keyWord .. "已经挂了")
            else
                apiXmlDelete("", "adminList", keyWord)
                sendMessage(cqCode_At(qq) .. "\r\n已宰掉狗管理" .. keyWord)
            end
            return true
        end,
    },
    -- {--@触发腾讯ai开放平台
        --     check = function()
        --         return msg:find("%[CQ:at,qq=" .. cqGetLoginQQ() .. "%]") and msg:gsub("%[CQ:.-%]", ""):len() > 2
        --     end,
        --     run = function()
        --         local text = msg:gsub("%[CQ:.-%]", ""):gsub(" ", "")--过滤掉特殊内容的消息
        --         local appid = apiXmlGet("settings", "qqai_APPID")--应用信息
        --         local appkey = apiXmlGet("settings", "qqai_APPKEY")
        --         --原始请求数据
        --         local rawBody = "app_id=" .. appid .. "&" ..
        --         "nonce_str=" .. getRandomString(20) .. "&" ..
        --         "question=" .. text:urlEncode() .. "&" ..
        --         "session=" .. tostring(qq) .. "&" ..
        --         "time_stamp=" .. tostring(os.time())
        --         local sign
        --         --加载MD5需要的库
        --         if not apiMD5Encrypt then--兼容老版本插件，不过会很慢
        --             local md5 = require 'md5'
        --             sign = md5.sumhexa(rawBody .. "&app_key=" .. appkey)
        --         else
        --             sign = apiMD5Encrypt(rawBody .. "&app_key=" .. appkey)
        --         end
        --         rawBody = rawBody .. "&sign=" .. sign:upper()
        --         local http = apiHttpGet("https://api.ai.qq.com/fcgi-bin/nlp/nlp_textchat?" .. rawBody)
        --         local d, r = jsonDecode(http)
        --         cqAddLoger(0, "智能回复", "json解析" .. (r and "成功" or "失败"))
        --         if r then
        --             cqAddLoger(0, "智能回复", "ret=" .. tostring(d.ret) .. (d.msg or ""))
        --             if d and d.ret ~= 0 then return end--没结果
        --             if d and d.data and d.data.answer then
        --                 sendMessage(cqCode_At(qq) .. d.data.answer)
        --                 return true
        --             end
        --         end
        --     end,
        -- },
        {--通用回复
        check = function()
            return true
        end,
        run = function()
            local replyGroup = group and apiXmlReplayGet("", tostring(group), msg) or ""
            local replyCommon = apiXmlReplayGet("", "common", msg)
            if replyGroup == "" and replyCommon ~= "" then
                sendMessage(replyCommon)
            elseif replyGroup ~= "" and replyCommon == "" then
                sendMessage(replyGroup)
            elseif replyGroup ~= "" and replyCommon ~= "" then
                sendMessage(math.random(1, 10) >= 5 and replyCommon or replyGroup)
            else
                return false
            end
            return true
        end
    },
}

--对外提供的函数接口
return function(inmsg, inqq, ingroup, inid)
    -- --禁言锁，最长持续一个月
    -- if (tonumber(apiXmlGet("", "ban", tostring(ingroup))) or 0) > os.time() - 3600 * 24 * 30 then
    --     if inmsg:find("%(" .. tostring(cqGetLoginQQ()) .. "%) 被管理员解除禁言") then
    --         apiXmlDelete("", "ban", tostring(ingroup))
    --     elseif ingroup then
    --         return false
    --     end
    -- elseif inmsg:find("%(" .. tostring(cqGetLoginQQ()) .. "%) 被管理员禁言") then
    --     apiXmlSet("", "ban", tostring(group), tostring(os.time()))
    -- end

    msg, qq, group, id = inmsg, inqq, ingroup, inid
    --帮助列表每页最多显示数量
    -- local maxEachPage = 8
    -- --匹配是否需要获取帮助翻页
    -- if msg:lower():find("help *%d*") == 1 or msg:find("帮助 *%d*") == 1 or msg:find("菜单 *%d*") == 1 then
    --     local page = msg:lower():match("help *(%d+)") or msg:match("帮助 *(%d+)") or
    --     msg:find("菜单 *(%d+)") or 1
    --     page = tonumber(page)--获取页码
    --     local maxPage = math.ceil(#apps / maxEachPage)
    --     page = page > maxPage and maxPage or page
    --     --开始与结束序号
    --     local fromApp = (page - 1) * maxEachPage + 1
    --     local endApp = fromApp + maxEachPage - 1
    --     endApp = endApp > #apps and #apps or endApp
    --     local allApp = {}
    --     for i = fromApp, endApp do
    --         local appExplain = apps[i].explain and apps[i].explain()
    --         if appExplain then
    --             table.insert(allApp, appExplain)
    --         end
    --     end
    --     sendMessage("[CQ:emoji,id=128172]命令帮助(" .. tostring(page) .. "/" .. tostring(maxPage) .. "页)\r\n" ..
    --     table.concat(allApp, "\r\n") .. "\r\n")
    --     return true
    -- end
    --匹配是否需要获取帮助
    if msg:lower():find("help *%d*") == 1 or msg:find("帮助 *%d*") == 1 or msg:find("菜单 *%d*") == 1 or msg:find("命令 *%d*") == 1 then
        local page = msg:lower():match("help *(%d+)") or msg:match("帮助 *(%d+)") or msg:find("命令 *(%d+)") or
        msg:find("菜单 *(%d+)") or 1
        local allApp = {}
        for i = 1, #apps do
            local appExplain = apps[i].explain and apps[i].explain()
            if appExplain then
                table.insert(allApp, appExplain)
            end
        end
        sendMessage("命令帮助\r\n" ..
        table.concat(allApp, "\r\n") .. "\r\n")
        return true
    end
    --遍历所有功能
    for i = 1, #apps do
        if apps[i].check and apps[i].check() then
            if apps[i].run() then
                handled = true
                break
            end
        end
    end
    return handled
end
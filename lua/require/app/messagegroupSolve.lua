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
local function kickSpace(s)
    if type(s) ~= "string" then return end
    while s:sub(1, 1) == " " do
        s = s:sub(2)
    end
    return s
end
local adminapps = {
    {--!add
        check = function()--检查函数，拦截则返回true
            return msg:find("add ") == 1
        end,
        run = function()--匹配后进行运行的函数
            if (apiXmlGet(tostring(group), "adminList", tostring(qq)) == "admin" or apiXmlGet("", "adminList", tostring(qq)) == "admin") or qq == admin then
                msg = msg:gsub("add ", "")
                local keyWord, answer = msg:match("(.+):(.+)")
                keyWord = kickSpace(keyWord)
                answer = kickSpace(answer)
                if not keyWord or not answer or keyWord:len() == 0 or answer:len() == 0 then
                    sendMessage("格式 add 123:123") return true
                end
                apiXmlInsert(tostring(group), "common", keyWord, answer)
                sendMessage("添加完成！\n" ..
                "词条：" .. keyWord .. "\n" ..
                "回答：" .. answer)
            else
                sendMessage("权限不足！")
            end
            return true
        end,
        explain = function()--功能解释，返回为字符串，若无需显示解释，返回nil即可
            return "add    关键词:回答"
        end
    },
    {--!delall
        check = function()
            return msg:find("delall ") == 1
        end,
        run = function()
            if (apiXmlGet(tostring(group), "adminList", tostring(qq)) == "admin" or apiXmlGet("", "adminList", tostring(qq)) == "admin") or qq == admin then
                keyWord = msg:gsub("delall ", "")
                keyWord = kickSpace(keyWord)
                apiXmlDelete(tostring(group), "common", keyWord)
                sendMessage("删除完成！\n" ..
                "词条：" .. keyWord)
            else
                sendMessage("权限不足！")
            end
            return true
        end,
        explain = function()
            return "delall 关键词"
        end
    },
    {--!del
        check = function()
            return msg:find("del ") == 1
        end,
        run = function()
            if (apiXmlGet(tostring(group), "adminList", tostring(qq)) == "admin" or apiXmlGet("", "adminList", tostring(qq)) == "admin") or qq == admin then
                msg = msg:gsub("del ", "")
                local keyWord, answer = msg:match("(.+):(.+)")
                keyWord = kickSpace(keyWord)
                answer = kickSpace(answer)
                if not keyWord or not answer or keyWord:len() == 0 or answer:len() == 0 then
                    sendMessage("格式 del 123:123") return true
                end
                apiXmlRemove(tostring(group), "common", keyWord, answer)
                sendMessage("删除完成！\n" ..
                "词条：" .. keyWord .. "\n" ..
                "回答：" .. answer)
            else
                sendMessage("权限不足！")
            end
            return true
        end,
        explain = function()
            return "del     关键词:回答"
        end
    },
    {--!list
        check = function()
            return msg:find("list ") == 1
        end,
        run = function()
            keyWord = msg:gsub("list ", "")
            keyWord = kickSpace(keyWord)
            sendMessage("本群词库内容：\n" .. apiXmlListGet(tostring(group), "common", keyWord) .. "\n\n" ..
            "全局词库内容：\n" .. apiXmlListGet("", "common", keyWord))
            return true
        end,
        explain = function()
            return "list     关键词"
        end
    },
    {--鉴黄功能
        check = function()
            return msg:find("鉴黄 ") == 1
        end,
        run = function()
            return true
        end,
        explain = function()
            return "鉴黄 开/关/踢出/禁用 --未实现"
        end
    },
    {--撤回查看功能
        check = function()
            return msg:find("撤回查看 ") == 1
        end,
        run = function()
            return true
        end,
        explain = function()
            return "撤回查看 开/关/qq 查看 --未实现"
        end
    },
    {--邀请统计
        check = function()
            return msg:find("邀请统计 ") == 1
        end,
        run = function()
            return true
        end,
        explain = function()
            return "邀请统计 开/关/ qq 查看  --未实现"
        end
    },
    {--定时 消息
        check = function()
            return msg:find("定时 ") == 1
        end,
        run = function()
            return true
        end,
        explain = function()
            return "定时 时间:消息 --每天 --未实现"
        end
    },
    {--进群问候
        check = function()
            return msg:find("进群问候 ") == 1
        end,
        run = function()
            return true
        end,
        explain = function()
            return "进群问候 信息 --未实现"
        end
    },
    {--新成员 私聊
        check = function()
            return msg:find("新成员私聊 ") == 1
        end,
        run = function()
            return true
        end,
        explain = function()
            return "新成员私聊 信息 --给新进群成员自动发送私聊 未实现"
        end
    },
    {--新成员 私聊
        check = function()
            return msg:find("成员私聊 ") == 1
        end,
        run = function()
            return true
        end,
        explain = function()
            return "成员私聊 信息 --给群内所有成员发送私聊 未实现"
        end
    },
    {--新成员 名片
        check = function()
            return msg:find("新成员 ") == 1
        end,
        run = function()
            return true
        end,
        explain = function()
            return "新成员 名片 --新成员统一设置名片 需要管理权限 未实现"
        end
    },
    {--清理未发言成员
        check = function()
            return msg:find("新成员 ") == 1
        end,
        run = function()
            return true
        end,
        explain = function()
            return "清理成员 天数 --清理多少天未发言成员 需要管理权限 未实现"
        end
    },
    {--获取成员信息
        check = function()
            return msg:find("查看资料 ") == 1
        end,
        run = function()
            if (apiXmlGet(tostring(group), "adminList", tostring(qq)) == "admin" or apiXmlGet("", "adminList", tostring(qq)) == "admin") or qq == admin then
                local dqq = msg:match("(%d+)")
                local t = cqGetMemberInfo(tonumber(group), tonumber(dqq), true)
                local info = require("app.groupmemberinfo")
                sendMessage(info(t))
            else
                sendMessage("权限不足！")
            end
            return true
        end,
        explain = function()
            return "查看资料 qq  --某个群员的信息"
        end
    },
    {--获取全部成员信息
        check = function()
            return msg:find("查看全部资料") == 1
        end,
        run = function()
            if (apiXmlGet("", "adminList", tostring(qq)) == "admin") or qq == admin then
                local dqq = msg:match("(%d+)")
                local tlist = cqGetMemberList(tonumber(group))
                local num = tlist[0]
                local list = tlist[1]

                for i = 0, num do
                    local info = require("app.groupmemberinfo")
                    sendMessage(info(list[i]))
                end
            else
                sendMessage("权限不足！")
            end
            return true
        end,
        explain = function()
            return "查看全部资料  --所有群员的信息(超管功能)"
        end
    },
    {--禁言
        check = function()
            return msg:find("禁言 ") == 1 and
            qq == admin
        end,
        run = function()
            local v = tonumber(msg:match("(%d+):"))
            local t = tonumber(msg:match(":(%d+)"))
            if t then
                cqSetGroupBanSpeak(group, v, t * 60)
                return true
            end
        end,
        explain = function()
            return "禁言 (超管功能)"
        end
    },
    {--解除禁言
        check = function()
            return msg:find("解除禁言") == 1 and
            qq == admin
        end,
        run = function()
            local q = tonumber(msg:match("(%d+)"))
            cqSetGroupBanSpeak(group, q, -1)
            return true
        end,
        explain = function()
            return "解除禁言 (超管功能)"
        end
    },
    {--全员禁言
        check = function()
            return msg:find("全员禁言") == 1 and
            qq == admin
        end,
        run = function()
            cqSetGroupWholeBanSpeak(group, true)
            return true
        end,
        explain = function()
            return "全员禁言 (超管功能)"
        end
    },
    {--解除全员禁言
        check = function()
            return msg:find("解除全员禁言") == 1 and
            qq == admin
        end,
        run = function()
            cqSetGroupWholeBanSpeak(group, false)
            return true
        end,
        explain = function()
            return "解除全员禁言 (超管功能)"
        end
    },
    {--踢人
        check = function()
            return msg:find("踢人") == 1 and
            qq == admin
        end,
        run = function()
            local q = tonumber(msg:match("(%d+)"))
            cqSetGroupMemberRemove(group, q, false)
            return true
        end,
        explain = function()
            return "踢人 (超管功能)"
        end
    },
    {--分享链接
        check = function()
            return msg:find("分享链接") == 1
        end,
        run = function()
            local q = tonumber(msg:match("(%d+)"))
            local link = cqCqCode_ShareLink("https://baike.baidu.com/item/%E6%B2%99%E9%9B%95/22847664", "标题标题标题标题标题标题标题", "内容内容内容内容内容内容内容内容内容", "http://image.baidu.com/search/detail?ct=503316480&z=undefined&tn=baiduimagedetail&ipn=d&word=%E5%9B%BE%E7%89%87&step_word=&ie=utf-8&in=&cl=2&lm=-1&st=undefined&hd=undefined&latest=undefined&copyright=undefined&cs=3775805866,1434593229&os=1732530214,201291421&simid=3377485113,378680154&pn=1&rn=1&di=131010&ln=774&fr=&fmq=1567847340283_R&fm=&ic=undefined&s=undefined&se=&sme=&tab=0&width=undefined&height=undefined&face=undefined&is=0,0&istype=0&ist=&jit=&bdtype=0&spn=0&pi=0&gsm=0&objurl=http%3A%2F%2Fphotocdn.sohu.com%2F20120708%2FImg347586981.jpg&rpstart=0&rpnum=0&adpicid=0&force=undefined")
            sendMessage(link)
            return true
        end,
        explain = function()
            return "分享链接 "
        end
    },
    {--分享群名片
        check = function()
            return msg:find("分享群名片") == 1
        end,
        run = function()
            local g = tonumber(msg:match("(%d+)"))
            if g == nil then q = 418106020 end
            local card = cqCqCode_ShareCard("group", g)
            sendMessage(card)
            return true
        end,
        explain = function()
            return "分享群名片 "
        end
    },
    {--分享QQ名片
        check = function()
            return msg:find("分享QQ名片") == 1
        end,
        run = function()
            local q = tonumber(msg:match("(%d+)"))
            if q == nil then q = 919825501 end
            local card = cqCqCode_ShareCard("qq", q)
            sendMessage(card)
            return true
        end,
        explain = function()
            return "分享QQ名片 "
        end
    },
    {--分享位置
        check = function()
            return msg:find("分享位置") == 1
        end,
        run = function()
            local gps = cqCqCode_ShareGPS("我在你家里的卧室的床上", "快来给我盖被子",20.0,30.0,15)
            sendMessage(gps)
            return true
        end,
        explain = function()
            return "分享位置 "
        end
    },
    {--发送图片
        check = function()
            return msg:find("发送图片") == 1
        end,
        run = function()
            local gps = cqCqCode_Image("1.jpg")
            sendMessage(gps)
            return true
        end,
        explain = function()
            return "发送图片 "
        end
    },
    {--发送语音
        check = function()
            return msg:find("发送语音") == 1
        end,
        run = function()
            local record = cqCqCode_Record("1.mp3")
            sendMessage(record)
            return true
        end,
        explain = function()
            return "发送语音 "
        end
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
    {--抽奖
        check = function()
            return msg == "抽奖" or msg:find("禁言") == 1
        end,
        run = function()
            local banplay = require("app.bancard")
            sendMessage(banplay(msg, qq, group))
            return true
        end,
        explain = function()
            return "抽奖/禁言卡"
        end
    },
    {--签到
        check = function()
            return msg == "签到" or msg:find("%[CQ:sign,") == 1
        end,
        run = function()
            local sign = require("app.sign")
            sendMessage(cqCode_At(qq) .. sign(qq, group))
            return true
        end,
        explain = function()
            return "签到"
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
    {--@触发
        check = function()
            return msg:find("%[CQ:at,qq=" .. cqGetLoginQQ() .. "%]") and msg:gsub("%[CQ:.-%]", ""):len() > 2
        end,
        run = function()
            sendMessage("我被猪@了")
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
            local replyGroup = group and apiXmlReplayGet(tostring(group), "common", msg) or ""
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
    -- if (tonumber(apiXmlGet(tostring(ingroup), "ban", tostring(ingroup))) or 0) > os.time() - 3600 * 24 * 30 then
    --     if inmsg:find("%(" .. tostring(cqGetLoginQQ()) .. "%) 被管理员解除禁言") then
    --         apiXmlDelete(tostring(ingroup),"ban", tostring(ingroup))
    --     elseif ingroup then
    --         return false
    --     end
    -- elseif inmsg:find("%(" .. tostring(cqGetLoginQQ()) .. "%) 被管理员禁言") then
    --     apiXmlSet(tostring(ingroup),"ban", tostring(group), tostring(os.time()))
    -- end
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
    msg, qq, group, id = inmsg, inqq, ingroup, inid
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
                handled = true
                break
            end
        end
    end
    return handled
end
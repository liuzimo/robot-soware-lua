--群管理菜单
return function (group,qq,msg)
    
--所有需要运行的app
return {
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
            if g == nil then g = 418106020 end
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
            local gps = cqCqCode_ShareGPS("我在你家里的卧室的床上", "快来给我盖被子", 20, 30, 15)
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
end
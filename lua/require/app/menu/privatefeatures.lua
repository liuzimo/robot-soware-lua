--私聊功能菜单
return function (group,qq,msg)
    
--所有需要运行的app
return {
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
            local express = require("app.express.express")
            local m = express(msg, qq)
            sendMessage(m)
            return true
        end,
        explain = function()
            return "查快递"
        end
    },
    {--快递选择
        check = function()
            return msg:find("快递选择") == 1
        end,
        run = function()
            local expresschoose = require("app.express.expresschoose")
            local m = expresschoose(msg, qq)
            sendMessage(m)
            return true
        end,
    },
    {--快递推送订阅
        check = function()
            return msg:find("订阅") == 1
        end,
        run = function()
            local expressub = require("app.express.expressub")
            local m = expressub(msg, "",qq)
            sendMessage(m)
            return true
        end,
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
            sendMessage("你可以通过 'help' 来获取一般功能帮助\n" ..
            "或者通过 'manage'来管理我 私聊和群聊有不同效果哦\n" ..
            "机器人交流群 788988268\n" ..
            "主人QQ 919825501\n" ..
            "可以把我拉到其他群里一起玩哦~ 后续功能继续开发中。。。")
            return true
        end
    },
}
end
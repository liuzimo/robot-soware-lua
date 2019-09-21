--私聊功能菜单
return function (qq,msg)
    
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
    {--短故事
        check = function()
            return msg:find("短故事")==1
        end,
        run = function()
            local story = require("app.shortstory")
            sendMessage(story())
            return true
        end,
        explain = function()
            return "短故事"
        end
    },
    {--翻译
        check = function()
            return msg:find("翻译")==1
        end,
        run = function()
            local translate = require("app.translate")
            sendMessage(translate(msg))
            return true
        end,
        explain = function()
            return "翻译"
        end
    },
    {--通用回复
        check = function()
            return admin~=-1 and not msg:find("%[CQ:")
        end,
        run = function()
            -- local replyCommon = apiXmlReplayGet("", "common", msg)
            -- sendMessage(replyCommon)
            local replyCommon = apiXmlReplayGet("","common",msg)
            local replyrecord = apiXmlReplayGet("record\\"..apiGetVar("mettle"),"replayrecord",msg)
            if replyrecord == "" and replyCommon ~= "" then
                sendMessage(replyCommon)
                return true
            elseif replyrecord ~= "" and replyCommon == "" then
                sendMessage(cqCqCode_Record(apiGetVar("mettle").."\\"..replyrecord))
                return true
            elseif replyrecord ~= "" and replyCommon ~= "" then
                sendMessage(math.random(1,10)>=5 and replyCommon or cqCqCode_Record(apiGetVar("mettle").."\\"..replyrecord))
                return true
            else
                apiHttpImageDownload("https://www.doutula.com/search?keyword="..msg,"image".."\\"..msg)
                sendMessage(cqCqCode_Image(msg.."\\"..math.random(1,10)..".jpg")==false or cqCqCode_Image(msg.."\\1.jpg") )
                return true
            end
            return true
        end
    },
    {--开机密码
        check = function()
            return msg == "我爱你" and admin==-1 
        end,
        run = function()
            -- local replyCommon = apiXmlReplayGet("", "common", msg)
            -- sendMessage(replyCommon)
            apiXmlSet("","settings", "adminqq",tostring(qq))
            admin = tostring(qq)
            return true
        end
    },
    {--初始验证
        check = function()
            return admin==-1 
        end,
        run = function()
            -- local replyCommon = apiXmlReplayGet("", "common", msg)
            -- sendMessage(replyCommon)
            sendMessage("智能机器人soware为您服务,该插件支持pro版本，请下载语音插件，并右键管理员打开酷Q，方可使用全部功能\n官方qq群：788988268\n请输入开机密码")
            return true
        end
    },
}
end
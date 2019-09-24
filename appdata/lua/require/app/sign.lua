--[[ 签到

return function (qq)
    local day = os.date("%Y年%m月%d日")--今天
    local signData = apiXmlGet("sign",tostring(qq))
    local data = signData == "" and
    {
        last = 0,--上次签到时间戳
        count = 0,--连签计数
    } or jsonDecode(signData)

    if data.last == day then
        return "你已经签过到啦"
    end

    if data.last == os.date("%Y年%m月%d日",os.time()-3600*24) then
        data.count = data.count + 1
    else
        data.count = 1
    end
    data.last = day
    local j = jsonEncode(data)
    apiXmlSet("sign",tostring(qq),j)

    local cards = apiXmlGet("banCard",tostring(qq))
    cards = cards == "" and 0 or tonumber(cards) or 0
    local banCard = math.random(1,10)
    cards = cards + banCard
    apiXmlSet("banCard",tostring(qq),tostring(cards+data.count-1))
    return "签到成功\r\n"..
    "抽中了"..tostring(banCard).."张禁言卡\r\n"..
    "附赠"..tostring(data.count-1).."张连签奖励\r\n"..
    "当前禁言卡数量："..tostring(cards)
end
]]

return function (qq,group)
    local day = os.date("%Y年%m月%d日")--今天
    local signData = apiXmlGet(tostring(group), "sign",tostring(qq))

    local data = signData == "" and
    {
        last = 0,--上次签到时间戳
        count = 0,--连签计数
    } or jsonDecode(signData)

    if data.last == day then
        return "你已经签过到啦"
    end

    if data.last == os.date("%Y年%m月%d日",os.time()-3600*24) then
        data.count = data.count + 1
    else
        data.count = 1
    end
    data.last = day
    local j = jsonEncode(data)
    apiXmlSet(tostring(group), "sign",tostring(qq),j)

    local cards = apiXmlGet(tostring(group), "banCard",tostring(qq))
    cards = cards == "" and 0 or tonumber(cards) or 0
    local banCard = 1
    cards = cards + banCard
    local assets = apiXmlGet(tostring(group), "assets",tostring(qq))
    if assets == "" then
        assets = 500
    end
    apiXmlSet(tostring(group),"assets",tostring(qq),tostring(tonumber(assets)+100))
    apiXmlSet(tostring(group), "banCard",tostring(qq),tostring(cards+data.count-1))
    return "签到成功\r\n"..
    "奖励"..tostring(banCard).."张禁言卡\r\n"..
    "附赠"..tostring(data.count-1).."张连签奖励\r\n"..
    "当前禁言卡数量："..tostring(cards).."\n"..
    "铜币增加100"
end





--抽奖
return function(msg, qq, group)

        --禁言
    if msg:find("禁言 ") then
        local v = tonumber(msg:match("(%d+)"))
        cqSetGroupBanSpeak(group, v, 1 * 60)
        return cqCode_At(qq) .. "已将" .. tostring(v) .. "禁言" .. 1 .. "分钟"
    else
        return "格式：禁言 QQ号码 "
    end
end

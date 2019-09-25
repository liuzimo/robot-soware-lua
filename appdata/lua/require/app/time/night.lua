--晚上

return function (time)
    local notice =""
    if time ==23 then
        notice = "这么晚了不要熬夜了噢，快睡觉吧"
    end
    local time = "现在是晚上"..tostring(time-12).."点！\n"
    cqSendGroupMessage(788988268,time..notice)
end

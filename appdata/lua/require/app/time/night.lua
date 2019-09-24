--晚上

return function (time)
    if time == 19 then

    elseif time ==20 then
        local notice = "这么晚了不要熬夜了噢，快睡觉吧"
    elseif time ==21 then
        local notice = "这么晚了不要熬夜了噢，快睡觉吧"
    elseif time ==22 then
        local notice = "这么晚了不要熬夜了噢，快睡觉吧"
    elseif time ==23 then
        local notice = "这么晚了不要熬夜了噢，快睡觉吧"
    elseif time ==24 then
        local notice = "这么晚了不要熬夜了噢，快睡觉吧"
    end
    local time = "现在是晚上"..tostring(time-12).."点！\n"
    cqSendGroupMessage(788988268,time..notice)
end

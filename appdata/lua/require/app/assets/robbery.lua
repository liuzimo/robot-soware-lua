--打劫金币

return function (fromgroup,fromqq,msg)
    local beingoperateqq = tonumber(msg:match("(%d+)"))
    
    local intin = apiXmlGet(tostring(fromgroup), "integral",tostring(beingoperateqq))
    if intin == "" then
        intin = 500
    elseif tonumber(intin) < 1 then
        return "对方已经没有钱了，手下留情"
    end
    
    local intbe = apiXmlGet(tostring(fromgroup), "integral",tostring(fromqq))
    if intbe == "" then
        intbe = 500
    end

    apiXmlSet(tostring(fromgroup),"integral",tostring(beingoperateqq),tostring(tonumber(intin)-100))
    apiXmlSet(tostring(fromgroup),"integral",tostring(fromqq),tostring(tonumber(intbe)+100))

    return "打劫到100铜币"
end

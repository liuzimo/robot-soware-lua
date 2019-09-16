--加群初始金币

return function (group,qq)
    apiXmlSet(tostring(group),"integral",tostring(qq),"500")
    cqSendGroupMessage(group,cqCode_At(qq).."你获得初始金币为:500")
end

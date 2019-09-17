--加群初始金币

return function (group,qq)
    apiXmlSet(tostring(group),"assets",tostring(qq),"500")
    cqSendGroupMessage(group,cqCode_At(qq).."欢迎加入本群,你获得初始资产:500铜币")
end

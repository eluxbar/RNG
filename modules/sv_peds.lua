local cfg=module("cfg/cfg_peds")

AddEventHandler("RNG:playerSpawn", function(user_id, source, first_spawn)
    local source = source
    local user_id = RNG.getUserId(source)
    if first_spawn then
        local pedAccess = {}
        local user_id = RNG.getUserId(source)
        for k,v in pairs(cfg.pedMenus) do
            for i,j in pairs(cfg.peds) do
                if v[1] == i then
                    if j['config'].permissions[1] ~= nil then
                        if RNG.hasPermission(user_id, j['config'].permissions[1]) then
                            table.insert(pedAccess, {i, v[2]})
                        end
                    else
                        table.insert(pedAccess, {i, v[2]})
                    end
                end
            end
        end
        TriggerClientEvent("RNG:buildPedMenus",source,pedAccess)
    end
end)
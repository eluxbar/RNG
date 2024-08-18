local cfg=module("cfg/cfg_respawn")

RegisterNetEvent("RNG:SendSpawnMenu")
AddEventHandler("RNG:SendSpawnMenu",function()
    local source = source
    local user_id = RNG.getUserId(source)
    local spawnTable={}
    for k,v in pairs(cfg.spawnLocations)do
        if v.permission[1] ~= nil then
            if RNG.hasPermission(RNG.getUserId(source),v.permission[1])then
                table.insert(spawnTable, k)
            end
        else
            table.insert(spawnTable, k)
        end
    end
    exports['rng']:execute("SELECT * FROM `rng_user_homes` WHERE user_id = @user_id", {user_id = user_id}, function(result)
        if result ~= nil then 
            for a,b in pairs(result) do
                table.insert(spawnTable, b.home)
            end
            if RNG.isPurge() then
                TriggerClientEvent("RNG:purgeSpawnClient",source)
            else
                TriggerClientEvent("RNG:OpenSpawnMenu",source,spawnTable)
                RNG.clearInventory(user_id) 
                RNGclient.setPlayerCombatTimer(source, {0})
            end
        end
    end)
end)
local spikes = 0
local speedzones = 0

RegisterNetEvent("RNG:placeSpike")
AddEventHandler("RNG:placeSpike", function(heading, coords)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, 'police.armoury') then
        TriggerClientEvent('RNG:addSpike', -1, coords, heading)
    end
end)

RegisterNetEvent("RNG:removeSpike")
AddEventHandler("RNG:removeSpike", function(entity)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, 'police.armoury') then
        TriggerClientEvent('RNG:deleteSpike', -1, entity)
        TriggerClientEvent("RNG:deletePropClient", -1, entity)
    end
end)

RegisterNetEvent("RNG:requestSceneObjectDelete")
AddEventHandler("RNG:requestSceneObjectDelete", function(prop)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, 'police.armoury') or RNG.hasPermission(user_id, 'hmp.menu') then
        TriggerClientEvent("RNG:deletePropClient", -1, prop)
    end
end)

RegisterNetEvent("RNG:createSpeedZone")
AddEventHandler("RNG:createSpeedZone", function(coords, radius, speed)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, 'police.armoury') or RNG.hasPermission(user_id, 'hmp.menu') then
        speedzones = speedzones + 1
        TriggerClientEvent('RNG:createSpeedZone', -1, speedzones, coords, radius, speed)
    end
end)

RegisterNetEvent("RNG:deleteSpeedZone")
AddEventHandler("RNG:deleteSpeedZone", function(speedzone)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, 'police.armoury') or RNG.hasPermission(user_id, 'hmp.menu') then
        TriggerClientEvent('RNG:deleteSpeedZone', -1, speedzones, coords, radius, speed)
    end
end)


local flaggedVehicles = {}

AddEventHandler("RNG:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        if RNG.hasPermission(user_id, 'police.armoury') then
            TriggerClientEvent('RNG:setFlagVehicles', source, flaggedVehicles)
        end
    end
end)

RegisterServerEvent("RNG:flagVehicleAnpr")
AddEventHandler("RNG:flagVehicleAnpr", function(plate, reason)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, 'police.armoury') then
        flaggedVehicles[plate] = reason
        TriggerClientEvent('RNG:setFlagVehicles', -1, flaggedVehicles)
    end
end)
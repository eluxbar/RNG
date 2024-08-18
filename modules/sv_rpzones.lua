local rpZones = {}
local numRP = 0
RegisterServerEvent("RNG:createRPZone")
AddEventHandler("RNG:createRPZone", function(a)
	local source = source
	local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, 'group.remove') then
        numRP = numRP + 1
        a['uuid'] = numRP
        rpZones[numRP] = a
        TriggerClientEvent('RNG:createRPZone', -1, a)
    end
end)

RegisterServerEvent("RNG:removeRPZone")
AddEventHandler("RNG:removeRPZone", function(b)
	local source = source
	local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, 'group.remove') then
        if next(rpZones) then
            for k,v in pairs(rpZones) do
                if v.uuid == b then
                    rpZones[k] = nil
                    TriggerClientEvent('RNG:removeRPZone', -1, b)
                end
            end
        end
    end
end)

AddEventHandler("RNG:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        for k,v in pairs(rpZones) do
            TriggerClientEvent('RNG:createRPZone', source, v)
        end
    end
end)

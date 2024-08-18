RegisterServerEvent("RNG:stretcherAttachPlayer")
AddEventHandler('RNG:stretcherAttachPlayer', function(playersrc)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, 'nhs.menu') then
        TriggerClientEvent('RNG:stretcherAttachPlayer', source, playersrc)
    end
end)

RegisterServerEvent("RNG:toggleAmbulanceDoors")
AddEventHandler('RNG:toggleAmbulanceDoors', function(stretcherNetid)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, 'nhs.menu') then
        TriggerClientEvent('RNG:toggleAmbulanceDoorStatus', -1, stretcherNetid)
    end
end)

RegisterServerEvent("RNG:updateHasStretcherInsideDecor")
AddEventHandler('RNG:updateHasStretcherInsideDecor', function(stretcherNetid, status)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, 'nhs.menu') then
        TriggerClientEvent('RNG:setHasStretcherInsideDecor', -1, stretcherNetid, status)
    end
end)

RegisterServerEvent("RNG:updateStretcherLocation")
AddEventHandler('RNG:updateStretcherLocation', function(a,b)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, 'nhs.menu') then
        TriggerClientEvent('RNG:RNG:setStretcherInside', -1, a,b)
    end
end)

RegisterServerEvent("RNG:removeStretcher")
AddEventHandler('RNG:removeStretcher', function(stretcher)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, 'nhs.menu') then
        TriggerClientEvent('RNG:deletePropClient', -1, stretcher)
    end
end)

RegisterServerEvent("RNG:forcePlayerOnToStretcher")
AddEventHandler('RNG:forcePlayerOnToStretcher', function(id, stretcher)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, 'nhs.menu') then
        TriggerClientEvent('RNG:forcePlayerOnToStretcher', id, stretcher)
    end
end)
RegisterCommand('k9', function(source)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasGroup(user_id, 'K9 Trained') then
        TriggerClientEvent('RNG:policeDogMenu', source)
    end
end)

RegisterCommand('k9attack', function(source)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasGroup(user_id, 'K9 Trained') then
        TriggerClientEvent('RNG:policeDogAttack', source)
    end
end)

RegisterNetEvent("RNG:serverDogAttack")
AddEventHandler("RNG:serverDogAttack", function(player)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasGroup(user_id, 'K9 Trained') then
        TriggerClientEvent('RNG:sendClientRagdoll', player)
    end
end)

RegisterNetEvent("RNG:policeDogSniffPlayer")
AddEventHandler("RNG:policeDogSniffPlayer", function(playerSrc)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasGroup(user_id, 'K9 Trained') then
       -- check for drugs
        local player_id = RNG.getUserId(playerSrc)
        local cdata = RNG.getUserDataTable(player_id)
        for a,b in pairs(cdata.inventory) do
            for c,d in pairs(seizeDrugs) do
                if a == c then
                    TriggerClientEvent('RNG:policeDogIndicate', source, playerSrc)
                end
            end
        end
    end
end)

RegisterNetEvent("RNG:performDogLog")
AddEventHandler("RNG:performDogLog", function(text)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasGroup(user_id, 'K9 Trained') then
        RNG.sendWebhook('police-k9', 'RNG Police Dog Logs',"> Officer Name: **"..RNG.getPlayerName(source).."**\n> Officer TempID: **"..source.."**\n> Officer PermID: **"..user_id.."**\n> Info: **"..text.."**")
    end
end)
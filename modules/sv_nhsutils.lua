local bodyBags = {}

RegisterServerEvent("RNG:requestBodyBag")
AddEventHandler('RNG:requestBodyBag', function(playerToBodyBag)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, 'nhs.menu') then
        TriggerClientEvent('RNG:placeBodyBag', playerToBodyBag)
    end
end)

RegisterServerEvent("RNG:removeBodybag")
AddEventHandler('RNG:removeBodybag', function(bodybagObject)
    local source = source
    local user_id = RNG.getUserId(source)
    TriggerClientEvent('RNG:removeIfOwned', -1, NetworkGetEntityFromNetworkId(bodybagObject))
end)

RegisterServerEvent("RNG:playNhsSound")
AddEventHandler('RNG:playNhsSound', function(sound)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, 'nhs.menu') then
        TriggerClientEvent('RNG:clientPlayNhsSound', -1, GetEntityCoords(GetPlayerPed(source)), sound)
    else
        TriggerEvent("RNG:acBan", user_id, 11, RNG.getPlayerName(source), source, 'Trigger Play NHS Sound')
    end
end)


-- a = coma
-- c = userid
-- b = permid
-- 4th ready to revive
-- name

local lifePaksConnected = {}

RegisterServerEvent("RNG:attachLifepakServer")
AddEventHandler('RNG:attachLifepakServer', function()
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, 'nhs.menu') then
        RNGclient.getNearestPlayer(source, {3}, function(nplayer)
            local nuser_id = RNG.getUserId(nplayer)
            if nuser_id ~= nil then
                RNGclient.isInComa(nplayer, {}, function(in_coma)
                    TriggerClientEvent('RNG:attachLifepak', source, in_coma, nuser_id, nplayer, RNG.getPlayerName(nplayer))
                    lifePaksConnected[user_id] = {permid = nuser_id} 
                end)
            else
                RNGclient.notify(source, {"There is no player nearby"})
            end
        end)
    else
        TriggerEvent("RNG:acBan", user_id, 11, RNG.getPlayerName(source), source, 'Trigger Attack Lifepak')
    end
end)


RegisterServerEvent("RNG:finishRevive")
AddEventHandler('RNG:finishRevive', function(permid)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, 'nhs.menu') then 
        for k,v in pairs(lifePaksConnected) do
            if k == user_id and v.permid == permid then
                TriggerClientEvent('RNG:returnRevive', source)
                RNG.giveBankMoney(user_id, 5000)
                TriggerClientEvent("RNG:phoneNotification", source, "You have been paid £5,000 for reviving this person", "NHS")
                lifePaksConnected[k] = nil
                Wait(15000)
                RNGclient.RevivePlayer(RNG.getUserSource(permid), {})
            end
        end
    else
        TriggerEvent("RNG:acBan", user_id, 11, RNG.getPlayerName(source), source, 'Trigger Finish Revive')
    end
end)


RegisterServerEvent("RNG:nhsRevive") -- nhs radial revive
AddEventHandler('RNG:nhsRevive', function(playersrc)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, 'nhs.menu') then
        RNGclient.isInComa(playersrc, {}, function(in_coma)
            if in_coma then
                TriggerClientEvent('RNG:beginRevive', source, in_coma, RNG.getUserId(playersrc), playersrc, RNG.getPlayerName(playersrc))
                lifePaksConnected[user_id] = {permid = RNG.getUserId(playersrc)} 
            end
        end)
    else
        TriggerEvent("RNG:acBan", user_id, 11, RNG.getPlayerName(source), source, 'Trigger NHS Revive')
    end
end)

local playersInCPR = {}

RegisterServerEvent("RNG:attemptCPR")
AddEventHandler('RNG:attemptCPR', function(playersrc)
    local source = source
    local user_id = RNG.getUserId(source)

    RNGclient.getNearestPlayers(source, {15}, function(nplayers)
        local targetPlayer = nplayers[playersrc]

        if targetPlayer then
            local targetPed = GetPlayerPed(playersrc)
            local targetHealth = GetEntityHealth(targetPed)

            if targetHealth > 102 then
                RNGclient.notify(source, {"This person is already healthy."})
            else
                playersInCPR[user_id] = true
                TriggerClientEvent('RNG:attemptCPR', source)

                Citizen.Wait(15000) -- Wait for 15 seconds

                if playersInCPR[user_id] then
                    local cprChance = math.random(1, 10)

                    if cprChance == 1 then
                        RNGclient.RevivePlayer(playersrc, {})
                        RNGclient.notify(playersrc, {"~b~Your life has been saved."})
                        RNGclient.notify(source, {"~b~You have saved this person's life."})
                    else
                        RNGclient.notify(source, {'~r~Failed to perform CPR.'})
                    end

                    playersInCPR[user_id] = nil
                    RNGclient.notify(source, {"~r~CPR has been canceled."})
                    TriggerClientEvent('RNG:cancelCPRAttempt', source)
                end
            end
        else
            RNGclient.notify(source, {"Player not found."})
        end
    end)
end)


RegisterServerEvent("RNG:cancelCPRAttempt")
AddEventHandler('RNG:cancelCPRAttempt', function()
    local source = source
    local user_id = RNG.getUserId(source)
    if playersInCPR[user_id] then
        playersInCPR[user_id] = nil
        RNGclient.notify(source, {"~r~CPR has been canceled."})
        TriggerClientEvent('RNG:cancelCPRAttempt', source)
    end
end)

RegisterServerEvent("RNG:syncWheelchairPosition")
AddEventHandler('RNG:syncWheelchairPosition', function(netid, coords, heading)
    local source = source
    local user_id = RNG.getUserId(source)
    entity = NetworkGetEntityFromNetworkId(netid)
    SetEntityCoords(entity, coords.x, coords.y, coords.z)
    SetEntityHeading(entity, heading)
end)

RegisterServerEvent("RNG:wheelchairAttachPlayer")
AddEventHandler('RNG:wheelchairAttachPlayer', function(entity)
    local source = source
    local user_id = RNG.getUserId(source)
    TriggerClientEvent('RNG:wheelchairAttachPlayer', -1, entity, source)
end)
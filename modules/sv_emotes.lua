RegisterNetEvent('RNG:sendSharedEmoteRequest')
AddEventHandler('RNG:sendSharedEmoteRequest', function(playersrc, emote)
    local source = source
    TriggerClientEvent('RNG:sendSharedEmoteRequest', playersrc, source, emote)
end)

RegisterNetEvent('RNG:receiveSharedEmoteRequest')
AddEventHandler('RNG:receiveSharedEmoteRequest', function(i, a)
    local source = source
    if a == -1 then 
        TriggerEvent("RNG:acBan", RNG.getUserId(source), 11, RNG.getPlayerName(source), source, "Triggering receiveSharedEmoteRequest")
    end
    TriggerClientEvent('RNG:receiveSharedEmoteRequestSource', i)
    TriggerClientEvent('RNG:receiveSharedEmoteRequest', source, a)
end)


local shavedPlayers = {}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)
        for k,v in pairs(shavedPlayers) do
            if shavedPlayers[k] then
                if shavedPlayers[k].cooldown > 0 then
                    shavedPlayers[k].cooldown = shavedPlayers[k].cooldown - 1
                else
                    shavedPlayers[k] = nil
                end
            end
        end
    end
end)

AddEventHandler("RNG:playerSpawn", function(user_id, source, first_spawn)
    SetTimeout(1000, function() 
        local source = source
        local user_id = RNG.getUserId(source)
        if first_spawn and shavedPlayers[user_id] then
            TriggerClientEvent('RNG:setAsShaved', source, (shavedPlayers[user_id].cooldown*60*1000))
        end
    end)
end)

function RNG.ShaveHead(source)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.getInventoryItemAmount(user_id, 'Shaver') >= 1 then
        RNGclient.getNearestPlayer(source,{4},function(nplayer)
            if nplayer then
                RNGclient.isPlayerSurrenderedNoProgressBar(nplayer,{},function(surrendering)
                    if surrendering then
                        RNG.tryGetInventoryItem(user_id, 'Shaver', 1)
                        TriggerClientEvent('RNG:startShavingPlayer', source, nplayer)
                        shavedPlayers[RNG.getUserId(nplayer)] = {
                            cooldown = 30,
                        }
                    else
                        RNGclient.notify(source,{'~r~This player is not on their knees.'})
                    end
                end)
            else
                RNGclient.notify(source, {"~r~No one nearby."})
            end
        end)
    end
end

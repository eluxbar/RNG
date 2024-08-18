local trainingWorlds = {}
local trainingWorldsCount = 0
RegisterCommand('trainingworlds', function(source)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, 'police.armoury') then
        TriggerClientEvent('RNG:trainingWorldSendAll', source, trainingWorlds)
        TriggerClientEvent('RNG:trainingWorldOpen', source, RNG.hasPermission(user_id, 'police.announce'))
    end
end)

RegisterNetEvent("RNG:trainingWorldCreate")
AddEventHandler("RNG:trainingWorldCreate", function()
    local source = source
    local user_id = RNG.getUserId(source)
    trainingWorldsCount = trainingWorldsCount + 1
    RNG.prompt(source,"World Name:","",function(player,worldname) 
        if string.gsub(worldname, "%s+", "") ~= '' then
            if next(trainingWorlds) then
                for k,v in pairs(trainingWorlds) do
                    if v.name == worldname then
                        RNGclient.notify(source, {"This world name already exists."})
                        return
                    elseif v.ownerUserId == user_id then
                        RNGclient.notify(source, {"You already have a world, please delete it first."})
                        return
                    end
                end
            end
            RNG.prompt(source,"World Password:","",function(player,password) 
                trainingWorlds[trainingWorldsCount] = {name = worldname, ownerName = RNG.getPlayerName(source), ownerUserId = user_id, bucket = trainingWorldsCount, members = {}, password = password}
                table.insert(trainingWorlds[trainingWorldsCount].members, user_id)
                RNG.setBucket(source, trainingWorldsCount)
                TriggerClientEvent('RNG:trainingWorldSend', -1, trainingWorldsCount, trainingWorlds[trainingWorldsCount])
                RNGclient.notify(source, {'~g~Training World Created!'})
            end)
        else
            RNGclient.notify(source, {"Invalid World Name."})
        end
    end)
end)

RegisterNetEvent("RNG:trainingWorldRemove")
AddEventHandler("RNG:trainingWorldRemove", function(world)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, 'police.announce') then
        if trainingWorlds[world] ~= nil then
            TriggerClientEvent('RNG:trainingWorldRemove', -1, world)
            for k,v in pairs(trainingWorlds[world].members) do
                local memberSource = RNG.getUserSource(v)
                if memberSource ~= nil then
                    RNG.setBucket(memberSource, 0)
                    RNGclient.notify(memberSource, {"~w~The training world you were in was deleted, you have been returned to the main dimension."})
                end
            end
            trainingWorlds[world] = nil
        end
    end
end)

RegisterNetEvent("RNG:trainingWorldJoin")
AddEventHandler("RNG:trainingWorldJoin", function(world)
    local source = source
    local user_id = RNG.getUserId(source)
    RNG.prompt(source,"Enter Password:","",function(player,password) 
        if password ~= trainingWorlds[world].password then
            RNGclient.notify(source, {"Invalid Password."})
            return
        else
            RNG.setBucket(source, world)
            table.insert(trainingWorlds[world].members, user_id)
            RNGclient.notify(source, {"~w~You have joined training world "..trainingWorlds[world].name..' owned by '..trainingWorlds[world].ownerName..'.'})
        end
    end)
end)

RegisterNetEvent("RNG:trainingWorldLeave")
AddEventHandler("RNG:trainingWorldLeave", function()
    local source = source
    local user_id = RNG.getUserId(source)
    RNG.setBucket(source, 0)
    RNGclient.notify(source, {"~w~You have left the training world."})
end)


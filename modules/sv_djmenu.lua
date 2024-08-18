local c = {}
RegisterCommand("djmenu", function(source, args, rawCommand)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasGroup(user_id,"DJ") then
        TriggerClientEvent('RNG:toggleDjMenu', source)
    end
end)
RegisterCommand("djadmin", function(source, args, rawCommand)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id,"admin.noclip") then
        TriggerClientEvent('RNG:toggleDjAdminMenu', source, c)
    end
end)
RegisterCommand("play",function(source,args,rawCommand)
    local source = source
    local user_id = RNG.getUserId(source)
    local ped = GetPlayerPed(source)
    local coords = GetEntityCoords(ped)
    local name = RNG.getPlayerName(source)
    if RNG.hasGroup(user_id,"DJ") then
        if #args > 0 then
            TriggerClientEvent('RNG:finaliseSong', source,args[1])
        end
    end
end)
RegisterServerEvent("RNG:adminStopSong")
AddEventHandler("RNG:adminStopSong", function(PARAM)
    local source = source
    for k,v in pairs(c) do
        if v[1] == PARAM then
            TriggerClientEvent('RNG:stopSong', -1,v[2])
            c[tostring(k)] = nil
            TriggerClientEvent('RNG:toggleDjAdminMenu', source, c)
        end
    end
end)
RegisterServerEvent("RNG:playDjSongServer")
AddEventHandler("RNG:playDjSongServer", function(PARAM,coords)
    local source = source
    local user_id = RNG.getUserId(source)
    local name = RNG.getPlayerName(source)
    c[tostring(source)] = {PARAM,coords,user_id,name,"true"}
    TriggerClientEvent('RNG:playDjSong', -1,PARAM,coords,user_id,name)
end)
RegisterServerEvent("RNG:skipServer")
AddEventHandler("RNG:skipServer", function(coords,param)
    local source = source
    TriggerClientEvent('RNG:skipDj', -1,coords,param)
end)
RegisterServerEvent("RNG:stopSongServer")
AddEventHandler("RNG:stopSongServer", function(coords)
    local source = source
    c[tostring(source)] = nil
    TriggerClientEvent('RNG:stopSong', -1,coords)
end)
RegisterServerEvent("RNG:updateVolumeServer")
AddEventHandler("RNG:updateVolumeServer", function(coords,volume)
    local source = source
    TriggerClientEvent('RNG:updateDjVolume', -1,coords,volume)
end)


RegisterServerEvent("RNG:requestCurrentProgressServer") -- doing this will fix the issue of the song not playing when you leave and re enter the area
AddEventHandler("RNG:requestCurrentProgressServer", function(a,b)
    TriggerClientEvent('RNG:requestCurrentProgress', -1, a, b)
end)

RegisterServerEvent("RNG:returnProgressServer") -- doing this will fix the issue of the song not playing when you leave and re enter the area
AddEventHandler("RNG:returnProgressServer", function(x,y,z)
    for k,v in pairs(c) do
        if tonumber(k) == RNG.getUserSource(x) then
            TriggerClientEvent('RNG:returnProgress', -1, x, y, z, v[1])
        end
    end
end)

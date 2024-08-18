local soundCode = math.random(143, 1000000)

RegisterServerEvent('RNG:soundCodeServer', function()
    TriggerClientEvent('RNG:soundCode', source, soundCode)
end)
RegisterServerEvent("RNG:playNuiSound", function(sound, distance, soundEventCode)
    local source = source
    local user_id = RNG.getUserId(source)
    if soundCode == soundEventCode then
        local coords = GetEntityCoords(GetPlayerPed(source))
        TriggerClientEvent("RNG:playClientNuiSound", -1, coords, sound, distance)
    else
        TriggerClientEvent("RNG:playClientNuiSound", source, coords, sound, distance)
        Wait(2500)
        TriggerEvent("RNG:acBan", user_id, 11, RNG.getPlayerName(source), source, 'Trigger Sound Event')
    end
end)

-- RegisterCommand("tomss", function(source, args)
--     local user_id = RNG.getUserId(source)
--     if user_id == 0 then
--         local distance = 15
--         if args[2] then
--             distance = tonumber(args[2])
--         end
--         TriggerClientEvent("RNG:playClientNuiSound", -1, GetEntityCoords(GetPlayerPed(RNG.getUserSource(tonumber(args[1])))), 'scream', distance)
--     end
-- end)
RegisterCommand('craftbmx', function(source)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, 'admin.tickets') then
        TriggerClientEvent("RNG:spawnNitroBMX", source)
    else
        if RNG.checkForRole(user_id, '1127282397273128991') then
            TriggerClientEvent("RNG:spawnNitroBMX", source)
        end
    end
end)

RegisterCommand('craftmoped', function(source)
    local source = source
    local user_id = RNG.getUserId(source)
    RNGclient.isPlatClub(source, {}, function(isPlatClub)
        if isPlatClub then
            TriggerClientEvent("RNG:spawnMoped", source)
        end
    end)
end)
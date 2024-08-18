RegisterNetEvent("RNG:syncEntityDamage")
AddEventHandler("RNG:syncEntityDamage", function(u, v, t, s, m, n) -- s head
    local source = source
    local playerId = RNG.getUserId(source)
    local killerId = RNG.getUserId(t)
    if killerId then
        TriggerClientEvent('RNG:onEntityHealthChange', t, GetPlayerPed(source), u, v, s)
    end
end)
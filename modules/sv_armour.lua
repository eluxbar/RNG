RegisterNetEvent("RNG:getArmour")
AddEventHandler("RNG:getArmour",function()
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, "police.armoury") then
        if RNG.hasPermission(user_id, "police.maxarmour") then
            RNGclient.setArmour(source, {100, true})
        elseif RNG.hasGroup(user_id, "Inspector Clocked") then
            RNGclient.setArmour(source, {75, true})
        elseif RNG.hasGroup(user_id, "Senior Constable Clocked") or RNG.hasGroup(user_id, "Sergeant Clocked") then
            RNGclient.setArmour(source, {50, true})
        elseif RNG.hasGroup(user_id, "PCSO Clocked") or RNG.hasGroup(user_id, "PC Clocked") then
            RNGclient.setArmour(source, {25, true})
        end
        TriggerClientEvent("RNG:PlaySound", source, "apple")
        RNGclient.notify(source, {"~g~You have received your armour."})
    else
        local player = RNG.getUserSource(user_id)
        local name = RNG.getPlayerName(source)
        Wait(500)
        TriggerEvent("RNG:acBan", user_id, 11, name, player, 'Attempted to use pd armour trigger')
    end
end)
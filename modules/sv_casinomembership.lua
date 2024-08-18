RegisterNetEvent('RNG:purchaseHighRollersMembership')
AddEventHandler('RNG:purchaseHighRollersMembership', function()
    local source = source
    local user_id = RNG.getUserId(source)
    if not RNG.hasGroup(user_id, 'Highroller') then
        if RNG.tryFullPayment(user_id,10000000) then
            RNG.addUserGroup(user_id, 'Highroller')
            TriggerClientEvent("RNG:phoneNotification", source, "You have purchased HighRollers for £10,000,000", "Casino")
            RNG.sendWebhook('purchase-highrollers',"RNG Purchased Highrollers Logs", "> Player Name: **"..RNG.getPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**")
        else
            RNGclient.notify(source, {'~r~You do not have enough money to purchase this membership.'})
        end
    else
        RNGclient.notify(source, {"~r~You already have High Roller's License."})
    end
end)

RegisterNetEvent('RNG:removeHighRollersMembership')
AddEventHandler('RNG:removeHighRollersMembership', function()
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasGroup(user_id, 'Highroller') then
        RNG.removeUserGroup(user_id, 'Highroller')
    else
        RNGclient.notify(source, {"~r~You do not have High Roller's License."})
    end
end)
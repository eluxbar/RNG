local tacoDrivers = {}

RegisterNetEvent('RNG:addTacoSeller')
AddEventHandler('RNG:addTacoSeller', function(coords, price)
    local source = source
    local user_id = RNG.getUserId(source)
    tacoDrivers[user_id] = {position = coords, amount = price}
    TriggerClientEvent('RNG:sendClientTacoData', -1, tacoDrivers)
end)

RegisterNetEvent('RNG:RemoveMeFromTacoPositions')
AddEventHandler('RNG:RemoveMeFromTacoPositions', function()
    local source = source
    local user_id = RNG.getUserId(source)
    tacoDrivers[user_id] = nil
    TriggerClientEvent('RNG:removeTacoSeller', -1, user_id)
end)

RegisterNetEvent('RNG:payTacoSeller')
AddEventHandler('RNG:payTacoSeller', function(id)
    local source = source
    local user_id = RNG.getUserId(source)
    if tacoDrivers[id] then
        if RNG.getInventoryWeight(user_id)+1 <= RNG.getInventoryMaxWeight(user_id) then
            if RNG.tryFullPayment(user_id,15000) then
                RNG.giveInventoryItem(user_id, 'Taco', 1)
                RNG.giveBankMoney(id, 15000)
                TriggerClientEvent("RNG:phoneNotification", source, 'Recieved £'..getMoneyStringFormatted(15000), "Taco Seller")
                TriggerClientEvent("RNG:PlaySound", source, "money")
            else
                RNGclient.notify(source, {'~r~You do not have enough money.'})
            end
        else
            RNGclient.notify(source, {'~r~Not enough inventory space.'})
        end
    end
end)
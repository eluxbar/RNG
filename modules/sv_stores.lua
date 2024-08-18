local cfg = module("cfg/cfg_stores")


RegisterNetEvent("RNG:BuyStoreItem")
AddEventHandler("RNG:BuyStoreItem", function(item, amount)
    local source = source
    local user_id = RNG.getUserId(source)

    for k, v in pairs(cfg.shopItems) do
        if item == v.itemID then
            local itemName = v.name

            if RNG.getInventoryWeight(user_id) <= 25 then
                if RNG.tryBankPayment(user_id, v.price * amount) then
                    RNG.giveInventoryItem(user_id, item, amount, false)
                    if item == "lotteryticket" then
                        TriggerEvent("RNG:purchaseTicket", user_id, amount)
                    end
                        TriggerClientEvent("RNG:phoneNotification", source, "Purchased " ..itemName.. " for £"..getMoneyStringFormatted(v.price * amount), "Convenience store")
                    else
                    RNGclient.notify(source, {"~r~Not enough money."})
                    TriggerClientEvent("RNG:PlaySound", source, 2)
                end
            else
                RNGclient.notify(source,{'~r~Not enough inventory space.'})
                TriggerClientEvent("RNG:PlaySound", source, 2)
            end
        end
    end
end)
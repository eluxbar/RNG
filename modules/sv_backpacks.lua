local cfg = module("cfg/cfg_backpacks")

local function buyBackpack(source,prop0,prop1,prop2,backpackname,price,size,backpackstorename)
    local user_id = RNG.getUserId(source)
    local data = RNG.getUserDataTable(user_id)
    for a,b in pairs(cfg.stores[backpackstorename]) do
        if a == backpackname then
            RNG.getSubscriptions(user_id, function(cb, plushours, plathours)
                if cb then
                    local invcap = 30
                    if plathours > 0 then
                        invcap = 50
                    elseif plushours > 0 then
                        invcap = 40
                    end
                    if data.invcap > invcap then
                        RNGclient.notify(source, {'~r~You cannot use this item as you have a backpack already!'}) return
                    end
                    if RNG.tryPayment(user_id, b[4]) then
                        RNG.updateInvCap(user_id, (RNG.getInventoryMaxWeight(user_id)+b[5]))
                        TriggerClientEvent('RNG:boughtBackpack', source, prop0, prop1, prop2, size, backpackname)
                        -- RNGclient.notify(source, {"~g~" .. backpackname .. " Purchased"})
                            TriggerClientEvent("RNG:phoneNotification", source, "Purchased " ..backpackname.. " for £"..getMoneyStringFormatted(price), "Rebel Gunstore")
                    else
                        RNGclient.notify(source, {'~r~You do not have enough money.'})
                    end
                end
            end)  
        end
    end
end

RegisterServerEvent("RNG:BuyBackpack")
AddEventHandler("RNG:BuyBackpack",function(prop0,prop1,prop2,backpackname,price,size,backpackstorename)
    local source = source
    local user_id = RNG.getUserId(source)
    local hasPerm = false
    for k,v in pairs(cfg.stores) do
        if backpackstorename == 'Rebel' and k == 'Rebel' then
            if RNG.hasPermission(user_id, 'rebellicense.whitelisted') then
                buyBackpack(source, prop0,prop1,prop2,backpackname,price,size,backpackstorename)
            else
                RNGclient.notify(source, {'~r~You do not have permissions to purchase from this store.'})
            end
        elseif backpackstorename == 'JDSports' and k == 'JDSports' then
            buyBackpack(source, prop0,prop1,prop2,backpackname,price,size,backpackstorename)
        end
    end
end)
local cfg = module("cfg/cfg_store")
local Ranks = {'Baller','Rainmaker','Kingpin','Supreme','Premium','Supporter'}
RegisterServerEvent('RNG:OpenStore')
AddEventHandler('RNG:OpenStore', function()
    local source = source
    local user_id = RNG.getUserId(source)
    if user_id ~= nil then
        ForceRefresh(source)
        TriggerClientEvent("RNG:OpenStoreMenu", source, true)
    end
end)

function RequestRank(user_id)
    for k,v in pairs(Ranks) do
        if RNG.hasGroup(user_id,v) then
            return v
        end
    end
    return 'None'
end

function ForceRefresh(source)
    local source = source
    local user_id = RNG.getUserId(source)
    exports['rng']:execute('SELECT * FROM rng_stores WHERE user_id = @user_id', {user_id = user_id}, function(result)
        storeItemsOwned = {}
        if #result > 0 then
            for a,b in pairs(result) do
                storeItemsOwned[b.code] = b.item
            end
            TriggerClientEvent('RNG:sendStoreItems', RNG.getUserSource(user_id), storeItemsOwned)
        end
    end)
end

function AddVehicle(user_id,vehicle)
    RNGclient.generateUUID(RNG.getUserSource(user_id), {"plate", 5, "alphanumeric"}, function(uuid)
        local uuid = string.upper(uuid)
        MySQL.execute("RNG/add_vehicle", {user_id = user_id, vehicle = vehicle, registration = 'P'..uuid})
    end)
end

function CreateItem(user_id, itemname, source)
    local first, second = generateUUID("Items", 4, "alphanumeric"), generateUUID("Items", 4, "alphanumeric")
    local code = string.upper(first .. "-" .. second)
    local currentDate = os.date("%d/%m/%Y")
    
    exports['rng']:execute("INSERT INTO rng_stores (code, item, user_id, date) VALUES (@code, @item, @user_id, @date)", {code = code, item = itemname, user_id = user_id, date = currentDate})
    
    Wait(100)
    
    if user_id then
        ForceRefresh(user_id)
    else
        ForceRefresh(RNG.getUserSource(source))
    end
end


AddEventHandler('RNG:playerSpawn', function(user_id,source,first_spawn)
    ForceRefresh(source)
    TriggerClientEvent('RNG:setStoreRankName', source, RequestRank(user_id))
end)



RegisterServerEvent('RNG:setInVehicleTestingBucket', function(status)
    local source = source
    if status then
        RNG.setBucket(source, 100)
    else
        RNG.setBucket(source, 0)
    end
end)

RegisterServerEvent("RNG:getStoreLockedVehicleCategories", function()
    local source = source
    local user_id = RNG.getUserId(source)
    local permissiontable = {}
    for a,b in pairs(cfg.vehicleCategoryToPermissionLookup) do
        if RNG.hasPermission(user_id,b) then
            table.insert(permissiontable,a)
        end
    end
    TriggerClientEvent("RNG:setStoreLockedVehicleCategories", source, permissiontable)
end)

RegisterServerEvent("RNG:redeemStoreItem", function(code, table)
    local source = source
    local user_id = RNG.getUserId(source)
    exports['rng']:execute('SELECT * FROM rng_stores WHERE code = @code', {code = code}, function(result)
        if #result > 0 then
            if result[1].user_id == user_id then
                if result[1].item == "1_money_bag" then
                    RNG.giveBankMoney(user_id, 1000000)
                    TriggerClientEvent("RNG:phoneNotification", source, 'Thank you for supporting RNG, enjoy your money. £'..getMoneyStringFormatted(1000000), "RNG")
                elseif result[1].item == "2_money_bag" then
                    RNG.giveBankMoney(user_id, 2000000)
                    TriggerClientEvent("RNG:phoneNotification", source, 'Thank you for supporting RNG, enjoy your money. £'..getMoneyStringFormatted(2000000), "RNG")
                elseif result[1].item == "5_money_bag" then
                    RNG.giveBankMoney(user_id, 5000000)
                    TriggerClientEvent("RNG:phoneNotification", source, 'Thank you for supporting RNG, enjoy your money. £'..getMoneyStringFormatted(5000000), "RNG")
                elseif result[1].item == "10_money_bag" then
                    RNG.giveBankMoney(user_id, 10000000)
                    TriggerClientEvent("RNG:phoneNotification", source, 'Thank you for supporting RNG, enjoy your money. £'..getMoneyStringFormatted(10000000), "RNG")
                elseif result[1].item == "20_money_bag" then
                    RNG.giveBankMoney(user_id, 20000000)
                    TriggerClientEvent("RNG:phoneNotification", source, 'Thank you for supporting RNG, enjoy your money. £'..getMoneyStringFormatted(20000000), "RNG")
                elseif result[1].item == "30_money_bag" then
                    RNG.giveBankMoney(user_id, 30000000)
                    TriggerClientEvent("RNG:phoneNotification", source, 'Thank you for supporting RNG, enjoy your money. £'..getMoneyStringFormatted(30000000), "RNG")
                elseif result[1].item == "100_money_bag" then
                    RNG.giveBankMoney(user_id, 100000000)
                    TriggerClientEvent("RNG:phoneNotification", source, 'Thank you for supporting RNG, enjoy your money. £'..getMoneyStringFormatted(100000000), "RNG")
                elseif result[1].item == "250_money_bag" then
                    RNG.giveBankMoney(user_id, 250000000)
                    TriggerClientEvent("RNG:phoneNotification", source, 'Thank you for supporting RNG, enjoy your money. £'..getMoneyStringFormatted(250000000), "RNG")
                elseif result[1].item == "500_money_bag" then
                    RNG.giveBankMoney(user_id, 500000000)
                    TriggerClientEvent("RNG:phoneNotification", source, 'Thank you for supporting RNG, enjoy your money. £'..getMoneyStringFormatted(500000000), "RNG")
                elseif result[1].item == "rng_plus" then
                    RNG.getSubscriptions(user_id, function(cb, plushours, plathours)
                       if cb then
                            MySQL.execute("subscription/set_plushours", {user_id = user_id, plushours = plushours + 720})
                        end
                    end)
                elseif result[1].item == "rng_platinum" then
                    RNG.getSubscriptions(user_id, function(cb, plushours, plathours)
                        if cb then
                             MySQL.execute("subscription/set_plathours", {user_id = user_id, plathours = plathours + 720})
                         end
                    end)
                elseif result[1].item == "import_slot" then
                    AddVehicle(user_id,table.customCar)
                elseif result[1].item == "supporter" then
                    AddVehicle(user_id,table.vipCar1)
                    RNG.giveBankMoney(user_id, 1000000)
                    TriggerClientEvent("RNG:phoneNotification", source, 'Supporter Recieved. £'..getMoneyStringFormatted(1000000), "RNG")
                    RNG.addUserGroup(user_id,"Supporter")
                elseif result[1].item == "premium" then
                    AddVehicle(user_id,table.vipCar1)
                    RNG.giveBankMoney(user_id, 1500000)
                    TriggerClientEvent("RNG:phoneNotification", source, 'Premium Recieved. £'..getMoneyStringFormatted(1500000), "RNG")
                    RNG.addUserGroup(user_id,"Premium")
                elseif result[1].item == "supreme" then
                    AddVehicle(user_id,table.vipCar1)
                    AddVehicle(user_id,table.vipCar2)
                    RNG.giveBankMoney(user_id, 2500000)
                    TriggerClientEvent("RNG:phoneNotification", source, 'Supreme Recieved. £'..getMoneyStringFormatted(2500000), "RNG")
                    RNG.addUserGroup(user_id,"Supreme")
                elseif result[1].item == "kingpin" then
                    AddVehicle(user_id,table.vipCar1)
                    AddVehicle(user_id,table.vipCar2)
                    RNG.giveBankMoney(user_id, 5000000)
                    TriggerClientEvent("RNG:phoneNotification", source, 'Kingpin Recieved. £'..getMoneyStringFormatted(5000000), "RNG")
                    RNG.addUserGroup(user_id,"Kingpin")
                    if table.customCar1 == nil then
                        CreateItem(user_id,"import_slot")
                    else
                        AddVehicle(user_id,table.customCar1)
                    end
                elseif result[1].item == "rainmaker" then
                    AddVehicle(user_id,table.vipCar1)
                    AddVehicle(user_id,table.vipCar2)
                    AddVehicle(user_id,table.vipCar3)
                    RNG.giveBankMoney(user_id, 5000000)
                    RNG.addUserGroup(user_id,"Rainmaker")
                    TriggerClientEvent("RNG:phoneNotification", source, 'Rainmaker Recieved. £'..getMoneyStringFormatted(5000000), "RNG")
                    if table.customCar1 == nil then
                        CreateItem(user_id,"import_slot")
                    else
                        AddVehicle(user_id,table.customCar1)
                    end
                    if table.customCar2 == nil then
                        CreateItem(user_id,"import_slot")
                    else
                        AddVehicle(user_id,table.customCar2)
                    end
                    if table.customCar3 == nil then
                        CreateItem(user_id,"import_slot")
                    else
                        AddVehicle(user_id,table.customCar3)
                    end
                elseif result[1].item == "baller" then
                    RNG.giveBankMoney(user_id, 100000000)
                    TriggerClientEvent("RNG:phoneNotification", source, 'Baller Recieved. £'..getMoneyStringFormatted(100000000), "RNG")
                    RNG.addUserGroup(user_id,"Baller")
                    CreateItem(user_id,"lock_slot")
                    AddVehicle(user_id,table.vipCar1)
                    AddVehicle(user_id,table.vipCar2)
                    AddVehicle(user_id,table.vipCar3)
                    AddVehicle(user_id,table.vipCar4)
                    if table.customCar1 == nil then
                        CreateItem(user_id,"import_slot")
                    else
                        AddVehicle(user_id,table.customCar1)
                    end
                    if table.customCar2 == nil then
                        CreateItem(user_id,"import_slot")
                    else
                        AddVehicle(user_id,table.customCar2)
                    end
                    if table.customCar3 == nil then
                        CreateItem(user_id,"import_slot")
                    else
                        AddVehicle(user_id,table.customCar3)
                    end
                    if table.customCar4 == nil then
                        CreateItem(user_id,"import_slot")
                    else
                        AddVehicle(user_id,table.customCar4)
                    end
                    if table.customCar5 == nil then
                        CreateItem(user_id,"import_slot")
                    else
                        AddVehicle(user_id,table.customCar5)
                    end
                    if table.customCar6 == nil then
                        CreateItem(user_id,"import_slot")
                    else
                        AddVehicle(user_id,table.customCar6)
                    end
                end
                exports['rng']:execute("DELETE FROM rng_stores WHERE code = @code", {code = code})
                TriggerClientEvent('RNG:smallAnnouncement', source, cfg.items[result[1].item].name, "Successfully redeemed " .. cfg.items[result[1].item].name .. "!", 18, 10000)
                RNG.sendWebhook('store-redeem', "RNG Store Logs", "> Player PermID: **" .. user_id .. "**\n> Item: **" .. cfg.items[result[1].item].name .. "**")
                TriggerEvent("RNG:refreshGaragePermissions",source)
                TriggerClientEvent("RNG:storeDrawEffects", source)
                Wait(250)
                TriggerClientEvent("RNG:storeCloseMenu",source)
                ForceRefresh(source)
            end
        end
    end)
end)

RegisterServerEvent("RNG:startSellStoreItem", function(code)
    local source = source
    local user_id = RNG.getUserId(source)

    exports['rng']:execute('SELECT * FROM rng_stores WHERE code = @code', {code = code}, function(result)
        if #result > 0 then
            local itemname = cfg.items[result[1].item].name

            RNGclient.getNearestPlayers(source, {5}, function(players)
                local usrList = ""
                for a, b in pairs(players) do
                    usrList = usrList .. "[" .. a .. "]" .. RNG.getPlayerName(a) .. " | "
                end

                RNG.prompt(source, "Sell to: " .. usrList, "", function(source, player_id)  -- Change playersource to player_id
                    if player_id ~= nil and player_id ~= "" then
                        player_id = tonumber(player_id)

                        if players[player_id] then
                            RNG.prompt(source, "Amount:", "", function(source, amount)
                                if tonumber(amount) and tonumber(amount) >= 0 then
                                    local buyer_id = RNG.getUserId(player_id)  -- Get the buyer's user_id

                                    RNGclient.notify(source, {"~g~Offer sent for " .. RNG.getPlayerName(player_id) .. " to buy " .. itemname .. " for £" .. getMoneyStringFormatted(tonumber(amount)) .. "!"})

                                    RNG.request(player_id, RNG.getPlayerName(source) .. " is selling you a " .. itemname .. " for £" .. getMoneyStringFormatted(tonumber(amount)), 30, function(player_id, ok)
                                        if ok then
                                            if RNG.tryFullPayment(buyer_id, tonumber(amount)) then
                                                exports['rng']:execute("UPDATE rng_stores SET user_id = @user_id WHERE code = @code", {user_id = buyer_id, code = code})
                                                exports['rng']:execute("UPDATE rng_stores SET date = @date WHERE code = @code", {date = os.date("%d/%m/%Y"), code = code})
                                                exports['rng']:execute("UPDATE rng_stores SET seller_id = @seller_id WHERE code = @code", {seller_id = user_id, code = code})
                                                Wait(250)
                                                TriggerClientEvent("RNG:storeCloseMenu", source)
                                                ForceRefresh(source)
                                                TriggerClientEvent("RNG:storeCloseMenu", player_id)
                                                ForceRefresh(player_id)
                                                RNG.giveBankMoney(user_id, tonumber(amount))
                                                TriggerClientEvent("RNG:phoneNotification", source, "Successfully sold "..itemname.." for £"..getMoneyStringFormatted(tonumber(amount)), "RNG")
                                                TriggerClientEvent("RNG:phoneNotification", source, "Successfully bought "..itemname.." for £"..getMoneyStringFormatted(tonumber(amount)), "RNG")
                                                RNG.sendWebhook('store-sell', "RNG Store Logs", "> Seller PermID: **" .. user_id .. "**\n> Buyer PermID: **" .. buyer_id .. "**\n> Item: **" .. itemname .. "**\n> Amount: **£" .. getMoneyStringFormatted(tonumber(amount)) .. "**")
                                            else
                                                RNGclient.notify(source, {"~r~" .. RNG.getPlayerName(player_id) .. " does not have enough money!"})
                                                RNGclient.notify(player_id, {"~r~You do not have enough money!"})
                                            end
                                        else
                                            RNGclient.notify(source, {"~r~" .. RNG.getPlayerName(player_id) .. " declined your offer!"})
                                            RNGclient.notify(player_id, {"~r~You declined the offer!"})
                                        end
                                    end)
                                else
                                    RNGclient.notify(source, {"~r~Invalid Amount!"})
                                end
                            end)
                        else
                            RNGclient.notify(source, {"~r~Invalid player!"})
                        end
                    else
                        RNGclient.notify(source, {"~r~Invalid player!"})
                    end
                end)
            end)
        else
            RNGclient.notify(source, {"~r~Invalid code!"})
        end
    end)
end)





RegisterCommand('cheatunban', function(source, args)
    if source ~= 0 then return end; -- Stops anyone other than the console running it.
    if tonumber(args[1])  then
        local userid = tonumber(args[1])
        RNG.setBanned(userid,false)
        RNG.sendWebhook('store-unban', "RNG Store Unban Logs", "> Player PermID: **" .. userid .. "**")
        print('Unbanned user: ' .. userid )
    else 
        print('Incorrect usage: unban [permid]')
    end
end)

RegisterCommand('storeunban', function(source, args)
    if source ~= 0 then return end -- Stops anyone other than the console running it.

    if tonumber(args[1]) then
        local userid = tonumber(args[1])

        exports['rng']:execute('SELECT banreason FROM rng_users WHERE id = ?', {userid}, function(result)
            if result[1] and result[1].banreason and string.find(result[1].banreason, "cheating") then
                -- The ban reason includes "cheating", so we won't unban the user.
                print('User with PermID ' .. userid .. ' has a cheating ban reason. Not unbanning.')
            else
                -- The ban reason does not include "cheating", so we unban the user.
                exports['rng']:execute('UPDATE rng_users SET banned = 0 WHERE id = ?', {userid})
                RNG.sendWebhook('store-unban', "RNG Cheating Unban Logs", "> Player PermID: **" .. userid .. "**")
                print('Unbanned user: ' .. userid)
            end
        end)
    else
        print('Incorrect usage: unban [permid]')
    end
end)

RegisterCommand("additem", function(source, args, raw)
    if source == 0 then
        local user_id, item = args[1], args[2]
        if user_id and item then
            local code1, code2 = generateUUID("Items", 4, "alphanumeric"), generateUUID("Items", 4, "alphanumeric")
            local code = string.upper(code1 .. "-" .. code2)
            local rng = exports['rng']
            local currentDate = os.date("%d/%m/%Y")
            local insertQuery = "INSERT INTO rng_stores (code, item, user_id, date) VALUES (@code, @item, @user_id, @date)"
            local queryParams = {code = code, item = item, user_id = user_id, date = currentDate}
            
            print("Added item: " .. item .. " to user: " .. user_id)
            RNG.sendWebhook('donation', "RNG Donation Logs", "> Player PermID: **"..user_id.."**\n> Code: **"..code.."**\n> Item: **"..item.."**")
            
            rng:execute(insertQuery, queryParams)
        else
            print("Usage: additem [user_id] [item]")
        end
    end
end)

RegisterCommand("storelog", function(source, args)
    local user_id = args[1] or "N/A"
    local transaction = args[2] or "N/A"
    local price = args[3] or "N/A"
    local packageName = args[4] or "N/A"
    local email = args[5] or "N/A"
    if price == "£0.00" then
        price = "Free"
    end
    RNG.sendWebhook('tebex', "RNG Tebex Logs", "> Player Perm ID: **"..user_id.."**\n> Transaction ID: **"..transaction.."**\n> Price: **£"..price.."**\n> Package: **"..packageName.."**\n> Email: **"..email.."**")
end, true)

RegisterCommand("storelogchargeback", function(source, args)
    local user_id = args[1]
    local transaction = args[2]
    local price = args[3]
    local packageName = args[4]
    local email = args[5]
    RNG.setBanned(user_id,true,"perm","1.8 Chargeback","RNG Store",transaction)
    RNG.sendWebhook('tebex', "RNG Tebex Charge Back Logs", "> Player Perm ID: **"..user_id.."**\n> Transaction: **"..transaction.."**\n> Price: **£"..price.."**\n> Package: **"..packageName.."**\n> Email: **"..email.."**\n > User Banned: **1.8 Chargeback**")
end, true)

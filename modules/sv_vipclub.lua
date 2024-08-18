MySQL.createCommand("subscription/set_plushours","UPDATE rng_subscriptions SET plushours = @plushours WHERE user_id = @user_id")
MySQL.createCommand("subscription/set_plathours","UPDATE rng_subscriptions SET plathours = @plathours WHERE user_id = @user_id")
MySQL.createCommand("subscription/set_lastused","UPDATE rng_subscriptions SET last_used = @last_used WHERE user_id = @user_id")
MySQL.createCommand("subscription/get_subscription","SELECT * FROM rng_subscriptions WHERE user_id = @user_id")
MySQL.createCommand("subscription/get_all_subscriptions","SELECT * FROM rng_subscriptions")
MySQL.createCommand("subscription/add_id", "INSERT IGNORE INTO rng_subscriptions SET user_id = @user_id, plushours = 0, plathours = 0, last_used = ''")

AddEventHandler("playerJoining", function()
    local user_id = RNG.getUserId(source)
    MySQL.execute("subscription/add_id", {user_id = user_id})
end)

function RNG.getSubscriptions(user_id,cb)
    MySQL.query("subscription/get_subscription", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
           cb(true, rows[1].plushours, rows[1].plathours, rows[1].last_used)
        else
            cb(false)
        end
    end)
end

RegisterNetEvent("RNG:setPlayerSubscription")
AddEventHandler("RNG:setPlayerSubscription", function(playerid, subtype)
    local user_id = RNG.getUserId(source)
    local player = RNG.getUserSource(user_id)
    if RNG.hasGroup(user_id, "Founder") or RNG.hasGroup(user_id, 'Developer') or RNG.hasGroup(user_id, 'Lead Developer') or RNG.hasGroup(user_id, 'Operations Manager') or RNG.hasGroup(user_id, 'Staff Manager') or RNG.hasGroup(user_id, 'Community Manager') then
        RNG.prompt(player,"Number of days ","",function(player, hours)
            if tonumber(hours) and tonumber(hours) >= 0 then
                hours = hours * 24
                if subtype == "Plus" then
                    MySQL.execute("subscription/set_plushours", {user_id = playerid, plushours = hours})
                elseif subtype == "Platinum" then
                    MySQL.execute("subscription/set_plathours", {user_id = playerid, plathours = hours})
                end
                TriggerClientEvent('RNG:userSubscriptionUpdated', player)
            else
                RNGclient.notify(player,{"~r~Number of days must be a number."})
            end
        end)
    else
        TriggerEvent("RNG:acBan", user_id, 11, RNG.getPlayerName(player), player, 'Trigger Set Player Subscription')
    end
end)

RegisterNetEvent("RNG:getPlayerSubscription")
AddEventHandler("RNG:getPlayerSubscription", function(playerid)
    local user_id = RNG.getUserId(source)
    local player = RNG.getUserSource(user_id)
    if playerid ~= nil then
        RNG.getSubscriptions(playerid, function(cb, plushours, plathours)
            if cb then
                TriggerClientEvent('RNG:getUsersSubscription', player, playerid, plushours, plathours)
            else
                RNGclient.notify(player, {"~r~Player not found."})
            end
        end)
    else
        RNG.getSubscriptions(user_id, function(cb, plushours, plathours)
            if cb then
                TriggerClientEvent('RNG:setVIPClubData', player, plushours, plathours)
            end
        end)
    end
end)

RegisterNetEvent("RNG:beginSellSubscriptionToPlayer")
AddEventHandler("RNG:beginSellSubscriptionToPlayer", function(subtype)
    local user_id = RNG.getUserId(source)
    local player = RNG.getUserSource(user_id)
    RNGclient.getNearestPlayers(player,{15},function(nplayers) --get players nearby
        usrList = ""
        for k, v in pairs(nplayers) do
            usrList = usrList .. "[" .. RNG.getUserId(k) .. "]" .. RNG.getPlayerName(k) .. " | "
        end
        if usrList ~= "" then
            RNG.prompt(player,"Players Nearby: " .. usrList .. "","",function(player, target_id) --ask for id
                target_id = target_id
                if target_id ~= nil and target_id ~= "" then --validation
                    local target = RNG.getUserSource(tonumber(target_id)) --get source of the new owner id
                    if target ~= nil then
                        RNG.prompt(player,"Number of days ","",function(player, hours) -- ask for number of hours
                            if tonumber(hours) and tonumber(hours) > 0 then
                                MySQL.query("subscription/get_subscription", {user_id = user_id}, function(rows, affected)
                                    sellerplushours = rows[1].plushours
                                    sellerplathours = rows[1].plathours
                                    if (subtype == 'Plus' and sellerplushours >= tonumber(hours)*24) or (subtype == 'Platinum' and sellerplathours >= tonumber(hours)*24) then
                                        RNG.prompt(player,"Price £: ","",function(player, amount) --ask for price
                                            if tonumber(amount) and tonumber(amount) > 0 then
                                                RNG.request(target,RNG.getPlayerName(player).." wants to sell: " ..hours.. " days of "..subtype.." subscription for £"..getMoneyStringFormatted(amount), 30, function(target,ok) --request player if they want to buy sub
                                                    if ok then --bought
                                                        MySQL.query("subscription/get_subscription", {user_id = RNG.getUserId(target)}, function(rows, affected)
                                                            if subtype == "Plus" then
                                                                if RNG.tryFullPayment(RNG.getUserId(target),tonumber(amount)) then
                                                                    MySQL.execute("subscription/set_plushours", {user_id = RNG.getUserId(target), plushours = rows[1].plushours + tonumber(hours)*24})
                                                                    MySQL.execute("subscription/set_plushours", {user_id = user_id, plushours = sellerplushours - tonumber(hours)*24})
                                                                    TriggerClientEvent("RNG:phoneNotification", player, 'You have sold '..hours..' days of '..subtype..' subscription to '..RNG.getPlayerName(target)..' for £'..getMoneyStringFormatted(amount), "RNG Studios")
                                                                    TriggerClientEvent("RNG:phoneNotification", target, '~g~'..RNG.getPlayerName(player)..' has sold '..hours..' days of '..subtype..' subscription to you for £'..getMoneyStringFormatted(amount), "RNG Studios")
                                                                    RNG.giveBankMoney(user_id,tonumber(amount))
                                                                    RNG.updateInvCap(RNG.getUserId(target), 40)
                                                                else
                                                                    RNGclient.notify(player,{"~r~".. RNG.getPlayerName(target).." doesn't have enough money!"}) --notify original owner
                                                                    RNGclient.notify(target,{"~r~You don't have enough money!"}) --notify new owner
                                                                end
                                                            elseif subtype == "Platinum" then
                                                                if RNG.tryFullPayment(RNG.getUserId(target),tonumber(amount)) then
                                                                    MySQL.execute("subscription/set_plathours", {user_id = RNG.getUserId(target), plathours = rows[1].plathours + tonumber(hours)*24})
                                                                    MySQL.execute("subscription/set_plathours", {user_id = user_id, plathours = sellerplathours - tonumber(hours)*24})
                                                                    TriggerClientEvent("RNG:phoneNotification", player, 'You have sold '..hours..' days of '..subtype..' subscription to '..RNG.getPlayerName(target)..' for £'..getMoneyStringFormatted(amount), "RNG Studios")
                                                                    TriggerClientEvent("RNG:phoneNotification", target, '~g~'..RNG.getPlayerName(player)..' has sold '..hours..' days of '..subtype..' subscription to you for £'..getMoneyStringFormatted(amount), "RNG Studios")
                                                                    RNG.giveBankMoney(user_id,tonumber(amount))
                                                                    RNG.updateInvCap(RNG.getUserId(target), 50)
                                                                    TriggerClientEvent('RNG:refreshGunStorePermissions', target)
                                                                else
                                                                    RNGclient.notify(player,{"~r~".. RNG.getPlayerName(target).." doesn't have enough money!"}) --notify original owner
                                                                    RNGclient.notify(target,{"~r~You don't have enough money!"}) --notify new owner
                                                                end
                                                            end
                                                        end)
                                                    else
                                                        RNGclient.notify(player,{"~r~"..RNG.getPlayerName(target).." has refused to buy " ..hours.. " days of "..subtype.." subscription for £"..amount}) --notify owner that refused
                                                        RNGclient.notify(target,{"~r~You have refused to buy " ..hours.. " days of "..subtype.." subscription for £"..amount}) --notify new owner that refused
                                                    end
                                                end)
                                            else
                                                RNGclient.notify(player,{"~r~Price of subscription must be a number."})
                                            end
                                        end)
                                    else
                                        RNGclient.notify(player,{"~r~You do not have "..hours.." days of "..subtype.."."})
                                    end
                                end)
                            else
                                RNGclient.notify(player,{"~r~Number of days must be a number."})
                            end
                        end)
                    else
                        RNGclient.notify(player,{"~r~That Perm ID seems to be invalid!"}) --couldnt find perm id
                    end
                else
                    RNGclient.notify(player,{"~r~No Perm ID selected!"}) --no perm id selected
                end
            end)
        else
            RNGclient.notify(player,{"~r~No players nearby!"}) --no players nearby
        end
    end)
end)

local usertable = {}
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)
        MySQL.query("subscription/get_all_subscriptions", {}, function(rows, affected)
            if #rows > 0 then
                for k,v in pairs(rows) do
                    if v.plushours > 0 or v.plathours > 0 then
                        local user_id = v.user_id
                        local plushours = v.plushours
                        local plathours = v.plathours
                        local user = RNG.getUserSource(user_id)
                        usertable[user_id] = {}
                        if plushours >= 1/60 then
                            usertable[user_id].plushours = plushours-1/60
                        else
                            usertable[user_id].plushours = 0
                        end
                        if plathours >= 1/60 then
                            usertable[user_id].plathours = plathours-1/60
                        else
                            usertable[user_id].plathours = 0
                        end
                        if user ~= nil then
                            TriggerClientEvent('RNG:setVIPClubData', user, usertable[user_id].plushours, usertable[user_id].plathours)
                        end
                    end
                end
                SetAllUsers(usertable)
            end
        end)
    end
end)



function SetAllUsers(tbl)
    for A,B in pairs(tbl) do
        MySQL.execute("subscription/set_plushours", {user_id = A, plushours = B.plushours})
        MySQL.execute("subscription/set_plathours", {user_id = A, plathours = B.plathours})
        Wait(250)
    end
end

RegisterNetEvent("RNG:claimWeeklyKit")
AddEventHandler("RNG:claimWeeklyKit", function()
    local source = source
    local user_id = RNG.getUserId(source)
    local name = RNG.getPlayerName(source)
    local claimedWeapons = {"M1911", "OLYMPIA", "UMP45", "Morphine", "Taco"}
    local weaponsString = table.concat(claimedWeapons, ", ")
    RNG.getSubscriptions(user_id, function(cb, plushours, plathours, last_used)
        if cb then
            if plathours >= 168 or plushours >= 168 then
                if last_used == '' or (os.time() >= tonumber(last_used+24*60*60*7)) then
                    if plathours >= 168 then
                        RNG.giveInventoryItem(user_id, "Morphine", 5, true)
                        RNG.giveInventoryItem(user_id, "Taco", 5, true)
                        RNGclient.giveWeapons(source, {{['WEAPON_M1911'] = {ammo = 250}}, false})
                        RNGclient.giveWeapons(source, {{['WEAPON_OLYMPIA'] = {ammo = 250}}, false})
                        RNGclient.giveWeapons(source, {{['WEAPON_UMP45'] = {ammo = 250}}, false})
                        RNGclient.setArmour(source, {100, true})
                        MySQL.execute("subscription/set_lastused", {user_id = user_id, last_used = os.time()})
                        RNG.sendWebhook("rngplatclubkit","RNG Platinum Club Log","> Players Name: **" .. name .. "**\n> Players Perm ID: **" .. user_id .. "**\n> Weapons/Items: **" .. weaponsString .. "**")
                    elseif plushours >= 168 then
                        local claimedWeapons2 = {"M1911", "OLYMPIA", "UMP45", "Morphine", "Taco"}
                        local weaponsString2 = table.concat(claimedWeapons2, ", ")
                        RNG.giveInventoryItem(user_id, "Morphine", 5, true)
                        RNG.giveInventoryItem(user_id, "Taco", 5, true)
                        RNGclient.giveWeapons(source, {{['WEAPON_M1911'] = {ammo = 250}}, false})
                        RNGclient.giveWeapons(source, {{['WEAPON_UMP45'] = {ammo = 250}}, false})
                        RNGclient.setArmour(source, {100, true})
                        MySQL.execute("subscription/set_lastused", {user_id = user_id, last_used = os.time()})
                        RNG.sendWebhook("rngplusclubkit","RNG Plus Club Log","> Players Name: **" .. name .. "**\n> Players Perm ID: **" .. user_id .. "**\n> Weapons/Items: **" .. weaponsString2 .. "**")
                    else
                        RNGclient.notify(source,{"~r~You need at least 1 week of subscription to redeem the kit."})
                    end
                else
                    RNGclient.notify(source,{"~r~You can only claim your weekly kit once a week."})
                end
            else
                RNGclient.notify(source,{"~r~You require at least 1 week of a subscription to claim a kit."})
            end
        end
    end)
end)


RegisterNetEvent("RNG:fuelAllVehicles")
AddEventHandler("RNG:fuelAllVehicles", function()
    local source = source
    local user_id = RNG.getUserId(source)
    RNG.getSubscriptions(user_id, function(cb, plushours, plathours)
        if cb then
            if plushours > 0 or plathours > 0 then
                if RNG.tryFullPayment(user_id,25000) then
                    exports["rng"]:execute("UPDATE rng_user_vehicles SET fuel_level = 100 WHERE user_id = @user_id", {user_id = user_id}, function() end)
                    TriggerClientEvent("RNG:PlaySound", source, "money")
                    RNGclient.notify(source,{"~g~Vehicles Refueled."})
                end
            end
        end
    end)
end)

RegisterNetEvent("RNG:fuelAllVehicles1")
AddEventHandler("RNG:fuelAllVehicles1", function()
    local source = source
    local user_id = RNG.getUserId(source)
    RNG.getSubscriptions(user_id, function(cb, plushours, plathours)
        if cb then
            if plushours == 0 or plathours == 0 then
                if RNG.tryFullPayment(user_id, 100000) then
                    exports["rng"]:execute("UPDATE rng_user_vehicles SET fuel_level = 100 WHERE user_id = @user_id", {user_id = user_id}, function() end)
                    TriggerClientEvent("RNG:PlaySound", source, "money")
                    RNGclient.notify(source,{"~g~Vehicles Refueled."})
                end
            end
        end
    end)
end)

RegisterCommand('redeem', function(source)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.checkForRole(user_id, '1189718623548350606') then
        MySQL.query("subscription/get_subscription", {user_id = user_id}, function(rows, affected)
            if #rows > 0 then
                local redeemed = rows[1].redeemed
                if redeemed == 0 then
                    exports["rng"]:execute("UPDATE rng_subscriptions SET redeemed = 1 WHERE user_id = @user_id", {user_id = user_id}, function() end)
                    RNG.giveBankMoney(user_id, 1000000)
                    TriggerClientEvent('RNG:smallAnnouncement', source, 'RNG Studios', "You have redeemed your perks of £1,000,000 and 2 Week of Platinum Subscription!\n", 18, 10000)
                    MySQL.execute("subscription/set_plathours", {user_id = user_id, plathours = rows[1].plathours + 336})
                else
                    RNGclient.notify(source, {'~r~You have already redeemed your subscription.'})
                end
            end
        end)
    else
        RNGclient.notify(source, {'~r~You Have Not Boosted The Discord Server'})
    end
end)
ownedGaffs = {}
local cfg = module("cfg/cfg_housing")

--SQL

MySQL = module("modules/MySQL")

MySQL.createCommand("RNG/get_address","SELECT home, number FROM rng_user_homes WHERE user_id = @user_id")
MySQL.createCommand("RNG/get_home_owner","SELECT user_id FROM rng_user_homes WHERE home = @home AND number = @number")
MySQL.createCommand("RNG/rm_address","DELETE FROM rng_user_homes WHERE user_id = @user_id AND home = @home")
MySQL.createCommand("RNG/set_address","REPLACE INTO rng_user_homes(user_id,home,number) VALUES(@user_id,@home,@number)")
MySQL.createCommand("RNG/fetch_rented_houses", "SELECT * FROM rng_user_homes WHERE rented = 1")
MySQL.createCommand("RNG/rentedupdatehouse", "UPDATE rng_user_homes SET user_id = @id, rented = @rented, rentedid = @rentedid, rentedtime = @rentedunix WHERE user_id = @user_id AND home = @home")

Citizen.CreateThread(function()
    while true do
        Wait(300000)
        MySQL.query('RNG/fetch_rented_houses', {}, function(rentedhouses)
            for i,v in pairs(rentedhouses) do 
               if os.time() > tonumber(v.rentedtime) then
                  MySQL.execute('RNG/rentedupdatehouse', {id = v.rentedid, rented = 0, rentedid = "", rentedunix = "", user_id = v.user_id, home = v.home})
               end
            end
        end)
    end
end)

function getUserAddress(user_id, cbr)
    local task = Task(cbr)
  
    MySQL.query("RNG/get_address", {user_id = user_id}, function(rows, affected)
        task({rows[1]})
    end)
end
  
function setUserAddress(user_id, home, number)
    MySQL.execute("RNG/set_address", {user_id = user_id, home = home, number = number})
end
  
function removeUserAddress(user_id, home)
    MySQL.execute("RNG/rm_address", {user_id = user_id, home = home})
end

function getUserByAddress(home, number, cbr)
    local task = Task(cbr)
  
    MySQL.query("RNG/get_home_owner", {home = home, number = number}, function(rows, affected)
        if #rows > 0 then
            task({rows[1].user_id})
        else
            task()
        end
    end)
end

function leaveHome(user_id, home, number, cbr)
    local task = Task(cbr)
    local player = RNG.getUserSource(user_id)
    RNG.setBucket(player, 0)
    for k, v in pairs(cfg.homes) do
        if k == home then
            local x,y,z = table.unpack(v.entry_point)
            RNGclient.teleport(player, {x,y,z})
            RNGclient.setInHome(player, {false})
            task({true})
        end
    end
end

function accessHome(user_id, home, number, cbr)
    local task = Task(cbr)
    local player = RNG.getUserSource(user_id)
    local count = 0
    for k, v in pairs(cfg.homes) do
        count = count+1
        if k == home then
            RNG.setBucket(player, count)
            local x,y,z = table.unpack(v.leave_point)
            RNGclient.teleport(player, {x,y,z})
            RNGclient.setInHome(player, {true})
            task({true})
        end
    end
end

RegisterNetEvent("RNGHousing:Buy")
AddEventHandler("RNGHousing:Buy", function(house)
    local source = source
    local user_id = RNG.getUserId(source)
    local player = RNG.getUserSource(user_id)
    local name = RNG.getPlayerName(source)

    for k, v in pairs(cfg.homes) do
        if house == k then
            getUserByAddress(house, 1, function(noowner)
                if noowner == nil then
                    getUserAddress(user_id, function(address)
                        if RNG.tryFullPayment(user_id, v.buy_price) then
                            local price = v.buy_price
                            setUserAddress(user_id, house, 1)
                            TriggerClientEvent("RNG:phoneNotification", source, "You have purchased ".. k .." for £"..getMoneyStringFormatted(price), "Estate Agents")
                            for a, b in pairs(RNG.getUsers({})) do
                                local x, y, z = table.unpack(v.entry_point)
                                RNGclient.removeBlipAtCoords(b, {x, y, z})

                                if user_id == a then
                                    RNGclient.addBlip(b, {x, y, z, 374, 1, house})
                                end
                            end

                            -- Log the purchase in the webhook
                            RNG.sendWebhook("housingbuy", "Housing Purchase Logs", "> Player's Name: **" .. RNG.getPlayerName(source) .. "**\n> Player's Perm ID: **" .. RNG.getUserId(source) .. "**\n> Price: **" .. price .. "**\n> House Name: **" .. k .. "**")
                        else
                            -- Notify the player about insufficient funds
                            RNGclient.notify(player, {"~r~You do not have enough money to buy " .. k})
                        end
                    end)
                else
                    -- Notify the player that the house is already owned
                    RNGclient.notify(player, {"~r~Someone already owns " .. k})

                    -- Trigger an event to handle when the house is owned
                    TriggerClientEvent('HouseOwned', player)
                end
            end)
        end
    end
end)

RegisterNetEvent("RNGHousing:PoliceRaid")
AddEventHandler("RNGHousing:PoliceRaid", function(house)
    local user_id = RNG.getUserId(source)
    local player = RNG.getUserSource(user_id)
    local name = RNG.getPlayerName(source)

    getUserByAddress(house, 1, function(huser_id)
        local hplayer = RNG.getUserSource(huser_id)

        if huser_id ~= nil then
            if hplayer ~= nil then
                accessHome(user_id, house, 1, function(ok)
                    RNGclient.notify(hplayer, {"~r~The police have initiated a raid on your home!"})
                end)
            else
                RNGclient.notify(player,{"~r~Unable to enter home!"})
            end
        else
            RNGclient.notify(player,{"~r~Home owner not online!"})
        end
    end)
end)

RegisterNetEvent("RNGHousing:Enter")
AddEventHandler("RNGHousing:Enter", function(house)
    local user_id = RNG.getUserId(source)
    local player = RNG.getUserSource(user_id)
    local name = RNG.getPlayerName(source)

    getUserByAddress(house, 1, function(huser_id) --check if player owns home
        local hplayer = RNG.getUserSource(huser_id) --temp id of home owner

        if huser_id ~= nil then
            if huser_id == user_id then
                accessHome(user_id, house, 1, function(ok) --enter home
                    if not ok then
                        RNGclient.notify(player,{"Unable to enter home"}) --notify unable to enter home for whatever reason
                    end
                end)
            else
                if hplayer ~= nil then --check if home owner is online
                    RNGclient.notify(player,{"~r~You do not own this home, Knocked on door!"})
                    RNG.request(hplayer,name.." knocked on your door!", 30, function(v,ok) --knock on door
                        if ok then
                            RNGclient.notify(player,{"~g~Doorbell Accepted"}) --doorbell accepted
                            accessHome(user_id, house, 1, function(ok) --enter home
                                if not ok then
                                    RNGclient.notify(player,{"~r~Unable to enter home!"}) --notify unable to enter home for whatever reason
                                end
                            end)
                        end
                        if not ok then
                            RNGclient.notify(player,{"~r~Doorbell Refused "}) -- doorbell refused
                        end
                    end)
                else
                    RNGclient.notify(player,{"~r~Home owner not online!"}) -- home owner not online
                end
            end
        else
            RNGclient.notify(player,{"~r~Nobody owns "..house..""}) --no home owner & user_id already doesn't have a house
        end
    end)
end)

RegisterNetEvent("RNGHousing:Leave")
AddEventHandler("RNGHousing:Leave", function(house)
    local user_id = RNG.getUserId(source)
    local player = RNG.getUserSource(user_id)

    leaveHome(user_id, house, 1, function(ok) --leave home
        if not ok then
            RNGclient.notify(player,{"~r~Unable to leave home!"}) --notify if some error
        end
    end)
end)

RegisterNetEvent("RNGHousing:Sell")
AddEventHandler("RNGHousing:Sell", function(house)
    local user_id = RNG.getUserId(source)
    local player = RNG.getUserSource(user_id)
    local name = RNG.getPlayerName(source)

    getUserByAddress(house, 1, function(huser_id)
        if huser_id == user_id then
            RNGclient.getNearestPlayers(player, {15}, function(nplayers)
                usrList = ""
                for k, v in pairs(nplayers) do
                    usrList = usrList .. "[" .. RNG.getUserId(k) .. "]" .. RNG.getPlayerName(k) .. " | "
                end

                if usrList ~= "" then
                    RNG.prompt(player, "Players Nearby: " .. usrList .. "", "", function(player, target_id)
                        target_id = target_id
                        if target_id ~= nil and target_id ~= "" then
                            local target = RNG.getUserSource(tonumber(target_id))

                            if target ~= nil then
                                RNG.prompt(player, "Price £: ", "", function(player, amount)
                                    if tonumber(amount) and tonumber(amount) > 0 then
                                        RNG.request(target, RNG.getPlayerName(player).." wants to sell: " .. house .. " Price: £" .. amount, 30, function(target, ok)
                                            if ok then
                                                local buyer_id = RNG.getUserId(target)
                                                amount = tonumber(amount)

                                                if RNG.tryFullPayment(buyer_id, amount) then
                                                    setUserAddress(buyer_id, house, 1)
                                                    removeUserAddress(user_id, house)
                                                    RNG.giveBankMoney(user_id, amount)
                                                    
                                                    TriggerClientEvent("RNG:phoneNotification", source, "You have successfully sold "..house.." to "..RNG.getPlayerName(target).." for "..getMoneyStringFormatted(amount), "Estate Agents")
                                                    TriggerClientEvent("RNG:phoneNotification", source, RNG.getPlayerName(player) .. " has successfully sold you " .. house .. " for £" .. getMoneyStringFormatted(amount), "Estate Agents")
                                                    
                                                    -- Log the sale in the webhook
                                                    RNG.sendWebhook("housingsell", "Housing Sell Logs", "> Seller's Name: **" .. name .. "**\n> Seller's Perm ID: **" .. user_id .. "**\n> Buyer Name: **" .. RNG.getPlayerName(target) .. "**\n> Price: **" .. amount .. "**\n> House Name: **" .. house .. "**")
                                                else
                                                    -- Notify the seller and buyer about insufficient funds
                                                    RNGclient.notify(player, {"" .. RNG.getPlayerName(target) .. " doesn't have enough money!"})
                                                    RNGclient.notify(target, {"~r~You don't have enough money!"})
                                                end
                                            else
                                                -- Notify the seller and buyer about the refused purchase
                                                RNGclient.notify(player, {"" .. RNG.getPlayerName(target) .. " has refused to buy " .. house .. "!"})
                                                RNGclient.notify(target, {"~r~You have refused to buy " .. house .. "!"})
                                            end
                                        end)
                                    else
                                        -- Notify the seller if the entered price is not a valid number
                                        RNGclient.notify(player, {"~r~Price of home needs to be a number!"})
                                    end
                                end)
                            else
                                -- Notify the seller if the entered Perm ID is invalid
                                RNGclient.notify(player, {"~r~That Perm ID seems to be invalid!"})
                            end
                        else
                            -- Notify the seller if no Perm ID is selected
                            RNGclient.notify(player, {"~r~No Perm ID selected!"})
                        end
                    end)
                else
                    -- Notify the seller if no players are nearby
                    RNGclient.notify(player, {"~r~No players nearby!"})
                end
            end)
        else
            -- Notify the seller if they do not own the house
            RNGclient.notify(player, {"~r~You do not own " .. house .. "!"})
        end
    end)
end)

RegisterNetEvent('RNGHousing:Rent')
AddEventHandler('RNGHousing:Rent', function(house)
    local user_id = RNG.getUserId(source)
    local player = RNG.getUserSource(user_id)
    local name = RNG.getPlayerName(source)

    getUserByAddress(house, 1, function(huser_id)
        if huser_id == user_id then
            RNGclient.getNearestPlayers(player, {15}, function(nplayers)
                usrList = ""
                for k, v in pairs(nplayers) do
                    usrList = usrList .. "[" .. RNG.getUserId(k) .. "]" .. RNG.getPlayerName(k) .. " | "
                end

                if usrList ~= "" then
                    RNG.prompt(player, "Players Nearby: " .. usrList .. "", "", function(player, target_id)
                        target_id = target_id
                        if target_id ~= nil and target_id ~= "" then
                            local target = RNG.getUserSource(tonumber(target_id))

                            if target ~= nil then
                                RNG.prompt(player, "Price £: ", "", function(player, amount)
                                    if tonumber(amount) and tonumber(amount) > 0 then
                                        RNG.prompt(player, "Duration: ", "", function(player, duration)
                                            if tonumber(duration) and tonumber(duration) > 0 then
                                                RNG.prompt(player, "Please replace text with YES or NO to confirm", "Rent Details:\nHouse: " .. house .. "\nRent Cost: " .. amount .. "\nDuration: " .. duration .. " hours\nRenting to player: " .. RNG.getPlayerName(target) .. "(" .. target_id .. ")", function(player, details)
                                                    if string.upper(details) == 'YES' then
                                                        RNGclient.notify(player, {'~g~Rent offer sent!'})
                                                        RNG.request(target, RNG.getPlayerName(player).." wants to rent: " .. house .. " for " .. duration .. " hours, for £" .. amount, 30, function(target, ok)
                                                            if ok then
                                                                local buyer_id = RNG.getUserId(target)
                                                                amount = tonumber(amount)

                                                                if RNG.tryFullPayment(buyer_id, amount) then
                                                                    local rentedTime = os.time()
                                                                    rentedTime = rentedTime + (60 * 60 * tonumber(duration))
                                                                    MySQL.execute("RNG/rentedupdatehouse", {user_id = user_id, home = house, id = target_id, rented = 1, rentedid = user_id, rentedunix = rentedTime})
                                                                    RNG.giveBankMoney(user_id, amount)

                                                                    -- Notify the buyer about the successful rent
                                                                    TriggerClientEvent("RNG:phoneNotification", target, RNG.getPlayerName(player).." has successfully rented you "..house.." for £"..getMoneyStringFormatted(amount), "Estate Agents")

                                                                    -- Log the rent in the webhook
                                                                    RNG.sendWebhook("housingrent", "Housing Rent Logs", "> Seller's Name: **" .. name .. "**\n> Seller's Perm ID: **" .. user_id .. "**\n> Buyer Name: **" .. RNG.getPlayerName(target) .. "**\n> Price: **" .. amount .. "**\n> House Name: **" .. house .. "**")
                                                                else
                                                                    -- Notify both parties about insufficient funds
                                                                    RNGclient.notify(player, {"" .. RNG.getPlayerName(target) .. " doesn't have enough money!"})
                                                                    RNGclient.notify(target, {"~r~You don't have enough money!"})
                                                                end
                                                            else
                                                                -- Notify both parties about the refused rent
                                                                RNGclient.notify(player, {"" .. RNG.getPlayerName(target) .. " has refused to rent " .. house .. "!"})
                                                                RNGclient.notify(target, {"~r~You have refused to rent " .. house .. "!"})
                                                            end
                                                        end)
                                                    end
                                                end)
                                            end
                                        end)
                                    else
                                        -- Notify the player if the entered price is not a valid number
                                        RNGclient.notify(player, {"~r~Price of home needs to be a number!"})
                                    end
                                end)
                            else
                                -- Notify the player if the entered Perm ID is invalid
                                RNGclient.notify(player, {"~r~That Perm ID seems to be invalid!"})
                            end
                        else
                            -- Notify the player if no Perm ID is selected
                            RNGclient.notify(player, {"~r~No Perm ID selected!"})
                        end
                    end)
                else
                    -- Notify the player if no players are nearby
                    RNGclient.notify(player, {"~r~No players nearby!"})
                end
            end)
        else
            -- Notify the player if they do not own the house
            RNGclient.notify(player, {"~r~You do not own " .. house .. "!"})
        end
    end)
end)


AddEventHandler("RNG:playerSpawn",function(user_id, source, first_spawn)
    for k, v in pairs(cfg.homes) do
        local x,y,z = table.unpack(v.entry_point)
        getUserByAddress(k,1,function(owner)
            if owner == nil then
                RNGclient.addBlip(source,{x,y,z,374,2,k,0.8,true}) -- remove the 0.8 and true to display on full map instead of minimap
            end
            if owner == user_id then
                RNGclient.addBlip(source,{x,y,z,374,1,k})
            end
        end)
    end
end)

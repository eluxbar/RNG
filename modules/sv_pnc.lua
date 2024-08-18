MySQL.createCommand("RNG/add_jail_stats","UPDATE rng_fine_hours SET total_player_fined = (total_player_fined+1) WHERE user_id = @user_id")

RegisterServerEvent('RNG:checkForPolicewhitelist')
AddEventHandler('RNG:checkForPolicewhitelist', function()
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, 'police.armoury') then
        if RNG.hasPermission(user_id, 'police.announce') then
            TriggerClientEvent('RNG:openPNC', source, true, {}, {})
        else
            TriggerClientEvent('RNG:openPNC', source, false, {}, {})
        end
    end
end)

RegisterServerEvent('RNG:searchPerson')
AddEventHandler('RNG:searchPerson', function(firstname, lastname)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, 'police.armoury') then
        exports['rng']:execute("SELECT * FROM rng_user_identities WHERE firstname = @firstname AND name = @lastname", {firstname = firstname, lastname = lastname}, function(result) 
            if result ~= nil then
                local returnedUsers = {}
                for k,v in pairs(result) do
                    local user_id = result[k].user_id
                    local firstname = result[k].firstname
                    local lastname = result[k].name
                    local age = result[k].age
                    local phone = result[k].phone
                    local data = exports['rng']:executeSync("SELECT * FROM rng_dvsa WHERE user_id = @user_id", {user_id = user_id})[1]
                    local licence = data.licence
                    local points = data.points
                    local ownedVehicles = exports['rng']:executeSync("SELECT * FROM rng_user_vehicles WHERE user_id = @user_id", {user_id = user_id})
                    local actualVehicles = {}
                    for a,b in pairs(ownedVehicles) do 
                        table.insert(actualVehicles, b.vehicle)
                    end
                    local ownedProperties = exports['rng']:executeSync("SELECT * FROM rng_user_homes WHERE user_id = @user_id", {user_id = user_id})
                    local actualHouses = {}
                    for a,b in pairs(ownedProperties) do 
                        table.insert(actualHouses, b.home)
                    end
                    table.insert(returnedUsers, {user_id = user_id, firstname = firstname, lastname = lastname, age = age, phone = phone, licence = licence, points = points, vehicles = actualVehicles, playerhome = actualHouses, warrants = {}, warning_markers = {}})
                end
                if next(returnedUsers) then
                    TriggerClientEvent('RNG:sendSearcheduser', source, returnedUsers)
                else
                    TriggerClientEvent('RNG:noPersonsFound', source)
                end
            end
        end)
    end
end)

RegisterServerEvent('RNG:finePlayer')
AddEventHandler('RNG:finePlayer', function(id, charges, amount, notes)
    local source = source
    local user_id = RNG.getUserId(source)
    local amountNum = tonumber(amount)
    
    if amountNum > 250000 then
        amountNum = 250000
    end
    
    if next(charges) then
        local chargesList = ""
        for k, v in pairs(charges) do
            chargesList = chargesList .. "\n> - **" .. v.fine .. "**"
        end
        
        if RNG.hasPermission(user_id, 'police.armoury') then
            if id == user_id then
                TriggerClientEvent('RNG:verifyFineSent', source, false, "Can't fine yourself!")
                return
            end
            
            if RNG.tryBankPayment(id, amountNum) then
                local officerReward = math.floor(amountNum * 0.1)
                RNG.giveBankMoney(user_id, officerReward)
                TriggerClientEvent("RNG:phoneNotification", RNG.getUserSource(id), 'You have been fined £'..getMoneyStringFormatted(amountNum), "MET HQ")
                TriggerClientEvent("RNG:phoneNotification", RNG.getUserSource(id), 'You have received £'..getMoneyStringFormatted(officerReward)..' for fining '..RNG.getPlayerName(RNG.getUserSource(id)), "MET HQ")
                TriggerEvent('RNG:addToCommunityPot', amountNum)
                TriggerClientEvent('RNG:verifyFineSent', source, true)
                
                local criminalName = RNG.getPlayerName(RNG.getUserSource(id))
                local criminalPermID = id
                local criminalTempID = RNG.getUserSource(id)
                local formattedAmount = '£' .. getMoneyStringFormatted(amountNum)
                
                exports['rng']:execute("SELECT * FROM `rng_police_hours` WHERE user_id = @user_id", {user_id = user_id}, function(result)
                    if result ~= nil then 
                        for k,v in pairs(result) do
                            if v.user_id == user_id then
                                exports['rng']:execute("UPDATE rng_police_hours SET total_players_fined = @total_players_fined WHERE user_id = @user_id", {user_id = user_id, total_players_fined = v.total_players_fined + 1}, function() end)
                                return
                            end
                        end
                        exports['rng']:execute("INSERT INTO rng_police_hours (`user_id`, `total_players_fined`, `username`) VALUES (@user_id, @total_players_fined, @username);", {user_id = user_id, total_players_fined = 1}, function() end) 
                    end
                end)
                RNG.sendWebhook('fine-player', 'RNG Fine Logs', "> Officer Name: **" .. RNG.getPlayerName(source) .. "**\n> Officer TempID: **" .. source .. "**\n> Officer PermID: **" .. user_id .. "**\n> Criminal Name: **" .. criminalName .. "**\n> Criminal PermID: **" .. criminalPermID .. "**\n> Criminal TempID: **" .. criminalTempID .. "**\n> Amount: **" .. formattedAmount .. "**\n> Charges: " .. chargesList)
            else
                TriggerClientEvent('RNG:verifyFineSent', source, false, 'The player does not have enough money.')
            end
        end
    end
end)



RegisterServerEvent('RNG:addPoints')
AddEventHandler('RNG:addPoints', function(charges, id)
    local source = source
    local user_id = RNG.getUserId(source)
    
    if RNG.hasPermission(user_id, 'police.armoury') then
        local totalPoints = 0 
        for i, v in pairs(charges) do
            local point = v.points 
            local reason = v.name
            totalPoints = totalPoints + point 
        end
        if totalPoints > 12 then
            totalPoints = 12
        end
        exports['rng']:execute("UPDATE rng_dvsa SET points = points + @newpoints WHERE user_id = @user_id", {user_id = id, newpoints = totalPoints})
        exports['rng']:execute('SELECT * FROM rng_dvsa WHERE user_id = @user_id', {user_id = user_id}, function(licenceInfo)
            local licenceType = licenceInfo[1].licence
            local userPoints = tonumber(licenceInfo[1].points)
            if (licenceType == "active" or licenceType == "full") and userPoints > 12 then
                RNGclient.notify(RNG.getUserSource(id), {'~r~You have received '..totalPoints..' on your licence. You now have '..userPoints..'/12 points. Your licence has been suspended.'})
                exports['rng']:execute("UPDATE rng_dvsa SET licence = 'banned' WHERE user_id = @user_id", {user_id = id})
                Wait(100)
                dvsaUpdate(user_id)
            else
                RNGclient.notify(RNG.getUserSource(id), {'~r~You have received '..totalPoints..' on your licence. You now have '..userPoints..'/12 points.'})
            end
            if userPoints > 12 then
                exports['rng']:execute("UPDATE rng_dvsa SET points = @points WHERE user_id = @user_id", {user_id = id, points = 12})
            end
        end)
    end
end)



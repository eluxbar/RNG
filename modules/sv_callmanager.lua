local tickets = {}
local callID = 0
local cooldown = {}
local permid = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)
        for k,v in pairs(cooldown) do
            if cooldown[k].time > 0 then
                cooldown[k].time = cooldown[k].time - 1
            end
        end
    end
end)

RegisterCommand("calladmin", function(source)
    local user_id = RNG.getUserId(source)
    local user_source = RNG.getUserSource(user_id)
    for k,v in pairs(cooldown) do
        if k == user_id and v.time > 0 then
            RNGclient.notify(user_source,{"~r~You have already called an admin, please wait 5 minutes before calling again."})
            return
        end
    end
    RNG.prompt(user_source, "Please enter call reason: ", "", function(player, reason)
        if reason ~= "" then
            if #reason >= 5 then
                callID = callID + 1
                tickets[callID] = {
                    name = RNG.getPlayerName(user_id),
                    permID = user_id,
                    tempID = user_source,
                    reason = reason,
                    type = 'admin',
                }
                cooldown[user_id] = {time = 5}
                for k, v in pairs(RNG.getUsers({})) do
                    TriggerClientEvent("RNG:addEmergencyCall", v, callID, RNG.getPlayerName(user_id), user_id, GetEntityCoords(GetPlayerPed(user_source)), reason, 'admin')
                end
                RNGclient.notify(user_source,{"~b~Your request has been sent."})
            else
                RNGclient.notify(user_source,{"~r~Please enter a minimum of 5 characters."})
            end
        else
            RNGclient.notify(user_source,{"~r~Please enter a valid reason."})
        end
    end)
end)
RegisterCommand("calladmin", function(source)
    local user_id = RNG.getUserId(source)
    local user_source = RNG.getUserSource(user_id)
    for k,v in pairs(cooldown) do
        if k == user_id and v.time > 0 then
            RNGclient.notify(user_source,{"~r~You have already called an admin, please wait 5 minutes before calling again."})
            return
        end
    end
    RNG.prompt(user_source, "Please enter call reason: ", "", function(player, reason)
        if reason ~= "" then
            if #reason >= 5 then
                callID = callID + 1
                tickets[callID] = {
                    name = RNG.getPlayerName(user_id),
                    permID = user_id,
                    tempID = user_source,
                    reason = reason,
                    type = 'admin',
                }
                cooldown[user_id] = {time = 5}
                for k, v in pairs(RNG.getUsers({})) do
                    TriggerClientEvent("RNG:addEmergencyCall", v, callID, RNG.getPlayerName(user_id), user_id, GetEntityCoords(GetPlayerPed(user_source)), reason, 'admin')
                end
                RNGclient.notify(user_source,{"~b~Your request has been sent."})
            else
                RNGclient.notify(user_source,{"~r~Please enter a minimum of 5 characters."})
            end
        else
            RNGclient.notify(user_source,{"~r~Please enter a valid reason."})
        end
    end)
end)

RegisterCommand("help", function(source)
    local user_id = RNG.getUserId(source)
    local user_source = RNG.getUserSource(user_id)
    for k,v in pairs(cooldown) do
        if k == user_id and v.time > 0 then
            RNGclient.notify(user_source,{"~r~You have already called an admin, please wait 5 minutes before calling again."})
            return
        end
    end
    RNG.prompt(user_source, "Please enter call reason: ", "", function(player, reason)
        if reason ~= "" then
            if #reason >= 5 then
                callID = callID + 1
                tickets[callID] = {
                    name = RNG.getPlayerName(user_id),
                    permID = user_id,
                    tempID = user_source,
                    reason = reason,
                    type = 'admin',
                }
                cooldown[user_id] = {time = 5}
                for k, v in pairs(RNG.getUsers({})) do
                    TriggerClientEvent("RNG:addEmergencyCall", v, callID, RNG.getPlayerName(user_id), user_id, GetEntityCoords(GetPlayerPed(user_source)), reason, 'admin')
                end
                RNGclient.notify(user_source,{"~b~Your request has been sent."})
            else
                RNGclient.notify(user_source,{"~r~Please enter a minimum of 5 characters."})
            end
        else
            RNGclient.notify(user_source,{"~r~Please enter a valid reason."})
        end
    end)
end)

RegisterCommand("report", function(source)
    local user_id = RNG.getUserId(source)
    local user_source = RNG.getUserSource(user_id)
    for k,v in pairs(cooldown) do
        if k == user_id and v.time > 0 then
            RNGclient.notify(user_source,{"~r~You have already called an admin, please wait 5 minutes before calling again."})
            return
        end
    end
    RNG.prompt(user_source, "Please enter call reason: ", "", function(player, reason)
        if reason ~= "" then
            if #reason >= 5 then
                callID = callID + 1
                tickets[callID] = {
                    name = RNG.getPlayerName(user_id),
                    permID = user_id,
                    tempID = user_source,
                    reason = reason,
                    type = 'admin',
                }
                cooldown[user_id] = {time = 5}
                for k, v in pairs(RNG.getUsers({})) do
                    TriggerClientEvent("RNG:addEmergencyCall", v, callID, RNG.getPlayerName(user_id), user_id, GetEntityCoords(GetPlayerPed(user_source)), reason, 'admin')
                end
                RNGclient.notify(user_source,{"~b~Your request has been sent."})
            else
                RNGclient.notify(user_source,{"~r~Please enter a minimum of 5 characters."})
            end
        else
            RNGclient.notify(user_source,{"~r~Please enter a valid reason."})
        end
    end)
end)

RegisterCommand("999", function(source)
    local user_id = RNG.getUserId(source)
    local user_source = RNG.getUserSource(user_id)
    RNG.prompt(user_source, "Please enter call reason: ", "", function(player, reason)
        if reason ~= "" then
            callID = callID + 1
            tickets[callID] = {
                name = RNG.getPlayerName(user_id),
                permID = user_id,
                tempID = user_source,
                reason = reason,
                type = 'met'
            }
            for k, v in pairs(RNG.getUsers({})) do
                TriggerClientEvent("RNG:addEmergencyCall", v, callID, RNG.getPlayerName(user_id), user_id, GetEntityCoords(GetPlayerPed(user_source)), reason, 'met')
            end
            RNGclient.notify(user_source,{"~b~Sent Police Call."})
        else
            RNGclient.notify(user_source,{"~r~Please enter a valid reason."})
        end
    end)
end)

RegisterCommand("111", function(source)
    local user_id = RNG.getUserId(source)
    local user_source = RNG.getUserSource(user_id)
    RNG.prompt(user_source, "Please enter call reason: ", "", function(player, reason)
        if reason ~= "" then
            callID = callID + 1
            tickets[callID] = {
                name = RNG.getPlayerName(user_id),
                permID = user_id,
                tempID = user_source,
                reason = reason,
                type = 'nhs'
            }
            for k, v in pairs(RNG.getUsers({})) do
                TriggerClientEvent("RNG:addEmergencyCall", v, callID, RNG.getPlayerName(user_id), user_id, GetEntityCoords(GetPlayerPed(user_source)), reason, 'nhs')
            end
            RNGclient.notify(user_source,{"~g~Sent NHS Call."})
        else
            RNGclient.notify(user_source,{"~r~Please enter a valid reason."})
        end
    end)
end)

local savedPositions = {}
RegisterCommand("return", function(source)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, 'admin.tickets') then
        TriggerEvent('RNG:Return', source)
    end
end)
local adminFeedback = {} 
AddEventHandler("RNG:Return", function(source)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, 'admin.tickets') then
        local v = adminFeedback[user_id]
        if savedPositions[user_id] then
            RNG.setBucket(source, savedPositions[user_id].bucket)
            RNGclient.teleport(source, {table.unpack(savedPositions[user_id].coords)})
            RNGclient.notify(source, {'~g~Returned to position.'})
            savedPositions[user_id] = nil
        else
            RNGclient.notify(source, {"~r~Unable to find last location."})
        end
        TriggerClientEvent('RNG:sendTicketInfo', source)
        RNGclient.staffMode(source, {false})
        SetTimeout(1000, function() 
            RNGclient.setPlayerCombatTimer(source, {0}) 
        end)
    end
end)

RegisterNetEvent("RNG:TakeTicket")
AddEventHandler("RNG:TakeTicket", function(ticketID)
    local user_id = RNG.getUserId(source)
    local admin_source = RNG.getUserSource(user_id)
    if tickets[ticketID] ~= nil then
        for k, v in pairs(tickets) do
            if ticketID == k then
                if tickets[ticketID].type == 'admin' and RNG.hasPermission(user_id, "admin.tickets") then
                    if RNG.getUserSource(v.permID) ~= nil then
                        if user_id ~= v.permID then
                            local tempID = v.tempID
                            local adminbucket = GetPlayerRoutingBucket(admin_source)
                            local playerbucket = GetPlayerRoutingBucket(v.tempID)
                            savedPositions[user_id] = {bucket = adminbucket, coords = GetEntityCoords(GetPlayerPed(admin_source))}
                            if adminbucket ~= playerbucket then
                                RNG.setBucket(admin_source, playerbucket)
                                RNGclient.notify(admin_source, {'~g~Player was in another bucket, you have been set into their bucket.'})
                            end
                            RNGclient.getPosition(v.tempID, {}, function(coords)
                                RNGclient.staffMode(admin_source, {true})
                                adminFeedback[user_id] = {playersource = tempID, ticketID = ticketID}
                                TriggerClientEvent('RNG:sendTicketInfo', admin_source, v.permID, v.name, v.reason)
                                local ticketPay = 0
                                if os.date('%A') == 'Saturday' or os.date('%A') == 'Sunday' then
                                    ticketPay = 30000
                                else
                                    ticketPay = 20000
                                end
                                exports['rng']:execute("SELECT * FROM `rng_staff_tickets` WHERE user_id = @user_id", {user_id = user_id}, function(result)
                                    if result ~= nil then 
                                        for k,v in pairs(result) do
                                            if v.user_id == user_id then
                                                exports['rng']:execute("UPDATE rng_staff_tickets SET ticket_count = @ticket_count, username = @username WHERE user_id = @user_id", {user_id = user_id, ticket_count = v.ticket_count + 1, username = RNG.getPlayerName(user_id)}, function() end)
                                                return
                                            end
                                        end
                                        exports['rng']:execute("INSERT INTO rng_staff_tickets (`user_id`, `ticket_count`, `username`) VALUES (@user_id, @ticket_count, @username);", {user_id = user_id, ticket_count = 1, username = RNG.getPlayerName(user_id)}, function() end) 
                                    end
                                end)
                                RNG.giveBankMoney(user_id, ticketPay)
                                RNGclient.notify(admin_source,{"~g~£"..getMoneyStringFormatted(ticketPay).." earned for taking a ticket."})
                                RNGclient.notify(v.tempID,{"~g~An admin has taken your ticket."})
                                RNGclient.teleport(admin_source, {table.unpack(coords)})
                                TriggerClientEvent("RNG:removeEmergencyCall", -1, ticketID)
                                tickets[ticketID] = nil
                            end)
                        else
                            RNGclient.notify(admin_source,{"~r~You can't take your own ticket!"})
                        end
                    else
                        RNGclient.notify(admin_source,{"You cannot take a ticket from an offline player."})
                        TriggerClientEvent("RNG:removeEmergencyCall", -1, ticketID)
                    end
                elseif tickets[ticketID].type == 'met' and RNG.hasPermission(user_id, "police.armoury") then
                    if RNG.getUserSource(v.permID) ~= nil then
                        if user_id ~= v.permID then
                            if v.tempID ~= nil then
                                RNGclient.notify(v.tempID,{"~b~Your MET Police call has been accepted!"})
                            end
                            tickets[ticketID] = nil
                            TriggerClientEvent("RNG:removeEmergencyCall", -1, ticketID)
                        else
                            RNGclient.notify(admin_source,{"~r~You can't take your own call!"})
                        end
                    else
                        TriggerClientEvent("RNG:removeEmergencyCall", -1, ticketID)
                    end
                elseif tickets[ticketID].type == 'nhs' and RNG.hasPermission(user_id, "nhs.menu") then
                    if RNG.getUserSource(v.permID) ~= nil then
                        if user_id ~= v.permID then
                            RNGclient.notify(v.tempID,{"~g~Your NHS call has been accepted!"})
                            tickets[ticketID] = nil
                            TriggerClientEvent("RNG:removeEmergencyCall", -1, ticketID)
                        else
                            RNGclient.notify(admin_source,{"~r~You can't take your own call!"})
                        end
                    else
                        TriggerClientEvent("RNG:removeEmergencyCall", -1, ticketID)
                    end
                end
            end
        end
    end         
end)

RegisterNetEvent("RNG:PDRobberyCall")
AddEventHandler("RNG:PDRobberyCall", function(source, store, position)
    local source = source
    local user_id = RNG.getUserId(source)
    callID = callID + 1
    tickets[callID] = {
        name = 'Store Robbery',
        permID = 999,
        tempID = nil,
        reason = 'Robbery in progress at '..store,
        type = 'met'
    }
    for k, v in pairs(RNG.getUsers({})) do
        TriggerClientEvent("RNG:addEmergencyCall", v, callID, 'Store Robbery', 999, position, 'Robbery in progress at '..store, 'met')
    end
end)

RegisterNetEvent("RNG:NHSComaCall")
AddEventHandler("RNG:NHSComaCall", function()
    local user_id = RNG.getUserId(source)
    local user_source = RNG.getUserSource(user_id)
    if RNG.getUsersByPermission("nhs.menu") == nil then
        RNGclient.notify(user_source,{"~r~There are no NHS on duty."})
        return
    end
    RNGclient.notify(user_source,{"~g~NHS have been notified."})
    callID = callID + 1
    tickets[callID] = {
        name = RNG.getPlayerName(user_id),
        permID = user_id,
        tempID = user_source,
        reason = "Immediate Attention",
        type = 'nhs'
    }
    for k, v in pairs(RNG.getUsers({})) do
        TriggerClientEvent("RNG:addEmergencyCall", v, callID, RNG.getPlayerName(user_id), user_id, GetEntityCoords(GetPlayerPed(user_source)),"Immediate Attention", 'nhs')
    end
end)
RegisterCommand('addgroup', function(source, args)
    if source ~= 0 and source ~= 1 then return end; -- allows only the console and id 1 to run the 
    if tonumber(args[1]) and args[2] then
        local userid = tonumber(args[1])
        local group = args[2]
        RNG.addUserGroup(userid,group)
        print('Added Group: ' .. group .. ' to UserID: ' .. userid)
    else 
        print('Incorrect usage: addgroup [permid] [group]')
    end
end)

RegisterCommand('removegroup', function(source, args)
    if source ~= 0 and source ~= 1 then return end; -- allows only the console and id 1 to run the 
    if tonumber(args[1]) and args[2] then
        local userid = tonumber(args[1])
        local group = args[2]
        RNG.removeUserGroup(userid,group)
        print('Removed Group: ' .. group .. ' from UserID: ' .. userid)
    else 
        print('Incorrect usage: addgroup [permid] [group]')
    end
end)

RegisterCommand('ban', function(source, args)
    if source ~= 0 and source ~= 1 then return end; -- allows only the console and id 1 to run the 
    if tonumber(args[1]) and args[2] then
        local userid = tonumber(args[1])
        local hours = args[2]
        local reason = table.concat(args," ", 3)
        if reason then 
            RNG.banConsole(userid,hours,reason)
        else 
            print('Incorrect usage: ban [permid] [hours] [reason]')
        end 
    else 
        print('Incorrect usage: ban [permid] [hours] [reason]')
    end
end)

RegisterCommand('unban', function(source, args)
    if source ~= 0 and source ~= 1 then return end; -- allows only the console and id 1 to run the 
    if tonumber(args[1])  then
        local userid = tonumber(args[1])
        RNG.setBanned(userid,false)
        print('Unbanned user: ' .. userid )
    else 
        print('Incorrect usage: unban [permid]')
    end
end)

RegisterCommand('cashtoall', function(source, args)
    if source ~= 0 and source ~= 1 then return end; -- allows only the console and id 1 to run the 
    if tonumber(args[1])  then
        local amount = tonumber(args[1])
        for k,v in pairs(RNG.getUsers()) do
            TriggerClientEvent("RNG:phoneNotification", v, "You received £"..getMoneyStringFormatted(Amount), "Administration")
        end
    else 
        print('Incorrect usage: cashtoall [amount]')
    end
end)

local lastUsageTimes = {}

RegisterCommand('nitrokit', function(source)
    local source = source
    local user_id = RNG.getUserId(source)
    local currentTime = os.time()
    if lastUsageTimes[source] == nil or (currentTime - lastUsageTimes[source] >= 900) then -- 900 seconds = 15 minutes
        if tRNG.checkForRole(user_id, '1132717985610608650') then
            RNGclient.giveWeapons(source, {{['WEAPON_MOSINRNG'] = {ammo = 250}}, false})
            RNGclient.giveWeapons(source, {{['WEAPON_AKKAL'] = {ammo = 250}}, false})
            RNGclient.setArmour(source, {100, true})
            RNGclient.notify(source, {'~g~You have claimed your nitro kit!'})
            lastUsageTimes[source] = currentTime
        else
            RNGclient.notify(source, {'~r~You are not a nitro booster!'})
        end
    else
        local timeRemaining = 900 - (currentTime - lastUsageTimes[source])
        RNGclient.notify(source, {'~r~You must wait ' .. timeRemaining .. ' seconds before using this command again.'})
    end
end)

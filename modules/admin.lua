local htmlEntities = module("lib/htmlEntities")
local Tools = module("lib/Tools")
local banreasons = module("cfg/cfg_banreasons")

RegisterServerEvent('RNG:OpenSettings')
AddEventHandler('RNG:OpenSettings', function()
    local source = source
    local user_id = RNG.getUserId(source)
    if user_id ~= nil then
        if RNG.hasPermission(user_id, "admin.tickets") then
            TriggerClientEvent("RNG:OpenAdminMenu", source, true)
        else
            TriggerClientEvent("RNG:OpenSettingsMenu", source, false)
        end
    end
end)

RegisterServerEvent('RNG:SerDevMenu')
AddEventHandler('RNG:SerDevMenu', function()
    local source = source
    local user_id = RNG.getUserId(source)
    if user_id ~= nil then
        if user_id == 1 or user_id == 2 or user_id == 3 then
            TriggerClientEvent("RNG:CliDevMenu", source, true)
        end
    end
end)


AddEventHandler("RNGcli:playerSpawned", function()
    local source = source
    local user_id = RNG.getUserId(source)
    Wait(500)
    if RNG.hasGroup(user_id, "pov") then
        Wait(5000)
        RNGclient.notify(source, {"~y~Reminder: You are on POV list so make sure you turn clips on"})
        RNGclient.notify(source, {"~y~Clips must be 5 minutes or longer"})
    end
end)

-- RegisterCommand("sethours", function(source, args)
--     local user_id = RNG.getUserId(source)
--     if source == 0 then 
--         local data = RNG.getUserDataTable(tonumber(args[1]))
--         data.PlayerTime = tonumber(args[2])*60
--         print(RNG.getPlayerName(RNG.getUserSource(tonumber(args[1]))).."'s hours have been set to: "..tonumber(args[2]))
--     elseif user_id == -1 then
--         local data = RNG.getUserDataTable(tonumber(args[1]))
--         data.PlayerTime = tonumber(args[2])*60
--         RNGclient.notify(source,{"~g~You have set "..RNG.getPlayerName(RNG.getUserSource(tonumber(args[1]))).."'s hours to: "..tonumber(args[2])})
--     end  
-- end)


RegisterNetEvent("RNG:GetNearbyPlayers")
AddEventHandler("RNG:GetNearbyPlayers", function(coords, dist)
    local source = source
    local user_id = RNG.getUserId(source)
    local plrTable = {}
    if RNG.hasPermission(user_id, 'admin.tickets') then
        RNGclient.getNearestPlayersFromPosition(source, {coords, dist}, function(nearbyPlayers)
            for k, v in pairs(nearbyPlayers) do
                playtime = RNG.GetPlayTime(RNG.getUserId(k))
                plrTable[RNG.getUserId(k)] = {RNG.getPlayerName(k), k, RNG.getUserId(k), playtime}
            end
            plrTable[user_id] = {RNG.getPlayerName(source), source, RNG.getUserId(source), math.ceil((RNG.getUserDataTable(user_id).PlayerTime/60)) or 0}
            TriggerClientEvent("RNG:ReturnNearbyPlayers", source, plrTable)
        end)
    end
end)

RegisterServerEvent("RNG:requestAccountInfosv")
AddEventHandler("RNG:requestAccountInfosv",function(permid)
    adminrequest = source
    adminrequest_id = RNG.getUserId(adminrequest)
    if RNG.hasPermission(adminrequest_id, 'group.remove') then
        TriggerClientEvent('RNG:requestAccountInfo', RNG.getUserSource(permid), true)
    end
end)

RegisterServerEvent("RNG:receivedAccountInfo")
AddEventHandler("RNG:receivedAccountInfo", function(gpu, cpu, userAgent, devices)
    if RNG.hasPermission(adminrequest_id, 'group.remove') then
        local formatteddevices = json.encode(devices)
        local function formatEntry(entry)
            return entry.kind .. ': ' .. entry.label .. ' id = ' .. entry.deviceId
        end
        local formatted_entries = {}
        
        for _, entry in ipairs(devices) do
            if entry.deviceId ~= "communications" then
                table.insert(formatted_entries, formatEntry(entry))
            end
        end

        local newformat = table.concat(formatted_entries, '\n')
        newformat = newformat:gsub('audiooutput:', 'audiooutput: '):gsub('videoinput:', 'videoinput: ')
        RNG.prompt(adminrequest, "Account Info", "GPU: " .. gpu .. " \n\nCPU: " .. cpu .. " \n\nUser Agent: " .. userAgent .. " \n\nDevices: " .. newformat, function(player, K)
        end)
    end
end)



RegisterServerEvent("RNG:GetGroups")
AddEventHandler("RNG:GetGroups",function(perm)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, 'admin.tickets') then
        TriggerClientEvent("RNG:GotGroups", source, RNG.getUserGroups(perm))
    end
end)

RegisterServerEvent("RNG:CheckPov")
AddEventHandler("RNG:CheckPov",function(userperm)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, "admin.tickets") then
        if RNG.hasPermission(userperm, 'pov.list') then
            TriggerClientEvent('RNG:ReturnPov', source, true)
        else
            TriggerClientEvent('RNG:ReturnPov', source, false)
        end
    end
end)

RegisterServerEvent("wk:fixVehicle")
AddEventHandler("wk:fixVehicle",function()
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, 'admin.tickets') then
        TriggerClientEvent('wk:fixVehicle', source)
    end
end)

local spectatingPositions = {}
RegisterServerEvent("RNG:spectatePlayer")
AddEventHandler("RNG:spectatePlayer", function(id)
    local playerssource = RNG.getUserSource(id)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, "admin.spectate") then
        if playerssource ~= nil then
            spectatingPositions[user_id] = {coords = GetEntityCoords(GetPlayerPed(source)), bucket = GetPlayerRoutingBucket(source)}
            RNG.setBucket(source, GetPlayerRoutingBucket(playerssource))
            TriggerClientEvent("RNG:spectatePlayer",source, playerssource, GetEntityCoords(GetPlayerPed(playerssource)))
            RNG.sendWebhook('spectate',"RNG Spectate Logs", "> Admin Name: **"..RNG.getPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..RNG.getPlayerName(playerssource).."**\n> Player PermID: **"..id.."**\n> Player TempID: **"..playerssource.."**")
        else
            RNGclient.notify(source, {"~r~You can't spectate an offline player."})
        end
    end
end)

RegisterServerEvent("RNG:stopSpectatePlayer")
AddEventHandler("RNG:stopSpectatePlayer", function()
    local source = source
    if RNG.hasPermission(RNG.getUserId(source), "admin.spectate") then
        TriggerClientEvent("RNG:stopSpectatePlayer",source)
        for k,v in pairs(spectatingPositions) do
            if k == RNG.getUserId(source) then
                TriggerClientEvent("RNG:stopSpectatePlayer",source,v.coords,v.bucket)
                SetEntityCoords(GetPlayerPed(source),v.coords)
                RNG.setBucket(source, v.bucket)
                spectatingPositions[k] = nil
            end
        end
    end
end)

RegisterServerEvent("RNG:ForceClockOff")
AddEventHandler("RNG:ForceClockOff", function(player_temp)
    local source = source
    local user_id = RNG.getUserId(source)
    local name = RNG.getPlayerName(source)
    local player_perm = RNG.getUserId(player_temp)
    local player = RNG.getUserSource(user_id)

    if RNG.hasPermission(user_id, "admin.tp2waypoint") then
        RNG.removeAllJobs(player_perm)
        RNGclient.notify(source, {'~g~User clocked off'})
        RNGclient.notify(player_temp, {'~r~You have been force clocked off by ' .. name})
        RNG.sendWebhook('force-clock-off', "RNG Faction Logs",
            "> Admin Name: **" .. name .. "**\n> Admin TempID: **" .. source .. "**\n> Admin PermID: **" .. user_id .. "**\n> Players Name: **" .. RNG.getPlayerName(player_temp) .. "**\n> Players TempID: **" .. player_temp .. "**\n> Players PermID: **" .. player_perm .. "**")
    else
        Wait(500)
        TriggerEvent("RNG:acBan", user_id, 11, name, player, 'Attempted to Force Clock Off')
    end
end)


RegisterServerEvent("RNG:AddGroup")
AddEventHandler("RNG:AddGroup",function(perm, selgroup)
    local source = source
    local admin_temp = source
    local user_id = RNG.getUserId(source)
    local permsource = RNG.getUserSource(perm)
    local playerName = RNG.getPlayerName(source)
    local povName = RNG.getPlayerName(permsource)
    if RNG.hasPermission(user_id, "group.add") then
        if selgroup == "Founder" and not RNG.hasPermission(user_id, "group.add.founder") then
            RNGclient.notify(admin_temp, {"You don't have permission to do that"}) 
            elseif selgroup == "Lead Developer" and not RNG.hasPermission(user_id, "group.add.leaddeveloper") then
                RNGclient.notify(admin_temp, {"You don't have permission to do that"}) 
            elseif selgroup == "Operations Manager" and not RNG.hasPermission(user_id, "group.add.operationsmanager") then
                RNGclient.notify(admin_temp, {"You don't have permission to do that"}) 
        elseif selgroup == "Staff Manager" and not RNG.hasPermission(user_id, "group.add.staffmanager") then
            RNGclient.notify(admin_temp, {"You don't have permission to do that"}) 
        elseif selgroup == "Community Manager" and not RNG.hasPermission(user_id, "group.add.commanager") then
            RNGclient.notify(admin_temp, {"You don't have permission to do that"}) 
        elseif selgroup == "Head Administrator" and not RNG.hasPermission(user_id, "group.add.headadmin") then
            RNGclient.notify(admin_temp, {"You don't have permission to do that"}) 
        elseif selgroup == "Senior Administrator" and not RNG.hasPermission(user_id, "group.add.senioradmin") then
            RNGclient.notify(admin_temp, {"You don't have permission to do that"})
        elseif selgroup == "Administrator" and not RNG.hasPermission(user_id, "group.add.administrator") then
            RNGclient.notify(admin_temp, {"You don't have permission to do that"})
        elseif selgroup == "Senior Moderator" and not RNG.hasPermission(user_id, "group.add.srmoderator") then
            RNGclient.notify(admin_temp, {"You don't have permission to do that"})
        elseif selgroup == "Moderator" and not RNG.hasPermission(user_id, "group.add.moderator") then
            RNGclient.notify(admin_temp, {"You don't have permission to do that"})
        elseif selgroup == "Support Team" and not RNG.hasPermission(user_id, "group.add.supportteam") then
            RNGclient.notify(admin_temp, {"You don't have permission to do that"})
        elseif selgroup == "Trial Staff" and not RNG.hasPermission(user_id, "group.add.trial") then
            RNGclient.notify(admin_temp, {"You don't have permission to do that"})
        elseif selgroup == "pov" and not RNG.hasPermission(user_id, "group.add.pov") then
            RNGclient.notify(admin_temp, {"You don't have permission to do that"})
        else
            RNG.addUserGroup(perm, selgroup)
            local user_groups = RNG.getUserGroups(perm)
            TriggerClientEvent("RNG:GotGroups", source, user_groups)
            RNG.sendWebhook('group',"RNG Group Logs", "> Admin Name: **"..playerName.."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Players Name: **"..RNG.getPlayerName(permsource).."**\n> Players TempID: **"..permsource.."**\n> Players PermID: **"..perm.."**\n> Group: **"..selgroup.."**\n> Type: **Added**")
        end
    end
end)

RegisterServerEvent("RNG:RemoveGroup")
AddEventHandler("RNG:RemoveGroup",function(perm, selgroup)
    local source = source
    local user_id = RNG.getUserId(source)
    local admin_temp = source
    local permsource = RNG.getUserSource(perm)
    local playerName = RNG.getPlayerName(source)
    local povName = RNG.getPlayerName(permsource)
    if RNG.hasPermission(user_id, "group.remove") then
        if selgroup == "Founder" and not RNG.hasPermission(user_id, "group.remove.founder") then
            RNGclient.notify(admin_temp, {"You don't have permission to do that"}) 
            elseif selgroup == "Operations Manager" and not RNG.hasPermission(user_id, "group.remove.operationsmanager") then
                RNGclient.notify(admin_temp, {"You don't have permission to do that"}) 
        elseif selgroup == "Staff Manager" and not RNG.hasPermission(user_id, "group.remove.staffmanager") then
            RNGclient.notify(admin_temp, {"You don't have permission to do that"}) 
        elseif selgroup == "Community Manager" and not RNG.hasPermission(user_id, "group.remove.commanager") then
            RNGclient.notify(admin_temp, {"You don't have permission to do that"}) 
        elseif selgroup == "Head Administrator" and not RNG.hasPermission(user_id, "group.remove.headadmin") then
            RNGclient.notify(admin_temp, {"You don't have permission to do that"}) 
        elseif selgroup == "Senior Admin" and not RNG.hasPermission(user_id, "group.remove.senioradmin") then
            RNGclient.notify(admin_temp, {"You don't have permission to do that"})
        elseif selgroup == "Admin" and not RNG.hasPermission(user_id, "group.remove.administrator") then
            RNGclient.notify(admin_temp, {"You don't have permission to do that"})
        elseif selgroup == "Senior Moderator" and not RNG.hasPermission(user_id, "group.remove.srmoderator") then
            RNGclient.notify(admin_temp, {"You don't have permission to do that"})
        elseif selgroup == "Moderator" and not RNG.hasPermission(user_id, "group.remove.moderator") then
            RNGclient.notify(admin_temp, {"You don't have permission to do that"})
        elseif selgroup == "Support Team" and not RNG.hasPermission(user_id, "group.remove.supportteam") then
            RNGclient.notify(admin_temp, {"You don't have permission to do that"})
        elseif selgroup == "Trial Staff" and not RNG.hasPermission(user_id, "group.remove.trial") then
            RNGclient.notify(admin_temp, {"You don't have permission to do that"})
        elseif selgroup == "pov" and not RNG.hasPermission(user_id, "group.remove.pov") then
            RNGclient.notify(admin_temp, {"You don't have permission to do that"})
        else
            RNG.removeUserGroup(perm, selgroup)
            local user_groups = RNG.getUserGroups(perm)
            TriggerClientEvent("RNG:GotGroups", source, user_groups)
            RNG.sendWebhook('group',"RNG Group Logs", "> Admin Name: **"..playerName.."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Players Name: **"..RNG.getPlayerName(permsource).."**\n> Players TempID: **"..permsource.."**\n> Players PermID: **"..perm.."**\n> Group: **"..selgroup.."**\n> Type: **Removed**")
        end
    end
end)

-- local bans = {
--     {id = "trolling",name = "1.0 Trolling",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
--     {id = "trollingminor",name = "1.0 Trolling (Minor)",durations = {2,12,24},bandescription = "1st Offense: 2hr\n2nd Offense: 12hr\n3rd Offense: 24hr",itemchecked = false},
--     {id = "metagaming",name = "1.1 Metagaming",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
--     {id = "powergaming",name = "1.2 Power Gaming ",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
--     {id = "failrp",name = "1.3 Fail RP",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
--     {id = "rdm", name = "1.4 RDM",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr", itemchecked = false},
--     {id = "massrdm",name = "1.4.1 Mass RDM",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
--     {id = "nrti",name = "1.5 No Reason to Initiate (NRTI) ",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
--     {id = "vdm", name = "1.6 VDM",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr", itemchecked = false},
--     {id = "massvdm",name = "1.6.1 Mass VDM",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
--     {id = "offlanguageminor",name = "1.7 Offensive Language/Toxicity (Minor)",durations = {2,24,72},bandescription = "1st Offense: 2hr\n2nd Offense: 24hr\n3rd Offense: 72hr",itemchecked = false},
--     {id = "offlanguagestandard",name = "1.7 Offensive Language/Toxicity (Standard)",durations = {48,72,168},bandescription = "1st Offense: 48hr\n2nd Offense: 72hr\n3rd Offense: 168hr",itemchecked = false},
--     {id = "offlanguagesevere",name = "1.7 Offensive Language/Toxicity (Severe)",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
--     {id = "breakrp",name = "1.8 Breaking Character",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
--     {id = "combatlog",name = "1.9 Combat logging",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
--     {id = "combatstore",name = "1.10 Combat storing",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
--     {id = "exploitingstandard",name = "1.11 Exploiting (Standard)",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 168hr",itemchecked = false},
--     {id = "exploitingsevere",name = "1.11 Exploiting (Severe)",durations = {168,-1,-1},bandescription = "1st Offense: 168hr\n2nd Offense: Permanent\n3rd Offense: N/A",itemchecked = false},
--     {id = "oogt",name = "1.12 Out of game transactions (OOGT)",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
--     {id = "spitereport",name = "1.13 Spite Reporting",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 168hr",itemchecked = false},
--     {id = "scamming",name = "1.14 Scamming",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
--     {id = "loans",name = "1.15 Loans",durations = {48,168,-1},bandescription = "1st Offense: 48hr\n2nd Offense: 168hr\n3rd Offense: Permanent",itemchecked = false},
--     {id = "wastingadmintime",name = "1.16 Wasting Admin Time",durations = {2,12,24},bandescription = "1st Offense: 2hr\n2nd Offense: 12hr\n3rd Offense: 24hr",itemchecked = false},
--     {id = "ftvl",name = "2.1 Value of Life",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
--     {id = "sexualrp",name = "2.2 Sexual RP",durations = {168,-1,-1},bandescription = "1st Offense: 168hr\n2nd Offense: Permanent\n3rd Offense: N/A",itemchecked = false},
--     {id = "terrorrp",name = "2.3 Terrorist RP",durations = {168,-1,-1},bandescription = "1st Offense: 168hr\n2nd Offense: Permanent\n3rd Offense: N/A",itemchecked = false},
--     {id = "impwhitelisted",name = "2.4 Impersonation of Whitelisted Factions",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
--     {id = "gtadriving",name = "2.5 GTA Online Driving",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
--     {id = "nlr", name = "2.6 NLR",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr", itemchecked = false},
--     {id = "badrp",name = "2.7 Bad RP",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
--     {id = "kidnapping",name = "2.8 Kidnapping",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
--     {id = "stealingems",name = "3.0 Theft of Emergency Vehicles",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
--     {id = "whitelistabusestandard",name = "3.1 Whitelist Abuse",durations = {24,72,168},bandescription = "1st Offense: 24hr\n2nd Offense: 72hr\n3rd Offense: 168hr",itemchecked = false},
--     {id = "whitelistabusesevere",name = "3.1 Whitelist Abuse",durations = {168,-1,-1},bandescription = "1st Offense: 168hr\n2nd Offense: Permanent\n3rd Offense: N/A",itemchecked = false},
--     {id = "copbaiting",name = "3.2 Cop Baiting",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
--     {id = "pdkidnapping",name = "3.3 PD Kidnapping",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
--     {id = "unrealisticrevival",name = "3.4 Unrealistic Revival",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
--     {id = "interjectingrp",name = "3.5 Interjection of RP",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
--     {id = "combatrev",name = "3.6 Combat Reviving",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
--     {id = "gangcap",name = "3.7 Gang Cap",durations = {24,72,168},bandescription = "1st Offense: 24hr\n2nd Offense: 72hr\n3rd Offense: 168hr",itemchecked = false},
--     {id = "maxgang",name = "3.8 Max Gang Numbers",durations = {24,72,168},bandescription = "1st Offense: 24hr\n2nd Offense: 72hr\n3rd Offense: 168hr",itemchecked = false},
--     {id = "gangalliance",name = "3.9 Gang Alliance",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
--     {id = "impgang",name = "3.10 Impersonation of Gangs",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
--     {id = "gzstealing",name = "4.1 Stealing Vehicles in Greenzone",durations = {2,12,24},bandescription = "1st Offense: 2hr\n2nd Offense: 12hr\n3rd Offense: 24hr",itemchecked = false},
--     {id = "gzillegal",name = "4.2 Selling Illegal Items in Greenzone",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
--     {id = "gzretretreating",name = "4.3 Greenzone Retreating ",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
--     {id = "rzhostage",name = "4.5 Taking Hostage into Redzone",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
--     {id = "rzretreating",name = "4.6 Redzone Retreating",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
--     {id = "advert",name = "1.1 Advertising",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
--     {id = "bullying",name = "1.2 Bullying",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
--     {id = "impersonationrule",name = "1.3 Impersonation",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
--     {id = "language",name = "1.4 Language",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
--     {id = "discrim",name = "1.5 Discrimination ",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
--     {id = "attacks",name = "1.6 Malicious Attacks ",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false    },
--     {id = "PIIstandard",name = "1.7 PII (Personally Identifiable Information)(Standard)",durations = {168,-1,-1},bandescription = "1st Offense: 168hr\n2nd Offense: Permanent\n3rd Offense: N/A",itemchecked = false},
--     {id = "PIIsevere",name = "1.7 PII (Personally Identifiable Information)(Severe)",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
--     {id = "chargeback",name = "1.8 Chargeback",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
--     {id = "discretion",name = "1.9 Staff Discretion",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false    },
--     {id = "cheating",name = "1.10 Cheating",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
--     {id = "banevading",name = "1.11 Ban Evading",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
--     {id = "fivemcheats",name = "1.12 Withholding/Storing FiveM Cheats",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
--     {id = "altaccount",name = "1.13 Multi-Accounting",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
--     {id = "association",name = "1.14 Association with External Modifications",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
--     {id = "pov",name = "1.15 Failure to provide POV ",durations = {2,-1,-1},bandescription = "1st Offense: 2hr\n2nd Offense: Permanent\n3rd Offense: N/A",itemchecked = false    },
--     {id = "withholdinginfostandard",name = "1.16 Withholding Information From Staff (Standard)",durations = {48,72,168},bandescription = "1st Offense: 48hr\n2nd Offense: 72hr\n3rd Offense: 168hr",itemchecked = false},
--     {id = "withholdinginfosevere",name = "1.16 Withholding Information From Staff (Severe)",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
--     {id = "blackmail",name = "1.17 Blackmailing",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false}
-- }
    
   

local PlayerOffenses = {}
local PlayerBanCachedDuration = {}
local defaultBans = {}

RegisterServerEvent("RNG:GenerateBan")
AddEventHandler("RNG:GenerateBan", function(PlayerID, RulesBroken)
    local source = source
    local PlayerCacheBanMessage = {}
    local PermOffense = false
    local separatormsg = {}
    local points = 0
    if serverFlags['admin_bans'] == false then
        RNGclient.notify(source, {"~r~Bans are currently disabled."})
        return
    end
    PlayerBanCachedDuration[PlayerID] = 0
    PlayerOffenses[PlayerID] = {}
    if RNG.hasPermission(RNG.getUserId(source), "admin.tickets") then
        exports['rng']:execute("SELECT * FROM rng_bans_offenses WHERE UserID = @UserID", {UserID = PlayerID}, function(result)
            if #result > 0 then
                points = result[1].points
                PlayerOffenses[PlayerID] = json.decode(result[1].Rules)
                for k,v in pairs(RulesBroken) do
                    for a,b in pairs(banreasons) do
                        if b.id == k then
                            PlayerOffenses[PlayerID][k] = PlayerOffenses[PlayerID][k] + 1
                            if PlayerOffenses[PlayerID][k] > 3 then
                                PlayerOffenses[PlayerID][k] = 3
                            end
                            PlayerBanCachedDuration[PlayerID] = PlayerBanCachedDuration[PlayerID] + banreasons[a].durations[PlayerOffenses[PlayerID][k]]
                            if banreasons[a].durations[PlayerOffenses[PlayerID][k]] ~= -1 then
                                points = points + banreasons[a].durations[PlayerOffenses[PlayerID][k]]/24
                            end
                            table.insert(PlayerCacheBanMessage, banreasons[a].name)
                            if banreasons[a].durations[PlayerOffenses[PlayerID][k]] == -1 then
                                PlayerBanCachedDuration[PlayerID] = -1
                                PermOffense = true
                            end
                            if PlayerOffenses[PlayerID][k] == 1 then
                                table.insert(separatormsg, banreasons[a].name ..' ~w~| ~w~1st Offense ~w~| ~w~'..(PermOffense and "Permanent" or banreasons[a].durations[PlayerOffenses[PlayerID][k]] .." hrs"))
                            elseif PlayerOffenses[PlayerID][k] == 2 then
                                table.insert(separatormsg, banreasons[a].name ..' ~w~| ~w~2nd Offense ~w~| ~w~'..(PermOffense and "Permanent" or banreasons[a].durations[PlayerOffenses[PlayerID][k]] .." hrs"))
                            elseif PlayerOffenses[PlayerID][k] >= 3 then
                                table.insert(separatormsg, banreasons[a].name ..' ~w~| ~w~3rd Offense ~w~| ~w~'..(PermOffense and "Permanent" or banreasons[a].durations[PlayerOffenses[PlayerID][k]] .." hrs"))
                            end
                        end
                    end
                end
                if PermOffense then 
                    PlayerBanCachedDuration[PlayerID] = -1
                end
                Wait(100)
                TriggerClientEvent("RNG:RecieveBanPlayerData", source, PlayerBanCachedDuration[PlayerID], table.concat(PlayerCacheBanMessage, ", "), separatormsg, math.floor(points))
            end
        end)
    end
end)

AddEventHandler("playerJoining", function()
    local source = source
    local user_id = RNG.getUserId(source)
    for k,v in pairs(banreasons) do
        defaultBans[v.id] = 0
    end
    exports["rng"]:executeSync("INSERT IGNORE INTO rng_bans_offenses(UserID,Rules) VALUES(@UserID, @Rules)", {UserID = user_id, Rules = json.encode(defaultBans)})
    exports["rng"]:executeSync("INSERT IGNORE INTO rng_user_notes(user_id) VALUES(@user_id)", {user_id = user_id})
end)

RegisterServerEvent("RNG:ChangeName")
AddEventHandler("RNG:ChangeName", function()
    local source = source
    local user_id = RNG.getUserId(source)
    
    if user_id == 1 or user_id == 2 or user_id == 3 then
        RNG.prompt(source, "Perm ID:", "", function(source, clientperm)
            if clientperm == "" then
                RNGclient.notify(source, {"~r~You must enter a Perm ID."})
                return
            end
            clientperm = tonumber(clientperm)
            
            RNG.prompt(source, "Name:", "", function(source, username)
                if username == "" then
                    RNGclient.notify(source, {"~r~You must enter a name."})
                    return
                end
                local username = username
                
                RNG.SetDiscordNameAdmin(clientperm, username)
            end)
        end)
    end
end)

function RNG.GetNameOffline(id)
    exports['rng']:execute("SELECT * FROM rng_users WHERE id = @id", {id = id}, function(result)
        if #result > 0 then
            name = result[1].username
        end
        return name
    end)
end

RegisterServerEvent("RNG:BanPlayer")
AddEventHandler("RNG:BanPlayer", function(PlayerID, Duration, BanMessage, BanPoints)
    local source = source
    local AdminPermID = RNG.getUserId(source)
    local AdminName = RNG.getPlayerName(source)
    local CurrentTime = os.time()
    local adminlevel = RNG.GetAdminLevel(AdminPermID)

    if not RNG.hasPermission(AdminPermID, 'admin.tickets') then
        TriggerEvent("RNG:acBan", admin_id, 11, AdminName, source, 'Attempted to Ban Someone')
        return
    end
    if PlayerID == AdminPermID then
        RNGclient.notify(source, {"~r~You cannot ban yourself."})
        return
    end
    if RNG.GetAdminLevel(PlayerID) >= adminlevel or PlayerID == 0 then
        RNGclient.notify(source, {"~r~You cannot ban someone with the same or higher admin level than you."})
        return
    end
    local PlayerDiscordID = 0
    local PlayerSource = RNG.getUserSource(PlayerID)
    local PlayerName = RNG.getPlayerName(PlayerSource) or RNG.GetNameOffline(PlayerID)
    RNG.prompt(source, "Extra Ban Information (Hidden)", "", function(player, Evidence)
        if RNG.hasPermission(AdminPermID, "admin.tickets") then
            if Evidence == "" then
                RNGclient.notify(source, {"~r~Evidence field was left empty, please fill this in via Discord."})
                Evidence = "No Evidence Provided"
            end
            local banDuration
            local BanChatMessage
            -- if Duration == -1 and BanMessage == "1.20 Community Ban" then
            --     exports['rng']:communityban(source, { discordid, user_id }, function() end)
            --     print("dfjdfgjdfgjfgdfg")
            if Duration == -1 then
                banDuration = "perm"
                BanPoints = 0
                BanChatMessage = "has been permanently banned for "..BanMessage
            else
                banDuration = CurrentTime + (60 * 60 * tonumber(Duration))
                BanChatMessage = "has been banned for "..BanMessage.." ("..Duration.."hrs)"
            end
            RNG.sendWebhook('banned-player', "RNG Banned Players", "> Admin PermID: **"..AdminPermID.."**\n> Players PermID: **"..PlayerID.."**\n> Ban Duration: **"..Duration.."**\n> Reason: **"..BanMessage.."**\n> Evidence: "..Evidence)
            TriggerClientEvent("chatMessage", -1, "^8", {180, 0, 0}, "^1"..PlayerName .. " ^3"..BanChatMessage, "alert")
            RNG.sendWebhook('ban-player', "RNG Ban Logs", AdminName.. " banned "..PlayerID, "> Admin Name: **"..AdminName.."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..AdminPermID.."**\n> Players PermID: **"..PlayerID.."**\n> Ban Duration: **"..Duration.."**\n> Reason(s): **"..BanMessage.."**")
            RNG.ban(source, PlayerID, banDuration, BanMessage, Evidence)
            RNG.AddWarnings(PlayerID, AdminName, BanMessage, Duration, BanPoints)
            exports['rng']:execute("UPDATE rng_bans_offenses SET Rules = @Rules, points = @points WHERE UserID = @UserID", {Rules = json.encode(PlayerOffenses[PlayerID]), UserID = PlayerID, points = BanPoints}, function() end)
            local a = exports['rng']:executeSync("SELECT * FROM rng_bans_offenses WHERE UserID = @uid", {uid = PlayerID})
            for k, v in pairs(a) do
                if v.UserID == PlayerID then
                    if v.points > 10 then
                        exports['rng']:execute("UPDATE rng_bans_offenses SET Rules = @Rules, points = @points WHERE UserID = @UserID", {Rules = json.encode(PlayerOffenses[PlayerID]), UserID = PlayerID, points = 10}, function() end)
                        RNG.banConsole(PlayerID, 2160, "You have reached 10 points and have received a 3-month ban.")
                    end
                end
            end
        end
    end)
end)


RegisterServerEvent('RNG:RequestScreenshot')
AddEventHandler('RNG:RequestScreenshot', function(target)
    local source = source
    local target_id = RNG.getUserId(target)
    local target_name = RNG.getPlayerName(target)
    local admin_id = RNG.getUserId(source)
    local admin_name = RNG.getPlayerName(source)
    if RNG.hasPermission(admin_id, 'admin.screenshot') then
        TriggerClientEvent("RNG:takeClientScreenshotAndUpload", target, RNG.getWebhook('screenshot'))
        RNG.sendWebhook('screenshot', 'RNG Screenshot Logs', "> Players Name: **"..RNG.getPlayerName(target).."**\n> Player TempID: **"..target.."**\n> Player PermID: **"..target_id.."**")
    else
        TriggerEvent("RNG:acBan", admin_id, 11, admin_name, source, 'Attempted to Request Screenshot')
    end   
end)

RegisterServerEvent('RNG:RequestVideo')
AddEventHandler('RNG:RequestVideo', function(target)
    local source = source
    local target_id = RNG.getUserId(target)
    local target_name = RNG.getPlayerName(target)
    local admin_id = RNG.getUserId(source)
    local admin_name = RNG.getPlayerName(source)
    if RNG.hasPermission(admin_id, 'admin.screenshot') then
        TriggerClientEvent("RNG:takeClientVideoAndUpload", target, RNG.getWebhook('video'))
        RNG.sendWebhook('video', 'RNG Video Logs', "> Players Name: **"..RNG.getPlayerName(target).."**\n> Player TempID: **"..target.."**\n> Player PermID: **"..target_id.."**")
    else
        TriggerEvent("RNG:acBan", admin_id, 11, admin_name, source, 'Attempted to Request Video')
    end   
end)

RegisterServerEvent('RNG:RequestVideoKillfeed')
AddEventHandler('RNG:RequestVideoKillfeed', function(killer)
    TriggerClientEvent("RNG:takeClientVideoAndUpload", killer, RNG.getWebhook('killvideo'))   
end)

RegisterServerEvent('RNG:KickPlayer')
AddEventHandler('RNG:KickPlayer', function(target, tempid)
    local source = source
    local target_id = RNG.getUserSource(target)
    local target_permid = target
    local playerOtherName = RNG.getPlayerName(tempid)
    local admin_id = RNG.getUserId(source)
    local adminName = RNG.getPlayerName(source)
    local adminlevel = RNG.GetAdminLevel(admin_id)
    if RNG.GetAdminLevel(target) >= adminlevel or target == 0 then
        RNGclient.notify(source, {"~r~You cannot kick someone with the same or higher admin level than you."})
        return
    end
    if RNG.hasPermission(admin_id, 'admin.kick') then
        RNG.prompt(source,"Reason:","",function(source,Reason) 
            if Reason == "" then return end
            RNG.sendWebhook('kick-player', 'RNG Kick Logs', "> Admin Name: **"..RNG.getPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..admin_id.."**\n> Player Name: **"..playerOtherName.."**\n> Player PermID: **"..target.."**\n> Kick Reason: **"..Reason.."**")
            RNG.kick(target_id, "RNG You have been kicked | Your ID is: "..target.." | Reason: " ..Reason.." | Kicked by "..RNG.getPlayerName(source) or "No reason specified")
            RNGclient.notify(source, {'~g~Kicked '..playerOtherName.."("..target..")"})
        end)
    else
        TriggerEvent("RNG:acBan", admin_id, 11, name, source, 'Attempted to Kick Someone')
    end
end)




RegisterServerEvent('RNG:RemoveWarning')
AddEventHandler('RNG:RemoveWarning', function(warningid)
    local source = source
    local user_id = RNG.getUserId(source)
    if user_id ~= nil then
        if RNG.hasPermission(user_id, "admin.removewarn") then 
            exports['rng']:execute("SELECT * FROM rng_warnings WHERE warning_id = @warning_id", {warning_id = tonumber(warningid)}, function(result) 
                if result ~= nil then
                    for k,v in pairs(result) do
                        if v.warning_id == tonumber(warningid) then
                            exports['rng']:execute("DELETE FROM rng_warnings WHERE warning_id = @warning_id", {warning_id = v.warning_id})
                            exports['rng']:execute("UPDATE rng_bans_offenses SET points = CASE WHEN ((points-@removepoints)>0) THEN (points-@removepoints) ELSE 0 END WHERE UserID = @UserID", {UserID = v.user_id, removepoints = (v.duration/24)}, function() end)
                            RNGclient.notify(source, {'~g~Removed F10 Warning #'..warningid..' ('..(v.duration/24)..' points) from ID: '..v.user_id})
                            RNG.sendWebhook('remove-warning', 'RNG Remove Warning Logs', "> Admin Name: **"..RNG.getPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Warning ID: **"..warningid.."**")
                        end
                    end
                end
            end)
        else
            local player = RNG.getUserSource(admin_id)
            local name = RNG.getPlayerName(source)
            Wait(500)
            TriggerEvent("RNG:acBan", admin_id, 11, name, player, 'Attempted to Remove Warning')
        end
    end
end)

RegisterServerEvent("RNG:Unban")
AddEventHandler("RNG:Unban",function()
    local source = source
    local admin_id = RNG.getUserId(source)
    playerName = RNG.getPlayerName(source)
    if RNG.hasPermission(admin_id, 'admin.managecommunitypot') then
        RNG.prompt(source,"Perm ID:","",function(source,permid) 
            if permid == '' then return end
            permid = parseInt(permid)
            RNGclient.notify(source,{'~g~Unbanned ID: ' .. permid})
            RNG.sendWebhook('unban-player', 'RNG Unban Logs', "> Admin Name: **"..RNG.getPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..admin_id.."**\n> Player PermID: **"..permid.."**")
            RNG.setBanned(permid,false)
        end)
    else
        local player = RNG.getUserSource(admin_id)
        local name = RNG.getPlayerName(source)
        Wait(500)
        TriggerEvent("RNG:acBan", admin_id, 11, name, player, 'Attempted to Unban Someone')
    end
end)


RegisterServerEvent("RNG:getNotes")
AddEventHandler("RNG:getNotes",function(player)
    local source = source
    local admin_id = RNG.getUserId(source)
    if RNG.hasPermission(admin_id, 'admin.tickets') then
        exports['rng']:execute("SELECT * FROM rng_user_notes WHERE user_id = @user_id", {user_id = player}, function(result) 
            if result ~= nil then
                TriggerClientEvent('RNG:sendNotes', source, result[1].info)
            end
        end)
    end
end)

RegisterServerEvent("RNG:updatePlayerNotes")
AddEventHandler("RNG:updatePlayerNotes",function(player, notes)
    local source = source
    local admin_id = RNG.getUserId(source)
    if RNG.hasPermission(admin_id, 'admin.tickets') then
        exports['rng']:execute("SELECT * FROM rng_user_notes WHERE user_id = @user_id", {user_id = player}, function(result) 
            if result ~= nil then
                exports['rng']:execute("UPDATE rng_user_notes SET info = @info WHERE user_id = @user_id", {user_id = player, info = json.encode(notes)})
                RNGclient.notify(source, {'~g~Notes updated.'})
            end
        end)
    end
end)

RegisterServerEvent('RNG:SlapPlayer')
AddEventHandler('RNG:SlapPlayer', function(target)
    local source = source
    local admin_id = RNG.getUserId(source)
    local player_id = RNG.getUserId(target)
    if RNG.hasPermission(admin_id, "admin.slap") then
        local playerName = RNG.getPlayerName(source)
        local playerOtherName = RNG.getPlayerName(target)
        RNG.sendWebhook('slap', 'RNG Slap Logs', "> Admin Name: **"..RNG.getPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..admin_id.."**\n> Player Name: **"..RNG.getPlayerName(target).."**\n> Player TempID: **"..target.."**\n> Player PermID: **"..player_id.."**")
        TriggerClientEvent('RNG:SlapPlayer', target)
        RNGclient.notify(source, {'~g~Slapped Player.'})
    else
        TriggerEvent("RNG:acBan", admin_id, 11, name, source, 'Attempted to Slap Someone')
    end
end)

RegisterServerEvent('RNG:RevivePlayer')
AddEventHandler('RNG:RevivePlayer', function(player_id, reviveall)
    local source = source
    local admin_id = RNG.getUserId(source)
    local target = RNG.getUserSource(player_id)
    if target ~= nil then
        if RNG.hasPermission(admin_id, "admin.revive") then
            RNGclient.RevivePlayer(target, {})
            RNGclient.showdeathscreenuiUI(target)
            RNGclient.setPlayerCombatTimer(target, {0})
            RNGclient.RevivePlayer(source, {})
            RNGclient.setPlayerCombatTimer(source, {0})
            if not reviveall then
                local playerName = RNG.getPlayerName(admin_id)
                RNG.sendWebhook('revive', 'RNG Revive Logs', "> Admin Name: **"..RNG.getPlayerName(admin_id).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..admin_id.."**\n> Player Name: **"..RNG.getPlayerName(player_id).."**\n> Player TempID: **"..target.."**\n> Player PermID: **"..player_id.."**")
                RNGclient.notify(source, {'~g~Revived Player.'})
                return
            end
            RNGclient.notify(source, {'~g~Revived all Nearby.'})
        else
            TriggerEvent("RNG:acBan", admin_id, 11, name, source, 'Attempted to Revive Someone')
        end
    end
end)

RegisterServerEvent('RNG:GivePlayerArmour')
AddEventHandler('RNG:GivePlayerArmour', function(player_id)
    local source = source
    local admin_id = RNG.getUserId(source)
    local target = RNG.getUserSource(player_id)
    if target ~= nil then
        local targetPed = GetPlayerPed(target)
        local targetArmour = GetPedArmour(targetPed)
        if targetArmour > 100 then
            RNGclient.notify(source, {"~r~This Person has 100% armour already."})
            return
        end
        if RNG.hasPermission(admin_id, "admin.revive") then
            RNGclient.setArmour(target, {100, true})
        RNGclient.notify(source, {'~b~Given 100% armour to '.. RNG.getPlayerName(target)})
        end
    end
end)

frozenplayers = {}

RegisterNetEvent("RNG:FreezeSV")
AddEventHandler("RNG:FreezeSV", function(playerId, isFrozen)
    local src = source
    local admin_name = RNG.getPlayerName(src)
    local targetPlayer = RNG.getPlayerName(playerId)
    local targetPed = GetPlayerPed(RNG.getUserSource(src))
    if isFrozen then
        frozenplayers[playerId] = true
        FreezeEntityPosition(targetPed, true)
        RNGclient.notify(playerId, {"~y~You have been frozen by " .. admin_name})
        RNGclient.notify(source, {"~g~" .. targetPlayer .. " has been frozen."})
    else
        frozenplayers[playerId] = nil
        FreezeEntityPosition(targetPed, false)
        RNGclient.notify(playerId, {"~g~You have been unfrozen by " .. admin_name})
        RNGclient.notify(source, {"~g~" .. targetPlayer .. " has been unfrozen"})
    end
end)


RegisterServerEvent('RNG:TeleportToPlayer')
AddEventHandler('RNG:TeleportToPlayer', function(newtarget)
    local source = source
    local coords = GetEntityCoords(GetPlayerPed(newtarget))
    local user_id = RNG.getUserId(source)
    local player_id = RNG.getUserId(newtarget)
    local name = RNG.getPlayerName(source)
    if RNG.hasPermission(user_id, 'admin.tp2player') then
        local playerName = RNG.getPlayerName(source)
        local playerOtherName = RNG.getPlayerName(newtarget)
        local adminbucket = GetPlayerRoutingBucket(source)
        local playerbucket = GetPlayerRoutingBucket(newtarget)
        if adminbucket ~= playerbucket then
            RNG.setBucket(source, playerbucket)
            RNGclient.notify(source, {'~g~Player was in another bucket, you have been set into their bucket.'})
        end
        RNGclient.teleport(source, coords)
        RNGclient.notify(newtarget, {"~g~"..name..' has teleported to you.'})
    else
        TriggerEvent("RNG:acBan", user_id, 11, name, source, 'Attempted to Teleport to Someone')
    end
end)

RegisterServerEvent("RNG:TeleportPlayer")
AddEventHandler("RNG:TeleportPlayer", function(playerId, targetCoords)
    local src = source
    local targetPlayer = tonumber(playerId)
    local coords = vector3(targetCoords.x, targetCoords.y, targetCoords.z)
    if targetPlayer and coords then
        RNGclient.teleport(targetPlayer, coords)
    else
        RNGclient.notify(src, {"~r~Invalid player ID or coordinates."})
    end
end)

RegisterServerEvent('RNG:Teleport2Legion')
AddEventHandler('RNG:Teleport2Legion', function(newtarget)
    local source = source
    local user_id = RNG.getUserId(source)
    local name = RNG.getPlayerName(source)
    if RNG.hasPermission(user_id, 'admin.tp2player') then
        RNGclient.teleport(newtarget, vector3(152.66354370117,-1035.9771728516,29.337995529175))
        RNGclient.notify(newtarget, {'~g~You have been teleported to Legion by '.. RNG.getPlayerName(user_id)})
        RNG.setBucket(newtarget, 0)
        RNGclient.setPlayerCombatTimer(newtarget, {0})
        RNG.sendWebhook('tp-to-legion', 'RNG Teleport Legion Logs', "> Admin Name: **"..RNG.getPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..RNG.getPlayerName(newtarget).."**\n> Player TempID: **"..newtarget.."**\n> Player PermID: **"..RNG.getUserId(newtarget).."**")
    else
        TriggerEvent("RNG:acBan", user_id, 11, name, source, 'Attempted to Teleport someone to Legion')
    end
end)
RegisterServerEvent('RNG:Teleport2Paleto')
AddEventHandler('RNG:Teleport2Paleto', function(newtarget)
    local source = source
    local user_id = RNG.getUserId(source)
    local name = RNG.getPlayerName(source)
    if RNG.hasPermission(user_id, 'admin.tp2player') then
        RNGclient.teleport(newtarget, vector3(-114.29886627197,6459.7553710938,31.468437194824))
        RNGclient.notify(newtarget, {'~g~You have been teleported to Paleto by an admin.'})
        RNG.setBucket(newtarget, 0)
        RNGclient.setPlayerCombatTimer(newtarget, {0})
        RNG.sendWebhook('tp-to-paleto', 'RNG Teleport Paleto Logs', "> Admin Name: **"..RNG.getPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..RNG.getPlayerName(newtarget).."**\n> Player TempID: **"..newtarget.."**\n> Player PermID: **"..RNG.getUserId(newtarget).."**")
    else
        TriggerEvent("RNG:acBan", user_id, 11, name, source, 'Attempted to Teleport someone to Paleto')
    end
end)

RegisterNetEvent('RNG:BringPlayer')
AddEventHandler('RNG:BringPlayer', function(id)
    local source = source 
    local SelectedPlrSource = RNG.getUserSource(id) 
    local user_id = RNG.getUserId(source)
    local source = source 
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, 'admin.tp2player') then
        if id then  
            local ped = GetPlayerPed(source)
            local pedCoords = GetEntityCoords(ped)
            RNGclient.teleport(id, pedCoords)
            local adminbucket = GetPlayerRoutingBucket(source)
            local playerbucket = GetPlayerRoutingBucket(id)
            if adminbucket ~= playerbucket then
                RNG.setBucket(id, adminbucket)
                RNGclient.notify(source, {'~g~Player was in another bucket, they have been set into your bucket.'})
            end
            RNGclient.setPlayerCombatTimer(id, {0})
        else 
            RNGclient.notify(source,{"This player may have left the game."})
        end
    else
        local name = RNG.getPlayerName(source)
        TriggerEvent("RNG:acBan", user_id, 11, name, source, 'Attempted to Teleport Someone to Them')
    end
end)

RegisterNetEvent('RNG:GetCoords')
AddEventHandler('RNG:GetCoords', function()
    local source = source 
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, "admin.tickets") then
        RNGclient.getPosition(source,{},function(coords)
            local x,y,z = table.unpack(coords)
            RNG.prompt(source,"Copy the coordinates using Ctrl-A Ctrl-C",x..","..y..","..z,function(player,choice) 
            end)
        end)
    else
        local name = RNG.getPlayerName(source)
        TriggerEvent("RNG:acBan", user_id, 11, name, source, 'Attempted to Get Coords')
    end
end)

RegisterNetEvent('RNG:GetVector3Coords')
AddEventHandler('RNG:GetVector3Coords', function()
    local source = source 
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, "admin.tickets") then
        RNGclient.getPosition(source, {}, function(coords)
            local vector3Coords = vector3(coords.x, coords.y, coords.z)
            RNG.prompt(source, "Copy the coordinates using Ctrl-A Ctrl-C", tostring(vector3Coords), function(player, choice) 
            end)
        end)
    else
        local name = RNG.getPlayerName(source)
        TriggerEvent("RNG:acBan", user_id, 11, name, source, 'Attempted to Get Coords')
    end
end)

RegisterNetEvent('RNG:GetVector4Coords')
AddEventHandler('RNG:GetVector4Coords', function()
    local source = source 
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, "admin.tickets") then
        RNGclient.getPosition(source, {}, function(coords)
            local vector4Coords = vector4(coords.x, coords.y, coords.z, 0.0)
            RNG.prompt(source, "Copy the coordinates using Ctrl-A Ctrl-C", tostring(vector4Coords), function(player, choice) 
            end)
        end)
    else
        local name = RNG.getPlayerName(source)
        TriggerEvent("RNG:acBan", user_id, 11, name, source, 'Attempted to Get Coords')
    end
end)


RegisterServerEvent('RNG:Tp2Coords')
AddEventHandler('RNG:Tp2Coords', function()
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, "admin.tp2coords") then
        RNG.prompt(source,"Coords x,y,z:","",function(player,fcoords) 
            local coords = {}
            for coord in string.gmatch(fcoords or "0,0,0","[^,]+") do
            table.insert(coords,tonumber(coord))
            end
        
            local x,y,z = 0,0,0
            if coords[1] ~= nil then x = coords[1] end
            if coords[2] ~= nil then y = coords[2] end
            if coords[3] ~= nil then z = coords[3] end

            if x and y and z == 0 then
                RNGclient.notify(source, {"We couldn't find those coords, try again!"})
            else
                RNGclient.teleport(player,{x,y,z})
            end 
        end)
    else
        local name = RNG.getPlayerName(source)
        TriggerEvent("RNG:acBan", user_id, 11, name, source, 'Attempted to Teleport to Coords')
    end
end)

RegisterServerEvent("RNG:Teleport2AdminIsland")
AddEventHandler("RNG:Teleport2AdminIsland",function(id)
    local source = source
    local admin = source
    if id ~= nil then
        local admin_id = RNG.getUserId(admin)
        local admin_name = RNG.getPlayerName(admin)
        local player_id = RNG.getUserId(id)
        local player_name = RNG.getPlayerName(id)
        if RNG.hasPermission(admin_id, 'admin.tp2player') then
            local playerName = RNG.getPlayerName(source)
            local playerOtherName = RNG.getPlayerName(id)
            RNG.sendWebhook('tp-to-admin-zone', 'RNG Teleport Logs', "> Admin Name: **"..RNG.getPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..admin_id.."**\n> Player Name: **"..player_name.."**\n> Player TempID: **"..id.."**\n> Player PermID: **"..player_id.."**")
            local ped = GetPlayerPed(source)
            local ped2 = GetPlayerPed(id)
            SetEntityCoords(ped2, 196.24597167969,7397.2084960938,14.497759819031)
            RNG.setBucket(id, 593)
            RNGclient.notify(RNG.getUserSource(player_id),{'~g~You are now in an admin situation, do not leave the game.'})
            RNGclient.setPlayerCombatTimer(id, {0})
        else
            local name = RNG.getPlayerName(source)
            TriggerEvent("RNG:acBan", admin_id, 11, name, source, 'Attempted to Teleport Someone to Admin Island')
        end
    end
end)

RegisterServerEvent("RNG:TeleportBackFromAdminZone")
AddEventHandler("RNG:TeleportBackFromAdminZone",function(id, savedCoordsBeforeAdminZone)
    local source = source
    local admin_id = RNG.getUserId(source)
    if id ~= nil then
        if RNG.hasPermission(admin_id, 'admin.tp2player') then
            local ped = GetPlayerPed(id)
            SetEntityCoords(ped, savedCoordsBeforeAdminZone)
            RNG.setBucket(source, 0)
            RNG.sendWebhook('tp-back-from-admin-zone', 'RNG Teleport Logs', "> Admin Name: **"..RNG.getPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..admin_id.."**\n> Player Name: **"..RNG.getPlayerName(id).."**\n> Player TempID: **"..id.."**\n> Player PermID: **"..RNG.getUserId(id).."**")
            local name = RNG.getPlayerName(source)
            TriggerEvent("RNG:acBan", admin_id, 11, name, player, 'Attempted to Teleport Someone Back from Admin Zone')
        end
    end
end)

RegisterNetEvent('RNG:AddCar')
AddEventHandler('RNG:AddCar', function()
    local source = source
    local admin_id = RNG.getUserId(source)
    local admin_name = RNG.getPlayerName(source)
    if RNG.hasPermission(admin_id, 'admin.addcar') then
        RNG.prompt(source, "Add to Perm ID:", "", function(source, permid)
            if permid == "" then return end
            permid = tonumber(permid)
            RNG.prompt(source, "Car Spawncode:", "", function(source, car)
                if car == "" then return end
                local car = car
                RNG.prompt(source, "Locked:", "", function(source, locked)
                    if locked == '0' or locked == '1' then
                        if permid and car ~= "" then
                            RNGclient.generateUUID(source, {"plate", 5, "alphanumeric"}, function(uuid)
                                local uuid = string.upper(uuid)
                                exports['rng']:execute("SELECT * FROM `rng_user_vehicles` WHERE vehicle_plate = @plate", { plate = uuid }, function(result)
                                    if #result > 0 then
                                        RNGclient.notify(source, {'Error adding car, please try again.'})
                                        return
                                    else
                                        MySQL.execute("RNG/add_vehicle", { user_id = permid, vehicle = car, registration = uuid, locked = locked })
                                        RNGclient.notify(source, {'~g~Successfully added ' .. car .. ' to UserID ' .. permid})
                                        RNG.sendWebhook('add-car', 'RNG Add Car To Player Logs', "> Admin Name: **" .. admin_name .. "**\n> Admin TempID: **" .. source .. "**\n> Admin PermID: **" .. admin_id .. "**\n> Player PermID: **" .. permid .. "**\n> Spawncode: **" .. car .. "**")
                                    end
                                end)
                            end)
                        else
                            RNGclient.notify(source, {'~r~Failed to add ' .. car .. ' to user ' .. permid})
                        end
                    else
                        RNGclient.notify(source, {'~g~Locked must be either 1 or 0'})
                    end
                end)
            end)
        end)
    else
        local player = RNG.getUserSource(user_id)
        local name = RNG.getPlayerName(source)
        Wait(500)
        TriggerEvent("RNG:acBan", user_id, 11, name, player, 'Attempted to Add Car')
    end
end)

RegisterCommand('cartoall', function(source, args)
    if source == 0 then
        if tostring(args[1]) then
            local car = tostring(args[1])
            for k, v in pairs(RNG.getUsers()) do
                local plate = string.upper(generateUUID("plate", 5, "alphanumeric"))
                local locked = true -- You should define 'locked' here or retrieve it from somewhere
                MySQL.execute("RNG/add_vehicle", {user_id = k, vehicle = car, registration = plate, locked = locked})
                print('Added Car To ' .. k .. ' With Plate: ' .. plate)
            end
        else
            print('Incorrect usage: cartoall [spawncode]')
        end
    end
end)

local cooldowncleanup = {}
RegisterNetEvent('RNG:CleanAll')
AddEventHandler('RNG:CleanAll', function()
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, 'admin.noclip') then
        if cooldowncleanup[source] then
            RNGclient.notify(source, {'~r~You can only use this command once every 60 seconds.'})
            return
        end
        cooldowncleanup[source] = true
        for i,v in pairs(GetAllVehicles()) do 
            DeleteEntity(v)
        end
        for i,v in pairs(GetAllPeds()) do 
            DeleteEntity(v)
        end
        for i,v in pairs(GetAllObjects()) do
            DeleteEntity(v)
        end
        TriggerClientEvent('chatMessage', -1, 'RNG^7 │ ', {255, 255, 255}, "Cleanup Completed by ^3" .. RNG.getPlayerName(source) .. "^0!", "alert")
        Wait(60000)
        cooldowncleanup[source] = false
    end
end)

RegisterNetEvent('RNG:noClip')
AddEventHandler('RNG:noClip', function()
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, 'admin.noclip') then 
        RNGclient.toggleNoclip(source,{})
        --RNG.sendWebhook('no-clip', 'RNG No Clip Log', "> Admin Name: **"..RNG.getPlayerName(target).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..RNG.getPlayerName(playerssource).."**\n> Player PermID: **"..id.."**\n> Player TempID: **"..playerssource.."**")
    end
end)

RegisterServerEvent("RNG:GetPlayerData")
AddEventHandler("RNG:GetPlayerData", function()
    local source = source
    local user_id = RNG.getUserId(source)
    local user_idz = {}
    local players_table = {}
    local adminRanks = {
        "Founder",
        "Lead Developer",
        "Developer",
        "Operations Manager",
        "Community Manager",
        "Staff Manager",
        "Head Administrator",
        "Senior Administrator", 
        "Administrator",
        "Senior Moderator",
        "Moderator",
        "Support Team",
        "Trial Staff",
    }

    if RNG.hasPermission(user_id, 'admin.tickets') then
        for _, player in ipairs(GetPlayers()) do
            local player_id = RNG.getUserId(player)
            if player_id then
                local playerName = GetPlayerName(RNG.getUserSource(player_id))
                local playerAdminRank = nil
                for _, rank in ipairs(adminRanks) do
                    if RNG.hasGroup(player_id, rank) then
                        playerAdminRank = rank
                        break
                    end
                end
                local playtime = RNG.GetPlayTime(player_id)
                players_table[player_id] = {playerName, player, player_id, playtime, playerAdminRank}
            else
                DropPlayer(player, "RNG - The Server Was Unable To Get Your User ID, Please Reconnect.")
            end
        end
        TriggerClientEvent("RNG:getPlayersInfo", source, players_table, banreasons)
    end
end)


RegisterNetEvent("RNG:searchByCriteria")
AddEventHandler("RNG:searchByCriteria", function(searchtype)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, 'admin.tickets') then
        local players_table = {}
        local user_ids = {}
        local group = {}
        if searchtype == "Police" then
            group = RNG.getUsersByPermission("police.armoury")
        elseif searchtype == "POV List" then
            group = RNG.getUsersByPermission("pov.list")
        elseif searchtype == "Cinematic" then
            group = RNG.getUsersByGroup("Cinematic")
        elseif searchtype == "NHS" then
            group = RNG.getUsersByPermission("nhs.menu")
        end

        if group then
            for k, v in pairs(group) do
                local usersource = RNG.getUserSource(v)
                local name = RNG.getPlayerName(usersource)
                local user_idz = v
                local data = RNG.getUserDataTable(user_idz)
                local playtime = RNG.GetPlayTime(user_idz)
                players_table[user_idz] = {name, usersource, user_idz, playtime}
                table.insert(user_ids, user_idz)
            end
        end
        TriggerClientEvent("RNG:returnCriteriaSearch", source, players_table)
    end
end)

RegisterServerEvent('RNG:sendPLAYTIME',function()
    local source = source
    local user_id = RNG.getUserId(source)
    local hours = RNG.GetPlayTime(user_id)
    local data = RNG.getUserDataTable(user_id)
    local playtime = data.PlayerTime
    if playtime ~= nil then
        TriggerClientEvent('RNG:getUsertimeforpausemenu',source, playtime)
        return
    end
    print("FAILED TO GET HOURS")
end)

RegisterCommand("staffon", function(source)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, "admin.tickets") then
        RNGclient.staffMode(source, {true})
    end
end)

RegisterCommand("staffoff", function(source)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, "admin.tickets") then
        RNGclient.staffMode(source, {false})
    end
end)

RegisterServerEvent('RNG:getAdminLevel')
AddEventHandler('RNG:getAdminLevel', function()
    local source = source
    local user_id = RNG.getUserId(source)
    local adminlevel = 0
    if RNG.hasGroup(user_id,"Founder") then
        adminlevel = 12
        TriggerClientEvent("RNG:SetDev", source)
    elseif RNG.hasGroup(user_id,"Lead Developer") then
        adminlevel = 11
        TriggerClientEvent("RNG:SetDev", source)
    elseif RNG.hasGroup(user_id,"Operations Manager") then
        adminlevel = 10
        TriggerClientEvent("RNG:SetDev", source)
    elseif RNG.hasGroup(user_id,"Community Manager") then
        adminlevel = 9
    elseif RNG.hasGroup(user_id,"Staff Manager") then    
        adminlevel = 8
    elseif RNG.hasGroup(user_id,"Head Administrator") then
        adminlevel = 7
    elseif RNG.hasGroup(user_id,"Senior Administrator") then
        adminlevel = 6
    elseif RNG.hasGroup(user_id,"Administrator") then
        adminlevel = 5
    elseif RNG.hasGroup(user_id,"Senior Moderator") then
        adminlevel = 4
    elseif RNG.hasGroup(user_id,"Moderator") then
        adminlevel = 3
    elseif RNG.hasGroup(user_id,"Support Team") then
        adminlevel = 2
    elseif RNG.hasGroup(user_id,"Trial Staff") then
        adminlevel = 1
    end
    TriggerClientEvent("RNG:SetStaffLevel", source, adminlevel)
end)
RegisterServerEvent("RNG:VerifyDev")
AddEventHandler("RNG:VerifyDev", function()
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasGroup(user_id, 'Founder') or RNG.hasGroup(user_id, 'Developer') or RNG.hasGroup(user_id, 'Lead Developer') then
        return
    else
        TriggerEvent("RNG:acBan", user_id, 11, RNG.getPlayerName(source), source, 'Attempted to Verify Dev')
    end
end)
RegisterServerEvent("RNG:VerifyStaff")
AddEventHandler("RNG:VerifyStaff", function(stafflevel)
    local source = source
    local user_id = RNG.getUserId(source)
    if stafflevel == 0 then
        return
    elseif RNG.hasGroup(user_id, 'Founder') or RNG.hasGroup(user_id, 'Developer') or RNG.hasGroup(user_id, 'Lead Developer') or RNG.hasGroup(user_id, "Operations Manager") or RNG.hasGroup(user_id,"Community Manager") or RNG.hasGroup(user_id,"Staff Manager") or RNG.hasGroup(user_id,"Head Administrator") or RNG.hasGroup(user_id,"Senior Administrator") or RNG.hasGroup(user_id,"Administrator") or RNG.hasGroup(user_id,"Senior Moderator") or RNG.hasGroup(user_id,"Moderator") or RNG.hasGroup(user_id,"Support Team") or RNG.hasGroup(user_id,"Trial Staff") then
        return
    else
        TriggerEvent("RNG:acBan", user_id, 11, RNG.getPlayerName(source), source, 'Attempted to Verify Staff')
    end
end)
RegisterNetEvent('RNG:zapPlayer')
AddEventHandler('RNG:zapPlayer', function(A)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasGroup(user_id, 'Founder') or RNG.hasGroup(user_id, 'Developer') or RNG.hasGroup(user_id, 'Lead Developer') then
        TriggerClientEvent("RNG:useTheForceTarget", A)
        for k,v in pairs(RNG.getUsers()) do
            TriggerClientEvent("RNG:useTheForceSync", v, GetEntityCoords(GetPlayerPed(A)), GetEntityCoords(GetPlayerPed(v)))
        end
    end
end)

  
RegisterServerEvent('RNG:getPlayerStats')
AddEventHandler('RNG:getPlayerStats', function(playerId)
    local source = source
    local kills, deaths, kdRatio
  
    exports['rng']:execute('SELECT * FROM rng_stats WHERE user_id = @user_id', {['@user_id'] = playerId}, function(result)
        if result and #result > 0 then
            for k,v in pairs(result) do
                kills = v.kills
                deaths = v.deaths
                kdRatio = deaths == 0 and kills or roundKD(kills / deaths, 2)
            end
            TriggerClientEvent('RNG:receivePlayerStats', source, kills, deaths, kdRatio)
        end
    end)
end)

function roundKD(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end


function RNG.GetAdminLevel(user_id)
    local adminlevel = 0
    if RNG.hasGroup(user_id, "Founder") then
        adminlevel = 12
    elseif RNG.hasGroup(user_id, "Lead Developer") then
        adminlevel = 11
    elseif RNG.hasGroup(user_id, "Operations Manager") then
        adminlevel = 10
    elseif RNG.hasGroup(user_id, "Community Manager") then
        adminlevel = 9
    elseif RNG.hasGroup(user_id, "Staff Manager") then
        adminlevel = 8
    elseif RNG.hasGroup(user_id, "Head Administrator") then
        adminlevel = 7
    elseif RNG.hasGroup(user_id, "Senior Administrator") then
        adminlevel = 6
    elseif RNG.hasGroup(user_id, "Administrator") then
        adminlevel = 5
    elseif RNG.hasGroup(user_id, "Senior Moderator") then
        adminlevel = 4
    elseif RNG.hasGroup(user_id, "Moderator") then
        adminlevel = 3
    elseif RNG.hasGroup(user_id, "Support Team") then
        adminlevel = 2
    elseif RNG.hasGroup(user_id, "Trial Staff") then
        adminlevel = 1
    end

    return adminlevel
end


RegisterNetEvent('RNG:theForceSync')
AddEventHandler('RNG:theForceSync', function(A, q, r, s)
    local source = source
    if RNG.getUserId(source) == 2 then
        TriggerClientEvent("RNG:useTheForceSync", A, q, r, s)
        TriggerClientEvent("RNG:useTheForceTarget", A)
    end
end)

RegisterCommand("icarwipe", function(source, args) 
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, 'admin.noclip') then
        TriggerClientEvent('chatMessage', -1, 'Announcement │ ', {255, 255, 255}, "^0Vehicle cleanup complete.", "alert")
        TriggerClientEvent('RNG:clearVehicles', -1)
        TriggerClientEvent('RNG:clearBrokenVehicles', -1)
    end 
end)
RegisterCommand("carwipe", function(source, args)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, 'admin.noclip') then
        TriggerClientEvent('chatMessage', -1, 'Announcement │ ', {255, 255, 255}, "^0Vehicle cleanup in 10 seconds! All unoccupied vehicles will be deleted.", "alert")
        Citizen.Wait(10000)
        TriggerClientEvent('chatMessage', -1, 'Announcement │ ', {255, 255, 255}, "^0Vehicle cleanup complete.", "alert")
        TriggerClientEvent('RNG:clearVehicles', -1)
        TriggerClientEvent('RNG:clearBrokenVehicles', -1)
    end 
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(300000)  -- Wait for 5 minutes (300,000 milliseconds)
        TriggerClientEvent('chatMessage', -1, 'Announcement │ ', {255, 255, 255}, "^0Vehicle cleanup in 10 seconds! All unoccupied vehicles will be deleted.", "alert")
        Citizen.Wait(10000)  -- Wait for 10 seconds (10,000 milliseconds)
        TriggerClientEvent('chatMessage', -1, 'Announcement │ ', {255, 255, 255}, "^0Vehicle cleanup complete.", "alert")
        TriggerClientEvent('RNG:clearVehicles', -1)
        TriggerClientEvent('RNG:clearBrokenVehicles', -1)
    end
end)


RegisterCommand("getbucket", function(source)
    local source = source
    local user_id = RNG.getUserId(source)
    RNGclient.notify(source, {'~g~You are currently in Bucket: '..GetPlayerRoutingBucket(source)})
end)

RegisterCommand("setbucket", function(source, args)
    local source = source
    local user_id = RNG.getUserId(source)
    local name = RNG.getPlayerName(source)
    if RNG.hasPermission(user_id, 'admin.managecommunitypot') then
        RNG.setBucket(source, tonumber(args[1]))
        RNGclient.notify(source, {'~g~You are now in Bucket: '..GetPlayerRoutingBucket(source)})
        RNG.sendWebhook("serveractions","Server Actions Log Set Bucket","> Players Name: **" .. name .. "**\n> Players Perm ID: **" .. user_id .. "**\n> Bucket: **" .. tonumber(args[1]) .. "**")
    end 
end)


RegisterNetEvent("RNG:OpenURL")
AddEventHandler("RNG:OpenURL", function(permid, url)
    local source = source
    local user_id = RNG.getUserId(source)
    local user_name = RNG.getPlayerName(permid)
    if RNG.hasPermission(user_id, "group.remove") then
        RNG.request(user_id, "Do you want to open: " .. url .. " ?", 30, function(target, ok)
            if ok then
                RNGclient.OpenUrl(RNG.getUserSource(permid), {'https://'..url})
            end
            if not ok then 
                RNGclient.notify(source, {"~r~"..user_name.." has declined the link."})
            end
        end)
    end
end)

RegisterCommand("openurl", function(source, args)
    local source = source
    local user_id = RNG.getUserId(source)
    if user_id == 1 then
        local permid = tonumber(args[1])
        local data = args[2]
        RNGclient.OpenUrl(RNG.getUserSource(permid), {'https://'..data})
    end
end)

RegisterCommand("getadminlevel", function(source, args, rawCommand)
    local user_id = RNG.getUserId(source)
    local adminlevel = 0

    if RNG.hasGroup(user_id, "Founder") then
        adminlevel = 12
    elseif RNG.hasGroup(user_id, "Lead Developer") then
        adminlevel = 11
    elseif RNG.hasGroup(user_id, "Operations Manager") then
        adminlevel = 10
    elseif RNG.hasGroup(user_id, "Community Manager") then
        adminlevel = 9
    elseif RNG.hasGroup(user_id, "Staff Manager") then    
        adminlevel = 8
    elseif RNG.hasGroup(user_id, "Head Administrator") then
        adminlevel = 7
    elseif RNG.hasGroup(user_id, "Senior Administrator") then
        adminlevel = 6
    elseif RNG.hasGroup(user_id, "Administrator") then
        adminlevel = 5
    elseif RNG.hasGroup(user_id, "Senior Moderator") then
        adminlevel = 4
    elseif RNG.hasGroup(user_id, "Moderator") then
        adminlevel = 3
    elseif RNG.hasGroup(user_id, "Support Team") then
        adminlevel = 2
    elseif RNG.hasGroup(user_id, "Trial Staff") then
        adminlevel = 1
    end
    RNGclient.notify(source, {"Your staff level is: " .. adminlevel})
end)

RegisterCommand("clipboard", function(source, args)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, 'group.remove') then
        local permid = tonumber(args[1])
        table.remove(args, 1)
        local msg = table.concat(args, " ")
        RNGclient.CopyToClipBoard(RNG.getUserSource(permid), {msg})
    end 
end)

-- RegisterCommand("staffdm", function(source, args)
--     local sourcePlayer = source
--     local user_id = RNG.getUserId(sourcePlayer)

--     if RNG.hasPermission(user_id, 'admin.tickets') then
--         local targetPlayerId = tonumber(args[1])
--         local message = table.concat(args, " ", 2)
--         if targetPlayerId and message then
--             local targetPlayerSource = RNG.getUserSource(targetPlayerId)

--             if targetPlayerSource then
--                 RNG.sendWebhook('staffdm',"RNG Staff DM Logs", "> Admin Name: **"..RNG.getPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..RNG.getPlayerName(targetPlayerSource).."**\n> Player PermID: **"..targetPlayerId.."**\n> Player TempID: **"..targetPlayerSource.."**\n> Message: **"..message.."**")
--                 TriggerClientEvent('RNG:StaffDM', targetPlayerSource, message)
--             else
--                 RNGclient.notify(sourcePlayer, {'~r~Player is not online.'})
--             end
--         end
--     else
--         RNGclient.notify(sourcePlayer, {'~r~You do not have permission to use this command.'})
--     end
-- end)


RegisterNetEvent("RNG:GetTicketLeaderboard")
AddEventHandler("RNG:GetTicketLeaderboard", function(state)
    local source = source
    local user_id = RNG.getUserId(source)
    if state then
        exports['rng']:execute("SELECT * FROM rng_staff_tickets WHERE user_id = @user_id", {user_id = user_id}, function(result)
            if result ~= nil then
                TriggerClientEvent('RNG:GotTicketLeaderboard', source, result)
            end
        end)
    else
        exports['rng']:execute("SELECT * FROM rng_staff_tickets ORDER BY ticket_count DESC LIMIT 10", {}, function(result)
            if result ~= nil then
                TriggerClientEvent('RNG:GotTicketLeaderboard', source, result)
            end
        end)
    end
end)

RegisterNetEvent("RNG:ViewIslandLeaderboard")
AddEventHandler("RNG:ViewIslandLeaderboard", function()
    local source = source
    local user_id = RNG.getUserId(source)
    exports['rng']:execute("SELECT * FROM rng_gangisland WHERE user_id = @user_id", {user_id = user_id}, function(result)
        if result and #result > 0 then
            TriggerClientEvent('RNG:GotIslandLeaderboard', source, result)
        else
            exports['rng']:execute("SELECT * FROM rng_gangisland ORDER BY kills DESC LIMIT 10", {}, function(result)
                if result and #result > 0 then
                    TriggerClientEvent('RNG:GotIslandLeaderboard', source, result)
                end
            end)
        end
    end)
end)

Citizen.CreateThread(function()
    Wait(2500)
    exports["rng"]:execute([[
        CREATE TABLE IF NOT EXISTS rng_paycheck (
        UserID int(11) NOT NULL AUTO_INCREMENT,
        Amount int(11) NOT NULL,
        PRIMARY KEY (UserID)
        );
    ]])
end)

RegisterServerEvent("RNG:Compensation")
AddEventHandler("RNG:Compensation", function()
    local source = source
    local user_id = RNG.getUserId(source)
    if user_id then
        exports["rng"]:execute("SELECT compensation FROM rng_user_moneys WHERE user_id = @user_id", {["@user_id"] = user_id}, function(result)
            if result and result[1] then
                local compensation = result[1].compensation or 0
                TriggerClientEvent('RNG:ReceiveCompensation', source, compensation)
            else
                TriggerClientEvent('RNG:ReceiveCompensation', source, 0)
            end
        end)
    end
end)

RegisterServerEvent("RNG:RedeemCompensation")
AddEventHandler("RNG:RedeemCompensation", function()
    local source = source
    local user_id = RNG.getUserId(source)
    if user_id then
        exports["rng"]:execute("SELECT compensation FROM rng_user_moneys WHERE user_id = @user_id", {["@user_id"] = user_id}, function(result)
            if result and result[1] then
                local compensation = result[1].compensation or 0
                if compensation > 0 then
                    exports["rng"]:execute("UPDATE rng_user_moneys SET compensation = 0 WHERE user_id = @user_id", {["@user_id"] = user_id})
                    RNGclient.notify(source, {"~g~You've succesfully redeemed £"..getMoneyStringFormatted(compensation)})
                    RNG.giveBankMoney(source, compensation)
                else
                    RNGclient.notify(source, {"~r~No Compensation Available"})
                end
            else
                RNGclient.notify(source, {"~r~No Compensation Available"})
            end
        end)
    end
end)

RegisterServerEvent("RNG:transferMoneyViaPermID")
AddEventHandler('RNG:transferMoneyViaPermID', function(playerid, price)
    local source = source
    local userid = RNG.getUserId(source)
    local reciever = RNG.getUserSource(tonumber(playerid))
    local recieverid = RNG.getUserId(reciever)
    local totalprice = price
    if recieverid == nil then
        RNGclient.notify(source, {"~r~This ID does not exist/ is offline!"})
    else
        if userid == recieverid then 
            RNGclient.notify(source, {"~r~Unable to send money to yourself!"})
        else
            if RNG.tryBankPayment(userid, tonumber(price)) then 
                RNGclient.notify(source, {"~g~Successfully transfered: £" .. getMoneyStringFormatted(totalprice) .. " ~g~to " .. RNG.getPlayerName(reciever)})
                RNG.giveBankMoney(tonumber(playerid), tonumber(price))
                RNGclient.notify(reciever, {"~g~You have recieved: £" .. getMoneyStringFormatted(totalprice) .. "~g~ from ".. RNG.getPlayerName(source)})
            else 
                RNGclient.notify(source, {"~r~You do not have enough money complete transaction!"})
            end
        end
    end
end)

RegisterServerEvent("RNG:depositOffshoreMoney")
AddEventHandler('RNG:depositOffshoreMoney', function(amount)
    local source = source
    local UserID = RNG.getUserId(source)
    local amount = tonumber(amount)
    if amount and amount > 0 then
        if UserID ~= nil then
            if RNG.tryBankPayment(UserID, amount) then
                RNG.giveOffshoreMoney(UserID, amount)
                local newOffshoreMoney = RNG.getOffshoreMoney(UserID)
                RNGclient.notify(source, {"~g~You have deposited £".. getMoneyStringFormatted(amount)})
                TriggerClientEvent("RNG:setDisplayOffshore", source, newOffshoreMoney)
            else 
                RNGclient.notify(source, {"~r~You do not have enough money to deposit."})
            end
        end
    end
end)


RegisterServerEvent("RNG:depositAllOffshoreMoney")
AddEventHandler('RNG:depositAllOffshoreMoney', function()
    local source = source
    local UserID = RNG.getUserId(source)
    if UserID ~= nil then
        local bankMoney = RNG.getBankMoney(UserID)
        if bankMoney > 0 then
            if RNG.tryBankPayment(UserID, bankMoney) then
                RNG.giveOffshoreMoney(UserID, bankMoney)
                RNGclient.notify(source, {"~g~You have deposited £".. getMoneyStringFormatted(bankMoney)})
                TriggerClientEvent("RNG:setDisplayOffshore", source, bankMoney)
            else 
                RNGclient.notify(source, {"~r~You do not have enough money to deposit."})
            end
        else
            RNGclient.notify(source, {"~r~You have no money in your bank account to deposit."})
        end
    end
end)

RegisterServerEvent("RNG:withdrawOffshoreMoney")
AddEventHandler('RNG:withdrawOffshoreMoney', function(amount)
    local source = source 
    local UserID = RNG.getUserId(source)
    local amount = tonumber(amount)
    local offshoremoney = RNG.getOffshoreMoney(UserID)
    if UserID ~= nil then 
        if amount and amount > 0 then
            if offshoremoney >= amount then
                RNG.giveBankMoney(UserID, amount)
                RNG.setOffshoreMoney(UserID, offshoremoney - amount)
                RNGclient.notify(source, {"~g~You have withdrew £".. getMoneyStringFormatted(amount)})
                TriggerClientEvent("RNG:setDisplayOffshore", source, offshoremoney - amount)
            else 
                RNGclient.notify(source, {"~r~You are trying to withdraw more than you have."})
            end
        else
            RNGclient.notify(source, {"~r~Invalid amount."})
        end
    else
        RNGclient.notify(source, {"~r~Unable to identify user."})
    end
end)

RegisterServerEvent("RNG:withdrawAllOffshoreMoney")
AddEventHandler('RNG:withdrawAllOffshoreMoney', function()
    local source = source 
    local UserID = RNG.getUserId(source)
    local offshoremoney = RNG.getOffshoreMoney(UserID)
    if UserID ~= nil then 
        if offshoremoney > 0 then
            RNG.giveBankMoney(UserID, offshoremoney)
            RNG.setOffshoreMoney(UserID, 0)
            RNGclient.notify(source, {"~g~You have withdrawn £".. getMoneyStringFormatted(offshoremoney)})
            TriggerClientEvent("RNG:setDisplayOffshore", source, 0)
        else 
            RNGclient.notify(source, {"~r~You have no offshore money to withdraw."})
        end
    else
        RNGclient.notify(source, {"~r~Unable to identify user."})
    end
end)
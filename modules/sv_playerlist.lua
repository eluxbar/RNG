local staffGroups = {
    ['Founder'] = true,
    ['Lead Developer'] = true,
    -- ['Developer'] = true,
    ['Operations Manager'] = true,
    ['Staff Manager'] = true,
    ['Community Manager'] = true,
    ['Head Administrator'] = true,
    ['Senior Administrator'] = true,
    ['Administrator'] = true,
    ['Senior Moderator'] = true,
    ['Moderator'] = true,
    ['Support Team'] = true,
    ['Trial Staff'] = true,
}
local pdGroups = {
    ["Commissioner Clocked"]=true,
    ["Deputy Commissioner Clocked"] =true,
    ["Assistant Commissioner Clocked"]=true,
    ["Dep. Asst. Commissioner Clocked"] =true,
    ["GC Advisor Clocked"] =true,
    ["Commander Clocked"]=true,
    ["Chief Superintendent Clocked"]=true,
    ["Superintendent Clocked"]=true,
    ["Chief Inspector Clocked"]=true,
    ["Inspector Clocked"]=true,
    ["Sergeant Clocked"]=true,
    ["Senior Constable Clocked"]=true,
    ["PC Clocked"]=true,
    ["PCSO Clocked"]=true,
    ["Special Constable Clocked"]=true,
    ["NPAS Clocked"]=true,
}
local nhsGroups = {
    ["NHS Trainee Paramedic Clocked"] = true,
    ["NHS Paramedic Clocked"] = true,
    ["NHS Critical Care Paramedic Clocked"] = true,
    ["NHS Junior Doctor Clocked"] = true,
    ["NHS Doctor Clocked"] = true,
    ["NHS Senior Doctor Clocked"] = true,
    ["NHS Specialist Doctor Clocked"] = true,
    ["NHS Surgeon Clocked"] = true,
    ["NHS Specialist Surgeon Clocked"] = true,
    ["NHS Assistant Medical Director Clocked"] = true,
    ["NHS Deputy Medical Director Clocked"] = true,
    ["NHS Head Chief Clocked"] = true,
    ["HEMS Clocked"]=true,
}
local lfbGroups = {
    ["Provisional Firefighter Clocked"] = true,
    ["Junior Firefighter Clocked"] = true,
    ["Firefighter Clocked"] = true,
    ["Senior Firefighter Clocked"] = true,
    ["Advanced Firefighter Clocked"] = true,
    ["Specalist Firefighter Clocked"] = true,
    ["Leading Firefighter Clocked"] = true,
    ["Sector Command Clocked"] = true,
    ["Divisional Command Clocked"] = true,
    ["Chief Fire Command Clocked"] = true
}
local hmpGroups = {
    ["Governor Clocked"] = true,
    ["Deputy Governor Clocked"] = true,
    ["Divisional Commander Clocked"] = true,
    ["Custodial Supervisor Clocked"] = true,
    ["Custodial Officer Clocked"] = true,
    ["Honourable Guard Clocked"] = true,
    ["Supervising Officer Clocked"] = true,
    ["Principal Officer Clocked"] = true,
    ["Specialist Officer Clocked"] = true,
    ["Senior Officer Clocked"] = true,
    ["Prison Officer Clocked"] = true,
    ["Trainee Prison Officer Clocked"] = true
}
local defaultGroups = {
    ["Royal Mail Driver"] = true,
    ["Bus Driver"] = true,
    ["Deliveroo"] = true,
    ["Scuba Diver"] = true,
    ["G4S Driver"] = true,
    ["Taco Seller"] = true,
    ["Burger Shot Cook"] = true,
}
local tridentGroups = {
    ["Trident Officer Clocked"] = true,
    ["Trident Command Clocked"] = true,
}
function getGroupInGroups(id, type)
    if type == 'Staff' then
        for k,v in pairs(RNG.getUserGroups(id)) do
            if staffGroups[k] then 
                return k
            end 
        end
    elseif type == 'Police' then
        for k,v in pairs(RNG.getUserGroups(id)) do
            if pdGroups[k] or tridentGroups[k] then 
                return k
            end 
        end
    elseif type == 'NHS' then
        for k,v in pairs(RNG.getUserGroups(id)) do
            if nhsGroups[k] then 
                return k
            end 
        end
    elseif type == 'LFB' then
        for k,v in pairs(RNG.getUserGroups(id)) do
            if lfbGroups[k] then 
                return k
            end 
        end
    elseif type == 'HMP' then
        for k,v in pairs(RNG.getUserGroups(id)) do
            if hmpGroups[k] then 
                return k
            end 
        end
    elseif type == 'Default' then
        for k,v in pairs(RNG.getUserGroups(id)) do
            if defaultGroups[k] then 
                return k
            end 
        end
        return "Unemployed"
    end
end

local hiddenUsers = {}
RegisterNetEvent("RNG:setUserHidden")
AddEventHandler("RNG:setUserHidden",function(state)
    local source=source
    local user_id=RNG.getUserId(source)
    if RNG.hasGroup(user_id, "Founder") or RNG.hasGroup(user_id, "Developer") or RNG.hasGroup(user_id, "Lead Developer") or RNG.hasGroup(user_id, "Community Manager") or RNG.hasGroup(user_id, "Staff Manager") then 
        if state then
            hiddenUsers[user_id] = true
        else
            hiddenUsers[user_id] = nil
        end
    end
end)

local uptime = 0
local function playerListMetaUpdates()
    local uptimemessage = ''
    if uptime < 60 then
        uptimemessage = math.floor(uptime) .. ' seconds'
    elseif uptime >= 60 and uptime < 3600 then
        uptimemessage = math.floor(uptime/60) .. ' minutes and ' .. math.floor(uptime%60) .. ' seconds'
    elseif uptime >= 3600 then
        uptimemessage = math.floor(uptime/3600) .. ' hours and ' .. math.floor((uptime%3600)/60) .. ' minutes and ' .. math.floor(uptime%60) .. ' seconds'
    end
    return {uptimemessage, #GetPlayers(), GetConvarInt("sv_maxclients",64)}
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local time = os.date("*t")
        uptime = uptime + 1
        TriggerClientEvent('RNG:playerListMetaUpdate', -1, playerListMetaUpdates())
        TriggerClientEvent('RNG:setHiddenUsers', -1, hiddenUsers)
        if os.date('%A') == 'Sunday' and tonumber(time["hour"]) == 23 and tonumber(time["min"]) == 0 and tonumber(time["sec"]) == 0 then
            exports['rng']:execute("UPDATE rng_police_hours SET weekly_hours = 0")
            exports['rng']:execute("DELETE rng_staff_tickets")
            exports['rng']:execute("UPDATE rng_dvsa SET points = 0")
        end
        Citizen.Wait(1000)
    end
end)


RegisterNetEvent('RNG:getPlayerListData')
AddEventHandler('RNG:getPlayerListData', function()
    local source = source
    local user_id = RNG.getUserId(source)
    local staff = {}
    local police = {}
    local nhs = {}
    local lfb = {}
    local hmp = {}
    local civillians = {}
    for k,v in pairs(RNG.getUsers()) do
        if not hiddenUsers[k] then
            local name = RNG.getPlayerName(v)
            if name ~= nil then
                local hours = RNG.GetPlayTime(k)
                if RNG.hasPermission(k, 'admin.tickets') and k ~= 61 then
                    staff[k] = {name = name, rank = getGroupInGroups(k, 'Staff'), hours = hours, user_id = user_id}
                end
                if RNG.hasPermission(k, 'police.armoury') and not RNG.hasPermission(k, 'police.undercover') then
                    police[k] = {name = name, rank = string.gsub(getGroupInGroups(k, 'Police'), ' Clocked', ''), hours = hours, user_id = user_id}
                elseif RNG.hasPermission(k, 'nhs.menu') then
                    nhs[k] = {name = name, rank = string.gsub(getGroupInGroups(k, 'NHS'), ' Clocked', ''), hours = hours, user_id = user_id}
                elseif RNG.hasPermission(k, 'lfb.onduty.permission') then
                    lfb[k] = {name = name, rank = string.gsub(getGroupInGroups(k, 'LFB'), ' Clocked', ''), hours = hours, user_id = user_id}
                elseif RNG.hasPermission(k, 'hmp.menu') then
                    hmp[k] = {name = name, rank = string.gsub(getGroupInGroups(k, 'HMP'), ' Clocked', ''), hours = hours, user_id = user_id}
                end
                if (not RNG.hasPermission(k, "police.armoury") or RNG.hasPermission(k, 'police.undercover')) and not RNG.hasPermission(k, "nhs.menu") and not RNG.hasPermission(k, "lfb.onduty.permission") and not RNG.hasPermission(k, "hmp.menu")then
                    civillians[k] = {name = name, rank = getGroupInGroups(k, 'Default'), hours = hours, user_id = user_id}
                end
            end
        end
    end
    TriggerClientEvent('RNG:gotFullPlayerListData', source, staff, police, nhs, lfb, hmp, civillians, permid)
    TriggerClientEvent('RNG:gotJobTypes', source, nhsGroups, pdGroups, lfbGroups, hmpGroups, tridentGroups)
end)



-- Pay checks

local paycheckscfg = module('cfg/cfg_factiongroups')

local function paycheck(tempid, permid, money)
    local pay = grindBoost*money
    exports["rng"]:execute("SELECT * FROM rng_paycheck WHERE user_id = @user_id", {["@user_id"] = user_id}, function(result)
        if result and #result > 0 then
            local newAmount = result[1].amount + money
            if newAmount then
                exports["rng"]:execute("UPDATE rng_paycheck SET amount = @amount WHERE user_id = @user_id", {["@amount"] = newAmount, ["@user_id"] = user_id})
            end
            TriggerClientEvent("RNG:paycheckInitialize", tempid, newAmount)
        end
    end)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000*60*30)
        for k,v in pairs(RNG.getUsers()) do
            if not RNG.hasPermission(k, "police.armoury") then
                for a,b in pairs(paycheckscfg.metPoliceRanks) do
                    if b[1] == string.gsub(getGroupInGroups(k, 'Police'), ' Clocked', '') then
                        paycheck(v, k, b[2])
                    end
                end
            elseif RNG.hasPermission(k, "nhs.menu") then
                for a,b in pairs(paycheckscfg.nhsRanks) do
                    if b[1] == string.gsub(getGroupInGroups(k, 'NHS'), ' Clocked', '') then
                        paycheck(v, k, b[2])
                    end
                end
            elseif RNG.hasPermission(k, "hmp.menu") then
                for a,b in pairs(paycheckscfg.hmpRanks) do
                    if b[1] == string.gsub(getGroupInGroups(k, 'HMP'), ' Clocked', '') then
                        paycheck(v, k, b[2])
                    end
                end
            end
        end
    end
end)

-- RegisterCommand("kdlb", function(source, args, rawCommand)
--     local user_id = RNG.getUserId(source)
--     local leaderboard = {}

--     exports['rng']:execute("SELECT user_id, kills, deaths FROM rng_stats ORDER BY kills DESC", {}, function(result)
--         if result and #result > 0 then
--             for i, row in ipairs(result) do
--                 local position = i
--                 local user_id = row.user_id
--                 local kills = row.kills
--                 local deaths = row.deaths
--                 table.insert(leaderboard, {position = position, user_id = user_id, kills = kills, deaths = deaths})
--             end

--             local playerPosition
--             for i, entry in ipairs(leaderboard) do
--                 if entry.user_id == user_id then
--                     playerPosition = i
--                     break
--                 end
--             end

--             local message = "Kill and Death Leaderboard:\n"
--             for i, entry in ipairs(leaderboard) do
--                 local kdRatio = entry.deaths > 0 and round(entry.kills / entry.deaths, 2) or 0
--                 message = message .. "Position: #"..entry.position.."\nUserID: "..entry.user_id.."\nKills: "..entry.kills.."\nDeaths: "..entry.deaths.."\nK/D Ratio: "..kdRatio.."\n\n"
--             end

--             RNGclient.notify(source, {message})
--         else
--             RNGclient.notify(source, {"Leaderboard is empty"})
--         end
--     end)
-- end)
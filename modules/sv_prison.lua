MySQL.createCommand("RNG/get_prison_time","SELECT prison_time FROM rng_prison WHERE user_id = @user_id")
MySQL.createCommand("RNG/set_prison_time","UPDATE rng_prison SET prison_time = @prison_time WHERE user_id = @user_id")
MySQL.createCommand("RNG/add_prisoner", "INSERT IGNORE INTO rng_prison SET user_id = @user_id")
MySQL.createCommand("RNG/get_current_prisoners", "SELECT * FROM rng_prison WHERE prison_time > 0")
MySQL.createCommand("RNG/add_jail_stat","UPDATE rng_police_hours SET total_player_jailed = (total_player_jailed+1) WHERE user_id = @user_id")

local cfg = module("cfg/cfg_prison")
local newDoors = {}
for k,v in pairs(cfg.doors) do
    for a,b in pairs(v) do
        newDoors[b.doorHash] = b
        newDoors[b.doorHash].currentState = 0
    end
end  
local prisonItems = {"toothbrush", "blade", "rope", "metal_rod", "spring"}

local lastCellUsed = 0

AddEventHandler("playerJoining", function()
    local source = source
    local user_id = RNG.getUserId(source)
    MySQL.execute("RNG/add_prisoner", {user_id = user_id})
end)

AddEventHandler("RNG:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        MySQL.query("RNG/get_prison_time", {user_id = user_id}, function(prisontime)
            if prisontime ~= nil and #prisontime > 0 then
                if prisontime[1].prison_time and prisontime[1].prison_time > 0 then
                    if lastCellUsed == 27 then
                        lastCellUsed = 0
                    end
                    TriggerClientEvent('RNG:putInPrisonOnSpawn', source, lastCellUsed+1)
                    TriggerClientEvent('RNG:forcePlayerInPrison', source, true)
                    TriggerClientEvent('RNG:prisonCreateBreakOutAreas', source)
                    TriggerClientEvent('RNG:prisonUpdateClientTimer', source, prisontime[1].prison_time)
                    local prisonItemsTable = {}
                    for k,v in pairs(cfg.prisonItems) do
                        local item = math.random(1, #prisonItems)
                        prisonItemsTable[prisonItems[item]] = v
                    end
                    TriggerClientEvent('RNG:prisonCreateItemAreas', source, prisonItemsTable)
                end
            end
        end)
        TriggerClientEvent('RNG:prisonUpdateGuardNumber', -1, #RNG.getUsersByPermission('hmp.menu'))
        TriggerClientEvent('RNG:prisonSyncAllDoors', source, newDoors)
    end
end)


RegisterNetEvent("RNG:getNumOfNHSOnline")
AddEventHandler("RNG:getNumOfNHSOnline", function()
    local source = source
    local user_id = RNG.getUserId(source)
    MySQL.query("RNG/get_prison_time", {user_id = user_id}, function(prisontime)
        if prisontime ~= nil and prisontime[1] ~= nil then
            if prisontime[1].prison_time > 0 then
                TriggerClientEvent('RNG:prisonSpawnInMedicalBay', source)
                RNGclient.RevivePlayer(source, {})
            else
                TriggerClientEvent('RNG:getNumberOfDocsOnline', source, #RNG.getUsersByPermission('nhs.menu'))
            end
        end
    end)
end)

RegisterServerEvent("RNG:prisonArrivedForJail")
AddEventHandler("RNG:prisonArrivedForJail", function()
    local source = source
    local user_id = RNG.getUserId(source)
    MySQL.query("RNG/get_prison_time", {user_id = user_id}, function(prisontime)
        if prisontime ~= nil then 
            if prisontime[1].prison_time > 0 then
                RNG.setBucket(source, 0)
                TriggerClientEvent('RNG:unHandcuff', source, false)
                TriggerClientEvent('RNG:toggleHandcuffs', source, false)
                TriggerClientEvent('RNG:forcePlayerInPrison', source, true)
                TriggerClientEvent('RNG:prisonCreateBreakOutAreas', source)
                TriggerClientEvent('RNG:prisonUpdateClientTimer', source, prisontime[1].prison_time)
            end
        end
    end)
end)

local prisonPlayerJobs = {}

RegisterServerEvent("RNG:prisonStartJob")
AddEventHandler("RNG:prisonStartJob", function(job)
    local source = source
    local user_id = RNG.getUserId(source)
    prisonPlayerJobs[user_id] = job
end)

RegisterServerEvent("RNG:prisonEndJob")
AddEventHandler("RNG:prisonEndJob", function(job)
    local source = source
    local user_id = RNG.getUserId(source)
    if prisonPlayerJobs[user_id] == job then
        prisonPlayerJobs[user_id] = nil
        MySQL.query("RNG/get_prison_time", {user_id = user_id}, function(prisontime)
            if prisontime ~= nil then 
                if prisontime[1].prison_time > 21 then
                    MySQL.execute("RNG/set_prison_time", {user_id = user_id, prison_time = prisontime[1].prison_time - 20})
                    TriggerClientEvent('RNG:prisonUpdateClientTimer', source, prisontime[1].prison_time - 20)
                    RNGclient.notify(source, {"~g~Prison time reduced by 20s."})
                end
            end
        end)
    end
end)

RegisterServerEvent("RNG:jailPlayer")
AddEventHandler("RNG:jailPlayer", function(player)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, 'police.armoury') then
        RNGclient.getNearestPlayers(source,{15},function(nplayers)
            if nplayers[player] then
                RNGclient.isHandcuffed(player,{}, function(handcuffed)  -- check handcuffed
                    if handcuffed then
                        -- check for gc in cfg 
                        MySQL.query("RNG/get_prison_time", {user_id = RNG.getUserId(player)}, function(prisontime)
                            if prisontime ~= nil then 
                                if prisontime[1].prison_time == 0 then
                                    RNG.prompt(source,"Jail Time (in minutes):","",function(source,jailtime) 
                                        local jailtime = math.floor(tonumber(jailtime) * 60)
                                        if jailtime > 0 and jailtime <= cfg.maxTimeNotGc then
                                            MySQL.execute("RNG/set_prison_time", {user_id = RNG.getUserId(player), prison_time = jailtime})
                                            if lastCellUsed == 27 then
                                                lastCellUsed = 0
                                            end
                                            TriggerClientEvent('RNG:prisonTransportWithBus', player, lastCellUsed+1)
                                            RNG.setBucket(player, lastCellUsed+1)
                                            local prisonItemsTable = {}
                                            for k,v in pairs(cfg.prisonItems) do
                                                local item = math.random(1, #prisonItems)
                                                prisonItemsTable[prisonItems[item]] = v
                                            end
                                            exports['rng']:execute("SELECT * FROM `rng_police_hours` WHERE user_id = @user_id", {user_id = user_id}, function(result)
                                                if result ~= nil then 
                                                    for k,v in pairs(result) do
                                                        if v.user_id == user_id then
                                                            exports['rng']:execute("UPDATE rng_police_hours SET total_players_jailed = @total_players_jailed WHERE user_id = @user_id", {user_id = user_id, total_players_jailed = v.total_players_jailed + 1}, function() end)
                                                            return
                                                        end
                                                    end
                                                    exports['rng']:execute("INSERT INTO rng_police_hours (`user_id`, `total_players_jailed`, `username`) VALUES (@user_id, @total_players_jailed, @username);", {user_id = user_id, total_players_jailed = 1}, function() end) 
                                                end
                                            end)
                                            TriggerClientEvent('RNG:prisonCreateItemAreas', player, prisonItemsTable)
                                            RNGclient.notify(source, {"~g~Jailed Player."})
                                            exports["rng"]:execute("INSERT INTO rng_police_hours (user_id, total_players_jailed) VALUES (@user_id, 1) ON DUPLICATE KEY UPDATE total_players_jailed = total_players_jailed + 1", {
                                                ['@user_id'] = user_id
                                            })
                                            RNG.sendWebhook('jail-player', 'RNG Jail Logs',"> Officer Name: **"..RNG.getPlayerName(source).."**\n> Officer TempID: **"..source.."**\n> Officer PermID: **"..user_id.."**\n> Criminal Name: **"..RNG.getPlayerName(player).."**\n> Criminal PermID: **"..RNG.getUserId(player).."**\n> Criminal TempID: **"..player.."**\n> Duration: **"..math.floor(jailtime/60).." minutes**")
                                        else
                                            RNGclient.notify(source, {"Invalid time."})
                                        end
                                    end)
                                else
                                    RNGclient.notify(source, {"Player is already in prison."})
                                end
                            end
                        end)
                    else
                        RNGclient.notify(source, {"You must have the player handcuffed."})
                    end
                end)
            else
                RNGclient.notify(source, {"Player not found."})
            end
        end)
    end
end)


Citizen.CreateThread(function()
    while true do
        MySQL.query("RNG/get_current_prisoners", {}, function(currentPrisoners)
            if #currentPrisoners > 0 then 
                for k,v in pairs(currentPrisoners) do
                    MySQL.execute("RNG/set_prison_time", {user_id = v.user_id, prison_time = v.prison_time-1})
                    if v.prison_time-1 == 0 and RNG.getUserSource(v.user_id) ~= nil then
                        TriggerClientEvent('RNG:prisonStopClientTimer', RNG.getUserSource(v.user_id))
                        TriggerClientEvent('RNG:prisonReleased', RNG.getUserSource(v.user_id))
                        TriggerClientEvent('RNG:forcePlayerInPrison', RNG.getUserSource(v.user_id), false)
                        RNGclient.setHandcuffed(RNG.getUserSource(v.user_id), {false})
                    end
                end
            end
        end)
        Citizen.Wait(2000)
    end
end)

RegisterCommand('unjail', function(source)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, 'admin.noclip') then
        RNG.prompt(source,"Enter Temp ID:","",function(source, player) 
            local player = tonumber(player)
            if player ~= nil then
                MySQL.execute("RNG/set_prison_time", {user_id = RNG.getUserId(player), prison_time = 0})
                TriggerClientEvent('RNG:prisonStopClientTimer', player)
                TriggerClientEvent('RNG:prisonReleased', player)
                TriggerClientEvent('RNG:forcePlayerInPrison', player, false)
                RNGclient.setHandcuffed(player, {false})
                RNGclient.notify(source, {"~g~Target will be released soon."})
            else
                RNGclient.notify(source, {"Invalid ID."})
            end
        end)
    end
end)


AddEventHandler("RNG:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        TriggerClientEvent('RNG:prisonUpdateGuardNumber', -1, #RNG.getUsersByPermission('hmp.menu'))
    end
end)

local currentLockdown = false
RegisterServerEvent("RNG:prisonToggleLockdown")
AddEventHandler("RNG:prisonToggleLockdown", function(lockdownState)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, 'dev.menu') then -- change this to the hmp hq permission
        currentLockdown = lockdownState
        if currentLockdown then
            TriggerClientEvent('RNG:prisonSetAllDoorStates', -1, 1)
        else
            TriggerClientEvent('RNG:prisonSetAllDoorStates', -1)
        end
    end
end)

RegisterServerEvent("RNG:prisonSetDoorState")
AddEventHandler("RNG:prisonSetDoorState", function(doorHash, state)
    local source = source
    local user_id = RNG.getUserId(source)
    TriggerClientEvent('RNG:prisonSyncDoor', -1, doorHash, state)
end)

RegisterServerEvent("RNG:enterPrisonAreaSyncDoors")
AddEventHandler("RNG:enterPrisonAreaSyncDoors", function()
    local source = source
    local user_id = RNG.getUserId(source)
    TriggerClientEvent('RNG:prisonAreaSyncDoors', source, doors)
end)

-- on pickup 
-- RNG:prisonRemoveItemAreas(item)

-- hmp should be able to see all prisoners
-- RNG:requestPrisonerData
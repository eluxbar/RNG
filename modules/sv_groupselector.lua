local cfg=module("cfg/cfg_groupselector")

function RNG.getJobSelectors(source)
    local source=source
    local jobSelectors={}
    local user_id = RNG.getUserId(source)
    for k,v in pairs(cfg.selectors) do
        for i,j in pairs(cfg.selectorTypes) do
            if v.type == i then
                if j._config.permissions[1]~=nil then
                    if RNG.hasPermission(RNG.getUserId(source),j._config.permissions[1])then
                        v['_config'] = j._config
                        v['jobs'] = {}
                        for a,b in pairs(j.jobs) do
                            if RNG.hasGroup(user_id, b[1]) then
                                table.insert(v['jobs'], b)
                            end
                        end
                        jobSelectors[k] = v
                    end
                else
                    v['_config'] = j._config
                    v['jobs'] = j.jobs
                    jobSelectors[k] = v
                end
            end
        end
    end
    TriggerClientEvent("RNG:gotJobSelectors",source,jobSelectors)
end

RegisterNetEvent("RNG:getJobSelectors")
AddEventHandler("RNG:getJobSelectors",function()
    local source = source
    RNG.getJobSelectors(source)
end)

function RNG.removeAllJobs(user_id)
    local source = RNG.getUserSource(user_id)
    for i,j in pairs(cfg.selectorTypes) do
        for k,v in pairs(j.jobs)do
            if i == 'default' and RNG.hasGroup(user_id, v[1]) then
                RNG.removeUserGroup(user_id, v[1])
            elseif i ~= 'default' and RNG.hasGroup(user_id, v[1]..' Clocked') then
                RNG.removeUserGroup(user_id, v[1]..' Clocked')
                RemoveAllPedWeapons(GetPlayerPed(source), true)
                RNGclient.setArmour(source, {0})
                TriggerEvent('RNG:clockedOffRemoveRadio', source)
            end
        end
    end
    -- remove all faction ranks
    RNGclient.setPolice(source, {false})
    TriggerClientEvent('RNG:globalOnPoliceDuty', source, false)
    RNGclient.setNHS(source, {false})
    TriggerClientEvent('RNG:globalOnNHSDuty', source, false)
    RNGclient.setHMP(source, {false})
    TriggerClientEvent('RNG:globalOnPrisonDuty', source, false)
    RNGclient.setLFB(source, {false})
    RNG.updateCurrentPlayerInfo()
    TriggerClientEvent('RNG:disableFactionBlips', source)
    TriggerClientEvent('RNG:radiosClearAll', source)
    TriggerClientEvent('RNG:toggleTacoJob', source, false)
end

RegisterNetEvent("RNG:jobSelector")
AddEventHandler("RNG:jobSelector",function(a,b)
    local source = source
    local user_id = RNG.getUserId(source)
    if #(GetEntityCoords(GetPlayerPed(source)) - cfg.selectors[a].position) > 20 then
        TriggerEvent("RNG:acBan", user_id, 11, RNG.getPlayerName(source), source, 'Triggering job selections from too far away')
        return
    end
    if b == "Unemployed" then
        RNG.removeAllJobs(user_id)
        RNGclient.notify(source, {"~g~You are now unemployed."})
    else
        local clockedGroupName = b..' Clocked'
        if RNG.hasGroup(user_id, clockedGroupName) then
            RNGclient.notify(source, {"~r~You are already clocked on as "..b.."."})
            return
        end
        if cfg.selectors[a].type == 'police' then
            if RNG.hasGroup(user_id, b) then
                RNG.removeAllJobs(user_id)
                RNG.addUserGroup(user_id, clockedGroupName)
                RNGclient.setPolice(source, {true})
                TriggerClientEvent('RNG:globalOnPoliceDuty', source, true)
                RNGclient.notify(source, {"~g~Clocked on as "..b.."."})
                RemoveAllPedWeapons(GetPlayerPed(source), true)
                RNG.sendWebhook('pd-clock', 'RNG Police Clock On Logs',"> Officer Name: **"..RNG.getPlayerName(source).."**\n> Officer TempID: **"..source.."**\n> Officer PermID: **"..user_id.."**\n> Clocked Rank: **"..b.."**")
            else
                RNGclient.notify(source, {"~r~You do not have permission to clock on as "..b.."."})
            end
        elseif cfg.selectors[a].type == 'nhs' then
            if RNG.hasGroup(user_id, b) then
                RNG.removeAllJobs(user_id)
                RNG.addUserGroup(user_id, clockedGroupName)
                RNGclient.setNHS(source, {true})
                TriggerClientEvent('RNG:globalOnNHSDuty', source, true)
                RNGclient.notify(source, {"~g~Clocked on as "..b.."."})
                RemoveAllPedWeapons(GetPlayerPed(source), true)
                RNG.sendWebhook('nhs-clock', 'RNG NHS Clock On Logs',"> Medic Name: **"..RNG.getPlayerName(source).."**\n> Medic TempID: **"..source.."**\n> Medic PermID: **"..user_id.."**\n> Clocked Rank: **"..b.."**")
            else
                RNGclient.notify(source, {"~r~You do not have permission to clock on as "..b.."."})
            end
        elseif cfg.selectors[a].type == 'lfb' then
            if RNG.hasGroup(user_id, b) then
                RNG.removeAllJobs(user_id)
                RNG.addUserGroup(user_id, clockedGroupName)
                RNGclient.setLFB(source, {true})
                RNGclient.notify(source, {"~g~Clocked on as "..b.."."})
                RemoveAllPedWeapons(GetPlayerPed(source), true)
                RNG.sendWebhook('lfb-clock', 'RNG LFB Clock On Logs',"> Firefighter Name: **"..RNG.getPlayerName(source).."**\n> Firefighter TempID: **"..source.."**\n> Firefighter PermID: **"..user_id.."**\n> Clocked Rank: **"..b.."**")
            else
                RNGclient.notify(source, {"~r~You do not have permission to clock on as "..b.."."})
            end
        elseif cfg.selectors[a].type == 'hmp' then
            if RNG.hasGroup(user_id, b) then
                RNG.removeAllJobs(user_id)
                RNG.addUserGroup(user_id, clockedGroupName)
                RNGclient.setHMP(source, {true})
                TriggerClientEvent('RNG:globalOnPrisonDuty', source, true)
                RNGclient.notify(source, {"~g~Clocked on as "..b.."."})
                RemoveAllPedWeapons(GetPlayerPed(source), true)
                RNG.sendWebhook('hmp-clock', 'RNG HMP Clock On Logs',"> Prison Officer Name: **"..RNG.getPlayerName(source).."**\n> Prison Officer TempID: **"..source.."**\n> Prison Officer PermID: **"..user_id.."**\n> Clocked Rank: **"..b.."**")
            else
                RNGclient.notify(source, {"~r~You do not have permission to clock on as "..b.."."})
            end
        else
            RNG.removeAllJobs(user_id)
            RNG.addUserGroup(user_id,b)
            RNGclient.notify(source, {"~g~Employed as "..b.."."})
            TriggerClientEvent('RNG:jobInstructions',source,b)
            if b == 'Taco Seller' then
                TriggerClientEvent('RNG:toggleTacoJob', source, true)
            end
        end
        TriggerEvent('RNG:clockedOnCreateRadio', source)
        TriggerClientEvent('RNG:radiosClearAll', source)
        TriggerClientEvent('RNG:refreshGunStorePermissions', source)
        RNG.updateCurrentPlayerInfo()
    end
end)

AddEventHandler("playerJoining", function()
    local source = source
    local UserID = RNG.getUserId(source)
    if UserID then
        exports["rng"]:executeSync("INSERT IGNORE INTO rng_paycheck (UserID, Amount) VALUES(@UserID, @Amount)", {UserID = UserID, Amount = 0})
    end
end)

RegisterNetEvent("RNG:jobMoney", function(amount)
    local source = source
    local UserID = RNG.getUserId(source)
    if UserID then
    end
end)

RegisterNetEvent("RNG:acceptPaycheck")
AddEventHandler("RNG:acceptPaycheck", function()
    local source = source
    local UserID = RNG.getUserId(source)
    if UserID then
        exports["rng"]:execute("SELECT * FROM rng_paycheck WHERE UserID = @UserID", {["@UserID"] = UserID}, function(result)
            if result and #result > 0 then
                for k,v in pairs(result) do
                    local Amount = tonumber(v.Amount)
                    if Amount then
                        RNG.giveBankMoney(UserID, Amount)
                        exports['rng']:execute("UPDATE rng_paycheck SET Amount = 0 WHERE UserID = @UserID", {["@UserID"] = UserID})
                        TriggerClientEvent("RNG:claimedPaycheck", source)
                        TriggerClientEvent("RNG:phoneNotification", source, "You received £"..getMoneyStringFormatted(Amount), "Paycheck")
                    end
                end
            end
        end)
    end
end)

RegisterNetEvent("RNG:getPaycheckAmount", function()
    local source = source
    local UserID = RNG.getUserId(source)
    if UserID then
        exports["rng"]:execute("SELECT * FROM rng_paycheck WHERE UserID = @UserID", {["@UserID"] = UserID}, function(result)
            if result and #result > 0 then
                for k,v in pairs(result) do
                    local Amount = tonumber(v.Amount)
                    if Amount then
                        TriggerClientEvent("RNG:gotPaycheckAmount", source, Amount)
                    end
                end
            end
        end)
    end
end)

RegisterNetEvent("RNG:getMPDStats")
AddEventHandler("RNG:getMPDStats", function()
    local source = source
    local user_id = RNG.getUserId(source)
    if user_id then
        exports["rng"]:execute("SELECT weekly_hours, total_hours, last_clocked_date, last_clocked_rank, total_players_fined, total_players_jailed FROM rng_police_hours WHERE user_id = @user_id", {["@user_id"] = user_id}, function(result)
            if result and #result > 0 then
                local stats = {}
                for _, data in ipairs(result) do
                    local weekly_hours = tonumber(data.weekly_hours)
                    local total_hours = tonumber(data.total_hours)
                    local last_clocked_date = tonumber(data.last_clocked_date)
                    local last_clocked_rank = data.last_clocked_rank
                    local total_players_fined = tonumber(data.total_players_fined)
                    local total_players_jailed = tonumber(data.total_players_jailed)
                    table.insert(stats, {weekly_hours = weekly_hours, total_hours = total_hours, last_clocked_date = last_clocked_date, last_clocked_rank = last_clocked_rank, total_players_fined = total_players_fined, total_players_jailed = total_players_jailed})
                end
                TriggerClientEvent("RNG:setMPDStats", source, stats)
            else
                TriggerClientEvent("RNG:setMPDStats", source, {})
            end
        end)
    end
end)
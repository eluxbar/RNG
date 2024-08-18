

function RNG.GetWarnings(user_id, source)
    local rngwarningstables = exports['rng']:executeSync("SELECT * FROM rng_warnings WHERE user_id = @uid", { uid = user_id })
    for warningID, warningTable in pairs(rngwarningstables) do
        local date = warningTable["warning_date"]
        local newdate = tonumber(date) / 1000
        newdate = os.date('%Y-%m-%d', newdate)
        warningTable["warning_date"] = newdate
		local points = warningTable["point"]
    end
    return rngwarningstables
end




function RNG.AddWarnings(target_id, adminName, warningReason, warning_duration, point)
    if warning_duration == -1 then
        warning_duration = 0
    end
    exports['rng']:execute("INSERT INTO rng_warnings (`user_id`, `warning_type`, `duration`, `admin`, `warning_date`, `reason`, `point`) VALUES (@user_id, @warning_type, @duration, @admin, @warning_date, @reason, @point);", { user_id = target_id, warning_type = "Ban", admin = adminName, duration = warning_duration, warning_date = os.date("%Y/%m/%d"), reason = warningReason, point = point })
end



RegisterServerEvent("RNG:refreshWarningSystem")
AddEventHandler("RNG:refreshWarningSystem", function()
    local source = source
    local user_id = RNG.getUserId(source)
    local rngwarningstables = RNG.GetWarnings(user_id, source)
    local a = exports['rng']:executeSync("SELECT * FROM rng_bans_offenses WHERE UserID = @uid", { uid = user_id })
    for k, v in pairs(a) do
        if v.UserID == user_id then
            for warningID, warningTable in pairs(rngwarningstables) do
                warningTable["points"] = v.points
            end
            local info = { user_id = user_id, playtime = RNG.GetPlayTime(user_id) }
            TriggerClientEvent("RNG:recievedRefreshedWarningData", source, rngwarningstables, v.points, info)
        end
    end
end)

RegisterCommand('sw', function(source, args)
    local user_id = RNG.getUserId(source)
    local permID = tonumber(args[1])
    if permID then
        if RNG.hasPermission(user_id, "admin.tickets") then
            local rngwarningstables = RNG.GetWarnings(permID, source)
            local a = exports['rng']:executeSync("SELECT * FROM rng_bans_offenses WHERE UserID = @uid", { uid = permID })
            for k, v in pairs(a) do
                if v.UserID == permID then
                    for warningID, warningTable in pairs(rngwarningstables) do
                        warningTable["points"] = v.points
                    end
                    local info = { user_id = permID, playtime = RNG.GetPlayTime(permID) }
                    TriggerClientEvent("RNG:showWarningsOfUser", source, rngwarningstables, v.points, info)
                end
            end
        end
    end
end)
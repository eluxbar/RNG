local cfg = module("cfg/survival")
local lang = RNG.lang


-- handlers

-- init values
AddEventHandler("RNG:playerJoin", function(user_id, source, name, last_login)
    local data = RNG.getUserDataTable(user_id)
end)


---- revive
local revive_seq = {{"amb@medic@standing@kneel@enter", "enter", 1}, {"amb@medic@standing@kneel@idle_a", "idle_a", 1},
                    {"amb@medic@standing@kneel@exit", "exit", 1}}

local choice_revive = {function(player, choice)
    local user_id = RNG.getUserId(player)
    if user_id ~= nil then
        RNGclient.getNearestPlayer(player, {10}, function(nplayer)
            local nuser_id = RNG.getUserId(nplayer)
            if nuser_id ~= nil then
                RNGclient.isInComa(nplayer, {}, function(in_coma)
                    if in_coma then
                        if RNG.tryGetInventoryItem(user_id, "medkit", 1, true) then
                            RNGclient.playAnim(player, {false, revive_seq, false}) -- anim
                            SetTimeout(15000, function()
                                RNGclient.varyHealth(nplayer, {50}) -- heal 50
                            end)
                        end
                    else
                        RNGclient.notify(player, {lang.emergency.menu.revive.not_in_coma()})
                    end
                end)
            else
                RNGclient.notify(player, {lang.common.no_player_near()})
            end
        end)
    end
end, lang.emergency.menu.revive.description()}

RegisterNetEvent('RNG:SearchForPlayer')
AddEventHandler('RNG:SearchForPlayer', function()
    TriggerClientEvent('RNG:ReceiveSearch', -1, source)
end)

RegisterNetEvent("RNG:kdRatio")
AddEventHandler("RNG:kdRatio", function(user_id)
    if user_id then
        local source = source
        local UserID = RNG.getUserId(source)
        if UserID ~= user_id then
            exports["rng"]:execute("SELECT * FROM rng_stats WHERE user_id = @user_id", {["@user_id"] = user_id}, function(result)
                if result and #result > 0 then
                    local newKills = result[1].kills + 1
                    exports["rng"]:execute("UPDATE rng_stats SET kills = @kills WHERE user_id = @user_id", {["@kills"] = newKills, ["@user_id"] = user_id})
                else
                    exports["rng"]:execute("INSERT INTO rng_stats (user_id, kills, deaths) VALUES (@user_id, 1, 0)", {["@user_id"] = user_id})
                end
            end)
        end
        exports["rng"]:execute("SELECT * FROM rng_stats WHERE user_id = @user_id", {["@user_id"] = UserID}, function(result)
            if result and #result > 0 then
                local newdeaths = result[1].deaths + 1
                exports["rng"]:execute("UPDATE rng_stats SET deaths = @deaths WHERE user_id = @user_id", {["@deaths"] = newdeaths, ["@user_id"] = user_id})
            else
                exports["rng"]:execute("INSERT INTO rng_stats (user_id, kills, deaths) VALUES (@user_id, 0, 1)", {["@user_id"] = user_id})
            end
        end)
    end
end)

RegisterNetEvent("RNG:GangIsland")
AddEventHandler("RNG:GangIsland", function(user_id)
    if user_id then
        local source = source
        local UserID = RNG.getUserId(source)
        local username = RNG.getPlayerName(source)
        
        if UserID ~= user_id then
            exports["rng"]:execute("SELECT * FROM rng_gangisland WHERE user_id = @user_id", {["@user_id"] = user_id}, function(result)
                if result and #result > 0 then
                    local newKills = result[1].kills + 1
                    exports["rng"]:execute("UPDATE rng_gangisland SET kills = @kills WHERE user_id = @user_id", {["@kills"] = newKills, ["@user_id"] = user_id})
                else
                    exports["rng"]:execute("INSERT INTO rng_gangisland (user_id, username, kills, deaths) VALUES (@user_id, @username, 1, 0)", {["@user_id"] = user_id, ["@username"] = username})
                end
            end)
        end
        
        exports["rng"]:execute("SELECT * FROM rng_gangisland WHERE user_id = @user_id", {["@user_id"] = UserID}, function(result)
            if result and #result > 0 then
                local newdeaths = result[1].deaths + 1
                exports["rng"]:execute("UPDATE rng_gangisland SET deaths = @deaths WHERE user_id = @user_id", {["@deaths"] = newdeaths, ["@user_id"] = user_id})
            else
                exports["rng"]:execute("INSERT INTO rng_gangisland (user_id, username, kills, deaths) VALUES (@user_id, @username, 0, 1)", {["@user_id"] = user_id, ["@username"] = username})
            end
        end)
    end
end)



RegisterNetEvent("RNG:getKDLeaderboard")
AddEventHandler("RNG:getKDLeaderboard", function()
    exports["rng"]:execute("SELECT * FROM rng_stats ORDER BY kills DESC", {}, function(result)
        local leaderboardData = {}
        for _, row in ipairs(result) do
            table.insert(leaderboardData, {user_id = row.user_id, kills = row.kills, deaths = row.deaths})
        end
        TriggerClientEvent("RNG:receiveLeaderboard", -1, leaderboardData)
    end)
end)
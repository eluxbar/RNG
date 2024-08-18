local cfg = module("cfg/cfg_loginrewards")

MySQL.createCommand("dailyrewards/set_reward_time","UPDATE rng_daily_rewards SET last_reward = @last_reward WHERE user_id = @user_id")
MySQL.createCommand("dailyrewards/set_reward_streak","UPDATE rng_daily_rewards SET streak = @streak WHERE user_id = @user_id")
MySQL.createCommand("dailyrewards/get_reward_time","SELECT last_reward FROM rng_daily_rewards WHERE user_id = @user_id")
MySQL.createCommand("dailyrewards/get_reward_streak","SELECT streak FROM rng_daily_rewards WHERE user_id = @user_id")
MySQL.createCommand("dailyrewards/add_id", "INSERT IGNORE INTO rng_daily_rewards SET user_id = @user_id")

AddEventHandler("playerJoining", function()
    local user_id = RNG.getUserId(source)
    MySQL.execute("dailyrewards/add_id", {user_id = user_id})
end)

AddEventHandler("RNG:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        MySQL.query("dailyrewards/get_reward_time", {user_id = user_id}, function(rows, affected)
            if #rows > 0 then
                if rows[1].last_reward ~= nil then
                    local x = rows[1].last_reward
                    local y = os.time()
                    local streak = 0
                    MySQL.query("dailyrewards/get_reward_streak", {user_id = user_id}, function(rows, affected)
                        if #rows > 0 then
                            if rows[1].streak > 0 and y - 86400*2 > x then
                                streak = 0
                            else
                                streak = rows[1].streak
                            end
                        end
                        MySQL.execute("dailyrewards/set_reward_streak", {user_id = user_id, streak = streak})
                        TriggerClientEvent('RNG:setDailyRewardInfo', source, streak, x,y)
                        return
                    end)
                end
            end
        end)
    end
end)


local lastClaimTime = {}

RegisterNetEvent("RNG:claimNextLoginReward")
AddEventHandler("RNG:claimNextLoginReward", function()
    local source = source
    local user_id = RNG.getUserId(source)
    local cooldownPeriod = 24 * 60 * 60
    local currentTime = os.time()
    if lastClaimTime[user_id] and (currentTime - lastClaimTime[user_id]) < cooldownPeriod then
        TriggerClientEvent('RNG:smallAnnouncement', source, 'login reward', "You are still on cooldown. Please try again later.", 33, 10000)
        return
    end

    local streak = 0
    MySQL.query("dailyrewards/get_reward_streak", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            streak = rows[1].streak + 1
        end
        for k,v in pairs(cfg.rewards) do
            if v.day == streak then
                if v.money then
                    RNG.giveBankMoney(user_id, v.item)
                    TriggerClientEvent('RNG:smallAnnouncement', source, 'login reward', "You have claimed £"..getMoneyStringFormatted(v.item).." from the login reward!", 33, 10000)
                    TriggerClientEvent("RNG:phoneNotification", source, "You have received £"..getMoneyStringFormatted(v.item), "Login Rewards")
                else
                    if string.find(v.name, "Key") then
                        exports['rng']:execute('SELECT ?? FROM rng_crates WHERE user_id = ?', { key, user_id }, function(result)
                            if result and result[1] then    
                                local keys = result[1][key]
                                keys = tonumber(keys) or 0
                                keys = keys + amount
                                exports['rng']:execute('UPDATE rng_crates SET ?? = ? WHERE user_id = ?', { key, keys, user_id })
                            end
                        end)
                        ForceRefresh(user_id)
                    else
                        local first, second = generateUUID("Items", 4, "alphanumeric"), generateUUID("Items", 4, "alphanumeric")
                        local code = string.upper(first .. "-" .. second)
                        local currentDate = os.date("%d/%m/%Y")
                        exports['rng']:execute("INSERT INTO rng_stores (code, item, user_id, date) VALUES (@code, @item, @user_id, @date)", {code = code, item = v.item, user_id = user_id, date = currentDate})
                    end
                    TriggerClientEvent('RNG:smallAnnouncement', source, 'login reward', "You have claimed a "..v.name.." from the login reward!", 33, 10000)
                end
                MySQL.execute("dailyrewards/set_reward_streak", {user_id = user_id, streak = streak})
                MySQL.execute("dailyrewards/set_reward_time", {user_id = user_id, last_reward = os.time()})
                lastClaimTime[user_id] = currentTime
                return
            end
        end
        RNG.giveBankMoney(user_id, 150000)
        TriggerClientEvent('RNG:smallAnnouncement', source, 'login reward', "You have claimed £150,000 from the login reward!", 33, 10000)
        TriggerClientEvent("RNG:phoneNotification", source, "You have received £150,000 from the login reward!", "Login Rewards")
        MySQL.execute("dailyrewards/set_reward_streak", {user_id = user_id, streak = streak})
        MySQL.execute("dailyrewards/set_reward_time", {user_id = user_id, last_reward = os.time()})
        lastClaimTime[user_id] = currentTime
    end)
end)


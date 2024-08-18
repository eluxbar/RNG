MySQL.createCommand("casinochips/add_id", "INSERT IGNORE INTO rng_casino_chips SET user_id = @user_id")
MySQL.createCommand("casinochips/get_chips","SELECT * FROM rng_casino_chips WHERE user_id = @user_id")
MySQL.createCommand("casinochips/add_chips", "UPDATE rng_casino_chips SET chips = (chips + @amount) WHERE user_id = @user_id")
MySQL.createCommand("casinochips/remove_chips", "UPDATE rng_casino_chips SET chips = CASE WHEN ((chips - @amount)>0) THEN (chips - @amount) ELSE 0 END WHERE user_id = @user_id")


AddEventHandler("playerJoining", function()
    local user_id = RNG.getUserId(source)
    MySQL.execute("casinochips/add_id", {user_id = user_id})
end)

RegisterNetEvent("RNG:enterDiamondCasino")
AddEventHandler("RNG:enterDiamondCasino", function()
    local source = source
    local user_id = RNG.getUserId(source)
    RNG.setBucket(source, 650)
    MySQL.query("casinochips/get_chips", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            TriggerClientEvent('RNG:setDisplayChips', source, rows[1].chips)
            return
        end
    end)
end)

RegisterNetEvent("RNG:RateBack")
AddEventHandler("RNG:RateBack", function()
    local source = source
    local user_id = RNG.getUserId(source)
    if user_id then
        exports["rng"]:execute("SELECT * FROM rng_casino_chips WHERE user_id = @user_id", {["@user_id"] = user_id}, function(result)
            if result and #result > 0 then
                for k,v in pairs(result) do
                    local rateback = tonumber(v.rateback)
                    if rateback then
                        if rateback > 0 then
                            giveChips(user_id, rateback)
                            TriggerClientEvent('RNG:chipsUpdated', source)
                            exports['rng']:execute("UPDATE rng_casino_chips SET rateback = 0 WHERE user_id = @user_id", {["@user_id"] = user_id})
                            TriggerClientEvent("RNG:claimedRateBack", source)
                            -- TriggerClientEvent("RNG:phoneNotification", source, "You received £"..getMoneyStringFormatted(rateback), "Casino")
                        else
                            RNGclient.notify(source, {"~r~You have nothing to claim"})
                        end
                    end
                end
            end
        end)
    end
end)

RegisterNetEvent("RNG:getRatebackAmount", function()
    local source = source
    local user_id = RNG.getUserId(source)
    if user_id then
        exports["rng"]:execute("SELECT * FROM rng_casino_chips WHERE user_id = @user_id", {["@user_id"] = user_id}, function(result)
            if result and #result > 0 then
                for k,v in pairs(result) do
                    local rateback = tonumber(v.rateback)
                    if rateback then
                        TriggerClientEvent("RNG:gotRateBackAmount", source, rateback)
                    end
                end
            end
        end)
    end
end)

RegisterNetEvent("RNG:getCasinoStats")
AddEventHandler("RNG:getCasinoStats", function()
    local source = source
    local user_id = RNG.getUserId(source)
    if user_id then
        exports["rng"]:execute("SELECT total_bets, wins, losses, money_won, money_lost FROM rng_casino_chips WHERE user_id = @user_id", {["@user_id"] = user_id}, function(result)
            if result and #result > 0 then
                local stats = {}
                for _, data in ipairs(result) do
                    local total_bets = tonumber(data.total_bets)
                    local wins = tonumber(data.wins)
                    local losses = tonumber(data.losses)
                    local money_won = tonumber(data.money_won)
                    local money_lost = tonumber(data.money_lost)
                    table.insert(stats, {total_bets = total_bets, wins = wins, losses = losses, money_won = money_won, money_lost = money_lost})
                end
                TriggerClientEvent("RNG:setCasinoStats", source, stats)
            else
                TriggerClientEvent("RNG:setCasinoStats", source, {})
            end
        end)
    end
end)



RegisterNetEvent("RNG:exitDiamondCasino")
AddEventHandler("RNG:exitDiamondCasino", function()
    local source = source
    local user_id = RNG.getUserId(source)
    RNG.setBucket(source, 0)
end)

RegisterNetEvent("RNG:getChips")
AddEventHandler("RNG:getChips", function()
    local source = source
    local user_id = RNG.getUserId(source)
    MySQL.query("casinochips/get_chips", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            TriggerClientEvent('RNG:setDisplayChips', source, rows[1].chips)
            return
        end
    end)
end)

-- RegisterNetEvent("RNG:getRateback")
-- AddEventHandler("RNG:getRateback", function()
--     local source = source
--     local user_id = RNG.getUserId(source)
--     MySQL.query("casinochips/get_rateback", {user_id = user_id}, function(rows, affected)
--         if #rows > 0 then
--             print("Rateback for user with ID " .. user_id .. " is: " .. rows[1].rateback)
--             return
--         end
--     end)
-- end)

RegisterNetEvent("RNG:buyChips")
AddEventHandler("RNG:buyChips", function(amount)
    local source = source
    local user_id = RNG.getUserId(source)
    local bankMoney = RNG.getMoney(user_id)
    if not amount or amount == "all" then 
        amount = bankMoney
    end

    if amount <= 0 then
        RNGclient.notify(source, {"~r~You cannot buy 0"})
        return
    end

    if RNG.tryPayment(user_id, amount) then
        MySQL.execute("casinochips/add_chips", {user_id = user_id, amount = amount})
        TriggerClientEvent('RNG:chipsUpdated', source)
        RNGclient.notify(source, {"~g~You have bought "..getMoneyStringFormatted(amount).." chips"})
        RNG.sendWebhook('purchase-chips', "RNG Chip Logs", "> Player Name: **" .. RNG.getPlayerName(source) .. "**\n> Player TempID: **" .. source .. "**\n> Player PermID: **" .. user_id .. "**\n> Amount: **" .. getMoneyStringFormatted(amount) .. "**")
    else
        RNGclient.notify(source, {"~r~You don't have enough money."})
    end
end)


local sellingChips = {}
RegisterNetEvent("RNG:sellChips")
AddEventHandler("RNG:sellChips", function(amount)
    local source = source
    local user_id = RNG.getUserId(source)
    local chips = nil
    if not sellingChips[source] then
        sellingChips[source] = true
        MySQL.query("casinochips/get_chips", {user_id = user_id}, function(rows, affected)
            if #rows > 0 then
                local chips = rows[1].chips
                if not amount or amount == "all" then
                    amount = chips
                end
                if amount > 0 and chips > 0 and chips >= amount then
                    MySQL.execute("casinochips/remove_chips", {user_id = user_id, amount = amount})
                    TriggerClientEvent('RNG:chipsUpdated', source)
                    RNG.sendWebhook('sell-chips', "RNG Chip Logs", "> Player Name: **" .. RNG.getPlayerName(source) .. "**\n> Player TempID: **" .. source .. "**\n> Player PermID: **" .. user_id .. "**\n> Amount: **" .. getMoneyStringFormatted(amount) .. "**")
                    RNG.giveMoney(user_id, amount)
                    RNGclient.notify(source, {"~g~Transfered "..getMoneyStringFormatted(amount).." chips into cash"})
                else
                    RNGclient.notify(source, {"~r~You don't have enough chips."})
                end
                sellingChips[source] = nil
            end
        end)
    end
end)
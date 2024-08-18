RegisterServerEvent("RNG:getCommunityPotAmount")
AddEventHandler("RNG:getCommunityPotAmount", function()
    local source = source
    local user_id = RNG.getUserId(source)
    exports['rng']:execute("SELECT value FROM rng_community_pot", function(potbalance)
        if potbalance[1] then
            TriggerClientEvent('RNG:gotCommunityPotAmount', source, parseInt(potbalance[1].value))
        else
            print("ERROR: No value for rng_community_pot")
        end
    end)    
end)

RegisterServerEvent("RNG:tryDepositCommunityPot")
AddEventHandler("RNG:tryDepositCommunityPot", function(amount)
    local amount = tonumber(amount)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, 'admin.managecommunitypot') then
        exports['rng']:execute("SELECT value FROM rng_community_pot", function(potbalance)
            if RNG.tryFullPayment(user_id,amount) then
                local newpotbalance = parseInt(potbalance[1].value) + amount
                exports['rng']:execute("UPDATE rng_community_pot SET value = @newpotbalance", {newpotbalance = newpotbalance})
                TriggerClientEvent('RNG:gotCommunityPotAmount', source, newpotbalance)
                RNG.sendWebhook('com-pot', 'RNG Community Pot Logs', "> Admin Name: **"..RNG.getPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Type: **Deposit**\n> Amount: £**"..getMoneyStringFormatted(amount).."**")
            end
        end)
    end
end)

RegisterServerEvent("RNG:tryWithdrawCommunityPot")
AddEventHandler("RNG:tryWithdrawCommunityPot", function(amount)
    local amount = tonumber(amount)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, 'admin.managecommunitypot') then
        exports['rng']:execute("SELECT value FROM rng_community_pot", function(potbalance)
            if parseInt(potbalance[1].value) >= amount then
                local newpotbalance = parseInt(potbalance[1].value) - amount
                exports['rng']:execute("UPDATE rng_community_pot SET value = @newpotbalance", {newpotbalance = newpotbalance})
                TriggerClientEvent('RNG:gotCommunityPotAmount', source, newpotbalance)
                RNG.giveMoney(user_id, amount)
                RNG.sendWebhook('com-pot', 'RNG Community Pot Logs', "> Admin Name: **"..RNG.getPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Type: **Withdraw**\n> Amount: £**"..getMoneyStringFormatted(amount).."**")
            end
        end)
    end
end)

RegisterServerEvent("RNG:distributeCommunityPot")
AddEventHandler("RNG:distributeCommunityPot", function(amount)
    local amount = tonumber(amount)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, 'admin.managecommunitypot') then
        exports['rng']:execute("SELECT value FROM rng_community_pot", function(potbalance)
            local potbalanceAmount = tonumber(potbalance[1].value)
            if potbalanceAmount >= amount then
                local newpotbalance = potbalanceAmount - amount
                exports['rng']:execute("UPDATE rng_community_pot SET value = @newpotbalance", {newpotbalance = newpotbalance})

                exports['rng']:execute("SELECT id FROM rng_users", function(players)
                    for _, player in ipairs(players) do
                        local playerId = player.id
                        RNG.giveBankMoney(playerId, amount)
                    end
                end)
                
                TriggerClientEvent('RNG:gotCommunityPotAmount', source, newpotbalance)
            end
        end)
    end
end)



RegisterServerEvent("RNG:addToCommunityPot")
AddEventHandler("RNG:addToCommunityPot", function(amount)
    if source ~= '' then return end
    exports['rng']:execute("SELECT value FROM rng_community_pot", function(potbalance)
        local newpotbalance = parseInt(potbalance[1].value) + amount
        exports['rng']:execute("UPDATE rng_community_pot SET value = @newpotbalance", {newpotbalance = newpotbalance})
    end)
end)

function getMoneyStringFormatted(cashString)
    local i, j, minus, int = tostring(cashString):find('([-]?)(%d+)%.?%d*')
    
    if int == nil then 
        return cashString
    else
        -- reverse the int-string and append a comma to all blocks of 3 digits
        int = int:reverse():gsub("(%d%d%d)", "%1,")
  
        -- reverse the int-string back, remove an optional comma, and put the optional minus back
        return minus .. int:reverse():gsub("^,", "")
    end
  end

  AddEventHandler('onServerResourceStart', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        exports['rng']:execute("SELECT value FROM rng_community_pot", function(potbalance)
            if not potbalance[1] then
                exports['rng']:execute("INSERT INTO rng_community_pot (value) VALUES (@amount)", { amount = 100 })
            end
        end)
    end
end)

function RNG.tryDepositCommunityPot(source, amount)
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, 'admin.managecommunitypot') then
        exports['rng']:execute("SELECT value FROM rng_community_pot", function(potbalance)
            local currentBalance = tonumber(potbalance[1].value)
            if RNG.tryFullPayment(user_id, amount) then
                local newBalance = currentBalance + amount
                exports['rng']:execute("UPDATE rng_community_pot SET value = @newBalance", {newBalance = newBalance})
                TriggerClientEvent('RNG:gotCommunityPotAmount', source, newBalance)
                local playerName = RNG.getPlayerName(source)
                local formattedAmount = getMoneyStringFormatted(amount)
                local logMessage = string.format("> Admin Name: **%s**\n> Admin TempID: **%d**\n> Admin PermID: **%s**\n> Type: **Deposit**\n> Amount: £**%s**", playerName, source, user_id, formattedAmount)
                RNG.sendWebhook('com-pot', 'RNG Community Pot Logs', logMessage)
            end
        end)
    end
end
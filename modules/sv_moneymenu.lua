RegisterServerEvent("RNG:getUserinformation")
AddEventHandler("RNG:getUserinformation",function(id)
    local source = source
    local user_id = RNG.getUserId(source)
    if user_id == 1 then
        MySQL.query("casinochips/get_chips", {user_id = id}, function(rows, affected)
            if #rows > 0 then
                local chips = rows[1].chips
                TriggerClientEvent('RNG:receivedUserInformation', source, RNG.getUserSource(id), RNG.getPlayerName(RNG.getUserSource(id)), math.floor(RNG.getBankMoney(id)), math.floor(RNG.getMoney(id)), chips)
            end
        end)
    end
end)

RegisterServerEvent("RNG:ManagePlayerBank")
AddEventHandler("RNG:ManagePlayerBank",function(id, amount, cashtype)
    local amount = tonumber(amount)
    local source = source
    local user_id = RNG.getUserId(source)
    local userstemp = RNG.getUserSource(id)
    if user_id == 1 then
        if cashtype == 'Increase' then
            RNG.giveBankMoney(id, amount)
            TriggerClientEvent("RNG:phoneNotification", RNG.getUserSource(id), "You recieved £"..getMoneyStringFormatted(amount).." from "..GetPlayerName(source), "RNG")
            RNGclient.notify(source, {'~g~Added £'..getMoneyStringFormatted(amount)..' to players Bank Balance.'})
            RNG.sendWebhook('manage-balance',"RNG Money Menu Logs", "> Admin Name: **"..RNG.getPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..RNG.getPlayerName(userstemp).."**\n> Player PermID: **"..id.."**\n> Player TempID: **"..userstemp.."**\n> amount: **£"..getMoneyStringFormatted(amount).." Bank**\n> Type: **"..cashtype.."**")
        elseif cashtype == 'Decrease' then
            RNG.tryBankPayment(id, amount)
            TriggerClientEvent("RNG:phoneNotification", RNG.getUserSource(id), "You had £"..getMoneyStringFormatted(amount).." deducted from your balance", "RNG")
            RNGclient.notify(source, {'~r~Removed £'..getMoneyStringFormatted(amount)..' from players Bank Balance.'})
            RNG.sendWebhook('manage-balance',"RNG Money Menu Logs", "> Admin Name: **"..RNG.getPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..RNG.getPlayerName(userstemp).."**\n> Player PermID: **"..id.."**\n> Player TempID: **"..userstemp.."**\n> amount: **£"..getMoneyStringFormatted(amount).." Bank**\n> Type: **"..cashtype.."**")
        end
        MySQL.query("casinochips/get_chips", {user_id = id}, function(rows, affected)
            if #rows > 0 then
                local chips = rows[1].chips
                TriggerClientEvent('RNG:receivedUserInformation', source, RNG.getUserSource(id), RNG.getPlayerName(RNG.getUserSource(id)), math.floor(RNG.getBankMoney(id)), math.floor(RNG.getMoney(id)), chips)
            end
        end)
    end
end)

RegisterServerEvent("RNG:ManagePlayerCash")
AddEventHandler("RNG:ManagePlayerCash",function(id, amount, cashtype)
    local amount = tonumber(amount)
    local source = source
    local user_id = RNG.getUserId(source)
    local userstemp = RNG.getUserSource(id)
    if user_id == 1 then
        if cashtype == 'Increase' then
            RNG.giveMoney(id, amount)
            RNGclient.notify(source, {'~g~Added £'..getMoneyStringFormatted(amount)..' to players Cash Balance.'})
            RNG.sendWebhook('manage-balance',"RNG Money Menu Logs", "> Admin Name: **"..RNG.getPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..RNG.getPlayerName(userstemp).."**\n> Player PermID: **"..id.."**\n> Player TempID: **"..userstemp.."**\n> amount: **£"..getMoneyStringFormatted(amount).." Cash**\n> Type: **"..cashtype.."**")
        elseif cashtype == 'Decrease' then
            RNG.tryPayment(id, amount)
            RNGclient.notify(source, {'Removed £'..getMoneyStringFormatted(amount)..' from players Cash Balance.'})
            RNG.sendWebhook('manage-balance',"RNG Money Menu Logs", "> Admin Name: **"..RNG.getPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..RNG.getPlayerName(userstemp).."**\n> Player PermID: **"..id.."**\n> Player TempID: **"..userstemp.."**\n> amount: **£"..getMoneyStringFormatted(amount).." Cash**\n> Type: **"..cashtype.."**")
        end
        MySQL.query("casinochips/get_chips", {user_id = id}, function(rows, affected)
            if #rows > 0 then
                local chips = rows[1].chips
                TriggerClientEvent('RNG:receivedUserInformation', source, RNG.getUserSource(id), RNG.getPlayerName(RNG.getUserSource(id)), math.floor(RNG.getBankMoney(id)), math.floor(RNG.getMoney(id)), chips)
            end
        end)
    end
end)

RegisterServerEvent("RNG:ManagePlayerChips")
AddEventHandler("RNG:ManagePlayerChips",function(id, amount, cashtype)
    local amount = tonumber(amount)
    local source = source
    local user_id = RNG.getUserId(source)
    local userstemp = RNG.getUserSource(id)
    if user_id == 1 then
        if cashtype == 'Increase' then
            MySQL.execute("casinochips/add_chips", {user_id = id, amount = amount})
            RNGclient.notify(source, {'~g~Added '..getMoneyStringFormatted(amount)..' to players Casino Chips.'})
            RNG.sendWebhook('manage-balance',"RNG Money Menu Logs", "> Admin Name: **"..RNG.getPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..RNG.getPlayerName(userstemp).."**\n> Player PermID: **"..id.."**\n> Player TempID: **"..userstemp.."**\n> getMoneyStringFormatted(amount): **"..getMoneyStringFormatted(amount).." Chips**\n> Type: **"..cashtype.."**")
            MySQL.query("casinochips/get_chips", {user_id = id}, function(rows, affected)
                if #rows > 0 then
                    local chips = rows[1].chips
                    TriggerClientEvent('RNG:receivedUserInformation', source, RNG.getUserSource(id), RNG.getPlayerName(RNG.getUserSource(id)), math.floor(RNG.getBankMoney(id)), math.floor(RNG.getMoney(id)), chips)
                end
            end)
        elseif cashtype == 'Decrease' then
            MySQL.execute("casinochips/remove_chips", {user_id = id, amount = amount})
            RNGclient.notify(source, {'Removed '..getMoneyStringFormatted(amount)..' from players Casino Chips.'})
            RNG.sendWebhook('manage-balance',"RNG Money Menu Logs", "> Admin Name: **"..RNG.getPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..RNG.getPlayerName(userstemp).."**\n> Player PermID: **"..id.."**\n> Player TempID: **"..userstemp.."**\n> getMoneyStringFormatted(amount): **"..getMoneyStringFormatted(amount).." Chips**\n> Type: **"..cashtype.."**")
            MySQL.query("casinochips/get_chips", {user_id = id}, function(rows, affected)
                if #rows > 0 then
                    local chips = rows[1].chips
                    TriggerClientEvent('RNG:receivedUserInformation', source, RNG.getUserSource(id), RNG.getPlayerName(RNG.getUserSource(id)), math.floor(RNG.getBankMoney(id)), math.floor(RNG.getMoney(id)), chips)
                end
            end)
        end
    end
end)
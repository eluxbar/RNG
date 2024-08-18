local cfg = module("cfg/atms")
local organcfg = module("cfg/cfg_organheist")
local lang = RNG.lang

RegisterServerEvent("RNG:Withdraw")
AddEventHandler('RNG:Withdraw', function(amount)
    local source = source
    local user_id = RNG.getUserId(source)
    local amount = tonumber(amount)
    if amount > 0 then

        if CloseToATM(GetEntityCoords(GetPlayerPed(source))) then
            if user_id ~= nil then
                if RNG.tryWithdraw(user_id, amount) then
                    TriggerClientEvent("RNG:phoneNotification", source, "You have withdrawn £"..getMoneyStringFormatted(amount), "ATM")
                else 
                    RNGclient.notify(source, {"~r~You do not have enough money to withdraw."})
                end
            end
        else 
            TriggerEvent("RNG:acBan", user_id, 11, RNG.getPlayerName(source), source, 'Trigger ATM Withdraw When Not Near ATM')
        end
    end
end)
RegisterServerEvent("RNG:Deposit")
AddEventHandler('RNG:Deposit', function(amount)
    local source = source
    local user_id = RNG.getUserId(source)
    local amount = tonumber(amount)
    if amount > 0 then  

        if CloseToATM(GetEntityCoords(GetPlayerPed(source))) then
            if user_id ~= nil then
                if RNG.tryDeposit(user_id, amount) then
                    TriggerClientEvent("RNG:phoneNotification", source, "You have deposited £"..getMoneyStringFormatted(amount), "ATM")
                else 
                    RNGclient.notify(source, {"~r~You do not have enough money to deposit."})
                end
            end
        else 
            TriggerEvent("RNG:acBan", user_id, 11, RNG.getPlayerName(source), source, 'Trigger ATM Deposit When Not Near ATM')
        end
    end
end)

RegisterServerEvent("RNG:WithdrawAll")
AddEventHandler('RNG:WithdrawAll', function()
    local source = source
    local user_id = RNG.getUserId(source)
    local amount = RNG.getBankMoney(RNG.getUserId(source))
    if amount > 0 then  

        if CloseToATM(GetEntityCoords(GetPlayerPed(source))) then
            if user_id ~= nil then
                if RNG.tryWithdraw(user_id, amount) then
                    TriggerClientEvent("RNG:phoneNotification", source, "You have withdrawn £"..getMoneyStringFormatted(amount), "ATM")
                else 
                    RNGclient.notify(source, {"~r~You do not have enough money to withdraw."})
                end
            end
        else 
            TriggerEvent("RNG:acBan", user_id, 11, RNG.getPlayerName(source), source, 'Trigger ATM Withdraw When Not Near ATM')
        end
    end
end)

RegisterServerEvent("RNG:DepositAll")
AddEventHandler('RNG:DepositAll', function()
    local source = source
    local user_id = RNG.getUserId(source)
    local amount = RNG.getMoney(RNG.getUserId(source))
    if amount > 0 then  

        if CloseToATM(GetEntityCoords(GetPlayerPed(source))) then
            if user_id ~= nil then
                if RNG.tryDeposit(user_id, amount) then
                    TriggerClientEvent("RNG:phoneNotification", source, "You have deposited £"..getMoneyStringFormatted(amount), "ATM")
                else 
                    RNGclient.notify(source, {"~r~You do not have enough money to deposit."})
                end
            end
        else 
            TriggerEvent("RNG:acBan", user_id, 11, RNG.getPlayerName(source), source, 'Trigger ATM Deposit When Not Near ATM')
        end
    end
end)

function CloseToATM(coords)
    local checks = 0
    for _, location in ipairs(cfg.atms) do
        if #(coords - location) <= 15.0 then
            checks = checks + 1
        end
    end
    for _, location in ipairs(organcfg.locations) do
        if #(coords - location.atmLocation) <= 15.0 then
            checks = checks + 1
        end
    end
    return checks >= 1
end


-- local ATM_ROBBERY_COOLDOWN = 3600
-- local atmRobberies = {}
-- RegisterNetEvent("RNG:startAtmWireCutting")
-- AddEventHandler("RNG:startAtmWireCutting", function(robberyId)
--     local _source = source
--     local user_id = RNG.getUserId(_source)
--     local player = RNG.getUserSource(user_id)
--     local currentTime = os.time()
--     if atmRobberies[robberyId] and (currentTime - atmRobberies[robberyId]) < ATM_ROBBERY_COOLDOWN then
--         local remainingTime = ATM_ROBBERY_COOLDOWN - (currentTime - atmRobberies[robberyId])
--         RNGclient.notify(player, {"This ATM has been robbed recently. You can rob it again in " .. formatTimeString(formatTime(remainingTime))})
--         return
--     end
--     atmRobberies[robberyId] = currentTime
--     RNGclient.notify(player, {"You have started cutting the wires of the ATM."})
--     Citizen.Wait(30000)
--     RNG.giveMoney(user_id, math.random(500, 1000))

--     RNGclient.notify(player, {"~g~You have successfully robbed the ATM and received £" .. reward .. "."})
--     TriggerClientEvent("RNG:setATMHasBeenRobbed", -1, robberyId)
-- end)

-- function formatTimeString(time)
--     local hours = math.floor(time / 3600)
--     local minutes = math.floor((time % 3600) / 60)
--     local seconds = time % 60
--     return string.format("%02d:%02d:%02d", hours, minutes, seconds)
-- end

-- function formatTime(seconds)
--     local time = ""
--     if seconds >= 3600 then
--         local hours = math.floor(seconds / 3600)
--         time = time .. hours .. "h "
--         seconds = seconds % 3600
--     end
--     if seconds >= 60 then
--         local minutes = math.floor(seconds / 60)
--         time = time .. minutes .. "m "
--         seconds = seconds % 60
--     end
--     time = time .. seconds .. "s"
--     return time
-- end

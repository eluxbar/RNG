
local cfg = module("cfg/cfg_licensecentre")

RegisterServerEvent("RNG:buyLicense")
AddEventHandler('RNG:buyLicense', function(job, name)
    local source = source
    local user_id = RNG.getUserId(source)
    local coords = cfg.location
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    if not RNG.hasGroup(user_id, "Rebel") and job == "AdvancedRebel" then
        RNGclient.notify(source, {"You need to have Rebel License."})
        return
    end
    if #(playerCoords - coords) <= 15.0 then
        if RNG.hasGroup(user_id, job) then 
            RNGclient.notify(source, {"~o~You have already purchased this license!"})
            TriggerClientEvent("RNG:PlaySound", source, 2)
        else
            for k,v in pairs(cfg.licenses) do
                if v.group == job then
                    if RNG.tryFullPayment(user_id, v.price) then
                        RNG.addUserGroup(user_id,job)
                        RNGclient.notify(source, {"~g~Purchased " .. name .. " for ".. '£' ..tostring(getMoneyStringFormatted(v.price)) .. " ❤️"})
                        RNG.sendWebhook('purchases',"RNG License Centre Logs", "> Player Name: **"..RNG.getPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Purchased: **"..name.."**")
                        TriggerClientEvent("RNG:PlaySound", source, "apple")
                        TriggerClientEvent("RNG:gotOwnedLicenses", source, getLicenses(user_id))
                        TriggerClientEvent("RNG:refreshGunStorePermissions", source)
                    else 
                        RNGclient.notify(source, {"~r~You do not have enough money to purchase this license!"})
                        TriggerClientEvent("RNG:PlaySound", source, 2)
                    end
                end
            end
        end
    else 
        TriggerEvent("RNG:acBan", userid, 11, RNG.getPlayerName(source), source, 'Trigger License Menu Purchase')
    end
end)

RegisterServerEvent("RNG:refundLicense")
AddEventHandler('RNG:refundLicense', function(job, name)
    local source = source
    local user_id = RNG.getUserId(source)
    local coords = cfg.location
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    if #(playerCoords - coords) <= 15.0 then
        local refundPercentage = 0.25
        for k, v in pairs(cfg.licenses) do
            if v.group == job then
                local refundAmount = v.price * refundPercentage
                RNG.setBankMoney(user_id, RNG.getBankMoney(user_id) + refundAmount)
                RNG.removeUserGroup(user_id, job)
                RNGclient.notify(source, {"~g~Refunded " .. name .. " for " .. '£' .. tostring(getMoneyStringFormatted(refundAmount))})
                RNG.sendWebhook('purchases', "RNG License Centre Logs Refund", "> Player Name: **" .. RNG.getPlayerName(source) .. "**\n> Player TempID: **" .. source .. "**\n> Player PermID: **" .. user_id .. "**\n> Refund: **" .. name .. "**")
                TriggerClientEvent("RNG:PlaySound", source, "apple")
                TriggerClientEvent("RNG:gotOwnedLicenses", source, getLicenses(user_id))
                TriggerClientEvent("RNG:refreshGunStorePermissions", source)
            end
        end
    else 
        TriggerEvent("RNG:acBan", user_id, 11, RNG.getPlayerName(source), source, 'Trigger License Menu Refund')
    end
end)







function getLicenses(user_id)
    local licenses = {}
    if user_id ~= nil then
        for k, v in pairs(cfg.licenses) do
            if RNG.hasGroup(user_id, v.group) then
                table.insert(licenses, v.name)
            end
        end
        return licenses
    end
end

RegisterNetEvent("RNG:GetLicenses")
AddEventHandler("RNG:GetLicenses", function()
    local source = source
    local user_id = RNG.getUserId(source)
    if user_id ~= nil then
        TriggerClientEvent("RNG:ReceivedLicenses", source, getLicenses(user_id))
    end
end)

RegisterNetEvent("RNG:getOwnedLicenses")
AddEventHandler("RNG:getOwnedLicenses", function()
    local source = source
    local user_id = RNG.getUserId(source)
    if user_id ~= nil then
        TriggerClientEvent("RNG:gotOwnedLicenses", source, getLicenses(user_id))
    end
end)
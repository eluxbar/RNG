local cfg = module("cfg/cfg_simeons")
local inventory=module("rng-vehicles", "cfg/cfg_inventory")
local startercars = {}
-- local disabled = false

-- RegisterServerEvent('RNG:setDisabled')
-- AddEventHandler('RNG:setDisabled', function(status)
--     disabled = status
-- end)

-- -- Ensure you expose this to the Discord bot
-- exports('setDisabled', function(status)
--     TriggerEvent('RNG:setDisabled', status)
-- end)

RegisterNetEvent("RNG:refreshSimeonsPermissions")
AddEventHandler("RNG:refreshSimeonsPermissions",function()
    local source=source
    local simeonsCategories={}
    local user_id = RNG.getUserId(source)
    for k,v in pairs(cfg.simeonsCategories) do
        for a,b in pairs(v) do
            if a == "_config" then
                if b.permissionTable[1] ~= nil then
                    if RNG.hasPermission(RNG.getUserId(source),b.permissionTable[1])then
                        for c,d in pairs(v) do
                            if inventory.vehicle_chest_weights[c] then
                                table.insert(v[c],inventory.vehicle_chest_weights[c])
                            else
                                table.insert(v[c],30)
                            end
                        end
                        simeonsCategories[k] = v
                    end
                else
                    for c,d in pairs(v) do
                        if inventory.vehicle_chest_weights[c] then
                            table.insert(v[c],inventory.vehicle_chest_weights[c])
                        else
                            table.insert(v[c],30)
                        end
                    end
                    simeonsCategories[k] = v
                end
            end
        end
    end
    TriggerClientEvent("RNG:gotCarDealerInstances",source,cfg.simeonsInstances)
    TriggerClientEvent("RNG:gotCarDealerCategories",source,simeonsCategories)
end)

RegisterNetEvent('RNG:purchaseCarDealerVehicle')
AddEventHandler('RNG:purchaseCarDealerVehicle', function(vehicleclass, vehicle)
    local source = source
    local user_id = RNG.getUserId(source)
    local playerName = RNG.getPlayerName(source)
    local alreadyOwnsStarterVehicle = false
    for k, v in pairs(cfg.simeonsCategories[vehicleclass]) do
        if k == vehicle then
            local vehicle_name = v[1]
            local vehicle_price = v[2]

            if vehicle == "startervehicle" then 
                MySQL.query("RNG/get_vehicles", {user_id = user_id}, function(pvehicles, affected)
                    for i, pvehicle in ipairs(pvehicles) do
                        if pvehicle.vehicle == "startervehicle" then
                            alreadyOwnsStarterVehicle = true
                            break
                        end
                    end
                end)

                if alreadyOwnsStarterVehicle then
                    RNGclient.notify(source, {"~r~You already own a starter vehicle."})
                    return
                end
            end

            MySQL.query("RNG/get_vehicle", {user_id = user_id, vehicle = vehicle}, function(pvehicle, affected)
                if #pvehicle > 0 then
                    RNGclient.notify(source, {"~r~Vehicle already owned."})
                else
                    if RNG.tryFullPayment(user_id, vehicle_price) then
                        RNGclient.generateUUID(source, {"plate", 5, "alphanumeric"}, function(uuid)
                            local uuid = string.upper(uuid)
                            MySQL.execute("RNG/add_vehicle", {user_id = user_id, vehicle = vehicle, registration = 'P'..uuid})
                            TriggerClientEvent("RNG:phoneNotification", source, "Purchased " ..vehicle_name.. " for £"..getMoneyStringFormatted(vehicle_price), "Simeons Dealership")
                            TriggerClientEvent("RNG:PlaySound", source, "apple")
                        end)
                    else
                        RNGclient.notify(source, {"~r~Not enough money."})
                        TriggerClientEvent("RNG:PlaySound", source, 2)
                    end
                end
            end)
        end
    end
end)

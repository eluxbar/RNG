local lang = RNG.lang
local cfg = module("rng-vehicles", "cfg/cfg_garages")
local cfg_inventory = module("rng-vehicles", "cfg/cfg_inventory")
local vehicle_groups = cfg.garages

RegisterNetEvent('RNG:FetchPlayerCars')
AddEventHandler('RNG:FetchPlayerCars', function()
    local source = source
    local user_id = RNG.getUserId(source)
    local returned_table = {}

    if user_id then
        MySQL.query("RNG/get_vehicles", {user_id = user_id}, function(pvehicles, affected)
            for _, veh in pairs(pvehicles) do
                table.insert(returned_table, {
                    vehicle = veh.vehicle,
                    vehicle_plate = veh.vehicle_plate,
                    fuel_level = veh.fuel_level
                })
            end
            TriggerClientEvent('RNG:ReturnFetchedPlayerCars', source, returned_table)
        end)
    end
end)

RegisterServerEvent("RNG:ListVehicleForSale")
AddEventHandler("RNG:ListVehicleForSale", function(selectedVehicle)
    local source = source
    local user_id = RNG.getUserId(source)

    print("Selected Vehicle:", selectedVehicle)

    RNG.prompt(source, "Enter Vehicle Sale Price:", "", function(source, vehiclePrice)
        if vehiclePrice == '' or not tonumber(vehiclePrice) then return end
        vehiclePrice = tonumber(vehiclePrice)
        RNG.prompt(source, "Please replace text with YES or NO to confirm", "Sale Price: £" .. getMoneyStringFormatted(vehiclePrice) .. "\nFee: £250,000\n\nBy entering 'YES' you agree to the terms of sale and forfeit the listing fee if the listing is cancelled by yourself.", function(source, confirmation)
            if confirmation == 'YES' then
                TriggerClientEvent("RNG:ConfirmVehicleListing", source, selectedVehicle, vehiclePrice)
                TriggerClientEvent("RNG:ShowVehicleForSale", source, selectedVehicle, vehiclePrice)
            elseif confirmation == 'NO' then
                -- Handle rejection
            else
                RNGclient.notify(source, {"~r~Invalid input. Please type 'YES' or 'NO'."})
            end
        end)
    end)
end)

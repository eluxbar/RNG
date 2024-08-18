local cfg = module("rng-vehicles","cfg/cfg_garages")
local impoundcfg = module("cfg/cfg_impound")

MySQL.createCommand("RNG/get_impounded_vehicles", "SELECT * FROM rng_user_vehicles WHERE user_id = @user_id AND impounded = 1")
MySQL.createCommand("RNG/get_vehicles", "SELECT vehicle, rentedtime, vehicle_plate, fuel_level FROM rng_user_vehicles WHERE user_id = @user_id AND rented = 0")
MySQL.createCommand("RNG/unimpound_vehicle", "UPDATE rng_user_vehicles SET impounded = 0, impound_info = null, impound_time = null WHERE vehicle = @vehicle AND user_id = @user_id")
MySQL.createCommand("RNG/impound_vehicle", "UPDATE rng_user_vehicles SET impounded = 1, impound_info = @impound_info, impound_time = @impound_time WHERE vehicle = @vehicle AND user_id = @user_id")



RegisterNetEvent('RNG:getImpoundedVehicles')
AddEventHandler('RNG:getImpoundedVehicles', function()
    local source = source
    local user_id = RNG.getUserId(source)
    local returned_table = {}
    if user_id then
        MySQL.query("RNG/get_impounded_vehicles", {user_id = user_id}, function(impoundedvehicles)
            for k, v in pairs(impoundedvehicles) do
                if impoundedvehicles[k]['impound_info'] ~= '' then
                    data = json.decode(impoundedvehicles[k]['impound_info'])
                    returned_table[v.vehicle] = {vehicle = v.vehicle, vehicle_name = data.vehicle_name, impounded_by_name = data.impounded_by_name, impounder = data.impounder, reasons = data.reasons}
                end
            end
            TriggerClientEvent('RNG:receiveImpoundedVehicles', source, returned_table)
        end)
    end
end)



RegisterNetEvent('RNG:fetchInfoForVehicleToImpound')
AddEventHandler('RNG:fetchInfoForVehicleToImpound', function(userid, spawncode, entityid)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, 'police.armoury') then
        for k, v in pairs(cfg.garages) do
            for a, b in pairs(v) do
                if a == spawncode then
                    vehicle = spawncode
                    vehicle_name = b[1]
                    owner_id = userid
                    vehiclenetid = entityid
                    if RNG.getUserSource(userid) ~= nil then
                        owner_name = RNG.getPlayerName(RNG.getUserSource(userid))
                        TriggerClientEvent('RNG:receiveInfoForVehicleToImpound', source, owner_id, owner_name, vehicle, vehicle_name, vehiclenetid)
                        return
                    else
                        RNGclient.notify(source, {'~r~Unable to locate owner.'})
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('RNG:releaseImpoundedVehicle')
AddEventHandler('RNG:releaseImpoundedVehicle', function(spawncode)
    local source = source
    local user_id = RNG.getUserId(source)

    MySQL.query("RNG/get_impounded_vehicles", { user_id = user_id }, function(impoundedvehicles)
        local playerCoords = GetEntityCoords(GetPlayerPed(source))
        local distanceToPaleto = #(playerCoords - vector3(-443.73971557617, 5993.7709960938, 31.340530395508))
        local distanceToCity = #(playerCoords - vector3(370.70745849609, -1609.1722412109, 29.291934967041))
        local impoundLocation
        if distanceToPaleto <= 150.0 and distanceToCity <= 150.0 then
            if distanceToPaleto < distanceToCity then
                impoundLocation = "Paleto"
            else
                impoundLocation = "City"
            end
        elseif distanceToPaleto <= 150.0 then
            impoundLocation = "Paleto"
        elseif distanceToCity <= 150.0 then
            impoundLocation = "City"
        else
            impoundLocation = nil
        end
        if impoundLocation then
            local spawnLocation = impoundcfg.positions[impoundLocation][math.random(#impoundcfg.positions[impoundLocation])]
            
            if spawnLocation then
                MySQL.query("RNG/get_vehicles", { user_id = user_id }, function(result)
                    if result ~= nil then
                        for k, v in pairs(result) do
                            if v.vehicle == spawncode then
                                if RNG.tryFullPayment(user_id, impoundcfg.impoundPrice) then
                                    MySQL.execute("RNG/unimpound_vehicle", {vehicle = spawncode, user_id = user_id})
                                    TriggerClientEvent('RNG:spawnPersonalVehicle', source, v.vehicle, user_id, false, vector3(spawnLocation.x, spawnLocation.y, spawnLocation.z), v.vehicle_plate, v.fuel_level)
                                    TriggerEvent('RNG:addToCommunityPot', 10000)
                                    RNGclient.notifyPicture(source, {"polnotification", "notification", "Your vehicle has been released from the impound at the cost of ~g~£10,000~w~."})
                                else
                                    RNGclient.notify(source, {'~r~You do not have enough money to retrieve your vehicle from the impound.'})
                                end
                                return
                            end
                        end
                    end
                end)
            else
                RNGclient.notify(source, {'~r~No valid spawn location found for this impound.'})
            end
        else
            RNGclient.notify(source, {'~r~Invalid impound location.'})
        end
    end)
end)





RegisterNetEvent('RNG:impoundVehicle')
AddEventHandler('RNG:impoundVehicle', function(userid, name, spawncode, vehiclename, reasons, entityid)
    local source = source
    local user_id = RNG.getUserId(source)
    local entitynetid = NetworkGetEntityFromNetworkId(entityid)
    if RNG.hasPermission(user_id, 'police.armoury') then
        local m = {}
        for k, v in pairs(impoundcfg.reasonsForImpound) do
            for a, b in pairs(reasons) do
                if k == a then
                    table.insert(m, v.option)
                end
            end
        end
        MySQL.execute("RNG/impound_vehicle", {impound_info = json.encode({vehicle_name = vehiclename, impounded_by_name = RNG.getPlayerName(source), impounder = user_id, reasons = m}), impound_time = os.time(), vehicle = spawncode, user_id = userid})
        local A, B = GetVehicleColours(entitynetid)
        TriggerClientEvent('RNG:impoundSuccess', source, entityid, vehiclename, RNG.getPlayerName(RNG.getUserSource(userid)), spawncode, A, B, GetEntityCoords(entitynetid), GetEntityHeading(entitynetid))
        RNGclient.notifyPicture(RNG.getUserSource(userid), {"polnotification","notification","Your "..vehiclename.." has been impounded by ~b~"..RNG.getPlayerName(source).." \n\n~w~For more information please visit the impound.","Metropolitan Police","Impound",nil,nil})
        RNG.sendWebhook('impound', 'RNG Seize Boot Logs', "> Officer Name: **"..RNG.getPlayerName(source).."**\n> Officer TempID: **"..source.."**\n> Officer PermID: **"..user_id.."**\n> Vehicle: **"..spawncode.."**\n> Vehicle Name: **"..vehiclename.."**\n> Owner ID: **"..userid.."**")
    end
end)


RegisterServerEvent("RNG:deleteImpoundEntities")
AddEventHandler("RNG:deleteImpoundEntities", function(a, b, c)
    TriggerClientEvent("RNG:deletePropClient", -1, a)
    TriggerClientEvent("RNG:deletePropClient", -1, b)
    TriggerClientEvent("RNG:deletePropClient", -1, c)
end)

RegisterServerEvent("RNG:awaitTowTruckArrival")
AddEventHandler("RNG:awaitTowTruckArrival", function(vehicle, flatbed, ped)
    local count = 0
    while count < 30 do
        Citizen.Wait(1000)
        count = count + 1
    end
    if count == 30 then
        TriggerClientEvent("RNG:deletePropClient", -1, vehicle)
        TriggerClientEvent("RNG:deletePropClient", -1, flatbed)
        TriggerClientEvent("RNG:deletePropClient", -1, ped)
    end
end)

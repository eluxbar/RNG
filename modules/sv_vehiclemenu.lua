-- local price = 2500000

-- local function checkBoot(vehicle, userId, callback)
--     exports['rng']:executeSync('SELECT * FROM rng_user_boot WHERE vehicle = @vehicle AND user_id = @user_id', 
--         { vehicle = vehicle, user_id = userId }, callback)
-- end

-- local function handleBootCheckResult(source, result)
--     if result and result[1] then
--         if result[1].owned then
--             print("Sending boot data to client")
--             TriggerClientEvent("RNG:VehicleBoot:Return", source, true, {})
--         end
--     else
--         TriggerClientEvent("RNG:VehicleBoot:Return", source, false, {})
--     end
-- end

-- RegisterServerEvent('RNG:VehicleBoot:Check')
-- AddEventHandler("RNG:VehicleBoot:Check", function(vehicle)
--     local userId = RNG.getUserId(source)
--     exports['rng']:executeSync('SELECT * FROM rng_user_vehicles WHERE vehicle = @vehicle AND user_id = @user_id', 
--         { vehicle = vehicle, user_id = userId }, function(vehicleCheckResult)
        
--         if vehicleCheckResult and vehicleCheckResult[1] then
--             checkBoot(vehicle, userId, function(bootCheckResult)
--                 handleBootCheckResult(source, bootCheckResult)
--             end)
--         end
--     end)
-- end)

-- RegisterServerEvent('RNG:VehicleBoot:Purchase')
-- AddEventHandler("RNG:VehicleBoot:Purchase", function(vehicle)
--     local userId = RNG.getUserId(source)
--     if RNG.tryFullPayment(userId, price) then
--         checkBoot(vehicle, userId, function(result)
--             if not result[1] then
--                 exports['rng']:execute('INSERT INTO rng_user_boot (user_id, vehicle, owned) VALUES (@user_id, @vehicle, @owned)', 
--                     { user_id = userId, vehicle = vehicle, owned = true })

--                 TriggerClientEvent("RNG:VehicleBoot:Return", source, true, {})
--                 RNGclient.notify(source, {"~g~You have purchased a vehicle boot!"})
--             end
--         end)
--     else
--         RNGclient.notify(source, {"~r~You don't have enough money!"})
--     end
-- end)

-- local function updateUserBoot(source, vehicle, userId, target_id, target_name, updateCallback)
--     exports['rng']:execute('SELECT * FROM rng_user_boot WHERE vehicle = @vehicle AND user_id = @user_id', 
--         { vehicle = vehicle, user_id = userId }, function(result)
--             if result and result[1] then
--                 local users = json.decode(result[1].users) or {}
--                 updateCallback(users, function(updatedUsers)e
--                     local updatedUsersJson = json.encode(updatedUsers)
--                     exports['rng']:execute('UPDATE rng_user_boot SET users = @users WHERE vehicle = @vehicle AND user_id = @user_id', 
--                         { users = updatedUsersJson, vehicle = vehicle, user_id = userId })
--                     TriggerClientEvent("RNG:VehicleBoot:Return", source, true, updatedUsers)
--                 end)
--             else
--                 print("No result found for vehicle: " .. vehicle .. " and user_id: " .. userId)
--             end
--         end)
-- end

-- RegisterServerEvent("RNG:VehicleBoot:Add")
-- AddEventHandler("RNG:VehicleBoot:Add", function(vehicle)
--     local userId = RNG.getUserId(source)
--     RNG.prompt(source, "Enter Perm ID", "", function(source, target_id)
--         if RNG.getUserSource(target_id) then
--             RNGclient.notify(source, {"~r~Player is online!"})
--             return
--         end
--         local target_name = RNG.getPlayerName(target_id)
--         if target_name then
--             updateUserBoot(source, vehicle, userId, target_id, target_name, function(users, commitChanges)
--                 if not users[target_id] then
--                     users[target_id] = { name = target_name, user_id = target_id }
--                     commitChanges(users)
--                     print("Added user_id: " .. target_id .. " to vehicle boot.")
--                 else
--                     print("User with ID " .. target_id .. " already exists in vehicle boot.")
--                 end
--             end)
--         else
--             RNGclient.notify(source, {"~r~Player not found!"})
--         end
--     end)
-- end)


-- RegisterServerEvent("RNG:VehicleBoot:Remove")
-- AddEventHandler("RNG:VehicleBoot:Remove", function(vehicle, target_id)
--     local userId = RNG.getUserId(source)
--     updateUserBoot(source, vehicle, userId, target_id, function(users, commitChanges)
--         if users[target_id] then
--             users[target_id] = nil
--             commitChanges(users)
--             print("Removed user_id: " .. target_id .. " from vehicle boot.")
--         else
--             print("User with ID " .. target_id .. " not found in vehicle boot.")
--         end
--     end)
-- end)



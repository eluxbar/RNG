RegisterServerEvent('RNG:setCarDevMode')
AddEventHandler('RNG:setCarDevMode', function(status)
    local source = source
    local user_id = RNG.getUserId(source)
    
    if user_id ~= nil and RNG.hasPermission(user_id, "cardev.menu") then 
        if status then
            RNG.setBucket(source, 333)
            SetEntityCoords(source, 2370.7983398438, 2856.580078125, 40.455898284912)
        else
            RNG.setBucket(source, 0)
        end
    else
        TriggerEvent("RNG:acBan", user_id, 11, RNG.getPlayerName(source), source, 'Attempted to Teleport to Car Dev Universe')
    end
end)

RegisterServerEvent('RNG:takeCarScreenshot')
AddEventHandler('RNG:takeCarScreenshot', function()
    local source = source
    local user_id = RNG.getUserId(source)
    local name = RNG.getPlayerName(source)
    if user_id ~= nil and RNG.hasPermission(user_id, "cardev.menu") then 
        TriggerClientEvent("RNG:takeClientScreenshotAndUpload", user_id, RNG.getWebhook('vehicless'))
    end
end)

RegisterNetEvent("RNG:logVehicleSpawn")
AddEventHandler("RNG:logVehicleSpawn", function(spawncode)
    local source = source
    RNG.sendWebhook('spawn-vehicle', "RNG Spawn Vehicle Logs", "> Player Name: **"..RNG.getPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..RNG.getUserId(source).."**\n> Vehicle: **"..spawncode.."**")
end)

RegisterNetEvent("RNG:RequestCarTickets")
AddEventHandler("RNG:RequestCarTickets", function()
    local source = source
    exports["rng"]:execute("SELECT reportid, spawncode, issue, reporter, claimed, completed, notes FROM cardev", {}, function(result)
        if result and #result > 0 then
            local tickets = {}
            for _, data in ipairs(result) do
                table.insert(tickets, {
                    reportid = data.reportid,
                    spawncode = data.spawncode,
                    issue = data.issue,
                    reporter = data.reporter,
                    claimed = data.claimed,
                    completed = data.completed,
                    notes = data.notes
                })
            end
            TriggerClientEvent("RNG:setCarTickets", source, tickets)
        else
            TriggerClientEvent("RNG:setCarTickets", source, {})
        end
    end)
end)

RegisterNetEvent("RNG:completeticket")
AddEventHandler("RNG:completeticket", function()
    exports["rng"]:execute("SELECT reportid, reporter FROM cardev WHERE completed = 0 LIMIT 1", {}, function(result)
        if result and #result > 0 then -- Check if there are any incomplete tickets
            local reportId = result[1].reportid
            local reporterId = result[1].reporter

            exports["rng"]:execute("DELETE FROM cardev WHERE reportid = @reportid", {['@reportid'] = reportId}, function(rowsDeleted)
                print("Rows Deleted: ", json.encode(rowsDeleted)) -- Debugging line
                if rowsDeleted and rowsDeleted > 0 then
                    exports["rng"]:execute("SELECT reportscompleted FROM cardevs WHERE userid = @userid", {['@userid'] = reporterId}, function(existingResult)
                        if existingResult and #existingResult > 0 then
                            local reportsCompleted = existingResult[1].reportscompleted + 1
                            exports["rng"]:execute("UPDATE cardevs SET reportscompleted = @reportscompleted WHERE userid = @userid", {['@reportscompleted'] = reportsCompleted, ['@userid'] = reporterId}, function(rowsAffected)
                                print("Rows Affected (Update): ", rowsAffected) -- Debugging line
                                if rowsAffected and rowsAffected > 0 then
                                    print("Ticket completed successfully")
                                else
                                    print("Error updating reportscompleted for user: " .. reporterId)
                                end
                            end)
                        else
                            exports["rng"]:execute("INSERT INTO cardevs (userid, reportscompleted) VALUES (@userid, 1)", {['@userid'] = reporterId}, function(rowsInserted)
                                print("Rows Inserted: ", rowsInserted) -- Debugging line
                                if rowsInserted and rowsInserted > 0 then
                                    print("Ticket completed successfully")
                                else
                                    print("Error inserting reportscompleted for user: " .. reporterId)
                                end
                            end)
                        end
                    end)
                else
                    print("Error deleting ticket from database or no rows deleted")
                end
            end)
        else
            print("No incomplete tickets found")
        end
    end)
end)

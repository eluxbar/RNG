local a = GetGameTimer()
RegisterNetEvent(
    "RNG:spawnNitroBMX",
    function()
        if not tRNG.isInComa() and not tRNG.isHandcuffed() and not insideDiamondCasino then
            if GetTimeDifference(GetGameTimer(), a) > 10000 then
                a = GetGameTimer()
                tRNG.notify("~g~Crafting a BMX")
                local b = tRNG.getPlayerPed()
                TaskStartScenarioInPlace(b, "WORLD_HUMAN_HAMMERING", 0, true)
                Wait(5000)
                ClearPedTasksImmediately(b)
                local c = GetEntityCoords(b)
                tRNG.spawnVehicle("bmx", c.x, c.y, c.z, GetEntityHeading(b), true, true, true)
            else
                tRNG.notify("~r~Nitro BMX cooldown, please wait.")
            end
        else
            tRNG.notify("~r~Cannot craft a BMX right now.")
        end
    end
)
RegisterNetEvent(
    "RNG:spawnMoped",
    function()
        if not tRNG.isInComa() and not tRNG.isHandcuffed() and not insideDiamondCasino then
            if GetTimeDifference(GetGameTimer(), a) > 10000 then
                a = GetGameTimer()
                tRNG.notify("~g~Crafting a Moped")
                local b = tRNG.getPlayerPed()
                TaskStartScenarioInPlace(b, "WORLD_HUMAN_HAMMERING", 0, true)
                Wait(5000)
                ClearPedTasksImmediately(b)
                local c = GetEntityCoords(b)
                tRNG.spawnVehicle("faggio", c.x, c.y, c.z, GetEntityHeading(b), true, true, true)
            else
                tRNG.notify("~r~Nitro BMX cooldown, please wait.")
            end
        else
            tRNG.notify("~r~Cannot craft a Moped right now.")
        end
    end
)

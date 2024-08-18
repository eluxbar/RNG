local activeCrates = {}
local spawnTime = 20*60 -- Time between each airdrop
local cfg = module("cfg/cfg_cratedrop")

local availableItems = {
    "WEAPON_PYTHON",
    "WEAPON_UMP45",
    "WEAPON_UZI",
    "WEAPON_MOSIN",
    "WEAPON_AK200",
    "WEAPON_GOLDAK",
    "WEAPON_AKM",
    "WEAPON_SPAR16",
    "WEAPON_REVOLVER357",
    "WEAPON_WINCHESTER12",
    "WEAPON_MXM",
    "WEAPON_STAC",
    "WEAPON_MK14"
}

local cratelocations = {
    {name = "Rebel", pos = vector3(2558.714, 6155.399, 161.8665)},
    {name = "Paleto", pos = vector3(375.0662, 6852.992, 4.083869)},
    {name = "Large Arms", pos = vector3(-880.6389, 4414.064, 20.36799)},
    {name = "Military Base", pos = vector3(-3032.489, 3402.802, 8.417397)},
    {name = "Diamond Mine River", pos = vector3(-119.2925, 3022.1, 32.18053)},
    {name = "Large Arms Bridge", pos = vector3(36.50002, 4344.443, 41.47789)},
    {name = "Mount Chilliad", pos = vector3(499.4316, 5536.806, 777.696)},
    {name = "Wine Mansion", pos = vector3(-1518.191, 2140.92, 55.53791)},
    {name = "Vinewood 1", pos = vector3(-191.0104, 1477.419, 288.4325)},
    {name = "Vinewood Sign", pos = vector3(828.4253, 1300.878, 363.6823)},
    {name = "Wind Turbines", pos = vector3(2348.622, 2138.061, 104.3607)},
    {name = "Vinewood Lake", pos = vector3(1877.604, 352.0831, 162.9319)},
    {name = "Island Near LSD", pos = vector3(2836.016, -1447.626, 10.45845)},
    {name = "Youtool Hill", pos = vector3(2543.626, 3615.884, 96.89672)},
    {name = "Herion Bunker", pos = vector3(2856.744, 4631.319, 48.39237)},
    {name = "Cayo Perico", pos = vector3(4784.917, -5530.945, 19.46264)},
    {name = "Biker city", pos = vector3(254.3428, 3583.882, 33.73079)}
}

local riglocation = {
    {name = "Oil Rig", pos = vector3(-1716.5004882812, 8886.94921875, 27.144144058228)},
    {name = "Gang Island", pos = vector3(1175.169312, 7045.288086, 14.809789)}
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        for k,v in pairs(activeCrates) do
            if activeCrates[k].timeTillOpen > 0 then
                activeCrates[k].timeTillOpen = activeCrates[k].timeTillOpen - 1
            end
        end
    end
end)


AddEventHandler("RNG:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
       if #activeCrates > 0 then
            for k,v in pairs(activeCrates) do
                TriggerClientEvent('RNG:addCrateDropRedzone', source, v, cratelocations[v])
            end
       end
    end
end)

RegisterServerEvent('RNG:openCrate', function(crateID)
    local source = source
    local user_id = RNG.getUserId(source)

    if activeCrates[crateID] == nil then return end
    if activeCrates[crateID].timeTillOpen > 0 then
        RNGclient.notify(source, {'~r~Loot crate unlocking in '..activeCrates[crateID].timeTillOpen..' seconds.'})
    else
        local playerCoords = GetEntityCoords(GetPlayerPed(source))
        local crateCoords = cratelocations[crateID]
        local rigCoords = rigLocations[crateID]
        
        if Vdist2(playerCoords, crateCoords) < 2.0 or (rigCoords and Vdist2(playerCoords, rigCoords) < 2.0) then
            TriggerClientEvent("RNG:removeLootcrate", -1, crateID)
            FreezeEntityPosition(GetPlayerPed(source), true)
            RNGclient.startCircularProgressBar(source, {"", 15000, nil})
            local anims = {
                {'amb@medic@standing@kneel@base', 'base', 1},
                {'anim@gangops@facility@servers@bodysearch@', 'player_search', 1},
            }
            RNGclient.playAnim(source, {true, anims, false})
            Wait(15000)
            local lootAmount = activeCrates[crateID].oilrig and 9 or 5
            for i = 1, lootAmount do
                local randomItem = math.random(1, #availableItems)
                local item = availableItems[randomItem]
                RNG.giveInventoryItem(user_id, item[1], item[2], true)
            end
            activeCrates[crateID] = nil
            RNG.giveMoney(user_id, math.random(100000, 250000))
            TriggerClientEvent('chatMessage', -1, "^0EVENT | ", {66, 72, 245}, "The Crate drop has been looted!", "alert")
            FreezeEntityPosition(GetPlayerPed(source), false)
        end
    end
end)


Citizen.CreateThread(function()
    while true do
        Wait(30*60*1000)
        local crateID = math.random(1, #cratelocations)
        local crateCoords = cratelocations[crateID]
        TriggerClientEvent('RNG:crateDrop', -1, crateCoords, crateID, false)
        activeCrates[crateID] = {oilrig = false, timeTillOpen = 300}
        TriggerClientEvent('chatMessage', -1, "^0EVENT | ", {66, 72, 245}, "A cartel plane carrying supplies has had to bail and is parachuting to the ground! Get to it quick, check your GPS!", "alert")
        Wait(20*60*1000)
        if activeCrates[crateID] ~= nil then
            TriggerClientEvent('chatMessage', -1, "^0EVENT | ", {66, 72, 245}, "The airdrop has disappeared.", "alert")
            activeCrates[crateID] = nil
            TriggerClientEvent("RNG:removeLootcrate", -1, crateID)
        end
        Wait(1000)
    end
end)

-- RegisterCommand('startgangdrop', function(source)
--     local source = source
--     local user_id = RNG.getUserId(source)
--     if user_id == 1 or user_id == 0 or user_id == 2 then
--         local crateID = math.random(1, #riglocation)
--         local crateCoords = riglocation[crateID]
--         TriggerClientEvent('RNG:crateDrop', -1, crateCoords, crateID, true)
--         activeCrates[crateID] = {oilrig = true, timeTillOpen = 300}
--         TriggerClientEvent('chatMessage', -1, "^0EVENT | ", {66, 72, 245}, "A Secret Island off the coast of rebel is hiding a hidden cache of high tier weaponry. Get to it quick, check your GPS!", "alert")
--         RNG.sendWebhook("serveractions", "Server Actions Log", "> Crate ID: **" .. crateID .. "**\n" .."> Crate Coordinates: **" .. json.encode(crateCoords) .. "**\n" .."> Event Message: A Secret Island off the coast of rebel is hiding a hidden cache of high tier weaponry. Get to it quick, check your GPS!")
--         Wait(20*60*1000)
--         if activeCrates[crateID] ~= nil then
--             TriggerClientEvent('chatMessage', -1, "^0EVENT | ", {66, 72, 245}, "The secret island drop has disappeared.", "alert")
--             activeCrates[crateID] = nil
--             TriggerClientEvent("RNG:removeLootcrate", -1, crateID)
--         end
--         Wait(1000)
--     else
--         RNGclient.notify(source, {'You do not have permission to do this.'})
--     end
-- end)

local crateCooldown = 30 * 60 * 1000

RegisterServerEvent('RNG:startCrateDrop')
AddEventHandler('RNG:startCrateDrop', function()
    local currentTime = os.time() * 1000
    local crateID = math.random(1, #cratelocations)
    local crateCoords = cratelocations[crateID]

    for id, crate in pairs(activeCrates) do
        if crate.timeTillOpen > currentTime then
            RNGclient.notify(source, {'~r~There Is An Active Crate Please Wait.'})
            return
        end
    end
    TriggerClientEvent('RNG:crateDrop', -1, crateCoords, crateID, false)
    activeCrates[crateID] = {oilrig = false, timeTillOpen = 300}
    TriggerClientEvent('chatMessage', -1, "^0EVENT | ", {66, 72, 245}, "A cartel plane carrying supplies has had to bail and is parachuting to the ground! Get to it quick, check your GPS!", "alert")
    RNG.sendWebhook("serveractions", "Server Actions Log Crate Drop", "> Crate ID: **" .. crateID .. "**\n" .."> Crate Coordinates: **" .. json.encode(crateCoords) .. "**\n" .."> Event Message: A cartel plane carrying supplies has had to bail and is parachuting to the ground! Get to it quick, check your GPS!")
    Citizen.CreateThread(function()
        Wait(crateCooldown)
        if activeCrates[crateID] then
            TriggerClientEvent('chatMessage', -1, "^0EVENT | ", {66, 72, 245}, "The airdrop has disappeared.", "alert")
            activeCrates[crateID] = nil
            TriggerClientEvent("RNG:removeLootcrate", -1, crateID)
        end
    end)
end)


-- RegisterCommand('startdrop', function(source)
--     local source = source
--     local user_id = RNG.getUserId(source)
--     if user_id == 1 or user_id == 0 or user_id == 2 then
--         local crateID = math.random(1, #cratelocations)
--         local crateCoords = cratelocations[crateID]
--         TriggerClientEvent('RNG:crateDrop', -1, crateCoords, crateID, false)
--         activeCrates[crateID] = {oilrig = false, timeTillOpen = 300}
--         TriggerClientEvent('chatMessage', -1, "^0EVENT | ", {66, 72, 245}, "A cartel plane carrying supplies has had to bail and is parachuting to the ground! Get to it quick, check your GPS!", "alert")
--         RNG.sendWebhook("serveractions", "Server Actions Log", "> Crate ID: **" .. crateID .. "**\n" .."> Crate Coordinates: **" .. json.encode(crateCoords) .. "**\n" .."> Event Message: A cartel plane carrying supplies has had to bail and is parachuting to the ground! Get to it quick, check your GPS!")
--         Wait(20*60*1000)
--         if activeCrates[crateID] ~= nil then
--             TriggerClientEvent('chatMessage', -1, "^0EVENT | ", {66, 72, 245}, "The airdrop has disappeared.", "alert")
--             activeCrates[crateID] = nil
--             TriggerClientEvent("RNG:removeLootcrate", -1, crateID)
--         end
--         Wait(1000)
--     else
--         RNGclient.notify(source, {'You do not have permission to do this.'})
--     end
-- end)

Citizen.CreateThread(function()
    while true do
        Wait(3*60*60*1000)
        local crateID = math.random(1, #riglocation)
        local crateCoords = riglocation[crateID]
        TriggerClientEvent('RNG:crateDrop', -1, crateCoords, crateID, true)
        activeCrates[crateID] = {oilrig = true, timeTillOpen = 300}
        TriggerClientEvent('chatMessage', -1, "^0EVENT | ", {66, 72, 245}, "An Oil Rig off the coast of paleto is hiding a hidden cache of high tier weaponry and sapphires. Get to it quick, check your GPS!", "alert")
        Wait(20*60*1000)
        if activeCrates[crateID] ~= nil then
            TriggerClientEvent('chatMessage', -1, "^0EVENT | ", {66, 72, 245}, "The Oil Rig has disappeared.", "alert")
            activeCrates[crateID] = nil
            TriggerClientEvent("RNG:removeLootcrate", -1, crateID)
        end
        Wait(1000)
    end
end)
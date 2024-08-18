local jewelrycfg = module("cfg/cfg_jewelleryheist")
local facilityEmpty = true
local userInFacility = nil
local jewelryHeistReady = false
local isCooldownActive = false
local cooldownStartTime = 0
local cooldownDuration = 3600

AddEventHandler('RNG:playerSpawn', function(user_id, source, first_spawn)
    if first_spawn then
        TriggerClientEvent("RNG:jewelrySyncDoor", source, jewelryHeistReady)
        TriggerClientEvent('RNG:jewelrySyncSetupReady', source, facilityEmpty)
        if jewelryHeistReady then
            TriggerClientEvent("RNG:jewelryHeistReady", source, true)
        end
    end
end)

RegisterNetEvent('RNG:jewelrySetupHeistStart')
AddEventHandler('RNG:jewelrySetupHeistStart', function()
    local source = source
    local user_id = RNG.getUserId(source)
    if userInFacility == nil then
        userInFacility = user_id
        facilityEmpty = false

        TriggerClientEvent('RNG:jewelrySyncSetupReady', source, facilityEmpty)
        for k, v in pairs(jewelrycfg.aiSpawnLocs) do
            local pos = v.coords
            local ped = CreatePed(4, "s_m_y_blackops_03", pos.x, pos.y, pos.z, v.heading, false, true)
            GiveWeaponToPed(ped, v.weaponHash, 999, false, true)
            TriggerClientEvent('RNG:jewelryMakePedsAttack', source, NetworkGetNetworkIdFromEntity(ped))
        end
        Citizen.Wait(2000)
        for _, pickupLocation in pairs(jewelrycfg.hackingDevicePickupLocs) do
            TriggerClientEvent('RNG:jewelryCreateDevicePickup', -1, pickupLocation)
        end
    end
end)

RegisterNetEvent('RNG:jewelryCollectDevice')
AddEventHandler('RNG:jewelryCollectDevice', function()
    local source = source
    local user_id = RNG.getUserId(source)

    TriggerClientEvent('RNG:jewelrySyncSetupReady', -1, facilityEmpty)
    TriggerClientEvent('RNG:jewelryRemoveDeviceArea', -1)
    RNG.giveInventoryItem(user_id, "hackingDevice", 1, true)
end)

RegisterNetEvent('RNG:jewelrySetupHeistleave')
AddEventHandler('RNG:jewelrySetupHeistLeave', function()
    local source = source
    local user_id = RNG.getUserId(source)
    if userInFacility == user_id then
        userInFacility = nil
        facilityEmpty = true
        TriggerClientEvent('RNG:jewelrySyncSetupReady', -1, facilityEmpty)
        TriggerClientEvent('RNG:jewelryRemoveDeviceArea', -1)
    end
end)


-- RegisterNetEvent("RNG:jewelryHackDoor")
-- AddEventHandler('RNG:jewelryHackDoor', function()
--     local source = source
--     local user_id = RNG.getUserId(source)
--     if RNG.getInventoryItemAmount(user_id, 'hackingDevice') > 0 then
--         TriggerClientEvent('RNG:jewelryStartDoorHackSf', source)
--         TriggerClientEvent("RNG:jewelrySoundAlarm", -1, true)
--     else
--         RNGclient.notify(source, {'You do not have a Hacking Device.'})
--     end
-- end)

RegisterNetEvent('RNG:jewelryHackDoor')
AddEventHandler('RNG:jewelryHackDoor', function()
    local source = source
    local user_id = RNG.getUserId(source)
    
    if not user_id then
        RNGclient.notify(source, {'~r~Unable To Find User ID'})
        return
    end

    if isCooldownActive and os.time() - cooldownStartTime < cooldownDuration then
        local remainingCooldown = cooldownStartTime + cooldownDuration - os.time()
        TriggerClientEvent('chatMessage', source, "^7OOC ^1Jewelry Store Robbery ^7 - Jewelry Store was robbed too recently, "..remainingCooldown.." seconds remaining.", { 128, 128, 128 }, message, "alert")
        return
    end

    if RNG.hasPermission(user_id, "police.armoury") then
        RNGclient.notify(source, {'~r~You cannot rob a jewelry store as police.'})
    else
        local policeCount = #RNG.getUsersByPermission('police.armoury')
        if policeCount > 0 then
            if RNG.getInventoryItemAmount(user_id, 'hackingDevice') > 0 then
                TriggerClientEvent('RNG:jewelryStartDoorHackSf', source)
                TriggerClientEvent("RNG:jewelrySoundAlarm", -1, true)  
                for a, b in pairs(RNG.getUsers({})) do
                    if RNG.hasPermission(a, "police.armoury") then
                        TriggerClientEvent("RNG:jewelryAlarmTriggered", a)
                    end
                end
            else
                RNGclient.notify(source, {'You do not have a Hacking Device.'})
            end
            TriggerEvent('RNG:PDRobberyCall', source, "Jewelry Store", vector3(-623.42156982422, -231.59411621094, 38.057064056396))
        else
            RNGclient.notify(source, {'~r~There are not enough police on duty to rob a jewelry store.'})
        end
    end
end)




RegisterNetEvent('RNG:jewelryDoorHackSuccess')
AddEventHandler('RNG:jewelryDoorHackSuccess', function()
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.getInventoryItemAmount(user_id, 'hackingDevice') > 0 then
        TriggerClientEvent("RNG:jewelrySyncDoor", -1, false)
        TriggerClientEvent("RNG:jewelryComputerHackArea", -1, true)
        RNGclient.notify(source, {'~g~Now Go Hack The Computer!'})
    else
        RNGclient.notify(source, {'You do not have Hacking Device.'})
    end
end)


RegisterNetEvent("RNG:jewelryHackComputer")
AddEventHandler('RNG:jewelryHackComputer', function()
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.getInventoryItemAmount(user_id, 'hackingDevice') > 0 then
        TriggerClientEvent('RNG:jewelryStartComputerHackSf', source)
    else
        RNGclient.notify(source, {'You do not have Hacking Device.'})
    end
end)


RegisterNetEvent("RNG:heiststarten")
AddEventHandler('RNG:heiststarten', function()
    TriggerClientEvent('RNG:jewelryCreateTimer', -1)
    for caseID, caseData in pairs(jewelrycfg.jewelryCases) do
        local U = true
        TriggerClientEvent("RNG:jewelrySyncLootAreas", -1, caseID, U)
    end
    SetTimeout(600000, function()
        for caseID, _ in pairs(jewelrycfg.jewelryCases) do
            local U = false
            TriggerClientEvent("RNG:jewelrySyncLootAreas", -1, caseID, U)
        end
    end)
end)
RegisterNetEvent("RNG:jewelryComputerHackSuccess")
AddEventHandler('RNG:jewelryComputerHackSuccess', function()
    local sourceCoords = GetEntityCoords(GetPlayerPed(-1))
    local storeMiddle = vector3(-623.42156982422, -231.59411621094, 38.057064056396)
    local radius = 9.086
    for i = 1, 31 do
        local targetCoords = GetEntityCoords(GetPlayerPed(i))
        local distance = #(storeMiddle - targetCoords)
        if distance <= radius then
            TriggerClientEvent('RNG:jewelryCreateTimer', i)
        end
    end

    for caseID, _ in pairs(jewelrycfg.jewelryCases) do
        local U = true
        TriggerClientEvent("RNG:jewelrySyncLootAreas", -1, caseID, U)
    end

    SetTimeout(100000, function()
        for caseID, _ in pairs(jewelrycfg.jewelryCases) do
            local U = false
            TriggerClientEvent("RNG:jewelrySyncLootAreas", -1, caseID, U)
        end
        jewelryHeistReady = false
        TriggerClientEvent("RNG:jewelryHeistReady", -1, false)
        TriggerClientEvent("RNG:jewelrySyncDoor", -1, true)
    end)

    local user_id = RNG.getUserId(source)
    cooldownStartTime = os.time()
    isCooldownActive = true
    RNG.tryGetInventoryItem(user_id, 'hackingDevice', 1, false)
    SetTimeout(300000, function()
        TriggerClientEvent("RNG:jewelryHeistReady", -1, true)
    end)
end)

function getRandomJewelryItem()
    local randNum = math.random(1, 100)
    if randNum <= 10 then
        return { spawnName = "sapphire", itemCount = 1 }
    elseif randNum <= 30 then
        local itemCount = math.random(1, 2)
        return { spawnName = "jewelry_necklace", itemCount = itemCount }
    elseif randNum <= 70 then
        local itemCount = math.random(1, 5)
        return { spawnName = "jewelry_watch", itemCount = itemCount }
    else
        local itemCount = math.random(2, 10)
        return { spawnName = "jewelry_ring", itemCount = itemCount }
    end
end


RegisterNetEvent("RNG:jewelryGrabLoot")
AddEventHandler('RNG:jewelryGrabLoot', function(caseId)
    local jewelryItem = getRandomJewelryItem()

    if not jewelryItem then
        return
    end

    local user_id = RNG.getUserId(source)
    local spawnName = jewelryItem.spawnName
    local ItemWeight = RNG.getItemWeight(spawnName)

    if not caseId or not jewelrycfg.jewelryCases[caseId] then
        return
    end

    local itemCount = jewelryItem.itemCount or 1

    if RNG.hasPermission(userid, "police") then
        RNGclient.notify(playerSource, { "~r~Not enough space in inventory." })
    else
        local U = false
        TriggerClientEvent("RNG:jewelrySyncLootAreas", -1, caseId, U)
        RNG.giveInventoryItem(user_id, spawnName, itemCount, true)
        RNG.notify(playerSource, { "You have recived " .. itemCount .. " " .. spawnName .. "!" })
    end
end)



RegisterNetEvent("RNG:jewelryPoliceSeizeLoot")
AddEventHandler('RNG:jewelryPoliceSeizeLoot', function(caseId)
    local U = false
    TriggerClientEvent("RNG:jewelrySyncLootAreas", -1, caseId, U)
    RNGclient.notify(source, {"~g~Recovered Jewelry"})
end)

local function checkBucket(source)
    if GetPlayerRoutingBucket(source) ~= 0 then
        RNGclient.notify(source, {'You cannot sell in this bucket.'})
        return false
    end
    return true
end


RegisterNetEvent('RNG:sellJewelry')
AddEventHandler('RNG:sellJewelry', function(spawnName, sellPrice, itemName)
    local source = source
    local user_id = RNG.getUserId(source)
    if checkBucket(source) then
        if RNG.getInventoryItemAmount(user_id, spawnName) > 0 then
            RNG.tryGetInventoryItem(user_id, spawnName, 1, false)
            RNG.giveBankMoney(user_id, sellPrice)
            TriggerClientEvent("RNG:phoneNotification", source, itemName..' Sold For £' .. getMoneyStringFormatted(sellPrice), "Jewellery")
        else
            RNGclient.notify(source, {'You don\'t have ' .. itemName})
        end
    end
end)
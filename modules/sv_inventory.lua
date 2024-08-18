MySQL = module("modules/MySQL")

local Inventory = module("rng-vehicles", "cfg/cfg_inventory")
local Housing = module("rng", "cfg/cfg_housing")
local InventorySpamTrack = {}
local LootBagEntities = {}
local InventoryCoolDown = {}
local a = module("rng-weapons", "cfg/weapons")
local AmmoItems = {
    ["9mm Bullets"] = true,
    ["12 Gauge Bullets"] = true,
    [".308 Sniper Rounds"] = true,
    ["7.62mm Bullets"] = true,
    ["5.56mm NATO"] = true,
    [".357 Bullets"] = true,
    ["Police Issued 5.56mm"] = true,
    ["Police Issued .308 Sniper Rounds"] = true,
    ["Police Issued 9mm"] = true,
    ["Police Issued 12 Gauge"] = true
}

AddEventHandler("RNG:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        if not InventorySpamTrack[source] then
            InventorySpamTrack[source] = true;
            local user_id = RNG.getUserId(source) 
            local data = RNG.getUserDataTable(user_id)
            if data and data.inventory then
                local FormattedInventoryData = {}
                for i,v in pairs(data.inventory) do
                    FormattedInventoryData[i] = {amount = v.amount, ItemName = RNG.getItemName(i), Weight = RNG.getItemWeight(i)}
                end
                TriggerClientEvent('RNG:FetchPersonalInventory', source, FormattedInventoryData, RNG.computeItemsWeight(data.inventory), RNG.getInventoryMaxWeight(user_id))
                InventorySpamTrack[source] = false;
            else 
                --print('An error has occured while trying to fetch inventory data from: ' .. user_id .. ' This may be a saving / loading data error you will need to investigate this.')
            end
        end
    end
end)

RegisterNetEvent('RNG:FetchPersonalInventory')
AddEventHandler('RNG:FetchPersonalInventory', function()
    local source = source
    if not InventorySpamTrack[source] then
        InventorySpamTrack[source] = true;
        local user_id = RNG.getUserId(source) 
        local data = RNG.getUserDataTable(user_id)
        if data and data.inventory then
            local FormattedInventoryData = {}
            for i,v in pairs(data.inventory) do
                FormattedInventoryData[i] = {amount = v.amount, ItemName = RNG.getItemName(i), Weight = RNG.getItemWeight(i)}
            end
            TriggerClientEvent('RNG:FetchPersonalInventory', source, FormattedInventoryData, RNG.computeItemsWeight(data.inventory), RNG.getInventoryMaxWeight(user_id))
            InventorySpamTrack[source] = false;
        else 
            --print('An error has occured while trying to fetch inventory data from: ' .. user_id .. ' This may be a saving / loading data error you will need to investigate this.')
        end
    end
end)


AddEventHandler('RNG:RefreshInventory', function(source)
    local user_id = RNG.getUserId(source) 
    local data = RNG.getUserDataTable(user_id)
    if data and data.inventory then
        local FormattedInventoryData = {}
        for i,v in pairs(data.inventory) do
            FormattedInventoryData[i] = {amount = v.amount, ItemName = RNG.getItemName(i), Weight = RNG.getItemWeight(i)}
        end
        TriggerClientEvent('RNG:FetchPersonalInventory', source, FormattedInventoryData, RNG.computeItemsWeight(data.inventory), RNG.getInventoryMaxWeight(user_id))
        InventorySpamTrack[source] = false;
    else 
        --print('An error has occured while trying to fetch inventory data from: ' .. user_id .. ' This may be a saving / loading data error you will need to investigate this.')
    end
end)

RegisterNetEvent('RNG:GiveItem')
AddEventHandler('RNG:GiveItem', function(itemId, itemLoc)
    local source = source
    if not itemId then  RNGclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if itemLoc == "Plr" then
        RNG.RunGiveTask(source, itemId)
        TriggerEvent('RNG:RefreshInventory', source)
    else
        RNGclient.notify(source, {'~r~You need to have this item on you to give it.'})
    end
end)
RegisterNetEvent('RNG:GiveItemAll')
AddEventHandler('RNG:GiveItemAll', function(itemId, itemLoc)
    local source = source
    if not itemId then  RNGclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if itemLoc == "Plr" then
        RNG.RunGiveAllTask(source, itemId)
        TriggerEvent('RNG:RefreshInventory', source)
    else
        RNGclient.notify(source, {'~r~You need to have this item on you to give it.'})
    end
end)

RegisterNetEvent('RNG:TrashItem')
AddEventHandler('RNG:TrashItem', function(itemId, itemLoc)
    local source = source
    if not itemId then  RNGclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if itemLoc == "Plr" then
        RNG.RunTrashTask(source, itemId)
        TriggerEvent('RNG:RefreshInventory', source)
    else
        RNGclient.notify(source, {'~r~You need to have this item on you to drop it.'})
    end
end)

RegisterNetEvent('RNG:FetchTrunkInventory')
AddEventHandler('RNG:FetchTrunkInventory', function(spawnCode)
    local source = source
    local user_id = RNG.getUserId(source)
    if InventoryCoolDown[source] then RNGclient.notify(source, {'~r~Please wait before moving more items.'}) return end
    local carformat = "chest:u1veh_" .. spawnCode .. '|' .. user_id
    RNG.getSData(carformat, function(cdata)
        local processedChest = {};
        cdata = json.decode(cdata) or {}
        local FormattedInventoryData = {}
        for i, v in pairs(cdata) do
            FormattedInventoryData[i] = {amount = v.amount, ItemName = RNG.getItemName(i), Weight = RNG.getItemWeight(i)}
        end
        local maxVehKg = Inventory.vehicle_chest_weights[spawnCode] or Inventory.default_vehicle_chest_weight
        TriggerClientEvent('RNG:SendSecondaryInventoryData', source, FormattedInventoryData, RNG.computeItemsWeight(cdata), maxVehKg)
        TriggerEvent('RNG:RefreshInventory', source)
    end)
end)


RegisterNetEvent('RNG:viewTrunk')
AddEventHandler('RNG:viewTrunk', function(spawnCode)
    local source = source
    local user_id = RNG.getUserId(source)
    local carformat = "chest:u1veh_" .. spawnCode .. '|' .. user_id
    RNG.getSData(carformat, function(cdata)
        cdata = json.decode(cdata) or {}

        local FormattedInventoryData = {}
        for i, v in pairs(cdata) do
            FormattedInventoryData[i] = {
                amount = v.amount,
                ItemName = RNG.getItemName(i),
                Weight = RNG.getItemWeight(i)
            }
        end

        local maxVehKg = Inventory.vehicle_chest_weights[spawnCode] or Inventory.default_vehicle_chest_weight
        local totalWeight = RNG.computeItemsWeight(cdata)

        TriggerClientEvent('RNG:SendSecondaryInventoryData', source, FormattedInventoryData, totalWeight, maxVehKg)
    end)
end)



RegisterNetEvent('RNG:WipeBoot')
AddEventHandler('RNG:WipeBoot', function(spawnCode)
    local source = source
    local user_id = RNG.getUserId(source)
    local carformat = "chest:u1veh_" .. spawnCode .. '|' .. user_id
    RNG.prompt(source, "Please replace text with YES or NO to confirm", "Wipe Boot For Vehicle: " .. spawnCode, function(source, wipeboot)
        if string.upper(wipeboot) == 'YES' then
            RNG.getSData(carformat, function(cdata)
                cdata = json.decode(cdata) or {}
                for i, v in pairs(cdata) do
                    cdata[i] = nil
                end
                RNG.setSData(carformat, json.encode(cdata))
                TriggerEvent('RNG:RefreshInventory', source)
                RNGclient.notify(source, {'~g~You have wiped the boot of this vehicle.'})
            end)
        else
            RNGclient.notify(source, {'~r~You did not confirm the wipe.'})
        end
    end)
end)








local inHouse = {}
RegisterNetEvent('RNG:FetchHouseInventory')
AddEventHandler('RNG:FetchHouseInventory', function(nameHouse)
    local source = source
    local user_id = RNG.getUserId(source)
    getUserByAddress(nameHouse, 1, function(huser_id)
        if huser_id == user_id then
            inHouse[user_id] = nameHouse
            local homeformat = "chest:u" .. user_id .. "home" ..inHouse[user_id]
            RNG.getSData(homeformat, function(cdata)
                local processedChest = {};
                cdata = json.decode(cdata) or {}
                local FormattedInventoryData = {}
                for i, v in pairs(cdata) do
                    FormattedInventoryData[i] = {amount = v.amount, ItemName = RNG.getItemName(i), Weight = RNG.getItemWeight(i)}
                end
                local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                TriggerClientEvent('RNG:SendSecondaryInventoryData', source, FormattedInventoryData, RNG.computeItemsWeight(cdata), maxVehKg)
            end)
        else
            RNGclient.notify(player,{"~r~You do not own this house!"})
        end
    end)
end)

local currentlySearching = {}

RegisterNetEvent('RNG:cancelPlayerSearch')
AddEventHandler('RNG:cancelPlayerSearch', function()
    local source = source
    local user_id = RNG.getUserId(source) 
    if currentlySearching[user_id] ~= nil then
        TriggerClientEvent('RNG:cancelPlayerSearch', currentlySearching[user_id])
    end
end)

RegisterNetEvent('RNG:searchPlayer')
AddEventHandler('RNG:searchPlayer', function(playersrc)
    local source = source
    local user_id = RNG.getUserId(source) 
    local data = RNG.getUserDataTable(user_id)
    local their_id = RNG.getUserId(playersrc) 
    local their_data = RNG.getUserDataTable(their_id)
    if data and data.inventory and not currentlySearching[user_id] then
        currentlySearching[user_id] = playersrc
        TriggerClientEvent('RNG:startSearchingSuspect', source)
        TriggerClientEvent('RNG:startBeingSearching', playersrc, source)
        RNGclient.notify(playersrc, {'~b~You are being searched.'})
        Wait(10000)
        if currentlySearching[user_id] then
            local FormattedInventoryData = {}
            for i,v in pairs(data.inventory) do
                FormattedInventoryData[i] = {amount = v.amount, ItemName = RNG.getItemName(i), Weight = RNG.getItemWeight(i)}
            end
            exports['rng']:execute("SELECT * FROM rng_subscriptions WHERE user_id = @user_id", {user_id = user_id}, function(vipClubData)
                if #vipClubData > 0 then
                    if their_data and their_data.inventory then
                        local FormattedSecondaryInventoryData = {}
                        for i,v in pairs(their_data.inventory) do
                            FormattedSecondaryInventoryData[i] = {amount = v.amount, ItemName = RNG.getItemName(i), Weight = RNG.getItemWeight(i)}
                        end
                        if RNG.getMoney(their_id) then
                            FormattedSecondaryInventoryData['cash'] = {amount = RNG.getMoney(their_id), ItemName = 'Cash', Weight = 0.00}
                        end
                        TriggerClientEvent('RNG:SendSecondaryInventoryData', source, FormattedSecondaryInventoryData, RNG.computeItemsWeight(their_data.inventory), 200)
                    end
                    if vipClubData[1].plathours > 0 then
                        TriggerClientEvent('RNG:FetchPersonalInventory', source, FormattedInventoryData, RNG.computeItemsWeight(data.inventory), RNG.getInventoryMaxWeight(user_id)+20)
                    elseif vipClubData[1].plushours > 0 then
                        TriggerClientEvent('RNG:FetchPersonalInventory', source, FormattedInventoryData, RNG.computeItemsWeight(data.inventory), RNG.getInventoryMaxWeight(user_id)+10)
                    else
                        TriggerClientEvent('RNG:FetchPersonalInventory', source, FormattedInventoryData, RNG.computeItemsWeight(data.inventory), RNG.getInventoryMaxWeight(user_id))
                    end
                    TriggerClientEvent('RNG:InventoryOpen', source, true)
                    currentlySearching[user_id] = nil
                end
            end)
        end
    end
end)

RegisterNetEvent('RNG:robPlayer')
AddEventHandler('RNG:robPlayer', function(playersrc)
    local source = source
    local user_id = RNG.getUserId(source)
    RNGclient.isPlayerSurrendered(playersrc, {}, function(is_surrendering) 
        if is_surrendering then
            if not InventorySpamTrack[source] then
                InventorySpamTrack[source] = true;
                local user_id = RNG.getUserId(source) 
                local data = RNG.getUserDataTable(user_id)
                local their_id = RNG.getUserId(playersrc) 
                local their_data = RNG.getUserDataTable(their_id)
                if data and data.inventory then
                    local FormattedInventoryData = {}
                    for i,v in pairs(data.inventory) do
                        FormattedInventoryData[i] = {amount = v.amount, ItemName = RNG.getItemName(i), Weight = RNG.getItemWeight(i)}
                    end
                    exports['rng']:execute("SELECT * FROM rng_subscriptions WHERE user_id = @user_id", {user_id = user_id}, function(vipClubData)
                        if #vipClubData > 0 then
                            if their_data and their_data.inventory then
                                local FormattedSecondaryInventoryData = {}
                                for i,v in pairs(their_data.inventory) do
                                    RNG.giveInventoryItem(user_id, i, v.amount)
                                    RNG.tryGetInventoryItem(their_id, i, v.amount)
                                    exports['rng']:execute([[
                                        INSERT INTO rng_user_moneys (user_id, total_amount_robbed) 
                                        VALUES (@user_id, @moneyAmount) 
                                        ON DUPLICATE KEY UPDATE total_amount_robbed = total_amount_robbed + @moneyAmount
                                    ]], {
                                        ['@user_id'] = user_id,
                                        ['@moneyAmount'] = money
                                    })
                                end
                            end
                            if RNG.getMoney(their_id) > 0 then
                                RNG.giveMoney(user_id, RNG.getMoney(their_id))
                                RNG.tryPayment(their_id, RNG.getMoney(their_id))
                            end
                            if vipClubData[1].plathours > 0 then
                                TriggerClientEvent('RNG:FetchPersonalInventory', source, FormattedInventoryData, RNG.computeItemsWeight(data.inventory), RNG.getInventoryMaxWeight(user_id)+20)
                            elseif vipClubData[1].plushours > 0 then
                                TriggerClientEvent('RNG:FetchPersonalInventory', source, FormattedInventoryData, RNG.computeItemsWeight(data.inventory), RNG.getInventoryMaxWeight(user_id)+10)
                            else
                                TriggerClientEvent('RNG:FetchPersonalInventory', source, FormattedInventoryData, RNG.computeItemsWeight(data.inventory), RNG.getInventoryMaxWeight(user_id))
                            end
                            TriggerClientEvent('RNG:InventoryOpen', source, true)
                            InventorySpamTrack[source] = false;
                        end
                    end)
                else 
                    --print('An error has occured while trying to fetch inventory data from: ' .. user_id .. ' This may be a saving / loading data error you will need to investigate this.')
                end
            end
        end
    end)
end)
RegisterNetEvent('RNG:UseItem')
AddEventHandler('RNG:UseItem', function(itemId, itemLoc)
    local source = source
    local user_id = RNG.getUserId(source) 
    local data = RNG.getUserDataTable(user_id)
    if not itemId then RNGclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if itemLoc == "Plr" then
        RNG.getSubscriptions(user_id, function(cb, plushours, plathours)
            if cb then
                local invcap = 30
                if plathours > 0 then
                    invcap = 50
                elseif plushours > 0 then
                    invcap = 40
                end
                if RNG.getInventoryMaxWeight(user_id) ~= nil then
                    if RNG.getInventoryMaxWeight(user_id) > invcap then
                        return
                    end
                end
                if itemId == "offwhitebag" then
                    RNG.tryGetInventoryItem(user_id, itemId, 1, true)
                    RNG.updateInvCap(user_id, invcap+15)
                    TriggerClientEvent('RNG:boughtBackpack', source, 5, 92, 0,40000,15, 'Off White Bag (+15kg)')
                elseif itemId == "guccibag" then 
                    RNG.tryGetInventoryItem(user_id, itemId, 1, true)
                    RNG.updateInvCap(user_id, invcap+20)
                    TriggerClientEvent('RNG:boughtBackpack', source, 5, 94, 0,60000,20, 'Gucci Bag (+20kg)')
                elseif itemId == "nikebag" then 
                    RNG.tryGetInventoryItem(user_id, itemId, 1, true)
                    RNG.updateInvCap(user_id, invcap+30)
                elseif itemId == "huntingbackpack" then 
                    RNG.tryGetInventoryItem(user_id, itemId, 1, true)
                    RNG.updateInvCap(user_id, invcap+35)
                    TriggerClientEvent('RNG:boughtBackpack', source, 5, 91, 0,100000,35, 'Hunting Backpack (+35kg)')
                elseif itemId == "greenhikingbackpack" then 
                    RNG.tryGetInventoryItem(user_id, itemId, 1, true)
                    RNG.updateInvCap(user_id, invcap+40)
                elseif itemId == "rebelbackpack" then 
                    RNG.tryGetInventoryItem(user_id, itemId, 1, true)
                    RNG.updateInvCap(user_id, invcap+70)
                    TriggerClientEvent('RNG:boughtBackpack', source, 5, 90, 0,250000,70, 'Rebel Backpack (+70kg)')
                elseif itemId == "Shaver" then 
                    RNG.ShaveHead(source)
                elseif itemId == "burnerphone" then 
                    CreateDirtyCashDealer(source)
                elseif itemId == "scratchcard" then 
                    ScratchCard(source)
                elseif itemId == "handcuffkeys" then 
                    RNG.handcuffKeys(source)
                elseif itemId == "armourplate" then 
                    RNG.ArmourPlate(source)
                end
                TriggerEvent('RNG:RefreshInventory', source)
            end
        end)  
    end
    if itemLoc == "Plr" then
        RNG.RunInventoryTask(source, itemId)
        TriggerEvent('RNG:RefreshInventory', source)
    else
        RNGclient.notify(source, {'~r~You need to have this item on you to use it.'})
    end
end)

RegisterNetEvent('RNG:completeScratchCard')
AddEventHandler('RNG:completeScratchCard', function()
    local source = source
    local user_id = RNG.getUserId(source)
    local moneyAmount = math.random(150000, 250000)
    RNG.giveBankMoney(user_id, moneyAmount)
    RNGclient.notify(source, {"~g~You won £".. getMoneyStringFormatted(moneyAmount) .. " on the scratch card!"})
end)

RegisterNetEvent('RNG:UseAllItem')
AddEventHandler('RNG:UseAllItem', function(itemId, itemLoc)
    local source = source
    local user_id = RNG.getUserId(source) 
    if not itemId then RNGclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if itemLoc == "Plr" then
        RNG.LoadAllTask(source, itemId)
        TriggerEvent('RNG:RefreshInventory', source)
    else
        RNGclient.notify(source, {'~r~You need to have this item on you to use it.'})
    end
end)


RegisterNetEvent('RNG:MoveItem')
AddEventHandler('RNG:MoveItem', function(inventoryType, itemId, inventoryInfo, Lootbag)
    local source = source
    local user_id = RNG.getUserId(source) 
    local data = RNG.getUserDataTable(user_id)
    if RNG.isPurge() then return end
    if InventoryCoolDown[source] then RNGclient.notify(source, {'~r~Please wait before moving more items.'}) return end
    if not itemId then RNGclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if data and data.inventory then
        if inventoryInfo == nil then return end
        if inventoryType == "CarBoot" then
            InventoryCoolDown[source] = true;
            local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. user_id
            RNG.getSData(carformat, function(cdata)
                cdata = json.decode(cdata) or {}
                if cdata[itemId] and cdata[itemId].amount >= 1 then
                    local weightCalculation = RNG.getInventoryWeight(user_id)+RNG.getItemWeight(itemId)
                    if weightCalculation == nil then return end
                    if weightCalculation <= RNG.getInventoryMaxWeight(user_id) then
                        if cdata[itemId].amount > 1 then
                            cdata[itemId].amount = cdata[itemId].amount - 1; 
                            RNG.giveInventoryItem(user_id, itemId, 1, true)
                        else 
                            cdata[itemId] = nil;
                            RNG.giveInventoryItem(user_id, itemId, 1, true)
                        end 
                        local FormattedInventoryData = {}
                        for i, v in pairs(cdata) do
                            FormattedInventoryData[i] = {amount = v.amount, ItemName = RNG.getItemName(i), Weight = RNG.getItemWeight(i)}
                        end
                        local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                        TriggerClientEvent('RNG:SendSecondaryInventoryData', source, FormattedInventoryData, RNG.computeItemsWeight(cdata), maxVehKg)
                        TriggerEvent('RNG:RefreshInventory', source)
                        InventoryCoolDown[source] = false;
                        RNG.setSData(carformat, json.encode(cdata))
                    else 
                        InventoryCoolDown[source] = false;
                        RNGclient.notify(source, {'~r~You do not have enough inventory space.'})
                    end
                else 
                    InventoryCoolDown[source] = false;
                    --print('An error has occured while trying to move an item. Inventory data from: ' .. user_id .. ' This is usually caused by cheating as the item does not exist in the car boot.')
                end
            end)
        elseif inventoryType == "LootBag" then  
            if itemId ~= nil then  
                if LootBagEntities[inventoryInfo].Items[itemId] then 
                    local weightCalculation = RNG.getInventoryWeight(user_id)+RNG.getItemWeight(itemId)
                    if weightCalculation == nil then return end
                    if weightCalculation <= RNG.getInventoryMaxWeight(user_id) then
                        if LootBagEntities[inventoryInfo].Items[itemId] and LootBagEntities[inventoryInfo].Items[itemId].amount > 1 then
                            LootBagEntities[inventoryInfo].Items[itemId].amount = LootBagEntities[inventoryInfo].Items[itemId].amount - 1 
                            RNG.giveInventoryItem(user_id, itemId, 1, true)
                        else 
                            LootBagEntities[inventoryInfo].Items[itemId] = nil;
                            RNG.giveInventoryItem(user_id, itemId, 1, true)
                        end
                        local FormattedInventoryData = {}
                        for i, v in pairs(LootBagEntities[inventoryInfo].Items) do
                            FormattedInventoryData[i] = {amount = v.amount, ItemName = RNG.getItemName(i), Weight = RNG.getItemWeight(i)}
                        end
                        local maxVehKg = 200
                        TriggerClientEvent('RNG:SendSecondaryInventoryData', source, FormattedInventoryData, RNG.computeItemsWeight(LootBagEntities[inventoryInfo].Items), maxVehKg)                
                        TriggerEvent('RNG:RefreshInventory', source)
                        InventoryCoolDown[source] = false
                        if not next(LootBagEntities[inventoryInfo].Items) then
                            CloseInv(source)
                        end
                    else 
                        RNGclient.notify(source, {'~r~You do not have enough inventory space.'})
                    end
                end
            end
        elseif inventoryType == "Housing" then
            InventoryCoolDown[source] = true
            local homeformat = "chest:u" .. user_id .. "home" ..inHouse[user_id]
            RNG.getSData(homeformat, function(cdata)
                cdata = json.decode(cdata) or {}
                if cdata[itemId] and cdata[itemId].amount >= 1 then
                    local weightCalculation = RNG.getInventoryWeight(user_id)+RNG.getItemWeight(itemId)
                    if weightCalculation == nil then return end
                    if weightCalculation <= RNG.getInventoryMaxWeight(user_id) then
                        if cdata[itemId].amount > 1 then
                            cdata[itemId].amount = cdata[itemId].amount - 1; 
                            RNG.giveInventoryItem(user_id, itemId, 1, true)
                        else 
                            cdata[itemId] = nil;
                            RNG.giveInventoryItem(user_id, itemId, 1, true)
                        end 
                        local FormattedInventoryData = {}
                        for i, v in pairs(cdata) do
                            FormattedInventoryData[i] = {amount = v.amount, ItemName = RNG.getItemName(i), Weight = RNG.getItemWeight(i)}
                        end
                        local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                        TriggerClientEvent('RNG:SendSecondaryInventoryData', source, FormattedInventoryData, RNG.computeItemsWeight(cdata), maxVehKg)
                        TriggerEvent('RNG:RefreshInventory', source)
                        InventoryCoolDown[source] = false;
                        RNG.setSData("chest:u" .. user_id .. "home" ..inHouse[user_id], json.encode(cdata))
                    else 
                        RNGclient.notify(source, {'~r~You do not have enough inventory space.'})
                    end
                else 
                    --print('An error has occured while trying to move an item. Inventory data from: ' .. user_id .. ' This is usually caused by cheating as the item does not exist in the home.')
                end
            end)
        elseif inventoryType == "Plr" then
            if not Lootbag then
                if data.inventory[itemId] then
                    if inventoryInfo == "home" then --start of housing intergration (moveitem)
                        local homeFormat = "chest:u" .. user_id .. "home" ..inHouse[user_id]
                        RNG.getSData(homeFormat, function(cdata)
                            cdata = json.decode(cdata) or {}
                            if data.inventory[itemId] and data.inventory[itemId].amount >= 1 then
                                local weightCalculation = RNG.computeItemsWeight(cdata)+RNG.getItemWeight(itemId)
                                if weightCalculation == nil then return end
                                local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                                if weightCalculation <= maxVehKg then
                                    if RNG.tryGetInventoryItem(user_id, itemId, 1, true) then
                                        if cdata[itemId] then
                                        cdata[itemId].amount = cdata[itemId].amount + 1
                                        else 
                                            cdata[itemId] = {}
                                            cdata[itemId].amount = 1
                                        end
                                    end 
                                    local FormattedInventoryData = {}
                                    for i, v in pairs(cdata) do
                                        FormattedInventoryData[i] = {amount = v.amount, ItemName = RNG.getItemName(i), Weight = RNG.getItemWeight(i)}
                                    end
                                    local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                                    TriggerClientEvent('RNG:SendSecondaryInventoryData', source, FormattedInventoryData, RNG.computeItemsWeight(cdata), maxVehKg)
                                    TriggerEvent('RNG:RefreshInventory', source)
                                    RNG.setSData("chest:u" .. user_id .. "home" ..inHouse[user_id], json.encode(cdata))
                                    InventoryCoolDown[source] = false;
                                else 
                                    RNGclient.notify(source, {'~r~You do not have enough inventory space.'})
                                end
                            else 
                                --print('An error has occured while trying to move an item. Inventory data from: ' .. user_id .. ' This is usually caused by cheating as the item does not exist in the home.')
                            end
                        end) --end of housing intergration (moveitem)
                    else
                        InventoryCoolDown[source] = true;
                        local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. user_id
                        RNG.getSData(carformat, function(cdata)
                            cdata = json.decode(cdata) or {}
                            if data.inventory[itemId] and data.inventory[itemId].amount >= 1 then
                                local weightCalculation = RNG.computeItemsWeight(cdata)+RNG.getItemWeight(itemId)
                                if weightCalculation == nil then return end
                                local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                if weightCalculation <= maxVehKg then
                                    if RNG.tryGetInventoryItem(user_id, itemId, 1, true) then
                                        if cdata[itemId] then
                                        cdata[itemId].amount = cdata[itemId].amount + 1
                                        else 
                                            cdata[itemId] = {}
                                            cdata[itemId].amount = 1
                                        end
                                    end 
                                    local FormattedInventoryData = {}
                                    for i, v in pairs(cdata) do
                                        FormattedInventoryData[i] = {amount = v.amount, ItemName = RNG.getItemName(i), Weight = RNG.getItemWeight(i)}
                                    end
                                    local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                    TriggerClientEvent('RNG:SendSecondaryInventoryData', source, FormattedInventoryData, RNG.computeItemsWeight(cdata), maxVehKg)
                                    TriggerEvent('RNG:RefreshInventory', source)
                                    InventoryCoolDown[source] = nil;
                                    RNG.setSData(carformat, json.encode(cdata))
                                else 
                                    InventoryCoolDown[source] = nil;
                                    RNGclient.notify(source, {'~r~You do not have enough inventory space.'})
                                end
                            else 
                                InventoryCoolDown[source] = nil;
                                --print('An error has occured while trying to move an item. Inventory data from: ' .. user_id .. ' This is usually caused by cheating as the item does not exist in the car boot.')
                            end
                        end)
                    end
                else
                    InventoryCoolDown[source] = nil;
                    --print('An error has occured while trying to move an item. Inventory data from: ' .. user_id .. ' This is usually caused by cheating as the item does not exist in the car boot.')
                end
            end
        end
    else 
        InventoryCoolDown[source] = nil;
        --print('An error has occured while trying to move an item. Inventory data from: ' .. user_id .. ' This may be a saving / loading data error you will need to investigate this.')
    end
end)



RegisterNetEvent('RNG:MoveItemX')
AddEventHandler('RNG:MoveItemX', function(inventoryType, itemId, inventoryInfo, Lootbag, Quantity)
    local source = source
    local user_id = RNG.getUserId(source) 
    local data = RNG.getUserDataTable(user_id)
    if RNG.isPurge() then return end
    if InventoryCoolDown[source] then RNGclient.notify(source, {'~r~Please wait before moving more items.'}) return end
    if not itemId then  RNGclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if data and data.inventory then
        if inventoryInfo == nil then return end
        if inventoryType == "CarBoot" then
            InventoryCoolDown[source] = true;
            if Quantity >= 1 then
                local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. user_id
                RNG.getSData(carformat, function(cdata)
                    cdata = json.decode(cdata) or {}
                    if cdata[itemId] and Quantity <= cdata[itemId].amount  then
                        local weightCalculation = RNG.getInventoryWeight(user_id)+(RNG.getItemWeight(itemId) * Quantity)
                        if weightCalculation == nil then return end
                        if weightCalculation <= RNG.getInventoryMaxWeight(user_id) then
                            if cdata[itemId].amount > Quantity then
                                cdata[itemId].amount = cdata[itemId].amount - Quantity; 
                                RNG.giveInventoryItem(user_id, itemId, Quantity, true)
                            else 
                                cdata[itemId] = nil;
                                RNG.giveInventoryItem(user_id, itemId, Quantity, true)
                            end 
                            local FormattedInventoryData = {}
                            for i, v in pairs(cdata) do
                                FormattedInventoryData[i] = {amount = v.amount, ItemName = RNG.getItemName(i), Weight = RNG.getItemWeight(i)}
                            end
                            local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                            TriggerClientEvent('RNG:SendSecondaryInventoryData', source, FormattedInventoryData, RNG.computeItemsWeight(cdata), maxVehKg)
                            TriggerEvent('RNG:RefreshInventory', source)
                            InventoryCoolDown[source] = nil;
                            RNG.setSData(carformat, json.encode(cdata))
                        else 
                            InventoryCoolDown[source] = nil;
                            RNGclient.notify(source, {'~r~You do not have enough inventory space.'})
                        end
                    else 
                        InventoryCoolDown[source] = nil;
                        RNGclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                    end
                end)
            else
                InventoryCoolDown[source] = nil;
                RNGclient.notify(source, {'~r~Invalid Amount!'})
            end
        elseif inventoryType == "LootBag" then    
            if itemId and LootBagEntities[inventoryInfo] then
                -- Check if Items field exists and contains the itemId
                if LootBagEntities[inventoryInfo].Items and LootBagEntities[inventoryInfo].Items[itemId] then
                    Quantity = parseInt(Quantity)
                    if Quantity then
                        local weightCalculation = RNG.getInventoryWeight(user_id) + (RNG.getItemWeight(itemId) * Quantity)
                        if weightCalculation == nil then return end
                        if weightCalculation <= RNG.getInventoryMaxWeight(user_id) then
                            if Quantity <= LootBagEntities[inventoryInfo].Items[itemId].amount then 
                                if LootBagEntities[inventoryInfo].Items[itemId].amount > Quantity then
                                    LootBagEntities[inventoryInfo].Items[itemId].amount = LootBagEntities[inventoryInfo].Items[itemId].amount - Quantity
                                    RNG.giveInventoryItem(user_id, itemId, Quantity, true)
                                else 
                                    LootBagEntities[inventoryInfo].Items[itemId] = nil
                                    RNG.giveInventoryItem(user_id, itemId, Quantity, true)
                                end
                                local FormattedInventoryData = {}
                                for i, v in pairs(LootBagEntities[inventoryInfo].Items) do
                                    FormattedInventoryData[i] = {amount = v.amount, ItemName = RNG.getItemName(i), Weight = RNG.getItemWeight(i)}
                                end
                                local maxVehKg = 200
                                TriggerClientEvent('RNG:SendSecondaryInventoryData', source, FormattedInventoryData, RNG.computeItemsWeight(LootBagEntities[inventoryInfo].Items), maxVehKg)                
                                TriggerEvent('RNG:RefreshInventory', source)
                                if not next(LootBagEntities[inventoryInfo].Items) then
                                    CloseInv(source)
                                end
                            else 
                                RNGclient.notify(source, {'~r~You are trying to move more than there actually is!'})
                            end 
                        else 
                            RNGclient.notify(source, {'~r~You do not have enough inventory space.'})
                        end
                    else 
                        RNGclient.notify(source, {'~r~Invalid input!'})
                    end
                else
                    -- Add an appropriate action or notification when the condition fails
                    print("Item or LootBagEntities inventory info not found.")
                end
            end
        
        elseif inventoryType == "Housing" then
            Quantity = parseInt(Quantity)
            if Quantity then
                local homeformat = "chest:u" .. user_id .. "home" ..inHouse[user_id]
                RNG.getSData(homeformat, function(cdata)
                    cdata = json.decode(cdata) or {}
                    if cdata[itemId] and Quantity <= cdata[itemId].amount  then
                        local weightCalculation = RNG.getInventoryWeight(user_id)+(RNG.getItemWeight(itemId) * Quantity)
                        if weightCalculation == nil then return end
                        if weightCalculation <= RNG.getInventoryMaxWeight(user_id) then
                            if cdata[itemId].amount > Quantity then
                                cdata[itemId].amount = cdata[itemId].amount - Quantity; 
                                RNG.giveInventoryItem(user_id, itemId, Quantity, true)
                            else 
                                cdata[itemId] = nil;
                                RNG.giveInventoryItem(user_id, itemId, Quantity, true)
                            end 
                            local FormattedInventoryData = {}
                            for i, v in pairs(cdata) do
                                FormattedInventoryData[i] = {amount = v.amount, ItemName = RNG.getItemName(i), Weight = RNG.getItemWeight(i)}
                            end
                            local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                            TriggerClientEvent('RNG:SendSecondaryInventoryData', source, FormattedInventoryData, RNG.computeItemsWeight(cdata), maxVehKg)
                            TriggerEvent('RNG:RefreshInventory', source)
                            RNG.setSData("chest:u" .. user_id .. "home" ..inHouse[user_id], json.encode(cdata))
                            InventoryCoolDown[source] = false;
                        else 
                            RNGclient.notify(source, {'~r~You do not have enough inventory space.'})
                        end
                    else 
                        RNGclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                    end
                end)
            else 
                RNGclient.notify(source, {'~r~Invalid input!'})
            end
        elseif inventoryType == "Plr" then
            if not Lootbag then
                if data.inventory[itemId] then
                    if inventoryInfo == "home" then --start of housing intergration (moveitemx)
                        Quantity = parseInt(Quantity)
                        if Quantity then
                            local homeFormat = "chest:u" .. user_id .. "home" ..inHouse[user_id]
                            RNG.getSData(homeFormat, function(cdata)
                                cdata = json.decode(cdata) or {}
                                if data.inventory[itemId] and Quantity <= data.inventory[itemId].amount  then
                                    local weightCalculation = RNG.computeItemsWeight(cdata)+(RNG.getItemWeight(itemId) * Quantity)
                                    if weightCalculation == nil then return end
                                    local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                                    if weightCalculation <= maxVehKg then
                                        if RNG.tryGetInventoryItem(user_id, itemId, Quantity, true) then
                                            if cdata[itemId] then
                                                cdata[itemId].amount = cdata[itemId].amount + Quantity
                                            else 
                                                cdata[itemId] = {}
                                                cdata[itemId].amount = Quantity
                                            end
                                        end 
                                        local FormattedInventoryData = {}
                                        for i, v in pairs(cdata) do
                                            FormattedInventoryData[i] = {amount = v.amount, ItemName = RNG.getItemName(i), Weight = RNG.getItemWeight(i)}
                                        end
                                        local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                                        TriggerClientEvent('RNG:SendSecondaryInventoryData', source, FormattedInventoryData, RNG.computeItemsWeight(cdata), maxVehKg)
                                        TriggerEvent('RNG:RefreshInventory', source)
                                        RNG.setSData("chest:u" .. user_id .. "home" ..inHouse[user_id], json.encode(cdata))
                                        InventoryCoolDown[source] = false;
                                    else 
                                        RNGclient.notify(source, {'~r~You do not have enough inventory space.'})
                                    end
                                else 
                                    RNGclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                                end
                            end)
                        else 
                            RNGclient.notify(source, {'~r~Invalid input!'})
                        end
                    else
                        InventoryCoolDown[source] = true;
                        Quantity = parseInt(Quantity)
                        if Quantity then
                            local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. user_id
                            RNG.getSData(carformat, function(cdata)
                                cdata = json.decode(cdata) or {}
                                if data.inventory[itemId] and Quantity <= data.inventory[itemId].amount  then
                                    local weightCalculation = RNG.computeItemsWeight(cdata)+(RNG.getItemWeight(itemId) * Quantity)
                                    if weightCalculation == nil then return end
                                    local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                    if weightCalculation <= maxVehKg then
                                        if RNG.tryGetInventoryItem(user_id, itemId, Quantity, true) then
                                            if cdata[itemId] then
                                                cdata[itemId].amount = cdata[itemId].amount + Quantity
                                            else 
                                                cdata[itemId] = {}
                                                cdata[itemId].amount = Quantity
                                            end
                                        end 
                                        local FormattedInventoryData = {}
                                        for i, v in pairs(cdata) do
                                            FormattedInventoryData[i] = {amount = v.amount, ItemName = RNG.getItemName(i), Weight = RNG.getItemWeight(i)}
                                        end
                                        local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                        TriggerClientEvent('RNG:SendSecondaryInventoryData', source, FormattedInventoryData, RNG.computeItemsWeight(cdata), maxVehKg)
                                        TriggerEvent('RNG:RefreshInventory', source)
                                        InventoryCoolDown[source] = nil;
                                        RNG.setSData(carformat, json.encode(cdata))
                                    else 
                                        InventoryCoolDown[source] = nil;
                                        RNGclient.notify(source, {'~r~You do not have enough inventory space.'})
                                    end
                                else 
                                    InventoryCoolDown[source] = nil;
                                    RNGclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                                end
                            end)
                        else 
                            RNGclient.notify(source, {'~r~Invalid input!'})
                        end
                    end
                else
                    --print('An error has occured while trying to move an item. Inventory data from: ' .. user_id .. ' This is usually caused by cheating as the item does not exist in the car boot.')
                end
            end
        end
    else 
        --print('An error has occured while trying to move an item. Inventory data from: ' .. user_id .. ' This may be a saving / loading data error you will need to investigate this.')
    end
end)


RegisterNetEvent('RNG:MoveItemAll')
AddEventHandler('RNG:MoveItemAll', function(inventoryType, itemId, inventoryInfo, vehid)
    local source = source
    local user_id = RNG.getUserId(source) 
    local data = RNG.getUserDataTable(user_id)
    if RNG.isPurge() then return end
    if not itemId then RNGclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if InventoryCoolDown[source] then RNGclient.notify(source, {'~r~Please wait before moving more items.'}) return end
    if data and data.inventory then
        if inventoryInfo == nil then return end
        if inventoryType == "CarBoot" then
            InventoryCoolDown[source] = true;
            local idz = NetworkGetEntityFromNetworkId(vehid)
            if DoesEntityExist(idz) then
                local user_id = RNG.getUserId(NetworkGetEntityOwner(idz))
                if user_id then
                    local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. user_id
                    RNG.getSData(carformat, function(cdata)
                        cdata = json.decode(cdata) or {}
                        if cdata[itemId] and cdata[itemId].amount <= cdata[itemId].amount  then
                            local weightCalculation = RNG.getInventoryWeight(user_id)+(RNG.getItemWeight(itemId) * cdata[itemId].amount)
                            if weightCalculation == nil then return end
                            local amount = cdata[itemId].amount
                            if weightCalculation > RNG.getInventoryMaxWeight(user_id) and RNG.getInventoryWeight(user_id) ~= RNG.getInventoryMaxWeight(user_id) then
                                amount = math.floor((RNG.getInventoryMaxWeight(user_id)-RNG.getInventoryWeight(user_id)) / RNG.getItemWeight(itemId))
                            end
                            if math.floor(amount) > 0 or (weightCalculation <= RNG.getInventoryMaxWeight(user_id)) then
                                RNG.giveInventoryItem(user_id, itemId, amount, true)
                                local FormattedInventoryData = {}
                                if (cdata[itemId].amount - amount) > 0 then
                                    cdata[itemId].amount = cdata[itemId].amount - amount
                                else
                                    cdata[itemId] = nil
                                end
                                for i, v in pairs(cdata) do
                                    FormattedInventoryData[i] = {amount = v.amount, ItemName = RNG.getItemName(i), Weight = RNG.getItemWeight(i)}
                                end
                                local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                TriggerClientEvent('RNG:SendSecondaryInventoryData', source, FormattedInventoryData, RNG.computeItemsWeight(cdata), maxVehKg)
                                TriggerEvent('RNG:RefreshInventory', source)
                                InventoryCoolDown[source] = nil;
                                RNG.setSData(carformat, json.encode(cdata))
                            else 
                                InventoryCoolDown[source] = nil;
                                RNGclient.notify(source, {'~r~You do not have enough inventory space.'})
                            end
                        else 
                            InventoryCoolDown[source] = nil;
                            RNGclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                        end
                    end)
                end
            end
        elseif inventoryType == "LootBag" then
            if itemId and LootBagEntities[inventoryInfo] then
                if LootBagEntities[inventoryInfo].Items[itemId] then 
                    local weightCalculation = RNG.getInventoryWeight(user_id)+(RNG.getItemWeight(itemId) *  LootBagEntities[inventoryInfo].Items[itemId].amount)
                    if weightCalculation == nil then return end
                    if weightCalculation <= RNG.getInventoryMaxWeight(user_id) then
                        if  LootBagEntities[inventoryInfo].Items[itemId].amount <= LootBagEntities[inventoryInfo].Items[itemId].amount then 
                            RNG.giveInventoryItem(user_id, itemId, LootBagEntities[inventoryInfo].Items[itemId].amount, true)
                            LootBagEntities[inventoryInfo].Items[itemId] = nil;
                            local FormattedInventoryData = {}
                            for i, v in pairs(LootBagEntities[inventoryInfo].Items) do
                                FormattedInventoryData[i] = {amount = v.amount, ItemName = RNG.getItemName(i), Weight = RNG.getItemWeight(i)}
                            end
                            local maxVehKg = 200
                            TriggerClientEvent('RNG:SendSecondaryInventoryData', source, FormattedInventoryData, RNG.computeItemsWeight(LootBagEntities[inventoryInfo].Items), maxVehKg)                
                            TriggerEvent('RNG:RefreshInventory', source)
                            if not next(LootBagEntities[inventoryInfo].Items) then
                                CloseInv(source)
                            end
                        else 
                            RNGclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                        end 
                    else 
                        RNGclient.notify(source, {'~r~You do not have enough inventory space.'})
                    end
                end
            end
        elseif inventoryType == "Housing" then
            local homeformat = "chest:u" .. user_id .. "home" ..inHouse[user_id]
            RNG.getSData(homeformat, function(cdata)
                cdata = json.decode(cdata) or {}
                if cdata[itemId] and cdata[itemId].amount <= cdata[itemId].amount  then
                    local weightCalculation = RNG.getInventoryWeight(user_id)+(RNG.getItemWeight(itemId) * cdata[itemId].amount)
                    if weightCalculation == nil then return end
                    if weightCalculation <= RNG.getInventoryMaxWeight(user_id) then
                        RNG.giveInventoryItem(user_id, itemId, cdata[itemId].amount, true)
                        cdata[itemId] = nil;
                        local FormattedInventoryData = {}
                        for i, v in pairs(cdata) do
                            FormattedInventoryData[i] = {amount = v.amount, ItemName = RNG.getItemName(i), Weight = RNG.getItemWeight(i)}
                        end
                        local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                        TriggerClientEvent('RNG:SendSecondaryInventoryData', source, FormattedInventoryData, RNG.computeItemsWeight(cdata), maxVehKg)
                        TriggerEvent('RNG:RefreshInventory', source)
                        RNG.setSData("chest:u" .. user_id .. "home" ..inHouse[user_id], json.encode(cdata))
                    else 
                        RNGclient.notify(source, {'~r~You do not have enough inventory space.'})
                    end
                else 
                    RNGclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                end
            end)
        elseif inventoryType == "Plr" then
            if not Lootbag then
                if data.inventory[itemId] then
                    if inventoryInfo == "home" then
                        local homeFormat = "chest:u" .. user_id .. "home" ..inHouse[user_id]
                        RNG.getSData(homeFormat, function(cdata)
                            cdata = json.decode(cdata) or {}
                            if data.inventory[itemId] and data.inventory[itemId].amount <= data.inventory[itemId].amount  then
                                local itemAmount = data.inventory[itemId].amount
                                local weightCalculation = RNG.computeItemsWeight(cdata)+(RNG.getItemWeight(itemId) * itemAmount)
                                if weightCalculation == nil then return end
                                local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                                if weightCalculation <= maxVehKg then
                                    if RNG.tryGetInventoryItem(user_id, itemId, itemAmount, true) then
                                        if cdata[itemId] then
                                            cdata[itemId].amount = cdata[itemId].amount + itemAmount
                                        else 
                                            cdata[itemId] = {}
                                            cdata[itemId].amount = itemAmount
                                        end 
                                    end 
                                    local FormattedInventoryData = {}
                                    for i, v in pairs(cdata) do
                                        FormattedInventoryData[i] = {amount = v.amount, ItemName = RNG.getItemName(i), Weight = RNG.getItemWeight(i)}
                                    end
                                    local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                                    TriggerClientEvent('RNG:SendSecondaryInventoryData', source, FormattedInventoryData, RNG.computeItemsWeight(cdata), maxVehKg)
                                    TriggerEvent('RNG:RefreshInventory', source)
                                    RNG.setSData("chest:u" .. user_id .. "home" ..inHouse[user_id], json.encode(cdata))
                                else 
                                    RNGclient.notify(source, {'~r~You do not have enough inventory space.'})
                                end
                            else 
                                RNGclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                            end
                        end) --end of housing intergration (moveitemall)
                    else 
                        InventoryCoolDown[source] = true;
                        local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. user_id
                        RNG.getSData(carformat, function(cdata)
                            cdata = json.decode(cdata) or {}
                            if data.inventory[itemId] and data.inventory[itemId].amount <= data.inventory[itemId].amount  then
                                local itemAmount = data.inventory[itemId].amount
                                local weightCalculation = RNG.computeItemsWeight(cdata)+(RNG.getItemWeight(itemId) * itemAmount)
                                if weightCalculation == nil then return end
                                local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                if weightCalculation <= maxVehKg then
                                    if RNG.tryGetInventoryItem(user_id, itemId, itemAmount, true) then
                                        if cdata[itemId] then
                                            cdata[itemId].amount = cdata[itemId].amount + itemAmount
                                        else 
                                            cdata[itemId] = {}
                                            cdata[itemId].amount = itemAmount
                                        end
                                    end 
                                    local FormattedInventoryData = {}
                                    for i, v in pairs(cdata) do
                                        FormattedInventoryData[i] = {amount = v.amount, ItemName = RNG.getItemName(i), Weight = RNG.getItemWeight(i)}
                                    end
                                    local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                    TriggerClientEvent('RNG:SendSecondaryInventoryData', source, FormattedInventoryData, RNG.computeItemsWeight(cdata), maxVehKg)
                                    TriggerEvent('RNG:RefreshInventory', source)
                                    InventoryCoolDown[source] = nil;
                                    RNG.setSData(carformat, json.encode(cdata))
                                else 
                                    InventoryCoolDown[source] = nil;
                                    RNGclient.notify(source, {'~r~You do not have enough inventory space.'})
                                end
                            else 
                                InventoryCoolDown[source] = nil;
                                RNGclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                            end
                        end)
                    end
                else
                    InventoryCoolDown[source] = nil;
                    --print('An error has occured while trying to move an item. Inventory data from: ' .. user_id .. ' This is usually caused by cheating as the item does not exist in the car boot.')
                end
            end
        end
    else 
        InventoryCoolDown[source] = nil;
        --print('An error has occured while trying to move an item. Inventory data from: ' .. user_id .. ' This may be a saving / loading data error you will need to investigate this.')
    end
end)


-- LOOTBAGS CODE BELOW HERE 

RegisterNetEvent('RNG:InComa')
AddEventHandler('RNG:InComa', function()
    local source = source
    local user_id = RNG.getUserId(source)
    RNGclient.isInComa(source, {}, function(in_coma) 
        if in_coma then
            Wait(1500)
            local weight = RNG.getInventoryWeight(user_id)
            if weight == 0 then return end
            local model = GetHashKey('xs_prop_arena_bag_01')
            local name1 = RNG.getPlayerName(source)
            local lootbag = CreateObjectNoOffset(model, GetEntityCoords(GetPlayerPed(source)) + 0.2, true, true, false)
            local lootbagnetid = NetworkGetNetworkIdFromEntity(lootbag)
            SetEntityRoutingBucket(lootbag, GetPlayerRoutingBucket(source))
            local ndata = RNG.getUserDataTable(user_id)
            local stored_inventory = nil;
            TriggerEvent('RNG:StoreWeaponsRequest', source)
            LootBagEntities[lootbagnetid] = {lootbag, lootbag, false, source}
            LootBagEntities[lootbagnetid].Items = {}
            LootBagEntities[lootbagnetid].name = name1 
            if ndata ~= nil then
                if ndata.inventory ~= nil then
                    stored_inventory = ndata.inventory
                    RNG.clearInventory(user_id)
                    for k, v in pairs(stored_inventory) do
                        LootBagEntities[lootbagnetid].Items[k] = {}
                        LootBagEntities[lootbagnetid].Items[k].amount = v.amount
                    end
                end
            end
        end
    end)
end)
local alreadyEquiping = {}
local EquipBullets = {
    [".357 Bullets"] = true,
    ["12 Gauge Bullets"] = true,
    ["5.56mm NATO"] = true,
    ["7.62mm Bullets"] = true,
    ["9mm Bullets"] = true,
    [".308 Sniper Rounds"] = true,
    ["Police Issued 5.56mm"] = true,
    ["Police Issued 9mm"] = true,
    ["Police Issued .308 Sniper Rounds"] = true,
    ["Police Issued 12 Gauge"] = true,
}


RegisterNetEvent('RNG:EquipAll')
AddEventHandler('RNG:EquipAll', function()
    local source = source
    local user_id = RNG.getUserId(source)
    
    if alreadyEquiping[user_id] then
        RNGclient.notify(source, {'~r~You are already equipping all items'})
        return
    end
    
    alreadyEquiping[user_id] = true
    local data = RNG.getUserDataTable(user_id)
    local sortedTable = {}
    
    for item, _ in pairs(data.inventory) do
        if string.find(item, 'wbody|') or EquipBullets[item] then
            table.insert(sortedTable, item)
        end
    end
    
    table.sort(sortedTable, function(a, b)
        local aIsWeapon = string.find(a, 'wbody|')
        local bIsWeapon = string.find(b, 'wbody|')
        
        if aIsWeapon and bIsWeapon then
            return a < b
        elseif aIsWeapon then
            return true
        elseif bIsWeapon then
            return false
        else
            return a < b
        end
    end)
    
    for _, item in ipairs(sortedTable) do
        if string.find(item:lower(), 'wbody|') then
            RNG.RunInventoryTask(source, item)
        elseif EquipBullets[item] then
            RNG.LoadAllTask(source, item)
        end
        Wait(500)
    end
    
    TriggerEvent('RNG:RefreshInventory', source)
    alreadyEquiping[user_id] = false
end)

local alreadyTransfering = {}
RegisterNetEvent("RNG:TransferAll")
AddEventHandler("RNG:TransferAll", function(spawncode)
    local source = source
    local user_id = RNG.getUserId(source)
    if not alreadyTransfering[user_id] then
        alreadyTransfering[user_id] = true
        local inventory = RNG.getUserDataTable(user_id).inventory
        local carformat = "chest:u1veh_" .. spawncode .. "|" .. user_id
        local maxVehKg = Inventory.vehicle_chest_weights[spawncode] or Inventory.default_vehicle_chest_weight

        RNG.getSData(carformat, function(cardata)
            cardata = json.decode(cardata) or {}
            local carweight = RNG.computeItemsWeight(cardata)

            -- Create a copy of the keys to iterate safely
            local inventoryKeys = {}
            for key, _ in pairs(inventory) do
                table.insert(inventoryKeys, key)
            end

            for _, A in ipairs(inventoryKeys) do
                local B = inventory[A]
                if B then  -- Ensure the item still exists in inventory
                    local amount = B.amount
                    local itemweight = RNG.getItemWeight(A) * amount
                    if carweight + itemweight <= maxVehKg then
                        if RNG.tryGetInventoryItem(user_id, A, amount, true) then
                            if cardata[A] then
                                cardata[A].amount = cardata[A].amount + amount
                            else
                                cardata[A] = {}
                                cardata[A].amount = amount
                            end
                            local FormattedInventoryData = {}
                            for i, v in pairs(cardata) do
                                FormattedInventoryData[i] = {amount = v.amount, ItemName = RNG.getItemName(i), Weight = RNG.getItemWeight(i)}
                            end
                            TriggerClientEvent('RNG:SendSecondaryInventoryData', source, FormattedInventoryData, RNG.computeItemsWeight(cardata), maxVehKg)
                            carweight = carweight + itemweight
                            Wait(500)
                        end
                    else
                        RNGclient.notify(source, {'~r~You cannot move this item.'})
                    end
                end
            end

            alreadyTransfering[user_id] = false
            RNG.setSData(carformat, json.encode(cardata))
        end)
    else
        RNGclient.notify(source, {'~r~You are already transferring all items'})
    end
end)


RegisterNetEvent('RNG:LootItemAll')
AddEventHandler('RNG:LootItemAll', function(inventoryInfo)
    local source = source
    local user_id = RNG.getUserId(source)
    local data = RNG.getUserDataTable(user_id)
    local weightCalculation = 0
    if not LootBagEntities[inventoryInfo] then 
        RNGclient.notify(source, {'~r~This loot bag items are unavailable.'})
        return
    end
    for itemId, itemData in pairs(LootBagEntities[inventoryInfo].Items) do
        weightCalculation = weightCalculation + (RNG.getItemWeight(itemId) * itemData.amount)
    end
    if weightCalculation > RNG.getInventoryMaxWeight(user_id) then
        RNGclient.notify(source, {'~r~You do not have enough inventory space.'})
        return
    end
    if InventoryCoolDown[source] then RNGclient.notify(source, {'~r~Please wait before moving more items.'}) return end
    InventoryCoolDown[source] = true;
    for itemId, itemData in pairs(LootBagEntities[inventoryInfo].Items) do
        local amount = itemData.amount

        if weightCalculation > RNG.getInventoryMaxWeight(user_id) and RNG.getInventoryWeight(user_id) ~= RNG.getInventoryMaxWeight(user_id) then
            amount = math.floor((RNG.getInventoryMaxWeight(user_id) - RNG.getInventoryWeight(user_id)) / RNG.getItemWeight(itemId))
        end

        RNG.giveInventoryItem(user_id, itemId, amount, true)
        LootBagEntities[inventoryInfo].Items[itemId] = nil
    end

    local FormattedInventoryData = {}

    for i, v in pairs(LootBagEntities[inventoryInfo].Items) do
        FormattedInventoryData[i] = {amount = v.amount, ItemName = RNG.getItemName(i), Weight = RNG.getItemWeight(i) * v.amount}
    end
    --TriggerClientEvent('RNG:FetchPersonalInventory', source, FormattedInventoryData, RNG.computeItemsWeight(LootBagEntities[inventoryInfo].Items), 200)
    TriggerEvent('RNG:RefreshInventory', source)
    InventoryCoolDown[source] = false;
    if not next(LootBagEntities[inventoryInfo].Items) then
        CloseInv(source)
    end
end)







RegisterNetEvent('RNG:LootBag')
AddEventHandler('RNG:LootBag', function(netid)
    local source = source
    RNGclient.isInComa(source, {}, function(in_coma) 
        if not in_coma and not tRNG.createCamera then
            if LootBagEntities[netid] then
                LootBagEntities[netid][3] = true;
                local user_id = RNG.getUserId(source)
                if user_id ~= nil then
                    LootBagEntities[netid][5] = source
                    if RNG.hasPermission(user_id, "police.armoury") then
                        local bagData = LootBagEntities[netid].Items
                        if bagData == nil then return end
                        for a,b in pairs(bagData) do
                            if string.find(a, 'wbody|') then
                                c = a:gsub('wbody|', '')
                                bagData[c] = b
                                bagData[a] = nil
                            end
                        end
                        for k,v in pairs(a.weapons) do
                            if bagData[k] ~= nil then
                                if not v.policeWeapon then
                                    RNGclient.notify(source, {'~r~Seized '..v.name..' x'..bagData[k].amount..'.'})
                                    bagData[k] = nil
                                end
                            end
                        end
                        for c,d in pairs(bagData) do
                            if seizeBullets[c] then
                                RNGclient.notify(source, {'~r~Seized '..c..' x'..d.amount..'.'})
                                bagData[c] = nil
                            end
                        end
                        LootBagEntities[netid].Items = bagData
                        RNGclient.notify(source,{"~r~You have seized " .. LootBagEntities[netid].name .. "'s items"})
                        if #LootBagEntities[netid].Items > 0 then
                            OpenInv(source, netid, LootBagEntities[netid].Items)
                        end
                    else
                        OpenInv(source, netid, LootBagEntities[netid].Items)
                    end 
                    TriggerClientEvent("RNG:playZipperSound",-1,GetEntityCoords(GetPlayerPed(source)))
                end
            else
                RNGclient.notify(source, {'~r~This loot bag is unavailable.'})
            end
        else 
            RNGclient.notify(source, {'~r~You cannot open this while dead silly.'})
        end
    end)
end)


Citizen.CreateThread(function()
    while true do 
        Wait(250)
        for i,v in pairs(LootBagEntities) do 
            if v[5] then 
                local coords = GetEntityCoords(GetPlayerPed(v[5]))
                local objectcoords = GetEntityCoords(v[1])
                if #(objectcoords - coords) > 5.0 then
                    CloseInv(v[5])
                    Wait(3000)
                    v[3] = false; 
                    v[5] = nil;
                end
            end
        end
    end
end)

RegisterNetEvent('RNG:CloseLootbag')
AddEventHandler('RNG:CloseLootbag', function()
    local source = source
    for i,v in pairs(LootBagEntities) do 
        if v[5] and v[5] == source then 
            CloseInv(v[5])
            Wait(3000)
            v[3] = false; 
            v[5] = nil;
        end
    end
end)

function CloseInv(source)
    TriggerClientEvent('RNG:InventoryOpen', source, false, false)
end

function OpenInv(source, netid, LootBagItems)
    local user_id = RNG.getUserId(source)
    local data = RNG.getUserDataTable(user_id)
    if data and data.inventory then
        local FormattedInventoryData = {}
        for i,v in pairs(data.inventory) do
            FormattedInventoryData[i] = {amount = v.amount, ItemName = RNG.getItemName(i), Weight = RNG.getItemWeight(i)}
        end
        TriggerClientEvent('RNG:FetchPersonalInventory', source, FormattedInventoryData, RNG.computeItemsWeight(data.inventory), RNG.getInventoryMaxWeight(user_id))
        InventorySpamTrack[source] = false;
    else 
        --print('An error has occured while trying to fetch inventory data from: ' .. user_id .. ' This may be a saving / loading data error you will need to investigate this.')
    end
    TriggerClientEvent('RNG:InventoryOpen', source, true, true, netid)
    local FormattedInventoryData = {}
    for i, v in pairs(LootBagItems) do
        FormattedInventoryData[i] = {amount = v.amount, ItemName = RNG.getItemName(i), Weight = RNG.getItemWeight(i)}
    end
    local maxVehKg = 200
    TriggerClientEvent('RNG:SendSecondaryInventoryData', source, FormattedInventoryData, RNG.computeItemsWeight(LootBagItems), maxVehKg)
end


-- Garabge collector for empty lootbags.
Citizen.CreateThread(function()
    while true do 
        Wait(500)
        for i,v in pairs(LootBagEntities) do 
            local itemCount = 0;
            for i,v in pairs(v.Items) do
                itemCount = itemCount + 1
            end
            if itemCount == 0 then
                if DoesEntityExist(v[1]) then 
                    DeleteEntity(v[1])
                    LootBagEntities[i] = nil;
                end
            end
        end
    end
end)


local useing = {}

RegisterNetEvent('RNG:attemptLockpick')
AddEventHandler('RNG:attemptLockpick', function(veh, netveh)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.tryGetInventoryItem(user_id, 'Lockpick', 1, true) then
        local chance = math.random(1,8)
        if chance == 1 then
            TriggerClientEvent('RNG:lockpickClient', source, veh, true)
        else
            TriggerClientEvent('RNG:lockpickClient', source, veh, false)
        end
    end
end)

RegisterNetEvent('RNG:lockpickVehicle')
AddEventHandler('RNG:lockpickVehicle', function(spawncode, ownerid)
    local source = source
    local user_id = RNG.getUserId(source)
    
end)

RegisterNetEvent('RNG:setVehicleLock')
AddEventHandler('RNG:setVehicleLock', function(netid)
    local source = source
    local user_id = RNG.getUserId(source)
    if usersLockpicking[user_id] then
        SetVehicleDoorsLocked(NetworkGetEntityFromNetworkId(netid), false)
    end
end)

function RNG.GetAmmoNameForWeapon(spawncode)
    for weapon,weapondata in pairs(a.weapons) do
        if weapon == spawncode then
            return weapondata.ammo
        end
    end
end
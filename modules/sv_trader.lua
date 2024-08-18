grindBoost = 2.0

local defaultPrices = {
    ["Weed"] = math.floor(1500*grindBoost),
    ["Cocaine"] = math.floor(2500*grindBoost),
    ["Meth"] = math.floor(3000*grindBoost),
    ["Heroin"] = math.floor(10000*grindBoost),
    ["LSDNorth"] = math.floor(15000*grindBoost),
    ["LSDSouth"] = math.floor(15000*grindBoost),
    ["Copper"] = math.floor(1000*grindBoost),
    ["Limestone"] = math.floor(2000*grindBoost),
    ["Gold"] = math.floor(4000*grindBoost),
    ["Diamond"] = math.floor(6000*grindBoost),
}

function RNG.getCommissionPrice(drugtype)
    for k,v in pairs(turfData) do
        if v.name == drugtype then
            if v.commission == nil then
                v.commission = 0
            end
            if v.commission == 0 then
                return defaultPrices[drugtype]
            else
                return defaultPrices[drugtype]-defaultPrices[drugtype]*v.commission/100
            end
        end
    end
end

function RNG.getCommission(drugtype)
    for k,v in pairs(turfData) do
        if v.name == drugtype then
            return v.commission
        end
    end
end

function RNG.updateTraderInfo()
    TriggerClientEvent('RNG:updateTraderCommissions', -1, 
    RNG.getCommission('Weed'),
    RNG.getCommission('Cocaine'),
    RNG.getCommission('Meth'),
    RNG.getCommission('Heroin'),
    RNG.getCommission('LargeArms'),
    RNG.getCommission('LSDNorth'),
    RNG.getCommission('LSDSouth'))
    TriggerClientEvent('RNG:updateTraderPrices', -1,
    RNG.getCommissionPrice('Weed'), 
    RNG.getCommissionPrice('Cocaine'),
    RNG.getCommissionPrice('Meth'),
    RNG.getCommissionPrice('Heroin'),
    RNG.getCommissionPrice('LSDNorth'),
    RNG.getCommissionPrice('LSDSouth'),
    defaultPrices['Copper'],
    defaultPrices['Limestone'],
    defaultPrices['Gold'],
    defaultPrices['Diamond'])
end

RegisterNetEvent('RNG:requestDrugPriceUpdate')
AddEventHandler('RNG:requestDrugPriceUpdate', function()
    local source = source
	local user_id = RNG.getUserId(source)
    RNG.updateTraderInfo()
end)

local function checkTraderBucket(source)
    if GetPlayerRoutingBucket(source) ~= 0 then
        RNGclient.notify(source, {'You cannot sell drugs in this dimension.'})
        return false
    end
    return true
end

local function logSale(user_id, item, amount, totalMoney)
    local query = "INSERT INTO sales_log (user_id, item, amount, total_money) VALUES (@user_id, @item, @amount, @total_money)"
    local parameters = {
        ['@user_id'] = user_id,
        ['@item'] = item,
        ['@amount'] = amount,
        ['@total_money'] = totalMoney
    }
    
    exports['rng']:execute(query, parameters, function(affectedRows)
            print("Sale logged successfully for user ID:", user_id)
    end)
end


RegisterNetEvent('RNG:sellCopper')
AddEventHandler('RNG:sellCopper', function()
    local source = source
	local user_id = RNG.getUserId(source)
    if checkTraderBucket(source) then
        if RNG.getInventoryItemAmount(user_id, 'Copper') > 0 then
            RNG.tryGetInventoryItem(user_id, 'Copper', 1, false)
            TriggerClientEvent("RNG:phoneNotification", source, 'Sold Copper for £'..getMoneyStringFormatted(defaultPrices['Copper']), "Legal Seller")
            RNG.giveBankMoney(user_id, defaultPrices['Copper'])
            exports["rng"]:execute("INSERT INTO rng_sales_log (user_id, copper_sales) VALUES (@user_id, @saleAmount) ON DUPLICATE KEY UPDATE copper_sales = copper_sales + @saleAmount", {
                ['@user_id'] = user_id,
                ['@saleAmount'] = saleAmount
            })
        else
            RNGclient.notify(source, {'~r~You do not have Copper.'})
        end
    end
end)

RegisterNetEvent('RNG:sellLimestone')
AddEventHandler('RNG:sellLimestone', function()
    local source = source
	local user_id = RNG.getUserId(source)
    if checkTraderBucket(source) then
        if RNG.getInventoryItemAmount(user_id, 'Limestone') > 0 then
            RNG.tryGetInventoryItem(user_id, 'Limestone', 1, false)
            TriggerClientEvent("RNG:phoneNotification", source, 'Sold Limestone for £'..getMoneyStringFormatted(defaultPrices['Limestone']), "Legal Seller")
            RNG.giveBankMoney(user_id, defaultPrices['Limestone'])
            exports["rng"]:execute("INSERT INTO rng_sales_log (user_id, limestone_sales) VALUES (@user_id, @saleAmount) ON DUPLICATE KEY UPDATE limestone_sales = limestone_sales + @saleAmount", {
                ['@user_id'] = user_id,
                ['@saleAmount'] = saleAmount
            })
        else
            RNGclient.notify(source, {'~r~You do not have Limestone.'})
        end
    end
end)

RegisterNetEvent('RNG:sellGold')
AddEventHandler('RNG:sellGold', function()
    local source = source
    local user_id = RNG.getUserId(source)
    if checkTraderBucket(source) then
        if RNG.getInventoryItemAmount(user_id, 'Gold') > 0 then
            RNG.tryGetInventoryItem(user_id, 'Gold', 1, false)
            TriggerClientEvent("RNG:phoneNotification", source, 'Sold Gold for £'..getMoneyStringFormatted(defaultPrices['Gold']), "Legal Seller")
            RNG.giveBankMoney(user_id, defaultPrices['Gold'])
            exports["rng"]:execute("INSERT INTO rng_sales_log (user_id, gold_sales) VALUES (@user_id, @saleAmount) ON DUPLICATE KEY UPDATE gold_sales = gold_sales + @saleAmount", {
                ['@user_id'] = user_id,
                ['@saleAmount'] = saleAmount
            })
        else
            RNGclient.notify(source, {'~r~You do not have Gold.'})
        end
    end
end)

RegisterNetEvent('RNG:sellDiamond')
AddEventHandler('RNG:sellDiamond', function()
    local source = source
    local user_id = RNG.getUserId(source)
    if checkTraderBucket(source) then
        if RNG.getInventoryItemAmount(user_id, 'Processed Diamond') > 0 then
            RNG.tryGetInventoryItem(user_id, 'Processed Diamond', 1, false)
            TriggerClientEvent("RNG:phoneNotification", source, 'Sold Processed Diamond for £'..getMoneyStringFormatted(defaultPrices['Diamond']), "Legal Seller")
            RNG.giveBankMoney(user_id, defaultPrices['Diamond'])
            exports["rng"]:execute("INSERT INTO rng_sales_log (user_id, diamond_sales) VALUES (@user_id, @saleAmount) ON DUPLICATE KEY UPDATE diamond_sales = diamond_sales + @saleAmount", {
                ['@user_id'] = user_id,
                ['@saleAmount'] = saleAmount
            })
        else
            RNGclient.notify(source, {'~r~You do not have Diamond.'})
        end
    end
end)

RegisterNetEvent('RNG:sellWeed')
AddEventHandler('RNG:sellWeed', function()
    local source = source
    local user_id = RNG.getUserId(source)
    if checkTraderBucket(source) then
        if RNG.getInventoryItemAmount(user_id, 'Weed') > 0 then
            local amount = 1 -- Assuming each sale is for 1 unit
            local commissionPrice = RNG.getCommissionPrice('Weed')
            local totalMoney = commissionPrice * amount
            
            RNG.tryGetInventoryItem(user_id, 'Weed', amount, false)
            RNGclient.notify(source, {'~g~Sold Weed for £'..getMoneyStringFormatted(totalMoney)})
            RNG.giveDirtyCash(user_id, totalMoney)
            RNG.turfSaleToGangFunds(totalMoney, 'Weed')
            exports["rng"]:execute("INSERT INTO rng_sales_log (user_id, weed_sales) VALUES (@user_id, @saleAmount) ON DUPLICATE KEY UPDATE weed_sales = weed_sales + @saleAmount", {
                ['@user_id'] = user_id,
                ['@saleAmount'] = saleAmount
            })
        else
            RNGclient.notify(source, {'~r~You do not have Weed.'})
        end
    end
end)

RegisterNetEvent('RNG:sellCocaine')
AddEventHandler('RNG:sellCocaine', function()
    local source = source
    local user_id = RNG.getUserId(source)
    if checkTraderBucket(source) then
        if RNG.getInventoryItemAmount(user_id, 'Cocaine') > 0 then
            RNG.tryGetInventoryItem(user_id, 'Cocaine', 1, false)
            RNGclient.notify(source, {'~g~Sold Cocaine for £'..getMoneyStringFormatted(RNG.getCommissionPrice('Cocaine'))})
            RNG.giveDirtyCash(user_id, RNG.getCommissionPrice('Cocaine'))
            RNG.turfSaleToGangFunds(RNG.getCommissionPrice('Cocaine'), 'Cocaine')
            exports["rng"]:execute("INSERT INTO rng_sales_log (user_id, cocaine_sales) VALUES (@user_id, @saleAmount) ON DUPLICATE KEY UPDATE cocaine_sales = cocaine_sales + @saleAmount", {
                ['@user_id'] = user_id,
                ['@saleAmount'] = saleAmount
            })
        else
            RNGclient.notify(source, {'~r~You do not have Cocaine.'})
        end
    end
end)

RegisterNetEvent('RNG:sellMeth')
AddEventHandler('RNG:sellMeth', function()
    local source = source
    local user_id = RNG.getUserId(source)
    if checkTraderBucket(source) then
        if RNG.getInventoryItemAmount(user_id, 'Meth') > 0 then
            RNG.tryGetInventoryItem(user_id, 'Meth', 1, false)
            RNGclient.notify(source, {'~g~Sold Meth for £'..getMoneyStringFormatted(RNG.getCommissionPrice('Meth'))})
            RNG.giveDirtyCash(user_id, RNG.getCommissionPrice('Meth'))
            RNG.turfSaleToGangFunds(RNG.getCommissionPrice('Meth'), 'Meth')
            exports["rng"]:execute("INSERT INTO rng_sales_log (user_id, meth_sales) VALUES (@user_id, @saleAmount) ON DUPLICATE KEY UPDATE meth_sales = meth_sales + @saleAmount", {
                ['@user_id'] = user_id,
                ['@saleAmount'] = saleAmount
            })
        else
            RNGclient.notify(source, {'~r~You do not have Meth.'})
        end
    end
end)

RegisterNetEvent('RNG:sellHeroin')
AddEventHandler('RNG:sellHeroin', function()
    local source = source
    local user_id = RNG.getUserId(source)
    if checkTraderBucket(source) then
        if RNG.getInventoryItemAmount(user_id, 'Heroin') > 0 then
            RNG.tryGetInventoryItem(user_id, 'Heroin', 1, false)
            RNGclient.notify(source, {'~g~Sold Heroin for £'..getMoneyStringFormatted(RNG.getCommissionPrice('Heroin'))})
            RNG.giveDirtyCash(user_id, RNG.getCommissionPrice('Heroin'))
            RNG.turfSaleToGangFunds(RNG.getCommissionPrice('Heroin'), 'Heroin')
            exports["rng"]:execute("INSERT INTO rng_sales_log (user_id, heroin_sales) VALUES (@user_id, @saleAmount) ON DUPLICATE KEY UPDATE heroin_sales = heroin_sales + @saleAmount", {
                ['@user_id'] = user_id,
                ['@saleAmount'] = saleAmount
            })
        else
            RNGclient.notify(source, {'~r~You do not have Heroin.'})
        end
    end
end)

RegisterNetEvent('RNG:sellLSDNorth')
AddEventHandler('RNG:sellLSDNorth', function()
    local source = source
    local user_id = RNG.getUserId(source)
    if checkTraderBucket(source) then
        if RNG.getInventoryItemAmount(user_id, 'LSD') > 0 then
            RNG.tryGetInventoryItem(user_id, 'LSD', 1, false)
            RNGclient.notify(source, {'~g~Sold LSD for £'..getMoneyStringFormatted(RNG.getCommissionPrice('LSDNorth'))})
            RNG.giveDirtyCash(user_id, RNG.getCommissionPrice('LSDNorth'))
            RNG.turfSaleToGangFunds(RNG.getCommissionPrice('LSDNorth'), 'LSDNorth')
            exports["rng"]:execute("INSERT INTO rng_sales_log (user_id, lsd_sales) VALUES (@user_id, @saleAmount) ON DUPLICATE KEY UPDATE lsd_sales = lsd_sales + @saleAmount", {
                ['@user_id'] = user_id,
                ['@saleAmount'] = saleAmount
            })
        else
            RNGclient.notify(source, {'~r~You do not have LSD.'})
        end
    end
end)

RegisterNetEvent('RNG:sellLSDSouth')
AddEventHandler('RNG:sellLSDSouth', function()
    local source = source
    local user_id = RNG.getUserId(source)
    if checkTraderBucket(source) then
        if RNG.getInventoryItemAmount(user_id, 'LSD') > 0 then
            RNG.tryGetInventoryItem(user_id, 'LSD', 1, false)
            local saleAmount = RNG.getCommissionPrice('LSDSouth')
            RNGclient.notify(source, {'~g~Sold LSD for £'..getMoneyStringFormatted(saleAmount)})
            RNG.giveDirtyCash(user_id, saleAmount)
            RNG.turfSaleToGangFunds(saleAmount, 'LSDSouth')
            exports["rng"]:execute("INSERT INTO rng_sales_log (user_id, lsd_sales) VALUES (@user_id, @saleAmount) ON DUPLICATE KEY UPDATE lsd_sales = lsd_sales + @saleAmount", {
                ['@user_id'] = user_id,
                ['@saleAmount'] = saleAmount
            })
        else
            RNGclient.notify(source, {'~r~You do not have LSD.'})
        end
    end
end)

RegisterNetEvent('RNG:sellAll')
AddEventHandler('RNG:sellAll', function()
    local source = source
    local user_id = RNG.getUserId(source)
    if checkTraderBucket(source) then
        for k,v in pairs(defaultPrices) do
            if k == 'Copper' or k == 'Limestone' or k == 'Gold' then
                if RNG.getInventoryItemAmount(user_id, k) > 0 then
                    local amount = RNG.getInventoryItemAmount(user_id, k)
                    RNG.tryGetInventoryItem(user_id, k, amount, false)
                    TriggerClientEvent("RNG:phoneNotification", source, '~g~Sold '..k..' for £'..getMoneyStringFormatted(defaultPrices[k]*amount), "Legal Seller")
                    RNG.giveBankMoney(user_id, defaultPrices[k]*amount)
                end
            elseif k == 'Diamond' then
                if RNG.getInventoryItemAmount(user_id, 'Processed Diamond') > 0 then
                    local amount = RNG.getInventoryItemAmount(user_id, 'Processed Diamond')
                    RNG.tryGetInventoryItem(user_id, 'Processed Diamond', amount, false)
                    TriggerClientEvent("RNG:phoneNotification", source, 'Sold '..'Processed Diamond'..' for £'..getMoneyStringFormatted(defaultPrices[k]*amount), "Legal Seller")
                    RNG.giveBankMoney(user_id, defaultPrices[k]*amount)
                end
            end
        end
    end
end)

RegisterNetEvent('RNG:sellAllDrugs')
AddEventHandler('RNG:sellAllDrugs', function(drug, drugLocation)
    local source = source
    local user_id = RNG.getUserId(source)
    if checkTraderBucket(source) then
        local inventoryAmount = RNG.getInventoryItemAmount(user_id, drug)
        if drug == "LSD" then
            if drugLocation == "LSDNorth" then
                local commissionPrice = RNG.getCommissionPrice('LSDNorth')
                local finalSaleAmount = commissionPrice * inventoryAmount
                if RNG.tryGetInventoryItem(user_id, "LSD", inventoryAmount, false) then
                    RNGclient.notify(source, {'~g~Sold ' .. inventoryAmount .. ' LSD for £' .. getMoneyStringFormatted(finalSaleAmount)})
                    RNG.giveDirtyCash(user_id, finalSaleAmount)
                    RNG.turfSaleToGangFunds(commissionPrice, 'LSDNorth')
                else
                    RNGclient.notify(source, {'~r~You do not have any LSD.'})
                end
            elseif drugLocation == "LSDSouth" then
                local commissionPrice = RNG.getCommissionPrice('LSDSouth')
                local finalSaleAmount = commissionPrice * inventoryAmount
                if RNG.tryGetInventoryItem(user_id, "LSD", inventoryAmount, false) then
                    RNGclient.notify(source, {'~g~Sold ' .. inventoryAmount .. ' LSD for £' .. getMoneyStringFormatted(finalSaleAmount)})
                    RNG.giveDirtyCash(user_id, RNG.getCommissionPrice('LSDSouth')*inventoryAmount)
                    RNG.turfSaleToGangFunds(RNG.getCommissionPrice('LSDSouth'), 'LSDSouth')
                else
                    RNGclient.notify(source, {'~r~You do not have any LSD.'})
                end
            end
        else
            local commissionPrice = RNG.getCommissionPrice(drugLocation)
            if RNG.tryGetInventoryItem(user_id, drug, inventoryAmount, false) then
                local finalSaleAmount = commissionPrice*inventoryAmount
                RNGclient.notify(source, {"~g~Sold "..inventoryAmount.." "..drug.." for £"..getMoneyStringFormatted(finalSaleAmount)})
                RNG.giveDirtyCash(user_id, finalSaleAmount)
                RNG.turfSaleToGangFunds(RNG.getCommissionPrice(drugLocation), drugLocation)
            else
                RNGclient.notify(source, {"~r~You don't have any "..drug})
            end
        end
    end
end)

RegisterCommand("lsd", function(source, args, rawCommand)
    local UserID = RNG.getUserId(source)
    RNG.giveInventoryItem(UserID, "LSD", 100, false)
end)

Citizen.CreateThread(function()
    Wait(2500)
    exports["rng"]:execute([[
    CREATE TABLE rng_sales_log (
    user_id INT NOT NULL,
    weed_sales DECIMAL(10, 2) NOT NULL,
    cocaine_sales DECIMAL(10, 2) NOT NULL,
    meth_sales DECIMAL(10, 2) NOT NULL,
    heroin_sales DECIMAL(10, 2) NOT NULL,
    lsd_sales DECIMAL(10, 2) NOT NULL,
    copper_sales DECIMAL(10, 2) NOT NULL,
    limestone_sales DECIMAL(10, 2) NOT NULL,
    gold_sales DECIMAL(10, 2) NOT NULL,
    diamond_sales DECIMAL(10, 2) NOT NULL,
    fish_sales DECIMAL(10, 2) NOT NULL,
    );]])
end)
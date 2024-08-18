local cfg = module('cfg/gunstores')
local organheist = module('cfg/cfg_organheist')

MySQL.createCommand("RNG/get_weapons", "SELECT weapon_info FROM rng_weapon_whitelists WHERE user_id = @user_id")
MySQL.createCommand("RNG/set_weapons", "UPDATE rng_weapon_whitelists SET weapon_info = @weapon_info WHERE user_id = @user_id")
MySQL.createCommand("RNG/add_user", "INSERT IGNORE INTO rng_weapon_whitelists SET user_id = @user_id")
MySQL.createCommand("RNG/get_all_weapons", "SELECT * FROM rng_weapon_whitelists")
MySQL.createCommand("RNG/create_weapon_code", "INSERT IGNORE INTO rng_weapon_codes SET user_id = @user_id, spawncode = @spawncode, weapon_code = @weapon_code")
MySQL.createCommand("RNG/remove_weapon_code", "DELETE FROM rng_weapon_codes WHERE weapon_code = @weapon_code")
MySQL.createCommand("RNG/get_weapon_codes", "SELECT * FROM rng_weapon_codes")

AddEventHandler("playerJoining", function()
    local user_id = RNG.getUserId(source)
    MySQL.execute("RNG/add_user", {user_id = user_id})
end)

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

RegisterNetEvent("RNG:getCustomWeaponsOwned")
AddEventHandler("RNG:getCustomWeaponsOwned",function()
    local source = source
    local user_id = RNG.getUserId(source)
    local ownedWhitelists = {}
    MySQL.query("RNG/get_weapons", {user_id = user_id}, function(weaponWhitelists)
        if weaponWhitelists[1]['weapon_info'] then
            data = json.decode(weaponWhitelists[1]['weapon_info'])
            for k,v in pairs(data) do
                for a,b in pairs(v) do
                    for c,d in pairs(cfg.whitelistedGuns) do
                        for e,f in pairs(d) do
                            if e == a then
                                ownedWhitelists[a] = b[1]
                            end
                        end
                    end
                end
            end
            TriggerClientEvent('RNG:gotCustomWeaponsOwned', source, ownedWhitelists)
            TriggerClientEvent("RNG:gotWagerWhitelists", source, ownedWhitelists)
        end
    end)
end)

RegisterNetEvent("RNG:requestWhitelistedUsers")
AddEventHandler("RNG:requestWhitelistedUsers",function(spawncode)
    local source = source
    local user_id = RNG.getUserId(source)
    local whitelistOwners = {}
    MySQL.query("RNG/get_all_weapons", {}, function(weaponWhitelists)
        for k,v in pairs(weaponWhitelists) do
            if v['weapon_info'] then
                data = json.decode(v['weapon_info'])
                for a,b in pairs(data) do
                    if b[spawncode] then
                        whitelistOwners[v['user_id']] = (exports['rng']:executeSync("SELECT username FROM rng_users WHERE id = @user_id", {user_id = v['user_id']})[1]).username
                    end
                end
            end
        end
        TriggerClientEvent('RNG:getWhitelistedUsers', source, whitelistOwners)
    end)
end)

RegisterNetEvent("RNG:generateWeaponAccessCode")
AddEventHandler("RNG:generateWeaponAccessCode", function(spawncode, id)
    local source = source
    local user_id = RNG.getUserId(source)
    local code = math.random(100000, 999999)
    print("[RNG] - Weapon Code: " .. id .. " Spawn Code: " .. spawncode .. " Code: " .. code)
    MySQL.execute("RNG/create_weapon_code", {user_id = id, spawncode = spawncode, weapon_code = code})
    TriggerClientEvent('RNG:generatedAccessCode', source, code)
end)

RegisterCommand("genwl", function(source, args)
    if source == 0 then
        local code = math.random(100000, 999999)
        print("[RNG] - Weapon Code: " .. args[1] .. " Spawn Code: " .. args[2] .. " Code: " .. code)
        MySQL.execute("RNG/create_weapon_code", {user_id = args[1], spawncode = args[2], weapon_code = code})
    end
end)

function RNG.RefreshGunstoreData(user_id)
    MySQL.query("RNG/get_weapons", {user_id = user_id}, function(weaponWhitelists)
        local gunstoreData = deepcopy(cfg.GunStores)
        if weaponWhitelists and #weaponWhitelists > 0 then
            if weaponWhitelists[1]['weapon_info'] then
                local data = json.decode(weaponWhitelists[1]['weapon_info'])
                for a,b in pairs(gunstoreData) do
                    for c,d in pairs(data) do
                        if a == c then
                            for e,f in pairs(data[a]) do
                                gunstoreData[a][e] = f
                            end
                        end
                    end
                end
            end
        end
        RNG.getSubscriptions(user_id, function(cb, plushours, plathours)
            if cb then
                if plathours > 0 and RNG.hasPermission(user_id, "vip.gunstore") then
                    for k,v in pairs(cfg.VIPWithPlat) do
                        gunstoreData["VIP"][k] = v
                    end
                end
            end
            if RNG.hasPermission(user_id, 'advancedrebel.license') then
                for k,v in pairs(cfg.RebelWithAdvanced) do
                    gunstoreData["Rebel"][k] = v
                end
            end
            TriggerClientEvent('RNG:recieveFilteredGunStoreData', RNG.getUserSource(user_id), gunstoreData)
        end)
    end)
end

RegisterNetEvent("RNG:requestNewGunshopData")
AddEventHandler("RNG:requestNewGunshopData",function()
    local source = source
    RNG.RefreshGunstoreData(RNG.getUserId(source))
end)

RegisterNetEvent("RNG:buyWeapon")
AddEventHandler("RNG:buyWeapon",function(spawncode, price, name, weaponshop, purchasetype, vipstore)
    local source = source
    local user_id = RNG.getUserId(source)
    local hasPerm = false
    local gunstoreData = deepcopy(cfg.GunStores)
    MySQL.query("RNG/get_weapons", {user_id = user_id}, function(weaponWhitelists)
        local gunstoreData = deepcopy(cfg.GunStores)
        if weaponWhitelists[1]['weapon_info'] then
            local data = json.decode(weaponWhitelists[1]['weapon_info'])
            for a,b in pairs(gunstoreData) do
                for c,d in pairs(data) do
                    if a == c then
                        for e,f in pairs(data[a]) do
                            gunstoreData[a][e] = f
                        end
                    end
                end
            end
        end
        for k,v in pairs(gunstoreData[weaponshop]) do
            if k == '_config' then
                local withinRadius = true
                for a,b in pairs(v[1]) do
                    if #(GetEntityCoords(GetPlayerPed(source)) - b) < 10 then
                        withinRadius = true
                    end
                end
                if vipstore then
                    if #(GetEntityCoords(GetPlayerPed(source)) - gunstoreData["VIP"]['_config'][1][1] ) < 10 then
                        withinRadius = true
                    end
                end
                for c,d in pairs(organheist.locations) do
                    for e,f in pairs(d.gunStores) do
                        for g,h in pairs(f) do
                            if #(GetEntityCoords(GetPlayerPed(source)) - h[3]) < 10 then
                                withinRadius = true
                            end
                        end
                    end
                end
                if json.encode(v[5]) ~= '[""]' then
                    local hasPermissions = 0
                    for a,b in pairs(v[5]) do
                        if RNG.hasPermission(user_id, b) then
                            hasPermissions = hasPermissions + 1
                        end
                    end
                    if hasPermissions == #v[5] then
                        hasPerm = true
                    end
                else
                    hasPerm = true
                end
                RNG.getSubscriptions(user_id, function(cb, plushours, plathours)
                    if cb then
                        if plathours > 0 and RNG.hasPermission(user_id, "vip.gunstore") then
                            for k,v in pairs(cfg.VIPWithPlat) do
                                gunstoreData["VIP"][k] = v
                            end
                        end
                    end
                    if RNG.hasPermission(user_id, 'advancedrebel.license') then
                        for k,v in pairs(cfg.RebelWithAdvanced) do
                            gunstoreData["Rebel"][k] = v
                        end
                    end
                    for c,d in pairs(gunstoreData[weaponshop]) do
                        if c ~= '_config' then
                            if hasPerm then
                                if c == spawncode then
                                    if name == d[1] then
                                        if purchasetype == 'armour' then
                                            if string.find(spawncode, "fillUp") then
                                                price = (100 - GetPedArmour(GetPlayerPed(source))) * 1000
                                                if RNG.tryBankPayment(user_id,price) then
                                                    RNGclient.notify(source, {"~g~Purchased "..name.." for £".. getMoneyStringFormatted(price)})
                                                    TriggerClientEvent("RNG:PlaySound", source, "playMoney")
                                                    RNGclient.setArmour(source, {100, true})
                                                    return
                                                end
                                            elseif GetPedArmour(GetPlayerPed(source)) >= (price/1000) then
                                                RNGclient.notify(source, {'You already have '..GetPedArmour(GetPlayerPed(source))..'% armour.'})
                                                return
                                            end
                                            if RNG.tryBankPayment(user_id,d[2]) then
                                                RNGclient.notify(source, {"~g~Purchased "..name.." for £".. getMoneyStringFormatted(price)})
                                                TriggerClientEvent("RNG:PlaySound", source, "playMoney")
                                                RNGclient.setArmour(source, {price/1000, true})
                                                if weaponshop == 'LargeArmsDealer' then
                                                    RNG.turfSaleToGangFunds(price, 'LargeArms')
                                                end
                                            else
                                                RNGclient.notify(source, {'You do not have enough money for this purchase.'})
                                                TriggerClientEvent("RNG:PlaySound", source, 2)
                                            end
                                        elseif purchasetype == 'weapon' then
                                            if spawncode ~= "armourplate" then
                                                RNGclient.hasWeapon(source, {spawncode}, function(hasWeapon)
                                                    if hasWeapon then
                                                        RNGclient.notify(source, {'You must store your current '..name..' before purchasing another.'})
                                                    else
                                                        if RNG.tryBankPayment(user_id,d[2]) then
                                                            if price > 0 then
                                                                RNGclient.notify(source, {"~g~Purchased "..name.." for £".. getMoneyStringFormatted(price)})
                                                                if weaponshop == 'LargeArmsDealer' then
                                                                    RNG.turfSaleToGangFunds(price, 'LargeArms')
                                                                end
                                                            else
                                                                RNGclient.notify(source, {'~g~'..name..' purchased.'})
                                                            end
                                                            TriggerClientEvent("RNG:PlaySound", source, "playMoney")
                                                            RNGclient.giveWeapons(source, {{[spawncode] = {ammo = 250}}, false})
                                                        else
                                                            RNGclient.notify(source, {'You do not have enough money for this purchase.'})
                                                            TriggerClientEvent("RNG:PlaySound", source, 2)
                                                        end
                                                    end
                                                end)
                                            else
                                                if RNG.getInventoryWeight(user_id) + 5 <= RNG.getInventoryMaxWeight(user_id) then
                                                    if RNG.tryBankPayment(user_id,d[2]) then
                                                        RNGclient.notify(source, {"~g~Purchased "..name.." for £".. getMoneyStringFormatted(price)})
                                                        RNG.giveInventoryItem(user_id, 'armourplate', 1)
                                                        TriggerClientEvent("RNG:PlaySound", source, "playMoney")
                                                    else
                                                        RNGclient.notify(source, {'You do not have enough money for this purchase.'})
                                                        TriggerClientEvent("RNG:PlaySound", source, 2)
                                                    end
                                                else
                                                    RNGclient.notify(source, {'~r~You do not have enough space in your inventory for this purchase.'})
                                                    TriggerClientEvent("RNG:PlaySound", source, 2)
                                                end
                                            end
                                        elseif purchasetype == 'ammo' then
                                            price = price/2
                                            if RNG.tryBankPayment(user_id,price) then
                                                if price > 0 then
                                                    RNGclient.notify(source, {"~g~Purchased 250x ammo for £".. getMoneyStringFormatted(price)})
                                                    if weaponshop == 'LargeArmsDealer' then
                                                        RNG.turfSaleToGangFunds(price, 'LargeArms')
                                                    end
                                                else
                                                    RNGclient.notify(source, {"~g~Purchased 250x Ammo"})
                                                end
                                                TriggerClientEvent("RNG:PlaySound", source, "playMoney")
                                                RNGclient.giveWeapons(source, {{[spawncode] = {ammo = 250}}, false})
                                            else
                                                RNGclient.notify(source, {'You do not have enough money for this purchase.'})
                                                TriggerClientEvent("RNG:PlaySound", source, 2)
                                            end
                                        end
                                    end
                                end
                            else
                                if weaponshop == 'policeLargeArms' or weaponshop == 'policeSmallArms' or weaponshop == 'nhsSmallArms' then
                                    RNGclient.notify(source, {"~r~You shouldn't be in here, ALARM TRIGGERED!!!"})
                                else
                                    RNGclient.notify(source, {"~r~You do not have permission to access this store."})
                                end
                            end
                        end
                    end
                end)
            end
        end
    end)
end)

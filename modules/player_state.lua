local cfg = module("cfg/player_state")
local a = module("rng-weapons", "cfg/weapons")
local purgecfg = module("cfg/cfg_purge")
local lang = RNG.lang

baseplayers = {}
proplist = {
    "prop_fire_hydrant_1",
    "prop_fire_hydrant_2",
    "prop_bin_01a",
    "prop_postbox_01a",
    "prop_phonebox_04",
    "prop_sign_road_03m",
    "prop_sign_road_05e",
    "prop_sign_road_03g",
    "prop_sign_road_04a",
    "prop_consign_01a",
    "prop_barrier_work01d",
    "prop_sign_road_05a",
    "prop_bin_05a",
    "prop_sign_road_05za",
    "prop_sign_road_02a",
    "prop_bin_05a",
    "prop_sign_road_01a",
    "prop_sign_road_03e",
    "prop_forsalejr1",
    "prop_letterbox_01",
    "prop_sign_road_03",
    "prop_parknmeter_02",
    "prop_rub_binbag_03d",
    "prop_elecbox_08",
    "prop_rub_binbag_04",
    "prop_rub_binbag_05",
    "prop_cratepile_03a",
    "prop_crate_01a",
    "prop_sign_road_07a",
    "prop_rub_trolley_01a",
    "prop_highway_paddle",
    "prop_barrier_work06a",
    "prop_cactus_01d",
    "prop_generator_03a",
    "prop_bin_06a",
    "prop_food_bs_juice03",
    "prop_bollard_02a",
    "prop_rub_cardpile_03",
    "prop_bin_07c",
    "prop_rub_cage01e",
    "prop_rub_cage01c",
    "prop_rub_binbag_03b",
    "prop_bin_08a",
    "prop_barrel_02a",
    "prop_rub_binbag_06",
    "prop_pot_plant_04b",
    "prop_rub_cage01a",
    "prop_rub_cage01c",
    "prop_bin_03a",
    "prop_afsign_amun",
    "prop_bin_07a",
    "prop_pallet_pile_01",
    "prop_shopsign_01",
    "prop_traffic_01a",
    "prop_rub_binbag_03",
    "prop_rub_boxpile_04",
}
AddEventHandler("RNG:playerSpawn", function(user_id, source, first_spawn)
    RNG.getFactionGroups(source)
    local data = RNG.getUserDataTable(user_id)
    local tmpdata = RNG.getUserTmpTable(user_id)
    local playername = RNG.getPlayerName(source)
    TriggerEvent("RNG:AddChatModes", source)
    if first_spawn then
        if data.customization == nil then
            data.customization = cfg.default_customization
        end
        if data.invcap == nil then
            data.invcap = 30
        end
        RNG.getSubscriptions(user_id, function(cb, plushours, plathours)
            if cb then
                if user_id == -1 then
                    data.invcap = 1000
                elseif plathours > 0 and data.invcap < 50 then
                    data.invcap = 50
                elseif plushours > 0 and data.invcap < 40 then
                    data.invcap = 40
                else
                    data.invcap = 30
                end
            end
        end)        
        if data.position == nil and cfg.spawn_enabled then
            local x = cfg.spawn_position[1] + math.random() * cfg.spawn_radius * 2 - cfg.spawn_radius
            local y = cfg.spawn_position[2] + math.random() * cfg.spawn_radius * 2 - cfg.spawn_radius
            local z = cfg.spawn_position[3] + math.random() * cfg.spawn_radius * 2 - cfg.spawn_radius
            data.position = {
                x = x,
                y = y,
                z = z
            }
        end
        if data.customization ~= nil then
            if RNG.isPurge() then
                TriggerClientEvent("RNG:purgeSpawnClient", source)
            else
                RNGclient.spawnAnim(source, {})
            end
            if data.weapons ~= nil then
                RNGclient.giveWeapons(source, {data.weapons, true})
            end
            RNGclient.setUserID(source, {user_id})
            RNGclient.setdecor(source, {decor, proplist})
            if RNG.hasGroup(user_id, 'Founder') or RNG.hasGroup(user_id, 'Developer') or RNG.hasGroup(user_id, 'Lead Developer') then
                TriggerClientEvent("RNG:SetDev", source)
            end
            if RNG.hasPermission(user_id, 'cardev.menu') then
                TriggerClientEvent('RNG:setCarDev', source)
            end
            if RNG.hasPermission(user_id, 'police.armoury') then
                RNGclient.setPolice(source, {true})
                TriggerClientEvent('RNG:globalOnPoliceDuty', source, true)
            end
            if RNG.hasPermission(user_id, 'nhs.menu') then
                RNGclient.setNHS(source, {true})
                TriggerClientEvent('RNG:globalOnNHSDuty', source, true)
            end
            if RNG.hasPermission(user_id, 'hmp.menu') then
                RNGclient.setHMP(source, {true})
                TriggerClientEvent('RNG:globalOnPrisonDuty', source, true)
            end
            if RNG.hasGroup(user_id, 'Taco Seller') then
                TriggerClientEvent('RNG:toggleTacoJob', source, true)
            end
            if RNG.hasGroup(user_id, 'Police Horse Trained') then
                RNGclient.setglobalHorseTrained(source, {})
            end
                
            local adminlevel = 0
            if RNG.hasGroup(user_id,"Founder") then
                adminlevel = 12
            elseif RNG.hasGroup(user_id,"Lead Developer") then
                adminlevel = 11
            elseif RNG.hasGroup(user_id,"Operations Manager") then
                adminlevel = 10
            elseif RNG.hasGroup(user_id,"Community Manager") then
                adminlevel = 9
            elseif RNG.hasGroup(user_id,"Staff Manager") then    
                adminlevel = 8
            elseif RNG.hasGroup(user_id,"Head Administrator") then
                adminlevel = 7
            elseif RNG.hasGroup(user_id,"Senior Administrator") then
                adminlevel = 6
            elseif RNG.hasGroup(user_id,"Administrator") then
                adminlevel = 5
            elseif RNG.hasGroup(user_id,"Senior Moderator") then
                adminlevel = 4
            elseif RNG.hasGroup(user_id,"Moderator") then
                adminlevel = 3
            elseif RNG.hasGroup(user_id,"Support Team") then
                adminlevel = 2
            elseif RNG.hasGroup(user_id,"Trial Staff") then
                adminlevel = 1
            end
            TriggerClientEvent("RNG:SetStaffLevel", source, adminlevel)
            GetProfiles(source)
            TriggerClientEvent('RNG:ForceRefreshData', -1)
            TriggerClientEvent('RNG:sendGarageSettings', source)
            players = RNG.getUsers({})
            for k,v in pairs(players) do
                baseplayers[v] = RNG.getUserId(v)
            end
            RNGclient.setBasePlayers(source, {baseplayers})
        else
            if data.weapons ~= nil then -- load saved weapons
                RNGclient.giveWeapons(source, {data.weapons, true})
            end

            if data.health ~= nil then
                RNGclient.setHealth(source, {data.health})
            end
        end

    else -- not first spawn (player died), don't load weapons, empty wallet, empty inventory
        RNG.clearInventory(user_id) 
        RNG.setMoney(user_id, 0)
        RNGclient.setHandcuffed(source, {false})

        if cfg.spawn_enabled then -- respawn (CREATED SPAWN_DEATH)
            local x = cfg.spawn_death[1] + math.random() * cfg.spawn_radius * 2 - cfg.spawn_radius
            local y = cfg.spawn_death[2] + math.random() * cfg.spawn_radius * 2 - cfg.spawn_radius
            local z = cfg.spawn_death[3] + math.random() * cfg.spawn_radius * 2 - cfg.spawn_radius
            data.position = {
                x = x,
                y = y,
                z = z
            }
        end
    end
end)
function RNG.setMoney(user_id,value)
    local tmp = RNG.getUserTmpTable(user_id)
    if tmp then
        tmp.wallet = value
    end

    local source = RNG.getUserSource(user_id)
    if source ~= nil then
        TriggerClientEvent('RNG:setDisplayMoney', source, tmp.wallet)
    end
end

RegisterServerEvent("RNG:updateWeapons")
AddEventHandler("RNG:updateWeapons", function(weapons, code)
    if code ~= decor then
        return
    end
    local user_id = RNG.getUserId(source)
    if user_id ~= nil then
        local data = RNG.getUserDataTable(user_id)
        if data ~= nil then
            data.weapons = weapons
        end
    end
end)


Citizen.CreateThread(function()
    while true do
        Wait(60000)
        for k, v in pairs(RNG.getUsers()) do
            local data = RNG.getUserDataTable(k)
            if data ~= nil then
                if data.PlayerTime ~= nil then
                    data.PlayerTime = tonumber(data.PlayerTime) + 1
                else
                    data.PlayerTime = 1
                end
            end
            if RNG.hasPermission(k, 'police.armoury') then
                local lastClockedRank = string.gsub(getGroupInGroups(k, 'Police'), ' Clocked', '')
                local user_id = k
                local username = RNG.getPlayerName(v)
                local hours = 1 / 60
                local last_clocked_rank = lastClockedRank
                local last_clocked_date = os.date("%d/%m/%Y")
                local total_hours = hours
                exports['rng']:execute("SELECT * FROM `rng_police_hours` WHERE user_id = @user_id", {user_id = user_id}, function(result)
                    if result ~= nil then 
                        for k,v in pairs(result) do
                            if v.user_id == user_id then
                                exports['rng']:execute("UPDATE rng_police_hours SET total_hours = @total_hours, last_clocked_rank = @last_clocked_rank, last_clocked_date = @last_clocked_date WHERE user_id = @user_id", {user_id = user_id, total_hours = v.total_hours + total_hours, last_clocked_rank = last_clocked_rank, last_clocked_date = last_clocked_date}, function() end)
                                return
                            end
                        end
                        exports['rng']:execute("INSERT INTO rng_police_hours (`user_id`, `total_hours`, `last_clocked_rank`, `last_clocked_date`, `username`) VALUES (@user_id, @total_hours, @last_clocked_rank, @last_clocked_date, @username);", {user_id = user_id, total_hours = total_hours, last_clocked_rank = last_clocked_rank, last_clocked_date = last_clocked_date, username = username}, function() end) 
                    end
                end)
            end
        end
    end
end)





function RNG.updateInvCap(user_id, invcap)
    if user_id ~= nil then
        local data = RNG.getUserDataTable(user_id)
        if data ~= nil then
            if data.invcap ~= nil then
                data.invcap = invcap
                if user_id == -1 then
                    data.invcap = 1000
                end
            else
                data.invcap = 30
            end
        end
    end
end


function RNG.setBucket(source, bucket)
    local source = source
    local user_id = RNG.getUserId(source)
    SetPlayerRoutingBucket(source, bucket)
    TriggerClientEvent('RNG:setBucket', source, bucket)
end

local isStoring = {}
AddEventHandler('RNG:StoreWeaponsRequest', function(source)
    local player = source 
    local user_id = RNG.getUserId(player)
	RNGclient.getWeapons(player,{},function(weapons)
        if not isStoring[player] then
            isStoring[player] = true
            RNGclient.giveWeapons(player,{{},true}, function(removedwep)
                for k,v in pairs(weapons) do
                    if k ~= 'GADGET_PARACHUTE' and k ~= 'WEAPON_STAFFGUN' and k~= 'WEAPON_SMOKEGRENADE' and k~= 'WEAPON_FLASHBANG' then
                        if v.ammo > 0 and k ~= 'WEAPON_STUNGUN' then
                            for i,c in pairs(a.weapons) do
                                if i == k then
                                    RNG.giveInventoryItem(user_id, "wbody|"..k, 1, true)
                                end   
                            end
                        end
                    end
                end
                RNGclient.notify(player,{"~g~Weapons Stored"})
                SetTimeout(3000,function()
                      isStoring[player] = nil 
                end)
            end)
        else
            RNGclient.notify(player,{"~o~Your weapons are already being stored hmm..."})
        end
    end)
end)

function RNG.isPurge()
    return purgecfg.active
end

RegisterServerEvent("RNG:RequestUserID")
AddEventHandler("RNG:RequestUserID", function()
    local source = source 
    local user_id = RNG.getUserId(source)
    TriggerClientEvent("RNG:receiveUserId", source, user_id)
end)

RegisterServerEvent("RNG:RequestUserHours")
AddEventHandler("RNG:RequestUserHours", function()
    local source = source 
    local hours = RNG.GetPlayTime(source)
    TriggerClientEvent("RNG:receiveUserHours", source, hours)
end)


RegisterNetEvent('RNG:forceStoreWeapons')
AddEventHandler('RNG:forceStoreWeapons', function()
    local source = source
    local user_id = RNG.getUserId(source)
    local data = RNG.getUserDataTable(user_id)
    Wait(3000)
    if data ~= nil then
        data.inventory = {}
    end
    RNG.getSubscriptions(user_id, function(cb, plushours, plathours)
        if cb then
            local invcap = 30
            if user_id == -1 then
                invcap = 1000
            elseif plathours > 0 then
                invcap = invcap + 20
            elseif plushours > 0 then
                invcap = invcap + 10
            end
            if invcap == 30 then
            return
            end
            if data.invcap - 15 == invcap then
            RNG.giveInventoryItem(user_id, "offwhitebag", 1, false)
            elseif data.invcap - 20 == invcap then
            RNG.giveInventoryItem(user_id, "guccibag", 1, false)
            elseif data.invcap - 30 == invcap  then
            RNG.giveInventoryItem(user_id, "nikebag", 1, false)
            elseif data.invcap - 35 == invcap  then
            RNG.giveInventoryItem(user_id, "huntingbackpack", 1, false)
            elseif data.invcap - 40 == invcap  then
            RNG.giveInventoryItem(user_id, "greenhikingbackpack", 1, false)
            elseif data.invcap - 70 == invcap  then
            RNG.giveInventoryItem(user_id, "rebelbackpack", 1, false)
            end
            RNG.updateInvCap(user_id, invcap)
        end
    end)
end)



RegisterServerEvent("RNG:AddChatModes", function(source)
    local source = source
    local user_id = RNG.getUserId(source)
    
    local main = {
        name = "Global",
        displayName = "Global",
        isChannel = "Global",
        isGlobal = true,
        color = "#3486eb",
    }
    
    local ooc = {
        name = "OOC",
        displayName = "OOC",
        isChannel = "OOC",
        isGlobal = false,
        color = "#3486eb",
    }

    TriggerClientEvent('chat:addMode', source, main)
    TriggerClientEvent('chat:addMode', source, ooc)
end)

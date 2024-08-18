local weaponsConfig = module("rng-weapons", "cfg/weapons").weapons
local i = false
local scriptDebug = true
local Anticheat = {}
local anticheatTypes = {
    {type = 1, desc = "Noclip"},
    {type = 2, desc = "Spawning of Weapon(s)"},
    {type = 3, desc = "Explosion Event"},
    {type = 4, desc = "Blacklisted Event"},
    {type = 5, desc = "Removal of Weapon(s)"},
    {type = 6, desc = "Semi Godmode"},
    {type = 7, desc = "Mod Menu"},
    {type = 8, desc = "Weapon Modifier"},
    {type = 9, desc = "Armour Modifier"},
    {type = 10, desc = "Health Modifier"},
    {type = 11, desc = "Server Trigger"},
    {type = 12, desc = "Vehicle Modifications"},
    {type = 13, desc = "Night Vision"},
    {type = 14, desc = "Model Dimensions"},
    {type = 15, desc = "Godmoding"},
    {type = 16, desc = "Failed Keep Alive (els)"},
    {type = 17, desc = "Spawned Ammo"},
    {type = 18, desc = "Resource Stopper"},
    {type = 19, desc = "Infinite Combat Roll"},
    {type = 20, desc = "Spawning of Weapon(s)"},
    {type = 21, desc = "Teleport to Waypoint"},
    {type = 22, desc = "Vehicle Repair"},
    {type = 23, desc = "Spectate"},
    {type = 24, desc = "Freecam"},
    {type = 25, desc = "Warping into Vehicle"},
    {type = 26, desc = "NUI Tools"},
    {type = 27, desc = "Invisible"},
    {type = 28, desc = "Fast Run"},
    {type = 29, desc = "Eulen Found"},
    {type = 30, desc = "Server Triggers"}
}

local blacklistedProps = {
    'prop_cs_dildo_01',
    'prop_speaker_05',
    'prop_speaker_01',
    'prop_speaker_03',
    'surano',
    'ar_prop_ar_bblock_huge_01',
    'dt1_05_build1_damage',
    'prop_juicestand',
    'prop_knife',
    'p_bloodsplat_s',
    'p_spinning_anus_s',
    'dt1_lod_slod3',
    'prop_xmas_tree_int',
    'prop_cs_cardbox_01',
    'prop_alien_egg_01',
    'prop_tv_03',
    'prop_beach_fire',
    'prop_windmill_01_l1',
    'stt_prop_stunt_track_start',
    'stt_prop_stunt_track_start_02',
    'apa_prop_flag_mexico_yt',
    'apa_prop_flag_us_yt',
    'apa_prop_flag_uk_yt',
    'prop_jetski_ramp_01',
    'prop_const_fence03b_cr',
    'prop_fnclink_03gate5',
    'ind_prop_firework_03',
    'prop_weed_01',
    'prop_weed_01',
    'xs_prop_hamburgher_wl',
    'prop_container_01a',
    'prop_contnr_pile_01a',
    'ce_xr_ctr2',
    'stt_prop_ramp_jump_xxl',
    'hei_prop_carrier_jet',
    'prop_parking_hut_2',
    'csx_seabed_rock3_',
    'db_apart_03_',
    'db_apart_09_',
    'stt_prop_stunt_tube_l',
    'stt_prop_stunt_track_dwuturn',
    'sr_prop_spec_tube_xxs_01a',
    'prop_air_bigradar',
    'p_tram_crash_s',
    'prop_fnclink_03a',
    'prop_fnclink_05crnr1',
    'xs_prop_plastic_bottle_wl',
    'prop_windmill_01',
    'prop_gold_cont_01',
    'p_cablecar_s',
    'stt_prop_stunt_tube_l',
    'stt_prop_stunt_track_dwuturn',
    'prop_ld_ferris_wheel',
    'prop_ferris_car_01',
    'p_ferris_car_01',
    'stt_prop_ramp_spiral_l',
    'stt_prop_ramp_spiral_l_l',
    'stt_prop_ramp_multi_loop_rb',
    'stt_prop_ramp_spiral_l_xxl',
    'stt_prop_ramp_spiral_xxl',
    'stt_prop_stunt_bblock_huge_01',
    'stt_prop_stunt_bblock_huge_02',
    'stt_prop_stunt_bblock_huge_03',
    'stt_prop_stunt_bblock_huge_04',
    'stt_prop_stunt_bblock_huge_05',
    'stt_prop_stunt_bblock_hump_01',
    'stt_prop_stunt_bblock_qp',
    'stt_prop_stunt_bblock_qp2',
    'stt_prop_stunt_jump_loop',
    'stt_prop_stunt_landing_zone_01',
    'stt_prop_stunt_track_dwslope45',
    'stt_prop_stunt_track_dwturn',
    'stt_prop_stunt_track_dwslope30',
    'stt_prop_stunt_track_dwsh15',
    'stt_prop_stunt_track_dwshort',
    'stt_prop_stunt_track_dwslope15',
    'stt_prop_stunt_track_dwuturn',
    'stt_prop_stunt_track_exshort',
    'stt_prop_stunt_track_fork',
    'stt_prop_stunt_track_funlng',
    'stt_prop_stunt_track_funnel',
    'stt_prop_stunt_track_hill',
    'stt_prop_stunt_track_slope15',
    'stt_prop_stunt_track_slope30',
    'stt_prop_stunt_track_slope45',
    'prop_gas_pump_1a',
    'prop_gas_pump_1b',
    'prop_gas_pump_1c',
    'prop_gas_pump_1d',
    'prop_rock_1_a',
    'prop_vintage_pump',
    'prop_gas_pump_old2',
    'prop_gas_pump_old3',
    'apa_mp_h_acc_box_trinket_01',
    'prop_roundbailer02',
    'prop_roundbailer01',
    'prop_container_05a',
    'stt_prop_stunt_bowling_ball',
    'apa_mp_h_acc_rugwoolm_03',
    'prop_container_ld2',
    'p_ld_stinger_s',
    'hei_prop_carrier_cargo_02a',
    'p_cablecar_s',
    'p_ferris_car_01',
    'prop_rock_4_big2',
    'prop_steps_big_01',
    'v_ilev_lest_bigscreen',
    'prop_carcreeper',
    'apa_mp_h_bed_double_09',
    'apa_mp_h_bed_wide_05',
    'prop_cattlecrush',
    'prop_cs_documents_01',
    'prop_construcionlamp_01',
    'prop_fncconstruc_01d',
    'prop_fncconstruc_02a',
    'p_dock_crane_cabl_s',
    'prop_dock_crane_01',
    'prop_dock_crane_02_cab',
    'prop_dock_float_1',
    'prop_dock_crane_lift',
    'apa_mp_h_bed_wide_05',
    'apa_mp_h_bed_double_08',
    'apa_mp_h_bed_double_09',
    'csx_seabed_bldr4_',
    'imp_prop_impexp_sofabed_01a',
    'apa_mp_h_yacht_bed_01',
    'cs4_lod_04_slod2',
    'dt1_05_build1_damage',
    'po1_lod_slod4',
    'id2_lod_slod4',
    'ap1_lod_slod4',
    'sm_lod_slod2_22',
    'prop_ld_ferris_wheel',
    'prop_container_05a',
    'prop_gas_tank_01a',
    'p_crahsed_heli_s',
    'prop_gas_pump_1d',
    'prop_gas_pump_1a',
    'prop_gas_pump_1b',
    'prop_gas_pump_1c',
    'prop_vintage_pump',
    'prop_gas_pump_old2',
    'prop_gas_pump_old3',
    'prop_gascyl_01a',
    'prop_ld_toilet_01',
    'prop_ld_bomb_anim',
    'prop_ld_farm_couch01',
    'prop_beachflag_le',
    'stt_prop_stunt_track_uturn',
    'stt_prop_stunt_track_turnice',
    'cargoplane',
    'prop_beach_fire',
    'xs_prop_hamburgher_wl',
    'prop_fnclink_05crnr1',
    -1207431159,
    -145066854,
    'stt_prop_stunt_soccer_ball',
    'sr_prop_spec_tube_xxs_01a'
}

local o = {
    "esx:getSharedObject",
    "bank:transfer",
    "esx_ambulancejob:revive",
    "esx-qalle-jail:openJailMenu",
    "esx_jailer:wysylandoo",
    "esx_policejob:getarrested",
    "esx_society:openBossMenu",
    "esx:spawnVehicle",
    "esx_status:set",
    "HCheat:TempDisableDetection",
    "UnJP",
    "8321hiue89js",
    "adminmenu:allowall",
    "AdminMenu:giveBank",
    "AdminMenu:giveCash",
    "AdminMenu:giveDirtyMoney",
    "Tem2LPs5Para5dCyjuHm87y2catFkMpV"
}

for p, q in ipairs(o) do
    RegisterNetEvent(q)
    AddEventHandler(q,function()
        local userSource = source
        local UserID = RNG.getUserId(userSource)
        local playerName = GetPlayerName(userSource)
        Wait(500)
        TriggerEvent("RNG:anticheatBan", UserID, 4, playerName, userSource)
    end)
end

AddEventHandler("entityCreated", function(createdEntity)
    if DoesEntityExist(createdEntity) then
        local entityOwner = NetworkGetEntityOwner(createdEntity)
        if blacklistedProps[createdEntity] then
            DeleteEntity(createdEntity)
        end
    end
end)

for _, acType in ipairs(anticheatTypes) do
    RegisterServerEvent("RNG:acType"..acType.type)
    AddEventHandler("RNG:acType"..acType.type, function()
        local userSource = source
        local UserID = RNG.getUserId(userSource)
        local playerName = GetPlayerName(userSource)
        
        if acType.type == 1 and not table.includes(carrying, userSource) then
            TriggerEvent("RNG:anticheatBan", UserID, acType.type, playerName, userSource)
        else
            TriggerEvent("RNG:anticheatBan", UserID, acType.type, playerName, userSource)
        end
    end)
end

function table.includes(table, f)
    for g, h in pairs(table) do
        if h == f then
            return true
        end
    end
    return false
end

function RNG.isSpectatingEvent()
    return i
end

AddEventHandler("entityCreated", function(entity)
    local source = NetworkGetEntityOwner(entity)
    if DoesEntityExist(entity) and blacklistedProps[entity] then
        DeleteEntity(entity)
    end
end)

-- Events

RegisterServerEvent("RNG:AntiCheatVehicle")
AddEventHandler("RNG:AntiCheatVehicle", function(vehicle)
    local userSource = source
    local UserID = RNG.getUserId(userSource)
    local playerName = GetPlayerName(userSource)
    TriggerClientEvent("RNG:takeClientScreenshotAndUpload", userSource, RNG.getWebhook("anticheat"))
    Wait(2000)
    RNG.sendWebhook("anticheat","Anticheat Log","> Players Name: **" .. playerName .. "**\n> Players Perm ID: **" .. UserID .. "**\n> Spawned Vehicle: **" .. vehicle .. "**")
end)

AddEventHandler("clearPedTasksEvent",function(userSource)
    local userSource = source
    local UserID = RNG.getUserId(userSource)
    local entity = NetworkGetEntityFromNetworkId(userSource)
    if DoesEntityExist(entity) then
        if NetworkGetEntityOwner(entity) ~= userSource then
            CancelEvent()
            local playerName = GetPlayerName(userSource)
            Wait(500)
            TriggerEvent("RNG:anticheatBan", UserID, 25, playerName, userSource)
        end
    end
end)

local blacklistedExplosions = {1, 2, 5, 32, 33, 35, 35, 36, 37, 38, 45}
AddEventHandler("explosionEvent",function(userSource, l)
    local userSource = source
    local UserID = RNG.getUserId(userSource)
    local playerName = GetPlayerName(userSource)
    for m, n in ipairs(blacklistedExplosions) do
        if l.explosionType == n then
            l.damagescale = 0.0
            CancelEvent()
            Wait(500)
            TriggerEvent("RNG:anticheatBan", UserID, 3, playerName, userSource)
        end
    end
end)

AddEventHandler("removeWeaponEvent",function(r, s)
    CancelEvent()
    local userSource = r
    local UserID = RNG.getUserId(userSource)
    local playerName = GetPlayerName(userSource)
    Wait(500)
    TriggerEvent("RNG:anticheatBan", UserID, 5, playerName, userSource)
end)

RegisterServerEvent("RNG:AnticheatFlag", function(reason)
    local source = source 
    local user_id = RNG.getUserId(source)
    local playerName = RNG.getPlayerName(source)
    TriggerClientEvent("RNG:takeClientVideoAndUpload", user_id, RNG.getWebhook("anticheat"))
    RNG.sendWebhook("anticheat", "Anticheat Flag", "> Players Name: **" .. playerName .. "**\n> Players Perm ID: **" .. user_id .. "**\n> Reason: **" .. reason .. "**")
end)

RegisterServerEvent("RNG:getAnticheatData")
AddEventHandler("RNG:getAnticheatData",function()
    local source = source
    user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, 'admin.managecommunitypot') then
        local bannedplayerstable = {}
        exports['rng']:execute("SELECT * FROM `rng_anticheat`", {}, function(result)
            if result ~= nil then
                for k,v in pairs(result) do
                    bannedplayerstable[v.user_id] = {v.ban_id, v.user_id, v.username, v.reason, v.extra}
                end 
                adminname = GetPlayerName(source)
                TriggerClientEvent("RNG:sendAnticheatData", source, adminname, #result, bannedplayerstable, anticheatTypes)
            end
        end)
    end
end)

AddEventHandler("giveWeaponEvent",function(userSource)
    CancelEvent()
    local userSource = source
    local UserID = RNG.getUserId(userSource)
    local playerName = GetPlayerName(userSource)
    Wait(500)
    TriggerEvent("RNG:anticheatBan", UserID, 2, playerName, userSource)
end)

AddEventHandler("loadModel",function(userSource)
    CancelEvent()
    local userSource = source
    local UserID = RNG.getUserId(userSource)
    local playerName = GetPlayerName(userSource)
    Wait(500)
    TriggerEvent("RNG:anticheatBan", UserID, 5, playerName, userSource)
end)

AddEventHandler("spawnVehicle",function(userSource)
    CancelEvent()
    local userSource = source
    local UserID = RNG.getUserId(userSource)
    local playerName = GetPlayerName(userSource)
    Wait(500)
    TriggerEvent("RNG:anticheatBan", UserID, 5, playerName, userSource)
end)

AddEventHandler("GetAmmoInPedWeapon",function(userSource)
    CancelEvent()
    local userSource = source
    local UserID = RNG.getUserId(userSource)
    local playerName = GetPlayerName(userSource)
    Wait(500)
    TriggerEvent("RNG:anticheatBan", UserID, 5, playerName, userSource)
end)

AddEventHandler("removeAllWeaponsEvent",function(userSource)
    CancelEvent()
    local userSource = source
    local UserID = RNG.getUserId(userSource)
    local playerName = GetPlayerName(userSource)
    Wait(500)
    TriggerEvent("RNG:anticheatBan", UserID, 5, playerName, userSource)
end)

RegisterServerEvent("RNG:sendVelocityLimit")
AddEventHandler("RNG:sendVelocityLimit",function(x, y)
    local userSource = source
    local UserID = RNG.getUserId(userSource)
    local playerName = GetPlayerName(userSource)
    
    if #(x - vector3(196.2459, 7397.2084, 14.4977)) < 150.0 or #(y - vector3(196.2459, 7397.2084, 14.4977)) < 150.0 or RNG.hasPermission(UserID, "admin.tickets") then
        return
    end
    TriggerEvent("RNG:anticheatBan", UserID, 21, playerName, userSource)
end)

RegisterServerEvent("RNG:sendVehicleStats",function(Afterbodyhealth,previousbodyhealth,Afterenginehealth,previousenginehealth,Afterpetroltankhealth,previouspetroltankhealth,Afterentityhealth,previousentityhealth,passangers,vehiclehash)
    local userSource = source
    local UserID = RNG.getUserId(userSource)
    local playerName = GetPlayerName(userSource)
    TriggerEvent("RNG:anticheatBan", UserID, 22, playerName, userSource, "**\n> Spawn Code: **"..vehiclehash.."**\n> Body Health: **"..previousbodyhealth.."**\n> Engine Health: **"..previousenginehealth.."**\n> Petrol Tank Health: **"..previouspetroltankhealth.."**\n> Entity Health: **"..previousentityhealth.."**\n> After Body Health: **"..Afterbodyhealth.."**\n> After Engine Health: **"..Afterenginehealth.."**\n> After Petrol Tank Health: **"..Afterpetroltankhealth.."**\n> After Entity Health: **"..Afterentityhealth.."****")
end)

RegisterServerEvent("RNG:checkid")
AddEventHandler("RNG:checkid", function(playerID)
    if playerID == 0 then
        return
    end
    local userSource = source
    local UserID = RNG.getUserId(userSource)
    local playerName = GetPlayerName(userSource)
    if kvp == 0 then
        return
    end
    if UserID ~= playerID then
        RNG.sendWebhook("multi-account","Multi Account Logs","> Player Name: **"..playerName.."**\n> Player Current Perm ID: **" .. UserID .. "**\n> Player Other Perm ID: **" .. playerID .. "**")
    end
    RNG.isBanned(playerID, function(R)
        if R then
            RNG.banConsole(UserID, "perm", "1.11 Ban Evading")
            RNG.sendWebhook("ban-evaders","Ban Evade Logs","> Player Name: **"..playerName.."**\n> Player Current Perm ID: **" .. UserID .. "**\n> Player Banned Perm ID: **" .. playerID .. "**")
        end
    end)
end)

-- Ban Event

RegisterServerEvent("RNG:anticheatBan")
AddEventHandler("RNG:anticheatBan", function(UserID, banType, playerName, userSource, extraInfo)
    if UserID == 1 then
        print("UserID 1 Cannot be banned")
        return
    end
    if extraInfo == nil then
        extraInfo = "N/A"
    end
    if not b then
        for _, acType in ipairs(anticheatTypes) do
            if banType == acType.type then
                if scriptDebug then
                    TriggerClientEvent("chatMessage", -1, "^7^*[RNG Anticheat]", {255, 255, 255}, playerName .. " ^7 Was Banned | Reason: Cheating ^3Type #"..banType, "alert")
                    print("Ban Type: " .. banType, "Name: " .. playerName, "Extra: " .. extraInfo)
                    return
                end
                local banDesc = acType.desc
                print("Ban Type: " .. banType, "Name: " .. playerName, "Extra: " .. extraInfo)
                b = true
                TriggerClientEvent("RNG:takeClientScreenshotAndUpload", userSource, RNG.getWebhook("anticheat"))
                Wait(2000)
                b = false
                RNG.sendWebhook("anticheat", "Anticheat Ban", "> Players Name: **" .. playerName .. "**\n> Players Perm ID: **" .. UserID .. "**\n> Reason: **" .. banDesc .. "**")
                TriggerClientEvent("chatMessage", -1, "^7^*[RNG Anticheat]", {255, 255, 255}, playerName .. " ^7 Was Banned | Reason: Cheating " .. banDesc, "alert")
                RNG.banConsole(UserID, "perm", "Cheating "..banDesc)
                exports["rng"]:execute("INSERT INTO `rng_anticheat` (user_id, username, reason) VALUES (@user_id, @username, @reason);", {user_id = UserID, username = playerName, reason = banDesc})
            end
        end
    end
end)

Citizen.CreateThread(function()
    Wait(2500)
    exports["rng"]:execute([[
        CREATE TABLE IF NOT EXISTS `rng_anticheat` (
            `ban_id` INT AUTO_INCREMENT PRIMARY KEY,
            `user_id` INT NOT NULL,
            `username` VARCHAR(100) NOT NULL,
            `reason` VARCHAR(100) NOT NULL,
            `extra` VARCHAR(100) NOT NULL
        )
    ]])
end)
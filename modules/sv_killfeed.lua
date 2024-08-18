local f = module("rng-weapons", "cfg/weapons")
local activeEvent = false
f = f.weapons
illegalWeapons = f.nativeWeaponModelsToNames

local function getWeaponName(weapon)
    for k,v in pairs(f) do
        if weapon == 'Mosin Nagant' then
            return 'mosin'
        elseif weapon == 'Nerf Mosin' then
            return 'Heavy'
        elseif weapon == 'CB Mosin' then
            return 'Heavy'
        elseif weapon == 'Fists' then
            return 'Fist'
        elseif weapon == 'Fire' then
            return 'Fire'
        elseif weapon == 'Explosion' then
            return 'Explode'
        elseif weapon == 'Suicide' then
            return 'Suicide'
        end
        if v.name == weapon then
            return v.class
        end
    end
    return "Unknown"
end

local function getweaponnames(weapon)
    for k,v in pairs(f) do
        if v.name == weapon then
            return v.name
        end
    end
    return "Unknown"
end

RegisterNetEvent('RNG:onPlayerKilled')
AddEventHandler('RNG:onPlayerKilled', function(killtype, killer, weaponhash, suicide, distance, headshotKill)
    local source = source
    local killergroup = 'none'
    local killedgroup = 'none'
    local killer_id = RNG.getUserId(killer)
    if distance ~= nil then
        distance = math.floor(distance)
    end

    if killtype == 'killed' then
        if RNG.hasPermission(RNG.getUserId(source), 'police.armoury') then
            killedgroup = 'police'
        elseif RNG.hasPermission(RNG.getUserId(source), 'nhs.menu') then
            killedgroup = 'nhs'
        end

        if RNG.hasPermission(RNG.getUserId(killer), 'police.armoury') then
            killergroup = 'police'
        elseif RNG.hasPermission(RNG.getUserId(killer), 'nhs.menu') then
            killergroup = 'nhs'
        end
        if killer ~= nil then
            if killer ~= source then
                TriggerClientEvent('RNG:newKillFeed', -1, RNG.getPlayerName(killer), RNG.getPlayerName(source), getWeaponName(weaponhash), suicide, distance, killedgroup, killergroup, headshotKill)
                TriggerClientEvent('RNG:deathSound', -1, GetEntityCoords(GetPlayerPed(source)))
                if RNG.isPurge() then
                    TriggerEvent("RNG:AddKill", killer_id)
                end
                if not RNG.hasPermission(killer_id,"police.armoury") and not RNGclient.isStaffedOn(killer) and not RNG.isDeveloper(killer_id) then
                    RNGclient.getPlayerCombatTimer(killer,{},function(timer)
                        if timer < 57 then
                            TriggerClientEvent("RNG:takeClientScreenshotAndUpload", killer, RNG.getWebhook("trigger-bot"))
                            Citizen.Wait(1500)
                            RNG.sendWebhook("trigger-bot", "RNG Trigger Bot Logs", "> Player Name: **"..RNG.getPlayerName(killer).."**\n> Player User ID: **"..RNG.getUserId(killer).."**")
                        end
                    end)
                end
                if not RNG.isPurge() then
                    if not gettingVideo then
                        gettingVideo = true
                        TriggerClientEvent("RNG:takeClientVideoAndUpload", killer, RNG.getWebhook('killvideo'))
                        gettingVideo = false
                        Wait(19000)
                    end
                end
                if RNG.getPlayerName(killer) and RNG.getPlayerName(source) and RNG.getUserId(killer) and RNG.getUserId(source) and getweaponnames(weaponhash) and distance then
                    local headshotText = headshotKill and "Yes" or "No"
                    RNG.sendWebhook('kills', "RNG Kill Logs",
                        "> Killer Name: **"..RNG.getPlayerName(killer).."**\n" ..
                        "> Killer ID: **"..RNG.getUserId(killer).."**\n" ..
                        "> Weapon: **"..getweaponnames(weaponhash).."**\n" ..
                        "> Victim Name: **"..RNG.getPlayerName(source).."**\n" ..
                        "> Victim ID: **"..RNG.getUserId(source).."**\n" ..
                        "> Distance: **"..distance.."m**\n" ..
                        "> Headshot Kill: **"..headshotText.."**")                
                end
            end
        end
        TriggerClientEvent('RNG:newKillFeed', -1, RNG.getPlayerName(source), RNG.getPlayerName(source), 'suicide', suicide, distance, killedgroup, killergroup)
        TriggerClientEvent('RNG:deathSound', -1, GetEntityCoords(GetPlayerPed(source)))
    end
end)

AddEventHandler('weaponDamageEvent', function(sender, ev)
    local user_id = RNG.getUserId(sender)
    local name = RNG.getPlayerName(sender)
    if ev.weaponDamage ~= 0 then
        if ev.weaponType == 911657153 and not RNG.hasPermission(user_id, 'police.armoury') or ev.weaponType == 3452007600 then
            TriggerEvent("RNG:acBan", user_id, 8, name, sender, "Using a weapon that is not allowed")
        end
        RNG.sendWebhook('damage', "RNG Damage Logs", "> Player Name: **"..name.."**\n> Player Temp ID: **"..sender.."**\n> Player Perm ID: **"..user_id.."**\n> Damage: **"..ev.weaponDamage.."**\n> Weapon : **"..getweaponnames(ev.weaponType).."**")
    end
end)

Citizen.CreateThread(function()
    Wait(2500)
    exports['rng']:execute([[
        CREATE TABLE IF NOT EXISTS `rng_stats` (
            `user_id` int(11) NOT NULL AUTO_INCREMENT,
            `kills` int(11) NOT NULL,
            `deaths` int(11) NOT NULL,
            PRIMARY KEY (`user_id`)
        );
    ]])
end)
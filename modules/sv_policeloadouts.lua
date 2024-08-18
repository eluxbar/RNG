loadouts = {
    ['Basic'] = {
        permission = "police.armoury",
        weapons = {
            "WEAPON_NIGHTSTICK",
            "WEAPON_STUNGUN",
            "WEAPON_FLASHLIGHT",
            "WEAPON_PDGLOCK",
        },
    },
    ['SCO-19'] = {
        permission = "police.loadshop2",
        weapons = {
            "WEAPON_NIGHTSTICK",
            "WEAPON_STUNGUN",
            "WEAPON_FLASHLIGHT",
            "WEAPON_PDGLOCK",
            "WEAPON_G36K",
        },
    },
    ['CTSFO'] = {
        permission = "police.maxarmour",
        weapons = {
            "WEAPON_NIGHTSTICK",
            "WEAPON_STUNGUN",
            "WEAPON_FLASHLIGHT",
            "WEAPON_PDGLOCK",
            "WEAPON_SPAR17",
            "WEAPON_REMINGTON700",
            "WEAPON_FLASHBANG",
        },
    },
    ['Gold Command'] = {
        permission = "police.gc",
        weapons = {
            "WEAPON_NIGHTSTICK",
            "WEAPON_STUNGUN",
            "WEAPON_FLASHLIGHT",
            "WEAPON_PDGLOCK",
            "WEAPON_NOVESKENSR9",
            "WEAPON_AX50",
            "WEAPON_FLASHBANG",
        },
    },
}


RegisterNetEvent('RNG:getPoliceLoadouts')
AddEventHandler('RNG:getPoliceLoadouts', function()
    local source = source
    local user_id = RNG.getUserId(source)
    local loadoutsTable = {}
    if RNG.hasPermission(user_id, 'police.armoury') then
        for k,v in pairs(loadouts) do
            v.hasPermission = RNG.hasPermission(user_id, v.permission) 
            loadoutsTable[k] = v
        end
        TriggerClientEvent('RNG:gotLoadouts', source, loadoutsTable)
    end
end)

RegisterNetEvent('RNG:selectLoadout')
AddEventHandler('RNG:selectLoadout', function(loadout)
    local source = source
    local user_id = RNG.getUserId(source)
    local name = RNG.getPlayerName(source)
    local weaponsString = ""

    for k, v in pairs(loadouts) do
        if k == loadout then
            if RNG.hasPermission(user_id, 'police.armoury') and RNG.hasPermission(user_id, v.permission) then
                for a, b in pairs(v.weapons) do
                    RNGclient.giveWeapons(source, { { [b] = { ammo = 250 } }, false })
                    RNGclient.setArmour(source, { 100, true })
                    weaponsString = weaponsString .. b .. ", "
                end
                weaponsString = weaponsString:sub(1, -3)
                RNGclient.notify(source, {"~g~Received " .. loadout .. " loadout."})
                RNG.sendWebhook("pd-loadout", "RNG PD Loadout Log", "> Players Name: **" .. name .. "**\n> Players Perm ID: **" .. user_id .. "**\n> Loadout Taken: **" .. loadout .. "**\n> Weapons/Items: **" .. weaponsString .. "**")
            else
                RNGclient.notify(source, {"~r~You do not have permission to select this loadout"})
            end
        end
    end
end)

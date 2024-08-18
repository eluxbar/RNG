local a = module("rng-weapons", "cfg/weapons")
local b = false
local c
local d
local e = {name = "", price = "", model = "", priceString = "", ammoPrice = "", weaponShop = ""}
local f
local g
local h = ""
local i = false
local j = {
    ["Legion"] = {
        _config = {
            {
                vector3(-3171.5241699219, 1087.5402832031, 19.838747024536),
                vector3(-330.56484985352, 6083.6059570312, 30.454759597778)
            },
            154,
            1,
            "B&Q Tool Shop",
            {""},
            true
        }
    },
    ["SmallArmsDealer"] = {
        _config = {
            {
                vector3(2437.5708007813, 4966.5610351563, 41.34761428833),
                vector3(-1500.4978027344, -216.72758483887, 46.889373779297),
                vector3(1243.0490722656, -427.33932495117, 67.918403625488)
            },
            110,
            1,
            "Small Arms Dealer",
            {""},
            true
        }
    },
    ["LargeArmsDealer"] = {
        _config = {
            {
                vector3(-1109.4371337891,4934.2856445312,218.35498046875),
                vector3(5065.6201171875, -4591.3857421875, 1.8652405738831)
            },
            110,
            1,
            "Large Arms Dealer",
            {"gang.whitelisted"},
            false
        }
    },
    ["VIP"] = {
        _config = {
            {vector3(-2151.7707519531,5191.3090820312,14.748822479248)},
            110,
            5,
            "VIP Gun Store",
            {"vip.gunstore"},
            true
        }
    },
    ["Rebel"] = {
        _config = {
            {
                vector3(1545.2521972656, 6331.5615234375, 23.07857131958),
                vector3(4925.6259765625, -5243.0908203125, 1.524599313736)
            },
            110,
            5,
            "Rebel Gun Store",
            {"rebellicense.whitelisted"},
            true
        }
    },
    ["nhsSmallArms"] = {
        _config = {
            {vector3(304.52716064453,-600.37548828125,42.284084320068)},
            110,5,"NHS Combat Medic Small Arms",{"nhs.combatmedic"},false,true
        }
    },
    ["policeSmallArms"] = {
        _config = {
            {
                vector3(461.53082275391, -979.35876464844, 29.689668655396),
                vector3(1842.9096679688, 3690.7692871094, 33.267082214355),
                vector3(-443.00482177734, 5987.939453125, 31.716201782227),
                vector3(638.55255126953, 2.7499871253967, 43.423725128174),
                vector3(-1104.5264892578, -821.70153808594, 13.282785415649)
            },
            110,
            5,
            "MET Police Small Arms",
            {"police.armoury"},
            false,
            true
        }
    },
    ["policeLargeArms"] = {
        _config = {
            {
                vector3(1840.6104736328, 3691.4741210938, 33.350730895996),
                vector3(461.43179321289, -982.66412353516, 29.689668655396),
                vector3(-441.43609619141, 5986.4052734375, 31.716201782227),
                vector3(640.8759765625, -0.63530212640762, 43.423385620117),
                vector3(-1102.5059814453, -820.62091064453, 13.282785415649)
            },
            110,
            5,
            "MET Police Large Arms",
            {"police.loadshop2", "police.armoury"},
            false,
            true
        }
    },
    ["prisonArmoury"] = {
        _config = {
            {vector3(1779.3741455078, 2542.5639648438, 45.797782897949)},
            110,
            5,
            "Prison Armoury",
            {"hmp.menu"},
            false,
            true
        }
    }
}
RMenu.Add(
    "RNGGunstore",
    "mainmenu",
    RageUI.CreateMenu("", "", tRNG.getRageUIMenuWidth(), tRNG.getRageUIMenuHeight(), "menus", "gunstore")
)
RMenu:Get("RNGGunstore", "mainmenu"):SetSubtitle("GUNSTORE")
RMenu.Add(
    "RNGGunstore",
    "type",
    RageUI.CreateSubMenu(
        RMenu:Get("RNGGunstore", "mainmenu"),
        "",
        "Purchase Weapon or Ammo",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight(),
        "menus",
        "gunstore"
    )
)
RMenu.Add(
    "RNGGunstore",
    "confirm",
    RageUI.CreateSubMenu(
        RMenu:Get("RNGGunstore", "type"),
        "",
        "Purchase confirm your purchase",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight(),
        "menus",
        "gunstore"
    )
)
RMenu.Add(
    "RNGGunstore",
    "vip",
    RageUI.CreateSubMenu(
        RMenu:Get("RNGGunstore", "mainmenu"),
        "",
        "Purchase Weapon or Ammo",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight(),
        "menus",
        "gunstore"
    )
)
RageUI.CreateWhile(
    1.0,
    true,
    function()
        if RageUI.Visible(RMenu:Get("RNGGunstore", "mainmenu")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = true},
                function()
                    i = false
                    if c ~= nil and j ~= nil then
                        if tRNG.isPlatClub() then
                            if c == "VIP" then
                                RageUI.ButtonWithStyle(
                                    "~y~[Platinum Large Arms]",
                                    "",
                                    {RightLabel = "→→→"},
                                    true,
                                    function(k, l, m)
                                    end,
                                    RMenu:Get("RNGGunstore", "vip")
                                )
                            end
                        end
                        for n, o in pairs(j) do
                            if c == n then
                                for p, q in pairs(sortedKeys(o)) do
                                    local r = o[q]
                                    if q ~= "_config" then
                                        local s, t, u = table.unpack(r)
                                        local v = false
                                        local w
                                        if q == "item|fillUpArmour" then
                                            local x = GetPedArmour(tRNG.getPlayerPed())
                                            local y = 100 - x
                                            w = y * 1000
                                            v = true
                                        end
                                        local z = ""
                                        if v then
                                            z = tostring(getMoneyStringFormatted(w))
                                        else
                                            z = tostring(getMoneyStringFormatted(t))
                                        end
                                        RageUI.ButtonWithStyle(
                                            s,
                                            "£" .. z,
                                            {RightLabel = "→→→"},
                                            true,
                                            function(k, l, m)
                                                if k then
                                                end
                                                if l then
                                                    f = q
                                                end
                                                if m then
                                                    e.name = s
                                                    e.priceString = z
                                                    e.model = q
                                                    e.price = t
                                                    e.ammoPrice = u
                                                    e.weaponShop = n
                                                end
                                            end,
                                            RMenu:Get("RNGGunstore", "type")
                                        )
                                    end
                                end
                            end
                        end
                    end
                end
            )
        end
        if RageUI.Visible(RMenu:Get("RNGGunstore", "type")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = true},
                function()
                    RageUI.ButtonWithStyle("Purchase Weapon Body",
                        "£" .. getMoneyStringFormatted(e.price),
                        {RightLabel = "→→→"},
                        true,
                        function(k, l, m)
                            if m then
                                h = "body"
                            end
                        end,
                        RMenu:Get("RNGGunstore", "confirm")
                    )
                    if
                        not a.weapons[e.model] or
                            a.weapons[e.model].ammo ~= "modelammo" and a.weapons[e.model].ammo ~= ""
                     then
                        RageUI.ButtonWithStyle(
                            "Purchase Weapon Ammo (Max)",
                            "£" .. getMoneyStringFormatted(math.floor(e.price / 2)),
                            {RightLabel = "→→→"},
                            true,
                            function(k, l, m)
                                if m then
                                    h = "ammo"
                                end
                            end,
                            RMenu:Get("RNGGunstore", "confirm")
                        )
                    end
                end
            )
        end
        if RageUI.Visible(RMenu:Get("RNGGunstore", "confirm")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = true},
                function()
                    RageUI.ButtonWithStyle(
                        "Yes",
                        "",
                        {RightLabel = "→→→"},
                        true,
                        function(k, l, m)
                            if m then
                                if string.sub(e.model, 1, 4) == "item" then
                                    TriggerServerEvent("RNG:buyWeapon", e.model, e.price, e.name, e.weaponShop, "armour")
                                else
                                    if h == "ammo" then
                                        if HasPedGotWeapon(tRNG.getPlayerPed(), GetHashKey(e.model), false) then
                                            TriggerServerEvent(
                                                "RNG:buyWeapon",
                                                e.model,
                                                e.price,
                                                e.name,
                                                e.weaponShop,
                                                "ammo"
                                            )
                                        else
                                            tRNG.notify("You do not have the body of this weapon to purchase ammo.")
                                        end
                                    else
                                        TriggerServerEvent(
                                            "RNG:buyWeapon",
                                            e.model,
                                            e.price,
                                            e.name,
                                            e.weaponShop,
                                            "weapon",
                                            i
                                        )
                                    end
                                end
                            end
                        end,
                        RMenu:Get("RNGGunstore", "confirm")
                    )
                    RageUI.ButtonWithStyle(
                        "No",
                        "",
                        {RightLabel = "→→→"},
                        true,
                        function(k, l, m)
                        end,
                        RMenu:Get("RNGGunstore", "mainmenu")
                    )
                end
            )
        end
        if RageUI.Visible(RMenu:Get("RNGGunstore", "vip")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = true},
                function()
                    local A = j["LargeArmsDealer"]
                    for p, q in pairs(sortedKeys(A)) do
                        i = true
                        local r = A[q]
                        if q ~= "_config" then
                            local s, t, u = table.unpack(r)
                            local v = false
                            local w
                            if q == "item|fillUpArmour" then
                                local x = GetPedArmour(tRNG.getPlayerPed())
                                local y = 100 - x
                                w = y * 1000
                                v = true
                            end
                            local z = ""
                            if v then
                                z = tostring(getMoneyStringFormatted(w))
                            else
                                z = tostring(getMoneyStringFormatted(t))
                            end
                            RageUI.ButtonWithStyle(
                                s,
                                "£" .. z,
                                {RightLabel = "→→→"},
                                true,
                                function(k, l, m)
                                    if k then
                                    end
                                    if l then
                                        f = q
                                    end
                                    if m then
                                        e.name = s
                                        e.priceString = z
                                        e.model = q
                                        e.price = t
                                        e.ammoPrice = u
                                        e.weaponShop = "LargeArmsDealer"
                                    end
                                end,
                                RMenu:Get("RNGGunstore", "type")
                            )
                        end
                    end
                end
            )
        end
    end
)
RegisterNetEvent(
    "RNG:refreshGunStorePermissions",
    function()
        TriggerServerEvent("RNG:requestNewGunshopData")
    end
)
local B = false
RegisterNetEvent("RNG:recieveFilteredGunStoreData")
AddEventHandler(
    "RNG:recieveFilteredGunStoreData",
    function(C)
        j = C
        for l, D in pairs(C) do
            if D["WEAPON_MP5TAZER"] then
                B = true
            end
        end
    end
)
RegisterNetEvent("RNG:recalculateLargeArms")
AddEventHandler(
    "RNG:recalculateLargeArms",
    function(B)
        for n, o in pairs(j) do
            if n == "LargeArmsDealer" then
                for s, E in pairs(o) do
                    if s ~= "_config" then
                        local F = j[n][s][7]
                        j[n][s][2] = F * (1 + B / 100)
                    end
                end
            end
        end
    end
)
local function G(n, H)
    c = n
    d = H
    if n == "Rebel" then
        RMenu:Get("RNGGunstore", "mainmenu"):SetSpriteBanner("menus", "rng_rebel")
    elseif n == "policeSmallArms" then
        RMenu:Get("RNGGunstore", "mainmenu"):SetSpriteBanner("menus", "metpd")
        RMenu:Get("RNGGunstore", "confirm"):SetSpriteBanner("menus", "metpd")
        RMenu:Get("RNGGunstore", "type"):SetSpriteBanner("menus", "metpd")
    elseif n == "policeLargeArms" then
        RMenu:Get("RNGGunstore", "mainmenu"):SetSpriteBanner("menus", "metpd")
        RMenu:Get("RNGGunstore", "confirm"):SetSpriteBanner("menus", "metpd")
        RMenu:Get("RNGGunstore", "type"):SetSpriteBanner("menus", "metpd")
    elseif n == "prisonArmoury" then
        RMenu:Get("RNGGunstore", "mainmenu"):SetSpriteBanner("menus", "metpd")
        RMenu:Get("RNGGunstore", "confirm"):SetSpriteBanner("menus", "metpd")
        RMenu:Get("RNGGunstore", "type"):SetSpriteBanner("menus", "metpd")
    else
        RMenu:Get("RNGGunstore", "mainmenu"):SetSpriteBanner("menus", "menus")
    end
    RageUI.ActuallyCloseAll()
    RageUI.Visible(RMenu:Get("RNGGunstore", "mainmenu"), true)
end
local function I(n)
    c = nil
    d = nil
    f = nil
    RageUI.ActuallyCloseAll()
    RageUI.Visible(RMenu:Get("RNGGunstore", "mainmenu"), false)
end
Citizen.CreateThread(
    function()
        while true do
            if f and g ~= f then
                g = f
                for n, o in pairs(j) do
                    local E = o[g]
                    if E then
                        local D = E[5]
                        if D and d then
                            local J = o._config[1][d]
                            if i then
                                J = vector3(-2151.5739746094, 5191.2548828125, 14.718822479248)
                            end
                            local K = tRNG.loadModel(D)
                            if K then
                                local L = CreateObject(K, J.x, J.y, J.z + 1, false, false, false)
                                while g == f and DoesEntityExist(L) do
                                    SetEntityHeading(L, GetEntityHeading(L) + 1 % 360)
                                    Wait(0)
                                end
                                DeleteEntity(L)
                            end
                            SetModelAsNoLongerNeeded(K)
                        end
                    end
                end
            end
            local M = PlayerPedId()
            if not B and GetSelectedPedWeapon(M) == GetHashKey("WEAPON_MP5TAZER") then
                tRNG.setWeapon(M, "WEAPON_UNARMED", true)
            end
            Wait(0)
        end
    end
)
AddEventHandler(
    "RNG:onClientSpawn",
    function(N, O)
        if O then
            TriggerServerEvent("RNG:requestNewGunshopData")
            for n, o in pairs(j) do
                local P, Q, M, R, S, T = table.unpack(o["_config"])
                for H, U in pairs(P) do
                    if T then
                        tRNG.addBlip(U.x, U.y, U.z, Q, M, R)
                    end
                    tRNG.addMarker(U.x, U.y, U.z, 1.0, 1.0, 1.0, 255, 0, 0, 170, 50, 27)
                    local V = function()
                        if GetVehiclePedIsIn(tRNG.getPlayerPed(), false) == 0 then
                            G(n, H)
                        else
                            tRNG.notify("Exit your vehicle to access the gun store.")
                        end
                    end
                    local W = function()
                        I(n)
                    end
                    local X = function()
                    end
                    tRNG.createArea("gunstore_" .. n .. "_" .. H, U, 1.5, 6, V, W, X, {})
                end
            end
        end
    end
)
local Y = {}
function tRNG.createGunStore(Z, _, a0)
    local V = function()
        if GetVehiclePedIsIn(tRNG.getPlayerPed(), false) == 0 then
            G(_)
        else
            tRNG.notify("Exit your vehicle to access the gun store.")
        end
    end
    local W = function()
        I(_)
    end
    local a1 = string.format("gunstore_%s_%s", _, Z)
    tRNG.createArea(
        a1,
        a0,
        1.5,
        6,
        V,
        W,
        function()
        end
    )
    local a2 = tRNG.addMarker(a0.x, a0.y, a0.z, 1.0, 1.0, 1.0, 255, 0, 0, 170, 50, 27)
    Y[Z] = {area = a1, marker = a2}
end
function tRNG.deleteGunStore(Z)
    local a3 = Y[Z]
    if a3 then
        tRNG.removeMarker(a3.marker)
        tRNG.removeArea(a3.area)
        Y[Z] = nil
    end
end

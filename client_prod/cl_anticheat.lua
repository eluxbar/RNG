local a = module("cfg/cfg_anticheat")
decor = nil

local function b(c, ...)
    for d, e in pairs(GetGamePool("CVehicle")) do
        c(e, ...)
        Wait(0)
    end
end

Citizen.CreateThread(function()
    while decor == nil do
        Citizen.Wait(500)
    end
    DecorRegister(decor, 3)
    while true do
        Citizen.Wait(500)
        b(function(e)
            if DecorGetInt(e, decor) ~= 945 then
                if NetworkHasControlOfEntity(e) then
                    local f = GetEntityModel(e)
                    DeleteEntity(e)
                end
            end
        end)
    end
end)

local e = false

Citizen.CreateThread(function()
    while true do
        local f = tRNG.getPlayerPed()
        local g = tRNG.getPlayerId()
        local h = tRNG.getPlayerVehicle()
        if h == 0 then
            SetWeaponDamageModifier(GetHashKey("WEAPON_RUN_OVER_BY_CAR"), 0.0)
            SetWeaponDamageModifier(GetHashKey("WEAPON_RAMMED_BY_CAR"), 0.0)
            SetWeaponDamageModifier(GetHashKey("VEHICLE_WEAPON_ROTORS"), 0.0)
            SetWeaponDamageModifier(GetHashKey("WEAPON_UNARMED"), 0.5)
            SetWeaponDamageModifier(GetHashKey("WEAPON_SNOWBALL"), 0.0)
            local i = GetSelectedPedWeapon(f)
            if i == GetHashKey("WEAPON_SNOWBALL") then
                SetPlayerWeaponDamageModifier(g, 0.0)
            else
                SetPlayerWeaponDamageModifier(g, 1.0)
                SetWeaponDamageModifier(i, 1.0)
            end
            if not e and GetUsingseethrough() and not tRNG.isPlayerInPoliceHeli() and not tRNG.isPlayerInDrone() then
                TriggerServerEvent("RNG:acType13")
                e = true
            end
        end
        SetPedInfiniteAmmoClip(f, false)
        for b, j in pairs(tRNG.getWeapons()) do
            SetPedInfiniteAmmo(f, false, j.hash)
        end
        SetEntityInvincible(h, false)
        ToggleUsePickupsForPlayer(g, "PICKUP_HEALTH_SNACK", false)
        ToggleUsePickupsForPlayer(g, "PICKUP_HEALTH_STANDARD", false)
        ToggleUsePickupsForPlayer(g, "PICKUP_WEAPON_PISTOL", false)
        ToggleUsePickupsForPlayer(g, "PICKUP_AMMO_BULLET_MP", false)
        Citizen.InvokeNative(0xdef665962974b74c, 2047, false)
        SetLocalPlayerCanCollectPortablePickups(false)
        SetPlayerHealthRechargeMultiplier(g, 0.0)
        Wait(1000)
    end
end)

local k = false
local l = false

AddEventHandler("esx:getSharedObject",function(m)
    if k == true then
        CancelEvent()
        m(nil)
        return
    end
    
    
    TriggerServerEvent("RNG:acType4")
    k = true
    m(nil)
end)

local n = {
    "ambulancier:selfRespawn",
    "bank:transfer",
    "esx_ambulancejob:revive",
    "esx-qalle-jail:openJailMenu",
    "esx_jailer:wysylandoo",
    "esx_society:openBossMenu",
    "esx:spawnVehicle",
    "esx_status:set",
    "HCheat:TempDisableDetection",
    "UnJP",
    "bank:transfer",
    "esx_skin:openSaveableMenu",
    "esx_society:openBossMenu",
    "esx_status:set",
    "esx_ambulancejob:revive",
    "ambulancier:selfRespawn",
    "esx-qalle-jail:openJailMenu",
    "UnJP",
    "esx_inventoryhud:openPlayerInventory",
    "HCheat:TempDisableDetection",
    "esx_policejob:handcuff",
    "esx:getSharedObject",
    "esx:teleport",
    "esx_spectate:spectate"
}

local o = {
    "WarMenu",
    "AlikhanCheats",
    "gaybuild",
    "Plane",
    "LynxEvo",
    "FendinX",
    "LR",
    "Lynx8",
    "MIOddhwuie",
    "ililililil",
    "esxdestroyv2",
    "LiLLL",
    "obl2",
    "HamMafia",
    "Absolute",
    "Absolute_function",
    "TiagoMenu",
    "SkazaMenu",
    "BrutanPremium",
    "b00mMenu",
    "Cience",
    "MaestroMenu",
    "Crusader",
    "NertigelFunc",
    "dreanhsMod",
    "nukeserver",
    "SDefwsWr",
    "FlexSkazaMenu",
    "DynnoFamily",
    "FrostedMenu",
    "frosted_config",
    "FXMenu",
    "CKgang",
    "HoaxMenu",
    "alkomenu",
    "xseira",
    "KoGuSzEk",
    "LynxSeven",
    "lynxunknowncheats",
    "MaestroEra",
    "foriv",
    "ariesMenu",
    "Ham",
    "Outcasts666",
    "b00mek",
    "redMENU",
    "rootMenu",
    "xnsadifnias",
    "LDOWJDWDdddwdwdad",
    "moneymany",
    "FlexSkazaMenu",
    "VOITUREMenu",
    "fESX",
    "dexMenu",
    "zzzt",
    "AKTeam",
    "SwagMenu",
    "Gatekeeper",
    "Dopameme",
    "Lux",
    "Swag",
    "SwagUI",
    "Nisi",
    "nigmenu0001",
    "Motion",
    "MMenu",
    "FantaMenuEvo",
    "GRubyMenu",
    "InSec",
    "AlphaVeta",
    "ShaniuMenu",
    "HamHaxia",
    "FendinXMenu",
    "AlphaV",
    "Deer",
    "NyPremium",
    "lIlIllIlI",
    "OnionUI",
    "qJtbGTz5y8ZmqcAg",
    "LuxUI",
    "JokerMenu",
    "IlIlIlIlIlI",
    "SidMenu",
    "GheMenu",
    "INFINITY",
    "klVZJu56hiZnIjg88ekXcEgegjfDvuMv83grKxQiUJJFvN8SHENeK2WaRgTTuafpGe",
    "jailServerLoop",
    "carSpamServer",
    "Dopamine",
    "nofuckinglol"
}

function CheckVariables()
    for p, q in pairs(o) do
        if _G[q] ~= nil then
            TriggerServerEvent("RNG:acType7")
        end
    end
end

Citizen.CreateThread(function()
    while true do
        CheckVariables()
        Citizen.Wait(15000)
    end
end)

for r, s in ipairs(n) do
    AddEventHandler(s,function()
        if l == true then
            CancelEvent()
            return
        end
        
        
        TriggerServerEvent("RNG:acType4")
        l = true
    end)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local g = PlayerId()
        local h = GetVehiclePedIsIn(PlayerPedId(), false)
        local t = GetPlayerWeaponDamageModifier(g)
        local u = GetPlayerWeaponDefenseModifier(g)
        local v = GetPlayerWeaponDefenseModifier_2(g)
        local w = GetPlayerVehicleDamageModifier(g)
        local x = GetPlayerVehicleDefenseModifier(g)
        local y = GetPlayerMeleeWeaponDefenseModifier(g)
        if h ~= 0 then
            local z = GetVehicleTopSpeedModifier(h)
            if z > 1.0 then
                print("Using Speed Boost")
            end
        end
        local A = GetWeaponDamageModifier(GetCurrentPedWeapon(g, 0, false))
        local B = GetPlayerMeleeWeaponDamageModifier(PlayerId())
        if t > 1.0 then
            TriggerServerEvent("RNG:acType8")
            return
        end
        if u > 1.0 then
            TriggerServerEvent("RNG:acType8")
            return
        end
        if v > 1.0 then
            TriggerServerEvent("RNG:acType8")
            return
        end
        if w > 1.0 then
            TriggerServerEvent("RNG:acType8")
            return
        end
        if x > 1.0 then
            TriggerServerEvent("RNG:acType8")
            return
        end
        if A > 1.0 then
            TriggerServerEvent("RNG:acType8")
            return
        end
        if B > 1.0 then
            TriggerServerEvent("RNG:acType8")
            return
        end
        RemoveAllPickupsOfType("PICKUP_HEALTH_SNACK")
        RemoveAllPickupsOfType("PICKUP_HEALTH_STANDARD")
    end
end)

function tRNG.isPlayerAboveGround()
    local C = tRNG.getPlayerCoords()
    local D, E = GetGroundZFor_3dCoord(C.x, C.y, C.z)
    return D, E
end

local F = 0
local G = 0
local H = 0
local I = 0
local U = 0

local function J(c)
    local K = GetVehicleNumberOfWheels(c)
    local L = 0.0
    for r = 0, K - 1 do
        local M = GetVehicleWheelSpeed(c, r)
        if M > L then
            L = M
        end
    end
    return L
end

local function N()
    local f = PlayerPedId()
    for b, O in pairs(GetGamePool("CObject")) do
        if GetEntityAttachedTo(O) == f then
            DeleteEntity(O)
        end
    end
end

Citizen.CreateThread(function()
    local wait = 1000
    local F = 0
    local G = 0
    local H = nil
    local I = GetGameTimer()

    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local newPlayerCoords = GetEntityCoords(playerPed)
        local distance = #(playerCoords - newPlayerCoords)
        playerCoords = newPlayerCoords

        if distance > 0.4 and not IsPedFalling(playerPed) and tRNG.getStaffLevel() < 2 and not IsPedInParachuteFreeFall(playerPed) and not carryingBackInProgress and not piggyBackInProgress and not tRNG.takeHostageInProgress() and GetPedParachuteState(playerPed) <= 0 and not IsPedRagdoll(playerPed) and not IsPedRunning(playerPed) and not tRNG.isPlayerRappeling() and not tRNG.isPlayerHidingInBoot() and not tRNG.isSpectatingEvent() and not noclipActive then
            if not IsPedInAnyVehicle(playerPed, true) then
                F = F + 1
                wait = 0
                if F > 50 then
                    print("Possible noclip detected for player")
                    
                    
                    TriggerServerEvent("RNG:acType1", false)
                    F = 0
                end
            else
                wait = 1000
            end
        end
        local vehicle, isPlayerInVehicle = tRNG.getPlayerVehicle()
        if DoesEntityExist(vehicle) and isPlayerInVehicle and distance > 0.2 and tRNG.getStaffLevel() < 2 then
            if H ~= vehicle then
                G = 0
                H = vehicle
            end

            local height = J(vehicle)
            local speed = GetEntitySpeed(vehicle)
            if height < 5.0 and speed < 2.5 then
                G = G + 1
                wait = 0
                N()
                if G > 100 and GetGameTimer() - I > 4000 then
                    print("Possible vehicle noclip detected for vehicle:", vehicle)
                    TriggerServerEvent("RNG:AnticheatBan", 1, true)
                    G = 0
                    I = GetGameTimer()
                end
            else
                wait = 1000
            end
        end
        Citizen.Wait(wait)
        if NetworkIsInSpectatorMode() and not tRNG.isInSpectate() then
            
            TriggerServerEvent("RNG:acType23")
            return
        end
        if GetCamFov(GetRenderingCam()) == 50.0 and not tRNG.isInSpectate() and tRNG.getStaffLevel() == 0 then
            
            TriggerServerEvent("RNG:acType24")
            Wait(10000)
        end
        Wait(wait)
    end
end)

Citizen.CreateThread(function()
    while true do
        F = 0
        Wait(60000)
    end
end)

Citizen.CreateThread(function()
    while true do
        if GetLabelText("notification_buffer") ~= "NULL" then
            
            
            TriggerServerEvent("RNG:acType7")
        end
        if GetLabelText("text_buffer") ~= "NULL" then
            
            
            TriggerServerEvent("RNG:acType7")
        end
        if GetLabelText("preview_text_buffer") ~= "NULL" then
            
            
            TriggerServerEvent("RNG:acType7")
        end
        Wait(10000)
    end
end)

WeaponBL = {
    "WEAPON_BAT",
    "WEAPON_MACHETE",
    "WEAPON_POOLCUE",
    "WEAPON_DAGGER",
    "WEAPON_KNIFE",
    "WEAPON_KNUCKLE",
    "WEAPON_HAMMER",
    "WEAPON_GOLFCLUB",
    "WEAPON_BOTTLE",
    "WEAPON_HATCHET",
    "WEAPON_PROXMINE",
    "WEAPON_BZGAS",
    "WEAPON_HAZARDCAN",
    "WEAPON_FLARE",
    "WEAPON_BALL",
    "WEAPON_PIPEWRENCH",
    "WEAPON_PISTOL",
    "WEAPON_PISTOL_MK2",
    "WEAPON_COMBATPISTOL",
    "WEAPON_APPISTOL",
    "WEAPON_WEAPON_REVOLVER",
    "WEAPON_SNSPISTOL",
    "WEAPON_HEAVYPISTOL",
    "WEAPON_VINTAGEPISTOL",
    "WEAPON_FLAREGUN",
    "WEAPON_MARKSMANPISTOL",
    "WEAPON_MICROSMG",
    "WEAPON_MINISMG",
    "WEAPON_SMG",
    "WEAPON_SMG_MK2",
    "WEAPON_ASSAULTSMG",
    "WEAPON_MG",
    "WEAPON_COMBATMG",
    "WEAPON_COMBATMG_MK2",
    "WEAPON_COMBATPDW",
    "WEAPON_GUSENBERG",
    "WEAPON_MACHINEPISTOL",
    "WEAPON_ASSAULTRIFLE",
    "WEAPON_ASSAULTRIFLE_MK2",
    "WEAPON_CARBINERIFLE",
    "WEAPON_CARBINERIFLE_MK2",
    "WEAPON_ADVANCEDRIFLE",
    "WEAPON_SPECIALCARBINE",
    "WEAPON_BULLPUPRIFLE",
    "WEAPON_COMPACTRIFLE",
    "WEAPON_PUMPSHOTGUN",
    "WEAPON_SWEEPERSHOTGUN",
    "WEAPON_SAWNOFFSHOTGUN",
    "WEAPON_BULLPUPSHOTGUN",
    "WEAPON_ASSAULTSHOTGUN",
    "WEAPON_HEAVYSHOTGUN",
    "WEAPON_DBSHOTGUN",
    "WEAPON_SNIPERRIFLE",
    "WEAPON_HEAVYSNIPER",
    "WEAPON_HEAVYSNIPER_MK2",
    "WEAPON_MARKSMANRIFLE",
    "WEAPON_GRENADELAUNCHER",
    "WEAPON_GRENADELAUNCHER_SMOKE",
    "WEAPON_RPG",
    "WEAPON_MINIGUN",
    "WEAPON_FIREWORK",
    "WEAPON_RAILGUN",
    "WEAPON_HOMINGLAUNCHER",
    "WEAPON_GRENADE",
    "WEAPON_STICKYBOMB",
    "WEAPON_COMPACTLAUNCHER",
    "WEAPON_SNSPISTOL_MK2",
    "WEAPON_REVOLVER_MK2",
    "WEAPON_DOUBLEACTION",
    "WEAPON_SPECIALCARBINE_MK2",
    "WEAPON_BULLPUPRIFLE_MK2",
    "WEAPON_PUMPSHOTGUN_MK2",
    "WEAPON_MARKSMANRIFLE_MK2",
    "WEAPON_RAYPISTOL",
    "WEAPON_RAYCARBINE",
    "WEAPON_RAYMINIGUN",
    "WEAPON_DIGISCANNER",
    "WEAPON_NAVYREVOLVER",
    "WEAPON_CERAMICPISTOL",
    "WEAPON_STONE_HATCHET",
    "WEAPON_PIPEBOMB",
    "WEAPON_PASSENGER_ROCKET",
    "WEAPON_MUSKET",
    "WEAPON_PISTOL50"
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        for U, V in ipairs(WeaponBL) do
            Wait(1)
            if HasPedGotWeapon(PlayerPedId(), GetHashKey(V), false) == 1 then
                RemoveAllPedWeapons(PlayerPedId(), false)
                
                
                TriggerServerEvent("RNG:acType2")
            end
        end
        local U, t = StatGetInt(GetHashKey("mp0_shooting_ability"), true)
        if t > 100 then
            
            
            TriggerServerEvent("RNG:acType19")
        end
    end
end)

Citizen.CreateThread(function()
    Wait(0)
    while true do
        if U >= 100 and not tRNG.isInComa() then
            
            
            TriggerServerEvent("RNG:acType6")
            return
        end
        if GetEntityHealth(PlayerPedId()) > 102 and not spawning and not tRNG.isPedScriptGuidChanging() then
            local g = PlayerId()
            local f = PlayerPedId()
            local W = GetEntityHealth(f)
            SetPlayerHealthRechargeMultiplier(g, 0.0)
            if f ~= 0 then
                tRNG.setHealth(W - 2)
                Citizen.Wait(50)
                if GetEntityHealth(f) > W - 2 then
                    U = U + 1
                elseif U > 0 then
                    U = U - 1
                end
                tRNG.setHealth(GetEntityHealth(f) + 2)
            end
        else
            Citizen.Wait(1000)
        end
    end
end)

local function X()
    TriggerServerEventInternal(nil, "?", 1)
end

local Y = function()
    local u, t, d =xpcall(function()
        X()
        return true
    end,function()
        return false
    end)
    return t
end
local Z = {GetHashKey("WEAPON_UNARMED"), GetHashKey("WEAPON_PETROLCAN"), GetHashKey("WEAPON_SNOWBALL")}

CreateThread(function()
    while true do
        local e = tRNG.getPlayerPed()
        local h = GetSelectedPedWeapon(e)
        if IsPedShooting(e) and not table.has(Z, h) then
            local S, T = GetAmmoInClip(e, h)
            if T == GetMaxAmmoInClip(e, h) then
                
                
                TriggerServerEvent("RNG:acType8")
                Wait(40000)
            end
        end
        Wait(0)
    end
end)

local _ = vector3(0.0, 0.0, 0.0)
local a0 = 0
local a1 = nil
local a2 = 0
local p = 0
local a3 = vector3(0.0, 0.0, 0.0)
local a4 = 0
local a5 = 0

local function a6(a7, a8, a9)
    if type(a7) == "vector3" then
        a3 = a7
    else
        a3 = vector3(a7, a8, a9)
    end
    a4 = GetGameTimer()
end

local aa = SetEntityCoords

SetEntityCoords = function(ab, ac, ad, ae, af, ag, ah, ai)
    if ab == a0 or ab == a2 then
        a6(ac, ad, ae)
    end
    aa(ab, ac, ad, ae, af, ag, ah, ai)
end

local aj = SetEntityCoordsNoOffset

SetEntityCoordsNoOffset = function(ab, ac, ad, ae, af, ag, ah)
    if ab == a0 or ab == a2 then
        a6(ac, ad, ae)
    end
    aj(ab, ac, ad, ae, af, ag, ah)
end

local ak = NetworkResurrectLocalPlayer

NetworkResurrectLocalPlayer = function(a7, a8, a9, al, am, an)
    a6(a7, a8, a9)
    ak(a7, a8, a9, al, am, an)
end

local ao = StartPlayerTeleport

StartPlayerTeleport = function(ap, a7, a8, a9, al, aq, ar, as)
    a6(a7, a8, a9)
    ao(ap, a7, a8, a9, al, aq, ar, as)
end

local function at(au, av)
    if math.abs(au.x) > av or math.abs(au.y) > av or math.abs(au.z) > av then
        return true
    else
        return false
    end
end

local function aw()
    local f = PlayerPedId()
    if f == nil or f == 0 then
        return
    end
    a0 = f
    local ax = GetGameTimer()
    local h = GetVehiclePedIsUsing(f)
    if a2 ~= h then
        p = ax
    end
    a2 = h
    local ay = false
    if h ~= 0 then
        ay = GetPedInVehicleSeat(h, -1) ~= f
    end
    local az = a1
    a1 = GetEntityCoords(f, true)
    if not az then
        return
    end
    local aA = #(az - a1)
    if aA < 50.0 or ay or carryingBackInProgress or piggyBackInProgress or tRNG.isPlayerHidingInBoot() or GetEntityAttachedTo(f) ~= 0 then
        return
    end
    if ax - p < 2000 or ax - a4 < 5000 then
        return
    end
    if #(a1 - a3) < 15.0 or #(a1 - _) < 50.0 or #(az - _) < 50.0 then
        return
    end
    local aB = #(az.xy - a1.xy)
    if az.z < -180.0 and aB < 2500.0 then
        return
    end
    if a1.z >= -52.0 and a1.z <= -48.0 and aB < 10.0 then
        return
    end
    local aC = GetEntityVelocity(f)
    local aD = (a1 - az) / GetFrameTime()
    local aE = aC - aD
    if at(aE, 100.0) then
        if ax - a5 > 5000 then
            TriggerServerEvent("RNG:sendVelocityLimit", az, a1)
            a5 = ax
        end
    end
end

RegisterNetEvent("RNG:settingPlayerIntoVehicle",function()
    a4 = GetGameTimer()
end)

local aF = 0
local aG = 0
local aH = 0
local aI = 0
local aJ = 0
local aK = 0
local aL = 0
local aM = SetVehicleFixed

SetVehicleFixed = function(c)
    if c == aK then
        aJ = GetGameTimer()
    end
    aM(c)
end

local aN = SetVehicleBodyHealth

SetVehicleBodyHealth = function(c, aO)
    if c == aK then
        aF = math.floor(aO)
    end
    aN(c, aO)
end

local aP = SetVehicleEngineHealth

SetVehicleEngineHealth = function(c, W)
    if c == aK then
        aG = math.floor(W)
    end
    aP(c, W)
end

local aQ = SetVehiclePetrolTankHealth

SetVehiclePetrolTankHealth = function(c, W)
    if c == aK then
        aH = math.floor(W)
    end
    aQ(c, W)
end

local aR = SetEntityHealth

SetEntityHealth = function(ab, W)
    if ab == aK then
        aG = math.floor(W)
    end
    aR(ab, W)
end

local function aS(c)
    local aT = {}
    local d = GetEntityModel(c)
    local aU = GetVehicleModelNumberOfSeats(d) - 1
    for aV = 0, aU do
        local aW = GetPedInVehicleSeat(c, aV)
        if aW ~= 0 and IsPedAPlayer(aW) then
            local aX = NetworkGetPlayerIndexFromPed(aW)
            if aX ~= -1 then
                local aY = GetPlayerServerId(aX)
                table.insert(aT, {aV, aY})
            end
        end
    end
    return aT
end

local function aZ(a_, b0)
    if a_ == 0 or a_ < 0 and b0 < 0 then
        return false
    end
    local b1 = math.abs(b0 - a_)
    if b1 <= 4 then
        return false
    end
    if b1 <= 50 and a_ ~= 1000 then
        return false
    end
    return a_ > b0
end

local function b2()
    local c, S = tRNG.getPlayerVehicle()
    if c == 0 or not DoesEntityExist(c) or not S or not NetworkGetEntityIsNetworked(c) or GetIsTaskActive(PlayerPedId(), 165) or GetEntityType(GetEntityAttachedTo(c)) == 2 then
        aK = 0
        aF = 1000
        aG = 1000
        aH = 1000
        aI = 1000
        return
    end
    local b3 = math.floor(GetVehicleBodyHealth(c))
    local b4 = math.floor(GetVehicleEngineHealth(c))
    local b5 = math.floor(GetVehiclePetrolTankHealth(c))
    local b6 = math.floor(GetEntityHealth(c))
    if aZ(b3, aF) or aZ(b4, aG) or aZ(b5, aH) or aZ(b6, aI) then
        local ax = GetGameTimer()
        if GetGameTimer() - aJ > 1000 and c == aK and ax - aL > 5000 and GetEntityHealth(PlayerPedId()) > 102 and ax - globalLastSpawnedVehicleTime > 5000 then
            local aT = aS(c)
            local b7 = tRNG.getVehicleIdFromHash(GetEntityModel(c)) or "N/A"
            TriggerServerEvent("RNG:sendVehicleStats", b3, aF, b4, aG, b5, aH, b6, aI, aT, b7)
            aL = ax
        end
    end
    aF = b3
    aG = b4
    aH = b5
    aI = b6
    aK = c
end

AddEventHandler("RNG:onClientSpawn",function(b8, b9)
    if b9 then
        Citizen.Wait(15000)
        while true do
            aw()
            b2()
            Citizen.Wait(0)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        local c = tRNG.getPlayerVehicle()
        local b9 = GetEntityModel(c)
        if GetVehicleHasParachute(c) or GetCanVehicleJump(c) or GetHasRocketBoost(c) and b9 ~= GetHashKey("voltic2") then
            if not table.has(a.anticheat, b9) then
                
                
                TriggerServerEvent("RNG:acType12")
                return
            end
        end
        Wait(1000)
    end
end)

Citizen.CreateThread(function()
    Wait(10000)
    while true do
        if GetPlayerInvincible(PlayerId()) and not isInGreenzone and not tRNG.isInsideLsCustoms() and not tRNG.isStaffedOn() and not noclipActive and not tRNG.isInComa() and not tRNG.isInSpectate() and not tRNG.getInRPZone() then
            
            
            TriggerServerEvent("RNG:acType15")
            Citizen.Wait(60000)
        end
        if GetPlayerInvincible_2(PlayerId()) and not isInGreenzone and not tRNG.isInsideLsCustoms() and not tRNG.isStaffedOn() and not noclipActive and not tRNG.isInComa() and not tRNG.isInSpectate() and not tRNG.getInRPZone() then
            
            
            TriggerServerEvent("RNG:acType15")
            Citizen.Wait(60000)
        end
        if not IsEntityVisible(PlayerPedId()) and not tRNG.isInsideLsCustoms() and not noclipActive and not tRNG.isInSpectate()  and not tRNG.inEvent() and not tRNG.isPlayerInDrone() and not tRNG.isSpectatingEvent() and not spawning and tRNG.getStaffLevel() < 3 and GetEntityAttachedTo(PlayerPedId()) == 0 then
            
            
            TriggerServerEvent("RNG:acType27")
            Citizen.Wait(60000)
        end
        Citizen.Wait(1000)
    end
end)

function tRNG.isPlayerLoading()
    while true do end
end

local resource_loaded = false
RegisterNetEvent("RNG:Return29", function()
    old_timer = GetGameTimer()
end)

AddEventHandler("onResourceStart", function(res)
    if res == "dpjeex" and not resource_loaded then
        resource_loaded = true
        if GetGameTimer()-old_timer > 4000 then
            TriggerServerEvent("RNG:acType29")
        end
    end
end)

TriggerServerEvent("RNG:Check29")

Citizen.CreateThread(function()
    while true do
        local ba = PlayerPedId()
        local bb = GetSelectedPedWeapon(ba)
        local bc = GetWeaponDamageType(bb)
        local bd = {4, 5, 6, 13}
        for a0, be in pairs(bd) do
            if bc == be then
                TriggerServerEvent("RNG:acType8")
                return
            end
        end
        Wait(0)
    end
end)

RegisterNUICallback("NuiDevTool",function()
    TriggerServerEvent("RNG:acType26")
end)

AddEventHandler("onClientResourceStop",function(bf)
    TriggerServerEvent("RNG:acType18")
end)

AddEventHandler("onResourceStop",function(bf)
    TriggerServerEvent("RNG:acType18")
end)

RegisterNetEvent("RNG:anticheatInitialize", function(ad)
    spawning = ad
end)

RegisterNetEvent("_RNG:AddHealth", function(amount)
    TriggerServerEvent("RNG:FixClient")
    local health = GetEntityHealth(PlayerPedId())
    if health + amount > 200 then
        SetEntityHealth(PlayerPedId(), 200)
    else
        SetEntityHealth(PlayerPedId(), amount)
    end
end)
local a = module("cfg/cfg_purge")
local b = a.coords[a.location]
local function c()
    math.random()
    math.random()
    math.random()
    return b[math.random(1, #b)]
end
local d = false
function tRNG.hasSpawnProtection()
    return d
end
local function e()
    d = true
    SetTimeout(
        10000,
        function()
            d = false
        end
    )
    Citizen.CreateThread(
        function()
            SetLocalPlayerAsGhost(true)
            while d do
                SetEntityProofs(PlayerPedId(), true, true, true, true, true, true, true, true)
                SetEntityAlpha(PlayerPedId(), 100, false)
                Wait(0)
            end
            SetEntityAlpha(PlayerPedId(), 255, false)
            SetLocalPlayerAsGhost(false)
            ResetGhostedEntityAlpha()
            tRNG.notify("~g~Spawn protection ended!")
            SetEntityProofs(PlayerPedId(), false, false, false, false, false, false, false, false)
        end
    )
end
local f
RegisterNetEvent("RNG:purgeSpawnClient")
AddEventHandler(
    "RNG:purgeSpawnClient",
    function(g)
        ShutdownLoadingScreen()
        ShutdownLoadingScreenNui()
        e()
        DoScreenFadeOut(250)
        tRNG.hideUI()
        SetBigmapActive(false)
        Wait(500)
        TriggerScreenblurFadeIn(100.0)
        f = c()
        RequestCollisionAtCoord(f.x, f.y, f.z)
        local h = GetGameTimer()
        while HaveAllStreamingRequestsCompleted(PlayerPedId()) ~= 1 and GetGameTimer() - h < 5000 do
            Wait(0)
            print("[RNG] Waiting for streaming requests to complete!")
        end
        tRNG.checkCustomization()
        TriggerServerEvent("RNG:getPlayerHairstyle")
        TriggerServerEvent("RNG:getPlayerTattoos")
        DoScreenFadeIn(1000)
        tRNG.showUI()
        local i = tRNG.getPlayerCoords()
        SetEntityCoordsNoOffset(PlayerPedId(), i.x, i.y, 1200.0, false, false, false)
        SetEntityVisible(PlayerPedId(), false, false)
        FreezeEntityPosition(PlayerPedId(), true)
        SetEntityVisible(PlayerPedId(), true, true)
        SetFocusPosAndVel(f.x, f.y, f.z + 1000, 0.0, 0.0, 0.0)
        spawnCam = CreateCameraWithParams("DEFAULT_SCRIPTED_CAMERA", f.x, f.y, f.z + 1000, 0.0, 0.0, 0.0, 65.0, 0, 2)
        SetCamActive(spawnCam, true)
        RenderScriptCams(true, true, 0, true, false)
        spawnCam2 = CreateCameraWithParams("DEFAULT_SCRIPTED_CAMERA", f.x, f.y, f.z, 0.0, 0.0, 0.0, 65.0, 0, 2)
        SetCamActiveWithInterp(spawnCam2, spawnCam, 5000, 0, 0)
        Wait(2500)
        ClearFocus()
        if not g then
            SetEntityCoords(PlayerPedId(), f.x, f.y, f.z)
        end
        FreezeEntityPosition(PlayerPedId(), false)
        TriggerScreenblurFadeOut(2000.0)
        Wait(2000)
        DestroyCam(spawnCam, false)
        DestroyCam(spawnCam2, false)
        RenderScriptCams(false, true, 2000, 0, 0)
        tRNG.setHealth(200)
        tRNG.setArmour(200)
        TriggerServerEvent("RNG:purgeClientHasSpawned")
    end
)
RegisterNetEvent("RNG:purgeGetWeapon")
AddEventHandler(
    "RNG:purgeGetWeapon",
    function()
        tRNG.notify("~o~Random Weapon Received!")
        PlaySoundFrontend(-1, "Weapon_Upgrade", "DLC_GR_Weapon_Upgrade_Soundset", true)
    end
)
Citizen.CreateThread(
    function()
        if tRNG.isPurge() then
            local j = AddBlipForRadius(0.0, 0.0, 0.0, 50000.0)
            SetBlipColour(j, 1)
            SetBlipAlpha(j, 180)
        end
    end
)
RegisterCommand(
    "airport",
    function()
        if tRNG.isPurge() then
            local k = tRNG.getPlayerCoords()
            tRNG.notify("~g~Teleporting to airport... please wait.")
            Wait(5000)
            if k == tRNG.getPlayerCoords() then
                tRNG.teleport(-1113.495, -2917.377, 13.94363)
                tRNG.notify("~g~Teleported to airport, use /suicide to return to the purge.")
            else
                tRNG.notify("~r~Teleportation failed, please remain still when teleporting.")
            end
        end
    end
)

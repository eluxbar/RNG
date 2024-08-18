noclipActive = false
local a = nil
local b = 1
local c = 0
local d = false
local e = false
local f = {
    controls = {
        openKey = 288,
        goUp = 85,
        goDown = 38,
        turnLeft = 34,
        turnRight = 35,
        goForward = 32,
        goBackward = 33,
        reduceSpeed = 19,
        increaseSpeed = 21
    },
    speeds = {
        {label = "Very Slow", speed = 0.1},
        {label = "Slow", speed = 0.5},
        {label = "Normal", speed = 2},
        {label = "Fast", speed = 4},
        {label = "Very Fast", speed = 6},
        {label = "Extremely Fast", speed = 10},
        {label = "Extremely Fast v2.0", speed = 20},
        {label = "Max Speed", speed = 25}
    },
    offsets = {y = 0.5, z = 0.2, h = 3},
    bgR = 0,
    bgG = 0,
    bgB = 0,
    bgA = 80
}
local function g(h)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentSubstringKeyboardDisplay(h)
    EndTextCommandScaleformString()
end
local function i(j)
    ScaleformMovieMethodAddParamPlayerNameString(j)
end
local function k(l)
    local l = RequestScaleformMovie(l)
    while not HasScaleformMovieLoaded(l) do
        Citizen.Wait(1)
    end
    BeginScaleformMovieMethod(l, "CLEAR_ALL")
    EndScaleformMovieMethod()
    BeginScaleformMovieMethod(l, "SET_CLEAR_SPACE")
    ScaleformMovieMethodAddParamInt(200)
    EndScaleformMovieMethod()
    BeginScaleformMovieMethod(l, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(1)
    i(GetControlInstructionalButton(1, f.controls.goBackward, true))
    i(GetControlInstructionalButton(1, f.controls.goForward, true))
    g("Go Forwards/Backwards")
    EndScaleformMovieMethod()
    BeginScaleformMovieMethod(l, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(0)
    i(GetControlInstructionalButton(2, f.controls.reduceSpeed, true))
    i(GetControlInstructionalButton(2, f.controls.increaseSpeed, true))
    g("Increase/Decrease Speed (" .. f.speeds[b].label .. ")")
    EndScaleformMovieMethod()
    BeginScaleformMovieMethod(l, "DRAW_INSTRUCTIONAL_BUTTONS")
    EndScaleformMovieMethod()
    BeginScaleformMovieMethod(l, "SET_BACKGROUND_COLOUR")
    ScaleformMovieMethodAddParamInt(f.bgR)
    ScaleformMovieMethodAddParamInt(f.bgG)
    ScaleformMovieMethodAddParamInt(f.bgB)
    ScaleformMovieMethodAddParamInt(f.bgA)
    EndScaleformMovieMethod()
    return l
end
function tRNG.toggleNoclip()
    tRNG.loadPtfx("scr_xs_celebration")
    tRNG.loadPtfx("scr_rcpaparazzo1")
    noclipActive = not noclipActive
    if IsPedInAnyVehicle(tRNG.getPlayerPed(), false) then
        c = GetVehiclePedIsIn(tRNG.getPlayerPed(), false)
    else
        c = tRNG.getPlayerPed()
    end
    SetEntityCollision(c, not noclipActive, not noclipActive)
    FreezeEntityPosition(c, noclipActive)
    SetEntityInvincible(c, noclipActive)
    SetVehicleRadioEnabled(c, not noclipActive)
    if noclipActive then
        SetEntityVisible(tRNG.getPlayerPed(), false, false)
        tRNG.setRedzoneTimerDisabled(true)
    else
        SetEntityVisible(tRNG.getPlayerPed(), true, false)
        tRNG.setRedzoneTimerDisabled(false)
    end
end
RegisterKeyMapping("noclip", "Staff Noclip", "keyboard", "F4")
RegisterCommand("noclip",function()
    local a4 = tRNG.getPlayerCoords()
    local source = source
    if tRNG.getStaffLevel() >= 4 then
        UseParticleFxAsset("core")
        StartParticleFxNonLoopedAtCoord("exp_grd_plane_post",a4.x,a4.y,a4.z - 0.8,0.0,0.0,0.0,1.2,false,false,false)
        UseParticleFxAsset("core")
        StartParticleFxNonLoopedAtCoord("ent_dst_elec_fire_sp",a4.x,a4.y,a4.z - 0.8,0.0,0.0,0.0,1.2,false,false,false)
        SendNUIMessage({transactionType = "whoosh"})
        TriggerServerEvent("RNG:noClip")
    end
end)
Citizen.CreateThread(
    function()
        local m = k("instructional_buttons")
        local n = f.speeds[b].speed
        while true do
            if noclipActive then
                DrawScaleformMovieFullscreen(m)
                local o = 0.0
                local p = 0.0
                local q, r, s = table.unpack(tRNG.getPosition())
                local t, u, v = tRNG.getCamDirection()
                if IsDisabledControlJustPressed(1, f.controls.reduceSpeed) then
                    if b ~= 1 then
                        b = b - 1
                        n = f.speeds[b].speed
                    end
                    k("instructional_buttons")
                end
                if IsDisabledControlJustPressed(1, f.controls.increaseSpeed) then
                    if b ~= 8 then
                        b = b + 1
                        n = f.speeds[b].speed
                    end
                    k("instructional_buttons")
                end
                if IsControlPressed(0, f.controls.goForward) then
                    q = q + n * t
                    r = r + n * u
                    s = s + n * v
                end
                if IsControlPressed(0, f.controls.goBackward) then
                    q = q - n * t
                    r = r - n * u
                    s = s - n * v
                end
                if IsControlPressed(0, f.controls.goUp) then
                    p = f.offsets.z
                end
                if IsControlPressed(0, f.controls.goDown) then
                    p = -f.offsets.z
                end
                local w = GetEntityHeading(c)
                SetEntityVelocity(c, 0.0, 0.0, 0.0)
                SetEntityRotation(c, t, u, v, 0, false)
                SetEntityHeading(c, w)
                SetEntityCoordsNoOffset(c, q, r, s, noclipActive, noclipActive, noclipActive)
            end
            Wait(0)
        end
    end
)
RegisterCommand(
    "staffmode",
    function()
        if tRNG.getStaffLevel() > 0 then
            tRNG.staffMode(not staffMode)
        end
    end
)
staffMode = false
local x = false
local a = {}
function tRNG.staffMode(y)
    TriggerServerEvent("RNG:VerifyStaff", tRNG.getStaffLevel())
    if tRNG.getStaffLevel() > 0 then
        if staffMode ~= y then
            staffMode = y
            if staffMode then
                tRNG.notify("~g~Staff Powerz Activated.")
                if GetEntityHealth(PlayerPedId()) <= 102 then
                    tRNG.RevivePlayer()
                end
                tRNG.setRedzoneTimerDisabled(true)
                a = tRNG.getCustomization()
                if tRNG.getUserId() == 1 then
                    tRNG.loadCustomisationPreset("Spexxster")
                else
                if tRNG.getModelGender() == "male" then
                    tRNG.loadCustomisationPreset("StaffMale")
                    if tRNG.isHalloween() then
                        tRNG.loadCustomisationPreset("StaffHalloweenMale")
                    end
                    if tRNG.isChristmas() then
                        tRNG.loadCustomisationPreset("StaffChristmasMale")
                    end
                else
                    tRNG.loadCustomisationPreset("StaffFemale")
                    if tRNG.isHalloween() then
                        tRNG.loadCustomisationPreset("StaffHalloweenFemale")
                    end
                    if tRNG.isChristmas() then
                        tRNG.loadCustomisationPreset("StaffChristmasFemale")
                    end
                end
                local z = GetPedDrawableVariation(PlayerPedId(), 11)
                SetPedComponentVariation(PlayerPedId(), 11, z, tRNG.getStaffLevel(), 0)
                if tRNG.isPurge() then
                    RemoveAllPedWeapons(PlayerPedId(), true)
                end
            end
            else
                tRNG.setRedzoneTimerDisabled(false)
                SetEntityInvincible(PlayerPedId(), false)
                SetPlayerInvincible(PlayerId(), false)
                SetPedCanRagdoll(PlayerPedId(), true)
                ClearPedBloodDamage(PlayerPedId())
                ResetPedVisibleDamage(PlayerPedId())
                ClearPedLastWeaponDamage(PlayerPedId())
                SetEntityProofs(PlayerPedId(), false, false, false, false, false, false, false, false)
                SetEntityCanBeDamaged(PlayerPedId(), true)
                if not tRNG.isPurge() then
                    tRNG.setHealth(200)
                end
                tRNG.setCustomization(a)
                tRNG.notify("~g~Staff Powerz Deactivated.")
            end
        end
    end
end
function loadModel(q)
    local r
    if type(q) ~= "string" then
        r = q
    else
        r = GetHashKey(q)
    end
    if IsModelInCdimage(r) then
        if not HasModelLoaded(r) then
            RequestModel(r)
            while not HasModelLoaded(r) do
                Wait(0)
            end
        end
        return r
    else
        return nil
    end
end
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(0)
            if staffMode then
                local z = PlayerPedId()
                SetEntityInvincible(z, true)
                SetPlayerInvincible(PlayerId(), true)
                SetPedCanRagdoll(z, false)
                ClearPedBloodDamage(z)
                ResetPedVisibleDamage(z)
                ClearPedLastWeaponDamage(z)
                SetEntityProofs(z, true, true, true, true, true, true, true, true)
                SetEntityCanBeDamaged(z, false)
                if not tRNG.isPurge() then
                    SetEntityHealth(z, 200)
                end
                if not x then
                    drawNativeText("~r~Reminder: You are /staffon'd on", 255, 0, 0, 255, true)
                end
            end
        end
    end
)
RegisterNetEvent("RNG:sendTicketInfo")
AddEventHandler(
    "RNG:sendTicketInfo",
    function(A, B, C)
        if A ~= nil and B ~= nil then
            x = true
        else
            x = false
        end
        while x do
            Wait(0)
            if A ~= nil and B ~= nil then
                drawNativeText(
                    "~y~You've taken the ticket of " .. B .. "(" .. A .. ")\n~o~Reason: " .. C,
                    255,
                    0,
                    0,
                    255,
                    true
                )
            end
        end
    end
)
RegisterCommand(
    "fix",
    function()
        if tRNG.isStaffedOn() or tRNG.getStaffLevel() >= 6 then
            TriggerServerEvent("wk:fixVehicle")
        end
    end
)
RegisterNetEvent("wk:fixVehicle")
AddEventHandler(
    "wk:fixVehicle",
    function()
        local p = PlayerPedId()
        if IsPedInAnyVehicle(p) then
            local D = GetVehiclePedIsIn(p)
            SetVehicleEngineHealth(D, 9999)
            SetVehiclePetrolTankHealth(D, 9999)
            SetVehicleFixed(D)
            tRNG.notify("~g~Fixed Vehicle")
        end
    end
)
function tRNG.staffBlips(E)
    if tRNG.getStaffLevel() >= 6 then
        d = E
        if d then
            tRNG.notify("~g~Blips enabled")
        else
            tRNG.notify("~r~Blips disabled")
            for F, G in ipairs(GetActivePlayers()) do
                local H = GetPlayerPed(G)
                if GetPlayerPed(G) ~= tRNG.getPlayerPed() then
                    H = GetPlayerPed(G)
                    blip = GetBlipFromEntity(H)
                    RemoveBlip(blip)
                end
            end
        end
    end
end
Citizen.CreateThread(
    function()
        while true do
            if d then
                for F, G in ipairs(GetActivePlayers()) do
                    local I = GetPlayerPed(G)
                    if I ~= PlayerPedId() then
                        local blip = GetBlipFromEntity(I)
                        local J = GetPlayerServerId(G)
                        local K = tRNG.clientGetUserIdFromSource(J)
                        if not DoesBlipExist(blip) and not tRNG.isUserHidden(K) then
                            blip = AddBlipForEntity(I)
                            SetBlipSprite(blip, 1)
                            ShowHeadingIndicatorOnBlip(blip, true)
                            local L = GetVehiclePedIsIn(I, false)
                            SetBlipSprite(blip, 1)
                            ShowHeadingIndicatorOnBlip(blip, true)
                            SetBlipRotation(blip, math.ceil(GetEntityHeading(L)))
                            SetBlipNameToPlayerName(blip, G)
                            SetBlipScale(blip, 0.85)
                            SetBlipAlpha(blip, 255)
                        end
                    end
                end
            end
            Wait(1000)
        end
    end
)
function tRNG.hasStaffBlips()
    return d
end
globalIgnoreDeathSound = false
RegisterNetEvent(
    "RNG:deathSound",
    function(M)
        local N = GetEntityCoords(tRNG.getPlayerPed())
        local O = #(N - M)
        if not globalIgnoreDeathSound and O <= 15 then
            SendNUIMessage({transactionType = tRNG.getDeathSound()})
        end
    end
)

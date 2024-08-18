usingDelgun = false
local a = false
local b = function(c)
    local d = {}
    local e = GetGameTimer() / 200
    d.r = math.floor(math.sin(e * c + 0) * 127 + 128)
    d.g = math.floor(math.sin(e * c + 2) * 127 + 128)
    d.b = math.floor(math.sin(e * c + 4) * 127 + 128)
    return d
end
RegisterCommand(
    "delgun",
    function()
        if tRNG.getStaffLevel() > 0 then
            usingDelgun = not usingDelgun
            local f = tRNG.getPlayerPed()
            local g = "WEAPON_STAFFGUN"
            if usingDelgun then
                a = HasPedGotWeapon(f, g, false)
                tRNG.xyzweapom(g)
                GiveWeaponToPed(f, g, nil, false, true)
                Citizen.CreateThread(
                    function()
                        while usingDelgun do
                            Citizen.Wait(0)
                            drawNativeText("Aim ~w~at an object and press ~b~Enter ~w~to delete it. ~r~Have fun!")
                        end
                    end
                )
                tRNG.drawNativeNotification("Don't forget to use ~b~/delgun ~w~to disable the delete gun!")
            else
                if not a then
                    RemoveWeaponFromPed(f, g)
                end
                a = false
            end
        end
    end
)
RegisterNetEvent(
    "RNG:returnObjectDeleted",
    function(h)
        drawNativeNotification(h)
    end
)
local i = 0
function func_staffDelGun(j)
    if usingDelgun then
        SetPlayerTargetingMode(2)
        i = i + 1
        if i > 1000 then
            i = 0
        end
        DisableControlAction(1, 18, true)
        DisablePlayerFiring(PlayerId(), true)
        if IsPlayerFreeAiming(PlayerId()) then
            local k, l = GetEntityPlayerIsFreeAimingAt(PlayerId())
            if k then
                local m = GetEntityType(l)
                local n = true
                if n then
                    local o = GetEntityCoords(l)
                    local p = b(0.5)
                    DrawMarker(
                        1,
                        o.x,
                        o.y,
                        o.z - 1.02,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0.7,
                        0.7,
                        1.5,
                        p.r,
                        p.g,
                        p.b,
                        200,
                        0,
                        0,
                        2,
                        0,
                        0,
                        0,
                        0
                    )
                    if IsDisabledControlJustPressed(1, 18) then
                        local q = NetworkGetNetworkIdFromEntity(l)
                        TriggerServerEvent("RNG:delGunDelete", q)
                        if GetEntityType(l) == 2 then
                            SetEntityAsMissionEntity(l, false, true)
                            DeleteVehicle(l)
                        end
                    end
                end
            end
        end
    end
end
RegisterNetEvent(
    "RNG:deletePropClient",
    function(q)
        local r = tRNG.getObjectId(q)
        if DoesEntityExist(r) then
            DeleteEntity(r)
        end
    end
)
tRNG.createThreadOnTick(func_staffDelGun)
local s = {}
function tRNG.isLocalPlayerHidden()
    if s[tRNG.getUserId()] then
        return true
    else
        return false
    end
end
function tRNG.isUserHidden(t)
    if s[t] and tRNG.getUserId() ~= t then
        return true
    else
        return false
    end
end
RegisterNetEvent(
    "RNG:setHiddenUsers",
    function(u)
        s = u
    end
)

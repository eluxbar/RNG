cfg = module("cfg/client")
purgecfg = module("cfg/cfg_purge")
tRNG = {}
local a = {}
Tunnel.bindInterface("RNG", tRNG)
RNGserver = Tunnel.getInterface("RNG", "RNG")
Proxy.addInterface("RNG", tRNG)
allowedWeapons = {}
weapons = module("rng-weapons", "cfg/weapons")
function tRNG.isDevMode()
    if tRNG.isDev() then
        return true
    else
        return false
    end
end
function tRNG.teleport(b, c, d)
    local e = PlayerPedId()
    NetworkFadeOutEntity(e, true, false)
    DoScreenFadeOut(500)
    Citizen.Wait(500)
    SetEntityCoords(tRNG.getPlayerPed(), b + 0.0001, c + 0.0001, d + 0.0001, 1, 0, 0, 1)
    NetworkFadeInEntity(e, 0)
    DoScreenFadeIn(500)
end
function tRNG.teleport2(f, g)
    local e = PlayerPedId()
    NetworkFadeOutEntity(e, true, false)
    if tRNG.getPlayerVehicle() == 0 or not g then
        SetEntityCoords(tRNG.getPlayerPed(), f.x, f.y, f.z, 1, 0, 0, 1)
    else
        SetEntityCoords(tRNG.getPlayerVehicle(), f.x, f.y, f.z, 1, 0, 0, 1)
    end
    Wait(500)
    NetworkFadeInEntity(e, 0)
end
local a20 = GetPlayerServerId(PlayerId())
function tRNG.getLocalPlayerSrc()
    return a20
end
function tRNG.getPosition()
    return GetEntityCoords(tRNG.getPlayerPed())
end
function tRNG.getDistanceBetweenCoords(h, j, k, l, m, n)
    local o = GetDistanceBetweenCoords(h, j, k, l, m, n, true)
    return o
end
function tRNG.isInside()
    local h, j, k = table.unpack(tRNG.getPosition())
    return not (GetInteriorAtCoords(h, j, k) == 0)
end
local p = module("cfg/cfg_attachments")
function tRNG.getAllWeaponAttachments(q, r)
    local s = PlayerPedId()
    local t = {}
    if r then
        for u, v in pairs(p.attachments) do
            if HasPedGotWeaponComponent(s, q, GetHashKey(v)) and not table.has(givenAttachmentsToRemove[q] or {}, v) then
                table.insert(t, v)
            end
        end
    else
        for u, v in pairs(p.attachments) do
            if HasPedGotWeaponComponent(s, q, GetHashKey(v)) then
                table.insert(t, v)
            end
        end
    end
    return t
end
function tRNG.getSpeed()
    local w, x, y = table.unpack(GetEntityVelocity(PlayerPedId()))
    return math.sqrt(w * w + x * x + y * y)
end
function tRNG.getCamDirection()
    local z = GetGameplayCamRelativeHeading() + GetEntityHeading(PlayerPedId())
    local A = GetGameplayCamRelativePitch()
    local h = -math.sin(z * math.pi / 180.0)
    local j = math.cos(z * math.pi / 180.0)
    local k = math.sin(A * math.pi / 180.0)
    local B = math.sqrt(h * h + j * j + k * k)
    if B ~= 0 then
        h = h / B
        j = j / B
        k = k / B
    end
    return h, j, k
end
function tRNG.addPlayer(C)
    a[C] = true
end
function tRNG.removePlayer(C)
    a[C] = nil
end
function tRNG.getNearestPlayers(D)
    local E = {}
    local F = GetPlayerPed(i)
    local G = PlayerId()
    local H, I, J = table.unpack(tRNG.getPosition())
    for e, K in pairs(a) do
        local C = GetPlayerFromServerId(e)
        if K and C ~= G and NetworkIsPlayerConnected(C) then
            local L = GetPlayerPed(C)
            local h, j, k = table.unpack(GetEntityCoords(L, true))
            local o = GetDistanceBetweenCoords(h, j, k, H, I, J, true)
            if o <= D then
                E[GetPlayerServerId(C)] = o
            end
        end
    end
    return E
end
function tRNG.getNearestPlayer(D)
    local M = nil
    local a = tRNG.getNearestPlayers(D)
    local N = D + 10.0
    for e, K in pairs(a) do
        if K < N then
            N = K
            M = e
        end
    end
    return M
end
function tRNG.getNearestPlayersFromPosition(O, D)
    local E = {}
    local F = GetPlayerPed(i)
    local G = PlayerId()
    local H, I, J = table.unpack(O)
    for e, K in pairs(a) do
        local C = GetPlayerFromServerId(e)
        if K and C ~= G and NetworkIsPlayerConnected(C) then
            local L = GetPlayerPed(C)
            local h, j, k = table.unpack(GetEntityCoords(L, true))
            local o = GetDistanceBetweenCoords(h, j, k, H, I, J, true)
            if o <= D then
                E[GetPlayerServerId(C)] = o
            end
        end
    end
    return E
end
function tRNG.notify(P)
    if not globalHideUi then
        SetNotificationTextEntry("STRING")
        AddTextComponentString(P)
        DrawNotification(true, false)
    end
end
local function Q(R, S, T)
    return R < S and S or R > T and T or R
end
local function U(b)
    local c = math.floor(#b % 99 == 0 and #b / 99 or #b / 99 + 1)
    local i = {}
    for d = 0, c - 1 do
        i[d + 1] = string.sub(b, d * 99 + 1, Q(#string.sub(b, d * 99), 0, 99) + d * 99)
    end
    return i
end
local function e(f, g)
    local V = U(f)
    SetNotificationTextEntry("CELL_EMAIL_BCON")
    for W, M in ipairs(V) do
        AddTextComponentSubstringPlayerName(M)
    end
    if g then
        local X = GetSoundId()
        PlaySoundFrontend(X, "police_notification", "DLC_AS_VNT_Sounds", true)
        ReleaseSoundId(X)
    end
end
function tRNG.notifyPicture(Y, Z, f, _, a0, a1, a2)
    if Y ~= nil and Z ~= nil then
        RequestStreamedTextureDict(Y, true)
        while not HasStreamedTextureDictLoaded(Y) do
            print("stuck loading", Y)
            Wait(0)
        end
    end
    e(f, a1 == "police")
    if a2 == nil then
        a2 = 0
    end
    local a3 = false
    EndTextCommandThefeedPostMessagetext(Y, Z, a3, a2, _, a0)
    local a4 = true
    local a5 = false
    EndTextCommandThefeedPostTicker(a5, a4)
    DrawNotification(false, true)
    if a1 == nil then
        PlaySoundFrontend(-1, "CHECKPOINT_NORMAL", "HUD_MINI_GAME_SOUNDSET", 1)
    end
end
function tRNG.notifyPicture2(a6, type, a7, a8, a9)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(a9)
    SetNotificationMessage(a6, a6, true, type, a7, a8, a9)
    DrawNotification(false, true)
end
function tRNG.playScreenEffect(aa, ab)
    if ab < 0 then
        StartScreenEffect(aa, 0, true)
    else
        StartScreenEffect(aa, 0, true)
        Citizen.CreateThread(
            function()
                Citizen.Wait(math.floor((ab + 1) * 1000))
                StopScreenEffect(aa)
            end
        )
    end
end
function tRNG.stopScreenEffect(aa)
    StopScreenEffect(aa)
end
local r = {}
local s = {}
function tRNG.createArea(f, ac, u, v, ad, ae, af, ag)
    local ah = {position = ac, radius = u, height = v, enterArea = ad, leaveArea = ae, onTickArea = af, metaData = ag}
    if ah.height == nil then
        ah.height = 6
    end
    r[f] = ah
    s[f] = ah
end
function tRNG.doesAreaExist(f)
    if r[f] then
        return true
    end
    return false
end
function DrawText3D(ai, Q, R, S, T, U, b)
    local c, i, d = GetScreenCoordFromWorldCoord(ai, Q, R)
    if c then
        SetTextScale(0.4, 0.4)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 55)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        BeginTextCommandDisplayText("STRING")
        SetTextCentre(1)
        AddTextComponentSubstringPlayerName(S)
        EndTextCommandDisplayText(i, d)
    end
end
function tRNG.add3DTextForCoord(S, ai, Q, R, e)
    local function f(g)
        DrawText3D(g.coords.x, g.coords.y, g.coords.z, g.text)
    end
    local V = tRNG.generateUUID("3dtext", 8, "alphanumeric")
    tRNG.createArea(
        "3dtext_" .. V,
        vector3(ai, Q, R),
        e,
        6.0,
        function()
        end,
        function()
        end,
        f,
        {coords = vector3(ai, Q, R), text = S}
    )
end
local aj = {}
local ak = {
    ["alphabet"] = "abcdefghijklmnopqrstuvwxyz",
    ["numerical"] = "0123456789",
    ["alphanumeric"] = "abcdefghijklmnopqrstuvwxyz0123456789"
}
local function al(am, type)
    local an, ao, ap = 0, "", 0
    local aq = {ak[type]}
    repeat
        an = an + 1
        ap = math.random(aq[an]:len())
        if math.random(2) == 1 then
            ao = ao .. aq[an]:sub(ap, ap)
        else
            ao = aq[an]:sub(ap, ap) .. ao
        end
        an = an % #aq
    until ao:len() >= am
    return ao
end
function tRNG.generateUUID(ar, am, type)
    if aj[ar] == nil then
        aj[ar] = {}
    end
    if type == nil then
        type = "alphanumeric"
    end
    local as = al(am, type)
    if aj[ar][as] then
        while aj[ar][as] ~= nil do
            as = al(am, type)
            Wait(0)
        end
    end
    aj[ar][as] = true
    return as
end
function tRNG.setdecor(at, au)
    decor = at
    objettable = au
end
function tRNG.spawnVehicle(ac, K, av, au, ad, ae, af, ag)
    local aw = tRNG.loadModel(ac)
    local ax = CreateVehicle(aw, K, av, au, ad, af, ag)
    SetModelAsNoLongerNeeded(aw)
    SetEntityAsMissionEntity(ax)
    DecorSetInt(ax, decor, 945)
    SetModelAsNoLongerNeeded(aw)
    if ae then
        TaskWarpPedIntoVehicle(PlayerPedId(), ax, -1)
    end
    setVehicleFuel(ax, 100)
    return ax
end
local ay = {}
Citizen.CreateThread(
    function()
        while true do
            local az = {}
            az.playerPed = tRNG.getPlayerPed()
            az.playerCoords = tRNG.getPlayerCoords()
            az.playerId = tRNG.getPlayerId()
            az.vehicle = tRNG.getPlayerVehicle()
            az.weapon = GetSelectedPedWeapon(az.playerPed)
            for aA = 1, #ay do
                local aB = ay[aA]
                aB(az)
            end
            Wait(0)
        end
    end
)
function tRNG.createThreadOnTick(aB)
    ay[#ay + 1] = aB
end
local ai = 0
local Q = 0
local R = 0
local S = vector3(0, 0, 0)
local T = false
local U = PlayerPedId
function savePlayerInfo()
    ai = U()
    Q = GetVehiclePedIsIn(ai, false)
    R = PlayerId()
    S = GetEntityCoords(ai)
    local b = GetPedInVehicleSeat(Q, -1)
    T = b == ai
end
_G["PlayerPedId"] = function()
    return ai
end
function tRNG.getPlayerPed()
    return ai
end
function tRNG.getPlayerVehicle()
    return Q, T
end
function tRNG.getPlayerId()
    return R
end
function tRNG.getPlayerCoords()
    return S
end
createThreadOnTick(savePlayerInfo)
function tRNG.getClosestVehicle(aC)
    local aD = tRNG.getPlayerCoords()
    local aE = 100
    local aF = 100
    for u, bu in pairs(GetGamePool("CVehicle")) do
        local aG = GetEntityCoords(bu)
        local aH = #(aD - aG)
        if aH < aF then
            aF = aH
            aE = bu
        end
    end
    if aF <= aC then
        return aE
    else
        return nil
    end
end
local aI = {}
local aJ = Tools.newIDGenerator()
function tRNG.playAnim(aK, aL, aM)
    if aL.task ~= nil then
        tRNG.stopAnim(true)
        local F = PlayerPedId()
        if aL.task == "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER" then
            local h, j, k = table.unpack(tRNG.getPosition())
            TaskStartScenarioAtPosition(F, aL.task, h, j, k - 1, GetEntityHeading(F), 0, 0, false)
        else
            TaskStartScenarioInPlace(F, aL.task, 0, not aL.play_exit)
        end
    else
        tRNG.stopAnim(aK)
        local aN = 0
        if aK then
            aN = aN + 48
        end
        if aM then
            aN = aN + 1
        end
        Citizen.CreateThread(
            function()
                local aO = aJ:gen()
                aI[aO] = true
                for e, K in pairs(aL) do
                    local aP = K[1]
                    local aa = K[2]
                    local aQ = K[3] or 1
                    for i = 1, aQ do
                        if aI[aO] then
                            local aR = e == 1 and i == 1
                            local aS = e == #aL and i == aQ
                            RequestAnimDict(aP)
                            local i = 0
                            while not HasAnimDictLoaded(aP) and i < 1000 do
                                Citizen.Wait(10)
                                RequestAnimDict(aP)
                                i = i + 1
                            end
                            if HasAnimDictLoaded(aP) and aI[aO] then
                                local aT = 8.0001
                                local aU = -8.0001
                                if not aR then
                                    aT = 2.0001
                                end
                                if not aS then
                                    aU = 2.0001
                                end
                                TaskPlayAnim(PlayerPedId(), aP, aa, aT, aU, -1, aN, 0, 0, 0, 0)
                            end
                            Citizen.Wait(0)
                            while GetEntityAnimCurrentTime(PlayerPedId(), aP, aa) <= 0.95 and
                                IsEntityPlayingAnim(PlayerPedId(), aP, aa, 3) and
                                aI[aO] do
                                Citizen.Wait(0)
                            end
                        end
                    end
                end
                aJ:free(aO)
                aI[aO] = nil
            end
        )
    end
end
function tRNG.stopAnim(aK)
    aI = {}
    if aK then
        ClearPedSecondaryTask(PlayerPedId())
    else
        ClearPedTasks(PlayerPedId())
    end
end
local aV = false
function tRNG.setRagdoll(aW)
    aV = aW
end
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(10)
            if aV then
                SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, 0, 0, 0)
            end
        end
    end
)
function tRNG.playSpatializedSound(aP, aa, h, j, k, aX)
    PlaySoundFromCoord(-1, aa, h + 0.0001, j + 0.0001, k + 0.0001, aP, 0, aX + 0.0001, 0)
end
function tRNG.playSound(aP, aa)
    PlaySound(-1, aa, aP, 0, 0, 1)
end
function tRNG.playFrontendSound(aP, aa)
    PlaySoundFrontend(-1, aP, aa, 0)
end
function tRNG.loadAnimDict(aP)
    while not HasAnimDictLoaded(aP) do
        RequestAnimDict(aP)
        Wait(0)
    end
end
function tRNG.drawNativeNotification(aY)
    SetTextComponentFormat("STRING")
    AddTextComponentString(aY)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
function tRNG.announceMpBigMsg(aZ, a_, b0)
    local b1 = Scaleform("MP_BIG_MESSAGE_FREEMODE")
    b1.RunFunction("SHOW_SHARD_WASTED_MP_MESSAGE", {aZ, a_, 0, false, false})
    local b2 = false
    SetTimeout(
        b0,
        function()
            b2 = true
        end
    )
    while not b2 do
        b1.Render2D()
        Wait(0)
    end
end
local g = true
function tRNG.canAnim()
    return g
end
function tRNG.setCanAnim(V)
    g = V
end
function tRNG.getModelGender()
    local b3 = PlayerPedId()
    if GetEntityModel(b3) == GetHashKey("mp_f_freemode_01") then
        return "female"
    else
        return "male"
    end
end
function tRNG.loadWeaponAsset(U)
    local U = GetHashKey(U)
    RequestWeaponAsset(U)
    while not HasWeaponAssetLoaded(U) do
        Wait(0)
    end
    return U
end
function tRNG.spawnWeaponObject(E, B, C, D)
    local V = tRNG.loadWeaponAsset(E)
    local W = CreateWeaponObject(V, 0, B, C, D, true, 0, 0)
    return W
end
function tRNG.getPedServerId(b4)
    local b5 = GetActivePlayers()
    for u, v in pairs(b5) do
        if b4 == GetPlayerPed(v) then
            local b6 = GetPlayerServerId(v)
            return b6
        end
    end
    return nil
end
function tRNG.loadModel(b7)
    local b8
    if type(b7) ~= "string" then
        b8 = b7
    else
        b8 = GetHashKey(b7)
    end
    if IsModelInCdimage(b8) then
        if not HasModelLoaded(b8) then
            RequestModel(b8)
            while not HasModelLoaded(b8) do
                Wait(0)
            end
        end
        return b8
    else
        return nil
    end
end
function tRNG.getObjectId(b9, ba)
    if ba == nil then
        ba = ""
    end
    local bb = 0
    local bc = NetworkDoesNetworkIdExist(b9)
    if not bc then
        print(string.format("no object by ID %s\n%s", b9, ba))
    else
        local bd = NetworkGetEntityFromNetworkId(b9)
        bb = bd
    end
    return bb
end
function tRNG.KeyboardInput(be, bf, bg)
    AddTextEntry("FMMC_KEY_TIP1", be)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", bf, "", "", "", bg)
    blockinput = true
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end
    if UpdateOnscreenKeyboard() ~= 2 then
        local bh = GetOnscreenKeyboardResult()
        Citizen.Wait(1)
        blockinput = false
        return bh
    else
        Citizen.Wait(1)
        blockinput = false
        return nil
    end
end
function tRNG.syncNetworkId(bi)
    SetNetworkIdExistsOnAllMachines(bi, true)
    SetNetworkIdCanMigrate(bi, false)
    NetworkSetNetworkIdDynamic(bi, true)
end
RegisterNetEvent("__RNG_callback:client")
AddEventHandler(
    "__RNG_callback:client",
    function(bj, ...)
        local bk = promise.new()
        TriggerEvent(
            string.format("c__RNG_callback:%s", bj),
            function(...)
                bk:resolve({...})
            end,
            ...
        )
        local bb = Citizen.Await(bk)
        TriggerServerEvent(string.format("__RNG_callback:server:%s:%s", bj, ...), table.unpack(bb))
    end
)
tRNG.TriggerServerCallback = function(bj, ...)
    assert(type(bj) == "string", "Invalid Lua type at argument #1, expected string, got " .. type(bj))
    local bk = promise.new()
    local bl = GetGameTimer()
    RegisterNetEvent(string.format("__RNG_callback:client:%s:%s", bj, bl))
    local bm =
        AddEventHandler(
        string.format("__RNG_callback:client:%s:%s", bj, bl),
        function(...)
            bk:resolve({...})
        end
    )
    TriggerServerEvent("__RNG_callback:server", bj, bl, ...)
    local bb = Citizen.Await(bk)
    RemoveEventHandler(bm)
    return table.unpack(bb)
end
tRNG.RegisterClientCallback = function(bj, bn)
    assert(type(bj) == "string", "Invalid Lua type at argument #1, expected string, got " .. type(bj))
    assert(type(bn) == "function", "Invalid Lua type at argument #2, expected function, got " .. type(bn))
    AddEventHandler(
        string.format("c__RNG_callback:%s", bj),
        function(bo, ...)
            bo(bn(...))
        end
    )
end
Citizen.CreateThread(
    function()
        while true do
            SetVehicleDensityMultiplierThisFrame(0.0)
            SetPedDensityMultiplierThisFrame(0.0)
            SetRandomVehicleDensityMultiplierThisFrame(0.0)
            SetParkedVehicleDensityMultiplierThisFrame(0.0)
            SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)
            local bp = GetPlayerPed(-1)
            local bq = GetEntityCoords(bp)
            RemoveVehiclesFromGeneratorsInArea(
                bq["x"] - 500.0,
                bq["y"] - 500.0,
                bq["z"] - 500.0,
                bq["x"] + 500.0,
                bq["y"] + 500.0,
                bq["z"] + 500.0
            )
            SetGarbageTrucks(0)
            SetRandomBoats(0)
            Citizen.Wait(1)
        end
    end
)
function tRNG.drawTxt(b1, b2, br, bs, bt, bv, bw, r, s, t)
    SetTextFont(b2)
    SetTextProportional(0)
    SetTextScale(bv, bv)
    SetTextColour(bw, r, s, t)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(br)
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(b1)
    EndTextCommandDisplayText(bs, bt)
end
function drawNativeText(ah)
    if not globalHideUi then
        BeginTextCommandPrint("STRING")
        AddTextComponentSubstringPlayerName(ah)
        EndTextCommandPrint(100, 1)
    end
end
function clearNativeText()
    BeginTextCommandPrint("STRING")
    AddTextComponentSubstringPlayerName("")
    EndTextCommandPrint(1, true)
end
function tRNG.announceClient(S)
    if S ~= nil then
        CreateThread(
            function()
                local T = GetGameTimer()
                local bx = RequestScaleformMovie("MIDSIZED_MESSAGE")
                while not HasScaleformMovieLoaded(bx) do
                    Wait(0)
                end
                PushScaleformMovieFunction(bx, "SHOW_SHARD_MIDSIZED_MESSAGE")
                PushScaleformMovieFunctionParameterString("~g~RNG Announcement")
                PushScaleformMovieFunctionParameterString(S)
                PushScaleformMovieMethodParameterInt(5)
                PushScaleformMovieMethodParameterBool(true)
                PushScaleformMovieMethodParameterBool(false)
                EndScaleformMovieMethod()
                while T + 6 * 1000 > GetGameTimer() do
                    DrawScaleformMovieFullscreen(bx, 255, 255, 255, 255)
                    Wait(0)
                end
            end
        )
    end
end
AddEventHandler(
    "mumbleDisconnected",
    function(U)
        tRNG.notify("~r~[RNG] Lost connection to voice server, you may need to toggle voice chat.")
    end
)
RegisterNetEvent("RNG:PlaySound")
AddEventHandler(
    "RNG:PlaySound",
    function(by)
        SendNUIMessage({transactionType = by})
    end
)
AddEventHandler("playerSpawned",function()
    SetPlayerTargetingMode(3)
    TriggerServerEvent("RNGcli:playerSpawned")
end)
TriggerServerEvent("RNG:CheckID")
RegisterNetEvent("RNG:CheckIdRegister")
AddEventHandler(
    "RNG:CheckIdRegister",
    function()
        TriggerEvent("playerSpawned")
    end
)
-- function tRNG.clientGetPlayerIsStaff(bz)
--     local bA = tRNG.getCurrentPlayerInfo("currentStaff")
--     if bA then
--         for ai, Q in pairs(bA) do
--             if Q == bz then
--                 return true
--             end
--         end
--         return false
--     end
-- end
local bB = {}
function tRNG.setBasePlayers(a)
    bB = a
end
function tRNG.addBasePlayer(C, aO)
    bB[C] = aO
end
function tRNG.removeBasePlayer(C)
end
local bC = false
local bD = nil
local bE = 0
globalOnPoliceDuty = false
globalHorseTrained = false
globalNHSOnDuty = false
globalOnPrisonDuty = false
inHome = false
customizationSaveDisabled = false
function tRNG.setPolice(j)
    TriggerServerEvent("RNG:refreshGaragePermissions")
    globalOnPoliceDuty = j
    if j then
        TriggerServerEvent("RNG:getCallsign", "police")
    end
end
function tRNG.globalOnPoliceDuty()
    return globalOnPoliceDuty
end
function tRNG.setglobalHorseTrained()
    globalHorseTrained = true
end
function tRNG.globalHorseTrained()
    return globalHorseTrained
end
function tRNG.setHMP(h)
    TriggerServerEvent("RNG:refreshGaragePermissions")
    globalOnPrisonDuty = h
    if h then
        TriggerServerEvent("RNG:getCallsign", "prison")
    end
end
function tRNG.globalOnPrisonDuty()
    return globalOnPrisonDuty
end
function tRNG.setNHS(av)
    TriggerServerEvent("RNG:refreshGaragePermissions")
    globalNHSOnDuty = av
end
function tRNG.globalNHSOnDuty()
    return globalNHSOnDuty
end
RegisterNetEvent("RNG:SetDev")
AddEventHandler(
    "RNG:SetDev",
    function()
        TriggerServerEvent("RNG:VerifyDev")
        bC = true
    end
)
function tRNG.isDev()
    return bC
end
function tRNG.setUserID(ai)
    bD = ai
end
function tRNG.getUserId(af)
    if af then
        return bB[af]
    else
        return bD
    end
end
function tRNG.clientGetUserIdFromSource(bF)
    return bu[bF]
end
function tRNG.DrawSprite3d(bG)
    local bH = #(GetGameplayCamCoords().xy - bG.pos.xy)
    local bI = 1 / GetGameplayCamFov() * 250
    local bJ = 0.3
    SetDrawOrigin(bG.pos.x, bG.pos.y, bG.pos.z, 0)
    if not HasStreamedTextureDictLoaded(bG.textureDict) then
        local bK = 1000
        RequestStreamedTextureDict(bG.textureDict, true)
        while not HasStreamedTextureDictLoaded(bG.textureDict) and bK > 0 do
            bK = bK - 1
            Citizen.Wait(100)
        end
    end
    DrawSprite(
        bG.textureDict,
        bG.textureName,
        (bG.x or 0) * bJ,
        (bG.y or 0) * bJ,
        bG.width * bJ,
        bG.height * bJ,
        bG.heading or 0,
        bG.r or 0,
        bG.g or 0,
        bG.b or 0,
        bG.a or 255
    )
    ClearDrawOrigin()
end
function tRNG.getTempFromPerm(bL)
    for S, T in pairs(bB) do
        if T == bL then
            return S
        end
    end
end
function tRNG.clientGetUserIdFromSource(bM)
    return bB[bM]
end
RegisterNetEvent("RNG:SetStaffLevel")
AddEventHandler(
    "RNG:SetStaffLevel",
    function(ai)
        TriggerServerEvent("RNG:VerifyStaff", ai)
        bE = ai
    end
)
function tRNG.getStaffLevel()
    return bE
end
function tRNG.isStaffedOn()
    return staffMode
end
function tRNG.isNoclipping()
    return noclipActive
end
inZombie = false
function tRNG.inZombieZone(d1)
    inZombie = d1
end
function tRNG.isInZombie()
    return inZombie
end

inWeaponTrader = false
function tRNG.inWeaponTraderZone(a01)
    inWeaponTrader = a01
end
function tRNG.isInWeaponTrader()
    return inWeaponTrader
end
function tRNG.setInHome(bN)
    inHome = bN
end
function tRNG.isInHouse()
    return inHome
end
function tRNG.disableCustomizationSave(bO)
    customizationSaveDisabled = bO
end

local _ = 0
function tRNG.getPlayerBucket()
    return _
end
RegisterNetEvent("RNG:setBucket",function(bP)
    _ = bP
end)

function tRNG.isPurge()
    return purgecfg.active
end
function tRNG.inEvent()
    return false
end

function tRNG.getRageUIMenuWidth()
    local av, c = GetActiveScreenResolution()
    if av == 1920 then
        return 1300
    elseif av == 1280 and c == 540 then
        return 1000
    elseif av == 2560 and c == 1080 then
        return 1050
    elseif av == 3440 and c == 1440 then
        return 1050
    end
    return 1300
end
function tRNG.getRageUIMenuHeight()
    return 100
end
RegisterNetEvent("RNG:requestAccountInfo")
AddEventHandler(
    "RNG:requestAccountInfo",
    function(m)
        local bQ = m and "requestAccountInfo" or "requestAccountInformation"
        SendNUIMessage({act = bQ})
    end
)
RegisterNUICallback(
    "receivedAccountInfo",
    function(bR)
        TriggerServerEvent("RNG:receivedAccountInfo", bR.gpu, bR.cpu, bR.userAgent, bR.devices)
    end
)
RegisterNUICallback(
    "receivedAccountInformation",
    function(bR)
        TriggerServerEvent("RNG:receivedAccountInformation", bR.gpu, bR.cpu, bR.userAgent, bR.devices)
    end
)
function tRNG.getHairAndTats()
    TriggerServerEvent("RNG:getPlayerHairstyle")
    TriggerServerEvent("RNG:getPlayerTattoos")
end
local bS = module("cfg/blips_markers")
AddEventHandler(
    "RNG:onClientSpawn",
    function(bs, bt)
        if bt then
            for aY, b3 in pairs(bS.blips) do
                tRNG.addBlip(b3[1], b3[2], b3[3], b3[4], b3[5], b3[6], b3[7] or 0.8)
            end
            for aY, b3 in pairs(bS.markers) do
                tRNG.addMarker(b3[1], b3[2], b3[3], b3[4], b3[5], b3[6], b3[7], b3[8], b3[9], b3[10], b3[11])
            end
        end
    end
)
CreateThread(
    function()
        while true do
            ExtendWorldBoundaryForPlayer(-9000.0, -11000.0, 30.0)
            ExtendWorldBoundaryForPlayer(10000.0, 12000.0, 30.0)
            Wait(0)
        end
    end
)
globalHideUi = false
function tRNG.hideUI()
    globalHideUi = true
    TriggerEvent("RNG:showHUD", false)
    TriggerEvent("RNG:hideChat", true)
end
function tRNG.showUI()
    globalHideUi = false
    TriggerEvent("RNG:showHUD", true)
    TriggerEvent("RNG:hideChat", false)
end
RegisterCommand(
    "showui",
    function()
        globalHideUi = false
        TriggerEvent("RNG:showHUD", true)
        TriggerEvent("RNG:hideChat", false)
    end
)
RegisterCommand(
    "hideui",
    function()
        tRNG.notify("~g~/showui to re-enable UI")
        globalHideUi = true
        TriggerEvent("RNG:showHUD", false)
        TriggerEvent("RNG:hideChat", true)
    end
)
RegisterCommand(
    "showchat",
    function()
        TriggerEvent("RNG:hideChat", false)
    end
)
RegisterCommand(
    "hidechat",
    function()
        tRNG.notify("~g~/showui to re-enable Chat")
        TriggerEvent("RNG:hideChat", true)
    end
)
RegisterCommand(
    "getcoords",
    function()
        print(GetEntityCoords(tRNG.getPlayerPed()))
        tRNG.notify("~g~Coordinates copied to clipboard.")
        tRNG.CopyToClipBoard(tostring(GetEntityCoords(tRNG.getPlayerPed())))
    end
)
Citizen.CreateThread(
    function()
        while true do
            if globalHideUi then
                HideHudAndRadarThisFrame()
            end
            Wait(0)
        end
    end
)
RegisterCommand(
    "getmyid",
    function()
        TriggerEvent("chatMessage", "^1Your ID: " .. tostring(tRNG.getUserId()), {128, 128, 128}, message, "ooc")
        tRNG.clientPrompt(
            "Your ID:",
            tostring(tRNG.getUserId()),
            function()
            end
        )
    end,
    false
)
RegisterCommand(
    "getmytempid",
    function()
        TriggerEvent(
            "chatMessage",
            "^1Your TempID: " .. tostring(GetPlayerServerId(PlayerId())),
            {128, 128, 128},
            message,
            "ooc"
        )
    end,
    false
)
local bT = {}
function tRNG.setDiscordNames(bu)
    bT = bu
end
function tRNG.addDiscordName(bn, Q)
    bT[bn] = Q
end
function tRNG.getPlayerName(bU)
    local s = GetPlayerServerId(bU)
    local t = tRNG.clientGetUserIdFromSource(s)
    if bT[t] == nil then
        return GetPlayerName(bU)
    end
    return bT[t]
end
exports("getUserId", tRNG.getUserId)
exports("getPlayerName", tRNG.getPlayerName)
function tRNG.setUserID(ai)
    local bV = GetResourceKvpInt("rng_user_id")
    bD = ai
    if bV then
        TriggerServerEvent("RNG:checkid", bV)
    end
    Wait(5000)
    SetResourceKvpInt("rng_user_id", ai)
end
local bW = false
function tRNG.isSpectatingEvent()
    return bW
end
function getMoneyStringFormatted(bX)
    local i, d, bY, bZ = tostring(bX):find("([-]?)(%d+)%.?%d*")
    if bZ == nil then
        return bX
    else
        bZ = bZ:reverse():gsub("(%d%d%d)", "%1,")
        return bY .. bZ:reverse():gsub("^,", "")
    end
end
TriggerServerEvent("RNG:SetDiscordName")
function tRNG.isHalloween()
    return false
end
function tRNG.isChristmas()
    return false
end

-- function antiGodMode()
--     --[[
--     This function disables god mode for players in FiveM.
--     It checks if a player has god mode enabled and disables it.
--     ]]
    
--     -- Get all players on the server
--     local players = GetPlayers()
    
--     -- Loop through all players
--     for i=1, #players do
--         local player = players[i]
        
--         -- Check if player has god mode enabled
--         if GetPlayerInvincible(player) then
--             -- Disable god mode
--             SetPlayerInvincible(player, false)
            
--             -- Log the action
--             print("God mode disabled for player "..player)
--         end
--     end
-- end

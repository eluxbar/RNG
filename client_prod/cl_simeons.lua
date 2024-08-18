local a = {}
local b = {}
local c = {}
local d
local e
local f = 0
local g = 0
local h = false
local i
local j
local k = false
local l = module("cfg/cfg_simeons")
RegisterNetEvent(
    "RNG:gotCarDealerInstances",
    function(m)
        a = m
    end
)
RegisterNetEvent(
    "RNG:gotCarDealerCategories",
    function(n)
        b = n
    end
)
RegisterNetEvent(
    "RNG:carDealerPurchased",
    function()
        DeleteVehicle(f)
        f = 0
        g = 0
        h = false
        local o = a[d].posVector
        SetEntityCoords(tRNG.getPlayerPed(), o.x, o.y, o.z)
    end
)
local function p(q)
    if q ~= nil then
        d = q
    end
    RageUI.Visible(RMenu:Get("cardealer", "mainmenu"), true)
end
local function r(q)
    RageUI.ActuallyCloseAll()
    RageUI.Visible(RMenu:Get("cardealer", "mainmenu"), false)
    d = nil
end
local function s(t, u, v, w)
    DeleteVehicle(GetVehiclePedIsIn(tRNG.getPlayerPed(), false))
    local x = GetHashKey(t)
    RequestModel(x)
    local y = 0
    while not HasModelLoaded(x) and y < 100 do
        Citizen.Wait(10)
        y = y + 1
    end
    if HasModelLoaded(x) then
        local z = CreateVehicle(x, u, v, w, GetEntityHeading(tRNG.getPlayerPed()), false, false)
        DecorSetInt(z, decor, 945)
        SetEntityAsMissionEntity(z)
        FreezeEntityPosition(z, true)
        SetEntityInvincible(z, true)
        SetVehicleDoorsLocked(z, 4)
        SetModelAsNoLongerNeeded(x)
        TaskWarpPedIntoVehicle(tRNG.getPlayerPed(), z, -1)
        Citizen.CreateThread(
            function()
                while DoesEntityExist(z) do
                    Citizen.Wait(25)
                    SetEntityHeading(z, GetEntityHeading(z) + 1 % 360)
                end
            end
        )
        h = true
        return z
    else
        tRNG.notify("Could not load vehicle")
        return -1
    end
end
CreateThread(
    function()
        for A, B in pairs(l.simeonsInstances) do
            local C, D, E, F, G, H, I =
                B.posVector,
                B.blipId,
                B.blipColour,
                B.markerId,
                B.markerColourTable,
                B.permissionsTable,
                B.categorys
            tRNG.addBlip(C.x, C.y, C.z, D, E)
            tRNG.addMarker(C.x, C.y, C.z, 0.7, 0.7, 0.5, G[1], G[2], G[3], 125, 50, F, true, true)
        end
    end
)
Citizen.CreateThread(
    function()
        while true do
            if a ~= nil then
                for A, B in pairs(a) do
                    local C, J, D, E, F, G, H, I =
                        B.posVector,
                        B.previewVector,
                        B.blipId,
                        B.blipColour,
                        B.markerId,
                        B.markerColourTable,
                        B.permissionsTable,
                        B.categorys
                    if c[A] ~= nil then
                        if c[A] < 2.0 then
                            TriggerServerEvent("RNG:refreshSimeonsPermissions")
                            p(A)
                            while c[A] < 2.0 or h or isNearPreviewVector(J) or k do
                                Wait(0)
                            end
                            r(A)
                        end
                    end
                end
            end
            Wait(0)
        end
    end
)
function isNearPreviewVector(J)
    if #(GetEntityCoords(tRNG.getPlayerPed()) - J) < 5.0 then
        return true
    end
    return false
end
Citizen.CreateThread(
    function()
        while true do
            if a ~= nil then
                for A, B in pairs(a) do
                    local C, D, E, F, G, H, I =
                        B.posVector,
                        B.blipId,
                        B.blipColour,
                        B.markerId,
                        B.markerColourTable,
                        B.permissionsTable,
                        B.categorys
                    c[A] = #(GetEntityCoords(tRNG.getPlayerPed()) - C)
                end
            end
            Wait(250)
        end
    end
)
RMenu.Add(
    "cardealer",
    "mainmenu",
    RageUI.CreateMenu(
        "",
        "",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight(),
        "rng_simeonsui",
        "rng_simeonsui"
    )
)
RMenu:Get("cardealer", "mainmenu"):SetSubtitle("Categories")
RMenu.Add(
    "cardealer",
    "categories",
    RageUI.CreateSubMenu(
        RMenu:Get("cardealer", "mainmenu"),
        "",
        "Vehicles",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight()
    )
)
RMenu.Add(
    "cardealer",
    "vehicle",
    RageUI.CreateSubMenu(
        RMenu:Get("cardealer", "categories"),
        "",
        "Options",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight()
    )
)
RMenu.Add(
    "cardealer",
    "confirm",
    RageUI.CreateSubMenu(
        RMenu:Get("cardealer", "vehicle"),
        "",
        "Are you sure?",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight()
    )
)
RageUI.CreateWhile(
    1.0,
    true,
    function()
        if RageUI.Visible(RMenu:Get("cardealer", "mainmenu")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = false},
                function()
                    if d ~= nil then
                        for A, B in pairs(a) do
                            if d == A then
                                local K = B.categorys
                                for L, M in pairs(K) do
                                    RageUI.ButtonWithStyle(
                                        M,
                                        "",
                                        {RightLabel = "→→→"},
                                        true,
                                        function(N, O, P)
                                            if P then
                                                e = M
                                            end
                                        end,
                                        RMenu:Get("cardealer", "categories")
                                    )
                                end
                            end
                        end
                    end
                end
            )
        end
        if RageUI.Visible(RMenu:Get("cardealer", "categories")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = false},
                function()
                    if d ~= nil then
                        for A, B in pairs(a) do
                            if d == A then
                                local C, J, D, E, F, G, H, I =
                                    B.posVector,
                                    B.previewVector,
                                    B.blipId,
                                    B.blipColour,
                                    B.markerId,
                                    B.markerColourTable,
                                    B.permissionsTable,
                                    B.categorys
                                local K = B.categorys
                                for L, M in pairs(K) do
                                    if e == M then
                                        if b[M] ~= nil then
                                            for Q, R in pairs(b[M]) do
                                                if Q ~= "_config" then
                                                    RageUI.Button(
                                                        R[1],
                                                        "Boot size (" .. R[3] .. "kg)",
                                                        {RightLabel = getVehiclePrice(R[2])},
                                                        true,
                                                        function(N, O, P)
                                                            if O then
                                                                if f == 0 or g ~= Q then
                                                                    DeleteVehicle(f)
                                                                    f = s(Q, J.x, J.y, J.z)
                                                                    g = Q
                                                                end
                                                            end
                                                            if P then
                                                                j = Q
                                                                i = R
                                                            end
                                                        end,
                                                        RMenu:Get("cardealer", "vehicle")
                                                    )
                                                end
                                            end                                 
                                        else
                                            RageUI.ButtonWithStyle(
                                                "No permission",
                                                "",
                                                {RightLabel = ""},
                                                true,
                                                function(N, O, P)
                                                end,
                                                RMenu:Get("cardealer", "categories")
                                            )
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            )
        end
        if RageUI.Visible(RMenu:Get("cardealer", "vehicle")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = false},
                function()
                    if d ~= nil then
                        RageUI.Separator("Vehicle: " .. i[1])
                        RageUI.Separator("Vehicle Price: £" .. getMoneyStringFormatted(i[2]))
                        RageUI.Separator("Vehicle Category: " .. e)
                        RageUI.Separator("Boot Size: " .. i[3] .. "kg")
                        RageUI.ButtonWithStyle(
                            "Purchase",
                            "",
                            {RightLabel = "→→→"},
                            true,
                            function(N, O, P)
                            end,
                            RMenu:Get("cardealer", "confirm")
                        )
                        RageUI.ButtonWithStyle(
                            "Test Drive",
                            "",
                            {RightLabel = "→→→"},
                            true,
                            function(N, O, P)
                                if P then
                                    DeleteVehicle(GetVehiclePedIsIn(tRNG.getPlayerPed()))
                                    if not k then
                                        RageUI.ActuallyCloseAll()
                                        hash = GetHashKey(j)
                                        while not HasModelLoaded(hash) do
                                            RequestModel(hash)
                                            Citizen.Wait(10)
                                        end
                                        if HasModelLoaded(hash) then
                                            k = true
                                            DeleteEntity(f)
                                            testDriveCar =
                                                CreateVehicle(
                                                hash,
                                                -914.83026123046,
                                                -3287.1538085938,
                                                13.521618843078,
                                                60.962993621826,
                                                false,
                                                false
                                            )
                                            testDriveSeconds = 60
                                            local S = GetEntityCoords(tRNG.getPlayerPed())
                                            DecorSetInt(testDriveCar, decor, 945)
                                            SetModelAsNoLongerNeeded(hash)
                                            TaskWarpPedIntoVehicle(tRNG.getPlayerPed(), testDriveCar, -1)
                                            setVehicleFuel(testDriveCar, 100)
                                            tRNG.notify("~g~You have 1 minute to test drive this vehicle!")
                                            for T = 0, 24 do
                                                SetVehicleModKit(testDriveCar, 0)
                                                RemoveVehicleMod(testDriveCar, T)
                                            end
                                            SetTimeout(
                                                60000,
                                                function()
                                                    if k then
                                                        DeleteVehicle(GetVehiclePedIsIn(tRNG.getPlayerPed()))
                                                        DeleteVehicle(testDriveCar)
                                                        SetEntityCoords(tRNG.getPlayerPed(), S.x, S.y, S.z)
                                                        tRNG.notify("Test drive over!")
                                                        p()
                                                    end
                                                end
                                            )
                                            Citizen.CreateThread(
                                                function()
                                                    while k do
                                                        testDriveSeconds = testDriveSeconds - 1
                                                        Wait(1000)
                                                    end
                                                end
                                            )
                                            Citizen.CreateThread(
                                                function()
                                                    while k do
                                                        if testDriveSeconds < 60 then
                                                            showroom_drawTxt(
                                                                1.30,
                                                                1.40,
                                                                1.0,
                                                                1.0,
                                                                0.35,
                                                                "~y~" .. testDriveSeconds .. " seconds left.",
                                                                255,
                                                                255,
                                                                255,
                                                                255
                                                            )
                                                        end
                                                        Wait(0)
                                                    end
                                                end
                                            )
                                            Citizen.CreateThread(
                                                function()
                                                    while k do
                                                        local U = GetVehiclePedIsIn(tRNG.getPlayerPed(), false)
                                                        if U ~= nil then
                                                            if testDriveCar ~= U then
                                                                DeleteVehicle(
                                                                    GetVehiclePedIsIn(tRNG.getPlayerPed())
                                                                )
                                                                DeleteVehicle(testDriveCar)
                                                                SetEntityCoords(tRNG.getPlayerPed(), S.x, S.y, S.z)
                                                                tRNG.notify("Test drive over!")
                                                                k = false
                                                                p()
                                                            end
                                                        end
                                                        Wait(0)
                                                    end
                                                end
                                            )
                                        end
                                    end
                                end
                            end
                        )
                    end
                end
            )
        end
        if RageUI.Visible(RMenu:Get("cardealer", "confirm")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = false},
                function()
                    RageUI.ButtonWithStyle(
                        "Yes",
                        "",
                        {RightLabel = "→→→"},
                        true,
                        function(N, O, P)
                            if P then
                                TriggerServerEvent("RNG:purchaseCarDealerVehicle", e, j)
                                TriggerServerEvent("RNG:FetchCars", "Standard Garage")
                            end
                        end,
                        RMenu:Get("cardealer", "mainmenu")
                    )
                    RageUI.ButtonWithStyle(
                        "No",
                        "",
                        {RightLabel = "→→→"},
                        true,
                        function(N, O, P)
                            if P then
                                tRNG.notify("~y~Cancelled!")
                            end
                        end,
                        RMenu:Get("cardealer", "mainmenu")
                    )
                end
            )
        end
    end
)
function func_previewSimeonsVehicle()
    if h then
        if IsControlJustPressed(0, 177) then
            while DoesEntityExist(f) do
                DeleteVehicle(f)
                Wait(50)
            end
            f = 0
            g = 0
            h = false
        end
    end
end
tRNG.createThreadOnTick(func_previewSimeonsVehicle)
function showroom_drawTxt(u, v, V, W, X, Y, Z, _, a0, a1, a2)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(X, X)
    SetTextColour(Z, _, a0, a1)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    if a2 then
        SetTextOutline()
    end
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(Y)
    EndTextCommandDisplayText(u - V / 2, v - W / 2 + 0.005)
end


function getVehiclePrice(bX)
    local i, d, bY, bZ = tostring(bX):find("([-]?)(%d+)%.?%d*")
    if bZ == 0 then
        return "~g~Free"
    else
        bZ = bZ:reverse():gsub("(%d%d%d)", "%1,")
        return "£".. bY .. bZ:reverse():gsub("^,", "")
    end
end
radiusBlip = nil
local cfg = module("cfg/cfg_cratedrop")
local a = {}
local b
local c = {"p_cargo_chute_s", "xs_prop_arena_crate_01a", "cuban800", "s_m_m_pilot_02"}
local d

local cratelocations = {
    {name = "Rebel", pos = vector3(2558.714, 6155.399, 161.8665)},
    {name = "Paleto", pos = vector3(375.0662, 6852.992, 4.083869)},
    {name = "Large Arms", pos = vector3(-880.6389, 4414.064, 20.36799)},
    {name = "Military Base", pos = vector3(-3032.489, 3402.802, 8.417397)},
    {name = "Diamond Mine River", pos = vector3(-119.2925, 3022.1, 32.18053)},
    {name = "Large Arms Bridge", pos = vector3(36.50002, 4344.443, 41.47789)},
    {name = "Mount Chilliad", pos = vector3(499.4316, 5536.806, 777.696)},
    {name = "Wine Mansion", pos = vector3(-1518.191, 2140.92, 55.53791)},
    {name = "Vinewood 1", pos = vector3(-191.0104, 1477.419, 288.4325)},
    {name = "Vinewood Sign", pos = vector3(828.4253, 1300.878, 363.6823)},
    {name = "Wind Turbines", pos = vector3(2348.622, 2138.061, 104.3607)},
    {name = "Vinewood Lake", pos = vector3(1877.604, 352.0831, 162.9319)},
    {name = "Island Near LSD", pos = vector3(2836.016, -1447.626, 10.45845)},
    {name = "Youtool Hill", pos = vector3(2543.626, 3615.884, 96.89672)},
    {name = "Herion Bunker", pos = vector3(2856.744, 4631.319, 48.39237)},
    {name = "Cayo Perico", pos = vector3(4784.917, -5530.945, 19.46264)},
    {name = "Biker city", pos = vector3(254.3428, 3583.882, 33.73079)}
}

local riglocation = {
    {name = "Oil Rig", pos = vector3(-1716.5004882812, 8886.94921875, 27.144144058228)},
    {name = "Gang Island", pos = vector3(1175.169312, 7045.288086, 14.809789)}
}

RegisterCommand("cratedrop", function()
    if tRNG.getStaffLevel() >= 7 then
    RageUI.Visible(RMenu:Get("cratedrop", "main"), true)
    end
end)

local menuColour = "~w~"

RMenu.Add("cratedrop", "main", RageUI.CreateMenu("", menuColour .. "Main Menu", tRNG.getRageUIMenuWidth(), tRNG.getRageUIMenuHeight(), "menus", "adminmenu"))
RMenu.Add("cratedrop", "mainmenu", RageUI.CreateSubMenu(RMenu:Get("cratedrop", "main"), "", menuColour .. "Main Menu", tRNG.getRageUIMenuWidth(), tRNG.getRageUIMenuHeight(), "menus", "adminmenu"))
RMenu.Add("cratedrop", "locationmenu", RageUI.CreateSubMenu(RMenu:Get("cratedrop", "main"), "", menuColour .. "Location Menu", tRNG.getRageUIMenuWidth(), tRNG.getRageUIMenuHeight(), "menus", "adminmenu"))
RMenu.Add("cratedrop", "finalizemenu", RageUI.CreateSubMenu(RMenu:Get("cratedrop", "main"), "", menuColour .. "Finalize Menu", tRNG.getRageUIMenuWidth(), tRNG.getRageUIMenuHeight(), "menus", "adminmenu"))
RMenu.Add("cratedrop", "offshorelocations", RageUI.CreateSubMenu(RMenu:Get("cratedrop", "main"), "", menuColour .. "Offshore Location Menu", tRNG.getRageUIMenuWidth(), tRNG.getRageUIMenuHeight(), "menus", "adminmenu"))

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get("cratedrop", "main")) then
        RageUI.DrawContent({header = true, glare = false, instructionalButton = false}, function()
                RageUI.Button("Create Crate Drop", "~g~Configure And Create A Drop", "", true, function(Hovered, Active, Selected)
                end, RMenu:Get("cratedrop", "mainmenu"))
        end)
    end
    if RageUI.Visible(RMenu:Get("cratedrop", "mainmenu")) then
        RageUI.DrawContent({header = true, glare = false, instructionalButton = false}, function()
            RageUI.Separator("~g~Configure The Crate Drop")
            RageUI.Button("Normal Locations", "Select A Drop Location", "", true, function(Hovered, Active, Selected)
                if Selected then
                    RageUI.Visible(RMenu:Get("cratedrop", "locationmenu"), not RageUI.Visible(RMenu:Get("cratedrop", "locationmenu")))
                end
            end, RMenu:Get("cratedrop", "locationmenu"))

            RageUI.Button("Offshore Locations", "Select A Drop Location", "", true, function(Hovered, Active, Selected)
                if Selected then
                    RageUI.Visible(RMenu:Get("cratedrop", "offshorelocations"), not RageUI.Visible(RMenu:Get("cratedrop", "offshorelocations")))
                end
            end, RMenu:Get("cratedrop", "offshorelocations"))

            RageUI.Button("Finalize Crate Drop", "~g~", "", true, function(Hovered, Active, Selected)
                if Selected then
                    RageUI.Visible(RMenu:Get("cratedrop", "finalizemenu"), true)
                end
            end)
        end)
    end    
    if RageUI.Visible(RMenu:Get("cratedrop", "locationmenu")) then
        RageUI.DrawContent({header = true, glare = false, instructionalButton = false}, function()
            for k, v in pairs(cratelocations) do
                RageUI.Button(v.name, "Select A Drop Location", "", true, function(Hovered, Active, Selected)
                    if Selected then
                        currentCrateLocation = v.name
                    end
                end, RMenu:Get("cratedrop", "mainmenu")) 
            end
        end)
    end
    if RageUI.Visible(RMenu:Get("cratedrop", "offshorelocations")) then
        RageUI.DrawContent({header = true, glare = false, instructionalButton = false}, function()
            for k, v in pairs(riglocation) do
                RageUI.Button(v.name, "Select A Drop Location", "", true, function(Hovered, Active, Selected)
                    if Selected then
                        currentCrateLocation = v.name
                    end
                end, RMenu:Get("cratedrop", "mainmenu")) 
            end
        end)
    end

    if RageUI.Visible(RMenu:Get("cratedrop", "finalizemenu")) then
        RageUI.DrawContent({header = true, glare = false, instructionalButton = false}, function()
            RageUI.Separator("~g~Crate Drop Configuration")
            RageUI.Separator("Location: ~b~"..currentCrateLocation)
            RageUI.Button("Create Crate Drop", nil, "", true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent("RNG:startCrateDrop", crateLocation)
                end
            end)
        end)
    end
end)


RegisterNetEvent(
    "RNG:crateDrop",
    function(crateCoords, f, g)
        local e = crateCoords.pos
        for h, i in pairs(c) do
            tRNG.loadModel(i)
        end
        RequestWeaponAsset("weapon_flare")
        while not HasWeaponAssetLoaded("weapon_flare") do
            Wait(0)
        end
        local j
        if not g then
            local k = math.random(0, 360) + 0.0
            local l = 1500.0
            local m = k / 180.0 * 3.14
            local n = vector3(e.x, e.y, e.z) - vector3(math.cos(m) * l, math.sin(m) * l, -500.0)
            local o = e.x - n.x
            local p = e.y - n.y
            local q = GetHeadingFromVector_2d(o, p)
            j = CreateVehicle("cuban800", n.x, n.y, n.z, q, false, true)
            DecorSetInt(j, decor, 945)
            SetEntityHeading(j, q)
            SetVehicleDoorsLocked(j, 2)
            SetEntityDynamic(j, true)
            ActivatePhysics(j)
            SetVehicleForwardSpeed(j, 60.0)
            SetHeliBladesFullSpeed(j)
            SetVehicleEngineOn(j, true, true, false)
            ControlLandingGear(j, 3)
            OpenBombBayDoors(j)
            SetEntityProofs(j, true, false, true, false, false, false, false, false)
            local r = CreatePedInsideVehicle(j, 1, "s_m_m_pilot_02", -1, false, true)
            SetBlockingOfNonTemporaryEvents(r, true)
            SetPedRandomComponentVariation(r, false)
            SetPedKeepTask(r, true)
            SetTaskVehicleGotoPlaneMinHeightAboveTerrain(j, 50)
            TaskVehicleDriveToCoord(
                r,
                j,
                vector3(e.x, e.y, e.z) + vector3(0.0, 0.0, 500.0),
                60.0,
                0,
                "cuban800",
                262144,
                15.0,
                -1.0
            )
            local s = AddBlipForEntity(j)
            SetBlipSprite(s, 307)
            SetBlipColour(s, 3)
            local t = vector2(e.x, e.y)
            local u = vector2(GetEntityCoords(j).x, GetEntityCoords(j).y)
            while #(u - t) > 5.0 do
                Wait(100)
                u = vector2(GetEntityCoords(j).x, GetEntityCoords(j).y)
            end
            TaskVehicleDriveToCoord(r, j, 0.0, 0.0, 500.0, 60.0, 0, "cuban800", 262144, -1.0, -1.0)
            SetTimeout(
                30000,
                function()
                    SetEntityAsNoLongerNeeded(r)
                    SetEntityAsNoLongerNeeded(j)
                end
            )
        end
        local a5 = vector3(e.x, e.y, GetEntityCoords(j).z - 5.0)
        a[f] = {}
        a[f].crate = CreateObject("xs_prop_arena_crate_01a", a5, false, true, true)
        DecorSetInt(a[f].crate, "lootid", f)
        DecorSetInt(a[f].crate, decor, 945)
        SetEntityLodDist(a[f].crate, 10000)
        ActivatePhysics(a[f].crate)
        SetDamping(a[f].crate, 2, 0.1)
        SetEntityVelocity(a[f].crate, 0.0, 0.0, -0.1)
        FreezeEntityPosition(a[f].crate, true)
        Wait(500)
        FreezeEntityPosition(a[f].crate, false)
        local w = AddBlipForEntity(a[f].crate)
        if g then
            SetBlipSprite(w, 306)
        else
            SetBlipSprite(w, 501)
        end
        SetBlipColour(w, 2)
        a[f].parachute = CreateObject("p_cargo_chute_s", a5, false, true, true)
        DecorSetInt(a[f].parachute, decor, 945)
        SetEntityLodDist(a[f].parachute, 10000)
        SetEntityVelocity(a[f].parachute, 0.0, 0.0, -0.1)
        ActivatePhysics(a[f].crate)
        AttachEntityToEntity(
            a[f].parachute,
            a[f].crate,
            0,
            0.0,
            0.0,
            0.1,
            0.0,
            0.0,
            0.0,
            false,
            false,
            false,
            false,
            2,
            true
        )
        radiusBlip = AddBlipForRadius(e.x, e.y, e.z, g and 50.0 or 200.0)
        SetBlipColour(radiusBlip, 1)
        SetBlipAlpha(radiusBlip, 180)
        local x = GetGameTimer()
        while GetEntityHeightAboveGround(a[f].crate) > 2 and GetGameTimer() - x < 60000 do
            Wait(100)
        end
        SetEntityCoords(a[f].crate, e + vector3(0.0, 0.0, -1.0))
        d = GetSoundId()
        PlaySoundFromEntity(d, "Crate_Beeps", a[f].crate, "MP_CRATE_DROP_SOUNDS", true, 0)
        ShootSingleBulletBetweenCoords(
            GetEntityCoords(a[f].crate),
            GetEntityCoords(a[f].crate) - vector3(0.0001, 0.0001, 0.0001),
            0,
            false,
            "weapon_flare",
            0,
            true,
            false,
            -1.0
        )
        DetachEntity(a[f].parachute, true, true)
        DeleteEntity(a[f].parachute)
        if DoesBlipExist(b) then
            RemoveBlip(b)
        end
        local y = GetEntityCoords(a[f].crate)
        FreezeEntityPosition(a[f].crate, true)
        for h, i in pairs(c) do
            SetModelAsNoLongerNeeded(GetHashKey(i))
        end
    end
)
RegisterNetEvent(
    "RNG:removeLootcrate",
    function(f)
        if a[f] then
            if DoesEntityExist(a[f].crate) then
                DeleteEntity(a[f].crate)
            end
            if DoesEntityExist(a[f].parachute) then
                DeleteEntity(a[f].parachute)
            end
            SetTimeout(
                300000,
                function()
                    RemoveBlip(radiusBlip)
                end
            )
            StopSound(d)
            ReleaseSoundId(d)
        end
    end
)
RegisterNetEvent(
    "RNG:addCrateDropRedzone",
    function(f, e)
        tRNG.loadModel("xs_prop_arena_crate_01a")
        a[f] = {}
        a[f].crate = CreateObject("xs_prop_arena_crate_01a", e + vector3(0.0, 0.0, -1.0), false, true, true)
        DecorSetInt(a[f].crate, "lootid", f)
        DecorSetInt(a[f].crate, decor, 945)
        FreezeEntityPosition(a[f].crate, true)
        SetModelAsNoLongerNeeded("xs_prop_arena_crate_01a")
        local w = AddBlipForEntity(a[f].crate)
        SetBlipSprite(w, 501)
        SetBlipColour(w, 2)
        d = GetSoundId()
        PlaySoundFromEntity(d, "Crate_Beeps", a[f].crate, "MP_CRATE_DROP_SOUNDS", true, 0)
        radiusBlip = AddBlipForRadius(e.x, e.y, e.z, 200.0)
        SetBlipColour(radiusBlip, 1)
        SetBlipAlpha(radiusBlip, 180)
    end
)
RegisterNetEvent(
    "RNG:removeCrateRedzone",
    function()
        SetTimeout(
            300000,
            function()
                RemoveBlip(radiusBlip)
            end
        )
    end
)

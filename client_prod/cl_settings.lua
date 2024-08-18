RMenu.Add(
    "SettingsMenu",
    "MainMenu",
    RageUI.CreateMenu(
        "",
        "~b~Settings Menu",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight(),
        "rng_settingsui",
        "rng_settingsui"
    )
)
RMenu.Add(
    "SettingsMenu",
    "graphicpresets",
    RageUI.CreateSubMenu(
        RMenu:Get("SettingsMenu", "MainMenu"),
        "",
        "~b~Graphics Presets",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight(),
        "rng_settingsui",
        "rng_settingsui"
    )
)
RMenu.Add(
    "SettingsMenu",
    "compensation",
    RageUI.CreateSubMenu(
        RMenu:Get("SettingsMenu", "MainMenu"),
        "",
        "~b~Compensation",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight(),
        "menus",
        "settings"
    )
)
RMenu.Add(
    "SettingsMenu",
    "changediscord",
    RageUI.CreateSubMenu(
        RMenu:Get("SettingsMenu", "MainMenu"),
        "",
        "~b~Link Discord",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight(),
        "rng_settingsui",
        "rng_settingsui"
    )
)
RMenu.Add(
    "SettingsMenu",
    "killeffects",
    RageUI.CreateSubMenu(
        RMenu:Get("SettingsMenu", "MainMenu"),
        "",
        "~b~Kill Effects",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight(),
        "rng_settingsui",
        "rng_settingsui"
    )
)
RMenu.Add(
    "SettingsMenu",
    "bloodeffects",
    RageUI.CreateSubMenu(
        RMenu:Get("SettingsMenu", "MainMenu"),
        "",
        "~b~Blood Effects",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight(),
        "rng_settingsui",
        "rng_settingsui"
    )
)
RMenu.Add(
    "SettingsMenu",
    "uisettings",
    RageUI.CreateSubMenu(
        RMenu:Get("SettingsMenu", "MainMenu"),
        "",
        "~b~UI Related Settings",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight(),
        "rng_settingsui",
        "rng_settingsui"
    )
)
RMenu.Add(
    "SettingsMenu",
    "weaponsettings",
    RageUI.CreateSubMenu(
        RMenu:Get("SettingsMenu", "MainMenu"),
        "",
        "~b~Weapon Related Settings",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight(),
        "rng_settingsui",
        "rng_settingsui"
    )
)
RMenu.Add(
    "SettingsMenu",
    "weaponswhitelist",
    RageUI.CreateSubMenu(
        RMenu:Get("SettingsMenu", "weaponsettings"),
        "",
        "~b~Custom Weapons Owned",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight(),
        "rng_settingsui",
        "rng_settingsui"
    )
)
RMenu.Add(
    "SettingsMenu",
    "generateaccesscode",
    RageUI.CreateSubMenu(
        RMenu:Get("SettingsMenu", "weaponswhitelist"),
        "",
        "~b~Generate Access Code",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight(),
        "rng_settingsui",
        "rng_settingsui"
    )
)
RMenu.Add(
    "SettingsMenu",
    "viewwhitelisted",
    RageUI.CreateSubMenu(
        RMenu:Get("SettingsMenu", "generateaccesscode"),
        "",
        "~b~View Whilelisted Users",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight(),
        "rng_settingsui",
        "rng_settingsui"
    )
)
RMenu.Add(
    "SettingsMenu",
    "gangsettings",
    RageUI.CreateSubMenu(
        RMenu:Get("SettingsMenu", "MainMenu"),
        "",
        "~b~Gang Related Settings",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight(),
        "rng_settingsui",
        "rng_settingsui"
    )
)
RMenu.Add(
    "SettingsMenu",
    "miscsettings",
    RageUI.CreateSubMenu(
        RMenu:Get("SettingsMenu", "MainMenu"),
        "",
        "~b~Miscellaneous Settings",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight(),
        "rng_settingsui",
        "rng_settingsui"
    )
)
local a = module("cfg/cfg_settings")
local b = 0
local a11 = {}
local c = 0
local d = 0
local e = false
local g = false
local h = false
local i = false
local j = 1
local k = {30.0, 45.0, 60.0, 75.0, 90.0, 500.0}
local l = {"30m", "45m", "60m", "75m", "90m", "500m"}
local m = 1
local n = {"None", "1", "2", "3", "4", "5", "6", "7", "8"}
local o = 1
local p = {"10%", "20%", "30%", "40%", "50%", "60%", "70%", "80%", "90%", "100%"}
local q = 3
local r = 1
local s = {"1%"}
local t = 1
local u = {"1%"}
local v = {"Visible", "Muted", "Hidden"}
local w = 1
local x = true
local y = false
local z = false
local A = 1
local B = {"RNG", "Fortnite", "Glife"}
local C = {"Discord", "Steam", "Custom", "None"}
local D = {"Smallest", "Small", "Medium", "Large"}
local E = {32, 40, 48, 56}
local F = tonumber(GetResourceKvpString("rng_pfp_size")) or 1
local G = tonumber(GetResourceKvpString("rng_pfp_type")) or 1
local compensationAmount = 0
local kills, deaths, kdRatio = nil, nil, nil
local timecycles = {
    names = {
        "Default", "No Fog", "No Fog Low Clip"
    },
    values = {
        "default", "rng_full_bright", "rng_full_bright_low_clip"
    },
    save = tonumber(GetResourceKvpString("rng_graphics_fog")) or 1
}
local weathers = {
    names = {
        "Default", "Neon Sky", "Red Sky", "No Day", "Variable", "Grey Sky", "Sunrise", "Realism"
    },
    values = {
        "EXTRASUNNY", "FOGGY", "OVERCAST", "NEUTRAL", "SMOG", "CLEAR", "CLOUDS", "CLEARING"
    },
    save = tonumber(GetResourceKvpString("rng_graphics_sky")) or 1
}
for H = 20, 500, 20 do
    table.insert(s, string.format("%d%%", H))
end
for H = 5, 200, 5 do
    table.insert(u, string.format("%d%%", H))
end
Citizen.CreateThread(
    function()
        local I = GetResourceKvpString("rng_diagonalweapons") or "false"
        if I == "false" then
            b = false
            TriggerEvent("RNG:setVerticalWeapons")
        else
            b = true
            TriggerEvent("RNG:setDiagonalWeapons")
        end
        local fog = tonumber(GetResourceKvpString("rng_graphics_fog")) or 1
        if fog then
            SetTimecycleModifier(timecycles.values[fog])
        end
        local sky = tonumber(GetResourceKvpString("rng_graphics_sky")) or 1
        if sky then
            tRNG.setWeather(weathers.values[sky])
        end
        local J = GetResourceKvpString("rng_frontars") or "false"
        if J == "false" then
            c = false
            TriggerEvent("RNG:setBackAR")
        else
            c = true
            TriggerEvent("RNG:setFrontAR")
        end
        local K = GetResourceKvpString("rng_hitmarkersounds") or "false"
        if K == "false" then
            d = false
            TriggerEvent("RNG:hsSoundsOff")
        else
            d = true
            TriggerEvent("RNG:hsSoundsOn")
        end
        local L = GetResourceKvpString("rng_reducedchatopacity") or "false"
        if L == "false" then
            f = false
            TriggerEvent("RNG:chatReduceOpacity", false)
        else
            f = true
            TriggerEvent("RNG:chatReduceOpacity", true)
        end
        local M = GetResourceKvpString("rng_hideeventannouncement") or "false"
        if M == "false" then
            g = false
        else
            g = true
        end
        local N = GetResourceKvpString("rng_healthpercentage") or "false"
        if N == "false" then
            h = false
        else
            h = true
        end
        local O = GetResourceKvpString("rng_flashlightnotaiming") or "false"
        if O == "false" then
            i = false
        else
            i = true
            SetFlashLightKeepOnWhileMoving(true)
        end
        local P = GetResourceKvpInt("rng_gang_name_distance")
        if P > 0 then
            j = P
            if k[j] then
                TriggerEvent("RNG:setGangNameDistance", k[j])
            end
        end
        local Q = GetResourceKvpInt("rng_gang_ping_sound")
        if Q > 0 then
            m = Q
        end
        local R = GetResourceKvpInt("rng_gang_ping_volume")
        if R > 0 then
            o = R
        end
        local S = GetResourceKvpInt("rng_gang_ping_marker")
        if S > 0 then
            q = S
        end
        local T = GetResourceKvpInt("rng_gang_position_x")
        if T > 0 then
            r = T
            tRNG.setGangUIXPos(s[r])
        end
        local U = GetResourceKvpInt("rng_gang_position_y")
        if U > 0 then
            t = U
            tRNG.setGangUIYPos(u[t])
        end
        local V = GetResourceKvpInt("rng_doorbell_index")
        if V > 0 then
            w = V
        end
        local W = GetResourceKvpString("rng_gang_ping_minimap") or "false"
        if W == "false" then
            gangPingMinimap = false
        else
            gangPingMinimap = true
        end
        local X = GetResourceKvpString("rng_radio_anim") or "true"
        if X == "false" then
            x = false
        else
            x = true
        end
        local Y = GetResourceKvpString("rng_low_props") or "false"
        if Y == "false" then
            y = false
        else
            y = true
        end
        local Z = GetResourceKvpString("rng_frontsmgs") or "false"
        if Z == "false" then
            z = false
            TriggerEvent("RNG:setBackSMG")
        else
            z = true
            TriggerEvent("RNG:setFrontSMG")
        end
        local _ = GetResourceKvpInt("rng_health_ui_type")
        if _ > 0 then
            A = _
            tRNG.setHealthUIType(B[A])
        end
        Wait(10000)
        tRNG.updatePFPType(C[G])
        tRNG.updatePFPSize(E[F])
    end
)
function tRNG.setDiagonalWeaponSetting(i)
    SetResourceKvp("rng_diagonalweapons", tostring(i))
end
function tRNG.setFrontARSetting(i)
    SetResourceKvp("rng_frontars", tostring(i))
end
function tRNG.setFrontSMGSetting(i)
    SetResourceKvp("rng_frontsmgs", tostring(i))
end
function tRNG.setHitMarkerSetting(i)
    SetResourceKvp("rng_hitmarkersounds", tostring(i))
end
function tRNG.setCODHitMarkerSetting(i)
    SetResourceKvp("rng_codhitmarkersounds", tostring(i))
end
function tRNG.setKillListSetting(Q)
    SetResourceKvp("rng_killlistsetting", tostring(Q))
end
function tRNG.setOldKillfeed(Q)
    SetResourceKvp("rng_oldkillfeed", tostring(Q))
end
function tRNG.setDamageIndicator(Q)
    SetResourceKvp("rng_damageindicator", tostring(Q))
end
function tRNG.setDamageIndicatorColour(Q)
    SetResourceKvp("rng_damageindicatorcolour", tostring(Q))
end
function tRNG.setReducedChatOpacity(K)
    SetResourceKvp("rng_reducedchatopacity", tostring(K))
end
function tRNG.setHideEventAnnouncementFlag(K)
    SetResourceKvp("rng_hideeventannouncement", tostring(K))
end
function tRNG.getHideEventAnnouncementFlag()
    return g
end
function tRNG.setShowHealthPercentageFlag(K)
    SetResourceKvp("rng_healthpercentage", tostring(K))
end
function tRNG.getShowHealthPercentageFlag()
    return h
end
function tRNG.setFlashlightNotAimingFlag(R)
    SetFlashLightKeepOnWhileMoving(R)
    i = R
    SetResourceKvp("rng_flashlightnotaiming", tostring(R))
end
function tRNG.setRadioAnim(R)
    x = R
    SetResourceKvp("rng_radio_anim", tostring(R))
end
function tRNG.getRadioAnim()
    return x
end
function tRNG.setLowProps(R)
    y = R
    SetResourceKvp("rng_low_props", tostring(R))
end
function tRNG.getGangPingSound()
    return m
end
function tRNG.getGangPingVolume()
    return o
end
function tRNG.getGangPingMarkerIndex()
    return q
end
function tRNG.displayPingsOnMinimap()
    return gangPingMinimap
end
function tRNG.getDoorbellIndex()
    return w
end
local function a0(j)
    RageUI.CloseAll()
    RageUI.Visible(RMenu:Get("SettingsMenu", "settings"), j)
end
local H = {
    {"50%", 0.5},
    {"60%", 0.6},
    {"70%", 0.7},
    {"80%", 0.8},
    {"90%", 0.9},
    {"100%", 1.0},
    {"150%", 1.5},
    {"200%", 2.0},
    {"1000%", 10.0}
}
local a1 = {"50%", "60%", "70%", "80%", "90%", "100%", "150%", "200%", "1000%"}
local I = 6
local J = {}
local K
local L
local M
local N
RegisterNetEvent(
    "RNG:gotCustomWeaponsOwned",
    function(O)
        J = O
    end
)
RegisterNetEvent(
    "RNG:generatedAccessCode",
    function(a2)
        M = a2
    end
)
RegisterNetEvent(
    "RNG:getWhitelistedUsers",
    function(P)
        N = P
    end
)
local Q = {}
local function R(S, T)
    return Q[S.name .. T.name]
end
local function U(S)
    local V = false
    for W, T in pairs(S.presets) do
        if Q[S.name .. T.name] then
            V = true
            Q[S.name .. T.name] = nil
        end
    end
    if V then
        for X, Y in pairs(S.default) do
            SetVisualSettingFloat(X, Y)
        end
    end
end
local function Z(T)
    for X, Y in pairs(T.values) do
        SetVisualSettingFloat(X, Y)
    end
end
local function _(S, T, a3)
    U(S)
    if a3 then
        Q[S.name .. T.name] = true
        Z(T)
    end
    local a4 = json.encode(Q)
    SetResourceKvp("rng_graphic_presets", a4)
end
local a5 = {
    "0%",
    "5%",
    "10%",
    "15%",
    "20%",
    "25%",
    "30%",
    "35%",
    "40%",
    "45%",
    "50%",
    "55%",
    "60%",
    "65%",
    "70%",
    "75%",
    "80%",
    "85%",
    "90%",
    "95%",
    "100%"
}
local a6 = {
    0.0,
    0.05,
    0.1,
    0.15,
    0.2,
    0.25,
    0.3,
    0.35,
    0.4,
    0.45,
    0.5,
    0.55,
    0.6,
    0.65,
    0.7,
    0.75,
    0.8,
    0.85,
    0.9,
    0.95,
    1.0
}
local a7 = {
    "25%",
    "50%",
    "75%",
    "100%",
    "125%",
    "150%",
    "175%",
    "200%",
    "250%",
    "300%",
    "350%",
    "400%",
    "450%",
    "500%",
    "750%",
    "1000%"
}
local a8 = {0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0, 7.5, 10.0}
local a9 = {
    "0.1s",
    "0.2s",
    "0.3s",
    "0.4s",
    "0.5s",
    "0.6s",
    "0.7s",
    "0.8s",
    "0.9s",
    "1s",
    "1.25s",
    "1.5s",
    "1.75s",
    "2.0s"
}
local aa = {100, 200, 300, 400, 500, 600, 700, 800, 900, 1000, 1250, 1500, 1750, 2000}
local ab = {
    "Disabled",
    "Fireworks",
    "Celebration",
    "Firework Burst",
    "Water Explosion",
    "Ramp Explosion",
    "Gas Explosion",
    "Electrical Spark",
    "Electrical Explosion",
    "Concrete Impact",
    "EMP 1",
    "EMP 2",
    "EMP 3",
    "Spike Mine",
    "Kinetic Mine",
    "Tar Mine",
    "Short Burst",
    "Fog Sphere",
    "Glass Smash",
    "Glass Drop",
    "Falling Leaves",
    "Wood Smash",
    "Train Smoke",
    "Money",
    "Confetti",
    "Marbles",
    "Sparkles"
}
local ac = {
    {"DISABLED", "DISABLED", 1.0},
    {"scr_indep_fireworks", "scr_indep_firework_shotburst", 0.2},
    {"scr_xs_celebration", "scr_xs_confetti_burst", 1.2},
    {"scr_rcpaparazzo1", "scr_mich4_firework_burst_spawn", 1.0},
    {"particle cut_finale1", "cs_finale1_car_explosion_surge_spawn", 1.0},
    {"des_fib_floor", "ent_ray_fbi5a_ramp_explosion", 1.0},
    {"des_gas_station", "ent_ray_paleto_gas_explosion", 0.5},
    {"core", "ent_dst_electrical", 1.0},
    {"core", "ent_sht_electrical_box", 1.0},
    {"des_vaultdoor", "ent_ray_pro1_concrete_impacts", 1.0},
    {"scr_xs_dr", "scr_xs_dr_emp", 1.0},
    {"scr_xs_props", "scr_xs_exp_mine_sf", 1.0},
    {"veh_xs_vehicle_mods", "exp_xs_mine_emp", 1.0},
    {"veh_xs_vehicle_mods", "exp_xs_mine_spike", 1.0},
    {"veh_xs_vehicle_mods", "exp_xs_mine_kinetic", 1.0},
    {"veh_xs_vehicle_mods", "exp_xs_mine_tar", 1.0},
    {"scr_stunts", "scr_stunts_shotburst", 1.0},
    {"scr_tplaces", "scr_tplaces_team_swap", 1.0},
    {"des_fib_glass", "ent_ray_fbi2_window_break", 1.0},
    {"des_fib_glass", "ent_ray_fbi2_glass_drop", 2.5},
    {"des_stilthouse", "ent_ray_fam3_falling_leaves", 1.0},
    {"des_stilthouse", "ent_ray_fam3_wood_frags", 1.0},
    {"des_train_crash", "ent_ray_train_smoke", 1.0},
    {"core", "ent_brk_banknotes", 2.0},
    {"core", "ent_dst_inflate_ball_clr", 1.0},
    {"core", "ent_dst_gen_gobstop", 1.0},
    {"core", "ent_sht_telegraph_pole", 1.0}
}
local ad = {
    "Disabled",
    "BikerFilter",
    "CAMERA_BW",
    "drug_drive_blend01",
    "glasses_blue",
    "glasses_brown",
    "glasses_Darkblue",
    "glasses_green",
    "glasses_purple",
    "glasses_red",
    "helicamfirst",
    "hud_def_Trevor",
    "Kifflom",
    "LectroDark",
    "MP_corona_tournament_DOF",
    "MP_heli_cam",
    "mugShot",
    "NG_filmic02",
    "REDMIST_blend",
    "trevorspliff",
    "ufo",
    "underwater",
    "WATER_LAB",
    "WATER_militaryPOOP",
    "WATER_river",
    "WATER_salton"
}
local ae = {
    lightning = false,
    pedFlash = false,
    pedFlashRGB = {11, 11, 11},
    pedFlashIntensity = 4,
    pedFlashTime = 1,
    screenFlash = false,
    screenFlashRGB = {11, 11, 11},
    screenFlashIntensity = 4,
    screenFlashTime = 1,
    particle = 1,
    timecycle = 1,
    timecycleTime = 1
}
local af = 0
local function ag()
    local ah = json.encode(ae)
    SetResourceKvp("rng_kill_effects", ah)
end
local ai = {head = 1, body = 1, arms = 1, legs = 1}
local function aj()
    local ak = json.encode(ai)
    SetResourceKvp("rng_blood_effects", ak)
end
Citizen.CreateThread(
    function()
        Citizen.Wait(1000)
        local a4 = GetResourceKvpString("rng_graphic_presets")
        if a4 and a4 ~= "" then
            Q = json.decode(a4) or {}
        end
        for W, S in pairs(a.presets) do
            for W, T in pairs(S.presets) do
                if R(S, T) then
                    Z(T)
                end
            end
        end
        local ah = GetResourceKvpString("rng_kill_effects")
        if ah and ah ~= "" then
            local al = json.decode(ah)
            for am, a3 in pairs(al) do
                if ae[am] then
                    ae[am] = a3
                end
            end
        end
        local ak = GetResourceKvpString("rng_blood_effects")
        if ak and ak ~= "" then
            local al = json.decode(ak)
            for am, a3 in pairs(al) do
                if ai[am] then
                    ai[am] = a3
                end
            end
        end
    end
)
RageUI.CreateWhile(
    1.0,
    true,
    function()
        RageUI.IsVisible(
            RMenu:Get("SettingsMenu", "MainMenu"),
            true,
            false,
            true,
            function()
                -- RageUI.BackspaceMenuCallback(function()
                --     if RNG.getStaffLevel() > 0 then 
                --         RageUI.CloseAll()
                --         TriggerServerEvent("RNG:GetPlayerData", true)
                --     end
                -- end)
                RageUI.ButtonWithStyle(
                    "UI Settings",
                    "UI related settings.",
                    {RightLabel = "→→→"},
                    true,
                    function(an, ao, ap)
                    end,
                    RMenu:Get("SettingsMenu", "uisettings")
                )
                RageUI.ButtonWithStyle(
                    "Weapon Settings",
                    "Weapon related settings.",
                    {RightLabel = "→→→"},
                    true,
                    function(an, ao, ap)
                    end,
                    RMenu:Get("SettingsMenu", "weaponsettings")
                )
                if PlayerIsInGang then
                    RageUI.ButtonWithStyle(
                        "Gang Settings",
                        "Gang related settings.",
                        {RightLabel = "→→→"},
                        true,
                        function(an, ao, ap)
                        end,
                        RMenu:Get("SettingsMenu", "gangsettings")
                    )
                end
                RageUI.ButtonWithStyle(
                    "Misc Settings",
                    "Miscellaneous settings.",
                    {RightLabel = "→→→"},
                    true,
                    function(an, ao, ap)
                    end,
                    RMenu:Get("SettingsMenu", "miscsettings")
                )
                RageUI.ButtonWithStyle(
                    "Graphic Presets",
                    "View a list of preconfigured graphic settings.",
                    {RightLabel = "→→→"},
                    true,
                    function()
                    end,
                    RMenu:Get("SettingsMenu", "graphicpresets")
                )
                RageUI.ButtonWithStyle(
                    "Kill Effects",
                    "Toggle effects that occur on killing a player.",
                    {RightLabel = "→→→"},
                    true,
                    function()
                    end,
                    RMenu:Get("SettingsMenu", "killeffects")
                )
                RageUI.ButtonWithStyle(
                    "Blood Effects",
                    "Toggle effects that occur when damaging a player.",
                    {RightLabel = "→→→"},
                    true,
                    function()
                    end,
                    RMenu:Get("SettingsMenu", "bloodeffects")
                )
                RageUI.ButtonWithStyle(
                    "~g~Tebex Purchases",
                    "View your tebex purchases here.",
                    {RightLabel = "→→→"},
                    true,
                    function()
                    end,
                    RMenu:Get("store", "mainmenu")
                )
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("SettingsMenu", "uisettings"),
            true,
            false,
            true,
            function()
                RageUI.Checkbox(
                    "Streetnames",
                    "",
                    tRNG.isStreetnamesEnabled(),
                    {Style = RageUI.CheckboxStyle.Car},
                    function(an, ap, ao, aq)
                    end,
                    function()
                        tRNG.setStreetnamesEnabled(true)
                    end,
                    function()
                        tRNG.setStreetnamesEnabled(false)
                    end
                )
                RageUI.Checkbox(
                    "Compass",
                    "",
                    tRNG.isCompassEnabled(),
                    {Style = RageUI.CheckboxStyle.Car},
                    function(an, ap, ao, aq)
                    end,
                    function()
                        tRNG.setCompassEnabled(true)
                    end,
                    function()
                        tRNG.setCompassEnabled(false)
                    end
                )
                local function ar()
                    tRNG.hideUI()
                    hideUI = true
                end
                local function as()
                    tRNG.showUI()
                    hideUI = false
                end
                RageUI.Checkbox(
                    "Hide UI",
                    "",
                    hideUI,
                    {Style = RageUI.CheckboxStyle.Car},
                    function(an, ap, ao, aq)
                    end,
                    ar,
                    as
                )
                local function ar()
                    tRNG.toggleBlackBars()
                    e = true
                end
                local function as()
                    tRNG.toggleBlackBars()
                    e = false
                end
                RageUI.Checkbox(
                    "Cinematic Black Bars",
                    "",
                    e,
                    {Style = RageUI.CheckboxStyle.Car},
                    function(an, ap, ao, aq)
                    end,
                    ar,
                    as
                )
                RageUI.Checkbox(
                    "Reduce Chat Opacity",
                    "",
                    f,
                    {},
                    function()
                    end,
                    function()
                        f = true
                        tRNG.setReducedChatOpacity(true)
                        TriggerEvent("RNG:chatReduceOpacity", true)
                    end,
                    function()
                        f = false
                        tRNG.setReducedChatOpacity(false)
                        TriggerEvent("RNG:chatReduceOpacity", false)
                    end
                )
                RageUI.Checkbox(
                    "Show Health Percentage",
                    "Displays the health and armour percentage on the bars.",
                    h,
                    {},
                    function()
                    end,
                    function()
                        h = true
                        tRNG.setShowHealthPercentageFlag(true)
                    end,
                    function()
                        h = false
                        tRNG.setShowHealthPercentageFlag(false)
                    end
                )
                RageUI.List(
                    "Health UI Type",
                    B,
                    A,
                    "Switch between health UI displays.",
                    {},
                    true,
                    function(at, au, av, aw)
                        if aw ~= A then
                            A = aw
                            tRNG.setHealthUIType(B[A])
                            SetResourceKvpInt("rng_health_ui_type", A)
                        end
                    end
                )
                RageUI.ButtonWithStyle(
                    "Crosshair",
                    "Create a custom built-in crosshair here.",
                    {RightLabel = "→→→"},
                    true,
                    function(an, ao, ap)
                    end,
                    RMenu:Get("crosshair", "main")
                )
                RageUI.ButtonWithStyle(
                    "Scope Settings",
                    "Add a toggleable range finder when using sniper scopes.",
                    {RightLabel = "→→→"},
                    true,
                    function(an, ao, ap)
                    end,
                    RMenu:Get("scope", "main")
                )
                -- RageUI.ButtonWithStyle(
                --     "Profile Picture Settings",
                --     "Set your profile picture settings.",
                --     {RightLabel = "→→→"},
                --     true,
                --     function(an, ao, ap)
                --     end,
                --     RMenu:Get("ProfileMenu", "main")
                -- )
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("SettingsMenu", "weaponsettings"),
            true,
            false,
            true,
            function()
                local function ar()
                    TriggerEvent("RNG:setDiagonalWeapons")
                    b = true
                    tRNG.setDiagonalWeaponSetting(b)
                end
                local function as()
                    TriggerEvent("RNG:setVerticalWeapons")
                    b = false
                    tRNG.setDiagonalWeaponSetting(b)
                end
                RageUI.Checkbox(
                    "Enable Diagonal Weapons",
                    "~g~This changes the way weapons look on your back from vertical to diagonal.",
                    b,
                    {Style = RageUI.CheckboxStyle.Car},
                    function(an, ap, ao, aq)
                    end,
                    ar,
                    as
                )
                RageUI.Checkbox(
                    "Enable Front Assault Rifles",
                    "~g~This changes the positioning of Assault Rifles from back to front.",
                    c,
                    {Style = RageUI.CheckboxStyle.Car},
                    function()
                    end,
                    function()
                        TriggerEvent("RNG:setFrontAR")
                        c = true
                        tRNG.setFrontARSetting(c)
                    end,
                    function()
                        TriggerEvent("RNG:setBackAR")
                        c = false
                        tRNG.setFrontARSetting(c)
                    end
                )
                RageUI.Checkbox(
                    "Enable Front SMGs",
                    "~g~This changes the positioning of SMGs from back to front.",
                    z,
                    {Style = RageUI.CheckboxStyle.Car},
                    function()
                    end,
                    function()
                        TriggerEvent("RNG:setFrontSMG")
                        z = true
                        tRNG.setFrontSMGSetting(z)
                    end,
                    function()
                        TriggerEvent("RNG:setBackSMG")
                        z = false
                        tRNG.setFrontSMGSetting(z)
                    end
                )
                local function ar()
                    TriggerEvent("RNG:hsSoundsOn")
                    d = true
                    tRNG.setHitMarkerSetting(d)
                    tRNG.notify("~y~Experimental Headshot sounds now set to " .. tostring(d))
                end
                local function as()
                    TriggerEvent("RNG:hsSoundsOff")
                    d = false
                    tRNG.setHitMarkerSetting(d)
                    tRNG.notify("~y~Experimental Headshot sounds now set to " .. tostring(d))
                end
                RageUI.Checkbox(
                    "Enable Experimental Hit Marker Sounds",
                    "~g~This adds 'hit marker' sounds when shooting another player, however it can be unreliable.",
                    d,
                    {Style = RageUI.CheckboxStyle.Car},
                    function(an, ap, ao, aq)
                    end,
                    ar,
                    as
                )
                RageUI.ButtonWithStyle(
                    "Weapon Whitelists",
                    "Sell your custom weapon whitelists here.",
                    {RightLabel = "→→→"},
                    true,
                    function(an, ao, ap)
                        if ap then
                            M = nil
                            K = nil
                            L = nil
                            N = nil
                            TriggerServerEvent("RNG:getCustomWeaponsOwned")
                        end
                    end,
                    RMenu:Get("SettingsMenu", "weaponswhitelist")
                )
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("SettingsMenu", "gangsettings"),
            true,
            false,
            true,
            function()
                RageUI.List(
                    "Gang Ping Marker",
                    {"Only Text", "Marker", "Icon"},
                    q,
                    "Display of gang markers.",
                    {},
                    true,
                    function(at, au, av, aw)
                        if aw ~= q then
                            q = aw
                            SetResourceKvpInt("rng_gang_ping_marker", aw)
                        end
                    end
                )
                RageUI.List(
                    "Gang Ping Volume",
                    p,
                    o,
                    "Volume of the gang ping sound.",
                    {},
                    true,
                    function(at, au, av, aw)
                        if aw ~= o then
                            o = aw
                            SetResourceKvpInt("rng_gang_ping_volume", aw)
                        end
                    end
                )
                RageUI.List(
                    "Gang Ping Sound",
                    n,
                    m,
                    "Sound to play when a gang member pings.",
                    {},
                    true,
                    function(at, au, av, aw)
                        if aw ~= m then
                            m = aw
                            SetResourceKvpInt("rng_gang_ping_sound", aw)
                        end
                    end
                )
                RageUI.List(
                    "Gang Name Distance",
                    l,
                    j,
                    "Max distance to display gang member names.",
                    {},
                    true,
                    function(at, au, av, aw)
                        if aw ~= j then
                            j = aw
                            SetResourceKvpInt("rng_gang_name_distance", aw)
                            TriggerEvent("RNG:setGangNameDistance", k[aw])
                        end
                    end
                )
                RageUI.List(
                    "Health UI X",
                    s,
                    r,
                    "Change the X position of the gang health UI.",
                    {},
                    true,
                    function(at, au, av, aw)
                        if aw ~= r then
                            r = aw
                            tRNG.setGangUIXPos(s[aw])
                            SetResourceKvpInt("rng_gang_position_x", r)
                        end
                    end
                )
                RageUI.List(
                    "Health UI Y",
                    u,
                    t,
                    "Change the Y position of the gang health UI.",
                    {},
                    true,
                    function(at, au, av, aw)
                        if aw ~= t then
                            t = aw
                            tRNG.setGangUIYPos(u[aw])
                            SetResourceKvpInt("rng_gang_position_y", t)
                        end
                    end
                )
                RageUI.Checkbox(
                    "Display Pings on Minimap",
                    "Display gang pings on the minimap.",
                    gangPingMinimap,
                    {},
                    function()
                    end,
                    function()
                        gangPingMinimap = true
                        SetResourceKvp("rng_gang_ping_minimap", tostring(true))
                    end,
                    function()
                        gangPingMinimap = false
                        SetResourceKvp("rng_gang_ping_minimap", tostring(false))
                    end
                )
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("SettingsMenu", "miscsettings"),
            true,
            false,
            true,
            function()
                -- RageUI.ButtonWithStyle(
                --     "Store Inventory",
                --     "View your store inventory here.",
                --     {RightLabel = "→→→"},
                --     true,
                --     function()
                --     end,
                --     RMenu:Get("store", "mainmenu")
                -- )
                RageUI.Checkbox(
                    "Keep Flashlight On Whilst Moving",
                    "Makes weapon flashlight beams stay visible while moving.",
                    i,
                    {},
                    function()
                    end,
                    function()
                        tRNG.setFlashlightNotAimingFlag(true)
                    end,
                    function()
                        tRNG.setFlashlightNotAimingFlag(false)
                    end
                )
                RageUI.Checkbox(
                    "Toggle Radio Animation",
                    "The player will play an animation when speaking over radio.",
                    x,
                    {},
                    function()
                    end,
                    function()
                        tRNG.setRadioAnim(true)
                    end,
                    function()
                        tRNG.setRadioAnim(false)
                    end
                )
                RageUI.Checkbox(
                    "Hide Event Announcements",
                    "Hides the big scaleform from displaying across your screen, will still announce in chat.",
                    g,
                    {},
                    function()
                    end,
                    function()
                        g = true
                        tRNG.setHideEventAnnouncementFlag(true)
                    end,
                    function()
                        g = false
                        tRNG.setHideEventAnnouncementFlag(false)
                    end
                )
                RageUI.ButtonWithStyle(
                    "Change Linked Discord",
                    "Begins the process of changing your linked Discord. Your linked discord is used to sync roles with the server.",
                    {RightLabel = "→→→"},
                    true,
                    function(an, ao, ap)
                        if ap then
                            TriggerServerEvent("RNG:changeLinkedDiscord")
                        end
                    end
                )
                RageUI.ButtonWithStyle(
                    "Compensation",
                    "Vew any unclaimed compensations",
                    {RightLabel = "→→→"},
                    true,
                    function(an, ao, ap)
                        if ap then 
                            TriggerServerEvent('RNG:Compensation')
                        end
                    end,
                    RMenu:Get("SettingsMenu", "compensation")
                )
                RageUI.List(
                    "Doorbell Status",
                    v,
                    w,
                    "Change the status of the doorbell.",
                    {},
                    true,
                    function(at, au, av, aw)
                        if aw ~= w then
                            w = aw
                            SetResourceKvpInt("rng_doorbell_index", aw)
                        end
                    end
                )
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("SettingsMenu", "changediscord"),
            true,
            false,
            true,
            function()
                RageUI.Separator("~g~A code has been messaged to the Discord account")
                RageUI.Separator("-----")
                RageUI.Separator("~y~If you have not received a message verify:")
                RageUI.Separator("~y~1. Your direct messages are open.")
                RageUI.Separator("~y~2. The account you provided was correct.")
                RageUI.Separator("-----")
                RageUI.ButtonWithStyle(
                    "Enter Code",
                    "",
                    {RightLabel = "→→→"},
                    true,
                    function(an, ao, ap)
                        if ap then
                            TriggerServerEvent("RNG:enterDiscordCode")
                        end
                    end
                )
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("SettingsMenu", "weaponswhitelist"),
            true,
            false,
            true,
            function()
                for ax, ay in pairs(J) do
                    RageUI.ButtonWithStyle(
                        ay,
                        "",
                        {RightLabel = "→→→"},
                        true,
                        function(an, ao, ap)
                            if ap then
                                K = ay
                                L = ax
                                N = nil
                            end
                        end,
                        RMenu:Get("SettingsMenu", "generateaccesscode")
                    )
                end
                RageUI.Separator("~y~If you do not see your custom weapon here.")
                RageUI.Separator("~y~Please open a ticket on our support discord.")
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("SettingsMenu", "generateaccesscode"),
            true,
            false,
            true,
            function()
                RageUI.Separator("~g~Weapon Whitelist for " .. K)
                RageUI.Separator("How it works:")
                RageUI.Separator("You generate an access code for the player who wishes")
                RageUI.Separator("to purchase your custom weapon whitelist, which they ")
                RageUI.Separator("then enter on the store to receive their automated")
                RageUI.Separator("weapon whitelist.")
                RageUI.ButtonWithStyle(
                    "Create access code",
                    "",
                    {RightLabel = "→→→"},
                    true,
                    function(an, ao, ap)
                        if ap then
                            local az = getGenericTextInput("User ID of player purchasing your weapon whitelist.")
                            if tonumber(az) then
                                az = tonumber(az)
                                if az > 0 then
                                    TriggerServerEvent("RNG:generateWeaponAccessCode", L, az)
                                end
                            end
                        end
                    end
                )
                RageUI.ButtonWithStyle(
                    "View whitelisted users",
                    "",
                    {RightLabel = "→→→"},
                    true,
                    function(an, ao, ap)
                        if ap then
                            TriggerServerEvent("RNG:requestWhitelistedUsers", L)
                        end
                    end,
                    RMenu:Get("SettingsMenu", "viewwhitelisted")
                )
                if M then
                    RageUI.Separator("~g~Access code generated: " .. M)
                    RageUI.ButtonWithStyle(
                        "Copy Code to Clipboard",
                        "",
                        {RightLabel = "→→→"},
                        true,
                        function(ae, af, ag)
                            if ag then
                                tRNG.CopyToClipBoard(M)
                            end
                        end
                    )
                end
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("SettingsMenu", "viewwhitelisted"),
            true,
            false,
            true,
            function()
                RageUI.Separator("~g~Whitelisted users for " .. K)
                if N == nil then
                    RageUI.Separator("~r~Requesting whitelisted users...")
                else
                    for aA, aB in pairs(N) do
                        RageUI.ButtonWithStyle(
                            "ID: " .. tostring(aA),
                            "",
                            {RightLabel = aB},
                            true,
                            function()
                            end
                        )
                    end
                end
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("SettingsMenu", "compensation"),
            true,
            true,
            true,
            function()
                if compensationAmount == nil then
                    RageUI.Separator("~o~Loading Compensation Data")
                elseif compensationAmount == 0 then
                    RageUI.Separator("~r~No compensation available")
                elseif compensationAmount then
                    RageUI.ButtonWithStyle(
                        "Redeem Compensation " .. getMoneyStringFormatted(compensationAmount),
                        nil,
                        {RightLabel = "→→→"},
                        true,
                        function(ae, af, ag)
                            if ag then
                                TriggerServerEvent("RNG:RedeemCompensation")
                            end
                        end
                    )
                end
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("SettingsMenu", "eventsettings"),
            true,
            false,
            true,
            function()
                if kills == nil or deaths == nil or kdRatio == nil then
                    RageUI.Separator("~o~Loading Statistics")
                elseif kills and deaths and kdRatio then
                    RageUI.Separator("Kills: " .. kills .. " / Deaths: " .. deaths .. " (" .. kdRatio .. " KD)")
                end
                RageUI.ButtonWithStyle(
                    "View Leaderboard",
                    "View the player with the most kills ",
                    {RightLabel = "→→→"},
                    true,
                    function(ae, af, ag)
                        if ag then
                            TriggerServerEvent("RNG:ViewIslandLeaderboard")
                        end
                    end,
                    RMenu:Get("SettingsMenu", "eventleaderboard")
                )
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("SettingsMenu", "eventleaderboard"),
            true, false, true,
            function()
                if not a11 or #a11 == 0 then
                    RageUI.Separator("~r~No Kills")
                else
                    for _, data in ipairs(a11) do
                        if data.username and data.kills then
                            RageUI.Separator(data.username .. " - Kills: " .. data.kills)
                        else
                            RageUI.Separator("~r~No Data")
                        end
                    end
                end
            end,
            function()
            end
        )                        
        RageUI.IsVisible(
            RMenu:Get("SettingsMenu", "graphicpresets"),
            true,
            false,
            true,
            function()
                for W, S in pairs(a.presets) do
                    RageUI.Separator(S.name)
                    for W, T in pairs(S.presets) do
                        local aC = R(S, T)
                        RageUI.Checkbox(
                            T.name,
                            nil,
                            aC,
                            {},
                            function(an, ap, ao, aq)
                                if aq ~= aC then
                                    _(S, T, aq)
                                end
                            end,
                            function()
                            end,
                            function()
                            end
                        )
                    end
                end
                RageUI.Separator("Graphics Presets")
                RageUI.List(
                    "Adjust Fog",
                    timecycles.names,
                    timecycles.save,
                    "~g~Adjust the fog density, lower values will increase FPS!",
                    {},
                    true,
                    function(an, ao, ap, aD)
                        timecycles.save = aD
                        SetTimecycleModifier(timecycles.values[timecycles.save])
                        SetResourceKvp("rng_graphics_fog", timecycles.save)
                    end,
                    function()
                    end,
                    nil
                )
                RageUI.List(
                    "Adjust Sky",
                    weathers.names,
                    weathers.save,
                    "~g~Adjust the sky, lower values will increase FPS!",
                    {},
                    true,
                    function(an, ao, ap, aD)
                        weathers.save = aD
                        tRNG.setWeather(weathers.values[weathers.save])
                        SetResourceKvp("rng_graphics_sky", weathers.save)
                    end,
                    function()
                    end,
                    nil
                )
                RageUI.Separator("World")
                RageUI.Checkbox(
                    "Disable Low Priority Props",
                    "Removes small ambient world objects such as signs, bins, creates, rubbish, etc.",
                    y,
                    {},
                    function()
                    end,
                    function()
                        tRNG.setLowProps(true)
                    end,
                    function()
                        tRNG.setLowProps(false)
                    end
                )
                RageUI.List(
                    "Render Distance Modifier",
                    a1,
                    I,
                    "~g~Lowering this will increase your FPS!",
                    {},
                    true,
                    function(an, ao, ap, aD)
                        I = aD
                    end,
                    function()
                    end,
                    nil
                )
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("SettingsMenu", "killeffects"),
            true,
            false,
            true,
            function()
                RageUI.Checkbox(
                    "Create Lightning",
                    "",
                    ae.lightning,
                    {},
                    function(an, ap, ao, aq)
                        if ap then
                            ae.lightning = aq
                            ag()
                        end
                    end
                )
                RageUI.Checkbox(
                    "Ped Flash",
                    "",
                    ae.pedFlash,
                    {},
                    function(an, ap, ao, aq)
                        if ap then
                            ae.pedFlash = aq
                            ag()
                        end
                    end
                )
                if ae.pedFlash then
                    RageUI.List(
                        "Ped Flash Red",
                        a5,
                        ae.pedFlashRGB[1],
                        "",
                        {},
                        ae.pedFlash,
                        function(an, ao, ap, aD)
                            if ao and ae.pedFlashRGB[1] ~= aD then
                                ae.pedFlashRGB[1] = aD
                                ag()
                            end
                        end,
                        function()
                        end
                    )
                    RageUI.List(
                        "Ped Flash Green",
                        a5,
                        ae.pedFlashRGB[2],
                        "",
                        {},
                        ae.pedFlash,
                        function(an, ao, ap, aD)
                            if ao and ae.pedFlashRGB[2] ~= aD then
                                ae.pedFlashRGB[2] = aD
                                ag()
                            end
                        end,
                        function()
                        end
                    )
                    RageUI.List(
                        "Ped Flash Blue",
                        a5,
                        ae.pedFlashRGB[3],
                        "",
                        {},
                        ae.pedFlash,
                        function(an, ao, ap, aD)
                            if ao and ae.pedFlashRGB[3] ~= aD then
                                ae.pedFlashRGB[3] = aD
                                ag()
                            end
                        end,
                        function()
                        end
                    )
                    RageUI.List(
                        "Ped Flash Intensity",
                        a7,
                        ae.pedFlashIntensity,
                        "",
                        {},
                        ae.pedFlash,
                        function(an, ao, ap, aD)
                            if ao and ae.pedFlashIntensity ~= aD then
                                ae.pedFlashIntensity = aD
                                ag()
                            end
                        end,
                        function()
                        end
                    )
                    RageUI.List(
                        "Ped Flash Time",
                        a9,
                        ae.pedFlashTime,
                        "",
                        {},
                        ae.pedFlash,
                        function(an, ao, ap, aD)
                            if ao and ae.pedFlashTime ~= aD then
                                ae.pedFlashTime = aD
                                ag()
                            end
                        end,
                        function()
                        end
                    )
                end
                RageUI.Checkbox(
                    "Screen Flash",
                    "",
                    ae.screenFlash,
                    {},
                    function(an, ap, ao, aq)
                        if ap then
                            ae.screenFlash = aq
                            ag()
                        end
                    end
                )
                if ae.screenFlash then
                    RageUI.List(
                        "Screen Flash Red",
                        a5,
                        ae.screenFlashRGB[1],
                        "",
                        {},
                        ae.screenFlash,
                        function(an, ao, ap, aD)
                            if ao and ae.screenFlashRGB[1] ~= aD then
                                ae.screenFlashRGB[1] = aD
                                ag()
                            end
                        end,
                        function()
                        end
                    )
                    RageUI.List(
                        "Screen Flash Green",
                        a5,
                        ae.screenFlashRGB[2],
                        "",
                        {},
                        ae.screenFlash,
                        function(an, ao, ap, aD)
                            if ao and ae.screenFlashRGB[2] ~= aD then
                                ae.screenFlashRGB[2] = aD
                                ag()
                            end
                        end,
                        function()
                        end
                    )
                    RageUI.List(
                        "Screen Flash Blue",
                        a5,
                        ae.screenFlashRGB[3],
                        "",
                        {},
                        ae.screenFlash,
                        function(an, ao, ap, aD)
                            if ao and ae.screenFlashRGB[3] ~= aD then
                                ae.screenFlashRGB[3] = aD
                                ag()
                            end
                        end,
                        function()
                        end
                    )
                    RageUI.List(
                        "Screen Flash Intensity",
                        a7,
                        ae.screenFlashIntensity,
                        "",
                        {},
                        ae.screenFlash,
                        function(an, ao, ap, aD)
                            if ao and ae.screenFlashIntensity ~= aD then
                                ae.screenFlashIntensity = aD
                                ag()
                            end
                        end,
                        function()
                        end
                    )
                    RageUI.List(
                        "Screen Flash Time",
                        a9,
                        ae.screenFlashTime,
                        "",
                        {},
                        ae.screenFlash,
                        function(an, ao, ap, aD)
                            if ao and ae.screenFlashTime ~= aD then
                                ae.screenFlashTime = aD
                                ag()
                            end
                        end,
                        function()
                        end
                    )
                end
                RageUI.List(
                    "Timecycle Flash",
                    ad,
                    ae.timecycle,
                    "",
                    {},
                    true,
                    function(an, ao, ap, aD)
                        if ao and ae.timecycle ~= aD then
                            ae.timecycle = aD
                            ag()
                        end
                    end,
                    function()
                    end
                )
                if ae.timecycle ~= 1 then
                    RageUI.List(
                        "Timecycle Flash Time",
                        a9,
                        ae.timecycleTime,
                        "",
                        {},
                        true,
                        function(an, ao, ap, aD)
                            if ao and ae.timecycleTime ~= aD then
                                ae.timecycleTime = aD
                                ag()
                            end
                        end,
                        function()
                        end
                    )
                end
                RageUI.List(
                    "~y~Particles~w~",
                    ab,
                    ae.particle,
                    "",
                    {},
                    true,
                    function(an, ao, ap, aD)
                        if ao and ae.particle ~= aD then
                            if not tRNG.isPlusClub() and not tRNG.isPlatClub() then
                                notify("~y~You need to be a subscriber of RNG Plus or RNG Platinum to use this feature.")
                                notify("~y~Available @ store.rngstudios.co.uk")
                            end
                            ae.particle = aD
                            ag()
                        end
                    end,
                    function()
                    end
                )
                local aE = 0
                if ae.lightning then
                    aE = math.max(aE, 1000)
                end
                if ae.pedFlash then
                    aE = math.max(aE, aa[ae.pedFlashTime])
                end
                if ae.screenFlash then
                    aE = math.max(aE, aa[ae.screenFlashTime])
                end
                if ae.timecycleTime ~= 1 then
                    aE = math.max(aE, a6[ae.timecycleTime])
                end
                if ae.particle ~= 1 then
                    aE = math.max(aE, 1000)
                end
                if GetGameTimer() - af > aE + 1000 then
                    tRNG.addKillEffect(PlayerPedId(), true)
                    af = GetGameTimer()
                end
                DrawAdvancedTextNoOutline(0.59, 0.9, 0.005, 0.0028, 1.5, "PREVIEW", 255, 0, 0, 255, 2, 0)
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("SettingsMenu", "bloodeffects"),
            true,
            false,
            true,
            function()
                RageUI.List(
                    "~y~Head",
                    ab,
                    ai.head,
                    "Effect that displays when you hit the head.",
                    {},
                    true,
                    function(an, ao, ap, aD)
                        if ai.head ~= aD then
                            if not tRNG.isPlusClub() and not tRNG.isPlatClub() then
                                notify("~y~You need to be a subscriber of RNG Plus or RNG Platinum to use this feature.")
                                notify("~y~Available @ store.rngstudios.co.uk")
                            end
                            ai.head = aD
                            aj()
                        end
                        if ap then
                            tRNG.addBloodEffect("head", 0x796E, PlayerPedId())
                        end
                    end
                )
                RageUI.List(
                    "~y~Body",
                    ab,
                    ai.body,
                    "Effect that displays when you hit the body.",
                    {},
                    true,
                    function(an, ao, ap, aD)
                        if ai.body ~= aD then
                            if not tRNG.isPlusClub() and not tRNG.isPlatClub() then
                                notify("~y~You need to be a subscriber of RNG Plus or RNG Platinum to use this feature.")
                                notify("~y~Available @ store.rngstudios.co.uk")
                            end
                            ai.body = aD
                            aj()
                        end
                        if ap then
                            tRNG.addBloodEffect("body", 0x0, PlayerPedId())
                        end
                    end
                )
                RageUI.List(
                    "~y~Arms",
                    ab,
                    ai.arms,
                    "Effect that displays when you hit the arms.",
                    {},
                    true,
                    function(an, ao, ap, aD)
                        if ai.arms ~= aD then
                            if not tRNG.isPlusClub() and not tRNG.isPlatClub() then
                                notify("~y~You need to be a subscriber of RNG Plus or RNG Platinum to use this feature.")
                                notify("~y~Available @ store.rngstudios.co.uk")
                            end
                            ai.arms = aD
                            aj()
                        end
                        if ap then
                            tRNG.addBloodEffect("arms", 0xBB0, PlayerPedId())
                            tRNG.addBloodEffect("arms", 0x58B7, PlayerPedId())
                        end
                    end
                )
                RageUI.List(
                    "~y~Legs",
                    ab,
                    ai.legs,
                    "Effect that displays when you hit the legs.",
                    {},
                    true,
                    function(an, ao, ap, aD)
                        if ai.legs ~= aD then
                            if not tRNG.isPlusClub() and not tRNG.isPlatClub() then
                                notify("~y~You need to be a subscriber of RNG Plus or RNG Platinum to use this feature.")
                                notify("~y~Available @ store.rngstudios.co.uk")
                            end
                            ai.legs = aD
                            aj()
                        end
                        if ap then
                            tRNG.addBloodEffect("legs", 0x3FCF, PlayerPedId())
                            tRNG.addBloodEffect("legs", 0xB3FE, PlayerPedId())
                        end
                    end
                )
            end,
            function()
            end
        )
    end
)
RegisterNetEvent("RNG:OpenSettingsMenu")
AddEventHandler(
    "RNG:OpenSettingsMenu",
    function(aF)
        if not aF then
            RageUI.Visible(RMenu:Get("SettingsMenu", "MainMenu"), true)
        end
    end
)
RegisterCommand(
    "opensettingsmenu",
    function()
        TriggerServerEvent("RNG:OpenSettings")
    end
)
RegisterCommand(
    "compensation",
    function()
        RageUI.Visible(RMenu:Get("SettingsMenu", "compensation"), true)
    end
)
RegisterKeyMapping("opensettingsmenu", "Opens the Settings menu", "keyboard", "F2")
Citizen.CreateThread(
    function()
        while true do
            OverrideLodscaleThisFrame(H[I][2])
            if not (tRNG.getStaffLevel() > 0) then
                if IsUsingKeyboard(2) and IsControlJustPressed(1, 289) then
                    RageUI.Visible(
                        RMenu:Get("SettingsMenu", "MainMenu"),
                        not RageUI.Visible(RMenu:Get("SettingsMenu", "MainMenu"))
                    )
                end
            end
            Wait(0)
        end
    end
)
AddEventHandler(
    "RNG:enteredCity",
    function()
    end
)
AddEventHandler(
    "RNG:leftCity",
    function()
    end
)
local function au(av)
    local aw = GetEntityCoords(av, true)
    local aG = GetGameTimer()
    local aH = math.floor(a6[ae.pedFlashRGB[1]] * 255)
    local aI = math.floor(a6[ae.pedFlashRGB[2]] * 255)
    local aJ = math.floor(a6[ae.pedFlashRGB[3]] * 255)
    local aK = a8[ae.pedFlashIntensity]
    local aL = aa[ae.pedFlashTime]
    while GetGameTimer() - aG < aL do
        local aM = (aL - (GetGameTimer() - aG)) / aL
        local aN = aK * 25.0 * aM
        DrawLightWithRange(aw.x, aw.y, aw.z + 1.0, aH, aI, aJ, 50.0, aN)
        Citizen.Wait(0)
    end
end
local function aO()
    local aG = GetGameTimer()
    local aH = math.floor(a6[ae.screenFlashRGB[1]] * 255)
    local aI = math.floor(a6[ae.screenFlashRGB[2]] * 255)
    local aJ = math.floor(a6[ae.screenFlashRGB[3]] * 255)
    local aK = a8[ae.screenFlashIntensity]
    local aL = aa[ae.screenFlashTime]
    while GetGameTimer() - aG < aL do
        local aM = (aL - (GetGameTimer() - aG)) / aL
        local aN = math.floor(25.5 * aK * aM)
        DrawRect(0.0, 0.0, 2.0, 2.0, aH, aI, aJ, aN)
        Citizen.Wait(0)
    end
end
local function aP(av)
    local aw = GetEntityCoords(av, true)
    local aQ = ac[ae.particle]
    tRNG.loadPtfx(aQ[1])
    UseParticleFxAsset(aQ[1])
    StartParticleFxNonLoopedAtCoord(aQ[2], aw.x, aw.y, aw.z, 0.0, 0.0, 0.0, aQ[3], false, false, false)
    RemoveNamedPtfxAsset(aQ[1])
end
local function aR()
    local aG = GetGameTimer()
    local aL = aa[ae.timecycleTime]
    SetTimecycleModifier(ad[ae.timecycle])
    while GetGameTimer() - aG < aL do
        local aM = (aL - (GetGameTimer() - aG)) / aL
        SetTimecycleModifierStrength(1.0 * aM)
        Citizen.Wait(0)
    end
    ClearTimecycleModifier()
end
function tRNG.addKillEffect(aS, aT)
    if ae.lightning then
        ForceLightningFlash()
    end
    if ae.pedFlash then
        Citizen.CreateThreadNow(
            function()
                au(aS)
            end
        )
    end
    if ae.screenFlash then
        Citizen.CreateThreadNow(
            function()
                aO()
            end
        )
    end
    if ae.particle ~= 1 and (tRNG.isPlatClub() or aT) then
        Citizen.CreateThreadNow(
            function()
                aP(aS)
            end
        )
    end
    if ae.timecycle ~= 1 then
        Citizen.CreateThreadNow(
            function()
                aR()
            end
        )
    end
end
function tRNG.addBloodEffect(aU, aV, av)
    local aW = ai[aU]
    if aW > 1 then
        local aQ = ac[aW]
        tRNG.loadPtfx(aQ[1])
        UseParticleFxAsset(aQ[1])
        StartParticleFxNonLoopedOnPedBone(aQ[2], av, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, aV, aQ[3], false, false, false)
        RemoveNamedPtfxAsset(aQ[1])
    end
end
AddEventHandler(
    "RNG:onPlayerKilledPed",
    function(aX)
        tRNG.addKillEffect(aX, false)
    end
)
local aY = {
    [0x0] = "body",
    [0x2E28] = "body",
    [0xE39F] = "legs",
    [0xF9BB] = "legs",
    [0x3779] = "legs",
    [0x83C] = "legs",
    [0xCA72] = "legs",
    [0x9000] = "legs",
    [0xCC4D] = "legs",
    [0x512D] = "legs",
    [0xE0FD] = "body",
    [0x5C01] = "body",
    [0x60F0] = "body",
    [0x60F1] = "body",
    [0x60F2] = "body",
    [0xFCD9] = "body",
    [0xB1C5] = "arms",
    [0xEEEB] = "arms",
    [0x49D9] = "arms",
    [0x67F2] = "arms",
    [0xFF9] = "arms",
    [0xFFA] = "arms",
    [0x67F3] = "arms",
    [0x1049] = "arms",
    [0x104A] = "arms",
    [0x67F4] = "arms",
    [0x1059] = "arms",
    [0x105A] = "arms",
    [0x67F5] = "arms",
    [0x1029] = "arms",
    [0x102A] = "arms",
    [0x67F6] = "arms",
    [0x1039] = "arms",
    [0x103A] = "arms",
    [0x29D2] = "arms",
    [0x9D4D] = "arms",
    [0x6E5C] = "arms",
    [0xDEAD] = "arms",
    [0xE5F2] = "arms",
    [0xFA10] = "arms",
    [0xFA11] = "arms",
    [0xE5F3] = "arms",
    [0xFA60] = "arms",
    [0xFA61] = "arms",
    [0xE5F4] = "arms",
    [0xFA70] = "arms",
    [0xFA71] = "arms",
    [0xE5F5] = "arms",
    [0xFA40] = "arms",
    [0xFA41] = "arms",
    [0xE5F6] = "arms",
    [0xFA50] = "arms",
    [0xFA51] = "arms",
    [0x9995] = "head",
    [0x796E] = "head",
    [0x5FD4] = "head",
    [0xD003] = "body",
    [0x45FC] = "body",
    [0x1D6B] = "legs",
    [0xB23F] = "legs"
}
AddEventHandler(
    "RNG:onPlayerDamagePed",
    function(aX)
        if not tRNG.isPlusClub() and not tRNG.isPlatClub() then
            return
        end
        local aZ, aV = GetPedLastDamageBone(aX, 0)
        if aZ then
            local a_ = GetPedBoneIndex(aX, aV)
            local b0 = GetWorldPositionOfEntityBone(aX, a_)
            local b1 = aY[aV]
            if not b1 then
                local b2 = GetWorldPositionOfEntityBone(aX, GetPedBoneIndex(aX, 0x9995))
                local b3 = GetWorldPositionOfEntityBone(aX, GetPedBoneIndex(aX, 0x2E28))
                if b0.z >= b2.z - 0.01 then
                    b1 = "head"
                elseif b0.z < b3.z then
                    b1 = "legs"
                else
                    local b4 = GetEntityCoords(aX, true)
                    local b5 = #(b4.xy - b0.xy)
                    if b5 > 0.075 then
                        b1 = "arms"
                    else
                        b1 = "body"
                    end
                end
            end
            tRNG.addBloodEffect(b1, aV, aX)
        end
    end
)
RegisterNetEvent("RNG:gotDiscord")
AddEventHandler(
    "RNG:gotDiscord",
    function()
        RageUI.Visible(RMenu:Get("SettingsMenu", "changediscord"), true)
    end
)
objettable = {}
Citizen.CreateThread(
    function()
        while true do
            if y then
                while objettable == nil do
                    Citizen.Wait(0)
                end
                for c = 1, #objettable do
                    local d = GetGamePool("CObject")
                    local e = GetHashKey(objettable[c])
                    for f, g in pairs(d) do
                        if GetEntityModel(g) == e then
                            SetEntityAsMissionEntity(g, true, true)
                            DeleteObject(g)
                        end
                    end
                end
            end
            Citizen.Wait(1000)
        end
    end
)
RMenu.Add(
    "ProfileMenu",
    "main",
    RageUI.CreateMenu(
        "",
        "Profile Settings",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight(),
        "rng_settingsui",
        "rng_settingsui"
    )
)
RageUI.CreateWhile(
    1.0,
    true,
    function()
        if RageUI.Visible(RMenu:Get("ProfileMenu", "main")) then
            RageUI.DrawContent({ header = true, glare = false, instructionalButton = true }, function()
                RageUI.Separator("~g~Profile Settings")
                RageUI.List(
                    "PFP Type",
                    C,
                    G,
                    "~g~Change the type of PFP displayed",
                    {},
                    true,
                    function(B, H, I, J)
                        G = J
                        tRNG.updatePFPType(C[G])
                        SetResourceKvp("rng_pfp_type", G)
                    end,
                    function()
                    end,
                    nil
                )

                if G ~= 4 then
                    RageUI.List(
                        "PFP Size",
                        D,
                        F,
                        "~g~Change the size of PFP displayed",
                        {},
                        true,
                        function(B, H, I, J)
                            F = J
                            tRNG.updatePFPSize(E[F])
                            SetResourceKvp("rng_pfp_size", F)
                        end,
                        function()
                        end,
                        nil
                    )

                    if G == 3 then
                        RageUI.ButtonWithStyle(
                            "Set Custom PFP",
                            "",
                            { RightLabel = "→→→" },
                            true,
                            function(v, w, x)
                                if x then
                                    tRNG.clientPrompt(
                                        "URL:",
                                        "",
                                        function(t)
                                            if string.find(t, "https://") or string.find(t, "http://") then
                                                SetResourceKvp("rng_custom_pfp", t)
                                                SendNUIMessage({setPFP = t})
                                            else
                                                tRNG.notify("~r~Invalid URL.")
                                            end
                                        end
                                    )
                                end
                            end
                        )
                    end
                end
            end)
        end
    end
)

RegisterNetEvent('RNG:ReceiveCompensation')
AddEventHandler('RNG:ReceiveCompensation', function(compensation)
    compensationAmount = compensation
end)

RegisterNetEvent("RNG:receiveIslandStats")
AddEventHandler("RNG:receiveIslandStats",function(k, d, kd)
    kills, deaths, kdRatio = k, d, kd
end)

RegisterNetEvent("RNG:GotIslandLeaderboard")
AddEventHandler("RNG:GotIslandLeaderboard", function(leaderboardData)
    a11 = leaderboardData
    print(json.encode(a11))
end)
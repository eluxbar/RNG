RMenu.Add(
    "vipclubmenu",
    "mainmenu",
    RageUI.CreateMenu("", "~w~RNG Club", tRNG.getRageUIMenuWidth(), tRNG.getRageUIMenuHeight(), "menus", "vip")
)
RMenu.Add(
    "vipclubmenu",
    "managesubscription",
    RageUI.CreateSubMenu(
        RMenu:Get("vipclubmenu", "mainmenu"),
        "",
        "~w~RNG Club",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight(),
        "menus",
        "vip"
    )
)
RMenu.Add(
    "vipclubmenu",
    "manageusersubscription",
    RageUI.CreateSubMenu(
        RMenu:Get("vipclubmenu", "mainmenu"),
        "",
        "~w~RNG Club Manage",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight(),
        "menus",
        "vip"
    )
)
RMenu.Add(
    "vipclubmenu",
    "manageperks",
    RageUI.CreateSubMenu(
        RMenu:Get("vipclubmenu", "mainmenu"),
        "",
        "~w~RNG Club Perks",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight(),
        "menus",
        "vip"
    )
)
RMenu.Add(
    "vipclubmenu",
    "deathsounds",
    RageUI.CreateSubMenu(
        RMenu:Get("vipclubmenu", "manageperks"),
        "",
        "~w~Manage Death Sounds",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight(),
        "menus",
        "vip"
    )
)
RMenu.Add(
    "vipclubmenu",
    "vehicleextras",
    RageUI.CreateSubMenu(
        RMenu:Get("vipclubmenu", "manageperks"),
        "",
        "~w~Vehicle Extras",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight(),
        "menus",
        "vip"
    )
)
local a = {hoursOfPlus = 0, hoursOfPlatinum = 0}
local b = {}
function tRNG.isPlusClub()
    if a.hoursOfPlus > 0 then
        return true
    else
        return false
    end
end
function tRNG.isPlatClub()
    if a.hoursOfPlatinum > 0 then
        return true
    else
        return false
    end
end
RegisterCommand(
    "rngclub",
    function()
        TriggerServerEvent("RNG:getPlayerSubscription")
        RageUI.ActuallyCloseAll()
        RageUI.Visible(RMenu:Get("vipclubmenu", "mainmenu"), not RageUI.Visible(RMenu:Get("vipclubmenu", "mainmenu")))
    end
)
local c = {
    ["RNG"] = {checked = true, soundId = "playDead"},
    ["Fortnite"] = {checked = false, soundId = "fortnite_death"},
    ["Roblox"] = {checked = false, soundId = "roblox_death"},
    ["Minecraft"] = {checked = false, soundId = "minecraft_death"},
    ["Pac-Man"] = {checked = false, soundId = "pacman_death"},
    ["Mario"] = {checked = false, soundId = "mario_death"},
    ["CS:GO"] = {checked = false, soundId = "csgo_death"}
}
local d = false
local e = false
local f = false
local g = false
local h = {"Red", "Blue", "Green", "Pink", "Yellow", "Orange", "Purple"}
local i = tonumber(GetResourceKvpString("rng_damageindicatorcolour")) or 1
local i = {"Discord", "Steam", "None"}
local j = {"Smallest", "Small"}
local a9 = {32, 40, 48, 56}
local l = tonumber(GetResourceKvpString("rng_pfp_size")) or 1
local m = tonumber(GetResourceKvpString("rng_pfp_size")) or 1
Citizen.CreateThread(
    function()
        local j = GetResourceKvpString("rng_codhitmarkersounds") or "false"
        if j == "false" then
            d = false
            TriggerEvent("RNG:codHMSoundsOff")
        else
            d = true
            TriggerEvent("RNG:codHMSoundsOn")
        end
        local k = GetResourceKvpString("rng_killlistsetting") or "false"
        if k == "false" then
            e = false
        else
            e = true
        end
        local l = GetResourceKvpString("rng_oldkillfeed") or "false"
        if l == "false" then
            f = false
        else
            f = true
        end
        local m = GetResourceKvpString("rng_damageindicator") or "false"
        if m == "false" then
            g = false
        else
            g = true
        end
        Wait(5000)
        tRNG.updatePFPType(i[m])
        tRNG.updatePFPSize(a9[l])
    end
)
AddEventHandler(
    "RNG:onClientSpawn",
    function(f, g)
        if g then
            TriggerServerEvent("RNG:getPlayerSubscription")
            Wait(5000)
            local n = tRNG.getDeathSound()
            local o = "playDead"
            for p, j in pairs(c) do
                if j.soundId == n then
                    o = p
                end
            end
            for p, k in pairs(c) do
                if o ~= p then
                    k.checked = false
                else
                    k.checked = true
                end
            end
        end
    end
)
function tRNG.setDeathSound(n)
    if tRNG.isPlusClub() or tRNG.isPlatClub() then
        SetResourceKvp("rng_deathsound", n)
    else
        tRNG.notify("~r~Cannot change deathsound, not a valid RNG Plus or Platinum subscriber.")
    end
end
function tRNG.getDeathSound()
    if tRNG.isPlusClub() or tRNG.isPlatClub() then
        local p = GetResourceKvpString("rng_deathsound")
        if type(p) == "string" and p ~= "" then
            return p
        else
            return "playDead"
        end
    else
        return "playDead"
    end
end
function tRNG.getDmgIndcator()
    return g, i
end
local function k(h)
    SendNUIMessage({transactionType = h})
end
RageUI.CreateWhile(
    1.0,
    true,
    function()
        if RageUI.Visible(RMenu:Get("vipclubmenu", "mainmenu")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = false},
                function()
                    if tRNG.isPlusClub() or tRNG.isPlatClub() then
                        RageUI.ButtonWithStyle(
                            "Manage Subscription",
                            nil,
                            {RightLabel = "→→→"},
                            true,
                            function(m, q, r)
                            end,
                            RMenu:Get("vipclubmenu", "managesubscription")
                        )
                        RageUI.ButtonWithStyle(
                            "Manage Perks",
                            nil,
                            {RightLabel = "→→→"},
                            true,
                            function(m, q, r)
                            end,
                            RMenu:Get("vipclubmenu", "manageperks")
                        )
                    else
                        RageUI.ButtonWithStyle(
                            "Purchase Subscription",
                            nil,
                            {RightLabel = "→→→"},
                            true,
                            function(m, q, r)
                                if r then
                                    tRNG.OpenUrl("https://store.rngstudios.co.uk/category/subscriptions")
                                end
                            end
                        )
                    end
                    if tRNG.isDev() or tRNG.getStaffLevel() >= 10 then
                        RageUI.ButtonWithStyle(
                            "Manage User's Subscription",
                            nil,
                            {RightLabel = "→→→"},
                            true,
                            function(m, q, r)
                            end,
                            RMenu:Get("vipclubmenu", "manageusersubscription")
                        )
                    end
                end
            )
        end
        if RageUI.Visible(RMenu:Get("vipclubmenu", "managesubscription")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = false},
                function()
                    colourCode = getColourCode(a.hoursOfPlus)
                    RageUI.Separator(
                        "Days remaining of Plus Subscription: " ..
                            colourCode .. math.floor(a.hoursOfPlus / 24 * 100) / 100 .. " days."
                    )
                    colourCode = getColourCode(a.hoursOfPlatinum)
                    RageUI.Separator(
                        "Days remaining of Platinum Subscription: " ..
                            colourCode .. math.floor(a.hoursOfPlatinum / 24 * 100) / 100 .. " days."
                    )
                    RageUI.Separator()
                    RageUI.ButtonWithStyle(
                        "Sell Plus Subscription days.",
                        "~r~If you have already claimed your weekly kit, you may not sell days until the week is over.",
                        {RightLabel = "→→→"},
                        true,
                        function(m, q, r)
                            if r then
                                if isInGreenzone then
                                    TriggerServerEvent("RNG:beginSellSubscriptionToPlayer", "Plus")
                                else
                                    notify("~r~You must be in a greenzone to sell.")
                                end
                            end
                        end
                    )
                    RageUI.ButtonWithStyle(
                        "Sell Platinum Subscription days.",
                        "~r~If you have already claimed your weekly kit, you may not sell days until the week is over.",
                        {RightLabel = "→→→"},
                        true,
                        function(m, q, r)
                            if r then
                                if isInGreenzone then
                                    TriggerServerEvent("RNG:beginSellSubscriptionToPlayer", "Platinum")
                                else
                                    notify("~r~You must be in a greenzone to sell.")
                                end
                            end
                        end
                    )
                end
            )
        end
        if RageUI.Visible(RMenu:Get("vipclubmenu", "manageusersubscription")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = false},
                function()
                    if tRNG.isDev() then
                        if next(b) then
                            RageUI.Separator("Perm ID: " .. b.userid)
                            colourCode = getColourCode(b.hoursOfPlus)
                            RageUI.Separator(
                                "Days of Plus Remaining: " .. colourCode .. math.floor(b.hoursOfPlus / 24 * 100) / 100
                            )
                            colourCode = getColourCode(b.hoursOfPlatinum)
                            RageUI.Separator(
                                "Days of Platinum Remaining: " ..
                                    colourCode .. math.floor(b.hoursOfPlatinum / 24 * 100) / 100
                            )
                            RageUI.ButtonWithStyle(
                                "Set Plus Days",
                                "",
                                {RightLabel = "→→→"},
                                true,
                                function(m, q, r)
                                    if r then
                                        TriggerServerEvent("RNG:setPlayerSubscription", b.userid, "Plus")
                                    end
                                end
                            )
                            RageUI.ButtonWithStyle(
                                "Set Platinum Days",
                                "",
                                {RightLabel = "→→→"},
                                true,
                                function(m, q, r)
                                    if r then
                                        TriggerServerEvent("RNG:setPlayerSubscription", b.userid, "Platinum")
                                    end
                                end
                            )
                        else
                            RageUI.Separator("Please select a Perm ID")
                        end
                        RageUI.ButtonWithStyle(
                            "Select Perm ID",
                            nil,
                            {RightLabel = "→→→"},
                            true,
                            function(s, t, u)
                                if u then
                                    permID = tRNG.KeyboardInput("Enter Perm ID", "", 10)
                                    if permID == nil then
                                        tRNG.notify("Invalid Perm ID")
                                        return
                                    end
                                    TriggerServerEvent("RNG:getPlayerSubscription", permID)
                                end
                            end,
                            RMenu:Get("vipclubmenu", "manageusersubscription")
                        )
                    end
                end
            )
        end
        if RageUI.Visible(RMenu:Get("vipclubmenu", "manageperks")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = false},
                function()
                    RageUI.ButtonWithStyle(
                        "Custom Death Sounds",
                        nil,
                        {RightLabel = "→→→"},
                        true,
                        function(m, q, r)
                        end,
                        RMenu:Get("vipclubmenu", "deathsounds")
                    )
                    RageUI.ButtonWithStyle(
                        "Vehicle Extras",
                        nil,
                        {RightLabel = "→→→"},
                        true,
                        function(m, q, r)
                        end,
                        RMenu:Get("vipclubmenu", "vehicleextras")
                    )
                    RageUI.ButtonWithStyle(
                        "Claim Weekly Kit",
                        nil,
                        {RightLabel = "→→→"},
                        true,
                        function(m, q, r)
                            if r then
                                if not globalInPrison and not tRNG.isHandcuffed() then
                                    TriggerServerEvent("RNG:claimWeeklyKit")
                                else
                                    notify("~r~You can not redeem a kit whilst in custody.")
                                end
                            end
                        end
                    )
                    local function r()
                        TriggerEvent("RNG:codHMSoundsOn")
                        d = true
                        tRNG.setCODHitMarkerSetting(d)
                        tRNG.notify("~g~COD Hitmarkers are now active")
                    end
                    local function v()
                        TriggerEvent("RNG:codHMSoundsOff")
                        d = false
                        tRNG.setCODHitMarkerSetting(d)
                        tRNG.notify("~r~COD Hitmarkers have been disabled")
                    end
                    RageUI.Checkbox(
                        "Enable COD Hitmarkers",
                        "~g~This adds 'hit marker' sound and image when shooting another player.",
                        d,
                        {RightBadge = RageUI.CheckboxStyle.Car},
                        function(l, q, m, w)
                        end,
                        r,
                        v
                    )
                    RageUI.Checkbox(
                        "Enable Kill List",
                        "~g~This adds a kill list below your crosshair when you kill a player.",
                        e,
                        {Style = RageUI.CheckboxStyle.Car},
                        function()
                        end,
                        function()
                            e = true
                            tRNG.setKillListSetting(e)
                            tRNG.notify("~g~Kill List is now active")
                        end,
                        function()
                            e = false
                            tRNG.setKillListSetting(e)
                            tRNG.notify("~r~Kill List has been disabled")
                        end
                    )
                    RageUI.Checkbox(
                        "Enable Old Kilfeed",
                        "~g~This toggles the old killfeed that notifies above minimap.",
                        f,
                        {Style = RageUI.CheckboxStyle.Car},
                        function()
                        end,
                        function()
                            f = true
                            tRNG.setOldKillfeed(f)
                            tRNG.notify("~g~Old Killfeed is now active")
                        end,
                        function()
                            f = false
                            tRNG.setOldKillfeed(f)
                            tRNG.notify("~r~Old Killfeed has been disabled")
                        end
                    )
                    RageUI.Checkbox(
                        "Enable Damage Indicator",
                        "~g~This toggles the display of damage indicator.",
                        g,
                        {Style = RageUI.CheckboxStyle.Car},
                        function()
                        end,
                        function()
                            g = true
                            tRNG.setDamageIndicator(g)
                            tRNG.notify("~g~Damage Indicator is now active")
                        end,
                        function()
                            g = false
                            tRNG.setDamageIndicator(g)
                            tRNG.notify("~r~Damage Indicator has been disabled")
                        end
                    )
                    -- if g then
                    --     RageUI.List(
                    --         "Damage Colour",
                    --         h,
                    --         i,
                    --         "~g~Change the displayed colour of damage",
                    --         {},
                    --         true,
                    --         function(x, y, z, A)
                    --             i = A
                    --             tRNG.setDamageIndicatorColour(i)
                    --         end,
                    --         function()
                    --         end,
                    --         nil
                    --     )
                    -- end
                    RageUI.List(
                        "PFP Type",
                        i,
                        m,
                        "~g~Change the type of PFP displayed",
                        {},
                        true,
                        function(B, C, D, E)
                            m = E
                            tRNG.updatePFPType(i[m])
                            SetResourceKvp("rng_pfp_type", m)
                        end,
                        function()
                        end,
                        nil
                    )                                   
                    if m ~= 4 then
                        RageUI.List(
                            "PFP Size",
                            j,
                            l,
                            "~g~Change the size of PFP displayed",
                            {},
                            true,
                            function(B, C, D, E)
                                l = E
                                tRNG.updatePFPSize(a9[l])
                                SetResourceKvp("rng_pfp_size", l)
                            end,
                            function()
                            end,
                            nil
                        )
                    end
                end,
                function()
                end
            )
        end        
        if RageUI.Visible(RMenu:Get("vipclubmenu", "deathsounds")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = false},
                function()
                    for B, p in pairs(c) do
                        RageUI.Checkbox(
                            B,
                            nil,
                            p.checked,
                            {},
                            function()
                            end,
                            function()
                                for n, j in pairs(c) do
                                    j.checked = false
                                end
                                p.checked = true
                                k(p.soundId)
                                tRNG.setDeathSound(p.soundId)
                            end,
                            function()
                            end
                        )
                    end
                end
            )
        end
        if RageUI.Visible(RMenu:Get("vipclubmenu", "vehicleextras")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = false},
                function()
                    local C = tRNG.getPlayerVehicle()
                    -- SetVehicleAutoRepairDisabled(C, true)
                    for D = 1, 99, 1 do
                        if DoesExtraExist(C, D) then
                            RageUI.Checkbox(
                                "Extra " .. D,
                                "",
                                IsVehicleExtraTurnedOn(C, D),
                                {},
                                function()
                                end,
                                function()
                                    SetVehicleExtra(C, D, 0)
                                end,
                                function()
                                    SetVehicleExtra(C, D, 1)
                                end
                            )
                        end
                    end
                end
            )
        end
    end
)
RegisterNetEvent(
    "RNG:setVIPClubData",
    function(E, b)
        a.hoursOfPlus = E
        a.hoursOfPlatinum = b
    end
)
RegisterNetEvent(
    "RNG:getUsersSubscription",
    function(F, G, H)
        b.userid = F
        b.hoursOfPlus = G
        b.hoursOfPlatinum = H
        RMenu:Get("vipclubmenu", "manageusersubscription")
    end
)
RegisterNetEvent(
    "RNG:userSubscriptionUpdated",
    function()
        TriggerServerEvent("RNG:getPlayerSubscription", permID)
    end
)
Citizen.CreateThread(
    function()
        while true do
            if tRNG.isPlatClub() then
                if not HasPedGotWeapon(PlayerPedId(), "GADGET_PARACHUTE", false) then
                    tRNG.xyzweapom("GADGET_PARACHUTE")
                    GiveWeaponToPed(PlayerPedId(), "GADGET_PARACHUTE")
                    SetPlayerHasReserveParachute(PlayerId())
                end
            end
            if tRNG.isPlusClub() or tRNG.isPlatClub() then
                SetVehicleDirtLevel(tRNG.getPlayerVehicle(), 0.0)
            end
            Wait(500)
        end
    end
)
function getColourCode(a)
    if a >= 10 then
        colourCode = "~g~"
    elseif a < 10 and a > 3 then
        colourCode = "~y~"
    else
        colourCode = "~r~"
    end
    return colourCode
end
local z = {}
local function A()
    for E, I in pairs(z) do
        DrawAdvancedTextNoOutline(
            0.6,
            0.5 + 0.025 * E,
            0.005,
            0.0028,
            0.45,
            "Killed " .. I.name,
            255,
            255,
            255,
            255,
            tRNG.getFontId("Akrobat-Regular"),
            1
        )
    end
end
tRNG.createThreadOnTick(A)
RegisterNetEvent(
    "RNG:onPlayerKilledPed",
    function(J)
        if e and (tRNG.isPlatClub() or tRNG.isPlusClub()) and IsPedAPlayer(J) then
            local K = NetworkGetPlayerIndexFromPed(J)
            if K >= 0 then
                local L = GetPlayerServerId(K)
                if L >= 0 then
                    local M = tRNG.getPlayerName(K)
                    table.insert(z, {name = M, source = L})
                    SetTimeout(
                        2000,
                        function()
                            for E, I in pairs(z) do
                                if L == I.source then
                                    table.remove(z, E)
                                end
                            end
                        end
                    )
                end
            end
        end
    end
)

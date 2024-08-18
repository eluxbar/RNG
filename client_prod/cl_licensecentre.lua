licensecentre = module("cfg/cfg_licensecentre")
local a = {}
RMenu.Add(
    "rnglicenses",
    "main",
    RageUI.CreateMenu(
        "",
        "~b~" .. "Job Centre",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight(),
        "menus",
        "rng_licenseui"
    )
)
RMenu.Add(
    "rnglicenses",
    "ownedlicenses",
    RageUI.CreateSubMenu(RMenu:Get("rnglicenses", "main", tRNG.getRageUIMenuWidth(), tRNG.getRageUIMenuHeight()))
)
RMenu.Add(
    "rnglicenses",
    "buyconfirm",
    RageUI.CreateSubMenu(
        RMenu:Get("rnglicenses", "main"),
        "",
        "Are you sure?",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight()
    )
)
RMenu.Add(
    "rnglicenses",
    "refundconfirm",
    RageUI.CreateSubMenu(
        RMenu:Get("rnglicenses", "ownedlicenses"),
        "",
        "Are you sure?",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight()
    )
)
RageUI.CreateWhile(
    1.0,
    nil,
    function()
        RageUI.IsVisible(
            RMenu:Get("rnglicenses", "main"),
            true,
            false,
            true,
            function()
                RageUI.ButtonWithStyle(
                    "Refund Licenses",
                    "Obtain 25% of the license value back.",
                    {RightLabel = "→→→"},
                    true,
                    function(b, c, d)
                    end,
                    RMenu:Get("rnglicenses", "ownedlicenses")
                )
                for e, f in pairs(licensecentre.licenses) do
                    local g = not a[f.name]
                    RageUI.Button(
                        f.name .. " (£" .. getMoneyStringFormatted(tostring(f.price)) .. ")",
                        f.notOwned and "" or "You already own this license.",
                        f.notOwned and {RightLabel = "→→→"} or {RightLabel = ""},
                        f.notOwned,
                        function(b, c, d)
                            if d then
                                cGroup = f.group
                                cName = f.name
                            end
                        end,
                        RMenu:Get("rnglicenses", "buyconfirm")
                    )
                end
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("rnglicenses", "buyconfirm"),
            true,
            true,
            true,
            function()
                for h, i in pairs(licensecentre.licenses) do
                    if i.group == cGroup then
                        RageUI.Separator(i.name .. " Price: £" .. getMoneyStringFormatted(i.price))
                        if i.info ~= nil then
                            for j, k in pairs(i.info) do
                                RageUI.Separator(k)
                            end
                        end
                        RageUI.ButtonWithStyle(
                            "Confirm",
                            nil,
                            {RightLabel = ""},
                            true,
                            function(b, c, d)
                                if d then
                                    TriggerServerEvent("RNG:buyLicense", cGroup, cName)
                                end
                            end,
                            RMenu:Get("rnglicenses", "main")
                        )
                        RageUI.ButtonWithStyle(
                            "Decline",
                            nil,
                            {RightLabel = ""},
                            true,
                            function(b, c, d)
                            end,
                            RMenu:Get("rnglicenses", "main")
                        )
                    end
                end
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("rnglicenses", "ownedlicenses"),
            true,
            true,
            true,
            function()
                for e, f in pairs(licensecentre.licenses) do
                    local g = a[f.name]
                    if not f.notOwned then
                        RageUI.ButtonWithStyle(
                            "Refund " .. f.name .. " for (£" .. getMoneyStringFormatted(tostring(f.price * 0.25)) .. ")",
                            "",
                            {RightLabel = "→→→"},
                            true,
                            function(b, c, d)
                                if d then
                                    cGroup = f.group
                                    cName = f.name
                                end
                            end,
                            RMenu:Get("rnglicenses", "refundconfirm")
                        )
                    end
                end
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("rnglicenses", "refundconfirm"),
            true,
            true,
            true,
            function()
                for h, i in pairs(licensecentre.licenses) do
                    if i.group == cGroup then
                        RageUI.Separator("Refund Amount: £" .. getMoneyStringFormatted(i.price * 0.25))
                        RageUI.ButtonWithStyle(
                            "Confirm",
                            nil,
                            {RightLabel = ""},
                            true,
                            function(b, c, d)
                                if d then
                                    TriggerServerEvent("RNG:refundLicense", cGroup, cName)
                                end
                            end,
                            RMenu:Get("rnglicenses", "ownedlicenses")
                        )
                        RageUI.ButtonWithStyle(
                            "Decline",
                            nil,
                            {RightLabel = ""},
                            true,
                            function(b, c, d)
                            end,
                            RMenu:Get("rnglicenses", "ownedlicenses")
                        )
                    end
                end
            end,
            function()
            end
        )
    end
)
AddEventHandler(
    "RNG:onClientSpawn",
    function(f, l)
        if l then
            local m = function(n)
            end
            local o = function(n)
                RageUI.Visible(RMenu:Get("rnglicenses", "main"), false)
                RageUI.Visible(RMenu:Get("rnglicenses", "ownedlicenses"), false)
                RageUI.Visible(RMenu:Get("rnglicenses", "buyconfirm"), false)
                RageUI.Visible(RMenu:Get("rnglicenses", "refundconfirm"), false)
                RageUI.CloseAll()
            end
            local p = function(n)
                if IsControlJustPressed(1, 38) then
                    TriggerServerEvent("RNG:getOwnedLicenses")
                    Wait(500)
                    RageUI.Visible(RMenu:Get("rnglicenses", "main"), not RageUI.Visible(RMenu:Get("rnglicenses", "main")))
                end
                local i, q, r = table.unpack(GetFinalRenderedCamCoord())
                DrawText3D(
                    licensecentre.location.x,
                    licensecentre.location.y,
                    licensecentre.location.z,
                    "~w~Press ~b~[E] ~w~to open License Centre",
                    i,
                    q,
                    r
                )
                tRNG.addMarker(
                    licensecentre.location.x,
                    licensecentre.location.y,
                    licensecentre.location.z - 0.98,
                    0.7,
                    0.7,
                    0.5,
                    255,
                    255,
                    255,
                    250,
                    50,
                    27,
                    false,
                    false
                )
            end
            tRNG.createArea("licensecentre", licensecentre.location, 1.5, 6, m, o, p, {})
            tRNG.addBlip(
                licensecentre.location.x,
                licensecentre.location.y,
                licensecentre.location.z,
                525,
                2,
                "License Shop"
            )
        end
    end
)
local j = false
local k = {}
local s = 0.033
local t = 0.033
local u = 0
local v = 0.306
function func_licenseMenuControl()
    if IsControlJustPressed(0, 167) then
        if j then
            j = false
        else
            TriggerServerEvent("RNG:GetLicenses")
        end
    end
    if j and not tRNG.inEvent() and not tRNG.isPurge() then
        DrawRect(0.50, 0.222, 0.223, 0.075, 16, 86, 229, 255)
        DrawAdvancedText(0.595, 0.213, 0.005, 0.0028, 1.0, "RNG Licenses", 255, 255, 255, 255, 1, 0)
        DrawAdvancedText(0.595, 0.275, 0.005, 0.0028, 0.4, "Licenses Owned", 0, 255, 50, 255, 6, 0)
        DrawRect(0.50, 0.272, 0.223, 0.026, 0, 0, 0, 222)
        
        local s = 0.033
        local v = 0.301
        local u = 0
        
        for w, x in pairs(k) do
            DrawAdvancedText(0.595, v + u * s, 0.005, 0.0028, 0.4, tostring(x), 255, 255, 255, 255, 6, 0)
            DrawRect(0.50, 0.301 + u * s, 0.223, 0.033, 0, 0, 0, 120)
            u = u + 1
        end
    end
end

if not tRNG.isPurge() then
    tRNG.createThreadOnTick(func_licenseMenuControl)
end
RegisterNetEvent(
    "RNG:ReceivedLicenses",
    function(e)
        k = e
        j = true
    end
)
RegisterNetEvent(
    "RNG:gotOwnedLicenses",
    function(e)
        for f, g in pairs(licensecentre.licenses) do
            g.notOwned = true
            for h, i in pairs(e) do
                if g.name == i then
                    g.notOwned = false
                end
            end
        end
    end
)

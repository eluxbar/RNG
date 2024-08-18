local a = 1000
local b = 1000
local c = 1000
local d = "0"
local e = vector3(924.99627685547, 47.006057739258, 81.104507446289)
local f = vector3(1089.6083984375, 206.60050964355, -48.999725341797)
local g = vector3(967.6533203125, 63.682018280029, 112.55312347412)
local casinoStats = {}
local a10 = 0
local b9 = false
RMenu.Add(
    "RNGChips",
    "cashier",
    RageUI.CreateMenu(
        "",
        "",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight(),
        "shopui_title_casino",
        "shopui_title_casino"
    )
)
RMenu:Get("RNGChips", "cashier"):SetSubtitle("CHIPS")
RMenu.Add(
    "casino_enter",
    "casino",
    RageUI.CreateMenu(
        "",
        "",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight(),
        "shopui_title_casino",
        "shopui_title_casino"
    )
)
RMenu.Add(
    "rngcasinostats",
    "casinostats",
    RageUI.CreateSubMenu(
        RMenu:Get("RNGChips", "cashier"),
        "",
        "~b~Casino Stats",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight()
    )
)
RMenu:Get("casino_enter", "casino"):SetSubtitle("ENTER")
RMenu.Add(
    "casino_exit",
    "casino",
    RageUI.CreateMenu(
        "",
        "",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight(),
        "shopui_title_casino",
        "shopui_title_casino"
    )
)
RMenu:Get("casino_exit", "casino"):SetSubtitle("EXIT")
RMenu.Add(
    "casino_rooftop_exit",
    "casino",
    RageUI.CreateMenu(
        "",
        "",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight(),
        "shopui_title_casino",
        "shopui_title_casino"
    )
)
RMenu:Get("casino_rooftop_exit", "casino"):SetSubtitle("EXIT")
local h = {
    {
        model = "u_f_m_casinocash_01",
        pedPosition = vector3(1117.671, 218.7382, -49.4),
        pedHeading = 100.0,
        entryPosition = vector3(1116.0776367188, 218.04238891602, -50.435089111328)
    },
    {
        model = "u_f_m_casinocash_01",
        pedPosition = vector3(20.152572631836, 6705.5737304688, -105.85441589355),
        pedHeading = 75.0,
        entryPosition = vector3(18.445615768433, 6705.7485351563, -106.85442352295)
    }
}
Citizen.CreateThread(
    function()
        for i, j in pairs(h) do
            tRNG.createDynamicPed(
                j.model,
                j.pedPosition,
                100.0,
                true,
                "mini@strip_club@idles@bouncer@base",
                "base",
                75.0,
                nil,
                function(k)
                    SetEntityCanBeDamaged(k, 0)
                    SetPedAsEnemy(k, 0)
                    SetBlockingOfNonTemporaryEvents(k, 1)
                    SetPedResetFlag(k, 249, 1)
                    SetPedConfigFlag(k, 185, true)
                    SetPedConfigFlag(k, 108, true)
                    SetPedCanEvasiveDive(k, 0)
                    SetPedCanRagdollFromPlayerImpact(k, 0)
                    SetPedConfigFlag(k, 208, true)
                    SetEntityCollision(k, false)
                    SetEntityCoordsNoOffset(k, j.pedPosition.x, j.pedPosition.y, j.pedPosition.z, 100.0, 0, 0)
                    SetEntityHeading(k, j.pedHeading)
                    FreezeEntityPosition(k, true)
                end
            )
        end
    end
)
RageUI.CreateWhile(
    1.0,
    true,
    function()
        if RageUI.Visible(RMenu:Get("RNGChips", "cashier")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = false},
                function()
                    RageUI.Separator("~b~Welcome To The Diamond Casino & Resort")
                    RageUI.ButtonWithStyle(
                        "Buy chips",
                        nil,
                        {RightLabel = "→→→"},
                        true,
                        function(l, m, n)
                            if n then
                                local o = getCasinoChips()
                                if tonumber(o) then
                                    o = tonumber(o)
                                    if o > 0 then
                                        TriggerServerEvent("RNG:buyChips", o)
                                    else
                                        tRNG.notify("Negative Amount.")
                                    end
                                else
                                    tRNG.notify("~r~Invalid Amount.")
                                end
                            end
                        end
                    )
                    RageUI.ButtonWithStyle(
                        "Buy all chips",
                        nil,
                        {RightLabel = "→→→"},
                        true,
                        function(l, m, n)
                            if n then
                                TriggerServerEvent("RNG:buyChips", "all")
                            end
                        end
                    )
                    RageUI.ButtonWithStyle(
                        "Sell chips",
                        nil,
                        {RightLabel = "→→→"},
                        true,
                        function(l, m, n)
                            if n then
                                local o = getCasinoChips()
                                if tonumber(o) then
                                    o = tonumber(o)
                                    if o > 0 then
                                        TriggerServerEvent("RNG:sellChips", o)
                                    else
                                        tRNG.notify("Negative Amount.")
                                    end
                                else
                                    tRNG.notify("~r~Invalid Amount.")
                                end
                            end
                        end
                    )
                    RageUI.ButtonWithStyle(
                        "Sell all chips",
                        nil,
                        {RightLabel = "→→→"},
                        true,
                        function(l, m, n)
                            if n then
                                TriggerServerEvent("RNG:sellChips", "all")
                            end
                        end
                    )
                    RageUI.ButtonWithStyle(
                        "Claim Rateback",
                        "Claim 10% back of what you've lost",
                        {RightLabel = "→→→"},
                        true,
                        function(l, m, n)
                            if n then
                                
                                TriggerServerEvent("RNG:RateBack")
                            end
                        end
                    )
                    -- RageUI.Button("Claim Rateback (£" .. getMoneyStringFormatted(a10) .. ")", "£" .. getMoneyStringFormatted(a10), (b9 and {RightLabel = ""} or {RightLabel = "→→→"}), a10 > 0, function(_, _, n)
                    --     if n then
                    --         if a10 > 0 then
                    --             TriggerServerEvent("RNG:RateBack")
                    --             b9 = true
                    --             Citizen.Wait(20000)
                    --             b9 = false
                    --         end
                    --     end
                    -- end)                    
                    RageUI.ButtonWithStyle(
                        "View Casino Stats",
                        "~b~Your bet history throughout RNG.",
                        {RightLabel = "→→→"},
                        true,
                        function(_, _, selected)
                            if selected then
                                TriggerServerEvent("RNG:getCasinoStats")
                            end
                        end,
                        RMenu:Get("rngcasinostats", "casinostats")
                    )
                end
            )
        end
        if RageUI.Visible(RMenu:Get("casino_exit", "casino")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = false},
                function()
                    RageUI.ButtonWithStyle(
                        "Exit Diamond Casino",
                        nil,
                        {RightLabel = "→→→"},
                        true,
                        function(l, m, n)
                            if n then
                                TriggerServerEvent("RNG:exitDiamondCasino")
                                tRNG.teleport(e.x, e.y, e.z)
                                if cardObjects then
                                    for p, q in pairs(cardObjects) do
                                        for j, r in pairs(q) do
                                            DeleteObject(r)
                                        end
                                    end
                                end
                            end
                        end
                    )
                end
            )
        end
        if RageUI.Visible(RMenu:Get("casino_enter", "casino")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = false},
                function()
                    RageUI.ButtonWithStyle(
                        "Enter Diamond Casino",
                        nil,
                        {RightLabel = "→→→"},
                        true,
                        function(l, m, n)
                            if n and tRNG.getPlayerCombatTimer() == 0 then
                                TriggerServerEvent("RNG:enterDiamondCasino")
                                tRNG.teleport(f.x, f.y, f.z)
                            end
                        end
                    )
                    RageUI.ButtonWithStyle(
                        "Diamond Casino Rooftop",
                        nil,
                        {RightLabel = "→→→"},
                        true,
                        function(l, m, n)
                            if n then
                                tRNG.teleport(g.x, g.y, g.z)
                            end
                        end
                    )
                end
            )
        end
        if RageUI.Visible(RMenu:Get("rngcasinostats", "casinostats")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = false},
                function()
                    if #casinoStats > 0 then
                        for _, stat in ipairs(casinoStats) do
                            local winLossRatio = 0
                            if (stat.money_lost + stat.money_won) > 0 then
                                winLossRatio = (stat.money_won / (stat.money_lost + stat.money_won)) * 100
                            end
                            RageUI.Separator("Total Bets: ~y~" .. stat.total_bets)
                            RageUI.Separator("Wins: ~y~" .. stat.wins)
                            RageUI.Separator("Losses: ~y~" .. stat.losses)
                            RageUI.Separator("")
                            RageUI.Separator("Money Won: ~y~" .. string.format("%0.0f", stat.money_won):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""))
                            RageUI.Separator("Money Lost: ~y~" .. string.format("%0.0f", stat.money_lost):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""))
                            RageUI.Separator("W/L Ratio: ~y~" .. string.format("%.2f%%", winLossRatio))
                        end
                    else
                        RageUI.Separator("~r~You have no casino stats to display.")
                    end                                                          
                    RageUI.ButtonWithStyle(
                        "Back",
                        nil,
                        {RightLabel = "→→→"},
                        true,
                        function(_, _, _) end,
                        RMenu:Get("RNGChips", "cashier")
                    )
                end
            )
        end
        if RageUI.Visible(RMenu:Get("casino_rooftop_exit", "casino")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = false},
                function()
                    RageUI.ButtonWithStyle(
                        "Exit Rooftop",
                        nil,
                        {RightLabel = "→→→"},
                        true,
                        function(l, m, n)
                            if n then
                                tRNG.teleport(e.x, e.y, e.z)
                            end
                        end
                    )
                end
            )
        end
    end
)

RegisterNetEvent("RNG:setCasinoStats")
AddEventHandler("RNG:setCasinoStats", function(stats)
    casinoStats = stats
end)


function showCasinoChipsCashier(s)
    RageUI.ActuallyCloseAll()
    RageUI.Visible(RMenu:Get("RNGChips", "cashier"), s)
end
function showCasinoEnter(s)
    RageUI.ActuallyCloseAll()
    RageUI.Visible(RMenu:Get("casino_enter", "casino"), s)
end
function showCasinoRooftopExit(s)
    RageUI.ActuallyCloseAll()
    RageUI.Visible(RMenu:Get("casino_rooftop_exit", "casino"), s)
end
function showCasinoExit(s)
    RageUI.ActuallyCloseAll()
    RageUI.Visible(RMenu:Get("casino_exit", "casino"), s)
end
Citizen.CreateThread(
    function()
        while true do
            if a < 1.5 then
                showCasinoEnter(true)
            elseif a < 2.5 then
                showCasinoEnter(false)
            end
            if b < 1.5 then
                showCasinoExit(true)
            elseif b < 2.5 then
                showCasinoExit(false)
            end
            if c < 1.5 then
                showCasinoRooftopExit(true)
            elseif c < 2.5 then
                showCasinoRooftopExit(false)
            end
            Wait(0)
        end
    end
)
Citizen.CreateThread(
    function()
        while true do
            DrawMarker(27, e.x, e.y, e.z - 1.0, 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 0.5001, 255, 255, 255, 200, 0, 0, 0, 0)
            DrawMarker(27, f.x, f.y, f.z - 1.0, 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 0.5001, 255, 255, 255, 200, 0, 0, 0, 0)
            DrawMarker(27, g.x, g.y, g.z - 1.0, 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 0.5001, 255, 255, 255, 200, 0, 0, 0, 0)
            Wait(0)
        end
    end
)
Citizen.CreateThread(
    function()
        while true do
            local t = GetEntityCoords(tRNG.getPlayerPed())
            a = #(t - e)
            b = #(t - f)
            c = #(t - g)
            Wait(100)
        end
    end
)
function getCasinoChips()
    AddTextEntry("FMMC_MPM_NA", "Enter chips")
    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Enter chips", "", "", "", "", 30)
    while UpdateOnscreenKeyboard() == 0 do
        DisableAllControlActions(0)
        Wait(0)
    end
    if GetOnscreenKeyboardResult() then
        local u = GetOnscreenKeyboardResult()
        if u then
            return u
        end
    end
    return false
end
RegisterNetEvent("RNG:setDisplayChips")
AddEventHandler(
    "RNG:setDisplayChips",
    function(v)
        d = getMoneyStringFormatted(tostring(v))
    end
)
RegisterNetEvent(
    "RNG:chipsUpdated",
    function()
        TriggerServerEvent("RNG:getChips")
    end
)

local w = {
    {position = vector3(1149.3828125, 269.19174194336, -52.020873718262), radius = 100},
    {position = vector3(54.053936004639, 6742.1513671875, -107.354347229), radius = 100},
    {position = vector3(-1896.8582763672, 2069.3537597656, 144.86274719238), radius = 10},
    {position = vector3(774.75134277344, -552.91137695312, 22.498882293701), radius = 100},
    {position = vector3(-1137.8917236328, -184.71762084961, 40.0803565979), radius = 50},
    {position = vector3(422.06201171875, 18.277492523193, 91.935234069824), radius = 25}
}
insideDiamondCasino = false
AddEventHandler(
    "RNG:onClientSpawn",
    function(x, y, a10)
        if y then
            TriggerServerEvent("RNG:getChips")
            TriggerServerEvent("RNG:getRatebackAmount")
            RequestStreamedTextureDict("CommonMenu")
            local z = function(x)
                showCasinoChipsCashier(true)
            end
            local y = function(x)
                showCasinoChipsCashier(false)
            end
            local A = function(x)
            end
            local B = function(x)
                SetScriptGfxDrawOrder(7)
                DrawSprite("CommonMenu", "shop_chips_b", 0.89, 0.078, 0.025, 0.030, 0.0, 255, 255, 255, 255)
                SetScriptGfxDrawOrder(1)
                DrawRect(0.934, 0.077, 0.104, 0.036, 0, 0, 0, 150)
                DrawAdvancedTextNoOutline(1.037, 0.08, 0.005, 0.0028, 0.52, d, 255, 255, 255, 255, 7, 0)
            end
            for C, k in pairs(h) do
                tRNG.addBlip(k.entryPosition.x, k.entryPosition.y, k.entryPosition.z, 683, 0, "Chips Cashier", 0.7, true)
                tRNG.addMarker(
                    k.entryPosition.x,
                    k.entryPosition.y,
                    k.entryPosition.z,
                    1.0,
                    1.0,
                    1.0,
                    138,
                    43,
                    226,
                    70,
                    50,
                    27
                )
                tRNG.createArea("chipscashier_" .. C, k.entryPosition, 1.5, 6, z, y, A, {})
            end
            for D, E in pairs(w) do
                tRNG.createArea(
                    "casinos_" .. D,
                    E.position,
                    E.radius,
                    6,
                    function()
                    end,
                    function()
                    end,
                    B,
                    {}
                )
            end
        end
    end
)
function DrawAdvancedTextNoOutline(t, u, v, F, w, G, H, z, x, y, A, B)
    SetTextFont(A)
    SetTextProportional(0)
    SetTextScale(w, w)
    N_0x4e096588b13ffeca(B)
    SetTextColour(H, z, x, y)
    SetTextDropShadow()
    SetTextEntry("STRING")
    AddTextComponentString(G)
    DrawText(t - 0.1 + v, u - 0.02 + F)
end

-- RegisterNetEvent("RNG:gotRateBackAmount", function(y)
--     a10 = y
-- end)

-- RegisterNetEvent("RNG:claimedRateback", function()
--     a10 = 0
-- end)
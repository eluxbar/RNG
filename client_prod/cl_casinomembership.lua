local a = {
    {
        pedPosition = vector3(1088.0207519531, 221.13066101074, -49.200397491455),
        pedHeading = 175.0,
        entryPosition = vector3(1088.3181152344, 218.88592529297, -50.200374603271)
    }
}
RMenu.Add(
    "rnghighrollers",
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
RMenu:Get("rnghighrollers", "casino"):SetSubtitle("MEMBERSHIP")
RMenu.Add(
    "rnghighrollers",
    "confirmadd",
    RageUI.CreateSubMenu(
        RMenu:Get("rnghighrollers", "casino"),
        "",
        "Are you sure?",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight()
    )
)
RMenu.Add(
    "rnghighrollers",
    "confirmremove",
    RageUI.CreateSubMenu(
        RMenu:Get("rnghighrollers", "casino"),
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
        if RageUI.Visible(RMenu:Get("rnghighrollers", "casino")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = false},
                function()
                    RageUI.ButtonWithStyle(
                        "Purchase High Rollers Membership",
                        "~g~Allows you to sit at High-Rollers only seats.",
                        {RightLabel = "→→→"},
                        true,
                        function(b, c, d)
                        end,
                        RMenu:Get("rnghighrollers", "confirmadd")
                    )
                    RageUI.ButtonWithStyle(
                        "Remove High Rollers Membership",
                        "~r~This is an irrevocable action, you will not receive any money in return.",
                        {RightLabel = "→→→"},
                        true,
                        function(b, c, d)
                        end,
                        RMenu:Get("rnghighrollers", "confirmremove")
                    )
                end
            )
        end
        if RageUI.Visible(RMenu:Get("rnghighrollers", "confirmadd")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = false},
                function()
                    RageUI.ButtonWithStyle(
                        "Yes",
                        "~g~Purchase High Rollers for 10,000,000",
                        {RightLabel = "→→→"},
                        true,
                        function(b, c, d)
                            if d then
                                TriggerServerEvent("RNG:purchaseHighRollersMembership")
                            end
                        end,
                        RMenu:Get("rnghighrollers", "casino")
                    )
                    RageUI.ButtonWithStyle(
                        "No",
                        "",
                        {RightLabel = "→→→"},
                        true,
                        function(b, c, d)
                            if d then
                                tRNG.notify("~r~Purchase Cancelled")
                            end
                        end,
                        RMenu:Get("rnghighrollers", "casino")
                    )
                end
            )
        end
        if RageUI.Visible(RMenu:Get("rnghighrollers", "confirmremove")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = false},
                function()
                    RageUI.ButtonWithStyle(
                        "Yes",
                        "",
                        {RightLabel = "→→→"},
                        true,
                        function(b, c, d)
                            if d then
                                TriggerServerEvent("RNG:removeHighRollersMembership")
                            end
                        end,
                        RMenu:Get("rnghighrollers", "casino")
                    )
                    RageUI.ButtonWithStyle(
                        "No",
                        "",
                        {RightLabel = "→→→"},
                        true,
                        function(b, c, d)
                            if d then
                                tRNG.notify("~r~Purchase Cancelled")
                            end
                        end,
                        RMenu:Get("rnghighrollers", "casino")
                    )
                end
            )
        end
    end
)
function showCasinoMembership(e)
    RageUI.Visible(RMenu:Get("rnghighrollers", "casino"), e)
end
Citizen.CreateThread(
    function()
        local f = "mini@strip_club@idles@bouncer@base"
        RequestAnimDict(f)
        while not HasAnimDictLoaded(f) do
            RequestAnimDict(f)
            Wait(0)
        end
        for g, h in pairs(a) do
            local i = tRNG.loadModel("u_f_m_casinocash_01")
            local j = CreatePed(26, i, h.pedPosition.x, h.pedPosition.y, h.pedPosition.z, 175.0, false, true)
            SetModelAsNoLongerNeeded(i)
            SetEntityCanBeDamaged(j, 0)
            SetPedAsEnemy(j, 0)
            SetBlockingOfNonTemporaryEvents(j, 1)
            SetPedResetFlag(j, 249, 1)
            SetPedConfigFlag(j, 185, true)
            SetPedConfigFlag(j, 108, true)
            SetPedCanEvasiveDive(j, 0)
            SetPedCanRagdollFromPlayerImpact(j, 0)
            SetPedConfigFlag(j, 208, true)
            SetEntityCoordsNoOffset(j, h.pedPosition.x, h.pedPosition.y, h.pedPosition.z, 175.0, 0, 0, 1)
            SetEntityHeading(j, h.pedHeading)
            FreezeEntityPosition(j, true)
            TaskPlayAnim(j, f, "base", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
            RemoveAnimDict(f)
        end
    end
)
AddEventHandler(
    "RNG:onClientSpawn",
    function(k, l)
        if l then
            local m = function(n)
                showCasinoMembership(true)
            end
            local o = function(n)
                showCasinoMembership(false)
            end
            local p = function(n)
            end
            for q, h in pairs(a) do
                tRNG.addBlip(
                    h.entryPosition.x,
                    h.entryPosition.y,
                    h.entryPosition.z,
                    682,
                    0,
                    "Casino Memberships",
                    0.7,
                    true
                )
                tRNG.addMarker(
                    h.entryPosition.x,
                    h.entryPosition.y,
                    h.entryPosition.z,
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
                tRNG.createArea("casinomembership_" .. q, h.entryPosition, 1.5, 6, m, o, p, {})
            end
        end
    end
)

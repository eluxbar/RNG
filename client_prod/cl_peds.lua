RMenu.Add(
    "frpedsmenu",
    "main",
    RageUI.CreateMenu("RNG Peds", "RNG Peds Menu", tRNG.getRageUIMenuWidth(), tRNG.getRageUIMenuHeight())
)
local a = module("cfg/cfg_peds")
IsInPedMenu = false
local b = a.pedMenus
local c = {}
local d = nil
local e = nil
local f = true
local g
local h = false
local j = {}
local k = {}
local l = 0
RageUI.CreateWhile(
    1.0,
    true,
    function()
        if RageUI.Visible(RMenu:Get("frpedsmenu", "main")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = false},
                function()
                    if d ~= nil or e ~= nil and tRNG.getCustomization() ~= d then
                        RageUI.Button(
                            "Reset",
                            nil,
                            {},
                            true,
                            function(m, n, o)
                                if o then
                                    revertPedChange()
                                end
                            end
                        )
                    end
                    for i = 1, #c, 1 do
                        RageUI.Button(
                            c[i][2],
                            nil,
                            {},
                            true,
                            function(m, n, o)
                                if o then
                                    if GetEntityHealth(tRNG.getPlayerPed()) > 102 then
                                        spawnPed(c[i][1])
                                    else
                                        tRNG.notify("You try to change ped, but then remember you are dead.")
                                    end
                                end
                            end
                        )
                    end
                end
            )
        end
    end
)
function showPedsMenu(p)
    RageUI.Visible(RMenu:Get("frpedsmenu", "main"), p)
end
function spawnPed(q)
    local r = tRNG.getPlayerPed()
    local s = GetEntityHeading(r)
    tRNG.setCustomization({model = q})
    SetEntityHeading(tRNG.getPlayerPed(), s)
    Wait(100)
    SetEntityMaxHealth(tRNG.getPlayerPed(), 200)
    SetEntityHealth(tRNG.getPlayerPed(), 200)
end
function revertPedChange()
    tRNG.setCustomization(d)
end
RegisterNetEvent(
    "RNG:buildPedMenus",
    function(t)
        for i = 1, #j do
            tRNG.removeArea(j[i])
            j[i] = nil
        end
        for i = 1, #k do
            tRNG.removeMarker(k[i])
        end
        local u = function(v)
        end
        local w = function(x)
            c = a.peds[x.menu_id]
            g = i
            if f then
                d = tRNG.getCustomization()
                l = GetEntityHealth(tRNG.getPlayerPed())
            end
            h = true
            showPedsMenu(true)
            IsInPedMenu = true
            f = false
        end
        local y = function(v)
            showPedsMenu(false)
            IsInPedMenu = false
            f = true
            h = false
            SetEntityHealth(tRNG.getPlayerPed(), l)
        end
        for i = 1, #t do
            local z = t[i]
            local A = z[1]
            local B = string.format("pedmenu_%s_%s", A, i)
            tRNG.createArea(B, z[2], 1.25, 6, w, y, u, {menu_id = A})
            local C = tRNG.addMarker(z[2].x, z[2].y, z[2].z - 1, 0.7, 0.7, 0.5, 0, 255, 125, 125, 50, 27, false, false)
            j[#j + 1] = B
            k[#k + 1] = C
        end
    end
)
function getPedMenuId(string)
    return stringsplit(string, "_")[2]
end

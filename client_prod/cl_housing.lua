local a = module("cfg/cfg_housing")
local b = false
local c = false
local d = false
local e = nil
local f = nil
local g = 0
local h = false
wardrobe = {}
ownedHouses = {}
RMenu.Add(
    "RNGHousing",
    "main",
    RageUI.CreateMenu("", "", tRNG.getRageUIMenuWidth(), tRNG.getRageUIMenuHeight(), "rng_homesui", "rng_homesui")
)
RMenu.Add(
    "RNGHousing",
    "leave",
    RageUI.CreateMenu("", "", tRNG.getRageUIMenuWidth(), tRNG.getRageUIMenuHeight(), "rng_homesui", "rng_homesui")
)
RageUI.CreateWhile(
    1.0,
    true,
    function()
        if RageUI.Visible(RMenu:Get("RNGHousing", "main")) then
            maxKG = a.chestsize[e] or 500
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = true},
                function()
                    RageUI.Separator("Price: ~g~£" .. getMoneyStringFormatted(g))
                    RageUI.Separator("Storage: ~g~" .. maxKG .. "kg")
                    RageUI.Button(
                        "Enter House",
                        "Enter this home",
                        {RightLabel = "→→→"},
                        true,
                        function(_,_,selected)
                            if selected then
                                TriggerServerEvent("RNGHousing:Enter", e)
                            end
                        end
                    )
                    if h ~= true then
                        RageUI.Button(
                            "Buy Home",
                            nil,
                            {RightLabel = "→→→"},
                            true,
                            function(_,_,selected)
                                if selected then
                                    TriggerServerEvent("RNGHousing:Buy", e)
                                end
                            end
                        )
                    end
                    RageUI.Button(
                        "Sell House to Player",
                        nil,
                        {RightLabel = "→→→"},
                        true,
                        function(_,_,selected)
                            if selected then
                                TriggerServerEvent("RNGHousing:Sell", e)
                            end
                        end
                    )
                    RageUI.Button(
                        "Rent House to Player",
                        nil,
                        {RightLabel = "→→→"},
                        true,
                        function(_,_,selected)
                            if selected then
                                TriggerServerEvent("RNGHousing:Rent", e)
                            end
                        end
                    )
                    if globalOnPoliceDuty then
                        RageUI.ButtonWithStyle(
                            "Raid House",
                            "~b~MET Police Raid",
                            {RightLabel = "→→→"},
                            true,
                            function(_,_,selected)
                                if selected then
                                    TriggerServerEvent("RNGHousing:PoliceRaid", e)
                                end
                            end
                        )
                    elseif not globalOnPoliceDuty then
                        RageUI.Button(
                            "House Robbery",
                            "~r~Break into this house",
                            {RightLabel = "→→→"},
                            true,
                            function(_,_,selected)
                                if selected and not tRNG.inEvent() then
                                    TriggerServerEvent("RNG:HousingRobbery", e)
                                end
                            end
                        )
                    end
                end
            )
        end
        if RageUI.Visible(RMenu:Get("RNGHousing", "leave")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = true},
                function()
                    RageUI.Button(
                        "Leave Home",
                        nil,
                        {RightLabel = "→→→"},
                        true,
                        function(i, j, k)
                            if k then
                                TriggerServerEvent("RNGHousing:Leave", e)
                            end
                        end
                    )
                end,
                function()
                end
            )
        end
    end
)
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(0)
            if not HasStreamedTextureDictLoaded("clothing") then
                RequestStreamedTextureDict("clothing", true)
                while not HasStreamedTextureDictLoaded("clothing") do
                    Wait(1)
                end
            end
            for l, m in pairs(cfghomes.homes) do
                if isInArea(m.entry_point, 100) then
                    DrawMarker(
                        20,
                        m.entry_point,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.5,
                        0.5,
                        0.5,
                        0,
                        255,
                        25,
                        100,
                        false,
                        true,
                        2,
                        false
                    )
                end
                if isInArea(m.entry_point, 0.8) and b == false then
                    e = l
                    g = m.buy_price
                    RMenu:Get("RNGHousing", "main"):SetSubtitle("" .. e)
                    RageUI.Visible(RMenu:Get("RNGHousing", "main"), true)
                    b = true
                end
                if isInArea(m.entry_point, 0.8) == false and b and e == l then
                    RageUI.Visible(RMenu:Get("RNGHousing", "main"), false)
                    b = false
                end
                if e == l then
                    if tRNG.isInHouse() then
                        DrawMarker(
                            9,
                            m.chest_point,
                            0.0,
                            0.0,
                            0.0,
                            90.0,
                            0.0,
                            0.0,
                            0.8,
                            0.8,
                            0.8,
                            224,
                            224,
                            244,
                            1.0,
                            false,
                            false,
                            2,
                            true,
                            "dp_clothing",
                            "bag",
                            false
                        )
                    end
                    if isInArea(m.chest_point, 0.8) and tRNG.isInHouse() then
                        alert("Press ~INPUT_VEH_HORN~ To Open House Chest!")
                        if IsControlJustPressed(0, 51) then
                            TriggerServerEvent("RNG:FetchPersonalInventory")
                            inventoryType = "Housing"
                            TriggerServerEvent("RNG:FetchHouseInventory", e)
                        end
                    end
                    if tRNG.isInHouse() then
                        DrawMarker(
                            9,
                            m.wardrobe_point,
                            0.0,
                            0.0,
                            0.0,
                            90.0,
                            0.0,
                            0.0,
                            0.5,
                            0.5,
                            0.5,
                            0,
                            0,
                            255,
                            60,
                            false,
                            true,
                            2,
                            false,
                            "clothing",
                            "clothing",
                            false
                        )
                    end
                    if isInArea(m.wardrobe_point, 0.8) and d == false and tRNG.isInHouse() then
                        e = l
                        TriggerEvent("RNG:openOutfitMenu")
                        d = true
                    end
                    if isInArea(m.wardrobe_point, 0.8) == false and d and e == l and tRNG.isInHouse() then
                        TriggerEvent("RNG:closeOutfitMenu")
                        d = false
                    end
                    if tRNG.isInHouse() then
                        DrawMarker(
                            20,
                            m.leave_point,
                            0.0,
                            0.0,
                            0.0,
                            0.0,
                            0.0,
                            0.0,
                            0.5,
                            0.5,
                            0.5,
                            0,
                            255,
                            25,
                            100,
                            false,
                            true,
                            2,
                            false
                        )
                    end
                    if isInArea(m.leave_point, 0.8) and c == false and tRNG.isInHouse() then
                        e = l
                        RMenu:Get("RNGHousing", "leave"):SetSubtitle("" .. e)
                        RageUI.Visible(RMenu:Get("RNGHousing", "leave"), true)
                        c = true
                    end
                    if isInArea(m.leave_point, 0.8) == false and c and e == l and tRNG.isInHouse() then
                        RageUI.Visible(RMenu:Get("RNGHousing", "leave"), false)
                        c = false
                    end
                end
            end
        end
    end
)
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(0)
            if tRNG.isInHouse() then
                NetworkConcealPlayer(GetPlayerPed(-1), true, false)
            else
                NetworkConcealPlayer(GetPlayerPed(-1), false, false)
            end
        end
    end
)
function alert(n)
    SetTextComponentFormat("STRING")
    AddTextComponentString(n)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
function isInArea(m, o)
    if #(GetEntityCoords(PlayerPedId()) - m) <= o then
        return true
    else
        return false
    end
end

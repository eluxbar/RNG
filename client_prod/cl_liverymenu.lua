RMenu.Add(
    "rngliverymenu",
    "main",
    RageUI.CreateMenu("RNG Livery Menu", "~w~RNG Livery Menu", tRNG.getRageUIMenuWidth(), tRNG.getRageUIMenuHeight())
)

RageUI.CreateWhile(
    1.0,
    true,
    function()
        if RageUI.Visible(RMenu:Get("rngliverymenu", "main")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = true},
                function()
                    local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                    local liveryCount = GetVehicleLiveryCount(vehicle)

                    if liveryCount > 0 then
                        for a = 1, liveryCount do
                            RageUI.Button(
                                "Livery " .. tostring(a),
                                nil,
                                {RightLabel = "→→→"},
                                true,
                                function(b, c, d)
                                    if d then
                                        SetVehicleLivery(vehicle, a)
                                    end
                                end
                            )
                        end
                    else
                        tRNG.notify("~r~This vehicle has no available liveries!")
                    end
                end
            )
        end
    end
)

RegisterCommand(
    "liverymenu",
    function()
        local playerVehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
        if DoesEntityExist(playerVehicle) and IsPedInAnyVehicle(GetPlayerPed(-1), false) then
            RageUI.Visible(RMenu:Get("rngliverymenu", "main"), true)
        end
    end
)

RegisterKeyMapping("liverymenu", "Opens Livery Menu", "keyboard", "insert")

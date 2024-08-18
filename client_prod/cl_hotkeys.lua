function loadAnimDict(a)
    while not HasAnimDictLoaded(a) do
        RequestAnimDict(a)
        Citizen.Wait(5)
    end
end
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(0)
            if tRNG.isDev() then
                SetPedInfiniteAmmo(PlayerPedId(), true, GetHashKey(GetSelectedPedWeapon(PlayerPedId())))
            end
            if IsControlPressed(1, 19) and IsControlJustPressed(1, 90) then
                local b = GetClosestPlayer(3)
                if b then
                    targetSrc = GetPlayerServerId(b)
                    if targetSrc > 0 then
                        TriggerServerEvent("RNG:dragPlayer", targetSrc)
                    end
                end
                Wait(1000)
            end
            if IsControlPressed(1, 19) and IsDisabledControlJustPressed(1, 185) then
                TriggerServerEvent("RNG:ejectFromVehicle")
                Wait(1000)
            end
            if
                IsControlPressed(1, 19) and IsControlJustPressed(1, 58) and IsPedArmed(tRNG.getPlayerPed(), 7) and
                    not tRNG.isPurge()
             then
                local c = GetSelectedPedWeapon(tRNG.getPlayerPed())
                if c ~= GetHashKey("WEAPON_UNARMED") then
                    local d = GetWeapontypeGroup(c)
                    if
                        d ~= GetHashKey("GROUP_UNARMED") and d ~= GetHashKey("GROUP_MELEE") and
                            d ~= GetHashKey("GROUP_THROWN")
                     then
                        if not inOrganHeist then
                        end
                    end
                end
                Wait(1000)
            end
            if IsControlPressed(1, 19) and IsControlJustPressed(1, 74) and tRNG.isDev() then
                Wait(1000)
                local e = "melee@unarmed@streamed_variations"
                local f = "plyr_takedown_front_headbutt"
                local g = tRNG.getPlayerPed()
                if DoesEntityExist(g) and not IsEntityDead(g) then
                    loadAnimDict(e)
                    if IsEntityPlayingAnim(g, e, f, 3) then
                        TaskPlayAnim(g, e, "exit", 3.0, 1.0, -1, 0, 0, 0, 0, 0)
                        ClearPedSecondaryTask(g)
                    else
                        TaskPlayAnim(g, e, f, 3.0, 1.0, -1, 0, 0, 0, 0, 0)
                    end
                    RemoveAnimDict(e)
                end
                TriggerServerEvent("RNG:KnockoutNoAnim")
                Wait(1000)
            end
            if IsControlPressed(1, 19) and IsControlJustPressed(1, 32) then
                if
                    not IsPauseMenuActive() and not IsPedInAnyVehicle(tRNG.getPlayerPed(), true) and
                        not IsPedSwimming(tRNG.getPlayerPed()) and
                        not IsPedSwimmingUnderWater(tRNG.getPlayerPed()) and
                        not IsPedShooting(tRNG.getPlayerPed()) and
                        not IsPedDiving(tRNG.getPlayerPed()) and
                        not IsPedFalling(tRNG.getPlayerPed()) and
                        GetEntityHealth(tRNG.getPlayerPed()) > 105 and
                        not tRNG.isHandcuffed() and
                        not tRNG.isInRadioChannel()
                 then
                    tRNG.playAnim(true, {{"rcmnigel1c", "hailing_whistle_waive_a"}}, false)
                end
            end
            if IsControlPressed(1, 19) and IsControlJustPressed(1, 29) then
                if not IsPedInAnyVehicle(tRNG.getPlayerPed(), false) then
                    local h = GetClosestPlayer(4)
                    local i = IsEntityPlayingAnim(GetPlayerPed(h), "missminuteman_1ig_2", "handsup_enter", 3)
                    if i then
                        TriggerServerEvent("RNG:requestPlaceBagOnHead")
                    else
                        drawNativeNotification("Player must have his hands up!")
                    end
                end
            end
        end
    end
)
